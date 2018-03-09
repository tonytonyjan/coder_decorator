# frozen_string_literal: true

require 'minitest/autorun'
require 'coder_decorator'

class TestMarshal < Minitest::Test
  include CoderDecorator
  def setup
    @coder = Coders::Marshal.new
  end

  def test_encode
    obj = 'foo'
    assert_equal Marshal.dump(obj), @coder.encode(obj)
  end

  def test_decode
    obj = 'foo'
    marshal = Marshal.dump(obj)
    assert_equal(Marshal.load(marshal), @coder.decode(marshal))
  end
end
