; ---------------------------------------------------------------------------

ObjMotobug:
		moveq	#0,d0
		move.b	$24(a0),d0
		move.w	off_B890(pc,d0.w),d1
		jmp	off_B890(pc,d1.w)
; ---------------------------------------------------------------------------

off_B890:	dc.w loc_B898-off_B890, loc_B8FA-off_B890, loc_B9D8-off_B890, loc_B9E6-off_B890
; ---------------------------------------------------------------------------

loc_B898:
		move.l	#MapMotobug,4(a0)
		move.w	#$4F0,2(a0)
		move.b	#4,1(a0)
		move.b	#4,$19(a0)
		move.b	#$14,$18(a0)
		tst.b	$1C(a0)
		bne.s	loc_B8F2
		move.b	#$E,$16(a0)
		move.b	#8,$17(a0)
		move.b	#$C,$20(a0)
		bsr.w	ObjectFall
		bsr.w	ObjectHitFloor
		tst.w	d1
		bpl.s	locret_B8F0
		add.w	d1,$C(a0)
		move.w	#0,$12(a0)
		addq.b	#2,$24(a0)
		bchg	#0,$22(a0)

locret_B8F0:
		rts
; ---------------------------------------------------------------------------

loc_B8F2:
		addq.b	#4,$24(a0)
		bra.w	loc_B9D8
; ---------------------------------------------------------------------------

loc_B8FA:
		moveq	#0,d0
		move.b	$25(a0),d0
		move.w	off_B94E(pc,d0.w),d1
		jsr	off_B94E(pc,d1.w)
		lea	(AniMotobug).l,a1
		bsr.w	ObjectAnimate
		
		include "_incObj\sub RememberState.asm"
; ---------------------------------------------------------------------------

off_B94E:	dc.w loc_B952-off_B94E, loc_B976-off_B94E
; ---------------------------------------------------------------------------

loc_B952:
		subq.w	#1,$30(a0)
		bpl.s	locret_B974
		addq.b	#2,$25(a0)
		move.w	#$FF00,$10(a0)
		move.b	#1,$1C(a0)
		bchg	#0,$22(a0)
		bne.s	locret_B974
		neg.w	$10(a0)

locret_B974:
		rts
; ---------------------------------------------------------------------------

loc_B976:
		bsr.w	SpeedToPos
		bsr.w	ObjectHitFloor
		cmpi.w	#$FFF8,d1
		blt.s	loc_B9C0
		cmpi.w	#$C,d1
		bge.s	loc_B9C0
		add.w	d1,$C(a0)
		subq.b	#1,$33(a0)
		bpl.s	locret_B9BE
		move.b	#$F,$33(a0)
		bsr.w	ObjectLoad
		bne.s	locret_B9BE
		move.b	#$40,0(a1)
		move.w	8(a0),8(a1)
		move.w	$C(a0),$C(a1)
		move.b	$22(a0),$22(a1)
		move.b	#2,$1C(a1)

locret_B9BE:
		rts
; ---------------------------------------------------------------------------

loc_B9C0:
		subq.b	#2,$25(a0)
		move.w	#$3B,$30(a0)
		move.w	#0,$10(a0)
		move.b	#0,$1C(a0)
		rts
; ---------------------------------------------------------------------------

loc_B9D8:
		lea	(AniMotobug).l,a1
		bsr.w	ObjectAnimate
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

loc_B9E6:
		bra.w	DeleteObject
