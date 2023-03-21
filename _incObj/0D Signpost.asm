; ---------------------------------------------------------------------------

ObjSignpost:
		moveq	#0,d0
		move.b	$24(a0),d0
		move.w	off_C726(pc,d0.w),d1
		jsr	off_C726(pc,d1.w)
		lea	(AniSignpost).l,a1
		bsr.w	ObjectAnimate
		bsr.w	DisplaySprite
		move.w	8(a0),d0
		andi.w	#$FF80,d0
		move.w	(v_screenposx).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0
		cmpi.w	#$280,d0
		bhi.w	DeleteObject
		rts
; ---------------------------------------------------------------------------
off_C726:	dc.w loc_C72E-off_C726
                dc.w loc_C752-off_C726
                dc.w loc_C77C-off_C726
                dc.w loc_C814-off_C726
; ---------------------------------------------------------------------------

loc_C72E:
		addq.b	#2,$24(a0)
		move.l	#MapSignpost,4(a0)
		move.w	#$680,2(a0)
		move.b	#4,1(a0)
		move.b	#$18,$18(a0)
		move.b	#4,$19(a0)

loc_C752:
		move.w	(v_objspace+8).w,d0
		sub.w	8(a0),d0
		bcs.s	locret_C77A
		cmpi.w	#$20,d0
		bcc.s	locret_C77A
		move.w	#sfx_Signpost,d0
		jsr	(PlayMusic).l
		clr.b	(f_timecount).w
		move.w	(unk_FFF72A).w,(unk_FFF728).w
		addq.b	#2,$24(a0)

locret_C77A:
		rts
; ---------------------------------------------------------------------------

loc_C77C:
		subq.w	#1,$30(a0)
		bpl.s	loc_C798
		move.w	#$3C,$30(a0)
		addq.b	#1,$1C(a0)
		cmpi.b	#3,$1C(a0)
		bne.s	loc_C798
		addq.b	#2,$24(a0)

loc_C798:
		subq.w	#1,$32(a0)
		bpl.s	locret_C802
		move.w	#$B,$32(a0)
		moveq	#0,d0
		move.b	$34(a0),d0
		addq.b	#2,$34(a0)
		andi.b	#$E,$34(a0)
		lea	byte_C804(pc,d0.w),a2
		bsr.w	ObjectLoad
		bne.s	locret_C802
		move.b	#$25,0(a1)
		move.b	#6,$24(a1)
		move.b	(a2)+,d0
		ext.w	d0
		add.w	8(a0),d0
		move.w	d0,8(a1)
		move.b	(a2)+,d0
		ext.w	d0
		add.w	$C(a0),d0
		move.w	d0,$C(a1)
		move.l	#MapRing,4(a1)
		move.w	#$27B2,2(a1)
		move.b	#4,1(a1)
		move.b	#2,$19(a1)
		move.b	#8,$18(a1)

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
		tst.w	(DebugRoutine).w
		bne.w	locret_C880
; ---------------------------------------------------------------------------

sub_C81C:
		tst.b	(f_victory).w
		bne.s	locret_C880
		move.w	(unk_FFF72A).w,(unk_FFF728).w
		clr.b	(v_invinc).w
		clr.b	(f_timecount).w
		move.b	#$3A,(v_objspace+$600).w
		moveq	#plcid_TitleCard,d0
		jsr	(plcReplace).l
		move.b	#1,(byte_FFFE58).w
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
		move.w	word_C882(pc,d0.w),(word_FFFE54).w
		move.w	(v_rings).w,d0
		mulu.w	#$A,d0
		move.w	d0,(word_FFFE56).w
		move.w	#bgm_GotThrough,d0
		jsr	(PlaySFX).l

locret_C880:
		rts
; ---------------------------------------------------------------------------

word_C882:	dc.w $1388, $3E8, $1F4, $190, $12C, $12C, $C8, $C8, $64
		dc.w $64, $64, $64, $32, $32, $32, $32, $A, $A, $A, $A
		dc.w 0
