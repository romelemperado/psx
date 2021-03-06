#!/opt/local/bin/tclsh8.5

# *************************************************************************************************

#

#	Copyright (C) 2010 Texas Instruments Incorporated - http://www.ti.com/ 

#	 

#	 

#	  Redistribution and use in source and binary forms, with or without 

#	  modification, are permitted provided that the following conditions 

#	  are met:

#	

#	    Redistributions of source code must retain the above copyright 

#	    notice, this list of conditions and the following disclaimer.

#	 

#	    Redistributions in binary form must reproduce the above copyright

#	    notice, this list of conditions and the following disclaimer in the 

#	    documentation and/or other materials provided with the   

#	    distribution.

#	 

#	    Neither the name of Texas Instruments Incorporated nor the names of

#	    its contributors may be used to endorse or promote products derived

#	    from this software without specific prior written permission.

#	

#	  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 

#	  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT 

#	  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR

#	  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT 

#	  OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 

#	  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT 

#	  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,

#	  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY

#	  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT 

#	  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 

#	  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#

# *************************************************************************************************

# ez430-Chronos Datalogger Application TCL/Tk script

# *************************************************************************************************

# Rev 1.1  

# - extended 12H / 24H format switch function
# - added WBSL support

#

# Rev 1.0

# - initial version released to manufacturing

# *************************************************************************************************


set exit_prog 0


# load libraries -----------------------------------------------------

package require Tk

# Set COM port where RF Access Point is mounted
set com "/dev/tty.usbmodem001"

# Include BlueRobin BM-USBD1 driver
# Adds global variable "vcp"
source "eZ430-Chronos_driver.tcl"

# Open COM port
if { [BM_OpenCOM $com 115200 30 0 0] == 0 } {
  tk_dialog .dialog1 "Error" "Could not detect USB dongle. Press OK to close application." info 0 OK
  set com_available 0

  exit 0
} else  {
  set com_available 1
  # Reset hardware

  BM_Reset
  after 20
  # Flush channel
  for {set i 0} {$i < 10} {incr i} {  
    BM_GetStatus
    after 10
  }

}



# ----------------------------------------------------------------------------------------

# Global variables -----------------------------------------------------------------------



# Script revision number

set revision                1.1



# Ini file for variables

set ini_file                "ez430-chronos-DL.ini"   



# SimpliciTi variables

set simpliciti_on           0

set simpliciti_ap_started   0



# Initial settings for Sync

set sync_use_metric_units   1

set sync_time_is_am         1

set sync_time_hours_24      4

set sync_time_hours_12      4

set sync_time_minutes       30

set sync_time_seconds       0

set sync_date_year          2009

set sync_date_month         9

set sync_date_day           1

set sync_altitude_24        500

set sync_altitude_12        1640

set sync_temperature_24     22

set sync_temperature_12     72

set sync_file               "ez430_data.log"

set sync_data_log_mode      0

set sync_data_log_interval  0

set sync_data_log_bytes     0

set sync_data_log_mode_hr   1

set sync_data_log_mode_temp 0

set sync_data_log_mode_alt  0

set sync_data_log_mode_acc  0

set packets_max             [expr 8192/16]

set packets_expected        0

for { set i 0 } { $i < $packets_max } {incr i } {

  set packet($i) "m"

}


# WBSL global variables

set select_input_file       ""

set call_wbsl_timer         0

set call_wbsl_1             2
set call_wbsl_2             3
set wbsl_progress           0

set wbsl_on                 0
set wbsl_ap_started         0

set fsize                   0

set fp                      0

set rData                   [list]

set rData_index             0

set low_index               0

set list_count              0

set wbsl_opcode             0

set maxPayload              0

set ram_updater_downloaded  0

set wirelessUpdateStarted   0

set wbsl_timer_enabled      0

set wbsl_timer_counter      0

set wbsl_timer_flag         0

set wbsl_timer_timeout      0



# Function required by WBSL

proc ceil x  {expr {ceil($x)} }


# ----------------------------------------------------------------------------------------

# Function prototypes --------------------------------------------------------------------

proc get_wbsl_status {} {}

proc wbsl_set_timer { timeout } {}

proc wbsl_reset_timer {} {}



# ----------------------------------------------------------------------------------------

# Graphical user interface setup ---------------------------------------------------------



# Some custom styles for graphical elements

ttk::setTheme clam

ttk::style configure custom.TCheckbutton -font "Helvetica 10"

ttk::style configure custom.TLabelframe -font "Helvetica 12 bold"

ttk::style configure custom.TRadiobutton -font "Helvetica 9"



# Define basic window geometry

wm title . "Texas Instruments eZ430-Chronos Datalogger $revision"

wm geometry . 640x510

wm resizable . 0 0

wm iconname . "ttknote"

ttk::frame .f

pack .f -fill both -expand 1

set w .f



# Map keys to internal functions

bind . <Key-q> { exitpgm }



## Make the notebook and set up Ctrl+Tab traversal

ttk::notebook $w.note

pack $w.note -fill both -expand 1 -padx 2 -pady 3

ttk::notebook::enableTraversal $w.note





# ----------------------------------------------------------------------------------------

# Sync pane ------------------------------------------------------------------------------

ttk::frame $w.note.sync -style custom.TFrame 

$w.note add $w.note.sync -text "SimpliciTI\u2122 Datalogger" -underline 0 -padding 2 

grid columnconfigure $w.note.sync {0 1} -weight 1 -uniform 1



# Buttons

ttk::labelframe $w.note.sync.f0 -borderwidth 0

ttk::button $w.note.sync.f0.btn_start_ap -text "Start Access Point" -command { start_simpliciti_ap } -width 14

ttk::button $w.note.sync.f0.btn_get_watch_settings -text "Read Watch" -command { sync_read_watch }  -width 11

ttk::button $w.note.sync.f0.btn_get_time_and_date -text "Copy System Time" -command { sync_get_time_and_date }  -width 14

ttk::button $w.note.sync.f0.btn_set_watch -text "Set Watch" -command { sync_write_watch }  -width 8

ttk::button $w.note.sync.f0.btn_erase_mem -text "Erase Memory" -command { sync_erase }  -width 11

grid $w.note.sync.f0 -row 0 -column 0 -pady 5 -padx 8 -sticky ew -columnspan 2

pack $w.note.sync.f0.btn_start_ap -side left -fill x  -padx 8

pack $w.note.sync.f0.btn_erase_mem -side right -fill x  -padx 8

pack $w.note.sync.f0.btn_set_watch -side right -fill x  -padx 8

pack $w.note.sync.f0.btn_get_time_and_date -side right -fill x  -padx 8

pack $w.note.sync.f0.btn_get_watch_settings -side right -fill x  -padx 8



# Download data

ttk::labelframe $w.note.sync.fdl -borderwidth 0

ttk::button $w.note.sync.fdl.btn1 -text "Download" -command { sync_download } -width 16

ttk::label $w.note.sync.fdl.lbl -text "Save data to:" -anchor e -font "Helvetica 9"

entry $w.note.sync.fdl.entry -textvariable sync_file -width 30

ttk::button $w.note.sync.fdl.btn2 -text "Browse" -command "fileDialog $w $w.note.sync.fdl.entry save" -width 10

grid $w.note.sync.fdl -row 1 -column 0 -pady 5 -padx 8 -sticky ew -columnspan 2

pack $w.note.sync.fdl.btn1 -side left -fill x -padx 8

pack $w.note.sync.fdl.lbl -side left -fill x -padx 8

pack $w.note.sync.fdl.entry -side left -fill x -padx 8

pack $w.note.sync.fdl.btn2 -side left -fill x -padx 8



# Time

ttk::labelframe $w.note.sync.f1 -borderwidth 0

ttk::label $w.note.sync.f1.l1 -text "Time" -width 18 -font "Helvetica 10 bold"

spinbox $w.note.sync.f1.sb1 -textvariable sync_time_hours_24 -justify right -width 2 -from 0 -to 23 -command { update_time_24 }

spinbox $w.note.sync.f1.sb2 -textvariable sync_time_minutes -justify right -width 2 -from 0 -to 59 

spinbox $w.note.sync.f1.sb3 -textvariable sync_time_seconds -justify right -width 2 -from 0 -to 59 

grid $w.note.sync.f1 -row 2 -column 0 -columnspan 1 -pady 0 -padx 10 -sticky ew

pack $w.note.sync.f1.l1  -side left -fill x

pack $w.note.sync.f1.sb1 -side left -fill x -padx 5

pack $w.note.sync.f1.sb2 -side left -fill x -padx 5

