; sign-extends a 32-bit integer to 64-bit
; all RAM addresses are run through this function to allow them to work in both 16-bit and 32-bit addressing modes
ramaddr function x,(-(x&$80000000)<<1)|x

; Variables (v) and Flags (f)

	phase ramaddr ( $FFFF0000 )
v_startofram:
v_256x256:		ds.b $A400			; 256x256 tile mappings ($A400 bytes)
v_256x256_end:

layoutsize:		= $40

v_lvllayout:		ds.b $400			; level layout buffer ($400 bytes)
v_lvllayoutbg:		= v_lvllayout+layoutsize
v_lvllayout_end:

v_bgscroll_buffer:	ds.b $200
v_ngfx_buffer:		ds.b $200
v_ngfx_buffer_end:
v_spritequeue:		ds.b $400
v_16x16:		ds.b $1800			; 16x16 tile mappings ($1800 bytes)
v_16x16_end:
v_sgfx_buffer:		ds.b $300			; sonic graphics ram buffer ($300 bytes)
v_tracksonic:		ds.b $100			; sonic position table ($100 bytes)
v_hscrolltablebuffer:	ds.b $380
v_hscrolltablebuffer_end:
			ds.b $80
v_hscrolltablebuffer_end_padded:
v_objspace:						; RAM for object space ($600 bytes)
v_player:
v_objslot0:		ds.b obj.Size
v_objslot1:		ds.b obj.Size
v_objslot2:		ds.b obj.Size
v_objslot3:		ds.b obj.Size
v_objslot4:		ds.b obj.Size
v_objslot5:		ds.b obj.Size
v_objslot6:		ds.b obj.Size
v_objslot7:		ds.b obj.Size
v_objslot8:		ds.b obj.Size
v_objslot9:		ds.b obj.Size
v_objslotA:		ds.b obj.Size
v_objslotB:		ds.b obj.Size
v_objslotC:		ds.b obj.Size
v_objslotD:		ds.b obj.Size
v_objslotE:		ds.b obj.Size
v_objslotF:		ds.b obj.Size
v_objslot10:		ds.b obj.Size
v_objslot11:		ds.b obj.Size
v_objslot12:		ds.b obj.Size
v_objslot13:		ds.b obj.Size
v_objslot14:		ds.b obj.Size
v_objslot15:		ds.b obj.Size
v_objslot16:		ds.b obj.Size
v_objslot17:		ds.b obj.Size
v_objslot18:		ds.b obj.Size			; flag for victory animation (1 byte)
v_objslot19:		ds.b obj.Size
v_objslot1A:		ds.b obj.Size
v_objslot1B:		ds.b obj.Size
v_objslot1C:		ds.b obj.Size
v_objslot1D:		ds.b obj.Size
v_objslot1E:		ds.b obj.Size
v_objslot1F:		ds.b obj.Size
v_lvlobjspace:
			ds.b obj.Size
			ds.b obj.Size
			ds.b obj.Size
			ds.b obj.Size
			ds.b obj.Size
			ds.b obj.Size
			ds.b obj.Size
			ds.b obj.Size
			ds.b obj.Size
			ds.b obj.Size
			ds.b obj.Size
			ds.b obj.Size
			ds.b obj.Size
			ds.b obj.Size
			ds.b obj.Size
			ds.b obj.Size
			ds.b obj.Size
			ds.b obj.Size
			ds.b obj.Size
			ds.b obj.Size
			ds.b obj.Size
			ds.b obj.Size
			ds.b obj.Size
			ds.b obj.Size
			ds.b obj.Size
			ds.b obj.Size
			ds.b obj.Size
			ds.b obj.Size
			ds.b obj.Size
			ds.b obj.Size
			ds.b obj.Size
			ds.b obj.Size
			ds.b obj.Size
			ds.b obj.Size
			ds.b obj.Size
			ds.b obj.Size
			ds.b obj.Size
			ds.b obj.Size
			ds.b obj.Size
			ds.b obj.Size
			ds.b obj.Size
			ds.b obj.Size
			ds.b obj.Size
			ds.b obj.Size
			ds.b obj.Size
			ds.b obj.Size
			ds.b obj.Size
			ds.b obj.Size
			ds.b obj.Size
			ds.b obj.Size
			ds.b obj.Size
			ds.b obj.Size
			ds.b obj.Size
			ds.b obj.Size
			ds.b obj.Size
			ds.b obj.Size
			ds.b obj.Size
			ds.b obj.Size
			ds.b obj.Size
			ds.b obj.Size
			ds.b obj.Size
			ds.b obj.Size
			ds.b obj.Size
			ds.b obj.Size
			ds.b obj.Size
			ds.b obj.Size
			ds.b obj.Size
			ds.b obj.Size
			ds.b obj.Size
			ds.b obj.Size
			ds.b obj.Size
			ds.b obj.Size
			ds.b obj.Size
			ds.b obj.Size
			ds.b obj.Size
			ds.b obj.Size
			ds.b obj.Size
			ds.b obj.Size
			ds.b obj.Size
			ds.b obj.Size
			ds.b obj.Size
			ds.b obj.Size
			ds.b obj.Size
			ds.b obj.Size
			ds.b obj.Size
			ds.b obj.Size
			ds.b obj.Size
			ds.b obj.Size
			ds.b obj.Size
			ds.b obj.Size
			ds.b obj.Size
			ds.b obj.Size
			ds.b obj.Size
			ds.b obj.Size
			ds.b obj.Size
			ds.b obj.Size
