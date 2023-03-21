SS_MapIndex:	dc.l Map_SSWalls
		dc.w $142
		dc.l Map_SSWalls
		dc.w $2142
		dc.l Map_SSWalls
		dc.w $4142
		dc.l Map_SSWalls
		dc.w $6142
		dc.l Map_SSWalls
		dc.w $142
		dc.l Map_SSWalls
		dc.w $142
		dc.l Map_SSWalls
		dc.w $142
		dc.l Map_SSWalls
		dc.w $142
		dc.l Map_SSWalls
		dc.w $2142
		dc.l Map_SSWalls
		dc.w $2142
		dc.l Map_SSWalls
		dc.w $2142
		dc.l Map_SSWalls
		dc.w $2142
		dc.l Map_SSWalls
		dc.w $4142
		dc.l Map_SSWalls
		dc.w $4142
		dc.l Map_SSWalls
		dc.w $4142
		dc.l Map_SSWalls
		dc.w $4142
		dc.l MapRing
		dc.w $27B2
		dc.l MapBumper
		dc.w $23B
		dc.l off_10C78
		dc.w $251
		dc.l off_10C88
		dc.w $251
		dc.l off_10C78
		dc.w $263
		dc.l off_10C88
		dc.w $263
		dc.l ($4<<24)|MapRing
		dc.w $27B2
		dc.l ($5<<24)|MapRing
		dc.w $27B2
		dc.l ($6<<24)|MapRing
		dc.w $27B2
		dc.l ($7<<24)|MapRing
		dc.w $27B2
		dc.l ($1<<24)|MapBumper
		dc.w $23B
		dc.l ($2<<24)|MapBumper
		dc.w $23B

off_10C78:	dc.w byte_10C7C-off_10C78, byte_10C82-off_10C78

byte_10C7C:	dc.b 1
		dc.b $F4, $A, 0, 0, $F4

byte_10C82:	dc.b 1
		dc.b $F4, $A, $20, 0, $F4

off_10C88:	dc.w byte_10C8C-off_10C88, byte_10C92-off_10C88

byte_10C8C:	dc.b 1
		dc.b $F4, $A, 0, 9, $F4

byte_10C92:	dc.b 1
		dc.b $F4, $A, $20, 9, $F4
