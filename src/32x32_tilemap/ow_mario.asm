;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Easier OW Mario Change
;
;what this patch does is easliy edit OW Mario's palette and tiles
;(the Mario you control and walk around with)
;without making a bunch of hex edits.
;
;I also included Yoshi stuff, so you can edit his tiles and palette (meh)
;
;No freespace required
;
;
;by Ladida
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

incsrc 32x32_tilemap.cfg
incsrc ../shared/shared.asm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Everything below this can be edited
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

!mario	= $20|((!ow_mario_palette&$7)<<1)	; palette value for Mario
!mariox	= $60|((!ow_mario_palette&$7)<<1)	; palette value for X-flipped Mario


;below are the palette values of the 'in water' tiles

!water	= $24	; palette value for water tile
!waterx	= $64	; palette value for x-flipped water tile


;below are Yoshi's tiles and palette

!yoshi	= $22	; palette value for Blue Yoshi
!yoshix	= $62	; palette value for x-flipped Blue Yoshi


;the above values must be in YXPPCCCT format



;all values below are Mario's tiles. each 4 entries are one frame, and each are one 8x8 tile.
;the entries go like this: 1st = top left 8x8 tile, 2nd = bottom left 8x8 tile,
;3rd = top right 8x8 tile, 4th = bottom right 8x8 tile.

!walkl2ul	= $06
!walkl2dl	= $16	; this is the frame for walking left
!walkl2ur	= $07
!walkl2dr	= $17

!walklul	= $08
!walkldl	= $18	; this is the frame for walking left, but not moving legs
!walklur	= $09
!walkldr	= $19

!walkr2ul	= $06
!walkr2dl	= $16	; this is the frame for walking right
!walkr2ur	= $07
!walkr2dr	= $17

!walkrul	= $08
!walkrdl	= $18	; this is the frame for walking right, but not moving legs
!walkrur	= $09
!walkrdr	= $19

!standful	= $0A
!standfdl	= $1A	; this frame is facing towards the screen
!standfur	= $0B
!standfdr	= $1B

!standf2ul	= $0C
!standf2dl	= $1C	; this frame is walking towards the screen
!standf2ur	= $0D
!standf2dr	= $1D

!walkbul	= $0E
!walkbdl	= $1E	; this frame is facing away from the screen
!walkbur	= $0F
!walkbdr	= $1F

!walkb2ul	= $4C
!walkb2dl	= $5C	; this frame is walking away from the screen
!walkb2ur	= $4D
!walkb2dr	= $5D

!enterul	= $24
!enterdl	= $34	; this frame is when you enter a level
!enterur	= $25
!enterdr	= $35

!climbul	= $46
!climbdl	= $56	; this frame is when you are climbing a ladder/vine/whatever
!climbur	= $47
!climbdr	= $57

!climb2ul	= $46
!climb2dl	= $56	; this frame is when you are climbing a ladder/vine/whatever (can use for 2nd frame)
!climb2ur	= $47
!climb2dr	= $57

!ridelul	= $64
!rideldl	= $74	; this frame is riding Yoshi, left
!ridelur	= $65
!rideldr	= $75

!riderul	= $64
!riderdl	= $74	; this frame is riding Yoshi, right
!riderur	= $65
!riderdr	= $75

!ridebul	= $66
!ridebdl	= $76	; this frame is riding Yoshi, going away from the screen
!ridebur	= $67
!ridebdr	= $77

!rideful	= $0A
!ridefdl	= $1A	; this frame is riding Yoshi, facing the screen
!ridefur	= $0B
!ridefdr	= $1B

!wadel2ul	= $06
!wadel2ur	= $07	; this is the frame for swimming left, 2nd frame

!wadelul	= $08
!wadelur	= $09	; this is the frame for swimming left

!wader2ul	= $06
!wader2ur	= $07	; this is the frame for swimming right, 2nd frame

!waderul	= $08
!waderur	= $09	; this is the frame for swimming right

!wadeful	= $0A
!wadefur	= $0B	; this frame is swimming towards the screen, stationary

!wadef2ul	= $0C
!wadef2ur	= $0D	; this frame is swimming towards the screen, 2nd frame

!wadebul	= $0E
!wadebur	= $0F	; this frame is swimming away from the screen

!wadeb2ul	= $4C
!wadeb2ur	= $4D	; this frame is swimming away from the screen, 2nd frame



;below are the tile numbers for the 'in water' tiles

!water1	= $38	; this is the 'in water' tile
!water2	= $39	; this is the second frame of the 'in water' tile



