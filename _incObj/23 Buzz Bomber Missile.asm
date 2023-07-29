; ---------------------------------------------------------------------------

ObjBuzzMissile:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	off_79FA(pc,d0.w),d1
		jmp	off_79FA(pc,d1.w)
; ---------------------------------------------------------------------------

off_79FA:	dc.w loc_7A04-off_79FA, loc_7A4E-off_79FA, loc_7A6C-off_79FA, loc_7AB2-off_79FA, loc_7AB8-off_79FA
; ---------------------------------------------------------------------------

loc_7A04:
		subq.w	#1,$32(a0)
		bpl.s	sub_7A5E
		addq.b	#2,obRoutine(a0)
		move.l	#MapBuzzMissile,obMap(a0)
		move.w	#$2444,obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#3,obPriority(a0)
		move.b	#8,obActWid(a0)
		andi.b	#3,obStatus(a0)
		tst.b	obSubtype(a0)
		beq.s	loc_7A4E
		move.b	#8,obRoutine(a0)
		move.b	#$87,obColType(a0)
		move.b	#1,obAnim(a0)
		bra.s	loc_7AC2
; ---------------------------------------------------------------------------

loc_7A4E:
		bsr.s	sub_7A5E
		lea	(AniBuzzMissile).l,a1
		bsr.w	AnimateSprite
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

sub_7A5E:
		movea.l	$3C(a0),a1
		cmpi.b	#id_ExplosionItem,obId(a1)
		beq.s	loc_7AB2
		rts
; ---------------------------------------------------------------------------

loc_7A6C:
		btst	#7,obStatus(a0)
		bne.s	loc_7AA2
		move.b	#$87,obColType(a0)
		move.b	#1,obAnim(a0)
		bsr.w	SpeedToPos
		lea	(AniBuzzMissile).l,a1
		bsr.w	AnimateSprite
		bsr.w	DisplaySprite
		move.w	(unk_FFF72E).w,d0
		addi.w	#$E0,d0
		cmp.w	obY(a0),d0
		bcs.s	loc_7AB2
		rts
; ---------------------------------------------------------------------------

loc_7AA2:
		move.b	#id_MissileDissolve,obId(a0)
		move.b	#0,obRoutine(a0)
		bra.w	ObjCannonballExplode
; ---------------------------------------------------------------------------

loc_7AB2:
		bsr.w	DeleteObject
		rts
; ---------------------------------------------------------------------------

loc_7AB8:
		tst.b	obRender(a0)
		bpl.s	loc_7AB2
		bsr.w	SpeedToPos

loc_7AC2:
		lea	(AniBuzzMissile).l,a1
		bsr.w	AnimateSprite
		bsr.w	DisplaySprite
		rts