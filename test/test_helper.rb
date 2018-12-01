require "bundler/setup"
require "active_record"
Bundler.require(:default)
require "minitest/autorun"
require "minitest/pride"
require "vcr"
require "webmock"

def smarty_streets?
  !ENV["SMARTY_STREETS_AUTH_ID"].nil?
end

VCR.configure do |c|
  c.hook_into :webmock
  c.cassette_library_dir = "test/cassettes"
  c.filter_sensitive_data("<auth-id>") { ENV["SMARTY_STREETS_AUTH_ID"] } if ENV["SMARTY_STREETS_AUTH_ID"]
  c.filter_sensitive_data("<auth-token>") { ENV["SMARTY_STREETS_AUTH_TOKEN"] } if ENV["SMARTY_STREETS_AUTH_TOKEN"]
end

cassette_name = smarty_streets? ? "smarty_streets" : "default"
VCR.insert_cassette(cassette_name, record: :once)
Minitest.after_run { VCR.eject_cassette }

# migrations
ActiveRecord::Base.establish_connection adapter: "sqlite3", database: ":memory:"

ActiveRecord::Migration.create_table :addresses do |t|
  t.text :street
  t.text :city
  t.string :region
  t.string :postal_code
  t.string :country
  t.decimal :latitude
  t.decimal :longitude
end

class Address < ActiveRecord::Base
  validates_address fields: [:street, :city, :region, :postal_code],
    geocode: true,
    country: -> { country }
end
