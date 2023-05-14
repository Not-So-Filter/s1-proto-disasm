; ---------------------------------------------------------------------------

ObjChopper:
		moveq	#0,d0
		move.b	$24(a0),d0
		move.w	off_8BB6(pc,d0.w),d1
		jsr	off_8BB6(pc,d1.w)
		bra.w	RememberState
; ---------------------------------------------------------------------------

off_8BB6:	dc.w loc_8BBA-off_8BB6, loc_8BF0-off_8BB6
; ---------------------------------------------------------------------------

loc_8BBA:
		addq.b	#2,$24(a0)
		move.l	#MapChopper,4(a0)
		move.w	#$47B,2(a0)
		move.b	#4,1(a0)
		move.b	#4,$19(a0)
		move.b	#9,$20(a0)
		move.b	#$10,$18(a0)
		move.w	#$F900,$12(a0)
		move.w	$C(a0),$30(a0)

loc_8BF0:
		lea	(AniChopper).l,a1
		bsr.w	AnimateSprite
		bsr.w	SpeedToPos
		addi.w	#$18,$12(a0)
		move.w	$30(a0),d0
		cmp.w	$C(a0),d0
		bcc.s	loc_8C18
		move.w	d0,$C(a0)
		move.w	#$F900,$12(a0)

loc_8C18:
		move.b	#1,$1C(a0)
		subi.w	#$C0,d0
		cmp.w	$C(a0),d0
		bcc.s	locret_8C3A
		move.b	#0,$1C(a0)
		tst.w	$12(a0)
		bmi.s	locret_8C3A
		move.b	#2,$1C(a0)

locret_8C3A:
		rts