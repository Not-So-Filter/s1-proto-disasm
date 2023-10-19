; ---------------------------------------------------------------------------

ObjCrabmeat:
		moveq	#0,d0
		move.b	objRoutine(a0),d0
		move.w	off_75B8(pc,d0.w),d1
		jmp	off_75B8(pc,d1.w)
; ---------------------------------------------------------------------------

off_75B8:	dc.w loc_75C2-off_75B8, loc_7616-off_75B8, loc_7772-off_75B8, loc_7778-off_75B8, loc_77AE-off_75B8
; ---------------------------------------------------------------------------

loc_75C2:
		move.b	#$10,objHeight(a0)
		move.b	#8,objWidth(a0)
		move.l	#Map_Crab,objMap(a0)
		move.w	#$400,objGfx(a0)
		move.b	#4,objRender(a0)
		move.b	#3,objPriority(a0)
		move.b	#6,objColType(a0)
		move.b	#$15,objActWid(a0)
		bsr.w	ObjectFall
		jsr	(ObjectHitFloor).l
		tst.w	d1
		bpl.s	locret_7614
		add.w	d1,objY(a0)
		move.b	d3,objAngle(a0)
		move.w	#0,objVelY(a0)
		addq.b	#2,objRoutine(a0)

locret_7614:
		rts
; ---------------------------------------------------------------------------

loc_7616:
		moveq	#0,d0
		move.b	obj2ndRout(a0),d0
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
		tst.b	objRender(a0)
		bpl.s	loc_764A
		bchg	#1,$32(a0)
		bne.s	loc_7672

loc_764A:
		addq.b	#2,obj2ndRout(a0)
		move.w	#$7F,$30(a0)
		move.w	#$80,objVelX(a0)
		bsr.w	sub_7742
		addq.b	#3,d0
		move.b	d0,objAnim(a0)
		bchg	#0,objStatus(a0)
		bne.s	locret_7670
		neg.w	objVelX(a0)

locret_7670:
		rts
; ---------------------------------------------------------------------------

loc_7672:
		move.w	#$3B,$30(a0)
		move.b	#6,objAnim(a0)
		bsr.w	FindFreeObj
		bne.s	loc_76A8
		move.b	#id_Crabmeat,objId(a1)
		move.b	#6,objRoutine(a1)
		move.w	objX(a0),objX(a1)
		subi.w	#$10,objX(a1)
		move.w	objY(a0),objY(a1)
		move.w	#$FF00,objVelX(a1)

loc_76A8:
		bsr.w	FindFreeObj
		bne.s	locret_76D2
		move.b	#id_Crabmeat,objId(a1)
		move.b	#6,objRoutine(a1)
		move.w	objX(a0),objX(a1)
		addi.w	#$10,objX(a1)
		move.w	objY(a0),objY(a1)
		move.w	#$100,objVelX(a1)

locret_76D2:
		rts
; ---------------------------------------------------------------------------

loc_76D4:
		subq.w	#1,$30(a0)
		bmi.s	loc_7728
		bsr.w	SpeedToPos
		bchg	#0,$32(a0)
		bne.s	loc_770E
		move.w	objX(a0),d3
		addi.w	#$10,d3
		btst	#0,objStatus(a0)
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
		add.w	d1,objY(a0)
		move.b	d3,objAngle(a0)
		bsr.w	sub_7742
		addq.b	#3,d0
		move.b	d0,objAnim(a0)
		rts
; ---------------------------------------------------------------------------

loc_7728:
		subq.b	#2,obj2ndRout(a0)
		move.w	#$3B,$30(a0)

loc_7732:
		move.w	#0,objVelX(a0)
		bsr.w	sub_7742
		move.b	d0,objAnim(a0)
		rts
; ---------------------------------------------------------------------------

sub_7742:
		moveq	#0,d0
		move.b	objAngle(a0),d3
		bmi.s	loc_775E
		cmpi.b	#6,d3
		bcs.s	locret_775C
		moveq	#1,d0
		btst	#0,objStatus(a0)
		bne.s	locret_775C
		moveq	#2,d0

locret_775C:
		rts
; ---------------------------------------------------------------------------

loc_775E:
		cmpi.b	#$FA,d3
		bhi.s	locret_7770
		moveq	#2,d0
		btst	#0,objStatus(a0)
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
		addq.b	#2,objRoutine(a0)
		move.l	#Map_Crab,objMap(a0)
		move.w	#$400,objGfx(a0)
		move.b	#4,objRender(a0)
		move.b	#3,objPriority(a0)
		move.b	#$87,objColType(a0)
		move.b	#8,objActWid(a0)
		move.w	#$FC00,objVelY(a0)
		move.b	#7,objAnim(a0)

loc_77AE:
		lea	(Ani_Crab).l,a1
		bsr.w	AnimateSprite
		bsr.w	ObjectFall
		bsr.w	DisplaySprite
		move.w	(v_limitbtm2).w,d0
		addi.w	#$E0,d0
		cmp.w	objY(a0),d0
		bcs.s	loc_77D0
		rts
; ---------------------------------------------------------------------------

loc_77D0:
		bra.w	DeleteObject