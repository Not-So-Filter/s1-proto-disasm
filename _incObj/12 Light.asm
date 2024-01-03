; ---------------------------------------------------------------------------

ObjSceneryLamp:
		moveq	#0,d0
		move.b	obj.Routine(a0),d0
		move.w	off_C538(pc,d0.w),d1
		jmp	off_C538(pc,d1.w)
; ---------------------------------------------------------------------------

off_C538:	dc.w loc_C53C-off_C538, loc_C560-off_C538
; ---------------------------------------------------------------------------

loc_C53C:
		addq.b	#2,obj.Routine(a0)
		move.l	#Map_Light,obj.Map(a0)
		move.w	#0,obj.Gfx(a0)
		move.b	#4,obj.Render(a0)
		move.b	#$10,obj.ActWid(a0)
		move.b	#6,obj.Priority(a0)

loc_C560:
		subq.b	#1,obj.TimeFrame(a0)
		bpl.s	loc_C57E
		move.b	#7,obj.TimeFrame(a0)
		addq.b	#1,obj.Frame(a0)
		cmpi.b	#6,obj.Frame(a0)
		bcs.s	loc_C57E
		move.b	#0,obj.Frame(a0)

loc_C57E:
		bsr.w	DisplaySprite
		out_of_range.w	DeleteObject
		rts
