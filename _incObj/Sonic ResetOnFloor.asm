; ---------------------------------------------------------------------------

Sonic_ResetOnFloor:
		btst	#4,$22(a0)
		beq.s	loc_F226
		nop
		nop
		nop

loc_F226:
		bclr	#5,$22(a0)
		bclr	#1,$22(a0)
		bclr	#4,$22(a0)
		btst	#2,$22(a0)
		beq.s	loc_F25C
		bclr	#2,$22(a0)
		move.b	#$13,$16(a0)
		move.b	#9,$17(a0)
		move.b	#0,$1C(a0)
		subq.w	#5,$C(a0)

loc_F25C:
		move.w	#0,$3E(a0)
		move.b	#0,$3C(a0)
		rts