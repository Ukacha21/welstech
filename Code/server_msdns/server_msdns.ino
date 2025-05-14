#include <WiFi.h>
#include <ESPmDNS.h>

const char* ssid = "altayar";
const char* password = "12345678";

WiFiServer server(8080);

void setup() {
  Serial.begin(115200);

  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("\nWiFi connected");

  if (!MDNS.begin("esp32device")) {
    Serial.println("Error starting mDNS");
    return;
  }

  // Advertise a TCP service on port 8080
  MDNS.addService("espdata", "tcp", 8080);

  server.begin();
  Serial.println("Server started on port 8080");
}

void loop() {
  WiFiClient client = server.available();
  if (client) {
    Serial.println("Client connected");
    client.println("Hello World");
    delay(100); // Give time to send
    client.stop();
  }
}

/*
flutter side
const String esp32Url = 'http://esp32s3.local/';
-----------------------------------
full code:

import 'package:http/http.dart' as http;

Future<String> fetchFromESP32() async {
  try {
    final response = await http.get(Uri.parse('http://esp32s3.local/'));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return 'Error: ${response.statusCode}';
    }
  } catch (e) {
    return 'Exception: $e';
  }
}


*/