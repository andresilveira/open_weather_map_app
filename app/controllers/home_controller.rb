class HomeController < ApplicationController
  before_action :random_coords
  
  # GET
  def index
    @weather = api.weather_by_coordinates(@coords.lat, @coords.lon)
  end
  
  # POST
  def search
    @weather = api.weather_by_city(params[:city][:name], params[:city][:country_code])
    
    if @weather.empty?
      render :index, notice: "City Not Found (is it Narnia?)"
    else
      render :show
    end
  end
  
  private
  
  def random_coords
    # TODO: refactor this concept of coordinates to it's own class
    @coords = Coordinate.new(rand(-90..90), rand(-180..180))
  end
  
  # TODO:
  #  * move the initialization of the API to a initializer
  #  * move the api_key to a config yaml
  def api
    OpenWeatherMap::API::JSON.new(api_key: "")
  end
  
end
