# frozen_string_literal: true
require 'minitest/autorun'
require 'coder_decorator/coders/marshal'

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

  def test_raise_error_if_it_cant_decode
    assert_raises CoderDecorator::InvalidEncoding do
      @coder.decode('invalid Marshal')
    end
  end
end
