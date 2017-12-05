require 'rubygems'
require 'mqtt'
require 'json'
require 'httparty'
require 'dotenv'
Dotenv.load

###########################################
################ Adapter ##################
###########################################

class Services
  module Adapter
    module Mqttadapter
      def self.post(payload, url, headers)
      end

      def self.get(topicUrl, headers)
        client = MQTT::Client.connect(headers)
        client.subscribe( topicUrl )
        return client
      end
    end

    module Httpadapter
      def self.post(payload, url, headers)
        if headers
          response = HTTParty.post(url,:body => payload.to_json,:headers => headers )
          return response
        else
          response = HTTParty.post(url,:body => payload.to_json,:headers => { 'Content-Type' => 'application/json' } )
          return response
        end
      end

      def self.get(url, headers)
      end
    end
  end

  def adapter
    return @adapter if @adapter
    self.adapter = :Httpadapter
    @adapter
  end

  def adapter=(adapter)
    @adapter = Services::Adapter.const_get(adapter.to_s.capitalize)
  end
end

###########################################
################# Logic ###################
###########################################

def get_auth0_token()
  payload = {
      "client_id": ENV['CLIENT_ID'],
      "client_secret": ENV['CLIENT_SECRET'],
      "audience": ENV['AUDIENCE'],
      "grant_type": ENV['GRANT_TYPE']
  }

  url = "https://arquisoft201720-wrravelo.auth0.com/oauth/token"
  services = Services.new
  services.adapter = :Httpadapter
  response = services.adapter.post(payload, url, nil)

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

  services = Services.new
  services.adapter = :Httpadapter
  response = services.adapter.post(payload, uri, header)
  puts "#{response.code} #{valor}"
end

token = get_auth0_token()

headers = {
  :host => 'localhost',
  :port => 8883 ,
  :ssl => true,
  :username => 'microcontrolador',
  :password => 'Isis2503.'
}

services = Services.new
services.adapter = :Mqttadapter
client = services.adapter.get('registros', headers)

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
