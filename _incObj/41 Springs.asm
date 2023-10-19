; ---------------------------------------------------------------------------

ObjSpring:
		moveq	#0,d0
		move.b	objRoutine(a0),d0
		move.w	off_BAA0(pc,d0.w),d1
		jsr	off_BAA0(pc,d1.w)
		bsr.w	DisplaySprite
		out_of_range.w	DeleteObject
		rts
; ---------------------------------------------------------------------------

off_BAA0:	dc.w loc_BAB8-off_BAA0, sub_BB2E-off_BAA0, loc_BB84-off_BAA0, sub_BB8E-off_BAA0, sub_BB9A-off_BAA0
		dc.w loc_BC1C-off_BAA0, sub_BC26-off_BAA0, loc_BC32-off_BAA0, loc_BC98-off_BAA0, loc_BCA2-off_BAA0

word_BAB4:	dc.w -$1000, -$A00
; ---------------------------------------------------------------------------

loc_BAB8:
		addq.b	#2,objRoutine(a0)
		move.l	#Map_Spring,objMap(a0)
		move.w	#$523,objGfx(a0)
		ori.b	#4,objRender(a0)
		move.b	#$10,objActWid(a0)
		move.b	#4,objPriority(a0)
		move.b	objSubtype(a0),d0
		btst	#4,d0
		beq.s	loc_BB04
		move.b	#8,objRoutine(a0)
		move.b	#1,objAnim(a0)
		move.b	#3,objFrame(a0)
		move.w	#$533,objGfx(a0)
		move.b	#8,objActWid(a0)

loc_BB04:
		btst	#5,d0
		beq.s	loc_BB16
		move.b	#$E,objRoutine(a0)
		bset	#1,objStatus(a0)

loc_BB16:
		btst	#1,d0
		beq.s	loc_BB22
		bset	#5,2(a0)

loc_BB22:
		andi.w	#$F,d0
		move.w	word_BAB4(pc,d0.w),$30(a0)
		rts
; ---------------------------------------------------------------------------

sub_BB2E:
		move.w	#$1B,d1
		move.w	#8,d2
		move.w	#$10,d3
		move.w	objX(a0),d4
		bsr.w	SolidObject
		tst.b	obj2ndRout(a0)
		bne.s	loc_BB4A
		rts
; ---------------------------------------------------------------------------

loc_BB4A:
		addq.b	#2,objRoutine(a0)
		addq.w	#8,objY(a1)
		move.w	$30(a0),objVelY(a1)
		bset	#1,objStatus(a1)
		bclr	#3,objStatus(a1)
		move.b	#$10,objAnim(a1)
		move.b	#2,objRoutine(a1)
		bclr	#3,objStatus(a0)
		clr.b	obj2ndRout(a0)
		move.w	#sfx_Spring,d0
		jsr	(PlaySound_Special).l

loc_BB84:
		lea	(Ani_Spring).l,a1
		bra.w	AnimateSprite
; ---------------------------------------------------------------------------

sub_BB8E:
		move.b	#1,objNextAni(a0)
		subq.b	#4,objRoutine(a0)
		rts
; ---------------------------------------------------------------------------

sub_BB9A:
		move.w	#$13,d1
		move.w	#$E,d2
		move.w	#$F,d3
		move.w	objX(a0),d4
		bsr.w	SolidObject
		cmpi.b	#2,objRoutine(a0)
		bne.s	loc_BBBC
		move.b	#8,objRoutine(a0)

loc_BBBC:
		btst	#5,objStatus(a0)
		bne.s	loc_BBC6
		rts
; ---------------------------------------------------------------------------

loc_BBC6:
		addq.b	#2,objRoutine(a0)
		move.w	$30(a0),objVelX(a1)
		addq.w	#8,objX(a1)
		btst	#0,objStatus(a0)
		bne.s	loc_BBE6
		subi.w	#$10,objX(a1)
		neg.w	objVelX(a1)

loc_BBE6:
		move.w	#$F,$3E(a1)
		move.w	objVelX(a1),objInertia(a1)
		bchg	#0,objStatus(a1)
		btst	#2,objStatus(a1)
		bne.s	loc_BC06
		move.b	#0,objAnim(a1)

loc_BC06:
		bclr	#5,objStatus(a0)
		bclr	#5,objStatus(a1)
		move.w	#sfx_Spring,d0
		jsr	(PlaySound_Special).l

loc_BC1C:
		lea	(Ani_Spring).l,a1
		bra.w	AnimateSprite
; ---------------------------------------------------------------------------

sub_BC26:
		move.b	#2,objNextAni(a0)
		subq.b	#4,objRoutine(a0)
		rts
; ---------------------------------------------------------------------------

loc_BC32:
		move.w	#$1B,d1
		move.w	#8,d2
		move.w	#$10,d3
		move.w	objX(a0),d4
		bsr.w	SolidObject
		cmpi.b	#2,objRoutine(a0)
		bne.s	loc_BC54
		move.b	#$E,objRoutine(a0)

loc_BC54:
		tst.b	obj2ndRout(a0)
		bne.s	locret_BC5E
		tst.w	d4
		bmi.s	loc_BC60

locret_BC5E:
		rts
; ---------------------------------------------------------------------------

loc_BC60:
		addq.b	#2,objRoutine(a0)
		subq.w	#8,objY(a1)
		move.w	$30(a0),objVelY(a1)
		neg.w	objVelY(a1)
		bset	#1,objStatus(a1)
		bclr	#3,objStatus(a1)
		move.b	#2,objRoutine(a1)
		bclr	#3,objStatus(a0)
		clr.b	obj2ndRout(a0)
		move.w	#sfx_Spring,d0
		jsr	(PlaySound_Special).l

loc_BC98:
		lea	(Ani_Spring).l,a1
		bra.w	AnimateSprite
; ---------------------------------------------------------------------------

loc_BCA2:
		move.b	#1,objNextAni(a0)
		subq.b	#4,objRoutine(a0)
		rts
