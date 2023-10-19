; ---------------------------------------------------------------------------

ObjMotobug:
		moveq	#0,d0
		move.b	objRoutine(a0),d0
		move.w	off_B890(pc,d0.w),d1
		jmp	off_B890(pc,d1.w)
; ---------------------------------------------------------------------------

off_B890:	dc.w loc_B898-off_B890, loc_B8FA-off_B890, loc_B9D8-off_B890, loc_B9E6-off_B890
; ---------------------------------------------------------------------------

loc_B898:
		move.l	#Map_Moto,objMap(a0)
		move.w	#$4F0,objGfx(a0)
		move.b	#4,objRender(a0)
		move.b	#4,objPriority(a0)
		move.b	#$14,objActWid(a0)
		tst.b	objAnim(a0)
		bne.s	loc_B8F2
		move.b	#$E,objHeight(a0)
		move.b	#8,objWidth(a0)
		move.b	#$C,objColType(a0)
		bsr.w	ObjectFall
		bsr.w	ObjectHitFloor
		tst.w	d1
		bpl.s	locret_B8F0
		add.w	d1,objY(a0)
		move.w	#0,objVelY(a0)
		addq.b	#2,objRoutine(a0)
		bchg	#0,objStatus(a0)

locret_B8F0:
		rts
; ---------------------------------------------------------------------------

loc_B8F2:
		addq.b	#4,objRoutine(a0)
		bra.w	loc_B9D8
; ---------------------------------------------------------------------------

loc_B8FA:
		moveq	#0,d0
		move.b	obj2ndRout(a0),d0
		move.w	off_B94E(pc,d0.w),d1
		jsr	off_B94E(pc,d1.w)
		lea	(Ani_Moto).l,a1
		bsr.w	AnimateSprite

		include "_incObj\sub RememberState.asm"
; ---------------------------------------------------------------------------

off_B94E:	dc.w loc_B952-off_B94E, loc_B976-off_B94E
; ---------------------------------------------------------------------------

loc_B952:
		subq.w	#1,$30(a0)
		bpl.s	locret_B974
		addq.b	#2,obj2ndRout(a0)
		move.w	#$FF00,objVelX(a0)
		move.b	#1,objAnim(a0)
		bchg	#0,objStatus(a0)
		bne.s	locret_B974
		neg.w	objVelX(a0)

locret_B974:
		rts
; ---------------------------------------------------------------------------

loc_B976:
		bsr.w	SpeedToPos
		bsr.w	ObjectHitFloor
		cmpi.w	#$FFF8,d1
		blt.s	loc_B9C0
		cmpi.w	#$C,d1
		bge.s	loc_B9C0
		add.w	d1,objY(a0)
		subq.b	#1,$33(a0)
		bpl.s	locret_B9BE
		move.b	#$F,$33(a0)
		bsr.w	FindFreeObj
		bne.s	locret_B9BE
		move.b	#id_MotoBug,objId(a1)
		move.w	objX(a0),objX(a1)
		move.w	objY(a0),objY(a1)
		move.b	objStatus(a0),objStatus(a1)
		move.b	#2,objAnim(a1)

locret_B9BE:
		rts
; ---------------------------------------------------------------------------

loc_B9C0:
		subq.b	#2,obj2ndRout(a0)
		move.w	#$3B,$30(a0)
		move.w	#0,objVelX(a0)
		move.b	#0,objAnim(a0)
		rts
; ---------------------------------------------------------------------------

loc_B9D8:
		lea	(Ani_Moto).l,a1
		bsr.w	AnimateSprite
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

loc_B9E6:
		bra.w	DeleteObject
