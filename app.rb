require 'sinatra'
require 'httparty'

set :public_folder, 'public'


def temperature
  url = "http://vitalbond.azurewebsites.net/home/sql?0=Esher"
  payload = "iGetSensorData 2, 'temperature'"
  #payload = "iGetSensorData 2, 'tempature', #{data_date(DateTime.now)}, #{data_date(DateTime.now)}"
  response = HTTParty.post(url, body: payload)
  tempature = response["Descr"]
  tempature.to_f.round(2)
end

def humidity
  url = "http://vitalbond.azurewebsites.net/home/sql?0=Esher"
  payload = "iGetSensorData 2, 'humidity'"
  #payload = "iGetSensorData 2, 'humidity', #{data_date(DateTime.now)}, #{data_date(DateTime.now)}"
  response = HTTParty.post(url, body: payload)
  humidity = response["Descr"]
  humidity.to_f.round(2)
end

def query(type)
  from = "20170909 12:56"
  to = "20170909 13:03"
  url = "http://vitalbond.azurewebsites.net/home/sql?0=Esher"
  payload = "iGetSensorData 2, '#{type}', '#{from}', '#{to}'"
  response = HTTParty.post(url, body: payload)
  humidity = response["Descr"]
  humidity.to_f.round(2)
end

def humudity_array
  a = []
  i = 13
  5.times do | num |
    a << query("humidity")
    i = i + 1
  end
  puts a.inspect
end

def date
  DateTime.now
end

def pritty_date(date)
  date.strftime("%H:%M")
end

def data_date(date)
  date.strftime("%Y%m%d %H:%M'")
end

post '/mail' do
  @name=params[:name]
  @from=params[:email]
  @message=params[:message]
  erb :mail
end

post '/dashboard/add-symptom' do
  puts params.inspect
  redirect "/dashboard"
end

get '/login' do
  erb :login
end

post '/login' do
  redirect '/dashboard'
end

get '/' do
  erb :index
end

get '/dashboard' do
  @tempature = temperature
  @humidity = humidity
  @timestamp = pritty_date(date)
  humudity_array
  @available_parts=['Head',
                    'Face',
                    'Mouth',
                    'Throat',
                    'Teeth',
                    'Right shoulder',
                    'Left shoulder',
                    'Right upper arm','Right lower arm',
                    'Left upper arm','Left lower arm',
                    'Right hand','Left hand',
                    'Chest',
                    'Stomach',
                    'Right upper part of leg',
                    'Left upper part of leg',
                    'Right lower part of leg',
                    'Left lower part of leg',
                    'Right knee', 'Left knee',
                    'Left Foot', 'Right Foot']
  @available_symptoms=['Hurts',
                       'Tingles',
                       'Cramps',
                       'Feels weird',
                       'Pounds',
                       'Under heavy pressure',
                       'Itches']
  @available_actions=['I do nothing',
                      'I stand up',
                      'I sit down',
                      'I hit myself',
                      'I sleep',
                      "I'm on the toilet",
                      'I swallow',
                      'I breathe']
  @available_times=['Always',
                    'Every time',
                    'Sometimes',
                    'Every week',
                    'Every day',
                    'In the mornings',
                    'In the afternoon',
                    'In the evening',
                    'At night']
  erb :dashboard, locals: {avail_parts: @available_parts, avail_symp: @available_symptoms, avail_actions: @available_actions, avail_times: @available_times}
end
