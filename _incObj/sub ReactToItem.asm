; ---------------------------------------------------------------------------
; Subroutine to react to obColType(a0)
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


TouchObjects:
		nop
		moveq	#0,d5
		move.b	obj.Height(a0),d5
		subq.b	#3,d5
		move.w	obj.Xpos(a0),d2
		move.w	obj.Ypos(a0),d3
		subq.w	#8,d2
		sub.w	d5,d3
		move.w	#$10,d4
		add.w	d5,d5
		lea	(v_lvlobjspace).w,a1
		move.w	#$5F,d6

loc_FB6E:
		tst.b	obj.Render(a1)
		bpl.s	loc_FB7A
		move.b	obj.ColType(a1),d0
		bne.s	loc_FBB8			; if nonzero, branch

	loc_FB7A:
		lea	obj.Size(a1),a1			; next object RAM
		dbf	d6,loc_FB6E			; repeat $5F more times

		moveq	#0,d0
		rts
; ---------------------------------------------------------------------------
RTI_sizes:	;   width, height
		dc.b  $14, $14				; $01
		dc.b   $C, $14				; $02
		dc.b  $14,  $C				; $03
		dc.b	4, $10				; $04
		dc.b   $C, $12				; $05
		dc.b  $10, $10				; $06
		dc.b	6,   6				; $07
		dc.b  $18,  $C				; $08
		dc.b   $C, $10				; $09
		dc.b  $10,  $C				; $0A
		dc.b	8,   8				; $0B
		dc.b  $14, $10				; $0C
		dc.b  $14,   8				; $0D
		dc.b   $E,  $E				; $0E
		dc.b  $18, $18				; $0F
		dc.b  $28, $10				; $10
		dc.b  $10, $18				; $11
		dc.b   $C, $20				; $12
		dc.b  $20, $70				; $13
		dc.b  $40, $20				; $14
		dc.b  $80, $20				; $15
		dc.b  $20, $20				; $16
		dc.b	8,   8				; $17
		dc.b	4,   4				; $18
		dc.b  $20,   8				; $19
; ---------------------------------------------------------------------------

loc_FBB8:
		andi.w	#$3F,d0
		add.w	d0,d0
		lea	RTI_sizes-2(pc,d0.w),a2
		moveq	#0,d1
		move.b	(a2)+,d1
		move.w	obj.Xpos(a1),d0
		sub.w	d1,d0
		sub.w	d2,d0
		bcc.s	loc_FBD8
		add.w	d1,d1
		add.w	d1,d0
		bcs.s	loc_FBDC
		bra.s	loc_FB7A
; ---------------------------------------------------------------------------

loc_FBD8:
		cmp.w	d4,d0
		bhi.s	loc_FB7A

loc_FBDC:
		moveq	#0,d1
		move.b	(a2)+,d1
		move.w	obj.Ypos(a1),d0
		sub.w	d1,d0
		sub.w	d3,d0
		bcc.s	loc_FBF2
		add.w	d1,d1
		add.w	d0,d1
		bcs.s	loc_FBF6
		bra.s	loc_FB7A
; ---------------------------------------------------------------------------

loc_FBF2:
		cmp.w	d5,d0
		bhi.s	loc_FB7A

loc_FBF6:
		move.b	obj.ColType(a1),d1
		andi.b	#$C0,d1
		beq.w	loc_FC6A
		cmpi.b	#$C0,d1
		beq.w	loc_FDC4
		tst.b	d1
		bmi.w	loc_FCE0
		move.b	obj.ColType(a1),d0
		andi.b	#$3F,d0
		cmpi.b	#6,d0
		beq.s	loc_FC2E
		cmpi.w	#$5A,$30(a0)
		bcc.w	locret_FC2C
		addq.b	#2,obj.Routine(a1)

locret_FC2C:
		rts
; ---------------------------------------------------------------------------

loc_FC2E:
		tst.w	obj.VelY(a0)
		bpl.s	loc_FC58
		move.w	obj.Ypos(a0),d0
		subi.w	#$10,d0
		cmp.w	obj.Ypos(a1),d0
		bcs.s	locret_FC68
		neg.w	obj.VelY(a0)
		move.w	#$FE80,obj.VelY(a1)
		tst.b	obj.2ndRout(a1)
		bne.s	locret_FC68
		addq.b	#4,obj.2ndRout(a1)
		rts
; ---------------------------------------------------------------------------

loc_FC58:
		cmpi.b	#2,obj.Anim(a0)
		bne.s	locret_FC68
		neg.w	obj.VelY(a0)
		addq.b	#2,obj.Routine(a1)

locret_FC68:
		rts
; ---------------------------------------------------------------------------

loc_FC6A:
		tst.b	(v_invinc).w
		bne.s	loc_FC78
		cmpi.b	#2,obj.Anim(a0)
		bne.s	loc_FCE0

