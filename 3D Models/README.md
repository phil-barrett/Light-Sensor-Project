## 3D Model Notes

There are two assemblies here.
### Sensor Scan head
This holds the AS7xxx sensor boards and mounts directly onto the shaft of a stepper motor. Designed for a 5mm D shaft, friction fit. [AS7434 STEMMA](https://www.adafruit.com/product/4698?srsltid=AfmBOor2rxCOUImPIXlQTtWJuis5Yq7lb6loksAWy17aclu3D4Mx71SQ) from Adafruit and [AS7331](https://www.adafruit.com/product/6476?srsltid=AfmBOoo0G0vsKSdfCCBtIPG2kE9StAU23IlXgtkwhU9rp5u1htrRYweF) from Adafruit.
![scan head](https://github.com/phil-barrett/Light-Sensor-Project/blob/main/Images/scan%20head.png)

### Light Scanner Case
This holds the Pico, PicoBooster and OLED LCD.  Designed for a Sparkfun [QWIIC 1.3" OLED display](https://www.sparkfun.com/sparkfun-qwiic-oled-1-3in-128x64.html).
![scanner case](https://github.com/phil-barrett/Light-Sensor-Project/blob/main/Images/pico%20booster%20case.png)
Use M2 6mm screws to mount the OLED display, M3 6mm screws to attach the back to the middle section.  Mounting boss to accept M5 bolts for mounting on the Z assemble of the CNC assembly. Though zip ties could alternatively be used. 
Note the use of a 1x6 right angle pin header for the trigger wire connector.
