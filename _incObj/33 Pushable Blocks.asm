; ---------------------------------------------------------------------------

ObjPushBlock:
		moveq	#0,d0
		move.b	obj.Routine(a0),d0
		move.w	off_9F10(pc,d0.w),d1
		jmp	off_9F10(pc,d1.w)
; ---------------------------------------------------------------------------
off_9F10:	dc.w loc_9F1A-off_9F10, loc_9F84-off_9F10, loc_A00C-off_9F10

byte_9F16:	dc.b $10, 0
		dc.b $40, 1
; ---------------------------------------------------------------------------

loc_9F1A:
		addq.b	#2,obj.Routine(a0)
		move.b	#$F,obj.Height(a0)
		move.b	#$F,obj.Width(a0)
		move.l	#Map_Push,obj.Map(a0)
		move.w	#$42B8,obj.Gfx(a0)
		move.b	#4,obj.Render(a0)
		move.b	#3,obj.Priority(a0)
		moveq	#0,d0
		move.b	obj.Subtype(a0),d0
		add.w	d0,d0
		andi.w	#$E,d0
		lea	byte_9F16(pc,d0.w),a2
		move.b	(a2)+,obj.ActWid(a0)
		move.b	(a2)+,obj.Frame(a0)
		tst.b	obj.Subtype(a0)
		beq.s	loc_9F68
		move.w	#$C2B8,obj.Gfx(a0)

loc_9F68:
		lea	(v_regbuffer).w,a2
		moveq	#0,d0
		move.b	obj.RespawnNo(a0),d0
		beq.s	loc_9F84
		bclr	#7,2(a2,d0.w)
		btst	#0,2(a2,d0.w)
		bne.w	DeleteObject

loc_9F84:
		moveq	#0,d1
		move.b	obj.ActWid(a0),d1
		addi.w	#$B,d1
		move.w	#$10,d2
		move.w	#$11,d3
		move.w	obj.Xpos(a0),d4
		bsr.w	sub_A14E
		cmpi.w	#$200,(v_zone).w
		bne.s	loc_9FD4
		bclr	#7,obj.Subtype(a0)
		move.w	obj.Xpos(a0),d0
		cmpi.w	#$A20,d0
		bcs.s	loc_9FD4
		cmpi.w	#$AA1,d0
		bcc.s	loc_9FD4
		move.w	(v_obj31ypos).w,d0
		subi.w	#$1C,d0
		move.w	d0,obj.Ypos(a0)
		bset	#7,(v_obj31ypos).w
		bset	#7,obj.Subtype(a0)

loc_9FD4:
		bsr.w	DisplaySprite
		out_of_range.s	loc_9FF6
		rts
; ---------------------------------------------------------------------------

loc_9FF6:
		lea	(v_regbuffer).w,a2
		moveq	#0,d0
		move.b	obj.RespawnNo(a0),d0
		beq.s	loc_A008
		bclr	#0,2(a2,d0.w)

loc_A008:
		bra.w	DeleteObject
; ---------------------------------------------------------------------------

loc_A00C:
		move.w	obj.Xpos(a0),-(sp)
		cmpi.b	#4,obj.2ndRout(a0)
		bcc.s	loc_A01C
		bsr.w	SpeedToPos

loc_A01C:
		btst	#1,obj.Status(a0)
		beq.s	loc_A05E
		addi.w	#$18,obj.VelY(a0)
		bsr.w	ObjectHitFloor
		tst.w	d1
		bpl.w	loc_A05C
		add.w	d1,obj.Ypos(a0)
		clr.w	obj.VelY(a0)
		bclr	#1,obj.Status(a0)
		move.w	(a1),d0
		andi.w	#$3FF,d0
		cmpi.w	#$2D2,d0
		bcs.s	loc_A05C
		move.w	$30(a0),d0
		asr.w	#3,d0
		move.w	d0,obj.VelX(a0)
		clr.w	$E(a0)

loc_A05C:
		bra.s	loc_A0A0
; ---------------------------------------------------------------------------

loc_A05E:
		tst.w	obj.VelX(a0)
		beq.w	loc_A090
		bmi.s	loc_A078
		moveq	#0,d3
		move.b	obj.ActWid(a0),d3
		bsr.w	ObjectHitWallRight
		tst.w	d1
		bmi.s	loc_A08A
		bra.s	loc_A0A0
; ---------------------------------------------------------------------------

loc_A078:
		moveq	#0,d3
		move.b	obj.ActWid(a0),d3
		not.w	d3
		bsr.w	ObjectHitWallLeft
		tst.w	d1
		bmi.s	loc_A08A
		bra.s	loc_A0A0
; ---------------------------------------------------------------------------

loc_A08A:
		clr.w	obj.VelX(a0)
		bra.s	loc_A0A0
; ---------------------------------------------------------------------------

loc_A090:
		addi.l	#$2001,obj.Ypos(a0)
		cmpi.b	#$A0,$F(a0)
		bcc.s	loc_A0CC

loc_A0A0:
		moveq	#0,d1
		move.b	obj.ActWid(a0),d1
		addi.w	#$B,d1
		move.w	#$10,d2
		move.w	#$11,d3
		move.w	(sp)+,d4
		bsr.w	sub_A14E
		cmpi.b	#4,obj.Routine(a0)
		beq.s	loc_A0C6
		move.b	#4,obj.Routine(a0)

loc_A0C6:
		bsr.s	sub_A0E2
		bra.w	loc_9FD4
; ---------------------------------------------------------------------------

