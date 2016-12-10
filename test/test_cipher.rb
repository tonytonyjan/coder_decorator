# frozen_string_literal: true
require 'minitest/autorun'
require 'coder_decorator/coders/cipher'

class TestCipher < Minitest::Test
  include CoderDecorator
  def setup
    @coder = Coders::Cipher.new secret: 'x' * 100
  end

  def test_it_works
    str = 'hello'
    encoded = @coder.encode(str)
    assert_equal str, @coder.decode(encoded)
  end

  def test_raise_error_if_it_cant_decode
    assert_raises CoderDecorator::InvalidEncoding do
      @coder.decode('invalid encoding')
    end
  end
end
