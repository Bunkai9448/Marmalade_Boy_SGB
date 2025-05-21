.gb
.open "output.gb", 0

.org 0x0134
    db   "GB MARMALADEBOY" ; ROM0:0134 - Game title
    db   0x31              ; ROM0:0143 - CGB Flag: Does not apply
    db   0x42, 0x32        ; ROM0:0144 - New Licensee Code: "B2" in ASCII (Used only if byte at 0x014B is 0x33)
    db   0x03              ; ROM0:0146 - SGB Flag: 0x03 = supports Super Game Boy functions
    db   0x01              ; ROM0:0147 - Cartridge Type: 0x01 = MBC1 (no RAM, no battery)
    db   0x03              ; ROM0:0148 - ROM Size: 0x03 = 256KB (16 banks of 16KB each)
    db   0x00              ; ROM0:0149 - RAM Size: 0x00 = No RAM on cartridge
    db   0x00              ; ROM0:014A - Destination Code: 0x00 = Japanese
    db   0x33              ; ROM0:014B - Old Licensee Code: 0x33 = Use new licensee code at 0x0144
    db   0x00              ; ROM0:014C - Mask ROM Version
    db   0xF1              ; ROM0:014D - Header Checksum
    db   0x99, 0xC1        ; ROM0:014E - Global Checksum

.org 0x0150                ; ROM0:0150 - Start of Game Code
    xor  a                 ; ROM0:0150 - Clear A
    ldh  (0xFE), a         ; ROM0:0151 - Store A at 0xFFFE
    ld   a, 0xFF           ; ROM0:0153 - Load A with 0xFF
    ldh  (0x47), a         ; ROM0:0155 - Store A at 0xFF47 (BGP)
    ldh  (0x48), a         ; ROM0:0157 - Store A at 0xFF48 (OBP0)
    ldh  (0x49), a         ; ROM0:0159 - Store A at 0xFF49 (OBP1)
    di                     ; ROM0:015B - Disable interrupts

.org 0x0385                ; ROM0:0385 - memset(dest = HL, value = 0xFF, count = BC) ; fills VRAM to be used with 0xFF
    ld   a, 0xFF           ; ROM0:0385 - Load 0xFF (all bits set) into register A
    ldi  (hl), a           ; ROM0:0387 - Load A into address HL and increment HL
    dec  bc                ; ROM0:0388 - Decrement 16-bit counter BC
    ld   a, c              ; ROM0:0389 - Load lower byte of counter into A
    or   b                 ; ROM0:038A - OR with upper byte to check if BC is zero
    jr   nz, 0x0385        ; ROM0:038B - Jump back if BC not zero (fill loop)
    ret                    ; ROM0:038D - Return when fill complete

.org 0x038E                ; ROM0:038E - memcpy(dest = DE, src = HL, count = BC)
    ldi  a, (hl)           ; ROM0:038E - Load from HL to A, increment HL
    ld   (de), a           ; ROM0:038F - Store A to address DE
    inc  de                ; ROM0:0390 - Increment destination pointer DE
    dec  bc                ; ROM0:0391 - Decrement byte counter BC
    ld   a, b              ; ROM0:0392 - Load upper byte of counter
    or   c                 ; ROM0:0393 - OR with lower byte to check if BC is zero
    jr   nz, 0x038E        ; ROM0:0394 - Jump back if more bytes to copy
    ret                    ; ROM0:0396 - Return when copy complete

.org 0x0397                ; ROM0:0397 - update_scroll(SCX = HRAM[0xD0], SCY = HRAM[0xD1])
    ldh  a, (0xD0)         ; ROM0:0397 - Load horizontal scroll value from HRAM
    ldh  (0x43), a         ; ROM0:0399 - Store to SCX (background X scroll register)
    ldh  a, (0xD1)         ; ROM0:039B - Load vertical scroll value from HRAM
    ldh  (0x42), a         ; ROM0:039D - Store to SCY (background Y scroll register)
    ret                    ; ROM0:039F - Return after scroll update

.org 0x03A0                ; ROM0:03A0 - Disables specific interrupts by masking the IE register with A xor 0xFF
    xor  a, 0xFF           ; ROM0:03A0 - Invert all bits in A
    ld   b, a              ; ROM0:03A2 - Store mask in B
    ldh  a, (0xFF)         ; ROM0:03A3 - Load interrupt enable register
    and  b                 ; ROM0:03A5 - Clear bits where B is 0
    ldh  (0xFF), a         ; ROM0:03A6 - Store updated interrupt enable
    ret                    ; ROM0:03A8 - Return after interrupt mask update

.org 0x03A9                ; ROM0:03A9 - Enable specific interrupts based on the mask in A
    ld   b, a              ; ROM0:03A9 - Save value in B
    xor  a                 ; ROM0:03AA - Clear A (set to 0)
    ldh  (0x0F), a         ; ROM0:03AB - Clear interrupt flag register
    ldh  a, (0xFF)         ; ROM0:03AD - Load interrupt enable register
    or   b                 ; ROM0:03AF - Set bits from saved value
    ldh  (0xFF), a         ; ROM0:03B0 - Store updated interrupt enable
    ret                    ; ROM0:03B2 - Return after interrupt enable update

.org 0x03B3                ; ROM0:03B3 - multiply_and_combine(dest = DE, value_b = B, value_c = C)
    ld   e, c              ; ROM0:03B3 - Load low byte into E
    ld   d, 0x00           ; ROM0:03B4 - Clear high byte D
    ld   c, 0x05           ; ROM0:03B6 - Set loop counter to 5
    sla  e                 ; ROM0:03B8 - Shift E left (multiply by 2)
    rl   d                 ; ROM0:03BA - Rotate D left with carry
    dec  c                 ; ROM0:03BC - Decrement loop counter
    jr   nz, 0x03B8        ; ROM0:03BD - Repeat shift 5 times (multiply by 32)
    ld   a, b              ; ROM0:03BF - Load value from B
    or   e                 ; ROM0:03C0 - Combine with shifted result
    ld   e, a              ; ROM0:03C1 - Store result in E
    ret                    ; ROM0:03C2 - Return with 16-bit result in DE

.org 0x0572
    ; Placeholder for subroutine, check user input (Gamepad and buttons)

