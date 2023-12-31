; ---------------------------------------------------------------------------

ObjBuzzbomber:
		moveq	#0,d0
		move.b	obj.Routine(a0),d0
		move.w	off_78A6(pc,d0.w),d1
		jmp	off_78A6(pc,d1.w)
; ---------------------------------------------------------------------------
off_78A6:	dc.w loc_78AC-off_78A6, loc_78D6-off_78A6, loc_79E6-off_78A6
; ---------------------------------------------------------------------------

loc_78AC:
		addq.b	#2,obj.Routine(a0)
		move.l	#Map_Buzz,obj.Map(a0)
		move.w	#$444,obj.Gfx(a0)
		move.b	#4,obj.Render(a0)
		move.b	#3,obj.Priority(a0)
		move.b	#8,obj.ColType(a0)
		move.b	#$18,obj.ActWid(a0)

loc_78D6:
		moveq	#0,d0
		move.b	obj.2ndRout(a0),d0
		move.w	off_78F2(pc,d0.w),d1
		jsr	off_78F2(pc,d1.w)
		lea	(Ani_Buzz).l,a1
		bsr.w	AnimateSprite
		bra.w	RememberState
; ---------------------------------------------------------------------------
off_78F2:
		dc.w loc_78F6-off_78F2
		dc.w loc_798C-off_78F2
; ---------------------------------------------------------------------------

loc_78F6:
		subq.w	#1,$32(a0)
		bpl.s	locret_7926
		btst	#1,$34(a0)
		bne.s	loc_7928
		addq.b	#2,obj.2ndRout(a0)
		move.w	#$7F,$32(a0)
		move.w	#$400,obj.VelX(a0)
		move.b	#1,obj.Anim(a0)
		btst	#0,obj.Status(a0)
		bne.s	locret_7926
		neg.w	obj.VelX(a0)

locret_7926:
		rts
; ---------------------------------------------------------------------------

loc_7928:
		bsr.w	FindFreeObj
		bne.s	locret_798A
		_move.b	#id_Missile,obj.Id(a1)
		move.w	obj.Xpos(a0),obj.Xpos(a1)
		move.w	obj.Ypos(a0),obj.Ypos(a1)
		addi.w	#$1C,obj.Ypos(a1)
		move.w	#$200,obj.VelY(a1)
		move.w	#$200,obj.VelX(a1)
		move.w	#$18,d0
		btst	#0,obj.Status(a0)
		bne.s	loc_7964
		neg.w	d0
		neg.w	obj.VelX(a1)

loc_7964:
		add.w	d0,obj.Xpos(a1)
		move.b	obj.Status(a0),obj.Status(a1)
		move.w	#$E,$32(a1)
		move.l	a0,$3C(a1)
		move.b	#1,$34(a0)
		move.w	#$3B,$32(a0)
		move.b	#2,obj.Anim(a0)

locret_798A:
		rts
; ---------------------------------------------------------------------------

loc_798C:
		subq.w	#1,$32(a0)
		bmi.s	loc_79C2
		bsr.w	SpeedToPos
		tst.b	$34(a0)
		bne.s	locret_79E4
		move.w	(v_objspace+obj.Xpos).w,d0
		sub.w	obj.Xpos(a0),d0
		bpl.s	loc_79A8
		neg.w	d0

loc_79A8:
		cmpi.w	#$60,d0
		bcc.s	locret_79E4
		tst.b	obj.Render(a0)
		bpl.s	locret_79E4
		move.b	#2,$34(a0)
		move.w	#$1D,$32(a0)
		bra.s	loc_79D4
; ---------------------------------------------------------------------------

loc_79C2:
		move.b	#0,$34(a0)
		bchg	#0,obj.Status(a0)
		move.w	#$3B,$32(a0)

loc_79D4:
		subq.b	#2,obj.2ndRout(a0)
		move.w	#0,obj.VelX(a0)
		move.b	#0,obj.Anim(a0)

locret_79E4:
		rts
; ---------------------------------------------------------------------------

loc_79E6:
		bsr.w	DeleteObject
		rts