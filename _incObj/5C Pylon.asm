; ---------------------------------------------------------------------------

ObjSLZGirder:
		moveq	#0,d0
		move.b	obj.Routine(a0),d0
		move.w	off_E4EA(pc,d0.w),d1
		jmp	off_E4EA(pc,d1.w)
; ---------------------------------------------------------------------------

off_E4EA:	dc.w loc_E4EE-off_E4EA, loc_E506-off_E4EA
; ---------------------------------------------------------------------------

loc_E4EE:
		addq.b	#2,obj.Routine(a0)
		move.l	#Map_Pylon,obj.Map(a0)
		move.w	#$83CC,obj.Gfx(a0)
		move.b	#$10,obj.ActWid(a0)

loc_E506:
		move.l	(v_screenposx).w,d1
		add.l	d1,d1
		swap	d1
		neg.w	d1
		move.w	d1,obj.Xpos(a0)
		move.l	(v_screenposy).w,d1
		add.l	d1,d1
		swap	d1
		andi.w	#$3F,d1
		neg.w	d1
		addi.w	#$100,d1
		move.w	d1,obj.ScreenY(a0)
		bra.w	DisplaySprite
