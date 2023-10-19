; ---------------------------------------------------------------------------

ObjLavafallMaker:
		moveq	#0,d0
		move.b	objRoutine(a0),d0
		move.w	off_C926(pc,d0.w),d1
		jsr	off_C926(pc,d1.w)
		bra.w	loc_CB28
; ---------------------------------------------------------------------------

off_C926:	dc.w loc_C932-off_C926, loc_C95C-off_C926, loc_C9CE-off_C926, loc_C982-off_C926, loc_C9DA-off_C926
		dc.w loc_C9EA-off_C926
; ---------------------------------------------------------------------------

loc_C932:
		addq.b	#2,objRoutine(a0)
		move.l	#Map_Geyser,objMap(a0)
		move.w	#$E3A8,objGfx(a0)
		move.b	#4,objRender(a0)
		move.b	#1,objPriority(a0)
		move.b	#$38,objActWid(a0)
		move.w	#$78,$34(a0)

loc_C95C:
		subq.w	#1,$32(a0)
		bpl.s	locret_C980
		move.w	$34(a0),$32(a0)
		move.w	(v_objspace+objY).w,d0
		move.w	objY(a0),d1
		cmp.w	d1,d0
		bcc.s	locret_C980
		subi.w	#$170,d1
		cmp.w	d1,d0
		bcs.s	locret_C980
		addq.b	#2,objRoutine(a0)

locret_C980:
		rts
; ---------------------------------------------------------------------------

loc_C982:
		addq.b	#2,objRoutine(a0)
		bsr.w	FindNextFreeObj
		bne.s	loc_C9A8
		move.b	#id_LavaGeyser,objId(a1)
		move.w	objX(a0),objX(a1)
		move.w	objY(a0),objY(a1)
		move.b	objSubtype(a0),objSubtype(a1)
		move.l	a0,$3C(a1)

loc_C9A8:
		move.b	#1,objAnim(a0)
		tst.b	objSubtype(a0)
		beq.s	loc_C9BC
		move.b	#4,objAnim(a0)
		bra.s	loc_C9DA
; ---------------------------------------------------------------------------

loc_C9BC:
		movea.l	$3C(a0),a1
		bset	#1,objStatus(a1)
		move.w	#$FA80,objVelY(a1)
		bra.s	loc_C9DA
; ---------------------------------------------------------------------------

loc_C9CE:
		tst.b	objSubtype(a0)
		beq.s	loc_C9DA
		addq.b	#2,objRoutine(a0)
		rts
; ---------------------------------------------------------------------------

loc_C9DA:
		lea	(Ani_Geyser).l,a1
		bsr.w	AnimateSprite
		bsr.w	DisplaySprite
		rts
; ---------------------------------------------------------------------------

loc_C9EA:
		move.b	#0,objAnim(a0)
		move.b	#2,objRoutine(a0)
		tst.b	objSubtype(a0)
		beq.w	DeleteObject
		rts
; ---------------------------------------------------------------------------

ObjLavafall:
		moveq	#0,d0
		move.b	objRoutine(a0),d0
		move.w	off_CA12(pc,d0.w),d1
		jsr	off_CA12(pc,d1.w)
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

off_CA12:	dc.w loc_CA1E-off_CA12, loc_CB0A-off_CA12, sub_CB8C-off_CA12, loc_CBEA-off_CA12

word_CA1A:	dc.w $FB00
		dc.w 0
; ---------------------------------------------------------------------------

loc_CA1E:
		addq.b	#2,objRoutine(a0)
		move.w	objY(a0),$30(a0)
		tst.b	objSubtype(a0)
		beq.s	loc_CA34
		subi.w	#$250,objY(a0)

loc_CA34:
		moveq	#0,d0
		move.b	objSubtype(a0),d0
		add.w	d0,d0
		move.w	word_CA1A(pc,d0.w),objVelY(a0)
		movea.l	a0,a1
		moveq	#1,d1
		bsr.s	sub_CA50
		bra.s	loc_CAA0
; ---------------------------------------------------------------------------

sub_CA4A:
		bsr.w	FindNextFreeObj
		bne.s	loc_CA9A
; ---------------------------------------------------------------------------

