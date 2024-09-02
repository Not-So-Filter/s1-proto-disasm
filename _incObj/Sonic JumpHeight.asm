; ---------------------------------------------------------------------------

Sonic_JumpHeight:
		tst.b	jumpflag(a0)
		beq.s	loc_EF78
		cmpi.w	#-$400,obVelY(a0)
		bge.s	locret_EF76
		move.b	(v_jpadhold2).w,d0
		andi.b	#btnABC,d0
		bne.s	locret_EF76
		move.w	#-$400,obVelY(a0)

locret_EF76:
		rts
; ---------------------------------------------------------------------------

loc_EF78:
		cmpi.w	#$F040,obVelY(a0)
		bge.s	locret_EF86
		move.w	#$F040,obVelY(a0)

locret_EF86:
		rts
