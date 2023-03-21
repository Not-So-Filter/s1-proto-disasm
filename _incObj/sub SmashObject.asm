; ---------------------------------------------------------------------------

ObjectFragment:
		moveq	#0,d0
		move.b	frame(a0),d0
		add.w	d0,d0
		movea.l	map(a0),a3
		adda.w	(a3,d0.w),a3
		addq.w	#1,a3
		bset	#5,render(a0)
		move.b	id(a0),d4
		move.b	render(a0),d5
		movea.l	a0,a1
		bra.s	loc_AED6
; ---------------------------------------------------------------------------

loc_AECE:
		bsr.w	ObjectLoad
		bne.s	loc_AF28
		addq.w	#5,a3

loc_AED6:
		move.b	#4,act(a1)
		move.b	d4,id(a1)
		move.l	a3,map(a1)
		move.b	d5,render(a1)
		move.w	xpos(a0),xpos(a1)
		move.w	ypos(a0),ypos(a1)
		move.w	tile(a0),tile(a1)
		move.b	prio(a0),prio(a1)
		move.b	xdisp(a0),xdisp(a1)
		move.w	(a4)+,xvel(a1)
		move.w	(a4)+,yvel(a1)
		cmpa.l	a0,a1
		bcc.s	loc_AF24
		move.l	a0,-(sp)
		movea.l	a1,a0
		bsr.w	SpeedToPos
		add.w	d2,yvel(a0)
		movea.l	(sp)+,a0
		bsr.w	DisplaySprite1

loc_AF24:
		dbf	d1,loc_AECE

loc_AF28:
		move.w	#sfx_WallSmash,d0
		jmp	(PlaySFX).l
