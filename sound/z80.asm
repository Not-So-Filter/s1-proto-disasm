
zmake68kPtr  function addr,zROMWindow+(addr&7FFFh)
zmake68kBank function addr,(((addr&0FF8000h)/zROMWindow))

; function to decide whether an offset's full range won't fit in one byte
offsetover1byte function from,maxsize, ((from&0FFh)>(100h-maxsize))

; macro to make sure that ($ & 0FF00h) == (($+maxsize) & 0FF00h)
ensure1byteoffset macro maxsize
	if offsetover1byte($,maxsize)
startpad := $
		align 100h
	    if MOMPASS=1
endpad := $
		if endpad-startpad>=1h
							; warn because otherwise you'd have no clue why you're running out of space so fast
			message "had to insert \{endpad-startpad}h   bytes of padding before improperly located data at 0\{startpad}h in Z80 code"
		endif
	    endif
	endif
    endm

		save
		phase	0				; set Z80 location to 0
		cpu z80					; use Z80 cpu
		listing purecode			; add to listing file

; =============== S U B R O U T I N E =======================================


StartOfZ80:
		di					; 4 disable interrupts
		di					; 4
		di					; 4
		ld	sp,z80_stack			; 10
		xor	a				; 4
		ld	(zDAC_Status),a			; 13
		ld	a,(zUnk_1FFB)			; 13
		rlca					; 4
		ld	(zBankRegister),a		; 13
		ld	b,8				; 7
		ld	a,(zUnk_1FFA)			; 13

loc_16:
		ld	(zBankRegister),a		; 13
		rrca					; 4
		djnz	loc_16				; 13/8
		jr	loc_2E				; 12
; ===========================================================================
; JMan2050's DAC decode lookup table
; ===========================================================================
	ensure1byteoffset 10h
zDACDecodeTbl:
	db	   0,	 1,   2,   4,   8,  10h,  20h,  40h
	db	 80h,	-1,  -2,  -4,  -8, -10h, -20h, -40h
; ---------------------------------------------------------------------------

loc_2E:
		ld	hl,zDAC_Sample			; 10

loc_31:
		ld	a,(hl)				; 7
		or	a				; 4
		jp	p,loc_31			; 10
		push	af				; 11
		push	hl				; 11
		ld	a,80h				; 7
		ld	(zDAC_Status),a			; 13
		ld	hl,zYM2612_A0			; 10
		ld	(hl),2Bh			; 10
		inc	hl				; 6
		ld	(hl),80h			; 10
		xor	a				; 4
		ld	(zDAC_Status),a			; 13
		dec	hl				; 6
		ld	ix,zUnk_1FFC			; 14
		ld	d,0				; 7
		exx					; 4
		pop	hl				; 10
		ld	(zDAC_Update),a			; 13
		pop	af				; 10
		ld	(zUnk_1FF7),a			; 13
		sub	81h				; 7
		ld	(hl),a				; 7
		ld	de,0				; 10
		ld	iy,zPCM_Table			; 14
		cp	6				; 7	; Is the sample 87h or higher?
		jr	c,loc_73			; 12/7	; If not, branch
		ld	(zUnk_1FF7),a			; 13
		ld	(zDAC_Update),a			; 13
		ld	iy,(zUnk_1FF8)			; 20
		sub	7				; 7

loc_73:
		add	a,a				; 4
		add	a,a				; 4
		ld	c,a				; 4
		add	a,a				; 4
		add	a,c				; 4
		ld	c,a				; 4
		ld	b,0				; 7
		add	iy,bc				; 15
		ld	e,(iy+0)			; 19
		ld	d,(iy+1)			; 19
		ld	a,(zUnk_1FF7)			; 13
		or	a				; 4
		jp	m,loc_8F			; 10
		ld	hl,(zUnk_1FF8)			; 16
		add	hl,de				; 11
		ex	de,hl				; 4

loc_8F:
		ld	c,(iy+2)			; 19
		ld	b,(iy+3)			; 19
		ld	a,(iy+4)			; 19
		ld	(zUnk_1FFE),a			; 13
		exx					; 4
		ld	c,80h				; 7
		exx					; 4

zPlayPCMLoop:
		ld	hl,zDAC_Sample			; 10
		ld	a,(de)				; 7
		and	0F0h				; 7
		rrca					; 4
		rrca					; 4
		rrca					; 4
		rrca					; 4
		add	a,zDACDecodeTbl&0FFh		; 7
		exx					; 4
		ld	e,a				; 4
		ld	a,(de)				; 7
		add	a,c				; 4
		ld	c,a				; 4
		ld	a,80h				; 7
		ld	(zDAC_Status),a			; 13
		ld	b,(iy+0Bh)			; 19

