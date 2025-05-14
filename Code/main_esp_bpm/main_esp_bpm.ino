#include <Wire.h>
// #include
#include <WiFi.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>

// #include <SPI.h>


// Define the OLED display object
#define SCREEN_WIDTH 128
#define SCREEN_HEIGHT 64
#define OLED_RESET -1

/*


*/


// Define custom SDA and SCL pins
#define SDA_PIN 2
#define SCL_PIN 4

// Create an instance of the display
Adafruit_SSD1306 display(SCREEN_WIDTH, SCREEN_HEIGHT, &Wire, OLED_RESET);

// I2C address of the display, usually 0x3C or 0x3D
// #define SSD1306_I2C_ADDRESS 0x3C //0x3C or 0x3D
// Define the I2C address for the SSD1306
#define OLED_I2C_ADDRESS 0x3C  

//  0x3C // MOST COMMON
//  0x3D
//  0x3A
//  0x3E
//  0x76

#define SENSOR_SIGNAL_PIN_ADC 7  // GPIO1 for the heart rate sensor signal
// #define ACTION_BUTTON_PIN 12 // change to 8

// about sensor----------------

//for getpulse2

//----------
#define MIN_BPM 30     // Set a minimum heart rate threshold for valid data
#define MAX_BPM 200 
#define NUM_SAMPLES 5

//last try variables ---------

//-----------
int threshold = 1995;   //1980 Adjust this based on your readings
bool peakDetected = false;
unsigned long lastPeakTime = 0;
unsigned long currentTime;
int BPM = 0;

unsigned long initialTime;
int interval = 10000; // to okbserve heartbeat peaks for 10 seconds
// int num_of_beats = 0;
int pulse_counts = 0;

int reading = 0;



// int Bpm = 0;

int led = 13;

const char* ssid = "ukxs"; //YOUR_WIFI_SSID
const char* password = "12345678"; //YOUR_WIFI_PASSWORD



// #define Highpulse 540

// float pulseIntervals[NUM_SAMPLES];  // Store pulse intervals



// -------------------------------
// const int analogPin = 34;

void scan_display_address() {
    Serial.begin(115200);
    Wire.begin();
    
    // Start the I2C communication
    Serial.println("I2C Scanner");

    // Scan all I2C addresses from 1 to 127
    for (byte address = 1; address < 127; address++) {
      Wire.beginTransmission(address);
      byte error = Wire.endTransmission();
      
      // Print out errors or success
      if (error == 0) {
        Serial.print("I2C device found at address 0x");
        if (address < 16) {
          Serial.print("0");
        }
        Serial.println(address, HEX);
      } else if (error == 4) {
        Serial.print("Unknown error at address 0x");
        if (address < 16) {
          Serial.print("0");
        }
        Serial.println(address, HEX);
      }
    }
    Serial.println("Scanning complete.");

}

void clearDisplay(){
  display.clearDisplay();
  // displayText("Heart Rate: ", 1, 0,0);
}

void display_init() {
    // about display--------------------
    // Start I2C communication
    // Wire.begin(3, 4); // SDA = GPIO 3, SCL = GPIO 4
    Wire.begin(SDA_PIN, SCL_PIN);

    // Initialize Serial for debugging
    // Serial.begin(115200);
    
    // Initialize the OLED display
    while (!display.begin(SSD1306_SWITCHCAPVCC, OLED_I2C_ADDRESS)) {
      // Serial.println(F("SSD1306 allocation failed"));
      
      digitalWrite(led, HIGH);
      delay(2000);
      digitalWrite(led, LOW);
      delay(2000);
      // for (;;); // Infinite loop if display initialization fails
      }

    // while (display.begin(OLED_I2C_ADDRESS, OLED_RESET)) {

    //   digitalWrite(led, HIGH);
    //   delay(200);
    //   digitalWrite(led, LOW);
    //   delay(200);
    //   this worked and out display turned on

    //   // f
    // }

    // Clear the display buffer
  // display.clearDisplay();
  // display.fillRect(0, 0, SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2, SSD1306_WHITE);  // White rectangle
  // display.fillRect(SCREEN_WIDTH / 2, 50, SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2, SSD1306_BLACK);  // Black rectangle

  //-------------
    display.clearDisplay();

//     // Set text color and size
//     /*
//     [
//     SSD1306_WHITE,
//     SSD1306_BLACK,
//     SSD1306_INVERT
//     ]
//     */
    display.setTextColor(SSD1306_WHITE);
    display.setTextSize(2);

    // Display a message
    display.setCursor(12, 30);
    display.println(F("WELSTECH"));


    display.setTextColor(SSD1306_WHITE);
    display.setTextSize(1);
    // Display a message
    display.setCursor(0, 0);
    display.println(F("welcome"));



    // ----------
    // Update the display content / Display everything on the screen
    display.display();


    
}

