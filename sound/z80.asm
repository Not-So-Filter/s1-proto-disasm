
Size_of_DAC_driver_guess:	equ $1C5C

                save
                !org    0
                CPU Z80
                listing purecode

z80_stack:		equ 1FF4h
zDAC_NoUpdate:  equ 1FF6h
zDAC_Status:	equ 1FFDh				; Bit 7 set if the driver is not accepting new samples, it is clear otherwise
zDAC_Sample:	equ 1FFFh				; Sample to play, the 68k will move into this locatiton whatever sample that's supposed to be played.

zYM2612_A0:		equ 4000h
zBankRegister:	equ 6000h

; =============== S U B R O U T I N E =======================================


StartOfZ80:
                di					; disable interrupts
                di					; twice
                di					; thrice
                ld      sp, z80_stack
                xor     a
                ld      (zDAC_Status), a
                ld      a, (1FFBh)
                rlca
                ld      (zBankRegister), a
                ld      b, 8
                ld      a, (1FFAh)

loc_16:
                ld      (zBankRegister), a
                rrca
                djnz    loc_16
                jr      loc_2E
; ---------------------------------------------------------------------------
byte_1E:        db    0,   1,   2,   4,   8, 10h, 20h, 40h
                db  80h,0FFh,0FEh,0FCh,0F8h,0F0h,0E0h,0C0h
; ---------------------------------------------------------------------------

loc_2E:
                ld      hl, zDAC_Sample

loc_31:
                ld      a, (hl)
                or      a
                jp      p, loc_31
                push    af
                push    hl
                ld      a, 80h
                ld      (zDAC_Status), a
                ld      hl, zYM2612_A0
                ld      (hl), 2Bh
                inc     hl
                ld      (hl), 80h
                xor     a
                ld      (zDAC_Status), a
                dec     hl
                ld      ix, 1FFCh
                ld      d, 0
                exx
                pop     hl
                ld      (zDAC_NoUpdate), a
                pop     af
                ld      (1FF7h), a
                sub     81h
                ld      (hl), a
                ld      de, 0
                ld      iy, off_160
                cp      6
                jr      c, loc_73
                ld      (1FF7h), a
                ld      (zDAC_NoUpdate), a
                ld      iy, (1FF8h)
                sub     7

loc_73:
                add     a, a
                add     a, a
                ld      c, a
                add     a, a
                add     a, c
                ld      c, a
                ld      b, 0
                add     iy, bc
                ld      e, (iy+0)
                ld      d, (iy+1)
                ld      a, (1FF7h)
                or      a
                jp      m, loc_8F
                ld      hl, (1FF8h)
                add     hl, de
                ex      de, hl

loc_8F:
                ld      c, (iy+2)
                ld      b, (iy+3)
                ld      a, (iy+4)
                ld      (1FFEh), a
                exx
                ld      c, 80h
                exx

loc_9F:
                ld      hl, zDAC_Sample
                ld      a, (de)
                and     0F0h
                rrca
                rrca
                rrca
                rrca
                add     a, byte_1E
                exx
                ld      e, a
                ld      a, (de)
                add     a, c
                ld      c, a
                ld      a, 80h
                ld      (zDAC_Status), a
                ld      b, (iy+0Bh)

loc_B8:
                bit     7, (hl)
                jr      nz, loc_B8
                ld      (hl), 2Ah
                inc     hl
                xor     a
                ld      (hl), c
                ld      (zDAC_Status), a
                dec     hl

loc_C5:
                djnz    $
                exx
                ld      a, (de)
                and     0Fh
                add     a, byte_1E
                exx
                ld      e, a
                ld      a, (de)
                add     a, c
                ld      c, a
                ld      a, 80h
                ld      (zDAC_Status), a
                ld      b, (iy+0Bh)

loc_DA:
                bit     7, (hl)
                jr      nz, loc_DA
                ld      (hl), 2Ah
                inc     hl
                xor     a
                ld      (hl), c
                ld      (zDAC_Status), a
                dec     hl

loc_E7:
                djnz    $
                exx
                bit     7, (iy+5)
                jr      nz, loc_F5
                bit     7, (hl)
                jp      nz, loc_31

loc_F5:
                inc     de
                dec     bc
                ld      a, c
                or      b
                jp      nz, loc_9F
                ld      a, (1FFEh)
                or      a
                jp      z, loc_153
                exx
                jp      p, loc_10C
                and     7Fh
                ld      (ix+0), c

loc_10C:
                dec     a
                ld      (1FFEh), a
                jr      z, loc_133
                ld      c, (ix+0)
                exx
                ld      l, (iy+6)
                ld      h, (iy+7)
                ld      b, h
                ld      c, l
                ld      e, (iy+0)
                ld      d, (iy+1)
                ld      hl, (1FF8h)
                add     hl, de
                ld      e, (iy+2)
                ld      d, (iy+3)
                add     hl, de
                ex      de, hl
                jp      loc_9F
; ---------------------------------------------------------------------------

loc_133:
                ld      c, (ix+0)
                exx
                ld      c, (iy+8)
                ld      b, (iy+9)
                ld      l, (iy+2)
                ld      h, (iy+3)
                ld      e, (iy+0)
                ld      d, (iy+1)
                add     hl, de
                ld      de, (1FF8h)
                add     hl, de
                ex      de, hl
                jp      loc_9F
; ---------------------------------------------------------------------------

loc_153:
                ld      hl, zDAC_NoUpdate
                ld      a, (hl)
                or      a
                jp      m, loc_2E
                xor     a
                ld      (hl), a
                jp      loc_2E
; End of function StartOfZ80

; ---------------------------------------------------------------------------
off_160:        dw zDAC_Sample1
                dw (zDAC_Sample1_End-zDAC_Sample1)
                dw 0
                dw 0
                dw 0
                db 0
                db 14h
                dw zDAC_Sample2
                dw (zDAC_Sample2_End-zDAC_Sample2)
                dw 0
                dw 0
                dw 0
                db 0
                db 1
                dw zDAC_Sample3
                dw (zDAC_Sample3_End-zDAC_Sample3)
                dw 0
                dw 0
                dw 0
                db 0
                db 1Bh

zDAC_Sample1:   binclude       "dac\kick.dpcm"
zDAC_Sample1_End:

zDAC_Sample2:   binclude       "dac\snare.dpcm"
zDAC_Sample2_End:

zDAC_Sample3:   binclude       "dac\timpani.dpcm"
zDAC_Sample3_End:

                restore
	        padding off
	        !org (StartOfZ80+Size_of_DAC_driver_guess)
