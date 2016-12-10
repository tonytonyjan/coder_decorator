# frozen_string_literal: true
require 'coder_decorator/coders/coder'
require 'zlib'
module CoderDecorator
  module Coders
    class Zip < Coder # :nodoc:
      def encode(str)
        ::Zlib::Deflate.deflate(coder.encode(str))
      end

      def decode(str)
        coder.decode(::Zlib::Inflate.inflate(str))
      rescue ::Zlib::DataError
        raise InvalidEncoding
      end
    end
  end
end
