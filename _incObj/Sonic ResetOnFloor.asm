; ---------------------------------------------------------------------------

Sonic_ResetOnFloor:
		btst	#4,objStatus(a0)
		beq.s	loc_F226
		nop
		nop
		nop

loc_F226:
		bclr	#5,objStatus(a0)
		bclr	#1,objStatus(a0)
		bclr	#4,objStatus(a0)
		btst	#2,objStatus(a0)
		beq.s	loc_F25C
		bclr	#2,objStatus(a0)
		move.b	#$13,objHeight(a0)
		move.b	#9,objWidth(a0)
		move.b	#id_Walk,objAnim(a0)
		subq.w	#5,objY(a0)

loc_F25C:
		move.w	#0,$3E(a0)
		move.b	#0,$3C(a0)
		rts