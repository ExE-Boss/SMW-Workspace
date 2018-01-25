@asar 1.50
; SMW Core Dump Patch
; Copyright (C) 2018 ExE Boss
;
; This program is free software: you can redistribute it and/or modify
; it under the terms of the GNU Lesser General Public License as published by
; the Free Software Foundation, either version 3 of the License, or
; (at your option) any later version.
;
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU Lesser General Public License for more details.
;
; You should have received a copy of the GNU Lesser General Public License
; along with this program.  If not, see <http://www.gnu.org/licenses/>.

incsrc ../shared/shared.asm	;> Using RPG Hacker’s shared functions.
incsrc core_dump.cfg	;> Configuration for this patch.

math	pri	on	;\ Asar defaults to Xkas settings instead
math	round	off	;/ of proper math rules, this fixes that.

print ""
print " SMW Core Dump Patch 0.2 – © 2018 ExE Boss "
print "      Licensed under the GNU-LGPL 3.0      "
print " ========================================= "
print ""

assert !Freespace&$FFFF == !Freespace "The Freespace definition must be in bank 0"

function get_crash_display_ram(X,Y) = ((X+(Y*$20))<<$1)

!Freeram	#= select(!use_sa1_mapping,!FreeramSA1,!Freeram)	;> Use the SA-1 RAM when SA-1 is in use.

!Dataram	= !Freeram+$740
!TextData	= !Dataram+$00
!TextSize	= !Dataram+$02
!StackSize	= !Dataram+$7E

org remap_rom(!Freespace)
	autoclean JML BreakInterruptListener
warnpc remap_rom(!Freespace+$04)

org remap_rom($00FFE6)
	dw !Freespace&$FFFF
warnpc remap_rom($00FFE8)

freedata ;> this one doesn’t change the data bank register, so let’s toss it into banks $40+

macro WriteA16ToRAM(X,Y)
	LDX.w #get_crash_display_ram(<X>+3,<Y>)
	JSL WriteA16ToRAM
endmacro

macro WriteA8ToRAM(X,Y)
	LDX.w #get_crash_display_ram(<X>+1,<Y>)
	JSL WriteA8ToRAM
endmacro

macro WriteA8bToRAM(X,Y)
	LDX.w #get_crash_display_ram(<X>+7,<Y>)
	JSL WriteA8bToRAM
endmacro

BreakInterruptListener:
	; Something broke, let’s do a core dump
	REP #$30	;> Set 16-bit A/X/Y registers
	PHA : PHX : PHY	;> Backup all the things

	SEP #$20	;> Set 8-bit Accumulator
	JSL PrepareTilemap
	REP #$20	;> Set 16-bit Accumulator

	LDA $5,s
	%WriteA16ToRAM(!Accumulator_X,!Accumulator_Y)

	LDA $3,s
	%WriteA16ToRAM(!RegisterX_X,!RegisterX_Y)

	LDA $1,s
	%WriteA16ToRAM(!RegisterY_X,!RegisterY_Y)

	TSC : CLC : ADC.w #$6+$4
	PHA
	%WriteA16ToRAM(!StackPointer_X,!StackPointer_Y)

	TDC
	%WriteA16ToRAM(!DirectPage_X,!DirectPage_Y)

	LDA $8+$2,s
	SEC : SBC.w #$2
	%WriteA16ToRAM(!ProgramCounter_X+2,!ProgramCounter_Y)

	SEP #$20	;> Set 8-bit Accumulator

	LDA $8+$4,s
	%WriteA8ToRAM(!ProgramCounter_X,!ProgramCounter_Y)

	LDA $8+$1,s
	%WriteA8bToRAM(!ProcessorFlags_X,!ProcessorFlags_Y)

	PHB : PLA
	%WriteA8ToRAM(!DataBank_X,!DataBank_Y)

	REP #$20	;> Set 16-bit Accumulator
	LDY $00
	LDX $01
	LDA $8+$2,s : DEC
	STA $00
	SEP #$20	;> Set 8-bit Accumulator
	LDA $8+$4,s
	STA $02
	LDA [$00]
	STY $00
	STX $01
	%WriteA8ToRAM(!BRKnumber_X,!BRKnumber_Y)

	REP #$20	;> Set 16-bit Accumulator

