; Variables (v) and Flags (f)

v_256x256:		=  $FF0000		; 256x256 tile mappings ($A400 bytes)
layoutsize:		=  $40
v_lvllayout:		=  $FFFFA400
v_lvllayoutbg:		=  v_lvllayout+layoutsize

v_bgscroll_buffer:	=  $FFFFA800
v_ngfx_buffer:		=  $FFFFAA00
v_spritequeue:		=  $FFFFAC00
v_16x16:		=  $FFFFB000		; 16x16 tile mappings ($1800 bytes)
v_sgfx_buffer:		=  $FFFFC800		; sonic graphics ram buffer ($300 bytes)
v_tracksonic:		=  $FFFFCB00		; sonic position table ($100 bytes)
v_hscrolltablebuffer:	=  $FFFFCC00
v_player:		=  $FFFFD000
v_objspace:		=  $FFFFD000		; RAM for object space ($600 bytes)
f_victory:		=  $FFFFD600		; flag for victory animation
v_lvlobjspace:		=  $FFFFD800

; $FFFFF000
v_snddriver_ram:	=  $FFFFF000		; start of RAM for the sound driver data ($600 bytes)

; =================================================================================
; From here on, until otherwise stated, all offsets are relative to v_snddriver_ram
; =================================================================================

	rsset 0
