// Example by Tom Igoe
// Modified for http://www.DFRobot.com by Lumi, Jan. 2014

/*
   This code should show one colored blob for each detected IR source (max four) at the relative position to the camera.
*/

import processing.serial.*;

int lf = 10;    // Linefeed in ASCII
String myString = null;
Serial myPort;  // The serial port
boolean ledState=false; //LED is off

void setup() {
  // List all the available serial ports
  println(Serial.list());
  // Open the port you are using at the rate you want:
  myPort = new Serial(this, Serial.list()[3], 19200);
  myPort.clear();
  // Throw out the first reading, in case we started reading 
  // in the middle of a string from the sender.
  myString = myPort.readStringUntil(lf);
  myString = null;
  size(800,800);
  //frameRate(30);
}

void draw() {
  background(77);
  //while (myPort.available() > 0) {
    myString = myPort.readStringUntil(lf);
    if (myString != null) {
      int[] output = int (split(myString, ','));

      println(myString); // display the incoming string
         
      int xx = output[0];
      int yy = output[1];
      
      int ww = output[2];
      int zz = output[3];
      
      int xxx = output[4];
      int yyy = output[5];
      
      int www = output[6];
      int zzz = output[7];

      ellipseMode(RADIUS);  // Set ellipseMode to RADIUS
      fill(255, 0, 0);  // Set fill to white
      ellipse(xx, yy, 20, 20);
      ellipseMode(RADIUS);  // Set ellipseMode to RADIUS
      fill(0, 255, 0);  // Set fill to white
      ellipse(ww, zz, 20, 20);
      
      ellipseMode(RADIUS);  // Set ellipseMode to RADIUS
      fill(0, 0, 255);  // Set fill to white
      ellipse(xxx, yyy, 20, 20);
      ellipseMode(RADIUS);  // Set ellipseMode to RADIUS
      fill(255);  // Set fill to white
      ellipse(www, zzz, 20, 20);
      
       //Toggle led ON and OFF
       ledState=!ledState;
      
       //If ledState is True - then send a value=1 (ON) to Arduino
       if(xx < 800){
         //background(0,255,0); //Change the background to green
 
         /*When the background is green, transmit
         a value=1 to the Arduino to turn ON LED */
         //myPort.write('1');
         myPort.write(Integer.toString(xx));
         println(Integer.toString(xx));
       }else{
         //background(255,0,0); //Change background to red
         //myPort.write('0'); //Send "0" to turn OFF LED.
         myPort.write(Integer.toString(xx));
       }

    }
}