.org 0x1462                ; ROM0:1462 - bank switching and script initialization
    call 0x14A1            ; ROM0:1462 - Get script offsets ; Starts text processing for dialogue or menu
    push af                ; ROM0:1465 - Save A and flags - Preserve state for bank switching
    ldh  a, (0xC9)         ; ROM0:1466 - Load from HRAM - Retrieves current ROM bank from HRAM
    ldh  (0xC8), a         ; ROM0:1468 - Store to HRAM - Backs up bank number for restoration
    ld   (0x3FFF), a       ; ROM0:146A - Switches to the bank stored in 0xFFC9
    pop  af                ; ROM0:146D - Restore A and flags
    ret                    ; ROM0:146E - Returns to 0x2F8B - Ends bank switch and script init

.org 0x146F                ; Tile Data to VRAM
    ld   hl, 0x7900        ; ROM0:146F - Sets VRAM address for tile data (0x7900-0x7FFF range)
    ld   c, a              ; ROM0:1472 - A contains tile number - Set low byte; Sets tile index from accumulator
    ld   b, 0x00           ; ROM0:1473 - Clear high byte - BC = tile number; Ensures BC is a 16-bit tile number with high byte zero
    sla  c                 ; ROM0:1475 - Multiply by 8 - Shift left; Begins multiplying tile number by 16 (tile size)
    rl   b                 ; ROM0:1477 - (tile data is 8 bytes per tile) - Rotate carry; Handles carry for 16-bit shift
    sla  c                 ; ROM0:1479 - Shift Left Arithmetic effectively multiplies c by 2; Continues multiplication (now ×4)
    rl   b                 ; ROM0:147B - Rotate Left through Carry on register b.; Handles carry
    sla  c                 ; ROM0:147D - Multiplies by 8; Final shift to ×16 (16 bytes per tile in VRAM)
    rl   b                 ; ROM0:147F - Handles overflow; Completes 16-bit shift
    add  hl, bc            ; ROM0:1481 - Calculate tile address - Add offset to base; Computes final VRAM address for tile
    ld   a, 0x0C           ; ROM0:1483 - Possibly bank number - Set ROM bank; Selects bank 0x0C for tile data
    ldh  (0xC8), a         ; ROM0:1485 - Store to HRAM - Updates HRAM with new bank number
    ld   (0x3FFF), a       ; ROM0:1487 - Store to banking register - Switches ROM to bank 0x0C
    ld   bc, 0x0008        ; ROM0:148A - 8 bytes to copy - Tile data size; Sets copy size (8 bytes, half a tile for 4x8?)
    ld   de, 0xCDBD        ; ROM0:148D - Source in WRAM - Points to tile data buffer in WRAM
    call 0x038E            ; ROM0:1490 - Memory copy routine - Copies tile data to VRAM
    ld   a, (0xCDCA)       ; ROM0:1493 - Load previous value - Retrieves previous bank number
    ldh  (0xC8), a         ; ROM0:1496 - Restore bank - Restores HRAM bank value
    ld   (0x3FFF), a       ; ROM0:1498 - Restore banking register - Update hardware
    ret                    ; ROM0:149B - Ends tile loading routine

.org 0x149B                ; ROM0:149B - backup_flag(src = (HRAM: 0xBC), dest = (WRAM: 0xCDC7))
    ldh  a, (0xBC)         ; ROM0:149B - Load from HRAM - Reads a game state or flag from HRAM
    ld   (0xCDC7), a       ; ROM0:149D - Store to WRAM - Saves value to WRAM for later use
    ret                    ; ROM0:14A0 - Ends backup routine

.org 0x14A1
    call 0x149B         ; ROM0:14A1 - Copy HRAM to WRAM - Backup current state; Saves HRAM state before script processing
    ld   a, (0xCDCB)    ; ROM0:14A4 - Load script pointer - Get current position; Loads current script offset
    ld   hl, 0xCDD8     ; ROM0:14A7 - Comparison address - Target position; Points to stored script position
    cp   (hl)           ; ROM0:14AA - Compare values - Check if matches; Checks if script position changed
    jr   nz, 0x14C6     ; ROM0:14AB - If different, update values - Jump to update; Updates if position differs
    ld   a, (0xCDCA)    ; ROM0:14AD - Load another pointer - Second check; Loads bank or secondary pointer
    ld   hl, 0xCDE3     ; ROM0:14B0 - Compare position - Second target; Points to stored bank/pointer
    cp   (hl)           ; ROM0:14B3; Compares second value
    jr   nz, 0x14C6     ; ROM0:14B4; Updates if different
    ld   a, (0xCDC8)    ; ROM0:14B6 - Load bank/offset - Third check; Loads another script-related value
    ld   hl, 0xCDE7     ; ROM0:14B9 - Compare position - Third target; Points to third stored value
    cp   (hl)           ; ROM0:14BC; Compares third value
    jr   nz, 0x14C6     ; ROM0:14BD; Updates if different
    ld   a, (0xCDC9)    ; ROM0:14BF - Load final offset - Fourth check; Loads final script offset
    inc  hl             ; ROM0:14C2 - Next position (0xCDE8) - Move to last target; Advances to fourth stored value
    cp   (hl)           ; ROM0:14C3; Compares fourth value
    jr   z, 0x14E1      ; ROM0:14C4 - If match, handle differently - All match, skip update; Skips update if all match
    ld   a, (0xCDCB)    ; ROM0:14C6 - Reload values - Get current position; Reloads script offset for update
    ld   (0xCDD8), a    ; ROM0:14C9 - Store updated pointer - Save new position; Updates stored script position
    ld   a, (0xCDCA)    ; ROM0:14CC - Get second pointer; Reloads bank/pointer
    ld   (0xCDE3), a    ; ROM0:14CF - Update second target; Updates second stored value
    ld   a, (0xCDC8)    ; ROM0:14D2 - Get bank/offset; Reloads third value
    ld   (0xCDE7), a    ; ROM0:14D5 - Update third target; Updates third stored value
    ld   a, (0xCDC9)    ; ROM0:14D8 - Get final offset; Reloads final offset
    ld   (0xCDE8), a    ; ROM0:14DB - Update fourth target; Updates fourth stored value
    jp   0x198E         ; ROM0:14DE - Jump to script handler - Process new script position; Jumps to script execution

