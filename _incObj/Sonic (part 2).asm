; ---------------------------------------------------------------------------

Sonic_Hurt:
		bsr.w	Sonic_HurtStop
		bsr.w	SpeedToPos
		addi.w	#$30,$12(a0)
		bsr.w	Sonic_LevelBound
		bsr.w	sub_E952
		bsr.w	Sonic_Animate
		bsr.w	Sonic_DynTiles
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

Sonic_HurtStop:
		move.w	(unk_FFF72E).w,d0
		addi.w	#$E0,d0
		cmp.w	$C(a0),d0
		bcs.w	loc_FD78
		bsr.w	loc_F07C
		btst	#1,$22(a0)
		bne.s	locret_F318
		moveq	#0,d0
		move.w	d0,$12(a0)
		move.w	d0,$10(a0)
		move.w	d0,$14(a0)
		move.b	#0,$1C(a0)
		subq.b	#2,$24(a0)
		move.w	#$78,$30(a0)

locret_F318:
		rts
; ---------------------------------------------------------------------------

Sonic_Death:
		bsr.w	Sonic_GameOver
		bsr.w	ObjectFall
		bsr.w	sub_E952
		bsr.w	Sonic_Animate
		bsr.w	Sonic_DynTiles
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

Sonic_GameOver:
		move.w	(unk_FFF72E).w,d0
		addi.w	#$100,d0
		cmp.w	$C(a0),d0
		bcc.w	locret_F3AE
		move.w	#$FFC8,$12(a0)
		addq.b	#2,$24(a0)
		addq.b	#1,(byte_FFFE1C).w
		subq.b	#1,(v_lives).w
		bne.s	loc_F380
		move.w	#0,$3A(a0)
		move.b	#$39,(v_objspace+$80).w
		move.b	#$39,(v_objspace+$C0).w
		move.b	#1,(v_objspace+$DA).w
		move.w	#bgm_GameOver,d0
		jsr	(PlaySFX).l
		moveq	#plcid_GameOver,d0
		jmp	(plcAdd).l
; ---------------------------------------------------------------------------

loc_F380:
		move.w	#$3C,$3A(a0)
		rts
; ---------------------------------------------------------------------------
loc_F388:
		move.b	(v_jpadpress2).w,d0
		andi.b	#$70,d0
		beq.s	locret_F3AE
		andi.b	#$40,d0
		bne.s	loc_F3B0
		move.b	#0,$1C(a0)			; Respawns you after a death
		subq.b	#4,$24(a0)			; The lines above seem to make the code do nothing
		move.w	$38(a0),$C(a0)
		move.w	#$78,$30(a0)

locret_F3AE:
		rts
; ---------------------------------------------------------------------------

loc_F3B0:
		move.w	#1,(LevelRestart).w
		rts
; ---------------------------------------------------------------------------

Sonic_ResetLevel:
		tst.w	$3A(a0)
		beq.s	locret_F3CA
		subq.w	#1,$3A(a0)
		bne.s	locret_F3CA
		move.w	#1,(LevelRestart).w

locret_F3CA:
		rts