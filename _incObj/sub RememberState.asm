ObjectChkDespawn:
		move.w	8(a0),d0
		andi.w	#$FF80,d0
		move.w	(v_screenposx).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0
		bmi.w	loc_B938
		cmpi.w	#$280,d0
		bhi.w	loc_B938
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

loc_B938:
		lea	(v_regbuffer).w,a2
		moveq	#0,d0
		move.b	$23(a0),d0
		beq.s	loc_B94A
		bclr	#7,2(a2,d0.w)

loc_B94A:
		bra.w	DeleteObject
