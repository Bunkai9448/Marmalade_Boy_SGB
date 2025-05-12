.gb
.open "output.gb", 0

.org 0x0134
    db   "GB MARMALADEBOY" ; ROM0:0134 - Game title
    db   0x31            ; ROM0:0143 - Additional header byte
    db   0x42, 0x32      ; ROM0:0144 - Additional header bytes
    db   0x03            ; ROM0:0146 - Additional header byte
    db   0x01            ; ROM0:0147 - Additional header byte
    db   0x03            ; ROM0:0148 - Additional header byte
    db   0x00            ; ROM0:0149 - Additional header byte
    db   0x00            ; ROM0:014A - Additional header byte
    db   0x33            ; ROM0:014B - Additional header byte
    db   0x00            ; ROM0:014C - Additional header byte
    db   0xF1            ; ROM0:014D - Additional header byte
    db   0x99, 0xC1      ; ROM0:014E - Additional header bytes

.org 0x0150
    xor  a              ; ROM0:0150 - Clear A
    ldh  (0xFE), a      ; ROM0:0151 - Store A at 0xFFFE (was 0xFFFE)
    ld   a, 0xFF        ; ROM0:0153 - Load A with 0xFF
    ldh  (0x47), a      ; ROM0:0155 - Store A at 0xFF47 (BGP) (was 0xFF47)
    ldh  (0x48), a      ; ROM0:0157 - Store A at 0xFF48 (OBP0) (was 0xFF48)
    ldh  (0x49), a      ; ROM0:0159 - Store A at 0xFF49 (OBP1) (was 0xFF49)
    di                  ; ROM0:015B - Disable interrupts
    ld   sp, 0xDFFF     ; ROM0:015C - Set stack pointer to 0xDFFF
    ld   hl, 0xFF80     ; ROM0:015F - Load HL with 0xFF80
    ld   bc, 0x007E     ; ROM0:0162 - Load BC with 0x007E
    call 0x037D         ; ROM0:0165 - Call subroutine at 0x037D
    ld   hl, 0xC000     ; ROM0:0168 - Load HL with 0xC000
    ld   bc, 0x1E00     ; ROM0:016B - Load BC with 0x1E00
    call 0x037D         ; ROM0:016E - Call subroutine at 0x037D
    call 0x034B         ; ROM0:0171 - Call subroutine at 0x034B
    ld   a, 0xFE        ; ROM0:0174 - Load A with 0xFE
    ld   (0xC200), a    ; ROM0:0176 - Store A at 0xC200
    xor  a              ; ROM0:0179 - Clear A
    ld   (0xC201), a    ; ROM0:017A - Store A at 0xC201
    ld   a, 0xFF        ; ROM0:017D - Load A with 0xFF
    ld   (0xC202), a    ; ROM0:017F - Store A at 0xC202
    ld   a, 0x0E        ; ROM0:0182 - Load A with 0x0E
    ldh  (0xC8), a      ; ROM0:0184 - Store A at 0xFFC8 (was 0xFFC8)
    ld   (0x3FFF), a    ; ROM0:0186 - Store A at 0x3FFF
    call 0x4000         ; ROM0:0189 - Call subroutine at 0x4000
    ld   a, 0x01        ; ROM0:018C - Load A with 0x01
    ldh  (0xC8), a      ; ROM0:018E - Store A at 0xFFC8 (was 0xFFC8)
    ld   (0x3FFF), a    ; ROM0:0190 - Store A at 0x3FFF
    call 0x02A2         ; ROM0:0193 - Call subroutine at 0x02A2
    call 0x13D7         ; ROM0:0196 - Call subroutine at 0x13D7
    ld   a, 0x01        ; ROM0:0199 - Load A with 0x01
    ldh  (0xFE), a      ; ROM0:019B - Store A at 0xFFFE (was 0xFFFE)
    ld   a, 0x00        ; ROM0:019D - Load A with 0x00
    ldh  (0x41), a      ; ROM0:019F - Store A at 0xFF41 (STAT) (was 0xFF41)
    ld   a, 0x05        ; ROM0:01A1 - Load A with 0x05
    call 0x03A9         ; ROM0:01A3 - Call subroutine at 0x03A9
    ld   hl, 0xFFB9     ; ROM0:01A6 - Load HL with 0xFFB9
    inc  (hl)           ; ROM0:01A9 - Increment value at HL
    ldh  a, (0xB7)      ; ROM0:01AA - Load value at 0xFFB7 into A (was 0xFFB7)
    sla  a              ; ROM0:01AC - Shift A left
    ld   hl, 0x028C     ; ROM0:01AE - Load HL with 0x028C
    rst  0x08           ; ROM0:01B1 - Call reset vector 0x08
    inc  hl             ; ROM0:01B2 - Increment HL
    ld   h, (hl)        ; ROM0:01B3 - Load value at HL into H
    ld   l, a           ; ROM0:01B4 - Load A into L
    jp   hl             ; ROM0:01B5 - Jump to address in HL
    call 0x006B         ; ROM0:01B6 - Call subroutine at 0x006B
    jr   0x01A6         ; ROM0:01B9 - Jump to 0x01A6
    call 0x27BF         ; ROM0:01BB - Call subroutine at 0x27BF
    call 0x0A3D         ; ROM0:01BE - Call subroutine at 0x0A3D
    jr   c, 0x01B6      ; ROM0:01C1 - Jump to 0x01B6 if carry set
    ld   a, 0xFF        ; ROM0:01C3 - Load A with 0xFF
    ldh  (0x47), a      ; ROM0:01C5 - Store A at 0xFF47 (BGP) (was 0xFF47)
    ldh  (0x48), a      ; ROM0:01C7 - Store A at 0xFF48 (OBP0) (was 0xFF48)
    ldh  (0x49), a      ; ROM0:01C9 - Store A at 0xFF49 (OBP1) (was 0xFF49)
    ld   a, 0x00        ; ROM0:01CB - Load A with 0x00
    ldh  (0xFD), a      ; ROM0:01CD - Store A at 0xFFFD (was 0xFFFD)
    ld   hl, 0x4009     ; ROM0:01CF - Load HL with 0x4009
    call 0x007C         ; ROM0:01D2 - Call subroutine at 0x007C
    ld   a, 0x00        ; ROM0:01D5 - Load A with 0x00
    ldh  (0xFD), a      ; ROM0:01D7 - Store A at 0xFFFD (was 0xFFFD)
    ld   hl, 0x4006     ; ROM0:01D9 - Load HL with 0x4006
    call 0x007C         ; ROM0:01DC - Call subroutine at 0x007C
    call 0x28A2         ; ROM0:01DF - Call subroutine at 0x28A2
    ld   hl, 0x4003     ; ROM0:01E2 - Load HL with 0x4003
    call 0x007C         ; ROM0:01E5 - Call subroutine at 0x007C
    ld   a, 0x01        ; ROM0:01E8 - Load A with 0x01
    ldh  (0xB7), a      ; ROM0:01EA - Store A at 0xFFB7 (was 0xFFB7)
    jr   0x01B6         ; ROM0:01EC - Jump to 0x01B6
    call 0x06B8         ; ROM0:01EE - Call subroutine at 0x06B8
    call 0x28A2         ; ROM0:01F1 - Call subroutine at 0x28A2
    call 0x06D7         ; ROM0:01F4 - Call subroutine at 0x06D7
    jr   0x01E8         ; ROM0:01F7 - Jump to 0x01E8
    call 0x06B8         ; ROM0:01F9 - Call subroutine at 0x06B8
    call 0x28A2         ; ROM0:01FC - Call subroutine at 0x28A2
    jr   0x01E8         ; ROM0:01FF - Jump to 0x01E8
    call 0x0718         ; ROM0:0201 - Call subroutine at 0x0718
    call 0x28A2         ; ROM0:0204 - Call subroutine at 0x28A2
    call 0x0737         ; ROM0:0207 - Call subroutine at 0x0737
    jr   0x01E8         ; ROM0:020A - Jump to 0x01E8
    call 0x0718         ; ROM0:020C - Call subroutine at 0x0718
    jr   0x01FC         ; ROM0:020F - Jump to 0x01FC
    call 0x0B7E         ; ROM0:0211 - Call subroutine at 0x0B7E
    call 0x0B8D         ; ROM0:0214 - Call subroutine at 0x0B8D
    call 0x0920         ; ROM0:0217 - Call subroutine at 0x0920
    call 0x0271         ; ROM0:021A - Call subroutine at 0x0271
    ld   a, 0x00        ; ROM0:021D - Load A with 0x00
    ldh  (0xFD), a      ; ROM0:021F - Store A at 0xFFFD (was 0xFFFD)
    ld   hl, 0x4009     ; ROM0:0221 - Load HL with 0x4009
    call 0x007C         ; ROM0:0224 - Call subroutine at 0x007C
    call 0x226F         ; ROM0:0227 - Call subroutine at 0x226F
    call 0x28A2         ; ROM0:022A - Call subroutine at 0x28A2
    ld   hl, 0x401E     ; ROM0:022D - Load HL with 0x401E
    call 0x007C         ; ROM0:0230 - Call subroutine at 0x007C
    call 0x226F         ; ROM0:0233 - Call subroutine at 0x226F
    ld   hl, 0x4021     ; ROM0:0236 - Load HL with 0x4021
    call 0x007C         ; ROM0:0239 - Call subroutine at 0x007C
    jr   0x01E8         ; ROM0:023C - Jump to 0x01E8
    call 0x0B7E         ; ROM0:023E - Call subroutine at 0x0B7E
    call 0x0B8D         ; ROM0:0241 - Call subroutine at 0x0B8D
    call 0x0920         ; ROM0:0244 - Call subroutine at 0x0920
    ld   a, 0x38        ; ROM0:0247 - Load A with 0x38
    call 0x07F8         ; ROM0:0249 - Call subroutine at 0x07F8
    ld   a, 0x00        ; ROM0:024C - Load A with 0x00
    ldh  (0xFD), a      ; ROM0:024E - Store A at 0xFFFD (was 0xFFFD)
    ld   hl, 0x4009     ; ROM0:0250 - Load HL with 0x4009
    call 0x007C         ; ROM0:0253 - Call subroutine at 0x007C
    call 0x22D1         ; ROM0:0256 - Call subroutine at 0x22D1
    call 0x28A2         ; ROM0:0259 - Call subroutine at 0x28A2
    ld   hl, 0x401E     ; ROM0:025C - Load HL with 0x401E
    call 0x007C         ; ROM0:025F - Call subroutine at 0x007C
    call 0x22E3         ; ROM0:0262 - Call subroutine at 0x22E3
    ld   hl, 0x4021     ; ROM0:0265 - Load HL with 0x4021
    call 0x007C         ; ROM0:0268 - Call subroutine at 0x007C
    call 0x3CFB         ; ROM0:026B - Call subroutine at 0x3CFB
    jp   0x01E8         ; ROM0:026E - Jump to 0x01E8
    ld   hl, 0xC800     ; ROM0:0271 - Load HL with 0xC800
    ld   a, 0xF9        ; ROM0:0274 - Load A with 0xF9
    ldi  (hl), a        ; ROM0:0276 - Load A into HL, increment HL
    ld   a, h           ; ROM0:0277 - Load H into A
    cp   0xCC           ; ROM0:0278 - Compare A with 0xCC
    jr   nz, 0x0274     ; ROM0:027A - Jump to 0x0274 if not equal
    ret                 ; ROM0:027C - Return from subroutine
    call 0x06B8         ; ROM0:027D - Call subroutine at 0x06B8
    call 0x28A2         ; ROM0:0280 - Call subroutine at 0x28A2
    call 0x06D7         ; ROM0:0283 - Call subroutine at 0x06D7
    call 0x3CFB         ; ROM0:0286 - Call subroutine at 0x3CFB
    jp   0x01E8         ; ROM0:0289 - Jump to 0x01E8
    jp   0xBB01         ; ROM0:028C - Jump to 0xBB01
    ld   bc, 0x01EE     ; ROM0:028F - Load BC with 0x01EE
    ld   sp, hl         ; ROM0:0292 - Load HL into SP
    ld   bc, 0x01F1     ; ROM0:0293 - Load BC with 0x01F1
    ld   bc, 0x0C02     ; ROM0:0296 - Load BC with 0x0C02
    ld   (bc), a        ; ROM0:0299 - Store A at BC
    inc  b              ; ROM0:029A - Increment B
    ld   (bc), a        ; ROM0:029B - Store A at BC
    ld   de, 0x3E02     ; ROM0:029C - Load DE with 0x3E02
    ld   (bc), a        ; ROM0:029F - Store A at BC
    ld   a, l           ; ROM0:02A0 - Load L into A
    ld   (bc), a        ; ROM0:02A1 - Store A at BC
    ldh  a, (0xC9)      ; ROM0:02A2 - Load value at 0xFFC9 into A (was 0xFFC9)
    ldh  (0xC8), a      ; ROM0:02A4 - Store A at 0xFFC8 (was 0xFFC8)
    ld   (0x3FFF), a    ; ROM0:02A6 - Store A at 0x3FFF
    ld   a, 0x01        ; ROM0:02A9 - Load A with 0x01
    ld   (0xCE2B), a    ; ROM0:02AB - Store A at 0xCE2B
    ld   a, 0x01        ; ROM0:02AE - Load A with 0x01
    ldh  (0xDB), a      ; ROM0:02B0 - Store A at 0xFFDB (was 0xFFDB)
    ldh  (0xDC), a      ; ROM0:02B2 - Store A at 0xFFDC (was 0xFFDC)
    ld   (0xCE2F), a    ; ROM0:02B4 - Store A at 0xCE2F
    call 0x0312         ; ROM0:02B7 - Call subroutine at 0x0312
    ld   a, 0xFF        ; ROM0:02BA - Load A with 0xFF
    ld   (0xCDE3), a    ; ROM0:02BC - Store A at 0xCDE3
    ld   (0xCDD8), a    ; ROM0:02BF - Store A at 0xCDD8
    ld   (0xCDB9), a    ; ROM0:02C2 - Store A at 0xCDB9
    call 0x221A         ; ROM0:02C5 - Call subroutine at 0x221A
    ret                 ; ROM0:02C8 - Return from subroutine
    ldh  a, (0xBB)      ; ROM0:02C9 - Load value at 0xFFBB into A (was 0xFFBB)
    cp   0x0F           ; ROM0:02CB - Compare A with 0x0F
    ret  nz             ; ROM0:02CD - Return if not equal
    ld   a, 0xFF        ; ROM0:02CE - Load A with 0xFF
    ldh  (0x47), a      ; ROM0:02D0 - Store A at 0xFF47 (BGP) (was 0xFF47)
    ldh  (0x48), a      ; ROM0:02D2 - Store A at 0xFF48 (OBP0) (was 0xFF48)
    ldh  (0x49), a      ; ROM0:02D4 - Store A at 0xFF49 (OBP1) (was 0xFF49)
    xor  a              ; ROM0:02D6 - Clear A
    ldh  (0xCA), a      ; ROM0:02D7 - Store A at 0xFFCA (was 0xFFCA)
    ldh  (0xCB), a      ; ROM0:02D9 - Store A at 0xFFCB (was 0xFFCB)
    ld   a, 0x00        ; ROM0:02DB - Load A with 0x00
    ldh  (0xFD), a      ; ROM0:02DD - Store A at 0xFFFD (was 0xFFFD)
    ld   hl, 0x4009     ; ROM0:02DF - Load HL with 0x4009
    call 0x007C         ; ROM0:02E2 - Call subroutine at 0x007C
    ld   a, 0x00        ; ROM0:02E5 - Load A with 0x00
    ldh  (0xFD), a      ; ROM0:02E7 - Store A at 0xFFFD (was 0xFFFD)
    ld   hl, 0x4006     ; ROM0:02E9 - Load HL with 0x4006
    call 0x007C         ; ROM0:02EC - Call subroutine at 0x007C
    ldh  a, (0xBB)      ; ROM0:02EF - Load value at 0xFFBB into A (was 0xFFBB)
    and  a              ; ROM0:02F1 - Test A for zero
    jr   nz, 0x02EF     ; ROM0:02F2 - Jump to 0x02EF if not zero
    jp   0x015B         ; ROM0:02F4 - Jump to 0x015B
    push hl             ; ROM0:02F7 - Push HL to stack
    push de             ; ROM0:02F8 - Push DE to stack
    ldh  a, (0xEF)      ; ROM0:02F9 - Load value at 0xFFEF into A (was 0xFFEF)
    ld   l, a           ; ROM0:02FB - Load A into L
    ldh  a, (0xF0)      ; ROM0:02FC - Load value at 0xFFF0 into A (was 0xFFF0)
    ld   h, a           ; ROM0:02FE - Load A into H
    ld   e, l           ; ROM0:02FF - Load L into E
    ld   d, h           ; ROM0:0300 - Load H into D
    add  hl, hl         ; ROM0:0301 - Add HL to itself
    add  hl, hl         ; ROM0:0302 - Add HL to itself
    add  hl, de         ; ROM0:0303 - Add DE to HL
    ld   de, 0x3711     ; ROM0:0304 - Load DE with 0x3711
    add  hl, de         ; ROM0:0307 - Add DE to HL
    ld   a, h           ; ROM0:0308 - Load H into A
    ld   a, l           ; ROM0:0309 - Load L into A
    ldh  (0xEF), a      ; ROM0:030A - Store A at 0xFFEF (was 0xFFEF)
    ld   a, h           ; ROM0:030C - Load H into A
    ldh  (0xF0), a      ; ROM0:030D - Store A at 0xFFF0 (was 0xFFF0)
    pop  de             ; ROM0:030F - Pop DE from stack
    pop  hl             ; ROM0:0310 - Pop HL from stack
    ret                 ; ROM0:0311 - Return from subroutine
    ld   a, 0x31        ; ROM0:0312 - Load A with 0x31
    ldh  (0xF2), a      ; ROM0:0314 - Store A at 0xFFF2 (was 0xFFF2)
    ld   a, 0x0B        ; ROM0:0316 - Load A with 0x0B
    ldh  (0xF4), a      ; ROM0:0318 - Store A at 0xFFF4 (was 0xFFF4)
    xor  a              ; ROM0:031A - Clear A
    ldh  (0xF3), a      ; ROM0:031B - Store A at 0xFFF3 (was 0xFFF3)
    ldh  (0xF5), a      ; ROM0:031D - Store A at 0xFFF5 (was 0xFFF5)
    ld   a, 0x21        ; ROM0:031F - Load A with 0x21
    ldh  (0xF6), a      ; ROM0:0321 - Store A at 0xFFF6 (was 0xFFF6)
    ld   a, 0x85        ; ROM0:0323 - Load A with 0x85
    ldh  (0xF7), a      ; ROM0:0325 - Store A at 0xFFF7 (was 0xFFF7)
    ret                 ; ROM0:0327 - Return from subroutine
    push hl             ; ROM0:0328 - Push HL to stack
    push de             ; ROM0:0329 - Push DE to stack
    push bc             ; ROM0:032A - Push BC to stack
    ldh  a, (0xF2)      ; ROM0:032B - Load value at 0xFFF2 into A (was 0xFFF2)
    ld   e, a           ; ROM0:032D - Load A into E
    ldh  a, (0xF3)      ; ROM0:032E - Load value at 0xFFF3 into A (was 0xFFF3)
    ld   d, a           ; ROM0:0330 - Load A into D
    ldh  a, (0xF6)      ; ROM0:0331 - Load value at 0xFFF6 into A (was 0xFFF6)
    ld   c, a           ; ROM0:0333 - Load A into C
    ldh  a, (0xF7)      ; ROM0:0334 - Load value at 0xFFF7 into A (was 0xFFF7)
    ld   b, a           ; ROM0:0336 - Load A into B
    call 0x069D         ; ROM0:0337 - Call subroutine at 0x069D
    ldh  a, (0xF4)      ; ROM0:033A - Load value at 0xFFF4 into A (was 0xFFF4)
    ld   e, a           ; ROM0:033C - Load A into E
    ldh  a, (0xF5)      ; ROM0:033D - Load value at 0xFFF5 into A (was 0xFFF5)
    ld   d, a           ; ROM0:033F - Load A into D
    add  hl, de         ; ROM0:0340 - Add DE to HL
    ld   a, h           ; ROM0:0341 - Load H into A
    ldh  (0xF7), a      ; ROM0:0342 - Store A at 0xFFF7 (was 0xFFF7)
    ld   a, l           ; ROM0:0344 - Load L into A
    ldh  (0xF6), a      ; ROM0:0345 - Store A at 0xFFF6 (was 0xFFF6)
    pop  bc             ; ROM0:0347 - Pop BC from stack
    pop  de             ; ROM0:0348 - Pop DE from stack
    pop  hl             ; ROM0:0349 - Pop HL from stack
    ret                 ; ROM0:034A - Return from subroutine
    ld   c, 0x80        ; ROM0:034B - Load C with 0x80
    ld   b, 0x0A        ; ROM0:034D - Load B with 0x0A
    ld   hl, 0x0359     ; ROM0:034F - Load HL with 0x0359
    ldi  a, (hl)        ; ROM0:0352 - Load from HL to A, increment HL
    ld   (0xFF00+c), a  ; ROM0:0353 - Store A at 0xFF00+C
    inc  c              ; ROM0:0354 - Increment C
    dec  b              ; ROM0:0355 - Decrement B
    jr   nz, 0x0352     ; ROM0:0356 - Jump to 0x0352 if not zero
    ret                 ; ROM0:0358 - Return from subroutine
    ld   a, 0xC0        ; ROM0:0359 - Load A with 0xC0
    ldh  (0x46), a      ; ROM0:035B - Store A at 0xFF46 (DMA) (was 0xFF46)
    ld   a, 0x28        ; ROM0:035D - Load A with 0x28
    dec  a              ; ROM0:035F - Decrement A
    jr   nz, 0x035F     ; ROM0:0360 - Jump to 0x035F if not zero
    ret                 ; ROM0:0362 - Return from subroutine
    ldh  a, (0x40)      ; ROM0:0363 - Load value at 0xFF40 into A (was 0xFF40)
    or   a, 0x80        ; ROM0:0365 - OR A with 0x80
    ldh  (0x40), a      ; ROM0:0367 - Store A at 0xFF40 (LCDC) (was 0xFF40)
    ret                 ; ROM0:0369 - Return from subroutine
    ldh  a, (0x40)      ; ROM0:036A - Load value at 0xFF40 into A (was 0xFF40)
    and  a, 0x80        ; ROM0:036C - Mask A with 0x80
    jr   z, 0x037C      ; ROM0:036E - Jump to 0x037C if zero
    ldh  a, (0x44)      ; ROM0:0370 - Load value at 0xFF44 into A (was 0xFF44)
    cp   0x91           ; ROM0:0372 - Compare A with 0x91
    jr   nz, 0x0370     ; ROM0:0374 - Jump to 0x0370 if not equal
    ldh  a, (0x40)      ; ROM0:0376 - Load value at 0xFF40 into A (was 0xFF40)
    and  a, 0x7F        ; ROM0:0378 - Mask A with 0x7F
    ldh  (0x40), a      ; ROM0:037A - Store A at 0xFF40 (LCDC) (was 0xFF40)
    ret                 ; ROM0:037C - Return from subroutine
    xor  a              ; ROM0:037D - Clear A

