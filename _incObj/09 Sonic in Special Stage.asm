; ---------------------------------------------------------------------------
; Object 09 - Sonic (special stage)
; ---------------------------------------------------------------------------

ObjSonicSpecial:
		moveq	#0,d0
		move.b	$24(a0),d0
		move.w	Obj09_Index(pc,d0.w),d1
		jmp	Obj09_Index(pc,d1.w)
; ---------------------------------------------------------------------------
Obj09_Index:	dc.w Obj09_Main-Obj09_Index
                dc.w Obj09_Load-Obj09_Index
                dc.w Obj09_ExitStage-Obj09_Index
                dc.w Obj09_Exit2-Obj09_Index
; ---------------------------------------------------------------------------

Obj09_Main:
		addq.b	#2,$24(a0)
		move.b	#$E,$16(a0)
		move.b	#7,$17(a0)
		move.l	#MapSonic,4(a0)
		move.w	#$780,2(a0)
		move.b	#4,1(a0)
		move.b	#0,$19(a0)
		move.b	#2,$1C(a0)
		bset	#2,$22(a0)
		bset	#1,$22(a0)

Obj09_Load:
		move.b	#0,$30(a0)
		moveq	#0,d0
		move.b	$22(a0),d0
		andi.w	#2,d0
		move.w	Obj09_Modes(pc,d0.w),d1
		jsr	Obj09_Modes(pc,d1.w)
		jsr	(Sonic_DynTiles).l
		jmp	(DisplaySprite).l
; ---------------------------------------------------------------------------
Obj09_Modes:	dc.w loc_10D32-Obj09_Modes
                dc.w loc_10D40-Obj09_Modes
; ---------------------------------------------------------------------------

loc_10D32:
		bsr.w	Obj09_Jump
		bsr.w	Obj09_Move
		bsr.w	Obj09_Fall
		bra.s	Obj09_Display
; ---------------------------------------------------------------------------

loc_10D40:
		bsr.w	Obj09_Move
		bsr.w	Obj09_Fall

Obj09_Display:
		bsr.w	sub_1107C
		bsr.w	sub_110DE
		jsr	(SpeedToPos).l
		bsr.w	SS_FixCamera
		btst	#6,(v_jpadhold1).w
		beq.s	loc_10D66
		subq.w	#2,(unk_FFF782).w

loc_10D66:
		btst	#4,(v_jpadhold1).w
		beq.s	loc_10D72
		addq.w	#2,(unk_FFF782).w

loc_10D72:
		btst	#7,(v_jpadpress1).w
		beq.s	loc_10D80
		move.w	#0,(unk_FFF782).w

loc_10D80:
		move.w	(unk_FFF780).w,d0
		add.w	(unk_FFF782).w,d0
		move.w	d0,(unk_FFF780).w
		jsr	(Sonic_Animate).l
		rts
; ---------------------------------------------------------------------------

Obj09_Move:
		btst	#2,(v_jpadhold2).w
		beq.s	loc_10DA0
		bsr.w	sub_10E2C

loc_10DA0:
		btst	#3,(v_jpadhold2).w
		beq.s	loc_10DAC
		bsr.w	sub_10E5C

loc_10DAC:
		move.b	(v_jpadhold2).w,d0
		andi.b	#$C,d0
		bne.s	loc_10DDC
		move.w	$14(a0),d0
		beq.s	loc_10DDC
		bmi.s	loc_10DCE
		subi.w	#$C,d0
		bcc.s	loc_10DC8
		move.w	#0,d0

loc_10DC8:
		move.w	d0,$14(a0)
		bra.s	loc_10DDC
; ---------------------------------------------------------------------------

loc_10DCE:
		addi.w	#$C,d0
		bcc.s	loc_10DD8
		move.w	#0,d0

loc_10DD8:
		move.w	d0,$14(a0)

