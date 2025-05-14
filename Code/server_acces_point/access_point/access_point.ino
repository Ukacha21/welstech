// #include <WiFi.h>
// const char* ssid = "ESP_AP";
// const char* password = "12345678";

// WiFiServer server(80);

// void setup() {
//   Serial.begin(115200);
//   WiFi.softAP(ssid, password);
//   server.begin();
//   Serial.println(WiFi.softAPIP());  // Show IP to connect from Flutter
// }

// void loop() {
//   WiFiClient client = server.available();
//   if (client) {
//     while (client.connected()) {
//       if (client.available()) {
//         String req = client.readStringUntil('\r');
//         Serial.println(req);
//         client.flush();
//         client.println("Hello from ESP32");
//         break;
//       }
//     }
//     client.stop();
//   }
// }

#include <WiFi.h>

const char *ssid = "ESP32-Access-Point";
const char *password = "12345678";  // Optional, minimum 8 chars

WiFiServer server(80);

void setup() {
  Serial.begin(115200);

  // Start Access Point
  WiFi.softAP(ssid, password);

  IPAddress IP = WiFi.softAPIP();
  Serial.print("Access Point IP address: ");
  Serial.println(IP);  // Should be 192.168.4.1

  server.begin();
}

void loop() {
  WiFiClient client = server.available();  // listen for incoming clients

  if (client) {
    Serial.println("New Client Connected");
    while (client.connected()) {
      if (client.available()) {
        // Read client request
        String request = client.readStringUntil('\r');
        Serial.println("Request: " + request);
        client.flush();

        /*
        
        // here implement the following
        if (request == "getBPM"){
          // initilize bpm reading 
          //do the math, predict and send
          //in the meantime while reading pulse, blink green/blue led
          //while reading bpm, led blinks is based on peaks
        }
        */

        //here simply blink blue or green
        // Respond with "Hello from ESP32"
        client.println("HTTP/1.1 200 OK");
        client.println("Content-Type: text/plain");
        client.println("Connection: close");
        client.println();
        client.println("Hello from ESP32");
        break;
      }
    }
    else {
      //blink red light, meaning no connection
    }

    delay(1);
    client.stop();
    Serial.println("Client Disconnected");
  }
}

