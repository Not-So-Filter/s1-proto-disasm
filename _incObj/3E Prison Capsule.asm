; ---------------------------------------------------------------------------

ObjCapsule:
		moveq	#0,d0
		move.b	obj.Routine(a0),d0
		move.w	off_B66C(pc,d0.w),d1
		jsr	off_B66C(pc,d1.w)
		bsr.w	DisplaySprite
		out_of_range.w	DeleteObject
		rts
; ---------------------------------------------------------------------------

off_B66C:	dc.w loc_B68C-off_B66C, loc_B6D6-off_B66C
		dc.w loc_B710-off_B66C, loc_B760-off_B66C
		dc.w loc_B760-off_B66C, loc_B760-off_B66C
		dc.w loc_B7C6-off_B66C, loc_B7FA-off_B66C

byte_B67C:	;    routine, actwid, priority, frame
		dc.b 2, $20, 4, 0
		dc.b 4, $C, 5, 1
		dc.b 6, $10, 4, 3
		dc.b 8, $10, 3, 5
; ---------------------------------------------------------------------------

loc_B68C:
		move.l	#Map_Pri,obj.Map(a0)
		move.w	#$49D,obj.Gfx(a0)
		move.b	#4,obj.Render(a0)
		move.w	obj.Ypos(a0),$30(a0)
		moveq	#0,d0
		move.b	obj.Subtype(a0),d0
		lsl.w	#2,d0
		lea	byte_B67C(pc,d0.w),a1
		move.b	(a1)+,obj.Routine(a0)
		move.b	(a1)+,obj.ActWid(a0)
		move.b	(a1)+,obj.Priority(a0)
		move.b	(a1)+,obj.Frame(a0)
		cmpi.w	#8,d0
		bne.s	locret_B6D4
		move.b	#6,obj.ColType(a0)
		move.b	#8,obj.ColProp(a0)

locret_B6D4:
		rts
; ---------------------------------------------------------------------------

loc_B6D6:
		cmpi.b	#2,(v_bossstatus).w
		beq.s	loc_B6F2
		move.w	#$2B,d1
		move.w	#$18,d2
		move.w	#$18,d3
		move.w	obj.Xpos(a0),d4
		bra.w	SolidObject
; ---------------------------------------------------------------------------

loc_B6F2:
		tst.b	obj.2ndRout(a0)
		beq.s	loc_B708
		clr.b	obj.2ndRout(a0)
		bclr	#3,(v_objspace+obj.Status).w
		bset	#1,(v_objspace+obj.Status).w

loc_B708:
		move.b	#2,obj.Frame(a0)
		rts
; ---------------------------------------------------------------------------

loc_B710:
		move.w	#$17,d1
		move.w	#8,d2
		move.w	#8,d3
		move.w	obj.Xpos(a0),d4
		bsr.w	SolidObject
		lea	(Ani_Pri).l,a1
		bsr.w	AnimateSprite
		move.w	$30(a0),obj.Ypos(a0)
		tst.b	obj.2ndRout(a0)
		beq.s	locret_B75E
		addq.w	#8,obj.Ypos(a0)
		move.b	#$A,obj.Routine(a0)
		move.w	#$3C,obj.TimeFrame(a0)
		clr.b	(f_timecount).w
		clr.b	obj.2ndRout(a0)
		bclr	#3,(v_objspace+obj.Status).w
		bset	#1,(v_objspace+obj.Status).w

locret_B75E:
		rts
; ---------------------------------------------------------------------------

loc_B760:
		move.b	(v_vbla_byte).w,d0
		andi.b	#7,d0
		bne.s	loc_B7A0
		bsr.w	FindFreeObj
		bne.s	loc_B7A0
		_move.b	#id_ExplosionBomb,obj.Id(a1)
		move.w	obj.Xpos(a0),obj.Xpos(a1)
		move.w	obj.Ypos(a0),obj.Ypos(a1)
		jsr	(RandomNumber).l
		move.w	d0,d1
		moveq	#0,d1
		move.b	d0,d1
		lsr.b	#2,d1
		subi.w	#$20,d1
		add.w	d1,obj.Xpos(a1)
		lsr.w	#8,d0
		lsr.b	#3,d0
		add.w	d0,obj.Ypos(a1)

loc_B7A0:
		subq.w	#1,obj.TimeFrame(a0)
		bne.s	locret_B7C4
		move.b	#2,(v_bossstatus).w
		move.b	#$C,obj.Routine(a0)
		move.b	#9,obj.Frame(a0)
		move.w	#$B4,obj.TimeFrame(a0)
		addi.w	#$20,obj.Ypos(a0)

locret_B7C4:
		rts
; ---------------------------------------------------------------------------

loc_B7C6:
		move.b	(v_vbla_byte).w,d0
		andi.b	#7,d0
		bne.s	VBla_028
		bsr.w	FindFreeObj
		bne.s	VBla_028
		_move.b	#id_Animals,obj.Id(a1)
		move.w	obj.Xpos(a0),obj.Xpos(a1)
		move.w	obj.Ypos(a0),obj.Ypos(a1)

VBla_028:
		subq.w	#1,obj.TimeFrame(a0)
		bne.s	locret_B7F8
		addq.b	#2,obj.Routine(a0)
		move.w	#60,obj.TimeFrame(a0)

locret_B7F8:
		rts
; ---------------------------------------------------------------------------

loc_B7FA:
		subq.w	#1,obj.TimeFrame(a0)
		bne.s	locret_B808
		bsr.w	sub_C81C
		bra.w	DeleteObject
; ---------------------------------------------------------------------------

locret_B808:
		rts
