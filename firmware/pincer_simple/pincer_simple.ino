#include <Adafruit_NeoPixel.h>
#include <ArduinoJson.h>
#include <ESP32Servo.h>

// The QT Py ESP32-C3 has a single onboard Neopixel LED
#define NUMPIXELS 1

Adafruit_NeoPixel pixels(NUMPIXELS, PIN_NEOPIXEL, NEO_GRB + NEO_KHZ800);

// Stores the last time LED was updated
unsigned long previousMillis = 0; 

// The interval at which to blink the LED in milliseconds
const long interval = 500;

// Define Servo objects
Servo baseServo;
Servo coxaServo;
Servo femurServo;
Servo gripperServo;

// Pin assignments for the servos
const int baseServoPin = 4; // A0
const int coxaServoPin = 3; // A1
const int femurServoPin = 1; // A2
const int gripperServoPin = 5;

void setup() {
  Serial.begin(115200);

  // Initizlie the NeoPixel strip object
  pixels.begin(); 

  // Set LED brightness
  pixels.setBrightness(20);

  // Attach servos to their respective pins
  baseServo.attach(baseServoPin);
  coxaServo.attach(coxaServoPin);
  femurServo.attach(femurServoPin);
  gripperServo.attach(gripperServoPin);

  // Hello
  Serial.println("PINCER ONLINE");
  Serial.println("Ready to pinch...");
}

/**
 * Processes the JSON command to control servo positions.
 *
 * Commands are sent to the Pincer robot arm as JSON objects which specify 
 * the desired angles for the robot's four servos. All of the fields in the
 * JSON commands are optional, allowing between one and four of the servos
 * to be controlled at the same time. For example, a command that would move
 * all four servos at once (assuming they were not already at the target
 * positioins) would be
 *
 *   {
 *     "base": 90,
 *     "coxa": 45,
 *     "femur": 75,
 *     "gripper": 30"
 *   }
 *
 * @param command The serialized JSON string containing servo positions.
 */
void processCommand(const String& command) {
  StaticJsonDocument<200> doc;
  deserializeJson(doc, command);

  // Check and set servo positions if they are provided in the JSON command
  if (doc.containsKey("base")) {
    Serial.print("Moving base servo to ");
    Serial.print(doc["base"].as<String>());
    Serial.println(" degrees");

    baseServo.write(doc["base"].as<int>());
  }
  if (doc.containsKey("coxa")) {
    Serial.print("Moving coxa servo to ");
    Serial.print(doc["coxa"].as<String>());
    Serial.println(" degrees");

    coxaServo.write(doc["coxa"].as<int>());
  }
  if (doc.containsKey("femur")) {
    Serial.print("Moving femur servo to ");
    Serial.print(doc["femur"].as<String>());
    Serial.println(" degrees");

    femurServo.write(doc["femur"].as<int>());
  }
  if (doc.containsKey("gripper")) {
    Serial.print("Moving gripper servo to ");
    Serial.print(doc["gripper"].as<String>());
    Serial.println(" degrees");

    gripperServo.write(doc["gripper"].as<int>());
  }

  // Clear the Serial buffer after the command has been processed
  Serial.flush();
}

void loop() {
  // Check if a command has been received over the Serial connection
  if (Serial.available() > 0) {
    // Read the incoming string
    String command = Serial.readStringUntil('\n');

    // Process the command
    processCommand(command);
  }

  unsigned long currentMillis = millis();

  // Check if the time since the last LED change is greater than 
  // the blink interval.
  if (currentMillis - previousMillis >= interval) {
    // Save the last time the LED was changed.
    previousMillis = currentMillis;

    // If the LED is off turn it on and vice-versa
    if (pixels.getPixelColor(0) == 0x000000) { // Check if the LED is off
      // Set color of the LED to unicorn pink and turn it on
      pixels.fill(0xBA34BA);
      pixels.show();
    } else {
      // Turn off
      pixels.fill(0x000000);
      pixels.show();
    }
  }
}