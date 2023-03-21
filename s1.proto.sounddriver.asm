; ---------------------------------------------------------------------------
; Modified SMPS 68k Type 1b sound driver
; ---------------------------------------------------------------------------
; Go_SoundTypes:
Go_SoundPriorities:     dc.l SoundPriorities
; Go_SoundD0:
Go_SpecSoundIndex:	dc.l SpecSoundIndex
Go_MusicIndex:          dc.l MusicIndex
Go_SoundIndex:	        dc.l SoundIndex
Go_Modulation:	        dc.l ModulationIndex
; off_74010:
Go_PSGIndex:	        dc.l PSG_Index
			dc.l $A0
			dc.l UpdateMusic
Go_SpeedUpIndex:	dc.l SpeedUpIndex

; ---------------------------------------------------------------------------
; PSG instruments used in music
; ---------------------------------------------------------------------------
PSG_Index:
		dc.l PSG1, PSG2, PSG3
		dc.l PSG4, PSG6, PSG5
		dc.l PSG7, PSG8, PSG9
PSG1:		incbin "sound/psg/psg1.bin"
PSG2:		incbin "sound/psg/psg2.bin"
PSG3:		incbin "sound/psg/psg3.bin"
PSG4:		incbin "sound/psg/psg4.bin"
PSG5:		incbin "sound/psg/psg5.bin"
PSG6:		incbin "sound/psg/psg6.bin"
PSG7:		incbin "sound/psg/psg7.bin"
PSG8:		incbin "sound/psg/psg8.bin"
PSG9:		incbin "sound/psg/psg9.bin"

ModulationIndex:dc.b $D, 1, 7, 4, 1, 1, 1, 4, 2, 1, 2, 4, 8, 1, 6, 4
; ---------------------------------------------------------------------------
; New tempos for songs during speed shoes
; ---------------------------------------------------------------------------
SpeedUpIndex:   dc.b 7					; GHZ
		dc.b $72				; LZ
		dc.b $73				; MZ
		dc.b $26				; SLZ
		dc.b $15				; SYZ
		dc.b 8					; SBZ
		dc.b $FF				; Invincibility
		dc.b 5					; Extra Life
		; All songs after will use their music index pointer instead

; ---------------------------------------------------------------------------
; Music	Pointers
; ---------------------------------------------------------------------------
MusicIndex:
ptr_mus81:	dc.l Music81
ptr_mus82:	dc.l Music82
ptr_mus83:	dc.l Music83
ptr_mus84:	dc.l Music84
ptr_mus85:	dc.l Music85
ptr_mus86:	dc.l Music86
ptr_mus87:	dc.l Music87
ptr_mus88:	dc.l Music88
ptr_mus89:	dc.l Music89
ptr_mus8A:	dc.l Music8A
ptr_mus8B:	dc.l Music8B
ptr_mus8C:	dc.l Music8C
ptr_mus8D:	dc.l Music8D
ptr_mus8E:	dc.l Music8E
ptr_mus8F:	dc.l Music8F
ptr_mus90:	dc.l Music90
ptr_mus91:	dc.l Music91				; Note the lack of a pointer for music $92
ptr_musend:
; ---------------------------------------------------------------------------
; Priority of sound. New music or SFX must have a priority higher than or equal
; to what is stored in v_sndprio or it won't play. If bit 7 of new priority is
; set ($80 and up), the new music or SFX will not set its priority -- meaning
; any music or SFX can override it (as long as it can override whatever was
; playing before). Usually, SFX will only override SFX, special SFX ($D0-$DF)
; will only override special SFX and music will only override music.
; ---------------------------------------------------------------------------
; SoundTypes:
SoundPriorities:
                dc.b $80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80 ; $81
		dc.b $80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$70 ; $90
		dc.b $70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70 ; $A0
		dc.b $70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70 ; $B0
		dc.b $70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$80 ; $C0
		dc.b $80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80 ; $D0
		dc.b $80,$80,$80,$80,$80		; $E0
		even
; ---------------------------------------------------------------------------
; Updates SMPS
; ---------------------------------------------------------------------------
UpdateMusic:
		stopZ80
		waitZ80
		btst	#7,(z80_dac_status).l
		beq.s	.driverinput
		startZ80
		nop
		nop
		nop
		nop
		nop
		bra.s	UpdateMusic
; ---------------------------------------------------------------------------

.driverinput:
		lea	(v_snddriver_ram&$FFFFFF).l,a6
		clr.b	f_voice_selector(a6)
		tst.b	f_pausemusic(a6)
		bne.w	PauseMusic
		subq.b	#1,v_main_tempo_timeout(a6)
		bne.s	.skipdelay
		jsr	TempoWait(pc)

.skipdelay:
		move.b	v_fadeout_counter(a6),d0
		beq.s	.skipfadeout
		jsr	DoFadeOut(pc)

.skipfadeout:
		tst.b	f_fadein_flag(a6)
		beq.s	.nofadein
		jsr	DoFadeIn(pc)

.nofadein:
		tst.w	v_soundqueue0(a6)
		beq.s	.noqueue
		jsr	CycleSoundQueue(pc)

.noqueue:
		lea	$40(a6),a5
		tst.b	(a5)
		bpl.s	.nodac
		jsr	DACUpdateTrack(pc)

.nodac:
		clr.b	f_updating_dac(a6)
		moveq	#5,d7

.loopfm1:
		adda.w	#TrackSz,a5
		tst.b	(a5)
		bpl.s	.nofm1
		jsr	dUpdateFM(pc)

.nofm1:
		dbf	d7,.loopfm1
		moveq	#2,d7

.looppsg1:
		adda.w	#TrackSz,a5
		tst.b	(a5)
		bpl.s	.nopsg1
		jsr	dUpdatePSG(pc)

.nopsg1:
		dbf	d7,.looppsg1
		move.b	#$80,f_voice_selector(a6)
		moveq	#2,d7

.loopfm2:
		adda.w	#TrackSz,a5
		tst.b	(a5)
		bpl.s	.nofm2
		jsr	dUpdateFM(pc)

.nofm2:
		dbf	d7,.loopfm2
		moveq	#2,d7

.looppsg2:
		adda.w	#TrackSz,a5
		tst.b	(a5)
		bpl.s	.nopsg2
		jsr	dUpdatePSG(pc)

.nopsg2:
		dbf	d7,.looppsg2
		move.b	#$40,f_voice_selector(a6)
		adda.w	#TrackSz,a5
		tst.b	(a5)
		bpl.s	.nofm3
		jsr	dUpdateFM(pc)

.nofm3:
		adda.w	#TrackSz,a5
		tst.b	(a5)
		bpl.s	dExit
		jsr	dUpdatePSG(pc)

dExit:
		startZ80
		rts
; ---------------------------------------------------------------------------

DACUpdateTrack:
		subq.b	#1,TrackDurationTimeout(a5)
		bne.s	.nodelay
		move.b	#$80,f_updating_dac(a6)
		movea.l	TrackDataPointer(a5),a4

.command:
		moveq	#0,d5
		move.b	(a4)+,d5
		cmpi.b	#$E0,d5
		bcs.s	.notcommand
		jsr	dCommands(pc)
		bra.s	.command
; ---------------------------------------------------------------------------

.notcommand:
		tst.b	d5
		bpl.s	.duration
		move.b	d5,TrackSavedDAC(a5)
		move.b	(a4)+,d5
		bpl.s	.duration
		subq.w	#1,a4
		move.b	TrackSavedDuration(a5),TrackDurationTimeout(a5)
		bra.s	.checknote
; ---------------------------------------------------------------------------

.duration:
		jsr	dCalcDuration(pc)

.checknote:
		move.l	a4,TrackDataPointer(a5)
		btst	#2,(a5)
		bne.s	.nodelay
		moveq	#0,d0
		move.b	TrackSavedDAC(a5),d0
		cmpi.b	#$80,d0
		beq.s	.nodelay
		btst	#3,d0
		bne.s	.timpani
		tst.b	(z80_dac_noupdate).l
		bne.s	.nodelay
		move.b	d0,(z80_dac_sample).l

.nodelay:
		rts
; ---------------------------------------------------------------------------

.timpani:
		subi.b	#$88,d0
		move.b	.timpanipitch(pc,d0.w),d0
		tst.b	(z80_dac_noupdate).l
		bne.s	.noupdate
		move.b  d0,(z80_dac3_pitch).l
		move.b	#$83,(z80_dac_sample).l

.noupdate:
		rts
; ---------------------------------------------------------------------------

.timpanipitch:	dc.b $12, $15, $1C, $1D, $FF, $FF, $FF, $FF
; ---------------------------------------------------------------------------

dUpdateFM:
		subq.b	#1,TrackDurationTimeout(a5)
		bne.s	.notegoing
		bclr	#4,(a5)
		jsr	dTrackerFM(pc)
		jsr	dUpdateFreqFM(pc)
		jsr	dPanAniInit(pc)
		bra.w	dNoteOnFM
; ---------------------------------------------------------------------------

.notegoing:
		jsr	dGate(pc)
		jsr	DoModulation(pc)
		bra.w	dUpdateFreqFM2
; ---------------------------------------------------------------------------

dTrackerFM:
		movea.l	TrackDataPointer(a5),a4
		bclr	#1,(a5)

.command:
		moveq	#0,d5
		move.b	(a4)+,d5
		cmpi.b	#$E0,d5
		bcs.s	.notcommand
		jsr	dCommands(pc)
		bra.s	.command
; ---------------------------------------------------------------------------

.notcommand:
		jsr	sKeyOffFM(pc)
		tst.b	d5
		bpl.s	.duration
		jsr	dLoadFreqFM(pc)
		move.b	(a4)+,d5
		bpl.s	.duration
		subq.w	#1,a4
		bra.w	dFinishTrack
; ---------------------------------------------------------------------------

.duration:
		jsr	dCalcDuration(pc)
		bra.w	dFinishTrack
; ---------------------------------------------------------------------------

dLoadFreqFM:
		subi.b	#$80,d5
		beq.s	TrackSetRest
		add.b	TrackTranspose(a5),d5
		andi.w	#$7F,d5
		lsl.w	#1,d5
		lea	FMFrequencies(pc),a0
		move.w	(a0,d5.w),d6
		move.w	d6,TrackFreq(a5)
		rts
