; ---------------------------------------------------------------------------

sub_E952:
		move.w	(v_trackpos).w,d0
		lea	(v_tracksonic).w,a1
		lea	(a1,d0.w),a1
		move.w	objX(a0),(a1)+
		move.w	objY(a0),(a1)+
		addq.b	#4,(v_trackbyte).w
		rts