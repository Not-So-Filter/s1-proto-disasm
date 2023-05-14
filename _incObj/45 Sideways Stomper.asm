; ---------------------------------------------------------------------------

Obj45:
		moveq	#0,d0
		move.b	$24(a0),d0
		move.w	off_99DE(pc,d0.w),d1
		jmp	off_99DE(pc,d1.w)
; ---------------------------------------------------------------------------

off_99DE:	dc.w loc_99FA-off_99DE, loc_9A8E-off_99DE, loc_9AC4-off_99DE, loc_9AD8-off_99DE, loc_9AB0-off_99DE

byte_99E8:	dc.b 2, 4, 0
		dc.b 4, $E4, 1
		dc.b 8, $34, 3
		dc.b 6, $28, 2

word_99F4:	dc.w $3800, $A000, $5000
; ---------------------------------------------------------------------------

loc_99FA:
		moveq	#0,d0
		move.b	obSubtype(a0),d0
		add.w	d0,d0
		move.w	word_99F4(pc,d0.w),d2
		lea	(byte_99E8).l,a2
		movea.l	a0,a1
		moveq	#3,d1
		bra.s	loc_9A18
; ---------------------------------------------------------------------------

loc_9A12:
		bsr.w	LoadNextObject
		bne.s	loc_9A88

loc_9A18:
		move.b	(a2)+,$24(a1)
		move.b	#$45,0(a1)
		move.w	obY(a0),obY(a1)
		move.b	(a2)+,d0
		ext.w	d0
		add.w	obX(a0),d0
		move.w	d0,obX(a1)
		move.l	#Map45,obMap(a1)
		move.w	#$300,obGfx(a1)
		move.b	#4,obRender(a1)
		move.w	obX(a1),$30(a1)
		move.w	obX(a0),$3A(a1)
		move.b	obSubtype(a0),obSubtype(a1)
		move.b	#$20,obActWid(a1)
		move.w	d2,$34(a1)
		move.b	#4,obPriority(a1)
		cmpi.b	#1,(a2)
		bne.s	loc_9A76
		move.b	#$91,obColType(a1)

loc_9A76:
		move.b	(a2)+,obFrame(a1)
		move.l	a0,$3C(a1)
		dbf	d1,loc_9A12
		move.b	#3,obPriority(a1)

loc_9A88:
		move.b	#$10,obActWid(a0)

loc_9A8E:
		move.w	obX(a0),-(sp)
		bsr.w	sub_9AFC
		move.w	#$17,d1
		move.w	#$20,d2
		move.w	#$20,d3
		move.w	(sp)+,d4
		bsr.w	SolidObject
		bsr.w	DisplaySprite
		bra.w	loc_9ADC
; ---------------------------------------------------------------------------

loc_9AB0:
		movea.l	$3C(a0),a1
		move.b	$32(a1),d0
		addi.b	#$10,d0
		lsr.b	#5,d0
		addq.b	#3,d0
		move.b	d0,obFrame(a0)

loc_9AC4:
		movea.l	$3C(a0),a1
		moveq	#0,d0
		move.b	$32(a1),d0
		neg.w	d0
		add.w	$30(a0),d0
		move.w	d0,obX(a0)

loc_9AD8:
		bsr.w	DisplaySprite

loc_9ADC:
		move.w	$3A(a0),d0
		andi.w	#$FF80,d0
		move.w	(v_screenposx).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0
		cmpi.w	#640,d0
		bhi.w	DeleteObject
		rts
; ---------------------------------------------------------------------------

sub_9AFC:
		moveq	#0,d0
		move.b	obSubtype(a0),d0
		add.w	d0,d0
		move.w	off_9B0C(pc,d0.w),d1
		jmp	off_9B0C(pc,d1.w)
; ---------------------------------------------------------------------------

off_9B0C:	dc.w loc_9B10-off_9B0C, loc_9B10-off_9B0C
; ---------------------------------------------------------------------------

loc_9B10:
		tst.w	$36(a0)
		beq.s	loc_9B3E
		tst.w	$38(a0)
		beq.s	loc_9B22
		subq.w	#1,$38(a0)
		bra.s	loc_9B72
; ---------------------------------------------------------------------------

loc_9B22:
		subi.w	#$80,$32(a0)
		bcc.s	loc_9B72
		move.w	#0,$32(a0)
		move.w	#0,obVelX(a0)
		move.w	#0,$36(a0)
		bra.s	loc_9B72
; ---------------------------------------------------------------------------

loc_9B3E:
		move.w	$34(a0),d1
		cmp.w	$32(a0),d1
		beq.s	loc_9B72
		move.w	obVelX(a0),d0
		addi.w	#$70,obVelX(a0)
		add.w	d0,$32(a0)
		cmp.w	$32(a0),d1
		bhi.s	loc_9B72
		move.w	d1,$32(a0)
		move.w	#0,obVelX(a0)
		move.w	#1,$36(a0)
		move.w	#$3C,$38(a0)

loc_9B72:
		moveq	#0,d0
		move.b	$32(a0),d0
		neg.w	d0
		add.w	$30(a0),d0
		move.w	d0,obX(a0)
		rts