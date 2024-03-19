# frozen_string_literal: true

require_relative '../../anchor'
require_relative '../dsl'

require 'puma/acme'

module Puma
  class Plugin
    # This is a plugin for Puma that will automatically provision & renew certificates based
    # on options loaded from a framework plugin or the environment. Only the foreground acme
    # mode is supported.
    class AutoCert < Puma::Acme::Plugin
      Plugins.register('auto_cert', self)

      class Error < StandardError; end
      class PortMissingError < Error; end
      class ServerNameMissingError < Error; end

      class << self
        attr_accessor :start_hooks
      end

      def self.add_start_hook(&block)
        (self.start_hooks ||= []) << block
      end

      def start(launcher, env: ENV)
        # puma.rb > framework config > ENV
        config = ConfigLookup.new(puma: launcher.options, app: framework_config, env: env)

        enabled = config.first(:enabled)

        https_port = config.first(:port, puma: :auto_cert_port, env: 'HTTPS_PORT')
        if https_port.nil?
          if enabled
            raise PortMissingError, 'AutoCert was enabled, but no https port number provided'
          end

          launcher.log_writer.log 'AutoCert >> Not enabled, no HTTPS_PORT'
          return
        end

        server_names = [*config.all(:server_names, env: Anchor::ENV_VARS[:server_names])]
                       .map { |val| val.split(/[ ,]/) }.flatten.uniq

        if server_names.empty?
          if enabled
            raise ServerNameMissingError, 'AutoCert was enabled, but no server name(s) provided'
          end

          launcher.log_writer.log 'AutoCert >> Not enabled, no ACME_SERVER_NAME(S)'
          return
        end

        launcher.options[:acme_server_names] = server_names

        tcp_hosts(launcher.options[:binds]).each do |host|
          launcher.options[:binds] << "acme://#{host}:#{https_port}"
        end

        %i[algorithm cache_dir contact tos_agreed].each do |key|
          if (val = config.first(key))
            launcher.options[:"acme_#{key}"] ||= val
          end
        end

        launcher.options[:acme_directory] ||= config.first(:directory, env: Anchor::ENV_VARS[:directory])

        launcher.options[:acme_eab_kid]      ||= config.first(:eab_kid, env: Anchor::ENV_VARS[:eab_kid])
        launcher.options[:acme_eab_hmac_key] ||= config.first(:eab_hmac_key,
                                                              env: Anchor::ENV_VARS[:eab_hmac_key])

        launcher.options[:acme_mode] ||= config.first(:mode) || :foreground

        # TODO: unify with config, check/use :renew_interval
        launcher.options[:acme_renew_at] ||= renew_before

        super(launcher)
      end

      protected

      def renew_before
        if (renew_at = ENV.fetch('ACME_RENEW_BEFORE_SECONDS', nil))
          renew_at.to_i
        elsif (renew_at = ENV.fetch('ACME_RENEW_BEFORE_FRACTION', nil))
          renew_at.to_f
        else
          0.5
        end
      end

      def framework_config
        # TODO(benburkert): for the next framework plugin, make this generic
        Rails.application.config.auto_cert if defined?(Rails)
      end

      def tcp_hosts(binds)
        binds.select { |bind| bind.start_with?('tcp://') }
             .map { |bind| URI.parse(bind).host }.uniq
      end

      # puma.rb > app framework config > ENV
      ConfigLookup = Struct.new(:puma, :app, :env, keyword_init: true) do
        alias_method :puma_config, :puma
        alias_method :app_config, :app
        alias_method :env_config, :env

        def first(key, puma: :"acme_#{key}", env: puma.upcase.to_s)
          lookup(key, puma: puma, env: env) { |val| return val }
          nil
        end

        def all(key, puma: :"acme_#{key}", env: puma.upcase)
          values = []
          lookup(key, puma: puma, env: env) { |val| values << val }
          values
        end

        protected

        def lookup(key, puma:, env:)
          yield(puma_config[puma]) if puma_config&.fetch(puma, nil)
          yield(app_config[key])   if app_config&.to_h&.fetch(key, nil)

          [*env].each do |k|
            yield(env_config[k]) if env_config&.fetch(k, nil)
          end
        end
      end
    end
  end
end
