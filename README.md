# The Computer Fair Heist

## Overview

This is a text adventure game specifically optimized for TRS-80 Model 4 mobile.
It was developed with goal of being used at the Greenford Computer Club Retcon 2026 show.
It runs using the M4ZVM interpreter which is available for the TS80 and other 8 bit computers.

## Game Features

- ✅ 10 interconnected rooms (Computer Fair venue)
- ✅ 15 interactive objects (clues, tools, quest items)
- ✅ 4 NPCs with dialogue (Mike, Dave, Technician, Dodgy Vendor)
- ✅ Complete puzzle chain (toolkit→screwdriver→crate→chip)
- ✅ Scoring system (120 points maximum)
- ✅ Win condition (escape with prototype chip)
- ✅ Time pressure (50-move limit, 35-move thief escape)
- ✅ Save/load functionality

### Source Code
- `computer-fair-heist.inf` - Main Inform 6 source code (521 lines)
- `compile.sh` - Build script for Z3 compilation

### Compiled Output
- `computer-fair-heist.z3` - Compiled game file (34KB)

### Dependencies

- PunyInform library 

## Building

To compile the game

./compile.sh

This will create `computer-fair-heist.z3` in the current directory.

## Testing

### On Mac (using frotz)

```bash
frotz computer-fair-heist.z3
```

### On TRS-80 (using M4ZVM)

1. Copy `computer-fair-heist.z3` to a TRS-80 disk image
2. Boot the TRS-80 with M4ZVM Trinity boot disk
3. Use the IMPORT2 command to load the game:
   ```
   IMPORT2 COMPUTER-FAIR-HEIST/Z3 :1
   ```
4. Run M4ZVM64/CMD or M4ZVM/CMD
5. Type the filename: `COMPUTER-FAIR-HEIST`

## Technical Details

### Z-Machine Version
- **Format:** Z-code Version 3
- **Max story file size:** 128KB
- **Actual size:** 34KB
- **Headroom:** 94KB available

### Compiler Options Used
```inform6
!% -~S                      ! Disable strict error checking (saves ~10KB)
!% $OMIT_UNUSED_ROUTINES=1  ! Remove unused routines
!% $ZCODE_LESS_DICT_DATA=1  ! Remove empty data bytes from dictionary
!% $LONG_DICT_FLAG_BUG=0    ! Enable plural flag bug fix
```

## Game Structure

See [GAME_STRUCTURE.md](GAME_STRUCTURE.md) for detailed information about rooms, puzzle solutions, and scoring.

## Development Notes

### Compatibility
- **TRS-80 Models:** Model 4 with 128KB RAM
- **Interpreter:** M4ZVM (Z-machine for TRS-80)
- **Operating System:** LS-DOS 6.3.x or TRSDOS 6.x
- **Storage:** Works with Gotek floppy emulator

## Credits

- **Game Design & Story:** David and Nigel Clark
- **Library:** PunyInform by Johan Berntsson
- **Compiler:** Inform 6 by Graham Nelson

## Version History


## License

The game content and story are copyright David and Nigel Clark, 2025.
The PunyInform library is licensed under the Artistic License 2.0.

## Support

For issues with:
- **Game content/bugs:** Contact the authors
- **PunyInform library:** https://github.com/johanberntsson/PunyInform
- **M4ZVM interpreter:** https://intfiction.org/t/m4zvm-a-new-modern-z-machine-for-the-trs-80-model-4/54896

---

**Enjoy your heist at the 2025 Computer Fair!**
