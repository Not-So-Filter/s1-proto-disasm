; ---------------------------------------------------------------------------

loc_50B2:
		bsr.s	ObjBridge_ChkExit
		bsr.w	DisplaySprite
		bra.w	ObjBridge_ChkDelete
; ---------------------------------------------------------------------------

ObjBridge_ChkExit:
		moveq	#0,d1
		move.b	arg(a0),d1
		lsl.w	#3,d1
		move.w	d1,d2
		addq.w	#8,d1
		bsr.s	PtfmCheckExit2
		bcc.s	locret_50E8
		lsr.w	#4,d0
		move.b	d0,$3F(a0)
		move.b	$3E(a0),d0
		cmpi.b	#$40,d0
		beq.s	loc_50E0
		addq.b	#4,$3E(a0)

loc_50E0:
		bsr.w	ObjBridge_UpdateBend
		bsr.w	ObjBridge_PlayerPos

locret_50E8:
		rts
