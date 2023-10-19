; ---------------------------------------------------------------------------
; Sprite mappings - moving blocks (SZ/SLZ)
; ---------------------------------------------------------------------------
Map_FBlock_internal:
		dc.w .sz1x1-Map_FBlock_internal
		dc.w .sz2x2-Map_FBlock_internal
		dc.w .sz1x2-Map_FBlock_internal
		dc.w .szrect2x2-Map_FBlock_internal
		dc.w .szrect1x3-Map_FBlock_internal
		dc.w .slz-Map_FBlock_internal
.sz1x1:		dc.b 1
		dc.b $F0, $F, 0, $61, $F0 ; SZ - 1x1 square block
.sz2x2:		dc.b 4
		dc.b $E0, $F, 0, $61, $E0 ; SZ - 2x2 square blocks
		dc.b $E0, $F, 0, $61, 0
		dc.b 0,	$F, 0, $61, $E0
		dc.b 0,	$F, 0, $61, 0
.sz1x2:		dc.b 2
		dc.b $E0, $F, 0, $61, $F0 ; SZ - 1x2 square blocks
		dc.b 0,	$F, 0, $61, $F0
.szrect2x2:	dc.b 4
		dc.b $E6, $F, 0, $81, $E0 ; SZ - 2x2 rectangular blocks
		dc.b $E6, $F, 0, $81, 0
		dc.b 0,	$F, 0, $81, $E0
		dc.b 0,	$F, 0, $81, 0
.szrect1x3:	dc.b 3
		dc.b $D9, $F, 0, $81, $F0 ; SZ - 1x3 rectangular blocks
		dc.b $F3, $F, 0, $81, $F0
		dc.b $D, $F, 0,	$81, $F0
.slz:		dc.b 1
		dc.b $F0, $F, 0, $21, $F0 ; SLZ - 1x1 square block
		even