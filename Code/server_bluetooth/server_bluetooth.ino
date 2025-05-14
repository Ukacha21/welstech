#include "BluetoothSerial.h"

BluetoothSerial SerialBT;

void setup() {
  Serial.begin(115200);
  SerialBT.begin("ESP32_HelloWorld"); // Bluetooth device name
  Serial.println("Bluetooth started. Waiting for connection...");
}

void loop() {
  // if (SerialBT.hasClient()) {
  //   SerialBT.println("Hello from ESP32!");
  //   delay(1000); // send every second
  // }
  if (SerialBT.connected()) {  // <-- changed from hasClient() to connected()
    SerialBT.println("Hello from ESP32!");
    delay(1000); // send every second
  }
}