.writeStack:
if !use_sa1_mapping
	LDY $0000 : LDA $3000 : INC : STA $0000 : CMP $3000 : STY $0000 : BNE ..snes
	LDA #$3800 ;> The SA-1 stack is at $XX:3700-$XX:37FF
	BRA ..snes_merge
..snes:
	LDA #$2000 ;> The SNES stack with the SA-1 is at $7E:0000-$7E:1FFF
...merge:
	STA !StackSize ;> Use the last two bytes of Freeram as the stack size
endif
	PLA : TAY
	LDX.w #get_crash_display_ram(!StackDump_X+1,!StackDump_Y)
-	INY
if !use_sa1_mapping
	TYA	;\ With the SA-1, the SNES stack is 16 times larger.
	CMP !StackSize	;/ And we also have to make sure that we are compatible with the SA-1 stack.
else
	CPY #$0200
endif
	SEP #$20	;> Set 8-bit Accumulator
	BCS .upload
	LDA $0000,y
	PHX
	JSL WriteA8ToRAM
	REP #$20	;> Set 16-bit Accumulator
	PLA
	CLC : ADC #$0020*2
	CMP.w #get_crash_display_ram($1C,!StackDump_Y+$10)
	BCS .upload
	CMP.w #get_crash_display_ram(0,!StackDump_Y+$10)
	BCC +
	SEC : SBC.w #get_crash_display_ram(!StackDump_X+1,!StackDump_Y+$10)-get_crash_display_ram(!StackDump_X+4,!StackDump_Y)
+	TAX
	BRA -

.upload:
	SEP #$20 ;> Set 8-bit Accumulator
if !use_sa1_mapping
	LDA !StackSize+1	;\ SA-1 sets this address to $38,
	AND.b #$0F	;| whereas SNES sets this address to $20.
	BEQ ..snes	;/

	LDX.w #..snes	;\ Put the SNES pointer to run
	STX $0183	;| in $0183-$0185.
	LDA.b #..snes>>$10	;|
	STA $0185	;/
	LDA #$D0	;\ Invoke/Call SNES
	STA $2209	;/
-	LDA $018A	;\ Spinlock self
	BEQ -	;|
	STZ $018A	;|
-	BRA -	;/ Spinlock self

..snes:
	SEI
endif
-	BIT $4212	;\ Wait for V-blank
	BPL -	;/

	JSL UploadToCGRAM
	JSL UploadToVRAM
	SEP #$30
	JSL SetAPURegisters
	JSL SetPPURegisters

--	LDX #$00	;\ Spinlock self
-	INX	;|
	BNE -	;|
	BRA --	;/
.end:

SetPPURegisters:
	STZ $2111	;\ Put Layer 3 at x000 y000
	STZ $2111	;|
	STZ $2112	;|
	STZ $2112	;/
	LDA #09	;\ Mode 3
	STA $2105	;/
	STZ $2131	;> Disable CGADSUB
	LDA #$04	;\ Display only Layer 3
	STA $212C	;|
	STZ $212D	;/
	STZ $2123	;\ Disable Window Mask
	STZ $2124	;|
	STZ $2125	;/
	LDA #$54	;\ Make Layer 3 read the tilemap from $5400
	STA $2109	;/
	LDA #$0F	;\ Set max brightness
	STA $2100	;/
	RTL

!AMK_installed = 0
SetAPURegisters:
	REP #$10
	LDY remap_ram($010B)	;> Get level number if UberASM has been installed.
	STZ remap_ram($1DF9)	;\ Clean up APU mirrors.
	STZ remap_ram($1DFA)	;|
	STZ remap_ram($1DFC)	;/
	STZ $2140	;\ Stop all Audio
	STZ $2141	;|
	STZ $2143	;/
	LDA #!CrashMusic
if	read1(remap_rom($0E8000)) == $40 && read1(remap_rom($0E8001)) == $41 && \	;\ When AMK is installed, then the Overworld and Levels use the same
	read1(remap_rom($0E8002)) == $4D && read1(remap_rom($0E8003)) == $4B	;/ music bank, which results in this code results in the wrong song playing.
	!AMK_installed = 1
