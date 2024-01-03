; ---------------------------------------------------------------------------

TitleText:
		moveq	#0,d0
		move.b	obj.Routine(a0),d0
		move.w	off_6AE8(pc,d0.w),d1
		jsr	off_6AE8(pc,d1.w)
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

off_6AE8:	dc.w loc_6AEE-off_6AE8, loc_6B1A-off_6AE8, locret_6B18-off_6AE8
; ---------------------------------------------------------------------------

loc_6AEE:
		addq.b	#2,obj.Routine(a0)
		move.w	#$D0,obj.Xpos(a0)
		move.w	#$130,obj.ScreenY(a0)
		move.l	#Map_TitleText,obj.Map(a0)
		move.w	#$200,obj.Gfx(a0)
		cmpi.b	#2,obj.Frame(a0)
		bne.s	loc_6B1A
		addq.b	#2,obj.Routine(a0)

locret_6B18:
		rts
; ---------------------------------------------------------------------------

loc_6B1A:
		lea	(Ani_PSBTM).l,a1
		bra.w	AnimateSprite
