# frozen_string_literal: true

require 'simplecov'
SimpleCov.start
require 'anchor-pki'
require 'rspec'
require 'vcr'
require 'webmock/rspec'

project_root = File.join(File.dirname(__FILE__), '..')

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = File.join(project_root, '.rspec_status')

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

DIRECTORY_URL = ENV['ACME_DIRECTORY_URL'] || 'https://anchor.dev/autocert-cab3bc/development/x509/ca/acme'

DEFAULT_CONFIG_PARAMETERS = {
  algorithm: :ecdsa,
  directory_url: DIRECTORY_URL,
  allow_identifiers: 'test.lcl.host',
  contact: 'developer@anchor.dev',
  external_account_binding: { kid: 'kid', hmac_key: 'hmac_key' }
}.freeze

# These 2 values are what are used for the VCR recordings, and are live keys
# for https://anchor.dev/autocert-cab3bc/services/anchor-pki-rb-testing/
VCR_KID = 'aae_S2Llt76kWJGiFnLqAmrVhDDta6uYxpKFEN7-w2Q692-8'
VCR_HMAC_KEY = '7_CEIU5snZIBoavP2O_Fc0nEraUSCoLu7rXFnZB-QsuMPCYHTKRZaM7011etAnyE'
VCR_CONFIG_PARAMETERS = {
  directory_url: DIRECTORY_URL,
  name: 'vcr',
  allow_identifiers: 'vcr.lcl.host',
  contact: 'developer@anchor.dev',
  external_account_binding: { kid: VCR_KID, hmac_key: VCR_HMAC_KEY },
  renew_before_fraction: 0.5,
  renew_before_seconds: 60 * 60 * 24 * 14 # 14 days
}.freeze

VCR.configure do |c|
  c.cassette_library_dir = File.join(project_root, 'spec/cassettes')
  c.configure_rspec_metadata!
  c.hook_into :webmock
  c.ignore_localhost = false
  c.default_cassette_options = { record: :once, match_requests_on: %i[method path query] }
  c.allow_http_connections_when_no_cassette = false
  c.filter_sensitive_data('<DIRECTORY_URL>') do
    DIRECTORY_URL
  end
  c.filter_sensitive_data('<DIRECTORY_BASE_URL>') do
    DIRECTORY_URL.gsub(%r{/[^/]+$}, '')
  end
  c.filter_sensitive_data('<VCR_KID>') do
    VCR_KID
  end
  c.filter_sensitive_data('<VCR_HMAC_KEY>') do
    VCR_HMAC_KEY
  end
  c.filter_sensitive_data('<PROTECTED>') do |interaction|
    next unless interaction.request.method == :post
    next unless interaction.request.headers['Content-Type'].first =~ /json$/

    body = JSON.parse(interaction.request.body)
    next unless body.key?('protected')

    body['protected']
  end
end
