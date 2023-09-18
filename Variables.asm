; Variables (v) and Flags (f)

	rsset $FFFF0000
v_startofram:		rs.b 0
v_256x256:		rs.b $A400		; 256x256 tile mappings ($A400 bytes)

layoutsize:		= $40

v_lvllayout:		rs.b $400		; level layout buffer ($400 bytes)
v_lvllayoutbg:		= v_lvllayout+layoutsize

v_bgscroll_buffer:	rs.b $200
v_ngfx_buffer:		rs.b $200
v_spritequeue:		rs.b $400
v_16x16:		rs.b $1800		; 16x16 tile mappings ($1800 bytes)
v_sgfx_buffer:		rs.b $300		; sonic graphics ram buffer ($300 bytes)
v_tracksonic:		rs.b $100		; sonic position table ($100 bytes)
v_hscrolltablebuffer:	rs.b $400
v_objspace:		rs.b 0			; RAM for object space ($600 bytes)
v_player:               rs.b 0
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
f_victory:		rs.b obSize		; flag for victory animation (1 byte)
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
v_lvlobjspace:		rs.b 0
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
			rs.b obSize
; $FFFFF000
v_snddriver_ram:	rs.b $600		; start of RAM for the sound driver data ($600 bytes)
v_snddriver_ram_end:	rs.b 0
	rsreset

; =================================================================================
; From here on, until otherwise stated, all offsets are relative to v_snddriver_ram
; =================================================================================

	rsset 0
v_startofvariables:	rs.b 0
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
v_soundqueue_start:	rs.b 0
v_soundqueue0:		rs.b 1			; sound or music to play
v_soundqueue1:		rs.b 1			; special sound to play
v_soundqueue2:		rs.b 1			; unused sound to play
v_soundqueue_end:	rs.b 0
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

	rsset v_snddriver_ram_end
v_gamemode:		rs.b 1
	rs.b 1					; unused
v_jpadhold2:		rs.b 1
v_jpadpress2:		rs.b 1
v_jpadhold1:		rs.b 1
v_jpadpress1:		rs.b 1
	rs.b 6					; unused
v_vdp_buffer1:		rs.w 1
	rs.b 6					; unused
v_demolength:		rs.w 1
v_scrposy_dup:		rs.w 1
v_bgscrposy_dup:	rs.w 1			; background screen position y (duplicate) (2 bytes)
v_scrposx_dup:		rs.w 1
v_bgscreenposx_dup:	rs.w 1			; background screen position x (duplicate) (2 bytes)
v_bg3scrposy_vdp:	rs.w 1
v_bg3scrposx_vdp:	rs.w 1
v_bg3scrposy_vdp_dup:	rs.w 1
v_hbla_hreg:		rs.b 1			; VDP H.interrupt register buffer (8Axx)
v_hbla_line:		rs.b 1			; screen line where water starts and palette is changed by HBlank
v_pfade_start:		rs.b 1			; palette fading - start position in bytes
v_pfade_size:		rs.b 1			; palette fading - number of colours
byte_FFF628:		rs.b 1
byte_FFF629:		rs.b 1
v_vbla_routine:		rs.w 1
v_spritecount:		rs.b 1
	rs.b 5					; unused
v_pcyc_num:		rs.w 1			; palette cycling - current reference number (2 bytes)
v_pcyc_time:		rs.w 1			; palette cycling - time until the next change (2 bytes)
v_random:		rs.l 1
f_pause:		rs.w 1
	rs.b 8					; unused
v_vdp_buffer2:		rs.w 1
	rs.w 1					; unused
f_hblank:		rs.w 1
	rs.w 1					; unused
f_water:		rs.w 1
	rs.w 1					; unused
v_pal_buffer:		rs.b $16		; palette data buffer (used for palette cycling) ($16 bytes)
v_levseldelay:		rs.w 1			; level select - time until change when up/down is held (2 bytes)
v_levselitem:		rs.w 1			; level select - item selected (2 bytes)
v_levselsound:		rs.w 1			; level select - sound selected (2 bytes)
	rs.b $14				; unused
