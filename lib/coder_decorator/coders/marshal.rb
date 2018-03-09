# frozen_string_literal: true

require 'coder_decorator/coders/coder'

module CoderDecorator
  module Coders
    class Marshal < Coder # :nodoc:
      def encode(obj)
        ::Marshal.dump(coder.encode(obj))
      end

      def decode(str)
        coder.decode(::Marshal.load(str))
      end
    end
  end
end
