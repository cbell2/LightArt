/**
 * MultipleColorTracking
 * Select 4 colors to track them separately
 *
 * It uses the OpenCV for Processing library by Greg Borenstein
 * https://github.com/atduskgreg/opencv-processing
 *
 * @author: Jordi Tost (@jorditost)
 * @url: https://github.com/jorditost/ImageFiltering/tree/master/MultipleColorTracking
 *
 * University of Applied Sciences Potsdam, 2014
 *
 *Modified: Josue Contreras (2019)
 *
 * Instructions:
 * Press one numerical key [1-4] and click on one color to track it
 */
 
import gab.opencv.*;
import processing.video.*;
import java.awt.Rectangle;

// Music Variables
int amt = 0;
int reset1 = -1;
int reset2 = -1;
int reset3 = -1;
int reset4 = -1;

// Location variables
int r1 = 0;
int r2 = 0;
int r3 = 0;
int r4 = 0;

Capture video;
OpenCV opencv;
PImage src;
ArrayList<Contour> contour1;
ArrayList<Contour> contour2;
ArrayList<Contour> contour3;
ArrayList<Contour> contour4;

// <1> Set the range of Hue values for our filter
//ArrayList<Integer> colors;
int maxColors = 4;
int[] hues;
int[] colors;
int rangeWidth = 10;

float xcoor;
float ycoor; 

PImage[] outputs;

int colorToChange = -1;

void setup() {
  
   String strAmt = str(0);
   String[] str = split(strAmt, ' ');
   saveStrings("/Users/chrisbell/Dropbox/Junior Year/D-Term/HU 3910/amt.txt", str);
  
  video = new Capture(this, 640, 480);
  opencv = new OpenCV(this, video.width, video.height);
  contour1 = new ArrayList<Contour>();
  contour2 = new ArrayList<Contour>();
  contour3 = new ArrayList<Contour>();
  contour4 = new ArrayList<Contour>();
  
  size(830, 480, P2D);
  
  // Array for detection colors
  colors = new int[maxColors];
  hues = new int[maxColors];
  
  outputs = new PImage[maxColors];
  
  video.start();
  
  // End Computer Vision
}

void draw() {
  
  background(150);
  
  if (video.available()) {
    video.read();
  }

  // <2> Load the new frame of our movie in to OpenCV
  opencv.loadImage(video);
  
  // Tell OpenCV to use color information
  opencv.useColor();
  src = opencv.getSnapshot();
  
  // <3> Tell OpenCV to work in HSV color space.
  opencv.useColor(HSB);
  
  detectColors();
  
  // Show images
  image(src, 0, 0);
  for (int i=0; i<outputs.length; i++) {
    if (outputs[i] != null) {
      image(outputs[i], width-src.width/4, i*src.height/4, src.width/4, src.height/4);
      
      noStroke();
      fill(colors[i]);
      rect(src.width, i*src.height/4, 30, src.height/4);
    }
  }
  
  // Print text if new color expected
  textSize(20);
  stroke(255);
  fill(255);
  
  if (colorToChange > -1) {
    text("click to change color " + colorToChange, 10, 25);
  } else {
    text("press key [1-4] to select color", 10, 25);
  }
  
  displayContoursBoundingBoxes();
  //println("x: " + xcoor + "y: " + ycoor);
}

//////////////////////
// Detect Functions
//////////////////////

