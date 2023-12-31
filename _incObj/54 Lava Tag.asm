; ---------------------------------------------------------------------------

ObjLavaHurt:
		moveq	#0,d0
		move.b	obj.Routine(a0),d0
		move.w	off_CD2E(pc,d0.w),d1
		jmp	off_CD2E(pc,d1.w)
; ---------------------------------------------------------------------------

off_CD2E:	dc.w loc_CD36-off_CD2E, loc_CD6C-off_CD2E

byte_CD32:	dc.b $96, $94, $95, 0
; ---------------------------------------------------------------------------

loc_CD36:
		addq.b	#2,obj.Routine(a0)
		moveq	#0,d0
		move.b	obj.Subtype(a0),d0
		move.b	byte_CD32(pc,d0.w),obj.ColType(a0)
		move.l	#Map_LTag,obj.Map(a0)
		move.w	#$8680,obj.Gfx(a0)
		move.b	#4,obj.Render(a0)
		move.b	#$80,obj.ActWid(a0)
		move.b	#4,obj.Priority(a0)
		move.b	obj.Subtype(a0),obj.Frame(a0)

loc_CD6C:
		tst.w	(v_debuguse).w
		beq.s	loc_CD76
		bsr.w	DisplaySprite

loc_CD76:
		cmpi.b	#6,(v_player+obj.Routine).w
		bcc.s	loc_CD84
		bset	#7,obj.Render(a0)

loc_CD84:
		move.w	obj.Xpos(a0),d0
		andi.w	#$FF80,d0
		move.w	(v_screenposx).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0
		bmi.w	DeleteObject
		cmpi.w	#$280,d0
		bhi.w	DeleteObject
		rts