sub_CA50:
		move.b	#id_LavaGeyser,objId(a1)
		move.l	#Map_Geyser,objMap(a1)
		move.w	#$63A8,objGfx(a1)
		move.b	#4,objRender(a1)
		move.b	#$20,objActWid(a1)
		move.w	objX(a0),objX(a1)
		move.w	objY(a0),objY(a1)
		move.b	objSubtype(a0),objSubtype(a1)
		move.b	#1,objPriority(a1)
		move.b	#5,objAnim(a1)
		tst.b	objSubtype(a0)
		beq.s	loc_CA9A
		move.b	#2,objAnim(a1)

loc_CA9A:
		dbf	d1,sub_CA4A
		rts
; ---------------------------------------------------------------------------

loc_CAA0:
		addi.w	#$60,objY(a1)
		move.w	$30(a0),$30(a1)
		addi.w	#$60,$30(a1)
		move.b	#$93,objColType(a1)
		move.b	#$80,objHeight(a1)
		bset	#4,objRender(a1)
		addq.b	#4,objRoutine(a1)
		move.l	a0,$3C(a1)
		tst.b	objSubtype(a0)
		beq.s	loc_CB00
		moveq	#0,d1
		bsr.w	sub_CA4A
		addq.b	#2,objRoutine(a1)
		bset	#4,2(a1)
		addi.w	#$100,objY(a1)
		move.b	#0,objPriority(a1)
		move.w	$30(a0),$30(a1)
		move.l	$3C(a0),$3C(a1)
		move.b	#0,objSubtype(a0)

loc_CB00:
		move.w	#sfx_Burning,d0
		jsr	(PlaySound_Special).l

loc_CB0A:
		moveq	#0,d0
		move.b	objSubtype(a0),d0
		add.w	d0,d0
		move.w	off_CB48(pc,d0.w),d1
		jsr	off_CB48(pc,d1.w)
		bsr.w	SpeedToPos
		lea	(Ani_Geyser).l,a1
		bsr.w	AnimateSprite

loc_CB28:
		out_of_range.w	DeleteObject
		rts
; ---------------------------------------------------------------------------

off_CB48:	dc.w loc_CB4C-off_CB48, loc_CB6C-off_CB48
; ---------------------------------------------------------------------------

loc_CB4C:
		addi.w	#$18,objVelY(a0)
		move.w	$30(a0),d0
		cmp.w	objY(a0),d0
		bcc.s	locret_CB6A
		addq.b	#4,objRoutine(a0)
		movea.l	$3C(a0),a1
		move.b	#3,objAnim(a1)

locret_CB6A:
		rts
; ---------------------------------------------------------------------------

loc_CB6C:
		addi.w	#$18,objVelY(a0)
		move.w	$30(a0),d0
		cmp.w	objY(a0),d0
		bcc.s	locret_CB8A
		addq.b	#4,objRoutine(a0)
		movea.l	$3C(a0),a1
		move.b	#1,objAnim(a1)

locret_CB8A:
		rts
; ---------------------------------------------------------------------------

sub_CB8C:
		movea.l	$3C(a0),a1
		cmpi.b	#6,objRoutine(a1)
		beq.w	loc_CBEA
		move.w	objY(a1),d0
		addi.w	#$60,d0
		move.w	d0,objY(a0)
		sub.w	$30(a0),d0
		neg.w	d0
		moveq	#8,d1
		cmpi.w	#$40,d0
		bge.s	loc_CBB6
		moveq	#$B,d1

loc_CBB6:
		cmpi.w	#$80,d0
		ble.s	loc_CBBE
		moveq	#$E,d1

loc_CBBE:
		subq.b	#1,objTimeFrame(a0)
		bpl.s	loc_CBDC
		move.b	#7,objTimeFrame(a0)
		addq.b	#1,objAniFrame(a0)
		cmpi.b	#2,objAniFrame(a0)
		bcs.s	loc_CBDC
		move.b	#0,objAniFrame(a0)

loc_CBDC:
		move.b	objAniFrame(a0),d0
		add.b	d1,d0
		move.b	d0,objFrame(a0)
		bra.w	loc_CB28
; ---------------------------------------------------------------------------

loc_CBEA:
		bra.w	DeleteObject