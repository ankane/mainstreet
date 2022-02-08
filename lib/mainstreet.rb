# dependencies
require "geocoder"

# modules
require "mainstreet/address_verifier"
require "mainstreet/version"

module MainStreet
  class << self
    attr_writer :lookup

    def lookup
      @lookup ||= ENV["SMARTY_STREETS_AUTH_ID"] ? :smarty_streets : nil
    end
  end
end

if ENV["SMARTY_STREETS_AUTH_ID"]
  Geocoder.config[:smarty_streets] ||= {
    api_key: [
      ENV["SMARTY_STREETS_AUTH_ID"],
      ENV["SMARTY_STREETS_AUTH_TOKEN"]
    ]
  }
end

if defined?(ActiveSupport.on_load)
  ActiveSupport.on_load(:active_record) do
    require "mainstreet/model"
    extend MainStreet::Model
  end
end
