; ---------------------------------------------------------------------------

ObjSceneryLamp:
		moveq	#0,d0
		move.b	objRoutine(a0),d0
		move.w	off_C538(pc,d0.w),d1
		jmp	off_C538(pc,d1.w)
; ---------------------------------------------------------------------------

off_C538:	dc.w loc_C53C-off_C538, loc_C560-off_C538
; ---------------------------------------------------------------------------

loc_C53C:
		addq.b	#2,objRoutine(a0)
		move.l	#Map_Light,objMap(a0)
		move.w	#0,objGfx(a0)
		move.b	#4,objRender(a0)
		move.b	#$10,objActWid(a0)
		move.b	#6,objPriority(a0)

loc_C560:
		subq.b	#1,objTimeFrame(a0)
		bpl.s	loc_C57E
		move.b	#7,objTimeFrame(a0)
		addq.b	#1,objFrame(a0)
		cmpi.b	#6,objFrame(a0)
		bcs.s	loc_C57E
		move.b	#0,objFrame(a0)

loc_C57E:
		bsr.w	DisplaySprite
		out_of_range.w	DeleteObject
		rts