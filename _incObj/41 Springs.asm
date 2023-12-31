; ---------------------------------------------------------------------------

ObjSpring:
		moveq	#0,d0
		move.b	obj.Routine(a0),d0
		move.w	off_BAA0(pc,d0.w),d1
		jsr	off_BAA0(pc,d1.w)
		bsr.w	DisplaySprite
		out_of_range.w	DeleteObject
		rts
; ---------------------------------------------------------------------------

off_BAA0:	dc.w loc_BAB8-off_BAA0, sub_BB2E-off_BAA0, loc_BB84-off_BAA0, sub_BB8E-off_BAA0, sub_BB9A-off_BAA0
		dc.w loc_BC1C-off_BAA0, sub_BC26-off_BAA0, loc_BC32-off_BAA0, loc_BC98-off_BAA0, loc_BCA2-off_BAA0

word_BAB4:	dc.w -$1000, -$A00
; ---------------------------------------------------------------------------

loc_BAB8:
		addq.b	#2,obj.Routine(a0)
		move.l	#Map_Spring,obj.Map(a0)
		move.w	#$523,obj.Gfx(a0)
		ori.b	#4,obj.Render(a0)
		move.b	#$10,obj.ActWid(a0)
		move.b	#4,obj.Priority(a0)
		move.b	obj.Subtype(a0),d0
		btst	#4,d0
		beq.s	loc_BB04
		move.b	#8,obj.Routine(a0)
		move.b	#1,obj.Anim(a0)
		move.b	#3,obj.Frame(a0)
		move.w	#$533,obj.Gfx(a0)
		move.b	#8,obj.ActWid(a0)

loc_BB04:
		btst	#5,d0
		beq.s	loc_BB16
		move.b	#$E,obj.Routine(a0)
		bset	#1,obj.Status(a0)

loc_BB16:
		btst	#1,d0
		beq.s	loc_BB22
		bset	#5,2(a0)

loc_BB22:
		andi.w	#$F,d0
		move.w	word_BAB4(pc,d0.w),$30(a0)
		rts
; ---------------------------------------------------------------------------

sub_BB2E:
		move.w	#$1B,d1
		move.w	#8,d2
		move.w	#$10,d3
		move.w	obj.Xpos(a0),d4
		bsr.w	SolidObject
		tst.b	obj.2ndRout(a0)
		bne.s	loc_BB4A
		rts
; ---------------------------------------------------------------------------

loc_BB4A:
		addq.b	#2,obj.Routine(a0)
		addq.w	#8,obj.Ypos(a1)
		move.w	$30(a0),obj.VelY(a1)
		bset	#1,obj.Status(a1)
		bclr	#3,obj.Status(a1)
		move.b	#$10,obj.Anim(a1)
		move.b	#2,obj.Routine(a1)
		bclr	#3,obj.Status(a0)
		clr.b	obj.2ndRout(a0)
		move.w	#sfx_Spring,d0
		jsr	(PlaySound_Special).l

loc_BB84:
		lea	(Ani_Spring).l,a1
		bra.w	AnimateSprite
; ---------------------------------------------------------------------------

sub_BB8E:
		move.b	#1,obj.NextAni(a0)
		subq.b	#4,obj.Routine(a0)
		rts
; ---------------------------------------------------------------------------

sub_BB9A:
		move.w	#$13,d1
		move.w	#$E,d2
		move.w	#$F,d3
		move.w	obj.Xpos(a0),d4
		bsr.w	SolidObject
		cmpi.b	#2,obj.Routine(a0)
		bne.s	loc_BBBC
		move.b	#8,obj.Routine(a0)

loc_BBBC:
		btst	#5,obj.Status(a0)
		bne.s	loc_BBC6
		rts
; ---------------------------------------------------------------------------

loc_BBC6:
		addq.b	#2,obj.Routine(a0)
		move.w	$30(a0),obj.VelX(a1)
		addq.w	#8,obj.Xpos(a1)
		btst	#0,obj.Status(a0)
		bne.s	loc_BBE6
		subi.w	#$10,obj.Xpos(a1)
		neg.w	obj.VelX(a1)

loc_BBE6:
		move.w	#$F,$3E(a1)
		move.w	obj.VelX(a1),obj.Inertia(a1)
		bchg	#0,obj.Status(a1)
		btst	#2,obj.Status(a1)
		bne.s	loc_BC06
		move.b	#0,obj.Anim(a1)

loc_BC06:
		bclr	#5,obj.Status(a0)
		bclr	#5,obj.Status(a1)
		move.w	#sfx_Spring,d0
		jsr	(PlaySound_Special).l

loc_BC1C:
		lea	(Ani_Spring).l,a1
		bra.w	AnimateSprite
; ---------------------------------------------------------------------------

sub_BC26:
		move.b	#2,obj.NextAni(a0)
		subq.b	#4,obj.Routine(a0)
		rts
; ---------------------------------------------------------------------------

loc_BC32:
		move.w	#$1B,d1
		move.w	#8,d2
		move.w	#$10,d3
		move.w	obj.Xpos(a0),d4
		bsr.w	SolidObject
		cmpi.b	#2,obj.Routine(a0)
		bne.s	loc_BC54
		move.b	#$E,obj.Routine(a0)

loc_BC54:
		tst.b	obj.2ndRout(a0)
		bne.s	locret_BC5E
		tst.w	d4
		bmi.s	loc_BC60

locret_BC5E:
		rts
; ---------------------------------------------------------------------------

loc_BC60:
		addq.b	#2,obj.Routine(a0)
		subq.w	#8,obj.Ypos(a1)
		move.w	$30(a0),obj.VelY(a1)
		neg.w	obj.VelY(a1)
		bset	#1,obj.Status(a1)
		bclr	#3,obj.Status(a1)
		move.b	#2,obj.Routine(a1)
		bclr	#3,obj.Status(a0)
		clr.b	obj.2ndRout(a0)
		move.w	#sfx_Spring,d0
		jsr	(PlaySound_Special).l

loc_BC98:
		lea	(Ani_Spring).l,a1
		bra.w	AnimateSprite
; ---------------------------------------------------------------------------

loc_BCA2:
		move.b	#1,obj.NextAni(a0)
		subq.b	#4,obj.Routine(a0)
		rts
