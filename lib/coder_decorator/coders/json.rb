# frozen_string_literal: true
require 'coder_decorator/coders/coder'
require 'json'
module CoderDecorator
  module Coders
    class JSON < Coder # :nodoc:
      def encode(obj)
        ::JSON.dump(coder.encode(obj))
      end

      def decode(str)
        coder.decode(::JSON.parse(str))
      end
    end
  end
end
