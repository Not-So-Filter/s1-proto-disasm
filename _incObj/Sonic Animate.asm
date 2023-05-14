; ---------------------------------------------------------------------------

Sonic_Animate:
		lea	(AniSonic).l,a1
		moveq	#0,d0
		move.b	$1C(a0),d0
		cmp.b	$1D(a0),d0
		beq.s	Sonic_AnimDo
		move.b	d0,$1D(a0)
		move.b	#0,$1B(a0)
		move.b	#0,$1E(a0)

Sonic_AnimDo:
		add.w	d0,d0
		adda.w	(a1,d0.w),a1
		move.b	(a1),d0
		bmi.s	Sonic_AnimateCmd
		move.b	$22(a0),d1
		andi.b	#1,d1
		andi.b	#$FC,1(a0)
		or.b	d1,1(a0)
		subq.b	#1,$1E(a0)
		bpl.s	Sonic_AnimDelay
		move.b	d0,$1E(a0)
; ---------------------------------------------------------------------------

Sonic_AnimDo2:
		moveq	#0,d1
		move.b	$1B(a0),d1
		move.b	1(a1,d1.w),d0
		bmi.s	Sonic_AnimEndFF

Sonic_AnimNext:
		move.b	d0,$1A(a0)
		addq.b	#1,$1B(a0)

Sonic_AnimDelay:
		rts
; ---------------------------------------------------------------------------

Sonic_AnimEndFF:
		addq.b	#1,d0
		bne.s	Sonic_AnimFE
		move.b	#0,$1B(a0)
		move.b	1(a1),d0
		bra.s	Sonic_AnimNext
; ---------------------------------------------------------------------------

Sonic_AnimFE:
		addq.b	#1,d0
		bne.s	Sonic_AnimFD
		move.b	2(a1,d1.w),d0
		sub.b	d0,$1B(a0)
		sub.b	d0,d1
		move.b	1(a1,d1.w),d0
		bra.s	Sonic_AnimNext
; ---------------------------------------------------------------------------

Sonic_AnimFD:
		addq.b	#1,d0
		bne.s	Sonic_AnimEnd
		move.b	2(a1,d1.w),$1C(a0)

Sonic_AnimEnd:
		rts
; ---------------------------------------------------------------------------

Sonic_AnimateCmd:
		subq.b	#1,$1E(a0)
		bpl.s	Sonic_AnimDelay
		addq.b	#1,d0
		bne.w	Sonic_AnimRollJump
		moveq	#0,d1
		move.b	$26(a0),d0
		move.b	$22(a0),d2
		andi.b	#1,d2
		bne.s	loc_F53E
		not.b	d0

loc_F53E:
		addi.b	#$10,d0
		bpl.s	loc_F546
		moveq	#3,d1

loc_F546:
		andi.b	#$FC,1(a0)
		eor.b	d1,d2
		or.b	d2,1(a0)
		btst	#5,$22(a0)
		bne.w	Sonic_AnimPush
		lsr.b	#4,d0
		andi.b	#6,d0
		move.w	$14(a0),d2
		bpl.s	loc_F56A
		neg.w	d2

loc_F56A:
		lea	(byte_F654).l,a1
		cmpi.w	#$600,d2
		bcc.s	loc_F582
		lea	(byte_F64C).l,a1
		move.b	d0,d1
		lsr.b	#1,d1
		add.b	d1,d0

loc_F582:
		add.b	d0,d0
		move.b	d0,d3
		neg.w	d2
		addi.w	#$800,d2
		bpl.s	loc_F590
		moveq	#0,d2

loc_F590:
		lsr.w	#8,d2
		move.b	d2,$1E(a0)
		bsr.w	Sonic_AnimDo2
		add.b	d3,$1A(a0)
		rts
; ---------------------------------------------------------------------------

Sonic_AnimRollJump:
		addq.b	#1,d0
		bne.s	Sonic_AnimPush
		move.w	$14(a0),d2
		bpl.s	loc_F5AC
		neg.w	d2

loc_F5AC:
		lea	(byte_F664).l,a1
		cmpi.w	#$600,d2
		bcc.s	loc_F5BE
		lea	(byte_F65C).l,a1

loc_F5BE:
		neg.w	d2
		addi.w	#$400,d2
		bpl.s	loc_F5C8
		moveq	#0,d2

loc_F5C8:
		lsr.w	#8,d2
		move.b	d2,$1E(a0)
		move.b	$22(a0),d1
		andi.b	#1,d1
		andi.b	#$FC,1(a0)
		or.b	d1,1(a0)
		bra.w	Sonic_AnimDo2
; ---------------------------------------------------------------------------

Sonic_AnimPush:
		move.w	$14(a0),d2
		bmi.s	loc_F5EC
		neg.w	d2

loc_F5EC:
		addi.w	#$800,d2
		bpl.s	loc_F5F4
		moveq	#0,d2

loc_F5F4:
		lsr.w	#6,d2
		move.b	d2,$1E(a0)

loc_F5FA:
		lea	(byte_F66C).l,a1
		move.b	$22(a0),d1
		andi.b	#1,d1
		andi.b	#$FC,1(a0)
		or.b	d1,1(a0)
		bra.w	Sonic_AnimDo2