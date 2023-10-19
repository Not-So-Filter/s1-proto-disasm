; ---------------------------------------------------------------------------

TitleText:
		moveq	#0,d0
		move.b	objRoutine(a0),d0
		move.w	off_6AE8(pc,d0.w),d1
		jsr	off_6AE8(pc,d1.w)
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

off_6AE8:	dc.w loc_6AEE-off_6AE8, loc_6B1A-off_6AE8, locret_6B18-off_6AE8
; ---------------------------------------------------------------------------

loc_6AEE:
		addq.b	#2,objRoutine(a0)
		move.w	#$D0,objX(a0)
		move.w	#$130,objScreenY(a0)
		move.l	#Map_TitleText,objMap(a0)
		move.w	#$200,objGfx(a0)
		cmpi.b	#2,objFrame(a0)
		bne.s	loc_6B1A
		addq.b	#2,objRoutine(a0)

locret_6B18:
		rts
; ---------------------------------------------------------------------------

loc_6B1A:
		lea	(Ani_PSBTM).l,a1
		bra.w	AnimateSprite