import serial
myPort = serial.Serial('com9', 9600)

def sendpacket():
    file = open("ptoacom.txt", "r")
    packet = file.readline()
    #This is how it should look like "150;005;110;000e"
    myPort.write(packet)
    print packet

if __name__ == '__main__':
    while(1):
        sendpacket()
