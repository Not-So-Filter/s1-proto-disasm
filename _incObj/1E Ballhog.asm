; ---------------------------------------------------------------------------

ObjBallhog:
		moveq	#0,d0
		move.b	obj.Routine(a0),d0
		move.w	off_6F3E(pc,d0.w),d1
		jmp	off_6F3E(pc,d1.w)
; ---------------------------------------------------------------------------

off_6F3E:	dc.w loc_6F46-off_6F3E, loc_6F96-off_6F3E, loc_7056-off_6F3E, loc_705C-off_6F3E
; ---------------------------------------------------------------------------

loc_6F46:
		move.b	#$13,obj.Height(a0)
		move.b	#8,obj.Width(a0)
		move.l	#Map_Hog,obj.Map(a0)
		move.w	#$2400,obj.Gfx(a0)
		move.b	#4,obj.Render(a0)
		move.b	#4,obj.Priority(a0)
		move.b	#5,obj.ColType(a0)
		move.b	#$C,obj.ActWid(a0)
		bsr.w	ObjectFall
		jsr	(ObjectHitFloor).l
		tst.w	d1
		bpl.s	locret_6F94
		add.w	d1,obj.Ypos(a0)
		move.w	#0,obj.VelY(a0)
		addq.b	#2,obj.Routine(a0)

locret_6F94:
		rts
; ---------------------------------------------------------------------------

loc_6F96:
		moveq	#0,d0
		move.b	obj.2ndRout(a0),d0
		move.w	off_6FB2(pc,d0.w),d1
		jsr	off_6FB2(pc,d1.w)
		lea	(Ani_Hog).l,a1
		bsr.w	AnimateSprite
		bra.w	RememberState
; ---------------------------------------------------------------------------

off_6FB2:	dc.w loc_6FB6-off_6FB2, loc_701C-off_6FB2
; ---------------------------------------------------------------------------

loc_6FB6:
		subq.w	#1,obj.Off_30(a0)
		bpl.s	loc_6FE6
		addq.b	#2,obj.2ndRout(a0)
		move.w	#$FF,obj.Off_30(a0)
		move.w	#$40,obj.VelX(a0)
		move.b	#1,obj.Anim(a0)
		bchg	#0,obj.Status(a0)
		bne.s	loc_6FDE
		neg.w	obj.VelX(a0)

loc_6FDE:
		move.b	#0,obj.Off_32(a0)
		rts
; ---------------------------------------------------------------------------

loc_6FE6:
		tst.b	obj.Off_32(a0)
		bne.s	locret_6FF4
		cmpi.b	#2,obj.Frame(a0)
		beq.s	loc_6FF6

locret_6FF4:
		rts
; ---------------------------------------------------------------------------

loc_6FF6:
		move.b	#1,obj.Off_32(a0)
		bsr.w	FindFreeObj
		bne.s	locret_701A
		_move.b	#id_Cannonball,obj.Id(a1)
		move.w	obj.Xpos(a0),obj.Xpos(a1)
		move.w	obj.Ypos(a0),obj.Ypos(a1)
		addi.w	#$10,obj.Ypos(a1)

locret_701A:
		rts
; ---------------------------------------------------------------------------

loc_701C:
		subq.w	#1,obj.Off_30(a0)
		bmi.s	loc_7032
		bsr.w	SpeedToPos
		jsr	(ObjectHitFloor).l
		add.w	d1,obj.Ypos(a0)
		rts
; ---------------------------------------------------------------------------

loc_7032:
		subq.b	#2,obj.2ndRout(a0)
		move.w	#$3B,obj.Off_30(a0)
		move.w	#0,obj.VelX(a0)
		move.b	#0,obj.Anim(a0)
		tst.b	obj.Render(a0)
		bpl.s	locret_7054
		move.b	#2,obj.Anim(a0)

locret_7054:
		rts
; ---------------------------------------------------------------------------

loc_7056:
		bsr.w	DisplaySprite
		rts
; ---------------------------------------------------------------------------

loc_705C:
		bsr.w	DeleteObject
		rts
