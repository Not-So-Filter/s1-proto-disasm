; ---------------------------------------------------------------------------

SolidObject:
		cmpi.b	#6,(v_player+objRoutine).w
		bcc.w	loc_A2FE
		tst.b	obj2ndRout(a0)
		beq.w	loc_A37C
		move.w	d1,d2
		add.w	d2,d2
		lea	(v_objspace).w,a1
		btst	#1,objStatus(a1)
		bne.s	loc_A2EE
		move.w	objX(a1),d0
		sub.w	objX(a0),d0
		add.w	d1,d0
		bmi.s	loc_A2EE
		cmp.w	d2,d0
		bcs.s	loc_A302

loc_A2EE:
		bclr	#3,objStatus(a1)
		bclr	#3,objStatus(a0)
		clr.b	obj2ndRout(a0)

loc_A2FE:
		moveq	#0,d4
		rts
; ---------------------------------------------------------------------------

loc_A302:
		move.w	d4,d2
		bsr.w	PtfmSurfaceHeight
		moveq	#0,d4
		rts
; ---------------------------------------------------------------------------

loc_A30C:
		tst.w	(v_debuguse).w
		bne.w	loc_A448
		tst.b	objRender(a0)
		bpl.w	loc_A42E
		lea	(v_objspace).w,a1
		move.w	objX(a1),d0
		sub.w	objX(a0),d0
		add.w	d1,d0
		bmi.w	loc_A42E
		move.w	d1,d3
		add.w	d3,d3
		cmp.w	d3,d0
		bhi.w	loc_A42E
		move.w	d0,d5
		btst	#0,objRender(a0)
		beq.s	loc_A346
		not.w	d5
		add.w	d3,d5

loc_A346:
		lsr.w	#1,d5
		moveq	#0,d3
		move.b	(a2,d5.w),d3
		sub.b	(a2),d3
		move.w	objY(a0),d5
		sub.w	d3,d5
		move.b	objHeight(a1),d3
		ext.w	d3
		add.w	d3,d2
		move.w	objY(a1),d3
		sub.w	d5,d3
		addq.w	#4,d3
		add.w	d2,d3
		bmi.w	loc_A42E
		subq.w	#4,d3
		move.w	d2,d4
		add.w	d4,d4
		cmp.w	d4,d3
		bcc.w	loc_A42E
		bra.w	loc_A3CC
; ---------------------------------------------------------------------------

loc_A37C:
		tst.w	(v_debuguse).w
		bne.w	loc_A448
		tst.b	objRender(a0)
		bpl.w	loc_A42E
		lea	(v_objspace).w,a1
		move.w	objX(a1),d0
		sub.w	objX(a0),d0
		add.w	d1,d0
		bmi.w	loc_A42E
		move.w	d1,d3
		add.w	d3,d3
		cmp.w	d3,d0
		bhi.w	loc_A42E
		move.b	objHeight(a1),d3
		ext.w	d3
		add.w	d3,d2
		move.w	objY(a1),d3
		sub.w	objY(a0),d3
		addq.w	#4,d3
		add.w	d2,d3
		bmi.w	loc_A42E
		subq.w	#4,d3
		move.w	d2,d4
		add.w	d4,d4
		cmp.w	d4,d3
		bcc.w	loc_A42E

loc_A3CC:
		move.w	d0,d5
		cmp.w	d0,d1
		bcc.s	loc_A3DA
		add.w	d1,d1
		sub.w	d1,d0
		move.w	d0,d5
		neg.w	d5

loc_A3DA:
		move.w	d3,d1
		cmp.w	d3,d2
		bcc.s	loc_A3E6
		sub.w	d4,d3
		move.w	d3,d1
		neg.w	d1

loc_A3E6:
		cmp.w	d1,d5
		bhi.w	loc_A44C
		tst.w	d0
		beq.s	loc_A40C
		bmi.s	loc_A3FA
		tst.w	objVelX(a1)
		bmi.s	loc_A40C
		bra.s	loc_A400
; ---------------------------------------------------------------------------

loc_A3FA:
		tst.w	objVelX(a1)
		bpl.s	loc_A40C

loc_A400:
		move.w	#0,objInertia(a1)
		move.w	#0,objVelX(a1)

loc_A40C:
		sub.w	d0,objX(a1)
		btst	#1,objStatus(a1)
		bne.s	loc_A428
		bset	#5,objStatus(a1)
		bset	#5,objStatus(a0)
		moveq	#1,d4
		rts
; ---------------------------------------------------------------------------

loc_A428:
		bsr.s	sub_A43C
		moveq	#1,d4
		rts
; ---------------------------------------------------------------------------

loc_A42E:
		btst	#5,objStatus(a0)
		beq.s	loc_A448
		move.w	#id_Run,objAnim(a1)

sub_A43C:
		bclr	#5,objStatus(a0)
		bclr	#5,objStatus(a1)

loc_A448:
		moveq	#0,d4
		rts
; ---------------------------------------------------------------------------

loc_A44C:
		tst.w	d3
		bmi.s	loc_A458

loc_A450:
		cmpi.w	#$10,d3
		bcs.s	loc_A488
		bra.s	loc_A42E
; ---------------------------------------------------------------------------

loc_A458:
		tst.w	objVelY(a1)
		beq.s	loc_A472
		bpl.s	loc_A46E
		tst.w	d3
		bpl.s	loc_A46E
		sub.w	d3,objY(a1)
		move.w	#0,objVelY(a1)

loc_A46E:
		moveq	#-1,d4
		rts
; ---------------------------------------------------------------------------

loc_A472:
		btst	#1,objStatus(a1)
		bne.s	loc_A46E
		move.l	a0,-(sp)
		movea.l	a1,a0
		bsr.w	loc_FD78
		movea.l	(sp)+,a0
		moveq	#-1,d4
		rts
; ---------------------------------------------------------------------------

loc_A488:
		moveq	#0,d1
		move.b	objActWid(a0),d1
		addq.w	#4,d1
		move.w	d1,d2
		add.w	d2,d2
		add.w	objX(a1),d1
		sub.w	objX(a0),d1
		bmi.s	loc_A4C4
		cmp.w	d2,d1
		bcc.s	loc_A4C4
		tst.w	objVelY(a1)
		bmi.s	loc_A4C4
		sub.w	d3,objY(a1)
		subq.w	#1,objY(a1)
		bsr.w	loc_4FD4
		move.b	#2,obj2ndRout(a0)
		bset	#3,objStatus(a0)
		moveq	#-1,d4
		rts
; ---------------------------------------------------------------------------

loc_A4C4:
		moveq	#0,d4
		rts