# The Computer Fair Heist

## Overview

This is a text adventure game specifically optimized for TRS-80 Model 4 mobile.
It was developed with goal of being used at the Greenford Computer Club Retcon 2026 show.
It runs using the M4ZVM interpreter which is available for the TS80 and other 8 bit computers.

## Game Features

- ✅ 10 interconnected rooms (Computer Fair venue)
- ✅ 25 NPCs including 23 club members participating in the raffle
- ✅ Interactive objects (clues, tools, quest items)
- ✅ Complete puzzle chain leading to recovery of stolen Spectrum Next
- ✅ Scoring system (105 points maximum)
- ✅ Random raffle winner selection
- ✅ Win condition (recover the grand prize and complete the raffle)
- ✅ Save/load functionality

### Source Code
- `computer-fair-heist.inf` - Main Inform 6 source code (577 lines)
- `compile.sh` - Build script for Mac/Linux
- `compile.bat` - Build script for Windows

### Compiled Output
- `heist28.z3` - Compiled game file (~49KB)

## Dependencies

### Required Software

**Inform 6 Compiler:**
- **Windows:** Download from [IF Archive - Inform 6 Executables](https://ifarchive.org/indexes/if-archive/infocom/compilers/inform6/executables/)
  - Get `inform644_win32.zip`
  - Extract and place `inform6.exe` in your PATH (e.g., `C:\Windows\System32`)
- **Mac:** `brew install inform6`
- **Linux:** Available via package managers or compile from [source](https://github.com/DavidKinder/Inform6)

**PunyInform Library:**
- Download from [PunyInform Releases](https://github.com/johanberntsson/PunyInform/releases)
- **Windows:** Extract to `C:\Program Files (x86)\PunyInform-6_3_1\`
- **Mac/Linux:** Automatically included with Homebrew's inform6 package

**Z-Machine Interpreter (for testing):**
- **Windows:** Download [Windows Frotz](https://ifarchive.org/indexes/if-archive/infocom/interpreters/frotz/)
  - Get `WindowsFrotzSrc.zip` (includes compiled Frotz.exe)
  - Extract to `C:\Program Files (x86)\WindowsFrotz\`
  - Add to PATH for command-line use
- **Mac:** `brew install frotz`
- **Linux:** `apt-get install frotz` or equivalent

## Building

### On Windows

```batch
compile.bat
```

This will create `heist28.z3` in the current directory.

**Note:** If you change the BUILD_NUMBER in `computer-fair-heist.inf`, update the VERSION variable on line 10 of `compile.bat` to match.

### On Mac/Linux

```bash
./compile.sh
```

This will create `heist28.z3` in the current directory.

## Testing

### On Windows (using Windows Frotz)

```batch
Frotz.exe heist28.z3
```

Or double-click `heist28.z3` if you've associated .z3 files with Frotz.

### On Mac/Linux (using frotz)

```bash
frotz heist28.z3
```

### On TRS-80 (using M4ZVM)

1. Copy `heist28.z3` to a TRS-80 disk image
2. Boot the TRS-80 with M4ZVM Trinity boot disk
3. Use the IMPORT2 command to load the game:
   ```
   IMPORT2 HEIST28/Z3 :1
   ```
4. Run M4ZVM64/CMD or M4ZVM/CMD
5. Type the filename: `HEIST28`

## Technical Details

### Z-Machine Version
- **Format:** Z-code Version 3
- **Max story file size:** 128KB
- **Actual size:** ~49KB
- **Headroom:** ~79KB available

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
