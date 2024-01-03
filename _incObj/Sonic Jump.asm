; ---------------------------------------------------------------------------

Sonic_Jump:
		move.b	(v_jpadpress2).w,d0
		andi.b	#btnABC,d0
		beq.w	locret_EF46
		moveq	#0,d0
		move.b	obj.Angle(a0),d0
		addi.b	#-$80,d0
		bsr.w	sub_10520
		cmpi.w	#6,d1
		blt.w	locret_EF46
		moveq	#0,d0
		move.b	obj.Angle(a0),d0
		subi.b	#$40,d0
		jsr	(CalcSine).l
		muls.w	#$680,d1
		asr.l	#8,d1
		add.w	d1,obj.VelX(a0)
		muls.w	#$680,d0
		asr.l	#8,d0
		add.w	d0,obj.VelY(a0)
		bset	#1,obj.Status(a0)
		bclr	#5,obj.Status(a0)
		addq.l	#4,sp
		move.b	#1,jumpflag(a0)
		move.w	#sfx_Jump,d0
		jsr	(PlaySound_Special).l
		move.b	#$13,obj.Height(a0)
		move.b	#9,obj.Width(a0)
		tst.b	(f_victory).w			; has the victory animation flag been set?
		bne.s	loc_EF48			; if yes, branch
		btst	#2,obj.Status(a0)
		bne.s	loc_EF50
		move.b	#$E,obj.Height(a0)
		move.b	#7,obj.Width(a0)
		move.b	#id_Roll,obj.Anim(a0)		; use "jumping" animation
		bset	#2,obj.Status(a0)
		addq.w	#5,obj.Ypos(a0)

locret_EF46:
		rts
; ---------------------------------------------------------------------------

loc_EF48:
		move.b	#id_Leap2,obj.Anim(a0)		; use the "victory leaping" animation
		rts
; ---------------------------------------------------------------------------

loc_EF50:
		bset	#4,obj.Status(a0)
		rts
