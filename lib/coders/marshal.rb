# frozen_string_literal: true
require 'coders'
module Coders
  class Marshal < Coder # :nodoc:
    def encode(obj)
      ::Marshal.dump(coder.encode(obj))
    end

    def decode(str)
      coder.decode(::Marshal.load(str))
    rescue ::TypeError
      raise InvalidEncoding
    end
  end
end