.org 0x14E1                ; Text unrolling routine
    ld   a, (0xCDDE)       ; ROM0:14E1 - Loads text delay or progress counter
    and  a                 ; ROM0:14E4 - Check if zero - Test completion
    jp   z, 0x14EF         ; ROM0:14E5 - If zero, process next - Move to next step
    ld   hl, 0xCDDE        ; ROM0:14E8 - Counter address - Point to counter
    dec  (hl)              ; ROM0:14EB - Decrease counter
    jp   0x155D            ; ROM0:14EC - Continue processing
    ld   a, (0xCDDF)       ; ROM0:14EF - Load default counter - Get reset value
    ld   (0xCDDE), a       ; ROM0:14F2 - Reset counter
    ld   a, (0xCDDC)       ; ROM0:14F5 - Loads low byte of script address
    ld   e, a              ; ROM0:14F8 - Store in E; Sets DE low byte
    ld   a, (0xCDDD)       ; ROM0:14F9 - Loads high byte of script address
    ld   d, a              ; ROM0:14FC - Store in D - DE now holds script pointer

.org 0x14FD                ; Dictionary unrolling routine
    ld   a, (de)           ; ROM0:14FD - Load character from script - Reads next script byte
    cp   0xE0              ; ROM0:14FE - Checks if byte is a control code
    jr   c, 0x150E         ; ROM0:1500 - Processes as text if < 0xE0
    sub  a, 0xE0           ; ROM0:1502 - Adjust control code value - Converts code to table index
    sla  a                 ; ROM0:1504 - Shift left; Doubles index for word-sized table
    ld   hl, 0x1CF8        ; ROM0:1506 - Points to control code jump table
    rst  0x08              ; ROM0:1509 - Call reset vector 0x08; Computes table address (adds A to HL)
    inc  hl                ; ROM0:150A - Points to high byte of handler
    ld   h, (hl)           ; ROM0:150B - Loads handler address high byte
    ld   l, a              ; ROM0:150C - Sets low byte from adjusted code
    jp   hl                ; ROM0:150D - Jumps to control code handler

.org 0x150E
    ld   a, (0xCE24)    ; ROM0:150E - Load value from 0xCE24 into A; Checks a text state flag
    cp   a, 0x02        ; ROM0:1511 - Compare A with 0x02; Tests for a specific mode (e.g., text speed)
    jr   nz, 0x1519     ; ROM0:1513 - Jump to 0x1519 if not equal; Skips reset if not in mode 2
    xor  a              ; ROM0:1515 - Clear A; Resets A to 0
    ld   (0xCE24), a    ; ROM0:1516 - Store 0 into 0xCE24; Clears text state flag
    call 0x17D0         ; ROM0:1519 - Call subroutine at 0x17D0 to convert character to tile; Converts char to tile number
    call 0x1BBC         ; ROM0:151C - Call subroutine at 0x1BBC for buffer management; Adds tile to display buffer
    ld   a, (0xCDDA)    ; ROM0:151F - Load X coordinate from 0xCDDA into A; Gets current text X position
    ld   l, a           ; ROM0:1522 - Load A into L; Sets HL low byte
    ld   a, (0xCDDB)    ; ROM0:1523 - Load Y coordinate from 0xCDDB into A; Gets current text Y position
    ld   h, a           ; ROM0:1526 - Load A into H - HL now holds position; HL now holds text cursor position
    ld   bc, 0x0020     ; ROM0:1527 - Load BC with 0x0020 (next line offset); Sets offset for next tilemap row (32 tiles)
    add  hl, bc         ; ROM0:152A - Advance HL to next line; Moves cursor to next line
    call 0x171C         ; ROM0:152B - Call subroutine at 0x171C for screen boundary check; Ensures position stays on screen
    ld   a, (0xCDCD)    ; ROM0:152E - Load value from 0xCDCD into A; Loads a text-related value (e.g., tile offset)
    ld   b, a           ; ROM0:1531 - Load A into B; Stores value in B
    ld   a, (0xCDE1)    ; ROM0:1532 - Load value from 0xCDE1 into A; Loads another text parameter (e.g., width)
    add  a, b           ; ROM0:1535 - Add B to A; Combines values (e.g., calculates tile index)
    rst  0x20           ; ROM0:1536 - Call reset vector 0x20; Writes tile to VRAM (common handler)
    call 0x182F         ; ROM0:1537 - Call subroutine at 0x182F; Updates display buffer
    call 0x1785         ; ROM0:153A - Call subroutine at 0x1785; Adjusts text rendering state
    ld   a, (0xCDDA)    ; ROM0:153D - Load X coordinate from 0xCDDA into A; Reloads X position
    ld   l, a           ; ROM0:1540 - Load A into L; Updates HL low byte
    ld   a, (0xCDDB)    ; ROM0:1541 - Load Y coordinate from 0xCDDB into A; Reloads Y position
    ld   h, a           ; ROM0:1544 - Load A into H - HL now holds position; HL holds updated position
    call 0x1790         ; ROM0:1545 - Call subroutine at 0x1790 to adjust position; Advances cursor with wrapping
    ld   a, l           ; ROM0:1548 - Load L into A; Gets updated X
    ld   (0xCDDA), a    ; ROM0:1549 - Store updated X coordinate into 0xCDDA; Saves new X position
    ld   a, h           ; ROM0:154C - Load H into A; Gets updated Y
    ld   (0xCDDB), a    ; ROM0:154D - Store updated Y coordinate into 0xCDDB; Saves new Y position
    jr   0x1555         ; ROM0:1550 - Jump to 0x1555; Skips redundant call
    call 0x182F         ; ROM0:1552 - Call subroutine at 0x182F; Updates display buffer (alternative path)
    ld   a, (0xCDCC)    ; ROM0:1555 - Load value from 0xCDCC into A; Loads text control flags
    bit  6, a           ; ROM0:1558 - Test bit 6 of A; Checks if text should pause (e.g., wait for input)
    jp   nz, 0x14EF     ; ROM0:155A - Jump to 0x14EF if bit 6 is set; Waits for input if flag set
    call 0x1BFB         ; ROM0:155D - Call subroutine at 0x1BFB; Finalizes text rendering
    xor  a              ; ROM0:1560 - Clear A; Sets return value to 0
    ret                 ; ROM0:1561 - Return from subroutine; Ends text processing

