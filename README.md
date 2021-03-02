# MainStreet

Address verification for Ruby and Rails

:earth_americas: Supports international addresses

[![Build Status](https://github.com/ankane/mainstreet/workflows/build/badge.svg?branch=master)](https://github.com/ankane/mainstreet/actions)

## Installation

Add this line to your application’s Gemfile:

```ruby
gem 'mainstreet'
```

## How It Works

MainStreet uses [Geocoder](https://github.com/alexreisner/geocoder) for address verification, which has a number of [3rd party services](https://github.com/alexreisner/geocoder/blob/master/README_API_GUIDE.md#global-street-address-lookups) you can use. If you adhere to GDPR, be sure to add the service to your subprocessor list.

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

The order should be the same as if you were to write the address out.

For performance, the address is only verified if at least one of the fields changes. Set your own condition with:

```ruby
class User < ApplicationRecord
  validates_address if: -> { something_changed? }, ...
end
```

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

## Internationalization (i18n)

You can customize error messages with the [i18n](https://github.com/ruby-i18n/i18n) gem. In Rails, add to the appropriate `config/locales` file:

```yml
en:
  mainstreet:
    errors:
      messages:
        unconfirmed: Address can't be confirmed
        apt_unconfirmed: Apartment or suite can't be confirmed
        apt_missing: Apartment or suite is missing
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

To get started with development:

```sh
git clone https://github.com/ankane/mainstreet.git
cd mainstreet
bundle install
bundle exec rake test
```
