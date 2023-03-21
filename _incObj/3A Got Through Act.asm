; ---------------------------------------------------------------------------

ObjLevelResults:
		moveq	#0,d0
		move.b	act(a0),d0
		move.w	off_A6EE(pc,d0.w),d1
		jmp	off_A6EE(pc,d1.w)
; ---------------------------------------------------------------------------

off_A6EE:	dc.w loc_A6FA-off_A6EE, loc_A74E-off_A6EE, loc_A786-off_A6EE, loc_A794-off_A6EE, loc_A786-off_A6EE
		dc.w loc_A7F2-off_A6EE
; ---------------------------------------------------------------------------

loc_A6FA:
		tst.l	(plcList).w
		beq.s	loc_A702
		rts
; ---------------------------------------------------------------------------

loc_A702:
		movea.l	a0,a1
		lea	(word_A856).l,a2
		moveq	#6,d1

loc_A70C:
		move.b	#$3A,id(a1)
		move.w	(a2)+,xpos(a1)
		move.w	(a2)+,$30(a1)
		move.w	(a2)+,xpix(a1)
		move.b	(a2)+,act(a1)
		move.b	(a2)+,d0
		cmpi.b	#6,d0
		bne.s	loc_A72E
		add.b	(v_act).w,d0

loc_A72E:
		move.b	d0,frame(a1)
		move.l	#MapLevelResults,map(a1)
		move.w	#$8580,tile(a1)
		move.b	#0,render(a1)
		lea	size(a1),a1
		dbf	d1,loc_A70C

loc_A74E:
		moveq	#$10,d1
		move.w	$30(a0),d0
		cmp.w	xpos(a0),d0
		beq.s	loc_A774
		bge.s	loc_A75E
		neg.w	d1

loc_A75E:
		add.w	d1,xpos(a0)

loc_A762:
		move.w	xpos(a0),d0
		bmi.s	locret_A772
		cmpi.w	#$200,d0
		bcc.s	locret_A772
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

locret_A772:
		rts
; ---------------------------------------------------------------------------

loc_A774:
		cmpi.b	#4,frame(a0)
		bne.s	loc_A762
		addq.b	#2,act(a0)
		move.w	#$B4,anidelay(a0)

loc_A786:
		subq.w	#1,anidelay(a0)
		bne.s	loc_A790
		addq.b	#2,act(a0)

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
		jsr	(PlaySFX).l
		addq.b	#2,act(a0)
		move.w	#$B4,anidelay(a0)

locret_A7D8:
		rts
; ---------------------------------------------------------------------------

loc_A7DA:
		bsr.w	ScoreAdd
		move.b	(byte_FFFE0F).w,d0
		andi.b	#3,d0
		bne.s	locret_A7D8
		move.w	#sfx_Switch,d0
		jmp	(PlaySFX).l
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
		move.b	#0,(v_gamemode).w
		bra.s	loc_A822
; ---------------------------------------------------------------------------

loc_A81C:
		move.w	#1,(LevelRestart).w

loc_A822:
		bra.w	DisplaySprite
