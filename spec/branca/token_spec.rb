# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Branca::Token do
  it 'has a token version number' do
    expect(Branca::Token::VERSION).to be 0xBA
  end

  it 'creates a token with default timestamp' do
    token = described_class.new('Test Payload')

    expect(token.payload).to eql('Test Payload')
  end

  describe 'encoding a token' do
    let(:token) { described_class.new('Payload data') }

    it 'properly encodes a token to a new string' do
      expect(token.encode).to be_a(String)
    end
  end

  describe 'decoding a token' do
    let(:payload) { 'Testing, testing, 1, 2, 3' }
    let(:timestamp) { Time.now.utc }
    let(:encoded_token) { described_class.new(payload, timestamp).encode }
    subject { described_class.decode(encoded_token) }

    it 'properly decodes the encoded token payload' do
      expect(subject.payload).to eql(payload)
    end

    it 'properly decodes the encoded token timestamp' do
      expect(subject.timestamp.to_i).to eql(timestamp.to_i)
    end

    it 'Decodes a known good token' do
      # Sample from reference Python implementation: https://github.com/tuupola/pybranca
      known_token = '87xqn4ACMhqDZvoNuO0pXykuDlCwRz4Vg7LS3klfHpTiOUw1ramOqfWoaA6bvsGwOQ49MDFOERU0T'
      config = Branca::Configuration.new.tap { |cfg| cfg.secret_key = 'supersecretkeyyoushouldnotcommit'.b }

      token = described_class.decode(known_token, config)
      expect(token.payload).to eql('Hello world!')
    end
  end
end