pack $w.note.sync.f1.sb3 -side left -fill x -padx 5



# Time format AM/PM

ttk::labelframe $w.note.sync.ampm -borderwidth 0

ttk::radiobutton $w.note.sync.ampm.rb1 -text "AM" -variable sync_time_is_am -value 1 -style custom.TRadiobutton -state disabled -command { update_time_12 }

ttk::radiobutton $w.note.sync.ampm.rb2 -text "PM" -variable sync_time_is_am -value 0 -style custom.TRadiobutton -state disabled -command { update_time_12 }

grid $w.note.sync.ampm -row 2 -column 1 -columnspan 2 -pady 0 -padx 10 -sticky ew

pack $w.note.sync.ampm.rb1 -side left -fill x -padx 5

pack $w.note.sync.ampm.rb2 -side left -fill x -padx 5



# Date

ttk::labelframe $w.note.sync.f2 -borderwidth 0

ttk::label $w.note.sync.f2.l1 -text "Date (dd.mm.yyyy)" -width 18 -font "Helvetica 10 bold"

spinbox $w.note.sync.f2.sb1 -textvariable sync_date_day   -justify right -width 2 -from 1 -to 31

spinbox $w.note.sync.f2.sb2 -textvariable sync_date_month -justify right -width 2 -from 1 -to 12

spinbox $w.note.sync.f2.sb3 -textvariable sync_date_year  -justify right -width 4 -from 2009 -to 2099

grid $w.note.sync.f2 -row 3 -column 0 -columnspan 1 -pady 0 -padx 10 -sticky ew

pack $w.note.sync.f2.l1  -side left -fill x

pack $w.note.sync.f2.sb1 -side left -fill x -padx 5

pack $w.note.sync.f2.sb2 -side left -fill x -padx 5

pack $w.note.sync.f2.sb3 -side left -fill x -padx 5



# Time / Date format

ttk::labelframe $w.note.sync.f1r -borderwidth 0

ttk::radiobutton $w.note.sync.f1r.rb1 -text "Metric units" -variable sync_use_metric_units -value 1 -style custom.TRadiobutton -command { switch_to_metric_units }

ttk::radiobutton $w.note.sync.f1r.rb2 -text "Imperial units" -variable sync_use_metric_units -value 0 -style custom.TRadiobutton -command { switch_to_imperial_units }

grid $w.note.sync.f1r -row 3 -column 1 -columnspan 2 -pady 0 -padx 10 -sticky ew

pack $w.note.sync.f1r.rb1 -side left -fill x -padx 5

pack $w.note.sync.f1r.rb2 -side left -fill x -padx 5



# Temperature

ttk::labelframe $w.note.sync.f4 -borderwidth 0

ttk::label $w.note.sync.f4.l1 -text "Temperature (\u00B0C)" -width 18 -font "Helvetica 10 bold"

spinbox $w.note.sync.f4.sb1 -textvariable sync_temperature_24 -justify right -width 3 -from -10 -to 60 

grid $w.note.sync.f4 -row 5 -column 0 -columnspan 1 -pady 0 -padx 10 -sticky ew

pack $w.note.sync.f4.l1  -side left -fill x

pack $w.note.sync.f4.sb1 -side left -fill x -padx 5



# Altitude

ttk::labelframe $w.note.sync.f5 -borderwidth 0

ttk::label $w.note.sync.f5.l1 -text "Altitude (m)" -width 18 -font "Helvetica 10 bold"

spinbox $w.note.sync.f5.sb1 -textvariable sync_altitude_24 -justify right -width 4 -from -100 -to 4000 

grid $w.note.sync.f5 -row 6 -column 0 -columnspan 1 -pady 0 -padx 10 -sticky ew

pack $w.note.sync.f5.l1  -side left -fill x

pack $w.note.sync.f5.sb1 -side left -fill x -padx 5



# Data log mode

ttk::labelframe $w.note.sync.f6 -borderwidth 0

ttk::label $w.note.sync.f6.l1 -text "Data log mode" -width 20 -font "Helvetica 10 bold"

ttk::checkbutton $w.note.sync.f6.cb1 -text "Heartrate" -variable sync_data_log_mode_hr

ttk::checkbutton $w.note.sync.f6.cb2 -text "Temperature" -variable sync_data_log_mode_temp

ttk::checkbutton $w.note.sync.f6.cb3 -text "Altitude" -variable sync_data_log_mode_alt

grid $w.note.sync.f6 -row 7 -column 0 -columnspan 2 -pady 0 -padx 10 -sticky ew

pack $w.note.sync.f6.l1  -side left -fill x

pack $w.note.sync.f6.cb1 -side left -fill x -padx 5

pack $w.note.sync.f6.cb2 -side left -fill x -padx 5

pack $w.note.sync.f6.cb3 -side left -fill x -padx 5



# Data log interval

ttk::labelframe $w.note.sync.f7 -borderwidth 0

ttk::label $w.note.sync.f7.l1 -text "Data log interval (s)" -width 20 -font "Helvetica 10 bold"

spinbox $w.note.sync.f7.sb1 -textvariable sync_data_log_interval -justify right -width 2 -from 1 -to 60 

grid $w.note.sync.f7 -row 8 -column 0 -columnspan 1 -pady 0 -padx 10 -sticky ew

pack $w.note.sync.f7.l1  -side left -fill x

pack $w.note.sync.f7.sb1 -side left -fill x -padx 5



# Data log bytes

ttk::labelframe $w.note.sync.f8 -borderwidth 0

ttk::label $w.note.sync.f8.l1 -text "Bytes logged" -width 20 -font "Helvetica 10 bold"

entry $w.note.sync.f8.sb1 -textvariable sync_data_log_bytes -justify right -width 5 -state readonly

grid $w.note.sync.f8 -row 9 -column 0 -columnspan 1 -pady 0 -padx 10 -sticky ew

pack $w.note.sync.f8.l1  -side left -fill x

pack $w.note.sync.f8.sb1 -side left -fill x -padx 5



# Status

labelframe $w.note.sync.status -borderwidth 1 -background "Yellow"

ttk::label $w.note.sync.status.l1 -text "Status:" -font "Helvetica 10 bold" -background "Yellow"

ttk::label $w.note.sync.status.l2 -text "Access Point is off." -font "Helvetica 10" -background "Yellow"

grid $w.note.sync.status -row 10 -column 0 -pady 20 -padx 10 -sticky ew -columnspan 2

pack $w.note.sync.status.l1 -side left -fill x 

pack $w.note.sync.status.l2 -side left -fill x 





# ----------------------------------------------------------------------------------------

# Wireless Update pane -------------------------------------------------------------------

ttk::frame $w.note.wbsl -style custom.TFrame

$w.note add $w.note.wbsl -text "Wireless Update" -underline 0 -padding 2 

grid columnconfigure $w.note.wbsl {0 1} -weight 1 -uniform 1



ttk::label $w.note.wbsl.label0 -font "Helvetica 10 bold" -width 40 -wraplength 600 -justify center -text "Only use this update function with watch firmware that allows to invoke the Wireless Update on the watch again.\n\nOlder eZ430-Chronos kits require a manual software update of the watch and access point. See Chronoswiki."

grid $w.note.wbsl.label0 -row 0 -column 0 -sticky ew -columnspan 3 -pady 10 -padx 10



#ttk::labelframe $w.note.wbsl.lf -borderwidth 0 

ttk::label $w.note.wbsl.label1 -font "Helvetica 10" -text "Select the firmware file that you want to download to the watch:" 

ttk::entry $w.note.wbsl.entry0 -state readonly -textvariable select_input_file



grid $w.note.wbsl.label1 -row 1 -column 0 -sticky ew -columnspan 3 -pady 10 -padx 10

grid $w.note.wbsl.entry0 -row 2 -column 0 -sticky ew -columnspan 2 -padx 10



ttk::button $w.note.wbsl.btnBrowse -text "Browse..." -command { open_file } -width 16

grid $w.note.wbsl.btnBrowse -row 2 -column 2 -sticky ew -padx 10



ttk::button $w.note.wbsl.btnDwnld -text "Update Chronos Watch" -command { start_wbsl_ap } -width 16 -default "active"

grid $w.note.wbsl.btnDwnld -row 3 -column 0 -sticky ew -pady 20 -padx 8 -columnspan 3



# Progress bar

labelframe $w.note.wbsl.frame1p -borderwidth 0

ttk::label $w.note.wbsl.frame1p.lblProgress -text "Progress " -font "Helvetica 10 bold"

