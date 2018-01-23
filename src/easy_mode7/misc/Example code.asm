; The following code tells the game to go into Mode 7 and then uploads an interleaved tilemap.
;
; NOTE 1:	As you probably know, the SNES's VRAM contains graphics and tilemaps for the different layers.
;	They are normally separated, but in Mode 7, all even bytes are graphics-related and all odd bytes are tilemap-related (Or maybe it's the opposite I dunno :P)
;	Long story short, the VRAM constantly alternates between graphics data and tilemap data.
;	You can create this sort of tilemap with Vitor Vilela's SNESGFX program.
;	Please note that you must not use more than 256 different 8x8 tiles or things might get sorta buggy or glitchy.
; NOTE 2:	It's also recommended to actually use only 127 different colors instead of all 255 because it will overwrite sprite palettes, beginning with Mario's.
; NOTE 3:	If you're using UberASMTool, take advantage of the prot_file macro to insert your interleaved tilemap into your ROM without problems.
; NOTE 4:	This code is already SA-1 compatible as it uses direct page adressing ($XX adresses) and SNES registers ($2000+).

	; To be put in a level's "init" hijack
	LDA #$07			;\ Set BG Mode to 7.
	STA $3E				;/
	LDA #$80            ; \ Increase on $2119 write.
	STA $2115           ; /
	REP #$10
	LDX #$0000			; \ Set where to write in VRAM...
	STX $2116			; / ...and since Mode 7 is layer 1 we can just put $0000 here.
	LDA #$01            ;\ Set mode to...
	STA $4300           ;/ ...2 regs write once.
	LDA #$18            ;\ 
	STA $4301           ;/ Writing to $2118 AND $2119.
	LDX.w #FileLabel    ;\  Adress where our data is.
	STX $4302          	; | 
	LDA.b #FileLabel>>16; | Bank where our data is.
	STA $4304          	;/
	LDX #$8000          ;\ Size of our data.
	STX $4305           ;/
	SEP #$10
	LDA.b #$01	   		;\ Start DMA transfer on channel 0.
	STA.w $420B	   		;/

; The following code sets the Mode 7 registers so that you can see your whole tilemap rotate.

	; To be put in a level's "main" hijack
	REP #$20
	LDA #$0180 : STA $2A	; \ Set effect center to tilemap center
	LDA #$0180 : STA $2C	; /
	STZ $36					; Set angle to 0°
	LDA #$8080 : STA $38	; Set size to 25% so the whole tilemap is visible
	LDA #$0180 : STA $3A	; \ Set layer position to tilemap center
	LDA #$0180 : STA $3C	; /
	SEP #$20

	LDA $13D4|!addr		; If game is paused...
	BNE .end			; ...skip this.
	REP #$20
	INC $36				; Increment angle
	SEP #$20
	.end: