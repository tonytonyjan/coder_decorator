# frozen_string_literal: true
require 'minitest/autorun'
require 'coder_decorator/coders/hmac'

class TestHMAC < Minitest::Test
  include CoderDecorator
  def setup
    @secret = 'tonytonyjan'
    @coder = Coders::HMAC.new secret: @secret
  end

  def test_encode
    str = 'hello'
    hmac = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), @secret, str)
    assert_equal "hello--#{hmac}", @coder.encode(str)
  end

  def test_decode
    str = 'world'
    hmac = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), @secret, str)
    assert_equal str, @coder.decode("world--#{hmac}")
  end

  def test_raise_error_if_it_cant_decode
    assert_raises CoderDecorator::InvalidEncoding do
      @coder.decode('invalid encoding')
    end
  end
end
