; ---------------------------------------------------------------------------

ObjChainPtfm:
		moveq	#0,d0
		move.b	obj.Routine(a0),d0
		move.w	off_96C2(pc,d0.w),d1
		jmp	off_96C2(pc,d1.w)
; ---------------------------------------------------------------------------

off_96C2:	dc.w loc_96EA-off_96C2, loc_97D0-off_96C2, loc_9834-off_96C2, loc_9846-off_96C2, loc_9818-off_96C2

byte_96CC:	dc.b 0, 0
		dc.b 1, 0

byte_96D0:	dc.b 2, 0, 0
		dc.b 4, $1C, 1
		dc.b 8, $CC, 3
		dc.b 6, $F0, 2

word_96DC:	dc.w $7000, $A000
		dc.w $5000, $7800
		dc.w $3800, $5800
		dc.w $B800
; ---------------------------------------------------------------------------

loc_96EA:
		moveq	#0,d0
		move.b	obj.Subtype(a0),d0
		bpl.s	loc_9706
		andi.w	#$7F,d0
		add.w	d0,d0
		lea	byte_96CC(pc,d0.w),a2
		move.b	(a2)+,$3A(a0)
		move.b	(a2)+,d0
		move.b	d0,obj.Subtype(a0)

loc_9706:
		andi.b	#$F,d0
		add.w	d0,d0
		move.w	word_96DC(pc,d0.w),d2
		tst.w	d0
		bne.s	loc_9718
		move.w	d2,$32(a0)

loc_9718:
		lea	(byte_96D0).l,a2
		movea.l	a0,a1
		moveq	#3,d1
		bra.s	loc_972C
; ---------------------------------------------------------------------------

loc_9724:
		bsr.w	FindNextFreeObj
		bne.w	loc_97B0

loc_972C:
		move.b	(a2)+,obj.Routine(a1)
		_move.b	#id_ChainStomp,obj.Id(a1)
		move.w	obj.Xpos(a0),obj.Xpos(a1)
		move.b	(a2)+,d0
		ext.w	d0
		add.w	obj.Ypos(a0),d0
		move.w	d0,obj.Ypos(a1)
		move.l	#Map_CStom,obj.Map(a1)
		move.w	#$300,obj.Gfx(a1)
		move.b	#4,obj.Render(a1)
		move.w	obj.Ypos(a1),$30(a1)
		move.b	obj.Subtype(a0),obj.Subtype(a1)
		move.b	#$10,obj.ActWid(a1)
		move.w	d2,$34(a1)
		move.b	#4,obj.Priority(a1)
		move.b	(a2)+,obj.Frame(a1)
		cmpi.b	#1,obj.Frame(a1)
		bne.s	loc_97A2
		subq.w	#1,d1
		move.b	obj.Subtype(a0),d0
		andi.w	#$F0,d0
		cmpi.w	#$20,d0
		beq.s	loc_972C
		move.b	#$38,obj.ActWid(a1)
		move.b	#$90,obj.ColType(a1)
		addq.w	#1,d1

loc_97A2:
		move.l	a0,$3C(a1)
		dbf	d1,loc_9724
		move.b	#3,obj.Priority(a1)

loc_97B0:
		moveq	#0,d0
		move.b	obj.Subtype(a0),d0
		lsr.w	#3,d0
		andi.b	#$E,d0
		lea	byte_97CA(pc,d0.w),a2
		move.b	(a2)+,obj.ActWid(a0)
		move.b	(a2)+,obj.Frame(a0)
		bra.s	loc_97D0
; ---------------------------------------------------------------------------

byte_97CA:	dc.b $38, 0
		dc.b $30, 9
		dc.b $10, $A
; ---------------------------------------------------------------------------

loc_97D0:
		bsr.w	sub_986A
		move.w	obj.Ypos(a0),(v_obj31ypos).w
		moveq	#0,d1
		move.b	obj.ActWid(a0),d1
		addi.w	#$B,d1
		move.w	#$C,d2
		move.w	#$D,d3
		move.w	obj.Xpos(a0),d4
		bsr.w	SolidObject
		btst	#3,obj.Status(a0)
		beq.s	loc_9810
		cmpi.b	#$10,$32(a0)
		bcc.s	loc_9810
		movea.l	a0,a2
		lea	(v_objspace).w,a0
		bsr.w	loc_FD78
		movea.l	a2,a0

loc_9810:
		bsr.w	DisplaySprite
		bra.w	loc_984A
; ---------------------------------------------------------------------------

loc_9818:
		move.b	#$80,obj.Height(a0)
		bset	#4,obj.Render(a0)
		movea.l	$3C(a0),a1
		move.b	$32(a1),d0
		lsr.b	#5,d0
		addq.b	#3,d0
		move.b	d0,obj.Frame(a0)

