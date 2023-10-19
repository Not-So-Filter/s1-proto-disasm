; ---------------------------------------------------------------------------

Obj1B:
		moveq	#0,d0
		move.b	objRoutine(a0),d0
		move.w	off_6634(pc,d0.w),d1
		jmp	off_6634(pc,d1.w)
; ---------------------------------------------------------------------------

off_6634:	dc.w loc_663E-off_6634, loc_6676-off_6634, loc_668A-off_6634, loc_66CE-off_6634, loc_66D6-off_6634
; ---------------------------------------------------------------------------

loc_663E:
		addq.b	#2,objRoutine(a0)
		move.l	#Map_1B,objMap(a0)
		move.w	#$4000,objGfx(a0)
		move.b	#4,objRender(a0)
		move.b	#$20,objActWid(a0)
		move.b	#5,objPriority(a0)
		tst.b	objSubtype(a0)
		bne.s	loc_6676
		move.b	#1,objPriority(a0)
		move.b	#6,objRoutine(a0)
		rts
; ---------------------------------------------------------------------------

loc_6676:
		move.w	#$20,d1
		move.w	#-$14,d3
		bsr.w	PtfmNormalHeight
		bsr.w	DisplaySprite
		bra.w	loc_66A8
; ---------------------------------------------------------------------------

loc_668A:
		move.w	#$20,d1
		bsr.w	PtfmCheckExit
		move.w	objX(a0),d2
		move.w	#-$14,d3
		bsr.w	PtfmSurfaceHeight
		bsr.w	DisplaySprite
		bra.w	loc_66A8
; ---------------------------------------------------------------------------
		rts
; ---------------------------------------------------------------------------

loc_66A8:
		out_of_range.w	loc_66C8
		rts
; ---------------------------------------------------------------------------

loc_66C8:
		bsr.w	DeleteObject
		rts
; ---------------------------------------------------------------------------

loc_66CE:
		bsr.w	DisplaySprite
		bra.w	loc_66A8
; ---------------------------------------------------------------------------

loc_66D6:
		bsr.w	DeleteObject
		rts