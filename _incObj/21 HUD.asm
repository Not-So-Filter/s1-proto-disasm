ObjHUD:
		moveq	#0,d0
		move.b	obj.Routine(a0),d0
		move.w	off_115EA(pc,d0.w),d1
		jmp	off_115EA(pc,d1.w)
; ---------------------------------------------------------------------------

off_115EA:	dc.w loc_115EE-off_115EA, loc_11618-off_115EA
; ---------------------------------------------------------------------------

loc_115EE:
		addq.b	#2,obj.Routine(a0)
		move.w	#$90,obj.Xpos(a0)
		move.w	#$108,obj.ScreenY(a0)
		move.l	#Map_HUD,obj.Map(a0)
		move.w	#$6CA,obj.Gfx(a0)
		move.b	#0,obj.Render(a0)
		move.b	#0,obj.Priority(a0)

loc_11618:
		jmp	(DisplaySprite).l
