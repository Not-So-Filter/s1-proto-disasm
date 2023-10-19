; ---------------------------------------------------------------------------

ObjPoints:
		moveq	#0,d0
		move.b	objRoutine(a0),d0
		move.w	off_7500(pc,d0.w),d1
		jsr	off_7500(pc,d1.w)
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

off_7500:	dc.w ObjPoints_Init-off_7500, ObjPoints_Act-off_7500
; ---------------------------------------------------------------------------

ObjPoints_Init:
		addq.b	#2,objRoutine(a0)
		move.l	#Map_Poi,objMap(a0)
		move.w	#$2797,objGfx(a0)
		move.b	#4,objRender(a0)
		move.b	#1,objPriority(a0)
		move.b	#8,objActWid(a0)
		move.w	#-$300,objVelY(a0)

ObjPoints_Act:
		tst.w	objVelY(a0)
		bpl.w	DeleteObject
		bsr.w	SpeedToPos
		addi.w	#$18,objVelY(a0)
		rts