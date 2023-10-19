; ---------------------------------------------------------------------------

Obj03:
		moveq	#0,d0
		move.b	objRoutine(a0),d0
		move.w	Obj03_Index(pc,d0.w),d1
		jmp	Obj03_Index(pc,d1.w)
; ---------------------------------------------------------------------------

Obj03_Index:	dc.w Obj03_Main-Obj03_Index
		dc.w Obj03_Display-Obj03_Index
		dc.w Obj03_Delete-Obj03_Index
		dc.w Obj03_Delete-Obj03_Index
; ---------------------------------------------------------------------------

Obj03_Main:
		addq.b	#2,objRoutine(a0)
		move.w	#$100,objX(a0)
		move.w	#$40,objY(a0)
		move.l	#Map_02,objMap(a0)
		move.w	#$64F0,objGfx(a0)
		move.b	#4,objRender(a0)
		move.b	#1,objColProp(a0)
		move.b	#3,objFrame(a0)
		move.b	#5,objPriority(a0)

Obj03_Display:
		bsr.w	DisplaySprite
		subq.b	#1,objTimeFrame(a0)
		bpl.s	.dontset
		move.b	#$10,objTimeFrame(a0)

.dontset:
		rts
; ---------------------------------------------------------------------------

Obj03_Delete:
		bsr.w	DeleteObject
		rts
