; ---------------------------------------------------------------------------

loc_B1AE:
		move.w	#$FF00,obj.VelX(a0)
		move.w	#$FFC0,obj.VelY(a0)
		bsr.w	BossMove
		cmpi.w	#$2A00,obj.BossX(a0)
		bne.s	loc_B1F8
		move.w	#0,obj.VelX(a0)
		move.w	#0,obj.VelY(a0)
		addq.b	#2,obj.2ndRout(a0)
		bsr.w	FindNextFreeObj
		bne.s	loc_B1F2
		_move.b	#id_BossBall,obj.Id(a1)
		move.w	obj.BossX(a0),obj.Xpos(a1)
		move.w	obj.BossY(a0),obj.Ypos(a1)
		move.l	a0,$34(a1)

loc_B1F2:
		move.w	#$77,$3C(a0)

loc_B1F8:
		bra.w	loc_B0D2
; ---------------------------------------------------------------------------

loc_B1FC:
		subq.w	#1,$3C(a0)
		bpl.s	loc_B226
		addq.b	#2,obj.2ndRout(a0)
		move.w	#$3F,$3C(a0)
		move.w	#$100,obj.VelX(a0)
		cmpi.w	#$2A00,obj.BossX(a0)
		bne.s	loc_B226
		move.w	#$7F,$3C(a0)
		move.w	#$40,obj.VelX(a0)

loc_B226:
		btst	#0,obj.Status(a0)
		bne.s	loc_B232
		neg.w	obj.VelX(a0)

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
		bchg	#0,obj.Status(a0)
		move.w	#$3F,$3C(a0)
		subq.b	#2,obj.2ndRout(a0)
		move.w	#0,obj.VelX(a0)

loc_B258:
		bra.w	loc_B0D2
; ---------------------------------------------------------------------------

loc_B25C:
		subq.w	#1,$3C(a0)
		bmi.s	loc_B266
		bra.w	sub_B146
; ---------------------------------------------------------------------------

loc_B266:
		bset	#0,obj.Status(a0)
		bclr	#7,obj.Status(a0)
		move.w	#$400,obj.VelX(a0)
		move.w	#$FFC0,obj.VelY(a0)
		addq.b	#2,obj.2ndRout(a0)
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
		tst.b	obj.Render(a0)
		bpl.w	DeleteObject

loc_B2A6:
		bsr.w	BossMove
		bra.w	loc_B0D2
; ---------------------------------------------------------------------------

loc_B2AE:
		movea.l	$34(a0),a1
		cmpi.b	#$A,obj.2ndRout(a1)
		bne.s	loc_B2C2
		tst.b	obj.Render(a0)
		bpl.w	DeleteObject

loc_B2C2:
		move.b	#1,obj.Anim(a0)
		tst.b	obj.ColType(a1)
		bne.s	loc_B2D4
		move.b	#5,obj.Anim(a0)

loc_B2D4:
		bra.s	loc_B2FC
; ---------------------------------------------------------------------------

loc_B2D6:
		movea.l	$34(a0),a1
		cmpi.b	#$A,obj.2ndRout(a1)
		bne.s	loc_B2EA
		tst.b	obj.Render(a0)
		bpl.w	DeleteObject

loc_B2EA:
		move.b	#7,obj.Anim(a0)
		move.w	obj.VelX(a1),d0
		beq.s	loc_B2FC
		move.b	#8,obj.Anim(a0)

loc_B2FC:
		movea.l	$34(a0),a1
		move.w	obj.Xpos(a1),obj.Xpos(a0)
		move.w	obj.Ypos(a1),obj.Ypos(a0)
		move.b	obj.Status(a1),obj.Status(a0)
		lea	(Ani_Eggman).l,a1
		bsr.w	AnimateSprite
		move.b	obj.Status(a0),d0
		andi.b	#3,d0
		andi.b	#$FC,obj.Render(a0)
		or.b	d0,obj.Render(a0)
		bra.w	DisplaySprite
