; ---------------------------------------------------------------------------

ObjLavafallMaker:
		moveq	#0,d0
		move.b	$24(a0),d0
		move.w	off_C926(pc,d0.w),d1
		jsr	off_C926(pc,d1.w)
		bra.w	loc_CB28
; ---------------------------------------------------------------------------

off_C926:	dc.w loc_C932-off_C926, loc_C95C-off_C926, loc_C9CE-off_C926, loc_C982-off_C926, loc_C9DA-off_C926
		dc.w loc_C9EA-off_C926
; ---------------------------------------------------------------------------

loc_C932:
		addq.b	#2,$24(a0)
		move.l	#MapLavafall,4(a0)
		move.w	#$E3A8,2(a0)
		move.b	#4,1(a0)
		move.b	#1,$19(a0)
		move.b	#$38,$18(a0)
		move.w	#$78,$34(a0)

loc_C95C:
		subq.w	#1,$32(a0)
		bpl.s	locret_C980
		move.w	$34(a0),$32(a0)
		move.w	(v_objspace+$C).w,d0
		move.w	$C(a0),d1
		cmp.w	d1,d0
		bcc.s	locret_C980
		subi.w	#$170,d1
		cmp.w	d1,d0
		bcs.s	locret_C980
		addq.b	#2,$24(a0)

locret_C980:
		rts
; ---------------------------------------------------------------------------

loc_C982:
		addq.b	#2,$24(a0)
		bsr.w	LoadNextObject
		bne.s	loc_C9A8
		move.b	#$4D,0(a1)
		move.w	8(a0),8(a1)
		move.w	$C(a0),$C(a1)
		move.b	$28(a0),$28(a1)
		move.l	a0,$3C(a1)

loc_C9A8:
		move.b	#1,$1C(a0)
		tst.b	$28(a0)
		beq.s	loc_C9BC
		move.b	#4,$1C(a0)
		bra.s	loc_C9DA
; ---------------------------------------------------------------------------

loc_C9BC:
		movea.l	$3C(a0),a1
		bset	#1,$22(a1)
		move.w	#$FA80,$12(a1)
		bra.s	loc_C9DA
; ---------------------------------------------------------------------------

loc_C9CE:
		tst.b	$28(a0)
		beq.s	loc_C9DA
		addq.b	#2,$24(a0)
		rts
; ---------------------------------------------------------------------------

loc_C9DA:
		lea	(AniLavaFallMaker).l,a1
		bsr.w	AnimateSprite
		bsr.w	DisplaySprite
		rts
; ---------------------------------------------------------------------------

loc_C9EA:
		move.b	#0,$1C(a0)
		move.b	#2,$24(a0)
		tst.b	$28(a0)
		beq.w	DeleteObject
		rts
; ---------------------------------------------------------------------------

ObjLavafall:
		moveq	#0,d0
		move.b	$24(a0),d0
		move.w	off_CA12(pc,d0.w),d1
		jsr	off_CA12(pc,d1.w)
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

off_CA12:	dc.w loc_CA1E-off_CA12, loc_CB0A-off_CA12, sub_CB8C-off_CA12, loc_CBEA-off_CA12

word_CA1A:	dc.w $FB00, 0
; ---------------------------------------------------------------------------

loc_CA1E:
		addq.b	#2,$24(a0)
		move.w	$C(a0),$30(a0)
		tst.b	$28(a0)
		beq.s	loc_CA34
		subi.w	#$250,$C(a0)

loc_CA34:
		moveq	#0,d0
		move.b	$28(a0),d0
		add.w	d0,d0
		move.w	word_CA1A(pc,d0.w),$12(a0)
		movea.l	a0,a1
		moveq	#1,d1
		bsr.s	sub_CA50
		bra.s	loc_CAA0
; ---------------------------------------------------------------------------

sub_CA4A:
		bsr.w	LoadNextObject
		bne.s	loc_CA9A
; ---------------------------------------------------------------------------

