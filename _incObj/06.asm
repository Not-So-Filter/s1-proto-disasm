; ---------------------------------------------------------------------------

Obj06:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Obj06_Index(pc,d0.w),d1
		jmp	Obj06_Index(pc,d1.w)
; ---------------------------------------------------------------------------
Obj06_Index:	dc.w Obj06_Main-Obj06_Index
		dc.w Obj06_Display-Obj06_Index
		dc.w Obj06_Delete-Obj06_Index
		dc.w Obj06_Delete-Obj06_Index
; ---------------------------------------------------------------------------

Obj06_Main:
		addq.b	#2,obRoutine(a0)
		move.w	#$A0,obScreenY(a0)
		move.l	#Map_05,obMap(a0)
		move.w	#$8470,obGfx(a0)
		move.b	#0,obRender(a0)
		move.b	#7,obPriority(a0)

Obj06_Display:
		bsr.w	DisplaySprite
		rts
; ---------------------------------------------------------------------------

Obj06_Delete:
		bsr.w	DeleteObject
		rts
