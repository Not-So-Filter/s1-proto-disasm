; ---------------------------------------------------------------------------

Signpost:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	off_C726(pc,d0.w),d1
		jsr	off_C726(pc,d1.w)
		lea	(AniSignpost).l,a1
		bsr.w	AnimateSprite
		bsr.w	DisplaySprite
		out_of_range.w	DeleteObject
		rts
; ---------------------------------------------------------------------------
off_C726:	dc.w loc_C72E-off_C726
                dc.w loc_C752-off_C726
                dc.w loc_C77C-off_C726
                dc.w loc_C814-off_C726
; ---------------------------------------------------------------------------

loc_C72E:
		addq.b	#2,obRoutine(a0)
		move.l	#MapSignpost,obMap(a0)
		move.w	#$680,obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#$18,obActWid(a0)
		move.b	#4,obPriority(a0)

loc_C752:
		move.w	(v_objspace+obX).w,d0
		sub.w	obX(a0),d0
		bcs.s	locret_C77A
		cmpi.w	#$20,d0
		bcc.s	locret_C77A
		move.w	#sfx_Signpost,d0
		jsr	(PlaySound).l
		clr.b	(f_timecount).w
		move.w	(v_limitright2).w,(v_limitleft2).w
		addq.b	#2,obRoutine(a0)

locret_C77A:
		rts
; ---------------------------------------------------------------------------

loc_C77C:
		subq.w	#1,$30(a0)
		bpl.s	loc_C798
		move.w	#$3C,$30(a0)
		addq.b	#1,obAnim(a0)
		cmpi.b	#3,obAnim(a0)
		bne.s	loc_C798
		addq.b	#2,obRoutine(a0)

loc_C798:
		subq.w	#1,$32(a0)
		bpl.s	locret_C802
		move.w	#$B,$32(a0)
		moveq	#0,d0
		move.b	$34(a0),d0
		addq.b	#2,$34(a0)
		andi.b	#$E,$34(a0)
		lea	byte_C804(pc,d0.w),a2
		bsr.w	FindFreeObj
		bne.s	locret_C802
		move.b	#id_Rings,obId(a1)
		move.b	#6,obRoutine(a1)
		move.b	(a2)+,d0
		ext.w	d0
		add.w	obX(a0),d0
		move.w	d0,obX(a1)
		move.b	(a2)+,d0
		ext.w	d0
		add.w	obY(a0),d0
		move.w	d0,obY(a1)
		move.l	#MapRing,obMap(a1)
		move.w	#$27B2,obGfx(a1)
		move.b	#4,obRender(a1)
		move.b	#2,obPriority(a1)
		move.b	#8,obActWid(a1)

locret_C802:
		rts
; ---------------------------------------------------------------------------

byte_C804:	dc.b $E8, $F0
		dc.b 8, 8
		dc.b $F0, 0
		dc.b $18, $F8
		dc.b 0, $F8
		dc.b $10, 0
		dc.b $E8, 8
		dc.b $18, $10
; ---------------------------------------------------------------------------

loc_C814:
		tst.w	(v_debuguse).w
		bne.w	locret_C880

sub_C81C:
		tst.b	(f_victory).w
		bne.s	locret_C880
		move.w	(v_limitright2).w,(v_limitleft2).w
		clr.b	(v_invinc).w
		clr.b	(f_timecount).w
		move.b	#id_GotThroughCard,(v_objspace+obSize*24).w
		moveq	#plcid_TitleCard,d0
		jsr	(NewPLC).l
		move.b	#1,(f_endactbonus).w
		moveq	#0,d0
		move.b	(v_time+1).w,d0
		mulu.w	#$3C,d0
		moveq	#0,d1
		move.b	(v_time+2).w,d1
		add.w	d1,d0
		divu.w	#$F,d0
		moveq	#$14,d1
		cmp.w	d1,d0
		bcs.s	loc_C862
		move.w	d1,d0

loc_C862:
		add.w	d0,d0
		move.w	TimeBonuses(pc,d0.w),(v_timebonus).w
		move.w	(v_rings).w,d0
		mulu.w	#10,d0
		move.w	d0,(v_ringbonus).w
		move.w	#bgm_GotThrough,d0
		jsr	(PlaySound_Special).l

locret_C880:
		rts
; ---------------------------------------------------------------------------

TimeBonuses:	dc.w 5000
		dc.w 1000
		dc.w 500
		dc.w 400
		dc.w 300
		dc.w 300
		dc.w 200
		dc.w 200
		dc.w 100
		dc.w 100
                dc.w 100
                dc.w 100
                dc.w 50
                dc.w 50
                dc.w 50
                dc.w 50
                dc.w 10
                dc.w 10
                dc.w 10
                dc.w 10
		dc.w 0