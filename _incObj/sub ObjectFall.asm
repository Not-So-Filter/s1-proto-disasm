; ---------------------------------------------------------------------------

ObjectFall:
		move.l	obj.Xpos(a0),d2
		move.l	obj.Ypos(a0),d3
		move.w	obj.VelX(a0),d0
		ext.l	d0
		asl.l	#8,d0
		add.l	d0,d2
		move.w	obj.VelY(a0),d0
		addi.w	#$38,d0
		move.w	d0,obj.VelY(a0)
		ext.l	d0
		asl.l	#8,d0
		add.l	d0,d3
		move.l	d2,obj.Xpos(a0)
		move.l	d3,obj.Ypos(a0)
		rts
