; ---------------------------------------------------------------------------

loc_B1AE:
		move.w	#-$100,obVelX(a0)
		move.w	#-$40,obVelY(a0)
		bsr.w	BossMove
		cmpi.w	#$2A00,obBossX(a0)
		bne.s	loc_B1F8
		move.w	#0,obVelX(a0)
		move.w	#0,obVelY(a0)
		addq.b	#2,ob2ndRout(a0)
		bsr.w	FindNextFreeObj
		bne.s	loc_B1F2
		_move.b	#id_BossBall,obID(a1)
		move.w	obBossX(a0),obX(a1)
		move.w	obBossY(a0),obY(a1)
		move.l	a0,objoff_34(a1)

loc_B1F2:
		move.w	#$77,objoff_3C(a0)

loc_B1F8:
		bra.w	loc_B0D2
; ---------------------------------------------------------------------------

loc_B1FC:
		subq.w	#1,objoff_3C(a0)
		bpl.s	loc_B226
		addq.b	#2,ob2ndRout(a0)
		move.w	#$3F,objoff_3C(a0)
		move.w	#$100,obVelX(a0)
		cmpi.w	#$2A00,obBossX(a0)
		bne.s	loc_B226
		move.w	#$7F,objoff_3C(a0)
		move.w	#$40,obVelX(a0)

loc_B226:
		btst	#0,obStatus(a0)
		bne.s	loc_B232
		neg.w	obVelX(a0)

loc_B232:
		bra.w	loc_B0D2
; ---------------------------------------------------------------------------

loc_B236:
		subq.w	#1,objoff_3C(a0)
		bmi.s	loc_B242
		bsr.w	BossMove
		bra.s	loc_B258
; ---------------------------------------------------------------------------

loc_B242:
		bchg	#0,obStatus(a0)
		move.w	#$3F,objoff_3C(a0)
		subq.b	#2,ob2ndRout(a0)
		move.w	#0,obVelX(a0)

loc_B258:
		bra.w	loc_B0D2
; ---------------------------------------------------------------------------

loc_B25C:
		subq.w	#1,objoff_3C(a0)
		bmi.s	loc_B266
		bra.w	sub_B146
; ---------------------------------------------------------------------------

loc_B266:
		bset	#0,obStatus(a0)
		bclr	#7,obStatus(a0)
		move.w	#$400,obVelX(a0)
		move.w	#-$40,obVelY(a0)
		addq.b	#2,ob2ndRout(a0)
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
		tst.b	obRender(a0)
		bpl.w	DeleteObject

loc_B2A6:
		bsr.w	BossMove
		bra.w	loc_B0D2
; ---------------------------------------------------------------------------

loc_B2AE:
		movea.l	objoff_34(a0),a1
		cmpi.b	#$A,ob2ndRout(a1)
		bne.s	loc_B2C2
		tst.b	obRender(a0)
		bpl.w	DeleteObject

loc_B2C2:
		move.b	#1,obAnim(a0)
		tst.b	obColType(a1)
		bne.s	loc_B2D4
		move.b	#5,obAnim(a0)

loc_B2D4:
		bra.s	loc_B2FC
; ---------------------------------------------------------------------------

loc_B2D6:
		movea.l	objoff_34(a0),a1
		cmpi.b	#$A,ob2ndRout(a1)
		bne.s	loc_B2EA
		tst.b	obRender(a0)
		bpl.w	DeleteObject

loc_B2EA:
		move.b	#7,obAnim(a0)
		move.w	obVelX(a1),d0
		beq.s	loc_B2FC
		move.b	#8,obAnim(a0)

loc_B2FC:
		movea.l	objoff_34(a0),a1
		move.w	obX(a1),obX(a0)
		move.w	obY(a1),obY(a0)
		move.b	obStatus(a1),obStatus(a0)
		lea	(Ani_Eggman).l,a1
		bsr.w	AnimateSprite
		move.b	obStatus(a0),d0
		andi.b	#3,d0
		andi.b	#$FC,obRender(a0)
		or.b	d0,obRender(a0)
		bra.w	DisplaySprite
