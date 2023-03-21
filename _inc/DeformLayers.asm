; ---------------------------------------------------------------------------
; Background layer deformation subroutines
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||

DeformLayers:
		tst.b	(f_nobgscroll).w
		bne.s	loc_3E18
		tst.b	(f_res_hscroll).w
		bne.w	loc_4258
		bsr.w	ScrollHoriz

loc_3E08:
		tst.b	(f_res_vscroll).w
		bne.w	loc_4276
		bsr.w	ScrollVertical

loc_3E14:
		bsr.w	DynamicLevelEvents

loc_3E18:
		move.w	(v_screenposx).w,(v_scrposx_dup).w
		move.w	(v_screenposy).w,(v_scrposy_dup).w
		move.w	(v_bgscreenposx).w,(v_bgscreenposx_dup).w
		move.w	(v_bgscreenposy).w,(v_bgscrposy_dup).w
		move.w	(v_bg3screenposx).w,(word_FFF620).w
		move.w	(v_bg3screenposy).w,(word_FFF61E).w
		moveq	#0,d0
		move.b	(v_zone).w,d0
		add.w	d0,d0
		move.w	Deform_Index(pc,d0.w),d0
		jmp	Deform_Index(pc,d0.w)
; ---------------------------------------------------------------------------

Deform_Index:	dc.w Deform_GHZ-Deform_Index, Deform_LZ-Deform_Index, Deform_MZ-Deform_Index
                dc.w Deform_SLZ-Deform_Index, Deform_SZ-Deform_Index, Deform_CWZ-Deform_Index
; ---------------------------------------------------------------------------

Deform_GHZ:
		move.w	(unk_FFF73A).w,d4
		ext.l	d4
		asl.l	#5,d4
		move.l	d4,d1
		asl.l	#1,d4
		add.l	d1,d4
		moveq	#0,d5
		bsr.w	sub_4298
		bsr.w	sub_4374
		lea	(v_hscrolltablebuffer).w,a1
		move.w	(v_screenposy).w,d0
		andi.w	#$7FF,d0
		lsr.w	#5,d0
		neg.w	d0
		addi.w	#$26,d0
		move.w	d0,(v_bg2screenposy).w
		move.w	d0,d4
		bsr.w	sub_4344
		move.w	(v_bgscreenposy).w,(v_bgscrposy_dup).w
		move.w	#$6F,d1
		sub.w	d4,d1
		move.w	(v_screenposx).w,d0
		cmpi.b	#4,(v_gamemode).w
		bne.s	loc_3EA8
		moveq	#0,d0

loc_3EA8:
		neg.w	d0
		swap	d0
		move.w	(v_bgscreenposx).w,d0
		neg.w	d0

loc_3EB2:
		move.l	d0,(a1)+
		dbf	d1,loc_3EB2
		move.w	#$27,d1
		move.w	(v_bg2screenposx).w,d0
		neg.w	d0

loc_3EC2:
		move.l	d0,(a1)+
		dbf	d1,loc_3EC2
		move.w	(v_bg2screenposx).w,d0
		addi.w	#0,d0
		move.w	(v_screenposx).w,d2
		addi.w	#-$200,d2
		sub.w	d0,d2
		ext.l	d2
		asl.l	#8,d2
		divs.w	#$68,d2
		ext.l	d2
		asl.l	#8,d2
		moveq	#0,d3
		move.w	d0,d3
		move.w	#$47,d1
		add.w	d4,d1

loc_3EF0:
		move.w	d3,d0
		neg.w	d0
		move.l	d0,(a1)+
		swap	d3
		add.l	d2,d3
		swap	d3
		dbf	d1,loc_3EF0
		rts
; ---------------------------------------------------------------------------

Deform_LZ:
		lea	(v_hscrolltablebuffer).w,a1
		move.w	#$DF,d1
		move.w	(v_screenposx).w,d0
		neg.w	d0
		swap	d0
		move.w	(v_bgscreenposx).w,d0
		move.w	#0,d0
		neg.w	d0