v_plc_buffer:		rs.b $60		; pattern load cues buffer (maximum $10 PLCs) ($60 bytes)
v_ptrnemcode:		rs.l 1			; pointer for nemesis decompression code ($1502 or $150C) (4 bytes)
unk_FFF6E4:		rs.l 1
unk_FFF6E8:		rs.l 1
unk_FFF6EC:		rs.l 1
unk_FFF6F0:		rs.l 1
unk_FFF6F4:		rs.l 1
f_plc_execute:		rs.w 1			; flag set for pattern load cue execution (2 bytes)
unk_FFF6FA:		rs.w 1
	rs.l 1					; unused
v_screenposx:		rs.l 1
v_screenposy:		rs.l 1
v_bgscreenposx:		rs.l 1
v_bgscreenposy:		rs.l 1
v_bg2screenposx:	rs.l 1
v_bg2screenposy:	rs.l 1
v_bg3screenposx:	rs.l 1
v_bg3screenposy:	rs.l 1
v_limitleft1:		rs.w 1
	rs.w 1					; unused
v_limittop1:		rs.w 1
v_limitbtm1:		rs.w 1
v_limitleft2:		rs.w 1
v_limitright2:		rs.w 1
v_limittop2:		rs.w 1
v_limitbtm2:		rs.w 1
unk_FFF730:		rs.w 1
v_limitleft3:		rs.w 1
	rs.b 6					; unused
v_scrshiftx:		rs.w 1
v_scrshifty:		rs.w 1
unk_FFF73E:		rs.w 1
f_res_hscroll:		rs.b 1
f_res_vscroll:		rs.b 1
v_dle_routine:		rs.w 1
f_nobgscroll:		rs.w 1
unk_FFF746:		rs.w 1
unk_FFF748:		rs.w 1
v_fg_xblock:		rs.b 1
v_fg_yblock:		rs.b 1
v_bg1_xblock:		rs.b 1
v_bg1_yblock:		rs.b 1
v_bg2_xblock:		rs.b 1
	rs.b 5					; unused
v_fg_scroll_flags:	rs.w 1
v_bg1_scroll_flags:	rs.w 1
v_bg2_scroll_flags:	rs.w 1
	rs.w 1					; unused
f_bgscrollvert:		rs.b 1
	rs.b 3					; unused
v_sonspeedmax:		rs.w 1
v_sonspeedacc:		rs.w 1
v_sonspeeddec:		rs.w 1
v_sonframenum:		rs.b 1			; frame to display for Sonic
f_sonframechg:		rs.b 1
v_prianglebuffer:	rs.w 1			; primary angle buffer (2 bytes)
v_secanglebuffer:	rs.w 1			; secondary angle buffer (2 bytes)
v_opl_routine:		rs.w 1			; ObjPosLoad - routine counter (2 bytes)
v_opl_screen:		rs.w 1			; ObjPosLoad - screen variable (2 bytes)
v_opl_data:		rs.b $10		; ObjPosLoad - data buffer ($10 bytes)
v_ssangle:		rs.w 1			; Special Stage angle (2 bytes)
v_ssrotate:		rs.w 1			; Special Stage rotation speed (2 bytes)
	rs.b $C					; unused
v_btnpushtime1:		rs.w 1
v_btnpushtime2:		rs.w 1
v_palchgspeed:		rs.w 1
v_collindex:		rs.l 1
v_palss_num:		rs.w 1
v_palss_time:		rs.w 1
unk_FFF79E:		rs.w 1
unk_FFF7A0:		rs.w 1
	rs.w 1					; unused
v_obj31ypos:		rs.w 1			; y-position of object 31 (MZ stomper) (2 bytes)
	rs.b 1					; unused
v_bossstatus:		rs.b 1
v_trackpos:		rs.b 1
v_trackbyte:		rs.b 1
f_lockscreen:		rs.b 1
	rs.b 1					; unused
unk_FFF7AC:		rs.b 1
unk_FFF7AD:		rs.b 1
unk_FFF7AE:		rs.b 1
unk_FFF7AF:		rs.b 1
v_lani0_frame:		rs.b 1
v_lani0_time:		rs.b 1
v_lani1_frame:		rs.b 1
v_lani1_time:		rs.b 1
v_lani2_frame:		rs.b 1
v_lani2_time:		rs.b 1
v_lani3_frame:		rs.b 1
	rs.b $29				; unused
