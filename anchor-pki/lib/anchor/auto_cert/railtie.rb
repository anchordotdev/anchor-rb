# frozen_string_literal: true

module Anchor
  module AutoCert
    # AutoCert Railtie
    class Railtie < Rails::Railtie
      # Initialize the configuration with a blank configuration, ensuring
      # the configuration exists, even if it is not used.
      config.auto_cert = ::Anchor::AutoCert::Configuration.new

      # this needs to be after the load_config_initializers so that the
      # application can override the :rails auto_cert configuration
      #

      initializer 'auto_cert.configure_rails_initialization', after: :load_config_initializers do |app|
        # Update the app.config.hosts with the server_names if we are NOT
        # in the test environment.
        #
        # In the test environment `config.hosts` is normally empty, and as a
        # result HostAuthorization is not used. If we add the allow_identifiers
        # to the `config.hosts` then HostAuthorization will be used, and tests
        # will break.
        unless Rails.env.test?
          app.config.auto_cert[:server_names]&.each do |identifier|
            # need to convert an identifier into a host matcher, which is just
            # strip off a leading '*' if it exists so that all subdomains match.
            #
            # https://guides.rubyonrails.org/configuring.html#actiondispatch-hostauthorization
            host = identifier.to_s.sub(/^\*/, '')
            app.config.hosts << host
          end
        end
      end
    end
  end
end
