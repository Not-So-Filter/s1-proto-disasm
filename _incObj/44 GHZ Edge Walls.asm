; ---------------------------------------------------------------------------

ObjWall:
		moveq	#0,d0
		move.b	objRoutine(a0),d0
		move.w	off_C10A(pc,d0.w),d1
		jmp	off_C10A(pc,d1.w)
; ---------------------------------------------------------------------------

off_C10A:	dc.w loc_C110-off_C10A, loc_C148-off_C10A, loc_C154-off_C10A
; ---------------------------------------------------------------------------

loc_C110:
		addq.b	#2,objRoutine(a0)
		move.l	#Map_Edge,objMap(a0)
		move.w	#$434C,objGfx(a0)
		ori.b	#4,objRender(a0)
		move.b	#8,objActWid(a0)
		move.b	#6,objPriority(a0)
		move.b	objSubtype(a0),objFrame(a0)
		bclr	#4,objFrame(a0)
		beq.s	loc_C148
		addq.b	#2,objRoutine(a0)
		bra.s	loc_C154
; ---------------------------------------------------------------------------

loc_C148:
		move.w	#$13,d1
		move.w	#$28,d2
		bsr.w	sub_6936

loc_C154:
		bsr.w	DisplaySprite
		move.w	objX(a0),d0
		andi.w	#$FF80,d0
		move.w	(v_screenposx).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0
		cmpi.w	#640,d0
		bhi.w	DeleteObject
		rts