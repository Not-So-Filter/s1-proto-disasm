MapSpikes:	dc.w byte_ACB0-MapSpikes, byte_ACC0-MapSpikes, byte_ACD0-MapSpikes
		dc.w byte_ACD6-MapSpikes, byte_ACE6-MapSpikes, byte_AD05-MapSpikes

byte_ACB0:	dc.b 3
		dc.b $F0, 3, 0, 4, $EC
		dc.b $F0, 3, 0, 4, $FC
		dc.b $F0, 3, 0, 4, $C

byte_ACC0:	dc.b 3
		dc.b $EC, $C, 0, 0, $F0
		dc.b $FC, $C, 0, 0, $F0
		dc.b $C, $C, 0, 0, $F0

byte_ACD0:	dc.b 1
		dc.b $F0, 3, 0, 4, $FC

byte_ACD6:	dc.b 3
		dc.b $F0, 3, 0, 4, $E4
		dc.b $F0, 3, 0, 4, $FC
		dc.b $F0, 3, 0, 4, $14

byte_ACE6:	dc.b 6
		dc.b $F0, 3, 0, 4, $C0
		dc.b $F0, 3, 0, 4, $D8
		dc.b $F0, 3, 0, 4, $F0
		dc.b $F0, 3, 0, 4, 8
		dc.b $F0, 3, 0, 4, $20
		dc.b $F0, 3, 0, 4, $38

byte_AD05:	dc.b 1
		dc.b $FC, $C, 0, 0, $F0
		even
