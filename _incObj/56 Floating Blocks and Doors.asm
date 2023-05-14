; ---------------------------------------------------------------------------

ObjMovingBlocks:
		moveq	#0,d0
		move.b	$24(a0),d0
		move.w	ObjMovingBlocks_Index(pc,d0.w),d1
		jmp	ObjMovingBlocks_Index(pc,d1.w)
; ---------------------------------------------------------------------------

ObjMovingBlocks_Index:dc.w ObjMovingBlocks_Init-ObjMovingBlocks_Index, ObjMovingBlocks_Action-ObjMovingBlocks_Index

ObjMovingBlocks_Variables:dc.b $10, $10
		dc.b $20, $20
		dc.b $10, $20
		dc.b $20, $1A
		dc.b $10, $27
		dc.b $10, $10
; ---------------------------------------------------------------------------

ObjMovingBlocks_Init:
		addq.b	#2,$24(a0)
		move.l	#MapMovingBlocks,4(a0)
		move.w	#$4000,2(a0)
		cmpi.b	#3,(v_zone).w
		bne.s	loc_D912
		move.w	#$4480,2(a0)

loc_D912:
		move.b	#4,1(a0)
		move.b	#3,$19(a0)
		moveq	#0,d0
		move.b	$28(a0),d0
		lsr.w	#3,d0
		andi.w	#$E,d0
		lea	ObjMovingBlocks_Variables(pc,d0.w),a2
		move.b	(a2)+,$18(a0)
		move.b	(a2),$16(a0)
		lsr.w	#1,d0
		move.b	d0,$1A(a0)
		move.w	8(a0),$34(a0)
		move.w	$C(a0),$30(a0)
		moveq	#0,d0
		move.b	(a2),d0
		add.w	d0,d0
		move.w	d0,$3A(a0)
		moveq	#0,d0
		move.b	$28(a0),d0
		andi.w	#$F,d0
		subq.w	#8,d0
		bcs.s	ObjMovingBlocks_IsGone
		lsl.w	#2,d0
		lea	(oscValues+$2C).w,a2
		lea	(a2,d0.w),a2
		tst.w	(a2)
		bpl.s	ObjMovingBlocks_IsGone
		bchg	#0,$22(a0)

ObjMovingBlocks_IsGone:
		move.b	$28(a0),d0
		bpl.s	ObjMovingBlocks_Action
		andi.b	#$F,d0
		move.b	d0,$3C(a0)
		move.b	#5,$28(a0)
		lea	(v_regbuffer).w,a2
		moveq	#0,d0
		move.b	$23(a0),d0
		beq.s	ObjMovingBlocks_Action
		bclr	#7,2(a2,d0.w)
		btst	#0,2(a2,d0.w)
		beq.s	ObjMovingBlocks_Action
		move.b	#6,$28(a0)
		clr.w	$3A(a0)

ObjMovingBlocks_Action:
		move.w	8(a0),-(sp)
		moveq	#0,d0
		move.b	$28(a0),d0
		andi.w	#$F,d0
		add.w	d0,d0
		move.w	ObjBasaran_TypeIndex(pc,d0.w),d1
		jsr	ObjBasaran_TypeIndex(pc,d1.w)
		move.w	(sp)+,d4
		tst.b	1(a0)
		bpl.s	ObjMovingBlocks_ChkDelete
		moveq	#0,d1
		move.b	$18(a0),d1
		addi.w	#$B,d1
		moveq	#0,d2
		move.b	$16(a0),d2
		move.w	d2,d3
		addq.w	#1,d3
		bsr.w	SolidObject

ObjMovingBlocks_ChkDelete:
		bsr.w	DisplaySprite
		move.w	$34(a0),d0
		andi.w	#$FF80,d0
		move.w	(v_screenposx).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0
		cmpi.w	#$280,d0
		bhi.w	DeleteObject
		rts
; ---------------------------------------------------------------------------