loc_3F1C:
		move.l	d0,(a1)+
		dbf	d1,loc_3F1C
		rts
; ---------------------------------------------------------------------------

Deform_MZ:
		move.w	(unk_FFF73A).w,d4
		ext.l	d4
		asl.l	#6,d4
		move.l	d4,d1
		asl.l	#1,d4
		add.l	d1,d4
		moveq	#0,d5
		bsr.w	sub_4298
		move.w	#$200,d0
		move.w	(v_screenposy).w,d1
		subi.w	#$1C8,d1
		bcs.s	loc_3F50
		move.w	d1,d2
		add.w	d1,d1
		add.w	d2,d1
		asr.w	#2,d1
		add.w	d1,d0

loc_3F50:
		move.w	d0,(v_bg2screenposy).w
		bsr.w	sub_4344
		move.w	(v_bgscreenposy).w,(v_bgscrposy_dup).w
		lea	(v_hscrolltablebuffer).w,a1
		move.w	#$DF,d1
		move.w	(v_screenposx).w,d0
		neg.w	d0
		swap	d0
		move.w	(v_bgscreenposx).w,d0
		neg.w	d0

loc_3F74:
		move.l	d0,(a1)+
		dbf	d1,loc_3F74
		rts
; ---------------------------------------------------------------------------

Deform_SLZ:
		move.w	(unk_FFF73A).w,d4
		ext.l	d4
		asl.l	#7,d4
		move.w	(unk_FFF73C).w,d5
		ext.l	d5
		asl.l	#7,d5
		bsr.w	sub_4302
		move.w	(v_bgscreenposy).w,(v_bgscrposy_dup).w
		bsr.w	sub_3FF6
		lea	(v_bgscroll_buffer).w,a2
		move.w	(v_bgscreenposy).w,d0
		move.w	d0,d2
		subi.w	#$C0,d0
		andi.w	#$3F0,d0
		lsr.w	#3,d0
		lea	(a2,d0.w),a2
		lea	(v_hscrolltablebuffer).w,a1
		move.w	#$E,d1
		move.w	(v_screenposx).w,d0
		neg.w	d0
		swap	d0
		andi.w	#$F,d2
		add.w	d2,d2
		move.w	(a2)+,d0
		jmp	loc_3FD0(pc,d2.w)
; ---------------------------------------------------------------------------

loc_3FCE:
		move.w	(a2)+,d0

loc_3FD0:
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		dbf	d1,loc_3FCE
		rts
; ---------------------------------------------------------------------------

sub_3FF6:
		lea	(v_bgscroll_buffer).w,a1
		move.w	(v_screenposx).w,d2
		neg.w	d2
		move.w	d2,d0
		asr.w	#3,d0
		sub.w	d2,d0
		ext.l	d0
		asl.l	#4,d0
		divs.w	#$1C,d0
		ext.l	d0
		asl.l	#4,d0
		asl.l	#8,d0
		moveq	#0,d3
		move.w	d2,d3
		move.w	#$1B,d1

loc_401C:
		move.w	d3,(a1)+
		swap	d3
		add.l	d0,d3
		swap	d3
		dbf	d1,loc_401C
		move.w	d2,d0
		asr.w	#3,d0
		move.w	#4,d1

loc_4030:
		move.w	d0,(a1)+
		dbf	d1,loc_4030
		move.w	d2,d0
		asr.w	#2,d0
		move.w	#4,d1

loc_403E:
		move.w	d0,(a1)+
		dbf	d1,loc_403E
		move.w	d2,d0
		asr.w	#1,d0
		move.w	#$1D,d1

loc_404C:
		move.w	d0,(a1)+
		dbf	d1,loc_404C
		rts
; ---------------------------------------------------------------------------

