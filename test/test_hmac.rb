# frozen_string_literal: true

require 'minitest/autorun'
require 'coder_decorator'

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
    assert_raises Coders::HMAC::InvalidSignature do
      @coder.decode('invalid encoding')
    end
  end

  def test_key_rotation
    str = 'hello world'
    secret = 'x' * 100
    coder = Coders::HMAC.new secret: secret
    encoded = coder.encode(str)
    new_coder = Coders::HMAC.new secret: 'new secret', old_secret: secret
    assert_equal str, new_coder.decode(encoded)
  end
end
