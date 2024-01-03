; ---------------------------------------------------------------------------

ObjSmashBlock:
		moveq	#0,d0
		move.b	obj.Routine(a0),d0
		move.w	off_D4D4(pc,d0.w),d1
		jsr	off_D4D4(pc,d1.w)
		bra.w	RememberState
; ---------------------------------------------------------------------------

off_D4D4:	dc.w loc_D4DA-off_D4D4, loc_D504-off_D4D4, loc_D580-off_D4D4
; ---------------------------------------------------------------------------

loc_D4DA:
		addq.b	#2,obj.Routine(a0)
		move.l	#MapSmashBlock,obj.Map(a0)
		move.w	#$42B8,obj.Gfx(a0)
		move.b	#4,obj.Render(a0)
		move.b	#$10,obj.ActWid(a0)
		move.b	#4,obj.Priority(a0)
		move.b	obj.Subtype(a0),obj.Frame(a0)

loc_D504:
		move.b	(v_player+obj.Anim).w,$32(a0)
		move.w	#$1B,d1
		move.w	#$10,d2
		move.w	#$11,d3
		move.w	obj.Xpos(a0),d4
		bsr.w	SolidObject
		btst	#3,obj.Status(a0)
		bne.s	loc_D528

locret_D526:
		rts
; ---------------------------------------------------------------------------

loc_D528:
		cmpi.b	#2,$32(a0)
		bne.s	locret_D526
		bset	#2,obj.Status(a1)
		move.b	#$E,obj.Height(a1)
		move.b	#7,obj.Width(a1)
		move.b	#2,obj.Anim(a1)
		move.w	#$FD00,obj.VelY(a1)
		bset	#1,obj.Status(a1)
		bclr	#3,obj.Status(a1)
		move.b	#2,obj.Routine(a1)
		bclr	#3,obj.Status(a0)
		clr.b	obj.2ndRout(a0)
		move.b	#1,obj.Frame(a0)
		lea	(ObjSmashBlock_Frag).l,a4
		moveq	#3,d1
		move.w	#$38,d2
		bsr.w	ObjectFragment

loc_D580:
		bsr.w	SpeedToPos
		addi.w	#$38,obj.VelY(a0)
		bsr.w	DisplaySprite
		tst.b	obj.Render(a0)
		bpl.w	DeleteObject
		rts
