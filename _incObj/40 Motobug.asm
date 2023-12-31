; ---------------------------------------------------------------------------

ObjMotobug:
		moveq	#0,d0
		move.b	obj.Routine(a0),d0
		move.w	off_B890(pc,d0.w),d1
		jmp	off_B890(pc,d1.w)
; ---------------------------------------------------------------------------

off_B890:	dc.w loc_B898-off_B890, loc_B8FA-off_B890, loc_B9D8-off_B890, loc_B9E6-off_B890
; ---------------------------------------------------------------------------

loc_B898:
		move.l	#Map_Moto,obj.Map(a0)
		move.w	#$4F0,obj.Gfx(a0)
		move.b	#4,obj.Render(a0)
		move.b	#4,obj.Priority(a0)
		move.b	#$14,obj.ActWid(a0)
		tst.b	obj.Anim(a0)
		bne.s	loc_B8F2
		move.b	#$E,obj.Height(a0)
		move.b	#8,obj.Width(a0)
		move.b	#$C,obj.ColType(a0)
		bsr.w	ObjectFall
		bsr.w	ObjectHitFloor
		tst.w	d1
		bpl.s	locret_B8F0
		add.w	d1,obj.Ypos(a0)
		move.w	#0,obj.VelY(a0)
		addq.b	#2,obj.Routine(a0)
		bchg	#0,obj.Status(a0)

locret_B8F0:
		rts
; ---------------------------------------------------------------------------

loc_B8F2:
		addq.b	#4,obj.Routine(a0)
		bra.w	loc_B9D8
; ---------------------------------------------------------------------------

loc_B8FA:
		moveq	#0,d0
		move.b	obj.2ndRout(a0),d0
		move.w	off_B94E(pc,d0.w),d1
		jsr	off_B94E(pc,d1.w)
		lea	(Ani_Moto).l,a1
		bsr.w	AnimateSprite

		include "sub RememberState.asm"
; ---------------------------------------------------------------------------

off_B94E:	dc.w loc_B952-off_B94E, loc_B976-off_B94E
; ---------------------------------------------------------------------------

loc_B952:
		subq.w	#1,$30(a0)
		bpl.s	locret_B974
		addq.b	#2,obj.2ndRout(a0)
		move.w	#-$100,obj.VelX(a0)
		move.b	#1,obj.Anim(a0)
		bchg	#0,obj.Status(a0)
		bne.s	locret_B974
		neg.w	obj.VelX(a0)

locret_B974:
		rts
; ---------------------------------------------------------------------------

loc_B976:
		bsr.w	SpeedToPos
		bsr.w	ObjectHitFloor
		cmpi.w	#$FFF8,d1
		blt.s	loc_B9C0
		cmpi.w	#$C,d1
		bge.s	loc_B9C0
		add.w	d1,obj.Ypos(a0)
		subq.b	#1,$33(a0)
		bpl.s	locret_B9BE
		move.b	#$F,$33(a0)
		bsr.w	FindFreeObj
		bne.s	locret_B9BE
		_move.b	#id_MotoBug,obj.Id(a1)
		move.w	obj.Xpos(a0),obj.Xpos(a1)
		move.w	obj.Ypos(a0),obj.Ypos(a1)
		move.b	obj.Status(a0),obj.Status(a1)
		move.b	#2,obj.Anim(a1)

locret_B9BE:
		rts
; ---------------------------------------------------------------------------

loc_B9C0:
		subq.b	#2,obj.2ndRout(a0)
		move.w	#$3B,$30(a0)
		move.w	#0,obj.VelX(a0)
		move.b	#0,obj.Anim(a0)
		rts
; ---------------------------------------------------------------------------

loc_B9D8:
		lea	(Ani_Moto).l,a1
		bsr.w	AnimateSprite
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

loc_B9E6:
		bra.w	DeleteObject
