# frozen_string_literal: true
module CoderDecorator; end # :nodoc:
CD = CoderDecorator
Dir[File.join(__dir__, 'coder_decorator', '**', '*.rb')].each { |path| require path }