.org 0x171C                ; ROM0:171C - check_and_clamp_y_position(y_position = h, boundary_flag = (HRAM: 0xCDD9)) ; Screen boundary check?
    ld   a, (0xCDD9)       ; ROM0:171C - Load value from memory at 0xCDD9 into a; Loads screen boundary flag
    and  a                 ; ROM0:171F - Test if a is zero; Checks if boundary checking is enabled
    jr   z, 0x1729         ; ROM0:1720 - Jump to 0x1729 if a is zero; Skips check if disabled
    ld   a, h              ; ROM0:1722 - Load high byte (h) into a; Gets Y position high byte
    cp   a, 0xA0           ; ROM0:1723 - Compare a with 0xA0 (screen boundary?); Checks if beyond VRAM tilemap (0x9800-0x9FFF)
    ret  c                 ; ROM0:1725 - Return if a < 0xA0; Returns if within bounds
    ld   h, 0x9C           ; ROM0:1726 - Set h to 0x9C (clamp to boundary); Clamps Y to top of tilemap
    ret                    ; ROM0:1728 - Return; Ends boundary check

.org 0x1790
    inc  hl             ; ROM0:1790 - Increment HL to next tile; Advances cursor to next tile
    ld   a, l           ; ROM0:1791 - Load L into A; Gets X position
    and  a, 0x1F        ; ROM0:1792 - Mask for 32 tiles per row (0x1F = 31); Checks if at row end (32 tiles)
    ret  nz             ; ROM0:1794 - Return if not at edge (less than 20); Returns if not at edge
    ld   a, l           ; ROM0:1795 - Load L into A; Reloads X
    sub  a, 0x20        ; ROM0:1796 - Subtract 20 to reset column; Moves X back to start of row
    ld   l, a           ; ROM0:1798 - Update L; Updates X position
    ld   a, h           ; ROM0:1799 - Load H into A; Gets Y position
    sbc  a, 0x00        ; ROM0:179A - Adjust H with carry (if any); Adjusts Y with borrow
    ld   h, a           ; ROM0:179C - Update H; Updates Y position
    ret                 ; ROM0:179D - Return; Ends position adjustment

.org 0x17D0                ; subroutine convert character to tile
    push de                ; ROM0:17D0 - Save the value of DE register pair to stack
    ld   a,(de)            ; ROM0:17D1 - Load the value at the memory location pointed to by DE into register A
    call 0x146F            ; ROM0:17D2 - Call function at address 0x146F
    ld   de,0xCDBD         ; ROM0:17D5 - Load the address 0xCDBD into DE register pair
    ld   hl,0x8000         ; ROM0:17D8 - Load the address 0x8000 into HL register pair
    ld   a,(0xCDCD)        ; ROM0:17DB - Load the value at address 0xCDCD into register A
    ld   b,a               ; ROM0:17DE - Copy value from register A into register B
    ld   a,(0xCDE1)        ; ROM0:17DF - Load the value at address 0xCDE1 into register A
    add a,b                ; ROM0:17E2 - Add the value of register B to register A
    cp   a,0x80            ; ROM0:17E3 - Compare register A with 0x80
    jr   nc,0x17EA         ; ROM0:17E5 - Jump if no carry (A >= 0x80) to address 0x17EA
    ld   hl,0x9000         ; ROM0:17E7 - Load the address 0x9000 into HL register pair
    ld   c,a               ; ROM0:17EA - Copy the value of A into register C
    ld   b,0x00            ; ROM0:17EB - Set register B to 0 (initialize counter)
    sla  c                 ; ROM0:17ED - Perform a left shift on register C (multiply by 2)
    rl   b                 ; ROM0:17EF - Rotate left through carry on register B
    sla  c                 ; ROM0:17F1 - Perform another left shift on register C (multiply by 2)
    rl   b                 ; ROM0:17F3 - Rotate left through carry on register B
    sla  c                 ; ROM0:17F5 - Perform another left shift on register C (multiply by 2)
    rl   b                 ; ROM0:17F7 - Rotate left through carry on register B
    sla  c                 ; ROM0:17F9 - Perform another left shift on register C (multiply by 2)
    rl   b                 ; ROM0:17FB - Rotate left through carry on register B
    add  hl,bc             ; ROM0:17FD - Add the value of BC to HL (calculate address offset)
    ld   b,0x08            ; ROM0:17FE - Set register B to 8 (loop counter)
    ld   a,(de)            ; ROM0:1800 - Load the value at address DE into register A
    rst  0x20              ; ROM0:1801 - Call the subroutine at address 0x0020 (software interrupt)
    inc  hl                ; ROM0:1802 - Increment the HL register pair
    ld   a,(de)            ; ROM0:1803 - Load the value at address DE into register A
    rst  0x20              ; ROM0:1804 - Call the subroutine at address 0x0020 (software interrupt)
    inc  de                ; ROM0:1805 - Increment the DE register pair
    inc  hl                ; ROM0:1806 - Increment the HL register pair
    dec  b                 ; ROM0:1807 - Decrement the value in register B (loop counter)
    jr   nz,0x1800         ; ROM0:1808 - Jump to address 0x1800 if B is not zero (repeat loop)
    pop  de                ; ROM0:180A - Restore the value of DE register pair from stack
    ret                    ; ROM0:180B - Return from the current subroutine

.org 0x182F                ; ROM0:182F - Increment DE and store its value to 0xCDDC/0xCDDD
    inc  de                ; ROM0:182F - Increment DE register pair
    ld   a, e              ; ROM0:1830 - Load lower byte (E) of DE into A
    ld   (0xCDDC), a       ; ROM0:1831 - Store A into address 0xCDDC
    ld   a, d              ; ROM0:1834 - Load upper byte (D) of DE into A
    ld   (0xCDDD), a       ; ROM0:1835 - Store A into address 0xCDDD
    ret                    ; ROM0:1838 - Return from subroutine

