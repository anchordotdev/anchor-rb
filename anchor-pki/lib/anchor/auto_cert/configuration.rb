# frozen_string_literal: true

module Anchor
  # This module is here in order to communicate plugin configuration options
  # to the plugin since the plugin is created dynamically and it is loaded and
  # initialized without any configuration options.
  module AutoCert
    config_keys = %i[
      algorithm
      cache
      cache_dir
      contact
      directory
      eab_kid
      eab_hmac_key
      enabled
      mode
      port
      renew_at
      renew_interval
      server_name
      server_names
      tos_agreed
    ]

    # AutoCert Configuration provides a way to configure the AutoCert Manager.
    #
    Configuration = Struct.new(*config_keys, keyword_init: true) do
      alias_method :allow_identifiers=, :server_names=
      alias_method :directory_url=, :directory=

      def initialize(opts = {})
        opts[:directory] ||= envs(:directory)
        opts[:eab_kid] ||= envs(:eab_kid)
        opts[:eab_hmac_key] ||= envs(:eab_hmac_key)
        opts[:server_names] ||= envs(:server_names)&.split(',')

        if (eab = opts.delete(:external_account_binding))
          opts[:eab_kid]      = eab[:kid]
          opts[:eab_hmac_key] = eab[:hmac_key]
        end

        super(opts)
      end

      def server_name=(name)
        self.server_names = [name]
      end

      def external_account_binding=(eab)
        self.eab_kid      = eab[:kid]
        self.eab_hmac_key = eab[:hmac_key]
      end

      private

      def envs(key)
        Anchor::ENV_VARS[key].map { |k| ENV.fetch(k, nil) }.compact.first
      end
    end
  end
end
