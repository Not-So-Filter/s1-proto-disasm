; ---------------------------------------------------------------------------

ObjectFragment:
		moveq	#0,d0
		move.b	objFrame(a0),d0
		add.w	d0,d0
		movea.l	objMap(a0),a3
		adda.w	(a3,d0.w),a3
		addq.w	#1,a3
		bset	#5,objRender(a0)
		move.b	objId(a0),d4
		move.b	objRender(a0),d5
		movea.l	a0,a1
		bra.s	loc_AED6
; ---------------------------------------------------------------------------

loc_AECE:
		bsr.w	FindFreeObj
		bne.s	loc_AF28
		addq.w	#5,a3

loc_AED6:
		move.b	#4,objRoutine(a1)
		move.b	d4,objId(a1)
		move.l	a3,objMap(a1)
		move.b	d5,objRender(a1)
		move.w	objX(a0),objX(a1)
		move.w	objY(a0),objY(a1)
		move.w	objGfx(a0),objGfx(a1)
		move.b	objPriority(a0),objPriority(a1)
		move.b	objActWid(a0),objActWid(a1)
		move.w	(a4)+,objVelX(a1)
		move.w	(a4)+,objVelY(a1)
		cmpa.l	a0,a1
		bcc.s	loc_AF24
		move.l	a0,-(sp)
		movea.l	a1,a0
		bsr.w	SpeedToPos
		add.w	d2,objVelY(a0)
		movea.l	(sp)+,a0
		bsr.w	DisplaySprite1

loc_AF24:
		dbf	d1,loc_AECE

loc_AF28:
		move.w	#sfx_WallSmash,d0
		jmp	(PlaySound_Special).l
