; ---------------------------------------------------------------------------

ObjMovingPtfm:
		moveq	#0,d0
		move.b	obj.Routine(a0),d0
		move.w	off_D5FC(pc,d0.w),d1
		jsr	off_D5FC(pc,d1.w)
		out_of_range.w	DeleteObject,$32(a0)
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

off_D5FC:	dc.w loc_D606-off_D5FC, loc_D648-off_D5FC, loc_D658-off_D5FC

byte_D602:	dc.b $10, 0
		dc.b $20, 1
; ---------------------------------------------------------------------------

loc_D606:
		addq.b	#2,obj.Routine(a0)
		move.l	#MapMovingPtfm,obj.Map(a0)
		move.w	#$42B8,obj.Gfx(a0)
		move.b	#4,obj.Render(a0)
		moveq	#0,d0
		move.b	obj.Subtype(a0),d0
		lsr.w	#3,d0
		andi.w	#$1E,d0
		lea	byte_D602(pc,d0.w),a2
		move.b	(a2)+,obj.ActWid(a0)
		move.b	(a2)+,obj.Frame(a0)
		move.b	#4,obj.Priority(a0)
		move.w	obj.Xpos(a0),$32(a0)
		move.w	obj.Ypos(a0),$30(a0)

loc_D648:
		moveq	#0,d1
		move.b	obj.ActWid(a0),d1
		jsr	(PtfmNormal).l
		bra.w	sub_D674
; ---------------------------------------------------------------------------

loc_D658:
		moveq	#0,d1
		move.b	obj.ActWid(a0),d1
		jsr	(PtfmCheckExit).l
		move.w	obj.Xpos(a0),-(sp)
		bsr.w	sub_D674
		move.w	(sp)+,d2
		jmp	(ptfmSurfaceNormal).l
; ---------------------------------------------------------------------------

sub_D674:
		moveq	#0,d0
		move.b	obj.Subtype(a0),d0
		andi.w	#$F,d0
		add.w	d0,d0
		move.w	off_D688(pc,d0.w),d1
		jmp	off_D688(pc,d1.w)
; ---------------------------------------------------------------------------

off_D688:	dc.w locret_D690-off_D688, loc_D692-off_D688, loc_D6B2-off_D688, loc_D6C0-off_D688
; ---------------------------------------------------------------------------

locret_D690:
		rts
; ---------------------------------------------------------------------------

loc_D692:
		move.b	(v_oscillate+$E).w,d0
		subi.b	#$60,d1
		btst	#0,obj.Status(a0)
		beq.s	loc_D6A6
		neg.w	d0
		add.w	d1,d0

loc_D6A6:
		move.w	$32(a0),d1
		sub.w	d0,d1
		move.w	d1,obj.Xpos(a0)
		rts
; ---------------------------------------------------------------------------

loc_D6B2:
		cmpi.b	#4,obj.Routine(a0)
		bne.s	locret_D6BE
		addq.b	#1,obj.Subtype(a0)

locret_D6BE:
		rts
; ---------------------------------------------------------------------------

loc_D6C0:
		moveq	#0,d3
		move.b	obj.ActWid(a0),d3
		bsr.w	ObjectHitWallRight
		tst.w	d1
		bmi.s	loc_D6DA
		addq.w	#1,obj.Xpos(a0)
		move.w	obj.Xpos(a0),$32(a0)
		rts
; ---------------------------------------------------------------------------

loc_D6DA:
		clr.b	obj.Subtype(a0)
		rts