Deform_SZ:
		move.w	(unk_FFF73A).w,d4
		ext.l	d4
		asl.l	#6,d4
		move.w	(unk_FFF73C).w,d5
		ext.l	d5
		asl.l	#4,d5
		move.l	d5,d1
		asl.l	#1,d5
		add.l	d1,d5
		bsr.w	sub_4298
		move.w	(v_bgscreenposy).w,(v_bgscrposy_dup).w
		lea	(v_hscrolltablebuffer).w,a1
		move.w	#$DF,d1
		move.w	(v_screenposx).w,d0
		neg.w	d0
		swap	d0
		move.w	(v_bgscreenposx).w,d0
		neg.w	d0

loc_408A:
		move.l	d0,(a1)+
		dbf	d1,loc_408A
		rts
; ---------------------------------------------------------------------------

Deform_CWZ:
		lea	(v_hscrolltablebuffer).w,a1
		move.w	#$DF,d1
		move.w	(v_screenposx).w,d0
		neg.w	d0
		swap	d0
		move.w	(v_bgscreenposx).w,d0
		move.w	#0,d0
		neg.w	d0

loc_40AC:
		move.l	d0,(a1)+
		dbf	d1,loc_40AC
		rts
; ---------------------------------------------------------------------------

ScrollHoriz:
		move.w	(v_screenposx).w,d4
		bsr.s	sub_40E8
		move.w	(v_screenposx).w,d0
		andi.w	#$10,d0
		move.b	(unk_FFF74A).w,d1
		eor.b	d1,d0
		bne.s	locret_40E6
		eori.b	#$10,(unk_FFF74A).w
		move.w	(v_screenposx).w,d0
		sub.w	d4,d0
		bpl.s	loc_40E0
		bset	#2,(unk_FFF754).w
		rts
; ---------------------------------------------------------------------------

loc_40E0:
		bset	#3,(unk_FFF754).w

locret_40E6:
		rts
; ---------------------------------------------------------------------------

sub_40E8:
		move.w	(v_objspace+8).w,d0
		sub.w	(v_screenposx).w,d0
		subi.w	#$90,d0
		bcs.s	loc_412C
		subi.w	#$10,d0
		bcc.s	loc_4102
		clr.w	(unk_FFF73A).w
		rts
; ---------------------------------------------------------------------------

loc_4102:
		cmpi.w	#$10,d0
		bcs.s	loc_410C
		move.w	#$10,d0

loc_410C:
		add.w	(v_screenposx).w,d0
		cmp.w	(unk_FFF72A).w,d0
		blt.s	loc_411A
		move.w	(unk_FFF72A).w,d0

loc_411A:
		move.w	d0,d1
		sub.w	(v_screenposx).w,d1
		asl.w	#8,d1
		move.w	d0,(v_screenposx).w
		move.w	d1,(unk_FFF73A).w
		rts
; ---------------------------------------------------------------------------

loc_412C:
		add.w	(v_screenposx).w,d0
		cmp.w	(unk_FFF728).w,d0
		bgt.s	loc_411A
		move.w	(unk_FFF728).w,d0
		bra.s	loc_411A
; ---------------------------------------------------------------------------
		tst.w	d0
		bpl.s	loc_4146
		move.w	#-2,d0
		bra.s	loc_412C
; ---------------------------------------------------------------------------

loc_4146:
		move.w	#2,d0
		bra.s	loc_4102
; ---------------------------------------------------------------------------

ScrollVertical:
		moveq	#0,d1
		move.w	(v_objspace+$C).w,d0
		sub.w	(v_screenposy).w,d0
		btst	#2,(v_objspace+$22).w
		beq.s	loc_4160
		subq.w	#5,d0

loc_4160:
		btst	#1,(v_objspace+$22).w
		beq.s	loc_4180
		addi.w	#$20,d0
		sub.w	(unk_FFF73E).w,d0
		bcs.s	loc_41BE
		subi.w	#$40,d0
		bcc.s	loc_41BE
		tst.b	(unk_FFF75C).w
		bne.s	loc_41D0
		bra.s	loc_418C
