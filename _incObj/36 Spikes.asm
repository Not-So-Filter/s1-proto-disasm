; ---------------------------------------------------------------------------

ObjSpikes:
		moveq	#0,d0
		move.b	obj.Routine(a0),d0
		move.w	off_AB0A(pc,d0.w),d1
		jmp	off_AB0A(pc,d1.w)
; ---------------------------------------------------------------------------

off_AB0A:	dc.w loc_AB1A-off_AB0A, loc_AB64-off_AB0A

byte_AB0E:	dc.b 0, $14
		dc.b 1, $10
		dc.b 2, 4
		dc.b 3, $1C
		dc.b 4, $40
		dc.b 5, $10
; ---------------------------------------------------------------------------

loc_AB1A:
		addq.b	#2,obj.Routine(a0)
		move.l	#MapSpikes,obj.Map(a0)
		move.w	#$51B,obj.Gfx(a0)
		ori.b	#4,obj.Render(a0)
		move.b	#4,obj.Priority(a0)
		move.b	obj.Subtype(a0),d0
		andi.b	#$F,obj.Subtype(a0)
		andi.w	#$F0,d0
		lea	(byte_AB0E).l,a1
		lsr.w	#3,d0
		adda.w	d0,a1
		move.b	(a1)+,obj.Frame(a0)
		move.b	(a1)+,obj.ActWid(a0)
		move.w	obj.Xpos(a0),$30(a0)
		move.w	obj.Ypos(a0),$32(a0)

loc_AB64:
		bsr.w	sub_AC02
		move.w	#4,d2
		cmpi.b	#5,obj.Frame(a0)
		beq.s	loc_AB80
		cmpi.b	#1,obj.Frame(a0)
		bne.s	loc_AB9E
		move.w	#$14,d2

loc_AB80:
		move.w	#$1B,d1
		move.w	d2,d3
		subq.w	#2,d3
		move.w	obj.Xpos(a0),d4
		bsr.w	SolidObject
		tst.b	obj.2ndRout(a0)
		bne.s	loc_ABDE
		cmpi.w	#1,d4
		beq.s	loc_ABBE
		bra.s	loc_ABDE
; ---------------------------------------------------------------------------

loc_AB9E:
		moveq	#0,d1
		move.b	obj.ActWid(a0),d1
		addi.w	#$B,d1
		move.w	#$10,d2
		bsr.w	sub_6936
		tst.w	d4
		bpl.s	loc_ABDE
		tst.w	obj.VelY(a1)
		beq.s	loc_ABDE
		tst.w	d3
		bmi.s	loc_ABDE

loc_ABBE:
		move.l	a0,-(sp)
		movea.l	a0,a2
		lea	(v_objspace).w,a0
		move.l	obj.Ypos(a0),d3
		move.w	obj.VelY(a0),d0
		ext.l	d0
		asl.l	#8,d0
		sub.l	d0,d3
		move.l	d3,obj.Ypos(a0)
		bsr.w	loc_FCF4
		movea.l	(sp)+,a0

loc_ABDE:
		bsr.w	DisplaySprite
		out_of_range.w	DeleteObject,$30(a0)
		rts
; ---------------------------------------------------------------------------

sub_AC02:
		moveq	#0,d0
		move.b	obj.Subtype(a0),d0
		add.w	d0,d0
		move.w	off_AC12(pc,d0.w),d1
		jmp	off_AC12(pc,d1.w)
; ---------------------------------------------------------------------------

off_AC12:	dc.w locret_AC18-off_AC12, loc_AC1A-off_AC12
		dc.w loc_AC2E-off_AC12
; ---------------------------------------------------------------------------

locret_AC18:
		rts
; ---------------------------------------------------------------------------

loc_AC1A:
		bsr.w	sub_AC42
		moveq	#0,d0
		move.b	$34(a0),d0
		add.w	$32(a0),d0
		move.w	d0,obj.Ypos(a0)
		rts
; ---------------------------------------------------------------------------

loc_AC2E:
		bsr.w	sub_AC42
		moveq	#0,d0
		move.b	$34(a0),d0
		add.w	$30(a0),d0
		move.w	d0,obj.Xpos(a0)
		rts
; ---------------------------------------------------------------------------

sub_AC42:
		tst.w	$38(a0)
		beq.s	loc_AC60
		subq.w	#1,$38(a0)
		bne.s	locret_ACA2
		tst.b	obj.Render(a0)
		bpl.s	locret_ACA2
		move.w	#sfx_SpikesMove,d0
		jsr	(PlaySound_Special).l
		bra.s	locret_ACA2
; ---------------------------------------------------------------------------

loc_AC60:
		tst.w	$36(a0)
		beq.s	loc_AC82
		subi.w	#$800,$34(a0)
		bcc.s	locret_ACA2
		move.w	#0,$34(a0)
		move.w	#0,$36(a0)
		move.w	#$3C,$38(a0)
		bra.s	locret_ACA2
; ---------------------------------------------------------------------------

loc_AC82:
		addi.w	#$800,$34(a0)
		cmpi.w	#$2000,$34(a0)
		bcs.s	locret_ACA2
		move.w	#$2000,$34(a0)
		move.w	#1,$36(a0)
		move.w	#$3C,$38(a0)

locret_ACA2:
		rts