; ---------------------------------------------------------------------------

dCalcDuration:
		move.b	d5,d0
		move.b	TrackTempoDivider(a5),d1

.loop:
		subq.b	#1,d1
		beq.s	.save
		add.b	d5,d0
		bra.s	.loop
; ---------------------------------------------------------------------------

.save:
		move.b	d0,TrackSavedDuration(a5)	; Save duration
		move.b	d0,TrackDurationTimeout(a5)	; Save duration timeout
		rts
; ---------------------------------------------------------------------------

TrackSetRest:
		bset	#1,(a5)
		clr.w	TrackFreq(a5)
; ---------------------------------------------------------------------------

dFinishTrack:
		move.l	a4,TrackDataPointer(a5)		; Store new track position
		move.b	TrackSavedDuration(a5),TrackDurationTimeout(a5) ; Reset note timeout
		btst	#4,(a5)				; Is track set to not attack note? (TrackPlaybackControl)
		bne.s	locret_74426			; If so, branch
		move.b	TrackNoteTimeoutMaster(a5),TrackNoteTimeout(a5) ; Reset note fill timeout
		clr.b	TrackVolEnvIndex(a5)		; Reset PSG volume envelope index (even on FM tracks...)
		btst	#3,(a5)				; Is modulation on? (TrackPlaybackControl)
		beq.s	locret_74426			; If not, return (TrackPlaybackControl)
		movea.l	TrackModulationPtr(a5),a0	; Modulation data pointer
		move.b	(a0)+,TrackModulationWait(a5)	; Reset wait
		move.b	(a0)+,TrackModulationSpeed(a5)	; Reset speed
		move.b	(a0)+,TrackModulationDelta(a5)	; Reset delta
		move.b	(a0)+,d0			; Get steps
		lsr.b	#1,d0				; Halve them
		move.b	d0,TrackModulationSteps(a5)	; Then store
		clr.w	TrackModulationVal(a5)		; Reset frequency change
locret_74426:
		rts
; ---------------------------------------------------------------------------

dGate:
		tst.b	TrackNoteTimeout(a5)
		beq.s	.locret
		subq.b	#1,TrackNoteTimeout(a5)
		bne.s	.locret
		bset	#1,(a5)
		tst.b	TrackVoiceControl(a5)
		bmi.w	.psg
		jsr	sKeyOffFM(pc)
		addq.w	#4,sp
		rts
; ---------------------------------------------------------------------------

.psg:
		jsr	sMutePSG(pc)
		addq.w	#4,sp

.locret:
		rts
; ---------------------------------------------------------------------------

DoModulation:
		addq.w	#4,sp
		btst	#3,(a5)
		beq.s	.nomods
		tst.b	TrackModulationWait(a5)
		beq.s	.waitdone
		subq.b	#1,TrackModulationWait(a5)
		rts
; ---------------------------------------------------------------------------

.waitdone:
		subq.b	#1,TrackModulationSpeed(a5)
		beq.s	.nextstep
		rts
; ---------------------------------------------------------------------------

.nextstep:
		movea.l	TrackModulationPtr(a5),a0
		move.b	1(a0),TrackModulationSpeed(a5)
		tst.b	TrackModulationSteps(a5)
		bne.s	.noflip
		move.b	3(a0),TrackModulationSteps(a5)
		neg.b	TrackModulationDelta(a5)
		rts
; ---------------------------------------------------------------------------

.noflip:
		subq.b	#1,TrackModulationSteps(a5)
		move.b	TrackModulationDelta(a5),d6
		ext.w	d6
		add.w	TrackModulationVal(a5),d6
		move.w	d6,TrackModulationVal(a5)
		add.w	TrackFreq(a5),d6
		subq.w	#4,sp

.nomods:
		rts
; ---------------------------------------------------------------------------

dUpdateFreqFM:
		btst	#1,(a5)
		bne.s	locret_744E0
		move.w	TrackFreq(a5),d6
		beq.s	dUpdateFreqFM_Rest

dUpdateFreqFM2:
		move.b	TrackDetune(a5),d0
		ext.w	d0
		add.w	d0,d6
		btst	#2,(a5)
		bne.s	locret_744E0
		tst.b	$F(a6)
		beq.s	.nofm3sm
		cmpi.b	#2,1(a5)
		beq.s	dUpdateFreqFM_FM3SM

.nofm3sm:
		move.w	d6,d1
		lsr.w	#8,d1
		move.b	#$A4,d0
		jsr	dWriteYMch(pc)
		move.b	d6,d1
		move.b	#$A0,d0
		jsr	dWriteYMch(pc)

locret_744E0:
		rts
; ---------------------------------------------------------------------------

dUpdateFreqFM_Rest:
		bset	#1,(a5)
		rts
; ---------------------------------------------------------------------------

dUpdateFreqFM_FM3SM:
		lea	.fm3freqs(pc),a1
		lea	TrackFreq(a6),a2
		moveq	#3,d7

.fm3loop:
		move.w	d6,d1
		move.w	(a2)+,d0
		add.w	d0,d1
		move.w	d1,d3
		lsr.w	#8,d1
		move.b	(a1)+,d0
		jsr	WriteFMI(pc)
		move.b	d3,d1
		move.b	(a1)+,d0
		jsr	WriteFMI(pc)
		dbf	d7,.fm3loop
		rts
; ---------------------------------------------------------------------------

.fm3freqs:	dc.b $AD, $A9
		dc.b $AC, $A8
		dc.b $AE, $AA
		dc.b $A6, $A2
; ---------------------------------------------------------------------------

dPanAniInit:
		btst	#1,(a5)
		bne.s	.tables
		moveq	#0,d0
		move.b	TrackFeedbackAlgo(a5),d0
		lsl.w	#1,d0
		jmp	.tables(pc,d0.w)
; ---------------------------------------------------------------------------

.tables:
		rts
; ---------------------------------------------------------------------------
		bra.s	dPanAni_Cont
; ---------------------------------------------------------------------------
		bra.s	dPanAni_Reset
; ---------------------------------------------------------------------------
		bra.s	dPanAni_Reset
; ---------------------------------------------------------------------------

dPanAni:
		btst	#1,(a5)
		bne.s	.table
		moveq	#0,d0
		move.b	TrackFeedbackAlgo(a5),d0
		lsl.w	#1,d0
		jmp	.table(pc,d0.w)
; ---------------------------------------------------------------------------

.table:
		rts
; ---------------------------------------------------------------------------
		rts
; ---------------------------------------------------------------------------
		bra.s	dPanAni_Cont
; ---------------------------------------------------------------------------
		bra.s	dPanAni_Cont
; ---------------------------------------------------------------------------

dPanAni_Reset:
		move.b	$23(a5),$24(a5)
		clr.b	$21(a5)

dPanAni_Cont:
		move.b	$24(a5),d0
		cmp.b	$23(a5),d0
		bne.s	loc_7457E
		move.b	$22(a5),d3
		cmp.b	$21(a5),d3
		bpl.s	loc_74576
		cmpi.b	#2,$1F(a5)
		beq.s	locret_745AE
		clr.b	$21(a5)

loc_74576:
		clr.b	$24(a5)
		addq.b	#1,$21(a5)

loc_7457E:
		moveq	#0,d0
		move.b	$20(a5),d0
		subq.w	#1,d0
		lsl.w	#2,d0
		movea.l	dPanAniTable(pc,d0.w),a0
		moveq	#0,d0
		move.b	$21(a5),d0
		subq.w	#1,d0
		move.b	(a0,d0.w),d1
		move.b	$A(a5),d0
		andi.b	#$37,d0
		or.b	d0,d1
		move.b	#$B4,d0
		jsr	dChkWriteYMch(pc)
		addq.b	#1,$24(a5)

locret_745AE:
		rts
; ---------------------------------------------------------------------------

dPanAniTable:	dc.l pd01, pd02, pd03

pd01:		dc.b $40, $80

pd02:		dc.b $40, $C0, $80

pd03:		dc.b $C0, $80, $C0, $40
		even
; ---------------------------------------------------------------------------

PauseMusic:
		bmi.s	.resume
		cmpi.b	#2,f_pausemusic(a6)
		beq.w	dPauseExit
		move.b	#2,f_pausemusic(a6)
		moveq	#2,d2
		move.b	#$B4,d0
		moveq	#0,d1

.clearpan:
		jsr	WriteFMI(pc)
		jsr	WriteFMII(pc)
		addq.b	#1,d0
		dbf	d2,.clearpan
		moveq	#2,d2
		moveq	#$28,d0

.keyoff:
		move.b	d2,d1
		jsr	WriteFMI(pc)
		addq.b	#4,d1
		jsr	WriteFMI(pc)
		dbf	d2,.keyoff
		jsr	dMutePSG(pc)
		bra.w	dExit
; ---------------------------------------------------------------------------

.resume:
		clr.b	f_pausemusic(a6)
		moveq	#$30,d3
		lea	$40(a6),a5
		moveq	#6,d4

.enablemusic:
		btst	#7,(a5)
		beq.s	.nextmusic
		btst	#2,(a5)
		bne.s	.nextmusic
		move.b	#$B4,d0
		move.b	TrackAMSFMSPan(a5),d1
		jsr	dWriteYMch(pc)

.nextmusic:
		adda.w	d3,a5
		dbf	d4,.enablemusic
		lea	$220(a6),a5
		moveq	#2,d4

.enablesfx:
		btst	#7,(a5)
		beq.s	.nextsfx
		btst	#2,(a5)
		bne.s	.nextsfx
		move.b	#$B4,d0
		move.b	TrackAMSFMSPan(a5),d1
		jsr	dWriteYMch(pc)

.nextsfx:
		adda.w	d3,a5
		dbf	d4,.enablesfx
		lea	$340(a6),a5
		btst	#7,(a5)
		beq.s	dPauseExit
		btst	#2,(a5)
		bne.s	dPauseExit
		move.b	#$B4,d0
		move.b	$A(a5),d1
		jsr	dWriteYMch(pc)

dPauseExit:
		bra.w	dExit
