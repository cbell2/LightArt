
//Include all directories pre-designated by complier
#include <Wire.h>
#include <FastLED.h>

//Include all classes in this directory
#include "IRTrackingCamera.h"

//DEBUG Prints
//#define ph //uncomment for personhalo() function debugging

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
int threshold = 2; //LED values on side of master LED
float maxBrightness = 256.0;
char person1 = 0;
char person2 = 0;

//Functionn signatures
int personHalo(int mathP);

void setup() {
  camera.initialize();
	delay(2000);
  FastLED.addLeds<WS2811, DATA_PIN, RGB>(leds, NUM_LEDS);
  Serial.begin(9600);
}

void loop() {
     // camera.useSensor();
     //camera.showAll();

     //Here is where the values from the camera are set
     x[0] = 100;
     y[0] = camera.getz();

     x[1] = 5;

     //This should be done in processing since we will be using cv
     if(x[0] > 0 && x[0] < 1023 && person1 == 0){
       //Serial.println("hi");
       Serial.println("1");
       person1 = 1;
     }else if(x[0] <= 0 || x[0] >= 1023){
       person1 = 0;
     }

     if(x[1] > 0 && x[1] < 1023 && person2 == 0){
       //Serial.println("hi");
       Serial.println("2");
       person2 = 1;
     }else if(x[1] <= 0 || x[1] >= 1023){
       person2 = 0;
     }

     //leds[2] = CRGB::White;
     // leds[2].fadeLightBy(200);
     // x values have to be set TODO: make a parameter for LED color (this will be dependet on the music)
     personHalo(x[0]);
     personHalo(x[1]);

      // Show the leds (only one of which is set to white, from above)
      FastLED.show();

      // Wait a little bit
      delay(50);
      FastLED.clear();
}

//Fucntion to light LEDS up
int personHalo(int mathP){

  int brightness = 256;
  long middle = (long)((float)mathP*0.393255132); //Decimal number: ratio of LEDs/sensor_value
  int step = (int)(maxBrightness/((float)threshold));

  #ifdef ph
  Serial.println(mathP);
  Serial.println(middle);
  Serial.println("--------------");
  Serial.println(step);
  #endif


  for(int i = 0; i < threshold*2; i++){
    int masterLed = i+middle-threshold;
    if(masterLed < 0 || masterLed > NUM_LEDS){
    }else{
      leds[masterLed] = CRGB::White;
    }
    if(masterLed < middle){

      #ifdef ph
      Serial.println(brightness);
      #endif

      brightness = brightness - step;
      leds[masterLed].fadeLightBy(brightness);

    }else if(masterLed > middle){

      #ifdef ph
      Serial.println(brightness);
      #endif

      brightness = brightness + step;
      leds[masterLed].fadeLightBy(brightness);
    }
  }
}
