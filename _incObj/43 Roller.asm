; ---------------------------------------------------------------------------

ObjRoller:
		moveq	#0,d0
		move.b	$24(a0),d0
		move.w	off_BFB8(pc,d0.w),d1
		jmp	off_BFB8(pc,d1.w)
; ---------------------------------------------------------------------------

off_BFB8:	dc.w loc_BFBE-off_BFB8, loc_C00C-off_BFB8, loc_C0B0-off_BFB8
; ---------------------------------------------------------------------------

loc_BFBE:
		move.b	#$E,$16(a0)
		move.b	#8,$17(a0)
		bsr.w	ObjectFall
		bsr.w	ObjectHitFloor
		tst.w	d1
		bpl.s	locret_C00A
		add.w	d1,$C(a0)
		move.w	#0,$12(a0)
		addq.b	#2,$24(a0)
		move.l	#MapRoller,4(a0)
		move.w	#$24B8,2(a0)
		move.b	#4,1(a0)
		move.b	#4,$19(a0)
		move.b	#$10,$18(a0)
		move.b	#$8E,$20(a0)

locret_C00A:
		rts
; ---------------------------------------------------------------------------

loc_C00C:
		moveq	#0,d0
		move.b	$25(a0),d0
		move.w	off_C028(pc,d0.w),d1
		jsr	off_C028(pc,d1.w)
		lea	(AniRoller).l,a1
		bsr.w	AnimateSprite
		bra.w	RememberState
; ---------------------------------------------------------------------------

off_C028:	dc.w loc_C030-off_C028, loc_C052-off_C028, loc_C060-off_C028, loc_C08E-off_C028
; ---------------------------------------------------------------------------

loc_C030:
		move.w	(v_objspace+8).w,d0
		sub.w	8(a0),d0
		bcs.s	locret_C050
		cmpi.w	#$20,d0
		bcc.s	locret_C050
		addq.b	#2,$25(a0)
		move.b	#1,$1C(a0)
		move.w	#$400,$10(a0)

locret_C050:
		rts
; ---------------------------------------------------------------------------

loc_C052:
		cmpi.b	#2,$1C(a0)
		bne.s	locret_C05E
		addq.b	#2,$25(a0)

locret_C05E:
		rts
; ---------------------------------------------------------------------------

loc_C060:
		bsr.w	SpeedToPos
		bsr.w	ObjectHitFloor
		cmpi.w	#$FFF8,d1
		blt.s	loc_C07A
		cmpi.w	#$C,d1
		bge.s	loc_C07A
		add.w	d1,$C(a0)
		rts
; ---------------------------------------------------------------------------

loc_C07A:
		addq.b	#2,$25(a0)
		bset	#0,$32(a0)
		beq.s	locret_C08C
		move.w	#$FA00,$12(a0)

locret_C08C:
		rts
; ---------------------------------------------------------------------------

loc_C08E:
		bsr.w	ObjectFall
		tst.w	$12(a0)
		bmi.s	locret_C0AE
		bsr.w	ObjectHitFloor
		tst.w	d1
		bpl.s	locret_C0AE
		add.w	d1,$C(a0)
		subq.b	#2,$25(a0)

loc_C0A8:
		move.w	#0,$12(a0)

locret_C0AE:
		rts
; ---------------------------------------------------------------------------

loc_C0B0:
		bra.w	DeleteObject