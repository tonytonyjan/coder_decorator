# frozen_string_literal: true
require 'coders'
require 'json'
module Coders
  class JSON < Coder # :nodoc:
    def encode(obj)
      ::JSON.dump(coder.encode(obj))
    end

    def decode(str)
      coder.decode(::JSON.parse(str))
    rescue ::JSON::ParserError
      raise InvalidEncoding
    end
  end
end
