# frozen_string_literal: true
require 'minitest/autorun'
require 'coder_decorator'

class TestCoderDecorator < Minitest::Test
  def test_coder_names
    path = File.expand_path('../../lib/coder_decorator/coders/*', __FILE__)
    coder_names = Dir[path].map! { |name| File.basename(name, '.rb') }
    coder_names.delete('coder')
    assert_equal coder_names.sort!, CoderDecorator.coder_names.sort!
  end
end
