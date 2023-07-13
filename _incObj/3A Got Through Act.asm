; ---------------------------------------------------------------------------

ObjLevelResults:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	off_A6EE(pc,d0.w),d1
		jmp	off_A6EE(pc,d1.w)
; ---------------------------------------------------------------------------

off_A6EE:	dc.w loc_A6FA-off_A6EE, loc_A74E-off_A6EE, loc_A786-off_A6EE, loc_A794-off_A6EE, loc_A786-off_A6EE
		dc.w loc_A7F2-off_A6EE

got_mainX:	equ $30		; position for card to display on
; ---------------------------------------------------------------------------

loc_A6FA:
		tst.l	(v_plc_buffer).w
		beq.s	loc_A702
		rts
; ---------------------------------------------------------------------------

loc_A702:
		movea.l	a0,a1
		lea	(word_A856).l,a2
		moveq	#6,d1

loc_A70C:
		move.b	#id_GotThroughCard,obId(a1)
		move.w	(a2)+,obX(a1)
		move.w	(a2)+,got_mainX(a1)
		move.w	(a2)+,obScreenY(a1)
		move.b	(a2)+,obRoutine(a1)
		move.b	(a2)+,d0
		cmpi.b	#6,d0
		bne.s	loc_A72E
		add.b	(v_act).w,d0

loc_A72E:
		move.b	d0,obFrame(a1)
		move.l	#MapLevelResults,obMap(a1)
		move.w	#$8580,obGfx(a1)
		move.b	#0,obRender(a1)
		lea	obSize(a1),a1
		dbf	d1,loc_A70C

loc_A74E:
		moveq	#$10,d1
		move.w	got_mainX(a0),d0
		cmp.w	obX(a0),d0
		beq.s	loc_A774
		bge.s	loc_A75E
		neg.w	d1

loc_A75E:
		add.w	d1,obX(a0)

loc_A762:
		move.w	obX(a0),d0
		bmi.s	locret_A772
		cmpi.w	#$200,d0
		bcc.s	locret_A772
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

locret_A772:
		rts
; ---------------------------------------------------------------------------

loc_A774:
		cmpi.b	#4,obFrame(a0)
		bne.s	loc_A762
		addq.b	#2,obRoutine(a0)
		move.w	#$B4,obTimeFrame(a0)

loc_A786:
		subq.w	#1,obTimeFrame(a0)
		bne.s	loc_A790
		addq.b	#2,obRoutine(a0)

loc_A790:
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

loc_A794:
		bsr.w	DisplaySprite
		move.b	#1,(byte_FFFE58).w
		moveq	#0,d0
		tst.w	(word_FFFE54).w
		beq.s	loc_A7B0
		addi.w	#10,d0
		subi.w	#10,(word_FFFE54).w

loc_A7B0:
		tst.w	(word_FFFE56).w
		beq.s	loc_A7C0
		addi.w	#10,d0
		subi.w	#10,(word_FFFE56).w

loc_A7C0:
		tst.w	d0
		bne.s	loc_A7DA
		move.w	#sfx_Cash,d0
		jsr	(PlaySound_Special).l
		addq.b	#2,obRoutine(a0)
		move.w	#$B4,obTimeFrame(a0)

locret_A7D8:
		rts
; ---------------------------------------------------------------------------

loc_A7DA:
		bsr.w	ScoreAdd
		move.b	(byte_FFFE0F).w,d0
		andi.b	#3,d0
		bne.s	locret_A7D8
		move.w	#sfx_Switch,d0
		jmp	(PlaySound_Special).l
; ---------------------------------------------------------------------------

loc_A7F2:
		move.b	(v_zone).w,d0
		andi.w	#7,d0
		lsl.w	#3,d0
		move.b	(v_act).w,d1
		andi.w	#3,d1
		add.w	d1,d1
		add.w	d1,d0
		move.w	word_A826(pc,d0.w),d0
		move.w	d0,(v_zone).w
		tst.w	d0
		bne.s	loc_A81C
		move.b	#id_Sega,(v_gamemode).w
		bra.s	loc_A822
; ---------------------------------------------------------------------------

loc_A81C:
		move.w	#1,(LevelRestart).w

loc_A822:
		bra.w	DisplaySprite
; ===========================================================================
; Level Order
; ===========================================================================
word_A826:	dc.w $001				; GHZ2
		dc.w $002				; GHZ3
		dc.w $200				; MZ1
		dc.w $000				; Sega Screen
		dc.w $101				; LZ2
		dc.w $102				; LZ3
		dc.w $200				; MZ1
		dc.w $000				; Sega Screen
		dc.w $201				; MZ2
		dc.w $202				; MZ3
		dc.w $400				; SZ1
		dc.w $000				; Sega Screen
		dc.w $000				; Sega Screen
		dc.w $302				; SLZ3
		dc.w $200				; MZ1
		dc.w $000				; Sega Screen
		dc.w $300				; SLZ1
		dc.w $402				; SZ3
		dc.w $500				; CWZ1
		dc.w $000				; Sega Screen
		dc.w $501				; CWZ2
		dc.w $502				; CWZ3
		dc.w $000				; Sega Screen
		dc.w $000				; Sega Screen

word_A856:	dc.w 4, $124, $BC
		dc.b 2, 0
		dc.w $FEE0, $120, $D0
		dc.b 2, 1
		dc.w $40C, $14C, $D6
		dc.b 2, 6
		dc.w $520, $120, $EC
		dc.b 2, 2
		dc.w $540, $120, $FC
		dc.b 2, 3
		dc.w $560, $120, $10C
		dc.b 2, 4
		dc.w $20C, $14C, $CC
		dc.b 2, 5