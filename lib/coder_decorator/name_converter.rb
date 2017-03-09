# frozen_string_literal: true
module CoderDecorator
  # It converts coder names into class name or constant, for example:
  #
  #     NameConverter.new('base64').to_class_name # => 'Base64'
  #     NameConverter.new('base64').constantize # => Coders::Base64
  #     NameConverter.new('json').to_class_name # => 'JSON'
  #     NameConverter.new('json').to_class_name # => Coders::JSON
  #
  class NameConverter
    def initialize(coder_name)
      @coder_name = coder_name.to_s
    end

    def constantize
      @constantize ||= begin
        require_relative "coders/#{@coder_name}"
        CoderDecorator.const_get("Coders::#{to_class_name}")
      rescue LoadError
        raise "The coder \"#{@coder_name}\" doesn't exist, use `CoderDecorator.coder_names` to see all available coders."
      end
    end

    def to_class_name
      case @coder_name
      when 'hmac', 'json' then @coder_name.upcase
      else @coder_name.to_s.split('_').map!(&:capitalize!).join
      end
    end
  end
end
