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
    Coders::Base64.new(
      Coders::Cipher.new(
        Coders::JSON.new,
        secret: 'x' * 32
      )
    ),
    secret: 'y' * 32
  )
)

app = Rack::Builder.app(app) do
  use Rack::Session::Cookie, coder: coder, let_coder_handle_secure_encoding: true
end

Rack::Handler::WEBrick.run app
