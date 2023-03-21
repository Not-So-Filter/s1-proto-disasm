; ---------------------------------------------------------------------------

PauseGame:
		nop
		tst.b	(v_lives).w
		beq.s	loc_1206
		tst.w	(f_pause).w
		bne.s	loc_11CC
		btst	#7,(v_jpadpress1).w
		beq.s	locret_120C

loc_11CC:
		move.w	#-1,(f_pause).w

loc_11D2:
		move.b	#$10,(VBlankRoutine).w
		bsr.w	WaitForVBla
		btst	#6,(v_jpadpress1).w
		beq.s	loc_11EE
		move.b	#4,(v_gamemode).w
		nop
		bra.s	loc_1206
; ---------------------------------------------------------------------------

loc_11EE:
		btst	#4,(v_jpadhold1).w
		bne.s	loc_120E
		btst	#5,(v_jpadpress1).w
		bne.s	loc_120E
		btst	#7,(v_jpadpress1).w
		beq.s	loc_11D2

loc_1206:
		move.w	#0,(f_pause).w

locret_120C:
		rts
; ---------------------------------------------------------------------------

loc_120E:
		move.w	#1,(f_pause).w
		rts