void detectColors() {
    
  for (int i=0; i<hues.length; i++) {
    
    if (hues[i] <= 0) continue;
    
    opencv.loadImage(src);
    opencv.useColor(HSB);
    
    // <4> Copy the Hue channel of our image into 
    //     the gray channel, which we process.
    opencv.setGray(opencv.getH().clone());
    
    int hueToDetect = hues[i];
    //println("index " + i + " - hue to detect: " + hueToDetect);
    
    // <5> Filter the image based on the range of 
    //     hue values that match the object we want to track.
    opencv.inRange(hueToDetect-rangeWidth/2, hueToDetect+rangeWidth/2);
    
    //opencv.dilate();
    opencv.erode();
    
    // TO DO:
    // Add here some image filtering to detect blobs better
    
    // <6> Save the processed image for reference.
    outputs[i] = opencv.getSnapshot();
  }
  
  // <7> Find contours in our range image.
  //     Passing 'true' sorts them by descending area.
  if (outputs[0] != null) {
    opencv.loadImage(outputs[0]);
    contour1 = opencv.findContours(true,true);
  }
  if (outputs[1] != null) {
    opencv.loadImage(outputs[1]);
    contour2 = opencv.findContours(true,true);
  }
  
  if (outputs[2] != null) {
    opencv.loadImage(outputs[2]);
    contour3 = opencv.findContours(true,true);
  }
  
  if (outputs[3] != null) {
    opencv.loadImage(outputs[3]);
    contour4 = opencv.findContours(true,true);
  }
}

void displayContoursBoundingBoxes() {
  
  for (int i=0; i<contour1.size(); i++) {
    
    Contour contour = contour1.get(0);
    Rectangle r = contour.getBoundingBox();
    
    if (r.width < 20 || r.height < 20) {
      if (reset1 == 0) {
        amt--;
        String strAmt = str(amt);
        String[] str = split(strAmt, ' ');
        saveStrings("/Users/chrisbell/Dropbox/Junior Year/D-Term/HU 3910/amt.txt", str);
        reset1 = 1;
      }
      continue;
    }
    
    if (reset1 == 1 || reset1 == -1) {
        amt++;
        String strAmt = str(amt);
        String[] str = split(strAmt, ' ');
        saveStrings("/Users/chrisbell/Dropbox/Junior Year/D-Term/HU 3910/amt.txt", str);
        reset1 = 0;
    }
    r1 = r.x;
    noFill();
    stroke(255, 0, 0);
    strokeWeight(2);
    println("current " +str(i)+ ": " + r.x);
    rect(r.x, r.y, r.width, r.height);
    
    xcoor = r.x + r.width/2;
    ycoor = r.y+r.height/2;
    
      
    noStroke();
    fill(255,0,0);
    ellipse(xcoor, ycoor,30,30);
  }
  
    for (int i=0; i<contour2.size(); i++) {
    
    Contour contour = contour2.get(0);
    Rectangle r = contour.getBoundingBox();
    
    if (r.width < 20 || r.height < 20) {
      if (reset2 == 0) {
        amt--;
        String strAmt = str(amt);
        String[] str = split(strAmt, ' ');
        saveStrings("/Users/chrisbell/Dropbox/Junior Year/D-Term/HU 3910/amt.txt", str);
        reset2 = 1;
      }
      continue;
    }
    
     if (reset2 == 1 || reset2 == -1) {
        amt++;
        String strAmt = str(amt);
        String[] str = split(strAmt, ' ');
        saveStrings("/Users/chrisbell/Dropbox/Junior Year/D-Term/HU 3910/amt.txt", str);
        reset2 = 0;
    }
    r2 = r.x;
    noFill();
    stroke(255, 0, 0);
    strokeWeight(2);
    //println("current " +str(i)+ ": " + r.x);
    rect(r.x, r.y, r.width, r.height);
    
    xcoor = r.x + r.width/2;
    ycoor = r.y+r.height/2;
    
      
    noStroke();
    fill(255,0,0);
    ellipse(xcoor, ycoor,30,30);
  }
  
  for (int i=0; i<contour3.size(); i++) {
    
    Contour contour = contour3.get(0);
    Rectangle r = contour.getBoundingBox();
    
    if (r.width < 20 || r.height < 20) {
       if (reset3 == 0) {
        amt--;
        String strAmt = str(amt);
        String[] str = split(strAmt, ' ');
        saveStrings("/Users/chrisbell/Dropbox/Junior Year/D-Term/HU 3910/amt.txt", str);
        reset3 = 1;
      }
      continue;
    }
    
    if (reset3 == 1 || reset3 == -1) {
        amt++;
        String strAmt = str(amt);
        String[] str = split(strAmt, ' ');
        saveStrings("/Users/chrisbell/Dropbox/Junior Year/D-Term/HU 3910/amt.txt", str);
        reset3 = 0;
    }
    r3 = r.x;
    noFill();
    stroke(255, 0, 0);
    strokeWeight(2);
    //println("current " +str(i)+ ": " + r.x);
    rect(r.x, r.y, r.width, r.height);
    
    xcoor = r.x + r.width/2;
    ycoor = r.y+r.height/2;
    
      
    noStroke();
    fill(255,0,0);
    ellipse(xcoor, ycoor,30,30);
  }
  
  for (int i=0; i<contour4.size(); i++) {
    
    Contour contour = contour4.get(0);
    Rectangle r = contour.getBoundingBox();
    
    if (r.width < 20 || r.height < 20) {
      if (reset4 == 0) {
        amt--;
        String strAmt = str(amt);
        String[] str = split(strAmt, ' ');
        saveStrings("/Users/chrisbell/Dropbox/Junior Year/D-Term/HU 3910/amt.txt", str);
        reset4 = 1;
      }
      continue;
    }
    
     if (reset4 == 1 || reset4 == -1) {
        amt++;
        String strAmt = str(amt);
        String[] str = split(strAmt, ' ');
        saveStrings("/Users/chrisbell/Dropbox/Junior Year/D-Term/HU 3910/amt.txt", str);
        reset4 = 0;
    }
    r4 = r.x;
    println("R1: " + r1 + " R2: " + r2 + " R3: " + r3 + " R4: " + r4);
    
    noFill();
    stroke(255, 0, 0);
    strokeWeight(2);
    //println("current " +str(i)+ ": " + r.x);
    rect(r.x, r.y, r.width, r.height);
    
    xcoor = r.x + r.width/2;
    ycoor = r.y+r.height/2;
    
      
    noStroke();
    fill(255,0,0);
    ellipse(xcoor, ycoor,30,30);
  }
}

