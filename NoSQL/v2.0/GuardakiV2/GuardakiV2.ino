/*********
  Rui Santos
  Complete project details at https://RandomNerdTutorials.com/esp8266-nodemcu-hc-sr04-ultrasonic-arduino/
  
  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files.
  
  The above copyright notice and this permission notice shall be included in all
  copies or substantial portions of the Software.
*********/

#include <ESP8266WiFi.h>
#include <PubSubClient.h>
#include <Wire.h>

const int trigPin = 12;
const int echoPin = 14;
const int redPin = 4;
char* travaON = "TRAVADO";
char* travaOFF = "DESTRAVADO";

// SSID e senha WiFi
const char* ssid = "HackaTruckVisitantes";
const char* password = "";

// Define a velocidade do som em cm/us
#define SOUND_VELOCITY 0.034
#define CM_TO_INCH 0.393701

// IBM Cloud
#define ORG "6unkgi"
#define DEVICE_TYPE "Arduino"
#define DEVICE_ID "Arduino01"
#define TOKEN "123456789"

// Broker Messagesight server
char server[] = ORG ".messaging.internetofthings.ibmcloud.com";
char topic[] = "iot-2/evt/status/fmt/json";
char authMethod[] = "use-token-auth";
char token[] = TOKEN;
char clientId[] = "d:" ORG ":" DEVICE_TYPE ":" DEVICE_ID;

long duration;
float distanceCm;
float distanceInch;
bool blocked = false;

WiFiClient wifiClient;
PubSubClient client(server, 1883, NULL, wifiClient);

void setup() {
  Serial.begin(115200);
  Serial.print("Conectando na rede WiFi "); // Imprime mensagem na Serial
  Serial.println(ssid); // Imprime o SSID na Serial
  WiFi.begin(ssid, password); // Conecta ao WiFi
  while (WiFi.status() != WL_CONNECTED) { // Aguarda a conexão
    delay(500);
    Serial.print(".");
  }
  Serial.println("");
  Serial.print("[INFO] Conectado WiFi IP: ");
  Serial.println(WiFi.localIP()); // Imprime o IP atribuído na Serial

  Serial.println(F("| ============================================= |"));
  Serial.println(F("| Arduino com sensor de obstáculos Ultrassonico |"));
  Serial.println(F("| ============================================= |"));

  pinMode(trigPin, OUTPUT); // Define o pino trigPin como saída
  pinMode(echoPin, INPUT); // Define o pino echoPin como entrada
  //pinMode(redPin, OUTPUT); // Define o pino redPin como saída

  client.setServer(server, 1883); // Configura o servidor MQTT
}

void loop() {
  if (!client.connected()) { // Se não estiver conectado ao servidor MQTT
    Serial.print("Reconnecting client to "); // Imprime mensagem na Serial
    Serial.println(server); // Imprime o servidor na Serial
    while (!client.connect(clientId, authMethod, token)) { // Tenta reconectar
      Serial.print(".");
      delay(500);
    }
    Serial.println();
  }

  distanceCm = measureDistance(); // Mede a distância

  if (distanceCm <= 9.00) { // Se a distância for menor ou igual a 9 cm
    if (!blocked) { // Se não estiver bloqueado
      Serial.println("TRAVADO"); // Imprime mensagem na Serial
      digitalWrite(redPin, HIGH); // Acende o LED vermelho
      Serial.print("Distance (cm): ");
      Serial.println(distanceCm); // Imprime a distância na Serial
    }
  } else if (distanceCm >= 15.00) { // Se a distância for maior ou igual a 15 cm
    if (blocked) { // Se estiver bloqueado
      Serial.println("DESTRAVADO"); // Imprime mensagem na Serial
      Serial.print("Distance (cm): ");
      Serial.println(distanceCm); // Imprime a distância na Serial
      blocked = false; // Desbloqueia
    }
  }

  publishDistance(distanceCm); // Publica a distância no tópico MQTT

  delay(2000); // Aguarda 10 segundos

  client.loop(); // Mantém a conexão com o servidor MQTT
}

// Função para medir a distância
float measureDistance() {
  digitalWrite(trigPin, LOW); // Define o pino trigPin como LOW
  delayMicroseconds(60); // Aguarda 60 microssegundos
  digitalWrite(trigPin, HIGH); // Define o pino trigPin como HIGH
  delayMicroseconds(10); // Aguarda 10 microssegundos
  digitalWrite(trigPin, LOW); // Define o pino trigPin como LOW
  duration = pulseIn(echoPin, HIGH); // Lê a duração do pulso no pino echoPin
  float distance = duration * SOUND_VELOCITY / 2.0; // Calcula a distância
  return distance; // Retorna a distância
}

// Função para publicar a distância no tópico MQTT
void publishDistance(float distanceCm) {
  String payload = "{\"distanceCm\": " + String(distanceCm) + "}"; // Cria o payload JSON com a distância
  if(distanceCm <= 9.00){
    //String payload = "{\"Saida\": " + String("travaOFF") + "}"; // Cria o payload JSON com a distância
  }else if(distanceCm >= 15.00){
    //String payload = "{\"Saida\": " + String("travaON") + "}"; // Cria o payload JSON com a distância
  }

  if (client.publish(topic, (char*)payload.c_str())) { // Publica o payload no tópico MQTT
    Serial.println("Publicado com sucesso!"); // Imprime mensagem na Serial
    digitalWrite(redPin, LOW); // Apaga o LED vermelho
  } else {
    Serial.println("Falha ao publicar!"); // Imprime mensagem na Serial
  }
}
