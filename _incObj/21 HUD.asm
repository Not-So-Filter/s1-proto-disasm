ObjHUD:
		moveq	#0,d0
		move.b	objRoutine(a0),d0
		move.w	off_115EA(pc,d0.w),d1
		jmp	off_115EA(pc,d1.w)
; ---------------------------------------------------------------------------

off_115EA:	dc.w loc_115EE-off_115EA, loc_11618-off_115EA
; ---------------------------------------------------------------------------

loc_115EE:
		addq.b	#2,objRoutine(a0)
		move.w	#$90,objX(a0)
		move.w	#$108,objScreenY(a0)
		move.l	#Map_HUD,objMap(a0)
		move.w	#$6CA,objGfx(a0)
		move.b	#0,objRender(a0)
		move.b	#0,objPriority(a0)

loc_11618:
		jmp	(DisplaySprite).l
