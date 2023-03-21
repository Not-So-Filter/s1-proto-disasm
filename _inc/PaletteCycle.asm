; ---------------------------------------------------------------------------

PaletteCycle:
		moveq	#0,d2
		moveq	#0,d0
		move.b	(v_zone).w,d0
		add.w	d0,d0
		move.w	.levels(pc,d0.w),d0
		jmp	.levels(pc,d0.w)
; ---------------------------------------------------------------------------

.levels:	dc.w PalCycGHZ-.levels, PalCycLZ-.levels, PalCycMZ-.levels, PalCycSLZ-.levels
                dc.w PalCycSZ-.levels, PalCycCWZ-.levels, PalCycEnding-.levels
; ---------------------------------------------------------------------------

PalCycTitle:
		lea	(Cyc_Title).l,a0
		bra.s	loc_1760
; ---------------------------------------------------------------------------

PalCycGHZ:
		lea	(Cyc_GHZ).l,a0

loc_1760:
		subq.w	#1,(word_FFF634).w
		bpl.s	locret_1786
		move.w	#5,(word_FFF634).w
		move.w	(word_FFF632).w,d0
		addq.w	#1,(word_FFF632).w
		andi.w	#3,d0
		lsl.w	#3,d0
		lea	(v_pal_dry+$50).w,a1
		move.l	(a0,d0.w),(a1)+
		move.l	4(a0,d0.w),(a1)

locret_1786:
		rts
; ---------------------------------------------------------------------------

PalCycLZ:
		rts
; ---------------------------------------------------------------------------
PalCycUnused:
		subq.w	#1,(word_FFF634).w
		bpl.s	locret_17B8
		move.w	#5,(word_FFF634).w
		move.w	(word_FFF632).w,d0
		addq.w	#1,(word_FFF632).w
		andi.w	#3,d0
		lsl.w	#3,d0
		lea	(Cyc_LZ).l,a0
		adda.w	d0,a0
		lea	(v_pal_dry+$6E).w,a1
		move.w	(a0)+,(a1)+
		addq.w	#8,a1
		move.w	(a0)+,(a1)+
		move.l	(a0)+,(a1)+

locret_17B8:
		rts
; ---------------------------------------------------------------------------

PalCycMZ:
		rts
; ---------------------------------------------------------------------------

PalCycSLZ:
		subq.w	#1,(word_FFF634).w
		bpl.s	locret_17F6
		move.w	#$F,(word_FFF634).w
		move.w	(word_FFF632).w,d0
		addq.w	#1,d0
		cmpi.w	#6,d0
		bcs.s	loc_17D6
		moveq	#0,d0

loc_17D6:
		move.w	d0,(word_FFF632).w
		move.w	d0,d1
		add.w	d1,d1
		add.w	d1,d0
		add.w	d0,d0
		lea	(Cyc_SLZ).l,a0
		lea	(v_pal_dry+$56).w,a1
		move.w	(a0,d0.w),(a1)
		move.l	2(a0,d0.w),4(a1)

locret_17F6:
		rts
; ---------------------------------------------------------------------------

PalCycSZ:
		subq.w	#1,(word_FFF634).w
		bpl.s	locret_1846
		move.w	#5,(word_FFF634).w
		move.w	(word_FFF632).w,d0
		move.w	d0,d1
		addq.w	#1,(word_FFF632).w
		andi.w	#3,d0
		lsl.w	#3,d0
		lea	(Cyc_SZ1).l,a0
		lea	(v_pal_dry+$6E).w,a1
		move.l	(a0,d0.w),(a1)+
		move.l	4(a0,d0.w),(a1)
		andi.w	#3,d1
		move.w	d1,d0
		add.w	d1,d1
		add.w	d0,d1
		add.w	d1,d1
		lea	(Cyc_SZ2).l,a0
		lea	(v_pal_dry+$76).w,a1
		move.l	(a0,d1.w),(a1)
		move.w	4(a0,d1.w),6(a1)

locret_1846:
		rts
; ---------------------------------------------------------------------------

PalCycCWZ:
		rts
; ---------------------------------------------------------------------------

PalCycEnding:
		rts
; ---------------------------------------------------------------------------
