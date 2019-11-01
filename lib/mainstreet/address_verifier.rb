module MainStreet
  class AddressVerifier
    def initialize(address, country: nil, locale: nil)
      @address = address
      @country = country
      @locale = locale
    end

    def success?
      failure_message.nil?
    end

    def failure_message
      if !result
        message :unconfirmed, "Address can't be confirmed"
      elsif result.respond_to?(:analysis)
        analysis = result.analysis

        if analysis["verification_status"]
          case analysis["verification_status"]
          when "Verified"
            nil # success!!
          when "Ambiguous", "Partial", "None"
            message :unconfirmed, "Address can't be confirmed"
          else
            raise "Unknown verification_status"
          end
        elsif analysis["dpv_match_code"]
          case analysis["dpv_match_code"]
          when "Y"
            nil # success!!
          when "N"
            message :unconfirmed, "Address can't be confirmed"
          when "S"
            message :apt_unconfirmed, "Apartment or suite can't be confirmed"
          when "D"
            message :apt_missing, "Apartment or suite is missing"
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
        # don't use smarty streets zipcode only API
        # keep mirrored with geocoder gem, including \Z
        # \Z is the same as \z when strip is used
        if @address.to_s.strip !~ /\A\d{5}(-\d{4})?\Z/
          Geocoder.search(@address, options).first
        end
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

    def message(key, default)
      if defined?(I18n)
        I18n.t(key, scope: [:mainstreet, :errors, :messages], locale: @locale, default: default)
      else
        default
      end
    end
  end
end
