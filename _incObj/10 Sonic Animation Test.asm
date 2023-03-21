; ---------------------------------------------------------------------------

ObjAniTest:
		moveq	#0,d0
		move.b	act(a0),d0
		move.w	off_111D0(pc,d0.w),d1
		jmp	off_111D0(pc,d1.w)
; ---------------------------------------------------------------------------

off_111D0:	dc.w ObjAniTest_Init-off_111D0, loc_11202-off_111D0, loc_11286-off_111D0, loc_11286-off_111D0
; ---------------------------------------------------------------------------

ObjAniTest_Init:
		addq.b	#2,act(a0)
		move.b	#$12,yrad(a0)
		move.b	#9,xrad(a0)
		move.l	#MapSonic,map(a0)
		move.w	#$780,tile(a0)
		move.b	#4,render(a0)
		move.b	#2,prio(a0)

loc_11202:
		bsr.w	sub_11210
		bsr.w	Sonic_DynTiles
		jmp	(DisplaySprite).l
; ---------------------------------------------------------------------------

sub_11210:
		move.b	(v_jpadhold2).w,d4
		move.w	ypos(a0),d2
		move.w	xpos(a0),d3
		moveq	#1,d1
		btst	#0,d4
		beq.s	loc_11226
		sub.w	d1,d2

loc_11226:
		btst	#1,d4
		beq.s	loc_1122E
		add.w	d1,d2

loc_1122E:
		btst	#2,d4
		beq.s	loc_11236
		sub.w	d1,d3

loc_11236:
		btst	#3,d4
		beq.s	loc_1123E
		add.w	d1,d3

loc_1123E:
		move.w	d2,ypos(a0)
		move.w	d3,xpos(a0)
		btst	#4,(v_jpadpress2).w
		beq.s	loc_11264
		move.b	render(a0),d0
		move.b	d0,d1
		addq.b	#1,d0
		andi.b	#3,d0
		andi.b	#$FC,d1
		or.b	d1,d0
		move.b	d0,1(a0)

loc_11264:
		btst	#5,(v_jpadpress2).w
		beq.s	loc_1127E
		addq.b	#1,ani(a0)
		cmpi.b	#$19,ani(a0)
		bcs.s	loc_1127E
		move.b	#0,ani(a0)

loc_1127E:
		jsr	(Sonic_Animate).l
		rts
; ---------------------------------------------------------------------------

loc_11286:
		jmp	(DeleteObject).l