ttk::progressbar $w.note.wbsl.frame1p.progBar -orient horizontal -value 0 -variable wbsl_progress -mode determinate 

grid $w.note.wbsl.frame1p -row 4 -column 0 -sticky ew -pady 15 -padx 10 -columnspan 3

pack $w.note.wbsl.frame1p.lblProgress -side left 

pack $w.note.wbsl.frame1p.progBar -side left -fill x -expand 1 



#Dummy Labels to fill Space

ttk::label $w.note.wbsl.importantNote -width 80 -wraplength 640 -justify center -text "Important: If the wireless update fails during the firmware download to flash memory, the watch display will be blank and the watch will be in sleep mode. To restart the update, press the down button." -font "Helvetica 10 bold"

grid $w.note.wbsl.importantNote -row 5 -column 0 -sticky ew -columnspan 3 -pady 5 -padx 10



# Frame for status display

labelframe $w.note.wbsl.frame0b -borderwidth 1 -background "Yellow"

ttk::label $w.note.wbsl.frame0b.lblStatus -text "Status:" -font "Helvetica 10 bold" -background "Yellow"

ttk::label $w.note.wbsl.frame0b.lblStatusText -text "Access Point is off." -font "Helvetica 10" -background "Yellow"

grid $w.note.wbsl.frame0b -row 6 -column 0 -pady 48 -padx 10 -sticky ew -columnspan 3

pack $w.note.wbsl.frame0b.lblStatus -side left -fill x 

pack $w.note.wbsl.frame0b.lblStatusText -side left -fill x 



# ----------------------------------------------------------------------------------------

# About pane -----------------------------------------------------------------------------

ttk::frame $w.note.about -style custom.TFrame 

$w.note add $w.note.about -text "About" -underline 0 -padding 2

grid rowconfigure $w.note.about 1 -weight 1 -uniform 1 

grid columnconfigure $w.note.about {0 1} -weight 1 -uniform 1



# SimpliciTI box

ttk::labelframe $w.note.about.s -borderwidth 1 

ttk::label $w.note.about.s.txt1 -font "Helvetica 12 bold" -justify "left" -width 4  -anchor center -style custom.TLabel -text "SimpliciTI\u2122"

ttk::label $w.note.about.s.txt2 -font "Helvetica 10" -width 80 -wraplength 550 -justify left -anchor n -style custom.TLabel \

-text "SimpliciTI\u2122 is a simple low-power RF network protocol aimed at small RF networks.\

\n\nSuch networks typically contain battery operated devices which require long battery life, low data rate and low duty cycle and have a limited number of nodes talking directly to each other or through an access point or range extenders. Access point and range extenders are not required but provide extra functionality such as store and forward messages.\

\n\nWith SimpliciTI\u2122 the MCU resource requirements are minimal which results in low system cost."

ttk::label $w.note.about.s.txt3 -font "Helvetica 10 bold" -wraplength 550 -justify left -anchor n -style custom.TLabel -text "Learn more about SimpliciTI\u2122 at http://www.ti.com/simpliciti"

grid $w.note.about.s -row 0 -column 0 -sticky new -pady 0 -columnspan 2

pack $w.note.about.s.txt1 -side top -fill x -pady 5 -padx 2m

pack $w.note.about.s.txt2 -side top -fill x -pady 0 -padx 2m

pack $w.note.about.s.txt3 -side top -fill x -pady 5 -padx 2m



# BlueRobin box

ttk::labelframe $w.note.about.b -borderwidth 1 

ttk::label $w.note.about.b.txt1 -font "Helvetica 12 bold italic" -foreground "Dark Blue" -justify "left" -width 4  -anchor center -text "BlueRobin\u2122" -style custom.TLabel

ttk::label $w.note.about.b.txt2 -font "Helvetica 10" -width 80 -wraplength 550 -justify left -anchor n -style custom.TLabel \

-text "The BlueRobin\u2122 protocol provides low data rate transmission for wireless body area sensor networks and team monitoring systems. Ultra-low power consumption, high reliability and low hardware costs are key elements of BlueRobin\u2122.\

\n\nBlueRobin\u2122 is successfully used in personal and multi-user heart rate monitoring systems, sports watches, chest straps, foot pods, cycle computers and other fitness equipment."

ttk::label $w.note.about.b.txt3 -font "Helvetica 10 bold" -wraplength 550 -justify left -anchor n -style custom.TLabel -text "Learn more about BlueRobin\u2122 at http://www.bm-innovations.com"

grid $w.note.about.b -row 1 -column 0 -sticky new -pady 5 -columnspan 2

pack $w.note.about.b.txt1 -side top -fill x -pady 5 -padx 2m

pack $w.note.about.b.txt2 -side top -fill x -pady 0 -padx 2m

pack $w.note.about.b.txt3 -side top -fill x -pady 5 -padx 2m





# ----------------------------------------------------------------------------------------

# Help pane ------------------------------------------------------------------------------

ttk::frame $w.note.help -style custom.TFrame 

$w.note add $w.note.help -text "Help" -underline 0 -padding 2

grid rowconfigure $w.note.help 1 -weight 1 -uniform 1 

grid columnconfigure $w.note.help {0 1} -weight 1 -uniform 1

ttk::labelframe $w.note.help.frame -borderwidth 1

ttk::label $w.note.help.frame.head -font "Helvetica 12 bold" -justify "right" -width 4  -anchor center -style custom.TLabel -text "Help"

ttk::label $w.note.help.frame.txt1 -font "Helvetica 10" -width 80 -wraplength 500 -justify left -anchor n -style custom.TLabel \

-text "If you cannot communicate with the RF access point, please check the following points:\
\n\n1) Do you have another instance of the GUI open?\n\nIf so, please close it, since it may block the COM port.\

\n\n2) Is the RF Access Point mounted (will be done automatically by Linux)?\n\nIt must appear as '/dev/ttyACM0'. You might also want to run the 'lsusb' command. The RF Access Point should be listed as 'Bus xxx Device xxx: ID 0451:16a6 Texas Instruments, Inc.'. If not, disconnect the RF Access Point from the USB port and reconnect it."

pack $w.note.help.frame.head -side top -fill x -pady 10 -padx 5m

pack $w.note.help.frame.txt1 -side top -fill x -pady 10 -padx 5m

grid $w.note.help.frame -row 0 -column 0 -sticky ew -pady 0 -columnspan 2





# ----------------------------------------------------------------------------------------

# Generic SimpliciTI functions -----------------------------------------------------------



# Start RF access point

proc start_simpliciti_ap { } {

  global w

  global simpliciti_on com_available

  global simpliciti_ap_started



  # No com port?  

  if { $com_available == 0} { return }

  

  # SimpliciTI on?

  if { $simpliciti_on == 1 } { return } 

  

  updateStatusSYNC "Starting access point."

  after 500



  # Link with SimpliciTI transmitter

  catch { BM_SPL_Start } result

  if { $result == 0 } {

    updateStatusSYNC "Failed to start access point."

    return

  }

  after 500

    

  # Set on flag after some waiting time  

  set simpliciti_on 1

  # Cancel out first received data

  set simpliciti_ap_started 0

  

  # Reconfig buttons

  $w.note.sync.f0.btn_start_ap configure -text "Stop Access Point" -command { stop_simpliciti_ap }



  updateStatusSYNC "Access point started. Now start watch in sync mode."

}





# Stop RF access point

proc stop_simpliciti_ap {} {

  global w

  global simpliciti_on com_available

  global simpliciti_ap_started



  # AP off?

  if { $simpliciti_on == 0 } { return } 



  # Clear on flags  

  set simpliciti_on 0

  

  # Send sync exit command

  BM_SYNC_SendCommand 7

  after 750

  
  # Now stop SimpliciTI

  BM_SPL_Stop



  # Show that link is inactive

  updateStatusSYNC "Access point is off."



  # Clear values

  set simpliciti_ap_started 0

  update

  

  # Reconfig button

  $w.note.sync.f0.btn_start_ap configure -text "Start Access Point" -command { start_simpliciti_ap }

}




# ----------------------------------------------------------------------------------------

# SimpliciTI sync functions --------------------------------------------------------------



# Read watch settings