; ---------------------------------------------------------------------------

CycleSoundQueue:
		movea.l	(Go_SoundPriorities).l,a0
		lea	v_soundqueue0(a6),a1
		move.b	v_sndprio(a6),d3
		moveq	#2,d4

loc_74688:
		move.b	(a1),d0
		move.b	d0,d1
		clr.b	(a1)+
		subi.b	#bgm__First,d0
		bcs.s	loc_746A6
		andi.w	#$7F,d0
		move.b	(a0,d0.w),d2
		cmp.b	d3,d2
		bcs.s	loc_746A6
		move.b	d2,d3
		move.b	d1,v_sound_id(a6)

loc_746A6:
		dbf	d4,loc_74688
		tst.b	d3
		bmi.s	dPlaySnd
		move.b	d3,v_sndprio(a6)

dPlaySnd:
		moveq	#0,d7
		move.b	v_sound_id(a6),d7
		move.b	#$80,v_sound_id(a6)
		cmpi.b	#$80,d7
		beq.s	.nosound
		bcs.w	dStopAll
		cmpi.b	#bgm__Last+$E,d7
		bls.w	dPlaySnd_Music
		cmpi.b	#sfx__First,d7
		bcs.w	.nosound
		cmpi.b	#sfx__Last,d7
		bls.w	dPlaySnd_SFX
		cmpi.b	#spec__First,d7
		bcs.w	.nosound
		cmpi.b	#spec__Last+5,d7
		bcs.w	dPlaySnd_SpecSFX
		cmpi.b	#flg__First,d7
		bcs.s	dPlaySnd_DAC
		cmpi.b	#flg__Last+1,d7
		bls.s	dPlaySnd_Cmd

.nosound:
		rts
; ---------------------------------------------------------------------------

dPlaySnd_Cmd:
		subi.b	#$E0,d7
		lsl.w	#2,d7
		jmp	Sound_ExIndex(pc,d7.w)
; ---------------------------------------------------------------------------

Sound_ExIndex:

ptr_flgE0:	bra.w	dPlaySnd_FadeOut
; ---------------------------------------------------------------------------
ptr_flgE1:	bra.w	dStopSFX
; ---------------------------------------------------------------------------
ptr_flgE2:	bra.w	dPlaySnd_ShoesOn
; ---------------------------------------------------------------------------
ptr_flgE3:	bra.w	dPlaySnd_ShoesOff
; ---------------------------------------------------------------------------
ptr_flgE4:	bra.w	dStopSpecSFX
ptr_flgend
; ---------------------------------------------------------------------------

dPlaySnd_DAC:
		addi.b	#-$4F,d7
		move.b	d7,(z80_dac_sample).l
		nop
		nop
		nop
		clr.b	(a0)+
		rts
; ---------------------------------------------------------------------------

dPlaySnd_Music:
		cmpi.b	#bgm_ExtraLife,d7
		bne.s	.notextralife
		tst.b	$27(a6)
		bne.w	.exit
		lea	$40(a6),a5
		moveq	#9,d0

.noint:
		bclr	#2,(a5)
		adda.w	#$30,a5
		dbf	d0,.noint
		lea	$220(a6),a5
		moveq	#5,d0

.loop0:
		bclr	#7,(a5)
		adda.w	#TrackSz,a5
		dbf	d0,.loop0
		movea.l	a6,a0
		lea	$3A0(a6),a1
		move.w	#$87,d0

.memcopy:
		move.l	(a0)+,(a1)+
		dbf	d0,.memcopy
		move.b	#$80,$27(a6)
		clr.b	0(a6)
		bra.s	.initmusic
; ---------------------------------------------------------------------------

.notextralife:
		clr.b	$27(a6)
		clr.b	$26(a6)

.initmusic:
		jsr	dClearMemory(pc)
		movea.l	(Go_SpeedUpIndex).l,a4
		subi.b	#bgm__First,d7
		move.b	(a4,d7.w),$29(a6)
		movea.l	(Go_MusicIndex).l,a4
		lsl.w	#2,d7
		movea.l	(a4,d7.w),a4
		moveq	#0,d0
		move.w	(a4),d0
		add.l	a4,d0
		move.l	d0,$18(a6)
		move.b	5(a4),d0
		move.b	d0,$28(a6)
		tst.b	$2A(a6)
		beq.s	.jump0
		move.b	$29(a6),d0

.jump0:
		move.b	d0,2(a6)
		move.b	d0,1(a6)
		moveq	#0,d1
		movea.l	a4,a3
		addq.w	#6,a4
		moveq	#0,d7
		move.b	2(a3),d7
		beq.w	.dopsg
		subq.b	#1,d7
		move.b	#$C0,d1
		move.b	4(a3),d4
		moveq	#$30,d6
		move.b	#1,d5
		lea	$40(a6),a1
		lea	dFMTypes(pc),a2

.loadfm:
		bset	#7,(a1)
		move.b	(a2)+,1(a1)
		move.b	d4,2(a1)
		move.b	d6,$D(a1)
		move.b	d1,$A(a1)
		move.b	d5,$E(a1)
		moveq	#0,d0
		move.w	(a4)+,d0
		add.l	a3,d0
		move.l	d0,4(a1)
		move.w	(a4)+,8(a1)
		adda.w	d6,a1
		dbf	d7,.loadfm
		cmpi.b	#7,2(a3)
		bne.s	.enabledac
		moveq	#$2B,d0
		moveq	#0,d1
		jsr	WriteFMI(pc)
		bra.w	.dopsg
; ---------------------------------------------------------------------------

.enabledac:
		moveq	#$28,d0
		moveq	#6,d1
		jsr	WriteFMI(pc)
		move.b	#$42,d0
		moveq	#$7F,d1
		jsr	WriteFMII(pc)
		move.b	#$4A,d0
		moveq	#$7F,d1
		jsr	WriteFMII(pc)
		move.b	#$46,d0
		moveq	#$7F,d1
		jsr	WriteFMII(pc)
		move.b	#$4E,d0
		moveq	#$7F,d1
		jsr	WriteFMII(pc)
		move.b	#$B6,d0
		move.b	#$C0,d1
		jsr	WriteFMII(pc)

.dopsg:
		moveq	#0,d7
		move.b	3(a3),d7
		beq.s	.updatesfx
		subq.b	#1,d7
		lea	$190(a6),a1
		lea	dPSGTypes(pc),a2

.loadpsg:
		bset	#7,(a1)
		move.b	(a2)+,1(a1)
		move.b	d4,2(a1)
		move.b	d6,$D(a1)
		move.b	d5,$E(a1)
		moveq	#0,d0
		move.w	(a4)+,d0
		add.l	a3,d0
		move.l	d0,4(a1)
		move.w	(a4)+,8(a1)
		move.b	(a4)+,d0
		move.b	(a4)+,$B(a1)
		adda.w	d6,a1
		dbf	d7,.loadpsg

.updatesfx:
		lea	$220(a6),a1
		moveq	#5,d7

.sfxloop:
		tst.b	(a1)
		bpl.w	.nextsfx
		moveq	#0,d0
		move.b	1(a1),d0
		bmi.s	.psgsfx
		subq.b	#2,d0
		lsl.b	#2,d0
		bra.s	.getch
; ---------------------------------------------------------------------------

.psgsfx:
		lsr.b	#3,d0

.getch:
		lea	dMusicChanTbl(pc),a0
		movea.l	(a0,d0.w),a0
		bset	#2,(a0)

.nextsfx:
		adda.w	d6,a1
		dbf	d7,.sfxloop
		tst.w	$340(a6)
		bpl.s	.nospec1
		bset	#2,$100(a6)

.nospec1:
		tst.w	$370(a6)
		bpl.s	.nospec2
		bset	#2,$1F0(a6)

.nospec2:
		lea	$70(a6),a5
		moveq	#5,d4

.keyofffm:
		jsr	sKeyOffFM(pc)
		adda.w	d6,a5
		dbf	d4,.keyofffm
		moveq	#2,d4

.mutepsg:
		jsr	sMutePSG(pc)
		adda.w	d6,a5
		dbf	d4,.mutepsg

.exit:
		addq.w	#4,sp
		rts
; ---------------------------------------------------------------------------

dFMTypes:
		dc.b 6, 0, 1, 2, 4, 5, 6
		even

dPSGTypes:
		dc.b $80, $A0, $C0
		even
; ---------------------------------------------------------------------------

dPlaySnd_SFX:
		tst.b	$27(a6)
		bne.w	.exits
		cmpi.b	#sfx_Ring,d7
		bne.s	.notring
		tst.b	$2B(a6)
		bne.s	.noswap
		move.b	#sfx_RingLeft,d7

.noswap:
		bchg	#0,$2B(a6)

.notring:
		cmpi.b	#sfx_Push,d7
		bne.s	.notpush
		tst.b	$2C(a6)
		bne.w	.exits
		move.b	#$80,$2C(a6)

.notpush:
		movea.l	(Go_SoundIndex).l,a0
		subi.b	#sfx__First,d7
		lsl.w	#2,d7
		movea.l	(a0,d7.w),a3
		movea.l	a3,a1
		moveq	#0,d0
		move.w	(a1)+,d0
		add.l	a3,d0
		move.l	d0,$1C(a6)
		move.b	(a1)+,d5
		move.b	(a1)+,d7
		subq.b	#1,d7
		moveq	#$30,d6

.chanloop:
		moveq	#0,d3
		move.b	1(a1),d3
		move.b	d3,d4
		bmi.s	.psg
		subq.w	#2,d3
		lsl.w	#2,d3
		lea	dMusicChanTbl(pc),a5
		movea.l	(a5,d3.w),a5
		bset	#2,(a5)
		bra.s	.continue
; ---------------------------------------------------------------------------

.psg:
		lsr.w	#3,d3
		movea.l	dMusicChanTbl(pc,d3.w),a5
		bset	#2,(a5)
		cmpi.b	#$C0,d4
		bne.s	.continue
		move.b	d4,d0
		ori.b	#$1F,d0
		move.b	d0,(psg_input).l
		bchg	#5,d0
		move.b	d0,(psg_input).l

