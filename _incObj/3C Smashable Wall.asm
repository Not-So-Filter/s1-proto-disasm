; ---------------------------------------------------------------------------

ObjSmashWall:
		moveq	#0,d0
		move.b	$24(a0),d0
		move.w	off_ADEA(pc,d0.w),d1
		jsr	off_ADEA(pc,d1.w)
		bra.w	ObjectChkDespawn
; ---------------------------------------------------------------------------

off_ADEA:	dc.w loc_ADF0-off_ADEA, loc_AE1A-off_ADEA, loc_AE92-off_ADEA
; ---------------------------------------------------------------------------

loc_ADF0:
		addq.b	#2,$24(a0)
		move.l	#MapSmashWall,4(a0)
		move.w	#$450F,2(a0)
		move.b	#4,1(a0)
		move.b	#$10,$18(a0)
		move.b	#4,$19(a0)
		move.b	$28(a0),$1A(a0)

loc_AE1A:
		move.w	(v_objspace+$10).w,$30(a0)
		move.w	#$1B,d1
		move.w	#$20,d2
		move.w	#$20,d3
		move.w	8(a0),d4
		bsr.w	SolidObject
		btst	#5,$22(a0)
		bne.s	loc_AE3E

locret_AE3C:
		rts
; ---------------------------------------------------------------------------

loc_AE3E:
		cmpi.b	#2,$1C(a1)
		bne.s	locret_AE3C
		move.w	$30(a0),d0
		bpl.s	loc_AE4E
		neg.w	d0

loc_AE4E:
		cmpi.w	#$480,d0
		bcs.s	locret_AE3C
		move.w	$30(a0),$10(a1)
		addq.w	#4,8(a1)
		lea	(ObjSmashWall_FragRight).l,a4
		move.w	8(a0),d0
		cmp.w	8(a1),d0
		bcs.s	loc_AE78
		subq.w	#8,8(a1)
		lea	(ObjSmashWall_FragLeft).l,a4

loc_AE78:
		move.w	$10(a1),$14(a1)
		bclr	#5,$22(a0)
		bclr	#5,$22(a1)
		moveq	#7,d1
		move.w	#$70,d2
		bsr.s	ObjectFragment

loc_AE92:
		bsr.w	SpeedToPos
		addi.w	#$70,$12(a0)
		bsr.w	DisplaySprite
		tst.b	1(a0)
		bpl.w	DeleteObject
		rts
