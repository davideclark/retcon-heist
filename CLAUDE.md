# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is "The Retcon Heist", a text adventure game written in Inform 6 using the PunyInform library, specifically optimized for the TRS-80 Model 4 using the M4ZVM Z-machine interpreter.

**Key Context:** This is a retro computing project targeting 1980s hardware constraints. The game compiles to Z-code version 3 (Z3). Players must recover a stolen Spectrum Next grand prize before the club raffle begins, featuring 25 NPCs and a random raffle winner system. Current build size: ~49KB.

## Build Commands

### Compile the game

**Windows:**
```batch
compile.bat
```
Note: Update VERSION variable in compile.bat when BUILD_NUMBER changes in .inf file.

**Mac/Linux:**
```bash
./compile.sh
```
The script uses the punyinform wrapper from Homebrew which automatically sets up correct library paths.

Both scripts build `heist{VERSION}.z3` (currently heist28.z3).

### Test locally

**Windows:**
```batch
Frotz.exe heist28.z3
```

**Mac/Linux:**
```bash
frotz heist28.z3
```

### Deploy to TRS-80
```bash
cp heist28.z3 ../gotek-disks/
```

## Architecture

### Language: Inform 6
This is **procedural C-like code**, NOT natural language like Inform 7. Key characteristics:

- Objects declared with `Object name "description" location`
- Properties defined with `with` clauses
- Actions handled in `before`, `after`, `life` routines
- Attributes (flags) set with `has` keyword
- Global variables declared with `Global` keyword

### Library: PunyInform
A lightweight Inform 6 library optimized for 8-bit systems. Included via `Include "puny.h"`.

**Critical differences from standard Inform 6:**
- Minimal memory footprint
- Simplified parser
- Optimized for Z3 format (128KB max story file)
- Uses standard Z-machine save/restore (no custom implementation needed)

### Compiler Directives
Located at top of `.inf` file:
```inform6
!% -~S                      ! Disable strict error checking
!% $OMIT_UNUSED_ROUTINES=1  ! Remove unused routines
!% $ZCODE_LESS_DICT_DATA=1  ! Remove empty dictionary bytes
!% $LONG_DICT_FLAG_BUG=0    ! Enable plural flag bug fix
```

These optimize for size while maintaining Z3 compatibility.

### Game Structure

**10 Rooms:** Entrance_Hall, Presentation_Room, Exhibition_Hall, Demo_Area, Vendor_Stall_1, Vendor_Stall_2, Storage_Room, Cafeteria, Toilets, Back_Office

**25 NPCs:**
- **Main NPCs:** Steve (organizer), Mike, Dave, Technician, Dodgy Vendor
- **Club Members (23 total):** Adam, Adrian, Alan, Andrew, Ben, Carlo, Chris Green, Chris NS, Ed, Fasih, Gary, Gordon, Mark, Martin, Martyn, Michael, Mike, Muzaffer, Neil, Nigel, Rob, Dave, Steve
- All NPCs use `life` property to handle Answer/Ask/Tell/Show/Give actions
- Must have `animate talkable` attributes
- Club members participate in random raffle draw at game end

**Quest Items:** show_badge, spectrum_next, toolkit, screwdriver, office_key, coffee (optional bonus)

**Scenery/Containers:** phone, safe, urgent_crate (prize_crate), stacked_boxes, staff_door, napkin, catalogue, pricelist, manifest

### Game Mechanics

**Time Limits (computer-fair-heist.inf:1644-1666):**
Implemented via `timer_daemon` object with `each_turn` property:
- 50-move hard limit (game over)
- 35-move thief escape (if spectrum_next not recovered from Storage_Room)

**Scoring (MAX_SCORE = 105):**
Points awarded via `after` routines when objects taken/examined for first time. Uses `moved` attribute to track if item scored.
- Talking to NPCs: 5-10 points
- Finding/taking quest items: 10-30 points
- Spectrum Next recovery: 30 points (biggest score)
- Optional coffee bonus: 5 points

**Raffle System (computer-fair-heist.inf:55-83):**
`RandomClubMember()` function selects winner from all 23 club members. Winner is chosen when player gives spectrum_next to Steve in Presentation_Room.

**Victory Condition (computer-fair-heist.inf:149-163):**
In Presentation_Room's `n_to` property: checks if `raffle_completed`. Player must:
1. Recover spectrum_next from Storage_Room
2. Enter Presentation_Room (triggers Steve + NPCs to move there)
3. Give spectrum_next to Steve (triggers raffle)
4. Exit north from Presentation_Room
Sets `deadflag = 2` for victory, `deadflag = 1` for defeat.

