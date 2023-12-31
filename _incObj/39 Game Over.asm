; ---------------------------------------------------------------------------

ObjGameOver:
		moveq	#0,d0
		move.b	obj.Routine(a0),d0
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
		addq.b	#2,obj.Routine(a0)
		move.w	#$50,obj.Xpos(a0)
		tst.b	obj.Frame(a0)
		beq.s	loc_A676
		move.w	#$1F0,obj.Xpos(a0)

loc_A676:
		move.w	#$F0,obj.ScreenY(a0)
		move.l	#Map_Over,obj.Map(a0)
		move.w	#$8580,obj.Gfx(a0)
		move.b	#0,obj.Render(a0)
		move.b	#0,obj.Priority(a0)

loc_A696:
		moveq	#$10,d1
		cmpi.w	#$120,obj.Xpos(a0)
		beq.s	loc_A6AC
		bcs.s	loc_A6A4
		neg.w	d1

loc_A6A4:
		add.w	d1,obj.Xpos(a0)
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

loc_A6AC:
		move.w	#$258,obj.TimeFrame(a0)
		addq.b	#2,obj.Routine(a0)
		rts
; ---------------------------------------------------------------------------

loc_A6B8:
		move.b	(v_jpadpress2).w,d0
		andi.b	#btnABC,d0
		bne.s	loc_A6D6
		tst.b	obj.Frame(a0)
		bne.s	loc_A6DC
		tst.w	obj.TimeFrame(a0)
		beq.s	loc_A6D6
		subq.w	#1,obj.TimeFrame(a0)
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

loc_A6D6:
		move.b	#id_Sega,(v_gamemode).w

loc_A6DC:
		bra.w	DisplaySprite
