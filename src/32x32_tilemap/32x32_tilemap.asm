@asar 1.50
;32×32 player tilemap patch
;by Ladida

print ""
print " 32×32 player tilemap patch v1.2 "
print "            by Ladida            "
print " =============================== "
print ""

incsrc 32x32_tilemap.cfg
incsrc ../shared/shared.asm

math	pri	on	;\ Asar defaults to Xkas settings instead
math	round	off	;/ of proper math rules, this fixes that.

namespace _32x32_tilemap_

;;;;;;;;;
;Defines;
;;;;;;;;;

; DO NOT EDIT THOSE!!!

!PlayerGFX_size #= select(equal(readfile1("PlayerGFX.bin",$10000,$FF),readfile1("PlayerGFX.bin",$10000,$00)),select(equal(readfile1("PlayerGFX.bin",$20000,$FF),readfile1("PlayerGFX.bin",$20000,$00)),$30000,$20000),$10000)
assert !PlayerGFX_size >= 0, "PlayerGFX.bin not found"
assert !PlayerGFX_size <= $20000, "PlayerGFX.bin is too big, must be at most 128KiB"

assert !Freedata%$8000 == 0, "Freedata must point to the start of a bank"
if !use_sa1_mapping
	assert !Freedata&$7F0000 < $400000, "Freedata is currently unsupported in the SA-1 HiROM area"
endif

;;;;;;;;;
;Hijacks;
;;;;;;;;;

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
incsrc ow_mario.asm


;;;;;;;;;;;;;;;;;
;MAIN CODE START;
;;;;;;;;;;;;;;;;;

freedata
if !PlayerGFX_size > $10000
	prot PlayerGFX,PlayerGFX_prot2
else
	prot PlayerGFX
endif

FreecodeStart:

MarioGFXDMA:
LDY remap_ram($0D84)
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
LDA remap_ram($0D82)
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
LDA remap_ram($0D85),x
STA $4312
LDA #$0040
STA $4315
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
LDA #$0040
STA $4315
STY $420B
INX #2
CPX remap_ram($0D84)
BCC -

;;
;New player GFX upload
;;

LDX remap_ram($0D87)
STX $4314
LDA remap_ram($0D86) : PHA
LDX #$06
-
LDA.l .vramtbl,x
STA $2116
LDA #$0080
STA $4315
LDA remap_ram($0D85)
STA $4312
STY $420B
INC remap_ram($0D86)
INC remap_ram($0D86)
DEX #2 : BPL -
PLA : STA remap_ram($0D86)
SEP #$20

.skipall
JML remap_rom($00A38F)

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

print "Patch inserted at $",hex(FreecodeStart)," (pc: $",hex(snestopc(FreecodeStart)),"), ",freespaceuse," bytes of free space used."

reset freespaceuse

!PlayerGFX_freespaceuse = freespaceuse
if !PlayerGFX_size <= $10000
	incbin PlayerGFX.bin -> PlayerGFX
else
	org remap_rom(!Freedata-$8008)
		db $53,$54,$41,$52	;\ Asar complains when `db "STAR"` is encoutered
		dw $FFFF	;| without the file starting with `;@xkas`, even
		dw $0000	;/ when Asar only features are used
	org remap_rom(!Freedata)
		PlayerGFX:
		incbin PlayerGFX.bin -> remap_rom(!Freedata)
	org remap_rom(!Freedata+$20000)
		db $53,$54,$41,$52
		dw clamp(!PlayerGFX_size-$10009,0,$FFF7)
		dw clamp(!PlayerGFX_size-$10009,0,$FFF7)^$FFFF
		.prot2:
endif

print "PlayerGFX inserted at: $",hex(PlayerGFX)," (pc: $",hex(snestopc(PlayerGFX)),"), !PlayerGFX_size bytes of free space used."
print ""
