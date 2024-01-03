; ---------------------------------------------------------------------------

ObjPlatform:
		moveq	#0,d0
		move.b	obj.Routine(a0),d0
		move.w	off_5918(pc,d0.w),d1
		jmp	off_5918(pc,d1.w)
; ---------------------------------------------------------------------------

off_5918:	dc.w loc_5922-off_5918, loc_59AE-off_5918, loc_59D2-off_5918, loc_5BCE-off_5918, loc_59C2-off_5918
; ---------------------------------------------------------------------------

loc_5922:
		addq.b	#2,obj.Routine(a0)
		move.w	#$4000,obj.Gfx(a0)
		move.l	#Map_Plat_GHZ,obj.Map(a0)
		move.b	#$20,obj.ActWid(a0)
		cmpi.b	#id_SZ,(v_zone).w
		bne.s	loc_5950
		move.l	#Map_Plat_SZ,obj.Map(a0)
		move.b	#$20,obj.ActWid(a0)

loc_5950:
		cmpi.b	#id_SLZ,(v_zone).w
		bne.s	loc_5972
		move.l	#Map_Plat_SLZ,obj.Map(a0)
		move.b	#$20,obj.ActWid(a0)
		move.w	#$4480,obj.Gfx(a0)
		move.b	#3,obj.Subtype(a0)

loc_5972:
		move.b	#4,obj.Render(a0)
		move.b	#4,obj.Priority(a0)
		move.w	obj.Ypos(a0),$2C(a0)
		move.w	obj.Ypos(a0),$34(a0)
		move.w	obj.Xpos(a0),$32(a0)
		move.w	#$80,obj.Angle(a0)
		moveq	#0,d1
		move.b	obj.Subtype(a0),d0
		cmpi.b	#$A,d0
		bne.s	loc_59AA
		addq.b	#1,d1
		move.b	#$20,obj.ActWid(a0)

loc_59AA:
		move.b	d1,obj.Frame(a0)

loc_59AE:
		tst.b	$38(a0)
		beq.s	loc_59B8
		subq.b	#4,$38(a0)

loc_59B8:
		moveq	#0,d1
		move.b	obj.ActWid(a0),d1
		bsr.w	PtfmNormal

loc_59C2:
		bsr.w	sub_5A1E
		bsr.w	sub_5A04
		bsr.w	DisplaySprite
		bra.w	loc_5BB0
; ---------------------------------------------------------------------------

loc_59D2:
		cmpi.b	#$40,$38(a0)
		beq.s	loc_59DE
		addq.b	#4,$38(a0)

loc_59DE:
		moveq	#0,d1
		move.b	obj.ActWid(a0),d1
		bsr.w	PtfmCheckExit
		move.w	obj.Xpos(a0),-(sp)
		bsr.w	sub_5A1E
		bsr.w	sub_5A04
		move.w	(sp)+,d2
		bsr.w	ptfmSurfaceNormal
		bsr.w	DisplaySprite
		bra.w	loc_5BB0
; ---------------------------------------------------------------------------
		rts
; ---------------------------------------------------------------------------

sub_5A04:
		move.b	$38(a0),d0
		bsr.w	CalcSine
		move.w	#$400,d1
		muls.w	d1,d0
		swap	d0
		add.w	$2C(a0),d0
		move.w	d0,obj.Ypos(a0)
		rts
; ---------------------------------------------------------------------------

sub_5A1E:
		moveq	#0,d0
		move.b	obj.Subtype(a0),d0
		andi.w	#$F,d0
		add.w	d0,d0
		move.w	off_5A32(pc,d0.w),d1
		jmp	off_5A32(pc,d1.w)
; ---------------------------------------------------------------------------

off_5A32:	dc.w locret_5A4C-off_5A32, loc_5A5E-off_5A32, loc_5AA4-off_5A32, loc_5ABC-off_5A32, loc_5AE4-off_5A32
		dc.w loc_5A4E-off_5A32, loc_5A94-off_5A32, loc_5B4E-off_5A32, loc_5B7A-off_5A32, locret_5A4C-off_5A32
		dc.w loc_5B92-off_5A32, loc_5A86-off_5A32, loc_5A76-off_5A32
; ---------------------------------------------------------------------------

locret_5A4C:
		rts
; ---------------------------------------------------------------------------

loc_5A4E:
		move.w	$32(a0),d0
		move.b	obj.Angle(a0),d1
		neg.b	d1
		addi.b	#$40,d1
		bra.s	loc_5A6A
; ---------------------------------------------------------------------------

