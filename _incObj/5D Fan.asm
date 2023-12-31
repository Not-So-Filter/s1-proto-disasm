; ---------------------------------------------------------------------------

ObjFan:
		moveq	#0,d0
		move.b	obj.Routine(a0),d0
		move.w	off_E56C(pc,d0.w),d1
		jmp	off_E56C(pc,d1.w)
; ---------------------------------------------------------------------------

off_E56C:	dc.w loc_E570-off_E56C, loc_E594-off_E56C
; ---------------------------------------------------------------------------

loc_E570:
		addq.b	#2,obj.Routine(a0)
		move.l	#Map_Fan,obj.Map(a0)
		move.w	#$43A0,obj.Gfx(a0)
		move.b	#4,obj.Render(a0)
		move.b	#$10,obj.ActWid(a0)
		move.b	#4,obj.Priority(a0)

loc_E594:
		btst	#1,$28(a0)
		bne.s	loc_E5B6
		subq.w	#1,$30(a0)
		bpl.s	loc_E5B6
		move.w	#$78,$30(a0)
		bchg	#0,$32(a0)
		beq.s	loc_E5B6
		move.w	#$B4,$30(a0)

loc_E5B6:
		tst.b	$32(a0)
		bne.w	loc_E64E
		lea	(v_objspace).w,a1
		move.w	obj.Xpos(a1),d0
		sub.w	obj.Xpos(a0),d0
		btst	#0,obj.Status(a0)
		bne.s	loc_E5D4
		neg.w	d0

loc_E5D4:
		addi.w	#$50,d0
		cmpi.w	#$F0,d0
		bcc.s	loc_E61C
		move.w	obj.Ypos(a1),d1
		addi.w	#$60,d1
		sub.w	obj.Ypos(a0),d1
		bcs.s	loc_E61C
		cmpi.w	#$70,d1
		bcc.s	loc_E61C
		subi.w	#$50,d0
		bcc.s	loc_E5FC
		not.w	d0
		add.w	d0,d0

loc_E5FC:
		addi.w	#$60,d0
		btst	#0,obj.Status(a0)
		bne.s	loc_E60A
		neg.w	d0

loc_E60A:
		neg.b	d0
		asr.w	#4,d0
		btst	#0,obj.Subtype(a0)
		beq.s	loc_E618
		neg.w	d0

loc_E618:
		add.w	d0,obj.Xpos(a1)

loc_E61C:
		subq.b	#1,obj.TimeFrame(a0)
		bpl.s	loc_E64E
		move.b	#0,obj.TimeFrame(a0)
		addq.b	#1,obj.AniFrame(a0)
		cmpi.b	#3,obj.AniFrame(a0)
		bcs.s	loc_E63A
		move.b	#0,obj.AniFrame(a0)

loc_E63A:
		moveq	#0,d0
		btst	#0,obj.Subtype(a0)
		beq.s	loc_E646
		moveq	#2,d0

loc_E646:
		add.b	obj.AniFrame(a0),d0
		move.b	d0,obj.Frame(a0)

loc_E64E:
		bsr.w	DisplaySprite
		out_of_range.w	DeleteObject
		rts