void displayText(String text, int textSize, int posX = 0, int posY = 0) {
  // clearDisplay();
  // Set the text size and color
  display.setCursor(posX, posY);
  display.setTextSize(textSize);          // Text size (1-10)
  display.setTextColor(SSD1306_WHITE);   

  // Print the text to the display
  display.println(text);
  
  // Update the display to show the text
  display.display();
  
}



WiFiServer server(80);
void setup() {
    Serial.begin(115200);

    WiFi.begin(ssid, password);

    while (WiFi.status() != WL_CONNECTED) {
      delay(1000);
      Serial.println("Connecting...");
    }

    server.begin();







    Wire.setClock(400000);  // Set I2C clock speed to 100kHz (default is 400kHz)

    // for (int i = 0; i < NUM_SAMPLES; i++) {
    //   pulseIntervals[i] = 0;
    // }

    pinMode(led, OUTPUT);

    pinMode(SENSOR_SIGNAL_PIN_ADC, INPUT);
    // Set the action button pin (for potential use in your project)
    // pinMode(ACTION_BUTTON_PIN, INPUT_PULLUP);
    
    // Attach interrupt to detect pulse on rising edge
    // attachInterrupt(digitalPinToInterrupt(SENSOR_SIGNAL_PIN_ADC), pulseISR, RISING);

    // Initial time
    // lastPulseTime = millis();  // Assuming the button is active low

    display_init();
    delay(2000); //to show welstech for some time, show logo and stuff
    
    clearDisplay();

}

int calcBPM(int counts, int interval) {
  // int result = (counts/interval) * 60 ;
  int result = (counts*60)/(interval/1000);
  counts = 0;
  return result;
}

void loop() {
    // Read the analog value from the heart rate sensor
    float currentReading = analogRead(SENSOR_SIGNAL_PIN_ADC);

    /*
    after some observations:
    currentReading seems to reach 1980-2000+ when pulse detected
    and below that when np pulse detected
    */

    // getPulse();

    //-----------------------------------
    delay(400);
    clearDisplay();
    char buffer[10];
    dtostrf(currentReading, 4, 2, buffer);
    String newtext = "Ang val:\n" + String(buffer);
    displayText(newtext, 2, 0,30);
    // displayText(String(millis()), 2, 0,30);
    currentTime = millis();  // Get current time
    //-------------------------------------------
    

    // displayText(String(WiFi.localIP()), 2, 0,30);
    

    //--------------------------------------

    // Detect peak when value rises above the threshold
    // if (currentReading > threshold && !peakDetected) {
    //     peakDetected = true;

    //     //WHAT IF WE DELAY A FEW SECONDS BEFORE 
    //     // WE START READING, AFTER THE FIRST DETECTION 
    //     reading = 1;
    //     clearDisplay();
        
    //     pulse_counts++;

    //     displayText("Peak", 2, 12,30);
    //     displayText(String(pulse_counts), 1, 110,56);
        

    //     if (currentTime - initialTime >= interval) { // SOMETHING IS OFF HERE // (currentTime - initialTime >= interval)
          
    //       initialTime = currentTime;

    //       String newRes = String(calcBPM(pulse_counts, interval));

    //       pulse_counts = 0;

    //       clearDisplay();
    //       displayText(newRes, 2, 55,30);
    //       displayText("BPM", 1, 60, 46);

    //       // pulse_c
    //       reading = 0;
          
    //       // pulse_counts = 0; //
    //       delay(interval/2); // CONTROL THIS LATER
    //       // delay(2500); //
    //       clearDisplay();
    //     }
    
    //     // }
    //     // lastPeakTime = currentTime;  // Update last peak time
    //     delay(25);
    // }
    // else {
      
    //   if (reading == 0){
    //     // clearDisplay();
    //     displayText("--", 2, 50,30);
    //     displayText("READING", 1, 40, 46);

    //   }
      
    // }

    // // Reset peak detection when signal drops
    // //ADJUST THIS AND THRESHOLD, UNLTIL WE GET AN ACCEPTABLE VALUE
    // if (currentReading < threshold - 80) { // was 100 before, adjust accordinlgy. Small buffer to avoid double counting
    //     peakDetected = false;
    // }
    

    // // if (digitalRead(ACTION_BUTTON_PIN) == LOW) { //eliminated button
    // //   while (digitalRead(ACTION_BUTTON_PIN) == LOW) {}
    // // }

    // // getPulse3();

    // // delay(25);
    
    // // delay(200);






}
