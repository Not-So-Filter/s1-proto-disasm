; ---------------------------------------------------------------------------

ObjSmashBlock:
		moveq	#0,d0
		move.b	objRoutine(a0),d0
		move.w	off_D4D4(pc,d0.w),d1
		jsr	off_D4D4(pc,d1.w)
		bra.w	RememberState
; ---------------------------------------------------------------------------

off_D4D4:	dc.w loc_D4DA-off_D4D4, loc_D504-off_D4D4, loc_D580-off_D4D4
; ---------------------------------------------------------------------------

loc_D4DA:
		addq.b	#2,objRoutine(a0)
		move.l	#MapSmashBlock,objMap(a0)
		move.w	#$42B8,objGfx(a0)
		move.b	#4,objRender(a0)
		move.b	#$10,objActWid(a0)
		move.b	#4,objPriority(a0)
		move.b	objSubtype(a0),objFrame(a0)

loc_D504:
		move.b	(v_player+objAnim).w,$32(a0)
		move.w	#$1B,d1
		move.w	#$10,d2
		move.w	#$11,d3
		move.w	objX(a0),d4
		bsr.w	SolidObject
		btst	#3,objStatus(a0)
		bne.s	loc_D528

locret_D526:
		rts
; ---------------------------------------------------------------------------

loc_D528:
		cmpi.b	#2,$32(a0)
		bne.s	locret_D526
		bset	#2,objStatus(a1)
		move.b	#$E,objHeight(a1)
		move.b	#7,objWidth(a1)
		move.b	#2,objAnim(a1)
		move.w	#$FD00,objVelY(a1)
		bset	#1,objStatus(a1)
		bclr	#3,objStatus(a1)
		move.b	#2,objRoutine(a1)
		bclr	#3,objStatus(a0)
		clr.b	obj2ndRout(a0)
		move.b	#1,objFrame(a0)
		lea	(ObjSmashBlock_Frag).l,a4
		moveq	#3,d1
		move.w	#$38,d2
		bsr.w	ObjectFragment

loc_D580:
		bsr.w	SpeedToPos
		addi.w	#$38,objVelY(a0)
		bsr.w	DisplaySprite
		tst.b	objRender(a0)
		bpl.w	DeleteObject
		rts