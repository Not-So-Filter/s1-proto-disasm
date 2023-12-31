; ---------------------------------------------------------------------------

ObjEntryRingBeta:
		moveq	#0,d0
		move.b	obj.Routine(a0),d0
		move.w	ObjEntryRingBeta_Index(pc,d0.w),d1
		jmp	ObjEntryRingBeta_Index(pc,d1.w)
; ---------------------------------------------------------------------------

ObjEntryRingBeta_Index:dc.w ObjEntryRingBeta_Init-ObjEntryRingBeta_Index, ObjEntryRingBeta_RmvSonic-ObjEntryRingBeta_Index
		dc.w ObjEntryRingBeta_LoadSonic-ObjEntryRingBeta_Index
; ---------------------------------------------------------------------------

ObjEntryRingBeta_Init:
		tst.l	(v_plc_buffer).w
		beq.s	ObjEntryRingBeta_Init2
		rts
; ---------------------------------------------------------------------------

ObjEntryRingBeta_Init2:
		addq.b	#2,obj.Routine(a0)
		move.l	#Map_Vanish,obj.Map(a0)
		move.b	#4,obj.Render(a0)
		move.b	#1,obj.Priority(a0)
		move.b	#$38,obj.ActWid(a0)
		move.w	#$541,obj.Gfx(a0)
		move.w	#$78,$30(a0)

ObjEntryRingBeta_RmvSonic:
		move.w	(v_player+obj.Xpos).w,obj.Xpos(a0)
		move.w	(v_player+obj.Ypos).w,obj.Ypos(a0)
		move.b	(v_player+obj.Status).w,obj.Status(a0)
		lea	(Ani_Vanish).l,a1
		jsr	(AnimateSprite).l
		cmpi.b	#2,obj.Frame(a0)
		bne.s	ObjEntryRingBeta_Display
		tst.b	(v_objspace).w
		beq.s	ObjEntryRingBeta_Display
		move.b	#0,(v_player).w
		move.w	#sfx_SSGoal,d0
		jsr	(PlaySound_Special).l

ObjEntryRingBeta_Display:
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

ObjEntryRingBeta_LoadSonic:
		subq.w	#1,$30(a0)
		bne.s	ObjEntryRingBeta_Wait
		move.b	#id_SonicPlayer,(v_player).w
		bra.w	DeleteObject
; ---------------------------------------------------------------------------

ObjEntryRingBeta_Wait:
		rts
