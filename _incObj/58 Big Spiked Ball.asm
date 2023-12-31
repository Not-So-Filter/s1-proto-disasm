; ---------------------------------------------------------------------------

ObjGiantSpikedBalls:
		moveq	#0,d0
		move.b	obj.Routine(a0),d0
		move.w	ObjGiantBalls_Index(pc,d0.w),d1
		jmp	ObjGiantBalls_Index(pc,d1.w)
; ---------------------------------------------------------------------------

ObjGiantBalls_Index:dc.w ObjGiantBalls_Init-ObjGiantBalls_Index, ObjGiantBalls_Move-ObjGiantBalls_Index
; ---------------------------------------------------------------------------

ObjGiantBalls_Init:
		addq.b	#2,obj.Routine(a0)
		move.l	#MapGiantSpikedBalls,obj.Map(a0)
		move.w	#$396,obj.Gfx(a0)
		move.b	#4,obj.Render(a0)
		move.b	#4,obj.Priority(a0)
		move.b	#$18,obj.ActWid(a0)
		move.w	obj.Xpos(a0),$3A(a0)
		move.w	obj.Ypos(a0),$38(a0)
		move.b	#$86,obj.ColType(a0)
		move.b	obj.Subtype(a0),d1
		andi.b	#$F0,d1
		ext.w	d1
		asl.w	#3,d1
		move.w	d1,$3E(a0)
		move.b	obj.Status(a0),d0
		ror.b	#2,d0
		andi.b	#$C0,d0
		move.b	d0,obj.Angle(a0)
		move.b	#$50,$3C(a0)

ObjGiantBalls_Move:
		moveq	#0,d0
		move.b	obj.Subtype(a0),d0
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
		move.b	(v_oscillate+$E).w,d0
		btst	#0,obj.Status(a0)
		beq.s	loc_DED6
		neg.w	d0
		add.w	d1,d0

loc_DED6:
		move.w	$3A(a0),d1
		sub.w	d0,d1
		move.w	d1,obj.Xpos(a0)
		rts
; ---------------------------------------------------------------------------

ObjGiantBalls_Type02:
		move.w	#$60,d1
		moveq	#0,d0
		move.b	(v_oscillate+$E).w,d0
		btst	#0,obj.Status(a0)
		beq.s	loc_DEFA
		neg.w	d0
		addi.w	#$80,d0

loc_DEFA:
		move.w	$38(a0),d1
		sub.w	d0,d1
		move.w	d1,obj.Ypos(a0)
		rts
; ---------------------------------------------------------------------------

ObjGiantBalls_Type03:
		move.w	$3E(a0),d0
		add.w	d0,obj.Angle(a0)
		move.b	obj.Angle(a0),d0
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
		move.w	d4,obj.Ypos(a0)
		move.w	d5,obj.Xpos(a0)
		rts