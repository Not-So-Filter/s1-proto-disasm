; ---------------------------------------------------------------------------

Sonic_JumpAngle:
		move.b	obAngle(a0),d0
		beq.s	locret_F04C
		bpl.s	loc_F042
		addq.b	#2,d0
		bcc.s	loc_F040
		moveq	#0,d0

loc_F040:
		bra.s	loc_F048
; ---------------------------------------------------------------------------

loc_F042:
		subq.b	#2,d0
		bcc.s	loc_F048
		moveq	#0,d0

loc_F048:
		move.b	d0,obAngle(a0)

locret_F04C:
		rts