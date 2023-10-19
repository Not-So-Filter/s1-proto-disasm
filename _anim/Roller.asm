; ---------------------------------------------------------------------------
; Animation script - Roller enemy
; ---------------------------------------------------------------------------
Ani_Roll:	dc.w A_Roll_Unfold-Ani_Roll
		dc.w A_Roll_Fold-Ani_Roll
		dc.w A_Roll_Roll-Ani_Roll
A_Roll_Unfold:	dc.b $F, 0, afEnd
		even
A_Roll_Fold:	dc.b $F, 1, 2, afChange, 2
		even
A_Roll_Roll:	dc.b 3,	2, 3, 4, afEnd
		even