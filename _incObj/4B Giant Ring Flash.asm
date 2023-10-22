; ---------------------------------------------------------------------------

Obj4B:
		moveq	#0,d0
		move.b	objRoutine(a0),d0
		move.w	off_7ECE(pc,d0.w),d1
		jmp	off_7ECE(pc,d1.w)
; ---------------------------------------------------------------------------

off_7ECE:	dc.w loc_7ED6-off_7ECE, loc_7F12-off_7ECE, loc_7F3C-off_7ECE, loc_7F4C-off_7ECE
; ---------------------------------------------------------------------------

loc_7ED6:
		lea	(v_regbuffer).w,a2
		moveq	#0,d0
		move.b	objRespawnNo(a0),d0
		lea	2(a2,d0.w),a2
		bclr	#7,(a2)
		addq.b	#2,objRoutine(a0)
		move.l	#Map_GRing,objMap(a0)
		move.w	#$24EC,objGfx(a0)
		move.b	#4,objRender(a0)
		move.b	#2,objPriority(a0)
		move.b	#$52,objColType(a0)
		move.b	#$C,objActWid(a0)

loc_7F12:
		move.b	(v_ani1_frame).w,objFrame(a0)
		bsr.w	DisplaySprite
		out_of_range.w	DeleteObject
		rts
; ---------------------------------------------------------------------------

loc_7F3C:
		addq.b	#2,objRoutine(a0)
		move.b	#0,objColType(a0)
		move.b	#1,objPriority(a0)

loc_7F4C:
		move.b	#id_VanishSonic,(v_objslot7).w
		moveq	#plcid_Warp,d0
		bsr.w	AddPLC
		bra.w	DeleteObject