else
	CPY.w #$C7	;\ Fix issue with the Title Screen using Overworld Music data
	BNE +	;| and $09 is the Special World music on the Overworld and Title Screen
	LDA #$0A : +	;/ instead of the death SFX it is in a level.
endif
	STA remap_ram($1DFB)	;\ Stop Music
	STA $2142	;/
	SEP #$10
	RTL

UploadToVRAM:
	SEP #$20	;\ Set 8-bit Accumulator
	REP #$10	;/ Set 16-bit X/Y registers

	JSL .uploadFont
	JSL .uploadTilemap
	RTL

.uploadFont:
	LDA #$80	;\ Set copy mode
	STA $2115	;/
	LDX #$4000	;\ Set target destination
	STX $2116	;/

	LDA.b #Font>>$10	;\ Set source bank, offset and size
	LDX.w #Font	;|
	LDY.w #(Font_end-Font)	;/

	STX $4302	;\ Store data offset into DMA source offset
	STA $4304	;| Store data bank into DMA source bank
	STY $4305	;/ Store size of data block

	LDA #$01	;\ Set DMA mode (word, normal increment)
	STA $4300	;/
	LDA #$18	;\ Set the destination register (VRAM write register)
	STA $4301	;/
	LDA #$01	;\ Initiate DMA transfer (channel 0)
	STA $420B	;/
	RTL

.uploadTilemap:
	LDA #$80	;\ Set copy mode
	STA $2115	;/
	LDX #$5400	;\ Set target destination
	STX $2116	;/

	LDA.b #!Freeram>>16	;\ Set source bank, offset and size
	LDX.w #!Freeram	;|
	LDY #$0800	;/

	STX $4302	;\ Store data offset into DMA source offset
	STA $4304	;| Store data bank into DMA source bank
	STY $4305	;/ Store size of data block

	LDA #$01	;\ Set DMA mode (word, normal increment)
	STA $4300	;/
	LDA #$18	;\ Set the destination register (VRAM write register)
	STA $4301	;/
	LDA #$01	;\ Initiate DMA transfer (channel 0)
	STA $420B	;/
	RTL

UploadToCGRAM:
	SEP #$30	;> 8-bit A/X/Y registers
	STZ $2121
	LDY #$20
	LDX #$00

-	TYA
	AND #$03
	BEQ .uploadBG
	LDA.l PaletteData+$2,x
	STA $2122
	INX
	LDA.l PaletteData+$2,x
	STA $2122
	INX
--	DEY
	BNE -

	LDA #$E0	;\ Disable non-CGRAM background colour
	STA $2132	;/
	RTL

.uploadBG:
	LDA.l PaletteData
	STA $2122
	LDA.l PaletteData+$1
	STA $2122
	BRA --

; Writes the binary contents of the 8-bit A
; to the Freeram address specified by X
WriteA8bToRAM:
	PHY
	LDY.w #$0007
-	PHA
	AND.b #$01
	JSL WriteAtoRAMsub	;> Write the value
	PLA
	LSR
	DEX #$2
	DEY
	BPL -
	PLY
	RTL

; Writes the HEX contents of the 8-bit A
; to the Freeram address specified by X
WriteA8ToRAM:
	PHA
	AND.b #$0F
	JSL WriteAtoRAMsub
	DEX #$2
	PLA
	LSR #$4
	JSL WriteAtoRAMsub
	RTL

; Writes the HEX contents of the 16-bit A
; to the Freeram address specified by X
WriteA16ToRAM:
	PHY
	LDY.w #$0003
-	PHA
	AND.w #$000F
	SEP #$20	;\ Write the value
	JSL WriteAtoRAMsub	;|
	REP #$20	;/
	PLA
	LSR #$4
	DEX #$2
	DEY
	BPL -
	PLY
	RTL

; Writes the HEX contents of the 8-bit A containing
; a <$10 value to the Freeram address specified by X
WriteAtoRAMsub:
	CMP.b #$0A
	BCC .num
	CMP.b #36
	BCC .b16

	LDA.b #$0A
	BRA .write

.num:
	ORA.b #$10
	BRA .write

.b16:
	CLC : ADC.b #$21-$0A

.write:
	STA.l !Freeram,x
	LDA #$20|((!CoreDumpPalette&$07)<<2)
	STA.l !Freeram+1,x
	RTL

