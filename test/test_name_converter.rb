# frozen_string_literal: true
require 'minitest/autorun'
require 'coder_decorator/name_converter'
require 'coder_decorator/coders/base64'
require 'coder_decorator/coders/cipher'
require 'coder_decorator/coders/hmac'
require 'coder_decorator/coders/identity'
require 'coder_decorator/coders/json'
require 'coder_decorator/coders/marshal'
require 'coder_decorator/coders/rescue'
require 'coder_decorator/coders/zip'

class TestBuilder < Minitest::Test
  def test_to_class_name
    assert_to_class_name 'Test', 'test'
    assert_to_class_name 'Base64', 'base64'
    assert_to_class_name 'Cipher', 'cipher'
    assert_to_class_name 'HMAC', 'hmac'
    assert_to_class_name 'Identity', 'identity'
    assert_to_class_name 'JSON', 'json'
    assert_to_class_name 'Marshal', 'marshal'
    assert_to_class_name 'Rescue', 'rescue'
    assert_to_class_name 'Zip', 'zip'
  end

  def test_constantize
    assert_constantize CoderDecorator::Coders::Base64, 'base64'
    assert_constantize CoderDecorator::Coders::Cipher, 'cipher'
    assert_constantize CoderDecorator::Coders::HMAC, 'hmac'
    assert_constantize CoderDecorator::Coders::Identity, 'identity'
    assert_constantize CoderDecorator::Coders::JSON, 'json'
    assert_constantize CoderDecorator::Coders::Marshal, 'marshal'
    assert_constantize CoderDecorator::Coders::Rescue, 'rescue'
    assert_constantize CoderDecorator::Coders::Zip, 'zip'
  end

  def test_wrong_coder_name
    exception = assert_raises RuntimeError do
      CoderDecorator::NameConverter.new('wrong_coder_name').constantize
    end
    assert_match(/"wrong_coder_name" doesn't exist/, exception.message)
  end

  private

  def assert_to_class_name(class_name, coder_name)
    assert_equal class_name, CoderDecorator::NameConverter.new(coder_name).to_class_name
  end

  def assert_constantize(coder_class, coder_name)
    assert_equal coder_class, CoderDecorator::NameConverter.new(coder_name).constantize
  end
end
