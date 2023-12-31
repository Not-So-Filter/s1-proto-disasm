; ---------------------------------------------------------------------------

Obj03:
		moveq	#0,d0
		move.b	obj.Routine(a0),d0
		move.w	Obj03_Index(pc,d0.w),d1
		jmp	Obj03_Index(pc,d1.w)
; ---------------------------------------------------------------------------

Obj03_Index:	dc.w Obj03_Main-Obj03_Index
		dc.w Obj03_Display-Obj03_Index
		dc.w Obj03_Delete-Obj03_Index
		dc.w Obj03_Delete-Obj03_Index
; ---------------------------------------------------------------------------

Obj03_Main:
		addq.b	#2,obj.Routine(a0)
		move.w	#$100,obj.Xpos(a0)
		move.w	#$40,obj.Ypos(a0)
		move.l	#Map_02,obj.Map(a0)
		move.w	#$64F0,obj.Gfx(a0)
		move.b	#4,obj.Render(a0)
		move.b	#1,obj.ColProp(a0)
		move.b	#3,obj.Frame(a0)
		move.b	#5,obj.Priority(a0)

Obj03_Display:
		bsr.w	DisplaySprite
		subq.b	#1,obj.TimeFrame(a0)
		bpl.s	.dontset
		move.b	#$10,obj.TimeFrame(a0)

.dontset:
		rts
; ---------------------------------------------------------------------------

Obj03_Delete:
		bsr.w	DeleteObject
		rts
