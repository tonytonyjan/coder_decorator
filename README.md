# CoderDecorator [![Build Status](https://travis-ci.org/tonytonyjan/coder_decorator.svg?branch=master)](https://travis-ci.org/tonytonyjan/coder_decorator)

It's a encoding/decoding library for Ruby designed with [decorator pattern](https://en.wikipedia.org/wiki/Decorator_pattern), which makes it more flexible, and can be wrapped infinitely using Ruby instantiation.

This gem can refers to [this pull request](https://github.com/rack/rack/pull/1134).

# Install

```
gem install 'coder_decorator'
```

# Usage

Encode data with Marshal and Base64:

```ruby
require 'coder_decorator/coders/base64'
require 'coder_decorator/coders/marshal'
include CoderDecorator
coder = Coders::Base64.new(Coders::Marshal.new)
encoded_data = coder.encode(data)
coder.decode(encoded_data)
```

Encode data with JSON and Zip:

```ruby
require 'coder_decorator/coders/json'
require 'coder_decorator/coders/zip'
include CoderDecorator
coder = Coders::Zip.new(Coders::JSON.new)
encoded_data = coder.encode(data)
coder.decode(encoded_data)
```

To load all coders and utilities, simply do:

```ruby
require 'coder_decorator'
```

All built-in coders are listed in [lib/coder_decorator/coders](lib/coder_decorator/coders).

## Use `CoderDecorator::Builder` to construct coders:

`CoderDecorator::Builder` provides a convenient interface to build a coder by passing arguments instead of tediously initializing and wrapping coders, for example:

```ruby
require 'coder_decorator/builder'
CoderDecorator::Builder.build(:marshal, :base64)
```

is equivalent to:

```ruby
require 'coder_decorator/coders/marshal'
require 'coder_decorator/coders/base64'
CoderDecorator::Coders::Marshal.new(CoderDecorator::Coders::Base64.new)
```

Use array to pass arguments to the coder:

```ruby
CoderDecorator::Builder.build(:marshal, [:base64, {strict: true}])
```

Use `CoderDecorator.coder_names` to see all available coder names.

## Integration with Rack

```ruby
require 'rack'
require 'coder_decorator/builder'

include CoderDecorator

app = lambda do |env|
  session = env['rack.session']
  session[:count] ||= 0
  session[:count] += 1
  [200, {}, [session[:count].to_s]]
end

coder = CoderDecorator::Builder.build(
  :marshal,
  [:cipher, {secret: 'x' * 32}],
  [:hmac, {secret: 'y' * 32}],
  :rescue
)

app = Rack::Builder.app(app) do
  use Rack::Session::Cookie, coder: coder, let_coder_handle_secure_encoding: true
end

Rack::Handler::WEBrick.run app
```
