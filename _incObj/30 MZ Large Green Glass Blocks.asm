; ---------------------------------------------------------------------------

ObjGlassBlock:
		moveq	#0,d0
		move.b	$24(a0),d0
		move.w	off_93DE(pc,d0.w),d1
		jsr	off_93DE(pc,d1.w)
		bsr.w	DisplaySprite
		out_of_range.w	loc_93D8
		rts
; ---------------------------------------------------------------------------

loc_93D8:
		bsr.w	DeleteObject
		rts
; ---------------------------------------------------------------------------

off_93DE:	dc.w loc_93FA-off_93DE, loc_9498-off_93DE, loc_94B0-off_93DE, loc_94CA-off_93DE, loc_94D8-off_93DE
		dc.w loc_9500-off_93DE

byte_93EA:	dc.b 2, 4, 0
		dc.b 4, $48, 1
		dc.b 6, 4, 2
		even

byte_93F4:	dc.b 8, 0, 3
		dc.b $A, 0, 2
; ---------------------------------------------------------------------------

loc_93FA:
		lea	(byte_93EA).l,a2
		moveq	#2,d1
		cmpi.b	#3,$28(a0)
		bcs.s	loc_9412
		lea	(byte_93F4).l,a2
		moveq	#1,d1

loc_9412:
		movea.l	a0,a1
		bra.s	loc_941C
; ---------------------------------------------------------------------------

loc_9416:
		bsr.w	FindNextFreeObj
		bne.s	loc_9486

loc_941C:
		move.b	(a2)+,$24(a1)
		move.b	#$30,0(a1)
		move.w	8(a0),8(a1)
		move.b	(a2)+,d0
		ext.w	d0
		add.w	$C(a0),d0
		move.w	d0,$C(a1)
		move.l	#MapGlassBlock,4(a1)
		move.w	#$C38E,2(a1)
		move.b	#4,1(a1)
		move.w	$C(a1),$30(a1)
		move.b	$28(a0),$28(a1)
		move.b	#$20,$18(a1)
		move.b	#4,$19(a1)
		move.b	(a2)+,$1A(a1)
		move.l	a0,$3C(a1)
		dbf	d1,loc_9416
		move.b	#$10,$18(a1)
		move.b	#3,$19(a1)
		addq.b	#8,$28(a1)
		andi.b	#$F,$28(a1)

loc_9486:
		move.w	#$90,$32(a0)
		move.b	#$38,$16(a0)
		bset	#4,1(a0)

loc_9498:
		bsr.w	sub_9514
		move.w	#$2B,d1
		move.w	#$24,d2
		move.w	#$24,d3
		move.w	8(a0),d4
		bra.w	SolidObject
; ---------------------------------------------------------------------------

loc_94B0:
		movea.l	$3C(a0),a1
		move.w	$32(a1),$32(a0)
		bsr.w	sub_9514
		move.w	#$2B,d1
		move.w	#$24,d2
		bra.w	sub_6936
; ---------------------------------------------------------------------------

loc_94CA:
		movea.l	$3C(a0),a1
		move.w	$32(a1),$32(a0)
		bra.w	sub_9514
; ---------------------------------------------------------------------------

loc_94D8:
		bsr.w	sub_9514
		move.w	#$2B,d1
		move.w	#$38,d2
		move.w	#$38,d3
		move.w	8(a0),d4
		bsr.w	SolidObject
		cmpi.b	#8,$24(a0)
		beq.s	locret_94FE
		move.b	#8,$24(a0)

locret_94FE:
		rts
; ---------------------------------------------------------------------------

loc_9500:
		movea.l	$3C(a0),a1
		move.w	$32(a1),$32(a0)
		move.w	$C(a1),$30(a0)
		bra.w	sub_9514
; ---------------------------------------------------------------------------

sub_9514:
		moveq	#0,d0
		move.b	$28(a0),d0
		andi.w	#7,d0
		add.w	d0,d0
		move.w	off_9528(pc,d0.w),d1
		jmp	off_9528(pc,d1.w)
; ---------------------------------------------------------------------------

off_9528:	dc.w locret_9532-off_9528, loc_9534-off_9528, loc_9540-off_9528
		dc.w loc_9550-off_9528, loc_95D6-off_9528
; ---------------------------------------------------------------------------

locret_9532:
		rts
; ---------------------------------------------------------------------------

loc_9534:
		move.b	(oscValues+$12).w,d0
		move.w	#$40,d1
		bra.w	loc_9616
; ---------------------------------------------------------------------------

loc_9540:
		move.b	(oscValues+$12).w,d0
		move.w	#$40,d1
		neg.w	d0
		add.w	d1,d0
		bra.w	loc_9616
; ---------------------------------------------------------------------------

loc_9550:
		btst	#3,$28(a0)
		beq.s	loc_9564
		move.b	(oscValues+$12).w,d0
		subi.w	#$10,d0
		bra.w	loc_9624
; ---------------------------------------------------------------------------

loc_9564:
		btst	#3,$22(a0)
		bne.s	loc_9574
		bclr	#0,$34(a0)
		bra.s	loc_95A8
; ---------------------------------------------------------------------------

loc_9574:
		tst.b	$34(a0)
		bne.s	loc_95A8
		move.b	#1,$34(a0)
		bset	#0,$35(a0)
		beq.s	loc_95A8
		bset	#7,$34(a0)
		move.w	#$10,$36(a0)
		move.b	#$A,$38(a0)
		cmpi.w	#$40,$32(a0)
		bne.s	loc_95A8
		move.w	#$40,$36(a0)

loc_95A8:
		tst.b	$34(a0)
		bpl.s	loc_95D0
		tst.b	$38(a0)
		beq.s	loc_95BA
		subq.b	#1,$38(a0)
		bne.s	loc_95D0

loc_95BA:
		tst.w	$32(a0)
		beq.s	loc_95CA
		subq.w	#1,$32(a0)
		subq.w	#1,$36(a0)
		bne.s	loc_95D0

loc_95CA:
		bclr	#7,$34(a0)

loc_95D0:
		move.w	$32(a0),d0
		bra.s	loc_9624
; ---------------------------------------------------------------------------

loc_95D6:
		btst	#3,$28(a0)
		beq.s	loc_95E8
		move.b	(oscValues+$12).w,d0
		subi.w	#$10,d0
		bra.s	loc_9624
; ---------------------------------------------------------------------------

loc_95E8:
		tst.b	$34(a0)
		bne.s	loc_9606
		lea	(unk_FFF7E0).w,a2
		moveq	#0,d0
		move.b	$28(a0),d0
		lsr.w	#4,d0
		tst.b	(a2,d0.w)
		beq.s	loc_9610
		move.b	#1,$34(a0)

loc_9606:
		tst.w	$32(a0)
		beq.s	loc_9610
		subq.w	#2,$32(a0)

loc_9610:
		move.w	$32(a0),d0
		bra.s	loc_9624
; ---------------------------------------------------------------------------

loc_9616:
		btst	#3,$28(a0)
		beq.s	loc_9624
		neg.w	d0
		add.w	d1,d0
		lsr.b	#1,d0

loc_9624:
		move.w	$30(a0),d1
		sub.w	d0,d1
		move.w	d1,$C(a0)
		rts