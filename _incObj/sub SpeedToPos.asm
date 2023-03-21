; ---------------------------------------------------------------------------

SpeedToPos:
		move.l	xpos(a0),d2
		move.l	ypos(a0),d3
		move.w	xvel(a0),d0
		ext.l	d0
		asl.l	#8,d0
		add.l	d0,d2
		move.w	yvel(a0),d0
		ext.l	d0
		asl.l	#8,d0
		add.l	d0,d3
		move.l	d2,xpos(a0)
		move.l	d3,ypos(a0)
		rts
