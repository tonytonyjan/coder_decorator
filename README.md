# CoderDecorator [![Build Status](https://travis-ci.org/tonytonyjan/coder_decorator.svg?branch=master)](https://travis-ci.org/tonytonyjan/coder_decorator)

It's a encoding/decoding library for Ruby designed with [decorator pattern](https://en.wikipedia.org/wiki/Decorator_pattern), which makes it more flexible, and can be wrapped infinitely using Ruby instantiation.

# Install

```
gem install 'coder_decorator'
```

# Example

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

Use with Rack:

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

encrypted_coder = Coders::Cipher.new(Coders::Marshal.new, secret: 'x'  *100)
signed_coder = Coders::HMAC.new(encrypted_coder, secret: 'y' * 100)
coder = Coders::Rescue.new(signed_coder)

app = Rack::Builder.app(app) do
  use Rack::Session::Cookie, coder: coder, let_coder_handle_secure_encoding: true
end

Rack::Handler::WEBrick.run app
```

All built-in coders are listed in [lib/coder_decorator/coders](/tonytonyjan/coder_decorator/tree/master/lib/coder_decorator/coders)

# TODO

- DSL