;below are the tile numbers for Yoshi

!yoshiful	= $2E
!yoshifdl	= $3E	; this frame is Yoshi facing towards the screen
!yoshifur	= $2F
!yoshifdr	= $3F

!yoshif2ul	= $2E
!yoshif2dl	= $3E	; this frame is Yoshi facing towards the screen, 2nd frame
!yoshif2ur	= $2F
!yoshif2dr	= $3F

!yoshibul	= $2E
!yoshibdl	= $3E	; this frame is Yoshi walking away from the screen
!yoshibur	= $2F
!yoshibdr	= $3F

!yoshib2ul	= $2E
!yoshib2dl	= $3E	; this frame is Yoshi walking away from the screen, 2nd frame
!yoshib2ur	= $2F
!yoshib2dr	= $3F

!yoshil2ul	= $40
!yoshil2dl	= $50	; this frame is Yoshi walking left
!yoshil2ur	= $41
!yoshil2dr	= $51

!yoshilul	= $42
!yoshildl	= $52	; this frame is Yoshi walking left, not moving legs
!yoshilur	= $43
!yoshildr	= $53

!yoshir2ul	= $40
!yoshir2dl	= $50	; this frame is Yoshi walking right
!yoshir2ur	= $41
!yoshir2dr	= $51

!yoshirul	= $42
!yoshirdl	= $52	; this frame is Yoshi walking right, not moving legs
!yoshirur	= $43
!yoshirdr	= $53



;!!!!!!!!!!!!!!!WARNING!!!!!!!!!!!!!!
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;Actual data below, I advise you
;not touch it unless you know what
;you are doing.
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;!!!!!!!!!!!!!!!GNINRAW!!!!!!!!!!!!!!


org remap_rom($0487CB)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Walking away from screen
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

db !walkbul,!mario,!walkbur,!mario,!walkbdl,!mario,!walkbdr,!mario
db !walkb2ul,!mario,!walkb2ur,!mario,!walkb2dl,!mario,!walkb2dr,!mario
db !walkbul,!mario,!walkbur,!mario,!walkbdl,!mario,!walkbdr,!mario
db !walkb2ul,!mario,!walkb2ur,!mario,!walkb2dr,!mariox,!walkb2dl,!mariox

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Walking towards screen/ standing
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

db !standful,!mario,!standfur,!mario,!standfdl,!mario,!standfdr,!mario
db !standf2ul,!mario,!standf2ur,!mario,!standf2dl,!mario,!standf2dr,!mario
db !standful,!mario,!standfur,!mario,!standfdl,!mario,!standfdr,!mario
db !standf2ul,!mario,!standf2ur,!mario,!standf2dr,!mariox,!standf2dl,!mariox

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Walking left
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

db !walklul,!mario,!walklur,!mario,!walkldl,!mario,!walkldr,!mario
db !walkl2ul,!mario,!walkl2ur,!mario,!walkl2dl,!mario,!walkl2dr,!mario
db !walklul,!mario,!walklur,!mario,!walkldl,!mario,!walkldr,!mario
db !walkl2ul,!mario,!walkl2ur,!mario,!walkl2dl,!mario,!walkl2dr,!mario

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Walking right
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

db !walkrur,!mariox,!walkrul,!mariox,!walkrdr,!mariox,!walkrdl,!mariox
db !walkr2ur,!mariox,!walkr2ul,!mariox,!walkr2dr,!mariox,!walkr2dl,!mariox
db !walkrur,!mariox,!walkrul,!mariox,!walkrdr,!mariox,!walkrdl,!mariox
db !walkr2ur,!mariox,!walkr2ul,!mariox,!walkr2dr,!mariox,!walkr2dl,!mariox

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Swimming away from screen
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

db !wadebul,!mario,!wadebur,!mario,!water1,!water,!water1,!waterx
db !wadeb2ul,!mario,!wadeb2ur,!mario,!water2,!water,!water2,!waterx
db !wadebul,!mario,!wadebur,!mario,!water1,!water,!water1,!waterx
db !wadeb2ul,!mario,!wadeb2ur,!mario,!water2,!water,!water2,!waterx

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Swimming towards screen/ wading
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

db !wadeful,!mario,!wadefur,!mario,!water1,!water,!water1,!waterx
db !wadef2ul,!mario,!wadef2ur,!mario,!water2,!water,!water2,!waterx
db !wadeful,!mario,!wadefur,!mario,!water1,!water,!water1,!waterx
db !wadef2ul,!mario,!wadef2ur,!mario,!water2,!water,!water2,!waterx

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Swimming left
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

