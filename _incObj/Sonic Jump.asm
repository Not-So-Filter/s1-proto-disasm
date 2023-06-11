; ---------------------------------------------------------------------------

Sonic_Jump:
		move.b	(v_jpadpress2).w,d0
		andi.b	#$70,d0
		beq.w	locret_EF46
		moveq	#0,d0
		move.b	$26(a0),d0
		addi.b	#-$80,d0
		bsr.w	sub_10520
		cmpi.w	#6,d1
		blt.w	locret_EF46
		moveq	#0,d0
		move.b	$26(a0),d0
		subi.b	#$40,d0
		jsr	(GetSine).l
		muls.w	#$680,d1
		asr.l	#8,d1
		add.w	d1,$10(a0)
		muls.w	#$680,d0
		asr.l	#8,d0
		add.w	d0,$12(a0)
		bset	#1,$22(a0)
		bclr	#5,$22(a0)
		addq.l	#4,sp
		move.b	#1,$3C(a0)
		move.w	#sfx_Jump,d0
		jsr	(PlaySound_Special).l
		move.b	#$13,$16(a0)
		move.b	#9,$17(a0)
		tst.b	(f_victory).w			; has the victory animation flag been set?
		bne.s	loc_EF48			; if not, branch
		btst	#2,$22(a0)			; use "victory leaping" animation
		bne.s	loc_EF50
		move.b	#$E,$16(a0)
		move.b	#7,$17(a0)
		move.b	#2,$1C(a0)			; use "jumping" animation
		bset	#2,$22(a0)
		addq.w	#5,$C(a0)

locret_EF46:
		rts
; ---------------------------------------------------------------------------

loc_EF48:
		move.b	#$13,$1C(a0)
		rts
; ---------------------------------------------------------------------------

loc_EF50:
		bset	#4,$22(a0)
		rts