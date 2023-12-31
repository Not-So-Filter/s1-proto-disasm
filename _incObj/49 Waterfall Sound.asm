; ---------------------------------------------------------------------------

ObjWaterfallSnd:
		moveq	#0,d0
		move.b	obj.Routine(a0),d0
		move.w	.act(pc,d0.w),d1
		jmp	.act(pc,d1.w)
; ---------------------------------------------------------------------------
.act:		dc.w ObjWaterfallSnd_Init-.act, ObjWaterfallSnd_Act-.act
; ---------------------------------------------------------------------------

ObjWaterfallSnd_Init:
		addq.b	#2,obj.Routine(a0)
		move.b	#4,obj.Render(a0)

ObjWaterfallSnd_Act:
		move.b	(v_vbla_byte).w,d0
		andi.b	#$3F,d0
		bne.s	.nosound
		move.w	#sfx_Waterfall,d0
		jsr	(PlaySound_Special).l

.nosound:
		out_of_range.w	DeleteObject
		rts
