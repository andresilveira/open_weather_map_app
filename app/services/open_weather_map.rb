class OpenWeatherMap
  class API
    require 'net/http'

    attr_reader :api_key

    API_VERSION = '2.5'
    API_URI = URI("http://api.openweathermap.org/data/#{API_VERSION}/weather")
    DEFAULT_PARAMETERS = { units: "metric" }

    def initialize(api_key:)
      @api_key = api_key
    end
    
    def weather_by_coordinates(lat, lon)
      response = Net::HTTP.get_response(uri_for_weather_by_coordinates(lat.to_s, lon.to_s))
      response.body if response.is_a?(Net::HTTPSuccess)
    end
    
    def weather_by_city(city_name, country_code="")
      response = Net::HTTP.get_response(uri_for_weather_by_city(city_name.to_s, country_code.to_s))
      response.body if response.is_a?(Net::HTTPSuccess)
    end
    
    def uri_for_weather_by_coordinates(lat, lon)
      uri = API_URI
      uri.query = URI.encode_www_form({lat: lat.to_s, lon: lon.to_s}.merge(DEFAULT_PARAMETERS))
      uri
    end
    
    def uri_weather_by_city(city_name, country_code="")
      uri = API_URI
      uri.query = URI.encode_www_form({q: "#{city_name.to_s},#{country_code.to_s}"}.merge(DEFAULT_PARAMETERS))
      uri
    end
    
    class API::JSON < API
      require 'json'

      def weather_by_coordinates(lat, lon)
        resp = ::JSON.parse(super(lat,lon))
        render_response(resp)
      end
      
      def weather_by_city(city_name, country_code="")
        resp = ::JSON.parse(super(city_name, country_code))
        render_response(resp)
      end
      
      private

      def render_response(resp)
        if resp["cod"].to_i == 200
          render_successful_response(resp)
        elsif resp["cod"].to_i == 404
          render_not_found_response(resp)
        else
          raise Exception, "Unknown API response code"
        end
      end

      def render_successful_response(resp)
        weather = resp["weather"].first
        main = resp["main"]
        sys = resp["sys"]

        {
          temperature:  main["temp"],           # depends on units
          pressure:     main["pressure"],       # hPa
          humidity:     main["humidity"],       # %
          description:  weather["description"], 
          icon:         weather["icon"],
          wind_speed:   resp["wind"]["speed"],  # m/s
          sunrise:      sys["sunrise"],         # time at UTC
          sunset:       sys["sunset"],          # time at UTC
          country:      sys["country"],         # country Code
          city:         resp["name"]            # city name
        }
      end

      def render_not_found_response(resp)
        {}
      end
    end
  end
end