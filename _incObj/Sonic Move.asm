; ---------------------------------------------------------------------------

Sonic_Move:
		move.w	(v_sonspeedmax).w,d6
		move.w	(v_sonspeedacc).w,d5
		move.w	(v_sonspeeddec).w,d4
		tst.w	ctrllock(a0)
		bne.w	Sonic_LookUp
		btst	#bitL,(v_jpadhold2).w
		beq.s	Sonic_NoLeft
		bsr.w	Sonic_MoveLeft

Sonic_NoLeft:
		btst	#bitR,(v_jpadhold2).w
		beq.s	Sonic_NoRight
		bsr.w	Sonic_MoveRight

Sonic_NoRight:
		move.b	objAngle(a0),d0
		addi.b	#$20,d0
		andi.b	#$C0,d0
		bne.w	Sonic_ResetScroll
		tst.w	objInertia(a0)
		bne.w	Sonic_ResetScroll
		bclr	#5,objStatus(a0)
		move.b	#id_Wait,objAnim(a0)
		btst	#3,objStatus(a0)
		beq.s	Sonic_Balance
		moveq	#0,d0
		move.b	standonobject(a0),d0
		lsl.w	#6,d0
		lea	(v_objspace).w,a1
		lea	(a1,d0.w),a1
		tst.b	objStatus(a1)
		bmi.s	Sonic_LookUp
		moveq	#0,d1
		move.b	objActWid(a1),d1
		move.w	d1,d2
		add.w	d2,d2
		subq.w	#4,d2
		add.w	objX(a0),d1
		sub.w	objX(a1),d1
		cmpi.w	#4,d1
		blt.s	loc_EA92
		cmp.w	d2,d1
		bge.s	loc_EA82
		bra.s	Sonic_LookUp
; ---------------------------------------------------------------------------

Sonic_Balance:
		jsr	(ObjectHitFloor).l
		cmpi.w	#$C,d1
		blt.s	Sonic_LookUp
		cmpi.b	#3,$36(a0)
		bne.s	loc_EA8A

loc_EA82:
		bclr	#0,objStatus(a0)
		bra.s	loc_EA98
; ---------------------------------------------------------------------------

loc_EA8A:
		cmpi.b	#3,$37(a0)
		bne.s	Sonic_LookUp

loc_EA92:
		bset	#0,objStatus(a0)

loc_EA98:
		move.b	#id_Balance,objAnim(a0)
		bra.s	Sonic_ResetScroll
; ---------------------------------------------------------------------------

Sonic_LookUp:
		btst	#bitUp,(v_jpadhold2).w
		beq.s	Sonic_Duck
		move.b	#id_LookUp,objAnim(a0)
		cmpi.w	#$C8,(v_lookshift).w
		beq.s	loc_EAEA
		addq.w	#2,(v_lookshift).w
		bra.s	loc_EAEA
; ---------------------------------------------------------------------------

Sonic_Duck:
		btst	#bitDn,(v_jpadhold2).w
		beq.s	Sonic_ResetScroll
		move.b	#id_Duck,objAnim(a0)
		cmpi.w	#8,(v_lookshift).w
		beq.s	loc_EAEA
		subq.w	#2,(v_lookshift).w
		bra.s	loc_EAEA
; ---------------------------------------------------------------------------

Sonic_ResetScroll:
		cmpi.w	#$60,(v_lookshift).w
		beq.s	loc_EAEA
		bcc.s	loc_EAE6
		addq.w	#4,(v_lookshift).w

loc_EAE6:
		subq.w	#2,(v_lookshift).w

loc_EAEA:
		move.b	(v_jpadhold2).w,d0
		andi.b	#btnL+btnR,d0
		bne.s	loc_EB16
		move.w	objInertia(a0),d0
		beq.s	loc_EB16
		bmi.s	loc_EB0A
		sub.w	d5,d0
		bcc.s	loc_EB04
		move.w	#0,d0

loc_EB04:
		move.w	d0,objInertia(a0)
		bra.s	loc_EB16
; ---------------------------------------------------------------------------

loc_EB0A:
		add.w	d5,d0
		bcc.s	loc_EB12
		move.w	#0,d0

loc_EB12:
		move.w	d0,objInertia(a0)

