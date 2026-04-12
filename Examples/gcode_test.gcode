;
;	Sample GCode for a 4 x 4, 1 mm scan grid
;	PL Barrett
;
G90 G21 G17 F5000	; Absolute distance mode, metric mode, X/Y Plane; 5000 mm/Sec feed rate

; row 1
M64 P2		; start document
M64 P1		; start line 1

G1 x0y0		; drive to grid location
G04 P1		; settling time
M64 P0		; trigger sample
G04 P0.4	; delay
M65 P0		; reset sample trigger

G1 x1y0		; drive to grid location
G04  P1		; settling time
M64 P0		; trigger sample
G04 P0.4	; delay
M65 P0		; reset sample trigger

G1 x2y0		; drive to grid location
G04  P1		; settling time
M64 P0		; trigger sample
G04 P0.4	; delay
M65 P0		; reset sample trigger

G1 x3y0		; drive to grid location
G04  P1		; settling time
M64 P0		; trigger sample
G04 P0.4	; delay
M65 P0		; reset sample trigger
M65 P1		; end of line
G04 P0.4	; delay

; row 2
M64 P1		; start line 
G1 x0y1		; drive to grid location
G04  P1		; settling time
M64 P0		; trigger sample
G04 P0.4	; delay
M65 P0		; reset sample trigger

G1 x1y1		; drive to grid location
G04  P1		; settling time
M64 P0		; trigger sample
G04 P0.4	; delay
M65 P0		; reset sample trigger

G1 x2y1		; drive to grid location
G04  P1		; settling time
M64 P0		; trigger sample
G04 P0.4	; delay
M65 P0		; reset sample trigger

G1 x3y1		; drive to grid location
G04  P1		; settling time
M64 P0		; trigger sample
G04 P0.4	; delay
M65 P0		; reset sample trigger
M65 P1		; end of line
G04 P0.4	; delay

; row 3
M64 P1		; start line 
G1 x0y2		; drive to grid location
G04  P1		; settling time
M64 P0		; trigger sample
G04 P0.4	; delay
M65 P0		; reset sample trigger

G1 x1y2		; drive to grid location
G04  P1		; settling time
M64 P0		; trigger sample
G04 P0.4	; delay
M65 P0		; reset sample trigger

G1 x2y2		; drive to grid location
G04  P1		; settling time
M64 P0		; trigger sample
G04 P0.4	; delay
M65 P0		; reset sample trigger

G1 x3y2		; drive to grid location
G04  P1		; settling time
M64 P0		; trigger sample
G04 P0.4	; delay
M65 P0		; reset sample trigger
M65 P1		; end of line
G04 P0.4	; delay

; row 4
M64 P1		; start line 
G1 x0y3		; drive to grid location
G04  P1		; settling time
M64 P0		; trigger sample
G04 P0.4	; delay
M65 P0		; reset sample trigger

G1 x1y3		; drive to grid location
G04  P1		; settling time
M64 P0		; trigger sample
G04 P0.4	; delay
M65 P0		; reset sample trigger

G1 x2y3		; drive to grid location
G04  P1		; settling time
M64 P0		; trigger sample
G04 P0.4	; delay
M65 P0		; reset sample trigger

G1 x3y3		; drive to grid location
G04  P1		; settling time
M64 P0		; trigger sample
G04 P0.4	; delay
M65 P0		; reset sample trigger
G04 P0.4	; delay
M65 P1		; end of line
G04 P0.4	; delay
M65 P2


