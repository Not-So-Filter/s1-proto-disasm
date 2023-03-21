; ---------------------------------------------------------------------------

ObjJaws:
		moveq	#0,d0
		move.b	$24(a0),d0
		move.w	off_8C70(pc,d0.w),d1
		jsr	off_8C70(pc,d1.w)
		bra.w	ObjectChkDespawn
; ---------------------------------------------------------------------------

off_8C70:	dc.w loc_8C74-off_8C70, loc_8CA4-off_8C70
; ---------------------------------------------------------------------------

loc_8C74:
		addq.b	#2,$24(a0)
		move.l	#MapJaws,4(a0)
		move.w	#$47B,2(a0)
		move.b	#4,1(a0)
		move.b	#$A,$20(a0)
		move.b	#4,$19(a0)
		move.b	#$10,$18(a0)
		move.w	#$FFC0,$10(a0)

loc_8CA4:
		lea	(AniJaws).l,a1
		bsr.w	ObjectAnimate
		bra.w	SpeedToPos
