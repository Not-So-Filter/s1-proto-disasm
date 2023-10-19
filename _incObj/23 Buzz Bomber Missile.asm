; ---------------------------------------------------------------------------

ObjBuzzMissile:
		moveq	#0,d0
		move.b	objRoutine(a0),d0
		move.w	off_79FA(pc,d0.w),d1
		jmp	off_79FA(pc,d1.w)
; ---------------------------------------------------------------------------

off_79FA:	dc.w loc_7A04-off_79FA, loc_7A4E-off_79FA, loc_7A6C-off_79FA, loc_7AB2-off_79FA, loc_7AB8-off_79FA
; ---------------------------------------------------------------------------

loc_7A04:
		subq.w	#1,$32(a0)
		bpl.s	sub_7A5E
		addq.b	#2,objRoutine(a0)
		move.l	#Map_Missile,objMap(a0)
		move.w	#$2444,objGfx(a0)
		move.b	#4,objRender(a0)
		move.b	#3,objPriority(a0)
		move.b	#8,objActWid(a0)
		andi.b	#3,objStatus(a0)
		tst.b	objSubtype(a0)
		beq.s	loc_7A4E
		move.b	#8,objRoutine(a0)
		move.b	#$87,objColType(a0)
		move.b	#1,objAnim(a0)
		bra.s	loc_7AC2
; ---------------------------------------------------------------------------

loc_7A4E:
		bsr.s	sub_7A5E
		lea	(Ani_Missile).l,a1
		bsr.w	AnimateSprite
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

sub_7A5E:
		movea.l	$3C(a0),a1
		cmpi.b	#id_ExplosionItem,objId(a1)
		beq.s	loc_7AB2
		rts
; ---------------------------------------------------------------------------

loc_7A6C:
		btst	#7,objStatus(a0)
		bne.s	loc_7AA2
		move.b	#$87,objColType(a0)
		move.b	#1,objAnim(a0)
		bsr.w	SpeedToPos
		lea	(Ani_Missile).l,a1
		bsr.w	AnimateSprite
		bsr.w	DisplaySprite
		move.w	(v_limitbtm2).w,d0
		addi.w	#$E0,d0
		cmp.w	objY(a0),d0
		bcs.s	loc_7AB2
		rts
; ---------------------------------------------------------------------------

loc_7AA2:
		move.b	#id_MissileDissolve,objId(a0)
		move.b	#0,objRoutine(a0)
		bra.w	ObjCannonballExplode
; ---------------------------------------------------------------------------

loc_7AB2:
		bsr.w	DeleteObject
		rts
; ---------------------------------------------------------------------------

loc_7AB8:
		tst.b	objRender(a0)
		bpl.s	loc_7AB2
		bsr.w	SpeedToPos

loc_7AC2:
		lea	(Ani_Missile).l,a1
		bsr.w	AnimateSprite
		bsr.w	DisplaySprite
		rts