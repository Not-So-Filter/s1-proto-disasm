; ---------------------------------------------------------------------------
; Sprite mappings - invisible lava tag (MZ)
; ---------------------------------------------------------------------------
Map_LTag_internal:	
		dc.w byte_CDAE-Map_LTag_internal, byte_CDC3-Map_LTag_internal, byte_CDD8-Map_LTag_internal
byte_CDAE:	dc.b 4
		dc.b $E0, 5, 0, $18, $E0
		dc.b $E0, 5, 0, $18, $10
		dc.b $10, 5, 0, $18, $E0
		dc.b $10, 5, 0, $18, $10
byte_CDC3:	dc.b 4
		dc.b $E0, 5, 0, $18, $C0
		dc.b $E0, 5, 0, $18, $30
		dc.b $10, 5, 0, $18, $C0
		dc.b $10, 5, 0, $18, $30
byte_CDD8:	dc.b 4
		dc.b $E0, 5, 0, $18, $80
		dc.b $E0, 5, 0, $18, $70
		dc.b $10, 5, 0, $18, $80
		dc.b $10, 5, 0, $18, $70
		even
