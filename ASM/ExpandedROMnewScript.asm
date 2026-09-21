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
    db   0xF0              ; ROM0:014D - Header Checksum
    db   0x99, 0xC1        ; ROM0:014E - Global Checksum

; Original Pointer Table at
.org 0xC000
; Original First Pointer
db 0xC6D0

; Original Script Start
.org 0xC6D0
; Original Text Bytes
db 0xF4, 0x2D

; Original Dictionary Pointer Table at
.org 0x13CD0
; Original First Pointer
db 0x13D70

; Original Address with the First Dict Word used in the game, pointer at org 0x13D2A
.org 0x13EBB
; Original Text Bytes
db 0x10, 0x24

    ; --- Switch to bank 0x10 and jump to hook ---
;    ld   a, 0x10           ; Bank 0x10
;    ldh  (0xC8), a
;    ld   (0x3FFF), a
;    jp   0x4000            ; Jump to hook code in bank 0x10


; Expanded ROM starts here
;.org 0x40000
    ; --- Optional: restore ROM0 bank if needed ---
;    ld   a, 0x0C           ; Bank ROM0 tile data
;    ldh  (0xC8), a
;    ld   (0x3FFF), a
;    ret                     ; Return to original game flow

.org 0x33900
; Edited Font data (4x8 characters)
; done in a diferent file, leaving the address for completeness.

; I was told by Phonymike that, It has to be an even filesize 256KB or 512KB, nothing in between.
; Otherwise emulators will ignore your extra code. So, better safe than sorry.
; This is to fill the remaining ROM space with 0s and reach the appropiate size.
.org 0x7FFFF
.db 0x00


.close
