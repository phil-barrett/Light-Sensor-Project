# Light scanner notes
Current Version: 0.7

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
    r[rmv] r - rotate 180, m - mirror, v - mirror and flip vertical
           no argument - restore to default rotation
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
In the GCode running the grblHAL based motion controller, you will use M62 and M63 codes to turn on or off the trigger pins. The trigger actions are as follows:

| MCode | Explanation | grblHAL behavior | Action |
|-----|-----|------|------|
| M62 P0 | reset sample pin | turn Aux 0 on | Send sample |
| M63 P0 | reset sample pin | turn Aux 0 off | nothing |
||||
| M62 P1 | set line pin | turn Aux 1 on | nothing |
| M63 P1 | reset line pin | turn Aux 1 off | Send newline (\n) |
||||
| M62 P2 | set document pin | turn Aux 2 on | Send document header |
| M63 P2 | reset document pin | turn Aux 2 off | Send document footer |

### Using screw terminals vs pin headers 
On the RP23U5XBB, there are 2 ways to the connect to the PicoBooster.
#### Using pin headers
The pin headers use normal signal logic - 0 is off, 1 is on.  Thus, you use M62 for on and M63 for off.  
#### Using screw terminals
You will need to set the relay voltage to 5V via a jumper.  Use the SIG screw terminal for the signal and a GND terminal (Axis B GND is convenient). The logic is inverted so in your GCode,
use M63 for on, M62 for off.  You will need to set the outputs to off (M63) at the start of your GCode program (in the prolog section).