.org 0x1BBC                ; Start of routine - Buffer management
    ld   a, (0xCDC6)       ; ROM0:1BBC - Load a flag or counter from WRAM; Checks text buffer state
    and  a                 ; ROM0:1BBF - Test if a is zero; Tests if buffer is ready
    ret  nz                ; ROM0:1BC0 - Return if non-zero, else continue; Exits if buffer busy
    ldh  a, (0xB8)         ; ROM0:1BC1 - Load value from HRAM at 0xFFB8 into a; Loads current character or state
    cp   a, 0x26           ; ROM0:1BC3 - Compare a with 0x26 (check specific state); Checks for special char (e.g., punctuation)
    jr   z, 0x1BEE         ; ROM0:1BC5 - Jump to 0x1BEE if equal (handle case 0x26); Handles special case
    cp   a, 0x2D           ; ROM0:1BC7 - Compare a with 0x2D (another state check); Checks for another special char
    jr   z, 0x1BEE         ; ROM0:1BC9 - Jump to 0x1BEE if equal (handle case 0x2D); Handles special case
    cp   a, 0x05           ; ROM0:1BCB - Compare a with 0x05; Checks for control code or space
    jr   z, 0x1BD9         ; ROM0:1BCD - Jump to 0x1BD9 if equal (handle case 0x05); Processes space-like char
    cp   a, 0x20           ; ROM0:1BCF - Compare a with 0x20; Checks for space character
    jr   z, 0x1BD9         ; ROM0:1BD1 - Jump to 0x1BD9 if equal (handle case 0x20); Processes space
    cp   a, 0x11           ; ROM0:1BD3 - Compare a with 0x11; Checks for another control code
    jr   z, 0x1BD9         ; ROM0:1BD5 - Jump to 0x1BD9 if equal (handle case 0x11); Processes special char
    jr   0x1BF2            ; ROM0:1BD7 - Jump to 0x1BF2 (default case); Handles regular characters
    ld   hl, 0xCDD6        ; ROM0:1BD9 - Load address 0xCDD6 into hl (start of 0x05/0x20/0x11 case); Points to text flag
    bit  0, (hl)           ; ROM0:1BDC - Test bit 0 of value at (hl); Checks if space rendering is enabled
    jr   nz, 0x1BF2        ; ROM0:1BDE - Jump to 0x1BF2 if bit 0 is set; Treats as regular char if flag set
    ld   a, (0xD505)       ; ROM0:1BE0 - Load value from 0xD505 (another WRAM check); Checks text mode or counter
    and  a                 ; ROM0:1BE3 - Test if a is zero; Tests if mode is active
    jr   z, 0x1BF2         ; ROM0:1BE4 - Jump to 0x1BF2 if zero; Treats as regular char if inactive
    cp   a, 0x03           ; ROM0:1BE6 - Compare a with 0x03; Checks for specific mode
    jr   z, 0x1BF6         ; ROM0:1BE8 - Jump to 0x1BF6 if equal (set 0x05); Sets special buffer state
    cp   a, 0x04           ; ROM0:1BEA - Compare a with 0x04; Checks for another mode
    jr   z, 0x1BF6         ; ROM0:1BEC - Jump to 0x1BF6 if equal (set 0x05); Sets special buffer state
    ld   a, 0x04           ; ROM0:1BEE - Load 0x04 into a (case 0x26/0x2D); Sets buffer state for punctuation
    jr   0x1BF8            ; ROM0:1BF0 - Jump to 0x1BF8 (store and return); Stores and exits
    ld   a, 0x05           ; ROM0:1BF2 - Load 0x05 into a (default case); Sets default buffer state for text
    jr   0x1BF8            ; ROM0:1BF4 - Jump to 0x1BF8 (store and return); Stores and exits
    ld   a, 0x06           ; ROM0:1BF6 - Load 0x06 into a (case 0x03/0x04); Sets buffer state for special mode
    ldh  (0xCB), a         ; ROM0:1BF8 - Store a into HRAM at 0xFFCB; Updates text buffer control in HRAM
    ret                    ; ROM0:1BFA - Return; Ends buffer management

.org 0x1BFB                ; ROM0:1BFB - Check condition flags before proceeding
    ld   a, (0xCE24)       ; ROM0:1BFB - Load value from address 0xCE24 into A
    and  a                 ; ROM0:1BFE - Logical AND A with itself (sets Z flag if A == 0)
    ret  nz                ; ROM0:1BFF - Return if result was not zero

.org 0x1D88                ; ROM0:1D88 - Control code handler (In the dictionary section)
    ld   a, (de)           ; ROM0:1D88 - Load character - Get next script byte; Reads next script byte
    cp   0xFD              ; ROM0:1D89 - Checks for Tenten-kana
    jr   z, 0x1DAF         ; ROM0:1D8B - Jump to handle tenten
    cp   0xFE              ; ROM0:1D8D - Checks for Maruten-kana
    jr   z, 0x1DB3         ; ROM0:1D8F - Jump to handle maruten
    cp   0xFF              ; ROM0:1D91 - Checks for space character
    jr   z, 0x1DE2         ; ROM0:1D93 - Jump to handle space
    cp   0xF0              ; ROM0:1D95 - Checks for text end code
    jp   z, 0x1E2F         ; ROM0:1D97 - Jump to end text processing
    cp   0xF2              ; ROM0:1D9A - Checks for newline code
    jr   z, 0x1DE9         ; ROM0:1D9C - Jump to handle newline
    cp   0xF3              ; ROM0:1D9E - Check for skip input (?)
    jp   z, 0x1E21         ; ROM0:1DA0 - Skips input delay
    cp   0xFB              ; ROM0:1DA3 - Checks for buffer continue code (?)
    jp   z, 0x1E41         ; ROM0:1DA5 - Continues text buffer
    cp   0xFC              ; ROM0:1DA8 - Checks for ellipsis '...' code
    jp   z, 0x1E85         ; ROM0:1DAA - Jump to handle ellipsis
    jr   0x1DC4            ; ROM0:1DAD - Processes regular text char (actual display print?)

