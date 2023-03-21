; ---------------------------------------------------------------------------
; Palette pointers
; ---------------------------------------------------------------------------

palp:	macro paladdress,ramaddress,colours
	dc.l paladdress
	dc.w ramaddress, (colours>>1)-1
	endm

PalPointers:

; palette address, RAM address, colours

ptr_Pal_SegaBG:		palp	Pal_SegaBG,v_pal_dry,$40 ; 0 - Sega logo
ptr_Pal_Title:		palp	Pal_Title,v_pal_dry,$40	; 1 - title screen
ptr_Pal_LevelSel:	palp	Pal_LevelSel,v_pal_dry,$40 ; 2 - level select
ptr_Pal_Sonic:		palp	Pal_Sonic,v_pal_dry,$10	; 3 - Sonic
Pal_Levels:
ptr_Pal_GHZ:		palp	Pal_GHZ,v_pal_dry+$20, $30 ; 4 - GHZ
ptr_Pal_LZ:		palp	Pal_LZ,v_pal_dry+$20,$30 ; 5 - LZ
ptr_Pal_MZ:		palp	Pal_MZ,v_pal_dry+$20,$30 ; 6 - MZ
ptr_Pal_SLZ:		palp	Pal_SLZ,v_pal_dry+$20,$30 ; 7 - SLZ
ptr_Pal_SZ:		palp	Pal_SZ,v_pal_dry+$20,$30 ; 8 - SZ
ptr_Pal_CWZ:		palp	Pal_CWZ,v_pal_dry+$20,$30 ; 9 - CWZ

ptr_Pal_Special:	palp	Pal_Special,v_pal_dry,$40 ; $A (10) - special stage
ptr_Pal_Ending:		palp	Pal_Ending,v_pal_dry,$40 ; $B (11) - ending sequence
		        even
		        
palid_SegaBG:		equ (ptr_Pal_SegaBG-PalPointers)/8
palid_Title:		equ (ptr_Pal_Title-PalPointers)/8
palid_LevelSel:		equ (ptr_Pal_LevelSel-PalPointers)/8
palid_Sonic:		equ (ptr_Pal_Sonic-PalPointers)/8
palid_GHZ:		equ (ptr_Pal_GHZ-PalPointers)/8
palid_LZ:		equ (ptr_Pal_LZ-PalPointers)/8
palid_MZ:		equ (ptr_Pal_MZ-PalPointers)/8
palid_SLZ:		equ (ptr_Pal_SLZ-PalPointers)/8
palid_SZ:		equ (ptr_Pal_SZ-PalPointers)/8
palid_CWZ:		equ (ptr_Pal_CWZ-PalPointers)/8
palid_Special:		equ (ptr_Pal_Special-PalPointers)/8
palid_Ending:		equ (ptr_Pal_Ending-PalPointers)/8
