; ---------------------------------------------------------------------------

ObjBallhog:
		moveq	#0,d0
		move.b	objRoutine(a0),d0
		move.w	off_6F3E(pc,d0.w),d1
		jmp	off_6F3E(pc,d1.w)
; ---------------------------------------------------------------------------

off_6F3E:	dc.w loc_6F46-off_6F3E, loc_6F96-off_6F3E, loc_7056-off_6F3E, loc_705C-off_6F3E
; ---------------------------------------------------------------------------

loc_6F46:
		move.b	#$13,objHeight(a0)
		move.b	#8,objWidth(a0)
		move.l	#Map_Hog,objMap(a0)
		move.w	#$2400,objGfx(a0)
		move.b	#4,objRender(a0)
		move.b	#4,objPriority(a0)
		move.b	#5,objColType(a0)
		move.b	#$C,objActWid(a0)
		bsr.w	ObjectFall
		jsr	(ObjectHitFloor).l
		tst.w	d1
		bpl.s	locret_6F94
		add.w	d1,objY(a0)
		move.w	#0,objVelY(a0)
		addq.b	#2,objRoutine(a0)

locret_6F94:
		rts
; ---------------------------------------------------------------------------

loc_6F96:
		moveq	#0,d0
		move.b	obj2ndRout(a0),d0
		move.w	off_6FB2(pc,d0.w),d1
		jsr	off_6FB2(pc,d1.w)
		lea	(Ani_Hog).l,a1
		bsr.w	AnimateSprite
		bra.w	RememberState
; ---------------------------------------------------------------------------

off_6FB2:	dc.w loc_6FB6-off_6FB2, loc_701C-off_6FB2
; ---------------------------------------------------------------------------

loc_6FB6:
		subq.w	#1,$30(a0)
		bpl.s	loc_6FE6
		addq.b	#2,obj2ndRout(a0)
		move.w	#$FF,$30(a0)
		move.w	#$40,objVelX(a0)
		move.b	#1,objAnim(a0)
		bchg	#0,objStatus(a0)
		bne.s	loc_6FDE
		neg.w	objVelX(a0)

loc_6FDE:
		move.b	#0,$32(a0)
		rts
; ---------------------------------------------------------------------------

loc_6FE6:
		tst.b	$32(a0)
		bne.s	locret_6FF4
		cmpi.b	#2,objFrame(a0)
		beq.s	loc_6FF6

locret_6FF4:
		rts
; ---------------------------------------------------------------------------

loc_6FF6:
		move.b	#1,$32(a0)
		bsr.w	FindFreeObj
		bne.s	locret_701A
		move.b	#id_Cannonball,objId(a1)
		move.w	objX(a0),objX(a1)
		move.w	objY(a0),objY(a1)
		addi.w	#$10,objY(a1)

locret_701A:
		rts
; ---------------------------------------------------------------------------

loc_701C:
		subq.w	#1,$30(a0)
		bmi.s	loc_7032
		bsr.w	SpeedToPos
		jsr	(ObjectHitFloor).l
		add.w	d1,objY(a0)
		rts
; ---------------------------------------------------------------------------

loc_7032:
		subq.b	#2,obj2ndRout(a0)
		move.w	#$3B,$30(a0)
		move.w	#0,objVelX(a0)
		move.b	#0,objAnim(a0)
		tst.b	objRender(a0)
		bpl.s	locret_7054
		move.b	#2,objAnim(a0)

locret_7054:
		rts
; ---------------------------------------------------------------------------

loc_7056:
		bsr.w	DisplaySprite
		rts
; ---------------------------------------------------------------------------

loc_705C:
		bsr.w	DeleteObject
		rts
