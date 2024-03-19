# frozen_string_literal: true

require_relative '../spec_helper'

RSpec.describe Anchor::Oid do
  describe 'certificate extension' do
    let(:extension) { described_class::CERT_EXT }

    it 'sets the OID' do
      expect(extension.oid).to eq('1.3.6.1.4.1.60900.1')
    end
  end
end
