; ---------------------------------------------------------------------------

Obj4B:
		moveq	#0,d0
		move.b	$24(a0),d0
		move.w	off_7ECE(pc,d0.w),d1
		jmp	off_7ECE(pc,d1.w)
; ---------------------------------------------------------------------------

off_7ECE:	dc.w loc_7ED6-off_7ECE, loc_7F12-off_7ECE, loc_7F3C-off_7ECE, loc_7F4C-off_7ECE
; ---------------------------------------------------------------------------

loc_7ED6:
		lea	(v_regbuffer).w,a2
		moveq	#0,d0
		move.b	obRespawnNo(a0),d0
		lea	2(a2,d0.w),a2
		bclr	#7,(a2)
		addq.b	#2,$24(a0)
		move.l	#Map4B,obMap(a0)
		move.w	#$24EC,obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#2,obPriority(a0)
		move.b	#$52,obColType(a0)
		move.b	#$C,obActWid(a0)

loc_7F12:
		move.b	(RingFrame).w,obFrame(a0)
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
; ---------------------------------------------------------------------------

loc_7F3C:
		addq.b	#2,$24(a0)
		move.b	#0,obColType(a0)
		move.b	#1,obPriority(a0)

loc_7F4C:
		move.b	#$4A,(v_objspace+$1C0).w
		moveq	#plcid_Warp,d0
		bsr.w	plcAdd
		bra.w	DeleteObject