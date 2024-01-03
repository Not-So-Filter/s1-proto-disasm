; ---------------------------------------------------------------------------

Sonic_SlopeResist:
		move.b	obj.Angle(a0),d0
		addi.b	#$60,d0
		cmpi.b	#$C0,d0
		bcc.s	locret_EFBC
		move.b	obj.Angle(a0),d0
		jsr	(CalcSine).l
		muls.w	#$20,d0
		asr.l	#8,d0
		tst.w	obj.Inertia(a0)
		beq.s	locret_EFBC
		bmi.s	loc_EFB8
		tst.w	d0
		beq.s	locret_EFB6
		add.w	d0,obj.Inertia(a0)

locret_EFB6:
		rts
; ---------------------------------------------------------------------------

loc_EFB8:
		add.w	d0,obj.Inertia(a0)

locret_EFBC:
		rts
