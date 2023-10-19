; ---------------------------------------------------------------------------
; Sprite mappings - large green	glassy blocks (MZ)
; ---------------------------------------------------------------------------
Map_Glass_internal:
		dc.w byte_9638-Map_Glass_internal
		dc.w byte_9657-Map_Glass_internal
		dc.w byte_9676-Map_Glass_internal
		dc.w byte_9681-Map_Glass_internal
byte_9638:	dc.b 6
		dc.b $DC, $C, 0, 0, $E0
		dc.b $DC, $C, 8, 0, 0
		dc.b $E4, $F, 0, 4, $E0
		dc.b $E4, $F, 8, 4, 0
		dc.b 4, $F, 0, 4, $E0
		dc.b 4, $F, 8, 4, 0
byte_9657:	dc.b 6
		dc.b $DC, $F, 0, 4, $E0
		dc.b $DC, $F, 8, 4, 0
		dc.b $FC, $F, 0, 4, $E0
		dc.b $FC, $F, 8, 4, 0
		dc.b $1C, $C, $10, 0, $E0
		dc.b $1C, $C, $18, 0, 0
byte_9676:	dc.b 2
		dc.b 8,	6, 0, $14, $F0	; reflected shine on block
		dc.b 0,	6, 0, $14, 0
byte_9681:	dc.b $A
		dc.b $C8, $C, 0, 0, $E0	; short block
		dc.b $C8, $C, 8, 0, 0
		dc.b $D0, $F, 0, 4, $E0
		dc.b $D0, $F, 8, 4, 0
		dc.b $F0, $F, 0, 4, $E0
		dc.b $F0, $F, 8, 4, 0
		dc.b $10, $F, 0, 4, $E0
		dc.b $10, $F, 8, 4, 0
		dc.b $30, $C, $10, 0, $E0
		dc.b $30, $C, $18, 0, 0
		even