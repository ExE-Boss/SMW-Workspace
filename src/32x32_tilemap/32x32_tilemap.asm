;32x32 player tilemap patch
;by Ladida

header : lorom

	!dp = $0000
	!addr = $0000
	!sa1 = 0
	!gsu = 0

if read1($00FFD6) == $15
	sfxrom
	!dp = $6000
	!addr = !dp
	!gsu = 1
elseif read1($00FFD5) == $23
	sa1rom
	!dp = $3000
	!addr = $6000
	!sa1 = 1
endif

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
LDY $0D84|!addr
BNE +
JMP .skipall
+

REP #$20
LDY #$02

;;
;Mario's Palette
;;

LDX #$86
STX $2121
LDA #$2200
STA $4310
LDA $0D82|!addr
STA $4312
LDX #$00
STX $4314
LDA #$0014
STA $4315
STY $420B


LDX #$80
STX $2115
LDA #$1801
STA $4310
LDX #$7E
STX $4314

;;
;Misc top tiles (cape, yoshi, podoboo)
;;

LDA #$6040
STA $2116
LDX #$04
-
LDA $0D85|!addr,x
STA $4312
LDA #$0040
STA $4315
STY $420B
INX #2
CPX $0D84|!addr
BCC -

;;
;Misc bottom tiles (cape, yoshi, podoboo)
;;

LDA #$6140
STA $2116
LDX #$04
-
LDA $0D8F|!addr,x
STA $4312
LDA #$0040
STA $4315
STY $420B
INX #2
CPX $0D84|!addr
BCC -

;;
;New player GFX upload
;;

LDX $0D87|!addr
STX $4314
LDA $0D86|!addr : PHA
LDX #$06
-
LDA.l .vramtbl,x
STA $2116
LDA #$0080
STA $4315
LDA $0D85|!addr
STA $4312
STY $420B
INC $0D86|!addr
INC $0D86|!addr
DEX #2 : BPL -
PLA : STA $0D86|!addr
SEP #$20

.skipall
JML $00A38F

.vramtbl
dw $6300,$6200,$6100,$6000


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
STA $0D85|!addr
LDY.b #PlayerGFX>>16
BIT $09
BVC +
INY
+
STY $0D87|!addr
PLA
JML $00F674

incsrc excharactertilemap.asm

incbin PlayerGFX.bin -> PlayerGFX