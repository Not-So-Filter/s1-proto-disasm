; ---------------------------------------------------------------------------

ObjCannonballExplode:
		moveq	#0,d0
		move.b	obj.Routine(a0),d0
		move.w	off_7102(pc,d0.w),d1
		jmp	off_7102(pc,d1.w)
; ---------------------------------------------------------------------------

off_7102:	dc.w ObjCannonballExplode_Init-off_7102, ObjCannonballExplode_Act-off_7102
; ---------------------------------------------------------------------------

ObjCannonballExplode_Init:
		addq.b	#2,obj.Routine(a0)
		move.l	#MapCannonballExplode,obj.Map(a0)
		move.w	#$41C,obj.Gfx(a0)
		move.b	#4,obj.Render(a0)
		move.b	#2,obj.Priority(a0)
		move.b	#0,obj.ColType(a0)
		move.b	#$C,obj.ActWid(a0)
		move.b	#9,obj.TimeFrame(a0)
		move.b	#0,obj.Frame(a0)
		move.w	#sfx_A5,d0
		jsr	(PlaySound_Special).l

ObjCannonballExplode_Act:
		subq.b	#1,obj.TimeFrame(a0)
		bpl.s	.display
		move.b	#9,obj.TimeFrame(a0)
		addq.b	#1,obj.Frame(a0)
		cmpi.b	#4,obj.Frame(a0)
		beq.w	DeleteObject

.display:
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

ObjExplode:
		moveq	#0,d0
		move.b	obj.Routine(a0),d0
		move.w	off_7172(pc,d0.w),d1
		jmp	off_7172(pc,d1.w)
; ---------------------------------------------------------------------------

off_7172:	dc.w ObjExplode_Load-off_7172, ObjExplode_Init-off_7172, ObjExplode_Act-off_7172
; ---------------------------------------------------------------------------

ObjExplode_Load:
		addq.b	#2,obj.Routine(a0)
		bsr.w	FindFreeObj
		bne.s	ObjExplode_Init
		_move.b	#id_Animals,obj.Id(a1)
		move.w	obj.Xpos(a0),obj.Xpos(a1)
		move.w	obj.Ypos(a0),obj.Ypos(a1)

ObjExplode_Init:
		addq.b	#2,obj.Routine(a0)
		move.l	#Map_ExplodeItem,obj.Map(a0)
		move.w	#$5A0,obj.Gfx(a0)
		move.b	#4,obj.Render(a0)
		move.b	#2,obj.Priority(a0)
		move.b	#0,obj.ColType(a0)
		move.b	#12,obj.ActWid(a0)
		move.b	#7,obj.TimeFrame(a0)
		move.b	#0,obj.Frame(a0)
		move.w	#sfx_BreakItem,d0
		jsr	(PlaySound_Special).l

ObjExplode_Act:
		subq.b	#1,obj.TimeFrame(a0)
		bpl.s	.display
		move.b	#7,obj.TimeFrame(a0)
		addq.b	#1,obj.Frame(a0)
		cmpi.b	#5,obj.Frame(a0)
		beq.w	DeleteObject

.display:
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

ObjBombExplode:
		moveq	#0,d0
		move.b	obj.Routine(a0),d0
		move.w	off_7200(pc,d0.w),d1
		jmp	off_7200(pc,d1.w)
; ---------------------------------------------------------------------------

off_7200:	dc.w ObjBomb_Init-off_7200, ObjExplode_Act-off_7200
; ---------------------------------------------------------------------------

ObjBomb_Init:
		addq.b	#2,obj.Routine(a0)
		move.l	#Map_ExplodeBomb,obj.Map(a0)
		move.w	#$5A0,obj.Gfx(a0)
		move.b	#4,obj.Render(a0)
		move.b	#2,obj.Priority(a0)
		move.b	#0,obj.ColType(a0)
		move.b	#$C,obj.ActWid(a0)
		move.b	#7,obj.TimeFrame(a0)
		move.b	#0,obj.Frame(a0)
		move.w	#sfx_Bomb,d0
		jmp	(PlaySound_Special).l
