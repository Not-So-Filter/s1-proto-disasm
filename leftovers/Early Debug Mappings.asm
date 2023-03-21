EarlyDebugMappings:
		lea	(word_2EF4).l,a0
		lea	(v_objspace+$400).w,a1
		move.w	#$B,d1

.loop:
		move.b	#5,(a1)
		move.w	(a0)+,8(a1)
		move.w	(a0)+,$A(a1)
		lea	$40(a1),a1
		dbf	d1,.loop
		rts
; ---------------------------------------------------------------------------

word_2EF4:	dc.w $158, $148
		dc.w $160, $148
		dc.w $168, $148
		dc.w $170, $148
		dc.w $180, $148
		dc.w $188, $148
		dc.w $190, $148
		dc.w $198, $148
		dc.w $158, $98
		dc.w $160, $98
		dc.w $168, $98
		dc.w $170, $98
