; ---------------------------------------------------------------------------

Sonic_Jump:
		move.b	(v_jpadpress2).w,d0
		andi.b	#btnABC,d0
		beq.w	locret_EF46
		moveq	#0,d0
		move.b	objAngle(a0),d0
		addi.b	#-$80,d0
		bsr.w	sub_10520
		cmpi.w	#6,d1
		blt.w	locret_EF46
		moveq	#0,d0
		move.b	objAngle(a0),d0
		subi.b	#$40,d0
		jsr	(CalcSine).l
		muls.w	#$680,d1
		asr.l	#8,d1
		add.w	d1,objVelX(a0)
		muls.w	#$680,d0
		asr.l	#8,d0
		add.w	d0,objVelY(a0)
		bset	#1,objStatus(a0)
		bclr	#5,objStatus(a0)
		addq.l	#4,sp
		move.b	#1,$3C(a0)
		move.w	#sfx_Jump,d0
		jsr	(PlaySound_Special).l
		move.b	#$13,objHeight(a0)
		move.b	#9,objWidth(a0)
		tst.b	(f_victory).w			; has the victory animation flag been set?
		bne.s	loc_EF48			; if yes, branch
		btst	#2,objStatus(a0)
		bne.s	loc_EF50
		move.b	#$E,objHeight(a0)
		move.b	#7,objWidth(a0)
		move.b	#id_Roll,objAnim(a0)		; use "jumping" animation
		bset	#2,objStatus(a0)
		addq.w	#5,objY(a0)

locret_EF46:
		rts
; ---------------------------------------------------------------------------

loc_EF48:
		move.b	#id_Leap2,objAnim(a0)		; use the "victory leaping" animation
		rts
; ---------------------------------------------------------------------------

loc_EF50:
		bset	#4,objStatus(a0)
		rts