.continue:
		movea.l	dSFXChanTbl(pc,d3.w),a5
		movea.l	a5,a2
		moveq	#$B,d0

.clear:
		clr.l	(a2)+
		dbf	d0,.clear
		move.w	(a1)+,(a5)
		move.b	d5,2(a5)
		moveq	#0,d0
		move.w	(a1)+,d0
		add.l	a3,d0
		move.l	d0,4(a5)
		move.w	(a1)+,8(a5)
		move.b	#1,$E(a5)
		move.b	d6,$D(a5)
		tst.b	d4
		bmi.s	.notpsg
		move.b	#$C0,$A(a5)

.notpsg:
		dbf	d7,.chanloop
		tst.b	$250(a6)
		bpl.s	.nospec
		bset	#2,$340(a6)

.nospec:
		tst.b	$310(a6)
		bpl.s	.exits
		bset	#2,$370(a6)

.exits:
		rts
; ---------------------------------------------------------------------------

dMusicChanTbl:
                dc.l (v_snddriver_ram+v_music_fm3_track)&$FFFFFF
		dc.l 0
		dc.l (v_snddriver_ram+v_music_fm4_track)&$FFFFFF
		dc.l (v_snddriver_ram+v_music_fm5_track)&$FFFFFF
		dc.l (v_snddriver_ram+v_music_psg1_track)&$FFFFFF
		dc.l (v_snddriver_ram+v_music_psg2_track)&$FFFFFF
		dc.l (v_snddriver_ram+v_music_psg3_track)&$FFFFFF ; Plain PSG3
		dc.l (v_snddriver_ram+v_music_psg3_track)&$FFFFFF ; Noise

dSFXChanTbl:
		dc.l (v_snddriver_ram+v_sfx_fm3_track)&$FFFFFF
		dc.l 0
		dc.l (v_snddriver_ram+v_sfx_fm4_track)&$FFFFFF
		dc.l (v_snddriver_ram+v_sfx_fm5_track)&$FFFFFF
		dc.l (v_snddriver_ram+v_sfx_psg1_track)&$FFFFFF
		dc.l (v_snddriver_ram+v_sfx_psg2_track)&$FFFFFF
		dc.l (v_snddriver_ram+v_sfx_psg3_track)&$FFFFFF ; Plain PSG3
		dc.l (v_snddriver_ram+v_sfx_psg3_track)&$FFFFFF ; Noise
; ---------------------------------------------------------------------------

dPlaySnd_SpecSFX:
		tst.b	$27(a6)
		bne.w	.exitp
		movea.l	(Go_SpecSoundIndex).l,a0
		subi.b	#spec__First,d7
		lsl.w	#2,d7
		movea.l	(a0,d7.w),a3
		movea.l	a3,a1
		moveq	#0,d0
		move.w	(a1)+,d0
		add.l	a3,d0
		move.l	d0,$20(a6)
		move.b	(a1)+,d5
		move.b	(a1)+,d7
		subq.b	#1,d7
		moveq	#$30,d6

.chloop:
		move.b	1(a1),d4
		bmi.s	.sppsg
		bset	#2,$100(a6)
		lea	$340(a6),a5
		bra.s	.cont
; ---------------------------------------------------------------------------

.sppsg:
		bset	#2,$1F0(a6)
		lea	$370(a6),a5

.cont:
		movea.l	a5,a2
		moveq	#$B,d0

.clearch:
		clr.l	(a2)+
		dbf	d0,.clearch
		move.w	(a1)+,(a5)
		move.b	d5,2(a5)
		moveq	#0,d0
		move.w	(a1)+,d0
		add.l	a3,d0
		move.l	d0,4(a5)
		move.w	(a1)+,8(a5)
		move.b	#1,$E(a5)
		move.b	d6,$D(a5)
		tst.b	d4
		bmi.s	.notsppsg
		move.b	#$C0,$A(a5)

.notsppsg:
		dbf	d7,.chloop
		tst.b	$250(a6)
		bpl.s	.nospecx
		bset	#2,$340(a6)

.nospecx:
		tst.b	$310(a6)
		bpl.s	.exitp
		bset	#2,$370(a6)
		ori.b	#$1F,d4
		move.b	d4,(psg_input).l
		bchg	#5,d4
		move.b	d4,(psg_input).l

.exitp:
		rts
; ---------------------------------------------------------------------------
; Unused RAM addresses for FM and PSG channel variables used by the Special SFX
; ---------------------------------------------------------------------------
; The first block would have been used for overriding the music tracks
; as they have a lower priority, just as they are in Sound_PlaySFX
; The third block would be used to set up the Special SFX
; The second block, however, is for the SFX tracks, which have a higher priority
; and would be checked for if they're currently playing
; If they are, then the third block would be used again, this time to mark
; the new tracks as 'currently playing'

; These were actually used in Moonwalker's driver (and other SMPS 68k Type 1a drivers)

; BGMFM4PSG3RAM:
;SpecSFX_BGMChannelRAM:
		dc.l (v_snddriver_ram+$100)&$FFFFFF
                dc.l (v_snddriver_ram+$1F0)&$FFFFFF
; SFXFM4PSG3RAM:
;SpecSFX_SFXChannelRAM:
                dc.l (v_snddriver_ram+$250)&$FFFFFF
		dc.l (v_snddriver_ram+$310)&$FFFFFF
; SpecialSFXFM4PSG3RAM:
;SpecSFX_SpecSFXChannelRAM:
                dc.l (v_snddriver_ram+$340)&$FFFFFF
                dc.l (v_snddriver_ram+$370)&$FFFFFF
; ---------------------------------------------------------------------------

dStopSFX:
		clr.b	0(a6)
		moveq	#$27,d0
		moveq	#0,d1
		jsr	WriteFMI(pc)
		lea	$220(a6),a5
		moveq	#5,d7

.runch:
		tst.b	(a5)
		bpl.w	.nextch
		bclr	#7,(a5)
		moveq	#0,d3
		move.b	1(a5),d3
		bmi.s	.psg
		jsr	sKeyOffFM(pc)
		cmpi.b	#4,d3
		bne.s	.notspecial
		tst.b	$340(a6)
		bpl.s	.notspecial
		lea	$340(a6),a5
		movea.l	$20(a6),a1
		bra.s	.procfm
; ---------------------------------------------------------------------------

.notspecial:
		subq.b	#2,d3
		lsl.b	#2,d3
		lea	dMusicChanTbl(pc),a0
		movea.l	a5,a3
		movea.l	(a0,d3.w),a5
		movea.l	$18(a6),a1

.procfm:
		bclr	#2,(a5)
		bset	#1,(a5)
		move.b	$B(a5),d0
		jsr	dUpdateVoice(pc)
		movea.l	a3,a5
		bra.s	.nextch
; ---------------------------------------------------------------------------

.psg:
		jsr	sMutePSG(pc)
		lea	$370(a6),a0
		cmpi.b	#$E0,d3
		beq.s	.procpsg
		cmpi.b	#$C0,d3
		beq.s	.procpsg
		lsr.b	#3,d3
		lea	dMusicChanTbl(pc),a0
		movea.l	(a0,d3.w),a0

.procpsg:
		bclr	#2,(a0)
		bset	#1,(a0)
		cmpi.b	#$E0,1(a0)
		bne.s	.nextch
		move.b	$26(a0),(psg_input).l

.nextch:
		adda.w	#$30,a5
		dbf	d7,.runch
		rts
; ---------------------------------------------------------------------------

dStopSpecSFX:
		lea	$340(a6),a5
		tst.b	(a5)
		bpl.s	.spec2
		bclr	#7,(a5)
		btst	#2,(a5)
		bne.s	.spec2
		jsr	sKeyOffFM2(pc)
		lea	$100(a6),a5
		bclr	#2,(a5)
		bset	#1,(a5)
		tst.b	(a5)
		bpl.s	.spec2
		movea.l	$18(a6),a1
		move.b	$B(a5),d0
		jsr	dUpdateVoice(pc)

.spec2:
		lea	$370(a6),a5
		tst.b	(a5)
		bpl.s	.rts
		bclr	#7,(a5)
		btst	#2,(a5)
		bne.s	.rts
		jsr	sMutePSG2(pc)
		lea	$1F0(a6),a5
		bclr	#2,(a5)
		bset	#1,(a5)
		tst.b	(a5)
		bpl.s	.rts
		cmpi.b	#$E0,1(a5)
		bne.s	.rts
		move.b	$26(a5),(psg_input).l

.rts:
		rts
; ---------------------------------------------------------------------------

dPlaySnd_FadeOut:
		jsr	dStopSFX(pc)
		jsr	dStopSpecSFX(pc)
		move.b	#3,6(a6)
		move.b	#$28,4(a6)
		clr.b	$40(a6)
		clr.b	$2A(a6)
		rts
; ---------------------------------------------------------------------------

DoFadeOut:
		move.b	6(a6),d0
		beq.s	.dotick
		subq.b	#1,6(a6)
		rts
; ---------------------------------------------------------------------------

.dotick:
		subq.b	#1,4(a6)
		beq.w	dStopAll
		move.b	#3,6(a6)
		lea	$70(a6),a5
		moveq	#5,d7

.loopfm:
		tst.b	(a5)
		bpl.s	.nofm
		addq.b	#1,9(a5)
		bpl.s	.updatefm
		bclr	#7,(a5)
		bra.s	.nofm
; ---------------------------------------------------------------------------

.updatefm:
		jsr	dUpdateVolFM(pc)

.nofm:
		adda.w	#$30,a5
		dbf	d7,.loopfm
		moveq	#2,d7

.looppsg:
		tst.b	(a5)
		bpl.s	.nopsg
		addq.b	#1,9(a5)
		cmpi.b	#$10,9(a5)
		bcs.s	.updatpsg
		bclr	#7,(a5)
		bra.s	.nopsg
; ---------------------------------------------------------------------------

.updatpsg:
		move.b	9(a5),d6
		jsr	dUpdateVolPSG(pc)

.nopsg:
		adda.w	#$30,a5
		dbf	d7,.looppsg
		rts
; ---------------------------------------------------------------------------

dMuteFM_Special:
		moveq	#3,d4
		moveq	#$40,d3
		moveq	#$7F,d1

