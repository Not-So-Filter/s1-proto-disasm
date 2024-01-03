; ---------------------------------------------------------------------------

ObjLavaMaker:
		moveq	#0,d0
		move.b	obj.Routine(a0),d0
		move.w	off_C1D0(pc,d0.w),d1
		jsr	off_C1D0(pc,d1.w)
		bra.w	loc_C2E6
; ---------------------------------------------------------------------------

off_C1D0:	dc.w loc_C1DA-off_C1D0, loc_C1FA-off_C1D0

byte_C1D4:	dc.b $1E, $3C, $5A, $78, $96, $B4
; ---------------------------------------------------------------------------

loc_C1DA:
		addq.b	#2,obj.Routine(a0)
		move.b	obj.Subtype(a0),d0
		lsr.w	#4,d0
		andi.w	#$F,d0
		move.b	byte_C1D4(pc,d0.w),obj.DelayAni(a0)
		move.b	obj.DelayAni(a0),obj.TimeFrame(a0)
		andi.b	#$F,obj.Subtype(a0)

loc_C1FA:
		subq.b	#1,obj.TimeFrame(a0)
		bne.s	locret_C22A
		move.b	obj.DelayAni(a0),obj.TimeFrame(a0)
		bsr.w	ObjectChkOffscreen
		bne.s	locret_C22A
		bsr.w	FindFreeObj
		bne.s	locret_C22A
		_move.b	#id_LavaBall,obj.Id(a1)
		move.w	obj.Xpos(a0),obj.Xpos(a1)
		move.w	obj.Ypos(a0),obj.Ypos(a1)
		move.b	obj.Subtype(a0),obj.Subtype(a1)

locret_C22A:
		rts
