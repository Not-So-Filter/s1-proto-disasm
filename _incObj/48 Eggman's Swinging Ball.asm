; ---------------------------------------------------------------------------

ObjGHZBossBall:
		moveq	#0,d0
		move.b	objRoutine(a0),d0
		move.w	off_B340(pc,d0.w),d1
		jmp	off_B340(pc,d1.w)
; ---------------------------------------------------------------------------

off_B340:	dc.w loc_B34A-off_B340, loc_B404-off_B340, loc_B462-off_B340, loc_B49E-off_B340, loc_B4B8-off_B340
; ---------------------------------------------------------------------------

loc_B34A:
		addq.b	#2,objRoutine(a0)
		move.w	#$4080,objAngle(a0)
		move.w	#$FE00,$3E(a0)
		move.l	#Map_BossItems,objMap(a0)
		move.w	#$46C,objGfx(a0)
		lea	objSubtype(a0),a2
		move.b	#0,(a2)+
		moveq	#5,d1
		movea.l	a0,a1
		bra.s	loc_B3AC
; ---------------------------------------------------------------------------

loc_B376:
		bsr.w	FindNextFreeObj
		bne.s	loc_B3D6
		move.w	objX(a0),objX(a1)
		move.w	objY(a0),objY(a1)
		move.b	#id_BossBall,objId(a1)
		move.b	#6,objRoutine(a1)
		move.l	#Map_Swing_GHZ,objMap(a1)
		move.w	#$380,objGfx(a1)
		move.b	#1,objFrame(a1)
		addq.b	#1,objSubtype(a0)

loc_B3AC:
		move.w	a1,d5
		subi.w	#$D000,d5
		lsr.w	#6,d5
		andi.w	#$7F,d5
		move.b	d5,(a2)+
		move.b	#4,objRender(a1)
		move.b	#8,objActWid(a1)
		move.b	#6,objPriority(a1)
		move.l	$34(a0),$34(a1)
		dbf	d1,loc_B376

loc_B3D6:
		move.b	#8,objRoutine(a1)
		move.l	#Map_GBall,objMap(a1)
		move.w	#$43AA,objGfx(a1)
		move.b	#1,objFrame(a1)
		move.b	#5,objPriority(a1)
		move.b	#$81,objColType(a1)
		rts
; ---------------------------------------------------------------------------

byte_B3FE:	dc.b 0, $10, $20, $30, $40, $60
; ---------------------------------------------------------------------------

loc_B404:
		lea	(byte_B3FE).l,a3
		lea	objSubtype(a0),a2
		moveq	#0,d6
		move.b	(a2)+,d6

loc_B412:
		moveq	#0,d4
		move.b	(a2)+,d4
		lsl.w	#6,d4
		addi.l	#v_objspace&$FFFFFF,d4
		movea.l	d4,a1
		move.b	(a3)+,d0
		cmp.b	$3C(a1),d0
		beq.s	loc_B42C
		addq.b	#1,$3C(a1)

loc_B42C:
		dbf	d6,loc_B412
		cmp.b	$3C(a1),d0
		bne.s	loc_B446
		movea.l	$34(a0),a1
		cmpi.b	#6,obj2ndRout(a1)
		bne.s	loc_B446
		addq.b	#2,objRoutine(a0)

loc_B446:
		cmpi.w	#$20,$32(a0)
		beq.s	loc_B452
		addq.w	#1,$32(a0)

loc_B452:
		bsr.w	sub_B46E
		move.b	objAngle(a0),d0
		bsr.w	loc_5692
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

loc_B462:
		bsr.w	sub_B46E
		bsr.w	loc_5652
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

sub_B46E:
		movea.l	$34(a0),a1
		move.w	objX(a1),$3A(a0)
		move.w	objY(a1),d0
		add.w	$32(a0),d0
		move.w	d0,$38(a0)
		move.b	objStatus(a1),objStatus(a0)
		tst.b	objStatus(a1)
		bpl.s	locret_B49C
		move.b	#id_ExplosionBomb,objId(a0)
		move.b	#0,objRoutine(a0)

locret_B49C:
		rts
; ---------------------------------------------------------------------------

loc_B49E:
		movea.l	$34(a0),a1
		tst.b	objStatus(a1)
		bpl.s	loc_B4B4
		move.b	#id_ExplosionBomb,objId(a0)
		move.b	#0,objRoutine(a0)

loc_B4B4:
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

loc_B4B8:
		moveq	#0,d0
		tst.b	objFrame(a0)
		bne.s	loc_B4C2
		addq.b	#1,d0

loc_B4C2:
		move.b	d0,objFrame(a0)
		movea.l	$34(a0),a1
		tst.b	objStatus(a1)
		bpl.w	DisplaySprite
		move.b	#0,objColType(a0)
		bsr.w	sub_B146
		subq.b	#1,$3C(a0)
		bpl.s	loc_B4EE
		move.b	#id_ExplosionBomb,objId(a0)
		move.b	#0,objRoutine(a0)

loc_B4EE:
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------
