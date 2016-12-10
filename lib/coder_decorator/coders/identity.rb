# frozen_string_literal: true
require 'coder_decorator/coders/coder'
module CoderDecorator
  module Coders
    class Identity < Coder # :nodoc:
      def encode(obj)
        coder.encode(obj)
      end

      def decode(obj)
        coder.decode(obj)
      end
    end
  end
end
