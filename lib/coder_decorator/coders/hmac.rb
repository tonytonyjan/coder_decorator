# frozen_string_literal: true
require 'coder_decorator/coders/coder'
require 'openssl'

module CoderDecorator
  module Coders
    # Actuall, it doesn't encode, instead, it appends a hex HMAC to the input data
    # in this format:
    #
    #     "#{data}--#{hmac}"
    #
    class HMAC < Coder
      REGEXP = /\A(.*)--(.*)\z/

      def initialize(coder = nil, secret:, digest: 'SHA1')
        super(coder)
        @secret = secret
        @digest = ::OpenSSL::Digest.new(digest)
      end

      def encode(str)
        data = coder.encode(str)
        hmac = generate_hmac(data)
        "#{data}--#{hmac}"
      end

      def decode(str)
        data, hmac = REGEXP.match(str)&.captures
        raise InvalidEncoding unless data && hmac && secure_compare(hmac, generate_hmac(data))
        coder.decode(data)
      end

      private

      def generate_hmac(str)
        ::OpenSSL::HMAC.hexdigest(@digest.new, @secret, str)
      end

      def secure_compare(a, b)
        return false unless a.bytesize == b.bytesize
        l = a.unpack('C*')
        r = 0
        i = -1
        b.each_byte { |v| r |= v ^ l[i += 1] }
        r.zero?
      end
    end
  end
end
