; ---------------------------------------------------------------------------
; Subroutine that controls the line that certain HBlank effects take place on
; via UP and DOWN on the control pad. Called in the main game loop
; ---------------------------------------------------------------------------
LZWaterFeatures:
		btst	#0,(v_jpadhold1).w		; Are we holding up?
		beq.s	.checkbtndown			; If not, check if we're holding down
		addq.w	#1,(v_bg3screenposy).w
		tst.b	(v_hbla_line).w
		beq.s	.checkbtndown
		subq.b	#1,(v_hbla_line).w

.checkbtndown:
		btst	#1,(v_jpadhold1).w		; Are we holding down?
		beq.s	.donothing			; If not, return
		subq.w	#1,(v_bg3screenposy).w
		cmpi.b	#$DF,(v_hbla_line).w
		beq.s	.donothing
		addq.b	#1,(v_hbla_line).w

.donothing:	rts
