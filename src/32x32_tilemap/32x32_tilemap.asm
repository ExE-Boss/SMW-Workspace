;32×32 player tilemap patch
;by Ladida

header : lorom

print ""
print " 32×32 player tilemap patch v1.1 "
print "            by Ladida            "
print " =============================== "
print ""

incsrc ../shared/shared.asm

!Freedata	= remap_rom($568000)	;> Needs to be 4 banks long

org remap_rom($00A300)
autoclean JML MarioGFXDMA

org remap_rom($00E370)
BEQ +
org remap_rom($00E381)
BNE +
org remap_rom($00E385)
NOP #6
+
LDA #$F8

org remap_rom($00E3B0)
TAX
LDA.l excharactertilemap,x
STA $0A
STZ $06
BRA +
NOP #5
+

org remap_rom($00E3E4)
BRA +
org remap_rom($00E3EC)
+

org remap_rom($00F636)
JML tilemapmaker

incsrc hexedits.asm



freecode
prot PlayerGFX

MarioGFXDMA:
REP #$20
LDX #$02
LDY remap_ram($0D84)
BNE +
JMP .skipall
+

;;
;Mario's Palette
;;

LDY #$86
STY $2121
LDA #$2200
STA $4310
LDA remap_ram($0D82)
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
LDA remap_ram($0D85),x
STA $4312
LDY #$7E
STY $4314
LDA #$0040
STA $4315
LDY #$02
STY $420B
INX #2
CPX remap_ram($0D84)
BCC -

;;
;Misc bottom tiles (cape, yoshi, podoboo)
;;

LDA #$6140
STA $2116
LDX #$04
-
LDA remap_ram($0D8F),x
STA $4312
LDY #$7E
STY $4314
LDA #$0040
STA $4315
LDY #$02
STY $420B
INX #2
CPX remap_ram($0D84)
BCC -

;;
;New player GFX upload
;;

PEA $6000
LDA remap_ram($0D85) : PHA

LDX #$03
-
LDA $03,s
STA $2116
LDA $01,s
STA $4312
LDY remap_ram($0D87)
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

JML remap_rom($00A38F)


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
STA remap_ram($0D85)
LDY.b #PlayerGFX>>16
BIT $09
BPL +
INY #$02
+
BVC +
INY
+
STY remap_ram($0D87)
PLA
JML remap_rom($00F674)

incsrc excharactertilemap.asm

print "PlayerGFX installed at: $", hex(PlayerGFX), " (pc: $", hex(snestopc(PlayerGFX)),")"
;pushpc : freedata align : PlayerGFX: : pullpc
;pushpc : freedata align : PlayerGFX: incbin PlayerGFX.bin : pullpc
;incbin PlayerGFX.bin -> PlayerGFX

org !Freedata-$8008
	db $53,$54,$41,$52	;\ Asar complains when `db "STAR"` is encoutered
	dw $FFFF	;| without the file starting with `;@xkas`, even
	dw $0000	;/ when Asar only features are used
org !Freedata
	PlayerGFX:
incbin PlayerGFX.bin -> !Freedata
org !Freedata+$020000
	db $53,$54,$41,$52
	dw $FFF7
	dw $0008
