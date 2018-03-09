# frozen_string_literal: true

module CoderDecorator # :nodoc:
  module Coders # :nodoc:
    autoload :Base64, 'coder_decorator/coders/base64'
    autoload :Cipher, 'coder_decorator/coders/cipher'
    autoload :Coder, 'coder_decorator/coders/coder'
    autoload :HMAC, 'coder_decorator/coders/hmac'
    autoload :Identity, 'coder_decorator/coders/identity'
    autoload :JSON, 'coder_decorator/coders/json'
    autoload :Marshal, 'coder_decorator/coders/marshal'
    autoload :Rescue, 'coder_decorator/coders/rescue'
    autoload :Zip, 'coder_decorator/coders/zip'
  end

  def self.coder_names
    @coder_names ||= begin
      coder_names = Dir["#{__dir__}/coder_decorator/coders/*"].map! { |name| File.basename(name, '.rb') }
      coder_names.delete('coder')
      coder_names
    end
  end
end
Dir[File.join(__dir__, 'coder_decorator', '**', '*.rb')].each { |path| require path }
