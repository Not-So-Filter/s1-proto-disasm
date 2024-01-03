; ---------------------------------------------------------------------------

ObjSpikedBalls:
		moveq	#0,d0
		move.b	obj.Routine(a0),d0
		move.w	ObjSpikedBalls_Index(pc,d0.w),d1
		jmp	ObjSpikedBalls_Index(pc,d1.w)
; ---------------------------------------------------------------------------

ObjSpikedBalls_Index:dc.w ObjSpikedBalls_Init-ObjSpikedBalls_Index, ObjSpikedBalls_Move-ObjSpikedBalls_Index, ObjSpikedBalls_Display-ObjSpikedBalls_Index
; ---------------------------------------------------------------------------

ObjSpikedBalls_Init:
		addq.b	#2,obj.Routine(a0)
		move.l	#MapSpikedBalls,obj.Map(a0)
		move.w	#$3BA,obj.Gfx(a0)
		move.b	#4,obj.Render(a0)
		move.b	#4,obj.Priority(a0)
		move.b	#8,obj.ActWid(a0)
		move.w	obj.Xpos(a0),$3A(a0)
		move.w	obj.Ypos(a0),$38(a0)
		move.b	#$98,obj.ColType(a0)
		move.b	obj.Subtype(a0),d1
		andi.b	#$F0,d1
		ext.w	d1
		asl.w	#3,d1
		move.w	d1,$3E(a0)
		move.b	obj.Status(a0),d0
		ror.b	#2,d0
		andi.b	#$C0,d0
		move.b	d0,obj.Angle(a0)
		lea	$29(a0),a2
		move.b	obj.Subtype(a0),d1
		andi.w	#7,d1
		move.b	#0,(a2)+
		move.w	d1,d3
		lsl.w	#4,d3
		move.b	d3,$3C(a0)
		subq.w	#1,d1
		bcs.s	loc_DD5E
		btst	#3,obj.Subtype(a0)
		beq.s	ObjSpikedBalls_MakeChain
		subq.w	#1,d1
		bcs.s	loc_DD5E

ObjSpikedBalls_MakeChain:
		bsr.w	FindFreeObj
		bne.s	loc_DD5E
		addq.b	#1,$29(a0)
		move.w	a1,d5
		subi.w	#v_objspace,d5
		lsr.w	#6,d5
		andi.w	#$7F,d5
		move.b	d5,(a2)+
		move.b	#4,obj.Routine(a1)
		_move.b	obj.Id(a0),obj.Id(a1)
		move.l	obj.Map(a0),obj.Map(a1)
		move.w	obj.Gfx(a0),obj.Gfx(a1)
		move.b	obj.Render(a0),obj.Render(a1)
		move.b	obj.Priority(a0),obj.Priority(a1)
		move.b	obj.ActWid(a0),obj.ActWid(a1)
		move.b	obj.ColType(a0),obj.ColType(a1)
		subi.b	#$10,d3
		move.b	d3,$3C(a1)
		dbf	d1,ObjSpikedBalls_MakeChain

loc_DD5E:
		move.w	a0,d5
		subi.w	#v_objspace,d5
		lsr.w	#6,d5
		andi.w	#$7F,d5
		move.b	d5,(a2)+

ObjSpikedBalls_Move:
		bsr.w	ObjSpikedBalls_MoveStub
		bra.w	ObjSpikedBalls_ChkDelete
; ---------------------------------------------------------------------------

ObjSpikedBalls_MoveStub:
		move.w	$3E(a0),d0
		add.w	d0,obj.Angle(a0)
		move.b	obj.Angle(a0),d0
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
		move.w	d4,obj.Ypos(a1)
		move.w	d5,obj.Xpos(a1)
		dbf	d6,ObjSpikedBalls_MoveLoop
		rts
; ---------------------------------------------------------------------------

ObjSpikedBalls_ChkDelete:
		out_of_range.w	ObjSpikedBalls_Delete,$3A(a0)
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