proc sync_read_watch {} {

  global w simpliciti_on

  global sync_use_metric_units sync_time_is_am sync_time_hours_24 sync_time_hours_12 sync_time_minutes sync_time_seconds

  global sync_date_year sync_date_month sync_date_day

  global sync_data_log_bytes sync_data_log_mode sync_data_log_interval

  global sync_data_log_mode_hr sync_data_log_mode_temp sync_data_log_mode_alt sync_data_log_mode_acc

  global sync_temperature_24 sync_altitude_24


  # AP not enabled?

  if { !$simpliciti_on } { return }

   

  # Dummy read to clean buffer

  catch { BM_SYNC_ReadBuffer } bin


  # Request watch data  

  BM_SYNC_SendCommand 2

  updateStatusSYNC "Requesting watch data."



  # Wait for buffer to be filled with RX packet - or timeout

  set repeat 10

  while { $repeat > 0 } {

    after 100

    set status [ BM_SYNC_GetBufferStatus ]

    if { $status == 1 } {

      updateStatusSYNC "Received watch status information."

      set repeat 0

      
      catch { BM_SYNC_ReadBuffer } data

      # Decode received data      

      # Received hours is always 24H format      
      set sync_use_metric_units   [format "%d" [expr ([lindex $data 1]>>7) & 0x01 ]]

      set sync_time_hours_24      [expr [lindex $data 1] & 0x7F]
      set sync_time_minutes       [format "%d" [lindex $data 2]]

      set sync_time_seconds       [format "%d" [lindex $data 3]]

      set sync_date_year          [format "%d" [expr ([lindex $data 4]<<8) + [lindex $data 5]]]

      set sync_date_month         [format "%d" [lindex $data 6]]

      set sync_date_day           [format "%d" [lindex $data 7]]

      set sync_alarm_hours        [format "%d" [lindex $data 8]]

      set sync_alarm_minutes      [format "%d" [lindex $data 9]]

      set sync_temperature_24     [format "%2.0f" [expr [format "%2.1f" [expr ([lindex $data 10]<<8) + [lindex $data 11]]] / 10]]

      set sync_altitude_24        [format "%d" [expr ([lindex $data 12]<<8) + [lindex $data 13]]]

      set sync_data_log_mode      [format "%d" [lindex $data 14]]

      set sync_data_log_interval  [format "%d" [lindex $data 15]]

      set sync_data_log_bytes     [format "%d" [expr ([lindex $data 16]<<8) + [lindex $data 17]]]

      

      # Decode data log mode bits

      if { [expr $sync_data_log_mode & 0x01] } { set sync_data_log_mode_hr 1 }

      if { [expr $sync_data_log_mode & 0x02] } { set sync_data_log_mode_temp 1 }

      if { [expr $sync_data_log_mode & 0x04] } { set sync_data_log_mode_alt 1 }

      

      # Calculate new 24H / 12H time

      update_time_24

      update_time_12

      

      # Reconfigure display

      if { $sync_use_metric_units == 1 } {

        switch_to_metric_units

      } else {

        switch_to_imperial_units

      }

      

      return

      

    } else {

        set repeat [expr $repeat-1]

    }

  }

  updateStatusSYNC "Error: Did not receive watch status information."

}





# Write watch settings

proc sync_write_watch {} {

  global w simpliciti_on

  global sync_use_metric_units sync_time_is_am sync_time_hours_24 sync_time_minutes sync_time_seconds

  global sync_date_year sync_date_month sync_date_day

  global sync_data_log_mode sync_data_log_interval

  global sync_data_log_mode_hr sync_data_log_mode_temp sync_data_log_mode_alt sync_data_log_mode_acc

  global sync_temperature_24 sync_altitude_24

  

  # AP not enabled?

  if { !$simpliciti_on } { return }



  # Assemble mode bits  

  set sync_data_log_mode [expr ($sync_data_log_mode_hr&0x01) | (($sync_data_log_mode_temp<<1)&0x02) | (($sync_data_log_mode_alt<<2)&0x04)]

  

  # Assemble command string

  lappend cmd 0x03

  lappend cmd [format "0x%02X" [expr $sync_time_hours_24 | (($sync_use_metric_units<<7)&0x80)]]

  lappend cmd [format "0x%02X" $sync_time_minutes] 

  lappend cmd [format "0x%02X" $sync_time_seconds] 

  lappend cmd [format "0x%02X" [expr $sync_date_year >> 8]] 

  lappend cmd [format "0x%02X" [expr $sync_date_year & 0xFF]] 

  lappend cmd [format "0x%02X" $sync_date_month] 

  lappend cmd [format "0x%02X" $sync_date_day] 

  lappend cmd "0x00 " 

  lappend cmd "0x00 "

  set t1 [format "%.0f" [expr $sync_temperature_24*10]]

  lappend cmd [format "0x%02X" [expr $t1 >> 8]]

  lappend cmd [format "0x%02X" [expr $t1 & 0xFF]] 

  lappend cmd [format "0x%02X" [expr $sync_altitude_24 >> 8]]

  lappend cmd [format "0x%02X" [expr $sync_altitude_24 & 0xFF]] 
  lappend cmd [format "0x%02X" $sync_data_log_mode] 
  lappend cmd [format "0x%02X" $sync_data_log_interval] 

  # Transfer command to RF access point
  BM_SYNC_SendCommand $cmd


  updateStatusSYNC "Sent data to watch."

}





# Update am/pm setting for a given 24H time

proc update_time_24 { hours } {

  global sync_use_metric_units sync_time_is_am sync_time_hours

  

  if { $hours >= 12 } { 

    set sync_time_is_am 0

  } else {

    set sync_time_is_am 1

  }

}





# Convert to 12H time format

proc convert_time_to_12 { hours } {

  global sync_use_metric_units sync_time_is_am sync_time_hours



  if { $hours == 0 } {

    set sync_time_is_am 1

    set sync_time_hours [expr $hours + 12]

  } elseif { $hours <= 12 } {

    set sync_time_is_am 1

    set sync_time_hours $hours

  } else {

    set sync_time_is_am 0

    set sync_time_hours [expr $hours - 12]

  }

}





# Convert global time to 24H time format

proc convert_time_to_24 {} {

  global sync_use_metric_units sync_time_is_am sync_time_hours



  if { $sync_use_metric_units == 1 } {

    set hours $sync_time_hours

  } else {

    if { $sync_time_is_am == 1 } {

      set hours $sync_time_hours

    } else {

      set hours [expr $sync_time_hours + 12]

    }

  }  

  

  return $hours

}

        



# Read system time and date

proc sync_get_time_and_date {} {

  global w 

  global sync_use_metric_units sync_time_is_am sync_time_hours_24 sync_time_minutes sync_time_seconds

  global sync_date_year sync_date_month sync_date_day

  

  # Get date  

  set sync_date_year    [format "%04.0f" [expr [clock format [clock seconds] -format "%Y"]]]

  set sync_date_month   [clock format [clock seconds] -format "%m"]

  if { [string first 0 $sync_date_month] == 0 } {

    set sync_date_month [string replace $sync_date_month 0 0]

  }

  set sync_date_day     [clock format [clock seconds] -format "%e"]

  

  # Get hours 

  set sync_time_hours_24 [clock format [clock seconds] -format "%H"]

  if { [string first 0 $sync_time_hours_24] == 0 } {

    set sync_time_hours_24 [string replace $sync_time_hours_24 0 0]

  }

  

  # Calculate hours in 12H time format

  update_time_24

  

  # Get minutes and seconds

  set sync_time_minutes  [clock format [clock seconds] -format "%M"]

  if { [string first 0 $sync_time_minutes] == 0 } {

    set sync_time_minutes [string replace $sync_time_minutes 0 0]

  }

  set sync_time_seconds  [clock format [clock seconds] -format "%S"]

  if { [string first 0 $sync_time_seconds] == 0 } {

    set sync_time_seconds [string replace $sync_time_seconds 0 0]

  }

  updateStatusSYNC "Copied system time and date to watch settings."

}







# Download packets, first in a burst, then missed packets packet-by-packet

