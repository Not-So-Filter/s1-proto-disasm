; ---------------------------------------------------------------------------

DisplaySprite:
		lea	(v_spritequeue).w,a1
		move.b	prio(a0),d0
		andi.w	#7,d0
		lsl.w	#7,d0
		adda.w	d0,a1
		cmpi.w	#$7E,(a1)
		bcc.s	locret_8768
		addq.w	#2,(a1)
		adda.w	(a1),a1
		move.w	a0,(a1)

locret_8768:
		rts
; ---------------------------------------------------------------------------

DisplaySprite1:
		lea	(v_spritequeue).w,a2
		move.b	prio(a1),d0
		andi.w	#7,d0
		lsl.w	#7,d0
		adda.w	d0,a2
		cmpi.w	#$7E,(a2)
		bcc.s	locret_8786
		addq.w	#2,(a2)
		adda.w	(a2),a2
		move.w	a1,(a2)

locret_8786:
		rts
