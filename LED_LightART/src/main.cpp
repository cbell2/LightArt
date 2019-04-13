
//Include all directories pre-designated by complier
#include <Wire.h>
#include <FastLED.h>

//Include all classes in this directory
#include "IRTrackingCamera.h"

// Number of LEDs on strip
#define NUM_LEDS 300

// Data pin for LED digital controll
#define DATA_PIN 7

// An array object to map every LED
CRGB leds[NUM_LEDS];

// IRTrackingCamera initilaize
IRTrackingCamera camera;
int x[4];
int y[4];

//LED stuff (bell curve)
long middle = 0;
int threshold = 1; //LED values on side of master LED
float maxBrightness = 256.0;

//Functionn signatures
int personHalo(int mathP);

void setup() {
  camera.initialize();
	delay(2000);
  FastLED.addLeds<WS2811, DATA_PIN, RGB>(leds, NUM_LEDS);
}

void loop() {
     camera.useSensor();
     //camera.showAll();

     x[0] = camera.getx();
     y[0] = camera.getz();

     x[1] = camera.getx2();

     // leds[2] = CRGB::White;
     // leds[2].fadeLightBy(200);

     personHalo(x[0]);
     //personHalo(x[1]);

      // Show the leds (only one of which is set to white, from above)
      FastLED.show();

      // Wait a little bit
      delay(50);
      FastLED.clear();
}

//Fucntion to light LEDS up
int personHalo(int mathP){
  Serial.println(mathP);
  int brightness = 256;
  long middle = (long)((float)mathP*0.393255132); //Decimal number: ratio of LEDs/sensor_value
  Serial.println(middle);
  int step = (int)(maxBrightness/((float)threshold));
  Serial.println("--------------");
  Serial.println(step);


  for(int i = 0; i < threshold*2; i++){
    int masterLed = i+middle-threshold;
    if(masterLed < 0 || masterLed > NUM_LEDS){
    }else{
      leds[masterLed] = CRGB::White;
    }
    if(masterLed < middle){
      Serial.println(brightness);
      brightness = brightness - step;
      leds[masterLed].fadeLightBy(brightness);
    }else if(masterLed > middle){
      Serial.println(brightness);
      brightness = brightness + step;
      leds[masterLed].fadeLightBy(brightness);
    }
  }
}
