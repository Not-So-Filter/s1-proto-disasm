UltraDebugMappings:
		lea	(word_2F48).l,a0
		lea	(v_objspace+$280).w,a1
		move.w	#$33,d1

.loop:
		move.b	#5,(a1)
		move.w	(a0)+,8(a1)
		move.w	(a0)+,$A(a1)
		lea	$40(a1),a1
		dbf	d1,.loop
		rts
; ---------------------------------------------------------------------------

word_2F48:	dc.w $158, $90
		dc.w $160, $90
		dc.w $168, $90
		dc.w $170, $90
		dc.w $180, $90
		dc.w $188, $90
		dc.w $190, $90
		dc.w $198, $90
		dc.w $158, $A0
		dc.w $160, $A0
		dc.w $168, $A0
		dc.w $170, $A0
		dc.w $180, $A0
		dc.w $188, $A0
		dc.w $190, $A0
		dc.w $198, $A0
		dc.w $158, $A8
		dc.w $160, $A8
		dc.w $168, $A8
		dc.w $170, $A8
		dc.w $180, $A8
		dc.w $188, $A8
		dc.w $190, $A8
		dc.w $198, $A8
		dc.w $158, $B0
		dc.w $160, $B0
		dc.w $168, $B0
		dc.w $170, $B0
		dc.w $180, $B0
		dc.w $188, $B0
		dc.w $190, $B0
		dc.w $198, $B0
		dc.w $158, $B8
		dc.w $160, $B8
		dc.w $168, $B8
		dc.w $170, $B8
		dc.w $180, $B8
		dc.w $188, $B8
		dc.w $190, $B8
		dc.w $198, $B8
		dc.w $100, $98
		dc.w $108, $98
		dc.w $110, $98
		dc.w $118, $98
		dc.w $128, $98
		dc.w $130, $98
		dc.w $138, $98
		dc.w $140, $98
		dc.w $128, $A8
		dc.w $130, $A8
		dc.w $138, $A8
		dc.w $140, $A8
