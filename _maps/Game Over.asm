; ---------------------------------------------------------------------------
; Sprite mappings - "GAME OVER"	and "TIME OVER"
; ---------------------------------------------------------------------------
Map_Over_internal:
		dc.w byte_CBAC-Map_Over_internal
		dc.w byte_CBB7-Map_Over_internal
byte_CBAC:	dc.b 2			; GAME
		dc.b $F8, $D, 0, 0, $B8
		dc.b $F8, $D, 0, 8, $D8
byte_CBB7:	dc.b 2			; OVER
		dc.b $F8, $D, 0, $14, 8
		dc.b $F8, $D, 0, $C, $28
		even