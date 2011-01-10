import serial
import array
import csv
from time import sleep

#Open a CSV file for writing
accelcsvfile = csv.writer(open('dlog.csv', 'w'))

def startAccessPoint():
	
	return array.array('B', [0xFF, 0x07, 0x03]).tostring()

def HW_reset(self):
    #Reset Hardware
	self.send_command("\xFF\x01\x03")
	
def HW_get_status(self):
	self.send_command("\xFF\x00\x04\x00")
    Data = self.read_data()
    if(len(Data)==4):
      """
      0 = Idle
      1 = AP Stopped
      2 = AP Attempting Link
      3 = AP Linked
      4 = BR Stopped
      5 = BR Transmitting
      """
      return ord(Data[3])
    else:
      return 0
	
	
	
	
# Open COM port	
ser = serial.Serial("/dev/ttyACM0",115200,timeout=1)

# Reset hardware
HW_reset(self)

sleep(2)

# Reset hardware
HW_get_status(self)


# Link with SimpliciTI transmitter
startAccessPoint()

sleep(1)





ser.close()