sub_CA50:
		move.b	#$4D,0(a1)
		move.l	#MapLavafall,4(a1)
		move.w	#$63A8,2(a1)
		move.b	#4,1(a1)
		move.b	#$20,$18(a1)
		move.w	8(a0),8(a1)
		move.w	$C(a0),$C(a1)
		move.b	$28(a0),$28(a1)
		move.b	#1,$19(a1)
		move.b	#5,$1C(a1)
		tst.b	$28(a0)
		beq.s	loc_CA9A
		move.b	#2,$1C(a1)

loc_CA9A:
		dbf	d1,sub_CA4A
		rts
; ---------------------------------------------------------------------------

loc_CAA0:
		addi.w	#$60,$C(a1)
		move.w	$30(a0),$30(a1)
		addi.w	#$60,$30(a1)
		move.b	#$93,$20(a1)
		move.b	#$80,$16(a1)
		bset	#4,1(a1)
		addq.b	#4,$24(a1)
		move.l	a0,$3C(a1)
		tst.b	$28(a0)
		beq.s	loc_CB00
		moveq	#0,d1
		bsr.w	sub_CA4A
		addq.b	#2,$24(a1)
		bset	#4,2(a1)
		addi.w	#$100,$C(a1)
		move.b	#0,$19(a1)
		move.w	$30(a0),$30(a1)
		move.l	$3C(a0),$3C(a1)
		move.b	#0,$28(a0)

loc_CB00:
		move.w	#sfx_Burning,d0
		jsr	(PlaySound_Special).l

loc_CB0A:
		moveq	#0,d0
		move.b	$28(a0),d0
		add.w	d0,d0
		move.w	off_CB48(pc,d0.w),d1
		jsr	off_CB48(pc,d1.w)
		bsr.w	SpeedToPos
		lea	(AniLavaFallMaker).l,a1
		bsr.w	AnimateSprite

loc_CB28:
		move.w	8(a0),d0
		andi.w	#$FF80,d0
		move.w	(v_screenposx).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0
		cmpi.w	#$280,d0
		bhi.w	DeleteObject
		rts
; ---------------------------------------------------------------------------

off_CB48:	dc.w loc_CB4C-off_CB48, loc_CB6C-off_CB48
; ---------------------------------------------------------------------------

loc_CB4C:
		addi.w	#$18,$12(a0)
		move.w	$30(a0),d0
		cmp.w	$C(a0),d0
		bcc.s	locret_CB6A
		addq.b	#4,$24(a0)
		movea.l	$3C(a0),a1
		move.b	#3,$1C(a1)

locret_CB6A:
		rts
; ---------------------------------------------------------------------------

loc_CB6C:
		addi.w	#$18,$12(a0)
		move.w	$30(a0),d0
		cmp.w	$C(a0),d0
		bcc.s	locret_CB8A
		addq.b	#4,$24(a0)
		movea.l	$3C(a0),a1
		move.b	#1,$1C(a1)

locret_CB8A:
		rts
; ---------------------------------------------------------------------------

sub_CB8C:
		movea.l	$3C(a0),a1
		cmpi.b	#6,$24(a1)
		beq.w	loc_CBEA
		move.w	$C(a1),d0
		addi.w	#$60,d0
		move.w	d0,$C(a0)
		sub.w	$30(a0),d0
		neg.w	d0
		moveq	#8,d1
		cmpi.w	#$40,d0
		bge.s	loc_CBB6
		moveq	#$B,d1

loc_CBB6:
		cmpi.w	#$80,d0
		ble.s	loc_CBBE
		moveq	#$E,d1

loc_CBBE:
		subq.b	#1,$1E(a0)
		bpl.s	loc_CBDC
		move.b	#7,$1E(a0)
		addq.b	#1,$1B(a0)
		cmpi.b	#2,$1B(a0)
		bcs.s	loc_CBDC
		move.b	#0,$1B(a0)

loc_CBDC:
		move.b	$1B(a0),d0
		add.b	d1,d0
		move.b	d0,$1A(a0)
		bra.w	loc_CB28
; ---------------------------------------------------------------------------

loc_CBEA:
		bra.w	DeleteObject