# MainStreet

Address verification for Ruby and Rails

:earth_americas: Supports international addresses

## Installation

Add this line to your application’s Gemfile:

```ruby
gem 'mainstreet'
```

## Full Verification

By default, bad street numbers, units, and postal codes may pass verification. For full verification, get an account with [SmartyStreets](https://smartystreets.com). The free plan supports 250 lookups per month for US addresses, and plans for international addresses start at $7. To use it, set:

```ruby
ENV["SMARTY_STREETS_AUTH_ID"] = "auth-id"
ENV["SMARTY_STREETS_AUTH_TOKEN"] = "auth-token"
```

## How to Use

Check an address with:

```ruby
address = "1600 Pennsylvania Ave NW, Washington DC 20500"
verifier = MainStreet::AddressVerifier.new(address)
verifier.success?
```

If verification fails, get the failure message with:

```ruby
verifier.failure_message
```

Get details about the result with:

```ruby
verifier.result
```

Get the latitude and longitude with:

```ruby
verifier.latitude
verifier.longitude
```

## Active Record

For Active Record models, use:

```ruby
class User < ApplicationRecord
  validates_address fields: [:street, :street2, :city, :state, :postal_code]
end
```

For performance, the address is only verified if at least one of the fields changes. The order should be the same as if you were to write the address out.

Geocode the address with:

```ruby
class User < ApplicationRecord
  validates_address geocode: true, ...
end
```

The `latitude` and `longitude` fields are used by default. Specify the fields with:

```ruby
class User < ApplicationRecord
  validates_address geocode: {latitude: :lat, longitude: :lon}, ...
end
```

You can custom the validation error message with:

```ruby
class User < ApplicationRecord
  validates :street, message: 'Looks like this address is not valid!'
end
```

Empty addresses are not verified. To require an address, add your own validation.

```ruby
class User < ApplicationRecord
  validates :street, presence: true
end
```

## SmartyStreets

With SmartyStreets, you must pass the country for non-US addresses.

```ruby
MainStreet::AddressVerifier.new(address, country: "France")
```

Here’s the list of [supported countries](https://smartystreets.com/docs/cloud/international-street-api#countries). You can pass the name, ISO-3, ISO-2, or ISO-N code (like `France`, `FRA`, `FR`, or `250`).

**Note:** This requires Geocoder 1.5.1 or greater.

For Active Record, use:

```ruby
class User < ApplicationRecord
  validates_address country: "France", ...
end
```

Or use a proc to make it dynamic

```ruby
class User < ApplicationRecord
  validates_address country: -> { country }, ...
end
```

## Data Protection

We recommend encrypting street information and postal code (at the very least) for user addresses. [Lockbox](https://github.com/ankane/lockbox) is great for this. Check out [this article](https://ankane.org/sensitive-data-rails) for more details.

```ruby
class User < ApplicationRecord
  encrypts :street, :postal_code
end
```

## Upgrading

### 0.2.0

See the [upgrade guide](docs/0-2-Upgrade.md)

## History

View the [changelog](https://github.com/ankane/mainstreet/blob/master/CHANGELOG.md)

## Contributing

Everyone is encouraged to help improve this project. Here are a few ways you can help:

- [Report bugs](https://github.com/ankane/mainstreet/issues)
- Fix bugs and [submit pull requests](https://github.com/ankane/mainstreet/pulls)
- Write, clarify, or fix documentation
- Suggest or add new features
