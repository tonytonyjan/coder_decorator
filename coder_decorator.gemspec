# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name = 'coder_decorator'
  s.version = '1.0.1'
  s.licenses = ['MIT']
  s.summary = 'An encoding/decoding library with decorator pattern.'
  s.description = 'An encoding/decoding library with decorator pattern.'
  s.author = 'Jian Weihang'
  s.files = Dir['lib/**/*.rb']
  s.email = 'tonytonyjan@gmail.com'
  s.required_ruby_version = '>= 2.2.0'
  s.add_development_dependency 'minitest'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rubocop'
end
