; ---------------------------------------------------------------------------

ObjCollapsePtfm:
		moveq	#0,d0
		move.b	objRoutine(a0),d0
		move.w	off_5EEE(pc,d0.w),d1
		jmp	off_5EEE(pc,d1.w)
; ---------------------------------------------------------------------------

off_5EEE:	dc.w loc_5EFA-off_5EEE, loc_5F2A-off_5EEE, loc_5F4E-off_5EEE, loc_5F7E-off_5EEE, loc_5FDE-off_5EEE
		dc.w sub_5F60-off_5EEE

ledge_timedelay: = objOff_38		; time between touching the ledge and it collapsing
ledge_collapse_flag: = objOff_3A		; collapse flag
; ---------------------------------------------------------------------------

loc_5EFA:
		addq.b	#2,objRoutine(a0)
		move.l	#Map_Ledge,objMap(a0)
		move.w	#$4000,objGfx(a0)
		ori.b	#4,objRender(a0)
		move.b	#4,objPriority(a0)
		move.b	#7,ledge_timedelay(a0)
		move.b	#$64,objActWid(a0)
		move.b	objSubtype(a0),objFrame(a0)

loc_5F2A:
		tst.b	ledge_collapse_flag(a0)
		beq.s	loc_5F3C
		tst.b	ledge_timedelay(a0)
		beq.w	loc_612A
		subq.b	#1,ledge_timedelay(a0)

loc_5F3C:
		move.w	#$30,d1
		lea	(ObjCollapsePtfm_Slope).l,a2
		bsr.w	PtfmSloped
		bra.w	RememberState
; ---------------------------------------------------------------------------

loc_5F4E:
		tst.b	ledge_timedelay(a0)
		beq.w	loc_6130
		move.b	#1,ledge_collapse_flag(a0)
		subq.b	#1,ledge_timedelay(a0)
; ---------------------------------------------------------------------------

sub_5F60:
		move.w	#$30,d1
		bsr.w	PtfmCheckExit
		move.w	#$30,d1
		lea	(ObjCollapsePtfm_Slope).l,a2
		move.w	objX(a0),d2
		bsr.w	sub_61E0
		bra.w	RememberState
; ---------------------------------------------------------------------------

loc_5F7E:
		tst.b	ledge_timedelay(a0)
		beq.s	loc_5FCE
		tst.b	ledge_collapse_flag(a0)
		bne.w	loc_5F94
		subq.b	#1,ledge_timedelay(a0)
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

loc_5F94:
		subq.b	#1,ledge_timedelay(a0)
		bsr.w	sub_5F60
		lea	(v_objspace).w,a1
		btst	#3,objStatus(a1)
		beq.s	loc_5FC0
		tst.b	ledge_timedelay(a0)
		bne.s	locret_5FCC
		bclr	#3,objStatus(a1)
		bclr	#5,objStatus(a1)
		move.b	#1,objNextAni(a1)

loc_5FC0:
		move.b	#0,ledge_collapse_flag(a0)
		move.b	#6,objRoutine(a0)

locret_5FCC:
		rts
; ---------------------------------------------------------------------------

loc_5FCE:
		bsr.w	ObjectFall
		bsr.w	DisplaySprite
		tst.b	objRender(a0)
		bpl.s	loc_5FDE
		rts
; ---------------------------------------------------------------------------

loc_5FDE:
		bsr.w	DeleteObject
		rts