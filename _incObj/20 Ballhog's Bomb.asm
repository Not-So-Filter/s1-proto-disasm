; ---------------------------------------------------------------------------

ObjCannonball:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	off_7070(pc,d0.w),d1
		jmp	off_7070(pc,d1.w)
; ---------------------------------------------------------------------------

off_7070:	dc.w ObjCannonball_Init-off_7070, ObjCannonball_Act-off_7070, ObjCannonball_Delete-off_7070
; ---------------------------------------------------------------------------

ObjCannonball_Init:
		addq.b	#2,obRoutine(a0)
		move.l	#MapCannonball,obMap(a0)
		move.w	#$2418,obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#3,obPriority(a0)
		move.b	#$87,obColType(a0)
		move.b	#8,obActWid(a0)
		move.w	#$18,$30(a0)

ObjCannonball_Act:
		btst	#7,obStatus(a0)
		bne.s	loc_70C2
		tst.w	$30(a0)
		bne.s	loc_70D2
		jsr	(ObjectHitFloor).l
		tst.w	d1
		bpl.s	loc_70D6
		add.w	d1,obY(a0)

loc_70C2:
		move.b	#id_MissileDissolve,obId(a0)
		move.b	#0,obRoutine(a0)
		bra.w	ObjCannonballExplode
; ---------------------------------------------------------------------------

loc_70D2:
		subq.w	#1,$30(a0)

loc_70D6:
		bsr.w	ObjectFall
		bsr.w	DisplaySprite
		move.w	(unk_FFF72E).w,d0
		addi.w	#224,d0
		cmp.w	obY(a0),d0
		bcs.s	ObjCannonball_Delete
		rts
; ---------------------------------------------------------------------------

ObjCannonball_Delete:
		bsr.w	DeleteObject
		rts
