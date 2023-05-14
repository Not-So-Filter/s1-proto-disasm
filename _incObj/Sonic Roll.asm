; ---------------------------------------------------------------------------

Sonic_Roll:
		move.w	$14(a0),d0
		bpl.s	loc_EE54
		neg.w	d0

loc_EE54:
		cmpi.w	#$80,d0
		bcs.s	locret_EE6C
		move.b	(v_jpadhold2).w,d0
		andi.b	#$C,d0
		bne.s	locret_EE6C
		btst	#1,(v_jpadhold2).w
		bne.s	Sonic_CheckRoll

locret_EE6C:
		rts
; ---------------------------------------------------------------------------

Sonic_CheckRoll:
		btst	#2,$22(a0)
		beq.s	Sonic_DoRoll
		rts
; ---------------------------------------------------------------------------

Sonic_DoRoll:
		bset	#2,$22(a0)
		move.b	#$E,$16(a0)
		move.b	#7,$17(a0)
		move.b	#2,$1C(a0)
		addq.w	#5,$C(a0)
		move.w	#sfx_Roll,d0
		jsr	(PlaySFX).l
		tst.w	$14(a0)
		bne.s	locret_EEAA
		move.w	#$200,$14(a0)

locret_EEAA:
		rts