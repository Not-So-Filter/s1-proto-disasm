; ---------------------------------------------------------------------------

ObjectFall:
		move.l	objX(a0),d2
		move.l	objY(a0),d3
		move.w	objVelX(a0),d0
		ext.l	d0
		asl.l	#8,d0
		add.l	d0,d2
		move.w	objVelY(a0),d0
		addi.w	#$38,d0
		move.w	d0,objVelY(a0)
		ext.l	d0
		asl.l	#8,d0
		add.l	d0,d3
		move.l	d2,objX(a0)
		move.l	d3,objY(a0)
		rts
