# frozen_string_literal: true
require 'coder_decorator/name_converter'
module CoderDecorator
  # It provides a convenient interface to build a coder by passing arguments
  # instead of tediously initializing and wrapping, for example:
  #
  #     require 'coder_decorator/builder'
  #     CoderDecorator::Builder.build(:marshal, :base64)
  #
  # is equivalent to:
  #
  #     require 'coder_decorator/coders/marshal'
  #     require 'coder_decorator/coders/base64'
  #     CoderDecorator::Coders::Marshal.new(CoderDecorator::Coders::Base64.new)
  #
  # To pass arguments to a coder, use array:
  #
  #     CoderDecorator::Builder.build(:marshal, [:base64, {strict: true}])
  #
  class Builder
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
          coder_class = NameConverter.new(name).constantize
          coder = coder_class.new(coder, *arguments)
        else
          raise ArgumentError, "Each argument should be one of Symbol, String or Array instance, but #{coder_name.inspect} was given."
        end
      end
      coder
    end
  end
end
