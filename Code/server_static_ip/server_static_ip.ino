#include <WiFi.h>
#include <WebServer.h>



/*
to add to flutter

const String esp32Url = 'http://192.168.137.184/';



*/

// Wi-Fi credentials (your phone's hotspot SSID and password)
const char* ssid = "altayar"; //YOUR_HOTSPOT_SSID
const char* password = "12345678"; //YOUR_HOTSPOT_PASSWORD


// Static IP config based on your phone's hotspot
IPAddress local_IP(192, 168, 137, 184);     // ESP32's IP (make sure it's not used)
IPAddress gateway(192, 168, 137, 102);      // Your phone's hotspot IP (from ipconfig)
IPAddress subnet(255, 255, 255, 0);         // Subnet mask
// IPAddress primaryDNS(8, 8, 8, 8);          // Optional
// IPAddress secondaryDNS(8, 8, 4, 4);        // Optional


WebServer server(80); // HTTP server on port 80

void handleRoot() {
  server.send(200, "text/plain", "Hello, World");
}


void setup() {
  Serial.begin(115200);

  // // Configure static IP
  // if (!WiFi.config(local_IP, gateway, subnet, primaryDNS, secondaryDNS)) {
  //   Serial.println("STA Failed to configure");
  // }
  // Set static IP before connecting
  if (!WiFi.config(local_IP, gateway, subnet)) {
    Serial.println("Failed to configure static IP");
  }

  // Connect to Wi-Fi
  WiFi.begin(ssid, password);
  Serial.print("Connecting to WiFi..");

  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.print(".");
  }

  Serial.println();
  Serial.println("WiFi connected");
  Serial.print("IP address: ");
  Serial.println(WiFi.localIP());

  // Define route and start server
  server.on("/", handleRoot); //handle root endlpoint
  server.begin();
  Serial.println("HTTP server started");

  /*more endpoint exxample----------------

    server.on("/status", []() {
    server.send(200, "text/plain", "ESP32 is alive!");
    });

    server.on("/sensor", []() {
      int value = analogRead(34);
      server.send(200, "text/plain", String(value));
    });

    //then on flutter side:-------

      await http.get(Uri.parse("http://192.168.137.184/status"));  // → ESP32 is alive!
      await http.get(Uri.parse("http://192.168.137.184/sensor"));  // → returns sensor value


  */
}

void loop() {
  server.handleClient(); // Handle incoming HTTP requests
}
