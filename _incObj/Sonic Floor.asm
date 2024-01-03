; ---------------------------------------------------------------------------

Sonic_Floor:
		move.w	obj.VelX(a0),d1
		move.w	obj.VelY(a0),d2
		jsr	(CalcAngle).l
		subi.b	#$20,d0
		andi.b	#$C0,d0
		cmpi.b	#$40,d0
		beq.w	loc_F104
		cmpi.b	#$80,d0
		beq.w	loc_F160
		cmpi.b	#$C0,d0
		beq.w	loc_F1BC

loc_F07C:
		bsr.w	Sonic_HitWall
		tst.w	d1
		bpl.s	loc_F08E
		sub.w	d1,obj.Xpos(a0)
		move.w	#0,obj.VelX(a0)

loc_F08E:
		bsr.w	sub_1068C
		tst.w	d1
		bpl.s	loc_F0A0
		add.w	d1,obj.Xpos(a0)
		move.w	#0,obj.VelX(a0)

loc_F0A0:
		bsr.w	Sonic_HitFloor
		tst.w	d1
		bpl.s	locret_F102
		move.b	obj.VelY(a0),d0
		addq.b	#8,d0
		neg.b	d0
		cmp.b	d0,d1
		blt.s	locret_F102
		add.w	d1,obj.Ypos(a0)
		move.b	d3,obj.Angle(a0)
		bsr.w	Sonic_ResetOnFloor
		move.b	#id_Walk,obj.Anim(a0)
		move.b	d3,d0
		addi.b	#$20,d0
		andi.b	#$40,d0
		bne.s	loc_F0E0
		move.w	#0,obj.VelY(a0)
		move.w	obj.VelX(a0),obj.Inertia(a0)
		rts
; ---------------------------------------------------------------------------

loc_F0E0:
		move.w	#0,obj.VelX(a0)
		cmpi.w	#$FC0,obj.VelY(a0)
		ble.s	loc_F0F4
		move.w	#$FC0,obj.VelY(a0)

loc_F0F4:
		move.w	obj.VelY(a0),obj.Inertia(a0)
		tst.b	d3
		bpl.s	locret_F102
		neg.w	obj.Inertia(a0)

locret_F102:
		rts
; ---------------------------------------------------------------------------

loc_F104:
		bsr.w	Sonic_HitWall
		tst.w	d1
		bpl.s	loc_F11E
		sub.w	d1,obj.Xpos(a0)
		move.w	#0,obj.VelX(a0)
		move.w	obj.VelY(a0),obj.Inertia(a0)
		rts
; ---------------------------------------------------------------------------

loc_F11E:
		bsr.w	Sonic_NoRunningOnWalls
		tst.w	d1
		bpl.s	loc_F132
		sub.w	d1,obj.Ypos(a0)
		move.w	#0,obj.VelY(a0)
		rts
; ---------------------------------------------------------------------------

loc_F132:
		tst.w	obj.VelY(a0)
		bmi.s	locret_F15E
		bsr.w	Sonic_HitFloor
		tst.w	d1
		bpl.s	locret_F15E
		add.w	d1,obj.Ypos(a0)
		move.b	d3,obj.Angle(a0)
		bsr.w	Sonic_ResetOnFloor
		move.b	#id_Walk,obj.Anim(a0)
		move.w	#0,obj.VelY(a0)
		move.w	obj.VelX(a0),obj.Inertia(a0)

locret_F15E:
		rts
; ---------------------------------------------------------------------------

loc_F160:
		bsr.w	Sonic_HitWall
		tst.w	d1
		bpl.s	loc_F172
		sub.w	d1,obj.Xpos(a0)
		move.w	#0,obj.VelX(a0)

loc_F172:
		bsr.w	sub_1068C
		tst.w	d1
		bpl.s	loc_F184
		add.w	d1,obj.Xpos(a0)
		move.w	#0,obj.VelX(a0)

loc_F184:
		bsr.w	Sonic_NoRunningOnWalls
		tst.w	d1
		bpl.s	locret_F1BA
		sub.w	d1,obj.Ypos(a0)
		move.b	d3,d0
		addi.b	#$20,d0
		andi.b	#$40,d0
		bne.s	loc_F1A4
		move.w	#0,obj.VelY(a0)
		rts
; ---------------------------------------------------------------------------

loc_F1A4:
		move.b	d3,obj.Angle(a0)
		bsr.w	Sonic_ResetOnFloor
		move.w	obj.VelY(a0),obj.Inertia(a0)
		tst.b	d3
		bpl.s	locret_F1BA
		neg.w	obj.Inertia(a0)

locret_F1BA:
		rts
; ---------------------------------------------------------------------------

loc_F1BC:
		bsr.w	sub_1068C
		tst.w	d1
		bpl.s	loc_F1D6
		add.w	d1,obj.Xpos(a0)
		move.w	#0,obj.VelX(a0)
		move.w	obj.VelY(a0),obj.Inertia(a0)
		rts
; ---------------------------------------------------------------------------

loc_F1D6:
		bsr.w	Sonic_NoRunningOnWalls
		tst.w	d1
		bpl.s	loc_F1EA
		sub.w	d1,obj.Ypos(a0)
		move.w	#0,obj.VelY(a0)
		rts
; ---------------------------------------------------------------------------

loc_F1EA:
		tst.w	obj.VelY(a0)
		bmi.s	locret_F216
		bsr.w	Sonic_HitFloor
		tst.w	d1
		bpl.s	locret_F216
		add.w	d1,obj.Ypos(a0)
		move.b	d3,obj.Angle(a0)
		bsr.w	Sonic_ResetOnFloor
		move.b	#id_Walk,obj.Anim(a0)
		move.w	#0,obj.VelY(a0)
		move.w	obj.VelX(a0),obj.Inertia(a0)

locret_F216:
		rts