loc_EB16:
		move.b	objAngle(a0),d0
		jsr	(CalcSine).l
		muls.w	objInertia(a0),d1
		asr.l	#8,d1
		move.w	d1,objVelX(a0)
		muls.w	objInertia(a0),d0
		asr.l	#8,d0
		move.w	d0,objVelY(a0)

loc_EB34:
		move.b	#$40,d1
		tst.w	objInertia(a0)
		beq.s	locret_EB8E
		bmi.s	loc_EB42
		neg.w	d1

loc_EB42:
		move.b	objAngle(a0),d0
		add.b	d1,d0
		move.w	d0,-(sp)
		bsr.w	Sonic_WalkSpeed
		move.w	(sp)+,d0
		tst.w	d1
		bpl.s	locret_EB8E
		move.w	#0,objInertia(a0)
		bset	#5,objStatus(a0)
		asl.w	#8,d1
		addi.b	#$20,d0
		andi.b	#$C0,d0
		beq.s	loc_EB8A
		cmpi.b	#$40,d0
		beq.s	loc_EB84
		cmpi.b	#$80,d0
		beq.s	loc_EB7E
		add.w	d1,objVelX(a0)
		rts
; ---------------------------------------------------------------------------

loc_EB7E:
		sub.w	d1,objVelY(a0)
		rts
; ---------------------------------------------------------------------------

loc_EB84:
		sub.w	d1,objVelX(a0)
		rts
; ---------------------------------------------------------------------------

loc_EB8A:
		add.w	d1,objVelY(a0)

locret_EB8E:
		rts
; ---------------------------------------------------------------------------

Sonic_MoveLeft:
		move.w	objInertia(a0),d0
		beq.s	loc_EB98
		bpl.s	loc_EBC4

loc_EB98:
		bset	#0,objStatus(a0)
		bne.s	loc_EBAC
		bclr	#5,objStatus(a0)
		move.b	#id_Run,objNextAni(a0)

loc_EBAC:
		sub.w	d5,d0
		move.w	d6,d1
		neg.w	d1
		cmp.w	d1,d0
		bgt.s	loc_EBB8
		move.w	d1,d0

loc_EBB8:
		move.w	d0,objInertia(a0)
		move.b	#id_Walk,objAnim(a0)
		rts
; ---------------------------------------------------------------------------

loc_EBC4:
		sub.w	d4,d0
		bcc.s	loc_EBCC
		move.w	#-$80,d0

loc_EBCC:
		move.w	d0,objInertia(a0)
		move.b	objAngle(a0),d0
		addi.b	#$20,d0
		andi.b	#$C0,d0
		bne.s	locret_EBFA
		cmpi.w	#$400,d0
		blt.s	locret_EBFA
		move.b	#id_Stop,objAnim(a0)
		bclr	#0,objStatus(a0)
		move.w	#sfx_Skid,d0
		jsr	(PlaySound_Special).l

locret_EBFA:
		rts
; ---------------------------------------------------------------------------

Sonic_MoveRight:
		move.w	objInertia(a0),d0
		bmi.s	loc_EC2A
		bclr	#0,objStatus(a0)
		beq.s	loc_EC16
		bclr	#5,objStatus(a0)
		move.b	#id_Run,objNextAni(a0)

loc_EC16:
		add.w	d5,d0
		cmp.w	d6,d0
		blt.s	loc_EC1E
		move.w	d6,d0

loc_EC1E:
		move.w	d0,objInertia(a0)
		move.b	#id_Walk,objAnim(a0)
		rts
; ---------------------------------------------------------------------------

loc_EC2A:
		add.w	d4,d0
		bcc.s	loc_EC32
		move.w	#$80,d0

loc_EC32:
		move.w	d0,objInertia(a0)
		move.b	objAngle(a0),d0
		addi.b	#$20,d0
		andi.b	#$C0,d0
		bne.s	locret_EC60
		cmpi.w	#-$400,d0
		bgt.s	locret_EC60
		move.b	#id_Stop,objAnim(a0)
		bset	#0,objStatus(a0)
		move.w	#sfx_Skid,d0
		jsr	(PlaySound_Special).l

locret_EC60:
		rts