#include "DHT.h"
#define DHTPIN 17
#define DHTTYPE DHT11 
int AOUTpin=27;//the AOUT pin of the CO sensor goes into analog pin A0 of the arduino
int DOUTpin=16;//the DOUT pin of the CO sensor goes into digital pin D8 of the arduino

DHT dht(DHTPIN, DHTTYPE);

int sensorPin = A0; // select the input pin for the potentiometer
int ledPin = 13; // select the pin for the LED
int sensorValue = 0; // variable to store the value coming from the sensor
int luxPin = 25;

void setup() {
  Serial.begin(9600);
  dht.begin();
  pinMode (ledPin, OUTPUT);
  pinMode(DOUTpin, INPUT);//sets the pin as an input to the arduino
}

void loop() {  
  int t= dht.readTemperature();//Lee la temperatura
                     
  Serial.print("temperature;");                  
  Serial.print(t);//Escribe la temperatura
  Serial.print(";C';");                   


  Serial.print("sound;");
 
  sensorValue = analogRead (sensorPin);
  digitalWrite (ledPin, HIGH);

  digitalWrite (ledPin, LOW);
 
  Serial.print(sensorValue, DEC);
  Serial.print(";dB;");
  
  int value= analogRead(AOUTpin); //lee el valor analaogo de el AOUT pin del sensor de monoxido de carbono
  Serial.print("monoxide;");
  Serial.print(value); //imprime valor de monoxido de carbono
    Serial.print(";ppm;");

  int anagLux = analogRead(luxPin);

  Serial.print("luminosidad;");
  Serial.print(anagLux); //imprime valor de lux
  Serial.print(";lux;");
  
  Serial.print("Place;1"); //imprime el lugar
  
  Serial.println("");
  

delay(2000);
}

