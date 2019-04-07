
//Include all directories pre-designated by complier
#include <Wire.h>
#include <FastLED.h>

//Include all classes in this directory
#include "IRTrackingCamera.h"

// Number of LEDs on strip
#define NUM_LEDS 60

// Data pin for LED digital controll
#define DATA_PIN 7

// An array object to map every LED
CRGB leds[NUM_LEDS];

// IRTrackingCamera initilaize
IRTrackingCamera camera;
int x[4];
int y[4];

void setup() {

  camera.initialize();
	delay(2000);
  FastLED.addLeds<WS2811, DATA_PIN, RGB>(leds, NUM_LEDS);
}

void loop() {
   // Move a single white led

     camera.useSensor();
     //camera.showAll();

     x[0] = camera.getx();
     y[0] = camera.getz();

  Serial.print("//");
    Serial.print(x[0]);
    Serial.print(",");
    Serial.print(y[0]);
    Serial.print("//");
      // Turn our current led on to white, then show the leds
      leds[x[0]/100] = CRGB::White;

      // Show the leds (only one of which is set to white, from above)
      FastLED.show();

      // Wait a little bit
      delay(100);

      // Turn our current led back to black for the next loop around
      leds[x[0]/100] = CRGB::Black;
}
