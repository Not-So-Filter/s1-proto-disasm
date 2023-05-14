; ---------------------------------------------------------------------------

ObjSmashBlock:
		moveq	#0,d0
		move.b	$24(a0),d0
		move.w	off_D4D4(pc,d0.w),d1
		jsr	off_D4D4(pc,d1.w)
		bra.w	RememberState
; ---------------------------------------------------------------------------

off_D4D4:	dc.w loc_D4DA-off_D4D4, loc_D504-off_D4D4, loc_D580-off_D4D4
; ---------------------------------------------------------------------------

loc_D4DA:
		addq.b	#2,$24(a0)
		move.l	#MapSmashBlock,4(a0)
		move.w	#$42B8,2(a0)
		move.b	#4,1(a0)
		move.b	#$10,$18(a0)
		move.b	#4,$19(a0)
		move.b	$28(a0),$1A(a0)

loc_D504:
		move.b	(v_objspace+$1C).w,$32(a0)
		move.w	#$1B,d1
		move.w	#$10,d2
		move.w	#$11,d3
		move.w	8(a0),d4
		bsr.w	SolidObject
		btst	#3,$22(a0)
		bne.s	loc_D528

locret_D526:
		rts
; ---------------------------------------------------------------------------

loc_D528:
		cmpi.b	#2,$32(a0)
		bne.s	locret_D526
		bset	#2,$22(a1)
		move.b	#$E,$16(a1)
		move.b	#7,$17(a1)
		move.b	#2,$1C(a1)
		move.w	#$FD00,$12(a1)
		bset	#1,$22(a1)
		bclr	#3,$22(a1)
		move.b	#2,$24(a1)
		bclr	#3,$22(a0)
		clr.b	$25(a0)
		move.b	#1,$1A(a0)
		lea	(ObjSmashBlock_Frag).l,a4
		moveq	#3,d1
		move.w	#$38,d2
		bsr.w	ObjectFragment

loc_D580:
		bsr.w	SpeedToPos
		addi.w	#$38,$12(a0)
		bsr.w	DisplaySprite
		tst.b	1(a0)
		bpl.w	DeleteObject
		rts