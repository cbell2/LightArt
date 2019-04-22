import serial
import time
myPort = serial.Serial('com11', 9600)

def sendpacket():
    file = open("/Users/JosuD/Documents/Light Art/code_lightart/ComputerVisionMultiObj/LEDLocation.txt", "r")
    packet = file.readline()
    #This is how it should look like "150;005;110;000e"
    #packet = "150;005;110;000e"
    myPort.write(packet)
    print packet

if __name__ == '__main__':
    while(1):
        sendpacket()
        time.sleep(0.2)
