ObjHUD:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	off_115EA(pc,d0.w),d1
		jmp	off_115EA(pc,d1.w)
; ---------------------------------------------------------------------------

off_115EA:	dc.w loc_115EE-off_115EA, loc_11618-off_115EA
; ---------------------------------------------------------------------------

loc_115EE:
		addq.b	#2,obRoutine(a0)
		move.w	#$90,obX(a0)
		move.w	#$108,obScreenY(a0)
		move.l	#Map_HUD,obMap(a0)
		move.w	#$6CA,obGfx(a0)
		move.b	#0,obRender(a0)
		move.b	#0,obPriority(a0)

loc_11618:
		jmp	(DisplaySprite).l