.org 0x1DAF                ; ROM0:1DAF - 
    ld   b,0xFA            ; ROM0:1DAF - Load 0xFA into register B (preparing a value)
    jr   0x1DB5            ; ROM0:1DB1 - Jump to address 0x1DB5 (relative jump)
    ld   b,0xFB            ; ROM0:1DB3 - Load 0xFB into register B (update the value in B)
    ld   a,(0xCDDA)        ; ROM0:1DB5 - Load the value at memory address 0xCDDA into register A
    ld   l,a               ; ROM0:1DB8 - Copy the value from A into register L (lower byte of HL)
    ld   a,(0xCDDB)        ; ROM0:1DB9 - Load the value at memory address 0xCDDB into register A
    ld   h,a               ; ROM0:1DBC - Copy the value from A into register H (upper byte of HL)
    ld   a,b               ; ROM0:1DBD - Load the value from register B into A
    rst  0x20              ; ROM0:1DBE - Call software interrupt (RST 0x20), typically used for specific tasks like graphics or sound
    inc  de                ; ROM0:1DBF - Increment the value in register pair DE (typically used for pointer increment)
    ld   hl,0xCDE0         ; ROM0:1DC0 - Load memory address 0xCDE0 into HL register pair (pointer to a location in memory)
    inc  (hl)              ; ROM0:1DC3 - Increment the value at the memory address pointed to by HL (likely updating data at that location)

.org 0x1DC4                ; ROM0:1DC4 - Character processing - Text to display conversion
    call 0x17D0            ; ROM0:1DC4 - Character to tile
    call 0x1BBC            ; ROM0:1DC7 - Buffer management - Add to display buffer
    ld   a, (0xCDDA)       ; ROM0:1DCA - Load current position - Get X coordinate
    ld   l, a              ; ROM0:1DCD - Store in L; Sets HL low byte
    ld   a, (0xCDDB)       ; ROM0:1DCE - Get Y coordinate
    ld   h, a              ; ROM0:1DD1 - Store in H - HL = position; HL holds cursor position
    ld   bc, 0x0020        ; ROM0:1DD2 - Next line offset - 32 tiles per line; Sets offset for next tilemap row
    add  hl, bc            ; ROM0:1DD5 - Advance position - Move to next line; Advances cursor to next line
    call 0x171C            ; ROM0:1DD7 - Screen boundary check - Validate position; Ensures cursor stays on screen

.org 0x1DE2
    ld   hl, 0xCDE0     ; ROM0:1DE2 - Load HL with 0xCDE0; Points to space counter or flag
    inc  (hl)           ; ROM0:1DE5 - Increment value at 0xCDE0; Increments space count
    xor  a              ; ROM0:1DE6 - Clear A; Prepares return value
    jr   0x1E35         ; ROM0:1DE7 - Jump to 0x1E35; Advances script pointer
    ld   a, (0xCDCE)    ; ROM0:1DE9 - Load A from 0xCDCE (newline handler); Loads base X position
    ld   l, a           ; ROM0:1DEC - Store in L; Sets HL low byte
    ld   a, (0xCDCF)    ; ROM0:1DED - Load A from 0xCDCF; Loads base Y position
    ld   h, a           ; ROM0:1DF0 - Store in H (HL = position); HL holds start of line position
    ld   a, (0xCDE2)    ; ROM0:1DF1 - Load A from 0xCDE2 (line counter?); Loads current line number
    inc  a              ; ROM0:1DF4 - Increment A; Advances to next line
    ld   (0xCDE2), a    ; ROM0:1DF5 - Store back to 0xCDE2; Updates line counter
    ld   c, a           ; ROM0:1DF8 - Copy to C; Prepares for offset calculation
    ld   b, 0x00        ; ROM0:1DF9 - Clear B (BC = line offset); Clears high byte
    sla  c              ; ROM0:1DFB - Shift C left (×2); Begins multiplying line number by 32
    rl   b              ; ROM0:1DFD - Rotate B with carry; Handles overflow
    sla  c              ; ROM0:1DFF - Shift C left (×4); Continues multiplication
    rl   b              ; ROM0:1E01 - Rotate B with carry; Handles overflow
    sla  c              ; ROM0:1E03 - Shift C left (×8); Continues multiplication
    rl   b              ; ROM0:1E05 - Rotate B with carry; Handles overflow
    sla  c              ; ROM0:1E07 - Shift C left (×16); Continues multiplication
    rl   b              ; ROM0:1E09 - Rotate B with carry; Handles overflow
    sla  c              ; ROM0:1E0B - Shift C left (×32); Final shift for tilemap row offset
    rl   b              ; ROM0:1E0D - Rotate B with carry; Handles overflow
    sla  c              ; ROM0:1E11 - Shift C left (×64); Extra shift (possibly a bug or unused)
    rl   b              ; ROM0:1E13 - Rotate B with carry; Handles overflow
    add  hl, bc         ; ROM0:1E14 - Add BC to HL (move down lines); Moves cursor down by line offset
    call 0x171C         ; ROM0:1E17 - Validate position; Ensures new position is valid
    ld   a, l           ; ROM0:1E18 - Load L into A; Gets updated X
    ld   (0xCDDA), a    ; ROM0:1E1B - Update X position; Saves new X position
    ld   a, h           ; ROM0:1E1C - Load H into A; Gets updated Y
    ld   (0xCDDB), a    ; ROM0:1E1F - Update Y position; Saves new Y position
    jr   0x1DE2         ; ROM0:1E21 - Loop back to space handler (?); Possibly a bug, meant to advance script
    inc  de             ; ROM0:1E22 - Increment DE (text pointer); Advances script pointer
    ld   a, (de)        ; ROM0:1E23 - Load next script byte; Reads next byte (e.g., delay value)
    ld   (0xCDDF), a    ; ROM0:1E26 - Store in 0xCDDF; Sets new delay value
    ld   hl, 0xCDE0     ; ROM0:1E29 - Load HL with 0xCDE0; Points to control counter
    inc  (hl)           ; ROM0:1E2C - Increment 0xCDE0; Increments counter (e.g., skip steps)
    inc  (hl)           ; ROM0:1E2D - Increment again; Double increment (e.g., for timing)
    ld   a, 0x01        ; ROM0:1E2E - Load A with 1; Sets return flag
    jr   0x1E35         ; ROM0:1E30 - Jump to 0x1E35; Advances script
    xor  a              ; ROM0:1E33 - Clear A; Prepares to clear counter
    ld   (0xCDE0), a    ; ROM0:1E34 - Clear 0xCDE0; Resets control counter
    ld   a, 0xF0        ; ROM0:1E37 - Load A with 0xF0 (end text); Sets end text code
    push af             ; ROM0:1E3A - Save A; Saves end code
    ld   a, (0xCDCA)    ; ROM0:1E3B - Load A from 0xCDCA; Loads previous bank
    ldh  (0xC8), a      ; ROM0:1E3E - Store in HRAM 0xFFC8; Restores bank in HRAM
    ld   (0x3FFF), a    ; ROM0:1E41 - Store in 0x3FFF (bank switch?); Switches back to original bank
    pop  af             ; ROM0:1E44 - Restore A; Restores end code
    pop  de             ; ROM0:1E45 - Restore DE; Restores script pointer
    ret                 ; ROM0:1E46 - Return; Ends control code handling

