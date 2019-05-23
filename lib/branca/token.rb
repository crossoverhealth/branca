# frozen_string_literal: true

require 'rbnacl'
require 'base_x'

require_relative 'configuration'
require_relative 'errors'

module Branca
  class Token
    VERSION = 0xBA

    attr_reader :payload
    attr_reader :timestamp

    def initialize(payload, timestamp = Time.now.utc)
      @payload = payload
      @timestamp = timestamp
    end

    def encode(config = Branca::Configuration.default)
      cipher = RbNaCl::AEAD::XChaCha20Poly1305IETF.new(config.secret_key)
      nonce = RbNaCl::Random.random_bytes(cipher.nonce_bytes)

      header = [VERSION, @timestamp.to_i].pack('C N') + nonce

      ciphertext = cipher.encrypt(nonce, @payload, header)

      raw_token = header + ciphertext

      BaseX::Base62.encode(raw_token)
    end

    class << self
      def decode(token, config = Branca::Configuration.default)
        header, bytes = decode_token_components(token)
        version, timestamp, nonce = decode_header(header)

        raise Branca::InvalidVersionError unless version == VERSION

        cipher = RbNaCl::AEAD::XChaCha20Poly1305IETF.new(config.secret_key)
        payload = cipher.decrypt(nonce, bytes.pack('C*'), header.pack('C*'))

        new(payload, Time.at(timestamp).utc)
      end

      private

      def decode_token_components(token)
        bytes = BaseX::Base62.decode(token).unpack('C C4 C24 C*')
        header = bytes.shift(1 + 4 + 24)

        [header, bytes]
      end

      def decode_header(header)
        [
          header[0],
          header[1..4].pack('C*').unpack1('N'),
          header[5..].pack('C*')
        ]
      end
    end
  end
end
