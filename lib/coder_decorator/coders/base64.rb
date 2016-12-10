# frozen_string_literal: true
require 'coder_decorator/coders/coder'
module CoderDecorator
  module Coders
    class Base64 < Coder # :nodoc:
      def initialize(coder = nil, strict: true)
        super(coder)
        @template_str = strict ? 'm0' : 'm'
      end

      def encode(obj)
        [coder.encode(obj)].pack(@template_str)
      end

      def decode(str)
        coder.decode(str.unpack(@template_str).first)
      rescue ::ArgumentError
        raise InvalidEncoding
      end
    end
  end
end
