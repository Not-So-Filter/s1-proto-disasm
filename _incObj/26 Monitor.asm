; ---------------------------------------------------------------------------

ObjMonitor:
		moveq	#0,d0
		move.b	objRoutine(a0),d0
		move.w	off_8054(pc,d0.w),d1
		jmp	off_8054(pc,d1.w)
; ---------------------------------------------------------------------------

off_8054:	dc.w loc_805E-off_8054, loc_80C0-off_8054
		dc.w sub_81D2-off_8054, loc_81A4-off_8054
		dc.w loc_81AE-off_8054
; ---------------------------------------------------------------------------

loc_805E:
		addq.b	#2,objRoutine(a0)
		move.b	#$E,objHeight(a0)
		move.b	#$E,objWidth(a0)
		move.l	#Map_Monitor,objMap(a0)
		move.w	#$680,objGfx(a0)
		move.b	#4,objRender(a0)
		move.b	#3,objPriority(a0)
		move.b	#$F,objActWid(a0)
		lea	(v_regbuffer).w,a2
		moveq	#0,d0
		move.b	objRespawnNo(a0),d0
		bclr	#7,2(a2,d0.w)
		btst	#0,2(a2,d0.w)
		beq.s	loc_80B4
		move.b	#8,objRoutine(a0)
		move.b	#$B,objFrame(a0)
		rts
; ---------------------------------------------------------------------------

loc_80B4:
		move.b	#$46,objColType(a0)
		move.b	objSubtype(a0),objAnim(a0)

loc_80C0:
		move.b	obj2ndRout(a0),d0
		beq.s	loc_811A
		subq.b	#2,d0
		bne.s	loc_80FA
		moveq	#0,d1
		move.b	objActWid(a0),d1
		addi.w	#$B,d1
		bsr.w	PtfmCheckExit
		btst	#3,objStatus(a1)
		bne.w	loc_80EA
		clr.b	obj2ndRout(a0)
		bra.w	loc_81A4
; ---------------------------------------------------------------------------

loc_80EA:
		move.w	#$10,d3
		move.w	objX(a0),d2
		bsr.w	PtfmSurfaceHeight
		bra.w	loc_81A4
; ---------------------------------------------------------------------------

loc_80FA:
		bsr.w	ObjectFall
		jsr	(ObjectHitFloor).l
		tst.w	d1
		bpl.w	loc_81A4
		add.w	d1,objY(a0)
		clr.w	objVelY(a0)
		clr.b	obj2ndRout(a0)
		bra.w	loc_81A4
; ---------------------------------------------------------------------------

loc_811A:
		move.w	#$1A,d1
		move.w	#$F,d2
		bsr.w	sub_83B4
		beq.w	loc_818A
		tst.w	objVelY(a1)
		bmi.s	loc_8138
		cmpi.b	#2,objAnim(a1)
		beq.s	loc_818A

loc_8138:
		tst.w	d1
		bpl.s	loc_814E
		sub.w	d3,objY(a1)
		bsr.w	loc_4FD4
		move.b	#2,obj2ndRout(a0)
		bra.w	loc_81A4
; ---------------------------------------------------------------------------

loc_814E:
		tst.w	d0
		beq.w	loc_8174
		bmi.s	loc_815E
		tst.w	objVelX(a1)
		bmi.s	loc_8174
		bra.s	loc_8164
; ---------------------------------------------------------------------------

loc_815E:
		tst.w	objVelX(a1)
		bpl.s	loc_8174

loc_8164:
		sub.w	d0,objX(a1)
		move.w	#0,objInertia(a1)
		move.w	#0,objVelX(a1)

loc_8174:
		btst	#1,objStatus(a1)
		bne.s	loc_8198
		bset	#5,objStatus(a1)
		bset	#5,objStatus(a0)
		bra.s	loc_81A4
; ---------------------------------------------------------------------------

loc_818A:
		btst	#5,objStatus(a0)
		beq.s	loc_81A4
		move.w	#1,objAnim(a1)

loc_8198:
		bclr	#5,objStatus(a0)
		bclr	#5,objStatus(a1)

loc_81A4:
		lea	(AniMonitor).l,a1
		bsr.w	AnimateSprite

loc_81AE:
		bsr.w	DisplaySprite
		out_of_range.w	DeleteObject
		rts
; ---------------------------------------------------------------------------

sub_81D2:
		addq.b	#2,objRoutine(a0)
		move.b	#0,objColType(a0)
		bsr.w	FindFreeObj
		bne.s	loc_81FA
		move.b	#id_PowerUp,objId(a1)
		move.w	objX(a0),objX(a1)
		move.w	objY(a0),objY(a1)
		move.b	objAnim(a0),objAnim(a1)

loc_81FA:
		bsr.w	FindFreeObj
		bne.s	loc_8216
		move.b	#id_ExplosionItem,objId(a1)
		addq.b	#2,objRoutine(a1)
		move.w	objX(a0),objX(a1)
		move.w	objY(a0),objY(a1)

loc_8216:
		lea	(v_regbuffer).w,a2
		moveq	#0,d0
		move.b	objRespawnNo(a0),d0
		bset	#0,2(a2,d0.w)
		move.b	#9,objAnim(a0)
		bra.w	DisplaySprite