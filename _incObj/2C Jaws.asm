; ---------------------------------------------------------------------------

ObjJaws:
		moveq	#0,d0
		move.b	objRoutine(a0),d0
		move.w	off_8C70(pc,d0.w),d1
		jsr	off_8C70(pc,d1.w)
		bra.w	RememberState
; ---------------------------------------------------------------------------

off_8C70:	dc.w loc_8C74-off_8C70, loc_8CA4-off_8C70
; ---------------------------------------------------------------------------

loc_8C74:
		addq.b	#2,objRoutine(a0)
		move.l	#Map_Jaws,objMap(a0)
		move.w	#$47B,objGfx(a0)
		move.b	#4,objRender(a0)
		move.b	#$A,objColType(a0)
		move.b	#4,objPriority(a0)
		move.b	#$10,objActWid(a0)
		move.w	#-$40,objVelX(a0)

loc_8CA4:
		lea	(Ani_Jaws).l,a1
		bsr.w	AnimateSprite
		bra.w	SpeedToPos