.org 0x1E33               ; display each character
    ld   a,0xF0            ; ROM0:1E33 -
    push af               ; ROM0:1E35 - 
    ld   a, (0xCDCA)      ; ROM0:1E36 - 
    ldh  (0xC8), a        ; ROM0:1E39 - 
    ld   (0x3FFF),a       ; ROM0:1E3B - 
    pop  af               ; ROM0:1E3E - 
    pop  de               ; ROM0:1E3F - 
    ret                   ; ROM0:1E40 - 

.org 0x1E85                ; ROM0:1E85
    ld   a,0x02          ; ROM0:1E85 3E 02 - Load 0x02 into register A
    ld   (0xCE24),a      ; ROM0:1E87 EA 24 CE - Store A (0x02) into memory address 0xCE24
    jr   0x1E7D          ; ROM0:1E8A 18 F1 - Jump to address 0x1E7D (relative jump)
    ld   hl,0xCDD6       ; ROM0:1E8C 21 D6 CD - Load memory address 0xCDD6 into HL register pair
    set  2,(hl)          ; ROM0:1E8F CB D6 - Set bit 2 of the byte at address (HL), enabling some feature (e.g., flipping)
    call 0x1BFB          ; ROM0:1E91 CD FB 1B - Call subroutine at address 0x1BFB
    ld   a,0x01          ; ROM0:1E94 3E 01 - Load 0x01 into register A
    ld   (0xCE18),a      ; ROM0:1E96 EA 18 CE - Store A (0x01) into memory address 0xCE18 (probably setting a control flag)
    call 0x1F33          ; ROM0:1E99 CD 33 1F - Call subroutine at address 0x1F33 (likely for further display setup)
    xor  a               ; ROM0:1E9C AF - XOR A with itself (clears register A, sets it to 0)
    ld   (0xCE19),a      ; ROM0:1E9D EA 19 CE - Store A (0) into memory address 0xCE19 (clearing a flag or control byte)
    ld   hl,0xCDD6       ; ROM0:1EA0 21 D6 CD - Reload memory address 0xCDD6 into HL register pair
    res  2,(hl)          ; ROM0:1EA3 CB 96 - Reset bit 2 of the byte at address (HL), reversing a previous change (e.g., flipping back)
    ld   a,(0xCE19)      ; ROM0:1EA5 FA 19 CE - Load the value at memory address 0xCE19 into register A
    ld   hl,0xCDE4       ; ROM0:1EA8 21 E4 CD - Load memory address 0xCDE4 into HL register pair
    rst  0x08            ; ROM0:1EAB CF - Call software interrupt (RST 0x08), likely to trigger a display or graphics update

.org 0x1F33                ; ROM0:1F33 - Count non-0xFF bytes starting at 0xCDE4 (max 3), store in 0xCE1A
    ld   hl, 0xCDE4        ; ROM0:1F33 - Load HL with address 0xCDE4
    ld   b, 0x00           ; ROM0:1F36 - Initialize counter B to 0
    ldi  a, (hl)           ; ROM0:1F38 - Load value at (HL) into A and increment HL
    cp   a, 0xFF           ; ROM0:1F39 - Compare A with 0xFF
    jr   z, 0x1F43         ; ROM0:1F3B - If A == 0xFF, jump to 0x1F43
    inc  b                ; ROM0:1F3D - Increment B
    ld   a, b              ; ROM0:1F3E - Load counter B into A
    cp   a, 0x03           ; ROM0:1F3F - Compare A with 3
    jr   nz, 0x1F38        ; ROM0:1F41 - Loop back if not yet 3 valid bytes
    ld   a, b              ; ROM0:1F43 - Load final count into A
    ld   (0xCE1A), a       ; ROM0:1F44 - Store result in 0xCE1A
    ret                    ; ROM0:1F47 - Return from subroutine

