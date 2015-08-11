require 'test_helper'
require 'minitest/autorun'

describe OpenWeatherMap::API do
  before do 
   @wrapper = OpenWeatherMap::API.new(api_key: "")
  end

  it 'have an uri for weather by coordinates' do
    @wrapper.uri_for_weather_by_coordinates(123,321).to_s.must_equal "http://api.openweathermap.org/data/2.5/weather?lat=123&lon=321&units=metric"
  end
  
  describe JSON do
    before do
     @wrapper = OpenWeatherMap::API::JSON.new(api_key: "")
    end

    describe '#weather_by_coordinates' do
      before(:all) do
        @weather = @wrapper.weather_by_coordinates(1,1)
      end
      
      [:temperature, :description, :icon, :wind_speed, :pressure, :humidity, :sunrise, :sunset, :city, :country].each do |attribute|
        it "should contain #{attribute}" do
          @weather.keys.include?(attribute).must_equal true
        end
      end
    end
  end
end
