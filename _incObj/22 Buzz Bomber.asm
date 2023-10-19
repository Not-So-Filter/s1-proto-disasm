; ---------------------------------------------------------------------------

ObjBuzzbomber:
		moveq	#0,d0
		move.b	objRoutine(a0),d0
		move.w	off_78A6(pc,d0.w),d1
		jmp	off_78A6(pc,d1.w)
; ---------------------------------------------------------------------------
off_78A6:	dc.w loc_78AC-off_78A6, loc_78D6-off_78A6, loc_79E6-off_78A6
; ---------------------------------------------------------------------------

loc_78AC:
		addq.b	#2,objRoutine(a0)
		move.l	#Map_Buzz,objMap(a0)
		move.w	#$444,objGfx(a0)
		move.b	#4,objRender(a0)
		move.b	#3,objPriority(a0)
		move.b	#8,objColType(a0)
		move.b	#$18,objActWid(a0)

loc_78D6:
		moveq	#0,d0
		move.b	obj2ndRout(a0),d0
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
		addq.b	#2,obj2ndRout(a0)
		move.w	#$7F,$32(a0)
		move.w	#$400,objVelX(a0)
		move.b	#1,objAnim(a0)
		btst	#0,objStatus(a0)
		bne.s	locret_7926
		neg.w	objVelX(a0)

locret_7926:
		rts
; ---------------------------------------------------------------------------

loc_7928:
		bsr.w	FindFreeObj
		bne.s	locret_798A
		move.b	#id_Missile,objId(a1)
		move.w	objX(a0),objX(a1)
		move.w	objY(a0),objY(a1)
		addi.w	#$1C,objY(a1)
		move.w	#$200,objVelY(a1)
		move.w	#$200,objVelX(a1)
		move.w	#$18,d0
		btst	#0,objStatus(a0)
		bne.s	loc_7964
		neg.w	d0
		neg.w	objVelX(a1)

loc_7964:
		add.w	d0,objX(a1)
		move.b	objStatus(a0),objStatus(a1)
		move.w	#$E,$32(a1)
		move.l	a0,$3C(a1)
		move.b	#1,$34(a0)
		move.w	#$3B,$32(a0)
		move.b	#2,objAnim(a0)

locret_798A:
		rts
; ---------------------------------------------------------------------------

loc_798C:
		subq.w	#1,$32(a0)
		bmi.s	loc_79C2
		bsr.w	SpeedToPos
		tst.b	$34(a0)
		bne.s	locret_79E4
		move.w	(v_objspace+objX).w,d0
		sub.w	objX(a0),d0
		bpl.s	loc_79A8
		neg.w	d0

loc_79A8:
		cmpi.w	#$60,d0
		bcc.s	locret_79E4
		tst.b	objRender(a0)
		bpl.s	locret_79E4
		move.b	#2,$34(a0)
		move.w	#$1D,$32(a0)
		bra.s	loc_79D4
; ---------------------------------------------------------------------------

loc_79C2:
		move.b	#0,$34(a0)
		bchg	#0,objStatus(a0)
		move.w	#$3B,$32(a0)

loc_79D4:
		subq.b	#2,obj2ndRout(a0)
		move.w	#0,objVelX(a0)
		move.b	#0,objAnim(a0)

locret_79E4:
		rts
; ---------------------------------------------------------------------------

loc_79E6:
		bsr.w	DeleteObject
		rts