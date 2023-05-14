; ---------------------------------------------------------------------------

Sonic_JumpHeight:
		tst.b	$3C(a0)
		beq.s	loc_EF78
		cmpi.w	#$FC00,$12(a0)
		bge.s	locret_EF76
		move.b	(v_jpadhold2).w,d0
		andi.b	#$70,d0
		bne.s	locret_EF76
		move.w	#$FC00,$12(a0)

locret_EF76:
		rts
; ---------------------------------------------------------------------------

loc_EF78:
		cmpi.w	#$F040,$12(a0)
		bge.s	locret_EF86
		move.w	#$F040,$12(a0)

locret_EF86:
		rts