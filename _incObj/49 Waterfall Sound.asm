; ---------------------------------------------------------------------------

ObjWaterfallSnd:
		moveq	#0,d0
		move.b	act(a0),d0
		move.w	@act(pc,d0.w),d1
		jmp	@act(pc,d1.w)
; ---------------------------------------------------------------------------

@act:		dc.w ObjWaterfallSnd_Init-@act, ObjWaterfallSnd_Act-@act
; ---------------------------------------------------------------------------

ObjWaterfallSnd_Init:
		addq.b	#2,act(a0)
		move.b	#4,render(a0)

ObjWaterfallSnd_Act:
		move.b	(byte_FFFE0F).w,d0
		andi.b	#$3F,d0
		bne.s	@nosound
		move.w	#$D0,d0
		jsr	(PlaySFX).l

@nosound:
		move.w	8(a0),d0
		andi.w	#$FF80,d0
		move.w	(v_screenposx).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0
		cmpi.w	#640,d0
		bhi.w	DeleteObject
		rts
