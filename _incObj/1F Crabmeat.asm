; ---------------------------------------------------------------------------

ObjCrabmeat:
		moveq	#0,d0
		move.b	obj.Routine(a0),d0
		move.w	off_75B8(pc,d0.w),d1
		jmp	off_75B8(pc,d1.w)
; ---------------------------------------------------------------------------

off_75B8:	dc.w loc_75C2-off_75B8, loc_7616-off_75B8, loc_7772-off_75B8, loc_7778-off_75B8, loc_77AE-off_75B8
; ---------------------------------------------------------------------------

loc_75C2:
		move.b	#$10,obj.Height(a0)
		move.b	#8,obj.Width(a0)
		move.l	#Map_Crab,obj.Map(a0)
		move.w	#$400,obj.Gfx(a0)
		move.b	#4,obj.Render(a0)
		move.b	#3,obj.Priority(a0)
		move.b	#6,obj.ColType(a0)
		move.b	#$15,obj.ActWid(a0)
		bsr.w	ObjectFall
		jsr	(ObjectHitFloor).l
		tst.w	d1
		bpl.s	locret_7614
		add.w	d1,obj.Ypos(a0)
		move.b	d3,obj.Angle(a0)
		move.w	#0,obj.VelY(a0)
		addq.b	#2,obj.Routine(a0)

locret_7614:
		rts
; ---------------------------------------------------------------------------

loc_7616:
		moveq	#0,d0
		move.b	obj.2ndRout(a0),d0
		move.w	off_7632(pc,d0.w),d1
		jsr	off_7632(pc,d1.w)
		lea	(Ani_Crab).l,a1
		bsr.w	AnimateSprite
		bra.w	RememberState
; ---------------------------------------------------------------------------

off_7632:	dc.w loc_7636-off_7632, loc_76D4-off_7632
; ---------------------------------------------------------------------------

loc_7636:
		subq.w	#1,$30(a0)
		bpl.s	locret_7670
		tst.b	obj.Render(a0)
		bpl.s	loc_764A
		bchg	#1,$32(a0)
		bne.s	loc_7672

loc_764A:
		addq.b	#2,obj.2ndRout(a0)
		move.w	#$7F,$30(a0)
		move.w	#$80,obj.VelX(a0)
		bsr.w	sub_7742
		addq.b	#3,d0
		move.b	d0,obj.Anim(a0)
		bchg	#0,obj.Status(a0)
		bne.s	locret_7670
		neg.w	obj.VelX(a0)

locret_7670:
		rts
; ---------------------------------------------------------------------------

loc_7672:
		move.w	#$3B,$30(a0)
		move.b	#6,obj.Anim(a0)
		bsr.w	FindFreeObj
		bne.s	loc_76A8
		_move.b	#id_Crabmeat,obj.Id(a1)
		move.b	#6,obj.Routine(a1)
		move.w	obj.Xpos(a0),obj.Xpos(a1)
		subi.w	#$10,obj.Xpos(a1)
		move.w	obj.Ypos(a0),obj.Ypos(a1)
		move.w	#-$100,obj.VelX(a1)

loc_76A8:
		bsr.w	FindFreeObj
		bne.s	locret_76D2
		_move.b	#id_Crabmeat,obj.Id(a1)
		move.b	#6,obj.Routine(a1)
		move.w	obj.Xpos(a0),obj.Xpos(a1)
		addi.w	#$10,obj.Xpos(a1)
		move.w	obj.Ypos(a0),obj.Ypos(a1)
		move.w	#$100,obj.VelX(a1)

locret_76D2:
		rts
; ---------------------------------------------------------------------------

loc_76D4:
		subq.w	#1,$30(a0)
		bmi.s	loc_7728
		bsr.w	SpeedToPos
		bchg	#0,$32(a0)
		bne.s	loc_770E
		move.w	obj.Xpos(a0),d3
		addi.w	#$10,d3
		btst	#0,obj.Status(a0)
		beq.s	loc_76FA
		subi.w	#$20,d3

loc_76FA:
		jsr	(ObjectHitFloor2).l
		cmpi.w	#$FFF8,d1
		blt.s	loc_7728
		cmpi.w	#$C,d1
		bge.s	loc_7728
		rts
; ---------------------------------------------------------------------------

loc_770E:
		jsr	(ObjectHitFloor).l
		add.w	d1,obj.Ypos(a0)
		move.b	d3,obj.Angle(a0)
		bsr.w	sub_7742
		addq.b	#3,d0
		move.b	d0,obj.Anim(a0)
		rts
; ---------------------------------------------------------------------------

loc_7728:
		subq.b	#2,obj.2ndRout(a0)
		move.w	#$3B,$30(a0)

loc_7732:
		move.w	#0,obj.VelX(a0)
		bsr.w	sub_7742
		move.b	d0,obj.Anim(a0)
		rts
; ---------------------------------------------------------------------------

sub_7742:
		moveq	#0,d0
		move.b	obj.Angle(a0),d3
		bmi.s	loc_775E
		cmpi.b	#6,d3
		bcs.s	locret_775C
		moveq	#1,d0
		btst	#0,obj.Status(a0)
		bne.s	locret_775C
		moveq	#2,d0

locret_775C:
		rts
; ---------------------------------------------------------------------------

loc_775E:
		cmpi.b	#$FA,d3
		bhi.s	locret_7770
		moveq	#2,d0
		btst	#0,obj.Status(a0)
		bne.s	locret_7770
		moveq	#1,d0

locret_7770:
		rts
; ---------------------------------------------------------------------------

loc_7772:
		bsr.w	DeleteObject
		rts
; ---------------------------------------------------------------------------

loc_7778:
		addq.b	#2,obj.Routine(a0)
		move.l	#Map_Crab,obj.Map(a0)
		move.w	#$400,obj.Gfx(a0)
		move.b	#4,obj.Render(a0)
		move.b	#3,obj.Priority(a0)
		move.b	#$87,obj.ColType(a0)
		move.b	#8,obj.ActWid(a0)
		move.w	#$FC00,obj.VelY(a0)
		move.b	#7,obj.Anim(a0)

loc_77AE:
		lea	(Ani_Crab).l,a1
		bsr.w	AnimateSprite
		bsr.w	ObjectFall
		bsr.w	DisplaySprite
		move.w	(v_limitbtm2).w,d0
		addi.w	#$E0,d0
		cmp.w	obj.Ypos(a0),d0
		bcs.s	loc_77D0
		rts
; ---------------------------------------------------------------------------

loc_77D0:
		bra.w	DeleteObject
