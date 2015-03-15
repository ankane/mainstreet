# MainStreet

A standard US address model for Rails

You get:

- verification
- standardization
- geocoding

## How It Works

```ruby
Address.create!(street: "1 infinite loop", zip_code: "95014")
```

This creates an address with:

- street - `1 Infinite Loop`
- city - `Cupertino`
- state - `CA`
- zip_code - `95014`
- latitude - `37.33053`
- longitude - `-122.02887`
- original_attributes - `{"street"=>"1 infinite loop", "street2"=>nil, "city"=>nil, "state"=>nil, "zip_code"=>"95014"}`
- verification_info

### Verification

By default, MainStreet performs ZIP code verification.

```ruby
address = Address.new(street:"1 infinite loop", zip_code: "95015")
address.valid?
# false
address.errors.full_messages
# ["Did you mean 95014?"]
```

For full verification, including unit number, [see below](#full-verification).

## Installation

Add this line to your application’s Gemfile:

```ruby
gem 'mainstreet'
```

To create a new address model, run:

```sh
rails g mainstreet:address
```

This creates an `Address` model with:

- street
- street2
- city
- state
- zip_code
- latitude
- longitude
- original_attributes
- verification_info

To add to an existing model:

1. Use `alias_attribute` to map existing field names
2. Add new fields like `original_attributes` and `verification_info`
3. Add `acts_as_address` to your model

## Full Verification

[SmartyStreets](https://smartystreets.com/features) is required for full verification. The free plan supports 250 lookups per month.

Set:

```ruby
ENV["SMARTY_STREETS_AUTH_ID"] = "auth-id"
ENV["SMARTY_STREETS_AUTH_TOKEN"] = "auth-token"
```

To test it, run:

```ruby
address = Address.new(street: "122 Mast Rd", zip_code: "03861")
address.valid?
# should get false
```

## Contributing

Everyone is encouraged to help improve this project. Here are a few ways you can help:

- [Report bugs](https://github.com/ankane/mainstreet/issues)
- Fix bugs and [submit pull requests](https://github.com/ankane/mainstreet/pulls)
- Write, clarify, or fix documentation
- Suggest or add new features
