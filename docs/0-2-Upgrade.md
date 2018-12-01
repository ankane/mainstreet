# 0.2.0 Upgrade

Replace `acts_as_address` with:

```ruby
class User < ApplicationRecord
  validates_address fields: [:street, :street2, :city, :state, :zip_code], geocode: true

  serialize :original_attributes
  serialize :verification_info

  before_save :standardize_address

  def standardize_address
    result = @address_verification_result
    if result
      self.original_attributes = attributes.slice(:street, :street2, :city, :state, :zip_code)
      self.verification_info = result.data.to_hash
      self.street =
        if result.respond_to?(:delivery_line_1)
          result.delivery_line_1
        elsif result.respond_to?(:formatted_address)
          result.formatted_address.split(",").first
        elsif result.respond_to?(:display_name)
          "#{result.house_number} #{result.street}"
        else
          raise "Unknown geocoding result"
        end
      self.street2 = nil
      self.city = result.city
      self.state = result.state_code
      self.zip_code = result.postal_code
    end
  end
end
```
