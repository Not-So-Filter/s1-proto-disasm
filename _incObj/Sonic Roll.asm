; ---------------------------------------------------------------------------

Sonic_Roll:
		move.w	obj.Inertia(a0),d0
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
		btst	#2,obj.Status(a0)
		beq.s	Sonic_DoRoll
		rts
; ---------------------------------------------------------------------------

Sonic_DoRoll:
		bset	#2,obj.Status(a0)
		move.b	#$E,obj.Height(a0)
		move.b	#7,obj.Width(a0)
		move.b	#id_Roll,obj.Anim(a0)
		addq.w	#5,obj.Ypos(a0)
		move.w	#sfx_Roll,d0
		jsr	(PlaySound_Special).l
		tst.w	obj.Inertia(a0)
		bne.s	locret_EEAA
		move.w	#$200,obj.Inertia(a0)

locret_EEAA:
		rts
