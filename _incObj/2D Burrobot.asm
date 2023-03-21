; ---------------------------------------------------------------------------

ObjBurrobot:
		moveq	#0,d0
		move.b	$24(a0),d0
		move.w	off_8CFC(pc,d0.w),d1
		jmp	off_8CFC(pc,d1.w)
; ---------------------------------------------------------------------------

off_8CFC:	dc.w loc_8D02-off_8CFC, loc_8D56-off_8CFC, loc_8E46-off_8CFC
; ---------------------------------------------------------------------------

loc_8D02:
		move.b	#$13,$16(a0)
		move.b	#8,$17(a0)
		move.l	#MapBurrobot,4(a0)
		move.w	#$239C,2(a0)
		move.b	#4,1(a0)
		move.b	#4,$19(a0)
		move.b	#5,$20(a0)
		move.b	#$C,$18(a0)
		bset	#0,$22(a0)
		bsr.w	ObjectFall
		bsr.w	ObjectHitFloor
		tst.w	d1
		bpl.s	locret_8D54
		add.w	d1,$C(a0)
		move.w	#0,$12(a0)
		addq.b	#2,$24(a0)

locret_8D54:
		rts
; ---------------------------------------------------------------------------

loc_8D56:
		moveq	#0,d0
		move.b	$25(a0),d0
		move.w	off_8D72(pc,d0.w),d1
		jsr	off_8D72(pc,d1.w)
		lea	(AniBurrobot).l,a1
		bsr.w	ObjectAnimate
		bra.w	ObjectChkDespawn
; ---------------------------------------------------------------------------

off_8D72:	dc.w loc_8D78-off_8D72, loc_8DA2-off_8D72, loc_8E10-off_8D72
; ---------------------------------------------------------------------------

loc_8D78:
		subq.w	#1,$30(a0)
		bpl.s	locret_8DA0
		addq.b	#2,$25(a0)
		move.w	#$FF,$30(a0)
		move.w	#$80,$10(a0)
		move.b	#1,$1C(a0)
		bchg	#0,$22(a0)
		beq.s	locret_8DA0
		neg.w	$10(a0)

locret_8DA0:
		rts
; ---------------------------------------------------------------------------

loc_8DA2:
		subq.w	#1,$30(a0)
		bmi.s	loc_8DDE
		bsr.w	SpeedToPos
		bchg	#0,$32(a0)
		bne.s	loc_8DD4
		move.w	8(a0),d3
		addi.w	#$C,d3
		btst	#0,$22(a0)
		bne.s	loc_8DC8
		subi.w	#$18,d3

loc_8DC8:
		bsr.w	ObjectHitFloor2
		cmpi.w	#$C,d1
		bge.s	loc_8DDE
		rts
; ---------------------------------------------------------------------------

loc_8DD4:
		bsr.w	ObjectHitFloor
		add.w	d1,$C(a0)
		rts
; ---------------------------------------------------------------------------

loc_8DDE:
		btst	#2,(byte_FFFE0F).w
		beq.s	loc_8DFE
		subq.b	#2,$25(a0)
		move.w	#$3B,$30(a0)
		move.w	#0,$10(a0)
		move.b	#0,$1C(a0)
		rts
; ---------------------------------------------------------------------------

loc_8DFE:
		addq.b	#2,$25(a0)
		move.w	#$FC00,$12(a0)
		move.b	#2,$1C(a0)
		rts
; ---------------------------------------------------------------------------

loc_8E10:
		bsr.w	SpeedToPos
		addi.w	#$18,$12(a0)
		bmi.s	locret_8E44
		move.b	#3,$1C(a0)
		bsr.w	ObjectHitFloor
		tst.w	d1
		bpl.s	locret_8E44
		add.w	d1,$C(a0)
		move.w	#0,$12(a0)
		move.b	#1,$1C(a0)
		move.w	#$FF,$30(a0)
		subq.b	#2,$25(a0)

locret_8E44:
		rts
; ---------------------------------------------------------------------------

loc_8E46:
		bsr.w	DeleteObject
		rts
