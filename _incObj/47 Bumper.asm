; ---------------------------------------------------------------------------

ObjBumper:
		moveq	#0,d0
		move.b	$24(a0),d0
		move.w	off_C5FE(pc,d0.w),d1
		jmp	off_C5FE(pc,d1.w)
; ---------------------------------------------------------------------------

off_C5FE:	dc.w loc_C602-off_C5FE, loc_C62C-off_C5FE
; ---------------------------------------------------------------------------

loc_C602:
		addq.b	#2,$24(a0)
		move.l	#MapBumper,4(a0)
		move.w	#$380,2(a0)
		move.b	#4,1(a0)
		move.b	#$10,$18(a0)
		move.b	#1,$19(a0)
		move.b	#$D7,$20(a0)

loc_C62C:
		tst.b	$21(a0)
		beq.s	loc_C684
		clr.b	$21(a0)
		lea	(v_objspace).w,a1
		move.w	8(a0),d1
		move.w	$C(a0),d2
		sub.w	8(a1),d1
		sub.w	$C(a1),d2
		jsr	(CalcAngle).l
		jsr	(CalcSine).l
		muls.w	#$F900,d1
		asr.l	#8,d1
		move.w	d1,$10(a1)
		muls.w	#$F900,d0
		asr.l	#8,d0
		move.w	d0,$12(a1)
		bset	#1,$22(a1)
		clr.b	$3C(a1)
		move.b	#1,$1C(a0)
		move.w	#sfx_Bumper,d0
		jsr	(PlaySound_Special).l

loc_C684:
		lea	(AniBumper).l,a1
		bsr.w	AnimateSprite
		bsr.w	DisplaySprite
		out_of_range.w	DeleteObject
		rts