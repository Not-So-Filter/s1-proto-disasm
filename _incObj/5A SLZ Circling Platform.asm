; ---------------------------------------------------------------------------

ObjCirclePtfm:
		moveq	#0,d0
		move.b	obj.Routine(a0),d0
		move.w	off_E222(pc,d0.w),d1
		jsr	off_E222(pc,d1.w)
		out_of_range.w	DeleteObject,$32(a0)
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

off_E222:	dc.w loc_E228-off_E222, loc_E258-off_E222, loc_E268-off_E222
; ---------------------------------------------------------------------------

loc_E228:
		addq.b	#2,obj.Routine(a0)
		move.l	#Map_Circ,obj.Map(a0)
		move.w	#$4480,obj.Gfx(a0)
		move.b	#4,obj.Render(a0)
		move.b	#4,obj.Priority(a0)
		move.b	#$18,obj.ActWid(a0)
		move.w	obj.Xpos(a0),$32(a0)
		move.w	obj.Ypos(a0),$30(a0)

loc_E258:
		moveq	#0,d1
		move.b	obj.ActWid(a0),d1
		jsr	(PtfmNormal).l
		bra.w	sub_E284
; ---------------------------------------------------------------------------

loc_E268:
		moveq	#0,d1
		move.b	obj.ActWid(a0),d1
		jsr	(PtfmCheckExit).l
		move.w	obj.Xpos(a0),-(sp)
		bsr.w	sub_E284
		move.w	(sp)+,d2
		jmp	(ptfmSurfaceNormal).l
; ---------------------------------------------------------------------------

sub_E284:
		moveq	#0,d0
		move.b	obj.Subtype(a0),d0
		andi.w	#$C,d0
		lsr.w	#1,d0
		move.w	off_E298(pc,d0.w),d1
		jmp	off_E298(pc,d1.w)
; ---------------------------------------------------------------------------

off_E298:	dc.w loc_E29C-off_E298, loc_E2DA-off_E298
; ---------------------------------------------------------------------------

loc_E29C:
		move.b	(v_oscillate+$22).w,d1
		subi.b	#$50,d1
		ext.w	d1
		move.b	(v_oscillate+$26).w,d2
		subi.b	#$50,d2
		ext.w	d2
		btst	#0,obj.Subtype(a0)
		beq.s	loc_E2BC
		neg.w	d1
		neg.w	d2

loc_E2BC:
		btst	#1,obj.Subtype(a0)
		beq.s	loc_E2C8
		neg.w	d1
		exg	d1,d2

loc_E2C8:
		add.w	$32(a0),d1
		move.w	d1,obj.Xpos(a0)
		add.w	$30(a0),d2
		move.w	d2,obj.Ypos(a0)
		rts
; ---------------------------------------------------------------------------

loc_E2DA:
		move.b	(v_oscillate+$22).w,d1
		subi.b	#$50,d1
		ext.w	d1
		move.b	(v_oscillate+$26).w,d2
		subi.b	#$50,d2
		ext.w	d2
		btst	#0,obj.Subtype(a0)
		beq.s	loc_E2FA
		neg.w	d1
		neg.w	d2

loc_E2FA:
		btst	#1,obj.Subtype(a0)
		beq.s	loc_E306
		neg.w	d1
		exg	d1,d2

loc_E306:
		neg.w	d1
		add.w	$32(a0),d1
		move.w	d1,obj.Xpos(a0)
		add.w	$30(a0),d2
		move.w	d2,obj.Ypos(a0)
		rts
