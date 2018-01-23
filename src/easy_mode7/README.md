Easy Mode 7 Patch
=================

When you try to use Mode 7 in the original SMW, you can't properly use its registers unless you store $C1 to $7E:0D9B to activate Bowser's battle mode. The problem, in this case, is that part of the Mode 7 tilemap is reserved to Bowser and thus is always filled with undesired tiles which are impossible to get rid of.

The earlier version of this patch, entirely made by HuFlungDu, corrected this aspect but caused the Mode 7 image to act like Iggy/Larry's platform and some sprite tiles to appear.

The version you can download here has been corrected with SA-1 compatibility and 2 tweaks to disable 1) Iggy/Larry's platform rotation 2) Iggy/Larry's animated lava sprite tiles.

This patch has some weird compatibility with the original Mode 7 bosses, so be cautious:
- It is fully compatible with Reznor and Ludwig
- It is compatible with Bowser, Roy and Morton only if you enter their rooms without having used custom Mode 7 before in the current level
(ex: it's okay to enter level 105 from the OW then fight Morton, but it's not to enter level 105, go to a level when you use custom Mode 7 then fight morton)
- It is not compatible with Iggy & Larry as it makes their battles either bland or unplayable depending on what angle Mode 7 image has been set to before.

An example code to enter Mode 7 and upload your own image is included.

Future plans:
- full compatibility with the original game's Mode 7 bosses.
- create a routine to upload your own image with a simple JSL 
