; ---------------------------------------------------------------------------

Obj04:
		moveq	#0,d0
		move.b	objRoutine(a0),d0
		move.w	off_4CCC(pc,d0.w),d1
		jmp	off_4CCC(pc,d1.w)
; ---------------------------------------------------------------------------

off_4CCC:	dc.w Obj04_Main-off_4CCC
		dc.w Obj04_Display-off_4CCC
		dc.w Obj04_Delete-off_4CCC
		dc.w Obj04_Delete-off_4CCC
; ---------------------------------------------------------------------------

Obj04_Main:
		addq.b	#2,objRoutine(a0)
		move.w	#$40,objY(a0)
		move.l	#Map_02,objMap(a0)
		move.w	#$2680,objGfx(a0)
		move.b	#4,objRender(a0)
		move.b	#1,objColProp(a0)
		move.b	#2,objFrame(a0)
		move.b	#3,objPriority(a0)

Obj04_Display:
		bsr.w	DisplaySprite
		subq.b	#1,objTimeFrame(a0)
		bpl.s	locret_4D26
		move.b	#$14,objTimeFrame(a0)
		move.b	objFrame(a0),d0
		addq.b	#1,d0
		cmpi.b	#4,d0
		bcs.s	loc_4D22
		moveq	#2,d0

loc_4D22:
		move.b	d0,objFrame(a0)

locret_4D26:
		rts
; ---------------------------------------------------------------------------

Obj04_Delete:
		bsr.w	DeleteObject
		rts