proc sync_download {} {

  global w simpliciti_on

  global sync_data_log_bytes sync_file

  global packets_max packet packets_expected

  

  # AP not enabled?

  if { $simpliciti_on == 0 } { return }

  

  # No bytes to download?

  sync_read_watch 

  if { $sync_data_log_bytes == 0 } { return }



  updateStatusSYNC "Requesting watch data."

  

  # Dummy read to clean buffer

  catch { BM_SYNC_ReadBuffer } bin

  after 10

  

  # Calculate how many packets (1 packet = 16 bytes data) are available for download

  set packet_start      0

  set packet_end        [expr $sync_data_log_bytes / 16]

  set packets_expected  [expr $packet_end + 1]

  set packets_per_burst 50

  set packets_received  0

  

  # Prepare received packet buffer

  for { set i 0 } { $i < $packets_max } {incr i } {

    set packet($i) "m"

  }



  # Request packet bursts until all packets have been requested once

  for { set i 0 } { $i < $packets_expected } {set i [expr $i + $packets_per_burst]} {

    

    # Request burst 

    set start_hi [expr ($i >> 8) & 0xFF]

    set start_lo [expr $i & 0xFF]

    if { $packet_end > [expr $i + $packets_per_burst] } {

      set end_hi [expr (($i + $packets_per_burst - 1) >> 8) & 0xFF]

      set end_lo [expr ($i + $packets_per_burst - 1) & 0xFF]

    } else {

      # Last burst request

      set end_hi [expr ($packet_end >> 8) & 0xFF]

      set end_lo [expr $packet_end & 0xFF]

    }

    # Assemble command string
    lappend cmd 0x04

    lappend cmd [format "0x%02X" $start_hi] 
    lappend cmd [format "0x%02X" $start_lo] 
    lappend cmd [format "0x%02X" $end_hi] 
    lappend cmd [format "0x%02X" $end_lo] 


    # Transfer command to RF access point
    BM_SYNC_SendCommand $cmd 
   

    # Wait for buffer to be filled - or timeout

    set repeat 200

    while { $repeat > 0 } {

      set status [ BM_SYNC_GetBufferStatus ]

      if { $status == 1 } {

        catch { BM_SYNC_ReadBuffer } data

        #binary scan $bin H* hex

        # Store packet 

        set idx [format "%d" [expr ([lindex $data 1]<<8) + [lindex $data 2]]]
          #set idx [expr 0x[string range $hex 2 5]]

          if { $packet($idx) == "m" } { 

            #set packet($idx) $hex 
            set packet($idx) $data 

            incr packets_received

            updateStatusSYNC "Received [format %4d [expr $packets_received*16]] bytes."

          }

        set repeat 10

      } else {

          set repeat [expr $repeat-1]

          after 2

      }

    }

  }



  # Clear buffer

  catch { BM_SYNC_ReadBuffer } bin

  

  # While packets are missing, download them separately (up to 180 missed packets)

  set packets_missed_count 1

  set repeats 0  

  while { $packets_missed_count > 0 && $repeats < 20 } {

  

    incr repeats

    

    # Create list of missed packets

    catch { unset packets_missed }

    set packets_missed_count 0

    for { set i 0 } { $i < $packets_expected } {incr i } {

      if { $packet($i) == "m" } { 

        lappend packets_missed $i

        incr packets_missed_count

      }

    }

    

    # Packets missed?

    if { $packets_missed_count > 0 } {

      # Request 9 packets per command

      set packets_single [lrange $packets_missed 0 8]

      # Add dummy packets

      while { [llength $packets_single] < 9 } {

        lappend packets_single [lindex $packets_missed 0]

      }

      # Split packet indizes into high and low byte

      for { set i 0 } { $i < 9 } {incr i } {

        set ps_hi($i) [expr ([lindex $packets_single $i] >> 8) & 0xFF]        

        set ps_lo($i) [expr  [lindex $packets_single $i] & 0xFF]        

      }



      # Request packets

      updateStatusSYNC "Requesting missed packets $packets_single"

      
      # Assemble command string
      unset cmd
      lappend cmd "0x05"

      for { set i 0 } { $i < 9 } {incr i } {

        lappend cmd [format "0x%02X" $ps_hi($i)]

        lappend cmd [format "0x%02X" $ps_lo($i)]

      } 

      # Transfer command to RF access point
      BM_SYNC_SendCommand $cmd 

      
      # Wait for buffer to be filled - or timeout

      set repeat 100

      while { $repeat > 0 } {

        set status [ BM_SYNC_GetBufferStatus ]

        if { $status == 1 } {


          catch { BM_SYNC_ReadBuffer } data


          # Store packet 

          set idx [format "%d" [expr ([lindex $data 1]<<8) + [lindex $data 2]]]

          if { $packet($idx) == "m" } { 

            set packet($idx) $data    

            incr packets_received

            updateStatusSYNC "Received [format %4d [expr $packets_received*16]] bytes."

          }

          set repeat 20

        } else {

            set repeat [expr $repeat-1]

            after 2

        }

      }

    }

  }

  

  # Output received data  

  if { $packets_received >= $packets_expected } { 

    sync_decode_data 

  } else {

    updateStatusSYNC "Error: Did not receive all logged data."

  }

  

  # Dummy read to clean buffer

  catch { BM_SYNC_ReadBuffer } bin



}




# Decode datastream

proc sync_decode_data {} {

  global sync_file sync_data_log_mode 

  global packets_max packet packets_expected

  #global hex_arr

  global sync_use_metric_units

  

  updateStatusSYNC "Writing data to file."

  set wp [open $sync_file w]

  

  # Write raw data and create a hex array

  set decode 1

  set hex_arr_len 0

  set data_stream ""

  for { set i 0 } { $i < $packets_expected } {incr i } {


    # Uncomment next line to output raw data at start of file

    #puts $wp "$i $packet($i)"



    if { $packet($i) != "m" } { 


      # Split data line in separate bytes
      set data [ split $packet($i) " " ]

      # Append data bytes to raw data stream
      for { set j 3 } { $j <= 18 } { incr j } {
        lappend hex_arr [lindex $data $j]
      }

    } else {


      # Data missing?

      updateStatusSYNC "Error: Not all data has been received."

      return 

    }

  }

  # Append dummy byte to eof

  lappend hex_arr 0x00
  lappend hex_arr 0x00
  lappend hex_arr 0x00
  lappend hex_arr 0x00

  # Decode data (format is lo-hi) and write to file

  set session 0  

  for { set i 0 } { $i < [expr [llength $hex_arr] - 2] } {incr i } {

    

    # Scan for markers
    # Markers can appear only at 16-bit boundaries

    if { [lindex $hex_arr $i]==0 && [expr $i%2]==1 } {
      set next_word [expr ([lindex $hex_arr [expr $i+2]]<<8) | [lindex $hex_arr [expr $i+1]]]
    } else {
      set next_word [expr ([lindex $hex_arr [expr $i+1]]<<8) | [lindex $hex_arr $i]]
    }

    # Check for start marker

    if { $session == 0 } {


      if { $next_word == 0xFFFB } {


        set session 1

        # Decode header

        incr i

        incr i

        set rec_mode      [format "0x%02X" [lindex $hex_arr $i]]

        incr i

        set rec_interval  [format %02d [lindex $hex_arr $i]]

        incr i

        set rec_day       [format %02d [lindex $hex_arr $i]]

        incr i

        set rec_month     [format %02d [lindex $hex_arr $i]]

        incr i

        set rec_year      [expr ([lindex $hex_arr [expr $i+1]]<<8) | [lindex $hex_arr $i]]

        incr i

        incr i

        set rec_hour      [format %02d [lindex $hex_arr $i]]

        incr i

        set rec_minute    [format %02d [lindex $hex_arr $i]]

        incr i

        set rec_second    [format %02d [lindex $hex_arr $i]]

        set start_time [clock scan "$rec_year-$rec_month-$rec_day $rec_hour:$rec_minute:$rec_second" -format {%Y-%m-%d %H:%M:%S}]


      }

    } elseif { $next_word == 0xFFFE } {



      # End marker found

      set session 0

      

    } else {



      # Get the next data set bytes

      set byte0     [lindex $hex_arr $i]

      set byte1     [lindex $hex_arr [expr $i+1]]

      set byte2     [lindex $hex_arr [expr $i+2]]  

      set byte3     [lindex $hex_arr [expr $i+3]]

      set rec_hr    0 

      set rec_temp  0 

      set rec_alt   0 



      # Decode data

      switch $rec_mode {

        0x01 { # HR

            set rec_hr      [format %d $byte0]

          }

        0x02 { # TEMP

            set rec_temp    [format %2.1f [expr [format %2.1f [expr (($byte0<<8) | $byte1)]]/10]]

            # Move to next data set        

            set i [expr $i+2-1]

          }

        0x04 { # ALT

            set rec_alt     [format %d [expr ($byte0<<8) | $byte1]]

            # Move to next data set        

            set i [expr $i+2-1]

          }

        0x07 { # HR + TEMP + ALT

            set rec_hr      [format %d $byte0]

            set rec_temp    [format %2.1f [expr [format %2.1f [expr (($byte1<<4) | (($byte2>>4)&0x0F))]]/10]]

            set rec_alt     [format %d [expr (($byte2&0x0F)<<8) | $byte3]]

            # Move to next data set        

            set i [expr $i+4-1]

          }

        0x03 { # HR + TEMP

            set rec_hr      [format %d $byte0]

            set rec_temp    [format %2.1f [expr [format %2.1f [expr (($byte1<<8) | $byte2)]]/10]]

            # Move to next data set        

            set i [expr $i+3-1]

          }

        0x05 { # HR + ALT

            set rec_hr      [format %d $byte0]

            set rec_alt    [format %d [expr ($byte1<<8) | $byte2]]

            # Move to next data set        

            set i [expr $i+3-1]

          }

        0x06 { # TEMP + ALT

            set rec_temp    [format %2.1f [expr [format %2.1f [expr (($byte0<<4) | (($byte1>>4)&0x0F))]]/10]]

            set rec_alt     [format %d [expr (($byte1&0x0F)<<8) | $byte2]]

            # Move to next data set        

            set i [expr $i+3-1]

          }

        }

        

        # Convert metric temperature and altitude to Imperial units 

        if { $sync_use_metric_units == 0 } {

          set rec_temp [format %2.1f [expr ($rec_temp*9)/5+32]]

          set rec_alt  [format %.0f [expr $rec_alt*3.28084]]

        }



        # Write data set to file

        puts $wp "[clock format $start_time -format {%d.%m.%Y}],[clock format $start_time -format {%H:%M:%S}],$rec_hr,$rec_temp,$rec_alt"

      

        # Calculate time for next data sample

        set start_time  [expr $start_time + $rec_interval]

    }

  }

  close $wp

  

  after 500

  updateStatusSYNC "Data download finished."

}




