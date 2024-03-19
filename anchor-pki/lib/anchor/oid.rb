# frozen_string_literal: true

module Anchor
  # Oid is ASN.1 Object Identifiers.
  module Oid
    PEN      = OpenSSL::ASN1::ObjectId.new('1.3.6.1.4.1.60900', OpenSSL::ASN1::OBJECT, :EXPLICIT, :PRIVATE)
    CERT_EXT = OpenSSL::ASN1::ObjectId.new("#{PEN.oid}.1", OpenSSL::ASN1::OBJECT, :EXPLICIT, :PRIVATE)

    OpenSSL::ASN1::ObjectId.register(CERT_EXT.oid, 'anchorCertExt', 'Anchor Certificate Extension')
  end
end
