; ---------------------------------------------------------------------------

ObjCannonballExplode:
		moveq	#0,d0
		move.b	objRoutine(a0),d0
		move.w	off_7102(pc,d0.w),d1
		jmp	off_7102(pc,d1.w)
; ---------------------------------------------------------------------------

off_7102:	dc.w ObjCannonballExplode_Init-off_7102, ObjCannonballExplode_Act-off_7102
; ---------------------------------------------------------------------------

ObjCannonballExplode_Init:
		addq.b	#2,objRoutine(a0)
		move.l	#MapCannonballExplode,objMap(a0)
		move.w	#$41C,objGfx(a0)
		move.b	#4,objRender(a0)
		move.b	#2,objPriority(a0)
		move.b	#0,objColType(a0)
		move.b	#$C,objActWid(a0)
		move.b	#9,objTimeFrame(a0)
		move.b	#0,objFrame(a0)
		move.w	#sfx_A5,d0
		jsr	(PlaySound_Special).l

ObjCannonballExplode_Act:
		subq.b	#1,objTimeFrame(a0)
		bpl.s	.display
		move.b	#9,objTimeFrame(a0)
		addq.b	#1,objFrame(a0)
		cmpi.b	#4,objFrame(a0)
		beq.w	DeleteObject

.display:
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

ObjExplode:
		moveq	#0,d0
		move.b	objRoutine(a0),d0
		move.w	off_7172(pc,d0.w),d1
		jmp	off_7172(pc,d1.w)
; ---------------------------------------------------------------------------

off_7172:	dc.w ObjExplode_Load-off_7172, ObjExplode_Init-off_7172, ObjExplode_Act-off_7172
; ---------------------------------------------------------------------------

ObjExplode_Load:
		addq.b	#2,objRoutine(a0)
		bsr.w	FindFreeObj
		bne.s	ObjExplode_Init
		move.b	#id_Animals,objId(a1)
		move.w	objX(a0),objX(a1)
		move.w	objY(a0),objY(a1)

ObjExplode_Init:
		addq.b	#2,objRoutine(a0)
		move.l	#Map_ExplodeItem,objMap(a0)
		move.w	#$5A0,objGfx(a0)
		move.b	#4,objRender(a0)
		move.b	#2,objPriority(a0)
		move.b	#0,objColType(a0)
		move.b	#12,objActWid(a0)
		move.b	#7,objTimeFrame(a0)
		move.b	#0,objFrame(a0)
		move.w	#sfx_BreakItem,d0
		jsr	(PlaySound_Special).l

ObjExplode_Act:
		subq.b	#1,objTimeFrame(a0)
		bpl.s	.display
		move.b	#7,objTimeFrame(a0)
		addq.b	#1,objFrame(a0)
		cmpi.b	#5,objFrame(a0)
		beq.w	DeleteObject

.display:
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

ObjBombExplode:
		moveq	#0,d0
		move.b	objRoutine(a0),d0
		move.w	off_7200(pc,d0.w),d1
		jmp	off_7200(pc,d1.w)
; ---------------------------------------------------------------------------

off_7200:	dc.w ObjBomb_Init-off_7200, ObjExplode_Act-off_7200
; ---------------------------------------------------------------------------

ObjBomb_Init:
		addq.b	#2,objRoutine(a0)
		move.l	#Map_ExplodeBomb,objMap(a0)
		move.w	#$5A0,objGfx(a0)
		move.b	#4,objRender(a0)
		move.b	#2,objPriority(a0)
		move.b	#0,objColType(a0)
		move.b	#$C,objActWid(a0)
		move.b	#7,objTimeFrame(a0)
		move.b	#0,objFrame(a0)
		move.w	#sfx_Bomb,d0
		jmp	(PlaySound_Special).l