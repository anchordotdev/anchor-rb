## [Unreleased]

## [0.8.0] - 2024-03-04

- fix 0.7 regression such that configuration once again considers ENV values

## [0.7.0] - 2024-01-11

- inherit from the puma-acme plugin in auto\_cert plugin
- remove extraneous config & environment settings

## [0.6.3] - 2024-01-10

- fixed release (0.6.2 didn't contain the expected changes)

## [0.6.2] - 2023-12-20

- make terms of service an optional parameter
- change default autocert key from rails to anchor

## [0.6.1] - 2023-12-11

- improve support for ENV based configuration
- improve error logging for Puma plugin

## [0.6.0] - 2023-11-29

- changes for feature parity and consistency across anchor language packages

## [0.5.0] - 2023-09-18

- automatic renewal for expired, cached certificates
- log whole URL at startup, not just identifier
- add support for Anchor Certificate Extension
- update tests and test data recordings

## [0.4.0] - 2023-06-06

- add a puma plugin and configuration DSL for better integration
- auto restart puma when certificates renew
- improve tests
- internal refactor to support the puma plugin

## [0.3.0] - 2023-06-05

- improve gem packaging
- extract out a configuration class for Acme
- add tests

## [0.2.0] - 2023-04-18

- add autocert client for automatic certificate provisioning
- don't contact ACME server when cache hits

## [0.1.0] - 2021-11-05

- Initial release
