; ---------------------------------------------------------------------------

ObjYadrin:
		moveq	#0,d0
		move.b	objRoutine(a0),d0
		move.w	off_D334(pc,d0.w),d1
		jmp	off_D334(pc,d1.w)
; ---------------------------------------------------------------------------

off_D334:	dc.w loc_D338-off_D334, loc_D38C-off_D334
; ---------------------------------------------------------------------------

loc_D338:
		move.l	#Map_Yadrin,objMap(a0)
		move.w	#$247B,objGfx(a0)
		move.b	#4,objRender(a0)
		move.b	#4,objPriority(a0)
		move.b	#$14,objActWid(a0)
		move.b	#$11,objHeight(a0)
		move.b	#8,objWidth(a0)
		move.b	#$CC,objColType(a0)
		bsr.w	ObjectFall
		bsr.w	ObjectHitFloor
		tst.w	d1
		bpl.s	locret_D38A
		add.w	d1,objY(a0)
		move.w	#0,objVelY(a0)
		addq.b	#2,objRoutine(a0)
		bchg	#0,objStatus(a0)

locret_D38A:
		rts
; ---------------------------------------------------------------------------

loc_D38C:
		moveq	#0,d0
		move.b	obj2ndRout(a0),d0
		move.w	off_D3A8(pc,d0.w),d1
		jsr	off_D3A8(pc,d1.w)
		lea	(Ani_Yadrin).l,a1
		bsr.w	AnimateSprite
		bra.w	RememberState
; ---------------------------------------------------------------------------

off_D3A8:	dc.w loc_D3AC-off_D3A8, loc_D3D0-off_D3A8
; ---------------------------------------------------------------------------

loc_D3AC:
		subq.w	#1,$30(a0)
		bpl.s	locret_D3CE
		addq.b	#2,obj2ndRout(a0)
		move.w	#$FF00,objVelX(a0)
		move.b	#1,objAnim(a0)
		bchg	#0,objStatus(a0)
		bne.s	locret_D3CE
		neg.w	objVelX(a0)

locret_D3CE:
		rts
; ---------------------------------------------------------------------------

loc_D3D0:
		bsr.w	SpeedToPos
		bsr.w	ObjectHitFloor
		cmpi.w	#$FFF8,d1
		blt.s	loc_D3F0
		cmpi.w	#$C,d1
		bge.s	loc_D3F0
		add.w	d1,objY(a0)
		bsr.w	sub_D2DA
		bne.s	loc_D3F0
		rts
; ---------------------------------------------------------------------------

loc_D3F0:
		subq.b	#2,obj2ndRout(a0)
		move.w	#$3B,$30(a0)
		move.w	#0,objVelX(a0)
		move.b	#0,objAnim(a0)
		rts