; ---------------------------------------------------------------------------

loc_4180:
		sub.w	(unk_FFF73E).w,d0
		bne.s	loc_4192
		tst.b	(unk_FFF75C).w
		bne.s	loc_41D0

loc_418C:
		clr.w	(unk_FFF73C).w
		rts
; ---------------------------------------------------------------------------

loc_4192:
		cmpi.w	#$60,(unk_FFF73E).w
		bne.s	loc_41AC
		move.w	#$600,d1
		cmpi.w	#6,d0
		bgt.s	loc_4200
		cmpi.w	#$FFFA,d0
		blt.s	loc_41E8
		bra.s	loc_41D6
; ---------------------------------------------------------------------------

loc_41AC:
		move.w	#$200,d1
		cmpi.w	#2,d0
		bgt.s	loc_4200
		cmpi.w	#$FFFE,d0
		blt.s	loc_41E8
		bra.s	loc_41D6
; ---------------------------------------------------------------------------

loc_41BE:
		move.w	#$1000,d1
		cmpi.w	#$10,d0
		bgt.s	loc_4200
		cmpi.w	#$FFF0,d0
		blt.s	loc_41E8
		bra.s	loc_41D6
; ---------------------------------------------------------------------------

loc_41D0:
		moveq	#0,d0
		move.b	d0,(unk_FFF75C).w

loc_41D6:
		moveq	#0,d1
		move.w	d0,d1
		add.w	(v_screenposy).w,d1
		tst.w	d0
		bpl.w	loc_420A
		bra.w	loc_41F4
; ---------------------------------------------------------------------------

loc_41E8:
		neg.w	d1
		ext.l	d1
		asl.l	#8,d1
		add.l	(v_screenposy).w,d1
		swap	d1

loc_41F4:
		cmp.w	(unk_FFF72C).w,d1
		bgt.s	loc_4214
		move.w	(unk_FFF72C).w,d1
		bra.s	loc_4214
; ---------------------------------------------------------------------------

loc_4200:
		ext.l	d1
		asl.l	#8,d1
		add.l	(v_screenposy).w,d1
		swap	d1

loc_420A:
		cmp.w	(unk_FFF72E).w,d1
		blt.s	loc_4214
		move.w	(unk_FFF72E).w,d1

loc_4214:
		move.w	(v_screenposy).w,d4
		swap	d1
		move.l	d1,d3
		sub.l	(v_screenposy).w,d3
		ror.l	#8,d3
		move.w	d3,(unk_FFF73C).w
		move.l	d1,(v_screenposy).w
		move.w	(v_screenposy).w,d0
		andi.w	#$10,d0
		move.b	(unk_FFF74B).w,d1
		eor.b	d1,d0
		bne.s	locret_4256
		eori.b	#$10,(unk_FFF74B).w
		move.w	(v_screenposy).w,d0
		sub.w	d4,d0
		bpl.s	loc_4250
		bset	#0,(unk_FFF754).w
		rts
; ---------------------------------------------------------------------------

loc_4250:
		bset	#1,(unk_FFF754).w

locret_4256:
		rts
; ---------------------------------------------------------------------------

loc_4258:
		move.w	(unk_FFF728).w,d0
		moveq	#1,d1
		sub.w	(v_screenposx).w,d0
		beq.s	loc_426E
		bpl.s	loc_4268
		moveq	#-1,d1

loc_4268:
		add.w	d1,(v_screenposx).w
		move.w	d1,d0

loc_426E:
		move.w	d0,(unk_FFF73A).w
		bra.w	loc_3E08
; ---------------------------------------------------------------------------

loc_4276:
		move.w	(unk_FFF72C).w,d0
		addi.w	#$20,d0
		moveq	#1,d1
		sub.w	(v_screenposy).w,d0
		beq.s	loc_4290
		bpl.s	loc_428A
		moveq	#-1,d1

loc_428A:
		add.w	d1,(v_screenposy).w
		move.w	d1,d0

