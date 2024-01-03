; ---------------------------------------------------------------------------

Sonic_ResetOnFloor:
		btst	#4,obj.Status(a0)
		beq.s	loc_F226
		nop
		nop
		nop

loc_F226:
		bclr	#5,obj.Status(a0)
		bclr	#1,obj.Status(a0)
		bclr	#4,obj.Status(a0)
		btst	#2,obj.Status(a0)
		beq.s	loc_F25C
		bclr	#2,obj.Status(a0)
		move.b	#$13,obj.Height(a0)
		move.b	#9,obj.Width(a0)
		move.b	#id_Walk,obj.Anim(a0)
		subq.w	#5,obj.Ypos(a0)

loc_F25C:
		move.w	#0,ctrllock(a0)
		move.b	#0,jumpflag(a0)
		rts
