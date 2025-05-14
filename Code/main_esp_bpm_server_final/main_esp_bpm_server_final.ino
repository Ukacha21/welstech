
#include <WiFi.h>

// Red Green adn Blue pins
#define red 2
// #define green 4
#define blue 4 // change to 8

bool rState = false;
// bool gState = false;
bool bState = false;

String resultString = "--";

#define SENSOR_SIGNAL_PIN_ADC 7  // GPIO1 for the heart rate sensor signal

//----------
#define MIN_BPM 30     // Set a minimum heart rate threshold for valid data
#define MAX_BPM 200 
#define NUM_SAMPLES 5

//last try variables ---------

//-----------
int threshold = 852;//860; //846-848 arasi//840-850 arasi   //1980 Adjust this based on your readings
bool peakDetected = false;
unsigned long lastPeakTime = 0;
unsigned long currentTime;
int BPM = 0;

unsigned long initialTime;
int interval = 10000; // to okbserve heartbeat peaks for 10 seconds
// int num_of_beats = 0;
int pulse_counts = 0;

int reading = 0;

float currentReading = 0;
//access point stuff----------

const char *ssid = "ESP32-Access-Point";
const char *password = "12345678";  // Optional, minimum 8 chars

WiFiServer server(80);
WiFiClient client;  // listen for incoming clients
bool connected = false;

void setup() {
    Serial.begin(115200);
      

    pinMode(red, OUTPUT);
    // pinMode(green, OUTPUT);
    pinMode(blue, OUTPUT);

    pinMode(SENSOR_SIGNAL_PIN_ADC, INPUT);


    WiFi.softAP(ssid, password);

    IPAddress IP = WiFi.softAPIP();
    Serial.print("Access Point IP address: ");
    Serial.println(IP);  // Should be 192.168.4.1

    server.begin();
    
}

int calcBPM(int counts, int interval) {
  // int result = (counts/interval) * 60 ;
  int result = (counts*60)/(interval/100);
  counts = 0;
  return result;
}

void post(String message){
  
  if (client && connected == true) {
    client.println("HTTP/1.1 200 OK");
    client.println("Content-Type: text/plain");
    client.println("Connection: close");
    client.println();
    client.println(message);
  }
}



void detect_Peaks() {
  // Update pulse count if peak detected
  // if (currentReading > threshold && !peakDetected && currentReading < (threshold)) { //threshold+2 = 848 for now
  if (currentReading > threshold) { //threshold+2 = 848 for now

    peakDetected = true;
    // reading = 0;
    pulse_counts++;
  }

  // // Reset peak detection if signal drops
  // if (currentReading < threshold - 80) {
  //   peakDetected = false;
  // }

  // Time to calculate BPM?
  if (currentTime - initialTime >= interval) {
    initialTime = currentTime;
    if (pulse_counts > 0) {
      String newRes = String(calcBPM(pulse_counts, interval));
      // post(newRes);
      resultString = newRes;

      // reading = 1;
    } else {
      post("No P. D.");
      // resultString = "No P. D.";
    }
    pulse_counts = 0;
  } else if (reading == 0) {
    // post("Reading");
    // resultString = "Reading";
  }

  // pulse_counts = 0;

  delay(20);  // Control sample rate
}


String get_rawDemo(float value) {
  // delay(400);//remove delay if necessary
  // clearDisplay();
  int tempint = (int)value;
  char buffer[10];
  dtostrf(tempint, 4, 2, buffer);
  String newtext = "" + String(buffer);
  
  // displayText(newtext, 2, 0,30); //post to http server
  // displayText(String(millis()), 2, 0,30);
  return newtext;
}


void loop() {
    // Read the analog value from the heart rate sensor
    currentReading = analogRead(SENSOR_SIGNAL_PIN_ADC);

    /*
    after some observations:
    currentReading seems to reach 1980-2000+ when pulse detected
    and below that when np pulse detected
    */

    
    currentTime = millis();  // Get current time
    // unsigned long ledCurrentMillis = millis();

    detect_Peaks(); 


    client = server.available();  // listen for incoming clients

    //-------------------------------------------
    if (client) {
      // connected = true;
      
      // Serial.println("New Client Connected");
      
      // while (client.connected()) {

      connected = true;
      Serial.println("New Client Connected");

      String request = client.readStringUntil('\r');
      Serial.println("Request: " + request);
      client.flush();


      //detect_Peaks(); //uncoment this, after getting the optimum threshold
      // post(get_rawDemo(currentReading));//after getting the optimum threshold, comment this out
      post(resultString);

      // if (resultString == "Reading"){

      // }
      // else{
      //   delay(interval/2);
      // }

      // if (reading == 1){
      //   delay(interval/2);
      //   reading = 0;
      // }

      client.stop();  // disconnect after sending response
      Serial.println("Client Disconnected");
            
      
    }
    else{
      
      connected = false;
    }

    delay(30);
    

}