loc_FC78:
		tst.b	obj.ColProp(a1)
		beq.s	loc_FCA2
		neg.w	obj.VelX(a0)
		neg.w	obj.VelY(a0)
		asr	obj.VelX(a0)
		asr	obj.VelY(a0)
		move.b	#0,obj.ColType(a1)
		subq.b	#1,obj.ColProp(a1)
		bne.s	locret_FCA0
		bset	#7,obj.Status(a1)

locret_FCA0:
		rts
; ---------------------------------------------------------------------------

loc_FCA2:
		bset	#7,obj.Status(a1)
		moveq	#10,d0
		bsr.w	ScoreAdd
		_move.b	#id_ExplosionItem,obj.Id(a1)
		move.b	#0,obj.Routine(a1)
		tst.w	obj.VelY(a0)
		bmi.s	loc_FCD0
		move.w	obj.Ypos(a0),d0
		cmp.w	obj.Ypos(a1),d0
		bcc.s	loc_FCD8
		neg.w	obj.VelY(a0)
		rts
; ---------------------------------------------------------------------------

loc_FCD0:
		addi.w	#$100,obj.VelY(a0)
		rts
; ---------------------------------------------------------------------------

loc_FCD8:
		subi.w	#$100,obj.VelY(a0)
		rts
; ---------------------------------------------------------------------------

loc_FCE0:
		tst.b	(v_invinc).w
		beq.s	loc_FCEA

loc_FCE6:
		moveq	#-1,d0
		rts
; ---------------------------------------------------------------------------

loc_FCEA:
		nop
		tst.w	$30(a0)
		bne.s	loc_FCE6
		movea.l	a1,a2

loc_FCF4:
		tst.b	(v_shield).w
		bne.s	loc_FD18
		tst.w	(v_rings).w
		beq.s	loc_FD72
		bsr.w	FindFreeObj
		bne.s	loc_FD18
		_move.b	#id_RingLoss,obj.Id(a1)
		move.w	obj.Xpos(a0),obj.Xpos(a1)
		move.w	obj.Ypos(a0),obj.Ypos(a1)

loc_FD18:
		move.b	#0,(v_shield).w
		move.b	#4,obj.Routine(a0)
		bsr.w	Sonic_ResetOnFloor
		bset	#1,obj.Status(a0)
		move.w	#$FC00,obj.VelY(a0)
		move.w	#$FE00,obj.VelX(a0)
		move.w	obj.Xpos(a0),d0
		cmp.w	obj.Xpos(a2),d0
		bcs.s	loc_FD48
		neg.w	obj.VelX(a0)

loc_FD48:
		move.w	#0,obj.Inertia(a0)
		move.b	#$1A,obj.Anim(a0)
		move.w	#$258,$30(a0)
		move.w	#sfx_Death,d0
		cmpi.b	#$36,(a2)
		bne.s	loc_FD68
		move.w	#sfx_HitSpikes,d0

loc_FD68:
		jsr	(PlaySound_Special).l
		moveq	#-1,d0
		rts
; ---------------------------------------------------------------------------

loc_FD72:
		tst.w	(f_debugmode).w
		bne.s	loc_FD18

loc_FD78:
		tst.w	(v_debuguse).w
		bne.s	loc_FDC0
		move.b	#6,obj.Routine(a0)
		bsr.w	Sonic_ResetOnFloor
		bset	#1,obj.Status(a0)
		move.w	#$F900,obj.VelY(a0)
		move.w	#0,obj.VelX(a0)
		move.w	#0,obj.Inertia(a0)
		move.w	obj.Ypos(a0),$38(a0)
		move.b	#$18,obj.Anim(a0)
		move.w	#sfx_Death,d0
		cmpi.b	#$36,(a2)
		bne.s	loc_FDBA
		move.w	#sfx_HitSpikes,d0

loc_FDBA:
		jsr	(PlaySound_Special).l

loc_FDC0:
		moveq	#-1,d0
		rts
; ---------------------------------------------------------------------------

loc_FDC4:
		move.b	obj.ColType(a1),d1
		andi.b	#$3F,d1
		cmpi.b	#$C,d1
		beq.s	loc_FDDA
		cmpi.b	#$17,d1
		beq.s	loc_FE0C
		rts
; ---------------------------------------------------------------------------

loc_FDDA:
		sub.w	d0,d5
		cmpi.w	#8,d5
		bcc.s	loc_FE08
		move.w	obj.Xpos(a1),d0
		subq.w	#4,d0
		btst	#0,obj.Status(a1)
		beq.s	loc_FDF4
		subi.w	#$10,d0

loc_FDF4:
		sub.w	d2,d0
		bcc.s	loc_FE00
		addi.w	#$18,d0
		bcs.s	loc_FE04
		bra.s	loc_FE08
; ---------------------------------------------------------------------------

loc_FE00:
		cmp.w	d4,d0
		bhi.s	loc_FE08

loc_FE04:
		bra.w	loc_FCE0
; ---------------------------------------------------------------------------

loc_FE08:
		bra.w	loc_FC6A
; ---------------------------------------------------------------------------

loc_FE0C:
		addq.b	#1,obj.ColProp(a1)
		rts