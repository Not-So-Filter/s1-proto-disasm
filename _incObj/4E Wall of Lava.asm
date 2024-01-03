; ---------------------------------------------------------------------------

ObjLavaChase:
		moveq	#0,d0
		move.b	obj.Routine(a0),d0
		move.w	off_CBFC(pc,d0.w),d1
		jmp	off_CBFC(pc,d1.w)
; ---------------------------------------------------------------------------

off_CBFC:	dc.w loc_CC06-off_CBFC, loc_CC66-off_CBFC, loc_CCA2-off_CBFC, loc_CD00-off_CBFC, loc_CD1C-off_CBFC
; ---------------------------------------------------------------------------

loc_CC06:
		addq.b	#2,obj.Routine(a0)
		movea.l	a0,a1
		moveq	#1,d1
		bra.s	loc_CC16
; ---------------------------------------------------------------------------

loc_CC10:
		bsr.w	FindNextFreeObj
		bne.s	loc_CC58

loc_CC16:
		_move.b	#id_LavaWall,obj.Id(a1)
		move.l	#Map_LWall,obj.Map(a1)
		move.w	#$63A8,obj.Gfx(a1)
		move.b	#4,obj.Render(a1)
		move.b	#$50,obj.ActWid(a1)
		move.w	obj.Xpos(a0),obj.Xpos(a1)
		move.w	obj.Ypos(a0),obj.Ypos(a1)
		move.b	#1,obj.Priority(a1)
		move.b	#0,obj.Anim(a1)
		move.b	#$94,obj.ColType(a1)
		move.l	a0,$3C(a1)

loc_CC58:
		dbf	d1,loc_CC10
		addq.b	#6,obj.Routine(a1)
		move.b	#4,obj.Frame(a1)

loc_CC66:
		move.w	(v_objspace+obj.Xpos).w,d0
		sub.w	obj.Xpos(a0),d0
		bcc.s	loc_CC72
		neg.w	d0

loc_CC72:
		cmpi.w	#$E0,d0
		bcc.s	loc_CC92
		move.w	(v_objspace+obj.Ypos).w,d0
		sub.w	obj.Ypos(a0),d0
		bcc.s	loc_CC84
		neg.w	d0

loc_CC84:
		cmpi.w	#$60,d0
		bcc.s	loc_CC92
		move.b	#1,$36(a0)
		bra.s	loc_CCA2
; ---------------------------------------------------------------------------

loc_CC92:
		tst.b	$36(a0)
		beq.s	loc_CCA2
		move.w	#$100,obj.VelX(a0)
		addq.b	#2,obj.Routine(a0)

loc_CCA2:
		cmpi.w	#$6A0,obj.Xpos(a0)
		bne.s	loc_CCB2
		clr.w	obj.VelX(a0)
		clr.b	$36(a0)

loc_CCB2:
		lea	(Ani_LWall).l,a1
		bsr.w	AnimateSprite
		bsr.w	SpeedToPos
		bsr.w	DisplaySprite
		tst.b	$36(a0)
		bne.s	locret_CCE6
		out_of_range.s	loc_CCE8

locret_CCE6:
		rts
; ---------------------------------------------------------------------------

loc_CCE8:
		lea	(v_regbuffer).w,a2
		moveq	#0,d0
		move.b	obj.RespawnNo(a0),d0
		bclr	#7,2(a2,d0.w)
		move.b	#8,obj.Routine(a0)
		rts
; ---------------------------------------------------------------------------

loc_CD00:
		movea.l	$3C(a0),a1
		cmpi.b	#8,obj.Routine(a1)
		beq.s	loc_CD1C
		move.w	obj.Xpos(a1),obj.Xpos(a0)
		subi.w	#$80,obj.Xpos(a0)
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

loc_CD1C:
		bra.w	DeleteObject
