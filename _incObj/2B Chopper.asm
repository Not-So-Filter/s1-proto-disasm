; ---------------------------------------------------------------------------

ObjChopper:
		moveq	#0,d0
		move.b	obj.Routine(a0),d0
		move.w	off_8BB6(pc,d0.w),d1
		jsr	off_8BB6(pc,d1.w)
		bra.w	RememberState
; ---------------------------------------------------------------------------

off_8BB6:	dc.w loc_8BBA-off_8BB6, loc_8BF0-off_8BB6
; ---------------------------------------------------------------------------

loc_8BBA:
		addq.b	#2,obj.Routine(a0)
		move.l	#Map_Chop,obj.Map(a0)
		move.w	#$47B,obj.Gfx(a0)
		move.b	#4,obj.Render(a0)
		move.b	#4,obj.Priority(a0)
		move.b	#9,obj.ColType(a0)
		move.b	#$10,obj.ActWid(a0)
		move.w	#$F900,obj.VelY(a0)
		move.w	obj.Ypos(a0),$30(a0)

loc_8BF0:
		lea	(Ani_Chop).l,a1
		bsr.w	AnimateSprite
		bsr.w	SpeedToPos
		addi.w	#$18,obj.VelY(a0)
		move.w	$30(a0),d0
		cmp.w	obj.Ypos(a0),d0
		bcc.s	loc_8C18
		move.w	d0,obj.Ypos(a0)
		move.w	#-$700,obj.VelY(a0)

loc_8C18:
		move.b	#1,obj.Anim(a0)
		subi.w	#$C0,d0
		cmp.w	obj.Ypos(a0),d0
		bcc.s	locret_8C3A
		move.b	#0,obj.Anim(a0)
		tst.w	obj.VelY(a0)
		bmi.s	locret_8C3A
		move.b	#2,obj.Anim(a0)

locret_8C3A:
		rts