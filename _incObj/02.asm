; ---------------------------------------------------------------------------

Obj02:
		moveq	#0,d0
		move.b	objRoutine(a0),d0
		move.w	Obj02_Index(pc,d0.w),d1
		jmp	Obj02_Index(pc,d1.w)
; ---------------------------------------------------------------------------

Obj02_Index:	dc.w Obj02_Main-Obj02_Index, Obj02_Display-Obj02_Index
		dc.w Obj02_Delete-Obj02_Index, Obj02_Delete-Obj02_Index
; ---------------------------------------------------------------------------

Obj02_Main:
		addq.b	#2,objRoutine(a0)
		move.w	#$200,objX(a0)		; Fixed positions
		move.w	#$60,objY(a0)
		move.l	#Map_02,objMap(a0)
		move.w	#$64F0,objGfx(a0)
		move.b	#4,objRender(a0)
		move.b	#1,objColProp(a0)
		move.b	#3,objPriority(a0)

Obj02_Display:
		bsr.w	DisplaySprite
		subq.b	#1,objTimeFrame(a0)	; Decrement delay timer
		bpl.s	.wait			; Branch if it's not 0
		move.b	#$10,objTimeFrame(a0)	; Set delay
		move.b	objFrame(a0),d0		; Set frame to d0
		addq.b	#1,d0			; Increment d0
		cmpi.b	#2,d0
		bcs.s	.dontrevert
		moveq	#0,d0

.dontrevert:
		move.b	d0,objFrame(a0)		; Make the frame what d0 is

.wait:
		rts
; ---------------------------------------------------------------------------

Obj02_Delete:
		bsr.w	DeleteObject
		rts
