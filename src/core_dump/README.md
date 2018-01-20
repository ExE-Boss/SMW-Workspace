SMW Core Dump Patch
===================

This patch provides a much more helpful crash screen.

Known Issues
------------

- The ROM freezes when a `BRK` instruction is executed by the SA-1 processor.
  This is caused by the `$0FF900` GFX decompression routine not working when
  called from the SA-1 side because it calls SNES only code.
