; ---------------------------------------------------------------------------

ObjRings:
		moveq	#0,d0
		move.b	obj.Routine(a0),d0
		move.w	off_7BEE(pc,d0.w),d1
		jmp	off_7BEE(pc,d1.w)
; ---------------------------------------------------------------------------

off_7BEE:	dc.w loc_7C18-off_7BEE, loc_7CD0-off_7BEE, loc_7CF8-off_7BEE, loc_7D1E-off_7BEE, loc_7D2C-off_7BEE

byte_7BF8:	dc.b $10, 0
		dc.b $18, 0
		dc.b $20, 0
		dc.b 0, $10
		dc.b 0, $18
		dc.b 0, $20
		dc.b $10, $10
		dc.b $18, $18
		dc.b $20, $20
		dc.b $F0, $10
		dc.b $E8, $18
		dc.b $E0, $20
		dc.b $10, 8
		dc.b $18, $10
		dc.b $F0, 8
		dc.b $E8, $10
; ---------------------------------------------------------------------------

loc_7C18:
		lea	(v_regbuffer).w,a2
		moveq	#0,d0
		move.b	obj.RespawnNo(a0),d0
		lea	2(a2,d0.w),a2
		move.b	(a2),d4
		move.b	obj.Subtype(a0),d1
		move.b	d1,d0
		andi.w	#7,d1
		cmpi.w	#7,d1
		bne.s	loc_7C3A
		moveq	#6,d1

loc_7C3A:
		swap	d1
		move.w	#0,d1
		lsr.b	#4,d0
		add.w	d0,d0
		move.b	byte_7BF8(pc,d0.w),d5
		ext.w	d5
		move.b	byte_7BF8+1(pc,d0.w),d6
		ext.w	d6
		movea.l	a0,a1
		move.w	obj.Xpos(a0),d2
		move.w	obj.Ypos(a0),d3
		lsr.b	#1,d4
		bcs.s	loc_7CBC
		bclr	#7,(a2)
		bra.s	loc_7C74
; ---------------------------------------------------------------------------

loc_7C64:
		swap	d1
		lsr.b	#1,d4
		bcs.s	loc_7CBC
		bclr	#7,(a2)
		bsr.w	FindFreeObj
		bne.s	loc_7CC8

loc_7C74:
		_move.b	#id_Rings,obj.Id(a1)
		addq.b	#2,obj.Routine(a1)
		move.w	d2,obj.Xpos(a1)
		move.w	obj.Xpos(a0),$32(a1)
		move.w	d3,obj.Ypos(a1)
		move.l	#Map_Ring,obj.Map(a1)
		move.w	#$27B2,obj.Gfx(a1)
		move.b	#4,obj.Render(a1)
		move.b	#2,obj.Priority(a1)
		move.b	#$47,obj.ColType(a1)
		move.b	#8,obj.ActWid(a1)
		move.b	obj.RespawnNo(a0),obj.RespawnNo(a1)
		move.b	d1,$34(a1)

loc_7CBC:
		addq.w	#1,d1
		add.w	d5,d2
		add.w	d6,d3
		swap	d1
		dbf	d1,loc_7C64

loc_7CC8:
		btst	#0,(a2)
		bne.w	DeleteObject

loc_7CD0:
		move.b	(v_ani1_frame).w,obj.Frame(a0)
		bsr.w	DisplaySprite
		out_of_range.s	loc_7D2C,$32(a0)
		rts
; ---------------------------------------------------------------------------

loc_7CF8:
		addq.b	#2,obj.Routine(a0)
		move.b	#0,obj.ColType(a0)
		move.b	#1,obj.Priority(a0)
		bsr.w	CollectRing
		lea	(v_regbuffer).w,a2
		moveq	#0,d0
		move.b	obj.RespawnNo(a0),d0
		move.b	$34(a0),d1
		bset	d1,2(a2,d0.w)

loc_7D1E:
		lea	(Ani_Ring).l,a1
		bsr.w	AnimateSprite
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

loc_7D2C:
		bra.w	DeleteObject
; ---------------------------------------------------------------------------

CollectRing:
		addq.w	#1,(v_rings).w
		ori.b	#1,(f_extralife).w
		move.w	#sfx_Ring,d0
		cmpi.w	#50,(v_rings).w
		bcs.s	loc_7D6A
		bset	#0,(v_lifecount).w
		beq.s	loc_7D5E
		cmpi.w	#100,(v_rings).w
		bcs.s	loc_7D6A
		bset	#1,(v_lifecount).w
		bne.s	loc_7D6A

