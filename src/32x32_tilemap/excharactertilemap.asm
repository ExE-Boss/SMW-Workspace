@includefrom 32x32_tilemap.asm

;see very bottom for pose definitions

excharactertilemap:

;small mario
db $00,$01,$01,$03,$04,$05,$05,$07	;1
db $08,$08,$0A,$0B,$0C,$0D,$0E,$0F	;2
db $10,$11,$12,$12,$14,$15,$16,$17	;3
db $18,$19,$1A,$1B,$1C,$1D,$1E,$1F	;4
db $20,$21,$22,$23,$24,$25,$26,$27	;5
db $28,$29,$80,$80,$80,$80,$80,$80	;6
db $30,$31,$32,$33,$34,$35,$36,$37	;7
db $38,$39,$3A,$3B,$3C	;8

;misc
db $3D,$3E,$3F,$80,$80,$2A,$2B,$2C	;9
db $2D	;10

;big/fire mario
db $40,$41,$42,$43,$44,$45,$46,$47	;1
db $48,$49,$4A,$4B,$4C,$4D,$4E,$4F	;2
db $50,$51,$52,$53,$54,$55,$56,$57	;3
db $58,$59,$5A,$5B,$5C,$5D,$5E,$5F	;4
db $60,$61,$62,$63,$64,$65,$66,$67	;5
db $68,$69,$6A,$6B,$6C,$6D,$6E,$6F	;6
db $70,$71,$72,$73,$74,$75,$76,$77	;7
db $78,$79,$7A,$7B,$7C	;8

;cape mario
db $40,$41,$42,$43,$44,$45,$46,$47	;1
db $48,$49,$4A,$4B,$4C,$4D,$4E,$4F	;2
db $50,$51,$52,$53,$54,$55,$56,$57	;3
db $58,$59,$5A,$5B,$5C,$5D,$5E,$5F	;4
db $60,$61,$62,$63,$64,$65,$66,$67	;5
db $68,$69,$6A,$6B,$6C,$6D,$6E,$6F	;6
db $70,$71,$72,$73,$74,$75,$76,$77	;7
db $78,$79,$7A,$7B,$7C	;8


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;For Above:
;
;1 - Walking 1/Standing, Walking 2, Walking 3, Looking Up, Running 1, Running 2, Running 3, Carrying Item 1
;
;2 - Carrying Item 2, Carrying Item 3, Looking Up with Item, Jumping, Flying/Taking Off, Skidding, Kicking Item, Going Down Pipe/Turning with Item
;
;3 - About to Run Up Wall, Running Up Wall 1, Running Up Wall 2, Running Up Wall 3, Posing on Yoshi, Climbing, Swimming 1, Swimming with Item 1
;
;4 - Swimming 2, Swimming with Item 2, Swimming 3, Swimming with Item 3, Sliding Downhill, Ducking with Item/Ducking on Yoshi, Punching net, Net Turning 1
;
;5 - Riding Yoshi/Net Turning 2, Turning on Yoshi/Net Turning 3, Climbing Behind, Punching Net Behind, Falling, Spinjump Back (Small Mario)/Brushing 1, Posing, About to use Yoshi Tongue
;
;6 - Use Yoshi Tongue, Unused, Gliding 1, Gliding 2, Gliding 3, Gliding 4, Gliding 5, Gliding 6
;
;7 - Burned (Open eyes), Burned (Closed eyes), Looking at Castle, Looking at Flying Castle 1, Looking at Flying Castle 2, Lean Back with Hammer, Hammer in Mid-Air, Smash Hammer
;
;8 - Brushing 3, Brushing 2, Smash Hammer Again (?), Unused (?), Ducking
;
;9 - Growing/shrinking, Dying, Throwing fireball, Unused (?), Unused (?), Balloon small, Balloon big, Spinjump back
;
;10 - Spinjump front
;
;(Mainly copied the descriptions from Smallhacker's Player Tilemap Editor)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

db $80,$80,$80,$80,$80,$80,$80,$80	;
db $80,$80,$80,$80,$80,$80,$80,$80	;
db $80,$80,$80,$80,$80,$80,$80,$80	;
db $80,$80,$80,$80,$80,$80,$80,$80	;
db $80,$80,$80,$80,$80,$80,$80,$80	;
db $80,$80,$80,$80,$80,$80,$80,$80	;
db $80,$80,$80,$80,$80,$80,$80,$80	;
db $80,$80,$80,$80,$80,$80,$80,$80	; Must always add up to 256 total indexes
.end:
