; ---------------------------------------------------------------------------

Obj2A:
		moveq	#0,d0
		move.b	obj.Routine(a0),d0
		move.w	off_689E(pc,d0.w),d1
		jmp	off_689E(pc,d1.w)
; ---------------------------------------------------------------------------
off_689E:	dc.w loc_68A4-off_689E, loc_68F0-off_689E, loc_6912-off_689E
; ---------------------------------------------------------------------------

loc_68A4:
		addq.b	#2,obj.Routine(a0)
		move.l	#Map_2A,obj.Map(a0)
		move.w	#0,obj.Gfx(a0)
		move.b	#4,obj.Render(a0)
		move.w	obj.Ypos(a0),d0
		subi.w	#$20,d0
		move.w	d0,obj.Off_30(a0)
		move.b	#$B,obj.ActWid(a0)
		move.b	#5,obj.Priority(a0)
		tst.b	obj.Subtype(a0)
		beq.s	loc_68F0
		move.b	#1,obj.Frame(a0)
		move.w	#$4000,obj.Gfx(a0)
		move.b	#4,obj.Priority(a0)
		addq.b	#2,obj.Routine(a0)

loc_68F0:
		tst.w	(f_switch).w
		beq.s	loc_6906
		subq.w	#1,obj.Ypos(a0)
		move.w	obj.Off_30(a0),d0
		cmp.w	obj.Ypos(a0),d0
		beq.w	DeleteObject

loc_6906:
		move.w	#$16,d1
		move.w	#$10,d2
		bsr.w	sub_6936

loc_6912:
		bsr.w	DisplaySprite
		out_of_range.w	DeleteObject
		rts
