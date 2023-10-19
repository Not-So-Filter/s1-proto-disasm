; ---------------------------------------------------------------------------

ObjSwingPtfm:
		moveq	#0,d0
		move.b	objRoutine(a0),d0
		move.w	off_548A(pc,d0.w),d1
		jmp	off_548A(pc,d1.w)
; ---------------------------------------------------------------------------

off_548A:	dc.w ObjSwingPtfm_Init-off_548A, loc_55C8-off_548A, loc_55E4-off_548A, ObjSwingPtfm_Delete-off_548A
		dc.w ObjSwingPtfm_Delete-off_548A, j_DisplaySprite-off_548A
; ---------------------------------------------------------------------------

ObjSwingPtfm_Init:
		addq.b	#2,objRoutine(a0)
		move.l	#Map_Swing_GHZ,objMap(a0)
		move.w	#$4380,objGfx(a0)
		move.b	#4,objRender(a0)
		move.b	#3,objPriority(a0)
		move.b	#$18,objActWid(a0)
		move.b	#8,objHeight(a0)
		move.w	objY(a0),$38(a0)
		move.w	objX(a0),$3A(a0)
		cmpi.b	#id_SLZ,(v_zone).w	; are we on Star Light Zone?
		bne.s	ObjSwingPtfm_NotSLZ	; if not, branch
		move.l	#Map_Swing_SLZ,objMap(a0)
		move.w	#$43DC,objGfx(a0)
		move.b	#$20,objActWid(a0)
		move.b	#$10,objHeight(a0)
		move.b	#$99,objColType(a0)

ObjSwingPtfm_NotSLZ:
		move.b	objId(a0),d4
		moveq	#0,d1
		lea	objSubtype(a0),a2
		move.b	(a2),d1
		move.w	d1,-(sp)
		andi.w	#$F,d1
		move.b	#0,(a2)+
		move.w	d1,d3
		lsl.w	#4,d3
		addq.b	#8,d3
		move.b	d3,$3C(a0)
		subq.b	#8,d3
		tst.b	objFrame(a0)
		beq.s	ObjSwingPtfm_LoadLinks
		addq.b	#8,d3
		subq.w	#1,d1

ObjSwingPtfm_LoadLinks:
		bsr.w	FindFreeObj
		bne.s	loc_5586
		addq.b	#1,objSubtype(a0)
		move.w	a1,d5
		subi.w	#$D000,d5
		lsr.w	#6,d5
		andi.w	#$7F,d5
		move.b	d5,(a2)+
		move.b	#$A,objRoutine(a1)
		move.b	d4,objId(a1)
		move.l	objMap(a0),objMap(a1)
		move.w	objGfx(a0),objGfx(a1)
		bclr	#6,2(a1)
		move.b	#4,objRender(a1)
		move.b	#4,objPriority(a1)
		move.b	#8,objActWid(a1)
		move.b	#1,objFrame(a1)
		move.b	d3,$3C(a1)
		subi.b	#$10,d3
		bcc.s	loc_5582
		move.b	#2,objFrame(a1)
		bset	#6,2(a1)

loc_5582:
		dbf	d1,ObjSwingPtfm_LoadLinks

loc_5586:
		move.w	a0,d5
		subi.w	#v_objspace,d5
		lsr.w	#6,d5
		andi.w	#$7F,d5
		move.b	d5,(a2)+
		move.w	#$4080,objAngle(a0)
		move.w	#$FE00,$3E(a0)
		move.w	(sp)+,d1
		btst	#4,d1
		beq.s	loc_55C8
		move.l	#Map_GBall,objMap(a0)
		move.w	#$43AA,objGfx(a0)
		move.b	#1,objFrame(a0)
		move.b	#2,objPriority(a0)
		move.b	#$81,objColType(a0)

loc_55C8:
		moveq	#0,d1
		move.b	objActWid(a0),d1
		moveq	#0,d3
		move.b	objHeight(a0),d3
		bsr.w	PtfmNormalHeight
		bsr.w	sub_563C
		bsr.w	DisplaySprite
		bra.w	ObjSwingPtfm_ChkDelete
