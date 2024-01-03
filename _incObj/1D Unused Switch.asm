; ---------------------------------------------------------------------------

ObjUnkSwitch:
		moveq	#0,d0
		move.b	obj.Routine(a0),d0
		move.w	off_67C8(pc,d0.w),d1
		jmp	off_67C8(pc,d1.w)
; ---------------------------------------------------------------------------

off_67C8:	dc.w loc_67CE-off_67C8, loc_67F8-off_67C8, loc_6836-off_67C8
; ---------------------------------------------------------------------------

loc_67CE:
		addq.b	#2,obj.Routine(a0)
		move.l	#Map_UnkSwitch,obj.Map(a0)
		move.w	#$4000,obj.Gfx(a0)
		move.b	#4,obj.Render(a0)
		move.w	obj.Ypos(a0),obj.Off_30(a0)
		move.b	#$10,obj.ActWid(a0)
		move.b	#5,obj.Priority(a0)

loc_67F8:
		move.w	obj.Off_30(a0),obj.Ypos(a0)
		move.w	#$10,d1
		bsr.w	sub_683C
		beq.s	loc_6812
		addq.w	#2,obj.Ypos(a0)
		moveq	#1,d0
		move.w	d0,(f_switch).w

loc_6812:
		bsr.w	DisplaySprite
		out_of_range.w	loc_6836
		rts
; ---------------------------------------------------------------------------

loc_6836:
		bsr.w	DeleteObject
		rts
; ---------------------------------------------------------------------------

sub_683C:
		lea	(v_objspace).w,a1
		move.w	obj.Xpos(a1),d0
		sub.w	obj.Xpos(a0),d0
		add.w	d1,d0
		bmi.s	loc_6874
		add.w	d1,d1
		cmp.w	d1,d0
		bcc.s	loc_6874
		move.w	obj.Ypos(a1),d2
		move.b	obj.Height(a1),d1
		ext.w	d1
		add.w	d2,d1
		move.w	obj.Ypos(a0),d0
		subi.w	#$10,d0
		sub.w	d1,d0
		bhi.s	loc_6874
		cmpi.w	#$FFF0,d0
		bcs.s	loc_6874
		moveq	#-1,d0
		rts
; ---------------------------------------------------------------------------

loc_6874:
		moveq	#0,d0
		rts
