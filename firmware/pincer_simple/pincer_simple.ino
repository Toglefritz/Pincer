#include <Adafruit_NeoPixel.h>
#include <ArduinoJson.h>
#include <ESP32Servo.h>
#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <BLE2902.h>

/* 
  PINCER ROBOT ARM
  SIMPLE FIRMWARE

  by: Scott Hatfield for Splendid Endeavors
/*
  This firmware is designed for the ESP32-based Pincer robot arm controller. It allows 
  for the control of four servos via JSON commands. Each servo corresponds to a 
  different part of the robot arm: 

    - the base servo rotates the arm about the vertical axis
    - the coxa servo adjusts the angle of the femur bone
    - the femur servo adjusts the angle between the femur bone and the tibia bone
    - the gripper servo opens and closes the gripper

  This simplified firmware eschews kinematics calculations in favor of accepting 
  commands to directly control the angles of the robot arm's servos. Commands can be
  sent to the robot arm via Serial from a PC connected to the robot arm by USB or 
  via Bluetooth from a client device, like a mobile app. The API for controlling the
  robot arm is the same in either case.
*/

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

/**
 * @class ServerCallbacks
 * @brief A class to handle BLE server connection and disconnection events.
 *
 * This class extends the BLEServerCallbacks class and overrides its methods
 * to provide custom behavior for when a client connects and disconnects from the
 * BLE server.
 *
 * @method onConnect
 * This method is called when a client device connects to the BLE server.
 * It can be used to perform actions such as logging the connection event or
 * triggering other functionalities on the ESP32.
 *
 * @method onDisconnect
 * This method is called when a client device disconnects from the BLE server.
 * It can be used to handle disconnection events such as logging or resetting
 * specific states on the ESP32.
 */
class ServerCallbacks : public BLEServerCallbacks {
    void onConnect(BLEServer* pServer) {
        Serial.println("Device connected");
    }

    void onDisconnect(BLEServer* pServer) {
        Serial.println("Device disconnected");
    }
};

/**
 * @brief Sets the value of a BLE characteristic to a specified string value.
 * 
 * @param pCharacteristic A pointer to the BLECharacteristic object to be updated.
 * @param value The string value to set for the characteristic.
 */
void setCharacteristicValue(BLECharacteristic* pCharacteristic, const std::string& value) {
    if (pCharacteristic != nullptr) { // Ensure the characteristic pointer is valid.
        pCharacteristic->setValue(value); // Set the value.
        pCharacteristic->notify(); // Notify connected clients about the change.
    }
}

/**
 * @class Callbacks
 * @brief A class to handle BLE characteristic read and write events.
 *
 * This class extends the BLECharacteristicCallbacks class and overrides its methods
 * to provide custom behavior for read and write operations on the BLE characteristics.
 *
 * @method onWrite
 * This method is called when a write request is received for the BLE characteristics.
 * It handles comands received to move the robot arm via Bluetooth.
 */
class Callbacks : public BLECharacteristicCallbacks {
    void onWrite(BLECharacteristic* pCharacteristic) {
        std::string value = pCharacteristic->getValue();
        String valueStr = String(value.c_str());
        processCommand(valueStr);
    }
};

/**
 * @class DescriptorCallbacks
 * @brief A class to handle BLE descriptor read and write events.
 *
 * This class extends the BLEDescriptorCallbacks class and overrides its onWrite method
 * to provide custom behavior for enabling or disabling notifications on the BLE characteristics.
 *
 * @method onWrite
 * This method is called when a write request is received for the BLE2902 descriptor,
 * which is the standard descriptor for enabling or disabling notifications.
 * It handles the following cases:
 *   - When a value of 0x01 is written to the descriptor, it means the client has enabled notifications.
 *     The method will print "Notifications enabled" to the serial console.
 *   - When a value of 0x00 is written to the descriptor, it means the client has disabled notifications.
 *     The method will print "Notifications disabled" to the serial console.
 *
 * The method checks the written value to determine if notifications have been enabled or disabled.
 *
 * So why enable notifications? This allows a client (like a mobile app) to listen for updates on
 * the position of Pincer's motors in real time.
 */
class DescriptorCallbacks : public BLEDescriptorCallbacks {
    void onWrite(BLEDescriptor* pDescriptor) {
        uint8_t* data = pDescriptor->getValue();
        if (data[0] == 0x01) { // Client has enabled notifications
            Serial.println("Notifications enabled");
        } else if (data[0] == 0x00) { // Client has disabled notifications
            Serial.println("Notifications disabled");
        }
    }
};

