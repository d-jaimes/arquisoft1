import msgpack
import json
import requests
from kafka import KafkaProducer
from kafka.errors import KafkaError

producer = KafkaProducer(bootstrap_servers=['localhost:8090'])

url = 'http://localhost:3000/api/registro_mediciones'

response = requests.get(url)

for currentJson in response.json():
	print(currentJson)
	#producer = KafkaProducer(value_serializer=msgpack.dumps)
	#producer.send('alta.piso1.local1', currentJson)

producer.flush()
