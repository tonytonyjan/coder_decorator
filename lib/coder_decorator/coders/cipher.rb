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
      def initialize(coder = nil, secret:, old_secret: nil, cipher: 'AES-256-CBC')
        super(coder)
        @secret = secret
        @old_secret = old_secret
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
        [@secret, @old_secret].each do |secret|
          begin
            return decrypt(secret, str)
          rescue ::OpenSSL::Cipher::CipherError, ::TypeError
            next
          end
        end
        raise InvalidEncoding
      end

      private

      def decrypt(secret, data)
        encrypted_data, iv = @base64.decode(data).split('--').map! { |v| @base64.decode(v) }
        @cipher.decrypt
        @cipher.key = secret
        @cipher.iv  = iv
        coder.decode(@cipher.update(encrypted_data) << @cipher.final)
      end
    end
  end
end
