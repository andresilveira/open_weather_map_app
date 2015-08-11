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
  end
end