ObjBasaran_TypeIndex:dc.w ObjBasaran_Type00-ObjBasaran_TypeIndex, ObjBasaran_Type01-ObjBasaran_TypeIndex, ObjBasaran_Type02-ObjBasaran_TypeIndex
		dc.w ObjBasaran_Type03-ObjBasaran_TypeIndex, ObjBasaran_Type04-ObjBasaran_TypeIndex, ObjBasaran_Type05-ObjBasaran_TypeIndex
		dc.w ObjBasaran_Type06-ObjBasaran_TypeIndex, ObjBasaran_Type07-ObjBasaran_TypeIndex, ObjBasaran_Type08-ObjBasaran_TypeIndex
		dc.w ObjBasaran_Type09-ObjBasaran_TypeIndex, ObjBasaran_Type0A-ObjBasaran_TypeIndex, ObjBasaran_Type0B-ObjBasaran_TypeIndex
; ---------------------------------------------------------------------------

ObjBasaran_Type00:
		rts
; ---------------------------------------------------------------------------

ObjBasaran_Type01:
		move.w	#$40,d1
		moveq	#0,d0
		move.b	(oscValues+$A).w,d0
		bra.s	loc_DA38
; ---------------------------------------------------------------------------

ObjBasaran_Type02:
		move.w	#$80,d1
		moveq	#0,d0
		move.b	(oscValues+$1E).w,d0

loc_DA38:
		btst	#0,$22(a0)
		beq.s	loc_DA44
		neg.w	d0
		add.w	d1,d0

loc_DA44:
		move.w	$34(a0),d1
		sub.w	d0,d1
		move.w	d1,8(a0)
		rts
; ---------------------------------------------------------------------------

ObjBasaran_Type03:
		move.w	#$40,d1
		moveq	#0,d0
		move.b	(oscValues+$A).w,d0
		bra.s	loc_DA62
; ---------------------------------------------------------------------------

ObjBasaran_Type04:
		moveq	#0,d0
		move.b	(oscValues+$1E).w,d0

loc_DA62:
		btst	#0,$22(a0)
		beq.s	loc_DA70
		neg.w	d0
		addi.w	#$80,d0

loc_DA70:
		move.w	$30(a0),d1
		sub.w	d0,d1
		move.w	d1,$C(a0)
		rts
; ---------------------------------------------------------------------------

ObjBasaran_Type05:
		tst.b	$38(a0)
		bne.s	loc_DA9A
		lea	(unk_FFF7E0).w,a2
		moveq	#0,d0
		move.b	$3C(a0),d0
		btst	#0,(a2,d0.w)
		beq.s	loc_DAA4
		move.b	#1,$38(a0)

loc_DA9A:
		tst.w	$3A(a0)
		beq.s	loc_DAB4
		subq.w	#2,$3A(a0)

loc_DAA4:
		move.w	$3A(a0),d0
		move.w	$30(a0),d1
		add.w	d0,d1
		move.w	d1,$C(a0)
		rts
; ---------------------------------------------------------------------------

loc_DAB4:
		addq.b	#1,$28(a0)
		clr.b	$38(a0)
		lea	(v_regbuffer).w,a2
		moveq	#0,d0
		move.b	$23(a0),d0
		beq.s	loc_DAA4
		bset	#0,2(a2,d0.w)
		bra.s	loc_DAA4
; ---------------------------------------------------------------------------

ObjBasaran_Type06:
		tst.b	$38(a0)
		bne.s	loc_DAEC
		lea	(unk_FFF7E0).w,a2
		moveq	#0,d0
		move.b	$3C(a0),d0
		tst.b	(a2,d0.w)
		bpl.s	loc_DAFE
		move.b	#1,$38(a0)

loc_DAEC:
		moveq	#0,d0
		move.b	$16(a0),d0
		add.w	d0,d0
		cmp.w	$3A(a0),d0
		beq.s	loc_DB0E
		addq.w	#2,$3A(a0)

