; Expanded ROM and Bank swap Test

.gb
.open "output.gb", 0

.org 0x0134
    db   "GB MARMALADEBOY" ; ROM0:0134 - Game title
    db   0x31              ; ROM0:0143 - CGB Flag: Does not apply
    db   0x42, 0x32        ; ROM0:0144 - New Licensee Code: "B2" in ASCII (Used only if byte at 0x014B is 0x33)
    db   0x03              ; ROM0:0146 - SGB Flag: 0x03 = supports Super Game Boy functions
    db   0x01              ; ROM0:0147 - Cartridge Type: 0x01 = MBC1 (no RAM, no battery)
    db   0x04              ; ROM0:0148 - ROM Size: 0x04 = 512KB (32 banks of 16KB each)
    db   0x00              ; ROM0:0149 - RAM Size: 0x00 = No RAM on cartridge
    db   0x00              ; ROM0:014A - Destination Code: 0x00 = Japanese
    db   0x33              ; ROM0:014B - Old Licensee Code: 0x33 = Use new licensee code at 0x0144
    db   0x00              ; ROM0:014C - Mask ROM Version
    db   0xF1              ; ROM0:014D - Header Checksum
    db   0x99, 0xC1        ; ROM0:014E - Global Checksum


; Original Tile Data to VRAM + hook trigger in bank 0x10
.org 0x146F
    ld   hl, 0x7900        ; Base VRAM address for tiles
    ld   c, a              ; A contains tile number - low byte
    ld   b, 0x00           ; Clear high byte - BC = tile number
    sla  c                 ; ×2
    rl   b
    sla  c                 ; ×4
    rl   b
    sla  c                 ; ×8 → final ×16 (16 bytes per tile)
    rl   b
    add  hl, bc            ; HL = VRAM address for tile

    ; --- Select ROM bank 0x0C for tile data ---
    ld   a, 0x0C
    ldh  (0xC8), a
    ld   (0x3FFF), a

    ; --- Copy tile data from WRAM to VRAM ---
    ld   bc, 0x0008        ; 8 bytes per tile
    ld   de, 0xCDBD        ; Source in WRAM
    call 0x038E            ; Memory copy routine

    ; --- Switch to bank 0x10 and jump to hook ---
    ld   a, 0x10           ; Bank 0x10
    ldh  (0xC8), a
    ld   (0x3FFF), a
    jp   0x4000            ; Jump to hook code in bank 0x10
; next instruction is at 0x149C, where code is unchanged



; Expanded ROM starts here
.org 0x40000

    ; --- Calculate VRAM tile address for tile number in A ---
;    ld   hl, 0x7900        ; Base VRAM address for tile 0  ; HL = tile_address(tile_index)
    ld   hl, 0x8780        ; Base VRAM address for tile 0
    ld   c, a              ; c = tile index
    ld   b, 0x00           ; bc will hold the byte offset
    sla  c
    rl   b
    sla  c
    rl   b
    sla  c
    rl   b
    add  hl, bc            ; HL = VRAM address for tile ; HL = base + (tile_index * 16)

    ; --- Fill VRAM tile data with 0xFF ---
    ld   b, 0x08           ;  byte counter ; 8 bytes per tile (half black bar) , use 0x10 to do the whole tile
vram_loop:
    ld   (hl), 0xFF        ; write pattern, 0xF0 is half left, 0xFF is full etc
    inc  hl                ; move to next byte in tile data
    dec  b                 ; decrement byte counter
    jr   nz, vram_loop

    ; --- Optional: restore ROM0 bank if needed ---
    ld   a, 0x0C           ; Bank ROM0 tile data
    ldh  (0xC8), a
    ld   (0x3FFF), a

    ret                     ; Return to original game flow


; I was told by Phonymike that, It has to be an even filesize 256KB or 512KB, nothing in between.
; Otherwise emulators will ignore your extra code. So, better safe than sorry.
; This is to fill the remaining ROM space with 0s and reach the appropiate size.
.org 0x7FFFF
.db 0x00


.close