# Erase memory on watch

proc sync_erase {} {

  global w simpliciti_on 

  global sync_data_log_bytes

  

  # AP not enabled?

  if { !$simpliciti_on } { return }


  # Transfer command to RF access point

  BM_SYNC_SendCommand 6

 

  updateStatusSYNC "Sent erase command to watch."

  after 1000

  

  updateStatusSYNC "Updating watch status."

  sync_read_watch 


  # Check if erase was successful

  if { $sync_data_log_bytes != 0 } {

    updateStatusSYNC "Error: Memory erase or status update failed. Please try again."

  }

}





# Change all affected parameters to metric units / 24H time format

proc switch_to_metric_units {} {

  global w

  global sync_time_is_am sync_time_hours

  global sync_date_year sync_date_month sync_date_day

  global sync_temperature_24 sync_altitude_24



  # Update 24H time

  update_time_12



  # Reconfigure hours

  $w.note.sync.f1.sb1 configure -textvariable sync_time_hours_24 -command { update_time_24 } -from 0 -to 23

  $w.note.sync.ampm.rb1 configure -state disabled

  $w.note.sync.ampm.rb2 configure -state disabled

  

  # Configure date fields

  $w.note.sync.f2.l1 configure -text "Date (dd.mm.yyyy)"     

  $w.note.sync.f2.sb1 configure -textvariable sync_date_day   -from 1 -to 31

  $w.note.sync.f2.sb2 configure -textvariable sync_date_month -from 1 -to 12

  

  # Change temperature

  $w.note.sync.f4.l1 configure -text "Temperature (\u00B0C)" 

  $w.note.sync.f4.sb1 configure -textvariable sync_temperature_24 -from -10 -to 60

   

  # Change altitude

  $w.note.sync.f5.l1 configure -text "Altitude (m)"

  $w.note.sync.f5.sb1 configure -textvariable sync_altitude_24 -from -100 -to 4000

}




# Change all affected parameters to imperial units / 12H time format

proc switch_to_imperial_units {} {

  global w 

  global sync_time_is_am sync_time_hours

  global sync_date_year sync_date_month sync_date_day

  global sync_temperature_12 sync_altitude_12

  

  # Update 12H time

  update_time_24

  

  # Reconfigure hours

  $w.note.sync.f1.sb1 configure -textvariable sync_time_hours_12 -command { update_time_12 } -from 1 -to 12

  $w.note.sync.ampm.rb1 configure -state normal

  $w.note.sync.ampm.rb2 configure -state normal

  

  # Change date

  $w.note.sync.f2.l1 configure -text "Date (mm.dd.yyyy)"     

  $w.note.sync.f2.sb1 configure -textvariable sync_date_month -from 1 -to 12

  $w.note.sync.f2.sb2 configure -textvariable sync_date_day   -from 1 -to 31

  

  # Change temperature

  $w.note.sync.f4.l1 configure -text "Temperature (\u00B0F)" 

  $w.note.sync.f4.sb1 configure -textvariable sync_temperature_12 -from 14 -to 140

    

  # Change altitude

  $w.note.sync.f5.l1 configure -text "Altitude (ft)"

  $w.note.sync.f5.sb1 configure -textvariable sync_altitude_12 -from -328 -to 9999

}





# Keep 24H and 12H time variable in sync

proc update_time_24 {} {

  global sync_use_metric_units sync_time_is_am sync_time_hours_24 sync_time_hours_12



  # Calculate 12H time  

  if { $sync_time_hours_24 == 0 } {

    set sync_time_hours_12 [expr $sync_time_hours_24 + 12]

    set sync_time_is_am 1

  } elseif { $sync_time_hours_24 <= 12 } {

    set sync_time_hours_12 $sync_time_hours_24

    set sync_time_is_am 1

  } else {

    set sync_time_hours_12 [expr $sync_time_hours_24 - 12]

    set sync_time_is_am 0 

  }

}





# Keep 24H and 12H time variable in sync

proc update_time_12 {} {

  global sync_use_metric_units sync_time_is_am sync_time_hours_24 sync_time_hours_12



  # Calculate 12H time 

  if { $sync_time_is_am == 1 } {

    if { $sync_time_hours_12 == 12 } { 

      set sync_time_hours_24 0 

    } else {

      set sync_time_hours_24 $sync_time_hours_12

    }

  } else {

    set sync_time_hours_24 [expr $sync_time_hours_12 + 12]

  }

}







# Trace altitude and temperature and update internal units

proc update_temperature args {

  global sync_use_metric_units sync_temperature_24 sync_temperature_12



  # Convert to internal format

  if { $sync_use_metric_units == 1 } {

    set sync_temperature_12 [format "%2.0f" [expr ($sync_temperature_24*9/5)+32]]

  } else {

    set sync_temperature_24 [format "%2.0f" [expr ($sync_temperature_12-32)/9*5]]

  }

}

proc update_altitude args {

  global sync_use_metric_units sync_altitude_24 sync_altitude_12



  # Convert to internal format

  if { $sync_use_metric_units == 1 } {

    set sync_altitude_12    [format "%4.0f" [expr $sync_altitude_24*3.28084]]

  } else {

    set sync_altitude_24    [format "%4.0f" [expr $sync_altitude_12/3.28084]]

  }

}

trace add variable sync_temperature_24 write update_temperature

trace add variable sync_temperature_12 write update_temperature

trace add variable sync_altitude_24 write update_altitude

trace add variable sync_altitude_12 write update_altitude

        

        

# ----------------------------------------------------------------------------------------

# WBSL Update functions ------------------------------------------------------------------



# Prompt the user to select a file

proc open_file {} {

	global select_input_file

	global w

	set types {

		{{CC430 Firmware} {.txt}					}

	}

	set select_input_file [tk_getOpenFile -title "Select File" -filetypes $types] 

	

}



# Safely execute WBSL service functions (non-overlapping)
proc call_wbsl_funcs {} {
  global call_wbsl_timer call_wbsl_1 call_wbsl_2

  if { $call_wbsl_timer == $call_wbsl_1 } { 
    get_wbsl_packet_status 
    set call_wbsl_1 [expr $call_wbsl_timer + 2]
  } 
  if { $call_wbsl_timer == $call_wbsl_2 } { 
    get_wbsl_status
    set call_wbsl_2 [expr $call_wbsl_timer + 3]
  } 

  incr call_wbsl_timer
}





# Start the Wireless update procedure, and put RF Access Point in RX mode

