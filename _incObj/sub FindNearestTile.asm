; ---------------------------------------------------------------------------

Floor_ChkTile:
		move.w	d2,d0
		lsr.w	#1,d0
		andi.w	#$380,d0
		move.w	d3,d1
		lsr.w	#8,d1
		andi.w	#$7F,d1
		add.w	d1,d0
		moveq	#-1,d1
		lea	(v_lvllayout).w,a1
		move.b	(a1,d0.w),d1
		beq.s	loc_10186
		bmi.s	loc_1018A
		subq.b	#1,d1
		ext.w	d1
		ror.w	#7,d1
		move.w	d2,d0
		add.w	d0,d0
		andi.w	#$1E0,d0
		add.w	d0,d1
		move.w	d3,d0
		lsr.w	#3,d0
		andi.w	#$1E,d0
		add.w	d0,d1

loc_10186:
		movea.l	d1,a1
		rts
; ---------------------------------------------------------------------------

loc_1018A:
		andi.w	#$7F,d1
		btst	#6,obRender(a0)
		beq.s	loc_101A2
		addq.w	#1,d1
		cmpi.w	#$29,d1
		bne.s	loc_101A2
		move.w	#$51,d1

loc_101A2:
		subq.b	#1,d1
		ror.w	#7,d1
		move.w	d2,d0
		add.w	d0,d0
		andi.w	#$1E0,d0
		add.w	d0,d1
		move.w	d3,d0
		lsr.w	#3,d0
		andi.w	#$1E,d0
		add.w	d0,d1
		movea.l	d1,a1
		rts