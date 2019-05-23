# frozen_string_literal: true

require 'rbnacl'

module Branca
  class Configuration
    class << self
      def secret_key
        @secret_key ||= RbNaCl::Random.random_bytes(32)
      end

      attr_writer :secret_key
    end
  end
end