### Key Inform 6 Patterns

**Hidden Objects:**
Use `concealed` attribute (e.g., office_key). Revealed via Search action removing attribute.

**Locked Doors:**
Directional property returns function checking condition:
```inform6
s_to [;
  if (office_unlocked) return Back_Office;
  print "The door is locked.^";
  return false;
];
```

**Container Interactions:**
`urgent_crate` (prize_crate) requires screwdriver to open. Check in `before Open` routine, spawn spectrum_next when opened.

**NPC Dialogue:**
NPCs respond in `life` property to Answer/Ask/Tell actions. Track conversation state with globals (mike_talked, dave_talked). Use TALK verb as alias: redirects to Ask action.

**Custom Verbs (computer-fair-heist.inf:1568-1637):**
- USE: redirects to appropriate Open action based on noun/location
- TALK: redirects to Ask action (allows "TALK TO MIKE" as alternative to "ASK MIKE")
- HELP: prints command reference
- DRINK: custom replacement handling coffee consumption with badge check

## Important Constraints

### Z3 Format Limits
- 128KB max story file (currently ~49KB, ~79KB headroom)
- Name properties limited to 4 words
- No Unicode or extended characters
- 255 objects maximum

### TRS-80 Considerations
- Target platform has 128KB RAM
- Uses M4ZVM interpreter (Z-machine implementation for TRS-80)
- Text must render efficiently on 80-column display
- Avoid complex string operations or frequent parsing

## Code Modification Guidelines

### When adding rooms:
```inform6
Object Room_Name "Display Name"
  with description "Room text here.",
       n_to Adjacent_Room,
       s_to Another_Room,
  has light;
```

### When adding objects:
```inform6
Object item_id "display name" Starting_Location
  with name 'word1' 'word2' 'word3',  ! Max 4 words for Z3
       description "Examine text.",
  has [attributes];  ! e.g., concealed, static, openable
```

### When adding NPCs:
```inform6
Object npc_id "NPC Name" Location
  with name 'name',
       description "Appearance.",
       life [;
         Answer, Ask, Tell:
           print "Response text.^";
           return true;
         Show:
           if (noun == specific_object) {
             print "Reaction.^";
             return true;
           }
       ],
  has animate talkable;
```

### Scoring Items:
Add `after` routine checking `moved` attribute:
```inform6
after [;
  Take:
    if (self hasnt moved) {
      score = score + POINTS;
      give self moved;
      print "[*** SCORE +X ***]^";
      return true;
    }
];
```

## Testing Notes

- Test on Mac/Windows with frotz before deploying to TRS-80
- Verify move count doesn't exceed 50 turns for normal playthrough
- Check critical path can be completed in under 35 moves (before thief escapes)
- Ensure all 105 points are achievable
- Test save/restore functionality
- Test random raffle winner selection (should vary between playthroughs)
- Verify all 23 club members can win the raffle

## Dependencies

**Inform 6 compiler:**
- **Windows:** v6.44 - Download from [IF Archive](https://ifarchive.org/indexes/if-archive/infocom/compilers/inform6/executables/) (`inform644_win32.zip`)
- **Mac:** `brew install inform6`

**PunyInform library:**
- **Windows:** Download from [GitHub Releases](https://github.com/johanberntsson/PunyInform/releases), extract to `C:\Program Files (x86)\PunyInform-6_3_1\`
- **Mac/Linux:** Automatically included with inform6 Homebrew package

**Z-machine interpreter (for testing):**
- **Windows:** Windows Frotz - Download from [IF Archive](https://ifarchive.org/indexes/if-archive/infocom/interpreters/frotz/) (`WindowsFrotzSrc.zip`)
- **Mac:** `brew install frotz`

**M4ZVM:** TRS-80 Z-machine interpreter (deployed separately on target hardware)

## File Organization

- `computer-fair-heist.inf` - Main source file (1667 lines)
- `compile.sh` - Build script for Mac/Linux (auto-increments version)
- `compile.bat` - Build script for Windows (VERSION hardcoded, update manually)
- `heist28.z3` - Compiled output (~49KB)
- `README.md` - User documentation with build instructions
- `GAME_STRUCTURE.md` - Detailed game walkthrough, rooms, and scoring
- `CLAUDE.md` - This file - AI assistant guidance
