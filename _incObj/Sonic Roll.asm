; ---------------------------------------------------------------------------

Sonic_Roll:
		move.w	objInertia(a0),d0
		bpl.s	loc_EE54
		neg.w	d0

loc_EE54:
		cmpi.w	#$80,d0
		bcs.s	locret_EE6C
		move.b	(v_jpadhold2).w,d0
		andi.b	#btnL+btnR,d0
		bne.s	locret_EE6C
		btst	#bitDn,(v_jpadhold2).w
		bne.s	Sonic_CheckRoll

locret_EE6C:
		rts
; ---------------------------------------------------------------------------

Sonic_CheckRoll:
		btst	#2,objStatus(a0)
		beq.s	Sonic_DoRoll
		rts
; ---------------------------------------------------------------------------

Sonic_DoRoll:
		bset	#2,objStatus(a0)
		move.b	#$E,objHeight(a0)
		move.b	#7,objWidth(a0)
		move.b	#id_Roll,objAnim(a0)
		addq.w	#5,objY(a0)
		move.w	#sfx_Roll,d0
		jsr	(PlaySound_Special).l
		tst.w	objInertia(a0)
		bne.s	locret_EEAA
		move.w	#$200,objInertia(a0)

locret_EEAA:
		rts