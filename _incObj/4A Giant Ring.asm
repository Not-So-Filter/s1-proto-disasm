; ---------------------------------------------------------------------------

ObjEntryRingBeta:
		moveq	#0,d0
		move.b	$24(a0),d0
		move.w	ObjEntryRingBeta_Index(pc,d0.w),d1
		jmp	ObjEntryRingBeta_Index(pc,d1.w)
; ---------------------------------------------------------------------------

ObjEntryRingBeta_Index:dc.w ObjEntryRingBeta_Init-ObjEntryRingBeta_Index, ObjEntryRingBeta_RmvSonic-ObjEntryRingBeta_Index
		dc.w ObjEntryRingBeta_LoadSonic-ObjEntryRingBeta_Index
; ---------------------------------------------------------------------------

ObjEntryRingBeta_Init:
		tst.l	(plcList).w
		beq.s	ObjEntryRingBeta_Init2
		rts
; ---------------------------------------------------------------------------

ObjEntryRingBeta_Init2:
		addq.b	#2,$24(a0)
		move.l	#MapEntryRingBeta,4(a0)
		move.b	#4,1(a0)
		move.b	#1,$19(a0)
		move.b	#$38,$18(a0)
		move.w	#$541,2(a0)
		move.w	#$78,$30(a0)

ObjEntryRingBeta_RmvSonic:
		move.w	(v_objspace+8).w,8(a0)
		move.w	(v_objspace+$C).w,$C(a0)
		move.b	(v_objspace+$22).w,$22(a0)
		lea	(AniEntryRingBeta).l,a1
		jsr	(ObjectAnimate).l
		cmpi.b	#2,$1A(a0)
		bne.s	ObjEntryRingBeta_Display
		tst.b	(v_objspace).w
		beq.s	ObjEntryRingBeta_Display
		move.b	#0,(v_objspace).w
		move.w	#sfx_SSGoal,d0
		jsr	(PlaySFX).l

ObjEntryRingBeta_Display:
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

ObjEntryRingBeta_LoadSonic:
		subq.w	#1,$30(a0)
		bne.s	ObjEntryRingBeta_Wait
		move.b	#1,(v_objspace).w
		bra.w	DeleteObject
; ---------------------------------------------------------------------------

ObjEntryRingBeta_Wait:
		rts