f_switch:		rs.w 1
	rs.b $E					; unused
v_scroll_block_1_size:	rs.w 1
	rs.b $E					; unused
v_spritetablebuffer:	rs.b $200
	rs.b $100				; unused
v_pal_dry:		rs.b $80
v_pal_dry_dup:		rs.b $80
v_regbuffer:		rs.b $40		; stores registers d0-a7 during an error event ($40 bytes)
v_spbuffer:		rs.l 1			; stores most recent sp address (4 bytes)
v_errortype:		rs.b 1			; error type
	rs.b $1BB				; unused
v_systemstack:		rs.w 1
f_restart:		rs.w 1			; restart level flag (2 bytes)
v_framecount:		rs.b 1			; frame counter (adds 1 every frame) (2 bytes)
v_framebyte:		rs.b 1			; low byte for frame counter
v_debugitem:		rs.w 1
v_debuguse:		rs.w 1
v_debugxspeed:		rs.b 1
v_debugyspeed:		rs.b 1
v_vbla_count:		rs.w 1
v_vbla_word:		rs.b 1			; low word for vertical interrupt counter (2 bytes)
v_vbla_byte:		rs.b 1			; low byte for vertical interrupt counter
v_zone:			rs.b 1
v_act:			rs.b 1
v_lives:		rs.b 1
	rs.b 8					; unused
v_lifecount:		rs.b 1			; lives counter value (for actual number, see "v_lives")
f_lifecount:		rs.b 1			; lives counter update flag
f_extralife:		rs.b 1
f_timecount:		rs.b 1
f_scorecount:		rs.b 1			; score counter update flag
v_rings:		rs.b 1
v_ringbyte:		rs.b 1			; low byte for rings
v_time:			rs.b 1
v_timemin:		rs.b 1			; time - minutes
v_timesec:		rs.b 1			; time - seconds
	rs.b 1					; unused
v_score:		rs.l 1
	rs.w 1					; unused
v_shield:		rs.b 1
v_invinc:		rs.b 1
v_shoes:		rs.b 1
byte_FFFE2F:		rs.b 1
	rs.b $20				; unused
v_scorecopy:		rs.l 1
v_timebonus:		rs.w 1
v_ringbonus:		rs.w 1
f_endactbonus:		rs.b 1
	rs.b 5					; unused
v_oscillate:		rs.b $42		; values which oscillate - for swinging platforms, et al ($42 bytes)
	rs.b $20				; unused
v_ani0_time:		rs.b 1			; synchronised sprite animation 0 - time until next frame (used for synchronised animations)
v_ani0_frame:		rs.b 1			; synchronised sprite animation 0 - current frame
v_ani1_time:		rs.b 1			; synchronised sprite animation 1 - time until next frame
v_ani1_frame:		rs.b 1			; synchronised sprite animation 1 - current frame
v_ani2_time:		rs.b 1			; synchronised sprite animation 2 - time until next frame
v_ani2_frame:		rs.b 1			; synchronised sprite animation 2 - current frame
v_ani3_time:		rs.b 1			; synchronised sprite animation 3 - time until next frame
v_ani3_frame:		rs.b 1			; synchronised sprite animation 3 - current frame
v_ani3_buf:		rs.w 1			; synchronised sprite animation 3 - info buffer (2 bytes)
	rs.b $116				; unused
word_FFFFE0:		rs.w 1			; value that's set to 1 during initation, unused elsewhere (2 bytes)
	rs.b 6					; unused
word_FFFFE8:		rs.w 1			; value that's set to 0 during initation of a level, unused elsewhere (2 bytes)
	rs.b 6					; unused
f_demo:			rs.w 1
v_demonum:		rs.w 1
	rs.l 1					; unused
v_megadrive:		rs.b 1
	rs.b 1					; unused
f_debugmode:		rs.b 1
	rs.b 1					; unused
v_init:			rs.b 1			; 'init' text string (4 bytes)
	rs.w 1					; unused
v_endofram:		rs.b 0
	rsreset