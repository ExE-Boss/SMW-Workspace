32×32 Player Tilemap patch by Ladida
====================================

- `32x32_tilemap.cfg`	(The configuration file, contains defines which allow for easy configuration of the patch)
- `32x32_tilemap.asm`	(the main patch. includes `excharactertilemap.asm`, `hexedits.asm`, and `PlayerGFX.bin`)
- `ow_mario.asm`	(Fixes player’s walking upward and swimming upward frame on the OW, can be applied separately)
- `excharactertilemap.asm`	(player tilemap. dont edit unless you want to change/create frames)
- `hexedits.asm`	(modifies some necessary ROM tables)
- `PlayerGFX.bin`	(the player GFX. this is what you edit if you want to change player GFX)
- `readme.txt`	(some mysterious file)
- `misc_gfx/*.bin`	(replaces your current ones. optional but useful; nulls unused tiles)

unlike the previous version of the patch, this version stores all of the player GFX into one
file rather than splitting it in half. It’s also a lot easier to visualize and edit.
see the included image for what values to use in `excharactertilemap.asm` (if needed)

Note that `GFX32` is not used EXCEPT for the cape’s frames and the berry animation, as well as some
Mario frames that are for LM display ONLY (modifying them only affects Mario in LM)

Have fun :>

ExE Boss’s Changes
------------------

- Expanded the maximum size of `PlayerGFX.bin` to 128KiB (256 frames) from 64KiB (128 frames),
  do note that tile `$80` is unusable by default because it is overwritten by the second `RATS` tag.
- Extracted configuration to `32x32_tilemap.cfg`.
- `ow_mario.asm` is now applied automatically when patching `32x32_tilemap.asm`, but can still be applied separately.
- Split `AllGFX.bin` into component files and added pre-converted Icegoom’s SMW Redrawn graphics.