.tlloop:
		move.b	d3,d0
		jsr	dWriteYMch(pc)
		addq.b	#4,d3
		dbf	d4,.tlloop
		moveq	#3,d4
		move.b	#$80,d3
		moveq	#$F,d1

.rrloop:
		move.b	d3,d0
		jsr	dWriteYMch(pc)
		addq.b	#4,d3
		dbf	d4,.rrloop
		rts
; ---------------------------------------------------------------------------

dMuteFM:
		moveq	#2,d2
		moveq	#$28,d0

.keyoff:
		move.b	d2,d1
		jsr	WriteFMI(pc)
		addq.b	#4,d1
		jsr	WriteFMI(pc)
		dbf	d2,.keyoff
		moveq	#$40,d0
		moveq	#$7F,d1
		moveq	#2,d3

.fmloop:
		moveq	#3,d2

.oploop:
		jsr	WriteFMI(pc)
		jsr	WriteFMII(pc)
		addq.w	#4,d0
		dbf	d2,.oploop
		subi.b	#$F,d0
		dbf	d3,.fmloop
		rts
; ---------------------------------------------------------------------------

dStopAll:
		moveq	#$2B,d0
		move.b	#$80,d1
		jsr	WriteFMI(pc)
		moveq	#$27,d0
		moveq	#0,d1
		jsr	WriteFMI(pc)
		movea.l	a6,a0
		move.w	#$E3,d0

.memclr:
		clr.l	(a0)+
		dbf	d0,.memclr
		move.b	#$80,9(a6)
		jsr	dMuteFM(pc)
		bra.w	dMutePSG
; ---------------------------------------------------------------------------

dClearMemory:
		movea.l	a6,a0
		move.b	0(a6),d1
		move.b	$27(a6),d2
		move.b	$2A(a6),d3
		move.b	$26(a6),d4
		move.w	#$87,d0

.clear:
		clr.l	(a0)+
		dbf	d0,.clear
		move.b	d1,0(a6)
		move.b	d2,$27(a6)
		move.b	d3,$2A(a6)
		move.b	d4,$26(a6)
		move.b	#$80,9(a6)
		bra.w	dMutePSG
; ---------------------------------------------------------------------------

TempoWait:
		move.b	2(a6),1(a6)
		addq.b	#1,$4E(a6)
		addq.b	#1,$7E(a6)
		addq.b	#1,$AE(a6)
		addq.b	#1,$DE(a6)
		addq.b	#1,$10E(a6)
		addq.b	#1,$13E(a6)
		addq.b	#1,$16E(a6)
		addq.b	#1,$19E(a6)
		addq.b	#1,$1CE(a6)
		addq.b	#1,$1FE(a6)
		rts
; ---------------------------------------------------------------------------

dPlaySnd_ShoesOn:
		move.b	$29(a6),2(a6)
		move.b	$29(a6),1(a6)
		move.b	#$80,$2A(a6)
		rts
; ---------------------------------------------------------------------------

dPlaySnd_ShoesOff:
		move.b	$28(a6),2(a6)
		move.b	$28(a6),1(a6)
		clr.b	$2A(a6)
		rts
; ---------------------------------------------------------------------------

DoFadeIn:
		tst.b	$25(a6)
		beq.s	.dotick
		subq.b	#1,$25(a6)
		rts
; ---------------------------------------------------------------------------

.dotick:
		tst.b	$26(a6)
		beq.s	.disable
		subq.b	#1,$26(a6)
		move.b	#2,$25(a6)
		lea	$70(a6),a5
		moveq	#5,d7

.loopfm:
		tst.b	(a5)
		bpl.s	.nofm
		subq.b	#1,9(a5)
		jsr	dUpdateVolFM(pc)

.nofm:
		adda.w	#$30,a5
		dbf	d7,.loopfm
		moveq	#2,d7

.looppsg:
		tst.b	(a5)
		bpl.s	.nopsg
		subq.b	#1,9(a5)
		jsr	dUpdateVolPSG(pc)

.nopsg:
		adda.w	#$30,a5
		dbf	d7,.looppsg
		rts
; ---------------------------------------------------------------------------

.disable:
		bclr	#2,$40(a6)
		clr.b	$24(a6)
		rts
; ---------------------------------------------------------------------------

dNoteOnFM:
		btst	#1,(a5)
		bne.s	.locret
		btst	#2,(a5)
		bne.s	.locret
		moveq	#$28,d0
		move.b	TrackVoiceControl(a5),d1
		ori.b	#$F0,d1
		bra.w	WriteFMI
; ---------------------------------------------------------------------------

.locret:
		rts
; ---------------------------------------------------------------------------

sKeyOffFM:
		btst	#4,(a5)
		bne.s	locret_74E42
		btst	#2,(a5)
		bne.s	locret_74E42

sKeyOffFM2:
		moveq	#$28,d0
		move.b	TrackVoiceControl(a5),d1
		bra.w	WriteFMI
; ---------------------------------------------------------------------------

locret_74E42:
		rts
; ---------------------------------------------------------------------------

dChkWriteYMch:
		btst	#2,(a5)
		bne.s	locret_74E4E
		bra.w	dWriteYMch
; ---------------------------------------------------------------------------

locret_74E4E:
		rts
; ---------------------------------------------------------------------------

dWriteYMch:
		btst	#2,TrackVoiceControl(a5)
		bne.s	dWriteYMch2
		add.b	TrackVoiceControl(a5),d0

; ---------------------------------------------------------------------------
; these are what are in the default smps 68k type 1b driver
; why the final chose the ones from the type 1a driver is a mystery
; ---------------------------------------------------------------------------

WriteFMI:
		lea	(ym2612_a0).l,a0

.waitym1:
		btst	#7,(a0)
		bne.s	.waitym1
		move.b	d0,(a0)

.waitym2:
		btst	#7,(a0)
		bne.s	.waitym2
		move.b	d1,1(a0)
		rts
; ---------------------------------------------------------------------------

dWriteYMch2:
		move.b	TrackVoiceControl(a5),d2
		bclr	#2,d2
		add.b	d2,d0
; ---------------------------------------------------------------------------

WriteFMII:
		lea	(ym2612_a0).l,a0

.waitym1:
		btst	#7,(a0)
		bne.s	.waitym1
		move.b	d0,2(a0)

.waitym2:
		btst	#7,(a0)
		bne.s	.waitym2
		move.b	d1,3(a0)
		rts
; ---------------------------------------------------------------------------

FMFrequencies:	dc.w $25E, $284, $2AB, $2D3, $2FE, $32D, $35C, $38F, $3C5
		dc.w $3FF, $43C, $47C, $A5E, $A84, $AAB, $AD3, $AFE, $B2D
		dc.w $B5C, $B8F, $BC5, $BFF, $C3C, $C7C,$125E,$1284,$12AB
		dc.w $12D3,$12FE,$132D,$135C,$138F,$13C5,$13FF,$143C,$147C
		dc.w $1A5E,$1A84,$1AAB,$1AD3,$1AFE,$1B2D,$1B5C,$1B8F,$1BC5
		dc.w $1BFF,$1C3C,$1C7C,$225E,$2284,$22AB,$22D3,$22FE,$232D
		dc.w $235C,$238F,$23C5,$23FF,$243C,$247C,$2A5E,$2A84,$2AAB
		dc.w $2AD3,$2AFE,$2B2D,$2B5C,$2B8F,$2BC5,$2BFF,$2C3C,$2C7C
		dc.w $325E,$3284,$32AB,$32D3,$32FE,$332D,$335C,$338F,$33C5
		dc.w $33FF,$343C,$347C,$3A5E,$3A84,$3AAB,$3AD3,$3AFE,$3B2D
		dc.w $3B5C,$3B8F,$3BC5,$3BFF,$3C3C,$3C7C
; ---------------------------------------------------------------------------

dUpdatePSG:
		subq.b	#1,$E(a5)
		bne.s	.noupdate
		bclr	#4,(a5)
		jsr	dTrackerPSG(pc)
		jsr	dUpdateFreqPSG(pc)
		bra.w	dVolEnvProg
; ---------------------------------------------------------------------------

.noupdate:
		jsr	dGate(pc)
		jsr	dVolEnvProg2(pc)
		jsr	DoModulation(pc)
		jsr	dUpdateFreqPSG2(pc)
		rts
; ---------------------------------------------------------------------------

dTrackerPSG:
		bclr	#1,(a5)
		movea.l	4(a5),a4

.command:
		moveq	#0,d5
		move.b	(a4)+,d5
		cmpi.b	#$E0,d5
		bcs.s	.notcommand
		jsr	dCommands(pc)
		bra.s	.command
; ---------------------------------------------------------------------------

.notcommand:
		tst.b	d5
		bpl.s	.duration
		jsr	dLoadFreqPSG(pc)
		move.b	(a4)+,d5
		tst.b	d5
		bpl.s	.duration
		subq.w	#1,a4
		bra.w	dFinishTrack
; ---------------------------------------------------------------------------

.duration:
		jsr	dCalcDuration(pc)
		bra.w	dFinishTrack
; ---------------------------------------------------------------------------

dLoadFreqPSG:
		subi.b	#$81,d5
		bcs.s	.duration
		add.b	8(a5),d5
		andi.w	#$7F,d5
		lsl.w	#1,d5
		lea	dFreqPSG(pc),a0
		move.w	(a0,d5.w),$10(a5)
		bra.w	dFinishTrack
; ---------------------------------------------------------------------------

.duration:
		bset	#1,(a5)
		move.w	#-1,$10(a5)
		jsr	dFinishTrack(pc)
		bra.w	sMutePSG
; ---------------------------------------------------------------------------

dUpdateFreqPSG:
		move.w	$10(a5),d6
		bmi.s	dRestPSG
; ---------------------------------------------------------------------------

dUpdateFreqPSG2:
		move.b	$1E(a5),d0
		ext.w	d0
		add.w	d0,d6
		btst	#2,(a5)
		bne.s	.locret
		btst	#1,(a5)
		bne.s	.locret
		move.b	1(a5),d0
		cmpi.b	#$E0,d0
		bne.s	.nopsg4
		move.b	#$C0,d0

