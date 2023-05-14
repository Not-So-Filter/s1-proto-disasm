; ---------------------------------------------------------------------------

sub_E952:
		move.w	(unk_FFF7A8).w,d0
		lea	(v_tracksonic).w,a1
		lea	(a1,d0.w),a1
		move.w	8(a0),(a1)+
		move.w	$C(a0),(a1)+
		addq.b	#4,(unk_FFF7A9).w
		rts