void setup() {
  Serial.begin(115200);
  Serial.flush(); // Clear the buffer

  // Initizlie the NeoPixel strip object
  pixels.begin(); 

  // Set LED brightness
  pixels.setBrightness(20);

  // Attach servos to their respective pins
  baseServo.attach(baseServoPin);
  coxaServo.attach(coxaServoPin);
  femurServo.attach(femurServoPin);
  gripperServo.attach(gripperServoPin);

  // Create the BLE Device
  BLEDevice::init("PINCER");

  // Configure BLE Security settings
  // Create a new instance of the BLESecurity class, which is used to manage BLE 
  // security settings.
  BLESecurity *pSecurity = new BLESecurity();
  // Set the Input/Output capabilities of the ESP32-C3's BLE to none, meaning it 
  // doesn't have a display or keyboard to enter or display a pairing PIN.
  pSecurity->setCapability(ESP_IO_CAP_NONE); 
  // Configure the authentication mode to "Secure Connections Only" (SC Only). This 
  // mode mandates a secure BLE connection, ensuring that the 
  // connection is protected against eavesdropping and man-in-the-middle attacks. 
  // From the perspective of somebody using a mobile app, this
  // security setting is invisible because it happens behind the scenes, however 
  // this setting is important to protect information exchanged between the mobile 
  // app and the Pincer robot arm.
  pSecurity->setAuthenticationMode(ESP_LE_AUTH_REQ_SC_ONLY);

  // Create the BLE server, which registers the callback classes above which contain
  // methods for handling actions like connections and the receipt of messages.
  BLEServer *pServer = BLEDevice::createServer();
  pServer->setCallbacks(new ServerCallbacks());

  // Create the BLE service, which is a number that uniquely identifies the Pincer 
  // robot arm among other Bluetooth Low Energy devices that may be within range of 
  // the mobile  app that is trying to connect to the robot arm.
  BLEService *pService = pServer->createService("b19cdadc-434f-42e2-9478-3bbd98234567");

  // Create the open BLE characteristic, which is the one characteristic used to control
  // the Pincer robot arm in this simple firmware. The Bluetooth characteristic is a 
  // communication channel that is used for a specific purpose, in this case controlling
  // the robot arm.
  BLECharacteristic *pOpenCharacteristic = pService->createCharacteristic(
      "abcd1234-1234-1234-1234-1234567890ab",
      BLECharacteristic::PROPERTY_READ |  // The app can read the value of this characteristic
      BLECharacteristic::PROPERTY_WRITE | // The app can write to this characteristic
      BLECharacteristic::PROPERTY_NOTIFY  // The app can subscribe to updates in the value
  );

  // Set callbacks on the open BLE characteristic. These callbacks are defined in several
  // classes above.
  pOpenCharacteristic->setCallbacks(new Callbacks());
  BLEDescriptor* pOpenNotificationDescriptor = new BLE2902();
  pOpenNotificationDescriptor->setCallbacks(new DescriptorCallbacks());
  pOpenCharacteristic->addDescriptor(pOpenNotificationDescriptor);

  // Start the service
  pService->start();

  // Start advertising, which means that the ESP32 will begin broadcasting details about
  // its BLE service so that clients, like mobile apps, can find the robot arm and 
  // begin the connectino process. Advertizing devices are the ones that show up in
  // the list when you go to add a new Bluetooth device to your phone.
  pServer->getAdvertising()->start();
  Serial.println("BLE advertising started");

  // Hello
  Serial.println("");
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

  // Check if the command JSON contains a value for the base servo and, if
  // it does, set this position on the servo. 
  if (doc.containsKey("base")) {
    Serial.print("Moving base servo to ");
    Serial.print(doc["base"].as<String>());
    Serial.println(" degrees");

    baseServo.write(doc["base"].as<int>());
  }

  // Check if the command JSON contains a value for the coxa servo and, if
  // it does, set this position on the servo. 
  if (doc.containsKey("coxa")) {
    Serial.print("Moving coxa servo to ");
    Serial.print(doc["coxa"].as<String>());
    Serial.println(" degrees");

    coxaServo.write(doc["coxa"].as<int>());
  }

  // Check if the command JSON contains a value for the femur servo and, if
  // it does, set this position on the servo. 
  if (doc.containsKey("femur")) {
    Serial.print("Moving femur servo to ");
    Serial.print(doc["femur"].as<String>());
    Serial.println(" degrees");

    femurServo.write(doc["femur"].as<int>());
  }

  // Check if the command JSON contains a value for the gripper servo and, if
  // it does, set this position on the servo. 
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

  // Note that there is nothing Bluetooth related in the loop because the
  // callbacks defined above handle Bluetooth operations.
}