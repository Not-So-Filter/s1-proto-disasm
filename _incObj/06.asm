; ---------------------------------------------------------------------------

Obj06:
		moveq	#0,d0
		move.b	act(a0),d0
		move.w	off_4DFC(pc,d0.w),d1
		jmp	off_4DFC(pc,d1.w)
; ---------------------------------------------------------------------------

off_4DFC:	dc.w Obj06_Main-off_4DFC
		dc.w Obj06_Display-off_4DFC
		dc.w Obj06_Delete-off_4DFC
		dc.w Obj06_Delete-off_4DFC
; ---------------------------------------------------------------------------

Obj06_Main:
		addq.b	#2,act(a0)
		move.w	#$A0,xpix(a0)
		move.l	#Map05,map(a0)
		move.w	#$8470,tile(a0)
		move.b	#0,render(a0)
		move.b	#7,prio(a0)

Obj06_Display:
		bsr.w	DisplaySprite
		rts
; ---------------------------------------------------------------------------

Obj06_Delete:
		bsr.w	DeleteObject
		rts
