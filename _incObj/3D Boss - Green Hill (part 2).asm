; ---------------------------------------------------------------------------

loc_B1AE:
		move.w	#$FF00,objVelX(a0)
		move.w	#$FFC0,objVelY(a0)
		bsr.w	BossMove
		cmpi.w	#$2A00,objBossX(a0)
		bne.s	loc_B1F8
		move.w	#0,objVelX(a0)
		move.w	#0,objVelY(a0)
		addq.b	#2,obj2ndRout(a0)
		bsr.w	FindNextFreeObj
		bne.s	loc_B1F2
		move.b	#id_BossBall,objId(a1)
		move.w	objBossX(a0),objX(a1)
		move.w	objBossY(a0),objY(a1)
		move.l	a0,$34(a1)

loc_B1F2:
		move.w	#$77,$3C(a0)

loc_B1F8:
		bra.w	loc_B0D2
; ---------------------------------------------------------------------------

loc_B1FC:
		subq.w	#1,$3C(a0)
		bpl.s	loc_B226
		addq.b	#2,obj2ndRout(a0)
		move.w	#$3F,$3C(a0)
		move.w	#$100,objVelX(a0)
		cmpi.w	#$2A00,objBossX(a0)
		bne.s	loc_B226
		move.w	#$7F,$3C(a0)
		move.w	#$40,objVelX(a0)

loc_B226:
		btst	#0,objStatus(a0)
		bne.s	loc_B232
		neg.w	objVelX(a0)

loc_B232:
		bra.w	loc_B0D2
; ---------------------------------------------------------------------------

loc_B236:
		subq.w	#1,$3C(a0)
		bmi.s	loc_B242
		bsr.w	BossMove
		bra.s	loc_B258
; ---------------------------------------------------------------------------

loc_B242:
		bchg	#0,objStatus(a0)
		move.w	#$3F,$3C(a0)
		subq.b	#2,obj2ndRout(a0)
		move.w	#0,objVelX(a0)

loc_B258:
		bra.w	loc_B0D2
; ---------------------------------------------------------------------------

loc_B25C:
		subq.w	#1,$3C(a0)
		bmi.s	loc_B266
		bra.w	sub_B146
; ---------------------------------------------------------------------------

loc_B266:
		bset	#0,objStatus(a0)
		bclr	#7,objStatus(a0)
		move.w	#$400,objVelX(a0)
		move.w	#$FFC0,objVelY(a0)
		addq.b	#2,obj2ndRout(a0)
		tst.b	(v_bossstatus).w
		bne.s	locret_B28E
		move.b	#1,(v_bossstatus).w

locret_B28E:
		rts
; ---------------------------------------------------------------------------

loc_B290:
		cmpi.w	#$2AC0,(v_limitright2).w
		beq.s	loc_B29E
		addq.w	#2,(v_limitright2).w
		bra.s	loc_B2A6
; ---------------------------------------------------------------------------

loc_B29E:
		tst.b	objRender(a0)
		bpl.w	DeleteObject

loc_B2A6:
		bsr.w	BossMove
		bra.w	loc_B0D2
; ---------------------------------------------------------------------------

loc_B2AE:
		movea.l	$34(a0),a1
		cmpi.b	#$A,obj2ndRout(a1)
		bne.s	loc_B2C2
		tst.b	objRender(a0)
		bpl.w	DeleteObject

loc_B2C2:
		move.b	#1,objAnim(a0)
		tst.b	objColType(a1)
		bne.s	loc_B2D4
		move.b	#5,objAnim(a0)

loc_B2D4:
		bra.s	loc_B2FC
; ---------------------------------------------------------------------------

loc_B2D6:
		movea.l	$34(a0),a1
		cmpi.b	#$A,obj2ndRout(a1)
		bne.s	loc_B2EA
		tst.b	objRender(a0)
		bpl.w	DeleteObject

loc_B2EA:
		move.b	#7,objAnim(a0)
		move.w	objVelX(a1),d0
		beq.s	loc_B2FC
		move.b	#8,objAnim(a0)

loc_B2FC:
		movea.l	$34(a0),a1
		move.w	objX(a1),objX(a0)
		move.w	objY(a1),objY(a0)
		move.b	objStatus(a1),objStatus(a0)
		lea	(Ani_Eggman).l,a1
		bsr.w	AnimateSprite
		move.b	objStatus(a0),d0
		andi.b	#3,d0
		andi.b	#$FC,objRender(a0)
		or.b	d0,objRender(a0)
		bra.w	DisplaySprite
