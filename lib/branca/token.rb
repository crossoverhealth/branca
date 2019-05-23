require "rbnacl"
require "base_x"

require_relative "configuration"
require_relative "errors"

module Branca
  class Token
    VERSION = 0xBA

    attr_reader :payload
    attr_reader :timestamp

    def initialize(payload, timestamp = Time.now)
      @payload = payload
      @timestamp = timestamp
    end

    def encode
      nonce = RbNaCl::Random.random_bytes(self.class.cipher.nonce_bytes)

      header = [VERSION, @timestamp.to_i].pack('C N') + nonce

      ciphertext = self.class.cipher.encrypt(nonce, @payload, header)

      raw_token = header + ciphertext

      BaseX::Base62.encode(raw_token)
    end

    def self.decode(token)
      decoded = BaseX::Base62.decode(token)
      bytes = decoded.unpack("C C4 C24 C*")
      header = bytes.shift(1 + 4 + 24)

      version = header[0]
      timestamp = header[1..4].pack("C*").unpack1("N")
      nonce = header[5..].pack("C*")
      data = bytes.pack("C*")

      raise Branca::InvalidVersionError unless version == VERSION

      payload = self.cipher.decrypt(nonce, data, header.pack("C*"))

      new(payload, timestamp)
    end

    private

    def self.cipher
      RbNaCl::AEAD::XChaCha20Poly1305IETF.new(Branca::Configuration.secret_key)
    end
  end

end
