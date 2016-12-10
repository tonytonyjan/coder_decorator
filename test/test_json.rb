# frozen_string_literal: true
require 'minitest/autorun'
require 'coder_decorator/coders/json'

class TestJSON < Minitest::Test
  include CoderDecorator
  def setup
    @coder = Coders::JSON.new
  end

  def test_encode
    obj = { name: 'tonytonyjan' }
    assert_equal JSON.dump(obj), @coder.encode(obj)
  end

  def test_decode
    obj = { name: 'tonytonyjan' }
    json = JSON.dump obj
    assert_equal JSON.parse(json), @coder.decode(json)
  end

  def test_raise_error_if_it_cant_decode
    assert_raises CoderDecorator::InvalidEncoding do
      @coder.decode('invalid JSON')
    end
  end
end