loc_4290:
		move.w	d0,(unk_FFF73C).w
		bra.w	loc_3E14
; ---------------------------------------------------------------------------

sub_4298:
		move.l	(v_bgscreenposx).w,d2
		move.l	d2,d0
		add.l	d4,d0
		move.l	d0,(v_bgscreenposx).w
		move.l	d0,d1
		swap	d1
		andi.w	#$10,d1
		move.b	(unk_FFF74C).w,d3
		eor.b	d3,d1
		bne.s	loc_42CC
		eori.b	#$10,(unk_FFF74C).w
		sub.l	d2,d0
		bpl.s	loc_42C6
		bset	#2,(unk_FFF756).w
		bra.s	loc_42CC
; ---------------------------------------------------------------------------

loc_42C6:
		bset	#3,(unk_FFF756).w

loc_42CC:
		move.l	(v_bgscreenposy).w,d3
		move.l	d3,d0
		add.l	d5,d0
		move.l	d0,(v_bgscreenposy).w
		move.l	d0,d1
		swap	d1
		andi.w	#$10,d1
		move.b	(unk_FFF74D).w,d2
		eor.b	d2,d1
		bne.s	locret_4300
		eori.b	#$10,(unk_FFF74D).w
		sub.l	d3,d0
		bpl.s	loc_42FA
		bset	#0,(unk_FFF756).w
		rts
; ---------------------------------------------------------------------------

loc_42FA:
		bset	#1,(unk_FFF756).w

locret_4300:
		rts
; ---------------------------------------------------------------------------

sub_4302:
		move.l	(v_bgscreenposx).w,d2
		move.l	d2,d0
		add.l	d4,d0
		move.l	d0,(v_bgscreenposx).w
		move.l	(v_bgscreenposy).w,d3
		move.l	d3,d0
		add.l	d5,d0
		move.l	d0,(v_bgscreenposy).w
		move.l	d0,d1
		swap	d1
		andi.w	#$10,d1
		move.b	(unk_FFF74D).w,d2
		eor.b	d2,d1
		bne.s	locret_4342
		eori.b	#$10,(unk_FFF74D).w
		sub.l	d3,d0
		bpl.s	loc_433C
		bset	#0,(unk_FFF756).w
		rts
; ---------------------------------------------------------------------------

loc_433C:
		bset	#1,(unk_FFF756).w

locret_4342:
		rts
; ---------------------------------------------------------------------------

sub_4344:
		move.w	(v_bgscreenposy).w,d3
		move.w	d0,(v_bgscreenposy).w
		move.w	d0,d1
		andi.w	#$10,d1
		move.b	(unk_FFF74D).w,d2
		eor.b	d2,d1
		bne.s	locret_4372
		eori.b	#$10,(unk_FFF74D).w
		sub.w	d3,d0
		bpl.s	loc_436C
		bset	#0,(unk_FFF756).w
		rts
; ---------------------------------------------------------------------------

loc_436C:
		bset	#1,(unk_FFF756).w

locret_4372:
		rts
; ---------------------------------------------------------------------------

sub_4374:
		move.w	(v_bg2screenposx).w,d2
		move.w	(v_bg2screenposy).w,d3
		move.w	(unk_FFF73A).w,d0
		ext.l	d0
		asl.l	#7,d0
		add.l	d0,(v_bg2screenposx).w
		move.w	(v_bg2screenposx).w,d0
		andi.w	#$10,d0
		move.b	(unk_FFF74E).w,d1
		eor.b	d1,d0
		bne.s	locret_43B4
		eori.b	#$10,(unk_FFF74E).w
		move.w	(v_bg2screenposx).w,d0
		sub.w	d2,d0
		bpl.s	loc_43AE
		bset	#2,(unk_FFF758).w
		bra.s	locret_43B4
; ---------------------------------------------------------------------------

loc_43AE:
		bset	#3,(unk_FFF758).w

locret_43B4:
		rts
