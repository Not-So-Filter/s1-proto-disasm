; ---------------------------------------------------------------------------

Obj04:
		moveq	#0,d0
		move.b	act(a0),d0
		move.w	off_4CCC(pc,d0.w),d1
		jmp	off_4CCC(pc,d1.w)
; ---------------------------------------------------------------------------

off_4CCC:	dc.w Obj04_Main-off_4CCC
		dc.w Obj04_Display-off_4CCC
		dc.w Obj04_Delete-off_4CCC
		dc.w Obj04_Delete-off_4CCC
; ---------------------------------------------------------------------------

Obj04_Main:
		addq.b	#2,act(a0)
		move.w	#$40,ypos(a0)
		move.l	#Map02,map(a0)
		move.w	#$2680,tile(a0)
		move.b	#4,render(a0)
		move.b	#1,colprop(a0)
		move.b	#tile,frame(a0)
		move.b	#3,prio(a0)

Obj04_Display:
		bsr.w	DisplaySprite
		subq.b	#1,anidelay(a0)
		bpl.s	locret_4D26
		move.b	#$14,anidelay(a0)
		move.b	frame(a0),d0
		addq.b	#1,d0
		cmpi.b	#4,d0
		bcs.s	loc_4D22
		moveq	#2,d0

loc_4D22:
		move.b	d0,frame(a0)

locret_4D26:
		rts
; ---------------------------------------------------------------------------

Obj04_Delete:
		bsr.w	DeleteObject
		rts
