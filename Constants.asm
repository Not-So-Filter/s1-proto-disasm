; enum object, width 64 bytes
id		equ 0
render		equ 1
tile		equ 2
map		equ 4
xpos		equ 8
xpix		equ $A
ypos		equ $C
ypix		equ $E
xvel		equ $10
yvel		equ $12
yrad		equ $16
xrad		equ $17
xdisp		equ $18
prio		equ $19
frame		equ $1A
anipos		equ $1B
ani		equ $1C
anilast		equ $1D
anidelay	equ $1E
col		equ $20
colprop		equ $21
status		equ $22
respawn		equ $23
act		equ $24
subact		equ $25
angle		equ $26
arg		equ $28
size		equ $40

; ---------------------------------------------------------------------------

; enum player, width 64 bytes
inertia		equ $14
air		equ $20
invulnerable	equ $30
invincible	equ $32
speedshoes	equ $34
sensorfront	equ $36
sensorback	equ $37
convex		equ $38
jumping		equ $3C
platform	equ $3D
lock		equ $3E

; ---------------------------------------------------------------------------

; Taken from plutiedev.com for some convience
VRAM_ADDR_CMD:  equ $40000000
CRAM_ADDR_CMD:  equ $C0000000
VSRAM_ADDR_CMD: equ $40000010

VRAM_DMA_CMD:   equ $40000080
CRAM_DMA_CMD:   equ $C0000080
VSRAM_DMA_CMD:  equ $40000090

; VDP addressses
vdp_data_port:		equ $C00000
vdp_control_port:	equ $C00004
vdp_counter:		equ $C00008

psg_input:		equ $C00011

; Z80 addresses
z80_ram:		equ $A00000			; start of Z80 RAM
z80_dac3_pitch:		equ $A00183
z80_dac_noupdate:	equ $A01FF6
z80_dac_status:		equ $A01FFD
z80_dac_sample:		equ $A01FFF
z80_ram_end:		equ $A02000			; end of non-reserved Z80 RAM
z80_version:		equ $A10001
z80_port_1_data:	equ $A10002
z80_port_1_control:	equ $A10008
z80_port_2_control:	equ $A1000A
z80_expansion_control:	equ $A1000C
z80_bus_request:	equ $A11100
z80_reset:		equ $A11200
ym2612_a0:		equ $A04000
ym2612_d0:		equ $A04001
ym2612_a1:		equ $A04002
ym2612_d1:		equ $A04003

security_addr:		equ $A14000

; Sound driver constants
TrackPlaybackControl:	equ 0				; All tracks
TrackVoiceControl:	equ 1				; All tracks
TrackTempoDivider:	equ 2				; All tracks
TrackDataPointer:	equ 4				; All tracks (4 bytes)
TrackTranspose:		equ 8				; FM/PSG only (sometimes written to as a word, to include TrackVolume)
TrackVolume:		equ 9				; FM/PSG only
TrackAMSFMSPan:		equ $A				; FM/DAC only
TrackVoiceIndex:	equ $B				; FM/PSG only
TrackVolEnvIndex:	equ $C				; PSG only
TrackStackPointer:	equ $D				; All tracks
TrackDurationTimeout:	equ $E				; All tracks
TrackSavedDuration:	equ $F				; All tracks
TrackSavedDAC:		equ $10				; DAC only
TrackFreq:		equ $10				; FM/PSG only (2 bytes)
TrackNoteTimeout:	equ $12				; FM/PSG only
TrackNoteTimeoutMaster:equ $13				; FM/PSG only
TrackModulationPtr:	equ $14				; FM/PSG only (4 bytes)
TrackModulationWait:	equ $18				; FM/PSG only
TrackModulationSpeed:	equ $19				; FM/PSG only
TrackModulationDelta:	equ $1A				; FM/PSG only
TrackModulationSteps:	equ $1B				; FM/PSG only
TrackModulationVal:	equ $1C				; FM/PSG only (2 bytes)
TrackDetune:		equ $1E				; FM/PSG only
TrackPSGNoise:		equ $1F				; PSG only
TrackFeedbackAlgo:	equ $1F				; FM only
TrackVoicePtr:		equ $20				; FM SFX only (4 bytes)
TrackLoopCounters:	equ $24				; All tracks (multiple bytes)
TrackGoSubStack:	equ TrackSz			; All tracks (multiple bytes. This constant won't get to be used because of an optimisation that just uses TrackSz)

TrackSz:	equ $30

; VRAM data
vram_fg:	equ $C000				; foreground namespace
vram_bg:	equ $E000				; background namespace
vram_sonic:	equ $F000				; Sonic graphics
vram_sprites:	equ $F800				; sprite table
vram_hscroll:	equ $FC00				; horizontal scroll table

; Background music
bgm__First:	equ $81
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
sfx__First:	equ $A0
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
spec__First:	equ $D0
sfx_Waterfall:	equ ((ptr_sndD0-SpecSoundIndex)/4)+spec__First
sfx_Loud_Waterfall:	equ ((ptr_sndD1-SpecSoundIndex)/4)+spec__First
sfx_Pounding:	equ ((ptr_sndD2-SpecSoundIndex)/4)+spec__First
spec__Last:	equ ((ptr_specend-SpecSoundIndex-4)/4)+spec__First

flg__First:	equ $E0
bgm_Fade:	equ ((ptr_flgE0-Sound_ExIndex)/4)+flg__First
bgm_Stop:	equ ((ptr_flgE1-Sound_ExIndex)/4)+flg__First
bgm_Speedup:	equ ((ptr_flgE2-Sound_ExIndex)/4)+flg__First
bgm_Slowdown:	equ ((ptr_flgE3-Sound_ExIndex)/4)+flg__First
bgm_StopSpec:	equ ((ptr_flgE4-Sound_ExIndex)/4)+flg__First
flg__Last:	equ ((ptr_flgend-Sound_ExIndex-4)/4)+flg__First
