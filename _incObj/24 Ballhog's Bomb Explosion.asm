; ---------------------------------------------------------------------------

ObjCannonballExplode:
		moveq	#0,d0
		move.b	$24(a0),d0
		move.w	off_7102(pc,d0.w),d1
		jmp	off_7102(pc,d1.w)
; ---------------------------------------------------------------------------

off_7102:	dc.w ObjCannonballExplode_Init-off_7102, ObjCannonballExplode_Act-off_7102
; ---------------------------------------------------------------------------

ObjCannonballExplode_Init:
		addq.b	#2,act(a0)
		move.l	#MapCannonballExplode,map(a0)
		move.w	#$41C,tile(a0)
		move.b	#4,render(a0)
		move.b	#2,prio(a0)
		move.b	#0,col(a0)
		move.b	#$C,xdisp(a0)
		move.b	#9,anidelay(a0)
		move.b	#0,frame(a0)
		move.w	#$A5,d0
		jsr	(PlaySFX).l

ObjCannonballExplode_Act:
		subq.b	#1,anidelay(a0)
		bpl.s	@disp
		move.b	#9,anidelay(a0)
		addq.b	#1,frame(a0)
		cmpi.b	#4,frame(a0)
		beq.w	DeleteObject

@disp:
		bra.w	DisplaySprite
