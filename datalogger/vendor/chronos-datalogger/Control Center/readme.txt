1. General notes

The eZ430-Chronos graphical user interface and serial port driver has been developed and 
tested under Ubuntu 8.10.

The eZ430-Chronos graphical user interface is based on TCL/Tk. 

If your Linux distribution does not already include TCL/Tk, you can 
install it with easily the apt-get command:
      
      sudo apt-get install tcl8.5
      sudo apt-get install tk8.5
      
In order to generate keyboard events and mouse clicks through the watch buttons, 
the tool xdotool is called from the script. Please install it with the apt-get command:

      sudo apt-get install xdotool
            

2. Operating instructions

  - Plug in the RF Access Point into a USB port

  - Check the /dev directory. A new entry should appear after some seconds ("/dev/ttyACM0")

  - If you see that the RF Access Point gets assigned to a different device 
    (e.g. ttyACM1), either remove the serial device that occupy this slot (e.g. a modem), 
    or change the script file variable "com".
    
  - Make sure that the script file is executable
  
      > chmod u+x ./eZ430-Chronos_CC_1_1.tcl 

  - Now start the script by simply executing it from a terminal window, e.g.
  
      > ./eZ430-Chronos_CC_1_1.tcl
      