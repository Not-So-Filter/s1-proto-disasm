; ---------------------------------------------------------------------------

ObjLavaHurt:
		moveq	#0,d0
		move.b	$24(a0),d0
		move.w	off_CD2E(pc,d0.w),d1
		jmp	off_CD2E(pc,d1.w)
; ---------------------------------------------------------------------------

off_CD2E:	dc.w loc_CD36-off_CD2E, loc_CD6C-off_CD2E

byte_CD32:	dc.b $96, $94, $95, 0
; ---------------------------------------------------------------------------

loc_CD36:
		addq.b	#2,$24(a0)
		moveq	#0,d0
		move.b	$28(a0),d0
		move.b	byte_CD32(pc,d0.w),$20(a0)
		move.l	#MapLavaHurt,4(a0)
		move.w	#$8680,2(a0)
		move.b	#4,1(a0)
		move.b	#$80,$18(a0)
		move.b	#4,$19(a0)
		move.b	$28(a0),$1A(a0)

loc_CD6C:
		tst.w	(DebugRoutine).w
		beq.s	loc_CD76
		bsr.w	DisplaySprite

loc_CD76:
		cmpi.b	#6,(v_objspace+$24).w
		bcc.s	loc_CD84
		bset	#7,1(a0)

loc_CD84:
		move.w	8(a0),d0
		andi.w	#$FF80,d0
		move.w	(v_screenposx).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0
		bmi.w	DeleteObject
		cmpi.w	#$280,d0
		bhi.w	DeleteObject
		rts