loc_B8:
		bit	7,(hl)				; 12
		jr	nz,loc_B8			; 12/7
		ld	(hl),2Ah			; 10
		inc	hl				; 6
		xor	a				; 4
		ld	(hl),c				; 7
		ld	(zDAC_Status),a			; 13
		dec	hl				; 6

loc_C5:
		djnz	$				; 13/8
		exx					; 4
		ld	a,(de)				; 7
		and	0Fh				; 7
		add	a,zDACDecodeTbl&0FFh		; 7
		exx					; 4
		ld	e,a				; 4
		ld	a,(de)				; 7
		add	a,c				; 4
		ld	c,a				; 4
		ld	a,80h				; 7
		ld	(zDAC_Status),a			; 13
		ld	b,(iy+0Bh)			; 19

loc_DA:
		bit	7,(hl)				; 12
		jr	nz,loc_DA			; 12/7
		ld	(hl),2Ah			; 10
		inc	hl				; 6
		xor	a				; 4
		ld	(hl),c				; 7
		ld	(zDAC_Status),a			; 13
		dec	hl				; 6

loc_E7:
		djnz	$				; 13/8
		exx					; 4
		bit	7,(iy+5)			; 20
		jr	nz,loc_F5			; 12/7
		bit	7,(hl)				; 12
		jp	nz,loc_31			; 10

loc_F5:
		inc	de				; 6
		dec	bc				; 6
		ld	a,c				; 4
		or	b				; 4
		jp	nz,zPlayPCMLoop			; 10
							; 425 cycles in total
		ld	a,(zUnk_1FFE)			; 13
		or	a				; 4
		jp	z,loc_153			; 10
		exx					; 4
		jp	p,loc_10C			; 10
		and	7Fh				; 7
		ld	(ix+0),c			; 19

loc_10C:
		dec	a				; 4
		ld	(zUnk_1FFE),a			; 13
		jr	z,loc_133			; 12/7
		ld	c,(ix+0)			; 19
		exx					; 4
		ld	l,(iy+6)			; 19
		ld	h,(iy+7)			; 19
		ld	b,h				; 4
		ld	c,l				; 4
		ld	e,(iy+0)			; 19
		ld	d,(iy+1)			; 19
		ld	hl,(zUnk_1FF8)			; 16
		add	hl,de				; 11
		ld	e,(iy+2)			; 19
		ld	d,(iy+3)			; 19
		add	hl,de				; 11
		ex	de,hl				; 4
		jp	zPlayPCMLoop			; 10
; ---------------------------------------------------------------------------

loc_133:
		ld	c,(ix+0)			; 19
		exx					; 4
		ld	c,(iy+8)			; 19
		ld	b,(iy+9)			; 19
		ld	l,(iy+2)			; 19
		ld	h,(iy+3)			; 19
		ld	e,(iy+0)			; 19
		ld	d,(iy+1)			; 19
		add	hl,de				; 11
		ld	de,(zUnk_1FF8)			; 20
		add	hl,de				; 11
		ex	de,hl				; 4
		jp	zPlayPCMLoop			; 10
; ---------------------------------------------------------------------------

loc_153:
		ld	hl,zDAC_Update			; 10
		ld	a,(hl)				; 7
		or	a				; 4
		jp	m,loc_2E			; 10
		xor	a				; 4
		ld	(hl),a				; 7
		jp	loc_2E				; 10
; End of function StartOfZ80

; ---------------------------------------------------------------------------
zPCMMetadata macro label,sampleRate
	dw	label					; Start
	dw	label_End-label				; Length
	rept	7
		db	0				; Padding
	endm
	db	dpcmLoopCounter(sampleRate)		; Pitch
    endm

; DPCM metadata
zPCM_Table:
	zPCMMetadata zDAC_Kick,7750
	zPCMMetadata zDAC_Snare,16500
zTimpani_Pitch = $+0Bh
	zPCMMetadata zDAC_Timpani,6500

; DPCM data
zDAC_Kick:
	binclude "sound/dac/kick.dpcm"
zDAC_Kick_End:

zDAC_Snare:
	binclude "sound/dac/snare.dpcm"
zDAC_Snare_End:

zDAC_Timpani:
	binclude "sound/dac/timpani.dpcm"
zDAC_Timpani_End:

		restore
		padding off
		dephase
