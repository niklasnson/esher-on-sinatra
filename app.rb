require 'sinatra'

set :public_folder, 'public'

get '/' do
  erb :index
end

get '/dashboard' do
  #pull data from external services
  erb :dashboard
end
