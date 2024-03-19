# frozen_string_literal: true

#
# Extend the ::Puma::DSL module with the configuration options we want for
# autocert
#

require 'puma/dsl'
require 'puma/acme/dsl'

module Puma
  # Extend the ::Puma::DSL module with the configuration options we want
  class DSL
    def auto_cert_port(port = nil)
      @options[:auto_cert_port] = port if port
      @options[:auto_cert_port]
    end

    alias auto_cert_algorithm acme_algorithm
    alias auto_cert_cache acme_cache
    alias auto_cert_cache_dir acme_cache_dir
    alias auto_cert_contact acme_contact
    alias auto_cert_directory acme_directory
    alias auto_cert_eab_kid acme_eab_kid
    alias auto_cert_eab_hmac_key acme_eab_hmac_key
    alias auto_cert_mode acme_mode
    alias auto_cert_renew_at acme_renew_at
    alias auto_cert_renew_interval acme_renew_interval
    alias auto_cert_server_name acme_server_name
    alias auto_cert_server_names acme_server_names
    alias auto_cert_tos_agreed acme_tos_agreed
  end
end
