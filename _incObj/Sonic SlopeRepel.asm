; ---------------------------------------------------------------------------

Sonic_SlopeRepel:
		nop
		tst.w	ctrllock(a0)
		bne.s	loc_F02C
		move.b	obj.Angle(a0),d0
		addi.b	#$20,d0
		andi.b	#$C0,d0
		beq.s	locret_F02A
		move.w	obj.Inertia(a0),d0
		bpl.s	loc_F018
		neg.w	d0

loc_F018:
		cmpi.w	#$280,d0
		bcc.s	locret_F02A
		bset	#1,obj.Status(a0)
		move.w	#$1E,ctrllock(a0)

locret_F02A:
		rts
; ---------------------------------------------------------------------------

loc_F02C:
		subq.w	#1,ctrllock(a0)
		rts
