; ---------------------------------------------------------------------------

Obj4F:
		moveq	#0,d0
		move.b	$24(a0),d0
		move.w	off_D202(pc,d0.w),d1
		jmp	off_D202(pc,d1.w)
; ---------------------------------------------------------------------------

off_D202:	dc.w loc_D20A-off_D202, loc_D246-off_D202, loc_D274-off_D202, loc_D2C8-off_D202
; ---------------------------------------------------------------------------

loc_D20A:
		addq.b	#2,$24(a0)
		move.l	#Map4F,obMap(a0)
		move.w	#$24E4,obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#4,obPriority(a0)
		move.b	#$C,obActWid(a0)
		move.b	#$14,$16(a0)
		move.b	#2,$20(a0)
		tst.b	obSubtype(a0)
		beq.s	loc_D246
		move.w	#$300,d2
		bra.s	loc_D24A
; ---------------------------------------------------------------------------

loc_D246:
		move.w	#$E0,d2

loc_D24A:
		move.w	#$100,d1
		bset	#0,obRender(a0)
		move.w	(v_objspace+8).w,d0
		sub.w	obX(a0),d0
		bcc.s	loc_D268
		neg.w	d0
		neg.w	d1
		bclr	#0,obRender(a0)

loc_D268:
		cmp.w	d2,d0
		bcc.s	loc_D274
		move.w	d1,obVelX(a0)
		addq.b	#2,$24(a0)

loc_D274:
		bsr.w	ObjectFall
		move.b	#1,obFrame(a0)
		tst.w	obVelY(a0)
		bmi.s	loc_D2AE
		move.b	#0,obFrame(a0)
		bsr.w	ObjectHitFloor
		tst.w	d1
		bpl.s	loc_D2AE
		move.w	(a1),d0
		andi.w	#$3FF,d0
		cmpi.w	#$2D2,d0
		bcs.s	loc_D2A4
		addq.b	#2,$24(a0)
		bra.s	loc_D2AE
; ---------------------------------------------------------------------------

loc_D2A4:
		add.w	d1,obY(a0)
		move.w	#-$400,obVelY(a0)

loc_D2AE:
		bsr.w	sub_D2DA
		beq.s	loc_D2C4
		neg.w	obVelX(a0)
		bchg	#0,obRender(a0)
		bchg	#0,obStatus(a0)

loc_D2C4:
		bra.w	RememberState
; ---------------------------------------------------------------------------

loc_D2C8:
		bsr.w	ObjectFall
		bsr.w	DisplaySprite
		tst.b	obRender(a0)
		bpl.w	DeleteObject
		rts
; ---------------------------------------------------------------------------

sub_D2DA:
		move.w	(LevelFrames).w,d0
		add.w	d7,d0
		andi.w	#3,d0
		bne.s	loc_D308
		moveq	#0,d3
		move.b	obActWid(a0),d3
		tst.w	obVelX(a0)
		bmi.s	loc_D2FE
		bsr.w	ObjectHitWallRight
		tst.w	d1
		bpl.s	loc_D308

loc_D2FA:
		moveq	#1,d0
		rts
; ---------------------------------------------------------------------------

loc_D2FE:
		not.w	d3
		bsr.w	ObjectHitWallLeft
		tst.w	d1
		bmi.s	loc_D2FA

loc_D308:
		moveq	#0,d0
		rts