require 'test_helper'
require 'minitest/autorun'

describe OpenWeatherMap::API do
  it 'it must exist' do
    OpenWeatherMap::API.new(api_key: 'some_key').wont_be_nil
  end
end
