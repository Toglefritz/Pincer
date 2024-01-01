/// This sketch is used to center a PWM servo motor, which is a useful first step when
/// assembling robotics projects.

/*
    Wiring:
      Wiring a servo to work with this sketch is easy. First, connect one of the board's GND 
      pins to the black wire from the servo. Second, connect one of the board's 5V pins to
      the red wire from the servo. Third, connect the board's GPIO pin #3 to the servo's yellow
      wire (or just its third wire if your servo has a color other than yellow).
*/

#include <Servo.h>

// Create a servo object to control the servo
Servo servo;

void setup() {
  // Attach the servo go GPIO pin 3
  servo.attach(3);
}

void loop() { 
  // Set the servo position to 90 degrees (which is half of 180 and thus in the center)
  servo.write(90);
  // Wait for the servo to move
  delay(100);
}
