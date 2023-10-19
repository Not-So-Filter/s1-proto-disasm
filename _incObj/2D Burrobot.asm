; ---------------------------------------------------------------------------

ObjBurrobot:
		moveq	#0,d0
		move.b	objRoutine(a0),d0
		move.w	off_8CFC(pc,d0.w),d1
		jmp	off_8CFC(pc,d1.w)
; ---------------------------------------------------------------------------

off_8CFC:	dc.w loc_8D02-off_8CFC, loc_8D56-off_8CFC, loc_8E46-off_8CFC
; ---------------------------------------------------------------------------

loc_8D02:
		move.b	#$13,objHeight(a0)
		move.b	#8,objWidth(a0)
		move.l	#Map_Burro,objMap(a0)
		move.w	#$239C,objGfx(a0)
		move.b	#4,objRender(a0)
		move.b	#4,objPriority(a0)
		move.b	#5,objColType(a0)
		move.b	#$C,objActWid(a0)
		bset	#0,objStatus(a0)
		bsr.w	ObjectFall
		bsr.w	ObjectHitFloor
		tst.w	d1
		bpl.s	locret_8D54
		add.w	d1,objY(a0)
		move.w	#0,objVelY(a0)
		addq.b	#2,objRoutine(a0)

locret_8D54:
		rts
; ---------------------------------------------------------------------------

loc_8D56:
		moveq	#0,d0
		move.b	obj2ndRout(a0),d0
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
		addq.b	#2,obj2ndRout(a0)
		move.w	#$FF,$30(a0)
		move.w	#$80,objVelX(a0)
		move.b	#1,objAnim(a0)
		bchg	#0,objStatus(a0)
		beq.s	locret_8DA0
		neg.w	objVelX(a0)

locret_8DA0:
		rts
; ---------------------------------------------------------------------------

loc_8DA2:
		subq.w	#1,$30(a0)
		bmi.s	loc_8DDE
		bsr.w	SpeedToPos
		bchg	#0,$32(a0)
		bne.s	loc_8DD4
		move.w	objX(a0),d3
		addi.w	#$C,d3
		btst	#0,objStatus(a0)
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
		add.w	d1,objY(a0)
		rts
; ---------------------------------------------------------------------------

loc_8DDE:
		btst	#2,(v_vbla_byte).w
		beq.s	loc_8DFE
		subq.b	#2,obj2ndRout(a0)
		move.w	#$3B,$30(a0)
		move.w	#0,objVelX(a0)
		move.b	#0,objAnim(a0)
		rts
; ---------------------------------------------------------------------------

loc_8DFE:
		addq.b	#2,obj2ndRout(a0)
		move.w	#$FC00,objVelY(a0)
		move.b	#2,objAnim(a0)
		rts
; ---------------------------------------------------------------------------

loc_8E10:
		bsr.w	SpeedToPos
		addi.w	#$18,objVelY(a0)
		bmi.s	locret_8E44
		move.b	#3,objAnim(a0)
		bsr.w	ObjectHitFloor
		tst.w	d1
		bpl.s	locret_8E44
		add.w	d1,objY(a0)
		move.w	#0,objVelY(a0)
		move.b	#1,objAnim(a0)
		move.w	#$FF,$30(a0)
		subq.b	#2,obj2ndRout(a0)

locret_8E44:
		rts
; ---------------------------------------------------------------------------

loc_8E46:
		bsr.w	DeleteObject
		rts
