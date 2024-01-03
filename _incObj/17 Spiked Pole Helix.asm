; ---------------------------------------------------------------------------

ObjSpikeLogs:
		moveq	#0,d0
		move.b	obj.Routine(a0),d0
		move.w	off_5788(pc,d0.w),d1
		jmp	off_5788(pc,d1.w)
; ---------------------------------------------------------------------------

off_5788:	dc.w loc_5792-off_5788, loc_5854-off_5788, loc_5854-off_5788, loc_58C2-off_5788, loc_58C8-off_5788
; ---------------------------------------------------------------------------

loc_5792:
		addq.b	#2,obj.Routine(a0)
		move.l	#Map_Hel,obj.Map(a0)
		move.w	#$4398,obj.Gfx(a0)
		move.b	#7,obj.Status(a0)
		move.b	#4,obj.Render(a0)
		move.b	#3,obj.Priority(a0)
		move.b	#8,obj.ActWid(a0)
		move.w	obj.Ypos(a0),d2
		move.w	obj.Xpos(a0),d3
		_move.b	obj.Id(a0),d4
		lea	obj.Subtype(a0),a2
		moveq	#0,d1
		move.b	(a2),d1
		move.b	#0,(a2)+
		move.w	d1,d0
		lsr.w	#1,d0
		lsl.w	#4,d0
		sub.w	d0,d3
		subq.b	#2,d1
		bcs.s	loc_5854
		moveq	#0,d6

loc_57E2:
		bsr.w	FindFreeObj
		bne.s	loc_5854
		addq.b	#1,obj.Subtype(a0)
		move.w	a1,d5
		subi.w	#v_objspace,d5
		lsr.w	#6,d5
		andi.w	#$7F,d5
		move.b	d5,(a2)+

loc_57FA:
		move.b	#8,obj.Routine(a1)
		_move.b	d4,obj.Id(a1)
		move.w	d2,obj.Ypos(a1)
		move.w	d3,obj.Xpos(a1)
		move.l	obj.Map(a0),obj.Map(a1)
		move.w	#$4398,obj.Gfx(a1)
		move.b	#4,obj.Render(a1)
		move.b	#3,obj.Priority(a1)
		move.b	#8,obj.ActWid(a1)
		move.b	d6,$3E(a1)
		addq.b	#1,d6
		andi.b	#7,d6
		addi.w	#$10,d3
		cmp.w	obj.Xpos(a0),d3
		bne.s	loc_5850
		move.b	d6,$3E(a0)
		addq.b	#1,d6
		andi.b	#7,d6
		addi.w	#$10,d3
		addq.b	#1,obj.Subtype(a0)

loc_5850:
		dbf	d1,loc_57E2

loc_5854:
		bsr.w	sub_5860
		bsr.w	DisplaySprite
		bra.w	loc_5880
; ---------------------------------------------------------------------------

sub_5860:
		move.b	(v_ani0_frame).w,d0
		move.b	#0,obj.ColType(a0)
		add.b	$3E(a0),d0
		andi.b	#7,d0
		move.b	d0,obj.Frame(a0)
		bne.s	locret_587E
		move.b	#$84,obj.ColType(a0)

locret_587E:
		rts
; ---------------------------------------------------------------------------

loc_5880:
		out_of_range.w	loc_58A0
		rts
; ---------------------------------------------------------------------------

loc_58A0:
		moveq	#0,d2
		lea	obj.Subtype(a0),a2
		move.b	(a2)+,d2
		subq.b	#2,d2
		bcs.s	loc_58C2

loc_58AC:
		moveq	#0,d0
		move.b	(a2)+,d0
		lsl.w	#6,d0
		addi.l	#v_objspace&$FFFFFF,d0
		movea.l	d0,a1
		bsr.w	ObjectDeleteA1
		dbf	d2,loc_58AC

loc_58C2:
		bsr.w	DeleteObject
		rts
; ---------------------------------------------------------------------------

loc_58C8:
		bsr.w	sub_5860
		bra.w	DisplaySprite
