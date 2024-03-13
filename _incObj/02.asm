; ---------------------------------------------------------------------------

Obj02:
		moveq	#0,d0
		move.b	obj.Routine(a0),d0
		move.w	Obj02_Index(pc,d0.w),d1
		jmp	Obj02_Index(pc,d1.w)
; ---------------------------------------------------------------------------

Obj02_Index:	dc.w Obj02_Main-Obj02_Index, Obj02_Display-Obj02_Index
		dc.w Obj02_Delete-Obj02_Index, Obj02_Delete-Obj02_Index
; ---------------------------------------------------------------------------

Obj02_Main:
		addq.b	#2,obj.Routine(a0)
		move.w	#$200,obj.Xpos(a0)	; Fixed positions
		move.w	#$60,obj.Ypos(a0)
		move.l	#Map_02,obj.Map(a0)
		move.w	#$64F0,obj.Gfx(a0)
		move.b	#4,obj.Render(a0)
		move.b	#1,obj.ColProp(a0)
		move.b	#3,obj.Priority(a0)

Obj02_Display:
		bsr.w	DisplaySprite
		subq.b	#1,obj.TimeFrame(a0)	; Decrement delay timer
		bpl.s	.wait			; Branch if it's not 0
		move.b	#$10,obj.TimeFrame(a0)	; Set delay
		move.b	obj.Frame(a0),d0	; Set frame to d0
		addq.b	#1,d0			; Increment d0
		cmpi.b	#2,d0
		bcs.s	.dontrevert
		moveq	#0,d0

.dontrevert:
		move.b	d0,obj.Frame(a0)	; Make the frame what d0 is

.wait:
		rts
; ---------------------------------------------------------------------------

Obj02_Delete:
		bsr.w	DeleteObject
		rts
