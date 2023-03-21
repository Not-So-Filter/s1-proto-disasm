ObjHUD:
		moveq	#0,d0
		move.b	$24(a0),d0
		move.w	off_115EA(pc,d0.w),d1
		jmp	off_115EA(pc,d1.w)
; ---------------------------------------------------------------------------

off_115EA:	dc.w loc_115EE-off_115EA, loc_11618-off_115EA
; ---------------------------------------------------------------------------

loc_115EE:
		addq.b	#2,act(a0)
		move.w	#$90,xpos(a0)
		move.w	#$108,xpix(a0)
		move.l	#MapHUD,map(a0)
		move.w	#$6CA,tile(a0)
		move.b	#0,render(a0)
		move.b	#0,prio(a0)

loc_11618:
		jmp	(DisplaySprite).l
