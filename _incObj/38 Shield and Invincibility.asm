; ---------------------------------------------------------------------------

ObjShield:
		moveq	#0,d0
		move.b	objRoutine(a0),d0
		move.w	ObjShield_Index(pc,d0.w),d1
		jmp	ObjShield_Index(pc,d1.w)
; ---------------------------------------------------------------------------

ObjShield_Index:dc.w ObjShield_Init-ObjShield_Index, ObjShield_Shield-ObjShield_Index, ObjShield_Stars-ObjShield_Index
; ---------------------------------------------------------------------------

ObjShield_Init:
		addq.b	#2,objRoutine(a0)
		move.l	#MapShield,objMap(a0)
		move.b	#4,objRender(a0)
		move.b	#1,objPriority(a0)
		move.b	#$10,objActWid(a0)
		tst.b	objAnim(a0)
		bne.s	loc_F786
		move.w	#$541,objGfx(a0)
		rts
; ---------------------------------------------------------------------------

loc_F786:
		addq.b	#2,objRoutine(a0)
		move.w	#$55C,objGfx(a0)
		rts
; ---------------------------------------------------------------------------

ObjShield_Shield:
		tst.b	(v_invinc).w
		bne.s	.locret
		tst.b	(v_shield).w
		beq.s	.delete
		move.w	(v_player+objX).w,objX(a0)
		move.w	(v_player+objY).w,objY(a0)
		move.b	(v_player+objStatus).w,objStatus(a0)
		lea	(AniShield).l,a1
		jsr	(AnimateSprite).l
		bsr.w	DisplaySprite

.locret:
		rts
; ---------------------------------------------------------------------------

.delete:
		bra.w	DeleteObject
; ---------------------------------------------------------------------------

ObjShield_Stars:
		tst.b	(v_invinc).w
		beq.s	ObjShield_Delete2
		move.w	(v_trackpos).w,d0
		move.b	objAnim(a0),d1
		subq.b	#1,d1
		bra.s	ObjShield_StarTrail
; ---------------------------------------------------------------------------
		lsl.b	#4,d1			; Unused code in the final game as well
		addq.b	#4,d1
		sub.b	d1,d0
		move.b	$30(a0),d1
		sub.b	d1,d0
		addq.b	#4,d1
		andi.b	#$F,d1
		move.b	d1,$30(a0)
		bra.s	ObjShield_StarTrail2a
; ---------------------------------------------------------------------------

ObjShield_StarTrail:
		lsl.b	#3,d1
		move.b	d1,d2
		add.b	d1,d1
		add.b	d2,d1
		addq.b	#4,d1
		sub.b	d1,d0
		move.b	$30(a0),d1
		sub.b	d1,d0
		addq.b	#4,d1
		cmpi.b	#$18,d1
		bcs.s	ObjShield_StarTrail2
		moveq	#0,d1

ObjShield_StarTrail2:
		move.b	d1,$30(a0)

ObjShield_StarTrail2a:
		lea	(v_tracksonic).w,a1
		lea	(a1,d0.w),a1
		move.w	(a1)+,objX(a0)
		move.w	(a1)+,objY(a0)
		move.b	(v_player+objStatus).w,objStatus(a0)
		lea	(AniShield).l,a1
		jsr	(AnimateSprite).l
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

ObjShield_Delete2:
		bra.w	DeleteObject
