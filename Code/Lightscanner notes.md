# Light scanner notes

## LCD Display
Requires a 128x64 monochrome display. Uses the graphics package u8g2 which supports both SH1106 and SSD1306 controller chips. To use either one, uncomment the appropriate line at approximately lines 14-15.

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

Note that the max bar size is dictated by the following defines
```
// spectral display max values (emprically derived)
#define UVMAX 2400
#define IRMAX 20000
#define LUXMAX 20000
```
Adjust as needed.  Note that the max values from the sensors are dependent on gain multipliers and your light sources.  Decrease the values for raltively dim sources and increase for bright ones.  You may need to experiment to derive useful values.


## Sensors
Currently, only the AS7343 and AS7331 are supported.  I will add the AS7341 at some point.


## COM port monitor
Sensor readings will be sent to the COM port, typically via USB. The output will look somethinglike this.
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
    ?     print command list
    c     Clear all settings
    u[+-] Toggle UV setting
    l[+-] Toggle visible light setting
    i[+-] Toggle IR setting
    a     Set all settings
```
The output (LCD and COM) will be adjusted based on selected settings.