loc_9834:
		movea.l	$3C(a0),a1
		moveq	#0,d0
		move.b	$32(a1),d0
		add.w	$30(a0),d0
		move.w	d0,obj.Ypos(a0)

loc_9846:
		bsr.w	DisplaySprite

loc_984A:
		out_of_range.w	DeleteObject
		rts
; ---------------------------------------------------------------------------

sub_986A:
		move.b	obj.Subtype(a0),d0
		andi.w	#$F,d0
		add.w	d0,d0
		move.w	off_987C(pc,d0.w),d1
		jmp	off_987C(pc,d1.w)
; ---------------------------------------------------------------------------

off_987C:	dc.w loc_988A-off_987C, loc_9926-off_987C, loc_9926-off_987C, loc_99B6-off_987C, loc_9926-off_987C
		dc.w loc_99B6-off_987C, loc_9926-off_987C
; ---------------------------------------------------------------------------

loc_988A:
		lea	(f_switch).w,a2
		moveq	#0,d0
		move.b	$3A(a0),d0
		tst.b	(a2,d0.w)
		beq.s	loc_98DE
		tst.w	(v_obj31ypos).w
		bpl.s	loc_98A8
		cmpi.b	#$10,$32(a0)
		beq.s	loc_98D6

loc_98A8:
		tst.w	$32(a0)
		beq.s	loc_98D6
		move.b	(v_vbla_byte).w,d0
		andi.b	#$F,d0
		bne.s	loc_98C8
		tst.b	obj.Render(a0)
		bpl.s	loc_98C8
		move.w	#sfx_ChainRise,d0
		jsr	(PlaySound_Special).l

loc_98C8:
		subi.w	#$80,$32(a0)
		bcc.s	loc_9916
		move.w	#0,$32(a0)

loc_98D6:
		move.w	#0,obj.VelY(a0)
		bra.s	loc_9916
; ---------------------------------------------------------------------------

loc_98DE:
		move.w	$34(a0),d1
		cmp.w	$32(a0),d1
		beq.s	loc_9916
		move.w	obj.VelY(a0),d0
		addi.w	#$70,obj.VelY(a0)
		add.w	d0,$32(a0)
		cmp.w	$32(a0),d1
		bhi.s	loc_9916
		move.w	d1,$32(a0)
		move.w	#0,obj.VelY(a0)
		tst.b	obj.Render(a0)
		bpl.s	loc_9916
		move.w	#sfx_ChainStomp,d0
		jsr	(PlaySound_Special).l

loc_9916:
		moveq	#0,d0
		move.b	$32(a0),d0
		add.w	$30(a0),d0
		move.w	d0,obj.Ypos(a0)
		rts
; ---------------------------------------------------------------------------

loc_9926:
		tst.w	$36(a0)
		beq.s	loc_996E
		tst.w	$38(a0)
		beq.s	loc_9938
		subq.w	#1,$38(a0)
		bra.s	loc_99B2
; ---------------------------------------------------------------------------

loc_9938:
		move.b	(v_vbla_byte).w,d0
		andi.b	#$F,d0
		bne.s	loc_9952
		tst.b	obj.Render(a0)
		bpl.s	loc_9952
		move.w	#sfx_ChainRise,d0
		jsr	(PlaySound_Special).l

loc_9952:
		subi.w	#$80,$32(a0)
		bcc.s	loc_99B2
		move.w	#0,$32(a0)
		move.w	#0,obj.VelY(a0)
		move.w	#0,$36(a0)
		bra.s	loc_99B2
; ---------------------------------------------------------------------------

loc_996E:
		move.w	$34(a0),d1
		cmp.w	$32(a0),d1
		beq.s	loc_99B2
		move.w	obj.VelY(a0),d0
		addi.w	#$70,obj.VelY(a0)
		add.w	d0,$32(a0)
		cmp.w	$32(a0),d1
		bhi.s	loc_99B2
		move.w	d1,$32(a0)
		move.w	#0,obj.VelY(a0)
		move.w	#1,$36(a0)
		move.w	#$3C,$38(a0)
		tst.b	obj.Render(a0)
		bpl.s	loc_99B2
		move.w	#sfx_ChainStomp,d0
		jsr	(PlaySound_Special).l

loc_99B2:
		bra.w	loc_9916
; ---------------------------------------------------------------------------

loc_99B6:
		move.w	(v_objspace+obj.Xpos).w,d0
		sub.w	obj.Xpos(a0),d0
		bcc.s	loc_99C2
		neg.w	d0

loc_99C2:
		cmpi.w	#$90,d0
		bcc.s	loc_99CC
		addq.b	#1,obj.Subtype(a0)

loc_99CC:
		bra.w	loc_9916