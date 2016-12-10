# frozen_string_literal: true
require 'coder_decorator/coders/coder'
require 'openssl'

module CoderDecorator
  module Coders
    # Encrypt the data into this format:
    #
    #     "#{encrypted_data}--#{initial_vector}"
    #
    class Cipher < Coder
      def initialize(coder, secret:, cipher: 'AES-256-CBC')
        super(coder)
        @secret = secret
        @cipher = OpenSSL::Cipher.new(cipher)
      end

      def encode(obj)
        @cipher.encrypt
        @cipher.key = @secret
        iv = @cipher.random_iv
        encrypted_data = @cipher.update(coder.encode(obj)) << @cipher.final
        blob = "#{::Base64.strict_encode64(encrypted_data)}--#{::Base64.strict_encode64(iv)}"
        ::Base64.strict_encode64(blob)
      end

      def decode(str)
        encrypted_data, iv = ::Base64.strict_decode64(str).split('--').map! { |v| ::Base64.strict_decode64(v) }
        @cipher.decrypt
        @cipher.key = @secret
        @cipher.iv  = iv
        begin
          coder.decode(@cipher.update(encrypted_data) << @cipher.final)
        rescue OpenSSL::Cipher::CipherError
          nil
        end
      end
    end
  end
end
