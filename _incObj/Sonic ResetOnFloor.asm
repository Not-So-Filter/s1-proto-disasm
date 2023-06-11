; ---------------------------------------------------------------------------

Sonic_ResetOnFloor:
		btst	#4,obStatus(a0)
		beq.s	loc_F226
		nop
		nop
		nop

loc_F226:
		bclr	#5,obStatus(a0)
		bclr	#1,obStatus(a0)
		bclr	#4,obStatus(a0)
		btst	#2,obStatus(a0)
		beq.s	loc_F25C
		bclr	#2,obStatus(a0)
		move.b	#$13,obHeight(a0)
		move.b	#9,obWidth(a0)
		move.b	#0,obAnim(a0)
		subq.w	#5,obY(a0)

loc_F25C:
		move.w	#0,$3E(a0)
		move.b	#0,$3C(a0)
		rts