; ---------------------------------------------------------------------------

ObjJaws:
		moveq	#0,d0
		move.b	obj.Routine(a0),d0
		move.w	off_8C70(pc,d0.w),d1
		jsr	off_8C70(pc,d1.w)
		bra.w	RememberState
; ---------------------------------------------------------------------------
off_8C70:	dc.w loc_8C74-off_8C70, loc_8CA4-off_8C70
; ---------------------------------------------------------------------------

loc_8C74:
		addq.b	#2,obj.Routine(a0)
		move.l	#Map_Jaws,obj.Map(a0)
		move.w	#$47B,obj.Gfx(a0)
		move.b	#4,obj.Render(a0)
		move.b	#$A,obj.ColType(a0)
		move.b	#4,obj.Priority(a0)
		move.b	#$10,obj.ActWid(a0)
		move.w	#-$40,obj.VelX(a0)

loc_8CA4:
		lea	(Ani_Jaws).l,a1
		bsr.w	AnimateSprite
		bra.w	SpeedToPos
