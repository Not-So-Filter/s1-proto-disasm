; ---------------------------------------------------------------------------

ObjBasaran:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	ObjBasaran_Index(pc,d0.w),d1
		jmp	ObjBasaran_Index(pc,d1.w)
; ---------------------------------------------------------------------------

ObjBasaran_Index:dc.w ObjBasaran_Init-ObjBasaran_Index, ObjBasaran_Action-ObjBasaran_Index
; ---------------------------------------------------------------------------

ObjBasaran_Init:
		addq.b	#2,obRoutine(a0)
		move.l	#MapBasaran,obMap(a0)
		move.w	#$84B8,obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#$C,obHeight(a0)
		move.b	#2,obPriority(a0)
		move.b	#$B,obColType(a0)
		move.b	#$10,obActWid(a0)

ObjBasaran_Action:
		moveq	#0,d0
		move.b	ob2ndRout(a0),d0
		move.w	ObjBasaran_Index2(pc,d0.w),d1
		jsr	ObjBasaran_Index2(pc,d1.w)
		lea	(AniBasaran).l,a1
		bsr.w	AnimateSprite
		bra.w	RememberState
; ---------------------------------------------------------------------------

ObjBasaran_Index2:dc.w ObjBasaran_ChkDrop-ObjBasaran_Index2, ObjBasaran_DropFly-ObjBasaran_Index2, ObjBasaran_PlaySound-ObjBasaran_Index2
		dc.w ObjBasaran_FlyUp-ObjBasaran_Index2
; ---------------------------------------------------------------------------

ObjBasaran_ChkDrop:
		move.w	#$80,d2
		bsr.w	ObjBasaran_CheckPlayer
		bcc.s	ObjBasaran_NotDropped
		move.w	(v_objspace+obY).w,d0
		move.w	d0,$36(a0)
		sub.w	obY(a0),d0
		bcs.s	ObjBasaran_NotDropped
		cmpi.w	#$80,d0
		bcc.s	ObjBasaran_NotDropped
		tst.w	(v_debuguse).w
		bne.s	ObjBasaran_NotDropped
		move.b	(v_vbla_byte).w,d0
		add.b	d7,d0
		andi.b	#7,d0
		bne.s	ObjBasaran_NotDropped
		move.b	#1,obAnim(a0)
		addq.b	#2,ob2ndRout(a0)

ObjBasaran_NotDropped:
		rts
; ---------------------------------------------------------------------------

ObjBasaran_DropFly:
		bsr.w	SpeedToPos
		addi.w	#$18,obVelY(a0)
		move.w	#$80,d2
		bsr.w	ObjBasaran_CheckPlayer
		move.w	$36(a0),d0
		sub.w	obY(a0),d0
		bcs.s	ObjBasaran_Delete
		cmpi.w	#$10,d0
		bcc.s	locret_D7CE
		move.w	d1,obVelX(a0)
		move.w	#0,obVelY(a0)
		move.b	#2,obAnim(a0)
		addq.b	#2,ob2ndRout(a0)

locret_D7CE:
		rts
; ---------------------------------------------------------------------------

ObjBasaran_Delete:
		tst.b	obRender(a0)
		bpl.w	DeleteObject
		rts
; ---------------------------------------------------------------------------

ObjBasaran_PlaySound:
		move.b	(v_vbla_byte).w,d0
		andi.b	#$F,d0
		bne.s	loc_D7EE
		move.w	#sfx_Basaran,d0
		jsr	(PlaySound_Special).l

loc_D7EE:
		bsr.w	SpeedToPos
		move.w	(v_objspace+obX).w,d0
		sub.w	obX(a0),d0
		bcc.s	loc_D7FE
		neg.w	d0

loc_D7FE:
		cmpi.w	#$80,d0
		bcs.s	locret_D814
		move.b	(v_vbla_byte).w,d0
		add.b	d7,d0
		andi.b	#7,d0
		bne.s	locret_D814
		addq.b	#2,ob2ndRout(a0)

locret_D814:
		rts
; ---------------------------------------------------------------------------

ObjBasaran_FlyUp:
		bsr.w	SpeedToPos
		subi.w	#$18,obVelY(a0)
		bsr.w	ObjectHitCeiling
		tst.w	d1
		bpl.s	locret_D842
		sub.w	d1,obY(a0)
		andi.w	#$FFF8,obX(a0)
		clr.w	obVelX(a0)
		clr.w	obVelY(a0)
		clr.b	obAnim(a0)
		clr.b	ob2ndRout(a0)

locret_D842:
		rts
; ---------------------------------------------------------------------------

ObjBasaran_CheckPlayer:
		move.w	#$100,d1
		bset	#0,obStatus(a0)
		move.w	(v_objspace+obX).w,d0
		sub.w	obX(a0),d0
		bcc.s	loc_D862
		neg.w	d0
		neg.w	d1
		bclr	#0,obStatus(a0)

loc_D862:
		cmp.w	d2,d0
		rts
; ---------------------------------------------------------------------------
		bsr.w	SpeedToPos
		bsr.w	DisplaySprite
		tst.b	obRender(a0)
		bpl.w	DeleteObject
		rts