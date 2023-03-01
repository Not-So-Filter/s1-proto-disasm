; ---------------------------------------------------------------------------

Obj06:
		moveq	#0,d0
		move.b	act(a0),d0
		move.w	off_4DFC(pc,d0.w),d1
		jmp	off_4DFC(pc,d1.w)
; ---------------------------------------------------------------------------

off_4DFC:	dc.w loc_4E04-off_4DFC, loc_4E28-off_4DFC, loc_4E2E-off_4DFC, loc_4E2E-off_4DFC
; ---------------------------------------------------------------------------

loc_4E04:
		addq.b	#2,act(a0)
		move.w	#$A0,xpix(a0)
		move.l	#Map05,map(a0)
		move.w	#$8470,tile(a0)
		move.b	#0,render(a0)
		move.b	#7,prio(a0)

loc_4E28:
		bsr.w	DisplaySprite
		rts
; ---------------------------------------------------------------------------

loc_4E2E:
		bsr.w	DeleteObject
		rts