loc_10DDC:
		move.b	(unk_FFF780).w,d0
		addi.b	#$20,d0
		andi.b	#$C0,d0
		neg.b	d0
		jsr	(GetSine).l
		muls.w	$14(a0),d1
		add.l	d1,8(a0)
		muls.w	$14(a0),d0
		add.l	d0,$C(a0)
		movem.l	d0-d1,-(sp)
		move.l	$C(a0),d2
		move.l	8(a0),d3
		bsr.w	sub_1100E
		beq.s	loc_10E26
		movem.l	(sp)+,d0-d1
		sub.l	d1,8(a0)
		sub.l	d0,$C(a0)
		move.w	#0,$14(a0)
		rts
; ---------------------------------------------------------------------------

loc_10E26:
		movem.l	(sp)+,d0-d1
		rts
; ---------------------------------------------------------------------------

sub_10E2C:
		bset	#0,$22(a0)
		move.w	$14(a0),d0
		beq.s	loc_10E3A
		bpl.s	loc_10E4E

loc_10E3A:
		subi.w	#$C,d0
		cmpi.w	#$F800,d0
		bgt.s	loc_10E48
		move.w	#$F800,d0

loc_10E48:
		move.w	d0,$14(a0)
		rts
; ---------------------------------------------------------------------------

loc_10E4E:
		subi.w	#$40,d0
		bcc.s	loc_10E56
		nop

loc_10E56:
		move.w	d0,$14(a0)
		rts
; ---------------------------------------------------------------------------

sub_10E5C:
		bclr	#0,$22(a0)
		move.w	$14(a0),d0
		bmi.s	loc_10E7C
		addi.w	#$C,d0
		cmpi.w	#$800,d0
		blt.s	loc_10E76
		move.w	#$800,d0

loc_10E76:
		move.w	d0,$14(a0)
		bra.s	locret_10E88
; ---------------------------------------------------------------------------

loc_10E7C:
		addi.w	#$40,d0
		bcc.s	loc_10E84
		nop

loc_10E84:
		move.w	d0,$14(a0)

locret_10E88:
		rts
; ---------------------------------------------------------------------------

Obj09_Jump:
		move.b	(v_jpadpress2).w,d0
		andi.b	#$20,d0
		beq.s	locret_10ECC
		move.b	(unk_FFF780).w,d0
		andi.b	#$FC,d0
		neg.b	d0
		subi.b	#$40,d0
		jsr	(GetSine).l
		muls.w	#$700,d1
		asr.l	#8,d1
		move.w	d1,$10(a0)
		muls.w	#$700,d0
		asr.l	#8,d0
		move.w	d0,$12(a0)
		bset	#1,$22(a0)
		move.w	#$A0,d0
		jsr	(PlaySFX).l

locret_10ECC:
		rts
; ---------------------------------------------------------------------------

SS_FixCamera:
		move.w	$C(a0),d2
		move.w	8(a0),d3
		move.w	(v_screenposx).w,d0
		subi.w	#$A0,d3
		bcs.s	loc_10EE6
		sub.w	d3,d0
		sub.w	d0,(v_screenposx).w

loc_10EE6:
		move.w	(v_screenposy).w,d0
		subi.w	#$70,d2
		bcs.s	locret_10EF6
		sub.w	d2,d0
		sub.w	d0,(v_screenposy).w

locret_10EF6:
		rts
; ---------------------------------------------------------------------------

Obj09_ExitStage:
		addi.w	#$40,(unk_FFF782).w
		cmpi.w	#$3000,(unk_FFF782).w
		blt.s	loc_10F1C
		move.w	#0,(unk_FFF782).w
		move.w	#$4000,(unk_FFF780).w
		addq.b	#2,$24(a0)
		move.w	#$12C,$38(a0)

loc_10F1C:
		move.w	(unk_FFF780).w,d0
		add.w	(unk_FFF782).w,d0
		move.w	d0,(unk_FFF780).w
		bsr.w	Sonic_Animate
		jsr	(Sonic_DynTiles).l
		bsr.w	SS_FixCamera
		jmp	(DisplaySprite).l
