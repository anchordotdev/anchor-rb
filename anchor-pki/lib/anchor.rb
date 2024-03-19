# frozen_string_literal: true

require 'openssl'

#
# Anchor module is the top-level namespace for the Anchor PKI client.
#
module Anchor
  ENV_VARS = {
    directory: %w[ACME_DIRECTORY ACME_DIRECTORY_URL],
    eab_kid: %w[ACME_KID ACME_EAB_KID],
    eab_hmac_key: %w[ACME_HMAC_KEY ACME_EAB_HMAC_KEY],
    server_names: %w[ACME_SERVER_NAME ACME_SERVER_NAMES SERVER_NAME SERVER_NAMES ACME_ALLOW_IDENTIFIERS]
  }.freeze

  def self.add_cert(pem)
    (@certs ||= []) << OpenSSL::X509::Certificate.new(pem)
  end

  def self.cert_store
    @cert_store ||= OpenSSL::X509::Store.new.tap do |store|
      (@certs || []).each do |cert|
        store.add_cert(cert)
      end
    end
  end
end

require_relative 'anchor/version'
require_relative 'anchor/auto_cert'
require_relative 'anchor/oid'
require_relative 'anchor/pem_bundle'
