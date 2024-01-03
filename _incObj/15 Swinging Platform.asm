; ---------------------------------------------------------------------------

ObjSwingPtfm:
		moveq	#0,d0
		move.b	obj.Routine(a0),d0
		move.w	off_548A(pc,d0.w),d1
		jmp	off_548A(pc,d1.w)
; ---------------------------------------------------------------------------

off_548A:	dc.w ObjSwingPtfm_Init-off_548A, loc_55C8-off_548A, loc_55E4-off_548A, ObjSwingPtfm_Delete-off_548A
		dc.w ObjSwingPtfm_Delete-off_548A, j_DisplaySprite-off_548A
; ---------------------------------------------------------------------------

ObjSwingPtfm_Init:
		addq.b	#2,obj.Routine(a0)
		move.l	#Map_Swing_GHZ,obj.Map(a0)
		move.w	#$4380,obj.Gfx(a0)
		move.b	#4,obj.Render(a0)
		move.b	#3,obj.Priority(a0)
		move.b	#$18,obj.ActWid(a0)
		move.b	#8,obj.Height(a0)
		move.w	obj.Ypos(a0),$38(a0)
		move.w	obj.Xpos(a0),$3A(a0)
		cmpi.b	#id_SLZ,(v_zone).w		; are we on Star Light Zone?
		bne.s	ObjSwingPtfm_NotSLZ		; if not, branch
		move.l	#Map_Swing_SLZ,obj.Map(a0)
		move.w	#$43DC,obj.Gfx(a0)
		move.b	#$20,obj.ActWid(a0)
		move.b	#$10,obj.Height(a0)
		move.b	#$99,obj.ColType(a0)

ObjSwingPtfm_NotSLZ:
		_move.b	obj.Id(a0),d4
		moveq	#0,d1
		lea	obj.Subtype(a0),a2
		move.b	(a2),d1
		move.w	d1,-(sp)
		andi.w	#$F,d1
		move.b	#0,(a2)+
		move.w	d1,d3
		lsl.w	#4,d3
		addq.b	#8,d3
		move.b	d3,$3C(a0)
		subq.b	#8,d3
		tst.b	obj.Frame(a0)
		beq.s	ObjSwingPtfm_LoadLinks
		addq.b	#8,d3
		subq.w	#1,d1

ObjSwingPtfm_LoadLinks:
		bsr.w	FindFreeObj
		bne.s	loc_5586
		addq.b	#1,obj.Subtype(a0)
		move.w	a1,d5
		subi.w	#v_objspace,d5
		lsr.w	#6,d5
		andi.w	#$7F,d5
		move.b	d5,(a2)+
		move.b	#$A,obj.Routine(a1)
		_move.b	d4,obj.Id(a1)
		move.l	obj.Map(a0),obj.Map(a1)
		move.w	obj.Gfx(a0),obj.Gfx(a1)
		bclr	#6,2(a1)
		move.b	#4,obj.Render(a1)
		move.b	#4,obj.Priority(a1)
		move.b	#8,obj.ActWid(a1)
		move.b	#1,obj.Frame(a1)
		move.b	d3,$3C(a1)
		subi.b	#$10,d3
		bcc.s	loc_5582
		move.b	#2,obj.Frame(a1)
		bset	#6,2(a1)

loc_5582:
		dbf	d1,ObjSwingPtfm_LoadLinks

loc_5586:
		move.w	a0,d5
		subi.w	#v_objspace,d5
		lsr.w	#6,d5
		andi.w	#$7F,d5
		move.b	d5,(a2)+
		move.w	#$4080,obj.Angle(a0)
		move.w	#$FE00,$3E(a0)
		move.w	(sp)+,d1
		btst	#4,d1
		beq.s	loc_55C8
		move.l	#Map_GBall,obj.Map(a0)
		move.w	#$43AA,obj.Gfx(a0)
		move.b	#1,obj.Frame(a0)
		move.b	#2,obj.Priority(a0)
		move.b	#$81,obj.ColType(a0)

loc_55C8:
		moveq	#0,d1
		move.b	obj.ActWid(a0),d1
		moveq	#0,d3
		move.b	obj.Height(a0),d3
		bsr.w	PtfmNormalHeight
		bsr.w	sub_563C
		bsr.w	DisplaySprite
		bra.w	ObjSwingPtfm_ChkDelete
; ---------------------------------------------------------------------------

loc_55E4:
		moveq	#0,d1
		move.b	obj.ActWid(a0),d1
		bsr.w	PtfmCheckExit
		move.w	obj.Xpos(a0),-(sp)
		bsr.w	sub_563C
		move.w	(sp)+,d2
		moveq	#0,d3
		move.b	obj.Height(a0),d3
		addq.b	#1,d3
		bsr.w	PtfmSurfaceHeight
		bsr.w	DisplaySprite
		bra.w	ObjSwingPtfm_ChkDelete
; ---------------------------------------------------------------------------
		rts
; ---------------------------------------------------------------------------

PtfmSurfaceHeight:
		lea	(v_objspace).w,a1
		move.w	obj.Ypos(a0),d0
		sub.w	d3,d0
		bra.s	loc_5626
; ---------------------------------------------------------------------------

ptfmSurfaceNormal:
		lea	(v_objspace).w,a1
		move.w	obj.Ypos(a0),d0
		subi.w	#9,d0

loc_5626:
		moveq	#0,d1
		move.b	obj.Height(a1),d1
		sub.w	d1,d0
		move.w	d0,obj.Ypos(a1)
		sub.w	obj.Xpos(a0),d2
		sub.w	d2,obj.Xpos(a1)
		rts
; ---------------------------------------------------------------------------

sub_563C:
		move.b	(v_oscillate+$1A).w,d0
		move.w	#$80,d1
		btst	#0,obj.Status(a0)
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
		add.w	d0,obj.Angle(a0)
		cmpi.w	#$200,d0
		bne.s	loc_568E
		move.b	#1,$3D(a0)
		bra.s	loc_568E
; ---------------------------------------------------------------------------

loc_5674:
		move.w	$3E(a0),d0
		subq.w	#8,d0
		move.w	d0,$3E(a0)
		add.w	d0,obj.Angle(a0)
		cmpi.w	#$FE00,d0
		bne.s	loc_568E
		move.b	#0,$3D(a0)

loc_568E:
		move.b	obj.Angle(a0),d0

loc_5692:
		bsr.w	CalcSine
		move.w	$38(a0),d2
		move.w	$3A(a0),d3
		lea	obj.Subtype(a0),a2
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
		move.w	d4,obj.Ypos(a1)
		move.w	d5,obj.Xpos(a1)
		dbf	d6,loc_56A6
		rts
; ---------------------------------------------------------------------------

ObjSwingPtfm_ChkDelete:
		out_of_range.w	ObjSwingPtfm_DeleteAll,$3A(a0)
		rts
; ---------------------------------------------------------------------------

ObjSwingPtfm_DeleteAll:
		moveq	#0,d2
		lea	obj.Subtype(a0),a2
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
