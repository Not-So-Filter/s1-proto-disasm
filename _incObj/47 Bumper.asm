; ---------------------------------------------------------------------------

ObjBumper:
		moveq	#0,d0
		move.b	obj.Routine(a0),d0
		move.w	off_C5FE(pc,d0.w),d1
		jmp	off_C5FE(pc,d1.w)
; ---------------------------------------------------------------------------

off_C5FE:	dc.w loc_C602-off_C5FE, loc_C62C-off_C5FE
; ---------------------------------------------------------------------------

loc_C602:
		addq.b	#2,obj.Routine(a0)
		move.l	#Map_Bump,obj.Map(a0)
		move.w	#$380,obj.Gfx(a0)
		move.b	#4,obj.Render(a0)
		move.b	#$10,obj.ActWid(a0)
		move.b	#1,obj.Priority(a0)
		move.b	#$D7,obj.ColType(a0)

loc_C62C:
		tst.b	obj.ColProp(a0)
		beq.s	loc_C684
		clr.b	obj.ColProp(a0)
		lea	(v_objspace).w,a1
		move.w	obj.Xpos(a0),d1
		move.w	obj.Ypos(a0),d2
		sub.w	obj.Xpos(a1),d1
		sub.w	obj.Ypos(a1),d2
		jsr	(CalcAngle).l
		jsr	(CalcSine).l
		muls.w	#$F900,d1
		asr.l	#8,d1
		move.w	d1,obj.VelX(a1)
		muls.w	#$F900,d0
		asr.l	#8,d0
		move.w	d0,obj.VelY(a1)
		bset	#1,obj.Status(a1)
		clr.b	$3C(a1)
		move.b	#1,obj.Anim(a0)
		move.w	#sfx_Bumper,d0
		jsr	(PlaySound_Special).l

loc_C684:
		lea	(Ani_Bump).l,a1
		bsr.w	AnimateSprite
		bsr.w	DisplaySprite
		out_of_range.w	DeleteObject
		rts