; ---------------------------------------------------------------------------

Obj09_Exit2:
		subq.w	#1,$38(a0)
		bne.s	loc_10F66
		clr.w	(unk_FFF780).w
		move.w	#$40,(unk_FFF782).w
		move.w	#$458,(v_objspace+8).w
		move.w	#$4A0,(v_objspace+$C).w
		clr.b	$24(a0)
		move.l	a0,-(sp)
		jsr	(SS_Load).l
		movea.l	(sp)+,a0

loc_10F66:
		jsr	(Sonic_Animate).l
		jsr	(Sonic_DynTiles).l
		bsr.w	SS_FixCamera
		jmp	(DisplaySprite).l
; ---------------------------------------------------------------------------

Obj09_Fall:
		move.l	$C(a0),d2
		move.l	8(a0),d3
		move.b	(unk_FFF780).w,d0
		andi.b	#$FC,d0
		jsr	(GetSine).l
		move.w	$10(a0),d4
		ext.l	d4
		asl.l	#8,d4
		muls.w	#$2A,d0
		add.l	d4,d0
		move.w	$12(a0),d4
		ext.l	d4
		asl.l	#8,d4
		muls.w	#$2A,d1
		add.l	d4,d1
		add.l	d0,d3
		bsr.w	sub_1100E
		beq.s	loc_10FD6
		sub.l	d0,d3
		moveq	#0,d0
		move.w	d0,$10(a0)
		bclr	#1,$22(a0)
		add.l	d1,d2
		bsr.w	sub_1100E
		beq.s	loc_10FEC
		sub.l	d1,d2
		moveq	#0,d1
		move.w	d1,$12(a0)
		rts
; ---------------------------------------------------------------------------

loc_10FD6:
		add.l	d1,d2
		bsr.w	sub_1100E
		beq.s	loc_10FFA
		sub.l	d1,d2
		moveq	#0,d1
		move.w	d1,$12(a0)
		bclr	#1,$22(a0)

loc_10FEC:
		asr.l	#8,d0
		asr.l	#8,d1
		move.w	d0,$10(a0)
		move.w	d1,$12(a0)
		rts
; ---------------------------------------------------------------------------

loc_10FFA:
		asr.l	#8,d0
		asr.l	#8,d1
		move.w	d0,$10(a0)
		move.w	d1,$12(a0)
		bset	#1,$22(a0)
		rts
; ---------------------------------------------------------------------------

sub_1100E:
		lea	($FF0000).l,a1
		moveq	#0,d4
		swap	d2
		move.w	d2,d4
		swap	d2
		addi.w	#$44,d4
		divu.w	#$18,d4
		mulu.w	#$80,d4
		adda.l	d4,a1
		moveq	#0,d4
		swap	d3
		move.w	d3,d4
		swap	d3
		addi.w	#$14,d4
		divu.w	#$18,d4
		adda.w	d4,a1
		moveq	#0,d5
		move.b	(a1)+,d4
		bsr.s	sub_11056
		move.b	(a1)+,d4
		bsr.s	sub_11056
		adda.w	#$7E,a1
		move.b	(a1)+,d4
		bsr.s	sub_11056
		move.b	(a1)+,d4
		bsr.s	sub_11056
		tst.b	d5
		rts
; ---------------------------------------------------------------------------

sub_11056:
		beq.s	locret_1105E
		cmpi.b	#$11,d4
		bne.s	loc_11060

locret_1105E:
		rts
; ---------------------------------------------------------------------------

loc_11060:
		cmpi.b	#$12,d4
		bcs.s	loc_11078
		cmpi.b	#$17,d4
		bcc.s	locret_1105E
		move.b	d4,$30(a0)
		move.l	a1,$32(a0)
		moveq	#-1,d5
		rts
