; ---------------------------------------------------------------------------

ObjGHZBoss:
		moveq	#0,d0
		move.b	$24(a0),d0
		move.w	off_B002(pc,d0.w),d1
		jmp	off_B002(pc,d1.w)
; ---------------------------------------------------------------------------

off_B002:	dc.w loc_B010-off_B002, loc_B07C-off_B002, loc_B2AE-off_B002, loc_B2D6-off_B002

byte_B00A:	dc.b 2, 0
		dc.b 4, 1
		dc.b 6, 7
; ---------------------------------------------------------------------------

loc_B010:
		lea	(byte_B00A).l,a2
		movea.l	a0,a1
		moveq	#2,d1
		bra.s	loc_B022
; ---------------------------------------------------------------------------

loc_B01C:
		bsr.w	LoadNextObject
		bne.s	loc_B064

loc_B022:
		move.b	(a2)+,$24(a1)
		move.b	#$3D,0(a1)
		move.w	8(a0),8(a1)
		move.w	$C(a0),$C(a1)
		move.l	#MapGHZBoss,4(a1)
		move.w	#$400,2(a1)
		move.b	#4,1(a1)
		move.b	#$20,$18(a1)
		move.b	#3,$19(a1)
		move.b	(a2)+,$1C(a1)
		move.l	a0,$34(a1)
		dbf	d1,loc_B01C

loc_B064:
		move.w	8(a0),$30(a0)
		move.w	$C(a0),$38(a0)
		move.b	#$F,$20(a0)
		move.b	#8,$21(a0)

loc_B07C:
		moveq	#0,d0
		move.b	$25(a0),d0
		move.w	off_B0AA(pc,d0.w),d1
		jsr	off_B0AA(pc,d1.w)
		lea	(AniGHZBoss).l,a1
		bsr.w	ObjectAnimate
		move.b	$22(a0),d0
		andi.b	#3,d0

loc_B09C:
		andi.b	#$FC,1(a0)
		or.b	d0,1(a0)
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

off_B0AA:	dc.w loc_B0B6-off_B0AA, loc_B1AE-off_B0AA
		dc.w loc_B1FC-off_B0AA, loc_B236-off_B0AA
		dc.w loc_B25C-off_B0AA, loc_B290-off_B0AA
; ---------------------------------------------------------------------------

loc_B0B6:
		move.w	#$100,$12(a0)
		bsr.w	BossMove
		cmpi.w	#$338,$38(a0)
		bne.s	loc_B0D2
		move.w	#0,$12(a0)
		addq.b	#2,$25(a0)

loc_B0D2:
		move.b	$3F(a0),d0
		jsr	(GetSine).l
		asr.w	#6,d0
		add.w	$38(a0),d0
		move.w	d0,$C(a0)
		move.w	$30(a0),8(a0)
		addq.b	#2,$3F(a0)
		cmpi.b	#8,$25(a0)
		bcc.s	locret_B136
		tst.b	$22(a0)
		bmi.s	loc_B138
		tst.b	$20(a0)
		bne.s	locret_B136
		tst.b	$3E(a0)
		bne.s	loc_B11A
		move.b	#$20,$3E(a0)
		move.w	#sfx_HitBoss,d0
		jsr	(PlaySFX).l

loc_B11A:
		lea	(v_pal_dry+$22).w,a1
		moveq	#0,d0
		tst.w	(a1)
		bne.s	loc_B128
		move.w	#$EEE,d0

loc_B128:
		move.w	d0,(a1)
		subq.b	#1,$3E(a0)
		bne.s	locret_B136
		move.b	#$F,$20(a0)

locret_B136:
		rts
; ---------------------------------------------------------------------------

loc_B138:
		move.b	#8,$25(a0)
		move.w	#$B3,$3C(a0)
		rts
; ---------------------------------------------------------------------------
