# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is "The Computer Fair Heist", a text adventure game written in Inform 6 using the PunyInform library. It's a port from Inform 7, specifically optimized for the TRS-80 Model 4 using the M4ZVM Z-machine interpreter.

**Key Context:** This is a retro computing project targeting 1980s hardware constraints. The game compiles to Z-code version 3 (Z3), achieving a 9.3x size reduction from the original Inform 7 version (317KB → 34KB).

## Build Commands

### Compile the game
```bash
./compile.sh
```

This builds `heist{VERSION}.z3` (auto-incremented version numbers). The script uses the punyinform wrapper from Homebrew which automatically sets up correct library paths.

### Test locally
```bash
frotz heist{VERSION}.z3
```

### Deploy to TRS-80
```bash
cp heist{VERSION}.z3 ../gotek-disks/
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

**10 Rooms:** Entrance_Hall, Security_Checkpoint, Exhibition_Hall, Demo_Area, Vendor_Stall_1, Vendor_Stall_2, Storage_Room, Cafeteria, Toilets, Back_Office

**4 NPCs:** Mike, Dave, Technician, Dodgy Vendor
- Use `life` property to handle Answer/Ask/Tell/Show actions
- Must have `animate talkable` attributes

**Quest Items:** show_badge, security_pass, prototype_chip, toolkit, screwdriver, office_key

**Scenery/Containers:** phone, safe, urgent_crate, stacked_boxes, staff_door

### Game Mechanics

**Time Limits (computer-fair-heist.inf:554-576):**
Implemented via `timer_daemon` object with `each_turn` property:
- 50-move hard limit (game over)
- 35-move thief escape (if chip not recovered)

**Scoring (MAX_SCORE = 120):**
Points awarded via `after` routines when objects taken/examined for first time. Uses `moved` attribute to track if item scored.

**Victory Condition (computer-fair-heist.inf:77-97):**
In Security_Checkpoint's `n_to` property: checks if `prototype_chip in player`. Sets `deadflag = 2` for victory, `deadflag = 1` for defeat.

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
`urgent_crate` requires screwdriver to open. Check in `before Open` routine, spawn prototype_chip when opened.

**NPC Dialogue:**
NPCs respond in `life` property to Answer/Ask/Tell actions. Track conversation state with globals (mike_talked, dave_talked). Use TALK verb as alias: redirects to Ask action.

**Custom Verbs (computer-fair-heist.inf:498-546):**
- USE: redirects to appropriate Open action based on noun/location
- TALK: redirects to Ask action
- HELP: prints command reference

## Important Constraints

### Z3 Format Limits
- 128KB max story file (currently 34KB)
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

- Test on Mac with frotz before deploying to TRS-80
- Verify move count doesn't exceed 50 turns for normal playthrough
- Check critical path can be completed in under 35 moves
- Ensure all 120 points are achievable
- Test save/restore functionality

## Dependencies

- **Inform 6 compiler:** v6.42 (installed via Homebrew: `brew install inform6`)
- **PunyInform library:** Automatically included with inform6 Homebrew package
- **frotz:** Z-machine interpreter for testing (install: `brew install frotz`)
- **M4ZVM:** TRS-80 Z-machine interpreter (deployed separately on target hardware)

## File Organization

- `computer-fair-heist.inf` - Main source file (577 lines)
- `compile.sh` - Build script with version auto-increment
- `heist{N}.z3` - Compiled output (auto-versioned)
- `README.md` - User documentation with full game guide