v_startofvariables:	= *
v_sndprio:		rs.b 1			; sound priority (priority of new music/SFX must be higher or =al to this value or it won't play; bit 7 of priority being set prevents this value from changing)
v_main_tempo_timeout:	rs.b 1			; Counts down to zero; when zero, resets to next value and delays song by 1 frame
v_main_tempo:		rs.b 1			; Used for music only
f_pausemusic:		rs.b 1			; flag set to stop music when paused
v_fadeout_counter:	rs.b 1
		rs.b 1				; unused
v_fadeout_delay:	rs.b 1
v_communication_byte:	rs.b 1			; used in Ristar to sync with a boss' attacks; unused here
f_updating_dac:		rs.b 1			; $80 if updating DAC, $00 otherwise
v_sound_id:		rs.b 1			; sound or music copied from below
v_soundqueue0:		rs.b 1			; sound or music to play
v_soundqueue1:		rs.b 1			; special sound to play
v_soundqueue2:		rs.b 1			; unused sound to play
		rs.b 1				; unused
f_voice_selector:	rs.b 10			; $00 = use music voice pointer; $40 = use special voice pointer; $80 = use track voice pointer

v_voice_ptr:		rs.l 1			; voice data pointer (4 bytes)
		rs.l 1				; unused voice data pointer (4 bytes)
v_special_voice_ptr:	rs.l 1			; voice data pointer for special SFX ($D0-$DF) (4 bytes)

f_fadein_flag:		rs.b 1			; Flag for fade in
v_fadein_delay:		rs.b 1
v_fadein_counter:	rs.b 1			; Timer for fade in/out
f_1up_playing:		rs.b 1			; flag indicating 1-up song is playing
v_tempo_mod:		rs.b 1			; music - tempo modifier
v_speeduptempo:		rs.b 1			; music - tempo modifier with speed shoes
f_speedup:		rs.b 1			; flag indicating whether speed shoes tempo is on ($80) or off ($00)
v_ring_speaker:		rs.b 1			; which speaker the "ring" sound is played in (00 = right; 01 = left)
f_push_playing:		rs.b 1			; if set, prevents further push sounds from playing
	rsreset

v_music_track_ram:	= $040			; Start of music RAM

v_music_fmdac_tracks:	= v_music_track_ram+TrackSz*0
v_music_dac_track:	= v_music_fmdac_tracks+TrackSz*0
v_music_fm_tracks:	= v_music_fmdac_tracks+TrackSz*1
v_music_fm1_track:	= v_music_fm_tracks+TrackSz*0
v_music_fm2_track:	= v_music_fm_tracks+TrackSz*1
v_music_fm3_track:	= v_music_fm_tracks+TrackSz*2
v_music_fm4_track:	= v_music_fm_tracks+TrackSz*3
v_music_fm5_track:	= v_music_fm_tracks+TrackSz*4
v_music_fm6_track:	= v_music_fm_tracks+TrackSz*5
v_music_fm_tracks_end:	= v_music_fm_tracks+TrackSz*6
v_music_fmdac_tracks_end:	= v_music_fm_tracks_end
v_music_psg_tracks:	= v_music_fmdac_tracks_end
v_music_psg1_track:	= v_music_psg_tracks+TrackSz*0
v_music_psg2_track:	= v_music_psg_tracks+TrackSz*1
v_music_psg3_track:	= v_music_psg_tracks+TrackSz*2
v_music_psg_tracks_end:	= v_music_psg_tracks+TrackSz*3
v_music_track_ram_end:	= v_music_psg_tracks_end

v_sfx_track_ram:	= v_music_track_ram_end	; Start of SFX RAM, straight after the end of music RAM

v_sfx_fm_tracks:	= v_sfx_track_ram+TrackSz*0
v_sfx_fm3_track:	= v_sfx_fm_tracks+TrackSz*0
v_sfx_fm4_track:	= v_sfx_fm_tracks+TrackSz*1
v_sfx_fm5_track:	= v_sfx_fm_tracks+TrackSz*2
v_sfx_fm_tracks_end:	= v_sfx_fm_tracks+TrackSz*3
v_sfx_psg_tracks:	= v_sfx_fm_tracks_end
v_sfx_psg1_track:	= v_sfx_psg_tracks+TrackSz*0
v_sfx_psg2_track:	= v_sfx_psg_tracks+TrackSz*1
v_sfx_psg3_track:	= v_sfx_psg_tracks+TrackSz*2
v_sfx_psg_tracks_end:	= v_sfx_psg_tracks+TrackSz*3
v_sfx_track_ram_end:	= v_sfx_psg_tracks_end

v_spcsfx_track_ram:	= v_sfx_track_ram_end		; Start of special SFX RAM, straight after the end of SFX RAM

v_spcsfx_fm4_track:	= v_spcsfx_track_ram+TrackSz*0
v_spcsfx_psg3_track:	= v_spcsfx_track_ram+TrackSz*1
v_spcsfx_track_ram_end:	= v_spcsfx_track_ram+TrackSz*2

v_1up_ram_copy:		= v_spcsfx_track_ram_end

; =================================================================================
; From here on, no longer relative to sound driver RAM
; =================================================================================

v_gamemode:		= $FFFFF600
v_jpadhold2:		= $FFFFF602
v_jpadpress2:		= $FFFFF603
v_jpadhold1:		= $FFFFF604
v_jpadpress1:		= $FFFFF605
v_vdp_buffer1:		= $FFFFF60C
v_demolength:		= $FFFFF614
v_scrposy_dup:		= $FFFFF616
v_bgscrposy_dup:	= $FFFFF618	; background screen position y (duplicate) (2 bytes)
v_scrposx_dup:		= $FFFFF61A
v_bgscreenposx_dup:	= $FFFFF61C	; background screen position x (duplicate) (2 bytes)
v_bg3scrposy_vdp:	= $FFFFF61E
v_bg3scrposx_vdp:	= $FFFFF620
v_bg3scrposy_vdp_dup:	= $FFFFF622
v_hbla_hreg:		= $FFFFF624	; VDP H.interrupt register buffer (8Axx)
v_hbla_line:		= $FFFFF625	; screen line where water starts and palette is changed by HBlank
v_pfade_start:		= $FFFFF626	; palette fading - start position in bytes
v_pfade_size:		= $FFFFF627	; palette fading - number of colours
byte_FFF628:		= $FFFFF628
byte_FFF629:		= $FFFFF629
v_vbla_routine:		= $FFFFF62A
v_spritecount:		= $FFFFF62C
v_pcyc_num:		= $FFFFF632	; palette cycling - current reference number (2 bytes)
v_pcyc_time:		= $FFFFF634	; palette cycling - time until the next change (2 bytes)
v_random:		= $FFFFF636
f_pause:		= $FFFFF63A
v_vdp_buffer2:		= $FFFFF644
f_hblank:		= $FFFFF648
f_water:		= $FFFFF64C
v_pal_buffer:		= $FFFFF650	; palette data buffer (used for palette cycling) ($30 bytes)
v_levseldelay:		= $FFFFF666	; level select - time until change when up/down is held (2 bytes)
v_levselitem:		= $FFFFF668	; level select - item selected (2 bytes)
v_levselsound:		= $FFFFF66A	; level select - sound selected (2 bytes)
v_plc_buffer:		= $FFFFF680	; pattern load cues buffer (maximum $10 PLCs) ($60 bytes)
v_ptrnemcode:		= $FFFFF6E0	; pointer for nemesis decompression code ($1502 or $150C) (4 bytes)
unk_FFF6E4:		= $FFFFF6E4
unk_FFF6E8:		= $FFFFF6E8
unk_FFF6EC:		= $FFFFF6EC
unk_FFF6F0:		= $FFFFF6F0
unk_FFF6F4:		= $FFFFF6F4
f_plc_execute:		= $FFFFF6F8	; flag set for pattern load cue execution (2 bytes)
unk_FFF6FA:		= $FFFFF6FA
v_screenposx:		= $FFFFF700
v_screenposy:		= $FFFFF704
v_bgscreenposx:		= $FFFFF708
v_bgscreenposy:		= $FFFFF70C
v_bg2screenposx:	= $FFFFF710
v_bg2screenposy:	= $FFFFF714
v_bg3screenposx:	= $FFFFF718
v_bg3screenposy:	= $FFFFF71C
v_limitleft1:		= $FFFFF720
v_limittop1:		= $FFFFF724
v_limitbtm1:		= $FFFFF726
v_limitleft2:		= $FFFFF728
v_limitright2:		= $FFFFF72A
v_limittop2:		= $FFFFF72C
v_limitbtm2:		= $FFFFF72E
unk_FFF730:		= $FFFFF730
v_limitleft3:		= $FFFFF732
v_scrshiftx:		= $FFFFF73A
v_scrshifty:		= $FFFFF73C
unk_FFF73E:		= $FFFFF73E
f_res_hscroll:		= $FFFFF740
f_res_vscroll:		= $FFFFF741
v_dle_routine:		= $FFFFF742
f_nobgscroll:		= $FFFFF744
unk_FFF746:		= $FFFFF746
unk_FFF748:		= $FFFFF748
v_fg_xblock:		= $FFFFF74A
v_fg_yblock:		= $FFFFF74B
v_bg1_xblock:		= $FFFFF74C
v_bg1_yblock:		= $FFFFF74D
v_bg2_xblock:		= $FFFFF74E
v_fg_scroll_flags:	= $FFFFF754
v_bg1_scroll_flags:	= $FFFFF756
v_bg2_scroll_flags:	= $FFFFF758
f_bgscrollvert:		= $FFFFF75C
v_sonspeedmax:		= $FFFFF760
v_sonspeedacc:		= $FFFFF762
v_sonspeeddec:		= $FFFFF764
v_sonframenum:		= $FFFFF766	; frame to display for Sonic
f_sonframechg:		= $FFFFF767
v_anglebuffer:		= $FFFFF768
unk_FFF76A:		= $FFFFF76A
v_opl_routine:		= $FFFFF76C	; ObjPosLoad - routine counter (2 bytes)
v_opl_screen:		= $FFFFF76E	; ObjPosLoad - screen variable (2 bytes)
v_opl_data:		= $FFFFF770	; ObjPosLoad - data buffer ($10 bytes)
v_ssangle:		= $FFFFF780	; Special Stage angle (2 bytes)
v_ssrotate:		= $FFFFF782	; Special Stage rotation speed (2 bytes)
v_btnpushtime1:		= $FFFFF790
v_btnpushtime2:		= $FFFFF792
v_palchgspeed:		= $FFFFF794
v_collindex:		= $FFFFF796
v_palss_num:		= $FFFFF79A
v_palss_time:		= $FFFFF79C
unk_FFF79E:		= $FFFFF79E
unk_FFF7A0:		= $FFFFF7A0
v_obj31ypos:		= $FFFFF7A4	; y-position of object 31 (MZ stomper) (2 bytes)
v_bossstatus:		= $FFFFF7A7
v_trackpos:		= $FFFFF7A8
v_trackbyte:		= $FFFFF7A9
f_lockscreen:		= $FFFFF7AA
unk_FFF7AC:		= $FFFFF7AC
unk_FFF7AD:		= $FFFFF7AD
unk_FFF7AE:		= $FFFFF7AE
unk_FFF7AF:		= $FFFFF7AF
v_lani0_frame:		= $FFFFF7B0
v_lani0_time:		= $FFFFF7B1
v_lani1_frame:		= $FFFFF7B2
v_lani1_time:		= $FFFFF7B3
v_lani2_frame:		= $FFFFF7B4
v_lani2_time:		= $FFFFF7B5
v_lani3_frame:		= $FFFFF7B6
f_switch:		= $FFFFF7E0
v_scroll_block_1_size:	= $FFFFF7F0
v_spritetablebuffer:	= $FFFFF800
v_pal_dry:		= $FFFFFB00
v_pal_dry_dup:		= $FFFFFB80
v_regbuffer:		= $FFFFFC00
v_spbuffer:		= $FFFFFC40	; stores most recent sp address (4 bytes)
v_errortype:		= $FFFFFC44	; error type
v_systemstack:		= $FFFFFE00
f_restart:		= $FFFFFE02	; restart level flag (2 bytes)
v_framecount:		= $FFFFFE04	; frame counter (adds 1 every frame) (2 bytes)
v_framebyte:		= v_framecount+1 ; low byte for frame counter
v_debugitem:		= $FFFFFE06
v_debuguse:		= $FFFFFE08
v_debugxspeed:		= $FFFFFE0A
v_debugyspeed:		= $FFFFFE0B
v_vbla_count:		= $FFFFFE0C
v_vbla_word:		= v_vbla_count+2 ; low word for vertical interrupt counter (2 bytes)
v_vbla_byte:		= v_vbla_word+1	; low byte for vertical interrupt counter
v_zone:			= $FFFFFE10
v_act:			= $FFFFFE11
v_lives:		= $FFFFFE12
v_lifecount:		= $FFFFFE1B	; lives counter value (for actual number, see "v_lives")
f_lifecount:		= $FFFFFE1C	; lives counter update flag
f_extralife:		= $FFFFFE1D
f_timecount:		= $FFFFFE1E
f_scorecount:		= $FFFFFE1F	; score counter update flag
v_rings:		= $FFFFFE20
v_ringbyte:		= v_rings+1	; low byte for rings
v_time:			= $FFFFFE22
v_timemin:		= v_time+1	; time - minutes
v_timesec:		= v_time+2	; time - seconds
v_score:		= $FFFFFE26
v_shield:		= $FFFFFE2C
v_invinc:		= $FFFFFE2D
v_shoes:		= $FFFFFE2E
byte_FFFE2F:		= $FFFFFE2F
v_scorecopy:		= $FFFFFE50
v_timebonus:		= $FFFFFE54
v_ringbonus:		= $FFFFFE56
f_endactbonus:		= $FFFFFE58
v_oscillate:		= $FFFFFE5E
v_ani0_time:		= $FFFFFEC0	; synchronised sprite animation 0 - time until next frame (used for synchronised animations)
v_ani0_frame:		= $FFFFFEC1	; synchronised sprite animation 0 - current frame
v_ani1_time:		= $FFFFFEC2	; synchronised sprite animation 1 - time until next frame
v_ani1_frame:		= $FFFFFEC3	; synchronised sprite animation 1 - current frame
v_ani2_time:		= $FFFFFEC4	; synchronised sprite animation 2 - time until next frame
v_ani2_frame:		= $FFFFFEC5	; synchronised sprite animation 2 - current frame
v_ani3_time:		= $FFFFFEC6	; synchronised sprite animation 3 - time until next frame
v_ani3_frame:		= $FFFFFEC7	; synchronised sprite animation 3 - current frame
v_ani3_buf:		= $FFFFFEC8	; synchronised sprite animation 3 - info buffer (2 bytes)
word_FFFFE0:		= $FFFFFFE0	; value that's set to 1 during initation, unused elsewhere (2 bytes)
word_FFFFE8:		= $FFFFFFE8	; value that's set to 0 during initation of a level, unused elsewhere (2 bytes)
f_demo:			= $FFFFFFF0
v_demonum:		= $FFFFFFF2
v_megadrive:		= $FFFFFFF8
f_debugmode:		= $FFFFFFFA
v_init:			= $FFFFFFFC	; 'init' text string (4 bytes)