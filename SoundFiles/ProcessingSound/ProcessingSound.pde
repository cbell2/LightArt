import processing.serial.*;

// Note: this program runs only in the Processing IDE, not in the browser

import ddf.minim.*;

Minim minim;
AudioSample sound1;
AudioSample sound2;
AudioSample bass;
AudioSample drums;

int amt = 0;
int prev = 0;
int numDrum;
int numBass;
int numS1;
int numS2;

String dStr;
String bStr;
String s1Str;
String s2Str;

//Serial com
Serial myPort;
String numObject = "";

void setup() {
  size(400, 300);
  fill(255, 0, 0);
  //noStroke();
  //smooth();
  
  numDrum = int(random(1,11));
  numBass = int(random(1,11));
  numS1 = int(random(1,16));
  numS2 = int(random(1,16));
  
  if (numS2 == numS1) {
     while (numS2 == numS1) {
         numS2 = int(random(1,16));
     }
  }
  
  dStr = "drum" + numDrum + ".mp3";
  bStr = "bass" + numBass + ".mp3";
  s1Str = "sound" + numS1 + ".mp3";
  s2Str = "sound" + numS2 + ".mp3";
  
  println(dStr);
  println(bStr);
  println(s1Str);
  println(s2Str);

  minim = new Minim(this);
  sound1 = minim.loadSample(s1Str, 2048);
  sound2 = minim.loadSample(s2Str, 2048);
  bass = minim.loadSample(bStr, 2048);
  drums = minim.loadSample(dStr, 2048);
  
  //Serial comm setup
  //myPort = new Serial(this, "COM5", 9600);
  //myPort.bufferUntil('\n');
}

void serialEvent(Serial myPort){
  numObject = myPort.readStringUntil('\n');
  numObject = trim(numObject);
  try{
    amt = Integer.parseInt(numObject);
  } catch(RuntimeException e){
    e.printStackTrace();
  }
}

void draw() {
  
  rect(0, 0, 200, 300);
  fill(244, 65, 65);
  rect(200, 0, 200, 300);
  fill(66, 244, 107);
 
 
 //println("Amount: " + amt + " Previous: " + prev);  
  if (amt < prev) {
    println("ENTERED");
    if ((4 > amt) && (4 <= prev)) {
      numS2 = int(random(1,16));
        if (numS2 == numS1) {
           while (numS2 == numS1) {
           numS2 = int(random(1,16));
           }
       }
      s2Str = "sound" + numS2 + ".mp3";
      sound2 = minim.loadSample(s2Str, 2048);
      println(s2Str);
    }
    if ((3 > amt) && (3 <= prev)) {
      numS1 = int(random(1,16));
      s1Str = "sound" + numS1 + ".mp3";
      sound1 = minim.loadSample(s1Str, 2048);
      println(s1Str);
    }
    if ((2 > amt) && (2 <= prev)) {
      numBass = int(random(1,11));
      bStr = "bass" + numBass + ".mp3";
      bass = minim.loadSample(bStr, 2048);
      println(bStr);
    }
    if ((1 > amt) && (1 <= prev)) {
      numDrum = int(random(1,11));
      dStr = "drum" + numDrum + ".mp3";
      drums = minim.loadSample(dStr, 2048);
      println(dStr);
    }
     prev = amt; 
    }
  
  else if(amt < 0){
    println("CLICK OUT OF RANGE");
    amt = 0;
  }else if(amt >= 5){
    println("CLICK OUT OF RANGE");
    amt = 4;
  }
  else {
  
  if (amt == 4) {
    sound2.trigger();
  }
  if (amt >= 3) {
    sound1.trigger();
  }
  if (amt >= 2) {
    bass.trigger();
  }
  if (amt >= 1) {
    drums.trigger();
  }
  
  if (amt > 0) {
    delay(4375);
    prev = amt;
  }
    
  }
}

void stop() {
  sound1.close();
  sound2.close();
  bass.close();
  drums.close();
  minim.stop();
  super.stop();
}

void mouseClicked() {
  
  if (mouseX < 201) {
    amt++;
  }
  else {
    amt--;
  }

  println(amt + " parts playing");
}
  
