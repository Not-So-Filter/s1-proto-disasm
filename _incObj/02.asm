; ---------------------------------------------------------------------------

Obj02:
		moveq	#0,d0
		move.b	act(a0),d0
		move.w	off_4B90(pc,d0.w),d1
		jmp	off_4B90(pc,d1.w)
; ---------------------------------------------------------------------------

off_4B90:	dc.w loc_4B98-off_4B90, loc_4BC8-off_4B90
		dc.w loc_4BEC-off_4B90, loc_4BEC-off_4B90
; ---------------------------------------------------------------------------

loc_4B98:
		addq.b	#2,act(a0)
		move.w	#$200,xpos(a0)
		move.w	#$60,ypos(a0)
		move.l	#Map02,map(a0)
		move.w	#$64F0,tile(a0)
		move.b	#4,render(a0)
		move.b	#1,colprop(a0)
		move.b	#3,prio(a0)

loc_4BC8:
		bsr.w	DisplaySprite
		subq.b	#1,anidelay(a0)
		bpl.s	locret_4BEA
		move.b	#$10,anidelay(a0)
		move.b	frame(a0),d0
		addq.b	#1,d0
		cmpi.b	#2,d0
		bcs.s	loc_4BE6
		moveq	#0,d0

loc_4BE6:
		move.b	d0,frame(a0)

locret_4BEA:
		rts
; ---------------------------------------------------------------------------

loc_4BEC:
		bsr.w	DeleteObject
		rts