.nopsg4:
		move.w	d6,d1
		andi.b	#$F,d1
		or.b	d1,d0
		lsr.w	#4,d6
		andi.b	#$3F,d6
		move.b	d0,(psg_input).l
		move.b	d6,(psg_input).l

.locret:
		rts
; ---------------------------------------------------------------------------

dRestPSG:
		bset	#1,(a5)
		rts
; ---------------------------------------------------------------------------

dVolEnvProg2:
		tst.b	$B(a5)
		beq.w	dUpdateVolPSG_Rts

dVolEnvProg:
		move.b	9(a5),d6
		moveq	#0,d0
		move.b	$B(a5),d0
		beq.s	dUpdateVolPSG
		movea.l	(Go_PSGIndex).l,a0
		subq.w	#1,d0
		lsl.w	#2,d0
		movea.l	(a0,d0.w),a0
		move.b	$C(a5),d0
		move.b	(a0,d0.w),d0
		addq.b	#1,$C(a5)
		btst	#7,d0
		beq.s	.volume
		cmpi.b	#$83,d0
		beq.s	dVolEnvCmd_Hold
		cmpi.b	#$85,d0
		beq.s	dVolEnvCmd_Loop
		cmpi.b	#$80,d0
		beq.s	dVolEnvCmd_Reset

.volume:
		add.w	d0,d6
		cmpi.b	#$10,d6
		bcs.s	dUpdateVolPSG
		moveq	#$F,d6
; ---------------------------------------------------------------------------

dUpdateVolPSG:
		btst	#1,(a5)
		bne.s	dUpdateVolPSG_Rts
		btst	#2,(a5)
		bne.s	dUpdateVolPSG_Rts
		btst	#4,(a5)
		bne.s	dUpdateVolPSG_ChkGate

dUpdateVolPSG_DoIt:
		or.b	1(a5),d6
		addi.b	#$10,d6
		move.b	d6,(psg_input).l

dUpdateVolPSG_Rts:
		rts
; ---------------------------------------------------------------------------

dUpdateVolPSG_ChkGate:
		tst.b	$13(a5)
		beq.s	dUpdateVolPSG_DoIt
		tst.b	$12(a5)
		bne.s	dUpdateVolPSG_DoIt
		rts
; ---------------------------------------------------------------------------

dVolEnvCmd_Hold:
		subq.b	#1,$C(a5)
		rts
; ---------------------------------------------------------------------------

dVolEnvCmd_Loop:
		move.b	1(a0,d0.w),$C(a5)
		bra.w	dVolEnvProg
; ---------------------------------------------------------------------------

dVolEnvCmd_Reset:
		clr.b	$C(a5)
		bra.w	dVolEnvProg
; ---------------------------------------------------------------------------

sMutePSG:
		btst	#2,(a5)
		bne.s	locret_750DE

sMutePSG2:
		move.b	1(a5),d0
		ori.b	#$1F,d0
		move.b	d0,(psg_input).l

locret_750DE:
		rts
; ---------------------------------------------------------------------------

dMutePSG:
		lea	(psg_input).l,a0
		move.b	#$9F,(a0)
		move.b	#$BF,(a0)
		move.b	#$DF,(a0)
		move.b	#$FF,(a0)
		rts
; ---------------------------------------------------------------------------

dFreqPSG:	dc.w $356,$326,$2F9,$2CE,$2A5,$280,$25C,$23A,$21A,$1FB
		dc.w $1DF,$1C4,$1AB,$193,$17D,$167,$153,$140,$12E,$11D
		dc.w $10D, $FE, $EF, $E2, $D6, $C9, $BE, $B4, $A9, $A0
		dc.w $97, $8F, $87, $7F, $78, $71, $6B, $65, $5F, $5A
		dc.w $55, $50, $4B, $47, $43, $40, $3C, $39, $36, $33
		dc.w $30, $2D, $2B, $28, $26, $24, $22, $20, $1F, $1D
		dc.w $1B, $1A, $18, $17, $16, $15, $13, $12, $11,   0
; ---------------------------------------------------------------------------

dCommands:
		subi.w	#$E0,d5
		lsl.w	#2,d5
		jmp	.commands(pc,d5.w)
; ---------------------------------------------------------------------------

.commands:
		bra.w	dcPan
; ---------------------------------------------------------------------------
		bra.w	dcsDetune
; ---------------------------------------------------------------------------
		bra.w	dcsComm
; ---------------------------------------------------------------------------
		bra.w	dcGlobalMod
; ---------------------------------------------------------------------------
		bra.w	loc_7527A
; ---------------------------------------------------------------------------
		bra.w	dcaVolFMP
; ---------------------------------------------------------------------------
		bra.w	dcaVolFM
; ---------------------------------------------------------------------------
		bra.w	dcHold
; ---------------------------------------------------------------------------
		bra.w	dcGate
; ---------------------------------------------------------------------------
		bra.w	dcsLFO
; ---------------------------------------------------------------------------
		bra.w	dcsTempo
; ---------------------------------------------------------------------------
		bra.w	dcPlaySnd
; ---------------------------------------------------------------------------
		bra.w	dcaVolPSG
; ---------------------------------------------------------------------------
		bra.w	loc_753C0
; ---------------------------------------------------------------------------
		bra.w	dcYM1
; ---------------------------------------------------------------------------
		bra.w	dcVoice
; ---------------------------------------------------------------------------
		bra.w	dcMod68k
; ---------------------------------------------------------------------------
		bra.w	dcModOn
; ---------------------------------------------------------------------------
		bra.w	dcStop
; ---------------------------------------------------------------------------
		bra.w	dcNoisePSG
; ---------------------------------------------------------------------------
		bra.w	dcModOff
; ---------------------------------------------------------------------------
		bra.w	dcVolEnv
; ---------------------------------------------------------------------------
		bra.w	dcJump
; ---------------------------------------------------------------------------
		bra.w	dcLoop
; ---------------------------------------------------------------------------
		bra.w	dcCall
; ---------------------------------------------------------------------------
		bra.w	dcReturn
; ---------------------------------------------------------------------------
		bra.w	dcTickCh
; ---------------------------------------------------------------------------
		bra.w	dcaTranspose
; ---------------------------------------------------------------------------
		bra.w	dcTick
; ---------------------------------------------------------------------------
		bra.w	loc_7565A
; ---------------------------------------------------------------------------
		bra.w	dcFM3SM
; ---------------------------------------------------------------------------
		moveq	#0,d0
		move.b	(a4)+,d0
		lsl.w	#2,d0
		jmp	.meta(pc,d0.w)
; ---------------------------------------------------------------------------

.meta:
		bra.w	dcSSGEG
; ---------------------------------------------------------------------------
		bra.w	dcSSGEG
; ---------------------------------------------------------------------------

dcPan:
		move.b	(a4)+,d1
		tst.b	1(a5)
		bmi.s	.rts
		move.b	$A(a5),d0
		andi.b	#$37,d0
		or.b	d0,d1
		move.b	d1,$A(a5)
		move.b	#$B4,d0
		bra.w	dChkWriteYMch
; ---------------------------------------------------------------------------

.rts:
		rts
; ---------------------------------------------------------------------------

dcsDetune:
		move.b	(a4)+,$1E(a5)
		rts
; ---------------------------------------------------------------------------

dcsComm:
		move.b	(a4)+,7(a6)
		rts
; ---------------------------------------------------------------------------

dcGlobalMod:
		movea.l	(Go_Modulation).l,a0
		moveq	#0,d0
		move.b	(a4)+,d0
		subq.b	#1,d0
		lsl.w	#2,d0
		adda.w	d0,a0
		bset	#3,(a5)
		move.l	a0,$14(a5)
		move.b	(a0)+,$18(a5)
		move.b	(a0)+,$19(a5)
		move.b	(a0)+,$1A(a5)
		move.b	(a0)+,d0
		lsr.b	#1,d0
		move.b	d0,$1B(a5)
		clr.w	$1C(a5)
		rts
; ---------------------------------------------------------------------------

loc_7527A:
		movea.l	a6,a0
		lea	$3A0(a6),a1
		move.w	#$87,d0

loc_75284:
		move.l	(a1)+,(a0)+
		dbf	d0,loc_75284
		bset	#2,$40(a6)
		movea.l	a5,a3
		move.b	#$28,d6
		sub.b	$26(a6),d6
		moveq	#5,d7
		lea	$70(a6),a5

loc_752A0:
		btst	#7,(a5)
		beq.s	loc_752C2
		bset	#1,(a5)
		add.b	d6,9(a5)
		btst	#2,(a5)
		bne.s	loc_752C2
		moveq	#0,d0
		move.b	$B(a5),d0
		movea.l	$18(a6),a1
		jsr	dUpdateVoice(pc)

loc_752C2:
		adda.w	#$30,a5
		dbf	d7,loc_752A0
		moveq	#2,d7

loc_752CC:
		btst	#7,(a5)
		beq.s	loc_752DE
		bset	#1,(a5)
		jsr	sMutePSG(pc)
		add.b	d6,9(a5)

loc_752DE:
		adda.w	#$30,a5
		dbf	d7,loc_752CC
		movea.l	a3,a5
		move.b	#$80,$24(a6)
		move.b	#$28,$26(a6)
		clr.b	$27(a6)
		addq.w	#8,sp
		rts
; ---------------------------------------------------------------------------

dcSilence:
		jsr	dMuteFM_Special(pc)
		bra.w	dcStop
; ---------------------------------------------------------------------------

dcPanAni:
		move.b	(a4)+,$1F(a5)
		beq.s	.disable
		move.b	(a4)+,$20(a5)
		move.b	(a4)+,$21(a5)
		move.b	(a4)+,$22(a5)
		move.b	(a4),$23(a5)
		move.b	(a4)+,$24(a5)
		rts
; ---------------------------------------------------------------------------

.disable:
		move.b	#$B4,d0
		move.b	$A(a5),d1
		bra.w	dChkWriteYMch
; ---------------------------------------------------------------------------

dcaVolFMP:
		move.b	(a4)+,d0
		tst.b	1(a5)
		bpl.s	dcaVolFM
		add.b	d0,9(a5)
		addq.w	#1,a4
		rts
