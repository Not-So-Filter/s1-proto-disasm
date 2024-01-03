; ---------------------------------------------------------------------------

ObjCollapseFloor:
		moveq	#0,d0
		move.b	obj.Routine(a0),d0
		move.w	off_5FF2(pc,d0.w),d1
		jmp	off_5FF2(pc,d1.w)
; ---------------------------------------------------------------------------

off_5FF2:	dc.w loc_5FFE-off_5FF2, loc_603A-off_5FF2, loc_607C-off_5FF2, loc_60A2-off_5FF2, loc_6102-off_5FF2
		dc.w sub_608E-off_5FF2
; ---------------------------------------------------------------------------

loc_5FFE:
		addq.b	#2,obj.Routine(a0)
		move.l	#Map_CFlo,obj.Map(a0)
		move.w	#$42B8,obj.Gfx(a0)
		cmpi.b	#id_SLZ,(v_zone).w
		bne.s	loc_6022
		move.w	#$44E0,obj.Gfx(a0)
		addq.b	#2,obj.Frame(a0)

loc_6022:
		ori.b	#4,obj.Render(a0)
		move.b	#4,obj.Priority(a0)
		move.b	#7,$38(a0)
		move.b	#$44,obj.ActWid(a0)

loc_603A:
		tst.b	$3A(a0)
		beq.s	loc_604C
		tst.b	$38(a0)
		beq.w	loc_6108
		subq.b	#1,$38(a0)

loc_604C:
		move.w	#$20,d1
		bsr.w	PtfmNormal
		tst.b	obj.Subtype(a0)
		bpl.s	loc_6078
		btst	#3,obj.Status(a1)
		beq.s	loc_6078
		bclr	#0,obj.Render(a0)
		move.w	obj.Xpos(a1),d0
		sub.w	obj.Xpos(a0),d0
		bcc.s	loc_6078
		bset	#0,obj.Render(a0)

loc_6078:
		bra.w	RememberState
; ---------------------------------------------------------------------------

loc_607C:
		tst.b	$38(a0)
		beq.w	loc_610E
		move.b	#1,$3A(a0)
		subq.b	#1,$38(a0)
; ---------------------------------------------------------------------------

sub_608E:
		move.w	#$20,d1
		bsr.w	PtfmCheckExit
		move.w	obj.Xpos(a0),d2
		bsr.w	ptfmSurfaceNormal
		bra.w	RememberState
; ---------------------------------------------------------------------------

loc_60A2:
		tst.b	$38(a0)
		beq.s	loc_60F2
		tst.b	$3A(a0)
		bne.w	loc_60B8
		subq.b	#1,$38(a0)
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

loc_60B8:
		subq.b	#1,$38(a0)
		bsr.w	sub_608E
		lea	(v_objspace).w,a1
		btst	#3,obj.Status(a1)
		beq.s	loc_60E4
		tst.b	$38(a0)
		bne.s	locret_60F0
		bclr	#3,obj.Status(a1)
		bclr	#5,obj.Status(a1)
		move.b	#1,obj.NextAni(a1)

loc_60E4:
		move.b	#0,$3A(a0)
		move.b	#6,obj.Routine(a0)

locret_60F0:
		rts
; ---------------------------------------------------------------------------

loc_60F2:
		bsr.w	ObjectFall
		bsr.w	DisplaySprite
		tst.b	obj.Render(a0)
		bpl.s	loc_6102
		rts
; ---------------------------------------------------------------------------

loc_6102:
		bsr.w	DeleteObject
		rts
; ---------------------------------------------------------------------------

loc_6108:
		move.b	#0,$3A(a0)

loc_610E:
		lea	(CFlo_Data2).l,a4
		btst	#0,obj.Subtype(a0)
		beq.s	loc_6122
		lea	(CFlo_Data3).l,a4

loc_6122:
		moveq	#7,d1
		addq.b	#1,obj.Frame(a0)
		bra.s	loc_613C
