; ---------------------------------------------------------------------------

Obj2A:
		moveq	#0,d0
		move.b	objRoutine(a0),d0
		move.w	off_689E(pc,d0.w),d1
		jmp	off_689E(pc,d1.w)
; ---------------------------------------------------------------------------
off_689E:	dc.w loc_68A4-off_689E, loc_68F0-off_689E, loc_6912-off_689E
; ---------------------------------------------------------------------------

loc_68A4:
		addq.b	#2,objRoutine(a0)
		move.l	#Map_2A,objMap(a0)
		move.w	#0,objGfx(a0)
		move.b	#4,objRender(a0)
		move.w	objY(a0),d0
		subi.w	#$20,d0
		move.w	d0,$30(a0)
		move.b	#$B,objActWid(a0)
		move.b	#5,objPriority(a0)
		tst.b	objSubtype(a0)
		beq.s	loc_68F0
		move.b	#1,objFrame(a0)
		move.w	#$4000,objGfx(a0)
		move.b	#4,objPriority(a0)
		addq.b	#2,objRoutine(a0)

loc_68F0:
		tst.w	(f_switch).w
		beq.s	loc_6906
		subq.w	#1,objY(a0)
		move.w	$30(a0),d0
		cmp.w	objY(a0),d0
		beq.w	DeleteObject

loc_6906:
		move.w	#$16,d1
		move.w	#$10,d2
		bsr.w	sub_6936

loc_6912:
		bsr.w	DisplaySprite
		out_of_range.w	DeleteObject
		rts