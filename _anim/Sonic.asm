AniSonic_internal:	
                dc.w byte_F64C-*
                dc.w byte_F654-AniSonic_internal
                dc.w byte_F65C-AniSonic_internal
		dc.w byte_F664-AniSonic_internal
                dc.w byte_F66C-AniSonic_internal
                dc.w byte_F674-AniSonic_internal
		dc.w byte_F68A-AniSonic_internal
                dc.w byte_F68E-AniSonic_internal
                dc.w byte_F692-AniSonic_internal
		dc.w byte_F696-AniSonic_internal
                dc.w byte_F69A-AniSonic_internal
                dc.w byte_F69E-AniSonic_internal
		dc.w byte_F6A2-AniSonic_internal
                dc.w byte_F6A6-AniSonic_internal
                dc.w byte_F6AA-AniSonic_internal
		dc.w byte_F6AE-AniSonic_internal
                dc.w byte_F6B6-AniSonic_internal
                dc.w byte_F6BA-AniSonic_internal
		dc.w byte_F6BE-AniSonic_internal
                dc.w byte_F6C4-AniSonic_internal
                dc.w byte_F6CA-AniSonic_internal
		dc.w byte_F6CE-AniSonic_internal
                dc.w byte_F6D2-AniSonic_internal
                dc.w byte_F6D6-AniSonic_internal
		dc.w byte_F6DA-AniSonic_internal
                dc.w byte_F6DE-AniSonic_internal
                dc.w byte_F6E8-AniSonic_internal

byte_F64C:	dc.b $FF, 8, 9, $A, $B, 6, 7, $FF

byte_F654:	dc.b $FF, $1E, $1F, $20, $21, $FF, $FF, $FF

byte_F65C:	dc.b $FE, $2E, $2F, $30, $31, $32, $FF, $FF

byte_F664:	dc.b $FE, $2E, $2F, $32, $30, $31, $32, $FF

byte_F66C:	dc.b $FD, $45, $46, $47, $48, $FF, $FF, $FF

byte_F674:	dc.b $17, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 2, 2
		dc.b 2, 3, 4, $FE, 2
		even

byte_F68A:	dc.b $1F, $3A, $3B, $FF

byte_F68E:	dc.b $3F, 5, $FF
		even

byte_F692:	dc.b $3F, $39, $FF
		even

byte_F696:	dc.b $3F, $33, $FF
		even

byte_F69A:	dc.b $3F, $34, $FF
		even

byte_F69E:	dc.b $3F, $35, $FF
		even

byte_F6A2:	dc.b $3F, $36, $FF
		even

byte_F6A6:	dc.b 7, $37, $38, $FF

byte_F6AA:	dc.b 7, $3C, $3F, $FF

byte_F6AE:	dc.b 7, $3C, $3D, $53, $3E, $54, $FF
		even

byte_F6B6:	dc.b $2F, $40, $FD
		even

byte_F6BA:	dc.b 4, $41, $42, $FF

byte_F6BE:	dc.b $F, $43, $43, $43, $FE, 1

byte_F6C4:	dc.b $F, $43, $44, $FE, 1
		even

byte_F6CA:	dc.b $3F, $49, $FF
		even

byte_F6CE:	dc.b $3F, $4A, $FF
		even

byte_F6D2:	dc.b 3, $4B, $FF
		even

byte_F6D6:	dc.b 3, $4C, $FF
		even

byte_F6DA:	dc.b 3, $4D, $FF
		even

byte_F6DE:	dc.b 3, $4E, $4F, $50, $51, $52, 0, $FE, 1, 0

byte_F6E8:	dc.b 3, $55, $FF
