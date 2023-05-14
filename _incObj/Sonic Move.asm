; ---------------------------------------------------------------------------

Sonic_Move:
		move.w	(unk_FFF760).w,d6
		move.w	(unk_FFF762).w,d5
		move.w	(unk_FFF764).w,d4
		tst.w	$3E(a0)
		bne.w	Sonic_LookUp
		btst	#2,(v_jpadhold2).w
		beq.s	Sonic_NoLeft
		bsr.w	Sonic_MoveLeft

Sonic_NoLeft:
		btst	#3,(v_jpadhold2).w
		beq.s	Sonic_NoRight
		bsr.w	Sonic_MoveRight

Sonic_NoRight:
		move.b	$26(a0),d0
		addi.b	#$20,d0
		andi.b	#$C0,d0
		bne.w	Sonic_ResetScroll
		tst.w	$14(a0)
		bne.w	Sonic_ResetScroll
		bclr	#5,$22(a0)
		move.b	#5,$1C(a0)
		btst	#3,$22(a0)
		beq.s	Sonic_Balance
		moveq	#0,d0
		move.b	$3D(a0),d0
		lsl.w	#6,d0
		lea	(v_objspace).w,a1
		lea	(a1,d0.w),a1
		tst.b	$22(a1)
		bmi.s	Sonic_LookUp
		moveq	#0,d1
		move.b	$18(a1),d1
		move.w	d1,d2
		add.w	d2,d2
		subq.w	#4,d2
		add.w	8(a0),d1
		sub.w	8(a1),d1
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
		bclr	#0,$22(a0)
		bra.s	loc_EA98
; ---------------------------------------------------------------------------

loc_EA8A:
		cmpi.b	#3,$37(a0)
		bne.s	Sonic_LookUp

loc_EA92:
		bset	#0,$22(a0)

loc_EA98:
		move.b	#6,$1C(a0)
		bra.s	Sonic_ResetScroll
; ---------------------------------------------------------------------------

Sonic_LookUp:
		btst	#0,(v_jpadhold2).w
		beq.s	Sonic_Duck
		move.b	#7,$1C(a0)
		cmpi.w	#$C8,(unk_FFF73E).w
		beq.s	loc_EAEA
		addq.w	#2,(unk_FFF73E).w
		bra.s	loc_EAEA
; ---------------------------------------------------------------------------

Sonic_Duck:
		btst	#1,(v_jpadhold2).w
		beq.s	Sonic_ResetScroll
		move.b	#8,$1C(a0)
		cmpi.w	#8,(unk_FFF73E).w
		beq.s	loc_EAEA
		subq.w	#2,(unk_FFF73E).w
		bra.s	loc_EAEA
; ---------------------------------------------------------------------------

Sonic_ResetScroll:
		cmpi.w	#$60,(unk_FFF73E).w
		beq.s	loc_EAEA
		bcc.s	loc_EAE6
		addq.w	#4,(unk_FFF73E).w

loc_EAE6:
		subq.w	#2,(unk_FFF73E).w

loc_EAEA:
		move.b	(v_jpadhold2).w,d0
		andi.b	#$C,d0
		bne.s	loc_EB16
		move.w	$14(a0),d0
		beq.s	loc_EB16
		bmi.s	loc_EB0A
		sub.w	d5,d0
		bcc.s	loc_EB04
		move.w	#0,d0

loc_EB04:
		move.w	d0,$14(a0)
		bra.s	loc_EB16
; ---------------------------------------------------------------------------

loc_EB0A:
		add.w	d5,d0
		bcc.s	loc_EB12
		move.w	#0,d0

loc_EB12:
		move.w	d0,$14(a0)

loc_EB16:
		move.b	$26(a0),d0
		jsr	(GetSine).l
		muls.w	$14(a0),d1
		asr.l	#8,d1
		move.w	d1,$10(a0)
		muls.w	$14(a0),d0
		asr.l	#8,d0
		move.w	d0,$12(a0)

loc_EB34:
		move.b	#$40,d1
		tst.w	$14(a0)
		beq.s	locret_EB8E
		bmi.s	loc_EB42
		neg.w	d1

loc_EB42:
		move.b	$26(a0),d0
		add.b	d1,d0
		move.w	d0,-(sp)
		bsr.w	Sonic_WalkSpeed
		move.w	(sp)+,d0
		tst.w	d1
		bpl.s	locret_EB8E
		move.w	#0,$14(a0)
		bset	#5,$22(a0)
		asl.w	#8,d1
		addi.b	#$20,d0
		andi.b	#$C0,d0
		beq.s	loc_EB8A
		cmpi.b	#$40,d0
		beq.s	loc_EB84
		cmpi.b	#$80,d0
		beq.s	loc_EB7E
		add.w	d1,$10(a0)
		rts
; ---------------------------------------------------------------------------

loc_EB7E:
		sub.w	d1,$12(a0)
		rts
; ---------------------------------------------------------------------------

loc_EB84:
		sub.w	d1,$10(a0)
		rts
; ---------------------------------------------------------------------------

loc_EB8A:
		add.w	d1,$12(a0)

locret_EB8E:
		rts
; ---------------------------------------------------------------------------

Sonic_MoveLeft:
		move.w	$14(a0),d0
		beq.s	loc_EB98
		bpl.s	loc_EBC4

loc_EB98:
		bset	#0,$22(a0)
		bne.s	loc_EBAC
		bclr	#5,$22(a0)
		move.b	#1,$1D(a0)

loc_EBAC:
		sub.w	d5,d0
		move.w	d6,d1
		neg.w	d1
		cmp.w	d1,d0
		bgt.s	loc_EBB8
		move.w	d1,d0

loc_EBB8:
		move.w	d0,$14(a0)
		move.b	#0,$1C(a0)
		rts
; ---------------------------------------------------------------------------

loc_EBC4:
		sub.w	d4,d0
		bcc.s	loc_EBCC
		move.w	#$FF80,d0

loc_EBCC:
		move.w	d0,$14(a0)
		move.b	$26(a0),d0
		addi.b	#$20,d0
		andi.b	#$C0,d0
		bne.s	locret_EBFA
		cmpi.w	#$400,d0
		blt.s	locret_EBFA
		move.b	#$D,$1C(a0)
		bclr	#0,$22(a0)
		move.w	#sfx_Skid,d0
		jsr	(PlaySFX).l

locret_EBFA:
		rts
; ---------------------------------------------------------------------------

Sonic_MoveRight:
		move.w	$14(a0),d0
		bmi.s	loc_EC2A
		bclr	#0,$22(a0)
		beq.s	loc_EC16
		bclr	#5,$22(a0)
		move.b	#1,$1D(a0)

loc_EC16:
		add.w	d5,d0
		cmp.w	d6,d0
		blt.s	loc_EC1E
		move.w	d6,d0

loc_EC1E:
		move.w	d0,$14(a0)
		move.b	#0,$1C(a0)
		rts
; ---------------------------------------------------------------------------

loc_EC2A:
		add.w	d4,d0
		bcc.s	loc_EC32
		move.w	#$80,d0

loc_EC32:
		move.w	d0,$14(a0)
		move.b	$26(a0),d0
		addi.b	#$20,d0
		andi.b	#$C0,d0
		bne.s	locret_EC60
		cmpi.w	#$FC00,d0
		bgt.s	locret_EC60
		move.b	#$D,$1C(a0)
		bset	#0,$22(a0)
		move.w	#sfx_Skid,d0
		jsr	(PlaySFX).l

locret_EC60:
		rts