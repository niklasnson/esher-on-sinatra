require 'sinatra'
require 'httparty'

set :public_folder, 'public'

get '/' do
  erb :index
end

post '/mail' do
  @name=params[:name]
  @from=params[:email]
  @message=params[:message]
  erb :mail
end

get '/login' do
  redirect '/dashboard'
end

get '/dashboard' do
  url = "http://vitalbond.azurewebsites.net/home/sql?0=Esher"
  payload = "iGetSensorData 2, 'Humidity', '20170909 12:56', '20170909 13:03'"
  response = HTTParty.post(url, body: payload)
  puts response["Descr"]

  erb :dashboard
end
