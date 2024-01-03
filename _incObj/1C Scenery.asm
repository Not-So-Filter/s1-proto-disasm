; ---------------------------------------------------------------------------

ObjScenery:
		moveq	#0,d0
		move.b	obj.Routine(a0),d0
		move.w	off_6718(pc,d0.w),d1
		jmp	off_6718(pc,d1.w)
; ---------------------------------------------------------------------------

off_6718:	dc.w ObjScenery_Init-off_6718, ObjScenery_Normal-off_6718, ObjScenery_Delete-off_6718, ObjScenery_Delete-off_6718
; ---------------------------------------------------------------------------

ObjScenery_Init:
		addq.b	#2,obj.Routine(a0)
		moveq	#0,d0
		move.b	obj.Subtype(a0),d0
		mulu.w	#10,d0
		lea	ObjScenery_Types(pc,d0.w),a1
		move.l	(a1)+,obj.Map(a0)
		move.w	(a1)+,obj.Gfx(a0)
		ori.b	#4,obj.Render(a0)
		move.b	(a1)+,obj.Frame(a0)
		move.b	(a1)+,obj.ActWid(a0)
		move.b	(a1)+,obj.Priority(a0)
		move.b	(a1)+,obj.ColType(a0)

ObjScenery_Normal:
		bsr.w	DisplaySprite
		out_of_range.w	ObjScenery_Delete
		rts
; ---------------------------------------------------------------------------

ObjScenery_Delete:
		bsr.w	DeleteObject
		rts
; ---------------------------------------------------------------------------

ObjScenery_Types:dc.l Map_Scen
		dc.w $398
		dc.b 0, $10, 4, $82
		dc.l Map_Scen
		dc.w $398
		dc.b 1, $14, 4, $83
		dc.l Map_Scen
		dc.w $4000
		dc.b 0, $20, 1, 0
		dc.l MapBridge
		dc.w $438E
		dc.b 1, $10, 1, 0
