require 'sinatra'
require 'httparty'

set :public_folder, 'public'


def temperature
  url = "http://vitalbond.azurewebsites.net/home/sql?0=Esher"
  payload = "iGetSensorData 2, 'temperature'"
  response = HTTParty.post(url, body: payload)
  tempature = response["Descr"]
  tempature.to_f.round(2)
end

def humidity
  url = "http://vitalbond.azurewebsites.net/home/sql?0=Esher"
  payload = "iGetSensorData 2, 'humidity'"
  response = HTTParty.post(url, body: payload)
  humidity = response["Descr"]
  humidity.to_f.round(2)
end

def date
  DateTime.now
end

def pritty_date(date)
  date.strftime("%H:%M")
end

def data_date(date)
end


def test
  url = "http://vitalbond.azurewebsites.net/home/sql?0=Esher"
  payload = "iGetSensorData 2, 'humidity','20170901 12:56', '20170909 17:03'"
  response = HTTParty.post(url, body: payload)
  humidity = response["Descr"]
  puts response.inspect
end


get '/' do
  erb :index
end

get '/dashboard' do
  @tempature = temperature
  @humidity = humidity
  @timestamp = pritty_date(date)
  test
  erb :dashboard
end