PrepareTilemap:
	LDA #$00
	LDX #$0800-$1

-	STA.l !Freeram,x
	DEX
	BPL -

	LDA $00 : PHA	;\ Backup $00
	LDA $01 : PHA	;|
	LDA $02 : PHA	;/
	JSL WriteText_main
	PLA : STA $02	;\ Restore $00
	PLA : STA $01	;|
	PLA : STA $00	;/
	RTL

WriteText:
.main:
	PHP
	SEP #$10	;> 8-bit X/Y registers

	LDY.b #$00
-	TYA : STY $00
	CMP.l TextPointers
	BCS ..return
	ASL : CLC : ADC $00 : TAX
	REP #$20	;> 16-bit Accumulator
	LDA.l TextPointers+1,x
	STA $00
	SEP #$20	;> 8-bit Accumulator
	LDA.l TextPointers+3,x
	STA $02
	JSL .sub
	INY
	BRA -

..return:
	PLP
	RTL

; Writes UTF-8 text to the tilemap
; ================================
.sub:
	PHA : PHX : PHY : PHP
	SEP #$30	;> 8-bit A/X/Y registers

	LDA [$00]	: STA.l !TextData	: INC $00	;\ Store text coordinates to RAM 
	LDA [$00]	: STA.l !TextData+1	: INC $00	;/

	REP #$20	;> 16-bit Accumulator
	LDA [$00]	: STA.l !TextSize	;\ Store text size to RAM
	INC $00	: INC $00	;/

	REP #$10	;> 16-bit X/Y registers
	LDY.w #$00
	LDA.l !TextData	;\ Calculate index from coordinates
	XBA : LSR #5	;|
	AND #$7FE : TAX	;/
	LDA #$0000

-	REP #$20	;> 16-bit Accumulator
	TYA
	CMP.l !TextSize
	BCS ..return
	SEP #$20	;> 8-bit Accumulator
	LDA [$00],y
	JSL .writeCharacter
	INY
	CPX.w #(!Dataram-!Freeram-1)	;\ Ensure that we stay in screen bounds
	BCC -	;/

..return:
	PLP : PLY : PLX : PLA
	RTL

.writeCharacter:
	CMP #$20
	BCC ..specialCharacter
	CMP #$80
	BCC ..normalCharacter
	; TODO: Add support for multi-byte UTF-8 code points
..return:
	RTL

..normalCharacter:
	SEC : SBC #$20	;\ Convert code point to index in GFX file.
	STA.l !Freeram,x	;/
	INX
	LDA.l !TextData+1	;\ Load text palette
	LSR : AND #$1C	;/
	ORA #$20	;> Set priority bit
	STA.l !Freeram,x	;> Store XYPCCCTT to RAM
	INX
	BRA ..return

..specialCharacter:
	; There are $20 special code points in the Basic Latin/ASCII Unicode block,
	; so let’s support only the important ones for now.
	CMP #$0A
	BEQ ...newline
	CMP #$0D
	BEQ ...dosNewline
	BRA ..return

...dosNewline:
	INY	;\ Treat the sequence $0D,$0A as a single newline character
	LDA [$00],y	;| instead of two
	CMP #$0A	;|
	BEQ ...newline	;|
	DEY	;/
...newline:
	REP #$20	;> 16-bit Accumulator
	TXA : AND.w #$07C0	;\ Increase the Y position
	CLC : ADC.w #$0040	;/
	PHA : LDA.l !TextData	;\ Reset the X position
	XBA : LSR #5	;|
	AND.w #$003E	;/
	ORA $1,s	;\ Transfer Accumulator to X
	PLX : TAX	;/
	SEP #$20	;> 8-bit Accumulator
	BRA ..return

incsrc "core_dump_text.asm"
Font:
incbin "font.bin"
.end:

print "BRK Interrupt Vector installed at: $",hex(BreakInterruptListener)
print "Using ($800) 2048 bytes of RAM at: $",hex(!Freeram)
print ""
print "Text pointers installed at: $",hex(TextPointers)
print "Font installed at:          $",hex(Font)
print ""
if !AMK_installed : print "AMK detected, ensuring compatibility" : print ""
print "Using ",freespaceuse," bytes of free ROM"
print ""
