require "rails/generators"

module Mainstreet
  class AddressGenerator < Rails::Generators::Base
    def boom
      invoke "model", ["Address", "street:string", "street2:string", "city:string", "state:string", "zip_code:string", "latitude:decimal{15.10}", "longitude:decimal{15.10}", "verification_info:text", "original_attributes:text"], options
      insert_into_file "app/models/address.rb", "  acts_as_address\n", after: "ActiveRecord::Base\n"
    end
  end
end
