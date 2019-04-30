
//Include all directories pre-designated by complier
#include <Wire.h>
#include <FastLED.h>
#include <LiquidCrystal_I2C.h>

//DEBUG Prints
//#define ph //uncomment for personhalo() function debugging
//#define lcdD //uncomment for Serial communication debugging

// Set the LCD address to 0x27 for a 16 chars and 2 line display
LiquidCrystal_I2C lcd(0x27, 16, 2);

// Number of LEDs on strip
#define NUM_LEDS 150

// Data pin for LED digital controll
#define DATA_PIN 7
#define DATA_PIN2 8

// An array object to map every LED
CRGB leds[NUM_LEDS];
String myStr = "0";
int time = 0;

//LED stuff (bell curve)
long middle = 15;
int threshold = 12; //LED values on side of master LED
float maxBrightness = 256.0;

//Serial communication packet variables
String inData;
char recieved;
String packetparsed;
int currentp;
int previousp;

String packetparsed1;
int currentp1;
int previousp1;

String packetparsed2;
int currentp2;
int previousp2;

String packetparsed3;
int currentp3;
int previousp3;
int packetthres = 25;

//Functionn signatures
int personHalo(int mathP,unsigned long color);
void testParallelLeds();
String getValue(String data, char separator, int index);
int x[4];

void setup() {

  FastLED.addLeds<WS2811, DATA_PIN, RGB>(leds, NUM_LEDS);
  FastLED.addLeds<WS2811, DATA_PIN2, RGB>(leds, NUM_LEDS);

  //I2C LCD for debugging
  lcd.begin();
  lcd.backlight();
  lcd.print("Spotlight Mix");

  x[0] =  10;
  x[1] =  0;
  x[2] =  0;
  x[3] =  0;
  previousp = 10;

  Serial.begin(9600);

}

void loop() {

//    for(int i = 0; i < 20; i++){
//    leds[i] = 0xFFFFFF; 
//  }

     //Here is where the values from the camera are set
     if(Serial.available()>0){
       recieved = Serial.read();

       if(recieved == 's'){
         while(recieved != 'e'){
           inData += recieved;
           recieved = Serial.read();
           //lcd.print("HI");
         }

         packetparsed = getValue(inData, ';', 1);
         currentp = packetparsed.toInt();

         if(currentp < previousp + packetthres && currentp > previousp - packetthres){
           x[0] = currentp;
           previousp = x[0];
          }

         packetparsed1 = getValue(inData, ';', 2);
         currentp1 = packetparsed1.toInt();

         if(currentp1 < previousp1 + packetthres && currentp1 > previousp1 - packetthres){
           x[1] = currentp1;
           previousp1 = x[1];
          }

         packetparsed2 = getValue(inData, ';', 3);
         currentp2 = packetparsed2.toInt();

         if(currentp2 < previousp2 + packetthres && currentp2 > previousp2 - packetthres){
           x[2] = currentp2;
           previousp2 = x[2];
          }

         packetparsed3 = getValue(inData, ';', 4);
         currentp3 = packetparsed3.toInt();

         if(currentp3 < previousp3 + packetthres && currentp3 > previousp3 - packetthres){
           x[3] = currentp3;
           previousp3 = x[3];
          }
       inData = "";

      #ifdef lcdD
      delay(500);
      lcd.clear();
      lcd.print(x[0]);
      lcd.setCursor(8,0);
      lcd.print(x[1]);
      lcd.setCursor(0,1);
      lcd.print(x[2]);
      lcd.setCursor(8,1);
      lcd.print(x[3]);
      #endif
    }
  }

      if(x[0] > 0){
      personHalo(x[0], 0xFFFFFF); //white
      }
      if(x[1] > 0){
        personHalo(x[1],0xFFFFFF); //red
      }
      if(x[2] > 0){
      personHalo(x[2],0xFFFFFF); //gold
      }
      if(x[3] > 0){
      personHalo(x[3],0xFFFFFF); //green
      }
      // Show the leds (only one of which is set to white, from above)
      FastLED.show();

      // Wait a little bit
      delay(50);
      FastLED.clear();
      //lcd.clear();

}

//Fucntion to light LEDS up
int personHalo(int mathP, unsigned long color){

  int brightness = 100;
  long middle = (long)((float)mathP); //Decimal number: ratio of LEDs/sensor_value
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
      leds[masterLed] = color;
    }
  }
}

void testParallelLeds(){
  for(int i = 0; i < NUM_LEDS; i++) {
    leds[i] = CRGB::Red;    // set our current dot to red
    FastLED.show();
    leds[i] = CRGB::Black;  //0x27 set our current dot to black before we continue
  }
}

String getValue(String data, char separator, int index)
{
    int found = 0;
    int strIndex[] = { 0, -1 };
    int maxIndex = data.length() - 1;

    for (int i = 0; i <= maxIndex && found <= index; i++) {
        if (data.charAt(i) == separator || i == maxIndex) {
            found++;
            strIndex[0] = strIndex[1] + 1;
            strIndex[1] = (i == maxIndex) ? i+1 : i;
        }
    }
    return found > index ? data.substring(strIndex[0], strIndex[1]) : "";
}
