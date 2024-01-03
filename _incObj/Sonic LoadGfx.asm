; ---------------------------------------------------------------------------

Sonic_DynTiles:
		moveq	#0,d0
		move.b	obj.Frame(a0),d0
		cmp.b	(v_sonframenum).w,d0
		beq.s	locret_F744
		move.b	d0,(v_sonframenum).w
		lea	(SonicDynPLC).l,a2
		add.w	d0,d0
		adda.w	(a2,d0.w),a2
		moveq	#0,d1
		move.b	(a2)+,d1
		subq.b	#1,d1
		bmi.s	locret_F744
		lea	(v_sgfx_buffer).w,a3
		move.b	#1,(f_sonframechg).w

Sonic_DynReadEntry:
		moveq	#0,d2
		move.b	(a2)+,d2
		move.w	d2,d0
		lsr.b	#4,d0
		lsl.w	#8,d2
		move.b	(a2)+,d2
		lsl.w	#5,d2
		lea	(Art_Sonic).l,a1
		adda.l	d2,a1

loc_F730:
		movem.l	(a1)+,d2-d6/a4-a6
		movem.l	d2-d6/a4-a6,(a3)
		lea	$20(a3),a3
		dbf	d0,loc_F730

loc_F740:
		dbf	d1,Sonic_DynReadEntry

locret_F744:
		rts
