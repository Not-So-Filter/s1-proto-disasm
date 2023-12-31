; ---------------------------------------------------------------------------

Sonic_RollSpeed:
		move.w	(v_sonspeedmax).w,d6
		asl.w	#1,d6
		move.w	(v_sonspeedacc).w,d5
		asr.w	#1,d5
		move.w	(v_sonspeeddec).w,d4
		asr.w	#2,d4
		tst.w	ctrllock(a0)
		bne.s	loc_EC92
		btst	#bitL,(v_jpadhold2).w
		beq.s	loc_EC86
		bsr.w	Sonic_RollLeft

loc_EC86:
		btst	#bitR,(v_jpadhold2).w
		beq.s	loc_EC92
		bsr.w	Sonic_RollRight

loc_EC92:
		move.w	obj.Inertia(a0),d0
		beq.s	loc_ECB4
		bmi.s	loc_ECA8
		sub.w	d5,d0
		bcc.s	loc_ECA2
		move.w	#0,d0

loc_ECA2:
		move.w	d0,obj.Inertia(a0)
		bra.s	loc_ECB4
; ---------------------------------------------------------------------------

loc_ECA8:
		add.w	d5,d0
		bcc.s	loc_ECB0
		move.w	#0,d0

loc_ECB0:
		move.w	d0,obj.Inertia(a0)

loc_ECB4:
		tst.w	obj.Inertia(a0)
		bne.s	loc_ECD6
		bclr	#2,obj.Status(a0)
		move.b	#$13,obj.Height(a0)
		move.b	#9,obj.Width(a0)
		move.b	#id_Wait,obj.Anim(a0)
		subq.w	#5,obj.Ypos(a0)

loc_ECD6:
		move.b	obj.Angle(a0),d0
		jsr	(CalcSine).l
		muls.w	obj.Inertia(a0),d1
		asr.l	#8,d1
		move.w	d1,obj.VelX(a0)
		muls.w	obj.Inertia(a0),d0
		asr.l	#8,d0
		move.w	d0,obj.VelY(a0)
		bra.w	loc_EB34
; ---------------------------------------------------------------------------

Sonic_RollLeft:
		move.w	obj.Inertia(a0),d0
		beq.s	loc_ED00
		bpl.s	loc_ED0E

loc_ED00:
		bset	#0,obj.Status(a0)
		move.b	#id_Roll,obj.Anim(a0)
		rts
; ---------------------------------------------------------------------------

loc_ED0E:
		sub.w	d4,d0
		bcc.s	loc_ED16
		move.w	#-$80,d0

loc_ED16:
		move.w	d0,obj.Inertia(a0)
		rts
; ---------------------------------------------------------------------------

Sonic_RollRight:
		move.w	obj.Inertia(a0),d0
		bmi.s	loc_ED30
		bclr	#0,obj.Status(a0)
		move.b	#id_Roll,obj.Anim(a0)
		rts
; ---------------------------------------------------------------------------

loc_ED30:
		add.w	d4,d0
		bcc.s	loc_ED38
		move.w	#$80,d0

loc_ED38:
		move.w	d0,obj.Inertia(a0)
		rts