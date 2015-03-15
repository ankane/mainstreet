require "mainstreet/version"
require "geocoder"

module Mainstreet
  class << self
    attr_writer :lookup

    def lookup
      @lookup ||= begin
        if ENV["SMARTY_STREETS_AUTH_ID"] && ENV["SMARTY_STREETS_AUTH_TOKEN"]
          Geocoder.config[:smarty_streets] ||= {api_key: [ENV["SMARTY_STREETS_AUTH_ID"], ENV["SMARTY_STREETS_AUTH_TOKEN"]]}
        end
        Geocoder.config[:smarty_streets] ? :smarty_streets : nil
      end
    end
  end

  module Model
    def acts_as_address(_options = {})
      class_eval do
        serialize :original_attributes
        serialize :verification_info

        validate :verify_address, if: -> { address_fields_changed? }
        before_save :standardize_address, if: -> { address_fields_changed? }

        def verify_address
          @verification_result = fetch_verification_info
          if @verification_result
            if @verification_result.respond_to?(:analysis)
              case @verification_result.analysis["dpv_match_code"]
              when "N"
                errors.add(:base, "Address could not be confirmed")
              when "S"
                errors.add(:base, "Apartment or suite could not be confirmed")
              when "D"
                errors.add(:base, "Apartment or suite is missing")
              end
            end

            correct_zip_code = @verification_result.postal_code
            if zip_code != correct_zip_code
              errors.add(:base, "Did you mean #{correct_zip_code}?")
            end
          else
            errors.add(:base, "Address could not be confirmed")
          end
          errors.full_messages
        end

        def standardize_address
          result = @verification_result
          if result
            info = result.data
            self.original_attributes = attributes.slice(*address_fields)
            self.verification_info = result.data.to_hash
            self.street =
              if result.respond_to?(:delivery_line_1)
                result.delivery_line_1
              else
                result.formatted_address.split(",").first
              end
            self.street2 = nil
            self.city = result.city
            self.state = result.state_code
            self.zip_code = result.postal_code
            self.latitude = result.latitude
            self.longitude = result.longitude
          end
          true
        end

        def fetch_verification_info
          Geocoder.search("#{street} #{street2} #{city}, #{state} #{zip_code}", lookup: Mainstreet.lookup).first
        end

        def address_fields_changed?
          address_fields.any? { |f| send("#{f}_changed?") }
        end

        def address_fields
          attributes.keys & %w(street street2 city state zip_code)
        end
      end
    end
  end
end

ActiveRecord::Base.send(:extend, Mainstreet::Model) if defined?(ActiveRecord)
