# frozen_string_literal: true

require_relative 'lib/anchor/version'

Gem::Specification.new do |s|
  s.name        = 'anchor-pki'
  s.version     = Anchor::VERSION
  s.summary     = 'Ruby client for Anchor PKI. See https://anchor.dev/ for details.'
  s.description = 'Anchor is a hosted PKI platform for your internal organization.'
  s.authors     = ['Anchor Security, Inc']
  s.homepage    = 'https://anchor.dev'
  s.license     = 'MIT'

  s.metadata['homepage_uri']          = s.homepage
  s.metadata['rubygems_mfa_required'] = 'true'

  s.require_paths         = ['lib']
  s.required_ruby_version = '>= 2.3'

  s.files            = Dir['{lib}/**/*'].to_a
  s.files           += ['LICENSE.txt', 'README.md', 'CHANGELOG.md', 'Gemfile', 'Gemfile.lock', 'Rakefile']
  s.extra_rdoc_files = ['LICENSE.txt', 'README.md', 'CHANGELOG.md']

  # Runtime dependencies for the AutoCert portions
  s.add_runtime_dependency 'puma-acme', '~> 0.1'

  s.add_development_dependency 'minitest', '~> 5.14'
  s.add_development_dependency 'rake', '~> 13.0'
  s.add_development_dependency 'rspec', '~> 3.9'
  s.add_development_dependency 'rubocop', '~> 1.50'
  s.add_development_dependency 'rubocop-rspec', '~> 2.22'
  s.add_development_dependency 'simplecov', '~> 0.22'
  s.add_development_dependency 'vcr', '~> 6.1'
  s.add_development_dependency 'webmock', '~> 3.8'
end