loc_5A5E:
		move.w	$32(a0),d0
		move.b	obj.Angle(a0),d1
		subi.b	#$40,d1

loc_5A6A:
		ext.w	d1
		add.w	d1,d0
		move.w	d0,obj.Xpos(a0)
		bra.w	loc_5BA8
; ---------------------------------------------------------------------------

loc_5A76:
		move.w	$34(a0),d0
		move.b	(v_oscillate+$E).w,d1
		neg.b	d1
		addi.b	#$30,d1
		bra.s	loc_5AB0
; ---------------------------------------------------------------------------

loc_5A86:
		move.w	$34(a0),d0
		move.b	(v_oscillate+$E).w,d1
		subi.b	#$30,d1
		bra.s	loc_5AB0
; ---------------------------------------------------------------------------

loc_5A94:
		move.w	$34(a0),d0
		move.b	obj.Angle(a0),d1
		neg.b	d1
		addi.b	#$40,d1
		bra.s	loc_5AB0
; ---------------------------------------------------------------------------

loc_5AA4:
		move.w	$34(a0),d0
		move.b	obj.Angle(a0),d1
		subi.b	#$40,d1

loc_5AB0:
		ext.w	d1
		add.w	d1,d0
		move.w	d0,$2C(a0)
		bra.w	loc_5BA8
; ---------------------------------------------------------------------------

loc_5ABC:
		tst.w	$3A(a0)
		bne.s	loc_5AD2
		btst	#3,obj.Status(a0)
		beq.s	locret_5AD0
		move.w	#$1E,$3A(a0)

locret_5AD0:
		rts
; ---------------------------------------------------------------------------

loc_5AD2:
		subq.w	#1,$3A(a0)
		bne.s	locret_5AD0
		move.w	#$20,$3A(a0)
		addq.b	#1,obj.Subtype(a0)
		rts
; ---------------------------------------------------------------------------

loc_5AE4:
		tst.w	$3A(a0)
		beq.s	loc_5B20
		subq.w	#1,$3A(a0)
		bne.s	loc_5B20
		btst	#3,obj.Status(a0)
		beq.s	loc_5B1A
		bset	#1,obj.Status(a1)
		bclr	#3,obj.Status(a1)
		move.b	#2,obj.Routine(a1)
		bclr	#3,obj.Status(a0)
		clr.b	obj.Solid(a0)
		move.w	obj.VelY(a0),obj.VelY(a1)

loc_5B1A:
		move.b	#8,obj.Routine(a0)

loc_5B20:
		move.l	$2C(a0),d3
		move.w	obj.VelY(a0),d0
		ext.l	d0
		asl.l	#8,d0
		add.l	d0,d3
		move.l	d3,$2C(a0)
		addi.w	#$38,obj.VelY(a0)
		move.w	(v_limitbtm2).w,d0
		addi.w	#$E0,d0
		cmp.w	$2C(a0),d0
		bcc.s	locret_5B4C
		move.b	#6,obj.Routine(a0)

locret_5B4C:
		rts
; ---------------------------------------------------------------------------

loc_5B4E:
		tst.w	$3A(a0)
		bne.s	loc_5B6E
		lea	(f_switch).w,a2
		moveq	#0,d0
		move.b	obj.Subtype(a0),d0
		lsr.w	#4,d0
		tst.b	(a2,d0.w)
		beq.s	locret_5B6C
		move.w	#$3C,$3A(a0)

locret_5B6C:
		rts
; ---------------------------------------------------------------------------

loc_5B6E:
		subq.w	#1,$3A(a0)
		bne.s	locret_5B6C
		addq.b	#1,obj.Subtype(a0)
		rts
; ---------------------------------------------------------------------------

loc_5B7A:
		subq.w	#2,$2C(a0)
		move.w	$34(a0),d0
		subi.w	#$200,d0
		cmp.w	$2C(a0),d0
		bne.s	locret_5B90
		clr.b	obj.Subtype(a0)

locret_5B90:
		rts
; ---------------------------------------------------------------------------

loc_5B92:
		move.w	$34(a0),d0
		move.b	obj.Angle(a0),d1
		subi.b	#$40,d1
		ext.w	d1
		asr.w	#1,d1
		add.w	d1,d0
		move.w	d0,$2C(a0)

loc_5BA8:
		move.b	(v_oscillate+$1A).w,obj.Angle(a0)
		rts
; ---------------------------------------------------------------------------

loc_5BB0:
		out_of_range.s	loc_5BCE,$32(a0)
		rts
; ---------------------------------------------------------------------------

loc_5BCE:
		bra.w	DeleteObject
