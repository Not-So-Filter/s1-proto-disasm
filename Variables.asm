; Variables (v) and Flags (f)

ObSize = $40 ; size for each object variables

v_256x256:	        equ  $FFFF0000			; 256x256 tile mappings ($A400 bytes)
v_lvllayout:	        equ  $FFFFA400
v_bgscroll_buffer:      equ  $FFFFA800
v_ngfx_buffer:          equ  $FFFFAA00
v_spritequeue:	        equ  $FFFFAC00
v_16x16:	        equ  $FFFFB000			; 16x16 tile mappings ($1800 bytes)
v_sgfx_buffer:	        equ  $FFFFC800			; sonic graphics ram buffer ($300 bytes)
v_tracksonic:	        equ  $FFFFCB00			; sonic position table ($100 bytes)
v_hscrolltablebuffer:   equ  $FFFFCC00
v_objspace:	        equ  $FFFFD000			; RAM for object space ($600 bytes)
f_victory:	        equ  $FFFFD600			; flag for victory animation
LevelObjectsList:       equ  $FFFFD800

; $FFFFF000
v_snddriver_ram:        equ  $FFFFF000			; start of RAM for the sound driver data ($600 bytes)

; =================================================================================
; From here on, until otherwise stated, all offsets are relative to v_snddriver_ram
; =================================================================================
v_startofvariables:	equ $000
v_sndprio:		equ $000			; sound priority (priority of new music/SFX must be higher or equal to this value or it won't play; bit 7 of priority being set prevents this value from changing)
v_main_tempo_timeout:	equ $001			; Counts down to zero; when zero, resets to next value and delays song by 1 frame
v_main_tempo:		equ $002			; Used for music only
f_pausemusic:		equ $003			; flag set to stop music when paused
v_fadeout_counter:	equ $004

v_fadeout_delay:	equ $006
v_communication_byte:	equ $007			; used in Ristar to sync with a boss' attacks; unused here
f_updating_dac:		equ $008			; $80 if updating DAC, $00 otherwise
v_sound_id:		equ $009			; sound or music copied from below
v_soundqueue0:		equ $00A			; sound or music to play
v_soundqueue1:		equ $00B			; special sound to play
v_soundqueue2:		equ $00C			; unused sound to play

f_voice_selector:	equ $00E			; $00 = use music voice pointer; $40 = use special voice pointer; $80 = use track voice pointer

v_voice_ptr:		equ $018			; voice data pointer (4 bytes)

v_special_voice_ptr:	equ $020			; voice data pointer for special SFX ($D0-$DF) (4 bytes)

f_fadein_flag:		equ $024			; Flag for fade in
v_fadein_delay:		equ $025
v_fadein_counter:	equ $026			; Timer for fade in/out
f_1up_playing:		equ $027			; flag indicating 1-up song is playing
v_tempo_mod:		equ $028			; music - tempo modifier
v_speeduptempo:		equ $029			; music - tempo modifier with speed shoes
f_speedup:		equ $02A			; flag indicating whether speed shoes tempo is on ($80) or off ($00)
v_ring_speaker:		equ $02B			; which speaker the "ring" sound is played in (00 = right; 01 = left)
f_push_playing:		equ $02C			; if set, prevents further push sounds from playing

v_music_track_ram:	equ $040			; Start of music RAM

v_music_fmdac_tracks:	equ v_music_track_ram+TrackSz*0
v_music_dac_track:	equ v_music_fmdac_tracks+TrackSz*0
v_music_fm_tracks:	equ v_music_fmdac_tracks+TrackSz*1
v_music_fm1_track:	equ v_music_fm_tracks+TrackSz*0
v_music_fm2_track:	equ v_music_fm_tracks+TrackSz*1
v_music_fm3_track:	equ v_music_fm_tracks+TrackSz*2
v_music_fm4_track:	equ v_music_fm_tracks+TrackSz*3
v_music_fm5_track:	equ v_music_fm_tracks+TrackSz*4
v_music_fm6_track:	equ v_music_fm_tracks+TrackSz*5
v_music_fm_tracks_end:	equ v_music_fm_tracks+TrackSz*6
v_music_fmdac_tracks_end:	equ v_music_fm_tracks_end
v_music_psg_tracks:	equ v_music_fmdac_tracks_end
v_music_psg1_track:	equ v_music_psg_tracks+TrackSz*0
v_music_psg2_track:	equ v_music_psg_tracks+TrackSz*1
v_music_psg3_track:	equ v_music_psg_tracks+TrackSz*2
v_music_psg_tracks_end:	equ v_music_psg_tracks+TrackSz*3
v_music_track_ram_end:	equ v_music_psg_tracks_end

v_sfx_track_ram:	equ v_music_track_ram_end	; Start of SFX RAM, straight after the end of music RAM

v_sfx_fm_tracks:	equ v_sfx_track_ram+TrackSz*0
v_sfx_fm3_track:	equ v_sfx_fm_tracks+TrackSz*0
v_sfx_fm4_track:	equ v_sfx_fm_tracks+TrackSz*1
v_sfx_fm5_track:	equ v_sfx_fm_tracks+TrackSz*2
v_sfx_fm_tracks_end:	equ v_sfx_fm_tracks+TrackSz*3
v_sfx_psg_tracks:	equ v_sfx_fm_tracks_end
v_sfx_psg1_track:	equ v_sfx_psg_tracks+TrackSz*0
v_sfx_psg2_track:	equ v_sfx_psg_tracks+TrackSz*1
v_sfx_psg3_track:	equ v_sfx_psg_tracks+TrackSz*2
v_sfx_psg_tracks_end:	equ v_sfx_psg_tracks+TrackSz*3
v_sfx_track_ram_end:	equ v_sfx_psg_tracks_end

v_spcsfx_track_ram:	equ v_sfx_track_ram_end		; Start of special SFX RAM, straight after the end of SFX RAM

v_spcsfx_fm4_track:	equ v_spcsfx_track_ram+TrackSz*0
v_spcsfx_psg3_track:	equ v_spcsfx_track_ram+TrackSz*1
v_spcsfx_track_ram_end:	equ v_spcsfx_track_ram+TrackSz*2

v_1up_ram_copy:		equ v_spcsfx_track_ram_end

; =================================================================================
; From here on, no longer relative to sound driver RAM
; =================================================================================

v_gamemode:             equ  $FFFFF600
v_jpadhold2:	        equ  $FFFFF602
v_jpadpress2:	        equ  $FFFFF603
v_jpadhold1:	        equ  $FFFFF604
v_jpadpress1:	        equ  $FFFFF605
v_vdp_buffer1:	        equ  $FFFFF60C
v_demolength:	        equ  $FFFFF614
v_scrposy_dup:	        equ  $FFFFF616
v_bgscrposy_dup:	equ  $FFFFF618			; background screen position y (duplicate) (2 bytes)
v_scrposx_dup:	        equ  $FFFFF61A
v_bgscreenposx_dup:	equ  $FFFFF61C			; background screen position x (duplicate) (2 bytes)
word_FFF61E:	        equ  $FFFFF61E
word_FFF620:	        equ  $FFFFF620
word_FFF622:	        equ  $FFFFF622
v_hbla_hreg:	        equ  $FFFFF624			; VDP H.interrupt register buffer (8Axx)
v_hbla_line:	        equ  $FFFFF625			; screen line where water starts and palette is changed by HBlank
v_pfade_start:	        equ  $FFFFF626			; palette fading - start position in bytes
v_pfade_size:	        equ  $FFFFF627			; palette fading - number of colours
byte_FFF628:	        equ  $FFFFF628
byte_FFF629:	        equ  $FFFFF629
VBlankRoutine:	        equ  $FFFFF62A
byte_FFF62C:	        equ  $FFFFF62C
word_FFF632:	        equ  $FFFFF632
word_FFF634:	        equ  $FFFFF634
RandomSeed:	        equ  $FFFFF636
f_pause:	        equ  $FFFFF63A
v_vdp_buffer2:	        equ  $FFFFF644
word_FFF648:	        equ  $FFFFF648
f_water:	        equ  $FFFFF64C
word_FFF660:	        equ  $FFFFF660
word_FFF662:	        equ  $FFFFF662
word_FFF666:	        equ  $FFFFF666
LevSelOption:	        equ  $FFFFF668
LevSelSound:	        equ  $FFFFF66A
plcList:	        equ  $FFFFF680
unk_FFF6E0:	        equ  $FFFFF6E0
unk_FFF6E4:	        equ  $FFFFF6E4
unk_FFF6E8:	        equ  $FFFFF6E8
unk_FFF6EC:	        equ  $FFFFF6EC
unk_FFF6F0:	        equ  $FFFFF6F0
unk_FFF6F4:	        equ  $FFFFF6F4
unk_FFF6F8:	        equ  $FFFFF6F8
unk_FFF6FA:	        equ  $FFFFF6FA
v_screenposx:	        equ  $FFFFF700
v_screenposy:	        equ  $FFFFF704
v_bgscreenposx:	        equ  $FFFFF708
v_bgscreenposy:	        equ  $FFFFF70C
v_bg2screenposx:	equ  $FFFFF710
v_bg2screenposy:	equ  $FFFFF714
v_bg3screenposx:	equ  $FFFFF718
v_bg3screenposy:	equ  $FFFFF71C
unk_FFF720:	        equ  $FFFFF720
unk_FFF724:	        equ  $FFFFF724
unk_FFF726:	        equ  $FFFFF726
unk_FFF728:	        equ  $FFFFF728
unk_FFF72A:	        equ  $FFFFF72A
unk_FFF72C:	        equ  $FFFFF72C
unk_FFF72E:	        equ  $FFFFF72E
unk_FFF730:	        equ  $FFFFF730
unk_FFF732:	        equ  $FFFFF732
unk_FFF73A:	        equ  $FFFFF73A
unk_FFF73C:	        equ  $FFFFF73C
unk_FFF73E:	        equ  $FFFFF73E
f_res_hscroll:	        equ  $FFFFF740
f_res_vscroll:	        equ  $FFFFF741
EventsRoutine:	        equ  $FFFFF742
f_nobgscroll:	        equ  $FFFFF744
unk_FFF746:	        equ  $FFFFF746
unk_FFF748:	        equ  $FFFFF748
unk_FFF74A:	        equ  $FFFFF74A
unk_FFF74B:	        equ  $FFFFF74B
unk_FFF74C:	        equ  $FFFFF74C
unk_FFF74D:	        equ  $FFFFF74D
unk_FFF74E:	        equ  $FFFFF74E
unk_FFF754:	        equ  $FFFFF754
unk_FFF756:	        equ  $FFFFF756
unk_FFF758:	        equ  $FFFFF758
unk_FFF75C:	        equ  $FFFFF75C
unk_FFF760:	        equ  $FFFFF760
unk_FFF762:	        equ  $FFFFF762
unk_FFF764:	        equ  $FFFFF764
unk_FFF766:	        equ  $FFFFF766
f_sonframechg:	        equ  $FFFFF767
unk_FFF768:	        equ  $FFFFF768
unk_FFF76A:	        equ  $FFFFF76A
unk_FFF76C:	        equ  $FFFFF76C
unk_FFF76E:	        equ  $FFFFF76E
unk_FFF770:	        equ  $FFFFF770
unk_FFF774:	        equ  $FFFFF774
unk_FFF778:	        equ  $FFFFF778
unk_FFF77C:	        equ  $FFFFF77C
unk_FFF780:	        equ  $FFFFF780
unk_FFF782:	        equ  $FFFFF782
unk_FFF783:	        equ  $FFFFF783
unk_FFF790:	        equ  $FFFFF790
unk_FFF792:	        equ  $FFFFF792
unk_FFF794:	        equ  $FFFFF794
v_collindex:	        equ  $FFFFF796
unk_FFF79A:	        equ  $FFFFF79A
unk_FFF79C:	        equ  $FFFFF79C
unk_FFF79E:	        equ  $FFFFF79E
unk_FFF7A0:	        equ  $FFFFF7A0
unk_FFF7A4:	        equ  $FFFFF7A4
unk_FFF7A7:	        equ  $FFFFF7A7
unk_FFF7A8:	        equ  $FFFFF7A8
unk_FFF7A9:	        equ  $FFFFF7A9
unk_FFF7AA:	        equ  $FFFFF7AA
unk_FFF7AC:	        equ  $FFFFF7AC
unk_FFF7AD:	        equ  $FFFFF7AD
unk_FFF7AE:	        equ  $FFFFF7AE
unk_FFF7AF:	        equ  $FFFFF7AF
unk_FFF7B0:	        equ  $FFFFF7B0
unk_FFF7B1:	        equ  $FFFFF7B1
unk_FFF7B2:	        equ  $FFFFF7B2
unk_FFF7B3:	        equ  $FFFFF7B3
unk_FFF7B4:	        equ  $FFFFF7B4
unk_FFF7B5:	        equ  $FFFFF7B5
unk_FFF7B6:	        equ  $FFFFF7B6
unk_FFF7E0:	        equ  $FFFFF7E0
unk_FFF7EF:	        equ  $FFFFF7EF
unk_FFF7F0:	        equ  $FFFFF7F0
v_spritetablebuffer:	equ  $FFFFF800
v_pal_dry:	        equ  $FFFFFB00
v_pal_dry_dup:	        equ  $FFFFFB80
v_regbuffer:	        equ  $FFFFFC00
v_spbuffer:	        equ  $FFFFFC40			; stores most recent sp address (4 bytes)
v_errortype:	        equ  $FFFFFC44			; error type
v_systemstack:	        equ  $FFFFFE00
LevelRestart:	        equ  $FFFFFE02
LevelFrames:	        equ  $FFFFFE04
v_debugitem:	        equ  $FFFFFE06
DebugRoutine:	        equ  $FFFFFE08
v_debugxspeed:	        equ  $FFFFFE0A
v_debugyspeed:	        equ  $FFFFFE0B
unk_FFFE0C:	        equ  $FFFFFE0C
byte_FFFE0F:	        equ  $FFFFFE0F
v_zone:	                equ  $FFFFFE10
v_act:		        equ  $FFFFFE11
v_lives:	        equ  $FFFFFE12
byte_FFFE1B:	        equ  $FFFFFE1B
byte_FFFE1C:	        equ  $FFFFFE1C
f_extralife:	        equ  $FFFFFE1D
f_timecount:	        equ  $FFFFFE1E
byte_FFFE1F:	        equ  $FFFFFE1F
v_rings:	        equ  $FFFFFE20
v_time:	                equ  $FFFFFE22
v_score:	        equ  $FFFFFE26
v_shield:	        equ  $FFFFFE2C
v_invinc:	        equ  $FFFFFE2D
v_shoes:	        equ  $FFFFFE2E
byte_FFFE2F:	        equ  $FFFFFE2F
unk_FFFE50:	        equ  $FFFFFE50
word_FFFE54:	        equ  $FFFFFE54
word_FFFE56:	        equ  $FFFFFE56
byte_FFFE58:	        equ  $FFFFFE58
oscValues:	        equ  $FFFFFE5E
unk_FFFEC0:	        equ  $FFFFFEC0
unk_FFFEC1:	        equ  $FFFFFEC1
RingTimer:	        equ  $FFFFFEC2
RingFrame:	        equ  $FFFFFEC3
unk_FFFEC4:	        equ  $FFFFFEC4
unk_FFFEC5:	        equ  $FFFFFEC5
RingLossTimer:	        equ  $FFFFFEC6
RingLossFrame:	        equ  $FFFFFEC7
RingLossAccumulator:    equ  $FFFFFEC8
word_FFFFE0:	        equ  $FFFFFFE0
word_FFFFE8:	        equ  $FFFFFFE8
DemoMode:	        equ  $FFFFFFF0
DemoNum:	        equ  $FFFFFFF2
v_megadrive:	        equ  $FFFFFFF8
f_debugmode:	        equ  $FFFFFFFA
ChecksumStr:	        equ  $FFFFFFFC
