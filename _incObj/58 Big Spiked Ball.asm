; ---------------------------------------------------------------------------

ObjGiantSpikedBalls:
		moveq	#0,d0
		move.b	$24(a0),d0
		move.w	ObjGiantBalls_Index(pc,d0.w),d1
		jmp	ObjGiantBalls_Index(pc,d1.w)
; ---------------------------------------------------------------------------

ObjGiantBalls_Index:dc.w ObjGiantBalls_Init-ObjGiantBalls_Index, ObjGiantBalls_Move-ObjGiantBalls_Index
; ---------------------------------------------------------------------------

ObjGiantBalls_Init:
		addq.b	#2,$24(a0)
		move.l	#MapGiantSpikedBalls,4(a0)
		move.w	#$396,2(a0)
		move.b	#4,1(a0)
		move.b	#4,$19(a0)
		move.b	#$18,$18(a0)
		move.w	8(a0),$3A(a0)
		move.w	$C(a0),$38(a0)
		move.b	#$86,$20(a0)
		move.b	$28(a0),d1
		andi.b	#$F0,d1
		ext.w	d1
		asl.w	#3,d1
		move.w	d1,$3E(a0)
		move.b	$22(a0),d0
		ror.b	#2,d0
		andi.b	#$C0,d0
		move.b	d0,$26(a0)
		move.b	#$50,$3C(a0)

ObjGiantBalls_Move:
		moveq	#0,d0
		move.b	$28(a0),d0
		andi.w	#7,d0
		add.w	d0,d0
		move.w	ObjGiantBalls_TypeIndex(pc,d0.w),d1
		jsr	ObjGiantBalls_TypeIndex(pc,d1.w)
		out_of_range.w	DeleteObject,$3A(a0)
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

ObjGiantBalls_TypeIndex:dc.w ObjGiantBalls_Type00-ObjGiantBalls_TypeIndex, ObjGiantBalls_Type01-ObjGiantBalls_TypeIndex, ObjGiantBalls_Type02-ObjGiantBalls_TypeIndex, ObjGiantBalls_Type03-ObjGiantBalls_TypeIndex
; ---------------------------------------------------------------------------

ObjGiantBalls_Type00:
		rts
; ---------------------------------------------------------------------------

ObjGiantBalls_Type01:
		move.w	#$60,d1
		moveq	#0,d0
		move.b	(oscValues+$E).w,d0
		btst	#0,$22(a0)
		beq.s	loc_DED6
		neg.w	d0
		add.w	d1,d0

loc_DED6:
		move.w	$3A(a0),d1
		sub.w	d0,d1
		move.w	d1,8(a0)
		rts
; ---------------------------------------------------------------------------

ObjGiantBalls_Type02:
		move.w	#$60,d1
		moveq	#0,d0
		move.b	(oscValues+$E).w,d0
		btst	#0,$22(a0)
		beq.s	loc_DEFA
		neg.w	d0
		addi.w	#$80,d0

loc_DEFA:
		move.w	$38(a0),d1
		sub.w	d0,d1
		move.w	d1,$C(a0)
		rts
; ---------------------------------------------------------------------------

ObjGiantBalls_Type03:
		move.w	$3E(a0),d0
		add.w	d0,$26(a0)
		move.b	$26(a0),d0
		jsr	(CalcSine).l
		move.w	$38(a0),d2
		move.w	$3A(a0),d3
		moveq	#0,d4
		move.b	$3C(a0),d4
		move.l	d4,d5
		muls.w	d0,d4
		asr.l	#8,d4
		muls.w	d1,d5
		asr.l	#8,d5
		add.w	d2,d4
		add.w	d3,d5
		move.w	d4,$C(a0)
		move.w	d5,8(a0)
		rts