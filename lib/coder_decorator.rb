# frozen_string_literal: true
module CoderDecorator # :nodoc:
  def self.coder_names
    @coder_names ||= begin
      coder_names = Dir["#{__dir__}/coder_decorator/coders/*"].map! { |name| File.basename(name, '.rb') }
      coder_names.delete('coder')
      coder_names
    end
  end
end
Dir[File.join(__dir__, 'coder_decorator', '**', '*.rb')].each { |path| require path }
