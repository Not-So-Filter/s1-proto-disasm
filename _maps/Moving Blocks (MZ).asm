; ---------------------------------------------------------------------------
; Sprite mappings - moving blocks (MZ, SBZ)
; ---------------------------------------------------------------------------
Map_MBlock_internal:
		dc.w .mz1-Map_MBlock_internal
		dc.w .mz2-Map_MBlock_internal
.mz1:		dc.b 1
		dc.b $F8, $F, 0, 8, $F0
.mz2:		dc.b 2
		dc.b $F8, $F, 0, 8, $E0
		dc.b $F8, $F, 0, 8, 0
		even