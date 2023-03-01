; ---------------------------------------------------------------------------

Obj05:
		moveq	#0,d0
		move.b	act(a0),d0
		move.w	off_4D3C(pc,d0.w),d1
		jmp	off_4D3C(pc,d1.w)
; ---------------------------------------------------------------------------

off_4D3C:	dc.w loc_4D44-off_4D3C, loc_4D62-off_4D3C, loc_4D68-off_4D3C, loc_4D68-off_4D3C
; ---------------------------------------------------------------------------

loc_4D44:
		addq.b	#2,act(a0)
		move.l	#Map05,map(a0)
		move.w	#$84F0,tile(a0)
		move.b	#0,render(a0)
		move.b	#7,prio(a0)

loc_4D62:
		bsr.w	DisplaySprite
		rts
; ---------------------------------------------------------------------------

loc_4D68:
		bsr.w	DeleteObject
		rts