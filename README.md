# CoderDecorator [![Build Status](https://travis-ci.org/tonytonyjan/coder_decorator.svg?branch=master)](https://travis-ci.org/tonytonyjan/coder_decorator) [![Yard Docs](https://img.shields.io/badge/yard-doc-blue.svg)](http://www.rubydoc.info/gems/coder_decorator/)

It's a encoding/decoding library for Ruby designed with [decorator pattern](https://en.wikipedia.org/wiki/Decorator_pattern), which makes it more flexible, and can be wrapped infinitely using Ruby instantiation.

This gem can refers to [this pull request](https://github.com/rack/rack/pull/1134).

# Install

```
gem install 'coder_decorator'
```

# Usage

Encode data with Marshal and Base64:

```ruby
require 'coder_decorator'
include CoderDecorator
coder = Coders::Base64.new(Coders::Marshal.new)
encoded_data = coder.encode(data)
coder.decode(encoded_data)
```

Encode data with JSON and Zip:

```ruby
require 'coder_decorator'
include CoderDecorator
coder = Coders::Zip.new(Coders::JSON.new)
encoded_data = coder.encode(data)
coder.decode(encoded_data)
```

Coders are listed in [lib/coder_decorator/coders](lib/coder_decorator/coders).

## Integration with Rack

```ruby
require 'rack'
require 'coder_decorator'

include CoderDecorator

app = lambda do |env|
  session = env['rack.session']
  session[:count] ||= 0
  session[:count] += 1
  [200, {}, [session[:count].to_s]]
end

coder = Coders::Rescue.new(
  Coders::HMAC.new(
    Coders::Cipher.new(
      Coders::JSON.new,
      secret: 'x' * 32
    ),
    secret: 'y' * 32
  )
)

app = Rack::Builder.app(app) do
  use Rack::Session::Cookie, coder: coder, let_coder_handle_secure_encoding: true
end

Rack::Handler::WEBrick.run app
```