//////////////////////
// Keyboard / Mouse
//////////////////////

void mousePressed() {
    
  if (colorToChange > -1) {
    
    color c = get(mouseX, mouseY);
    println("r: " + red(c) + " g: " + green(c) + " b: " + blue(c));
   
    int hue = int(map(hue(c), 0, 255, 0, 180));
    
    colors[colorToChange-1] = c;
    hues[colorToChange-1] = hue;
    
    //println("color index " + (colorToChange-1) + ", value: " + hue);
  }
}

void keyPressed() {
  
  if (key == '1') {
    colorToChange = 1;
    //amt++;
    //String strAmt = str(amt);
    //String[] str = split(strAmt, ' ');
    //saveStrings("/Users/chrisbell/Dropbox/Junior Year/D-Term/HU 3910/amt.txt", str);
    
  } else if (key == '2') {
    colorToChange = 2;
    //amt++;
    //String strAmt = str(amt);
    //String[] str = split(strAmt, ' ');
    //saveStrings("/Users/chrisbell/Dropbox/Junior Year/D-Term/HU 3910/amt.txt", str);
    
  } else if (key == '3') {
    colorToChange = 3;
    //amt++;
    //String strAmt = str(amt);
    //String[] str = split(strAmt, ' ');
    //saveStrings("/Users/chrisbell/Dropbox/Junior Year/D-Term/HU 3910/amt.txt", str);
    
  } else if (key == '4') {
    colorToChange = 4;
    //amt++;
    //String strAmt = str(amt);
    //String[] str = split(strAmt, ' ');
    //saveStrings("/Users/chrisbell/Dropbox/Junior Year/D-Term/HU 3910/amt.txt", str);
  }
}

void keyReleased() {
  colorToChange = -1; 
}