v_lvlobjend:
v_objend:
; $FFFFF000
v_snddriver_ram:	ds.b $600			; start of RAM for the sound driver data ($600 bytes)
v_snddriver_ram_end:
			dephase

; =================================================================================
; From here on, until otherwise stated, all offsets are relative to v_snddriver_ram
; =================================================================================

			phase 0
v_startofvariables:
v_sndprio:		ds.b 1				; sound priority (priority of new music/SFX must be higher or =al to this value or it won't play; bit 7 of priority being set prevents this value from changing)
v_main_tempo_timeout:	ds.b 1				; Counts down to zero; when zero, resets to next value and delays song by 1 frame
v_main_tempo:		ds.b 1				; Used for music only
f_pausemusic:		ds.b 1				; flag set to stop music when paused
v_fadeout_counter:	ds.b 1
			ds.b 1				; unused
v_fadeout_delay:	ds.b 1
v_communication_byte:	ds.b 1				; used in Ristar to sync with a boss' attacks; unused here
f_updating_dac:		ds.b 1				; $80 if updating DAC, $00 otherwise
v_sound_id:		ds.b 1				; sound or music copied from below
v_soundqueue_start:	ds.b 0
v_soundqueue0:		ds.b 1				; sound or music to play
v_soundqueue1:		ds.b 1				; special sound to play
v_soundqueue2:		ds.b 1				; unused sound to play
v_soundqueue_end:	ds.b 0
			ds.b 1				; unused
f_voice_selector:	ds.b 10				; $00 = use music voice pointer; $40 = use special voice pointer; $80 = use track voice pointer

v_voice_ptr:		ds.l 1				; voice data pointer (4 bytes)
v_lfo_voice_ptr:	ds.l 1				; lfo voice data pointer (4 bytes)
v_special_voice_ptr:	ds.l 1				; voice data pointer for special SFX ($D0-$DF) (4 bytes)

f_fadein_flag:		ds.b 1				; Flag for fade in
v_fadein_delay:		ds.b 1
v_fadein_counter:	ds.b 1				; Timer for fade in/out
f_1up_playing:		ds.b 1				; flag indicating 1-up song is playing
v_tempo_mod:		ds.b 1				; music - tempo modifier
v_speeduptempo:		ds.b 1				; music - tempo modifier with speed shoes
f_speedup:		ds.b 1				; flag indicating whether speed shoes tempo is on ($80) or off ($00)
v_ring_speaker:		ds.b 1				; which speaker the "ring" sound is played in (00 = right; 01 = left)
f_push_playing:		ds.b 1				; if set, prevents further push sounds from playing
			dephase

			phase $40

v_music_track_ram:					; Start of music RAM

v_music_fmdac_tracks:
v_music_dac_track:	ds.b TrackSz
v_music_fm_tracks:
v_music_fm1_track:	ds.b TrackSz
v_music_fm2_track:	ds.b TrackSz
v_music_fm3_track:	ds.b TrackSz
v_music_fm4_track:	ds.b TrackSz
v_music_fm5_track:	ds.b TrackSz
v_music_fm6_track:	ds.b TrackSz
v_music_fm_tracks_end:
v_music_fmdac_tracks_end:
v_music_psg_tracks:
v_music_psg1_track:	ds.b TrackSz
v_music_psg2_track:	ds.b TrackSz
v_music_psg3_track:	ds.b TrackSz
v_music_psg_tracks_end:
v_music_track_ram_end:

v_sfx_track_ram:					; Start of SFX RAM, straight after the end of music RAM

v_sfx_fm_tracks:
v_sfx_fm3_track:	ds.b TrackSz
v_sfx_fm4_track:	ds.b TrackSz
v_sfx_fm5_track:	ds.b TrackSz
v_sfx_fm_tracks_end:
v_sfx_psg_tracks:
v_sfx_psg1_track:	ds.b TrackSz
v_sfx_psg2_track:	ds.b TrackSz
v_sfx_psg3_track:	ds.b TrackSz
v_sfx_psg_tracks_end:
v_sfx_track_ram_end:

v_spcsfx_track_ram:					; Start of special SFX RAM, straight after the end of SFX RAM

v_spcsfx_fm4_track:	ds.b TrackSz
v_spcsfx_psg3_track:	ds.b TrackSz
v_spcsfx_track_ram_end:

v_1up_ram_copy:		ds.b TrackSz

			dephase

; =================================================================================
; From here on, no longer relative to sound driver RAM
; =================================================================================

			phase v_snddriver_ram_end
v_gamemode:		ds.b 1
			ds.b 1				; unused
v_jpadhold2:		ds.b 1
v_jpadpress2:		ds.b 1
v_jpadhold1:		ds.b 1
v_jpadpress1:		ds.b 1
			ds.b 6				; unused
v_vdp_buffer1:		ds.w 1
			ds.b 6				; unused
v_demolength:		ds.w 1
v_scrposy_dup:		ds.w 1
v_bgscrposy_dup:	ds.w 1				; background screen position y (duplicate) (2 bytes)
v_scrposx_dup:		ds.w 1
v_bgscreenposx_dup:	ds.w 1				; background screen position x (duplicate) (2 bytes)
v_bg3scrposy_vdp:	ds.w 1
v_bg3scrposx_vdp:	ds.w 1
v_bg3scrposy_vdp_dup:	ds.w 1
v_hbla_hreg:		ds.b 1				; VDP H.interrupt register buffer (8Axx)
v_hbla_line:		ds.b 1				; screen line where water starts and palette is changed by HBlank
v_pfade_start:		ds.b 1				; palette fading - start position in bytes
v_pfade_size:		ds.b 1				; palette fading - number of colouds
byte_FFF628:		ds.b 1
byte_FFF629:		ds.b 1
v_vbla_routine:		ds.w 1
v_spritecount:		ds.b 1
			ds.b 5				; unused
v_pcyc_num:		ds.w 1				; palette cycling - current reference number (2 bytes)
v_pcyc_time:		ds.w 1				; palette cycling - time until the next change (2 bytes)
v_random:		ds.l 1
f_pause:		ds.w 1
			ds.b 8				; unused
v_vdp_buffer2:		ds.w 1
			ds.w 1				; unused
f_hblank:		ds.w 1
			ds.w 1				; unused
f_water:		ds.w 1
			ds.w 1				; unused
v_pal_buffer:		ds.b $16			; palette data buffer (used for palette cycling) ($16 bytes)
v_levseldelay:		ds.w 1				; level select - time until change when up/down is held (2 bytes)
v_levselitem:		ds.w 1				; level select - item selected (2 bytes)
v_levselsound:		ds.w 1				; level select - sound selected (2 bytes)
			ds.b $14			; unused
v_plc_buffer:		ds.b 6*16			; pattern load cues buffer (maximum $10 PLCs) ($60 bytes)
v_plc_buffer_only_end:
v_plc_buffer_reg0:	ds.l 1				; pattern load cues buffer (4 bytes)
v_plc_buffer_reg4:	ds.l 1				; pattern load cues buffer (4 bytes)
v_plc_buffer_reg8:	ds.l 1				; pattern load cues buffer (4 bytes)
v_plc_buffer_regC:	ds.l 1				; pattern load cues buffer (4 bytes)
v_plc_buffer_reg10:	ds.l 1				; pattern load cues buffer (4 bytes)
v_plc_buffer_reg14:	ds.l 1				; pattern load cues buffer (4 bytes)
f_plc_execute:		ds.w 1				; flag set for pattern load cue execution (2 bytes)
v_plc_buffer_reg1A:	ds.w 1
			ds.l 1				; unused
v_plc_buffer_end:
v_screenposx:		ds.l 1
v_screenposy:		ds.l 1
v_bgscreenposx:		ds.l 1
v_bgscreenposy:		ds.l 1
v_bg2screenposx:	ds.l 1
v_bg2screenposy:	ds.l 1
v_bg3screenposx:	ds.l 1
v_bg3screenposy:	ds.l 1
v_limitleft1:		ds.w 1
			ds.w 1				; unused, was probably v_limitright1
v_limittop1:		ds.w 1
v_limitbtm1:		ds.w 1
v_limitleft2:		ds.w 1
v_limitright2:		ds.w 1
v_limittop2:		ds.w 1
v_limitbtm2:		ds.w 1
unk_FFF730:		ds.w 1
v_limitleft3:		ds.w 1
			ds.b 6				; unused
v_scrshiftx:		ds.w 1
v_scrshifty:		ds.w 1
v_lookshift:		ds.w 1
f_res_hscroll:		ds.b 1
f_res_vscroll:		ds.b 1
v_dle_routine:		ds.w 1
f_nobgscroll:		ds.w 1
unk_FFF746:		ds.w 1
unk_FFF748:		ds.w 1
v_fg_xblock:		ds.b 1
v_fg_yblock:		ds.b 1
v_bg1_xblock:		ds.b 1
v_bg1_yblock:		ds.b 1
v_bg2_xblock:		ds.b 1
			ds.b 5				; unused
v_fg_scroll_flags:	ds.w 1
v_bg1_scroll_flags:	ds.w 1
v_bg2_scroll_flags:	ds.w 1
			ds.w 1				; unused
f_bgscrollvert:		ds.b 1
			ds.b 3				; unused
v_sonspeedmax:		ds.w 1
v_sonspeedacc:		ds.w 1
v_sonspeeddec:		ds.w 1
v_sonframenum:		ds.b 1				; frame to display for Sonic
f_sonframechg:		ds.b 1
v_angle_primary:	ds.w 1				; primary angle buffer (2 bytes)
v_angle_secondary:	ds.w 1				; secondary angle buffer (2 bytes)
v_opl_routine:		ds.w 1				; ObjPosLoad - routine counter (2 bytes)
v_opl_screen:		ds.w 1				; ObjPosLoad - screen variable (2 bytes)
v_opl_data:		ds.b $10			; ObjPosLoad - data buffer ($10 bytes)
v_ssangle:		ds.w 1				; Special Stage angle (2 bytes)
v_ssrotate:		ds.w 1				; Special Stage rotation speed (2 bytes)
			ds.b $C				; unused
v_btnpushtime1:		ds.w 1
v_btnpushtime2:		ds.w 1
v_palchgspeed:		ds.w 1
v_collindex:		ds.l 1
v_palss_num:		ds.w 1
v_palss_time:		ds.w 1
unk_FFF79E:		ds.w 1
unk_FFF7A0:		ds.w 1
			ds.w 1				; unused
v_obj31ypos:		ds.w 1				; y-position of object 31 (MZ stomper) (2 bytes)
			ds.b 1				; unused
v_bossstatus:		ds.b 1
v_trackpos:		ds.b 1
v_trackbyte:		ds.b 1
f_lockscreen:		ds.b 1
			ds.b 1				; unused
v_256loop1:		ds.b 1				; 256x256 level tile which contains a loop (GHZ/SLZ)
v_256loop2:		ds.b 1				; 256x256 level tile which contains a loop (GHZ/SLZ)
v_256roll1:		ds.b 1				; 256x256 level tile which contains a roll tunnel (GHZ)
v_256roll2:		ds.b 1				; 256x256 level tile which contains a roll tunnel (GHZ)
v_lani0_frame:		ds.b 1				; level graphics animation 0 - current frame
v_lani0_time:		ds.b 1				; level graphics animation 0 - time until next frame
v_lani1_frame:		ds.b 1				; level graphics animation 1 - current frame
v_lani1_time:		ds.b 1				; level graphics animation 1 - time until next frame
v_lani2_frame:		ds.b 1				; level graphics animation 2 - current frame
v_lani2_time:		ds.b 1				; level graphics animation 2 - time until next frame
v_lani3_frame:		ds.b 1				; level graphics animation 3 - current frame
			ds.b $29			; unused
f_switch:		ds.w 1
			ds.b $E				; unused
v_scroll_block_1_size:	ds.w 1
			ds.b $E				; unused
v_spritetablebuffer:	ds.b $280
v_spritetablebuffer_end
			ds.b $80			; unused
v_pal_dry:		ds.b $80
v_pal_dry_dup:		ds.b $80
v_objstate:		ds.b $C0			; object state list
v_objstate_end:
			ds.b $140			; stack
v_systemstack:
v_crossresetram:
			ds.w 1
f_restart:		ds.w 1				; restart level flag (2 bytes)
v_framecount:		ds.b 1				; frame counter (adds 1 every frame) (2 bytes)
v_framebyte:		ds.b 1				; low byte for frame counter
v_debugitem:		ds.w 1
v_debuguse:		ds.w 1
v_debugxspeed:		ds.b 1
v_debugyspeed:		ds.b 1
v_vbla_count:		ds.w 1
v_vbla_word:		ds.b 1				; low word for vertical interrupt counter (2 bytes)
v_vbla_byte:		ds.b 1				; low byte for vertical interrupt counter
v_zone:			ds.b 1
v_act:			ds.b 1
v_lives:		ds.b 1
			ds.b 8				; unused
v_lifecount:		ds.b 1				; lives counter value (for actual number, see "v_lives")
f_lifecount:		ds.b 1				; lives counter update flag
f_extralife:		ds.b 1
f_timecount:		ds.b 1
f_scorecount:		ds.b 1				; score counter update flag
v_rings:		ds.b 1
v_ringbyte:		ds.b 1				; low byte for rings
v_time:			ds.b 1
v_timemin:		ds.b 1				; time - minutes
v_timesec:		ds.b 1				; time - seconds
			ds.b 1				; unused
v_score:		ds.l 1
			ds.w 1				; unused
v_shield:		ds.b 1
v_invinc:		ds.b 1
v_shoes:		ds.b 1
byte_FFFE2F:		ds.b 1
			ds.b $20			; unused
v_scorecopy:		ds.l 1
v_timebonus:		ds.w 1
v_ringbonus:		ds.w 1
f_endactbonus:		ds.b 1
			ds.b 5				; unused
v_oscillate:		ds.b $42			; values which oscillate - for swinging platforms, et al ($42 bytes)
			ds.b $20			; unused
v_ani0_time:		ds.b 1				; synchronised sprite animation 0 - time until next frame (used for synchronised animations)
v_ani0_frame:		ds.b 1				; synchronised sprite animation 0 - current frame
v_ani1_time:		ds.b 1				; synchronised sprite animation 1 - time until next frame
v_ani1_frame:		ds.b 1				; synchronised sprite animation 1 - current frame
v_ani2_time:		ds.b 1				; synchronised sprite animation 2 - time until next frame
v_ani2_frame:		ds.b 1				; synchronised sprite animation 2 - current frame
v_ani3_time:		ds.b 1				; synchronised sprite animation 3 - time until next frame
v_ani3_frame:		ds.b 1				; synchronised sprite animation 3 - current frame
v_ani3_buf:		ds.w 1				; synchronised sprite animation 3 - info buffer (2 bytes)
			ds.b $116			; unused
word_FFFFE0:		ds.w 1				; value that's set to 1 during initation, unused otherwise (2 bytes)
			ds.b 6				; unused
word_FFFFE8:		ds.w 1				; value that's set to 0 during initation of a level, unused otherwise (2 bytes)
			ds.b 6				; unused
f_demo:			ds.w 1
v_demonum:		ds.w 1
			ds.l 1				; unused
v_megadrive:		ds.b 1
			ds.b 1				; unused
f_debugmode:		ds.b 1
			ds.b 1				; unused
v_init:			ds.b 1				; 'init' text string (4 bytes)
			ds.w 1				; unused
			ds.b 1				; unused
v_endofram:
			dephase

	phase v_objstate
v_regbuffer:		ds.b	$40			; stores registers d0-a7 during an error event
v_spbuffer:		ds.l	1			; stores most recent sp address
v_errortype:		ds.b	1			; error type
	dephase

	phase v_objslot18
f_victory:		ds.b 1				; flag for victory animation (1 byte)
	dephase
			!org 0
