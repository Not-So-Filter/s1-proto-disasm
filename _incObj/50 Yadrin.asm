; ---------------------------------------------------------------------------

ObjYadrin:
		moveq	#0,d0
		move.b	$24(a0),d0
		move.w	off_D334(pc,d0.w),d1
		jmp	off_D334(pc,d1.w)
; ---------------------------------------------------------------------------

off_D334:	dc.w loc_D338-off_D334, loc_D38C-off_D334
; ---------------------------------------------------------------------------

loc_D338:
		move.l	#Map_Yadrin,4(a0)
		move.w	#$247B,2(a0)
		move.b	#4,1(a0)
		move.b	#4,$19(a0)
		move.b	#$14,$18(a0)
		move.b	#$11,$16(a0)
		move.b	#8,$17(a0)
		move.b	#$CC,$20(a0)
		bsr.w	ObjectFall
		bsr.w	ObjectHitFloor
		tst.w	d1
		bpl.s	locret_D38A
		add.w	d1,$C(a0)
		move.w	#0,$12(a0)
		addq.b	#2,$24(a0)
		bchg	#0,$22(a0)

locret_D38A:
		rts
; ---------------------------------------------------------------------------

loc_D38C:
		moveq	#0,d0
		move.b	$25(a0),d0
		move.w	off_D3A8(pc,d0.w),d1
		jsr	off_D3A8(pc,d1.w)
		lea	(Ani_Yadrin).l,a1
		bsr.w	AnimateSprite
		bra.w	RememberState
; ---------------------------------------------------------------------------

off_D3A8:	dc.w loc_D3AC-off_D3A8, loc_D3D0-off_D3A8
; ---------------------------------------------------------------------------

loc_D3AC:
		subq.w	#1,$30(a0)
		bpl.s	locret_D3CE
		addq.b	#2,$25(a0)
		move.w	#$FF00,$10(a0)
		move.b	#1,$1C(a0)
		bchg	#0,$22(a0)
		bne.s	locret_D3CE
		neg.w	$10(a0)

locret_D3CE:
		rts
; ---------------------------------------------------------------------------

loc_D3D0:
		bsr.w	SpeedToPos
		bsr.w	ObjectHitFloor
		cmpi.w	#$FFF8,d1
		blt.s	loc_D3F0
		cmpi.w	#$C,d1
		bge.s	loc_D3F0
		add.w	d1,$C(a0)
		bsr.w	sub_D2DA
		bne.s	loc_D3F0
		rts
; ---------------------------------------------------------------------------

loc_D3F0:
		subq.b	#2,$25(a0)
		move.w	#$3B,$30(a0)
		move.w	#0,$10(a0)
		move.b	#0,$1C(a0)
		rts