class HomeController < ApplicationController
  before_action :random_coords
  
  # TODO:
  #  * move the initialization of the API to a initializer
  #  * move the api_key to a config yaml
  def index
    @weather = OpenWeatherMap::API::JSON.new(api_key: "").weather_by_coordinates(@coords.lat, @coords.lon)
  end
  
  private
  
  def random_coords
    # TODO: refactor this concept of coordinates to it's own class
    @coords = Coordinate.new(rand(-90..90), rand(-180..180))
  end
  
end
