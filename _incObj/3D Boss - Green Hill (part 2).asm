; ---------------------------------------------------------------------------

loc_B1AE:
		move.w	#$FF00,$10(a0)
		move.w	#$FFC0,$12(a0)
		bsr.w	BossMove
		cmpi.w	#$2A00,$30(a0)
		bne.s	loc_B1F8
		move.w	#0,$10(a0)
		move.w	#0,$12(a0)
		addq.b	#2,$25(a0)
		bsr.w	LoadNextObject
		bne.s	loc_B1F2
		move.b	#$48,0(a1)
		move.w	$30(a0),8(a1)
		move.w	$38(a0),$C(a1)
		move.l	a0,$34(a1)

loc_B1F2:
		move.w	#$77,$3C(a0)

loc_B1F8:
		bra.w	loc_B0D2
; ---------------------------------------------------------------------------

loc_B1FC:
		subq.w	#1,$3C(a0)
		bpl.s	loc_B226
		addq.b	#2,$25(a0)
		move.w	#$3F,$3C(a0)
		move.w	#$100,$10(a0)
		cmpi.w	#$2A00,$30(a0)
		bne.s	loc_B226
		move.w	#$7F,$3C(a0)
		move.w	#$40,$10(a0)

loc_B226:
		btst	#0,$22(a0)
		bne.s	loc_B232
		neg.w	$10(a0)

loc_B232:
		bra.w	loc_B0D2
; ---------------------------------------------------------------------------

loc_B236:
		subq.w	#1,$3C(a0)
		bmi.s	loc_B242
		bsr.w	BossMove
		bra.s	loc_B258
; ---------------------------------------------------------------------------

loc_B242:
		bchg	#0,$22(a0)
		move.w	#$3F,$3C(a0)
		subq.b	#2,$25(a0)
		move.w	#0,$10(a0)

loc_B258:
		bra.w	loc_B0D2
; ---------------------------------------------------------------------------

loc_B25C:
		subq.w	#1,$3C(a0)
		bmi.s	loc_B266
		bra.w	sub_B146
; ---------------------------------------------------------------------------

loc_B266:
		bset	#0,$22(a0)
		bclr	#7,$22(a0)
		move.w	#$400,$10(a0)
		move.w	#$FFC0,$12(a0)
		addq.b	#2,$25(a0)
		tst.b	(unk_FFF7A7).w
		bne.s	locret_B28E
		move.b	#1,(unk_FFF7A7).w

locret_B28E:
		rts
; ---------------------------------------------------------------------------

loc_B290:
		cmpi.w	#$2AC0,(unk_FFF72A).w
		beq.s	loc_B29E
		addq.w	#2,(unk_FFF72A).w
		bra.s	loc_B2A6
; ---------------------------------------------------------------------------

loc_B29E:
		tst.b	1(a0)
		bpl.w	DeleteObject

loc_B2A6:
		bsr.w	BossMove
		bra.w	loc_B0D2
; ---------------------------------------------------------------------------

loc_B2AE:
		movea.l	$34(a0),a1
		cmpi.b	#$A,$25(a1)
		bne.s	loc_B2C2
		tst.b	1(a0)
		bpl.w	DeleteObject

loc_B2C2:
		move.b	#1,$1C(a0)
		tst.b	$20(a1)
		bne.s	loc_B2D4
		move.b	#5,$1C(a0)

loc_B2D4:
		bra.s	loc_B2FC
; ---------------------------------------------------------------------------

loc_B2D6:
		movea.l	$34(a0),a1
		cmpi.b	#$A,$25(a1)
		bne.s	loc_B2EA
		tst.b	1(a0)
		bpl.w	DeleteObject

loc_B2EA:
		move.b	#7,$1C(a0)
		move.w	$10(a1),d0
		beq.s	loc_B2FC
		move.b	#8,$1C(a0)

loc_B2FC:
		movea.l	$34(a0),a1
		move.w	8(a1),8(a0)
		move.w	$C(a1),$C(a0)
		move.b	$22(a1),$22(a0)
		lea	(AniGHZBoss).l,a1
		bsr.w	ObjectAnimate
		move.b	$22(a0),d0
		andi.b	#3,d0
		andi.b	#$FC,1(a0)
		or.b	d0,1(a0)
		bra.w	DisplaySprite
