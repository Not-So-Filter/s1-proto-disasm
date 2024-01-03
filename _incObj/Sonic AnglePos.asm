; ---------------------------------------------------------------------------

Sonic_AnglePos:
		btst	#3,obj.Status(a0)
		beq.s	loc_FE26
		moveq	#0,d0
		move.b	d0,(v_angle_primary).w
		move.b	d0,(v_angle_secondary).w
		rts
; ---------------------------------------------------------------------------

loc_FE26:
		moveq	#3,d0
		move.b	d0,(v_angle_primary).w
		move.b	d0,(v_angle_secondary).w
		move.b	obj.Angle(a0),d0
		addi.b	#$20,d0
		andi.b	#$C0,d0
		cmpi.b	#$40,d0
		beq.w	Sonic_WalkVertL
		cmpi.b	#$80,d0
		beq.w	Sonic_WalkCeiling
		cmpi.b	#$C0,d0
		beq.w	Sonic_WalkVertR
		move.w	obj.Ypos(a0),d2
		move.w	obj.Xpos(a0),d3
		moveq	#0,d0
		move.b	obj.Height(a0),d0
		ext.w	d0
		add.w	d0,d2
		move.b	obj.Width(a0),d0
		ext.w	d0
		add.w	d0,d3
		lea	(v_angle_primary).w,a4
		movea.w	#$10,a3
		move.w	#0,d6
		moveq	#$D,d5
		bsr.w	sub_101BE
		move.w	d1,-(sp)
		move.w	obj.Ypos(a0),d2
		move.w	obj.Xpos(a0),d3
		moveq	#0,d0
		move.b	obj.Height(a0),d0
		ext.w	d0
		add.w	d0,d2
		move.b	obj.Width(a0),d0
		ext.w	d0
		neg.w	d0
		add.w	d0,d3
		lea	(v_angle_secondary).w,a4
		movea.w	#$10,a3
		move.w	#0,d6
		moveq	#$D,d5
		bsr.w	sub_101BE
		move.w	(sp)+,d0
		bsr.w	Sonic_Angle
		tst.w	d1
		beq.s	locret_FEC6
		bpl.s	loc_FEC8
		cmpi.w	#$FFF2,d1
		blt.s	locret_FEE8
		add.w	d1,obj.Ypos(a0)

locret_FEC6:
		rts
; ---------------------------------------------------------------------------

loc_FEC8:
		cmpi.w	#$E,d1
		bgt.s	loc_FED4
		add.w	d1,obj.Ypos(a0)
		rts
; ---------------------------------------------------------------------------

loc_FED4:
		bset	#1,obj.Status(a0)
		bclr	#5,obj.Status(a0)
		move.b	#1,obj.NextAni(a0)
		rts
; ---------------------------------------------------------------------------

locret_FEE8:
		rts
; ---------------------------------------------------------------------------
		move.l	obj.Xpos(a0),d2
		move.w	obj.VelX(a0),d0
		ext.l	d0
		asl.l	#8,d0
		sub.l	d0,d2
		move.l	d2,obj.Xpos(a0)
		move.w	#$38,d0
		ext.l	d0
		asl.l	#8,d0
		sub.l	d0,d3
		move.l	d3,obj.Ypos(a0)
		rts
; ---------------------------------------------------------------------------

locret_FF0C:
		rts
; ---------------------------------------------------------------------------
		move.l	obj.Ypos(a0),d3
		move.w	obj.VelY(a0),d0
		subi.w	#$38,d0
		move.w	d0,obj.VelY(a0)
		ext.l	d0
		asl.l	#8,d0
		sub.l	d0,d3
		move.l	d3,obj.Ypos(a0)
		rts
; ---------------------------------------------------------------------------
		rts
; ---------------------------------------------------------------------------

sub_FF2C:
		move.l	obj.Xpos(a0),d2
		move.l	obj.Ypos(a0),d3
		move.w	obj.VelX(a0),d0
		ext.l	d0
		asl.l	#8,d0
		sub.l	d0,d2

loc_FF3E:
		move.w	obj.VelY(a0),d0
		ext.l	d0
		asl.l	#8,d0
		sub.l	d0,d3
		move.l	d2,obj.Xpos(a0)
		move.l	d3,obj.Ypos(a0)
		rts
; ---------------------------------------------------------------------------

Sonic_Angle:
		move.b	(v_angle_secondary).w,d2
		cmp.w	d0,d1
		ble.s	loc_FF60
		move.b	(v_angle_primary).w,d2
		move.w	d0,d1

loc_FF60:
		btst	#0,d2
		bne.s	loc_FF6C
		move.b	d2,obj.Angle(a0)
		rts
; ---------------------------------------------------------------------------

loc_FF6C:
		move.b	obj.Angle(a0),d2
		addi.b	#$20,d2
		andi.b	#$C0,d2
		move.b	d2,obj.Angle(a0)
		rts
; ---------------------------------------------------------------------------

Sonic_WalkVertR:
		move.w	obj.Ypos(a0),d2
		move.w	obj.Xpos(a0),d3
		moveq	#0,d0

