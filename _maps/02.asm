Map02:		dc.w byte_4BFA-Map02, byte_4C00-Map02, byte_4C06-Map02, byte_4C30-Map02

byte_4BFA:	dc.b 1
		dc.b $F0, $F, $80, 0, $F0
byte_4C00:	dc.b 1
		dc.b $F0, $F, $80, $10, $F0
byte_4C06:	dc.b 8
		dc.b $80, $F, $80, $10, $F0
		dc.b $60, $F, $80, $10, $F0
		dc.b $40, $F, $80, $10, $F0
		dc.b $20, $F, $80, $10, $F0
		dc.b 0, $F, $80, $10, $F0
		dc.b $E0, $F, $80, $10, $F0
		dc.b $C0, $F, $80, $10, $F0
		dc.b $A0, $F, $80, $10, $F0
		even
byte_4C30:	dc.b 8
		dc.b $80, $F, $80, 0, $F0
		dc.b $60, $F, $80, 0, $F0
		dc.b $40, $F, $80, 0, $F0
		dc.b $20, $F, $80, 0, $F0
		dc.b 0, $F, $80, 0, $F0
		dc.b $E0, $F, $80, 0, $F0
		dc.b $C0, $F, $80, 0, $F0
		dc.b $A0, $F, $80, 0, $F0
		even
