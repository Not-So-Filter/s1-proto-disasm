; ---------------------------------------------------------------------------

Obj05:
		moveq	#0,d0
		move.b	act(a0),d0
		move.w	off_4D3C(pc,d0.w),d1
		jmp	off_4D3C(pc,d1.w)
; ---------------------------------------------------------------------------

off_4D3C:	dc.w Obj05_Main-off_4D3C
		dc.w Obj05_Display-off_4D3C
		dc.w Obj05_Delete-off_4D3C
		dc.w Obj05_Delete-off_4D3C
; ---------------------------------------------------------------------------

Obj05_Main:
		addq.b	#2,act(a0)
		move.l	#Map05,map(a0)
		move.w	#$84F0,tile(a0)
		move.b	#0,render(a0)
		move.b	#7,prio(a0)

Obj05_Display:
		bsr.w	DisplaySprite
		rts
; ---------------------------------------------------------------------------

Obj05_Delete:
		bsr.w	DeleteObject
		rts