proc start_wbsl_ap {} {

  global w

  global simpliciti_on com_available

  global wbsl_on select_input_file

  global wbsl_ap_started

  global fsize

  global fp

  global rData

  global rData_index

  global low_index

  global list_count maxPayload 

  global ram_updater_downloaded

  global wirelessUpdateStarted



  # init needed variables

  set rData [list]

  set rData_index 0

  set low_index 0

  

  # No com port?  

  if { $com_available == 0} { return }

  

  # Testing REMOVE

  # set ram_updater_downloaded 1

  

  set ram_updater_file "ram_based_updater.txt"



  if { $ram_updater_downloaded == 0 } {

	  # Check that the user has selected a file    

	  if { [string length $select_input_file] == 0 } {

	  		tk_dialog .dialog1 "No file selected" {Please select a watch firmware file (*.txt) to download to the watch.} info 0 OK

	  		return

	  }

	  

	  # Check that the file selected by the user has the extension .txt 

	  if { [string first ".txt" $select_input_file] == -1 } {

	  	    tk_dialog .dialog1 "Invalid .txt File" {The file selected is not a .txt file.} info 0 OK

	  		return

	  }

  }



  # First off check that the file trying to be downloaded has the right format

  catch { file size $select_input_file } fsize

  

  # Check if the file exist

  if { [string first "no such file" $fsize] != -1 } {

  	tk_dialog .dialog1 "File doesnt exist" {The selected file doesnt exist, please verify the path.} info 0 OK

  	return

  }

  

  # Open the file for reading

  catch { open $select_input_file r } fp

  fconfigure $fp -translation binary



  # read the first character of the file, it should be an @ symbol

  set test_at [read $fp 1]



  if { $test_at != "@" } { 

    tk_dialog .dialog1 "Invalid .txt File" {The .txt file is NOT formatted correctly.} info 0 OK

    close $fp

    return

  }

  

  # read the complete file

  set rawdata [read $fp $fsize]

  close $fp

  # Remove spaces, tabs, endlines from the data

  regsub -all {[ \r\t\nq]*} $rawdata "" stripped_data

  set lines 0

  # Divide the file by the symbol @ so that in each list there is data to be written consecutively at the address indicated by the first 2 bytes

  set datainlist [split $stripped_data "@"]

  set list_count 0

  set byteCounter 0

  

  # For each line, convert the ASCII format in which is saved to Raw HEX format

  foreach lines $datainlist {

  	set lines [join $lines]

  	regsub -all {[ \r\t\nq]*} $lines "" line

  	if { [catch { binary format H* $line } line] } {

  	      tk_dialog .dialog1 "Invalid .txt File" {The .txt file is NOT formatted correctly.} info 0 OK

  	      return

      } 

      lappend rData $line

      incr list_count

   }

  

  # Check if the RAM_UPDATER is not yet on the watch so that we download this first

  if { $ram_updater_downloaded == 0 } {

  	  # init needed variables

      set rData [list]

      set rData_index 0

      set low_index 0

      

	  catch { file size $ram_updater_file} fsize

	  

	  # Check that the RAM Updater file is present on the GUI working directory

	  if { [string first "no such file" $fsize] != -1 } {

	    	tk_dialog .dialog1 "No Updater File" {The RAM Updater File is not present on the working directory. Filename should be:ram_based_updater.txt} info 0 OK

	     return

	  }

	  

	  catch { open $ram_updater_file r } fp

	  fconfigure $fp -translation binary

	  

	  set test_at [read $fp 1]

	 

	  if { $test_at != "@" } { 

	  	tk_dialog .dialog1 "Invalid .txt File" {The ram_based_updater.txt file is NOT formatted correctly.} info 0 OK

	  	close $fp

	  	return

	  }

	  

	  set rawdata [read $fp $fsize]

	  close $fp

	  # Remove spaces, tabs, endlines from the data

	  regsub -all {[ \r\t\nq]*} $rawdata "" stripped_data

	  

	  set datainlist [split $stripped_data "@"]

	  set list_count 0

	  set byteCounter 0

	  foreach lines $datainlist {

	  		set lines [join $lines]

	  		regsub -all {[ \r\t\nq]*} $lines "" line

	  		if { [catch { binary format H* $line } line] } {

	  	    	  tk_dialog .dialog1 "Invalid .txt File" {The ram_based_updater.txt file is NOT formatted correctly.} info 0 OK

	  	    	  return

	  	    } 

	  	    lappend rData $line

	  	    incr list_count

	  	}

  }

  # In AP mode?

  if { $simpliciti_on == 1 } { 

    stop_simpliciti_ap

    after 500

  } 

  

  updateStatusWBSL "Starting Wireless Update."

  after 200



  # Link with WBSL transmitter
  BM_WBSL_Start
  after 100

  
  set result [ BM_WBSL_GetMaxPayload ]
  after 10

  set result [ BM_WBSL_GetMaxPayload ]

  if { $result < 2 } {

    updateStatusWBSL "$result Failed to start Wireless Update."

    return

  }


  set maxPayload $result

  

  # Calculate the number of packets needed to be sent

  

  #initialize the number of packets

  set fsize 0

  

  # sum up all the bytes to be sent

  foreach block $rData {

  	set byteCounter [string length $block]

  	set dByte [expr {double($byteCounter)}]

  	set dMax [expr {double($maxPayload)} ]

  	set temp [ceil [expr  $dByte / $dMax]]

  	set fsize [expr $fsize + $temp]

  }

    

  # Set on WBSL flag   

  set wbsl_on 1


  # Cancel out first received data

  set wbsl_ap_started 0

  

  # Reconfig buttons

  $w.note.wbsl.btnDwnld configure -text "Cancel Update" -command { stop_wbsl_ap }

  

}



# Stop the wireless update procedure

proc stop_wbsl_ap {} {

  global w

  global simpliciti_on com_available wbsl_on

  global ram_updater_downloaded

  global wirelessUpdateStarted



  # AP off?

  if { $wbsl_on == 0 } { return }

  

  # Clear on flags  

  set wbsl_on 0
  set ram_updater_downloaded 0



  after 500

 

  BM_WBSL_Stop



  # Show that link is inactive

  updateStatusWBSL "Wireless Update is off."



  update

  

  # Initialize the variable that tell us when the update procedure has been initiated by the Watch

  set wirelessUpdateStarted 0

  # Reconfig button and re-enable it in case the update procedure was started and it was disabled during the procedure

  $w.note.wbsl.btnDwnld configure -text "Update Chronos Watch" -command { start_wbsl_ap } -state enabled

  

}



proc get_wbsl_packet_status {} {

  global w

  global wbsl_on 

  global wbsl_ap_started

  global fsize

  global fp

  global rData   

  global rData_index

  global low_index

  global list_count maxPayload

  global wbsl_opcode

  global ram_updater_downloaded
  global vcp_reply

  

  set status 0

  

  # return if WBSL is not active  

  if { $wbsl_on == 0 } { return }

 
  # Check packet status
  set status [ BM_WBSL_GetPacketStatus ]
 

  if { $status == 1 } {

    # WBSL_DISABLED Not started by watch

    return

  } elseif { $status == 2 } {

  	# WBSL Is processing a packet

        return	

  } elseif { $status == 4 } {

	# Send the size of the file

	set packets [expr {int($fsize)} ]

	# send opcode 0 which is a info packet, which contains the total packets to be sent

	catch { BM_WBSL_SendData 0 $packets } status 

    # The next packet will contain an address

	set wbsl_opcode 1

  } elseif { $status == 8 } {

	# Send the next data packet

		

	if { $rData_index <  $list_count } {

		# Choose the appropriate block of data

		set data_block [lindex $rData $rData_index]

		# Get the size of the block of data, to know if we have sent all of the data in this block and move to the next

		set block_size [string length $data_block]

		# Read MaxPayload Bytes from the list

		set c_data [string range $data_block $low_index [expr $low_index + [expr $maxPayload - 1]]]

		

		# Send the read bytes to the dongle

		set status [BM_WBSL_SendData $wbsl_opcode $c_data] 
		

		#update the low index

		set low_index [expr $low_index + $maxPayload]

		

		# Next packet is a normal data packet

		set wbsl_opcode 2

		

		if { $low_index >= $block_size } { 

			incr rData_index

			set 	low_index 0

			# Next packet will include an address at the beginning of the packet

			set wbsl_opcode 1

		}

	 }

  } else {

  	# ERROR only the previous options should be returned

    if { $ram_updater_downloaded == 0 } {

  		tk_dialog .dialog1 "Error in communication" {There was an error in the communication between the RF Access Point and the watch during the download to RAM. The watch should have reset itself. Please retry the update the same way as before.} info 0 OK

    } else {

      tk_dialog .dialog1 "Error in communication" {There was an error in the communication between the RF Access Point and the watch during the download to Flash. The watch is in a sleep mode now. Please press the "Update Chronos Watch" first and then press the down button on the watch to restart the update.} info 0 OK

    }

  	after 200

  	stop_wbsl_ap 

  	return

  }
}



# Get the global status of the AP, check if the state in which the GUI is, matches the state of the AP

