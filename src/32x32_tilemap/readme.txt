32x32 Player Tilemap patch.
- By Ladida


32x32_tilemap.asm	(the main patch. includes excharactertilemap.asm, hexedits.asm, and PlayerGFX.bin)
excharactertilemap.asm	(player tilemap. dont edit unless you want to change/create frames)
hexedits.asm		(modifies some necessary ROM tables)
ow_mario.asm		(Fixes player's walking upward and swimming upward frame on the OW)
PlayerGFX.bin		(the player GFX. this is what you edit if you want to change player GFX)
AllGFX.bin		(replaces your current one. optional but useful; nulls unused tiles)
readme.txt		(some mysterious file)

unlike the previous version of the patch, this version stores all of the player GFX into one
file rather than splitting it in half. It's also a lot easier to visualize and edit.
see the included image for what values to use in excharactertilemap.asm (if needed)

Note that GFX32 is not used EXCEPT for the cape's frames and the berry animation, as well as some
Mario frames that are for LM display ONLY (modifying them only affects Mario in LM)



Have fun :>