.org 0x0385
    ld   a, 0xFF        ; ROM0:0385 - Load 0xFF (all bits set) into register A
    ldi  (hl), a        ; ROM0:0387 - Load A into address HL and increment HL
    dec  bc             ; ROM0:0388 - Decrement 16-bit counter BC
    ld   a, c           ; ROM0:0389 - Load lower byte of counter into A
    or   b              ; ROM0:038A - OR with upper byte to check if BC is zero
    jr   nz, 0x0385     ; ROM0:038B - Jump back if BC not zero (fill loop)
    ret                 ; ROM0:038D - Return when fill complete

    ldi  a, (hl)        ; ROM0:038E - Memory copy routine - Load from HL to A, increment HL
    ld   (de), a        ; ROM0:038F - Store A to address DE
    inc  de             ; ROM0:0390 - Increment destination pointer DE
    dec  bc             ; ROM0:0391 - Decrement byte counter BC
    ld   a, b           ; ROM0:0392 - Load upper byte of counter
    or   c              ; ROM0:0393 - OR with lower byte to check if BC is zero
    jr   nz, 0x038E     ; ROM0:0394 - Jump back if more bytes to copy
    ret                 ; ROM0:0396 - Return when copy complete
    ldh  a, (0xD0)      ; ROM0:0397 - Load horizontal scroll value from HRAM (was 0xFFD0)
    ldh  (0x43), a      ; ROM0:0399 - Store to SCX (background X scroll register) (was 0xFF43)
    ldh  a, (0xD1)      ; ROM0:039B - Load vertical scroll value from HRAM (was 0xFFD1)
    ldh  (0x42), a      ; ROM0:039D - Store to SCY (background Y scroll register) (was 0xFF42)
    ret                 ; ROM0:039F - Return after scroll update
    xor  a, 0xFF        ; ROM0:03A0 - Invert all bits in A (one's complement)
    ld   b, a           ; ROM0:03A2 - Store mask in B
    ldh  a, (0xFF)      ; ROM0:03A3 - Load interrupt enable register (was 0xFFFF)
    and  b              ; ROM0:03A5 - Clear bits where B is 0
    ldh  (0xFF), a      ; ROM0:03A6 - Store updated interrupt enable (was 0xFFFF)
    ret                 ; ROM0:03A8 - Return after interrupt mask update
    ld   b, a           ; ROM0:03A9 - Save value in B
    xor  a              ; ROM0:03AA - Clear A (set to 0)
    ldh  (0x0F), a      ; ROM0:03AB - Clear interrupt flag register (was 0xFF0F)
    ldh  a, (0xFF)      ; ROM0:03AD - Load interrupt enable register (was 0xFFFF)
    or   b              ; ROM0:03AF - Set bits from saved value
    ldh  (0xFF), a      ; ROM0:03B0 - Store updated interrupt enable (was 0xFFFF)
    ret                 ; ROM0:03B2 - Return after interrupt enable update
    ld   e, c           ; ROM0:03B3 - Load low byte into E
    ld   d, 0x00        ; ROM0:03B4 - Clear high byte D
    ld   c, 0x05        ; ROM0:03B6 - Set loop counter to 5
    sla  e              ; ROM0:03B8 - Shift E left (multiply by 2)
    rl   d              ; ROM0:03BA - Rotate D left with carry
    dec  c              ; ROM0:03BC - Decrement loop counter
    jr   nz, 0x03B8     ; ROM0:03BD - Repeat shift 5 times (multiply by 32)
    ld   a, b           ; ROM0:03BF - Load value from B
    or   e              ; ROM0:03C0 - Combine with shifted result
    ld   e, a           ; ROM0:03C1 - Store result in E
    ret                 ; ROM0:03C2 - Return with 16-bit result in DE
    ld   a, d           ; ROM0:03C3 - Load high byte
    ldh  (0x8B), a      ; ROM0:03C4 - Store to HRAM temp high byte (was 0xFF8B)
    ld   a, e           ; ROM0:03C6 - Load low byte
    and  a, 0xE0        ; ROM0:03C7 - Mask upper 3 bits (tile Y)
    ldh  (0x8A), a      ; ROM0:03C9 - Store to HRAM temp coordinate (was 0xFF8A)
    ld   a, e           ; ROM0:03CB - Reload low byte
    and  a, 0x1F        ; ROM0:03CC - Mask lower 5 bits (tile X)
    ldh  (0x8C), a      ; ROM0:03CE - Store to HRAM temp X (was 0xFF8C)
    ldh  a, (0xD0)      ; ROM0:03D0 - Load scroll X from HRAM (was 0xFFD0)
    srl  a              ; ROM0:03D2 - Divide by 2
    srl  a              ; ROM0:03D4 - Divide by 4
    srl  a              ; ROM0:03D6 - Divide by 8 (convert pixels to tiles)
    ld   b, a           ; ROM0:03D8 - Save tile offset
    ldh  a, (0x8C)      ; ROM0:03D9 - Load temp X coordinate (was 0xFF8C)
    add  a, b           ; ROM0:03DB - Add scroll offset
    and  a, 0x1F        ; ROM0:03DC - Wrap around at 32 tiles
    ld   b, a           ; ROM0:03DE - Save adjusted X
    ldh  a, (0x8A)      ; ROM0:03DF - Load temp coordinate (was 0xFF8A)
    or   b              ; ROM0:03E1 - Combine with X position
    ldh  (0x8A), a      ; ROM0:03E2 - Store updated coordinate (was 0xFF8A)
    ld   c, 0x00        ; ROM0:03E4 - Clear carry register
    ldh  a, (0xD1)      ; ROM0:03E6 - Load scroll Y from HRAM (was 0xFFD1)
    sla  a              ; ROM0:03E8 - Multiply by 2
    rl   c              ; ROM0:03EA - Rotate carry into C
    sla  a              ; ROM0:03EC - Multiply by 4
    rl   c              ; ROM0:03EE - Rotate carry into C
    and  a, 0xE0        ; ROM0:03F0 - Mask to tile coordinate
    ld   b, a           ; ROM0:03F2 - Save Y tile position
    ldh  a, (0x8A)      ; ROM0:03F3 - Load coordinate (was 0xFF8A)
    add  a, b           ; ROM0:03F5 - Add Y position
    ldh  (0x8A), a      ; ROM0:03F6 - Store updated coordinate (was 0xFF8A)
    ldh  a, (0x8B)      ; ROM0:03F8 - Load high byte (was 0xFF8B)
    adc  a, c           ; ROM0:03FA - Add carry from Y calculation
    and  a, 0xFB        ; ROM0:03FB - Clear unused bits
    ldh  (0x8B), a      ; ROM0:03FD - Store updated high byte (was 0xFF8B)
    ldh  a, (0x8A)      ; ROM0:03FF - Load final coordinate (was 0xFF8A)
    ld   e, a           ; ROM0:0401 - Store in E
    ldh  a, (0x8B)      ; ROM0:0402 - Load final high byte (was 0xFF8B)

.org 0x0572
    ; Placeholder for subroutine, check user input (Gamepad and buttons)

.org 0x1462
    call 0x14A1         ; ROM0:1462 - Get script offsets - Call script initialization; Starts text processing for dialogue or menu
    push af             ; ROM0:1465 - Save A and flags - Preserve state; Saves accumulator and flags for bank switching
    ldh  a, (0xC9)      ; ROM0:1466 - Load from HRAM - Get bank/offset value (was 0xFFC9); Retrieves current ROM bank from HRAM
    ldh  (0xC8), a      ; ROM0:1468 - Store to HRAM - Save for later (was 0xFFC8); Backs up bank number for restoration
    ld   (0x3FFF), a    ; ROM0:146A - Possibly bank switch or VRAM - Set memory bank; Switches to the bank stored in 0xFFC9
    pop  af             ; ROM0:146D - Restore A and flags - Recover state; Restores state before returning
    ret                 ; ROM0:146E - Returns to 0x2F8B - Exit subroutine; Ends bank switch and script init

.org 0x146F             ; Tile Data to VRAM
    ld   hl, 0x7900     ; ROM0:146F - Sets VRAM address for tile data (0x7900-0x7FFF range)
    ld   c, a           ; ROM0:1472 - A contains tile number - Set low byte; Sets tile index from accumulator
    ld   b, 0x00        ; ROM0:1473 - Clear high byte - BC = tile number; Ensures BC is a 16-bit tile number with high byte zero
    sla  c              ; ROM0:1475 - Multiply by 8 - Shift left; Begins multiplying tile number by 16 (tile size)
    rl   b              ; ROM0:1477 - (tile data is 8 bytes per tile) - Rotate carry; Handles carry for 16-bit shift
    sla  c              ; ROM0:1479 - Shift Left Arithmetic effectively multiplies c by 2; Continues multiplication (now ×4)
    rl   b              ; ROM0:147B - Rotate Left through Carry on register b.; Handles carry
    sla  c              ; ROM0:147D; Multiplies by 8; Final shift to ×16 (16 bytes per tile in VRAM)
    rl   b              ; ROM0:147F; Handles overflow; Completes 16-bit shift
    add  hl, bc         ; ROM0:1481 - Calculate tile address - Add offset to base; Computes final VRAM address for tile
    ld   a, 0x0C        ; ROM0:1483 - Possibly bank number - Set ROM bank; Selects bank 0x0C for tile data
    ldh  (0xC8), a      ; ROM0:1485 - Store to HRAM - Save bank (was 0xFFC8); Updates HRAM with new bank number
    ld   (0x3FFF), a    ; ROM0:1487 - Store to banking register - Switch bank; Switches ROM to bank 0x0C
    ld   bc, 0x0008     ; ROM0:148A - 8 bytes to copy - Tile data size; Sets copy size (8 bytes, half a tile for 4x8?)
    ld   de, 0xCDBD     ; ROM0:148D - Source in WRAM - Tile data location; Points to tile data buffer in WRAM
    call 0x038E         ; ROM0:1490 - Memory copy routine - Copy tile to VRAM; Copies tile data to VRAM
    ld   a, (0xCDCA)    ; ROM0:1493 - Load previous value - Get old bank; Retrieves previous bank number
    ldh  (0xC8), a      ; ROM0:1496 - Restore bank - Return to previous bank (was 0xFFC8); Restores HRAM bank value
    ld   (0x3FFF), a    ; ROM0:1498 - Restore banking register - Update hardware; Switches back to original bank
    ret                 ; ROM0:149B - Return from tile copy; Ends tile loading routine

.org 0x149B
    ldh  a, (0xBC)      ; ROM0:149B - Load from HRAM - Get value (was 0xFFBC); Reads a game state or flag from HRAM
    ld   (0xCDC7), a    ; ROM0:149D - Store to WRAM - Save in work RAM; Backs up value to WRAM for later use
    ret                 ; ROM0:14A0 - Return from backup; Ends backup routine

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

.org 0x14E1
    ld   a, (0xCDDE)    ; ROM0:14E1 - Load counter - Get script delay/progress; Loads text delay or progress counter
    and  a              ; ROM0:14E4 - Check if zero - Test completion; Tests if delay is complete
    jp   z, 0x14EF      ; ROM0:14E5 - If zero, process next - Move to next step; Advances script if delay done
    ld   hl, 0xCDDE     ; ROM0:14E8 - Counter address - Point to counter; Points to delay counter
    dec  (hl)           ; ROM0:14EB - Decrease counter - Count down; Decrements delay
    jp   0x155D         ; ROM0:14EC - Continue processing - Keep going; Continues current script state
    ld   a, (0xCDDF)    ; ROM0:14EF - Load default counter - Get reset value; Loads default delay value
    ld   (0xCDDE), a    ; ROM0:14F2 - Reset counter - Restore delay; Resets delay counter
    ld   a, (0xCDDC)    ; ROM0:14F5 - Load script pointer low - Get address low; Loads low byte of script address
    ld   e, a           ; ROM0:14F8 - Store in E; Sets DE low byte
    ld   a, (0xCDDD)    ; ROM0:14F9 - Load script pointer high - Get address high; Loads high byte of script address
    ld   d, a           ; ROM0:14FC - Store in D - DE now points to script; DE now holds script pointer

.org 0x14FD
    ld   a, (de)        ; ROM0:14FD - Load character from script - Get next byte; Reads next script byte
    cp   0xE0           ; ROM0:14FE - Check if control code - Compare with boundary; Checks if byte is a control code (? 0xE0)
    jr   c, 0x150E      ; ROM0:1500 - If regular char, process - Below E0 is text; Processes as text if < 0xE0
    sub  a, 0xE0        ; ROM0:1502 - Adjust control code value - Normalize code; Converts code to table index
    sla  a              ; ROM0:1504 - Shift left; Doubles index for word-sized table
    ld   hl, 0x1CF8     ; ROM0:1506 - Set handler table address; Points to control code jump table
    rst  0x08           ; ROM0:1509 - Call reset vector 0x08; Computes table address (adds A to HL)
    inc  hl             ; ROM0:150A - Move to handler address; Points to high byte of handler
    ld   h, (hl)        ; ROM0:150B - Load high byte of address; Loads handler address high byte
    ld   l, a           ; ROM0:150C - Load low byte from A; Sets low byte from adjusted code
    jp   hl             ; ROM0:150D - Jump to handler; Jumps to control code handler

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

.org 0x171C             ; Screen boundary check - Validate position
    ld   a, (0xCDD9)    ; ROM0:171C - Load value from memory at 0xCDD9 into a; Loads screen boundary flag
    and  a              ; ROM0:171F - Test if a is zero; Checks if boundary checking is enabled
    jr   z, 0x1729      ; ROM0:1720 - Jump to 0x1729 if a is zero; Skips check if disabled
    ld   a, h           ; ROM0:1722 - Load high byte (h) into a; Gets Y position high byte
    cp   a, 0xA0        ; ROM0:1723 - Compare a with 0xA0 (screen boundary?); Checks if beyond VRAM tilemap (0x9800-0x9FFF)
    ret  c              ; ROM0:1725 - Return if a < 0xA0; Returns if within bounds
    ld   h, 0x9C        ; ROM0:1726 - Set h to 0x9C (clamp to boundary); Clamps Y to top of tilemap
    ret                 ; ROM0:1728 - Return; Ends boundary check

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

.org 0x17D0               ; subroutine convert character to tile
    push de               ; ROM0:17D0 D5 - Save the value of DE register pair to stack
    ld   a,(de)           ; ROM0:17D1 1A - Load the value at the memory location pointed to by DE into register A
    call 0x146F           ; ROM0:17D2 CD 6F 14 - Call function at address 0x146F
    ld   de,0xCDBD        ; ROM0:17D5 11 BD CD - Load the address 0xCDBD into DE register pair
    ld   hl,0x8000        ; ROM0:17D8 21 00 80 - Load the address 0x8000 into HL register pair
    ld   a,(0xCDCD)       ; ROM0:17DB FA CD CD - Load the value at address 0xCDCD into register A
    ld   b,a              ; ROM0:17DE 47 - Copy value from register A into register B
    ld   a,(0xCDE1)       ; ROM0:17DF FA E1 CD - Load the value at address 0xCDE1 into register A
    add a,b               ; ROM0:17E2 80 - Add the value of register B to register A
    cp   a,0x80           ; ROM0:17E3 FE 80 - Compare register A with 0x80
    jr   nc,0x17EA        ; ROM0:17E5 30 03 - Jump if no carry (A >= 0x80) to address 0x17EA
    ld   hl,0x9000        ; ROM0:17E7 21 00 90 - Load the address 0x9000 into HL register pair
    ld   c,a              ; ROM0:17EA 4F - Copy the value of A into register C
    ld   b,0x00           ; ROM0:17EB 06 00 - Set register B to 0 (initialize counter)
    sla  c                ; ROM0:17ED CB 21 - Perform a left shift on register C (multiply by 2)
    rl   b                ; ROM0:17EF CB 10 - Rotate left through carry on register B
    sla  c                ; ROM0:17F1 CB 21 - Perform another left shift on register C (multiply by 2)
    rl   b                ; ROM0:17F3 CB 10 - Rotate left through carry on register B
    sla  c                ; ROM0:17F5 CB 21 - Perform another left shift on register C (multiply by 2)
    rl   b                ; ROM0:17F7 CB 10 - Rotate left through carry on register B
    sla  c                ; ROM0:17F9 CB 21 - Perform another left shift on register C (multiply by 2)
    rl   b                ; ROM0:17FB CB 10 - Rotate left through carry on register B
    add  hl,bc            ; ROM0:17FD 09 - Add the value of BC to HL (calculate address offset)
    ld   b,0x08           ; ROM0:17FE 06 08 - Set register B to 8 (loop counter)
    ld   a,(de)           ; ROM0:1800 1A - Load the value at address DE into register A
    rst  0x20             ; ROM0:1801 E7 - Call the subroutine at address 0x0020 (software interrupt)
    inc  hl               ; ROM0:1802 23 - Increment the HL register pair
    ld   a,(de)           ; ROM0:1803 1A - Load the value at address DE into register A
    rst  0x20             ; ROM0:1804 E7 - Call the subroutine at address 0x0020 (software interrupt)
    inc  de               ; ROM0:1805 13 - Increment the DE register pair
    inc  hl               ; ROM0:1806 23 - Increment the HL register pair
    dec  b                ; ROM0:1807 05 - Decrement the value in register B (loop counter)
    jr   nz,0x1800        ; ROM0:1808 20 F6 - Jump to address 0x1800 if B is not zero (repeat loop)
    pop  de               ; ROM0:180A D1 - Restore the value of DE register pair from stack
    ret                   ; ROM0:180B C9 - Return from the current subroutine

.org 0x1BBC          ; Start of routine - Buffer management
    ld   a, (0xCDC6)    ; ROM0:1BBC - Load a flag or counter from WRAM; Checks text buffer state
    and  a              ; ROM0:1BBF - Test if a is zero; Tests if buffer is ready
    ret  nz             ; ROM0:1BC0 - Return if non-zero, else continue; Exits if buffer busy
    ldh  a, (0xB8)      ; ROM0:1BC1 - Load value from HRAM at 0xFFB8 into a; Loads current character or state
    cp   a, 0x26        ; ROM0:1BC3 - Compare a with 0x26 (check specific state); Checks for special char (e.g., punctuation)
    jr   z, 0x1BEE      ; ROM0:1BC5 - Jump to 0x1BEE if equal (handle case 0x26); Handles special case
    cp   a, 0x2D        ; ROM0:1BC7 - Compare a with 0x2D (another state check); Checks for another special char
    jr   z, 0x1BEE      ; ROM0:1BC9 - Jump to 0x1BEE if equal (handle case 0x2D); Handles special case
    cp   a, 0x05        ; ROM0:1BCB - Compare a with 0x05; Checks for control code or space
    jr   z, 0x1BD9      ; ROM0:1BCD - Jump to 0x1BD9 if equal (handle case 0x05); Processes space-like char
    cp   a, 0x20        ; ROM0:1BCF - Compare a with 0x20; Checks for space character
    jr   z, 0x1BD9      ; ROM0:1BD1 - Jump to 0x1BD9 if equal (handle case 0x20); Processes space
    cp   a, 0x11        ; ROM0:1BD3 - Compare a with 0x11; Checks for another control code
    jr   z, 0x1BD9      ; ROM0:1BD5 - Jump to 0x1BD9 if equal (handle case 0x11); Processes special char
    jr   0x1BF2         ; ROM0:1BD7 - Jump to 0x1BF2 (default case); Handles regular characters
    ld   hl, 0xCDD6     ; ROM0:1BD9 - Load address 0xCDD6 into hl (start of 0x05/0x20/0x11 case); Points to text flag
    bit  0, (hl)        ; ROM0:1BDC - Test bit 0 of value at (hl); Checks if space rendering is enabled
    jr   nz, 0x1BF2     ; ROM0:1BDE - Jump to 0x1BF2 if bit 0 is set; Treats as regular char if flag set
    ld   a, (0xD505)    ; ROM0:1BE0 - Load value from 0xD505 (another WRAM check); Checks text mode or counter
    and  a              ; ROM0:1BE3 - Test if a is zero; Tests if mode is active
    jr   z, 0x1BF2      ; ROM0:1BE4 - Jump to 0x1BF2 if zero; Treats as regular char if inactive
    cp   a, 0x03        ; ROM0:1BE6 - Compare a with 0x03; Checks for specific mode
    jr   z, 0x1BF6      ; ROM0:1BE8 - Jump to 0x1BF6 if equal (set 0x05); Sets special buffer state
    cp   a, 0x04        ; ROM0:1BEA - Compare a with 0x04; Checks for another mode
    jr   z, 0x1BF6      ; ROM0:1BEC - Jump to 0x1BF6 if equal (set 0x05); Sets special buffer state
    ld   a, 0x04        ; ROM0:1BEE - Load 0x04 into a (case 0x26/0x2D); Sets buffer state for punctuation
    jr   0x1BF8         ; ROM0:1BF0 - Jump to 0x1BF8 (store and return); Stores and exits
    ld   a, 0x05        ; ROM0:1BF2 - Load 0x05 into a (default case); Sets default buffer state for text
    jr   0x1BF8         ; ROM0:1BF4 - Jump to 0x1BF8 (store and return); Stores and exits
    ld   a, 0x06        ; ROM0:1BF6 - Load 0x06 into a (case 0x03/0x04); Sets buffer state for special mode
    ldh  (0xCB), a      ; ROM0:1BF8 - Store a into HRAM at 0xFFCB; Updates text buffer control in HRAM
    ret                 ; ROM0:1BFA - Return; Ends buffer management

.org 0x1D88 ; Control code handler (In the dictionary section)
    ld   a, (de)        ; ROM0:1D88 - Load character - Get next script byte; Reads next script byte
    cp   0xFD           ; ROM0:1D89 - Checks for Tenten-kana
    jr   z, 0x1DAF      ; ROM0:1D8B - Jump to handle tenten
    cp   0xFE           ; ROM0:1D8D - Checks for Maruten-kana
    jr   z, 0x1DB3      ; ROM0:1D8F - Jump to handle maruten
    cp   0xFF           ; ROM0:1D91 - Checks for space character
    jr   z, 0x1DE2      ; ROM0:1D93 - Jump to handle space
    cp   0xF0           ; ROM0:1D95 - Checks for text end code
    jp   z, 0x1E2F      ; ROM0:1D97 - Jump to end text processing
    cp   0xF2           ; ROM0:1D9A - Checks for newline code
    jr   z, 0x1DE9      ; ROM0:1D9C - Jump to handle newline
    cp   0xF3           ; ROM0:1D9E - Check for skip input (?)
    jp   z, 0x1E21      ; ROM0:1DA0 - Skips input delay
    cp   0xFB           ; ROM0:1DA3 - Checks for buffer continue code (?)
    jp   z, 0x1E41      ; ROM0:1DA5 - Continues text buffer
    cp   0xFC           ; ROM0:1DA8 - Checks for ellipsis '...' code
    jp   z, 0x1E85      ; ROM0:1DAA - Jump to handle ellipsis
    jr   0x1DC4         ; ROM0:1DAD - Processes regular text char (actual display print?)

.org 0x1DAF           ; ROM0:1DAF - Set program start address at 0x1DAF

    ld   b,0xFA          ; ROM0:1DAF - Load 0xFA into register B (preparing a value)
    jr   0x1DB5          ; ROM0:1DB1 - Jump to address 0x1DB5 (relative jump)
    ld   b,0xFB          ; ROM0:1DB3 - Load 0xFB into register B (update the value in B)
    ld   a,(0xCDDA)      ; ROM0:1DB5 - Load the value at memory address 0xCDDA into register A
    ld   l,a             ; ROM0:1DB8 - Copy the value from A into register L (lower byte of HL)
    ld   a,(0xCDDB)      ; ROM0:1DB9 - Load the value at memory address 0xCDDB into register A
    ld   h,a             ; ROM0:1DBC - Copy the value from A into register H (upper byte of HL)
    ld   a,b             ; ROM0:1DBD - Load the value from register B into A
    rst  0x20            ; ROM0:1DBE - Call software interrupt (RST 0x20), typically used for specific tasks like graphics or sound
    inc  de              ; ROM0:1DBF - Increment the value in register pair DE (typically used for pointer increment)
    ld   hl,0xCDE0       ; ROM0:1DC0 - Load memory address 0xCDE0 into HL register pair (pointer to a location in memory)
    inc  (hl)            ; ROM0:1DC3 - Increment the value at the memory address pointed to by HL (likely updating data at that location)


.org 0x1DC4 ; Character processing - Text to display conversion
    call 0x17D0         ; ROM0:1DC4 - Character to tile
    call 0x1BBC         ; ROM0:1DC7 - Buffer management - Add to display buffer
    ld   a, (0xCDDA)    ; ROM0:1DCA - Load current position - Get X coordinate
    ld   l, a           ; ROM0:1DCD - Store in L; Sets HL low byte
    ld   a, (0xCDDB)    ; ROM0:1DCE - Get Y coordinate
    ld   h, a           ; ROM0:1DD1 - Store in H - HL = position; HL holds cursor position
    ld   bc, 0x0020     ; ROM0:1DD2 - Next line offset - 32 tiles per line; Sets offset for next tilemap row
    add  hl, bc         ; ROM0:1DD5 - Advance position - Move to next line; Advances cursor to next line
    call 0x171C         ; ROM0:1DD7 - Screen boundary check - Validate position; Ensures cursor stays on screen

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

.org 0x1E85               ; ROM0:1E85 - Set program start address
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


.org 0x2F25          ; Line count check - Text formatting (default case ends game intro)
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

.org 0x2F75 ; Display update - Screen refresh
    call 0x0B8D         ; ROM0:2F75 - Various screen - Update routine 1; Updates background tiles
    call 0x24FA         ; ROM0:2F78 - update routines - Update routine 2; Updates sprite positions
    call 0x1B3C         ; ROM0:2F7B - Update routine 3; Updates text buffer to VRAM
    call 0x1B50         ; ROM0:2F7E - Update routine 4; Adjusts scroll values
    call 0x26CE         ; ROM0:2F81 - Update routine 5; Refreshes palettes
    call 0x0B9D         ; ROM0:2F84 - Update routine 6; Finalizes frame rendering
    ret                 ; ROM0:2F87 - Returns to 0x01BE - Complete update; Ends display update

.org 0x2F8B ; Input check - User interaction
    and  a              ; ROM0:2F8B - Check A register - Test for input; Tests if input was detected
    jr   z, 0x2F75      ; ROM0:2F8C - If zero, update display - Refresh if no input; Updates screen if no input

.org 0x33900 ; Font Tiles, 8x8 1bpp Japanese Charset // AND each byte with 0xF0 to blank out the right half of the tile for an 8×4 test
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
