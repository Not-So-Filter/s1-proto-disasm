; ---------------------------------------------------------------------------

ObjNewtron:
		moveq	#0,d0
		move.b	obj.Routine(a0),d0
		move.w	off_BD26(pc,d0.w),d1
		jmp	off_BD26(pc,d1.w)
; ---------------------------------------------------------------------------

off_BD26:	dc.w loc_BD2C-off_BD26, loc_BD5C-off_BD26, loc_BEC6-off_BD26
; ---------------------------------------------------------------------------

loc_BD2C:
		addq.b	#2,obj.Routine(a0)
		move.l	#Map_Newt,obj.Map(a0)
		move.w	#$249B,obj.Gfx(a0)
		move.b	#4,obj.Render(a0)
		move.b	#4,obj.Priority(a0)
		move.b	#$14,obj.ActWid(a0)
		move.b	#$10,obj.Height(a0)
		move.b	#8,obj.Width(a0)

loc_BD5C:
		moveq	#0,d0
		move.b	obj.2ndRout(a0),d0
		move.w	off_BD78(pc,d0.w),d1
		jsr	off_BD78(pc,d1.w)
		lea	(Ani_Newt).l,a1
		bsr.w	AnimateSprite
		bra.w	RememberState
; ---------------------------------------------------------------------------

off_BD78:	dc.w loc_BD82-off_BD78, loc_BDC4-off_BD78, loc_BE38-off_BD78, loc_BE58-off_BD78, loc_BE5E-off_BD78
; ---------------------------------------------------------------------------

loc_BD82:
		bset	#0,obj.Status(a0)
		move.w	(v_objspace+obj.Xpos).w,d0
		sub.w	obj.Xpos(a0),d0
		bcc.s	loc_BD9A
		neg.w	d0
		bclr	#0,obj.Status(a0)

loc_BD9A:
		cmpi.w	#$80,d0
		bcc.s	locret_BDC2
		addq.b	#2,obj.2ndRout(a0)
		move.b	#1,obj.Anim(a0)
		tst.b	obj.Subtype(a0)
		beq.s	locret_BDC2
		move.w	#$49B,obj.Gfx(a0)
		move.b	#8,obj.2ndRout(a0)
		move.b	#4,obj.Anim(a0)

locret_BDC2:
		rts
; ---------------------------------------------------------------------------

loc_BDC4:
		cmpi.b	#4,obj.Frame(a0)
		bcc.s	loc_BDE4
		bset	#0,obj.Status(a0)
		move.w	(v_objspace+obj.Xpos).w,d0
		sub.w	obj.Xpos(a0),d0
		bcc.s	locret_BDE2
		bclr	#0,obj.Status(a0)

locret_BDE2:
		rts
; ---------------------------------------------------------------------------

loc_BDE4:
		cmpi.b	#1,obj.Frame(a0)
		bne.s	loc_BDF2
		move.b	#$C,obj.ColType(a0)

loc_BDF2:
		bsr.w	ObjectFall
		bsr.w	ObjectHitFloor
		tst.w	d1
		bpl.s	locret_BE36
		add.w	d1,obj.Ypos(a0)
		move.w	#0,obj.VelY(a0)
		addq.b	#2,obj.2ndRout(a0)
		move.b	#2,obj.Anim(a0)
		btst	#5,2(a0)
		beq.s	loc_BE1E
		addq.b	#1,obj.Anim(a0)

loc_BE1E:
		move.b	#$D,obj.ColType(a0)
		move.w	#$200,obj.VelX(a0)
		btst	#0,obj.Status(a0)
		bne.s	locret_BE36
		neg.w	obj.VelX(a0)

locret_BE36:
		rts
; ---------------------------------------------------------------------------

loc_BE38:
		bsr.w	SpeedToPos

loc_BE3C:
		bsr.w	ObjectHitFloor
		cmpi.w	#$FFF8,d1
		blt.s	loc_BE52
		cmpi.w	#$C,d1
		bge.s	loc_BE52
		add.w	d1,obj.Ypos(a0)
		rts
; ---------------------------------------------------------------------------

loc_BE52:
		addq.b	#2,obj.2ndRout(a0)
		rts
; ---------------------------------------------------------------------------

loc_BE58:
		bsr.w	SpeedToPos
		rts
; ---------------------------------------------------------------------------

loc_BE5E:
		cmpi.b	#1,obj.Frame(a0)
		bne.s	loc_BE6C
		move.b	#$C,obj.ColType(a0)

loc_BE6C:
		cmpi.b	#2,obj.Frame(a0)
		bne.s	locret_BEC4
		tst.b	$32(a0)
		bne.s	locret_BEC4
		move.b	#1,$32(a0)
		bsr.w	FindFreeObj
		bne.s	locret_BEC4
		_move.b	#id_Missile,obj.Id(a1)
		move.w	obj.Xpos(a0),obj.Xpos(a1)
		move.w	obj.Ypos(a0),obj.Ypos(a1)
		subq.w	#8,obj.Ypos(a1)
		move.w	#$200,obj.VelX(a1)
		move.w	#$14,d0
		btst	#0,obj.Status(a0)
		bne.s	loc_BEB4
		neg.w	d0
		neg.w	obj.VelX(a1)

loc_BEB4:
		add.w	d0,obj.Xpos(a1)
		move.b	obj.Status(a0),obj.Status(a1)
		move.b	#1,obj.Subtype(a1)

locret_BEC4:
		rts
; ---------------------------------------------------------------------------

loc_BEC6:
		bra.w	DeleteObject
