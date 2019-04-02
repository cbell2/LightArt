#ifndef IRTRACKINGCAMERA_h
#define IRTRACKINGCAMERA_h

#include "Arduino.h"

/***************************************************************************************************
 * Wii Remote IR sensor  test sample code  by kako http://www.kako.com                             *
 * modified output for Wii-BlobTrack program by RobotFreak http://www.letsmakerobots.com/user/1433 *
 * modified for http://DFRobot.com by Lumi, Jan. 2014                                              *
 * modified for Light Art Project by Josue Contreras, April 2019                                       *
 ***************************************************************************************************/


/*******************************************************
 * IRTrackingCamera class to control IR tacking camera *
 *******************************************************/


class IRTrackingCamera{
public:
  IRTrackingCamera();
  void initialize();
  void Write_2bytes(byte,byte);
  void useSensor();
  void showAll();
  bool isPerson();
  int getz();
  int getx();

private:
  int IRsensorAddress = 0xB0;
  int slaveAddress;
  int ledPin = 13;
  boolean ledState = false;
  byte data_buf[16];
  int i;
  int Ix[4];
  int Iy[4];
  int s;
  bool seen;
};

#endif
