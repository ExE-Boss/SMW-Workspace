;32x32 player tilemap patch
;by Ladida

header : lorom

org $00A300
autoclean JML MarioGFXDMA

org $00E370
BEQ +
org $00E381
BNE +
org $00E385
NOP #6
+
LDA #$F8

org $00E3B0
TAX
LDA.l excharactertilemap,x
STA $0A
STZ $06
BRA +
NOP #5
+

org $00E3E4
BRA +
org $00E3EC
+

org $00F636
JML tilemapmaker

incsrc hexedits.asm



freecode
prot PlayerGFX

MarioGFXDMA:
REP #$20
LDX #$02
LDY $0D84
BNE +
BRL .skipall
+

;;
;Mario's Palette
;;

LDY #$86
STY $2121
LDA #$2200
STA $4310
LDA $0D82
STA $4312
LDY #$00
STY $4314
LDA #$0014
STA $4315
STX $420B


LDY #$80
STY $2115
LDA #$1801
STA $4310

;;
;Misc top tiles (cape, yoshi, podoboo)
;;

LDA #$6040
STA $2116
LDX #$04
-
LDA $0D85,x
STA $4312
LDY #$7E
STY $4314
LDA #$0040
STA $4315
LDY #$02
STY $420B
INX #2
CPX $0D84
BCC -

;;
;Misc bottom tiles (cape, yoshi, podoboo)
;;

LDA #$6140
STA $2116
LDX #$04
-
LDA $0D8F,x
STA $4312
LDY #$7E
STY $4314
LDA #$0040
STA $4315
LDY #$02
STY $420B
INX #2
CPX $0D84
BCC -

;;
;New player GFX upload
;;

PEA $6000
LDA $0D85 : PHA

LDX #$03
-
LDA $03,s
STA $2116
LDA $01,s
STA $4312
LDY $0D87
STY $4314
LDA #$0080
STA $4315

LDY #$02
STY $420B

LDA $03,s
CLC : ADC #$0100
STA $03,s
LDA $01,s
CLC : ADC #$0200
STA $01,s

DEX : BPL -

PLA : PLA

.skipall
SEP #$20

JML $00A38F


tilemapmaker:
REP #$20
LDX #$00
LDA $09
AND #$0300
SEC : ROR
PHA
LDA $09
AND #$3C00
ASL
ORA $01,s
STA $0D85
LDY.b #PlayerGFX>>16
BIT $09
BVC +
INY
+
STY $0D87
PLA
JML $00F674

incsrc excharactertilemap.asm

incbin PlayerGFX.bin -> PlayerGFX