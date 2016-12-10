# frozen_string_literal: true
require 'minitest/autorun'
require 'coders/zip'

class TestZip < Minitest::Test
  def setup
    @coder = Coders::Zip.new
  end

  def test_encode
    str = 'hello'
    assert_equal ::Zlib::Deflate.deflate(str), @coder.encode(str)
  end

  def test_decode
    str = 'world'
    zip = ::Zlib::Deflate.deflate(str)
    assert_equal ::Zlib::Inflate.inflate(zip), @coder.decode(zip)
  end

  def test_raise_error_if_it_cant_decode
    assert_raises Coders::InvalidEncoding do
      @coder.decode('invalid Zip')
    end
  end
end