loc_FF88:
		move.b	obj.Width(a0),d0
		ext.w	d0
		neg.w	d0
		add.w	d0,d2
		move.b	obj.Height(a0),d0
		ext.w	d0
		add.w	d0,d3
		lea	(v_angle_primary).w,a4
		movea.w	#$10,a3
		move.w	#0,d6
		moveq	#$D,d5
		bsr.w	FindFloor
		move.w	d1,-(sp)

loc_FFAE:
		move.w	obj.Ypos(a0),d2
		move.w	obj.Xpos(a0),d3
		moveq	#0,d0
		move.b	obj.Width(a0),d0
		ext.w	d0
		add.w	d0,d2
		move.b	obj.Height(a0),d0
		ext.w	d0
		add.w	d0,d3
		lea	(v_angle_secondary).w,a4
		movea.w	#$10,a3
		move.w	#0,d6
		moveq	#$D,d5

loc_FFD6:
		bsr.w	FindFloor
		move.w	(sp)+,d0
		bsr.w	Sonic_Angle
		tst.w	d1
		beq.s	locret_FFF2
		bpl.s	loc_FFF4
		cmpi.w	#$FFF2,d1
		blt.w	locret_FF0C
		add.w	d1,obj.Xpos(a0)

locret_FFF2:
		rts
; ---------------------------------------------------------------------------

loc_FFF4:
		cmpi.w	#$E,d1
		bgt.s	loc_10000
		add.w	d1,obj.Xpos(a0)

locret_FFFE:
		rts
; ---------------------------------------------------------------------------

loc_10000:
		bset	#1,obj.Status(a0)
		bclr	#5,obj.Status(a0)
		move.b	#1,obj.NextAni(a0)
		rts
; ---------------------------------------------------------------------------

Sonic_WalkCeiling:
		move.w	obj.Ypos(a0),d2
		move.w	obj.Xpos(a0),d3
		moveq	#0,d0
		move.b	obj.Height(a0),d0
		ext.w	d0
		sub.w	d0,d2
		eori.w	#$F,d2
		move.b	obj.Width(a0),d0
		ext.w	d0
		add.w	d0,d3
		lea	(v_angle_primary).w,a4
		movea.w	#-$10,a3
		move.w	#$1000,d6
		moveq	#$D,d5
		bsr.w	sub_101BE
		move.w	d1,-(sp)
		move.w	obj.Ypos(a0),d2
		move.w	obj.Xpos(a0),d3
		moveq	#0,d0
		move.b	obj.Height(a0),d0
		ext.w	d0
		sub.w	d0,d2
		eori.w	#$F,d2
		move.b	obj.Width(a0),d0
		ext.w	d0
		sub.w	d0,d3
		lea	(v_angle_secondary).w,a4
		movea.w	#-$10,a3
		move.w	#$1000,d6
		moveq	#$D,d5
		bsr.w	sub_101BE
		move.w	(sp)+,d0
		bsr.w	Sonic_Angle
		tst.w	d1
		beq.s	locret_1008E
		bpl.s	loc_10090
		cmpi.w	#$FFF2,d1
		blt.w	locret_FEE8
		sub.w	d1,obj.Ypos(a0)

locret_1008E:
		rts
; ---------------------------------------------------------------------------

loc_10090:
		cmpi.w	#$E,d1
		bgt.s	loc_1009C
		sub.w	d1,obj.Ypos(a0)
		rts
; ---------------------------------------------------------------------------

loc_1009C:
		bset	#1,obj.Status(a0)
		bclr	#5,obj.Status(a0)
		move.b	#1,obj.NextAni(a0)
		rts
; ---------------------------------------------------------------------------

Sonic_WalkVertL:
		move.w	obj.Ypos(a0),d2
		move.w	obj.Xpos(a0),d3
		moveq	#0,d0
		move.b	obj.Width(a0),d0
		ext.w	d0
		sub.w	d0,d2
		move.b	obj.Height(a0),d0
		ext.w	d0
		sub.w	d0,d3
		eori.w	#$F,d3
		lea	(v_angle_primary).w,a4
		movea.w	#-$10,a3
		move.w	#$800,d6
		moveq	#$D,d5
		bsr.w	FindFloor
		move.w	d1,-(sp)
		move.w	obj.Ypos(a0),d2
		move.w	obj.Xpos(a0),d3
		moveq	#0,d0
		move.b	obj.Width(a0),d0
		ext.w	d0
		add.w	d0,d2
		move.b	obj.Height(a0),d0
		ext.w	d0
		sub.w	d0,d3
		eori.w	#$F,d3
		lea	(v_angle_secondary).w,a4
		movea.w	#-$10,a3
		move.w	#$800,d6
		moveq	#$D,d5
		bsr.w	FindFloor
		move.w	(sp)+,d0
		bsr.w	Sonic_Angle
		tst.w	d1
		beq.s	locret_1012A
		bpl.s	loc_1012C
		cmpi.w	#$FFF2,d1
		blt.w	locret_FF0C
		sub.w	d1,obj.Xpos(a0)

locret_1012A:
		rts
; ---------------------------------------------------------------------------

loc_1012C:
		cmpi.w	#$E,d1
		bgt.s	loc_10138
		sub.w	d1,obj.Xpos(a0)
		rts
; ---------------------------------------------------------------------------

loc_10138:
		bset	#1,obj.Status(a0)
		bclr	#5,obj.Status(a0)
		move.b	#1,obj.NextAni(a0)
		rts