; ---------------------------------------------------------------------------

loc_55E4:
		moveq	#0,d1
		move.b	objActWid(a0),d1
		bsr.w	PtfmCheckExit
		move.w	objX(a0),-(sp)
		bsr.w	sub_563C
		move.w	(sp)+,d2
		moveq	#0,d3
		move.b	objHeight(a0),d3
		addq.b	#1,d3
		bsr.w	PtfmSurfaceHeight
		bsr.w	DisplaySprite
		bra.w	ObjSwingPtfm_ChkDelete
; ---------------------------------------------------------------------------
		rts
; ---------------------------------------------------------------------------

PtfmSurfaceHeight:
		lea	(v_objspace).w,a1
		move.w	objY(a0),d0
		sub.w	d3,d0
		bra.s	loc_5626
; ---------------------------------------------------------------------------

ptfmSurfaceNormal:
		lea	(v_objspace).w,a1
		move.w	objY(a0),d0
		subi.w	#9,d0

loc_5626:
		moveq	#0,d1
		move.b	objHeight(a1),d1
		sub.w	d1,d0
		move.w	d0,objY(a1)
		sub.w	objX(a0),d2
		sub.w	d2,objX(a1)
		rts
; ---------------------------------------------------------------------------

sub_563C:
		move.b	(v_oscillate+$1A).w,d0
		move.w	#$80,d1
		btst	#0,objStatus(a0)
		beq.s	loc_5650
		neg.w	d0
		add.w	d1,d0

loc_5650:
		bra.s	loc_5692
; ---------------------------------------------------------------------------

loc_5652:
		tst.b	$3D(a0)
		bne.s	loc_5674
		move.w	$3E(a0),d0
		addq.w	#8,d0
		move.w	d0,$3E(a0)
		add.w	d0,objAngle(a0)
		cmpi.w	#$200,d0
		bne.s	loc_568E
		move.b	#1,$3D(a0)
		bra.s	loc_568E
; ---------------------------------------------------------------------------

loc_5674:
		move.w	$3E(a0),d0
		subq.w	#8,d0
		move.w	d0,$3E(a0)
		add.w	d0,objAngle(a0)
		cmpi.w	#$FE00,d0
		bne.s	loc_568E
		move.b	#0,$3D(a0)

loc_568E:
		move.b	objAngle(a0),d0

loc_5692:
		bsr.w	CalcSine
		move.w	$38(a0),d2
		move.w	$3A(a0),d3
		lea	objSubtype(a0),a2
		moveq	#0,d6
		move.b	(a2)+,d6

loc_56A6:
		moveq	#0,d4
		move.b	(a2)+,d4
		lsl.w	#6,d4
		addi.l	#v_objspace&$FFFFFF,d4
		movea.l	d4,a1
		moveq	#0,d4
		move.b	$3C(a1),d4
		move.l	d4,d5
		muls.w	d0,d4
		asr.l	#8,d4
		muls.w	d1,d5
		asr.l	#8,d5
		add.w	d2,d4
		add.w	d3,d5
		move.w	d4,objY(a1)
		move.w	d5,objX(a1)
		dbf	d6,loc_56A6
		rts
; ---------------------------------------------------------------------------

ObjSwingPtfm_ChkDelete:
		out_of_range.w	ObjSwingPtfm_DeleteAll,$3A(a0)
		rts
; ---------------------------------------------------------------------------

ObjSwingPtfm_DeleteAll:
		moveq	#0,d2
		lea	objSubtype(a0),a2
		move.b	(a2)+,d2

loc_56FE:
		moveq	#0,d0
		move.b	(a2)+,d0
		lsl.w	#6,d0
		addi.l	#v_objspace&$FFFFFF,d0
		movea.l	d0,a1
		bsr.w	ObjectDeleteA1
		dbf	d2,loc_56FE
		rts
; ---------------------------------------------------------------------------

ObjSwingPtfm_Delete:
		bsr.w	DeleteObject
		rts
; ---------------------------------------------------------------------------
; Attributes: thunk

j_DisplaySprite:
		bra.w	DisplaySprite
