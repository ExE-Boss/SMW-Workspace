
PaletteData:
dw $0000	; Background Colour
dw $0000,$0000,$0000	; Palette 0
dw $0000,$0000,$0000	; Palette 1
dw $0000,$0CFB,$2FEB	; Palette 2
dw $0000,$7FDD,$2D7F	; Palette 3
dw $7FDD,$7FFF,$0000	; Palette 4
dw $7F20,$7F80,$7FE0	; Palette 5
dw $0000,$7AAB,$7FFF	; Palette 6
dw $0000,$1E9B,$3B7F	; Palette 7

TextPointers:
db $04 ;> Text pointers used
dl Header,Registers,StackHeader,StackNumbers

Header:
.header:
;  %yyyyyxxx,%xxccc--- (Y position, X position, palette)
db %00001000,%01011000
dw (.end-.body) ; Max 65535 characters (~2048 lines of text)

.body:
db "A CRASH HAS OCCURED,",$0A
db "THE PROGRAM STATE HAS BEEN",$0A
db "RECORDED AND DISPLAYED BELOW."
.end:

Registers:
.header:
db %00101000,%10111000
dw (.end-.body)

.body:
db "A:      S :          DP:",$0A
db "X:      P :          DB:",$0A
db "Y:      PC:          BRK:"
.end:

StackHeader:
.header:
db %01001000,%01111000
dw (.end-.body)

.body:
db "STACK)------------------------"
.end:

StackNumbers:
.header:
db %01010000,%00111000
dw (.end-.body)

.body:
db "  0- 1- 2- 3- 4- 5- 6- 7- 8- 9-",$0A
db "0",$0A
db "1",$0A
db "2",$0A
db "3",$0A
db "4",$0A
db "5",$0A
db "6",$0A
db "7",$0A
db "8",$0A
db "9",$0A
db "A",$0A
db "B",$0A
db "C",$0A
db "D",$0A
db "E",$0A
db "F"
.end:
