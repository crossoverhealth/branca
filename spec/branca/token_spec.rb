require "spec_helper"

RSpec.describe Branca::Token do
  it "has a version number" do
    expect(Branca::VERSION).not_to be nil
  end

  it "creates a token with default timestamp" do
    token = described_class.new("Test Payload")

    expect(token.payload).to eql("Test Payload")
  end

  describe "encoding a token" do
    let(:token) { described_class.new("Payload data") }

    it "properly encodes a token to a new string" do
      expect(token.encode).to be_a(String)
    end
  end

  describe "decoding a token" do
    before :all do
      Branca::Configuration.secret_key = "supersecretkeyyoushouldnotcommit".b
    end

    let(:payload) { "Hello world!" }
    let(:encoded_token) { described_class.new(payload).encode }

    it "properly decodes the encoded token" do
      token = described_class.decode(encoded_token)

      expect(token.payload).to eql(payload)
    end

    it "Decodes a known good token" do
      # Sample from reference Python implementation: https://github.com/tuupola/pybranca
      token = described_class.decode("87xqn4ACMhqDZvoNuO0pXykuDlCwRz4Vg7LS3klfHpTiOUw1ramOqfWoaA6bvsGwOQ49MDFOERU0T")
      expect(token.payload).to eql("Hello world!")
    end
  end
end
