module MainStreet
  class AddressVerifier
    def initialize(address, country: nil, locale: nil, options: nil)
      @address = address
      @country = country
      @locale = locale
      @options = options
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
      return @result if defined?(@result)

      @result = begin
        Geocoder.configure(@options) if @options[:smarty_streets].present?
        Geocoder.search(@address, fetch_search_options).first if @address.to_s.strip !~ /\A\d{5}(-\d{4})?\Z/
      end
    end

    def latitude
      result && result.latitude
    end

    def longitude
      result && result.longitude
    end

    private

    def fetch_search_options
      search_options = {}
      search_options[:lookup] = @options[:smarty_streets].present? ? :smarty_streets : MainStreet.lookup
      search_options[:country] = @country if @country && !usa?
      search_options
    end

    def usa?
      ["United States", "USA", "US", "840"].include?(@country.to_s)
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