loc_7D5E:
		addq.b	#1,(v_lives).w
		addq.b	#1,(f_lifecount).w
		move.w	#bgm_ExtraLife,d0

loc_7D6A:
		jmp	(PlaySound_Special).l
; ---------------------------------------------------------------------------

ObjRingLoss:
		moveq	#0,d0
		move.b	obj.Routine(a0),d0
		move.w	off_7D7E(pc,d0.w),d1
		jmp	off_7D7E(pc,d1.w)
; ---------------------------------------------------------------------------

off_7D7E:	dc.w loc_7D88-off_7D7E, loc_7E48-off_7D7E
		dc.w loc_7E9A-off_7D7E, loc_7EAE-off_7D7E
		dc.w loc_7EBC-off_7D7E
; ---------------------------------------------------------------------------

loc_7D88:
		movea.l	a0,a1
		moveq	#0,d5
		move.w	(v_rings).w,d5
		moveq	#32,d0
		cmp.w	d0,d5
		bcs.s	loc_7D98
		move.w	d0,d5

loc_7D98:
		subq.w	#1,d5
		move.w	#$288,d4
		bra.s	loc_7DA8
; ---------------------------------------------------------------------------

loc_7DA0:
		bsr.w	FindFreeObj
		bne.w	loc_7E2C

loc_7DA8:
		_move.b	#id_RingLoss,obj.Id(a1)
		addq.b	#2,obj.Routine(a1)
		move.b	#8,obj.Height(a1)
		move.b	#8,obj.Width(a1)
		move.w	obj.Xpos(a0),obj.Xpos(a1)
		move.w	obj.Ypos(a0),obj.Ypos(a1)
		move.l	#Map_Ring,obj.Map(a1)

loc_7DD2:
		move.w	#$27B2,obj.Gfx(a1)
		move.b	#4,obj.Render(a1)
		move.b	#2,obj.Priority(a1)
		move.b	#$47,obj.ColType(a1)
		move.b	#8,obj.ActWid(a1)
		move.b	#-1,(v_ani3_time).w
		tst.w	d4
		bmi.s	loc_7E1C
		move.w	d4,d0
		bsr.w	CalcSine
		move.w	d4,d2
		lsr.w	#8,d2
		asl.w	d2,d0
		asl.w	d2,d1
		move.w	d0,d2
		move.w	d1,d3
		addi.b	#$10,d4
		bcc.s	loc_7E1C
		subi.w	#$80,d4
		bcc.s	loc_7E1C
		move.w	#$288,d4

loc_7E1C:
		move.w	d2,obj.VelX(a1)
		move.w	d3,obj.VelY(a1)
		neg.w	d2
		neg.w	d4
		dbf	d5,loc_7DA0

loc_7E2C:
		move.w	#0,(v_rings).w
		move.b	#$80,(f_extralife).w
		move.b	#0,(v_lifecount).w
		move.w	#sfx_RingLoss,d0
		jsr	(PlaySound_Special).l

loc_7E48:
		move.b	(v_ani3_frame).w,obj.Frame(a0)
		bsr.w	SpeedToPos
		addi.w	#$18,obj.VelY(a0)
		bmi.s	loc_7E82
		move.b	(v_vbla_byte).w,d0
		add.b	d7,d0
		andi.b	#3,d0
		bne.s	loc_7E82
		jsr	(ObjectHitFloor).l
		tst.w	d1
		bpl.s	loc_7E82
		add.w	d1,obj.Ypos(a0)
		move.w	obj.VelY(a0),d0
		asr.w	#2,d0
		sub.w	d0,obj.VelY(a0)
		neg.w	obj.VelY(a0)

loc_7E82:
		tst.b	(v_ani3_time).w
		beq.s	loc_7EBC
		move.w	(v_limitbtm2).w,d0
		addi.w	#224,d0
		cmp.w	obj.Ypos(a0),d0
		bcs.s	loc_7EBC
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

loc_7E9A:
		addq.b	#2,obj.Routine(a0)
		move.b	#0,obj.ColType(a0)
		move.b	#1,obj.Priority(a0)
		bsr.w	CollectRing

loc_7EAE:
		lea	(Ani_Ring).l,a1
		bsr.w	AnimateSprite
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

loc_7EBC:
		bra.w	DeleteObject
