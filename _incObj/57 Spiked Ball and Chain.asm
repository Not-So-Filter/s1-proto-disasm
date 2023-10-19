; ---------------------------------------------------------------------------

ObjSpikedBalls:
		moveq	#0,d0
		move.b	objRoutine(a0),d0
		move.w	ObjSpikedBalls_Index(pc,d0.w),d1
		jmp	ObjSpikedBalls_Index(pc,d1.w)
; ---------------------------------------------------------------------------

ObjSpikedBalls_Index:dc.w ObjSpikedBalls_Init-ObjSpikedBalls_Index, ObjSpikedBalls_Move-ObjSpikedBalls_Index, ObjSpikedBalls_Display-ObjSpikedBalls_Index
; ---------------------------------------------------------------------------

ObjSpikedBalls_Init:
		addq.b	#2,objRoutine(a0)
		move.l	#MapSpikedBalls,objMap(a0)
		move.w	#$3BA,objGfx(a0)
		move.b	#4,objRender(a0)
		move.b	#4,objPriority(a0)
		move.b	#8,objActWid(a0)
		move.w	objX(a0),$3A(a0)
		move.w	objY(a0),$38(a0)
		move.b	#$98,objColType(a0)
		move.b	objSubtype(a0),d1
		andi.b	#$F0,d1
		ext.w	d1
		asl.w	#3,d1
		move.w	d1,$3E(a0)
		move.b	objStatus(a0),d0
		ror.b	#2,d0
		andi.b	#$C0,d0
		move.b	d0,objAngle(a0)
		lea	$29(a0),a2
		move.b	objSubtype(a0),d1
		andi.w	#7,d1
		move.b	#0,(a2)+
		move.w	d1,d3
		lsl.w	#4,d3
		move.b	d3,$3C(a0)
		subq.w	#1,d1
		bcs.s	loc_DD5E
		btst	#3,objSubtype(a0)
		beq.s	ObjSpikedBalls_MakeChain
		subq.w	#1,d1
		bcs.s	loc_DD5E

ObjSpikedBalls_MakeChain:
		bsr.w	FindFreeObj
		bne.s	loc_DD5E
		addq.b	#1,$29(a0)
		move.w	a1,d5
		subi.w	#$D000,d5
		lsr.w	#6,d5
		andi.w	#$7F,d5
		move.b	d5,(a2)+
		move.b	#4,objRoutine(a1)
		move.b	objId(a0),objId(a1)
		move.l	objMap(a0),objMap(a1)
		move.w	objGfx(a0),objGfx(a1)
		move.b	objRender(a0),objRender(a1)
		move.b	objPriority(a0),objPriority(a1)
		move.b	objActWid(a0),objActWid(a1)
		move.b	objColType(a0),objColType(a1)
		subi.b	#$10,d3
		move.b	d3,$3C(a1)
		dbf	d1,ObjSpikedBalls_MakeChain

loc_DD5E:
		move.w	a0,d5
		subi.w	#$D000,d5
		lsr.w	#6,d5
		andi.w	#$7F,d5
		move.b	d5,(a2)+

ObjSpikedBalls_Move:
		bsr.w	ObjSpikedBalls_MoveStub
		bra.w	ObjSpikedBalls_ChkDelete
; ---------------------------------------------------------------------------

ObjSpikedBalls_MoveStub:
		move.w	$3E(a0),d0
		add.w	d0,objAngle(a0)
		move.b	objAngle(a0),d0
		jsr	(CalcSine).l
		move.w	$38(a0),d2
		move.w	$3A(a0),d3
		lea	$29(a0),a2
		moveq	#0,d6
		move.b	(a2)+,d6

ObjSpikedBalls_MoveLoop:
		moveq	#0,d4
		move.b	(a2)+,d4
		lsl.w	#6,d4
		addi.l	#v_objspace&$FFFFFF,d4
		movea.l	d4,a1
		moveq	#0,d4
		move.b	$3C(a1),d4
		move.l	d4,d5
		muls.w	d0,d4
		asr.l	#8,d4
		muls.w	d1,d5
		asr.l	#8,d5
		add.w	d2,d4
		add.w	d3,d5
		move.w	d4,objY(a1)
		move.w	d5,objX(a1)
		dbf	d6,ObjSpikedBalls_MoveLoop
		rts
; ---------------------------------------------------------------------------

ObjSpikedBalls_ChkDelete:
		move.w	$3A(a0),d0
		andi.w	#$FF80,d0
		move.w	(v_screenposx).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0
		cmpi.w	#$280,d0
		bhi.w	ObjSpikedBalls_Delete
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

ObjSpikedBalls_Delete:
		moveq	#0,d2
		lea	$29(a0),a2
		move.b	(a2)+,d2

ObjSpikedBalls_DeleteLoop:
		moveq	#0,d0
		move.b	(a2)+,d0
		lsl.w	#6,d0
		addi.l	#v_objspace&$FFFFFF,d0
		movea.l	d0,a1
		bsr.w	ObjectDeleteA1
		dbf	d2,ObjSpikedBalls_DeleteLoop
		rts
; ---------------------------------------------------------------------------

ObjSpikedBalls_Display:
		bra.w	DisplaySprite