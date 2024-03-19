# frozen_string_literal: true

require_relative '../spec_helper'

RSpec.describe Anchor::PemBundle do
  let(:bundle) { described_class.new }

  it '#add_cert' do
    bundle.add_cert('this is a cert, but not really')
    expect(bundle.pems).to eq(['this is a cert, but not really'])
  end

  it '#pems returns a copy' do
    bundle.add_cert('this is a cert')
    pem1 = bundle.pems
    pem2 = bundle.pems

    expect(pem1.object_id).not_to eq(pem2.object_id)
  end

  it '#to_s returns a string of the pems' do
    bundle.add_cert('this is a cert')
    bundle.add_cert('this is another cert')

    expect(bundle.to_s).to eq("this is a cert\nthis is another cert")
  end

  describe '#path' do
    it 'writes the bundle to a file' do
      bundle.add_cert('this is a cert')
      bundle.add_cert('this is another cert')
      bundle_path = bundle.path
      expect(File.read(bundle_path)).to eq(bundle.to_s)
    end
  end

  describe '#with_path' do
    it 'yields the path to the bundle' do
      bundle.add_cert('this is a cert')
      bundle.with_path do |path|
        expect(File.read(path)).to eq(bundle.to_s)
      end
    end

    it 'removes the path after the block' do
      bundle.add_cert('this is a cert')
      bundle_path = nil
      bundle.with_path { |path| bundle_path = path }
      expect(File.exist?(bundle_path)).to be false
    end
  end

  # rubocop:disable RSpec/MultipleExpectations
  describe '#clear' do
    it 'removes all certs' do
      bundle.add_cert('this is a cert')
      expect(bundle.pems.length).to eq(1)
      bundle.clear
      expect(bundle.pems).to eq([])
    end

    it 'removes the path' do
      bundle.add_cert('this is a cert')
      bundle_path = bundle.path
      expect(File.exist?(bundle_path)).to be true
      bundle.clear
      expect(File.exist?(bundle_path)).to be false
    end
  end
  # rubocop:enable RSpec/MultipleExpectations
end