; ---------------------------------------------------------------------------

dcaVolFM:
		move.b	(a4)+,d0
		add.b	d0,9(a5)
		bra.w	dUpdateVolFM
; ---------------------------------------------------------------------------

dcHold:
		bset	#4,(a5)
		rts
; ---------------------------------------------------------------------------

dcGate:
		move.b	(a4),$12(a5)
		move.b	(a4)+,$13(a5)
		rts
; ---------------------------------------------------------------------------

dcsLFO:
		movea.l	$18(a6),a1
		beq.s	.something
		movea.l	$1C(a6),a1

.something:
		move.b	(a4),d3
		adda.w	#9,a0
		lea	dOpLFO(pc),a2
		moveq	#3,d6

.lfoops:
		move.b	(a1)+,d1
		move.b	(a2)+,d0
		btst	#7,d3
		beq.s	.skipop
		bset	#7,d1
		jsr	dChkWriteYMch(pc)

.skipop:
		lsl.w	#1,d3
		dbf	d6,.lfoops
		move.b	(a4)+,d1
		moveq	#$22,d0
		jsr	WriteFMI(pc)
		move.b	(a4)+,d1
		move.b	$A(a5),d0
		andi.b	#$C0,d0
		or.b	d0,d1
		move.b	d1,$A(a5)
		move.b	#$B4,d0
		bra.w	dChkWriteYMch
; ---------------------------------------------------------------------------

dOpLFO:		dc.b $60, $68, $64, $6C
; ---------------------------------------------------------------------------

dcsTempo:
		move.b	(a4),2(a6)
		move.b	(a4)+,1(a6)
		rts
; ---------------------------------------------------------------------------

dcPlaySnd:
		move.b	(a4)+,$A(a6)
		rts
; ---------------------------------------------------------------------------

dcaVolPSG:
		move.b	(a4)+,d0
		add.b	d0,9(a5)
		rts
; ---------------------------------------------------------------------------

loc_753C0:
		move.b	#0,$2C(a6)
		rts
; ---------------------------------------------------------------------------

dcYM1:
		move.b	(a4)+,d0
		move.b	(a4)+,d1
		bra.w	WriteFMI
; ---------------------------------------------------------------------------

dcVoice:
		moveq	#0,d0
		move.b	(a4)+,d0
		move.b	d0,$B(a5)
		btst	#2,(a5)
		bne.w	locret_75454
		movea.l	$18(a6),a1
		tst.b	$E(a6)
		beq.s	dUpdateVoice
		movea.l	$1C(a6),a1
		tst.b	$E(a6)
		bmi.s	dUpdateVoice
		movea.l	$20(a6),a1
; ---------------------------------------------------------------------------

dUpdateVoice:
		subq.w	#1,d0
		bmi.s	.gotvoice
		move.w	#$19,d1

.count:
		adda.w	d1,a1
		dbf	d0,.count

.gotvoice:
		move.b	(a1)+,d1
		move.b	d1,$25(a5)
		move.b	d1,d4
		move.b	#$B0,d0
		jsr	dWriteYMch(pc)
		lea	dOpVoice(pc),a2
		moveq	#$13,d3

.writeregs:
		move.b	(a2)+,d0
		move.b	(a1)+,d1
		jsr	dWriteYMch(pc)
		dbf	d3,.writeregs
		moveq	#3,d5
		andi.w	#7,d4
		move.b	dAlgoMasks(pc,d4.w),d4
		move.b	9(a5),d3

.updatetl:
		move.b	(a2)+,d0
		move.b	(a1)+,d1
		lsr.b	#1,d4
		bcc.s	.nonslot
		add.b	d3,d1

.nonslot:
		jsr	dWriteYMch(pc)
		dbf	d5,.updatetl
		move.b	#$B4,d0
		move.b	$A(a5),d1
		jsr	dWriteYMch(pc)

locret_75454:
		rts
; ---------------------------------------------------------------------------

dAlgoMasks:	dc.b 8, 8, 8, 8, $A, $E, $E, $F
; ---------------------------------------------------------------------------

dUpdateVolFM:
		btst	#2,(a5)
		bne.s	.rts
		moveq	#0,d0
		move.b	$B(a5),d0
		movea.l	$18(a6),a1
		tst.b	$E(a6)
		beq.s	.gotvoices
		movea.l	$1C(a6),a1
		tst.b	$E(a6)
		bmi.s	.gotvoices
		movea.l	$20(a6),a1

.gotvoices:
		subq.w	#1,d0
		bmi.s	.gotaddr
		move.w	#$19,d1

.count:
		adda.w	d1,a1
		dbf	d0,.count

.gotaddr:
		adda.w	#$15,a1
		lea	dOpTL(pc),a2
		move.b	$25(a5),d0
		andi.w	#7,d0
		move.b	dAlgoMasks(pc,d0.w),d4
		move.b	9(a5),d3
		bmi.s	.rts
		moveq	#3,d5

.nextop:
		move.b	(a2)+,d0
		move.b	(a1)+,d1
		lsr.b	#1,d4
		bcc.s	.nextch
		add.b	d3,d1
		bcs.s	.nextch
		jsr	dWriteYMch(pc)

.nextch:
		dbf	d5,.nextop

.rts:
		rts
; ---------------------------------------------------------------------------

dOpVoice:	dc.b $30
                dc.b $38
                dc.b $34
                dc.b $3C
		dc.b $50
                dc.b $58
                dc.b $54
                dc.b $5C
		dc.b $60
                dc.b $68
                dc.b $64
                dc.b $6C
		dc.b $70
                dc.b $78
                dc.b $74
                dc.b $7C
		dc.b $80
                dc.b $88
                dc.b $84
                dc.b $8C

dOpTL:		dc.b $40
                dc.b $48
                dc.b $44
                dc.b $4C
; ---------------------------------------------------------------------------

dcMod68k:
		bset	#3,(a5)
		move.l	a4,$14(a5)
		move.b	(a4)+,$18(a5)
		move.b	(a4)+,$19(a5)
		move.b	(a4)+,$1A(a5)
		move.b	(a4)+,d0
		lsr.b	#1,d0
		move.b	d0,$1B(a5)
		clr.w	$1C(a5)
		rts
; ---------------------------------------------------------------------------

dcModOn:
		bset	#3,(a5)
		rts
; ---------------------------------------------------------------------------

dcStop:
		bclr	#7,(a5)
		bclr	#4,(a5)
		tst.b	1(a5)
		bmi.s	.psg
		tst.b	8(a6)
		bmi.w	.exit
		jsr	sKeyOffFM(pc)
		bra.s	.checksfx
; ---------------------------------------------------------------------------

.psg:
		jsr	sMutePSG(pc)

.checksfx:
		tst.b	$E(a6)
		bpl.w	.exit
		clr.b	0(a6)
		moveq	#0,d0
		move.b	1(a5),d0
		bmi.s	.getpsg
		lea	dMusicChanTbl(pc),a0
		movea.l	a5,a3
		cmpi.b	#4,d0
		bne.s	.getfm
		tst.b	$340(a6)
		bpl.s	.getfm
		lea	$340(a6),a5
		movea.l	$20(a6),a1
		bra.s	.voice
; ---------------------------------------------------------------------------

.getfm:
		subq.b	#2,d0
		lsl.b	#2,d0
		movea.l	(a0,d0.w),a5
		tst.b	(a5)
		bpl.s	.checkfm3
		movea.l	$18(a6),a1

.voice:
		bclr	#2,(a5)
		bset	#1,(a5)
		move.b	$B(a5),d0
		jsr	dUpdateVoice(pc)

.checkfm3:
		movea.l	a3,a5
		cmpi.b	#2,1(a5)
		bne.s	.exit
		clr.b	$F(a6)
		moveq	#0,d1
		moveq	#$27,d0
		jsr	WriteFMI(pc)
		bra.s	.exit
; ---------------------------------------------------------------------------

.getpsg:
		lea	$370(a6),a0
		tst.b	(a0)
		bpl.s	.normalpsg
		cmpi.b	#$E0,d0
		beq.s	.unint
		cmpi.b	#$C0,d0
		beq.s	.unint

.normalpsg:
		lea	dMusicChanTbl(pc),a0
		lsr.b	#3,d0
		movea.l	(a0,d0.w),a0

.unint:
		bclr	#2,(a0)
		bset	#1,(a0)
		cmpi.b	#$E0,1(a0)
		bne.s	.exit
		move.b	$26(a0),(psg_input).l

.exit:
		addq.w	#8,sp
		rts
; ---------------------------------------------------------------------------

dcNoisePSG:
		move.b	#$E0,1(a5)
		move.b	(a4)+,$26(a5)
		btst	#2,(a5)
		bne.s	.interrupted
		move.b	-1(a4),(psg_input).l

.interrupted:
		rts
; ---------------------------------------------------------------------------

dcModOff:
		bclr	#3,(a5)
		rts
; ---------------------------------------------------------------------------

dcVolEnv:
		move.b	(a4)+,$B(a5)
		rts
; ---------------------------------------------------------------------------

dcJump:
		move.b	(a4)+,d0
		lsl.w	#8,d0
		move.b	(a4)+,d0
		adda.w	d0,a4
		subq.w	#1,a4
		rts
; ---------------------------------------------------------------------------

dcLoop:
		moveq	#0,d0
		move.b	(a4)+,d0
		move.b	(a4)+,d1
		tst.b	$28(a5,d0.w)
		bne.s	.noreset
		move.b	d1,$28(a5,d0.w)

.noreset:
		subq.b	#1,$28(a5,d0.w)
		bne.s	dcJump
		addq.w	#2,a4
		rts
; ---------------------------------------------------------------------------

dcCall:
		moveq	#0,d0
		move.b	$D(a5),d0
		subq.b	#4,d0
		move.l	a4,(a5,d0.w)
		move.b	d0,$D(a5)
		bra.s	dcJump
; ---------------------------------------------------------------------------

dcReturn:
		moveq	#0,d0
		move.b	$D(a5),d0
		movea.l	(a5,d0.w),a4
		addq.w	#2,a4
		addq.b	#4,d0
		move.b	d0,$D(a5)
		rts