; ---------------------------------------------------------------------------

loc_11078:
		moveq	#-1,d5
		rts
; ---------------------------------------------------------------------------

sub_1107C:
		lea	($FF0000).l,a1
		moveq	#0,d4
		move.w	$C(a0),d4
		addi.w	#$50,d4
		divu.w	#$18,d4
		mulu.w	#$80,d4
		adda.l	d4,a1
		moveq	#0,d4
		move.w	8(a0),d4
		addi.w	#$20,d4
		divu.w	#$18,d4
		adda.w	d4,a1
		move.b	(a1),d4
		bne.s	loc_110AE
		moveq	#0,d4
		rts
; ---------------------------------------------------------------------------

loc_110AE:
		cmpi.b	#$11,d4
		bne.s	loc_110D0
		bsr.w	sub_10ACC
		bne.s	loc_110C2
		move.b	#1,(a2)
		move.l	a1,4(a2)

loc_110C2:
		move.w	#$B5,d0
		jsr	(PlaySFX).l
		moveq	#0,d4
		rts
; ---------------------------------------------------------------------------

loc_110D0:
		cmpi.b	#$12,d4
		bne.s	loc_110DA
		moveq	#0,d4
		rts
; ---------------------------------------------------------------------------

loc_110DA:
		moveq	#-1,d4
		rts
; ---------------------------------------------------------------------------

sub_110DE:
		move.b	$30(a0),d0
		bne.s	loc_110FE
		subq.b	#1,$36(a0)
		bpl.s	loc_110F0
		move.b	#0,$36(a0)

loc_110F0:
		subq.b	#1,$37(a0)
		bpl.s	locret_110FC
		move.b	#0,$37(a0)

locret_110FC:
		rts
; ---------------------------------------------------------------------------

loc_110FE:
		cmpi.b	#$12,d0
		bne.s	loc_11176
		move.l	$32(a0),d1
		subi.l	#$FF0001,d1
		move.w	d1,d2
		andi.w	#$7F,d1
		mulu.w	#$18,d1
		subi.w	#$14,d1
		lsr.w	#7,d2
		andi.w	#$7F,d2
		mulu.w	#$18,d2
		subi.w	#$44,d2
		sub.w	8(a0),d1
		sub.w	$C(a0),d2
		jsr	(CalcAngle).l
		jsr	(GetSine).l
		muls.w	#$FB00,d1
		asr.l	#8,d1
		move.w	d1,$10(a0)
		muls.w	#$FB00,d0
		asr.l	#8,d0
		move.w	d0,$12(a0)
		bset	#1,$22(a0)
		bsr.w	sub_10ACC
		bne.s	loc_1116C
		move.b	#2,(a2)
		move.l	$32(a0),d0
		subq.l	#1,d0
		move.l	d0,4(a2)

loc_1116C:
		move.w	#$B4,d0
		jmp	(PlaySFX).l
; ---------------------------------------------------------------------------

loc_11176:
		cmpi.b	#$14,d0
		bne.s	loc_11182
		addq.b	#2,$24(a0)
		rts
; ---------------------------------------------------------------------------

loc_11182:
		cmpi.b	#$15,d0
		bne.s	loc_111A8
		tst.b	$36(a0)
		bne.s	locret_111C0
		move.b	#$1E,$36(a0)
		btst	#6,(unk_FFF783).w
		beq.s	loc_111A2
		asl	(unk_FFF782).w
		rts
; ---------------------------------------------------------------------------

loc_111A2:
		asr	(unk_FFF782).w
		rts
; ---------------------------------------------------------------------------

loc_111A8:
		cmpi.b	#$16,d0
		bne.s	locret_111C0
		tst.b	$37(a0)
		bne.s	locret_111C0
		move.b	#$1E,$37(a0)
		neg.w	(unk_FFF782).w
		rts
; ---------------------------------------------------------------------------

locret_111C0:
		rts
