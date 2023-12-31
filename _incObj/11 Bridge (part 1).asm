; ---------------------------------------------------------------------------

Bridge:
		moveq	#0,d0
		move.b	obj.Routine(a0),d0
		move.w	off_4E64(pc,d0.w),d1
		jmp	off_4E64(pc,d1.w)
; ---------------------------------------------------------------------------

off_4E64:	dc.w Bridge_Init-off_4E64, loc_4F32-off_4E64, loc_50B2-off_4E64, Bridge_Delete-off_4E64, Bridge_Delete-off_4E64
		dc.w Bridge_Display-off_4E64
; ---------------------------------------------------------------------------

Bridge_Init:
		addq.b	#2,obj.Routine(a0)
		move.l	#MapBridge,obj.Map(a0)
		move.w	#$438E,obj.Gfx(a0)
		move.b	#4,obj.Render(a0)
		move.b	#3,obj.Priority(a0)
		move.b	#$80,obj.ActWid(a0)
		move.w	obj.Ypos(a0),d2
		move.w	obj.Xpos(a0),d3
		_move.b	obj.Id(a0),d4
		lea	obj.Subtype(a0),a2
		moveq	#0,d1
		move.b	(a2),d1
		move.b	#0,(a2)+
		move.w	d1,d0
		lsr.w	#1,d0
		lsl.w	#4,d0
		sub.w	d0,d3
		subq.b	#2,d1
		bcs.s	loc_4F32

Bridge_MakeLog:
		bsr.w	FindFreeObj
		bne.s	loc_4F32
		addq.b	#1,obj.Subtype(a0)
		cmp.w	obj.Xpos(a0),d3
		bne.s	loc_4EE6
		addi.w	#$10,d3
		move.w	d2,obj.Ypos(a0)
		move.w	d2,$3C(a0)
		move.w	a0,d5
		subi.w	#v_objspace,d5
		lsr.w	#6,d5
		andi.w	#$7F,d5
		move.b	d5,(a2)+
		addq.b	#1,obj.Subtype(a0)

loc_4EE6:
		move.w	a1,d5
		subi.w	#v_objspace,d5
		lsr.w	#6,d5
		andi.w	#$7F,d5
		move.b	d5,(a2)+
		move.b	#$A,obj.Routine(a1)
		_move.b	d4,obj.Id(a1)
		move.w	d2,obj.Ypos(a1)
		move.w	d2,$3C(a1)
		move.w	d3,obj.Xpos(a1)
		move.l	#MapBridge,obj.Map(a1)
		move.w	#$438E,obj.Gfx(a1)
		move.b	#4,obj.Render(a1)
		move.b	#3,obj.Priority(a1)
		move.b	#8,obj.ActWid(a1)
		addi.w	#$10,d3
		dbf	d1,Bridge_MakeLog

loc_4F32:
		bsr.s	PtfmBridge
		tst.b	$3E(a0)
		beq.s	loc_4F42
		subq.b	#4,$3E(a0)
		bsr.w	Bridge_UpdateBend

loc_4F42:
		bsr.w	DisplaySprite
		bra.w	Bridge_ChkDelete