; ---------------------------------------------------------------------------

dcTickCh:
		move.b	(a4)+,2(a5)
		rts
; ---------------------------------------------------------------------------

dcaTranspose:
		move.b	(a4)+,d0
		add.b	d0,8(a5)
		rts
; ---------------------------------------------------------------------------

dcTick:
		lea	$40(a6),a0
		move.b	(a4)+,d0
		moveq	#$30,d1
		moveq	#9,d2

.tickloop:
		move.b	d0,2(a0)
		adda.w	d1,a0
		dbf	d2,.tickloop
		rts
; ---------------------------------------------------------------------------

loc_7565A:
		bclr	#7,(a5)
		bclr	#4,(a5)
		jsr	sKeyOffFM(pc)
		tst.b	$250(a6)
		bmi.s	loc_75688
		movea.l	a5,a3
		lea	$100(a6),a5
		movea.l	$18(a6),a1
		bclr	#2,(a5)
		bset	#1,(a5)
		move.b	$B(a5),d0
		jsr	dUpdateVoice(pc)
		movea.l	a3,a5

loc_75688:
		addq.w	#8,sp
		rts
; ---------------------------------------------------------------------------

dcFM3SM:
		lea	$10(a6),a0
		moveq	#7,d0

.clear:
		move.b	(a4)+,(a0)+
		dbf	d0,.clear
		move.b	#$80,$F(a6)
		move.b	#$27,d0
		moveq	#$40,d1
		bra.w	WriteFMI
; ---------------------------------------------------------------------------

dcSSGEG:
		lea	dOpSSGEG(pc),a1
		moveq	#3,d3

.oploop:
		move.b	(a1)+,d0
		move.b	(a4)+,d1
		bset	#3,d1
		jsr	dChkWriteYMch(pc)
		move.b	(a1)+,d0
		moveq	#$1F,d1
		jsr	dChkWriteYMch(pc)
		dbf	d3,.oploop
		rts
; ---------------------------------------------------------------------------

dOpSSGEG:	dc.b $90, $50, $98, $58
		dc.b $94, $54, $9C, $5C
		even

Unc_Z80:        incbin "sound/Z80.bin"
Unc_Z80_End:	even
Music81:	incbin "sound/music/Mus81 - GHZ.bin"
		even
Music82:	incbin "sound/music/Mus82 - LZ.bin"
		even
Music83:	incbin "sound/music/Mus83 - MZ.bin"
		even
Music84:	incbin "sound/music/Mus84 - SLZ.bin"
		even
Music85:	incbin "sound/music/Mus85 - SZ.bin"
		even
Music86:	incbin "sound/music/Mus86 - CWZ.bin"
		even
Music87:	incbin "sound/music/Mus87 - Invincibility.bin"
		even
Music88:	incbin "sound/music/Mus88 - Extra Life.bin"
		even
Music89:	incbin "sound/music/Mus89 - Special Stage.bin"
		even
Music8A:	incbin "sound/music/Mus8A - Title Screen.bin"
		even
Music8B:	incbin "sound/music/Mus8B - Ending.bin"
		even
Music8C:	incbin "sound/music/Mus8C - Boss.bin"
		even
Music8D:	incbin "sound/music/Mus8D - FZ.bin"
		even
Music8E:	incbin "sound/music/Mus8E - Sonic Got Through.bin"
		even
Music8F:	incbin "sound/music/Mus8F - Game Over.bin"
		even
Music90:	incbin "sound/music/Mus90 - Continue Screen.bin"
		even
Music91:	incbin "sound/music/Mus91 - Credits.bin"
		even
; ---------------------------------------------------------------------------
; Sound	effect pointers
; ---------------------------------------------------------------------------
SoundIndex:
ptr_sndA0:	dc.l SoundA0
ptr_sndA1:	dc.l SoundA1
ptr_sndA2:	dc.l SoundA2
ptr_sndA3:	dc.l SoundA3
ptr_sndA4:	dc.l SoundA4
ptr_sndA5:	dc.l SoundA5
ptr_sndA6:	dc.l SoundA6
ptr_sndA7:	dc.l SoundA7
ptr_sndA8:	dc.l SoundA8
ptr_sndA9:	dc.l SoundA9
ptr_sndAA:	dc.l SoundAA
ptr_sndAB:	dc.l SoundAB
ptr_sndAC:	dc.l SoundAC
ptr_sndAD:	dc.l SoundAD
ptr_sndAE:	dc.l SoundAE
ptr_sndAF:	dc.l SoundAF
ptr_sndB0:	dc.l SoundB0
ptr_sndB1:	dc.l SoundB1
ptr_sndB2:	dc.l SoundB2
ptr_sndB3:	dc.l SoundB3
ptr_sndB4:	dc.l SoundB4
ptr_sndB5:	dc.l SoundB5
ptr_sndB6:	dc.l SoundB6
ptr_sndB7:	dc.l SoundB7
ptr_sndB8:	dc.l SoundB8
ptr_sndB9:	dc.l SoundB9
ptr_sndBA:	dc.l SoundBA
ptr_sndBB:	dc.l SoundBB
ptr_sndBC:	dc.l SoundBC
ptr_sndBD:	dc.l SoundBD
ptr_sndBE:	dc.l SoundBE
ptr_sndBF:	dc.l SoundBF
ptr_sndC0:	dc.l SoundC0
ptr_sndC1:	dc.l SoundC1
ptr_sndC2:	dc.l SoundC2
ptr_sndC3:	dc.l SoundC3
ptr_sndC4:	dc.l SoundC4
ptr_sndC5:	dc.l SoundC5
ptr_sndC6:	dc.l SoundC6
ptr_sndC7:	dc.l SoundC7
ptr_sndC8:	dc.l SoundC8
ptr_sndC9:	dc.l SoundC9
ptr_sndCA:	dc.l SoundCA
ptr_sndCB:	dc.l SoundCB
ptr_sndCC:	dc.l SoundCC
ptr_sndCD:	dc.l SoundCD
ptr_sndCE:	dc.l SoundCE
ptr_sndCF:	dc.l SoundCF
ptr_sndend:
; ---------------------------------------------------------------------------
; Special sound effect pointers
; ---------------------------------------------------------------------------
SpecSoundIndex:
ptr_sndD0:	dc.l SoundD0
ptr_sndD1:	dc.l SoundD1				; leftover from Michael Jackson's Moonwalker
ptr_sndD2:	dc.l SoundD2				; leftover from Michael Jackson's Moonwalker
ptr_specend:

SoundA0:	incbin "sound/sfx/A0.ssf"
		even
SoundA1:	incbin "sound/sfx/A1.ssf"
		even
SoundA2:	incbin "sound/sfx/A2.ssf"
		even
SoundA3:	incbin "sound/sfx/A3.ssf"
		even
SoundA4:	incbin "sound/sfx/A4.ssf"
		even
SoundA5:	incbin "sound/sfx/A5.ssf"
		even
SoundA6:	incbin "sound/sfx/A6.ssf"
		even
SoundA7:	incbin "sound/sfx/A7.ssf"
		even
SoundA8:	incbin "sound/sfx/A8.ssf"
		even
SoundA9:	incbin "sound/sfx/A9.ssf"
		even
SoundAA:	incbin "sound/sfx/AA.ssf"
		even
SoundAB:	incbin "sound/sfx/AB.ssf"
		even
SoundAC:	incbin "sound/sfx/AC.ssf"
		even
SoundAD:	incbin "sound/sfx/AD.ssf"
		even
SoundAE:	incbin "sound/sfx/AE.ssf"
		even
SoundAF:	incbin "sound/sfx/AF.ssf"
		even
SoundB0:	incbin "sound/sfx/B0.ssf"
		even
SoundB1:	incbin "sound/sfx/B1.ssf"
		even
SoundB2:	incbin "sound/sfx/B2.ssf"
		even
SoundB3:	incbin "sound/sfx/B3.ssf"
		even
SoundB4:	incbin "sound/sfx/B4.ssf"
		even
SoundB5:	incbin "sound/sfx/B5.ssf"
		even
SoundB6:	incbin "sound/sfx/B6.ssf"
		even
SoundB7:	incbin "sound/sfx/B7.ssf"
		even
SoundB8:	incbin "sound/sfx/B8.ssf"
		even
SoundB9:	incbin "sound/sfx/B9.ssf"
		even
SoundBA:	incbin "sound/sfx/BA.ssf"
		even
SoundBB:	incbin "sound/sfx/BB.ssf"
		even
SoundBC:	incbin "sound/sfx/BC.ssf"
		even
SoundBD:	incbin "sound/sfx/BD.ssf"
		even
SoundBE:	incbin "sound/sfx/BE.ssf"
		even
SoundBF:	incbin "sound/sfx/BF.ssf"
		even
SoundC0:	incbin "sound/sfx/C0.ssf"
		even
SoundC1:	incbin "sound/sfx/C1.ssf"
		even
SoundC2:	incbin "sound/sfx/C2.ssf"
		even
SoundC3:	incbin "sound/sfx/C3.ssf"
		even
SoundC4:	incbin "sound/sfx/C4.ssf"
		even
SoundC5:	incbin "sound/sfx/C5.ssf"
		even
SoundC6:	incbin "sound/sfx/C6.ssf"
		even
SoundC7:	incbin "sound/sfx/C7.ssf"
		even
SoundC8:	incbin "sound/sfx/C8.ssf"
		even
SoundC9:	incbin "sound/sfx/C9.ssf"
		even
SoundCA:	incbin "sound/sfx/CA.ssf"
		even
SoundCB:	incbin "sound/sfx/CB.ssf"
		even
SoundCC:	incbin "sound/sfx/CC.ssf"
		even
SoundCD:	incbin "sound/sfx/CD.ssf"
		even
SoundCE:	incbin "sound/sfx/CE.ssf"
		even
SoundCF:	incbin "sound/sfx/CF.ssf"
		even
SoundD0:	incbin "sound/sfx/D0.ssf"
		even
SoundD1:	incbin "sound/sfx/D1.ssf"
		even
SoundD2:	incbin "sound/sfx/D2.ssf"
		even
