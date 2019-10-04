module MainStreet
  module Model
    def validates_address(fields:, geocode: false, country: nil, **options)
      fields = Array(fields.map(&:to_s))
      geocode_options = {latitude: :latitude, longitude: :longitude}
      geocode_options = geocode_options.merge(geocode) if geocode.is_a?(Hash)
      options[:if] ||= -> { fields.any? { |f| changes.key?(f.to_s) } } unless options[:unless]

      class_eval do
        validate :verify_address, **options

        define_method :verify_address do
          address = fields.map { |v| send(v).presence }.compact.join(", ")

          if address.present?
            # must use a different variable than country
            record_country = instance_exec(&country) if country.respond_to?(:call)
            verifier = MainStreet::AddressVerifier.new(address, country: record_country)
            if verifier.success?
              if geocode
                self.send("#{geocode_options[:latitude]}=", verifier.latitude)
                self.send("#{geocode_options[:longitude]}=", verifier.longitude)
              end
            else
              errors.add(:base, verifier.failure_message)
            end

            # legacy - for standardize_address method
            @address_verification_result = verifier.result
          end
        end
      end
    end
  end
end
