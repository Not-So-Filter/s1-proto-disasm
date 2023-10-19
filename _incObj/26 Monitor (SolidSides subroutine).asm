; ---------------------------------------------------------------------------

sub_83B4:
		tst.w	(v_debuguse).w
		bne.w	loc_8400
		lea	(v_objspace).w,a1
		move.w	objX(a1),d0
		sub.w	objX(a0),d0
		add.w	d1,d0
		bmi.s	loc_8400
		move.w	d1,d3
		add.w	d3,d3
		cmp.w	d3,d0
		bhi.s	loc_8400
		move.b	objHeight(a1),d3
		ext.w	d3
		add.w	d3,d2
		move.w	objY(a1),d3
		sub.w	objY(a0),d3
		add.w	d2,d3
		bmi.s	loc_8400
		add.w	d2,d2
		cmp.w	d2,d3
		bcc.s	loc_8400
		cmp.w	d0,d1
		bcc.s	loc_83F6
		add.w	d1,d1
		sub.w	d1,d0

loc_83F6:
		cmpi.w	#$10,d3
		bcs.s	loc_8404

loc_83FC:
		moveq	#1,d1
		rts
; ---------------------------------------------------------------------------

loc_8400:
		moveq	#0,d1
		rts
; ---------------------------------------------------------------------------

loc_8404:
		moveq	#0,d1
		move.b	objActWid(a0),d1
		addq.w	#4,d1
		move.w	d1,d2
		add.w	d2,d2
		add.w	objX(a1),d1
		sub.w	objX(a0),d1
		bmi.s	loc_83FC
		cmp.w	d2,d1
		bcc.s	loc_83FC
		moveq	#-1,d1
		rts