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
    
    def uri_for_weather_by_coordinates(lat, lon)
      uri = API_URI
      uri.query = URI.encode_www_form({lat: lat.to_s, lon: lon.to_s}.merge(DEFAULT_PARAMETERS))
      uri
    end
    
    class API::JSON < API
      require 'json'

      def weather_by_coordinates(lat, lon)
        resp = ::JSON.parse(super(lat,lon))
        
        weather = resp["weather"].first
        main = resp["main"]
        sys = resp["sys"]

        {
          temperature:  main["temp"],           # depends on units
          pressure:     main["pressure"],       # %
          humidity:     main["humidity"],       # hPa
          description:  weather["description"], 
          icon:         weather["icon"],
          wind_speed:   resp["wind"]["speed"],  # m/s
          sunrise:      sys["sunrise"],         # time at UTC
          sunset:       sys["sunset"],          # time at UTC
          country:      sys["country"],         # country Code
          city:         resp["name"]            # city name
        }
      end
    end
  end
end