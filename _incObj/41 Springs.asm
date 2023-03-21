; ---------------------------------------------------------------------------

ObjSpring:
		moveq	#0,d0
		move.b	$24(a0),d0
		move.w	off_BAA0(pc,d0.w),d1
		jsr	off_BAA0(pc,d1.w)
		bsr.w	DisplaySprite
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

off_BAA0:	dc.w loc_BAB8-off_BAA0, sub_BB2E-off_BAA0, loc_BB84-off_BAA0, sub_BB8E-off_BAA0, sub_BB9A-off_BAA0
		dc.w loc_BC1C-off_BAA0, sub_BC26-off_BAA0, loc_BC32-off_BAA0, loc_BC98-off_BAA0, loc_BCA2-off_BAA0

word_BAB4:	dc.w -$1000, -$A00
; ---------------------------------------------------------------------------

loc_BAB8:
		addq.b	#2,$24(a0)
		move.l	#MapSpring,4(a0)
		move.w	#$523,2(a0)
		ori.b	#4,1(a0)
		move.b	#$10,$18(a0)
		move.b	#4,$19(a0)
		move.b	$28(a0),d0
		btst	#4,d0
		beq.s	loc_BB04
		move.b	#8,$24(a0)
		move.b	#1,$1C(a0)
		move.b	#3,$1A(a0)
		move.w	#$533,2(a0)
		move.b	#8,$18(a0)

loc_BB04:
		btst	#5,d0
		beq.s	loc_BB16
		move.b	#$E,$24(a0)
		bset	#1,$22(a0)

loc_BB16:
		btst	#1,d0
		beq.s	loc_BB22
		bset	#5,2(a0)

loc_BB22:
		andi.w	#$F,d0
		move.w	word_BAB4(pc,d0.w),$30(a0)
		rts
; ---------------------------------------------------------------------------

sub_BB2E:
		move.w	#$1B,d1
		move.w	#8,d2
		move.w	#$10,d3
		move.w	8(a0),d4
		bsr.w	SolidObject
		tst.b	$25(a0)
		bne.s	loc_BB4A
		rts
; ---------------------------------------------------------------------------

loc_BB4A:
		addq.b	#2,$24(a0)
		addq.w	#8,$C(a1)
		move.w	$30(a0),$12(a1)
		bset	#1,$22(a1)
		bclr	#3,$22(a1)
		move.b	#$10,$1C(a1)
		move.b	#2,$24(a1)
		bclr	#3,$22(a0)
		clr.b	$25(a0)
		move.w	#$CC,d0
		jsr	(PlaySFX).l

loc_BB84:
		lea	(AniSpring).l,a1
		bra.w	ObjectAnimate
; ---------------------------------------------------------------------------

sub_BB8E:
		move.b	#1,$1D(a0)
		subq.b	#4,$24(a0)
		rts
; ---------------------------------------------------------------------------

sub_BB9A:
		move.w	#$13,d1
		move.w	#$E,d2
		move.w	#$F,d3
		move.w	8(a0),d4
		bsr.w	SolidObject
		cmpi.b	#2,$24(a0)
		bne.s	loc_BBBC
		move.b	#8,$24(a0)

loc_BBBC:
		btst	#5,$22(a0)
		bne.s	loc_BBC6
		rts
; ---------------------------------------------------------------------------

loc_BBC6:
		addq.b	#2,$24(a0)
		move.w	$30(a0),$10(a1)
		addq.w	#8,8(a1)
		btst	#0,$22(a0)
		bne.s	loc_BBE6
		subi.w	#$10,8(a1)
		neg.w	$10(a1)

loc_BBE6:
		move.w	#$F,$3E(a1)
		move.w	$10(a1),$14(a1)
		bchg	#0,$22(a1)
		btst	#2,$22(a1)
		bne.s	loc_BC06
		move.b	#0,$1C(a1)

loc_BC06:
		bclr	#5,$22(a0)
		bclr	#5,$22(a1)
		move.w	#$CC,d0
		jsr	(PlaySFX).l

loc_BC1C:
		lea	(AniSpring).l,a1
		bra.w	ObjectAnimate
; ---------------------------------------------------------------------------

sub_BC26:
		move.b	#2,$1D(a0)
		subq.b	#4,$24(a0)
		rts
; ---------------------------------------------------------------------------

loc_BC32:
		move.w	#$1B,d1
		move.w	#8,d2
		move.w	#$10,d3
		move.w	8(a0),d4
		bsr.w	SolidObject
		cmpi.b	#2,$24(a0)
		bne.s	loc_BC54
		move.b	#$E,$24(a0)

loc_BC54:
		tst.b	$25(a0)
		bne.s	locret_BC5E
		tst.w	d4
		bmi.s	loc_BC60

locret_BC5E:
		rts
; ---------------------------------------------------------------------------

loc_BC60:
		addq.b	#2,$24(a0)
		subq.w	#8,$C(a1)
		move.w	$30(a0),$12(a1)
		neg.w	$12(a1)
		bset	#1,$22(a1)
		bclr	#3,$22(a1)
		move.b	#2,$24(a1)
		bclr	#3,$22(a0)
		clr.b	$25(a0)
		move.w	#$CC,d0
		jsr	(PlaySFX).l

loc_BC98:
		lea	(AniSpring).l,a1
		bra.w	ObjectAnimate
; ---------------------------------------------------------------------------

loc_BCA2:
		move.b	#1,$1D(a0)
		subq.b	#4,$24(a0)
		rts
