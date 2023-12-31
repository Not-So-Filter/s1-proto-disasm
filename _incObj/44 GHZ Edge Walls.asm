; ---------------------------------------------------------------------------

ObjWall:
		moveq	#0,d0
		move.b	obj.Routine(a0),d0
		move.w	off_C10A(pc,d0.w),d1
		jmp	off_C10A(pc,d1.w)
; ---------------------------------------------------------------------------

off_C10A:	dc.w loc_C110-off_C10A, loc_C148-off_C10A, loc_C154-off_C10A
; ---------------------------------------------------------------------------

loc_C110:
		addq.b	#2,obj.Routine(a0)
		move.l	#Map_Edge,obj.Map(a0)
		move.w	#$434C,obj.Gfx(a0)
		ori.b	#4,obj.Render(a0)
		move.b	#8,obj.ActWid(a0)
		move.b	#6,obj.Priority(a0)
		move.b	obj.Subtype(a0),obj.Frame(a0)
		bclr	#4,obj.Frame(a0)
		beq.s	loc_C148
		addq.b	#2,obj.Routine(a0)
		bra.s	loc_C154
; ---------------------------------------------------------------------------

loc_C148:
		move.w	#$13,d1
		move.w	#$28,d2
		bsr.w	sub_6936

loc_C154:
		bsr.w	DisplaySprite
		out_of_range.w	DeleteObject
		rts