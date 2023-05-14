; ---------------------------------------------------------------------------

ObjCollapsePtfm:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	off_5EEE(pc,d0.w),d1
		jmp	off_5EEE(pc,d1.w)
; ---------------------------------------------------------------------------

off_5EEE:	dc.w loc_5EFA-off_5EEE, loc_5F2A-off_5EEE, loc_5F4E-off_5EEE, loc_5F7E-off_5EEE, loc_5FDE-off_5EEE
		dc.w sub_5F60-off_5EEE
; ---------------------------------------------------------------------------

loc_5EFA:
		addq.b	#2,obRoutine(a0)
		move.l	#MapCollapsePtfm,obMap(a0)
		move.w	#$4000,obGfx(a0)
		ori.b	#4,obRender(a0)
		move.b	#4,obPriority(a0)
		move.b	#7,$38(a0)
		move.b	#$64,obActWid(a0)
		move.b	obSubtype(a0),obFrame(a0)

loc_5F2A:
		tst.b	$3A(a0)
		beq.s	loc_5F3C
		tst.b	$38(a0)
		beq.w	loc_612A
		subq.b	#1,$38(a0)

loc_5F3C:
		move.w	#$30,d1
		lea	(ObjCollapsePtfm_Slope).l,a2
		bsr.w	PtfmSloped
		bra.w	RememberState
; ---------------------------------------------------------------------------

loc_5F4E:
		tst.b	$38(a0)
		beq.w	loc_6130
		move.b	#1,$3A(a0)
		subq.b	#1,$38(a0)
; ---------------------------------------------------------------------------

sub_5F60:
		move.w	#$30,d1
		bsr.w	PtfmCheckExit
		move.w	#$30,d1
		lea	(ObjCollapsePtfm_Slope).l,a2
		move.w	obX(a0),d2
		bsr.w	sub_61E0
		bra.w	RememberState
; ---------------------------------------------------------------------------

loc_5F7E:
		tst.b	$38(a0)
		beq.s	loc_5FCE
		tst.b	$3A(a0)
		bne.w	loc_5F94
		subq.b	#1,$38(a0)
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

loc_5F94:
		subq.b	#1,$38(a0)
		bsr.w	sub_5F60
		lea	(v_objspace).w,a1
		btst	#3,obStatus(a1)
		beq.s	loc_5FC0
		tst.b	$38(a0)
		bne.s	locret_5FCC
		bclr	#3,obStatus(a1)
		bclr	#5,obStatus(a1)
		move.b	#1,obNextAni(a1)

loc_5FC0:
		move.b	#0,$3A(a0)
		move.b	#6,obRoutine(a0)

locret_5FCC:
		rts
; ---------------------------------------------------------------------------

loc_5FCE:
		bsr.w	ObjectFall
		bsr.w	DisplaySprite
		tst.b	obRender(a0)
		bpl.s	loc_5FDE
		rts
; ---------------------------------------------------------------------------

loc_5FDE:
		bsr.w	DeleteObject
		rts