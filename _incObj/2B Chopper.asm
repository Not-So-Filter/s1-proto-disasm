; ---------------------------------------------------------------------------

ObjChopper:
		moveq	#0,d0
		move.b	objRoutine(a0),d0
		move.w	off_8BB6(pc,d0.w),d1
		jsr	off_8BB6(pc,d1.w)
		bra.w	RememberState
; ---------------------------------------------------------------------------

off_8BB6:	dc.w loc_8BBA-off_8BB6, loc_8BF0-off_8BB6
; ---------------------------------------------------------------------------

loc_8BBA:
		addq.b	#2,objRoutine(a0)
		move.l	#Map_Chop,objMap(a0)
		move.w	#$47B,objGfx(a0)
		move.b	#4,objRender(a0)
		move.b	#4,objPriority(a0)
		move.b	#9,objColType(a0)
		move.b	#$10,objActWid(a0)
		move.w	#$F900,objVelY(a0)
		move.w	objY(a0),$30(a0)

loc_8BF0:
		lea	(Ani_Chop).l,a1
		bsr.w	AnimateSprite
		bsr.w	SpeedToPos
		addi.w	#$18,objVelY(a0)
		move.w	$30(a0),d0
		cmp.w	objY(a0),d0
		bcc.s	loc_8C18
		move.w	d0,objY(a0)
		move.w	#$F900,objVelY(a0)

loc_8C18:
		move.b	#1,objAnim(a0)
		subi.w	#$C0,d0
		cmp.w	objY(a0),d0
		bcc.s	locret_8C3A
		move.b	#0,objAnim(a0)
		tst.w	objVelY(a0)
		bmi.s	locret_8C3A
		move.b	#2,objAnim(a0)

locret_8C3A:
		rts