; ---------------------------------------------------------------------------

sub_E8D6:
		move.w	$30(a0),d0
		beq.s	loc_E8E4
		subq.w	#1,$30(a0)
		lsr.w	#3,d0
		bcc.s	loc_E8E8

loc_E8E4:
		bsr.w	DisplaySprite

loc_E8E8:
		tst.b	(v_invinc).w
		beq.s	loc_E91C
		tst.w	$32(a0)
		beq.s	loc_E91C
		subq.w	#1,$32(a0)
		bne.s	loc_E91C
		tst.b	(unk_FFF7AA).w
		bne.s	loc_E916
		moveq	#0,d0
		move.b	(v_zone).w,d0
		lea	(MusicList2).l,a1
		move.b	(a1,d0.w),d0
		jsr	(PlaySound).l

loc_E916:
		move.b	#0,(v_invinc).w

loc_E91C:
		tst.b	(v_shoes).w
		beq.s	locret_E950
		tst.w	$34(a0)
		beq.s	locret_E950
		subq.w	#1,$34(a0)
		bne.s	locret_E950
		move.w	#$600,(unk_FFF760).w
		move.w	#$C,(unk_FFF762).w
		move.w	#$40,(unk_FFF764).w
		move.b	#0,(v_shoes).w
		move.w	#bgm_Slowdown,d0
		jmp	(PlaySound_Special).l
; ---------------------------------------------------------------------------

locret_E950:
		rts