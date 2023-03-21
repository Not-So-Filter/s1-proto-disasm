; ---------------------------------------------------------------------------

ObjNewtron:
		moveq	#0,d0
		move.b	$24(a0),d0
		move.w	off_BD26(pc,d0.w),d1
		jmp	off_BD26(pc,d1.w)
; ---------------------------------------------------------------------------

off_BD26:	dc.w loc_BD2C-off_BD26, loc_BD5C-off_BD26, loc_BEC6-off_BD26
; ---------------------------------------------------------------------------

loc_BD2C:
		addq.b	#2,$24(a0)
		move.l	#MapNewtron,4(a0)
		move.w	#$249B,2(a0)
		move.b	#4,1(a0)
		move.b	#4,$19(a0)
		move.b	#$14,$18(a0)
		move.b	#$10,$16(a0)
		move.b	#8,$17(a0)

loc_BD5C:
		moveq	#0,d0
		move.b	$25(a0),d0
		move.w	off_BD78(pc,d0.w),d1
		jsr	off_BD78(pc,d1.w)
		lea	(AniNewtron).l,a1
		bsr.w	ObjectAnimate
		bra.w	ObjectChkDespawn
; ---------------------------------------------------------------------------

off_BD78:	dc.w loc_BD82-off_BD78, loc_BDC4-off_BD78, loc_BE38-off_BD78, loc_BE58-off_BD78, loc_BE5E-off_BD78
; ---------------------------------------------------------------------------

loc_BD82:
		bset	#0,$22(a0)
		move.w	(v_objspace+8).w,d0
		sub.w	8(a0),d0
		bcc.s	loc_BD9A
		neg.w	d0
		bclr	#0,$22(a0)

loc_BD9A:
		cmpi.w	#$80,d0
		bcc.s	locret_BDC2
		addq.b	#2,$25(a0)
		move.b	#1,$1C(a0)
		tst.b	$28(a0)
		beq.s	locret_BDC2
		move.w	#$49B,2(a0)
		move.b	#8,$25(a0)
		move.b	#4,$1C(a0)

locret_BDC2:
		rts
; ---------------------------------------------------------------------------

loc_BDC4:
		cmpi.b	#4,$1A(a0)
		bcc.s	loc_BDE4
		bset	#0,$22(a0)
		move.w	(v_objspace+8).w,d0
		sub.w	8(a0),d0
		bcc.s	locret_BDE2
		bclr	#0,$22(a0)

locret_BDE2:
		rts
; ---------------------------------------------------------------------------

loc_BDE4:
		cmpi.b	#1,$1A(a0)
		bne.s	loc_BDF2
		move.b	#$C,$20(a0)

loc_BDF2:
		bsr.w	ObjectFall
		bsr.w	ObjectHitFloor
		tst.w	d1
		bpl.s	locret_BE36
		add.w	d1,$C(a0)
		move.w	#0,$12(a0)
		addq.b	#2,$25(a0)
		move.b	#2,$1C(a0)
		btst	#5,2(a0)
		beq.s	loc_BE1E
		addq.b	#1,$1C(a0)

loc_BE1E:
		move.b	#$D,$20(a0)
		move.w	#$200,$10(a0)
		btst	#0,$22(a0)
		bne.s	locret_BE36
		neg.w	$10(a0)

locret_BE36:
		rts
; ---------------------------------------------------------------------------

loc_BE38:
		bsr.w	SpeedToPos

loc_BE3C:
		bsr.w	ObjectHitFloor
		cmpi.w	#$FFF8,d1
		blt.s	loc_BE52
		cmpi.w	#$C,d1
		bge.s	loc_BE52
		add.w	d1,$C(a0)
		rts
; ---------------------------------------------------------------------------

loc_BE52:
		addq.b	#2,$25(a0)
		rts
; ---------------------------------------------------------------------------

loc_BE58:
		bsr.w	SpeedToPos
		rts
; ---------------------------------------------------------------------------

loc_BE5E:
		cmpi.b	#1,$1A(a0)
		bne.s	loc_BE6C
		move.b	#$C,$20(a0)

loc_BE6C:
		cmpi.b	#2,$1A(a0)
		bne.s	locret_BEC4
		tst.b	$32(a0)
		bne.s	locret_BEC4
		move.b	#1,$32(a0)
		bsr.w	ObjectLoad
		bne.s	locret_BEC4
		move.b	#$23,0(a1)
		move.w	8(a0),8(a1)
		move.w	$C(a0),$C(a1)
		subq.w	#8,$C(a1)
		move.w	#$200,$10(a1)
		move.w	#$14,d0
		btst	#0,$22(a0)
		bne.s	loc_BEB4
		neg.w	d0
		neg.w	$10(a1)

loc_BEB4:
		add.w	d0,8(a1)
		move.b	$22(a0),$22(a1)
		move.b	#1,$28(a1)

locret_BEC4:
		rts
; ---------------------------------------------------------------------------

loc_BEC6:
		bra.w	DeleteObject
