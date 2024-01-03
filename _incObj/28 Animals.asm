; ---------------------------------------------------------------------------

ObjAnimals:
		moveq	#0,d0
		move.b	obj.Routine(a0),d0
		move.w	off_732C(pc,d0.w),d1
		jmp	off_732C(pc,d1.w)
; ---------------------------------------------------------------------------

off_732C:	dc.w loc_7382-off_732C, loc_7418-off_732C, loc_7472-off_732C, loc_74A8-off_732C, loc_7472-off_732C
		dc.w loc_7472-off_732C, loc_7472-off_732C, loc_74A8-off_732C, loc_7472-off_732C

byte_733E:	dc.b 0, 1, 2, 3, 4, 5, 6, 3, 4, 1, 0, 5

word_734A:	dc.w $FE00, $FC00
		dc.l Map_Animal1
		dc.w $FE00, $FD00
		dc.l Map_Animal2
		dc.w $FEC0, $FE00
		dc.l Map_Animal1
		dc.w $FF00, $FE80
		dc.l Map_Animal2
		dc.w $FE80, $FD00
		dc.l Map_Animal3
		dc.w $FD00, $FC00
		dc.l Map_Animal2
		dc.w $FD80, $FC80
		dc.l Map_Animal3
; ---------------------------------------------------------------------------

loc_7382:
		addq.b	#2,obj.Routine(a0)
		bsr.w	RandomNumber
		andi.w	#1,d0
		moveq	#0,d1
		move.b	(v_zone).w,d1
		add.w	d1,d1
		add.w	d0,d1
		move.b	byte_733E(pc,d1.w),d0
		move.b	d0,$30(a0)
		lsl.w	#3,d0
		lea	word_734A(pc,d0.w),a1
		move.w	(a1)+,$32(a0)
		move.w	(a1)+,$34(a0)
		move.l	(a1)+,obj.Map(a0)
		move.w	#$580,obj.Gfx(a0)
		btst	#0,$30(a0)
		beq.s	loc_73C6
		move.w	#$592,obj.Gfx(a0)

loc_73C6:
		move.b	#$C,obj.Height(a0)
		move.b	#4,obj.Render(a0)
		bset	#0,obj.Render(a0)
		move.b	#6,obj.Priority(a0)
		move.b	#8,obj.ActWid(a0)
		move.b	#7,obj.TimeFrame(a0)
		move.b	#2,obj.Frame(a0)
		move.w	#-$400,obj.VelY(a0)
		tst.b	(v_bossstatus).w
		bne.s	loc_7438
		bsr.w	FindFreeObj
		bne.s	loc_7414
		_move.b	#id_Points,obj.Id(a1)
		move.w	obj.Xpos(a0),obj.Xpos(a1)
		move.w	obj.Ypos(a0),obj.Ypos(a1)

loc_7414:
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

loc_7418:
		tst.b	obj.Render(a0)
		bpl.w	DeleteObject
		bsr.w	ObjectFall
		tst.w	obj.VelY(a0)
		bmi.s	loc_746E
		jsr	(ObjectHitFloor).l
		tst.w	d1
		bpl.s	loc_746E
		add.w	d1,obj.Ypos(a0)

loc_7438:
		move.w	$32(a0),obj.VelX(a0)
		move.w	$34(a0),obj.VelY(a0)
		move.b	#1,obj.Frame(a0)
		move.b	$30(a0),d0
		add.b	d0,d0
		addq.b	#4,d0
		move.b	d0,obj.Routine(a0)
		tst.b	(v_bossstatus).w
		beq.s	loc_746E
		btst	#4,(v_vbla_byte).w
		beq.s	loc_746E
		neg.w	obj.VelX(a0)
		bchg	#0,obj.Render(a0)

loc_746E:
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

loc_7472:
		bsr.w	ObjectFall
		move.b	#1,obj.Frame(a0)
		tst.w	obj.VelY(a0)
		bmi.s	loc_749C
		move.b	#0,obj.Frame(a0)
		jsr	(ObjectHitFloor).l
		tst.w	d1
		bpl.s	loc_749C
		add.w	d1,obj.Ypos(a0)
		move.w	$34(a0),obj.VelY(a0)

loc_749C:
		tst.b	obj.Render(a0)
		bpl.w	DeleteObject
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

loc_74A8:
		bsr.w	SpeedToPos
		addi.w	#$18,obj.VelY(a0)
		tst.w	obj.VelY(a0)
		bmi.s	loc_74CC
		jsr	(ObjectHitFloor).l
		tst.w	d1
		bpl.s	loc_74CC
		add.w	d1,obj.Ypos(a0)
		move.w	$34(a0),obj.VelY(a0)

loc_74CC:
		subq.b	#1,obj.TimeFrame(a0)
		bpl.s	loc_74E2
		move.b	#1,obj.TimeFrame(a0)
		addq.b	#1,obj.Frame(a0)
		andi.b	#1,obj.Frame(a0)

loc_74E2:
		tst.b	obj.Render(a0)
		bpl.w	DeleteObject
		bra.w	DisplaySprite
