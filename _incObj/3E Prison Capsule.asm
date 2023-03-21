; ---------------------------------------------------------------------------

ObjCapsule:
		moveq	#0,d0
		move.b	$24(a0),d0
		move.w	off_B66C(pc,d0.w),d1
		jsr	off_B66C(pc,d1.w)
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

off_B66C:	dc.w loc_B68C-off_B66C, loc_B6D6-off_B66C
		dc.w loc_B710-off_B66C, loc_B760-off_B66C
		dc.w loc_B760-off_B66C, loc_B760-off_B66C
		dc.w loc_B7C6-off_B66C, loc_B7FA-off_B66C

byte_B67C:	dc.b 2, $20, 4, 0
		dc.b 4, $C, 5, 1
		dc.b 6, $10, 4, 3
		dc.b 8, $10, 3, 5
; ---------------------------------------------------------------------------

loc_B68C:
		move.l	#MapCapsule,4(a0)
		move.w	#$49D,2(a0)
		move.b	#4,1(a0)
		move.w	$C(a0),$30(a0)
		moveq	#0,d0
		move.b	$28(a0),d0
		lsl.w	#2,d0
		lea	byte_B67C(pc,d0.w),a1
		move.b	(a1)+,$24(a0)
		move.b	(a1)+,$18(a0)
		move.b	(a1)+,$19(a0)
		move.b	(a1)+,$1A(a0)
		cmpi.w	#8,d0
		bne.s	locret_B6D4
		move.b	#6,$20(a0)
		move.b	#8,$21(a0)

locret_B6D4:
		rts
; ---------------------------------------------------------------------------

loc_B6D6:
		cmpi.b	#2,(unk_FFF7A7).w
		beq.s	loc_B6F2
		move.w	#$2B,d1
		move.w	#$18,d2
		move.w	#$18,d3
		move.w	8(a0),d4
		bra.w	SolidObject
; ---------------------------------------------------------------------------

loc_B6F2:
		tst.b	$25(a0)
		beq.s	loc_B708
		clr.b	$25(a0)
		bclr	#3,(v_objspace+$22).w
		bset	#1,(v_objspace+$22).w

loc_B708:
		move.b	#2,$1A(a0)
		rts
; ---------------------------------------------------------------------------

loc_B710:
		move.w	#$17,d1
		move.w	#8,d2
		move.w	#8,d3
		move.w	8(a0),d4
		bsr.w	SolidObject
		lea	(AniCapsule).l,a1
		bsr.w	ObjectAnimate
		move.w	$30(a0),$C(a0)
		tst.b	$25(a0)
		beq.s	locret_B75E
		addq.w	#8,$C(a0)
		move.b	#$A,$24(a0)
		move.w	#$3C,$1E(a0)
		clr.b	(f_timecount).w
		clr.b	$25(a0)
		bclr	#3,(v_objspace+$22).w
		bset	#1,(v_objspace+$22).w

locret_B75E:
		rts
; ---------------------------------------------------------------------------

loc_B760:
		move.b	(byte_FFFE0F).w,d0
		andi.b	#7,d0
		bne.s	loc_B7A0
		bsr.w	ObjectLoad
		bne.s	loc_B7A0
		move.b	#$3F,0(a1)
		move.w	8(a0),8(a1)
		move.w	$C(a0),$C(a1)
		jsr	(RandomNumber).l
		move.w	d0,d1
		moveq	#0,d1
		move.b	d0,d1
		lsr.b	#2,d1
		subi.w	#$20,d1
		add.w	d1,8(a1)
		lsr.w	#8,d0
		lsr.b	#3,d0
		add.w	d0,$C(a1)

loc_B7A0:
		subq.w	#1,$1E(a0)
		bne.s	locret_B7C4
		move.b	#2,(unk_FFF7A7).w
		move.b	#$C,$24(a0)
		move.b	#9,$1A(a0)
		move.w	#$B4,$1E(a0)
		addi.w	#$20,$C(a0)

locret_B7C4:
		rts
; ---------------------------------------------------------------------------

loc_B7C6:
		move.b	(byte_FFFE0F).w,d0
		andi.b	#7,d0
		bne.s	VBla_028
		bsr.w	ObjectLoad
		bne.s	VBla_028
		move.b	#$28,0(a1)
		move.w	8(a0),8(a1)
		move.w	$C(a0),$C(a1)

VBla_028:
		subq.w	#1,$1E(a0)
		bne.s	locret_B7F8
		addq.b	#2,$24(a0)
		move.w	#$3C,$1E(a0)

locret_B7F8:
		rts
; ---------------------------------------------------------------------------

loc_B7FA:
		subq.w	#1,$1E(a0)
		bne.s	locret_B808
		bsr.w	sub_C81C
		bra.w	DeleteObject
; ---------------------------------------------------------------------------

locret_B808:
		rts
