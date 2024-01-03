; ---------------------------------------------------------------------------

ObjBuzzMissile:
		moveq	#0,d0
		move.b	obj.Routine(a0),d0
		move.w	off_79FA(pc,d0.w),d1
		jmp	off_79FA(pc,d1.w)
; ---------------------------------------------------------------------------

off_79FA:	dc.w loc_7A04-off_79FA, loc_7A4E-off_79FA, loc_7A6C-off_79FA, loc_7AB2-off_79FA, loc_7AB8-off_79FA
; ---------------------------------------------------------------------------

loc_7A04:
		subq.w	#1,$32(a0)
		bpl.s	sub_7A5E
		addq.b	#2,obj.Routine(a0)
		move.l	#Map_Missile,obj.Map(a0)
		move.w	#$2444,obj.Gfx(a0)
		move.b	#4,obj.Render(a0)
		move.b	#3,obj.Priority(a0)
		move.b	#8,obj.ActWid(a0)
		andi.b	#3,obj.Status(a0)
		tst.b	obj.Subtype(a0)
		beq.s	loc_7A4E
		move.b	#8,obj.Routine(a0)
		move.b	#$87,obj.ColType(a0)
		move.b	#1,obj.Anim(a0)
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
		_cmpi.b	#id_ExplosionItem,obj.Id(a1)
		beq.s	loc_7AB2
		rts
; ---------------------------------------------------------------------------

loc_7A6C:
		btst	#7,obj.Status(a0)
		bne.s	loc_7AA2
		move.b	#$87,obj.ColType(a0)
		move.b	#1,obj.Anim(a0)
		bsr.w	SpeedToPos
		lea	(Ani_Missile).l,a1
		bsr.w	AnimateSprite
		bsr.w	DisplaySprite
		move.w	(v_limitbtm2).w,d0
		addi.w	#$E0,d0
		cmp.w	obj.Ypos(a0),d0
		bcs.s	loc_7AB2
		rts
; ---------------------------------------------------------------------------

loc_7AA2:
		_move.b	#id_MissileDissolve,obj.Id(a0)
		move.b	#0,obj.Routine(a0)
		bra.w	ObjCannonballExplode
; ---------------------------------------------------------------------------

loc_7AB2:
		bsr.w	DeleteObject
		rts
; ---------------------------------------------------------------------------

loc_7AB8:
		tst.b	obj.Render(a0)
		bpl.s	loc_7AB2
		bsr.w	SpeedToPos

loc_7AC2:
		lea	(Ani_Missile).l,a1
		bsr.w	AnimateSprite
		bsr.w	DisplaySprite
		rts
