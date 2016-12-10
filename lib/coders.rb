# frozen_string_literal: true
module Coders
  class Error < RuntimeError; end
  class InvalidEncoding < Error; end
  # The abstract class of coder, must implement #encode and #decode.
  # It's designed with decorator pattern, which makes it more flexible,
  # and can be wrapped infinitely using Ruby instantiation.
  #
  # Example of encode data in Marshal and Base64:
  #
  #     coder = Coders::Base64.new(Coders::Marshal.new)
  #     encoded_data = coder.encode(data)
  #     coder.decode(encoded_data)
  #
  # Example of encode data in JSON and Zip:
  #
  #     coder = Coders::Zip.new(Coders::JSON.new)
  #     encoded_data = coder.encode(data)
  #     coder.decode(encoded_data)
  #
  # To implement a custom coder decorator, inherit from Coders::Coder, and use
  # +coder.encode+, +coder.decode+ to get results from base coder
  # instance, for example:
  #
  #    class Reverse < Coders::Coder
  #       def encode(str); coder.encode(str).reverse; end
  #       def decode(str); coder.decode(str.reverse); end
  #    end
  #    coder = Reverse.new(Coder::Base64.new)
  #
  # If you also want to customize options, be sure to call super, for example:
  #
  #     class Foo < Coders::Coder
  #       def initialize(gueset_coder, options = {})
  #         super(guest_coder)
  #         @options = options
  #       end
  #     end
  #
  class Coder < BasicObject
    # Can optionally pass a base coder which is going to be decorated.
    def initialize(coder = nil)
      @_coder = coder
    end

    def coder
      @_coder ||= Null.new
    end

    def encode(_obj)
      ::Kernel.raise ::NotImplementedError
    end

    # It decodes +_obj+, returning decoded data,
    # or +nil+ if it can't decode.
    def decode(_obj)
      ::Kernel.raise ::NotImplementedError
    end

    def raise(*args)
      ::Kernel.raise(*args)
    end
  end

  class Null < BasicObject # :nodoc:
    def encode(obj)
      obj
    end

    def decode(obj)
      obj
    end
  end
end
