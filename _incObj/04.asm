; ---------------------------------------------------------------------------

Obj04:
		moveq	#0,d0
		move.b	obj.Routine(a0),d0
		move.w	off_4CCC(pc,d0.w),d1
		jmp	off_4CCC(pc,d1.w)
; ---------------------------------------------------------------------------

off_4CCC:	dc.w Obj04_Main-off_4CCC
		dc.w Obj04_Display-off_4CCC
		dc.w Obj04_Delete-off_4CCC
		dc.w Obj04_Delete-off_4CCC
; ---------------------------------------------------------------------------

Obj04_Main:
		addq.b	#2,obj.Routine(a0)
		move.w	#$40,obj.Ypos(a0)
		move.l	#Map_02,obj.Map(a0)
		move.w	#$2680,obj.Gfx(a0)
		move.b	#4,obj.Render(a0)
		move.b	#1,obj.ColProp(a0)
		move.b	#2,obj.Frame(a0)
		move.b	#3,obj.Priority(a0)

Obj04_Display:
		bsr.w	DisplaySprite
		subq.b	#1,obj.TimeFrame(a0)
		bpl.s	locret_4D26
		move.b	#$14,obj.TimeFrame(a0)
		move.b	obj.Frame(a0),d0
		addq.b	#1,d0
		cmpi.b	#4,d0
		bcs.s	loc_4D22
		moveq	#2,d0

loc_4D22:
		move.b	d0,obj.Frame(a0)

locret_4D26:
		rts
; ---------------------------------------------------------------------------

Obj04_Delete:
		bsr.w	DeleteObject
		rts
