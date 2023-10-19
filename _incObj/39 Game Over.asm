; ---------------------------------------------------------------------------

ObjGameOver:
		moveq	#0,d0
		move.b	objRoutine(a0),d0
		move.w	off_A652(pc,d0.w),d1
		jmp	off_A652(pc,d1.w)
; ---------------------------------------------------------------------------

off_A652:	dc.w loc_A658-off_A652, loc_A696-off_A652, loc_A6B8-off_A652
; ---------------------------------------------------------------------------

loc_A658:
		tst.l	(v_plc_buffer).w
		beq.s	loc_A660
		rts
; ---------------------------------------------------------------------------

loc_A660:
		addq.b	#2,objRoutine(a0)
		move.w	#$50,objX(a0)
		tst.b	objFrame(a0)
		beq.s	loc_A676
		move.w	#$1F0,objX(a0)

loc_A676:
		move.w	#$F0,objScreenY(a0)
		move.l	#Map_Over,objMap(a0)
		move.w	#$8580,objGfx(a0)
		move.b	#0,objRender(a0)
		move.b	#0,objPriority(a0)

loc_A696:
		moveq	#$10,d1
		cmpi.w	#$120,objX(a0)
		beq.s	loc_A6AC
		bcs.s	loc_A6A4
		neg.w	d1

loc_A6A4:
		add.w	d1,objX(a0)
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

loc_A6AC:
		move.w	#$258,objTimeFrame(a0)
		addq.b	#2,objRoutine(a0)
		rts
; ---------------------------------------------------------------------------

loc_A6B8:
		move.b	(v_jpadpress2).w,d0
		andi.b	#btnABC,d0
		bne.s	loc_A6D6
		tst.b	objFrame(a0)
		bne.s	loc_A6DC
		tst.w	objTimeFrame(a0)
		beq.s	loc_A6D6
		subq.w	#1,objTimeFrame(a0)
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

loc_A6D6:
		move.b	#id_Sega,(v_gamemode).w

loc_A6DC:
		bra.w	DisplaySprite
