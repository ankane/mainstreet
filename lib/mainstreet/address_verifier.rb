module MainStreet
  class AddressVerifier
    def initialize(address, country: nil)
      @address = address
      @country = country
    end

    def success?
      failure_message.nil?
    end

    def failure_message
      if !result
        "Address can't be confirmed"
      elsif result.respond_to?(:analysis)
        analysis = result.analysis

        if analysis["verification_status"]
          case analysis["verification_status"]
          when "Verified"
            nil # success!!
          when "Ambiguous", "Partial", "None"
            "Address can't be confirmed"
          else
            raise "Unknown verification_status"
          end
        elsif analysis["dpv_match_code"]
          case analysis["dpv_match_code"]
          when "Y"
            nil # success!!
          when "N"
            "Address can't be confirmed"
          when "S"
            "Apartment or suite can't be confirmed"
          when "D"
            "Apartment or suite is missing"
          else
            raise "Unknown dpv_match_code"
          end
        end
      end
    end

    def result
      @result ||= begin
        options = {lookup: lookup}
        options[:country] = @country if @country && !usa?
        Geocoder.search(@address, options).first
      end
    end

    def latitude
      result && result.latitude
    end

    def longitude
      result && result.longitude
    end

    private

    def usa?
      ["United States", "USA", "US", "840"].include?(@country.to_s)
    end

    def lookup
      ENV["SMARTY_STREETS_AUTH_ID"] ? :smarty_streets : nil
    end
  end
end
