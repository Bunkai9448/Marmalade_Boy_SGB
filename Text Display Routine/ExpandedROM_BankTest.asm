; Expanded ROM and Bank swap Test
.gb
.open "output.gb", 0

.org 0x0134
    db "TEST MARMALADEY" ; ROM0:0134 - Game title
    db 0x31           ; ROM0:0143 - CGB Flag: Does not apply
    db 0x42, 0x32     ; ROM0:0144 - New Licensee Code: "B2" in ASCII
    db 0x03           ; ROM0:0146 - SGB Flag: Supports Super Game Boy
    db 0x01           ; ROM0:0147 - Cartridge Type: MBC1
    db 0x04           ; ROM0:0148 - ROM Size: 512KB
    db 0x00           ; ROM0:0149 - RAM Size: No RAM
    db 0x00           ; ROM0:014A - Destination Code: Japanese
    db 0x33           ; ROM0:014B - Old Licensee Code: Use new licensee code
    db 0x00           ; ROM0:014C - Mask ROM Version
    db 0xEB           ; ROM0:014D - Header Checksum (recalculate if needed)
    db 0x99, 0xC1     ; ROM0:014E - Global Checksum (unchanged)

; Original text load to modify with the Bank Swap Test next
.org 0x1E33               ; display each character
    ld   a,0xF0           ; ROM0:1E33 - Load 0xF0 into A
    push af               ; ROM0:1E35 - Save AF to stack
    ld   a,0x0F           ; ROM0:1E36 - Load bank number 0x10 into A
    ldh  (0xC8), a        ; ROM0:1E38 - Store A to 0xFFC8
    ld   (0x3FFF),a       ; ROM0:1E3A - Set ROM bank to 0x10
    pop  af               ; ROM0:1E3C - Restore AF from stack
    pop  de               ; ROM0:1E3D - Restore DE from stack
    ret                   ; ROM0:1E3E - Return

; This swaps the first word in the game with <ぶんかい> for testing purposes
.org 0x13EBB
.db 0xFD, 0x2B, 0x3D, 0x15, 0x11, 0xF0 ; FD=゛ 2B=ふ 3D=ん 15=か 11=い F0=<END>


; Expanded ROM starts here
.org 0x40000         ; 0x40000 is in Bank 15 = 0x10 (Banks from 0 to 15)
.db 0xFD, 0x2B, 0x3D, 0x15, 0x11, 0xF0 ; FD=゛ 2B=ふ 3D=ん 15=か 11=い F0=<END>

; I was told by Phonymike that, It has to be an even filesize 256KB or 512KB, nothing in between.
; Otherwise emulators will ignore your extra code. So, better safe than sorry.
; This is to fill the remaining ROM space with 0s and reach the appropiate size.
.org 0x7FFFF
.db 0x00

.close
