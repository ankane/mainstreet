require "bundler/setup"
require "active_record"
Bundler.require(:default)
require "minitest/autorun"
require "minitest/pride"
require "vcr"

VCR.configure do |config|
  config.cassette_library_dir = "test/fixtures/vcr_cassettes"
  config.hook_into :webmock
end

# migrations
ActiveRecord::Base.establish_connection adapter: "sqlite3", database: ":memory:"

ActiveRecord::Migration.create_table :addresses do |t|
  t.text :street
  t.text :street2
  t.text :city
  t.string :state
  t.string :zip_code
  t.decimal :latitude
  t.decimal :longitude
  t.text :original_attributes
  t.text :verification_info
  t.timestamps null: false
end

class Address < ActiveRecord::Base
  acts_as_address
end
