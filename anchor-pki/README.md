# Anchor

Ruby client for Anchor PKI. See https://anchor.dev/ for details.

## Configuration

The Following environment variables are available to configure the default
[`AutoCert::Manager`](./lib/anchor/auto_cert/manager.rb).

* `HTTPS_PORT` - the TCP numerical port to bind SSL to.
* `SERVER_NAME`/`SERVER_NAMES` - A comma separated list of hostnames for provisioning certs
* `ACME_DIRECTORY_URL` - the ACME provider's directory
* `ACME_HMAC_KEY` - your External Account Binding (EAB) HMAC_KEY for authenticating with the ACME directory above
* `ACME_KID` - your External Account Binding (EAB) KID for authenticating with the ACME directory above with an
* `ACME_CONTACT` - **optional** URL to contact in case of issues with the account
* `ACME_RENEW_BEFORE_SECONDS` - **optional** Start a renewal this number number of seconds before the cert expires. This defaults to 30 days (2592000 seconds)
* `ACME_RENEW_BEFORE_FRACTION` - **optional** Start the renewal when this fraction of a cert's valid window is left. This defaults to 0.5, which means when the cert is in the last 50% of its lifespan a renewal is attempted.

If both `ACME_RENEW_BEFORE_SECONDS` and `ACME_RENEW_BEFORE_FRACTION` are set,
the one that causes the renewal to take place earlier is used.

Example:

* Cert start (not_before) moment is : `2023-05-24 20:53:11 UTC`
* Cert expiration (not_after) moment is : `2023-06-21 20:53:10 UTC`
* `ACME_RENEW_BEFORE_SECONDS` is `1209600` (14 days)
* `ACME_RENEW_BEFORE_FRACTION` is `0.25` - which equates to a before seconds value of `604799` (~7 days)

The possible moments to start renewing are:

* 14 days before expiration moment - `2023-06-07 20:53:10 UTC`
* when 25% of the valid time is left - `2023-06-14 20:53:11 UTC`

Currently the `AutoCert::Manager` will use whichever is earlier.

### Example configuration

```sh
HTTPS_PORT=44300
SERVER_NAMES=my.lcl.host,*.my.lcl.host
ACME_DIRECTORY_URL=https://acme-v02.api.letsencrypt.org/directory
ACME_KID=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
ACME_HMAC_KEY=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
```

## Record new test cassettes

This code base tests against vcr recordings. These may need to be
regenerated periodically.

1. check out the code base locally
1. go to <https://anchor.dev/autocert-cab3bc/services/anchor-pki-rb-testing>
1. in the **Server Setup** section, generate new `ACME_KID` & `ACME_HMAC_KEY`
   tokens.
1. Make a local `.env` file or similar containing:

        export ACME_DIRECTORY_URL='https://anchor.dev/autocert-cab3bc/development/x509/ca/acme'
        export ACME_KID=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
        export ACME_HMAC_KEY=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
1. Update the [./spec/spec_helper.rb](spec/spec_helper.rb) file with these
   values as the respective `VCR_KID` and `VCR_HMAC_KEY`.
1. on the command line execute:

        $ . .env
        $ rm -r spec/cassettes
        $ bundle exec rake spec

## License

The gem is available as open source under the terms of the [MIT
License](./LICENSE.txt)
