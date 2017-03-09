# frozen_string_literal: true
require 'minitest/autorun'
require 'coder_decorator/builder'

class TestBuilder < Minitest::Test
  def test_build
    cipher_secret = 'x' * 32
    hmac_secret = 'y' * 32
    built_coder = CoderDecorator::Builder.build(
      :marshal,
      :base64,
      [:cipher, { secret: cipher_secret }],
      [:hmac, { secret: hmac_secret }],
      :rescue
    )
    str = 'hi'
    encoded = built_coder.encode(str)
    assert_equal str, built_coder.decode(encoded)
  end

  def test_wrong_argument
    exception = assert_raises ArgumentError do
      CoderDecorator::Builder.build(:marshal, :base64, 123)
    end
    assert_match(/but 123 was given/, exception.message)
  end
end
