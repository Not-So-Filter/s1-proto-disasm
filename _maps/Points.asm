; ---------------------------------------------------------------------------
; Sprite mappings - points that	appear when you	destroy	something
; ---------------------------------------------------------------------------
Map_Poi_internal:
		dc.w byte_94BC-Map_Poi_internal
		dc.w byte_94C2-Map_Poi_internal
		dc.w byte_94C8-Map_Poi_internal
		dc.w byte_94CE-Map_Poi_internal
byte_94BC:	dc.b 1
		dc.b $FC, 4, 0,	0, $F8			; 100 points
byte_94C2:	dc.b 1
		dc.b $FC, 4, 0,	2, $F8			; 200 points
byte_94C8:	dc.b 1
		dc.b $FC, 4, 0,	4, $F8			; 500 points
byte_94CE:	dc.b 1
		dc.b $FC, 8, 0,	6, $F4			; 1000 points
		even
