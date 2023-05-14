; ---------------------------------------------------------------------------

sub_101BE:
		bsr.s	Floor_ChkTile
		move.w	(a1),d0
		move.w	d0,d4
		andi.w	#$7FF,d0
		beq.s	loc_101CE
		btst	d5,d4
		bne.s	loc_101DC

loc_101CE:
		add.w	a3,d2
		bsr.w	sub_10264
		sub.w	a3,d2
		addi.w	#$10,d1
		rts
; ---------------------------------------------------------------------------

loc_101DC:
		movea.l	(v_collindex).w,a2
		move.b	(a2,d0.w),d0
		andi.w	#$FF,d0
		beq.s	loc_101CE
		lea	(colAngles).l,a2
		move.b	(a2,d0.w),(a4)
		lsl.w	#4,d0
		move.w	d3,d1
		btst	#$B,d4
		beq.s	loc_10202
		not.w	d1
		neg.b	(a4)

loc_10202:
		btst	#$C,d4
		beq.s	loc_10212
		addi.b	#$40,(a4)
		neg.b	(a4)
		subi.b	#$40,(a4)

loc_10212:
		andi.w	#$F,d1
		add.w	d0,d1
		lea	(colWidth).l,a2
		move.b	(a2,d1.w),d0
		ext.w	d0
		eor.w	d6,d4
		btst	#$C,d4
		beq.s	loc_1022E
		neg.w	d0

loc_1022E:
		tst.w	d0
		beq.s	loc_101CE
		bmi.s	loc_1024A
		cmpi.b	#$10,d0
		beq.s	loc_10256
		move.w	d2,d1
		andi.w	#$F,d1
		add.w	d1,d0
		move.w	#$F,d1
		sub.w	d0,d1
		rts
; ---------------------------------------------------------------------------

loc_1024A:
		move.w	d2,d1
		andi.w	#$F,d1
		add.w	d1,d0
		bpl.w	loc_101CE

loc_10256:
		sub.w	a3,d2
		bsr.w	sub_10264
		add.w	a3,d2
		subi.w	#$10,d1
		rts
; ---------------------------------------------------------------------------

sub_10264:
		bsr.w	Floor_ChkTile
		move.w	(a1),d0
		move.w	d0,d4
		andi.w	#$7FF,d0
		beq.s	loc_10276
		btst	d5,d4
		bne.s	loc_10284

loc_10276:
		move.w	#$F,d1
		move.w	d2,d0
		andi.w	#$F,d0
		sub.w	d0,d1
		rts
; ---------------------------------------------------------------------------

loc_10284:
		movea.l	(v_collindex).w,a2
		move.b	(a2,d0.w),d0
		andi.w	#$FF,d0
		beq.s	loc_10276
		lea	(colAngles).l,a2
		move.b	(a2,d0.w),(a4)
		lsl.w	#4,d0
		move.w	d3,d1
		btst	#$B,d4
		beq.s	loc_102AA
		not.w	d1
		neg.b	(a4)

loc_102AA:
		btst	#$C,d4
		beq.s	loc_102BA
		addi.b	#$40,(a4)
		neg.b	(a4)
		subi.b	#$40,(a4)

loc_102BA:
		andi.w	#$F,d1
		add.w	d0,d1
		lea	(colWidth).l,a2
		move.b	(a2,d1.w),d0
		ext.w	d0
		eor.w	d6,d4
		btst	#$C,d4
		beq.s	loc_102D6
		neg.w	d0

loc_102D6:
		tst.w	d0
		beq.s	loc_10276
		bmi.s	loc_102EC
		move.w	d2,d1
		andi.w	#$F,d1
		add.w	d1,d0
		move.w	#$F,d1
		sub.w	d0,d1
		rts
; ---------------------------------------------------------------------------

loc_102EC:
		move.w	d2,d1
		andi.w	#$F,d1
		add.w	d1,d0
		bpl.w	loc_10276
		not.w	d1
		rts