; ---------------------------------------------------------------------------

ObjSceneryLamp:
		moveq	#0,d0
		move.b	$24(a0),d0
		move.w	off_C538(pc,d0.w),d1
		jmp	off_C538(pc,d1.w)
; ---------------------------------------------------------------------------

off_C538:	dc.w loc_C53C-off_C538, loc_C560-off_C538
; ---------------------------------------------------------------------------

loc_C53C:
		addq.b	#2,$24(a0)
		move.l	#MapSceneryLamp,4(a0)
		move.w	#0,2(a0)
		move.b	#4,1(a0)
		move.b	#$10,$18(a0)
		move.b	#6,$19(a0)

loc_C560:
		subq.b	#1,$1E(a0)
		bpl.s	loc_C57E
		move.b	#7,$1E(a0)
		addq.b	#1,$1A(a0)
		cmpi.b	#6,$1A(a0)
		bcs.s	loc_C57E
		move.b	#0,$1A(a0)

loc_C57E:
		bsr.w	DisplaySprite
		out_of_range.w	DeleteObject
		rts