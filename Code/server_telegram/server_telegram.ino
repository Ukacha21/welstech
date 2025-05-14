#include <WiFi.h>
#include <WiFiClientSecure.h>
#include <UniversalTelegramBot.h>


/*
chat id: <Your chat id>

bot token: <YOur Token>






*/

// Replace these with your network credentials
const char* ssid = "YOUR_WIFI_SSID";
const char* password = "YOUR_WIFI_PASSWORD";

// Telegram BOT Token (from BotFather)
const char* botToken = "YOUR_BOT_TOKEN_HERE";

// Your Telegram Chat ID (get it from https://api.telegram.org/bot<your_bot_token>/getUpdates)
const char* chatID = "YOUR_CHAT_ID_HERE";

WiFiClientSecure secured_client;
UniversalTelegramBot bot(botToken, secured_client);

void setup() {
  Serial.begin(115200);

  // Connect to Wi-Fi
  WiFi.begin(ssid, password);
  Serial.print("Connecting to WiFi..");
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("\nConnected to WiFi");

  // Allow insecure connection (bypass SSL certificate checking)
  secured_client.setInsecure();

  // Send a message
  String message = "Hello from ESP32-S3!";
  bool sent = bot.sendMessage(chatID, message, "");
  
  if (sent) {
    Serial.println("Message sent successfully!");
  } else {
    Serial.println("Failed to send message.");
  }
}

void loop() {
  // nothing here
}
