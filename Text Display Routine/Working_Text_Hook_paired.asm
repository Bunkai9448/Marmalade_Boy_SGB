.gb
.open "output.gb", 0

; ============================================================
; ROM0: $17D0
;
; Original sequence:
;
;   push de
;   ld   a,(de)       ; read script byte while script bank is active
;   call $146F        ; select/load glyph
;
; New:
;   save the script bank
;   switch to bank $10
;   execute the original tail from the expanded section
;   restore the script bank
; ============================================================

.org 0x17D0

    push de                  ; Preserve DE, which points to the current script byte.

    ; --------------------------------------------------------
    ; Read the current character while the correct script bank
    ; is still mapped at $4000-$7FFF.
    ; --------------------------------------------------------

    ld   a,(de)              ; A = actual script/text character.
    call 0x146F              ; Load the glyph corresponding to A into CDBD.
                              ; The original bank is restored by 146F.

    ; --------------------------------------------------------
    ; Save the currently selected script bank so it can be
    ; restored after the bank-$10 routine finishes.
    ; --------------------------------------------------------

    ld   a,(0xC8)            ; Read the currently selected ROM bank.
    push af                   ; Preserve the bank value on the stack.

    ; --------------------------------------------------------
    ; Switch the $4000-$7FFF ROM window to bank $10.
    ; --------------------------------------------------------

    ld   a,0x10              ; Select expanded ROM bank $10.
    ldh  (0xC8),a            ; Update the game's bank register.
    ld   (0x3FFF),a          ; Apply the bank switch.

    call 0x4000              ; Execute the relocated $17D0 tail in bank $10.

    ; --------------------------------------------------------
    ; Restore the script bank after returning from bank $10.
    ; --------------------------------------------------------

    pop  af                   ; Recover the original script bank.
    ldh  (0xC8),a             ; Restore the game's bank register.
    ld   (0x3FFF),a           ; Apply the restored bank.

    pop  de                   ; Restore the script pointer.
    ret                       ; Return to the original caller.



; ============================================================
; BANK $10
; physical ROM $40000
;
; NEW: pack two characters' left-4px crops into one shared tile
; instead of writing a full tile per character.
;
; 0xCDF0 = half_phase: 0 = this call starts a new pair (left
;          half), 1 = this call completes it (right half)
; 0xCDF1-0xCDF8 = 8-byte pending buffer holding the merged row
;          data while waiting for the second character
;
; NOTE: 0xCDF0-0xCDF8 worked without incident for the crop-only
; test, but that test never wrote there -- this is the first
; time anything touches that range. Worth watching for in
; testing.
;
; This routine does not perform any bank switching, same as the
; confirmed-working base.
; ============================================================

.org 0x40000

    ld   a,(0xCDF0)
    and  a
    jr   nz,.right_half

.left_half:
    ; Crop to the left 4 pixels (bits 7-4, same mask as the
    ; working crop test) and stash it -- this lands in the
    ; tile's left half, which is exactly where it needs to be.
    ; No VRAM write yet; we don't have the second character.
    ld   hl,0xCDBD
    ld   de,0xCDF1
    ld   b,0x08
.lh_copy:
    ld   a,(hl)
    and  0xF0
    ld   (de),a
    inc  hl
    inc  de
    dec  b
    jr   nz,.lh_copy

    ld   a,0x01
    ld   (0xCDF0),a
    ret

.right_half:
    ; Crop the same way, then shift it into the low nibble --
    ; that's the tile's right half on screen -- and OR it into
    ; the byte the left half already wrote there.
    ld   hl,0xCDBD
    ld   de,0xCDF1
    ld   b,0x08
.rh_merge:
    ld   a,(hl)
    and  0xF0
    srl  a
    srl  a
    srl  a
    srl  a
    ld   c,a
    ld   a,(de)
    or   c
    ld   (de),a
    inc  hl
    inc  de
    dec  b
    jr   nz,.rh_merge

    ; Same tile-index math as the original routine, using THIS
    ; character's own naturally-allocated slot (CDCD+CDE1 right
    ; now) -- the same slot the driver's own tilemap write is
    ; about to use for this same cursor cell, since the cursor
    ; never moved after the left half.
    ld   de,0xCDF1
    ld   hl,0x8000
    ld   a,(0xCDCD)
    ld   b,a
    ld   a,(0xCDE1)
    add  a,b
    cp   a,0x80
    jr   nc,.base
    ld   hl,0x9000
.base:
    ld   c,a
    ld   b,0x00
    sla  c
    rl   b
    sla  c
    rl   b
    sla  c
    rl   b
    sla  c
    rl   b
    add  hl,bc
    ld   b,0x08

.loop:
    ld   a,(de)
    rst  0x20
    inc  hl
    ld   a,(de)
    rst  0x20
    inc  de
    inc  hl
    dec  b
    jr   nz,.loop

    xor  a
    ld   (0xCDF0),a
    ret


; ============================================================
; ROM0: $1790 -- cursor advance, phase-gated.
;
; half_phase == 1 right after bank 10 means we just drew the
; LEFT half -- hold the cursor so the RIGHT half lands in the
; same tilemap cell (the driver re-reads the cursor position
; unchanged and will overwrite that same cell with the correct
; merged tile once the right half runs).
;
; half_phase == 0 means we just completed a pair -- advance one
; full tile, exactly as the verified original bytes do
; (confirmed against the ROM: 23 7d e6 1f c0 7d d6 20 6f 7c de 00).
; ============================================================

.org 0x1790

    ld   a,(0xCDF0)
    and  a
    jr   z,.advance
    ret

.advance:
    inc  hl
    ld   a,l
    and  a,0x1F
    ret  nz
    ld   a,l
    sub  a,0x20
    ld   l,a
    ld   a,h
    sbc  a,0x00
    ld   h,a
    ret

.close