loc_A0CC:
		move.w	(sp)+,d4
		lea	(v_objspace).w,a1
		bclr	#3,obj.Status(a1)
		bclr	#3,obj.Status(a0)
		bra.w	loc_9FF6
; ---------------------------------------------------------------------------

sub_A0E2:
		cmpi.w	#id_MZ*$100+1,(v_zone).w
		bne.s	loc_A108
		move.w	#$FFE0,d2
		cmpi.w	#$DD0,obj.Xpos(a0)
		beq.s	loc_A126
		cmpi.w	#$CC0,obj.Xpos(a0)
		beq.s	loc_A126
		cmpi.w	#$BA0,obj.Xpos(a0)
		beq.s	loc_A126
		rts
; ---------------------------------------------------------------------------

loc_A108:
		cmpi.w	#id_MZ*$100+2,(v_zone).w
		bne.s	locret_A124
		move.w	#$20,d2
		cmpi.w	#$560,obj.Xpos(a0)
		beq.s	loc_A126
		cmpi.w	#$5C0,obj.Xpos(a0)
		beq.s	loc_A126

locret_A124:
		rts
; ---------------------------------------------------------------------------

loc_A126:
		bsr.w	FindFreeObj
		bne.s	locret_A14C
		_move.b	#id_GeyserMaker,obj.Id(a1)
		move.w	obj.Xpos(a0),obj.Xpos(a1)
		add.w	d2,obj.Xpos(a1)
		move.w	obj.Ypos(a0),obj.Ypos(a1)
		addi.w	#$10,obj.Ypos(a1)
		move.l	a0,$3C(a1)

locret_A14C:
		rts
; ---------------------------------------------------------------------------

sub_A14E:
		move.b	obj.2ndRout(a0),d0
		beq.w	loc_A1DE
		subq.b	#2,d0
		bne.s	loc_A172
		bsr.w	PtfmCheckExit
		btst	#3,obj.Status(a1)
		bne.s	loc_A16C
		clr.b	obj.2ndRout(a0)
		rts
; ---------------------------------------------------------------------------

loc_A16C:
		move.w	d4,d2
		bra.w	PtfmSurfaceHeight
; ---------------------------------------------------------------------------

loc_A172:
		subq.b	#2,d0
		bne.s	loc_A1B8
		bsr.w	SpeedToPos
		addi.w	#$18,obj.VelY(a0)
		bsr.w	ObjectHitFloor
		tst.w	d1
		bpl.w	locret_A1B6
		add.w	d1,obj.Ypos(a0)
		clr.w	obj.VelY(a0)
		clr.b	obj.2ndRout(a0)
		move.w	(a1),d0
		andi.w	#$3FF,d0
		cmpi.w	#$2D2,d0
		bcs.s	locret_A1B6
		move.w	$30(a0),d0
		asr.w	#3,d0
		move.w	d0,obj.VelX(a0)
		move.b	#4,obj.Routine(a0)
		clr.w	$E(a0)

locret_A1B6:
		rts
; ---------------------------------------------------------------------------

loc_A1B8:
		bsr.w	SpeedToPos
		move.w	obj.Xpos(a0),d0
		andi.w	#$C,d0
		bne.w	locret_A29A
		andi.w	#$FFF0,obj.Xpos(a0)
		move.w	obj.VelX(a0),$30(a0)
		clr.w	obj.VelX(a0)
		subq.b	#2,obj.2ndRout(a0)
		rts
; ---------------------------------------------------------------------------

loc_A1DE:
		bsr.w	loc_A37C
		tst.w	d4
		beq.w	locret_A29A
		bmi.w	locret_A29A
		tst.w	d0
		beq.w	locret_A29A
		bmi.s	loc_A222
		btst	#0,obj.Status(a1)
		bne.w	locret_A29A
		move.w	d0,-(sp)
		moveq	#0,d3
		move.b	obj.ActWid(a0),d3
		bsr.w	ObjectHitWallRight
		move.w	(sp)+,d0
		tst.w	d1
		bmi.w	locret_A29A
		addi.l	#$10000,obj.Xpos(a0)
		moveq	#1,d0
		move.w	#$40,d1
		bra.s	loc_A24C
; ---------------------------------------------------------------------------

loc_A222:
		btst	#0,obj.Status(a1)
		beq.s	locret_A29A
		move.w	d0,-(sp)
		moveq	#0,d3
		move.b	obj.ActWid(a0),d3
		not.w	d3
		bsr.w	ObjectHitWallLeft
		move.w	(sp)+,d0
		tst.w	d1
		bmi.s	locret_A29A
		subi.l	#$10000,obj.Xpos(a0)
		moveq	#-1,d0
		move.w	#$FFC0,d1

loc_A24C:
		lea	(v_objspace).w,a1
		add.w	d0,obj.Xpos(a1)
		move.w	d1,obj.Inertia(a1)
		move.w	#0,obj.VelX(a1)
		move.w	d0,-(sp)
		move.w	#sfx_Push,d0
		jsr	(PlaySound_Special).l
		move.w	(sp)+,d0
		tst.b	obj.Subtype(a0)
		bmi.s	locret_A29A
		move.w	d0,-(sp)
		bsr.w	ObjectHitFloor
		move.w	(sp)+,d0
		cmpi.w	#4,d1
		ble.s	loc_A296
		move.w	#$400,obj.VelX(a0)
		tst.w	d0
		bpl.s	loc_A28E
		neg.w	obj.VelX(a0)

loc_A28E:
		move.b	#6,obj.2ndRout(a0)
		bra.s	locret_A29A
; ---------------------------------------------------------------------------

loc_A296:
		add.w	d1,obj.Ypos(a0)

locret_A29A:
		rts
