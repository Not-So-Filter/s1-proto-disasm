; ---------------------------------------------------------------------------
; Object 59 - platforms	that move when you stand on them (SLZ)
; ---------------------------------------------------------------------------

elev_origX:	equ objOff_32		; original x-axis position
elev_origY:	equ objOff_30		; original y-axis position
elev_dist:	equ objOff_3C		; distance to move (2 bytes)

ObjSLZMovingPtfm:
		moveq	#0,d0
		move.b	objRoutine(a0),d0
		move.w	off_DF9A(pc,d0.w),d1
		jsr	off_DF9A(pc,d1.w)
		out_of_range.w	DeleteObject,elev_origX(a0)
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

off_DF9A:	dc.w loc_DFC2-off_DF9A, loc_E03A-off_DF9A, loc_E04A-off_DF9A, loc_E194-off_DF9A

byte_DFA2:	dc.b $28, 0
		dc.b $10, 1
		dc.b $20, 1
		dc.b $34, 1
		dc.b $10, 3
		dc.b $20, 3
		dc.b $34, 3
		dc.b $14, 1
		dc.b $24, 1
		dc.b $2C, 1
		dc.b $14, 3
		dc.b $24, 3
		dc.b $2C, 3
		dc.b $20, 5
		dc.b $20, 7
		dc.b $30, 9
; ---------------------------------------------------------------------------

loc_DFC2:
		addq.b	#2,objRoutine(a0)
		moveq	#0,d0
		move.b	objSubtype(a0),d0
		bpl.s	loc_DFE6
		addq.b	#4,objRoutine(a0)
		andi.w	#$7F,d0
		mulu.w	#6,d0
		move.w	d0,elev_dist(a0)
		move.w	d0,$3E(a0)
		addq.l	#4,sp
		rts
; ---------------------------------------------------------------------------

loc_DFE6:
		lsr.w	#3,d0
		andi.w	#$1E,d0
		lea	byte_DFA2(pc,d0.w),a2
		move.b	(a2)+,objActWid(a0)
		move.b	(a2)+,objFrame(a0)
		moveq	#0,d0
		move.b	objSubtype(a0),d0
		add.w	d0,d0
		andi.w	#$1E,d0
		lea	byte_DFA2+2(pc,d0.w),a2
		move.b	(a2)+,d0
		lsl.w	#2,d0
		move.w	d0,elev_dist(a0)
		move.b	(a2)+,objSubtype(a0)
		move.l	#Map_Elev,objMap(a0)
		move.w	#$4480,objGfx(a0)
		move.b	#4,objRender(a0)
		move.b	#4,objPriority(a0)
		move.w	objX(a0),elev_origX(a0)
		move.w	objY(a0),elev_origY(a0)

loc_E03A:
		moveq	#0,d1
		move.b	objActWid(a0),d1
		jsr	(PtfmNormal).l
		bra.w	sub_E06E
; ---------------------------------------------------------------------------

loc_E04A:
		moveq	#0,d1
		move.b	objActWid(a0),d1
		jsr	(PtfmCheckExit).l
		move.w	objX(a0),-(sp)
		bsr.w	sub_E06E
		move.w	(sp)+,d2
		tst.b	objId(a0)
		beq.s	locret_E06C
		jmp	(ptfmSurfaceNormal).l
; ---------------------------------------------------------------------------

locret_E06C:
		rts
; ---------------------------------------------------------------------------

sub_E06E:
		moveq	#0,d0
		move.b	objSubtype(a0),d0
		andi.w	#$F,d0
		add.w	d0,d0
		move.w	off_E082(pc,d0.w),d1
		jmp	off_E082(pc,d1.w)
; ---------------------------------------------------------------------------

off_E082:	dc.w locret_E096-off_E082, loc_E098-off_E082, loc_E0A6-off_E082, loc_E098-off_E082
		dc.w loc_E0BA-off_E082, loc_E098-off_E082, loc_E0CC-off_E082, loc_E098-off_E082, loc_E0EE-off_E082
		dc.w loc_E110-off_E082
; ---------------------------------------------------------------------------

locret_E096:
		rts
; ---------------------------------------------------------------------------

loc_E098:
		cmpi.b	#4,objRoutine(a0)
		bne.s	locret_E0A4
		addq.b	#1,objSubtype(a0)

locret_E0A4:
		rts
; ---------------------------------------------------------------------------

loc_E0A6:
		bsr.w	sub_E14A
		move.w	$34(a0),d0
		neg.w	d0
		add.w	elev_origY(a0),d0
		move.w	d0,objY(a0)
		rts
; ---------------------------------------------------------------------------

loc_E0BA:
		bsr.w	sub_E14A
		move.w	$34(a0),d0
		add.w	elev_origY(a0),d0
		move.w	d0,objY(a0)
		rts
; ---------------------------------------------------------------------------

loc_E0CC:
		bsr.w	sub_E14A
		move.w	$34(a0),d0
		asr.w	#1,d0
		neg.w	d0
		add.w	elev_origY(a0),d0
		move.w	d0,objY(a0)
		move.w	$34(a0),d0
		add.w	elev_origX(a0),d0
		move.w	d0,objX(a0)
		rts
; ---------------------------------------------------------------------------

loc_E0EE:
		bsr.w	sub_E14A
		move.w	$34(a0),d0
		asr.w	#1,d0
		add.w	elev_origY(a0),d0
		move.w	d0,objY(a0)
		move.w	$34(a0),d0
		neg.w	d0
		add.w	elev_origX(a0),d0
		move.w	d0,objX(a0)
		rts
; ---------------------------------------------------------------------------

loc_E110:
		bsr.w	sub_E14A
		move.w	$34(a0),d0
		neg.w	d0
		add.w	elev_origY(a0),d0
		move.w	d0,objY(a0)
		tst.b	objSubtype(a0)
		beq.w	loc_E12C
		rts
; ---------------------------------------------------------------------------

loc_E12C:
		btst	#3,objStatus(a0)
		beq.s	loc_E146
		bset	#1,objStatus(a1)
		bclr	#3,objStatus(a1)
		move.b	#2,objRoutine(a1)

loc_E146:
		bra.w	DeleteObject
; ---------------------------------------------------------------------------

sub_E14A:
		move.w	$38(a0),d0
		tst.b	$3A(a0)
		bne.s	loc_E160
		cmpi.w	#$800,d0
		bcc.s	loc_E168
		addi.w	#$10,d0
		bra.s	loc_E168
; ---------------------------------------------------------------------------

loc_E160:
		tst.w	d0
		beq.s	loc_E168
		subi.w	#$10,d0

loc_E168:
		move.w	d0,$38(a0)
		ext.l	d0
		asl.l	#8,d0
		add.l	$34(a0),d0
		move.l	d0,$34(a0)
		swap	d0
		move.w	elev_dist(a0),d2
		cmp.w	d2,d0
		bls.s	loc_E188
		move.b	#1,$3A(a0)

loc_E188:
		add.w	d2,d2
		cmp.w	d2,d0
		bne.s	locret_E192
		clr.b	objSubtype(a0)

locret_E192:
		rts
; ---------------------------------------------------------------------------

loc_E194:
		subq.w	#1,elev_dist(a0)
		bne.s	loc_E1BE
		move.w	$3E(a0),elev_dist(a0)
		bsr.w	FindFreeObj
		bne.s	loc_E1BE
		move.b	#id_Elevator,objId(a1)
		move.w	objX(a0),objX(a1)
		move.w	objY(a0),objY(a1)
		move.b	#$E,objSubtype(a1)

loc_E1BE:
		addq.l	#4,sp
		out_of_range.w	DeleteObject
		rts