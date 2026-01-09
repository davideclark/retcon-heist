# The Computer Fair Heist - PunyInform Edition

## Overview

This is a complete port of "The Computer Fair Heist" from Inform 7 to Inform 6 using the PunyInform library, specifically optimized for TRS-80 Model 4 with M4ZVM interpreter.

## Performance Improvements

### File Size Reduction
- **Inform 7 (Z8 format):** 317KB
- **PunyInform (Z3 format):** 34KB
- **Reduction:** 9.3x smaller (89% size reduction)

### Expected Performance Gains
- **Faster text rendering:** Z3 format has minimal overhead for 8-bit systems
- **Reduced memory usage:** Smaller file footprint
- **Optimized for TRS-80:** PunyInform is specifically designed for retro hardware

## Game Features

All core gameplay features from the Inform 7 version have been preserved:

- ✅ 10 interconnected rooms (Computer Fair venue)
- ✅ 15 interactive objects (clues, tools, quest items)
- ✅ 4 NPCs with dialogue (Mike, Dave, Technician, Dodgy Vendor)
- ✅ Complete puzzle chain (toolkit→screwdriver→crate→chip)
- ✅ Scoring system (120 points maximum)
- ✅ Win condition (escape with prototype chip)
- ✅ Time pressure (50-move limit, 35-move thief escape)
- ✅ Save/load functionality (built into Z-machine)

### Features Simplified for Performance
- Score ranks and certificates removed (user accepted trade-off)
- Dynamic room descriptions simplified to static descriptions
- Parser uses PunyInform's standard ASK/TELL/ANSWER system instead of custom TALK verb

## Files

### Source Code
- `computer-fair-heist.inf` - Main Inform 6 source code (521 lines)
- `compile.sh` - Build script for Z3 compilation

### Compiled Output
- `computer-fair-heist.z3` - Compiled game file (34KB)

### Dependencies
- PunyInform library (automatically installed with Inform 6 via Homebrew)
- Inform 6 compiler v6.42 (installed via Homebrew)

## Building

To compile the game:

```bash
cd /Users/davidclark/Documents/TRS/trs80-game/punyinform
./compile.sh
```

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

### Key Inform 6 Differences from Inform 7

1. **Syntax:** C-like procedural instead of natural language
2. **Objects:** Explicit property and attribute declarations
3. **Actions:** Handled in `before`/`after`/`life` routines
4. **NPCs:** Use Answer/Ask/Tell instead of Talk
5. **Attributes:** No `takeable` attribute (items are takeable by default unless `static`)

## Game Structure

### Rooms (10 locations)
1. Entrance Hall
2. Security Checkpoint (exit point)
3. Main Exhibition Hall
4. Demo Area
5. Vendor Stall 1 (dodgy vendor location)
6. Vendor Stall 2
7. Storage Room (prototype location)
8. Cafeteria (Mike's location)
9. Toilets (toolkit location)
10. Back Office (security pass location)

### Puzzle Solution Path
1. Talk to Mike in Cafeteria → learn about storage room
2. Talk to Dave in Exhibition Hall → learn about dodgy vendor
3. Search stacked boxes in Vendor Stall 2 → find office key
4. Get toolkit from Toilets → get screwdriver inside
5. Use office key to unlock staff door → access Back Office
6. Get security pass from Back Office
7. Use screwdriver to open urgent crate in Storage Room → get prototype chip
8. Go north from Security Checkpoint with chip → WIN!

### Scoring Breakdown
- Talk to Mike: +5 points
- Talk to Dave: +10 points
- Examine napkin: +5 points
- Find office key in boxes: +10 points
- Take show badge: +10 points
- Take toolkit: +10 points
- Open toolkit (get screwdriver): +10 points
- Take screwdriver: +10 points
- Take office key: +10 points
- Take security pass: +20 points
- Take prototype chip: +30 points
- **Maximum:** 120 points

## Development Notes

### Porting Process
The game was manually ported from Inform 7 to Inform 6/PunyInform to solve performance issues on the TRS-80. Key changes:

1. **Converted natural language to procedural code**
   - Inform 7's declarative style → Inform 6's imperative style
   - Example: "The badge is in the hall" → `Object show_badge "show badge" Entrance_Hall`

2. **Simplified parser interaction**
   - Custom TALK verb → Standard ASK/TELL/ANSWER
   - Maintained game functionality while using library verbs

3. **Optimized object structure**
   - Limited name properties to 4 words (Z3 constraint)
   - Used `concealed` attribute for hidden objects
   - Removed unnecessary attributes

4. **Streamlined time mechanics**
   - Implemented via `each_turn` property on daemon object
   - Checks turn count every turn for time limits

### Compatibility
- **TRS-80 Models:** Model 4 with 128KB RAM
- **Interpreter:** M4ZVM (Z-machine for TRS-80)
- **Operating System:** LS-DOS 6.3.x or TRSDOS 6.x
- **Storage:** Works with Gotek floppy emulator

## Credits

- **Game Design & Story:** David and Nigel Clark
- **Inform 7 Version:** Original implementation
- **PunyInform Port:** Conversion to Inform 6 for TRS-80 optimization
- **Library:** PunyInform by Johan Berntsson
- **Compiler:** Inform 6 by Graham Nelson

## Version History

### Version 1.0 (2025-12-28)
- Initial PunyInform port from Inform 7
- File size reduced from 317KB to 34KB (9.3x reduction)
- All core gameplay features preserved
- Optimized for TRS-80 Model 4 with M4ZVM

## License

The game content and story are copyright David and Nigel Clark, 2025.
The PunyInform library is licensed under the Artistic License 2.0.

## Support

For issues with:
- **Game content/bugs:** Contact the authors
- **PunyInform library:** https://github.com/johanberntsson/PunyInform
- **M4ZVM interpreter:** https://intfiction.org/t/m4zvm-a-new-modern-z-machine-for-the-trs-80-model-4/54896

---

**Enjoy your heist at the 1983 Computer Fair!**
