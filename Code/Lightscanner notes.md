# Light scanner notes
Current Version: 0.72

## LCD Display
Requires a 128x64 monochrome display with an I2C interface. These are plentiful and inexpensive. Typically called 1.3" OLED LCD or similar.  Also available in 0.9" and 1.5" sizes.

### Changing graphics controller
Uses the graphics package u8g2 which supports both SH1106 and SSD1306 controller chips. To use either one, uncomment the appropriate line at approximately lines 14-15.
For SH1106
```
U8G2_SH1106_128X64_NONAME_F_HW_I2C u8g2(U8G2_R0, /* reset=*/ U8X8_PIN_NONE);
//U8G2_SSD1306_128X64_NONAME_F_HW_I2C u8g2(U8G2_R0, /* reset=*/ U8X8_PIN_NONE);
```

For SSD1306
```
//U8G2_SH1106_128X64_NONAME_F_HW_I2C u8g2(U8G2_R0, /* reset=*/ U8X8_PIN_NONE);
U8G2_SSD1306_128X64_NONAME_F_HW_I2C u8g2(U8G2_R0, /* reset=*/ U8X8_PIN_NONE);
```
Other graphics controllers are supported.  See the [u8g2 reference](https://github.com/olikraus/u8g2/wiki) for more details.

### Sensor data display
The display shows a bar for several sensor values. The max bar size is dictated by the following defines
```
// spectral display max values (emprically derived)
#define UVMAX 2400
#define IRMAX 20000
#define LUXMAX 20000
```
Adjust as needed.  Note that the max values from the sensors are dependent on gain multipliers and your light sources.  Decrease the values for raltively dim sources and increase for bright ones.  You may need to experiment to derive useful values.

### Display rotation
You can rotate the the display 180 degrees, mirror it or mirror and flip vertical.  See the monitor's r command.


## Sensors
Currently, only the AS7343 and AS7331 are supported.  I will add the AS7341 at some point.


## COM port monitor
By default, sensor readings will be sent continuously to the COM port every 2 seconds, typically via USB. The output will look something like this.
```
Visible     UV       IR
    4045    0.68     516
    4046    0.68     516
    4058    0.68     518
    4036    0.77     515
    4035    0.77     515
    4033    0.89     510
    4027    0.89     510
    4030    0.68     510
```

The actions of the light scanner can be controlled by the built in monitor code. It takes commands from the COM input. A "?" character will display a list of commands.
```
Usage:
    ?      print command list
    c      Clear all settings
    u[+-]  Toggle UV setting
    l[+-]  Toggle visible (LUX) light setting
    i[+-]  Toggle IR setting
    a      Set all settings
    t[+-]  Triggered mode on/off
    r[rmv] display rotation. no argument - restore to default rotation
           r - rotate 180, m - mirror, v - mirror and flip vertical
    v      display version number
```
The output (LCD and COM) will be adjusted based on selected settings.


## Trigger mode
In the monitor, trigger mode can be set by using the t+ command. In this mode, continuous reporting of the sensor data is turned off. To restore continuous reporting, turn Triggered Mode off (t-).

### Trigger inputs
Triggering done via the inputs pins on the PicoBooster SPI pins.
| Action | Pin# | SPI name | grblHAL output |
|--------|-------|-------|-------|
| Send Sample| 19 | RX | Aux 0 |
| Line | 18 | SCK | Aux 1 |
| Document | 17 | CS | Aux 2 |

When in triggered mode, the trigger information is sent to the COM port (USB connection).  The data sent is selected by the UV, visible (LUX) light and IR settings.  For example, if you want only the IR data to be sent, set the visible (LUX) and UV settings off.
```
t+
l-
u-
```

### GCode triggering
GCode files programs can be used to drive a motion platform which has the sensor module. The motion controller needs to have 3 digital outputs which the light scanner program uses to trigger sensor sampling and aid in formatting the output. In the GCode running the grblHAL based motion controller, you will use M64 and M65 codes to turn on or off the trigger pins. The trigger actions are as follows:

| MCode | Explanation | grblHAL behavior | Action |
|-----|-----|------|------|
| M64 P0 | reset sample pin | turn Aux 0 on | Send sample |
| M65 P0 | reset sample pin | turn Aux 0 off | nothing |
||||
| M64 P1 | set line pin | turn Aux 1 on | nothing |
| M65 P1 | reset line pin | turn Aux 1 off | Send newline (\n) |
||||
| M64 P2 | set document pin | turn Aux 2 on | Send document header |
| M65 P2 | reset document pin | turn Aux 2 off | Send document footer |

### Using screw terminals vs pin headers 
On the RP23U5XBB, there are 2 ways to the connect to the PicoBooster.
#### Using pin headers
The pin headers use normal signal logic - 0 is off, 1 is on.  Thus, you use M64 for on and M65 for off.  
#### Using screw terminals
You will need to set the relay voltage to 5V via a jumper.  Use the SIG screw terminal for the signal and a GND terminal (Axis B GND is convenient). The logic is inverted so in your GCode,
use M65 for on, M64 for off.  You will need to set the outputs to off (M65) at the start of your GCode program (in the prolog section).

### Constructing GCode files
GCode programs are simply text documents that the motion controller will run.

For each sample location, the GCode program needs to move the X/Y location of the sensor head via G0 or G1 command, issue a pause to allow the motion to settle down and send the sample trigger. Aux 0 is used to trigger a sample. 
```
G1 X<X_location>Y<Y_location> ; drive machine to sample location
G04 P1    ; pause 1 second*
M64 P0    ; trigger sample
G04 P0.4  ; pause 400 mS
M65 P0    ; turn off trigger
```

To support building spreadsheets, Aux 1 is used to indicate the start or end of a line of samples, cooresponding to a set of samples with the same X (or Y) coordinates. Take care to insert some pause time between an on and off action.
```
G1 X<nnn>Y<mmm>
G04 P1    ; pause for 1 second
M64 P0    ; trigger sample
G04 P0.4  ; pause 400 mS
M65 P0    ; turn off trigger
M65 P1    ; end of a line, turn line trigger off
G04 P0.4  ; pause 400 mS

; next row
M64 P1    ; start of a new line, turn trigger on
G1 X<sss>Y<ttt>
G04 P1    ; pause 1 second
M64 P0    ; trigger sample
G04 P0.4  ; pause 400 mS
M65 P0    ; turn off trigger
```

The third trigger is to support header and footer in the stream of data from the sensor head via Aux 2. At the start of a sampling session, raise Aux 2 (M64 P2) and some header text will be inserted in the sample stream. Lower it at the end of the session (M65 P2) and footer text will be inserted in the output stream.

Rotation of the Z axis can be inserted into your GCode where ever drive the machine to a smapling location.

For more information, take a look at this [example GCode program](https://github.com/phil-barrett/Light-Sensor-Project/blob/main/Examples/gcode_test.gcode).

### Compatible GCode Senders
Due to the nature of the how Grbl based motion controllers, the GCode Sender that feeds GCode to them needs to operate synchronously.  This means it needs to send each command when the previous one has completed.  It is common for GCode Senders to send many commands to the motion controller ahead of the actual motion.  This will disrupt timing of the trigger signals.  Currently we recommendusing ioSender from IO Engineering. [It is available from github](https://github.com/terjeio/ioSender/releases/tag/2.0.46).