proc get_wbsl_status {} {

  global w vcp

  global wbsl_on

  global wbsl_ap_started wbsl_progress

  global ram_updater_downloaded

  global wirelessUpdateStarted

  global wbsl_timer_flag
  global vcp_reply fh

  

  set status 0

  

  # return if WBSL is not active  

  if { $wbsl_on == 0 } { return }


  # Check if the flag has been set, which means the communication was lost while trying to link to download the update image

 if { $wbsl_timer_flag == 1 } {

	     tk_dialog .dialog1 "Error in communication" {There was an error in the communication between the AP and the Watch while trying to start the download to Flash. The watch should have reset itself. Please retry the update the same way as before.} info 0 OK

	     wbsl_reset_timer	     

	     after 300

	     stop_wbsl_ap

	     return

    }



  # Update status box  
  set status [ BM_GetStatus1 ]

  if { $status == 9 } {

    # just starting AP

    updateStatusWBSL "Starting access point."
    return

  # Check if there was an error during the communication between the AP and the watch

  } elseif { $status == 11 || $status == 12 } {

  	

  	if { $ram_updater_downloaded == 0 } {

  		tk_dialog .dialog1 "Error in communication" {There was an error in the communication between the RF Access Point and the watch during the download to RAM. The watch should have reset itself. Please retry the update the same way as before.} info 0 OK

    } else {

        tk_dialog .dialog1 "Error in communication" {There was an error in the communication between the RF Access Point and the watch during the download to Flash. The watch is in sleep mode now. Please press the "Update Chronos Watch" first and then press the down button on the watch to restart the update.} info 0 OK

    }

	after 300

	stop_wbsl_ap 

	

  } elseif { $status == 10 } {

    

    # Read WBSL data from dongle

    set data [ BM_WBSL_GetStatus ]
   # if { $data == "" }  { return }

    

    if { $wbsl_ap_started == 0} {

    	if { $ram_updater_downloaded == 0 } {

      updateStatusWBSL "Access point started. Now start watch in rFbSL mode."
after 2000

     } else {

     	updateStatusWBSL "Starting to download update image to watch."

     	# We will now try to link with the watch to start downloading the Update Image, we need a timer in case the communication is lost

     	# while trying to link, since for the linking to start, the Dongle normally waits until the watch initiates the procedure.

     	wbsl_set_timer 1

     	update

     }

      set wbsl_ap_started 1
      return

    } else {

   

      # Check if data is valid

      if { $data < 0 } {
        return

      } 

     

     set wbsl_progress $data

     

     if { $wbsl_progress != 0 } {

     	   

     	   if { $wirelessUpdateStarted == 0 } {

     	   	

     	   	  set wirelessUpdateStarted 1

     	      # Reconfig buttons

  		    $w.note.wbsl.btnDwnld configure -state disabled

  	     }

     	   

	     if { $ram_updater_downloaded == 1 } {

	     	 # The download to FLASH has started, we don't need the timer to keep running

	     	 wbsl_reset_timer

	     	 update

	    	  updateStatusWBSL "Downloading update image to watch. Progress: [format %d $wbsl_progress]%"	

           

		    if { $wbsl_progress >= 100 } { 

		  	    updateStatusWBSL "Image has been successfully downloaded to the watch"	

		  	    after 1500

		  	    stop_wbsl_ap

		  	   }

		  	

	     } else {

	     	 updateStatusWBSL "Downloading the RAM Based Updater. Progress: [format %d $wbsl_progress]%"	


#puts $fh "\nDownloading the RAM Based Updater.\n"


	     	  if { $wbsl_progress >= 100 } { 

		  	    updateStatusWBSL "RAM Based Updater downloaded. Starting download of update image."	

		  	    set ram_updater_downloaded 1

		  	    BM_WBSL_Stop

		  	    set wbsl_on 0

		  	    start_wbsl_ap

		  	   }

	     }

     }
      return

      }

   } 

}



# Stop and reset the timer variables

proc wbsl_reset_timer { } {

 	global wbsl_timer_enabled

 	global wbsl_timer_counter

 	global wbsl_timer_flag

 	global wbsl_timer_timeout

 	

 	set  wbsl_timer_counter  0

 	set  wbsl_timer_flag     0

 	set  wbsl_timer_timeout  0

 	set  wbsl_timer_enabled  0

 }



# Set the timeout variable and start the timer

proc wbsl_set_timer { timeout } {

 	global wbsl_timer_enabled

 	global wbsl_timer_counter

 	global wbsl_timer_flag

 	global wbsl_timer_timeout

 	

 	set  wbsl_timer_counter  0

 	set  wbsl_timer_flag     0

 	set  wbsl_timer_timeout  $timeout

 	set  wbsl_timer_enabled  1

 }



# Called every 2.5 seconds, acts as the timer, it only counts if it's enabled

proc wbsl_simple_timer {} {

 	global wbsl_timer_enabled

 	global wbsl_timer_counter

 	global wbsl_timer_flag

 	global wbsl_timer_timeout

 	

 	if { $wbsl_timer_enabled == 0 } { 

 	   return	

 	}

    	set wbsl_timer_counter [expr $wbsl_timer_counter+1]

    	if { $wbsl_timer_counter > $wbsl_timer_timeout } {

    	    	set wbsl_timer_flag 1

          set wbsl_timer_enabled 0

    }

    

}





# --------------------------------------------------------------------------

# System procedures 



# Generic file browse dialog

proc fileDialog {w ent operation} {

	global selected_type

  

  # Define default file types

  set types {

  	{"eZ430-Chronos datalogger files"		{.log}	}

  	{"All files"		*}

  }



  # Use standard Windows file dialog 

  if {$operation == "open"} {

  	if {![info exists selected_type]} {

  	    set selected_type "eZ430-Chronos datalogger files"

  	}

    set file [tk_getOpenFile -filetypes $types -parent $w -typevariable selected_type]

  } else {

	 set file [tk_getSaveFile -filetypes $types -parent $w -initialfile Untitled -defaultextension .log]

  }

  

  # Copy selected file to entry

  if {[string compare $file ""]} {

  	$ent delete 0 end

  	$ent insert 0 $file

  	$ent xview end

  }

}







# Read variables from file 

proc load_ini_file {} {

  global w

  global ini_file

  global sync_use_metric_units

  

  # Try to open file with key definitions

  catch { set fhandle [open "$ini_file" r] } res

  

  # Exit if file is missing

  if { [string first "couldn't open" $res] == 0 } { return }

  

  fconfigure $fhandle -buffering line



  # Read file line by line and set global variables

  while { ![eof $fhandle] } {

    # Get next line

    gets $fhandle line

    # Split line

    set data [ split $line "=" ]

    # Verify that extracted strings consist of ASCII characters

    if { [string is ascii [ lindex $data 0 ]] && [string is ascii [ lindex $data 1 ]] } {

      # Set variable

      set [ lindex $data 0 ] [ lindex $data 1 ]

    }

  }

  

  close $fhandle  

}





# Save variables to file 

proc save_ini_file { } {

  global w

  global ini_file

  global sync_use_metric_units

  

  # Delete existing key file  

  catch { file delete "$ini_file" }

  

  # Break if directory is write only

  catch { set fhandle [open "$ini_file" a] } res

  if { [string first "permission denied" $res] == 0 } {

    return

  }

  

  fconfigure $fhandle -buffering line

  

  # Make a list of all variables to save

  set varlist { sync_use_metric_units }

                

  # Walk through list and save variables to file

  foreach { el } $varlist {

    set val [expr $$el]

    puts $fhandle "$el=$val"

  }  



  close $fhandle  

}





# ----------------------------------------------------------------------------------------

# Status output functions ----------------------------------------------------------------



# Status output

proc updateStatusSYNC { msg } {

  global w

  $w.note.sync.status.l2 configure -text $msg

  update

}
proc updateStatusWBSL { msg } {

  global w

  $w.note.wbsl.frame0b.lblStatusText configure -text $msg

  update

}





# ----------------------------------------------------------------------------------------

# Start / stop application ---------------------------------------------------------------



# Exit program

proc exitpgm {} {

  catch { stop_simpliciti_ap }

  catch { BM_CloseCOM }

  save_ini_file

  exit 0

}



# Load variables from ini file

load_ini_file

# Reconfigure display

if { $sync_use_metric_units == 1 } {

  switch_to_metric_units

} else {

  switch_to_imperial_units

}



# Exit program

if { $exit_prog == 1 } { exitpgm }




# ----------------------------------------------------------------------------------------

# Periodic functions  --------------------------------------------------------------------


proc every {ms body} {eval $body; after $ms [info level 0]}

every 10   { call_wbsl_funcs }

every 2500 { wbsl_simple_timer }