.org 0x2F25                ; Line count check - Text formatting (default case ends game intro)
    ld   a, (0xD525)    ; ROM0:2F25 - Paragraph lines - Get line count; Loads number of text lines
    cp   0x01           ; ROM0:2F28 - Compare with 1; Checks for single line
    jr   c, 0x2F88      ; ROM0:2F2A - Less than 1 - Empty text; Handles empty text
    jr   z, 0x2FAA      ; ROM0:2F2C - Exactly 1 - Single line; Handles single-line text
    cp   0x03           ; ROM0:2F2E - Check for 3 - Multi-line check; Checks for 3 lines
    jp   c, 0x2FF3      ; ROM0:2F30 - Less than 3 - Handle 2 lines; Handles 2-line text
    jr   z, 0x2F88      ; ROM0:2F33 - Exactly 3 - Empty or special case; Special case for 3 lines
    cp   a, 0x05        ; ROM0:2F35 - Check for 5 - Continue multi-line check; Checks for 5 lines
    jp   c, 0x30A1      ; ROM0:2F37 - Less than 5 - Handle 4 lines; Handles 4-line text
    jp   z, 0x30CC      ; ROM0:2F3A - Exactly 5 - Specific 5-line case; Handles 5-line text
    cp   a, 0x07        ; ROM0:2F3D - Check for 7; Checks for 7 lines
    jr   c, 0x2F88      ; ROM0:2F40 - Less than 7 - Empty or invalid (6 lines); Invalid case for 6 lines
    jr   z, 0x2FAA      ; ROM0:2F42 - Exactly 7 - Reuse single-line-like handler; Reuses handler for 7 lines
    cp   a, 0x09        ; ROM0:2F44 - Check for 9; Checks for 9 lines
    jp   c, 0x2FF3      ; ROM0:2F46 - Less than 9 - Handle 8 lines; Handles 8-line text
    jr   z, 0x2F88      ; ROM0:2F49 - Exactly 9 - Empty or special case; Special case for 9 lines
    cp   a, 0x0B        ; ROM0:2F4B - Check for 11 (0x0B); Checks for 11 lines
    jp   c, 0x30A1      ; ROM0:2F4D - Less than 11 - Handle 10 lines; Handles 10-line text
    jp   z, 0x30CC      ; ROM0:2F50 - Exactly 11 - Reuse 5-line-like handler; Reuses handler for 11 lines
    cp   a, 0x0D        ; ROM0:2F53 - Check for 13 (0x0D); Checks for 13 lines
    jr   c, 0x2F98      ; ROM0:2F55 - Less than 13 - Handle 12 lines; Handles 12-line text
    jr   z, 0x2F88      ; ROM0:2F57 - Exactly 13 - Special or empty case; Special case for 13 lines
    cp   a, 0x0F        ; ROM0:2F59 - Check for 15 (0x0F); Checks for 15 lines
    jp   c, 0x3143      ; ROM0:2F5B - Less than 15 - Handle 14 lines; Handles 14-line text
    jp   z, 0x316F      ; ROM0:2F5E - Exactly 15 - Specific 15-line case; Handles 15-line text
    cp   a, 0x11        ; ROM0:2F61 - Check for 17 (0x11); Checks for 17 lines
    jr   c, 0x2F88      ; ROM0:2F63 - Less than 17 - Empty or invalid (16 lines); Invalid case for 16 lines
    jp   z, 0x31CB      ; ROM0:2F65 - Exactly 17 - Specific 17-line case; Handles 17-line text
    cp   a, 0x13        ; ROM0:2F68 - Check for 19 (0x13); Checks for 19 lines
    jr   c, 0x2F88      ; ROM0:2F6A - Less than 19 - Empty or invalid (18 lines); Invalid case for 18 lines
    jp   z, 0x31C3      ; ROM0:2F6C - Exactly 19 - Specific 19-line case; Handles 19-line text
    cp   a, 0x15        ; ROM0:2F6F - Check for 21 (0x15); Checks for 21 lines
    jr   c, 0x2F88      ; ROM0:2F71 - Less than 21 - Empty or invalid (20 lines); Invalid case for 20 lines
    jp   0x3201         ; ROM0:2F73 - Greater than or equal to 21 - Default or max case; Handles max or overflow case

.org 0x2F75                ; Screen refresh
    call 0x0B8D         ; ROM0:2F75 - Updates background tiles
    call 0x24FA         ; ROM0:2F78 - Updates sprite positions
    call 0x1B3C         ; ROM0:2F7B - Updates text buffer to VRAM
    call 0x1B50         ; ROM0:2F7E - Adjusts scroll values
    call 0x26CE         ; ROM0:2F81 - Refreshes palettes
    call 0x0B9D         ; ROM0:2F84 - Finalizes frame rendering
    ret                 ; ROM0:2F87 - Ends display update

.org 0x2F8B                ; Input check - User interaction
    and  a              ; ROM0:2F8B - Check A register - Test for input; Tests if input was detected
    jr   z, 0x2F75      ; ROM0:2F8C - If zero, update display - Refresh if no input; Updates screen if no input

.org 0x33900               ; Font Tiles, 8x8 1bpp Japanese Charset 
; AND each byte with 0xF0 to blank out the right half of the tile for an 8×4 test
db 0x00, 0x38, 0x44, 0x44, 0x44, 0x44, 0x44, 0x38  ; "0"
db 0x00, 0x10, 0x30, 0x10, 0x10, 0x10, 0x10, 0x38  ; "1"
db 0x00, 0x38, 0x44, 0x04, 0x18, 0x20, 0x40, 0x7C  ; "2"
db 0x00, 0x38, 0x44, 0x04, 0x18, 0x04, 0x44, 0x38  ; "3"
db 0x00, 0x08, 0x18, 0x28, 0x48, 0x7C, 0x08, 0x08  ; "4"
db 0x00, 0x7C, 0x40, 0x40, 0x78, 0x04, 0x44, 0x38  ; "5"
db 0x00, 0x38, 0x44, 0x40, 0x78, 0x44, 0x44, 0x38  ; "6"
db 0x00, 0x7C, 0x44, 0x08, 0x08, 0x10, 0x10, 0x10  ; "7"
db 0x00, 0x38, 0x44, 0x44, 0x38, 0x44, 0x44, 0x38  ; "8"
db 0x00, 0x38, 0x44, 0x44, 0x3C, 0x04, 0x44, 0x38  ; "9"
db 0x0E, 0x0E, 0x1C, 0x1C, 0x18, 0x00, 0x30, 0x30  ; "!"
db 0x3C, 0x6E, 0x6E, 0x1C, 0x18, 0x00, 0x18, 0x18  ; "?"
db 0x00, 0x00, 0x00, 0x00, 0x7E, 0x00, 0x00, 0x00  ; "-"
db 0x00, 0x00, 0x00, 0x18, 0x18, 0x00, 0x00, 0x00  ; "・"
db 0x3C, 0x20, 0x20, 0x20, 0x20, 0x20, 0x00, 0x00  ; "「"
db 0x00, 0x00, 0x08, 0x08, 0x08, 0x08, 0x08, 0x78  ; "」"
db 0x00, 0x20, 0xFC, 0x20, 0x7C, 0xAA, 0x92, 0x64  ; "あ"
db 0x00, 0x00, 0x44, 0x42, 0x42, 0x42, 0x48, 0x30  ; "い"
db 0x00, 0x38, 0x00, 0x7C, 0x02, 0x02, 0x04, 0x38  ; "う"
db 0x00, 0x10, 0x7C, 0x08, 0x10, 0x38, 0x48, 0x86  ; "え"
db 0x00, 0x22, 0xFA, 0x20, 0x7C, 0xA2, 0xA2, 0x44  ; "お"

.close              ; End of assembly file
