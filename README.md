# Branca

A Ruby implementation of the Branca encrypted and tamperproof tokens. See [https://branca.io/](https://branca.io/) for
more details, the full specification, etc.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'branca'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install branca

## Usage

### Creating/Encoding Tokens

```ruby
require "branca"

# Creating a token with a default timestamp of Time.now
token = Branca::Token.new("Some arbitrary payload of bytes")
# => #<Branca::Token:0x00007fea06129ab0 @payload="Some arbitrary payload of bytes", @timestamp=2019-05-23 13:53:23 UTC>

encoded_token = token.encode
# => "19uURRnUUFkuzqi0TyT5MHcBUYekA36Y0n0dNC15oq6Iho8ub1FDKAosHWBBxejMnqmEfozLKLyGCD7vr4rU3vNgF6Ua1Yzqvblm8i9"

# Explicit timestamp for the token
token2 = Branca::Token.new("Some arbitrary payload of bytes", Time.now.utc)
# => #<Branca::Token:0x00007fea069093e8 @payload="Some arbitrary payload of bytes", @timestamp=2019-05-23 13:57:50 UTC>

encoded_token2 = token2.encode
# => "19uURS9VdfcOkpzz4FSZxBe7iHjUTxV1ECDGEdDwR2OpGchQKMsBu8Jv9owyIqXbHZqZP4YElsIpg0y3xg0zQSgwH4TZqOxin8riZRQ"
```

### Decoding Tokens

```ruby
require "branca"

encoded_token = "19uURS9VdfcOkpzz4FSZxBe7iHjUTxV1ECDGEdDwR2OpGchQKMsBu8Jv9owyIqXbHZqZP4YElsIpg0y3xg0zQSgwH4TZqOxin8riZRQ"

token = Branca::Token.decode(encoded_token)
# => #<Branca::Token:0x00007fea069093e8 @payload="Some arbitrary payload of bytes", @timestamp=2019-05-23 13:57:50 UTC>
```

### Exceptions

TODO: Document exceptions

### Configuration

TODO:
 
## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/crossoverhealth/branca.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

