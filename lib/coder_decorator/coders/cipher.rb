# frozen_string_literal: true
require 'coder_decorator/coders/coder'
require 'coder_decorator/coders/base64'
require 'openssl'

module CoderDecorator
  module Coders
    # Encrypt the data into this format:
    #
    #     "#{encrypted_data}--#{initial_vector}"
    #
    class Cipher < Coder
      def initialize(coder = nil, secret:, cipher: 'AES-256-CBC')
        super(coder)
        @secret = secret
        @cipher = ::OpenSSL::Cipher.new(cipher)
        @base64 = Coders::Base64.new
      end

      def encode(obj)
        @cipher.encrypt
        @cipher.key = @secret
        iv = @cipher.random_iv
        encrypted_data = @cipher.update(coder.encode(obj)) << @cipher.final
        blob = "#{@base64.encode(encrypted_data)}--#{@base64.encode(iv)}"
        @base64.encode(blob)
      end

      def decode(str)
        encrypted_data, iv = @base64.decode(str).split('--').map! { |v| @base64.decode(v) }
        @cipher.decrypt
        @cipher.key = @secret
        @cipher.iv  = iv
        begin
          coder.decode(@cipher.update(encrypted_data) << @cipher.final)
        rescue ::OpenSSL::Cipher::CipherError
          raise InvalidEncoding
        end
      end
    end
  end
end
