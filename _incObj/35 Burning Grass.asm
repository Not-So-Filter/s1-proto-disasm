; ---------------------------------------------------------------------------

ObjFloorLavaball:
		moveq	#0,d0
		move.b	$24(a0),d0
		move.w	off_91F2(pc,d0.w),d1
		jmp	off_91F2(pc,d1.w)
; ---------------------------------------------------------------------------

off_91F2:	dc.w loc_91F8-off_91F2, loc_9240-off_91F2, loc_92BA-off_91F2
; ---------------------------------------------------------------------------

loc_91F8:
		addq.b	#2,$24(a0)
		move.l	#MapLavaball,4(a0)
		move.w	#$345,2(a0)
		move.w	8(a0),$2A(a0)
		move.b	#4,1(a0)
		move.b	#1,$19(a0)
		move.b	#$8B,$20(a0)
		move.b	#8,$18(a0)
		move.w	#sfx_Burning,d0
		jsr	(PlaySFX).l
		tst.b	$28(a0)
		beq.s	loc_9240
		addq.b	#2,$24(a0)
		bra.w	loc_92BA
; ---------------------------------------------------------------------------

loc_9240:
		movea.l	$30(a0),a1
		move.w	8(a0),d1
		sub.w	$2A(a0),d1
		addi.w	#$C,d1
		move.w	d1,d0
		lsr.w	#1,d0
		move.b	(a1,d0.w),d0
		neg.w	d0
		add.w	$2C(a0),d0
		move.w	d0,d2
		add.w	$3C(a0),d0
		move.w	d0,$C(a0)
		cmpi.w	#$84,d1
		bcc.s	loc_92B8
		addi.l	#$10000,8(a0)
		cmpi.w	#$80,d1
		bcc.s	loc_92B8
		move.l	8(a0),d0
		addi.l	#$80000,d0
		andi.l	#$FFFFF,d0
		bne.s	loc_92B8
		bsr.w	LoadNextObject
		bne.s	loc_92B8
		move.b	#$35,0(a1)
		move.w	8(a0),8(a1)
		move.w	d2,$2C(a1)
		move.w	$3C(a0),$3C(a1)
		move.b	#1,$28(a1)
		movea.l	$38(a0),a2
		bsr.w	sub_90A4

loc_92B8:
		bra.s	loc_92C6
; ---------------------------------------------------------------------------

loc_92BA:
		move.w	$2C(a0),d0
		add.w	$3C(a0),d0
		move.w	d0,$C(a0)

loc_92C6:
		lea	(AniFloorLavaball).l,a1
		bsr.w	AnimateSprite
		bra.w	DisplaySprite