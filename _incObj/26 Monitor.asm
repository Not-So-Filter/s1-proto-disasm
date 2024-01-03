; ---------------------------------------------------------------------------

ObjMonitor:
		moveq	#0,d0
		move.b	obj.Routine(a0),d0
		move.w	off_8054(pc,d0.w),d1
		jmp	off_8054(pc,d1.w)
; ---------------------------------------------------------------------------

off_8054:	dc.w loc_805E-off_8054, loc_80C0-off_8054
		dc.w sub_81D2-off_8054, loc_81A4-off_8054
		dc.w loc_81AE-off_8054
; ---------------------------------------------------------------------------

loc_805E:
		addq.b	#2,obj.Routine(a0)
		move.b	#$E,obj.Height(a0)
		move.b	#$E,obj.Width(a0)
		move.l	#Map_Monitor,obj.Map(a0)
		move.w	#$680,obj.Gfx(a0)
		move.b	#4,obj.Render(a0)
		move.b	#3,obj.Priority(a0)
		move.b	#$F,obj.ActWid(a0)
		lea	(v_regbuffer).w,a2
		moveq	#0,d0
		move.b	obj.RespawnNo(a0),d0
		bclr	#7,2(a2,d0.w)
		btst	#0,2(a2,d0.w)
		beq.s	loc_80B4
		move.b	#8,obj.Routine(a0)
		move.b	#$B,obj.Frame(a0)
		rts
; ---------------------------------------------------------------------------

loc_80B4:
		move.b	#$46,obj.ColType(a0)
		move.b	obj.Subtype(a0),obj.Anim(a0)

loc_80C0:
		move.b	obj.2ndRout(a0),d0
		beq.s	loc_811A
		subq.b	#2,d0
		bne.s	loc_80FA
		moveq	#0,d1
		move.b	obj.ActWid(a0),d1
		addi.w	#$B,d1
		bsr.w	PtfmCheckExit
		btst	#3,obj.Status(a1)
		bne.w	loc_80EA
		clr.b	obj.2ndRout(a0)
		bra.w	loc_81A4
; ---------------------------------------------------------------------------

loc_80EA:
		move.w	#$10,d3
		move.w	obj.Xpos(a0),d2
		bsr.w	PtfmSurfaceHeight
		bra.w	loc_81A4
; ---------------------------------------------------------------------------

loc_80FA:
		bsr.w	ObjectFall
		jsr	(ObjectHitFloor).l
		tst.w	d1
		bpl.w	loc_81A4
		add.w	d1,obj.Ypos(a0)
		clr.w	obj.VelY(a0)
		clr.b	obj.2ndRout(a0)
		bra.w	loc_81A4
; ---------------------------------------------------------------------------

loc_811A:
		move.w	#$1A,d1
		move.w	#$F,d2
		bsr.w	sub_83B4
		beq.w	loc_818A
		tst.w	obj.VelY(a1)
		bmi.s	loc_8138
		cmpi.b	#2,obj.Anim(a1)
		beq.s	loc_818A

loc_8138:
		tst.w	d1
		bpl.s	loc_814E
		sub.w	d3,obj.Ypos(a1)
		bsr.w	loc_4FD4
		move.b	#2,obj.2ndRout(a0)
		bra.w	loc_81A4
; ---------------------------------------------------------------------------

loc_814E:
		tst.w	d0
		beq.w	loc_8174
		bmi.s	loc_815E
		tst.w	obj.VelX(a1)
		bmi.s	loc_8174
		bra.s	loc_8164
; ---------------------------------------------------------------------------

loc_815E:
		tst.w	obj.VelX(a1)
		bpl.s	loc_8174

loc_8164:
		sub.w	d0,obj.Xpos(a1)
		move.w	#0,obj.Inertia(a1)
		move.w	#0,obj.VelX(a1)

loc_8174:
		btst	#1,obj.Status(a1)
		bne.s	loc_8198
		bset	#5,obj.Status(a1)
		bset	#5,obj.Status(a0)
		bra.s	loc_81A4
; ---------------------------------------------------------------------------

loc_818A:
		btst	#5,obj.Status(a0)
		beq.s	loc_81A4
		move.w	#1,obj.Anim(a1)

loc_8198:
		bclr	#5,obj.Status(a0)
		bclr	#5,obj.Status(a1)

loc_81A4:
		lea	(AniMonitor).l,a1
		bsr.w	AnimateSprite

loc_81AE:
		bsr.w	DisplaySprite
		out_of_range.w	DeleteObject
		rts
; ---------------------------------------------------------------------------

sub_81D2:
		addq.b	#2,obj.Routine(a0)
		move.b	#0,obj.ColType(a0)
		bsr.w	FindFreeObj
		bne.s	loc_81FA
		_move.b	#id_PowerUp,obj.Id(a1)
		move.w	obj.Xpos(a0),obj.Xpos(a1)
		move.w	obj.Ypos(a0),obj.Ypos(a1)
		move.b	obj.Anim(a0),obj.Anim(a1)

loc_81FA:
		bsr.w	FindFreeObj
		bne.s	loc_8216
		_move.b	#id_ExplosionItem,obj.Id(a1)
		addq.b	#2,obj.Routine(a1)
		move.w	obj.Xpos(a0),obj.Xpos(a1)
		move.w	obj.Ypos(a0),obj.Ypos(a1)

loc_8216:
		lea	(v_regbuffer).w,a2
		moveq	#0,d0
		move.b	obj.RespawnNo(a0),d0
		bset	#0,2(a2,d0.w)
		move.b	#9,obj.Anim(a0)
		bra.w	DisplaySprite
