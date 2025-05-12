#include <ESP8266WiFi.h>

const char* ssid = "ESP_LED";
const char* password = "12345678";

WiFiServer server(80);
const int ledPin = 5;  // GPIO5 = D1

void setup() {
  pinMode(ledPin, OUTPUT);
  digitalWrite(ledPin, LOW);

  Serial.begin(9600);

  // 1. IP fija para evitar conflictos y mantener estable la conexión
  IPAddress local_ip(192, 168, 4, 1);
  IPAddress gateway(192, 168, 4, 1);
  IPAddress subnet(255, 255, 255, 0);
  WiFi.softAPConfig(local_ip, gateway, subnet);

  // 2. Desactivar modo ahorro de energía (importante para que no se "duerma")
  WiFi.setSleepMode(WIFI_NONE_SLEEP);

  // 3. Iniciar el Access Point
  WiFi.softAP(ssid, password);

  Serial.print("Access Point IP: ");
  Serial.println(WiFi.softAPIP());

  server.begin();
}

void loop() {
  WiFiClient client = server.available();
  if (!client) return;

  // Esperar a que haya datos sin bloquear el WiFi
  unsigned long timeout = millis() + 2000;
  while (!client.available() && millis() < timeout) {
    delay(1); // puedes usar yield() si prefieres
  }

  if (!client.available()) {
    client.stop();
    return;
  }

  String request = client.readStringUntil('\r');
  client.readStringUntil('\n');
  Serial.println("Petición: " + request);

  if (request.indexOf("/data/") != -1) {
  int pos = request.indexOf("/data/") + 6;
  String binario = request.substring(pos, pos + 8); // Asumiendo longitud fija
  Serial.println("Binario recibido: " + binario);

  // Si quieres convertirlo a número:
  byte valor = strtol(binario.c_str(), NULL, 2); // convierte de binario a decimal
  Serial.print("Valor en decimal: ");
  Serial.println(valor);
  Serial.write(valor);  // Envía el byte real por UART
}

  client.print("HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\n\r\n");
  client.print("LED está ");
  client.print((digitalRead(ledPin) == HIGH) ? "ENCENDIDO" : "APAGADO");

  delay(1);

  client.stop();
}
