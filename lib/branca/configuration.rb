require "rbnacl"

module Branca
  class Configuration
    class << self
      def secret_key
        @secret_key ||= RbNaCl::Random.random_bytes(32)
      end

      def secret_key=(secret_key)
        puts "Setting secret!: #{secret_key}"
        @secret_key = secret_key
      end
    end
  end
end
