; ---------------------------------------------------------------------------

Obj02:
		moveq	#0,d0
		move.b	act(a0),d0
		move.w	Obj02_Index(pc,d0.w),d1
		jmp	Obj02_Index(pc,d1.w)
; ---------------------------------------------------------------------------

Obj02_Index:	dc.w	Obj02_Main-Obj02_Index, Obj02_Display-Obj02_Index
		dc.w	Obj02_Delete-Obj02_Index, Obj02_Delete-Obj02_Index
; ---------------------------------------------------------------------------

Obj02_Main:
		addq.b	#2,act(a0)
		move.w	#$200,xpos(a0)			; Fixed positions
		move.w	#$60,ypos(a0)
		move.l	#Map02,map(a0)
		move.w	#$64F0,tile(a0)
		move.b	#4,render(a0)
		move.b	#1,colprop(a0)
		move.b	#3,prio(a0)

Obj02_Display:
		bsr.w	DisplaySprite
		subq.b	#1,anidelay(a0)			; Decrement delay timer
		bpl.s	.wait				; Branch if it's not 0
		move.b	#$10,anidelay(a0)		; Set delay
		move.b	frame(a0),d0			; Set frame to d0
		addq.b	#1,d0				; Increment d0
		cmpi.b	#2,d0
		bcs.s	.dontrevert
		moveq	#0,d0

.dontrevert:
		move.b	d0,frame(a0)			; Make the frame what d0 is

.wait:
		rts
; ---------------------------------------------------------------------------

Obj02_Delete:
		bsr.w	DeleteObject
		rts
