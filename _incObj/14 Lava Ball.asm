; ---------------------------------------------------------------------------

ObjLavaball:
		moveq	#0,d0
		move.b	objRoutine(a0),d0
		move.w	off_C23E(pc,d0.w),d1
		jsr	off_C23E(pc,d1.w)
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

off_C23E:	dc.w loc_C254-off_C23E, loc_C2C8-off_C23E, j_DeleteObject-off_C23E

word_C244:	dc.w $FC00, $FB00, $FA00, $F900, $FE00, $200, $FE00, $200
; ---------------------------------------------------------------------------

loc_C254:
		addq.b	#2,objRoutine(a0)
		move.b	#8,objHeight(a0)
		move.b	#8,objWidth(a0)
		move.l	#Map_Fire,objMap(a0)
		move.w	#$345,objGfx(a0)
		move.b	#4,objRender(a0)
		move.b	#3,objPriority(a0)
		move.b	#$8B,objColType(a0)
		move.w	objY(a0),$30(a0)
		moveq	#0,d0
		move.b	objSubtype(a0),d0
		add.w	d0,d0
		move.w	word_C244(pc,d0.w),objVelY(a0)
		move.b	#8,objActWid(a0)
		cmpi.b	#6,objSubtype(a0)
		bcs.s	loc_C2BE
		move.b	#$10,objActWid(a0)
		move.b	#2,objAnim(a0)
		move.w	objVelY(a0),objVelX(a0)
		move.w	#0,objVelY(a0)

loc_C2BE:
		move.w	#sfx_Fireball,d0
		jsr	(PlaySound_Special).l

loc_C2C8:
		moveq	#0,d0
		move.b	objSubtype(a0),d0
		add.w	d0,d0
		move.w	off_C306(pc,d0.w),d1
		jsr	off_C306(pc,d1.w)
		bsr.w	SpeedToPos
		lea	(Ani_Fire).l,a1
		bsr.w	AnimateSprite

loc_C2E6:
		out_of_range.w	DeleteObject
		rts
; ---------------------------------------------------------------------------

off_C306:	dc.w loc_C318-off_C306, loc_C318-off_C306, loc_C318-off_C306, loc_C318-off_C306, loc_C340-off_C306
		dc.w loc_C362-off_C306, loc_C384-off_C306, loc_C3A8-off_C306, locret_C3CC-off_C306
; ---------------------------------------------------------------------------

loc_C318:
		addi.w	#$18,objVelY(a0)
		move.w	$30(a0),d0
		cmp.w	objY(a0),d0
		bcc.s	loc_C32C
		addq.b	#2,objRoutine(a0)

loc_C32C:
		bclr	#1,objStatus(a0)
		tst.w	objVelY(a0)
		bpl.s	locret_C33E
		bset	#1,objStatus(a0)

locret_C33E:
		rts
; ---------------------------------------------------------------------------

loc_C340:
		bset	#1,objStatus(a0)
		bsr.w	ObjectHitCeiling
		tst.w	d1
		bpl.s	locret_C360
		move.b	#8,objSubtype(a0)
		move.b	#1,objAnim(a0)
		move.w	#0,objVelY(a0)

locret_C360:
		rts
; ---------------------------------------------------------------------------

loc_C362:
		bclr	#1,objStatus(a0)
		bsr.w	ObjectHitFloor
		tst.w	d1
		bpl.s	locret_C382
		move.b	#8,objSubtype(a0)
		move.b	#1,objAnim(a0)
		move.w	#0,objVelY(a0)

locret_C382:
		rts
; ---------------------------------------------------------------------------

loc_C384:
		bset	#0,objStatus(a0)
		moveq	#-8,d3
		bsr.w	ObjectHitWallLeft
		tst.w	d1
		bpl.s	locret_C3A6
		move.b	#8,objSubtype(a0)
		move.b	#3,objAnim(a0)
		move.w	#0,objVelX(a0)

locret_C3A6:
		rts
; ---------------------------------------------------------------------------

loc_C3A8:
		bclr	#0,objStatus(a0)
		moveq	#8,d3
		bsr.w	ObjectHitWallRight
		tst.w	d1
		bpl.s	locret_C3CA
		move.b	#8,objSubtype(a0)
		move.b	#3,objAnim(a0)
		move.w	#0,objVelX(a0)

locret_C3CA:
		rts
; ---------------------------------------------------------------------------

locret_C3CC:
		rts
; ---------------------------------------------------------------------------
; Attributes: thunk

j_DeleteObject:
		bra.w	DeleteObject