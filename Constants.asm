; VRAM data
vram_fg:	= $C000					; foreground namespace
vram_bg:	= $E000					; background namespace
vram_sonic:	= $F000					; Sonic graphics
vram_sprites:	= $F800					; sprite table
vram_hscroll:	= $FC00					; horizontal scroll table

; Game modes
id_Sega:	equ ptr_GM_Sega-GameModeArray		; $00
id_Title:	equ ptr_GM_Title-GameModeArray		; $04
id_Demo:	equ ptr_GM_Demo-GameModeArray		; $08
id_Level:	equ ptr_GM_Level-GameModeArray		; $0C
id_Special:	equ ptr_GM_Special-GameModeArray	; $10

; Levels
id_GHZ:		= 0
id_LZ:		= 1
id_MZ:		= 2
id_SLZ:		= 3
id_SZ:		= 4
id_CWZ:		= 5
id_06:		= 6
id_SS:		= 7

; Colours
cBlack:		= $000					; colour black
cWhite:		= $EEE					; colour white
cBlue:		= $E00					; colour blue
cGreen:		= $0E0					; colour green
cRed:		= $00E					; colour red
cYellow:	= cGreen+cRed				; colour yellow
cAqua:		= cGreen+cBlue				; colour aqua
cMagenta:	= cBlue+cRed				; colour magenta

; Joypad input
btnStart:	= %10000000				; Start button	($80)
btnA:		= %01000000				; A		($40)
btnC:		= %00100000				; C		($20)
btnB:		= %00010000				; B		($10)
btnR:		= %00001000				; Right		($08)
btnL:		= %00000100				; Left		($04)
btnDn:		= %00000010				; Down		($02)
btnUp:		= %00000001				; Up		($01)
btnDir:		= %00001111				; Any direction	($0F)
btnABC:		= %01110000				; A, B or C	($70)
bitStart:	= 7
bitA:		= 6
bitC:		= 5
bitB:		= 4
bitR:		= 3
bitL:		= 2
bitDn:		= 1
bitUp:		= 0

; Object variables
obj STRUCT DOTS
Id		ds.b 1					; id of object (this is put here for readability, this actually makes routines slower by 4 cycles)
Render		ds.b 1					; bitfield for x/y flip, display mode
Gfx		ds.w 1					; palette line & VRAM setting (2 bytes)
Map		ds.l 1					; mappings address (4 bytes)
Xpos		ds.w 1					; x-axis position (2-4 bytes)
ScreenY		ds.w 1					; y-axis position for screen-fixed items (2 bytes)
Ypos		ds.w 1					; y-axis position (2-4 bytes)
ScreenX		ds.w 1					; x-axis position for screen-fixed items (2 bytes)
VelX		ds.w 1					; x-axis velocity (2 bytes)
VelY		ds.w 1					; y-axis velocity (2 bytes)
Inertia		ds.w 1					; potential speed (2 bytes)
Height		ds.b 1					; height/2
Width		ds.b 1					; width/2
ActWid		ds.b 1					; action width
Priority	ds.b 1					; sprite stack priority -- 0 is front
Frame		ds.b 1					; current frame displayed
AniFrame	ds.b 1					; current frame in animation script
Anim		ds.b 1					; current animation
NextAni		ds.b 1					; next animation
TimeFrame	ds.b 1					; time to next frame
DelayAni	ds.b 1					; time to delay animation
ColType		ds.b 1					; collision response type
ColProp		ds.b 1					; collision extra property
Status		ds.b 1					; orientation or mode
RespawnNo	ds.b 1					; respawn list index number
Routine		ds.b 1					; routine number
2ndRout							; secondary routine number
Solid		ds.b 1					; solid status flag
Angle		ds.w 1					; angle
Subtype		ds.b 1					; object subtype
Off_29		ds.b 1
Off_2A		ds.b 1
Off_2B		ds.b 1
Off_2C		ds.b 1
Off_2D		ds.b 1
Off_2E		ds.b 1
Off_2F		ds.b 1
BossX
Off_30		ds.b 1
Off_31		ds.b 1
Off_32		ds.b 1
Off_33		ds.b 1
Off_34		ds.b 1
Off_35		ds.b 1
Off_36		ds.b 1
Off_37		ds.b 1
BossY
Off_38		ds.b 1
Off_39		ds.b 1
Off_3A		ds.b 1
Off_3B		ds.b 1
Off_3C		ds.b 1
Off_3D		ds.b 1
Off_3E		ds.b 1
Off_3F		ds.b 1
Size		ds.b 1					; size for each object
obj ENDSTRUCT

