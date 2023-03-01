; ---------------------------------------------------------------------------

Obj03:
		moveq	#0,d0
		move.b	act(a0),d0
		move.w	off_4C68(pc,d0.w),d1
		jmp	off_4C68(pc,d1.w)
; ---------------------------------------------------------------------------

off_4C68:	dc.w loc_4C70-off_4C68, loc_4CA6-off_4C68, loc_4CB8-off_4C68, loc_4CB8-off_4C68
; ---------------------------------------------------------------------------

loc_4C70:
		addq.b	#2,act(a0)
		move.w	#$100,xpos(a0)
		move.w	#$40,ypos(a0)
		move.l	#Map02,map(a0)
		move.w	#$64F0,tile(a0)
		move.b	#4,render(a0)
		move.b	#1,colprop(a0)
		move.b	#3,frame(a0)
		move.b	#5,prio(a0)

loc_4CA6:
		bsr.w	DisplaySprite
		subq.b	#1,anidelay(a0)
		bpl.s	locret_4CB6
		move.b	#$10,anidelay(a0)

locret_4CB6:
		rts
; ---------------------------------------------------------------------------

loc_4CB8:
		bsr.w	DeleteObject
		rts