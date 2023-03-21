; ---------------------------------------------------------------------------

ObjSwitch:
		moveq	#0,d0
		move.b	$24(a0),d0
		move.w	off_9D72(pc,d0.w),d1
		jmp	off_9D72(pc,d1.w)
; ---------------------------------------------------------------------------

off_9D72:	dc.w loc_9D76-off_9D72, loc_9DAC-off_9D72
; ---------------------------------------------------------------------------

loc_9D76:
		addq.b	#2,$24(a0)
		move.l	#MapSwitch,4(a0)
		move.w	#$4513,2(a0)
		cmpi.b	#2,(v_zone).w
		beq.s	loc_9D96
		move.w	#$513,2(a0)

loc_9D96:
		move.b	#4,1(a0)
		move.b	#$10,$18(a0)
		move.b	#4,$19(a0)
		addq.w	#3,$C(a0)

loc_9DAC:
		tst.b	1(a0)
		bpl.s	loc_9E2E
		move.w	#$1B,d1
		move.w	#5,d2
		move.w	#5,d3
		move.w	8(a0),d4
		bsr.w	SolidObject
		bclr	#0,$1A(a0)
		move.b	$28(a0),d0
		andi.w	#$F,d0
		lea	(unk_FFF7E0).w,a3
		lea	(a3,d0.w),a3
		tst.b	$28(a0)
		bpl.s	loc_9DE8
		bsr.w	sub_9E58
		bne.s	loc_9DFE

loc_9DE8:
		moveq	#0,d3
		btst	#6,$28(a0)
		beq.s	loc_9DF4
		moveq	#7,d3

loc_9DF4:
		tst.b	$25(a0)
		bne.s	loc_9DFE
		bclr	d3,(a3)
		bra.s	loc_9E14
; ---------------------------------------------------------------------------

loc_9DFE:
		tst.b	(a3)
		bne.s	loc_9E0C
		move.w	#$CD,d0
		jsr	(PlaySFX).l

loc_9E0C:
		bset	#0,$1A(a0)
		bset	d3,(a3)

loc_9E14:
		btst	#5,$28(a0)
		beq.s	loc_9E2E
		subq.b	#1,$1E(a0)
		bpl.s	loc_9E2E
		move.b	#7,$1E(a0)
		bchg	#1,$1A(a0)

loc_9E2E:
		bsr.w	DisplaySprite
		move.w	8(a0),d0
		andi.w	#$FF80,d0
		move.w	(v_screenposx).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0
		cmpi.w	#$280,d0
		bhi.w	loc_9E52
		rts
; ---------------------------------------------------------------------------

loc_9E52:
		bsr.w	DeleteObject
		rts
; ---------------------------------------------------------------------------

sub_9E58:
		move.w	8(a0),d2
		move.w	$C(a0),d3
		subi.w	#$10,d2
		subq.w	#8,d3
		move.w	#$20,d4
		move.w	#$10,d5
		lea	(LevelObjectsList).w,a1
		move.w	#$5F,d6

loc_9E76:
		tst.b	1(a1)
		bpl.s	loc_9E82
		cmpi.b	#$33,(a1)
		beq.s	loc_9E90

loc_9E82:
		lea	$40(a1),a1
		dbf	d6,loc_9E76
		moveq	#0,d0

locret_9E8C:
		rts
; ---------------------------------------------------------------------------
But_MZData:	dc.b $10, $10
; ---------------------------------------------------------------------------

loc_9E90:
		moveq	#1,d0
		andi.w	#$3F,d0
		add.w	d0,d0
		lea	But_MZData-2(pc,d0.w),a2
		move.b	(a2)+,d1
		ext.w	d1
		move.w	8(a1),d0
		sub.w	d1,d0
		sub.w	d2,d0
		bcc.s	loc_9EB2
		add.w	d1,d1
		add.w	d1,d0
		bcs.s	loc_9EB6
		bra.s	loc_9E82
; ---------------------------------------------------------------------------

loc_9EB2:
		cmp.w	d4,d0
		bhi.s	loc_9E82

loc_9EB6:
		move.b	(a2)+,d1
		ext.w	d1
		move.w	$C(a1),d0
		sub.w	d1,d0
		sub.w	d3,d0
		bcc.s	loc_9ECC
		add.w	d1,d1
		add.w	d1,d0
		bcs.s	loc_9ED0
		bra.s	loc_9E82
; ---------------------------------------------------------------------------

loc_9ECC:
		cmp.w	d5,d0
		bhi.s	loc_9E82

loc_9ED0:
		moveq	#1,d0
		rts
