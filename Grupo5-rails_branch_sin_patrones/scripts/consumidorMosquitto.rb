require 'rubygems'
require 'mqtt'
require 'json'
require 'httparty'
require 'dotenv'
Dotenv.load

def get_auth0_token()
  payload = {
      "client_id": ENV['CLIENT_ID'],
      "client_secret": ENV['CLIENT_SECRET'],
      "audience": ENV['AUDIENCE'],
      "grant_type": ENV['GRANT_TYPE']
  }

  response = HTTParty.post("https://arquisoft201720-wrravelo.auth0.com/oauth/token",:body => payload.to_json,:headers => { 'Content-Type' => 'application/json' } )
  token = response['access_token']
  puts "Code: #{response.code} Token : #{token}"
  return token
end

def create_register(token, valor, promedio, nivel, area, tipo)
  uri = 'http://localhost:3000/api/registro_mediciones'
  header_token = "Bearer #{token}"
  header = {'Content-Type': 'application/json', 'Authorization': header_token}

  payload = {
    "registro_medicion": {
      "valor": valor
    },
    "promedio": promedio,
    "nivel": nivel,
    "area": area,
    "tipo": tipo
  }

  response = HTTParty.post(uri,:body => payload.to_json,:headers => header )
  puts "#{response.code} #{valor}"
end

token = get_auth0_token()
client = MQTT::Client.connect(
:host => 'localhost',
:port => 8883 ,
:ssl => true,
:username => 'microcontrolador',
:password => 'Isis2503.'
)

client.subscribe( 'registros' )

client.get do |topic,message|
  puts "-----------------------------------------"
  puts topic
  puts "-----------------------------------------"
  json = JSON.parse(message)
  puts json

  nivel = json['Nivel']
  area = json['Area']

  create_register(token, json['Temperature']['Value'], json['Temperature']['Promedio'], nivel, area, "Temperature")
  create_register(token, json['Sound']['Value'], json['Sound']['Promedio'], nivel, area, "Sound")
  create_register(token, json['Monoxide']['Value'], json['Monoxide']['Promedio'], nivel, area, "Monoxide")
  create_register(token, json['Lux']['Value'], json['Lux']['Promedio'], nivel, area, "Lux")
  # TODO Mandar el place
end

client.disconnect()
