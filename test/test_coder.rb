# frozen_string_literal: true
require 'minitest/autorun'
require 'coder_decorator/coders/coder'
require 'coder_decorator/coders/base64'
require 'coder_decorator/coders/marshal'

class TestCoders < Minitest::Test
  include CoderDecorator
  class EmptyCoder < Coders::Coder
  end

  class CustomCoder < Coders::Coder
    def encode(str)
      coder.encode(str).reverse
    end

    def decode(str)
      coder.decode(str.reverse)
    end
  end

  def test_encode_should_raise_error_if_not_implemented
    assert_raises(NotImplementedError) do
      EmptyCoder.new.encode('foo')
    end
  end

  def test_decode_should_raise_error_if_not_implemented
    assert_raises(NotImplementedError) do
      EmptyCoder.new.decode('foo')
    end
  end

  def test_custom_coder_will_be_both_a_base_coder_and_decorator
    custom_coder = CustomCoder.new
    assert_equal 'olleh', custom_coder.encode('hello')
    custom_coder = CustomCoder.new(custom_coder)
    assert_equal 'hello', custom_coder.encode('hello')
  end

  def test_it_can_decorate
    coder = Coders::Base64.new(Coders::Marshal.new(Coders::JSON.new))
    data = {'name' => 'tonytonyjan', 'length' => 30}
    assert_equal data, coder.decode(coder.encode(data))
  end
end