; Object variables used by Sonic
flashtime:	= obj.Off_30				; time between flashes after getting hit
invtime:	= obj.Off_32				; time left for invincibility
shoetime:	= obj.Off_34				; time left for speed shoes
jumpflag:	= obj.Off_3C				; flag for when sonic is jumping
standonobject:	= obj.Off_3D				; object Sonic stands on
ctrllock:	= obj.Off_3E				; lock left and right controls (2 bytes)

; Object variables used by the title card
card_mainX:	= obj.Off_30				; position for card to display on
card_finalX:	= obj.Off_32				; position for card to finish on

; Animation flags
afEnd:		= $FF					; return to beginning of animation
afBack:		= $FE					; go back (specified number) bytes
afChange:	= $FD					; run specified animation
afRoutine:	= $FC					; increment routine counter
afReset:	= $FB					; reset animation and 2nd object routine counter
af2ndRoutine:	= $FA					; increment 2nd routine counter

; ---------------------------------------------------------------------------

; VDP addressses
vdp_data_port:		= $C00000
vdp_control_port:	= $C00004
vdp_counter:		= $C00008

psg_input:		= $C00011

	phase	$1FF4
z80_stack:	ds.w 1
zDAC_Update:	ds.b 1
zUnk_1FF7:	ds.b 1
zUnk_1FF8:	ds.w 1
zUnk_1FFA:	ds.b 1
zUnk_1FFB:	ds.b 1
zUnk_1FFC:	ds.b 1
zDAC_Status:	ds.b 1					; Bit 7 set if the driver is not accepting new samples, it is clear otherwise
zUnk_1FFE:	ds.b 1
zDAC_Sample:	ds.b 1					; Sample to play, the 68k will move into this locatiton whatever sample that's supposed to be played.
	dephase

zYM2612_A0:	equ $4000
zYM2612_D0:	equ $4001
zYM2612_A1:	equ $4002
zYM2612_D1:	equ $4003
zBankRegister:	equ $6000
zROMWindow:	equ $8000

; Z80 addresses
z80_ram:		= $A00000			; start of Z80 RAM
z80_dac3_pitch:		= z80_ram+zTimpani_Pitch
z80_dac_update:		= z80_ram+zDAC_Update
z80_dac_unk1FF8:	= z80_ram+zUnk_1FF8
z80_dac_status:		= z80_ram+zDAC_Status
z80_dac_sample:		= z80_ram+zDAC_Sample
z80_ram_end:		= $A02000			; end of non-reserved Z80 RAM
ym2612_a0:		= z80_ram+zYM2612_A0
ym2612_d0:		= z80_ram+zYM2612_D0
ym2612_a1:		= z80_ram+zYM2612_A1
ym2612_d1:		= z80_ram+zYM2612_D1
z80_version:		= $A10001
z80_port_1_data:	= $A10002
z80_port_1_control:	= $A10008
z80_port_2_control:	= $A1000A
z80_expansion_control:	= $A1000C
z80_bus_request:	= $A11100
z80_reset:		= $A11200

security_addr:		= $A14000