loc_DAFE:
		move.w	$3A(a0),d0
		move.w	$30(a0),d1
		add.w	d0,d1
		move.w	d1,$C(a0)
		rts
; ---------------------------------------------------------------------------

loc_DB0E:
		subq.b	#1,$28(a0)
		clr.b	$38(a0)
		lea	(v_regbuffer).w,a2
		moveq	#0,d0
		move.b	$23(a0),d0
		beq.s	loc_DAFE
		bclr	#0,2(a2,d0.w)
		bra.s	loc_DAFE
; ---------------------------------------------------------------------------

ObjBasaran_Type07:
		tst.b	$38(a0)
		bne.s	loc_DB40
		tst.b	(unk_FFF7EF).w
		beq.s	locret_DB5A
		move.b	#1,$38(a0)
		clr.w	$3A(a0)

loc_DB40:
		addq.w	#1,8(a0)
		move.w	8(a0),$34(a0)
		addq.w	#1,$3A(a0)
		cmpi.w	#$380,$3A(a0)
		bne.s	locret_DB5A
		clr.b	$28(a0)

locret_DB5A:
		rts
; ---------------------------------------------------------------------------

ObjBasaran_Type08:
		move.w	#$10,d1
		moveq	#0,d0
		move.b	(oscValues+$2A).w,d0
		lsr.w	#1,d0
		move.w	(oscValues+$2C).w,d3
		bra.s	ObjBasaran_MoveSquare
; ---------------------------------------------------------------------------

ObjBasaran_Type09:
		move.w	#$30,d1
		moveq	#0,d0
		move.b	(oscValues+$2E).w,d0
		move.w	(oscValues+$30).w,d3
		bra.s	ObjBasaran_MoveSquare
; ---------------------------------------------------------------------------

ObjBasaran_Type0A:
		move.w	#$50,d1
		moveq	#0,d0
		move.b	(oscValues+$32).w,d0
		move.w	(oscValues+$34).w,d3
		bra.s	ObjBasaran_MoveSquare
; ---------------------------------------------------------------------------

ObjBasaran_Type0B:
		move.w	#$70,d1
		moveq	#0,d0
		move.b	(oscValues+$36).w,d0
		move.w	(oscValues+$38).w,d3

ObjBasaran_MoveSquare:
		tst.w	d3
		bne.s	loc_DBAA
		addq.b	#1,$22(a0)
		andi.b	#3,$22(a0)

loc_DBAA:
		move.b	$22(a0),d2
		andi.b	#3,d2
		bne.s	loc_DBCA
		sub.w	d1,d0
		add.w	$34(a0),d0
		move.w	d0,8(a0)
		neg.w	d1
		add.w	$30(a0),d1
		move.w	d1,$C(a0)
		rts
; ---------------------------------------------------------------------------

loc_DBCA:
		subq.b	#1,d2
		bne.s	loc_DBE8
		subq.w	#1,d1
		sub.w	d1,d0
		neg.w	d0
		add.w	$30(a0),d0
		move.w	d0,$C(a0)
		addq.w	#1,d1
		add.w	$34(a0),d1
		move.w	d1,8(a0)
		rts
; ---------------------------------------------------------------------------

loc_DBE8:
		subq.b	#1,d2
		bne.s	loc_DC06
		subq.w	#1,d1
		sub.w	d1,d0
		neg.w	d0
		add.w	$34(a0),d0
		move.w	d0,8(a0)
		addq.w	#1,d1
		add.w	$30(a0),d1
		move.w	d1,$C(a0)
		rts
; ---------------------------------------------------------------------------

loc_DC06:
		sub.w	d1,d0
		add.w	$30(a0),d0
		move.w	d0,$C(a0)
		neg.w	d1
		add.w	$34(a0),d1
		move.w	d1,8(a0)
		rts