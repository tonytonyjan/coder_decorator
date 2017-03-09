# frozen_string_literal: true
module CoderDecorator
  # TODO: doc
  class Builder # :nodoc:
    # equivalent to +new(*coder_names).build+
    def self.build(*coder_names)
      new(*coder_names).build
    end

    # all coder names are listed as filenames under +lib/coder_decorator/coders+,
    def initialize(*coder_names)
      @coder_names = coder_names
    end

    def build
      coder = nil
      @coder_names.each do |coder_name|
        case coder_name
        when String, Symbol, Array
          name, *arguments = Array(coder_name)
          coder_class = constantize(name)
          coder = coder_class.new(coder, *arguments)
        else
          raise ArgumentError, "Each argument should be one of Symbol, String or Array instance, but #{coder_name.inspect} was given."
        end
      end
      coder
    end

    private

    def constantize(name)
      begin
        require_relative "coders/#{name}"
      rescue LoadError
        raise "The coder \"#{name}\" doesn't exist, use `CoderDecorator.coder_names` to see all available coders."
      end
      case name
      when :hmac, :json
        CoderDecorator.const_get("Coders::#{name.upcase}")
      else
        CoderDecorator.const_get("Coders::#{camelize(name)}")
      end
    end

    def camelize(str)
      str.to_s.split('_').map!(&:capitalize!).join
    end
  end
end
