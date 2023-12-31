; ---------------------------------------------------------------------------

ObjectFragment:
		moveq	#0,d0
		move.b	obj.Frame(a0),d0
		add.w	d0,d0
		movea.l	obj.Map(a0),a3
		adda.w	(a3,d0.w),a3
		addq.w	#1,a3
		bset	#5,obj.Render(a0)
		_move.b	obj.Id(a0),d4
		move.b	obj.Render(a0),d5
		movea.l	a0,a1
		bra.s	loc_AED6
; ---------------------------------------------------------------------------

loc_AECE:
		bsr.w	FindFreeObj
		bne.s	loc_AF28
		addq.w	#5,a3

loc_AED6:
		move.b	#4,obj.Routine(a1)
		_move.b	d4,obj.Id(a1)
		move.l	a3,obj.Map(a1)
		move.b	d5,obj.Render(a1)
		move.w	obj.Xpos(a0),obj.Xpos(a1)
		move.w	obj.Ypos(a0),obj.Ypos(a1)
		move.w	obj.Gfx(a0),obj.Gfx(a1)
		move.b	obj.Priority(a0),obj.Priority(a1)
		move.b	obj.ActWid(a0),obj.ActWid(a1)
		move.w	(a4)+,obj.VelX(a1)
		move.w	(a4)+,obj.VelY(a1)
		cmpa.l	a0,a1
		bcc.s	loc_AF24
		move.l	a0,-(sp)
		movea.l	a1,a0
		bsr.w	SpeedToPos
		add.w	d2,obj.VelY(a0)
		movea.l	(sp)+,a0
		bsr.w	DisplaySprite1

loc_AF24:
		dbf	d1,loc_AECE

loc_AF28:
		move.w	#sfx_WallSmash,d0
		jmp	(PlaySound_Special).l
