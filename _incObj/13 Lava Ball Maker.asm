; ---------------------------------------------------------------------------

ObjLavaMaker:
		moveq	#0,d0
		move.b	objRoutine(a0),d0
		move.w	off_C1D0(pc,d0.w),d1
		jsr	off_C1D0(pc,d1.w)
		bra.w	loc_C2E6
; ---------------------------------------------------------------------------

off_C1D0:	dc.w loc_C1DA-off_C1D0, loc_C1FA-off_C1D0

byte_C1D4:	dc.b $1E, $3C, $5A, $78, $96, $B4
; ---------------------------------------------------------------------------

loc_C1DA:
		addq.b	#2,objRoutine(a0)
		move.b	objSubtype(a0),d0
		lsr.w	#4,d0
		andi.w	#$F,d0
		move.b	byte_C1D4(pc,d0.w),objDelayAni(a0)
		move.b	objDelayAni(a0),objTimeFrame(a0)
		andi.b	#$F,objSubtype(a0)

loc_C1FA:
		subq.b	#1,objTimeFrame(a0)
		bne.s	locret_C22A
		move.b	objDelayAni(a0),objTimeFrame(a0)
		bsr.w	ObjectChkOffscreen
		bne.s	locret_C22A
		bsr.w	FindFreeObj
		bne.s	locret_C22A
		move.b	#id_LavaBall,objId(a1)
		move.w	objX(a0),objX(a1)
		move.w	objY(a0),objY(a1)
		move.b	objSubtype(a0),objSubtype(a1)

locret_C22A:
		rts