; ---------------------------------------------------------------------------

ObjBallhog:
		moveq	#0,d0
		move.b	$24(a0),d0
		move.w	off_6F3E(pc,d0.w),d1
		jmp	off_6F3E(pc,d1.w)
; ---------------------------------------------------------------------------

off_6F3E:	dc.w loc_6F46-off_6F3E, loc_6F96-off_6F3E, loc_7056-off_6F3E, loc_705C-off_6F3E
; ---------------------------------------------------------------------------

loc_6F46:
		move.b	#$13,$16(a0)
		move.b	#8,$17(a0)
		move.l	#MapBallhog,4(a0)
		move.w	#$2400,2(a0)
		move.b	#4,1(a0)
		move.b	#4,$19(a0)
		move.b	#5,$20(a0)
		move.b	#$C,$18(a0)
		bsr.w	ObjectFall
		jsr	(ObjectHitFloor).l
		tst.w	d1
		bpl.s	locret_6F94
		add.w	d1,$C(a0)
		move.w	#0,$12(a0)
		addq.b	#2,$24(a0)

locret_6F94:
		rts
; ---------------------------------------------------------------------------

loc_6F96:
		moveq	#0,d0
		move.b	$25(a0),d0
		move.w	off_6FB2(pc,d0.w),d1
		jsr	off_6FB2(pc,d1.w)
		lea	(AniBallhog).l,a1
		bsr.w	ObjectAnimate
		bra.w	ObjectChkDespawn
; ---------------------------------------------------------------------------

off_6FB2:	dc.w loc_6FB6-off_6FB2, loc_701C-off_6FB2
; ---------------------------------------------------------------------------

loc_6FB6:
		subq.w	#1,$30(a0)
		bpl.s	loc_6FE6
		addq.b	#2,$25(a0)
		move.w	#$FF,$30(a0)
		move.w	#$40,$10(a0)
		move.b	#1,$1C(a0)
		bchg	#0,$22(a0)
		bne.s	loc_6FDE
		neg.w	$10(a0)

loc_6FDE:
		move.b	#0,$32(a0)
		rts
; ---------------------------------------------------------------------------

loc_6FE6:
		tst.b	$32(a0)
		bne.s	locret_6FF4
		cmpi.b	#2,$1A(a0)
		beq.s	loc_6FF6

locret_6FF4:
		rts
; ---------------------------------------------------------------------------

loc_6FF6:
		move.b	#1,$32(a0)
		bsr.w	ObjectLoad
		bne.s	locret_701A
		move.b	#$20,0(a1)
		move.w	8(a0),8(a1)
		move.w	$C(a0),$C(a1)
		addi.w	#$10,$C(a1)

locret_701A:
		rts
; ---------------------------------------------------------------------------

loc_701C:
		subq.w	#1,$30(a0)
		bmi.s	loc_7032
		bsr.w	SpeedToPos
		jsr	ObjectHitFloor
		add.w	d1,$C(a0)
		rts
; ---------------------------------------------------------------------------

loc_7032:
		subq.b	#2,$25(a0)
		move.w	#$3B,$30(a0)
		move.w	#0,$10(a0)
		move.b	#0,$1C(a0)
		tst.b	1(a0)
		bpl.s	locret_7054
		move.b	#2,$1C(a0)

locret_7054:
		rts
; ---------------------------------------------------------------------------

loc_7056:
		bsr.w	DisplaySprite
		rts
; ---------------------------------------------------------------------------

loc_705C:
		bsr.w	DeleteObject
		rts
