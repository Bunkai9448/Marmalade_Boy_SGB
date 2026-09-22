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

; Sample with a bank switch for reference
;    ld   a, 0x10           ; load new Bank 0x10 into register
;    ldh  (0xC8), a         ; load the bank to hram
;    ld   (0x3FFF), a       
;    jp   0x4000            ; Jump to hook code in bank 0x10, address 0x4000 -> 

; CDCA = original script bank 0x03
.org 0x2F00
    db   0x11  ; new script bank

; Original Pointer Table at CPU $4000 / Bank 0x03
.org 0xC000
; Original First Pointer
db 0xD0, 0x46

; Original Script Start
.org 0xC6D0
; Original Text Bytes
db 0xF4, 0x2D

; copy at expanded section
.org 0x44000 ; at CPU 0x4000 / Bank $11
.incbin "Marmalade Boy (Japan).gb", 0x0C000, 0x4000

.org 0x44000 ; it overwrites partially the above insertion, but only the
    db   0x00, 0x50    ; New First Pointer -> 0x5000

.org 0x45000 ; New Script Start with changed text for in-game check
    db   0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08
    db   0x09, 0x0A, 0x0B, 0x0C, 0x0D, 0x0E, 0xF0


; Original Dictionary Pointer Table at
.org 0x13CD0
; Original First Pointer
db 0x70, 0x7D

; Original Address with the First Dict Word used in the game, pointer at org 0x13D2A
.org 0x13EBB
; Original Text Bytes
db 0x10, 0x24


.org 0x33900
; Edited Font data (4x8 characters)
; done in a different file, leaving the address for completeness.

; I was told by Phonymike that, it has to be an even filesize 256KB or 512KB, nothing in between.
; Otherwise emulators will ignore your extra code. So, better safe than sorry.
; This is to fill the remaining ROM space with 0s and reach the appropriate size.
.org 0x7FFFF
.db 0x00


.close
