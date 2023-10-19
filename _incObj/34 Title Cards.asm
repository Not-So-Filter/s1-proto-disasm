; ---------------------------------------------------------------------------

ObjTitleCard:
		moveq	#0,d0
		move.b	objRoutine(a0),d0
		move.w	off_A4D6(pc,d0.w),d1
		jmp	off_A4D6(pc,d1.w)
; ---------------------------------------------------------------------------

off_A4D6:	dc.w loc_A4DE-off_A4D6, loc_A556-off_A4D6, loc_A57C-off_A4D6, loc_A57C-off_A4D6
; ---------------------------------------------------------------------------

loc_A4DE:
		movea.l	a0,a1
		moveq	#0,d0
		move.b	(v_zone).w,d0
		lea	(word_A5E4).l,a3
		lsl.w	#4,d0
		adda.w	d0,a3
		lea	(word_A5D4).l,a2
		moveq	#3,d1

loc_A4F8:
		move.b	#id_TitleCard,objId(a1)
		move.w	(a3),objX(a1)
		move.w	(a3)+,card_finalX(a1)
		move.w	(a3)+,card_mainX(a1)
		move.w	(a2)+,objScreenY(a1)
		move.b	(a2)+,objRoutine(a1)
		move.b	(a2)+,d0
		bne.s	loc_A51A
		move.b	(v_zone).w,d0

loc_A51A:
		cmpi.b	#7,d0
		bne.s	loc_A524
		add.b	(v_act).w,d0

loc_A524:
		move.b	d0,objFrame(a1)
		move.l	#Map_TitleCard,objMap(a1)
		move.w	#$8580,objGfx(a1)
		move.b	#$78,objActWid(a1)
		move.b	#0,objRender(a1)
		move.b	#0,objPriority(a1)
		move.w	#$3C,objTimeFrame(a1)
		lea	objSize(a1),a1
		dbf	d1,loc_A4F8

loc_A556:
		moveq	#$10,d1
		move.w	card_mainX(a0),d0
		cmp.w	objX(a0),d0
		beq.s	loc_A56A
		bge.s	loc_A566
		neg.w	d1

loc_A566:
		add.w	d1,objX(a0)

loc_A56A:
		move.w	objX(a0),d0
		bmi.s	locret_A57A
		cmpi.w	#$200,d0
		bcc.s	locret_A57A
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

locret_A57A:
		rts
; ---------------------------------------------------------------------------

loc_A57C:
		tst.w	objTimeFrame(a0)
		beq.s	loc_A58A
		subq.w	#1,objTimeFrame(a0)
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

loc_A58A:
		moveq	#$20,d1
		move.w	card_finalX(a0),d0
		cmp.w	objX(a0),d0
		beq.s	loc_A5B0
		bge.s	loc_A59A
		neg.w	d1

loc_A59A:
		add.w	d1,objX(a0)
		move.w	objX(a0),d0
		bmi.s	locret_A5AE
		cmpi.w	#$200,d0
		bcc.s	locret_A5AE
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

locret_A5AE:
		rts
; ---------------------------------------------------------------------------

loc_A5B0:
		cmpi.b	#4,objRoutine(a0)
		bne.s	loc_A5D0
		moveq	#plcid_Explode,d0
		jsr	(plcAdd).l
		moveq	#0,d0
		move.b	(v_zone).w,d0
		addi.w	#plcid_GHZAnimals,d0
		jsr	(plcAdd).l

loc_A5D0:
		bra.w	DeleteObject
; ---------------------------------------------------------------------------

word_A5D4:	dc.w $D0
		dc.b 2, 0
		dc.w $E4
		dc.b 2, 6
		dc.w $EA
		dc.b 2, 7
		dc.w $E0
		dc.b 2, $A

word_A5E4:	dc.w 0, $120, $FEFC, $13C, $414, $154, $214, $154
		dc.w 0, $120, $FEF4, $134, $40C, $14C, $20C, $14C
		dc.w 0, $120, $FEE0, $120, $3F8, $138, $1F8, $138
		dc.w 0, $120, $FEFC, $13C, $414, $154, $214, $154
		dc.w 0, $120, $FEF4, $134, $40C, $14C, $20C, $14C
		dc.w 0, $120, $FF00, $140, $418, $158, $218, $158