db !wadelul,!mario,!wadelur,!mario,!water1,!water,!water1,!waterx
db !wadel2ul,!mario,!wadel2ur,!mario,!water2,!water,!water2,!waterx
db !wadelul,!mario,!wadelur,!mario,!water1,!water,!water1,!waterx
db !wadel2ul,!mario,!wadel2ur,!mario,!water2,!water,!water2,!waterx

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Swimming right
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

db !waderur,!mariox,!waderul,!mariox,!water1,!water,!water1,!waterx
db !wader2ur,!mariox,!wader2ul,!mariox,!water2,!water,!water2,!waterx
db !waderur,!mariox,!waderul,!mariox,!water1,!water,!water1,!waterx
db !wader2ur,!mariox,!wader2ul,!mariox,!water2,!water,!water2,!waterx

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Entering level
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

db !enterul,!mario,!enterur,!mario,!enterdl,!mario,!enterdr,!mario
db !enterul,!mario,!enterur,!mario,!enterdl,!mario,!enterdr,!mario
db !enterul,!mario,!enterur,!mario,!enterdl,!mario,!enterdr,!mario
db !enterul,!mario,!enterur,!mario,!enterdl,!mario,!enterdr,!mario

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Entering level, in water
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

db !enterul,!mario,!enterur,!mario,!water1,!water,!water1,!waterx
db !enterul,!mario,!enterur,!mario,!water1,!water,!water1,!waterx
db !enterul,!mario,!enterur,!mario,!water1,!water,!water1,!waterx
db !enterul,!mario,!enterur,!mario,!water1,!water,!water1,!waterx

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Climbing
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

db !climbul,!mario,!climbur,!mario,!climbdl,!mario,!climbdr,!mario
db !climb2ur,!mariox,!climb2ul,!mariox,!climb2dr,!mariox,!climb2dl,!mariox
db !climbul,!mario,!climbur,!mario,!climbdl,!mario,!climbdr,!mario
db !climb2ur,!mariox,!climb2ul,!mariox,!climb2dr,!mariox,!climb2dl,!mariox
db !climbul,!mario,!climbur,!mario,!climbdl,!mario,!climbdr,!mario
db !climb2ur,!mariox,!climb2ul,!mariox,!climb2dr,!mariox,!climb2dl,!mariox
db !climbul,!mario,!climbur,!mario,!climbdl,!mario,!climbdr,!mario
db !climb2ur,!mariox,!climb2ul,!mariox,!climb2dr,!mariox,!climb2dl,!mariox


;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;Below are the Yoshi frames and the Mario riding Yoshi frames
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


org remap_rom($0489DE)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Riding Yoshi away from the screen
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

db !ridebul,!mario,!ridebur,!mario,!ridebdl,!mario,!ridebdr,!mario
db !yoshib2ur,!yoshix,!yoshib2ul,!yoshix,!yoshib2dr,!yoshix,!yoshib2dl,!yoshix
db !ridebul,!mario,!ridebur,!mario,!ridebdl,!mario,!ridebdr,!mario
db !yoshibul,!yoshi,!yoshibur,!yoshi,!yoshibdl,!yoshi,!yoshibdr,!yoshi

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Riding Yoshi towards the screen
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

db !yoshif2ur,!yoshix,!yoshif2ul,!yoshix,!yoshif2dr,!yoshix,!yoshif2dl,!yoshix
db !rideful,!mario,!ridefur,!mario,!ridefdl,!mario,!ridefdr,!mario
db !yoshiful,!yoshi,!yoshifur,!yoshi,!yoshifdl,!yoshi,!yoshifdr,!yoshi
db !rideful,!mario,!ridefur,!mario,!ridefdl,!mario,!ridefdr,!mario

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Riding Yoshi to the left
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

db !ridelul,!mario,!ridelur,!mario,!rideldl,!mario,!rideldr,!mario
db !yoshil2ul,!yoshi,!yoshil2ur,!yoshi,!yoshil2dl,!yoshi,!yoshil2dr,!yoshi
db !ridelul,!mario,!ridelur,!mario,!rideldl,!mario,!rideldr,!mario
db !yoshilul,!yoshi,!yoshilur,!yoshi,!yoshildl,!yoshi,!yoshildr,!yoshi

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Riding Yoshi to the right
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

