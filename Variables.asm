; Variables (v) and Flags (f)

v_256x256:		equ  $FF0000			; 256x256 tile mappings ($A400 bytes)
v_lvllayout:		equ  $FFFFA400
v_lvllayoutbg:		equ  v_lvllayout+layoutsize
layoutsize:		equ  $40

v_bgscroll_buffer:	equ  $FFFFA800
v_ngfx_buffer:		equ  $FFFFAA00
v_spritequeue:		equ  $FFFFAC00
v_16x16:		equ  $FFFFB000			; 16x16 tile mappings ($1800 bytes)
v_sgfx_buffer:		equ  $FFFFC800			; sonic graphics ram buffer ($300 bytes)
v_tracksonic:		equ  $FFFFCB00			; sonic position table ($100 bytes)
v_hscrolltablebuffer:	equ  $FFFFCC00
v_player:		equ  $FFFFD000
v_objspace:		equ  $FFFFD000			; RAM for object space ($600 bytes)
f_victory:		equ  $FFFFD600			; flag for victory animation
v_lvlobjspace:		equ  $FFFFD800

; $FFFFF000
v_snddriver_ram:	equ  $FFFFF000			; start of RAM for the sound driver data ($600 bytes)

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

v_gamemode:		equ $FFFFF600
v_jpadhold2:		equ $FFFFF602
v_jpadpress2:		equ $FFFFF603
v_jpadhold1:		equ $FFFFF604
v_jpadpress1:		equ $FFFFF605
v_vdp_buffer1:		equ $FFFFF60C
v_demolength:		equ $FFFFF614
v_scrposy_dup:		equ $FFFFF616
v_bgscrposy_dup:	equ $FFFFF618	; background screen position y (duplicate) (2 bytes)
v_scrposx_dup:		equ $FFFFF61A
v_bgscreenposx_dup:	equ $FFFFF61C	; background screen position x (duplicate) (2 bytes)
v_bg3scrposy_vdp:	equ $FFFFF61E
v_bg3scrposx_vdp:	equ $FFFFF620
v_bg3scrposy_vdp_dup:	equ $FFFFF622
v_hbla_hreg:		equ $FFFFF624	; VDP H.interrupt register buffer (8Axx)
v_hbla_line:		equ $FFFFF625	; screen line where water starts and palette is changed by HBlank
v_pfade_start:		equ $FFFFF626	; palette fading - start position in bytes
v_pfade_size:		equ $FFFFF627	; palette fading - number of colours
byte_FFF628:		equ $FFFFF628
byte_FFF629:		equ $FFFFF629
v_vbla_routine:		equ $FFFFF62A
v_spritecount:		equ $FFFFF62C
v_pcyc_num:		equ $FFFFF632	; palette cycling - current reference number (2 bytes)
v_pcyc_time:		equ $FFFFF634	; palette cycling - time until the next change (2 bytes)
v_random:		equ $FFFFF636
f_pause:		equ $FFFFF63A
v_vdp_buffer2:		equ $FFFFF644
f_hblank:		equ $FFFFF648
f_water:		equ $FFFFF64C
v_pal_buffer:		equ $FFFFF650	; palette data buffer (used for palette cycling) ($30 bytes)
v_levseldelay:		equ $FFFFF666	; level select - time until change when up/down is held (2 bytes)
v_levselitem:		equ $FFFFF668	; level select - item selected (2 bytes)
v_levselsound:		equ $FFFFF66A	; level select - sound selected (2 bytes)
v_plc_buffer:		equ $FFFFF680	; pattern load cues buffer (maximum $10 PLCs) ($60 bytes)
v_ptrnemcode:		equ $FFFFF6E0	; pointer for nemesis decompression code ($1502 or $150C) (4 bytes)
unk_FFF6E4:		equ $FFFFF6E4
unk_FFF6E8:		equ $FFFFF6E8
unk_FFF6EC:		equ $FFFFF6EC
unk_FFF6F0:		equ $FFFFF6F0
unk_FFF6F4:		equ $FFFFF6F4
f_plc_execute:		equ $FFFFF6F8	; flag set for pattern load cue execution (2 bytes)
unk_FFF6FA:		equ $FFFFF6FA
v_screenposx:		equ $FFFFF700
v_screenposy:		equ $FFFFF704
v_bgscreenposx:		equ $FFFFF708
v_bgscreenposy:		equ $FFFFF70C
v_bg2screenposx:	equ $FFFFF710
v_bg2screenposy:	equ $FFFFF714
v_bg3screenposx:	equ $FFFFF718
v_bg3screenposy:	equ $FFFFF71C
v_limitleft1:		equ $FFFFF720
v_limittop1:		equ $FFFFF724
v_limitbtm1:		equ $FFFFF726
v_limitleft2:		equ $FFFFF728
v_limitright2:		equ $FFFFF72A
v_limittop2:		equ $FFFFF72C
v_limitbtm2:		equ $FFFFF72E
unk_FFF730:		equ $FFFFF730
v_limitleft3:		equ $FFFFF732
v_scrshiftx:		equ $FFFFF73A
v_scrshifty:		equ $FFFFF73C
unk_FFF73E:		equ $FFFFF73E
f_res_hscroll:		equ $FFFFF740
f_res_vscroll:		equ $FFFFF741
v_dle_routine:		equ $FFFFF742
f_nobgscroll:		equ $FFFFF744
unk_FFF746:		equ $FFFFF746
unk_FFF748:		equ $FFFFF748
v_fg_xblock:		equ $FFFFF74A
v_fg_yblock:		equ $FFFFF74B
v_bg1_xblock:		equ $FFFFF74C
v_bg1_yblock:		equ $FFFFF74D
v_bg2_xblock:		equ $FFFFF74E
v_fg_scroll_flags:	equ $FFFFF754
v_bg1_scroll_flags:	equ $FFFFF756
v_bg2_scroll_flags:	equ $FFFFF758
f_bgscrollvert:		equ $FFFFF75C
v_sonspeedmax:		equ $FFFFF760
v_sonspeedacc:		equ $FFFFF762
v_sonspeeddec:		equ $FFFFF764
v_sonframenum:		equ $FFFFF766	; frame to display for Sonic
f_sonframechg:		equ $FFFFF767
v_anglebuffer:		equ $FFFFF768
unk_FFF76A:		equ $FFFFF76A
v_opl_routine:		equ $FFFFF76C	; ObjPosLoad - routine counter (2 bytes)
v_opl_screen:		equ $FFFFF76E	; ObjPosLoad - screen variable (2 bytes)
v_opl_data:		equ $FFFFF770	; ObjPosLoad - data buffer ($10 bytes)
v_ssangle:		equ $FFFFF780	; Special Stage angle (2 bytes)
v_ssrotate:		equ $FFFFF782	; Special Stage rotation speed (2 bytes)
v_btnpushtime1:		equ $FFFFF790
v_btnpushtime2:		equ $FFFFF792
v_palchgspeed:		equ $FFFFF794
v_collindex:		equ $FFFFF796
v_palss_num:		equ $FFFFF79A
v_palss_time:		equ $FFFFF79C
unk_FFF79E:		equ $FFFFF79E
unk_FFF7A0:		equ $FFFFF7A0
v_obj31ypos:		equ $FFFFF7A4	; y-position of object 31 (MZ stomper) (2 bytes)
v_bossstatus:		equ $FFFFF7A7
v_trackpos:		equ $FFFFF7A8
v_trackbyte:		equ $FFFFF7A9
f_lockscreen:		equ $FFFFF7AA
unk_FFF7AC:		equ $FFFFF7AC
unk_FFF7AD:		equ $FFFFF7AD
unk_FFF7AE:		equ $FFFFF7AE
unk_FFF7AF:		equ $FFFFF7AF
v_lani0_frame:		equ $FFFFF7B0
v_lani0_time:		equ $FFFFF7B1
v_lani1_frame:		equ $FFFFF7B2
v_lani1_time:		equ $FFFFF7B3
v_lani2_frame:		equ $FFFFF7B4
v_lani2_time:		equ $FFFFF7B5
v_lani3_frame:		equ $FFFFF7B6
f_switch:		equ $FFFFF7E0
v_scroll_block_1_size:	equ $FFFFF7F0
v_spritetablebuffer:	equ $FFFFF800
v_pal_dry:		equ $FFFFFB00
v_pal_dry_dup:		equ $FFFFFB80
v_regbuffer:		equ $FFFFFC00
v_spbuffer:		equ $FFFFFC40	; stores most recent sp address (4 bytes)
v_errortype:		equ $FFFFFC44	; error type
v_systemstack:		equ $FFFFFE00
f_restart:		equ $FFFFFE02	; restart level flag (2 bytes)
v_framecount:		equ $FFFFFE04	; frame counter (adds 1 every frame) (2 bytes)
v_framebyte:		equ v_framecount+1 ; low byte for frame counter
v_debugitem:		equ $FFFFFE06
v_debuguse:		equ $FFFFFE08
v_debugxspeed:		equ $FFFFFE0A
v_debugyspeed:		equ $FFFFFE0B
v_vbla_count:		equ $FFFFFE0C
v_vbla_word:		equ v_vbla_count+2 ; low word for vertical interrupt counter (2 bytes)
v_vbla_byte:		equ v_vbla_word+1	; low byte for vertical interrupt counter
v_zone:			equ $FFFFFE10
v_act:			equ $FFFFFE11
v_lives:		equ $FFFFFE12
v_lifecount:		equ $FFFFFE1B	; lives counter value (for actual number, see "v_lives")
f_lifecount:		equ $FFFFFE1C	; lives counter update flag
f_extralife:		equ $FFFFFE1D
f_timecount:		equ $FFFFFE1E
f_scorecount:		equ $FFFFFE1F	; score counter update flag
v_rings:		equ $FFFFFE20
v_ringbyte:		equ v_rings+1	; low byte for rings
v_time:			equ $FFFFFE22
v_timemin:		equ v_time+1	; time - minutes
v_timesec:		equ v_time+2	; time - seconds
v_score:		equ $FFFFFE26
v_shield:		equ $FFFFFE2C
v_invinc:		equ $FFFFFE2D
v_shoes:		equ $FFFFFE2E
byte_FFFE2F:		equ $FFFFFE2F
v_scorecopy:		equ $FFFFFE50
v_timebonus:		equ $FFFFFE54
v_ringbonus:		equ $FFFFFE56
f_endactbonus:		equ $FFFFFE58
v_oscillate:		equ $FFFFFE5E
v_ani0_time:		equ $FFFFFEC0	; synchronised sprite animation 0 - time until next frame (used for synchronised animations)
v_ani0_frame:		equ $FFFFFEC1	; synchronised sprite animation 0 - current frame
v_ani1_time:		equ $FFFFFEC2	; synchronised sprite animation 1 - time until next frame
v_ani1_frame:		equ $FFFFFEC3	; synchronised sprite animation 1 - current frame
v_ani2_time:		equ $FFFFFEC4	; synchronised sprite animation 2 - time until next frame
v_ani2_frame:		equ $FFFFFEC5	; synchronised sprite animation 2 - current frame
v_ani3_time:		equ $FFFFFEC6	; synchronised sprite animation 3 - time until next frame
v_ani3_frame:		equ $FFFFFEC7	; synchronised sprite animation 3 - current frame
v_ani3_buf:		equ $FFFFFEC8	; synchronised sprite animation 3 - info buffer (2 bytes)
word_FFFFE0:		equ $FFFFFFE0	; value that's set to 1 during initation, unused elsewhere (2 bytes)
word_FFFFE8:		equ $FFFFFFE8
DemoMode:		equ $FFFFFFF0
DemoNum:		equ $FFFFFFF2
v_megadrive:		equ $FFFFFFF8
f_debugmode:		equ $FFFFFFFA
v_init:			equ $FFFFFFFC	; 'init' text string (4 bytes)