; ---------------------------------------------------------------------------

Obj03:
		moveq	#0,d0
		move.b	act(a0),d0
		move.w	Obj03_Index(pc,d0.w),d1
		jmp	Obj03_Index(pc,d1.w)
; ---------------------------------------------------------------------------

Obj03_Index:	dc.w Obj03_Main-Obj03_Index
		dc.w Obj03_Display-Obj03_Index
		dc.w Obj03_Delete-Obj03_Index
		dc.w Obj03_Delete-Obj03_Index
; ---------------------------------------------------------------------------

Obj03_Main:
		addq.b	#2,act(a0)
		move.w	#$100,xpos(a0)
		move.w	#$40,ypos(a0)
		move.l	#Map02,map(a0)
		move.w	#$64F0,tile(a0)
		move.b	#4,render(a0)
		move.b	#1,colprop(a0)
		move.b	#3,frame(a0)
		move.b	#5,prio(a0)

Obj03_Display:
		bsr.w	DisplaySprite
		subq.b	#1,anidelay(a0)
		bpl.s	.dontset
		move.b	#$10,anidelay(a0)

.dontset:
		rts
; ---------------------------------------------------------------------------

Obj03_Delete:
		bsr.w	DeleteObject
		rts