db !riderur,!mariox,!riderul,!mariox,!riderdr,!mariox,!riderdl,!mariox
db !yoshir2ur,!yoshix,!yoshir2ul,!yoshix,!yoshir2dr,!yoshix,!yoshir2dl,!yoshix
db !riderur,!mariox,!riderul,!mariox,!riderdr,!mariox,!riderdl,!mariox
db !yoshirur,!yoshix,!yoshirul,!yoshix,!yoshirdr,!yoshix,!yoshirdl,!yoshix

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Seems to be Riding Yoshi away from screen in Water
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

db !water1,!water,!water1,!waterx,!ridebul,!mario,!ridebur,!mario
db !ridebdl,!mario,!ridebdr,!mario,$FF,$FF,$FF,$FF
db !water2,!water,!water2,!waterx,!ridebul,!mario,!ridebur,!mario
db !ridebdl,!mario,!ridebdr,!mario,$FF,$FF,$FF,$FF

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Riding Yoshi towards screen in Water
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

db !water1,!water,!water1,!waterx,!yoshif2ur,!yoshix,!yoshif2ul,!yoshix
db !rideful,!mario,!ridefur,!mario,!ridefdl,!mario,!ridefdr,!mario
db !water2,!water,!water2,!waterx,!yoshiful,!yoshi,!yoshifur,!yoshi
db !rideful,!mario,!ridefur,!mario,!ridefdl,!mario,!ridefdr,!mario

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Riding Yoshi to the left in Water
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

db !water1,!water,!water1,!waterx,!ridelul,!mario,!ridelur,!mario
db !rideldl,!mario,!rideldr,!mario,!yoshil2ul,!yoshi,!yoshil2ur,!yoshi
db !water2,!water,!water2,!waterx,!ridelul,!mario,!ridelur,!mario
db !rideldl,!mario,!rideldr,!mario,!yoshilul,!yoshi,!yoshilur,!yoshi

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Riding Yoshi to the right in Water
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

db !water1,!water,!water1,!waterx,!riderur,!mariox,!riderul,!mariox
db !riderdr,!mariox,!riderdl,!mariox,!yoshir2ur,!yoshix,!yoshir2ul,!yoshix
db !water2,!water,!water2,!waterx,!riderur,!mariox,!riderul,!mariox
db !riderdr,!mariox,!riderdl,!mariox,!yoshirur,!yoshix,!yoshirul,!yoshix

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Entering a level on Yoshi
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

db !yoshif2ur,!yoshix,!yoshif2ul,!yoshix,!yoshif2dr,!yoshix,!yoshif2dl,!yoshix
db !enterul,!mario,!enterur,!mario,!enterdl,!mario,!enterdr,!mario
db !yoshiful,!yoshi,!yoshifur,!yoshi,!yoshifdl,!yoshi,!yoshifdr,!yoshi
db !enterul,!mario,!enterur,!mario,!enterdl,!mario,!enterdr,!mario

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Entering a level on Yoshi, in Water
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

db !water1,!water,!water1,!waterx,!yoshif2ur,!yoshix,!yoshif2ul,!yoshix
db !enterul,!mario,!enterur,!mario,!enterdl,!mario,!enterdr,!mario
db !water2,!water,!water2,!waterx,!yoshiful,!yoshi,!yoshifur,!yoshi
db !enterul,!mario,!enterur,!mario,!enterdl,!mario,!enterdr,!mario

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Climbing with Yoshi
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

db !ridebul,!mario,!ridebur,!mario,!ridebdl,!mario,!ridebdr,!mario
db !yoshib2ur,!yoshix,!yoshib2ul,!yoshix,!yoshib2dr,!yoshix,!yoshib2dl,!yoshix
db !ridebul,!mario,!ridebur,!mario,!ridebdl,!mario,!ridebdr,!mario
db !yoshibul,!yoshi,!yoshibur,!yoshi,!yoshibdl,!yoshi,!yoshibdr,!yoshi
db !ridebul,!mario,!ridebur,!mario,!ridebdl,!mario,!ridebdr,!mario
db !yoshib2ur,!yoshix,!yoshib2ul,!yoshix,!yoshib2dr,!yoshix,!yoshib2dl,!yoshix
db !ridebul,!mario,!ridebur,!mario,!ridebdl,!mario,!ridebdr,!mario
db !yoshibul,!yoshi,!yoshibur,!yoshi,!yoshibdl,!yoshi,!yoshibdr,!yoshi


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;END OF EXTREMELY LONG AND BORING STUFF THAT I HAD TO DISASSEMBLE AND COMMENT D:
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
