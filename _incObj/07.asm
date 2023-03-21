; ---------------------------------------------------------------------------

Obj07:
		moveq	#0,d0
		move.b	act(a0),d0
		move.w	off_4E42(pc,d0.w),d1
		jmp	off_4E42(pc,d1.w)
; ---------------------------------------------------------------------------

off_4E42:	dc.w loc_4E4A-off_4E42
		dc.w locret_4E4E-off_4E42
		dc.w Obj07_Delete-off_4E42
		dc.w Obj07_Delete-off_4E42
; ---------------------------------------------------------------------------

loc_4E4A:
		addq.b	#2,act(a0)			; The code was nulled out at some point.

locret_4E4E:
		rts
; ---------------------------------------------------------------------------

Obj07_Delete:
		bsr.w	DeleteObject
		rts
