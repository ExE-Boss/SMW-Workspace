; === HUFLUNGDU'S NOTES ===
;
; This patch makes it so that SMW's Mode 7 mirrors as well as rotation and scaling routines can be used in any level where the BG Mode ($3E) is set to 7.
;
; === MATHOS'S NOTES ===
;
; (Fortunately ?) this patch doesn't automatically disable scrolling when you go into Mode 7.
; So you'll have to do this manually in LM.
; However, it disables ExAnimation (so that you don't have VRAM uploads that may glitch your tilemap)
;
; Plus, it appears that when you go into Mode 7, the Mode 7 image acts like Iggy/Larry's platform: that is to say, it tilts.
; Animated lava sprite tiles are also present at the bottom of the screen. However, Iggy/Larry's platform interaction is absent.
; So, to disable these, I implemented 2 minor tweaks. Both are enabled by default.
; Obvious consequences are, if you use them, Iggy/Larry's boss battles will be "unusable" even if they'll stay playable.
; To be precise, Iggy/Larry will stay to the right side of the platform and will be able able to be thrown into lava only by this side.
; 
; Important fact:  when you go into Mode 7, the status bar and layer 2 background disappear: THE WHOLE SCREEN GOES INTO MODE 7.
; So if you're skilled enough, you could put some custom static sprites to have a minimal scenery.
;
; It is also to be noted that when you use a Mode 7 background, you'd better not use anything that changes VRAM, not even parts of it.
; That include question mark blocks, for example, because as they transform into brown used ones, they change the tilemap.
;



!LavaRoutine = 1		; 1 to disable a routine, 0 to leave it untouched
!TiltRoutine = 1

if read1($00FFD5) == $23
	sa1rom
	!base1 = $3000
	!base2 = $6000
	!base3 = $000000
else
	lorom
	!base1 = $0000
	!base2 = $0000
	!base3 = $800000
endif

;-------------------------------------

; Disabling some routines

if !LavaRoutine == 1

	org $00988C		; Kills the only JSL to the subroutine.
	NOP #4

	org $03C0C6		; And now you get 76 bytes of freespace here !
					; Insert anything you want here as long as it's 76 bytes or shorter
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF
	
endif

if !TiltRoutine == 1

	org $03C0CA		; Kills the only JSR to the subroutine
	NOP #3

	org $03C11E		; And now you get 88 bytes of freespace here !
					; Insert anything you want here as long as it's 88 bytes or shorter
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	
endif
	
;-------------------------------------

org $0081C6|!base3
	autoclean JML MirrorCheck
	NOP

org $00A28A|!base3
	autoclean JML ScrollRotateCheck
	NOP

org $00A5AF|!base3
	autoclean JML ExAnimCheck
	NOP
	
org $008387|!base3
	autoclean JML Mode7Pos
	
org $009890|!base3	; Now the routine at $00987D is a "long" one
	RTL

;-------------------------------------

freecode

; This makes SMW use the Mode 7 mirrors in ANY Mode 7 level instead
; of just boss levels.

MirrorCheck:
	LDA $3E
	AND #$07
	CMP #$07
	BEQ .mode7level
	LDA $0D9B|!base2
	BMI .mode7level
	JML $0081CE|!base3

.mode7level:
	STA $0D9B|!base2
	JML $0082C4|!base3
	
Mode7Pos:
	LDA $3E
	AND #$07
	CMP #$07
	BEQ .mode7level
	LDA $0D9B|!base2
	BMI .mode7level
	LDA #$81
	STA $4200
	JML $00838F|!base3

.mode7level:
	LDA #$81
	JML $0083BA|!base3

;-------------------------------------

; Handles rotation and scaling.

ScrollRotateCheck:
	LDA $3E
	AND #$07
	CMP #$07
	BEQ .mode7level
	LDA $0D9B|!base2
	BMI .bosslevel
	JML $00A295|!base3

.mode7level:
	JSL $00987D|!base3
	JML $00A295|!base3

.bosslevel:
	JSL $00987D|!base3
	JML $00A2A9|!base3

;-------------------------------------

; Turns off ExAnimation in Mode 7 levels.

ExAnimCheck:
	LDA $3E
	AND #$07
	CMP #$07
	BEQ .mode7level
	LDA $0D9B|!base2
	BMI .mode7level
	JML $00A5B9|!base3

.mode7level:
	JML $00A5B4|!base3
