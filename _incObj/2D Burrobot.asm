; ---------------------------------------------------------------------------

ObjBurrobot:
		moveq	#0,d0
		move.b	obj.Routine(a0),d0
		move.w	off_8CFC(pc,d0.w),d1
		jmp	off_8CFC(pc,d1.w)
; ---------------------------------------------------------------------------

off_8CFC:	dc.w loc_8D02-off_8CFC, loc_8D56-off_8CFC, loc_8E46-off_8CFC
; ---------------------------------------------------------------------------

loc_8D02:
		move.b	#$13,obj.Height(a0)
		move.b	#8,obj.Width(a0)
		move.l	#Map_Burro,obj.Map(a0)
		move.w	#$239C,obj.Gfx(a0)
		move.b	#4,obj.Render(a0)
		move.b	#4,obj.Priority(a0)
		move.b	#5,obj.ColType(a0)
		move.b	#$C,obj.ActWid(a0)
		bset	#0,obj.Status(a0)
		bsr.w	ObjectFall
		bsr.w	ObjectHitFloor
		tst.w	d1
		bpl.s	locret_8D54
		add.w	d1,obj.Ypos(a0)
		move.w	#0,obj.VelY(a0)
		addq.b	#2,obj.Routine(a0)

locret_8D54:
		rts
; ---------------------------------------------------------------------------

loc_8D56:
		moveq	#0,d0
		move.b	obj.2ndRout(a0),d0
		move.w	off_8D72(pc,d0.w),d1
		jsr	off_8D72(pc,d1.w)
		lea	(Ani_Burro).l,a1
		bsr.w	AnimateSprite
		bra.w	RememberState
; ---------------------------------------------------------------------------

off_8D72:	dc.w loc_8D78-off_8D72, loc_8DA2-off_8D72, loc_8E10-off_8D72
; ---------------------------------------------------------------------------

loc_8D78:
		subq.w	#1,$30(a0)
		bpl.s	locret_8DA0
		addq.b	#2,obj.2ndRout(a0)
		move.w	#$FF,$30(a0)
		move.w	#$80,obj.VelX(a0)
		move.b	#1,obj.Anim(a0)
		bchg	#0,obj.Status(a0)
		beq.s	locret_8DA0
		neg.w	obj.VelX(a0)

locret_8DA0:
		rts
; ---------------------------------------------------------------------------

loc_8DA2:
		subq.w	#1,$30(a0)
		bmi.s	loc_8DDE
		bsr.w	SpeedToPos
		bchg	#0,$32(a0)
		bne.s	loc_8DD4
		move.w	obj.Xpos(a0),d3
		addi.w	#$C,d3
		btst	#0,obj.Status(a0)
		bne.s	loc_8DC8
		subi.w	#$18,d3

loc_8DC8:
		bsr.w	ObjectHitFloor2
		cmpi.w	#$C,d1
		bge.s	loc_8DDE
		rts
; ---------------------------------------------------------------------------

loc_8DD4:
		bsr.w	ObjectHitFloor
		add.w	d1,obj.Ypos(a0)
		rts
; ---------------------------------------------------------------------------

loc_8DDE:
		btst	#2,(v_vbla_byte).w
		beq.s	loc_8DFE
		subq.b	#2,obj.2ndRout(a0)
		move.w	#$3B,$30(a0)
		move.w	#0,obj.VelX(a0)
		move.b	#0,obj.Anim(a0)
		rts
; ---------------------------------------------------------------------------

loc_8DFE:
		addq.b	#2,obj.2ndRout(a0)
		move.w	#$FC00,obj.VelY(a0)
		move.b	#2,obj.Anim(a0)
		rts
; ---------------------------------------------------------------------------

loc_8E10:
		bsr.w	SpeedToPos
		addi.w	#$18,obj.VelY(a0)
		bmi.s	locret_8E44
		move.b	#3,obj.Anim(a0)
		bsr.w	ObjectHitFloor
		tst.w	d1
		bpl.s	locret_8E44
		add.w	d1,obj.Ypos(a0)
		move.w	#0,obj.VelY(a0)
		move.b	#1,obj.Anim(a0)
		move.w	#$FF,$30(a0)
		subq.b	#2,obj.2ndRout(a0)

locret_8E44:
		rts
; ---------------------------------------------------------------------------

loc_8E46:
		bsr.w	DeleteObject
		rts
