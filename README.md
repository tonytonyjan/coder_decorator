Example of encode data in Marshal and Base64:

```ruby
coder = Coders::Base64.new(Coders::Marshal.new)
encoded_data = coder.encode(data)
coder.decode(encoded_data)
```

Example of encode data in JSON and Zip:

```ruby
coder = Coders::Zip.new(Coders::JSON.new)
encoded_data = coder.encode(data)
coder.decode(encoded_data)
```

# TODO

- READMD
- test of `Coder::HMAC`
- test of `Coder::Cipher`
- description of gemspec
