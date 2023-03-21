; ---------------------------------------------------------------------------

ObjCannonball:
		moveq	#0,d0
		move.b	$24(a0),d0
		move.w	off_7070(pc,d0.w),d1
		jmp	off_7070(pc,d1.w)
; ---------------------------------------------------------------------------

off_7070:	dc.w ObjCannonball_Init-off_7070, ObjCannonball_Act-off_7070, ObjCannonball_Delete-off_7070
; ---------------------------------------------------------------------------

ObjCannonball_Init:
		addq.b	#2,act(a0)
		move.l	#MapCannonball,map(a0)
		move.w	#$2418,tile(a0)
		move.b	#4,render(a0)
		move.b	#3,prio(a0)
		move.b	#$87,col(a0)
		move.b	#8,xdisp(a0)
		move.w	#$18,$30(a0)

ObjCannonball_Act:
		btst	#7,status(a0)
		bne.s	loc_70C2
		tst.w	$30(a0)
		bne.s	loc_70D2
		jsr	ObjectHitFloor
		tst.w	d1
		bpl.s	loc_70D6
		add.w	d1,ypos(a0)

loc_70C2:
		move.b	#$24,id(a0)
		move.b	#0,act(a0)
		bra.w	ObjCannonballExplode
; ---------------------------------------------------------------------------

loc_70D2:
		subq.w	#1,$30(a0)

loc_70D6:
		bsr.w	ObjectFall
		bsr.w	DisplaySprite
		move.w	(unk_FFF72E).w,d0
		addi.w	#224,d0
		cmp.w	ypos(a0),d0
		bcs.s	ObjCannonball_Delete
		rts
; ---------------------------------------------------------------------------

ObjCannonball_Delete:
		bsr.w	DeleteObject
		rts
