# frozen_string_literal: true
require 'coder_decorator/coders/coder'
module CoderDecorator
  module Coders
    # When there's exception raised, it rescues and returns +nil+.
    class Rescue < Coder # :nodoc:
      def encode(obj)
        coder.encode(obj)
      end

      def decode(obj)
        coder.decode(obj)
      rescue
        nil
      end
    end
  end
end
