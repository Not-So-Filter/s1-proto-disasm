; ---------------------------------------------------------------------------

ObjPoints:
		moveq	#0,d0
		move.b	obj.Routine(a0),d0
		move.w	off_7500(pc,d0.w),d1
		jsr	off_7500(pc,d1.w)
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

off_7500:	dc.w ObjPoints_Init-off_7500, ObjPoints_Act-off_7500
; ---------------------------------------------------------------------------

ObjPoints_Init:
		addq.b	#2,obj.Routine(a0)
		move.l	#Map_Poi,obj.Map(a0)
		move.w	#$2797,obj.Gfx(a0)
		move.b	#4,obj.Render(a0)
		move.b	#1,obj.Priority(a0)
		move.b	#8,obj.ActWid(a0)
		move.w	#-$300,obj.VelY(a0)

ObjPoints_Act:
		tst.w	obj.VelY(a0)
		bpl.w	DeleteObject
		bsr.w	SpeedToPos
		addi.w	#$18,obj.VelY(a0)
		rts
