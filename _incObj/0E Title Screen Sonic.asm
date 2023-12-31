; ---------------------------------------------------------------------------

TitleSonic:
		moveq	#0,d0
		move.b	obj.Routine(a0),d0
		move.w	off_6A64(pc,d0.w),d1
		jmp	off_6A64(pc,d1.w)
; ---------------------------------------------------------------------------

off_6A64:	dc.w loc_6A6C-off_6A64, loc_6AA0-off_6A64, loc_6AB0-off_6A64, loc_6AC6-off_6A64
; ---------------------------------------------------------------------------

loc_6A6C:
		addq.b	#2,obj.Routine(a0)
		move.w	#$F0,obj.Xpos(a0)
		move.w	#$DE,obj.ScreenY(a0)
		move.l	#Map_TitleSonic,obj.Map(a0)
		move.w	#$2300,obj.Gfx(a0)
		move.b	#1,obj.Priority(a0)
		move.b	#$1D,obj.DelayAni(a0)
		lea	(Ani_TSon).l,a1
		bsr.w	AnimateSprite

loc_6AA0:
		subq.b	#1,obj.DelayAni(a0)
		bpl.s	locret_6AAE
		addq.b	#2,obj.Routine(a0)
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

locret_6AAE:
		rts
; ---------------------------------------------------------------------------

loc_6AB0:
		subq.w	#8,obj.ScreenY(a0)
		cmpi.w	#$96,obj.ScreenY(a0)
		bne.s	loc_6AC0
		addq.b	#2,obj.Routine(a0)

loc_6AC0:
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------
		rts
; ---------------------------------------------------------------------------

loc_6AC6:
		lea	(Ani_TSon).l,a1
		bsr.w	AnimateSprite
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------
		rts