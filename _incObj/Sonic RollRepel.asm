; ---------------------------------------------------------------------------

Sonic_RollRepel:
		move.b	obAngle(a0),d0
		addi.b	#$60,d0
		cmpi.b	#$C0,d0
		bcc.s	locret_EFF8
		move.b	obAngle(a0),d0
		jsr	(CalcSine).l
		muls.w	#$50,d0
		asr.l	#8,d0
		tst.w	obInertia(a0)
		bmi.s	loc_EFEE
		tst.w	d0
		bpl.s	loc_EFE8
		asr.l	#2,d0

loc_EFE8:
		add.w	d0,obInertia(a0)
		rts
; ---------------------------------------------------------------------------

loc_EFEE:
		tst.w	d0
		bmi.s	loc_EFF4
		asr.l	#2,d0

loc_EFF4:
		add.w	d0,obInertia(a0)

locret_EFF8:
		rts