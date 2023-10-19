; ---------------------------------------------------------------------------

TitleSonic:
		moveq	#0,d0
		move.b	objRoutine(a0),d0
		move.w	off_6A64(pc,d0.w),d1
		jmp	off_6A64(pc,d1.w)
; ---------------------------------------------------------------------------

off_6A64:	dc.w loc_6A6C-off_6A64, loc_6AA0-off_6A64, loc_6AB0-off_6A64, loc_6AC6-off_6A64
; ---------------------------------------------------------------------------

loc_6A6C:
		addq.b	#2,objRoutine(a0)
		move.w	#$F0,objX(a0)
		move.w	#$DE,objScreenY(a0)
		move.l	#Map_TitleSonic,objMap(a0)
		move.w	#$2300,objGfx(a0)
		move.b	#1,objPriority(a0)
		move.b	#$1D,objDelayAni(a0)
		lea	(Ani_TSon).l,a1
		bsr.w	AnimateSprite

loc_6AA0:
		subq.b	#1,objDelayAni(a0)
		bpl.s	locret_6AAE
		addq.b	#2,objRoutine(a0)
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

locret_6AAE:
		rts
; ---------------------------------------------------------------------------

loc_6AB0:
		subq.w	#8,objScreenY(a0)
		cmpi.w	#$96,objScreenY(a0)
		bne.s	loc_6AC0
		addq.b	#2,objRoutine(a0)

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