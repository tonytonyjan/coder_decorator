# frozen_string_literal: true
require 'minitest/autorun'
require 'coders/base64'
require 'base64'

class TestBase64 < Minitest::Test
  def setup
    @coder = Coders::Base64.new
    @nonstrict_coder = Coders::Base64.new strict: false
  end

  def test_encode
    src = 'hello'
    assert_equal Base64.strict_encode64(src), @coder.encode(src)
  end

  def test_decode
    src = 'hello'
    base64 = Base64.strict_encode64(src)
    assert_equal Base64.strict_decode64(base64), @coder.decode(base64)
  end

  def test_encode_nonstrict_mode
    str = 'x' * 100
    assert_equal Base64.encode64(str), @nonstrict_coder.encode(str)
  end

  def test_decode_nonstrict_mode
    str = 'x' * 100
    base64 = Base64.encode64(str)
    assert_equal Base64.decode64(base64), @nonstrict_coder.decode(base64)
  end

  def test_raise_error_if_it_cant_decode
    assert_raises Coders::InvalidEncoding do
      @coder.decode('invalid Base64')
    end
  end
end
