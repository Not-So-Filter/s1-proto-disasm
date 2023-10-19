; ---------------------------------------------------------------------------

Sonic_SlopeRepel:
		nop
		tst.w	$3E(a0)
		bne.s	loc_F02C
		move.b	objAngle(a0),d0
		addi.b	#$20,d0
		andi.b	#$C0,d0
		beq.s	locret_F02A
		move.w	objInertia(a0),d0
		bpl.s	loc_F018
		neg.w	d0

loc_F018:
		cmpi.w	#$280,d0
		bcc.s	locret_F02A
		bset	#1,objStatus(a0)
		move.w	#$1E,$3E(a0)

locret_F02A:
		rts
; ---------------------------------------------------------------------------

loc_F02C:
		subq.w	#1,$3E(a0)
		rts