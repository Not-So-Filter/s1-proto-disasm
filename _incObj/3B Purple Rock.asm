; ---------------------------------------------------------------------------

ObjPurpleRock:
		moveq	#0,d0
		move.b	obj.Routine(a0),d0
		move.w	off_AD1A(pc,d0.w),d1
		jmp	off_AD1A(pc,d1.w)
; ---------------------------------------------------------------------------

off_AD1A:	dc.w loc_AD1E-off_AD1A, loc_AD42-off_AD1A
; ---------------------------------------------------------------------------

loc_AD1E:
		addq.b	#2,obj.Routine(a0)
		move.l	#Map_PRock,obj.Map(a0)
		move.w	#$63D0,obj.Gfx(a0)
		move.b	#4,obj.Render(a0)
		move.b	#$13,obj.ActWid(a0)
		move.b	#4,obj.Priority(a0)

loc_AD42:
		move.w	#$1B,d1
		move.w	#$10,d2
		move.w	#$10,d3
		move.w	obj.Xpos(a0),d4
		bsr.w	SolidObject
		bsr.w	DisplaySprite
		out_of_range.w	DeleteObject
		rts