; Sound driver constants
TrackPlaybackControl:	= 0				; All tracks
TrackVoiceControl:	= 1				; All tracks
TrackTempoDivider:	= 2				; All tracks
TrackDataPointer:	= 4				; All tracks (4 bytes)
TrackTranspose:		= 8				; FM/PSG only (sometimes written to as a word, to include TrackVolume)
TrackVolume:		= 9				; FM/PSG only
TrackAMSFMSPan:		= $A				; FM/DAC only
TrackVoiceIndex:	= $B				; FM/PSG only
TrackVolEnvIndex:	= $C				; PSG only
TrackStackPointer:	= $D				; All tracks
TrackDurationTimeout:	= $E				; All tracks
TrackSavedDuration:	= $F				; All tracks
TrackSavedDAC:		= $10				; DAC only
TrackFreq:		= $10				; FM/PSG only (2 bytes)
TrackNoteTimeout:	= $12				; FM/PSG only
TrackNoteTimeoutMaster:	= $13				; FM/PSG only
TrackModulationPtr:	= $14				; FM/PSG only (4 bytes)
TrackModulationWait:	= $18				; FM/PSG only
TrackModulationSpeed:	= $19				; FM/PSG only
TrackModulationDelta:	= $1A				; FM/PSG only
TrackModulationSteps:	= $1B				; FM/PSG only
TrackModulationVal:	= $1C				; FM/PSG only (2 bytes)
TrackDetune:		= $1E				; FM/PSG only
TrackVoicePtr:		= $1C				; FM SFX only (4 bytes)
TrackPanNumber:		= $1F				; FM only
TrackPanTable:		= $20				; FM only
TrackPanStart:		= $21				; FM only
TrackPanLimit:		= $22				; FM only
TrackPanLength:		= $23				; FM only
TrackPanContinue:	= $24				; FM only
TrackFeedbackAlgo:	= $25				; FM only
TrackPSGNoise:		= $26				; PSG only
TrackLoopCounters:	= $28				; All tracks (multiple bytes)
TrackSz:		= $30
TrackGoSubStack:	= TrackSz			; All tracks (multiple bytes. This constant won't get to be used because of an optimisation that just uses TrackSz)

; Background music
bgm__First:	= $81
bgm_GHZ:	equ ((ptr_mus81-MusicIndex)/4)+bgm__First
bgm_LZ:		equ ((ptr_mus82-MusicIndex)/4)+bgm__First
bgm_MZ:		equ ((ptr_mus83-MusicIndex)/4)+bgm__First
bgm_SLZ:	equ ((ptr_mus84-MusicIndex)/4)+bgm__First
bgm_SZ:	        equ ((ptr_mus85-MusicIndex)/4)+bgm__First
bgm_CWZ:	equ ((ptr_mus86-MusicIndex)/4)+bgm__First
bgm_Invincible:	equ ((ptr_mus87-MusicIndex)/4)+bgm__First
bgm_ExtraLife:	equ ((ptr_mus88-MusicIndex)/4)+bgm__First
bgm_SS:		equ ((ptr_mus89-MusicIndex)/4)+bgm__First
bgm_Title:	equ ((ptr_mus8A-MusicIndex)/4)+bgm__First
bgm_Ending:	equ ((ptr_mus8B-MusicIndex)/4)+bgm__First
bgm_Boss:	equ ((ptr_mus8C-MusicIndex)/4)+bgm__First
bgm_FZ:		equ ((ptr_mus8D-MusicIndex)/4)+bgm__First
bgm_GotThrough:	equ ((ptr_mus8E-MusicIndex)/4)+bgm__First
bgm_GameOver:	equ ((ptr_mus8F-MusicIndex)/4)+bgm__First
bgm_Continue:	equ ((ptr_mus90-MusicIndex)/4)+bgm__First
bgm_Credits:	equ ((ptr_mus91-MusicIndex)/4)+bgm__First
bgm__Last:	equ ((ptr_musend-MusicIndex-4)/4)+bgm__First

; Sound effects
sfx__First:	= $A0
sfx_Jump:	equ ((ptr_sndA0-SoundIndex)/4)+sfx__First
sfx_Lamppost:	equ ((ptr_sndA1-SoundIndex)/4)+sfx__First
sfx_A2:		equ ((ptr_sndA2-SoundIndex)/4)+sfx__First
sfx_Death:	equ ((ptr_sndA3-SoundIndex)/4)+sfx__First
sfx_Skid:	equ ((ptr_sndA4-SoundIndex)/4)+sfx__First
sfx_A5:		equ ((ptr_sndA5-SoundIndex)/4)+sfx__First
sfx_HitSpikes:	equ ((ptr_sndA6-SoundIndex)/4)+sfx__First
sfx_Push:	equ ((ptr_sndA7-SoundIndex)/4)+sfx__First
sfx_SSGoal:	equ ((ptr_sndA8-SoundIndex)/4)+sfx__First
sfx_SSItem:	equ ((ptr_sndA9-SoundIndex)/4)+sfx__First
sfx_Splash:	equ ((ptr_sndAA-SoundIndex)/4)+sfx__First
sfx_AB:		equ ((ptr_sndAB-SoundIndex)/4)+sfx__First
sfx_HitBoss:	equ ((ptr_sndAC-SoundIndex)/4)+sfx__First
sfx_Bubble:	equ ((ptr_sndAD-SoundIndex)/4)+sfx__First
sfx_Fireball:	equ ((ptr_sndAE-SoundIndex)/4)+sfx__First
sfx_Shield:	equ ((ptr_sndAF-SoundIndex)/4)+sfx__First
sfx_Saw:	equ ((ptr_sndB0-SoundIndex)/4)+sfx__First
sfx_Electric:	equ ((ptr_sndB1-SoundIndex)/4)+sfx__First
sfx_Drown:	equ ((ptr_sndB2-SoundIndex)/4)+sfx__First
sfx_Flamethrower:equ ((ptr_sndB3-SoundIndex)/4)+sfx__First
sfx_Bumper:	equ ((ptr_sndB4-SoundIndex)/4)+sfx__First
sfx_Ring:	equ ((ptr_sndB5-SoundIndex)/4)+sfx__First
sfx_SpikesMove:	equ ((ptr_sndB6-SoundIndex)/4)+sfx__First
sfx_Rumbling:	equ ((ptr_sndB7-SoundIndex)/4)+sfx__First
sfx_B8:		equ ((ptr_sndB8-SoundIndex)/4)+sfx__First
sfx_Collapse:	equ ((ptr_sndB9-SoundIndex)/4)+sfx__First
sfx_SSGlass:	equ ((ptr_sndBA-SoundIndex)/4)+sfx__First
sfx_Door:	equ ((ptr_sndBB-SoundIndex)/4)+sfx__First
sfx_Teleport:	equ ((ptr_sndBC-SoundIndex)/4)+sfx__First
sfx_ChainStomp:	equ ((ptr_sndBD-SoundIndex)/4)+sfx__First
sfx_Roll:	equ ((ptr_sndBE-SoundIndex)/4)+sfx__First
sfx_Continue:	equ ((ptr_sndBF-SoundIndex)/4)+sfx__First
sfx_Basaran:	equ ((ptr_sndC0-SoundIndex)/4)+sfx__First
sfx_BreakItem:	equ ((ptr_sndC1-SoundIndex)/4)+sfx__First
sfx_Warning:	equ ((ptr_sndC2-SoundIndex)/4)+sfx__First
sfx_GiantRing:	equ ((ptr_sndC3-SoundIndex)/4)+sfx__First
sfx_Bomb:	equ ((ptr_sndC4-SoundIndex)/4)+sfx__First
sfx_Cash:	equ ((ptr_sndC5-SoundIndex)/4)+sfx__First
sfx_RingLoss:	equ ((ptr_sndC6-SoundIndex)/4)+sfx__First
sfx_ChainRise:	equ ((ptr_sndC7-SoundIndex)/4)+sfx__First
sfx_Burning:	equ ((ptr_sndC8-SoundIndex)/4)+sfx__First
sfx_Bonus:	equ ((ptr_sndC9-SoundIndex)/4)+sfx__First
sfx_EnterSS:	equ ((ptr_sndCA-SoundIndex)/4)+sfx__First
sfx_WallSmash:	equ ((ptr_sndCB-SoundIndex)/4)+sfx__First
sfx_Spring:	equ ((ptr_sndCC-SoundIndex)/4)+sfx__First
sfx_Switch:	equ ((ptr_sndCD-SoundIndex)/4)+sfx__First
sfx_RingLeft:	equ ((ptr_sndCE-SoundIndex)/4)+sfx__First
sfx_Signpost:	equ ((ptr_sndCF-SoundIndex)/4)+sfx__First
sfx__Last:	equ ((ptr_sndend-SoundIndex-4)/4)+sfx__First

; Special sound effects
spec__First:	= $D0
sfx_Waterfall:	equ ((ptr_sndD0-SpecSoundIndex)/4)+spec__First
sfx_Loud_Waterfall:	equ ((ptr_sndD1-SpecSoundIndex)/4)+spec__First
sfx_Pounding:	equ ((ptr_sndD2-SpecSoundIndex)/4)+spec__First
spec__Last:	equ ((ptr_specend-SpecSoundIndex-4)/4)+spec__First

flg__First:	= $E0
bgm_Fade:	equ ((ptr_flgE0-Sound_ExIndex)/4)+flg__First
bgm_Stop:	equ ((ptr_flgE1-Sound_ExIndex)/4)+flg__First
bgm_Speedup:	equ ((ptr_flgE2-Sound_ExIndex)/4)+flg__First
bgm_Slowdown:	equ ((ptr_flgE3-Sound_ExIndex)/4)+flg__First
bgm_StopSpec:	equ ((ptr_flgE4-Sound_ExIndex)/4)+flg__First
flg__Last:	equ ((ptr_flgend-Sound_ExIndex-4)/4)+flg__First
