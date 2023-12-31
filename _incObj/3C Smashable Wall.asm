; ---------------------------------------------------------------------------

ObjSmashWall:
		moveq	#0,d0
		move.b	obj.Routine(a0),d0
		move.w	off_ADEA(pc,d0.w),d1
		jsr	off_ADEA(pc,d1.w)
		bra.w	RememberState
; ---------------------------------------------------------------------------

off_ADEA:	dc.w loc_ADF0-off_ADEA, loc_AE1A-off_ADEA, loc_AE92-off_ADEA
; ---------------------------------------------------------------------------

loc_ADF0:
		addq.b	#2,obj.Routine(a0)
		move.l	#MapSmashWall,obj.Map(a0)
		move.w	#$450F,obj.Gfx(a0)
		move.b	#4,obj.Render(a0)
		move.b	#$10,obj.ActWid(a0)
		move.b	#4,obj.Priority(a0)
		move.b	obj.Subtype(a0),obj.Frame(a0)

loc_AE1A:
		move.w	(v_objspace+obj.VelX).w,$30(a0)
		move.w	#$1B,d1
		move.w	#$20,d2
		move.w	#$20,d3
		move.w	obj.Xpos(a0),d4
		bsr.w	SolidObject
		btst	#5,obj.Status(a0)
		bne.s	loc_AE3E

locret_AE3C:
		rts
; ---------------------------------------------------------------------------

loc_AE3E:
		cmpi.b	#id_Roll,obj.Anim(a1)
		bne.s	locret_AE3C
		move.w	$30(a0),d0
		bpl.s	loc_AE4E
		neg.w	d0

loc_AE4E:
		cmpi.w	#$480,d0
		bcs.s	locret_AE3C
		move.w	$30(a0),obj.VelX(a1)
		addq.w	#4,obj.Xpos(a1)
		lea	(ObjSmashWall_FragRight).l,a4
		move.w	obj.Xpos(a0),d0
		cmp.w	obj.Xpos(a1),d0
		bcs.s	loc_AE78
		subq.w	#8,obj.Xpos(a1)
		lea	(ObjSmashWall_FragLeft).l,a4

loc_AE78:
		move.w	obj.VelX(a1),obj.Inertia(a1)
		bclr	#5,obj.Status(a0)
		bclr	#5,obj.Status(a1)
		moveq	#7,d1
		move.w	#$70,d2
		bsr.s	ObjectFragment

loc_AE92:
		bsr.w	SpeedToPos
		addi.w	#$70,obj.VelY(a0)
		bsr.w	DisplaySprite
		tst.b	obj.Render(a0)
		bpl.w	DeleteObject
		rts
