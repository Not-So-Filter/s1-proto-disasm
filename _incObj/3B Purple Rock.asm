; ---------------------------------------------------------------------------

ObjPurpleRock:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	off_AD1A(pc,d0.w),d1
		jmp	off_AD1A(pc,d1.w)
; ---------------------------------------------------------------------------

off_AD1A:	dc.w loc_AD1E-off_AD1A, loc_AD42-off_AD1A
; ---------------------------------------------------------------------------

loc_AD1E:
		addq.b	#2,obRoutine(a0)
		move.l	#MapPRock,obMap(a0)
		move.w	#$63D0,obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#$13,obActWid(a0)
		move.b	#4,obPriority(a0)

loc_AD42:
		move.w	#$1B,d1
		move.w	#$10,d2
		move.w	#$10,d3
		move.w	obX(a0),d4
		bsr.w	SolidObject
		bsr.w	DisplaySprite
		move.w	obX(a0),d0
		andi.w	#$FF80,d0
		move.w	(v_screenposx).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0
		cmpi.w	#640,d0
		bhi.w	DeleteObject
		rts
