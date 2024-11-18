; +------------------------------------------------------+
; | Sonic the Hedgehog (Prototype)                       |
; | Split/Text Disassembly.                              |
; | Originally done by Mega Drive Developers Collective. |
; +------------------------------------------------------+

; Processor: Motorola 68000 (M68K)
; Sound Processor: Zilog Z80 (Z80)
; Intended for tab width of 8

; ---------------------------------------------------------------------------

	cpu 68000

zeroOffsetOptimization = 0
;	| If 1, makes a handful of zero-offset instructions smaller

		include "MacroSetup.asm"
		include "Constants.asm"
		include "Variables.asm"
		include "Macros.asm"
; ---------------------------------------------------------------------------

StartOfROM:
Vectors:	dc.l v_systemstack&$FFFFFF		; Initial stack pointer value
		dc.l EntryPoint				; Start of program
		dc.l BusError				; Bus error
		dc.l AddressError			; Address error (4)
		dc.l IllegalInstr			; Illegal instruction
		dc.l ZeroDivide				; Division by zero
		dc.l ChkInstr				; CHK exception
		dc.l TrapvInstr				; TRAPV exception (8)
		dc.l PrivilegeViol			; Privilege violation
		dc.l Trace				; TRACE exception
		dc.l Line1010Emu			; Line-A emulator
		dc.l Line1111Emu			; Line-F emulator (12)
		dc.l ErrorExcept			; Unused (reserved)
		dc.l ErrorExcept			; Unused (reserved)
		dc.l ErrorExcept			; Unused (reserved)
		dc.l ErrorExcept			; Unused (reserved) (16)
		dc.l ErrorExcept			; Unused (reserved)
		dc.l ErrorExcept			; Unused (reserved)
		dc.l ErrorExcept			; Unused (reserved)
		dc.l ErrorExcept			; Unused (reserved) (20)
		dc.l ErrorExcept			; Unused (reserved)
		dc.l ErrorExcept			; Unused (reserved)
		dc.l ErrorExcept			; Unused (reserved)
		dc.l ErrorExcept			; Unused (reserved) (24)
		dc.l ErrorExcept			; Spurious exception
		dc.l ErrorTrap				; IRQ level 1
		dc.l ErrorTrap				; IRQ level 2
		dc.l ErrorTrap				; IRQ level 3 (28)
		dc.l HBlank				; IRQ level 4 (horizontal retrace interrupt)
		dc.l ErrorTrap				; IRQ level 5
		dc.l VBlank				; IRQ level 6 (vertical retrace interrupt)
		dc.l ErrorTrap				; IRQ level 7 (32)
		dc.l ErrorTrap				; TRAP #00 exception
		dc.l ErrorTrap				; TRAP #01 exception
		dc.l ErrorTrap				; TRAP #02 exception
		dc.l ErrorTrap				; TRAP #03 exception (36)
		dc.l ErrorTrap				; TRAP #04 exception
		dc.l ErrorTrap				; TRAP #05 exception
		dc.l ErrorTrap				; TRAP #06 exception
		dc.l ErrorTrap				; TRAP #07 exception (40)
		dc.l ErrorTrap				; TRAP #08 exception
		dc.l ErrorTrap				; TRAP #09 exception
		dc.l ErrorTrap				; TRAP #10 exception
		dc.l ErrorTrap				; TRAP #11 exception (44)
		dc.l ErrorTrap				; TRAP #12 exception
		dc.l ErrorTrap				; TRAP #13 exception
		dc.l ErrorTrap				; TRAP #14 exception
		dc.l ErrorTrap				; TRAP #15 exception (48)
		dc.l ErrorTrap				; Unused (reserved)
		dc.l ErrorTrap				; Unused (reserved)
		dc.l ErrorTrap				; Unused (reserved)
		dc.l ErrorTrap				; Unused (reserved)
		dc.l ErrorTrap				; Unused (reserved)
		dc.l ErrorTrap				; Unused (reserved)
		dc.l ErrorTrap				; Unused (reserved)
		dc.l ErrorTrap				; Unused (reserved)
		dc.l ErrorTrap				; Unused (reserved)
		dc.l ErrorTrap				; Unused (reserved)
		dc.l ErrorTrap				; Unused (reserved)
		dc.l ErrorTrap				; Unused (reserved)
		dc.l ErrorTrap				; Unused (reserved)
		dc.l ErrorTrap				; Unused (reserved)
		dc.l ErrorTrap				; Unused (reserved)
		dc.l ErrorTrap				; Unused (reserved)
Console:	dc.b "SEGA MEGA DRIVE "			; Hardware system ID (Console name)
		dc.b "(C)SEGA 1989.JAN"			; Copyright holder and release date (generally year)
Title_Local:	dc.b "                                                " ; Domestic name (blank)
Title_Int:	dc.b "                                                " ; International name (blank)
Serial:		dc.b "GM 00000000-00"			; Serial\version number
Checksum:	dc.w 0					; Checksum
		dc.b "J               "			; I\O support
RomStartLoc:	dc.l StartOfROM				; Start address of ROM
RomEndLoc:      dc.l EndOfROM-1				; End address of ROM
RamStartLoc:	dc.l v_start&$FFFFFF			; Start address of RAM
RamEndLoc:      dc.l (v_end-1)&$FFFFFF			; End address of RAM
SRAMSupport:	dc.l $20202020				; SRAM (none)
                dc.l $20202020				; SRAM start ($200001)
                dc.l $20202020				; SRAM end ($20xxxx)
Notes:		dc.b "                                                    " ; Notes (unused, anything can be put in this space, but it has to be 52 bytes.)
		dc.b "JU              "			; Region (Country code)
EndOfHeader:

; ===========================================================================
; Crash/Freeze the 68000.

ErrorTrap:
		nop
		nop
		bra.s	ErrorTrap
; ===========================================================================

EntryPoint:
		tst.l	(z80_port_1_control).l
loc_20C:
		bne.w	loc_306
		tst.w	(z80_expansion_control).l
		bne.s	loc_20C
		lea	SetupValues(pc),a5
		movem.l	(a5)+,d5-a4
		move.w	-$1100(a1),d0
		andi.w	#$F00,d0
		beq.s	loc_232
		move.l	#"SEGA",$2F00(a1)

loc_232:
		move.w	(a4),d0
		moveq	#0,d0
		movea.l	d0,a6
		move.l	a6,usp
		moveq	#$18-1,d1

loc_23C:
		move.b	(a5)+,d5
		move.w	d5,(a4)
		add.w	d7,d5
		dbf	d1,loc_23C
		move.l	#$40000080,(a4)
		move.w	d0,(a3)
		move.w	d7,(a1)
		move.w	d7,(a2)

loc_252:
		btst	d0,(a1)
		bne.s	loc_252
		moveq	#$28-1,d2

loc_258:
		move.b	(a5)+,(a0)+
		dbf	d2,loc_258
		move.w	d0,(a2)
		move.w	d0,(a1)
		move.w	d7,(a2)

loc_264:
		move.l	d0,-(a6)
		dbf	d6,loc_264
		move.l	#$81048F02,(a4)
		move.l	#$C0000000,(a4)
		moveq	#($80)/4-1,d3

loc_278:
		move.l	d0,(a3)
		dbf	d3,loc_278
		move.l	#$40000010,(a4)
		moveq	#($50)/4-1,d4

loc_286:
		move.l	d0,(a3)
		dbf	d4,loc_286
		moveq	#4-1,d5

loc_28E:
		move.b	(a5)+,$10(a3)
		dbf	d5,loc_28E
		move.w	d0,(a2)
		movem.l	(a6),d0-a6
		disable_ints
		bra.s	loc_306
; ---------------------------------------------------------------------------
SetupValues:	dc.l $8000				; VDP register start number
		dc.l $3FFF				; size of RAM\4
		dc.l $100				; VDP register diff

		dc.l z80_ram				; start of Z80 RAM
		dc.l z80_bus_request			; Z80 bus request
		dc.l z80_reset				; Z80 reset
		dc.l vdp_data_port			; VDP data
		dc.l vdp_control_port			; VDP control

		; VDP register values, $8000-$9700 (for initialization)
		dc.b 4
		dc.b $14
		dc.b $30
		dc.b $3C
		dc.b 7
		dc.b $6C
		dc.b 0
		dc.b 0
		dc.b 0
		dc.b 0
		dc.b $FF
		dc.b 0
		dc.b $81
		dc.b $37
		dc.b 0
		dc.b 1
		dc.b 1
		dc.b 0
		dc.b 0
		dc.b $FF
		dc.b $FF
		dc.b 0
		dc.b 0
		dc.b $80
		even

		; Z80 initalization
	save
	cpu z80
		xor	a
		ld	bc,1FD7h
		ld	de,29h
		ld	hl,28h
		ld	sp,hl
		ld	(hl),a
		ldir
		pop	ix
		pop	iy
		ld	i,a
		ld	r,a
		ex	af,af'
		exx
		pop	af
		pop	bc
		pop	de
		pop	hl
		ex	af,af'
		exx
		pop	af
		pop	de
		pop	hl
		ld	sp,hl
		di
		im	1
		ld	(hl),0E9h
		jp	(hl)
	restore
	padding off

		dc.b $9F,$BF,$DF,$FF			; values for PSG channel volumes
		even
; ---------------------------------------------------------------------------

loc_306:
		btst	#6,(z80_expansion_control+1).l
		beq.s	DoChecksum
		cmpi.l	#"init",(v_init).w
		beq.w	loc_36A

DoChecksum:
		movea.l	#EndOfHeader,a0
		movea.l	#RomEndLoc,a1
		move.l	(a1),d0
		moveq	#0,d1

loc_32C:
		add.w	(a0)+,d1
		cmp.l	a0,d0
		bhs.s	loc_32C
		movea.l	#Checksum,a1
		cmp.w	(a1),d1
		nop
		nop
		lea	(v_crossresetram).w,a6
		moveq	#0,d7
		move.w	#bytesToLcnt(v_end-v_crossresetram),d6

loc_348:
		move.l	d7,(a6)+
		dbf	d6,loc_348
		move.b	(z80_version).l,d0
		andi.b	#$C0,d0
		move.b	d0,(v_megadrive).w
		move.w	#1,(word_FFFFE0).w
		move.l	#"init",(v_init).w

loc_36A:
		lea	(v_start&$FFFFFF).l,a6
		moveq	#0,d7
		move.w	#bytesToLcnt(v_crossresetram-v_start),d6

loc_376:
		move.l	d7,(a6)+
		dbf	d6,loc_376
		bsr.w	VDPSetupGame
		bsr.w	SoundDriverLoad
		bsr.w	padInit
		move.b	#id_Sega,(v_gamemode).w

ScreensLoop:
		move.b	(v_gamemode).w,d0
		andi.w	#$1C,d0
		jsr	GameModeArray(pc,d0.w)
		bra.s	ScreensLoop
; ---------------------------------------------------------------------------

GameModeArray:

ptr_GM_Sega:	bra.w	GM_Sega
; ---------------------------------------------------------------------------
ptr_GM_Title:	bra.w	GM_Title
; ---------------------------------------------------------------------------
ptr_GM_Demo:	bra.w	GM_Level
; ---------------------------------------------------------------------------
ptr_GM_Level:	bra.w	GM_Level
; ---------------------------------------------------------------------------
ptr_GM_Special:	bra.w	GM_Special
; ---------------------------------------------------------------------------
		rts
; ---------------------------------------------------------------------------

; Unused, as the checksum check doesn't care if the checksum is wrong.
ChecksumError:
		bsr.w	VDPSetupGame
		move.l	#$C0000000,(vdp_control_port).l	; Set VDP to CRAM write
		moveq	#bytesToWcnt(v_palette_end-v_palette),d7

.palette:
		move.w	#cRed,(vdp_data_port).l		; Write red to data
		dbf	d7,.palette
		bra.s	*
; ---------------------------------------------------------------------------

BusError:
		move.b	#2,(v_errortype).w
		bra.s	ErrorAddress
; ---------------------------------------------------------------------------

AddressError:
		move.b	#4,(v_errortype).w
		bra.s	ErrorAddress
; ---------------------------------------------------------------------------

IllegalInstr:
		move.b	#6,(v_errortype).w
		addq.l	#2,2(sp)
		bra.s	ErrorNormal
; ---------------------------------------------------------------------------

ZeroDivide:
		move.b	#8,(v_errortype).w
		bra.s	ErrorNormal
; ---------------------------------------------------------------------------

ChkInstr:
		move.b	#$A,(v_errortype).w
		bra.s	ErrorNormal
; ---------------------------------------------------------------------------

TrapvInstr:
		move.b	#$C,(v_errortype).w
		bra.s	ErrorNormal
; ---------------------------------------------------------------------------

PrivilegeViol:
		move.b	#$E,(v_errortype).w
		bra.s	ErrorNormal
; ---------------------------------------------------------------------------

Trace:
		move.b	#$10,(v_errortype).w
		bra.s	ErrorNormal
; ---------------------------------------------------------------------------

Line1010Emu:
		move.b	#$12,(v_errortype).w
		addq.l	#2,2(sp)
		bra.s	ErrorNormal
; ---------------------------------------------------------------------------

Line1111Emu:
		move.b	#$14,(v_errortype).w
		addq.l	#2,2(sp)
		bra.s	ErrorNormal
; ---------------------------------------------------------------------------

ErrorExcept:
		move.b	#0,(v_errortype).w
		bra.s	ErrorNormal
; ---------------------------------------------------------------------------

ErrorAddress:
		disable_ints
		addq.w	#2,sp
		move.l	(sp)+,(v_spbuffer).w
		addq.w	#2,sp
		movem.l	d0-sp,(v_regbuffer).w
		bsr.w	ErrorPrint
		move.l	2(sp),d0
		bsr.w	ErrorPrintAddr
		move.l	(v_spbuffer).w,d0
		bsr.w	ErrorPrintAddr
		bra.s	loc_472
; ---------------------------------------------------------------------------

ErrorNormal:
		disable_ints
		movem.l	d0-sp,(v_regbuffer).w
		bsr.w	ErrorPrint
		move.l	2(sp),d0
		bsr.w	ErrorPrintAddr

loc_472:
		bsr.w	ErrorWaitInput
		movem.l	(v_regbuffer).w,d0-sp
		enable_ints
		rte
; ---------------------------------------------------------------------------

ErrorPrint:
		lea	(vdp_data_port).l,a6
		locVRAM	$F800
		lea	(Art_Text).l,a0
		move.w	#bytesToWcnt(Art_Text_end-Art_Text-tile_size),d1

.loadart:
		move.w	(a0)+,(a6)
		dbf	d1,.loadart
		moveq	#0,d0
		move.b	(v_errortype).w,d0
		move.w	Error_Text(pc,d0.w),d0
		lea	Error_Text(pc,d0.w),a0
		locVRAM (vram_fg+$604)
		moveq	#$13-1,d1

.loadtext:
		moveq	#0,d0
		move.b	(a0)+,d0
		addi.w	#$790,d0
		move.w	d0,(a6)
		dbf	d1,.loadtext
		rts
; ---------------------------------------------------------------------------

Error_Text:	dc.w .exception-Error_Text
		dc.w .bus-Error_Text
		dc.w .address-Error_Text
		dc.w .illinstruct-Error_Text
		dc.w .zerodivide-Error_Text
		dc.w .chkinstruct-Error_Text
		dc.w .trapv-Error_Text
		dc.w .privilege-Error_Text
		dc.w .trace-Error_Text
		dc.w .line1010-Error_Text
		dc.w .line1111-Error_Text
.exception:	dc.b "ERROR EXCEPTION    "
.bus:		dc.b "BUS ERROR          "
.address:	dc.b "ADDRESS ERROR      "
.illinstruct:	dc.b "ILLEGAL INSTRUCTION"
.zerodivide:	dc.b "@ERO DIVIDE        "
.chkinstruct:	dc.b "CHK INSTRUCTION    "
.trapv:		dc.b "TRAPV INSTRUCTION  "
.privilege:	dc.b "PRIVILEGE VIOLATION"
.trace:		dc.b "TRACE              "
.line1010:	dc.b "LINE 1010 EMULATOR "
.line1111:	dc.b "LINE 1111 EMULATOR "
		even
; ---------------------------------------------------------------------------

ErrorPrintAddr:
		move.w	#$7CA,(a6)
		moveq	#8-1,d2

loc_5BA:
		rol.l	#4,d0
		bsr.s	sub_5C4
		dbf	d2,loc_5BA
		rts
; ---------------------------------------------------------------------------

sub_5C4:
		move.w	d0,d1
		andi.w	#$F,d1
		cmpi.w	#$A,d1
		bcs.s	loc_5D2
		addq.w	#7,d1

loc_5D2:
		addi.w	#$7C0,d1
		move.w	d1,(a6)
		rts
; ---------------------------------------------------------------------------

ErrorWaitInput:
		bsr.w	ReadJoypads
		cmpi.b	#btnC,(v_jpadpress1).w
		bne.w	ErrorWaitInput
		rts
; ---------------------------------------------------------------------------
Art_Text:	binclude "artunc/menutext.bin"
Art_Text_end:	even
; ---------------------------------------------------------------------------

VBlank:
		movem.l	d0-a6,-(sp)
		tst.b	(v_vbla_routine).w
		beq.s	VBla_Exit
		move.w	(vdp_control_port).l,d0
		move.l	#$40000010,(vdp_control_port).l
		move.l	(v_scrposy_dup).w,(vdp_data_port).l
		btst	#6,(v_megadrive).w	; are we on a PAL machine?
		beq.s	.notPAL	; if not, branch
		move.w	#$700,d0	; intentionally lag the system to move the CRAM dots
		dbf	d0,*

.notPAL:
		move.b	(v_vbla_routine).w,d0
		move.b	#0,(v_vbla_routine).w
		move.w	#1,(f_hblank).w
		andi.w	#$3E,d0
		move.w	VBla_Index(pc,d0.w),d0
		jsr	VBla_Index(pc,d0.w)

VBla_Exit:
		addq.l	#1,(v_vbla_count).w
		jsr	(UpdateMusic).l
		movem.l	(sp)+,d0-a6
		rte
; ---------------------------------------------------------------------------

VBla_00:
		rts
; ---------------------------------------------------------------------------

VBla_Index:	dc.w VBla_00-VBla_Index
		dc.w VBla_02-VBla_Index
		dc.w VBla_04-VBla_Index
		dc.w VBla_06-VBla_Index
		dc.w VBla_08-VBla_Index
		dc.w VBla_0A-VBla_Index
		dc.w VBla_0C-VBla_Index
		dc.w VBla_0E-VBla_Index
		dc.w VBla_10-VBla_Index
		dc.w VBla_12-VBla_Index
; ---------------------------------------------------------------------------

VBla_02:
		bsr.w	sub_E78
		tst.w	(v_demolength).w
		beq.w	.end
		subq.w	#1,(v_demolength).w

.end:
		rts
; ---------------------------------------------------------------------------

VBla_04:
		bsr.w	sub_E78
		bsr.w	LoadTilesAsYouMove_BGOnly
		bsr.w	sub_1438
		tst.w	(v_demolength).w
		beq.w	.end
		subq.w	#1,(v_demolength).w

.end:
		rts
; ---------------------------------------------------------------------------

VBla_06:
		bsr.w	sub_E78
		rts
; ---------------------------------------------------------------------------

VBla_10:
		cmpi.b	#id_Special,(v_gamemode).w
		beq.w	VBla_0A

VBla_08:
		bsr.w	ReadJoypads
		stopZ80
		waitZ80
		writeCRAM	v_palette,0
		writeVRAM	v_hscrolltablebuffer,vram_hscroll
		move.w	#$8407,(a5)
		move.w	(v_hbla_hreg).w,(a5)
		move.w	(v_bg3scrposy_vdp).w,(v_bg3scrposy_vdp_dup).w
		writeVRAM	v_spritetablebuffer,vram_sprites
		tst.b	(f_sonframechg).w
		beq.s	.nochg
		writeVRAM	v_sgfx_buffer,vram_sonic ; load new Sonic gfx
		move.b	#0,(f_sonframechg).w

.nochg:
		startZ80
		bsr.w	LoadTilesAsYouMove
		jsr	(AnimateLevelGfx).l
		jsr	(UpdateHUD).l
		bsr.w	loc_1454
		moveq	#0,d0
		move.b	(byte_FFF628).w,d0
		move.b	(byte_FFF629).w,d1
		cmp.b	d0,d1
		bhs.s	loc_CA8
		move.b	d0,(byte_FFF629).w

loc_CA8:
		move.b	#0,(byte_FFF628).w
		tst.w	(v_demolength).w
		beq.w	.end
		subq.w	#1,(v_demolength).w

.end:
		rts
; ---------------------------------------------------------------------------

VBla_0A:
		bsr.w	ReadJoypads
		stopZ80
		waitZ80
		writeCRAM	v_palette,0
		writeVRAM	v_spritetablebuffer,vram_sprites
		writeVRAM	v_hscrolltablebuffer,vram_hscroll
		startZ80
		bsr.w	SS_PalCycle
		tst.b	(f_sonframechg).w
		beq.s	.nochg
		writeVRAM	v_sgfx_buffer,vram_sonic ; load new Sonic gfx
		move.b	#0,(f_sonframechg).w

.nochg:
		tst.w	(v_demolength).w
		beq.w	.end
		subq.w	#1,(v_demolength).w

.end:
		rts
; ---------------------------------------------------------------------------

VBla_0C:
		bsr.w	ReadJoypads
		stopZ80
		waitZ80
		writeCRAM	v_palette,0
		writeVRAM	v_spritetablebuffer,vram_sprites
		writeVRAM	v_hscrolltablebuffer,vram_hscroll
		tst.b	(f_sonframechg).w
		beq.s	.nochg
		writeVRAM	v_sgfx_buffer,vram_sonic ; load new Sonic gfx
		move.b	#0,(f_sonframechg).w

.nochg:
		startZ80
		bsr.w	LoadTilesAsYouMove
		jsr	(AnimateLevelGfx).l
		jsr	(UpdateHUD).l
		bsr.w	sub_1438
		rts
; ---------------------------------------------------------------------------

VBla_0E:
		bsr.w	sub_E78
		bsr.w	ExecuteObjects
		bsr.w	BuildSprites
		addq.b	#1,(byte_FFF628).w
		move.b	#$E,(v_vbla_routine).w
		rts
; ---------------------------------------------------------------------------

VBla_12:
		bsr.w	sub_E78
		bra.w	sub_1438
; ---------------------------------------------------------------------------

sub_E78:
		bsr.w	ReadJoypads
		stopZ80
		waitZ80
		writeCRAM	v_palette,0
		writeVRAM	v_spritetablebuffer,vram_sprites
		writeVRAM	v_hscrolltablebuffer,vram_hscroll
		startZ80
		rts
; ---------------------------------------------------------------------------

HBlank:
		tst.w	(f_hblank).w
		beq.s	.locret
		move.l	a5,-(sp)
		writeCRAM	v_palette_fading,0
		movem.l	(sp)+,a5
		move.w	#0,(f_hblank).w

.locret:
		rte
; ---------------------------------------------------------------------------

HBlank2:
		tst.w	(f_hblank).w
		beq.s	.locret
		movem.l	d0/a0/a5,-(sp)
		move.w	#0,(f_hblank).w
		move.w	#$8405,(vdp_control_port).l
		move.w	#$857C,(vdp_control_port).l
		locVRAM $F800
		lea	(v_spritetablebuffer).w,a0
		lea	(vdp_data_port).l,a5
		move.w	#bytesToLcnt(v_spritetablebuffer_end-v_spritetablebuffer),d0

.loop:
		move.l	(a0)+,(a5)
		dbf	d0,.loop
		movem.l	(sp)+,d0/a0/a5

.locret:
		rte
; ---------------------------------------------------------------------------

padInit:
		stopZ80
		waitZ80
		moveq	#$40,d0
		move.b	d0,($A10009).l
		move.b	d0,($A1000B).l
		move.b	d0,($A1000D).l
		startZ80
		rts
; ---------------------------------------------------------------------------

ReadJoypads:
		stopZ80
		waitZ80
		lea	(v_jpadhold1).w,a0
		lea	(z80_port_1_data+1).l,a1
		bsr.s	Joypad_Read
		addq.w	#2,a1
		bsr.s	Joypad_Read
		startZ80
		rts
; ---------------------------------------------------------------------------

Joypad_Read:
		move.b	#0,(a1)
		nop
		nop
		move.b	(a1),d0
		lsl.b	#2,d0
		andi.b	#$C0,d0
		move.b	#$40,(a1)
		nop
		nop
		move.b	(a1),d1
		andi.b	#$3F,d1
		or.b	d1,d0
		not.b	d0
		move.b	(a0),d1
		eor.b	d0,d1
		move.b	d0,(a0)+
		and.b	d0,d1
		move.b	d1,(a0)+
		rts
; ---------------------------------------------------------------------------

VDPSetupGame:
		lea	(vdp_control_port).l,a0
		lea	(vdp_data_port).l,a1
		lea	(VDPSetupArray).l,a2
		moveq	#bytesToWcnt(VDPSetupArray_End-VDPSetupArray),d7

loc_101E:
		move.w	(a2)+,(a0)
		dbf	d7,loc_101E
		move.w	(VDPSetupArray+2).l,d0
		move.w	d0,(v_vdp_buffer1).w
		moveq	#0,d0
		move.l	#$C0000000,(vdp_control_port).l
		move.w	#bytesToWcnt(v_palette_end-v_palette),d7

loc_103E:
		move.w	d0,(a1)
		dbf	d7,loc_103E
		clr.l	(v_scrposy_dup).w
		clr.l	(v_scrposx_dup).w
		move.l	d1,-(sp)
		fillVRAM	0,0,$10000
		move.l	(sp)+,d1
		rts
; ---------------------------------------------------------------------------
VDPSetupArray:	dc.w $8004
		dc.w $8134
		dc.w $8230
		dc.w $8328
		dc.w $8407
		dc.w $857C
		dc.w $8600
		dc.w $8700
		dc.w $8800
		dc.w $8900
		dc.w $8A00
		dc.w $8B00
		dc.w $8C81
		dc.w $8D3F
		dc.w $8E00
		dc.w $8F02
		dc.w $9001
		dc.w $9100
		dc.w $9200
VDPSetupArray_End:
		even
; ---------------------------------------------------------------------------

ClearScreen:
		fillVRAM	0, vram_fg, vram_fg+plane_size_64x32		; clear foreground namespace
		fillVRAM	0, vram_bg, vram_bg+plane_size_64x32		; clear background namespace

		move.l	#0,(v_scrposy_dup).w
		move.l	#0,(v_scrposx_dup).w

		clearRAM v_spritetablebuffer,v_spritetablebuffer_end+4	; This clears too much RAM, but this won't effect much since water palettes don't exist.
		clearRAM v_hscrolltablebuffer,v_hscrolltablebuffer_end_padded+4	; This clears too much RAM, leading to a slight bug (first bit of the Sonic object's RAM is cleared)

		rts
; ---------------------------------------------------------------------------

SoundDriverLoad:
		nop
		stopZ80
		resetZ80
		lea	(Unc_Z80).l,a0
		lea	(z80_ram).l,a1
		move.w	#(Unc_Z80_End-Unc_Z80)-1,d0

.loop:
		move.b	(a0)+,(a1)+
		dbf	d0,.loop
		moveq	#0,d0
		lea	(z80_dac_unk1FF8).l,a1
		move.b	d0,(a1)+	; Write 0 to 1FF8
		move.b	#$80,(a1)+	; Write $80 to 1FF9
		move.b	#7,(a1)+	; Write 7 to 1FFA
		move.b	#$80,(a1)+	; Write $80 to 1FFB
		move.b	d0,(a1)+	; Write 0 to 1FFC
		move.b	d0,(a1)+	; Write 0 to 1FFD
		move.b	d0,(a1)+	; Write 0 to 1FFE
		move.b	d0,(a1)+	; Write 0 to 1FFF
		resetZ80a
		nop
		nop
		nop
		nop
		resetZ80
		startZ80
		rts
; ---------------------------------------------------------------------------
; This could potentially be leftover Z80 variables for the above, unused
; ---------------------------------------------------------------------------
;unk_119C:
		dc.b 3
		dc.b 0
		dc.b 0
		dc.b $14
		dc.b 0
		dc.b 0
		dc.b 0
		dc.b 0
		even
; ---------------------------------------------------------------------------

PlaySound:
		move.b	d0,(v_snddriver_ram.v_soundqueue0).w
		rts
; ---------------------------------------------------------------------------

PlaySound_Special:
		move.b	d0,(v_snddriver_ram.v_soundqueue1).w
		rts
; ---------------------------------------------------------------------------
PlaySound_Unused:
		move.b	d0,(v_snddriver_ram.v_soundqueue2).w
		rts

		include "_inc/PauseGame.asm"
; ---------------------------------------------------------------------------

TilemapToVRAM:
		lea	(vdp_data_port).l,a6
		move.l	#$800000,d4

loc_1222:
		move.l	d0,4(a6)
		move.w	d1,d3

loc_1228:
		move.w	(a1)+,(a6)
		dbf	d3,loc_1228
		add.l	d4,d0
		dbf	d2,loc_1222
		rts
; ---------------------------------------------------------------------------
		include "_inc/Nemesis Decompression.asm"
; ---------------------------------------------------------------------------

AddPLC:
		movem.l	a1-a2,-(sp)
		lea	(ArtLoadCues).l,a1
		add.w	d0,d0
		move.w	(a1,d0.w),d0
		lea	(a1,d0.w),a1
		lea	(v_plc_buffer).w,a2

loc_138E:
		tst.l	(a2)
		beq.s	loc_1396
		addq.w	#6,a2
		bra.s	loc_138E
; ---------------------------------------------------------------------------

loc_1396:
		move.w	(a1)+,d0
		bmi.s	loc_13A2

loc_139A:
		move.l	(a1)+,(a2)+
		move.w	(a1)+,(a2)+
		dbf	d0,loc_139A

loc_13A2:
		movem.l	(sp)+,a1-a2
		rts

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||
; Queue pattern load requests, but clear the PLQ first

; ARGUMENTS
; d0 = index of PLC list (see ArtLoadCues)

; NOTICE: This subroutine does not check for buffer overruns. The programmer
;	  (or hacker) is responsible for making sure that no more than
;	  16 load requests are copied into the buffer.
;	  _________DO NOT PUT MORE THAN 16 LOAD REQUESTS IN A LIST!__________
;	  (or if you change the size of Plc_Buffer, the limit becomes (Plc_Buffer_Only_End-Plc_Buffer)/6)

; LoadPLC2:
NewPLC:
		movem.l	a1-a2,-(sp)
		lea	(ArtLoadCues).l,a1
		add.w	d0,d0
		move.w	(a1,d0.w),d0
		lea	(a1,d0.w),a1			; jump to relevant PLC
		bsr.s	ClearPLC			; erase any data in PLC buffer space
		lea	(v_plc_buffer).w,a2
		move.w	(a1)+,d0			; get length of PLC
		bmi.s	.skip				; if it's negative, skip the next loop

	.loop:
		move.l	(a1)+,(a2)+
		move.w	(a1)+,(a2)+			; copy PLC to RAM
		dbf	d0,.loop			; repeat for length of PLC

	.skip:
		movem.l	(sp)+,a1-a2
		rts
; End of function NewPLC

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||

; ---------------------------------------------------------------------------
; Subroutine to	clear the pattern load cues
; ---------------------------------------------------------------------------

; Clear the pattern load queue ($FFF680 - $FFF700)


ClearPLC:
		lea	(v_plc_buffer).w,a2		; PLC buffer space in RAM
		moveq	#bytesToLcnt(v_plc_buffer_end-v_plc_buffer),d0

	.loop:
		clr.l	(a2)+
		dbf	d0,.loop
		rts
; End of function ClearPLC
; ---------------------------------------------------------------------------

RunPLC:
		tst.l	(v_plc_buffer).w
		beq.s	locret_1436
		tst.w	(f_plc_execute).w
		bne.s	locret_1436
		movea.l	(v_plc_buffer).w,a0
		lea	(NemPCD_WriteRowToVDP).l,a3
		lea	(v_ngfx_buffer).w,a1
		move.w	(a0)+,d2
		bpl.s	loc_1404
		adda.w	#NemPCD_WriteRowToVDP_XOR-NemPCD_WriteRowToVDP,a3

loc_1404:
		andi.w	#$7FFF,d2
		move.w	d2,(f_plc_execute).w
		bsr.w	NemDec_BuildCodeTable
		move.b	(a0)+,d5
		asl.w	#8,d5
		move.b	(a0)+,d5
		moveq	#$10,d6
		moveq	#0,d0
		move.l	a0,(v_plc_buffer).w
		move.l	a3,(v_plc_buffer_reg0).w
		move.l	d0,(v_plc_buffer_reg4).w
		move.l	d0,(v_plc_buffer_reg8).w
		move.l	d0,(v_plc_buffer_regC).w
		move.l	d5,(v_plc_buffer_reg10).w
		move.l	d6,(v_plc_buffer_reg14).w

locret_1436:
		rts
; ---------------------------------------------------------------------------

sub_1438:
		tst.w	(f_plc_execute).w
		beq.w	locret_14D0
		move.w	#9,(v_plc_buffer_reg1A).w
		moveq	#0,d0
		move.w	(v_plc_buffer+4).w,d0
		addi.w	#$120,(v_plc_buffer+4).w
		bra.s	loc_146C
; ---------------------------------------------------------------------------

loc_1454:
		tst.w	(f_plc_execute).w
		beq.s	locret_14D0
		move.w	#3,(v_plc_buffer_reg1A).w
		moveq	#0,d0
		move.w	(v_plc_buffer+4).w,d0
		addi.w	#$60,(v_plc_buffer+4).w

loc_146C:
		lea	(vdp_control_port).l,a4
		lsl.l	#2,d0
		lsr.w	#2,d0
		ori.w	#$4000,d0
		swap	d0
		move.l	d0,(a4)
		subq.w	#4,a4
		movea.l	(v_plc_buffer).w,a0
		movea.l	(v_plc_buffer_reg0).w,a3
		move.l	(v_plc_buffer_reg4).w,d0
		move.l	(v_plc_buffer_reg8).w,d1
		move.l	(v_plc_buffer_regC).w,d2
		move.l	(v_plc_buffer_reg10).w,d5
		move.l	(v_plc_buffer_reg14).w,d6
		lea	(v_ngfx_buffer).w,a1

loc_14A0:
		movea.w	#8,a5
		bsr.w	NemPCD_NewRow
		subq.w	#1,(f_plc_execute).w
		beq.s	ShiftPLC
		subq.w	#1,(v_plc_buffer_reg1A).w
		bne.s	loc_14A0
		move.l	a0,(v_plc_buffer).w

loc_14B8:
		move.l	a3,(v_plc_buffer_reg0).w
		move.l	d0,(v_plc_buffer_reg4).w
		move.l	d1,(v_plc_buffer_reg8).w
		move.l	d2,(v_plc_buffer_regC).w
		move.l	d5,(v_plc_buffer_reg10).w
		move.l	d6,(v_plc_buffer_reg14).w

locret_14D0:
		rts
; ---------------------------------------------------------------------------

ShiftPLC:
		lea	(v_plc_buffer).w,a0
		moveq	#bytesToLcnt(v_plc_buffer_only_end-v_plc_buffer-6),d0

loc_14D8:
		move.l	6(a0),(a0)+
		dbf	d0,loc_14D8
		rts
; ---------------------------------------------------------------------------

QuickPLC:
		lea	(ArtLoadCues).l,a1
		add.w	d0,d0
		move.w	(a1,d0.w),d0
		lea	(a1,d0.w),a1
		move.w	(a1)+,d1

loc_14F4:
		movea.l	(a1)+,a0
		moveq	#0,d0
		move.w	(a1)+,d0
		lsl.l	#2,d0
		lsr.w	#2,d0
		ori.w	#$4000,d0
		swap	d0
		move.l	d0,(vdp_control_port).l
		bsr.w	NemDec
		dbf	d1,loc_14F4
		rts
; ---------------------------------------------------------------------------

		include "_inc/Enigma Decompression.asm"
		include "_inc/Kosinski Decompression.asm"
		include "_inc/PaletteCycle.asm"

Cyc_Title:	binclude "palette/Cycle - Title.bin"
		even
Cyc_GHZ:	binclude "palette/Cycle - GHZ.bin"
		even
Cyc_LZ:		binclude "palette/Cycle - LZ (Unused).bin"
		even
Cyc_MZ:		binclude "palette/Cycle - MZ (Unused).bin"
		even
Cyc_SLZ:	binclude "palette/Cycle - SLZ.bin"
		even
Cyc_SZ1:	binclude "palette/Cycle - SZ1.bin"
		even
Cyc_SZ2:	binclude "palette/Cycle - SZ2.bin"
		even
; ---------------------------------------------------------------------------

PaletteWhiteIn:
		move.w	#$3F,(v_pfade_start).w

PaletteWhiteIn_Sub:
		moveq	#0,d0
		lea	(v_palette).w,a0
		move.b	(v_pfade_start).w,d0
		adda.w	d0,a0
		moveq	#0,d1
		move.b	(v_pfade_size).w,d0

loc_1968:
		move.w	d1,(a0)+
		dbf	d0,loc_1968
		move.w	#$15-1,d4

loc_1972:
		move.b	#$12,(v_vbla_routine).w
		bsr.w	WaitForVBla
		bsr.s	sub_1988
		bsr.w	RunPLC
		dbf	d4,loc_1972
		rts
; ---------------------------------------------------------------------------

sub_1988:
		moveq	#0,d0
		lea	(v_palette).w,a0
		lea	(v_palette_fading).w,a1
		move.b	(v_pfade_start).w,d0
		adda.w	d0,a0
		adda.w	d0,a1
		move.b	(v_pfade_size).w,d0

loc_199E:
		bsr.s	sub_19A6
		dbf	d0,loc_199E
		rts
; ---------------------------------------------------------------------------

sub_19A6:
		move.w	(a1)+,d2
		move.w	(a0),d3
		cmp.w	d2,d3
		beq.s	loc_19CE
		move.w	d3,d1
		addi.w	#$200,d1
		cmp.w	d2,d1
		bhi.s	loc_19BC
		move.w	d1,(a0)+
		rts
; ---------------------------------------------------------------------------

loc_19BC:
		move.w	d3,d1
		addi.w	#$20,d1
		cmp.w	d2,d1
		bhi.s	loc_19CA
		move.w	d1,(a0)+
		rts
; ---------------------------------------------------------------------------

loc_19CA:
		addq.w	#2,(a0)+
		rts
; ---------------------------------------------------------------------------

loc_19CE:
		addq.w	#2,a0
		rts
; ---------------------------------------------------------------------------

PaletteFadeOut:
		move.w	#$3F,(v_pfade_start).w
		move.w	#$15-1,d4

loc_19DC:
		move.b	#$12,(v_vbla_routine).w
		bsr.w	WaitForVBla
		bsr.s	FadeOut_ToBlack
		bsr.w	RunPLC
		dbf	d4,loc_19DC
		rts
; ---------------------------------------------------------------------------

FadeOut_ToBlack:
		moveq	#0,d0
		lea	(v_palette).w,a0
		move.b	(v_pfade_start).w,d0
		adda.w	d0,a0
		move.b	(v_pfade_size).w,d0

loc_1A02:
		bsr.s	sub_1A0A
		dbf	d0,loc_1A02
		rts
; ---------------------------------------------------------------------------

sub_1A0A:
		move.w	(a0),d2
		beq.s	loc_1A36
		move.w	d2,d1
		andi.w	#$E,d1
		beq.s	loc_1A1A
		subq.w	#2,(a0)+
		rts
; ---------------------------------------------------------------------------

loc_1A1A:
		move.w	d2,d1
		andi.w	#$E0,d1
		beq.s	loc_1A28
		subi.w	#$20,(a0)+
		rts
; ---------------------------------------------------------------------------

loc_1A28:
		move.w	d2,d1
		andi.w	#$E00,d1
		beq.s	loc_1A36
		subi.w	#$200,(a0)+
		rts
; ---------------------------------------------------------------------------

loc_1A36:
		addq.w	#2,a0
		rts
; ---------------------------------------------------------------------------

PalCycSega:
		subq.w	#1,(v_pcyc_time).w
		bpl.s	.locret
		move.w	#3,(v_pcyc_time).w
		move.w	(v_pcyc_num).w,d0
		bmi.s	.locret
		subq.w	#2,(v_pcyc_num).w
		lea	(Cyc_Sega).l,a0
		lea	(v_palette+4).w,a1
		adda.w	d0,a0
		move.l	(a0)+,(a1)+
		move.l	(a0)+,(a1)+
		move.l	(a0)+,(a1)+
		move.l	(a0)+,(a1)+
		move.l	(a0)+,(a1)+
		move.w	(a0)+,(a1)+

.locret:
		rts
; ---------------------------------------------------------------------------
Cyc_Sega:	binclude "palette/Cycle - Sega.bin"
		even
; ---------------------------------------------------------------------------

PalLoad1:
		lea	(PalPointers).l,a1
		lsl.w	#3,d0
		adda.w	d0,a1
		movea.l	(a1)+,a2
		movea.w	(a1)+,a3
		adda.w	#v_palette_fading-v_palette,a3
		move.w	(a1)+,d7

.loop:
		move.l	(a2)+,(a3)+
		dbf	d7,.loop
		rts
; ---------------------------------------------------------------------------

PalLoad2:
		lea	(PalPointers).l,a1
		lsl.w	#3,d0
		adda.w	d0,a1
		movea.l	(a1)+,a2
		movea.w	(a1)+,a3
		move.w	(a1)+,d7

.loop:
		move.l	(a2)+,(a3)+
		dbf	d7,.loop
		rts

		include "_inc/Palette Pointers.asm"

Pal_SegaBG:	binclude "palette/Sega Screen.bin"
		even
Pal_Title:	binclude "palette/Title Screen.bin"
		even
Pal_LevelSel:	binclude "palette/Level Select.bin"
		even
Pal_Sonic:	binclude "palette/Sonic.bin"
		even
Pal_GHZ:	binclude "palette/Green Hill Zone.bin"
		even
Pal_LZ:		binclude "palette/Labyrinth Zone.bin"
		even
Pal_Ending:	binclude "palette/Ending.bin"
		even
Pal_MZ:		binclude "palette/Marble Zone.bin"
		even
Pal_SLZ:	binclude "palette/Star Light Zone.bin"
		even
Pal_SZ:		binclude "palette/Sparkling Zone.bin"
		even
Pal_CWZ:	binclude "palette/Clock Work Zone.bin"
		even
Pal_Special:	binclude "palette/Special Stage.bin"
		even

; ---------------------------------------------------------------------------

WaitForVBla:
		enable_ints

.wait:
		tst.b	(v_vbla_routine).w
		bne.s	.wait
		rts
; ---------------------------------------------------------------------------

RandomNumber:
		move.l	(v_random).w,d1
		bne.s	.noreset
		move.l	#$2A6D365A,d1

.noreset:
		move.l	d1,d0
		asl.l	#2,d1
		add.l	d0,d1
		asl.l	#3,d1
		add.l	d0,d1
		move.w	d1,d0
		swap	d1
		add.w	d1,d0
		move.w	d0,d1
		swap	d1
		move.l	d1,(v_random).w
		rts
; ---------------------------------------------------------------------------

CalcSine:
		andi.w	#$FF,d0
		add.w	d0,d0
		addi.w	#$80,d0
		move.w	SineTable(pc,d0.w),d1
		subi.w	#$80,d0
		move.w	SineTable(pc,d0.w),d0
		rts
; ---------------------------------------------------------------------------
SineTable:	binclude "misc/sinewave.bin"
		even
; ---------------------------------------------------------------------------

;GetSqrt:						; Leftover in the final game (REV00 only)
		movem.l	d1-d2,-(sp)
		move.w	d0,d1
		swap	d1
		moveq	#0,d0
		move.w	d0,d1
		moveq	#8-1,d2

loc_22F4:
		rol.l	#2,d1
		add.w	d0,d0
		addq.w	#1,d0
		sub.w	d0,d1
		bhs.s	loc_230E
		add.w	d0,d1
		subq.w	#1,d0
		dbf	d2,loc_22F4
		lsr.w	#1,d0
		movem.l	(sp)+,d1-d2
		rts
; ---------------------------------------------------------------------------

loc_230E:
		addq.w	#1,d0
		dbf	d2,loc_22F4
		lsr.w	#1,d0
		movem.l	(sp)+,d1-d2
		rts
; ---------------------------------------------------------------------------

CalcAngle:
		movem.l	d3-d4,-(sp)
		moveq	#0,d3
		moveq	#0,d4
		move.w	d1,d3
		move.w	d2,d4
		or.w	d3,d4
		beq.s	loc_2378
		move.w	d2,d4
		tst.w	d3
		bpl.w	loc_2336
		neg.w	d3

loc_2336:
		tst.w	d4
		bpl.w	loc_233E
		neg.w	d4

loc_233E:
		cmp.w	d3,d4
		bhs.w	loc_2350
		lsl.l	#8,d4
		divu.w	d3,d4
		moveq	#0,d0
		move.b	AngleTable(pc,d4.w),d0
		bra.s	loc_235A
; ---------------------------------------------------------------------------

loc_2350:
		lsl.l	#8,d3
		divu.w	d4,d3
		moveq	#$40,d0
		sub.b	AngleTable(pc,d3.w),d0

loc_235A:
		tst.w	d1
		bpl.w	loc_2366
		neg.w	d0
		addi.w	#$80,d0

loc_2366:
		tst.w	d2
		bpl.w	loc_2372
		neg.w	d0
		addi.w	#$100,d0

loc_2372:
		movem.l	(sp)+,d3-d4
		rts
; ---------------------------------------------------------------------------

loc_2378:
		move.w	#$40,d0
		movem.l	(sp)+,d3-d4
		rts
; ---------------------------------------------------------------------------
AngleTable:	binclude "misc/angles.bin"
		even
; ---------------------------------------------------------------------------

GM_Sega:
		move.b	#bgm_Fade,d0
		bsr.w	PlaySound_Special
		bsr.w	ClearPLC
		bsr.w	PaletteFadeOut
		lea	(vdp_control_port).l,a6
		move.w	#$8004,(a6)
		move.w	#$8230,(a6)
		move.w	#$8407,(a6)
		move.w	#$8700,(a6)
		move.w	#$8B00,(a6)
		move.w	(v_vdp_buffer1).w,d0
		andi.b	#$BF,d0
		move.w	d0,(vdp_control_port).l
		bsr.w	ClearScreen
		locVRAM 0
		lea	(Nem_SegaLogo).l,a0
		bsr.w	NemDec
		lea	(v_start&$FFFFFF).l,a1
		lea	(Eni_SegaLogo).l,a0
		move.w	#0,d0
		bsr.w	EniDec

		copyTilemap	v_start&$FFFFFF,$C61C,12-1,4-1

		moveq	#palid_SegaBG,d0
		bsr.w	PalLoad2
		move.w	#$28,(v_pcyc_num).w
		move.w	#0,(v_pal_buffer+$12).w
		move.w	#0,(v_pal_buffer+$10).w
		move.w	#180,(v_demolength).w
		move.w	(v_vdp_buffer1).w,d0
		ori.b	#$40,d0
		move.w	d0,(vdp_control_port).l

loc_2528:
		move.b	#2,(v_vbla_routine).w
		bsr.w	WaitForVBla
		bsr.w	PalCycSega
		tst.w	(v_demolength).w
		beq.s	loc_2544
		andi.b	#btnStart,(v_jpadpress1).w
		beq.s	loc_2528

loc_2544:
		move.b	#id_Title,(v_gamemode).w
		rts
; ---------------------------------------------------------------------------

GM_Title:
		bsr.w	ClearPLC
		bsr.w	PaletteFadeOut
		lea	(vdp_control_port).l,a6
		move.w	#$8004,(a6)
		move.w	#$8230,(a6)
		move.w	#$8407,(a6)
		move.w	#$9001,(a6)
		move.w	#$9200,(a6)
		move.w	#$8B03,(a6)
		move.w	#$8720,(a6)
		move.w	(v_vdp_buffer1).w,d0
		andi.b	#$BF,d0
		move.w	d0,(vdp_control_port).l
		bsr.w	ClearScreen

		clearRAM v_objspace,v_objspace_end

		locVRAM $4000
		lea	(Nem_TitleFg).l,a0
		bsr.w	NemDec
		locVRAM $6000
		lea	(Nem_TitleSonic).l,a0
		bsr.w	NemDec
		lea	(vdp_data_port).l,a6
		locVRAM $D000,4(a6)
		lea	(Art_Text).l,a5
		move.w	#bytesToWcnt(Art_Text_end-Art_Text),d1

loc_25D8:
		move.w	(a5)+,(a6)
		dbf	d1,loc_25D8

		lea	(Unc_Title).l,a1

		copyUncTilemap	$C206,34-1,22-1

		move.w	#0,(v_debuguse).w
		move.w	#0,(f_demo).w
		move.w	#0,(v_zone).w
		bsr.w	LoadLevelBounds
		bsr.w	DeformLayers
		locVRAM 0
		lea	(Nem_GHZ_1st).l,a0
		bsr.w	NemDec
		lea	(Blk16_GHZ).l,a0
		lea	(v_16x16).w,a4
		move.w	#bytesToLcnt(v_16x16_end-v_16x16),d0

.loadblocks:
		move.l	(a0)+,(a4)+
		dbf	d0,.loadblocks
		lea	(Blk256_GHZ).l,a0
		lea	(v_256x256&$FFFFFF).l,a1
		bsr.w	KosDec
		bsr.w	LevelLayoutLoad
		lea	(vdp_control_port).l,a5
		lea	(vdp_data_port).l,a6
		lea	(v_bgscreenposx).w,a3
		lea	(v_lvllayoutbg).w,a4
		move.w	#$6000,d2
		bsr.w	DrawChunks
		moveq	#palid_Title,d0
		bsr.w	PalLoad1
		move.b	#bgm_Title,d0
		bsr.w	PlaySound_Special
		move.b	#0,(f_debugmode).w
		move.w	#376,(v_demolength).w		; run title screen for 376 frames
		move.b	#id_TitleSonic,(v_objslot1).w	; load big sonic object
		move.b	#id_PSBTM,(v_objslot2).w	; load press start button text
		move.b	#id_PSBTM,(v_objslot3).w	; load object which hides sonic
		move.b	#2,(v_objslot3+obFrame).w
		moveq	#plcid_Main,d0
		bsr.w	NewPLC
		move.w	(v_vdp_buffer1).w,d0
		ori.b	#$40,d0
		move.w	d0,(vdp_control_port).l
		bsr.w	PaletteWhiteIn

loc_26AE:
		move.b	#4,(v_vbla_routine).w
		bsr.w	WaitForVBla
		bsr.w	ExecuteObjects
		bsr.w	DeformLayers
		bsr.w	BuildSprites
		bsr.w	PalCycTitle
		bsr.w	RunPLC
		move.w	(v_objslot0+obX).w,d0
		addq.w	#2,d0				; set object scroll right speed
		move.w	d0,(v_objslot0+obX).w	; move sonic to the right
		cmpi.w	#$1C00,d0			; has object passed $1C00?
		bcs.s	loc_26E4			; if not, branch
		move.b	#id_Sega,(v_gamemode).w		; go to Sega Screen
		rts
; ---------------------------------------------------------------------------

loc_26E4:
		tst.w	(v_demolength).w
		beq.w	loc_27F8
		andi.b	#btnStart,(v_jpadpress1).w
		beq.w	loc_26AE
		btst	#bitA,(v_jpadhold1).w
		beq.w	loc_27AA
		moveq	#palid_LevelSel,d0
		bsr.w	PalLoad2
		clearRAM v_hscrolltablebuffer,v_hscrolltablebuffer_end
		move.l	d0,(v_scrposy_dup).w
		disable_ints
		lea	(vdp_data_port).l,a6
		move.l	#$60000003,(vdp_control_port).l
		move.w	#bytesToLcnt($1000),d1

loc_2732:
		move.l	d0,(a6)
		dbf	d1,loc_2732
		bsr.w	LevSelTextLoad

;loc_273C:
LevelSelect:
		move.b	#4,(v_vbla_routine).w
		bsr.w	WaitForVBla
		bsr.w	sub_28A6
		bsr.w	RunPLC
		tst.l	(v_plc_buffer).w
		bne.s	LevelSelect
		andi.b	#btnABC|btnStart,(v_jpadpress1).w
		beq.s	LevelSelect
		move.w	(v_levselitem).w,d0
		cmpi.w	#$13,d0
		bne.s	loc_2780
		move.w	(v_levselsound).w,d0
		addi.w	#$80,d0
		cmpi.w	#bgm__Last+2,d0			; There's no pointer for music $92 or $93
		bcs.s	loc_277A			; So the game crashes when played
		cmpi.w	#sfx__First,d0
		bcs.s	LevelSelect

loc_277A:
		bsr.w	PlaySound_Special
		bra.s	LevelSelect
; ---------------------------------------------------------------------------

loc_2780:
		add.w	d0,d0
		move.w	LevSelOrder(pc,d0.w),d0
		bmi.s	LevelSelect
		cmpi.w	#id_SS*$100,d0
		bne.s	loc_2796
		move.b	#id_Special,(v_gamemode).w
		rts
; ---------------------------------------------------------------------------

loc_2796:
		andi.w	#$3FFF,d0
		btst	#bitB,(v_jpadhold1).w		; Is B pressed?
		beq.s	loc_27A6			; If not, ignore below
		move.w	#id_GHZ+3,d0			; Set the zone to Green Hill Act 4

loc_27A6:
		move.w	d0,(v_zone).w

loc_27AA:
		move.b	#id_Level,(v_gamemode).w
		move.b	#3,(v_lives).w
		moveq	#0,d0
		move.w	d0,(v_rings).w
		move.l	d0,(v_time).w
		move.l	d0,(v_score).w
		move.b	#bgm_Fade,d0
		bsr.w	PlaySound_Special
		rts
; ---------------------------------------------------------------------------
LevSelOrder:	dc.b id_GHZ, 0				; GHZ1
		dc.b id_GHZ, 1				; GHZ2
		dc.b id_GHZ, 2				; GHZ3
		dc.b id_LZ, 0				; LZ1
		dc.b id_LZ, 1				; LZ2
		dc.b id_LZ, 2				; LZ3
		dc.b id_MZ, 0				; MZ1
		dc.b id_MZ, 1				; MZ2
		dc.b id_MZ, 2				; MZ3
		dc.b id_SLZ, 0				; SLZ1
		dc.b id_SLZ, 1				; SLZ2
		dc.b id_SLZ, 2				; SLZ3
		dc.b id_SZ, 0				; SZ1
		dc.b id_SZ, 1				; SZ2
		dc.b id_SZ, 2				; SZ3
		dc.b id_CWZ, 0				; CWZ1
		dc.b id_CWZ, 1				; CWZ2
		dc.b id_CWZ+$80, 0			; CWZ3
		dc.b id_SS, 0				; SS
		dc.b id_SS, 0				; SS (Sound Select)
		dc.w $8000
		even
; ---------------------------------------------------------------------------

loc_27F8:
		move.w	#30,(v_demolength).w

loc_27FE:
		move.b	#4,(v_vbla_routine).w
		bsr.w	WaitForVBla
		bsr.w	DeformLayers
		bsr.w	PaletteCycle
		bsr.w	RunPLC
		move.w	(v_objslot0+obX).w,d0
		addq.w	#2,d0
		move.w	d0,(v_objslot0+obX).w
		cmpi.w	#$1C00,d0
		bcs.s	loc_282C
		move.b	#id_Sega,(v_gamemode).w
		rts
; ---------------------------------------------------------------------------

loc_282C:
		tst.w	(v_demolength).w
		bne.w	loc_27FE
		move.b	#bgm_Fade,d0
		bsr.w	PlaySound_Special
		move.w	(v_demonum).w,d0
		andi.w	#7,d0
		add.w	d0,d0
		move.w	DemoLevels(pc,d0.w),d0
		move.w	d0,(v_zone).w
		addq.w	#1,(v_demonum).w
		cmpi.w	#6,(v_demonum).w
		bcs.s	loc_2860
		move.w	#0,(v_demonum).w

loc_2860:
		move.w	#1,(f_demo).w
		move.b	#id_Demo,(v_gamemode).w
		cmpi.w	#$600,d0
		bne.s	loc_2878
		move.b	#id_Special,(v_gamemode).w

loc_2878:
		move.b	#3,(v_lives).w
		moveq	#0,d0
		move.w	d0,(v_rings).w
		move.l	d0,(v_time).w
		move.l	d0,(v_score).w
		rts
; ---------------------------------------------------------------------------

DemoLevels:	binclude "misc/Demo Level Order - Intro.bin"
		even
; ---------------------------------------------------------------------------

sub_28A6:
		move.b	(v_jpadpress1).w,d1
		andi.b	#btnUp|btnDn,d1
		bne.s	loc_28B6
		subq.w	#1,(v_levseldelay).w
		bpl.s	loc_28F0

loc_28B6:
		move.w	#$B,(v_levseldelay).w
		move.b	(v_jpadhold1).w,d1
		andi.b	#btnUp|btnDn,d1
		beq.s	loc_28F0
		move.w	(v_levselitem).w,d0
		btst	#bitUp,d1
		beq.s	loc_28D6
		subq.w	#1,d0
		bhs.s	loc_28D6
		moveq	#$13,d0

loc_28D6:
		btst	#bitDn,d1
		beq.s	loc_28E6
		addq.w	#1,d0
		cmpi.w	#$14,d0
		bcs.s	loc_28E6
		moveq	#0,d0

loc_28E6:
		move.w	d0,(v_levselitem).w
		bsr.w	LevSelTextLoad
		rts
; ---------------------------------------------------------------------------

loc_28F0:
		cmpi.w	#$13,(v_levselitem).w
		bne.s	locret_292A
		move.b	(v_jpadpress1).w,d1
		andi.b	#btnL|btnR,d1
		beq.s	locret_292A
		move.w	(v_levselsound).w,d0
		btst	#bitL,d1
		beq.s	loc_2912
		subq.w	#1,d0
		bhs.s	loc_2912
		moveq	#$4F,d0

loc_2912:
		btst	#bitR,d1
		beq.s	loc_2922
		addq.w	#1,d0
		cmpi.w	#$50,d0
		bcs.s	loc_2922
		moveq	#0,d0

loc_2922:
		move.w	d0,(v_levselsound).w
		bsr.w	LevSelTextLoad

locret_292A:
		rts
; ---------------------------------------------------------------------------

LevSelTextLoad:
		lea	(LevelSelectText).l,a1
		lea	(vdp_data_port).l,a6
		move.l	#$62100003,d4
		move.w	#$E680,d3
		moveq	#$13,d1				; Only load 13 lines.

loc_2944:
		move.l	d4,4(a6)
		bsr.w	sub_29CC
		addi.l	#$800000,d4
		dbf	d1,loc_2944
		moveq	#0,d0
		move.w	(v_levselitem).w,d0
		move.w	d0,d1
		move.l	#$62100003,d4
		lsl.w	#7,d0
		swap	d0
		add.l	d0,d4
		lea	(LevelSelectText).l,a1
		lsl.w	#3,d1
		move.w	d1,d0
		add.w	d1,d1
		add.w	d0,d1
		adda.w	d1,a1
		move.w	#$C680,d3
		move.l	d4,4(a6)
		bsr.w	sub_29CC
		move.w	#$E680,d3
		cmpi.w	#$13,(v_levselitem).w		; are we on Sound Select?
		bne.s	loc_2996			; if not, branch
		move.w	#$C680,d3

loc_2996:
		locVRAM $EBB0
		move.w	(v_levselsound).w,d0
		addi.w	#$80,d0
		move.b	d0,d2
		lsr.b	#4,d0
		bsr.w	sub_29B8
		move.b	d2,d0
		bsr.w	sub_29B8
		rts
; ---------------------------------------------------------------------------

sub_29B8:
		andi.w	#$F,d0
		cmpi.b	#$A,d0
		bcs.s	loc_29C6
		addi.b	#7,d0

loc_29C6:
		add.w	d3,d0
		move.w	d0,(a6)
		rts
; ---------------------------------------------------------------------------

sub_29CC:
		moveq	#$18-1,d2

loc_29CE:
		moveq	#0,d0
		move.b	(a1)+,d0
		bpl.s	loc_29DE
		move.w	#0,(a6)
		dbf	d2,loc_29CE
		rts
; ---------------------------------------------------------------------------

loc_29DE:
		add.w	d3,d0
		move.w	d0,(a6)
		dbf	d2,loc_29CE
		rts
; ---------------------------------------------------------------------------

LevelSelectText:binclude "misc/Level Select Text.bin"
		even

MusicList:	dc.b bgm_GHZ
		dc.b bgm_LZ
		dc.b bgm_MZ
		dc.b bgm_SLZ
		dc.b bgm_SZ
		dc.b bgm_CWZ
		even
; ---------------------------------------------------------------------------

GM_Level:
		move.b	#bgm_Fade,d0
		bsr.w	PlaySound_Special
		locVRAM $B000
		lea	(Nem_TitleCard).l,a0
		bsr.w	NemDec
		bsr.w	ClearPLC
		moveq	#0,d0
		move.b	(v_zone).w,d0
		lsl.w	#4,d0
		lea	(LevelHeaders).l,a2
		lea	(a2,d0.w),a2
		moveq	#0,d0
		move.b	(a2),d0
		beq.s	loc_2C0A
		bsr.w	AddPLC

loc_2C0A:
		moveq	#plcid_Main2,d0
		bsr.w	AddPLC
		bsr.w	PaletteFadeOut
		bsr.w	ClearScreen
		lea	(vdp_control_port).l,a6
		move.w	#$8B03,(a6)
		move.w	#$8230,(a6)
		move.w	#$8407,(a6)
		move.w	#$857C,(a6)
		move.w	#0,(word_FFFFE8).w
		move.w	#$8AAF,(v_hbla_hreg).w
		move.w	#$8004,(a6)
		move.w	#$8720,(a6)

		clearRAM v_objspace,v_objspace_end
		clearRAM v_misc_variables,v_misc_variables_end
		clearRAM v_timingandscreenvariables,v_timingandscreenvariables_end

		moveq	#palid_Sonic,d0
		bsr.w	PalLoad2
		moveq	#0,d0
		move.b	(v_zone).w,d0
		lea	(MusicList).l,a1
		move.b	(a1,d0.w),d0
		bsr.w	PlaySound
		move.b	#id_TitleCard,(v_objslot2).w	; load title card object

loc_2C92:
		move.b	#$C,(v_vbla_routine).w
		bsr.w	WaitForVBla
		bsr.w	ExecuteObjects
		bsr.w	BuildSprites
		bsr.w	RunPLC
		move.w	(v_objslot4+obX).w,d0
		cmp.w	(v_objslot4+card_mainX).w,d0
		bne.s	loc_2C92
		tst.l	(v_plc_buffer).w
		bne.s	loc_2C92
		bsr.w	DebugPosLoadArt
		jsr	(sub_117C6).l
		moveq	#palid_Sonic,d0
		bsr.w	PalLoad1
		bsr.w	LoadLevelBounds
		bsr.w	DeformLayers
		bsr.w	LoadLevelData
		bsr.w	LoadAnimatedBlocks
		bsr.w	LoadTilesFromStart
		jsr	(LogCollision).l
		move.l	#colGHZ,(v_collindex).w		; Load Green Hill's collision - what follows are some C style conditional statements, really unnecessary and replaced with a table in the final game
		cmpi.b	#id_LZ,(v_zone).w		; Is the current zone Labyrinth?
		bne.s	loc_2CFA			; If not, go to the next condition
		move.l	#colLZ,(v_collindex).w		; Load Labyrinth's collision

loc_2CFA:
		cmpi.b	#id_MZ,(v_zone).w		; Is the current zone Marble?
		bne.s	loc_2D0A			; If not, go to the next condition
		move.l	#colMZ,(v_collindex).w		; Load Marble's collision

loc_2D0A:
		cmpi.b	#id_SLZ,(v_zone).w		; Is the current zone Star Light?
		bne.s	loc_2D1A			; If not, go to the next condition
		move.l	#colSLZ,(v_collindex).w		; Load Star Light's collision

loc_2D1A:
		cmpi.b	#id_SZ,(v_zone).w		; Is the current zone Sparkling?
		bne.s	loc_2D2A			; If not, go to the last condition
		move.l	#colSZ,(v_collindex).w		; Load Sparkling's collision

loc_2D2A:
		cmpi.b	#id_CWZ,(v_zone).w		; Is the current zone Clock Work?
		bne.s	loc_2D3A			; If not, then just skip loading collision
		move.l	#colCWZ,(v_collindex).w		; Load Clock Work's collision

loc_2D3A:
		move.b	#id_SonicPlayer,(v_player).w
		move.b	#id_HUD,(v_objslot1).w
		btst	#bitA,(v_jpadhold1).w
		beq.s	loc_2D54
		move.b	#1,(f_debugmode).w

loc_2D54:
		move.w	#0,(v_jpadhold2).w
		move.w	#0,(v_jpadhold1).w
		bsr.w	ObjPosLoad
		bsr.w	ExecuteObjects
		bsr.w	BuildSprites
		moveq	#0,d0
		move.w	d0,(v_rings).w
		move.b	d0,(v_lifecount).w
		move.l	d0,(v_time).w
		move.b	d0,(v_shield).w
		move.b	d0,(v_invinc).w
		move.b	d0,(v_shoes).w
		move.b	d0,(byte_FFFE2F).w
		move.w	d0,(v_debuguse).w
		move.w	d0,(f_restart).w
		move.w	d0,(v_framecount).w
		bsr.w	oscInit
		move.b	#1,(f_scorecount).w
		move.b	#1,(f_extralife).w
		move.b	#1,(f_timecount).w
		move.w	#0,(v_btnpushtime1).w
		lea	(DemoDataPtr).l,a1
		moveq	#0,d0
		move.b	(v_zone).w,d0
		lsl.w	#2,d0
		movea.l	(a1,d0.w),a1
		move.b	1(a1),(v_btnpushtime2).w
		subq.b	#1,(v_btnpushtime2).w
		move.w	#$708,(v_demolength).w
		move.b	#8,(v_vbla_routine).w
		bsr.w	WaitForVBla
		move.w	#$202F,(v_pfade_start).w
		bsr.w	PaletteWhiteIn_Sub
		addq.b	#2,(v_objslot2+obRoutine).w
		addq.b	#4,(v_objslot3+obRoutine).w
		addq.b	#4,(v_objslot4+obRoutine).w
		addq.b	#4,(v_objslot5+obRoutine).w

GM_LevelLoop:
		bsr.w	PauseGame
		move.b	#8,(v_vbla_routine).w
		bsr.w	WaitForVBla
		addq.w	#1,(v_framecount).w
		bsr.w	LZWaterFeatures
		bsr.w	DemoPlayback
		move.w	(v_jpadhold1).w,(v_jpadhold2).w
		bsr.w	ExecuteObjects
		tst.w	(v_debuguse).w
		bne.s	loc_2E2A
		cmpi.b	#6,(v_player+obRoutine).w
		bhs.s	loc_2E2E

loc_2E2A:
		bsr.w	DeformLayers

loc_2E2E:
		bsr.w	BuildSprites
		bsr.w	ObjPosLoad
		bsr.w	PaletteCycle
		bsr.w	RunPLC
		bsr.w	oscUpdate
		bsr.w	UpdateTimers
		bsr.w	LoadSignpostPLC
		cmpi.b	#id_Demo,(v_gamemode).w
		beq.s	loc_2E66
		tst.w	(f_restart).w
		bne.w	GM_Level
		cmpi.b	#id_Level,(v_gamemode).w
		beq.w	GM_LevelLoop
		rts
; ---------------------------------------------------------------------------

loc_2E66:
		tst.w	(f_restart).w
		bne.s	loc_2E84
		tst.w	(v_demolength).w
		beq.s	loc_2E84
		cmpi.b	#id_Demo,(v_gamemode).w
		beq.w	GM_LevelLoop
		move.b	#id_Sega,(v_gamemode).w
		rts
; ---------------------------------------------------------------------------

loc_2E84:
		cmpi.b	#id_Demo,(v_gamemode).w
		bne.s	loc_2E92
		move.b	#id_Sega,(v_gamemode).w

loc_2E92:
		move.w	#60,(v_demolength).w
		move.w	#$3F,(v_pfade_start).w

loc_2E9E:
		move.b	#8,(v_vbla_routine).w
		bsr.w	WaitForVBla
		bsr.w	DemoPlayback
		bsr.w	ExecuteObjects
		bsr.w	BuildSprites
		bsr.w	ObjPosLoad
		subq.w	#1,(v_palchgspeed).w
		bpl.s	loc_2EC8
		move.w	#2,(v_palchgspeed).w
		bsr.w	FadeOut_ToBlack

loc_2EC8:
		tst.w	(v_demolength).w
		bne.s	loc_2E9E
		rts
; ---------------------------------------------------------------------------
		include "leftovers/Debug Coordinate Sprites.asm"
; ---------------------------------------------------------------------------
; Unused, Speculated to have been for a window plane wavy masking effect
; involving writes during HBlank. It writes its tables in the Nemesis GFX
; buffer, only seemingly needing to be called once.
; Discovered by Filter, reconstructed by KatKuriN, Rivet, and ProjectFM
; ---------------------------------------------------------------------------
;sub_3018:
		lea	(v_ngfx_buffer).w,a0
		move.w	(f_water).w,d2
		move.w	#$9100,d3
		move.w	#$100-1,d7

loc_3028:
		move.w	d2,d0
		bsr.w	CalcSine
		asr.w	#4,d0
		bpl.s	loc_3034
		moveq	#0,d0

loc_3034:
		andi.w	#$1F,d0
		move.b	d0,d3
		move.w	d3,(a0)+
		addq.w	#2,d2
		dbf	d7,loc_3028
		addq.w	#2,(f_water).w
		rts

		include "_inc/LZWaterFeatures.asm"

; ---------------------------------------------------------------------------

DemoPlayback:
		tst.w	(f_demo).w
		bne.s	loc_30B8
		rts
; ---------------------------------------------------------------------------

;DemoRecord:
		lea	(EndOfROM).l,a1
		move.w	(v_btnpushtime1).w,d0
		adda.w	d0,a1
		move.b	(v_jpadhold1).w,d0
		cmp.b	(a1),d0
		bne.s	loc_30A2
		addq.b	#1,1(a1)
		cmpi.b	#$FF,1(a1)
		beq.s	loc_30A2
		rts
; ---------------------------------------------------------------------------

loc_30A2:
		move.b	d0,2(a1)
		move.b	#0,3(a1)
		addq.w	#2,(v_btnpushtime1).w
		andi.w	#$3FF,(v_btnpushtime1).w
		rts
; ---------------------------------------------------------------------------

loc_30B8:
		tst.b	(v_jpadhold1).w
		bpl.s	loc_30C4
		move.b	#id_Title,(v_gamemode).w

loc_30C4:
		lea	(DemoDataPtr).l,a1
		moveq	#0,d0
		move.b	(v_zone).w,d0
		lsl.w	#2,d0
		movea.l	(a1,d0.w),a1
		move.w	(v_btnpushtime1).w,d0
		adda.w	d0,a1
		move.b	(a1),d0
		lea	(v_jpadhold1).w,a0
		move.b	d0,d1
		move.b	(a0),d2
		eor.b	d2,d0
		move.b	d1,(a0)+
		and.b	d1,d0
		move.b	d0,(a0)+
		subq.b	#1,(v_btnpushtime2).w
		bhs.s	locret_30FE
		move.b	3(a1),(v_btnpushtime2).w
		addq.w	#2,(v_btnpushtime1).w

locret_30FE:
		rts
; ---------------------------------------------------------------------------

DemoDataPtr:	dc.l byte_614C6
		dc.l byte_614C6
		dc.l byte_614C6
		dc.l byte_61434
		dc.l byte_61578
		dc.l byte_61578
		dc.l byte_6161E

		dc.b 0, $8B, 8, $37, 0, $42, 8, $5C, 0, $6A, 8, $5F, 0, $2F, 8, $2C
		dc.b 0, $21, 8, 3, $28, $30, 8, 8, 0, $2E, 8, $15, 0, $F, 8, $46
		dc.b 0, $1A, 8, $FF, 8, $CA, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		even
; ---------------------------------------------------------------------------
;sub_314C:
		cmpi.b	#id_06,(v_zone).w	; are we on Zone 6?
		bne.s	locret_3176	; if not, branch
		bsr.w	sub_3178
		lea	(v_256x256&$FFFFFF+$900).l,a1
		bsr.s	sub_3166
		lea	(v_256x256&$FFFFFF+$3380).l,a1

sub_3166:
		lea	(Anim16Unk1).l,a0
		move.w	#bytesToWcnt(Anim16Unk1_end-Anim16Unk1),d1

.loadchunks:
		move.w	(a0)+,(a1)+
		dbf	d1,.loadchunks

locret_3176:
		rts
; ---------------------------------------------------------------------------

sub_3178:
		lea	(v_256x256&$FFFFFF).l,a1
		lea	(Anim16Unk2).l,a0
		move.w	#bytesToWcnt(Anim16Unk2_end-Anim16Unk2),d1

.loadchunks2:
		move.w	(a0)+,d0
		ori.w	#$2000,(a1,d0.w)
		dbf	d1,.loadchunks2
		rts
; ---------------------------------------------------------------------------
Anim16Unk1:	binclude "map16/Anim Unknown 1.bin"
Anim16Unk1_end:	even
Anim16Unk2:	binclude "map16/Anim Unknown 2.bin"
Anim16Unk2_end:	even
; ---------------------------------------------------------------------------

LoadAnimatedBlocks:
		cmpi.b	#id_MZ,(v_zone).w	; are we on Marble Zone?
		beq.s	.ismz	; if yes, branch
		cmpi.b	#id_SLZ,(v_zone).w	; are we on Star Light Zone?
		beq.s	.isslz	; if yes, branch
		tst.b	(v_zone).w	; are we on Green Hill Zone?
		bne.s	.notghz	; if not, branch

.isslz:
		lea	(v_16x16+$1790).w,a1	; load ROM address for animated blocks to load in the main block RAM into a1.
		lea	(Anim16GHZ).l,a0	; load animated GHZ blocks into a0.
		move.w	#bytesToWcnt(Anim16GHZ_end-Anim16GHZ),d1	; load approximate size of the blocks into d1.

.loadghz:
		move.w	(a0)+,(a1)+
		dbf	d1,.loadghz

.notghz:
		rts
; ---------------------------------------------------------------------------

.ismz:
		lea	(v_16x16+$17A0).w,a1	; load ROM address for animated blocks to load in the main block RAM into a1.
		lea	(Anim16MZ).l,a0	; load animated MZ blocks into a0.
		move.w	#bytesToWcnt(Anim16MZ_end-Anim16MZ),d1	; load approximate size of the blocks into d1.

.loadmz:
		move.w	(a0)+,(a1)+
		dbf	d1,.loadmz
		rts
; ---------------------------------------------------------------------------
Anim16GHZ:	binclude "map16/Anim GHZ.bin"
Anim16GHZ_end:	even
Anim16MZ:	binclude "map16/Anim MZ.bin"
Anim16MZ_end:	even
; ---------------------------------------------------------------------------

DebugPosLoadArt:
		rts
; ---------------------------------------------------------------------------
		locVRAM $9E00
		lea	(Art_Text).l,a0
		move.w	#bytesToWcnt(Art_Text_end-Art_Text-tile_size*$1F),d1
		bsr.s	.loadtext
		lea	(Art_Text).l,a0
		adda.w	#tile_size*$11,a0
		move.w	#bytesToWcnt(Art_Text_end-Art_Text-tile_size*$23),d1

.loadtext:
		move.w	(a0)+,(vdp_data_port).l
		dbf	d1,.loadtext
		rts
; ---------------------------------------------------------------------------
;1bppConvert:
		moveq	#0,d0				; this code converts palette indices from 1 to 6
		move.b	(a0)+,d0			; for example, $11 will be turned into $66
		ror.w	#1,d0
		lsr.b	#3,d0
		rol.w	#1,d0
		move.b	.1bpp(pc,d0.w),d2
		lsl.w	#8,d2
		moveq	#0,d0
		move.b	(a0)+,d0
		ror.w	#1,d0
		lsr.b	#3,d0
		rol.w	#1,d0
		move.b	.1bpp(pc,d0.w),d2
		move.w	d2,(vdp_data_port).l
		dbf	d1,.loadtext
		rts
; ---------------------------------------------------------------------------

.1bpp:		dc.b 0, 6, $60, $66
		even

		include "_inc/Oscillatory Routines.asm"

; ---------------------------------------------------------------------------

UpdateTimers:
		subq.b	#1,(v_ani0_time).w
		bpl.s	loc_3464
		move.b	#$B,(v_ani0_time).w
		subq.b	#1,(v_ani0_frame).w
		andi.b	#7,(v_ani0_frame).w

loc_3464:
		subq.b	#1,(v_ani1_time).w
		bpl.s	loc_347A
		move.b	#7,(v_ani1_time).w
		addq.b	#1,(v_ani1_frame).w
		andi.b	#3,(v_ani1_frame).w

loc_347A:
		subq.b	#1,(v_ani2_time).w
		bpl.s	loc_3498
		move.b	#7,(v_ani2_time).w
		addq.b	#1,(v_ani2_frame).w
		cmpi.b	#6,(v_ani2_frame).w
		bcs.s	loc_3498
		move.b	#0,(v_ani2_frame).w

loc_3498:
		tst.b	(v_ani3_time).w
		beq.s	locret_34BA
		moveq	#0,d0
		move.b	(v_ani3_time).w,d0
		add.w	(v_ani3_buf).w,d0
		move.w	d0,(v_ani3_buf).w
		rol.w	#7,d0
		andi.w	#3,d0
		move.b	d0,(v_ani3_frame).w
		subq.b	#1,(v_ani3_time).w

locret_34BA:
		rts
; ---------------------------------------------------------------------------

LoadSignpostPLC:
		tst.w	(v_debuguse).w
		bne.w	locret_34FA
		cmpi.w	#id_MZ*$100+2,(v_zone).w
		beq.s	loc_34D4
		cmpi.b	#2,(v_act).w
		beq.s	locret_34FA

loc_34D4:
		move.w	(v_screenposx).w,d0
		move.w	(v_limitright2).w,d1
		subi.w	#$100,d1
		cmp.w	d1,d0
		blt.s	locret_34FA
		tst.b	(f_timecount).w
		beq.s	locret_34FA
		cmp.w	(v_limitleft2).w,d1
		beq.s	locret_34FA
		move.w	d1,(v_limitleft2).w
		moveq	#plcid_Signpost,d0
		bra.w	NewPLC
; ---------------------------------------------------------------------------

locret_34FA:
		rts
; ---------------------------------------------------------------------------

GM_Special:
		bsr.w	PaletteFadeOut
		move.w	(v_vdp_buffer1).w,d0
		andi.b	#$BF,d0
		move.w	d0,(vdp_control_port).l
		bsr.w	ClearScreen
		fillVRAM	0, ArtTile_SS_Plane_1*tile_size+plane_size_64x32, ArtTile_SS_Plane_5*tile_size
		moveq	#plcid_SpecialStage,d0
		bsr.w	QuickPLC
		bsr.w	ssLoadBG
		clearRAM v_objspace,v_objspace_end
		clearRAM v_misc_variables,v_misc_variables_end
		clearRAM v_timingandscreenvariables,v_timingandscreenvariables_end
		clearRAM v_ngfx_buffer,v_ngfx_buffer_end
		moveq	#palid_Special,d0
		bsr.w	PalLoad1
		jsr	(SS_Load).l
		move.l	#0,(v_screenposx).w
		move.l	#0,(v_screenposy).w
		move.b	#id_SonicSpecial,(v_player).w
		move.w	#$458,(v_player+obX).w
		move.w	#$4A0,(v_player+obY).w
		lea	(vdp_control_port).l,a6
		move.w	#$8B03,(a6)
		move.w	#$8004,(a6)
		move.w	#$8AAF,(v_hbla_hreg).w
		move.w	#$9011,(a6)
		bsr.w	SS_PalCycle
		clr.w	(v_ssangle).w
		move.w	#$40,(v_ssrotate).w
		move.w	#bgm_SS,d0
		bsr.w	PlaySound_Special
		move.w	#0,(v_btnpushtime1).w
		lea	(DemoDataPtr).l,a1
		moveq	#0,d0
		move.b	(v_zone).w,d0
		lsl.w	#2,d0
		movea.l	(a1,d0.w),a1
		move.b	1(a1),(v_btnpushtime2).w
		subq.b	#1,(v_btnpushtime2).w
		move.w	#$708,(v_demolength).w
		move.w	(v_vdp_buffer1).w,d0
		ori.b	#$40,d0
		move.w	d0,(vdp_control_port).l
		bsr.w	PaletteWhiteIn

loc_3620:
		bsr.w	PauseGame
		move.b	#$A,(v_vbla_routine).w
		bsr.w	WaitForVBla
		bsr.w	DemoPlayback
		move.w	(v_jpadhold1).w,(v_jpadhold2).w
		bsr.w	ExecuteObjects
		bsr.w	BuildSprites
		jsr	(Special_ShowLayout).l
		bsr.w	SpecialAnimateBG
		tst.w	(f_demo).w
		beq.s	loc_3656
		tst.w	(v_demolength).w
		beq.s	loc_3662

loc_3656:
		cmpi.b	#id_Special,(v_gamemode).w
		beq.w	loc_3620
		rts
; ---------------------------------------------------------------------------

loc_3662:
		move.b	#id_Sega,(v_gamemode).w
		rts
; ---------------------------------------------------------------------------

ssLoadBG:
		lea	(v_start&$FFFFFF).l,a1
		lea	(byte_639B8).l,a0
		move.w	#$4051,d0
		bsr.w	EniDec
		move.l	#$50000001,d3
		lea	(v_start&$FFFFFF+$80).l,a2
		moveq	#6,d7

loc_368C:
		move.l	d3,d0
		moveq	#3,d6
		moveq	#0,d4
		cmpi.w	#3,d7
		bhs.s	loc_369A
		moveq	#1,d4

loc_369A:
		moveq	#7,d5

loc_369C:
		movea.l	a2,a1
		eori.b	#1,d4
		bne.s	loc_36B0
		cmpi.w	#6,d7
		bne.s	loc_36C0
		lea	(v_start&$FFFFFF).l,a1

loc_36B0:
		movem.l	d0-d4,-(sp)
		moveq	#8-1,d1
		moveq	#8-1,d2
		bsr.w	TilemapToVRAM
		movem.l	(sp)+,d0-d4

loc_36C0:
		addi.l	#$100000,d0
		dbf	d5,loc_369C
		addi.l	#$3800000,d0
		eori.b	#1,d4
		dbf	d6,loc_369A
		addi.l	#$10000000,d3
		bpl.s	loc_36EA
		swap	d3
		addi.l	#$C000,d3
		swap	d3

loc_36EA:
		adda.w	#$80,a2
		dbf	d7,loc_368C
		lea	(v_start&$FFFFFF).l,a1
		lea	(byte_6477C).l,a0
		move.w	#$4000,d0
		bsr.w	EniDec
		copyTilemap	v_start&$FFFFFF,$C000,64-1,32-1
		copyTilemap	v_start&$FFFFFF,$D000,64-1,64-1
		rts
; ---------------------------------------------------------------------------

SS_PalCycle:
		tst.w	(f_pause).w
		bmi.s	locret_37B4
		subq.w	#1,(v_palss_time).w
		bpl.s	locret_37B4
		lea	(vdp_control_port).l,a6
		move.w	(v_palss_num).w,d0
		addq.w	#1,(v_palss_num).w
		andi.w	#$1F,d0
		lsl.w	#2,d0
		lea	(byte_380A).l,a0
		adda.w	d0,a0
		move.b	(a0)+,d0
		bpl.s	loc_3760
		move.w	#$1FF,d0

loc_3760:
		move.w	d0,(v_palss_time).w
		moveq	#0,d0
		move.b	(a0)+,d0
		move.w	d0,(unk_FFF7A0).w
		lea	(byte_388A).l,a1
		lea	(a1,d0.w),a1
		move.w	#$8200,d0
		move.b	(a1)+,d0
		move.w	d0,(a6)
		move.b	(a1),(v_scrposy_dup).w
		move.w	#$8400,d0
		move.b	(a0)+,d0
		move.w	d0,(a6)
		move.l	#$40000010,(vdp_control_port).l
		move.l	(v_scrposy_dup).w,(vdp_data_port).l
		moveq	#0,d0
		move.b	(a0)+,d0
		bmi.s	loc_37B6
		lea	(dword_3898).l,a1
		adda.w	d0,a1
		lea	(v_palette+$4E).w,a2
		move.l	(a1)+,(a2)+
		move.l	(a1)+,(a2)+
		move.l	(a1)+,(a2)+

locret_37B4:
		rts
; ---------------------------------------------------------------------------

loc_37B6:
		move.w	(unk_FFF79E).w,d1
		cmpi.w	#$8A,d0
		bcs.s	loc_37C2
		addq.w	#1,d1

loc_37C2:
		mulu.w	#$2A,d1
		lea	(word_38E0).l,a1
		adda.w	d1,a1
		andi.w	#$7F,d0
		bclr	#0,d0
		beq.s	loc_37E6
		lea	(v_palette+$6E).w,a2
		move.l	(a1),(a2)+
		move.l	4(a1),(a2)+
		move.l	8(a1),(a2)+

loc_37E6:
		adda.w	#$C,a1
		lea	(v_palette+$5A).w,a2
		cmpi.w	#$A,d0
		bcs.s	loc_37FC
		subi.w	#$A,d0
		lea	(v_palette+$7A).w,a2

loc_37FC:
		move.w	d0,d1
		add.w	d0,d0
		add.w	d1,d0
		adda.w	d0,a1
		move.l	(a1)+,(a2)+
		move.w	(a1)+,(a2)+
		rts
; ---------------------------------------------------------------------------

byte_380A:	dc.b 3, 0, 7, $92, 3, 0, 7, $90, 3, 0, 7, $8E, 3, 0, 7
		dc.b $8C, 3, 0, 7, $8B, 3, 0, 7, $80, 3, 0, 7, $82, 3
		dc.b 0, 7, $84, 3, 0, 7, $86, 3, 0, 7, $88, 7, 8, 7, 0
		dc.b 7, $A, 7, $C, $FF, $C, 7, $18, $FF, $C, 7, $18, 7
		dc.b $A, 7, $C, 7, 8, 7, 0, 3, 0, 6, $88, 3, 0, 6, $86
		dc.b 3, 0, 6, $84, 3, 0, 6, $82, 3, 0, 6, $81, 3, 0, 6
		dc.b $8A, 3, 0, 6, $8C, 3, 0, 6, $8E, 3, 0, 6, $90, 3
		dc.b 0, 6, $92, 7, 2, 6, $24, 7, 4, 6, $30, $FF, 6, 6
		dc.b $3C, $FF, 6, 6, $3C, 7, 4, 6, $30, 7, 2, 6, $24
		even

byte_388A:	dc.b $10, 1, $18, 0, $18, 1, $20, 0, $20, 1, $28, 0, $28
		dc.b 1
		even

dword_3898:	dc.l $4000600, $6200624, $6640666, $6000820, $A640A68
		dc.l $AA60AAA, $8000C42, $E860ECA, $EEC0EEE, $4000420
		dc.l $6200620, $8640666, $4200620, $8420842, $A860AAA
		dc.l $6200842, $A640C86, $EA80EEE
		even

word_38E0:	binclude "palette/Cycle - SS.bin"
		even
; ---------------------------------------------------------------------------

SpecialAnimateBG:
		move.w	(unk_FFF7A0).w,d0
		bne.s	loc_39C4
		move.w	#0,(v_bgscreenposy).w
		move.w	(v_bgscreenposy).w,(v_scrposy_dup+2).w

loc_39C4:
		cmpi.w	#8,d0
		bhs.s	loc_3A1C
		cmpi.w	#6,d0
		bne.s	loc_39DE
		addq.w	#1,(v_bg3screenposx).w
		addq.w	#1,(v_bgscreenposy).w
		move.w	(v_bgscreenposy).w,(v_scrposy_dup+2).w

loc_39DE:
		moveq	#0,d0
		move.w	(v_bgscreenposx).w,d0
		neg.w	d0
		swap	d0
		lea	(byte_3A9A).l,a1
		lea	(v_ngfx_buffer).w,a3
		moveq	#9,d3

loc_39F4:
		move.w	2(a3),d0
		bsr.w	CalcSine
		moveq	#0,d2
		move.b	(a1)+,d2
		muls.w	d2,d0
		asr.l	#8,d0
		move.w	d0,(a3)+
		move.b	(a1)+,d2
		ext.w	d2
		add.w	d2,(a3)+
		dbf	d3,loc_39F4
		lea	(v_ngfx_buffer).w,a3
		lea	(byte_3A86).l,a2
		bra.s	loc_3A4C
; ---------------------------------------------------------------------------

loc_3A1C:
		cmpi.w	#$C,d0
		bne.s	loc_3A42
		subq.w	#1,(v_bg3screenposx).w
		lea	(v_ssscroll_buffer).w,a3
		move.l	#$18000,d2
		moveq	#6,d1

loc_3A32:
		move.l	(a3),d0
		sub.l	d2,d0
		move.l	d0,(a3)+
		subi.l	#$2000,d2
		dbf	d1,loc_3A32

loc_3A42:
		lea	(v_ssscroll_buffer).w,a3
		lea	(byte_3A92).l,a2

loc_3A4C:
		lea	(v_hscrolltablebuffer).w,a1
		move.w	(v_bg3screenposx).w,d0
		neg.w	d0
		swap	d0
		moveq	#0,d3
		move.b	(a2)+,d3
		move.w	(v_bgscreenposy).w,d2
		neg.w	d2
		andi.w	#$FF,d2
		lsl.w	#2,d2

loc_3A68:
		move.w	(a3)+,d0
		addq.w	#2,a3
		moveq	#0,d1
		move.b	(a2)+,d1
		subq.w	#1,d1

loc_3A72:
		move.l	d0,(a1,d2.w)
		addq.w	#4,d2
		andi.w	#$3FC,d2
		dbf	d1,loc_3A72
		dbf	d3,loc_3A68
		rts
; ---------------------------------------------------------------------------

byte_3A86:	dc.b 9, $28, $18, $10, $28, $18, $10, $30, $18, 8, $10
		dc.b 0
		even

byte_3A92:	dc.b 6, $30, $30, $30, $28, $18, $18, $18
		even

byte_3A9A:	dc.b 8, 2, 4, $FF, 2, 3, 8, $FF, 4, 2, 2, 3, 8, $FD, 4
		dc.b 2, 2, 3, 2, $FF
		even
; ---------------------------------------------------------------------------

		include "_inc/LevelSizeLoad & BgScrollSpeed.asm"
		include "_inc/DeformLayers.asm"

; ---------------------------------------------------------------------------

; sub_43B6:
LoadTilesAsYouMove_BGOnly:
		lea	(vdp_control_port).l,a5
		lea	(vdp_data_port).l,a6
		lea	(v_bg1_scroll_flags).w,a2
		lea	(v_bgscreenposx).w,a3
		lea	(v_lvllayoutbg).w,a4
		move.w	#$6000,d2
		bsr.w	DrawBGScrollBlock1
		lea	(v_bg2_scroll_flags).w,a2
		lea	(v_bg2screenposx).w,a3
		bra.w	DrawBGScrollBlock2
; ---------------------------------------------------------------------------

LoadTilesAsYouMove:
		lea	(vdp_control_port).l,a5
		lea	(vdp_data_port).l,a6
		lea	(v_bg1_scroll_flags).w,a2
		lea	(v_bgscreenposx).w,a3
		lea	(v_lvllayoutbg).w,a4
		move.w	#$6000,d2
		bsr.w	DrawBGScrollBlock1
		lea	(v_bg2_scroll_flags).w,a2
		lea	(v_bg2screenposx).w,a3
		bsr.w	DrawBGScrollBlock2
		lea	(v_fg_scroll_flags).w,a2
		lea	(v_screenposx).w,a3
		lea	(v_lvllayout).w,a4
		move.w	#$4000,d2
		tst.b	(a2)
		beq.s	locret_4482
		bclr	#0,(a2)
		beq.s	loc_4438
		moveq	#-16,d4
		moveq	#-16,d5
		bsr.w	Calc_VRAM_Pos
		moveq	#-16,d4
		moveq	#-16,d5
		bsr.w	DrawBlocks_LR

loc_4438:
		bclr	#1,(a2)
		beq.s	loc_4452
		move.w	#224,d4
		moveq	#-16,d5
		bsr.w	Calc_VRAM_Pos
		move.w	#224,d4
		moveq	#-16,d5
		bsr.w	DrawBlocks_LR

loc_4452:
		bclr	#2,(a2)
		beq.s	loc_4468
		moveq	#-16,d4
		moveq	#-16,d5
		bsr.w	Calc_VRAM_Pos
		moveq	#-16,d4
		moveq	#-16,d5
		bsr.w	DrawBlocks_TB

loc_4468:
		bclr	#3,(a2)
		beq.s	locret_4482
		moveq	#-16,d4
		move.w	#320,d5
		bsr.w	Calc_VRAM_Pos
		moveq	#-16,d4
		move.w	#320,d5
		bsr.w	DrawBlocks_TB

locret_4482:
		rts
; ---------------------------------------------------------------------------

DrawBGScrollBlock1:
		tst.b	(a2)
		beq.w	locret_4522
		bclr	#0,(a2)
		beq.s	loc_44A2
		moveq	#-16,d4
		moveq	#-16,d5
		bsr.w	Calc_VRAM_Pos
		moveq	#-16,d4
		moveq	#-16,d5
		moveq	#(512/16)-1,d6
		bsr.w	DrawBlocks_LR_2

loc_44A2:
		bclr	#1,(a2)
		beq.s	loc_44BE
		move.w	#224,d4
		moveq	#-16,d5
		bsr.w	Calc_VRAM_Pos
		move.w	#224,d4
		moveq	#-16,d5
		moveq	#(512/16)-1,d6
		bsr.w	DrawBlocks_LR_2

loc_44BE:
		bclr	#2,(a2)
		beq.s	loc_44EE
		moveq	#-16,d4
		moveq	#-16,d5
		bsr.w	Calc_VRAM_Pos
		moveq	#-16,d4
		moveq	#-16,d5
		move.w	(v_scroll_block_1_size).w,d6
		move.w	4(a3),d1
		andi.w	#-16,d1
		sub.w	d1,d6
		blt.s	loc_44EE
		lsr.w	#4,d6
		cmpi.w	#((224+16+16)/16)-1,d6
		bcs.s	loc_44EA
		moveq	#((224+16+16)/16)-1,d6

loc_44EA:
		bsr.w	DrawBlocks_TB_2

loc_44EE:
		bclr	#3,(a2)
		beq.s	locret_4522
		moveq	#-16,d4
		move.w	#320,d5
		bsr.w	Calc_VRAM_Pos
		moveq	#-16,d4
		move.w	#320,d5
		move.w	(v_scroll_block_1_size).w,d6
		move.w	4(a3),d1
		andi.w	#-16,d1
		sub.w	d1,d6
		blt.s	locret_4522
		lsr.w	#4,d6
		cmpi.w	#((224+16+16)/16)-1,d6
		bcs.s	loc_451E
		moveq	#((224+16+16)/16)-1,d6

loc_451E:
		bsr.w	DrawBlocks_TB_2

locret_4522:
		rts
; ---------------------------------------------------------------------------

DrawBGScrollBlock2:
		tst.b	(a2)
		beq.w	locret_45B0
		bclr	#2,(a2)
		beq.s	loc_456E
		cmpi.w	#16,(a3)
		bcs.s	loc_456E
		move.w	(v_scroll_block_1_size).w,d4
		move.w	4(a3),d1
		andi.w	#-16,d1
		sub.w	d1,d4
		move.w	d4,-(sp)
		moveq	#-16,d5
		bsr.w	Calc_VRAM_Pos
		move.w	(sp)+,d4
		moveq	#-16,d5
		move.w	(v_scroll_block_1_size).w,d6
		move.w	4(a3),d1
		andi.w	#-16,d1
		sub.w	d1,d6
		blt.s	loc_456E
		lsr.w	#4,d6
		subi.w	#((224+16)/16)-1,d6
		bhs.s	loc_456E
		neg.w	d6
		bsr.w	DrawBlocks_TB_2

loc_456E:
		bclr	#3,(a2)
		beq.s	locret_45B0
		move.w	(v_scroll_block_1_size).w,d4
		move.w	4(a3),d1
		andi.w	#-16,d1
		sub.w	d1,d4
		move.w	d4,-(sp)
		move.w	#320,d5
		bsr.w	Calc_VRAM_Pos
		move.w	(sp)+,d4
		move.w	#320,d5
		move.w	(v_scroll_block_1_size).w,d6
		move.w	4(a3),d1
		andi.w	#-16,d1
		sub.w	d1,d6
		blt.s	locret_45B0
		lsr.w	#4,d6
		subi.w	#((224+16)/16)-1,d6
		bhs.s	locret_45B0
		neg.w	d6
		bsr.w	DrawBlocks_TB_2

locret_45B0:
		rts
; ---------------------------------------------------------------------------
		tst.b	(a2)
		beq.s	locret_4606
		bclr	#2,(a2)
		beq.s	loc_45DC
		move.w	#224-16,d4
		move.w	4(a3),d1
		andi.w	#-16,d1
		sub.w	d1,d4
		move.w	d4,-(sp)
		moveq	#-16,d5
		bsr.w	Calc_VRAM_Pos_Unknown
		move.w	(sp)+,d4
		moveq	#-16,d5
		moveq	#2,d6
		bsr.w	DrawBlocks_TB_2

loc_45DC:
		bclr	#3,(a2)
		beq.s	locret_4606
		move.w	#224-16,d4
		move.w	4(a3),d1
		andi.w	#-16,d1
		sub.w	d1,d4
		move.w	d4,-(sp)
		move.w	#320,d5
		bsr.w	Calc_VRAM_Pos_Unknown
		move.w	(sp)+,d4
		move.w	#320,d5
		moveq	#2,d6
		bsr.w	DrawBlocks_TB_2

locret_4606:
		rts
; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||

; Don't be fooled by the name: this function's for drawing from left to right
; when the camera's moving up or down
; DrawTiles_LR:
DrawBlocks_LR:
		moveq	#((320+16+16)/16)-1,d6	; Draw the entire width of the screen + two extra columns
; DrawTiles_LR_2:
DrawBlocks_LR_2:
		move.l	#$800000,d7	; Delta between rows of tiles
		move.l	d0,d1

.loop:
		movem.l	d4-d5,-(sp)
		bsr.w	GetBlockData
		move.l	d1,d0
		bsr.w	DrawBlock
		addq.b	#4,d1		; Two tiles ahead
		andi.b	#$7F,d1		; Wrap around row
		movem.l	(sp)+,d4-d5
		addi.w	#16,d5		; Move X coordinate one block ahead
		dbf	d6,.loop
		rts
; End of function DrawBlocks_LR

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||

; Don't be fooled by the name: this function's for drawing from top to bottom
; when the camera's moving left or right
; DrawTiles_TB:
DrawBlocks_TB:
		moveq	#((224+16+16)/16)-1,d6	; Draw the entire height of the screen + two extra rows
; DrawTiles_TB_2:
DrawBlocks_TB_2:
		move.l	#$800000,d7	; Delta between rows of tiles
		move.l	d0,d1

.loop:
		movem.l	d4-d5,-(sp)
		bsr.w	GetBlockData
		move.l	d1,d0
		bsr.w	DrawBlock
		addi.w	#$100,d1	; Two rows ahead
		andi.w	#$FFF,d1	; Wrap around plane
		movem.l	(sp)+,d4-d5
		addi.w	#16,d4		; Move X coordinate one block ahead
		dbf	d6,.loop
		rts
; End of function DrawBlocks_TB_2

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||

; Draws a block's worth of tiles
; Parameters:
; a0 = Pointer to block metadata (block index and X/Y flip)
; a1 = Pointer to block
; a5 = Pointer to VDP command port
; a6 = Pointer to VDP data port
; d0 = VRAM command to access plane
; d2 = VRAM plane A/B specifier
; d7 = Plane row delta
; DrawTiles:
DrawBlock:
		or.w	d2,d0	; OR in that plane A/B specifier to the VRAM command
		swap	d0
		btst	#4,(a0)	; Check Y-flip bit
		bne.s	DrawFlipY
		btst	#3,(a0)	; Check X-flip bit
		bne.s	DrawFlipX
		move.l	d0,(a5)
		move.l	(a1)+,(a6)	; Write top two tiles
		add.l	d7,d0		; Next row
		move.l	d0,(a5)
		move.l	(a1)+,(a6)	; Write bottom two tiles
		rts	
; ===========================================================================

DrawFlipX:
		move.l	d0,(a5)
		move.l	(a1)+,d4
		eori.l	#$8000800,d4	; Invert X-flip bits of each tile
		swap	d4		; Swap the tiles around
		move.l	d4,(a6)		; Write top two tiles
		add.l	d7,d0		; Next row
		move.l	d0,(a5)
		move.l	(a1)+,d4
		eori.l	#$8000800,d4
		swap	d4
		move.l	d4,(a6)		; Write bottom two tiles
		rts	
; ===========================================================================

DrawFlipY:
		btst	#3,(a0)
		bne.s	DrawFlipXY
		move.l	d0,(a5)
		move.l	(a1)+,d5
		move.l	(a1)+,d4
		eori.l	#$10001000,d4
		move.l	d4,(a6)
		add.l	d7,d0
		move.l	d0,(a5)
		eori.l	#$10001000,d5
		move.l	d5,(a6)
		rts	
; ===========================================================================

DrawFlipXY:
		move.l	d0,(a5)
		move.l	(a1)+,d5
		move.l	(a1)+,d4
		eori.l	#$18001800,d4
		swap	d4
		move.l	d4,(a6)
		add.l	d7,d0
		move.l	d0,(a5)
		eori.l	#$18001800,d5
		swap	d5
		move.l	d5,(a6)
		rts	
; End of function DrawBlocks

; ---------------------------------------------------------------------------
; unused garbage
; This is interesting. It draws a block, but not before
; incrementing its palette lines by 1. This may have been
; a debug function to discolour mirrored tiles, to test
; if they're loading properly.
		rts
		move.l	d0,(a5)
		move.w	#$2000,d5
		move.w	(a1)+,d4
		add.w	d5,d4
		move.w	d4,(a6)
		move.w	(a1)+,d4
		add.w	d5,d4
		move.w	d4,(a6)
		add.l	d7,d0
		move.l	d0,(a5)
		move.w	(a1)+,d4
		add.w	d5,d4
		move.w	d4,(a6)
		move.w	(a1)+,d4
		add.w	d5,d4
		move.w	d4,(a6)
		rts

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||

; Gets address of block at a certain coordinate
; Parameters:
; a4 = Pointer to level layout
; d4 = Relative Y coordinate
; d5 = Relative X coordinate
; Returns:
; a0 = Address of block metadata
; a1 = Address of block
; DrawBlocks:
GetBlockData:
		lea	(v_16x16).w,a1
		add.w	4(a3),d4	; Add camera Y coordinate to relative coordinate
		add.w	(a3),d5		; Add camera X coordinate to relative coordinate
		; Turn Y coordinate into index into level layout
		move.w	d4,d3
		lsr.w	#1,d3
		andi.w	#$380,d3
		; Turn X coordinate into index into level layout
		lsr.w	#3,d5
		move.w	d5,d0
		lsr.w	#5,d0
		andi.w	#$7F,d0
		; Get chunk from level layout
		add.w	d3,d0
		moveq	#-1,d3
		move.b	(a4,d0.w),d3
		andi.b	#$7F,d3
		beq.s	locret_4750	; If chunk is 80, just return a pointer to the first block (expected to be empty)
		; Turn chunk ID into index into chunk table
		subq.b	#1,d3
		ext.w	d3
		ror.w	#7,d3
		; Turn Y coordinate into index into chunk
		add.w	d4,d4
		andi.w	#$1E0,d4
		; Turn X coordinate into index into chunk
		andi.w	#$1E,d5
		; Get block metadata from chunk
		add.w	d4,d3
		add.w	d5,d3
		movea.l	d3,a0
		move.w	(a0),d3
		; Turn block ID into address
		andi.w	#$3FF,d3
		lsl.w	#3,d3
		adda.w	d3,a1

locret_4750:
		rts
; End of function GetBlockData

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||

; Produces a VRAM plane access command from coordinates
; Parameters:
; d4 = Relative Y coordinate
; d5 = Relative X coordinate
; Returns VDP command in d0
Calc_VRAM_Pos:
		add.w	4(a3),d4	; Add camera Y coordinate
		add.w	(a3),d5		; Add camera X coordinate
		; Floor the coordinates to the nearest pair of tiles (the size of a block).
		; Also note that this wraps the value to the size of the plane:
		; The plane is 64*8 wide, so wrap at $100, and it's 32*8 tall, so wrap at $200
		andi.w	#$F0,d4
		andi.w	#$1F0,d5
		; Transform the adjusted coordinates into a VDP command
		lsl.w	#4,d4
		lsr.w	#2,d5
		add.w	d5,d4
		moveq	#3,d0	; Highest bits of plane VRAM address
		swap	d0
		move.w	d4,d0
		rts	
; End of function Calc_VRAM_Pos

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||
; not used

; This is just like Calc_VRAM_Pos, but seemingly for an earlier
; VRAM layout: the only difference is the high bits of the
; plane's VRAM address, which are 10 instead of 11.
; Both the foreground and background are at $C000 and $E000
; respectively, so this one starting at $8000 makes no sense.
; sub_6C3C:
Calc_VRAM_Pos_Unknown:
		add.w	4(a3),d4
		add.w	(a3),d5
		andi.w	#$F0,d4
		andi.w	#$1F0,d5
		lsl.w	#4,d4
		lsr.w	#2,d5
		add.w	d5,d4
		moveq	#2,d0
		swap	d0
		move.w	d4,d0
		rts
; End of function Calc_VRAM_Pos_Unknown

; ---------------------------------------------------------------------------
; Subroutine to	load tiles as soon as the level	appears
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


LoadTilesFromStart:
		lea	(vdp_control_port).l,a5
		lea	(vdp_data_port).l,a6
		lea	(v_screenposx).w,a3
		lea	(v_lvllayout).w,a4
		move.w	#$4000,d2
		bsr.s	DrawChunks
		lea	(v_bgscreenposx).w,a3
		lea	(v_lvllayoutbg).w,a4
		move.w	#$6000,d2
; End of function LoadTilesFromStart

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||

DrawChunks:
		moveq	#-16,d4
		moveq	#((224+16+16)/16)-1,d6

.loop:
		movem.l	d4-d6,-(sp)
		moveq	#0,d5
		move.w	d4,d1
		bsr.w	Calc_VRAM_Pos
		move.w	d1,d4
		moveq	#0,d5
		moveq	#(512/16)-1,d6
		bsr.w	DrawBlocks_LR_2
		movem.l	(sp)+,d4-d6
		addi.w	#16,d4
		dbf	d6,.loop
		rts
; ---------------------------------------------------------------------------
;loc_47D8:
		lea	(v_bg3screenposx).w,a3
		move.w	#$6000,d2
		move.w	#$B0,d4
		moveq	#3-1,d6

loc_47E6:
		movem.l	d4-d6,-(sp)
		moveq	#0,d5
		move.w	d4,d1
		bsr.w	Calc_VRAM_Pos_Unknown
		move.w	d1,d4
		moveq	#0,d5
		moveq	#(512/16)-1,d6
		bsr.w	DrawBlocks_LR_2
		movem.l	(sp)+,d4-d6
		addi.w	#16,d4
		dbf	d6,loc_47E6
		rts
; ---------------------------------------------------------------------------

LoadLevelData:
		moveq	#0,d0
		move.b	(v_zone).w,d0
		lsl.w	#4,d0
		lea	(LevelHeaders).l,a2
		lea	(a2,d0.w),a2
		move.l	a2,-(sp)
		addq.l	#4,a2
		movea.l	(a2)+,a0
		lea	(v_16x16).w,a4
		move.w	#bytesToLcnt(v_16x16_end-v_16x16),d0

.loadblocks:
		move.l	(a0)+,(a4)+
		dbf	d0,.loadblocks
		movea.l	(a2)+,a0
		lea	(v_256x256&$FFFFFF).l,a1
		bsr.w	KosDec
		bsr.w	LevelLayoutLoad
		move.w	(a2)+,d0
		move.w	(a2),d0
		andi.w	#$FF,d0
		bsr.w	PalLoad1
		movea.l	(sp)+,a2
		addq.w	#4,a2
		moveq	#0,d0
		move.b	(a2),d0
		beq.s	.locret
		bsr.w	AddPLC

.locret:
		rts
; ---------------------------------------------------------------------------
;sub_485C:
		moveq	#0,d0
		move.b	(v_lives).w,d1
		cmpi.b	#2,d1
		bcs.s	loc_4876
		move.b	d1,d0
		subq.b	#1,d0
		cmpi.b	#5,d0
		bcs.s	loc_4876
		move.b	#4,d0

loc_4876:
		lea	(vdp_data_port).l,a6
		locVRAM $ACBE
		move.l	#$8579857A,d2
		bsr.s	sub_489E
		locVRAM $AD3E
		move.l	#$857B857C,d2

sub_489E:
		moveq	#0,d3
		moveq	#3,d1
		sub.w	d0,d1
		bcs.s	loc_48AC

loc_48A6:
		move.l	d3,(a6)
		dbf	d1,loc_48A6

loc_48AC:
		move.w	d0,d1
		subq.w	#1,d1
		bcs.s	locret_48B8

loc_48B2:
		move.l	d2,(a6)
		dbf	d1,loc_48B2

locret_48B8:
		rts
; ---------------------------------------------------------------------------

LevelLayoutLoad:
		; This is bugged, the size is too large!
		; To fix this, change bytesToWcnt to bytesToLcnt.
		lea	(v_lvllayout).w,a3
		move.w	#bytesToWcnt(v_lvllayout_end-v_lvllayout),d1
		moveq	#0,d0

loc_48C4:
		move.l	d0,(a3)+
		dbf	d1,loc_48C4
		lea	(v_lvllayout).w,a3
		moveq	#0,d1
		bsr.w	sub_48DA
		lea	(v_lvllayoutbg).w,a3
		moveq	#2,d1

sub_48DA:
		move.w	(v_zone).w,d0
		lsl.b	#6,d0
		lsr.w	#5,d0
		move.w	d0,d2
		add.w	d0,d0
		add.w	d2,d0
		add.w	d1,d0
		lea	(LayoutArray).l,a1
		move.w	(a1,d0.w),d0
		lea	(a1,d0.w),a1
		moveq	#0,d1
		move.w	d1,d2
		move.b	(a1)+,d1
		move.b	(a1)+,d2

loc_4900:
		move.w	d1,d0
		movea.l	a3,a0

loc_4904:
		move.b	(a1)+,(a0)+
		dbf	d0,loc_4904
		lea	layoutsize*2(a3),a3
		dbf	d2,loc_4900
		rts
; ---------------------------------------------------------------------------

		include "_inc/DynamicLevelEvents.asm"

		include "_incObj/02.asm"
Map_02:		include "_maps/02.asm"

		include "_incObj/03.asm"
		include "_incObj/04.asm"
		include "_incObj/05.asm"
Map_05:		include "_maps/05.asm"

		include "_incObj/06.asm"
		include "_incObj/07.asm"
		include "_incObj/11 Bridge (part 1).asm"
; ---------------------------------------------------------------------------

PtfmBridge:
		moveq	#0,d1
		move.b	obSubtype(a0),d1
		lsl.w	#3,d1
		move.w	d1,d2
		addq.w	#8,d1
		add.w	d2,d2
		lea	(v_objspace).w,a1
		tst.w	obVelY(a1)
		bmi.w	locret_5048
		move.w	obX(a1),d0
		sub.w	obX(a0),d0
		add.w	d1,d0
		bmi.w	locret_5048
		cmp.w	d2,d0
		bhs.w	locret_5048
		bra.s	PtfmNormal2
; ---------------------------------------------------------------------------

PtfmNormal:
		lea	(v_objspace).w,a1
		tst.w	obVelY(a1)
		bmi.w	locret_5048
		move.w	obX(a1),d0
		sub.w	obX(a0),d0
		add.w	d1,d0
		bmi.w	locret_5048
		add.w	d1,d1
		cmp.w	d1,d0
		bhs.w	locret_5048

PtfmNormal2:
		move.w	obY(a0),d0
		subq.w	#8,d0

PtfmNormal3:
		move.w	obY(a1),d2
		move.b	obHeight(a1),d1
		ext.w	d1
		add.w	d2,d1
		addq.w	#4,d1
		sub.w	d1,d0
		bhi.w	locret_5048
		cmpi.w	#-$10,d0
		bcs.w	locret_5048
		cmpi.b	#6,obRoutine(a1)
		bhs.w	locret_5048
		add.w	d0,d2
		addq.w	#3,d2
		move.w	d2,obY(a1)
		addq.b	#2,obRoutine(a0)

loc_4FD4:
		btst	#3,obStatus(a1)
		beq.s	loc_4FFC
		moveq	#0,d0
		move.b	standonobject(a1),d0
		lsl.w	#object_size_bits,d0
		addi.l	#v_objspace&$FFFFFF,d0
		movea.l	d0,a2
		cmpi.b	#4,obRoutine(a2)
		bne.s	loc_4FFC
		subq.b	#2,obRoutine(a2)
		clr.b	ob2ndRout(a2)

loc_4FFC:
		move.w	a0,d0
		subi.w	#v_objspace,d0
		lsr.w	#object_size_bits,d0
		andi.w	#$7F,d0
		move.b	d0,standonobject(a1)
		move.b	#0,obAngle(a1)
		move.w	#0,obVelY(a1)
		move.w	obVelX(a1),d0
		asr.w	#2,d0
		sub.w	d0,obVelX(a1)
		move.w	obVelX(a1),obInertia(a1)
		btst	#1,obStatus(a1)
		beq.s	loc_503C
		move.l	a0,-(sp)
		movea.l	a1,a0
		jsr	(Sonic_ResetOnFloor).l
		movea.l	(sp)+,a0

loc_503C:
		bset	#3,obStatus(a1)
		bset	#3,obStatus(a0)

locret_5048:
		rts
; ---------------------------------------------------------------------------

PtfmSloped:
		lea	(v_objspace).w,a1
		tst.w	obVelY(a1)
		bmi.w	locret_5048
		move.w	obX(a1),d0
		sub.w	obX(a0),d0
		add.w	d1,d0
		bmi.s	locret_5048
		add.w	d1,d1
		cmp.w	d1,d0
		bhs.s	locret_5048
		btst	#0,obRender(a0)
		beq.s	loc_5074
		not.w	d0
		add.w	d1,d0

loc_5074:
		lsr.w	#1,d0
		moveq	#0,d3
		move.b	(a2,d0.w),d3
		move.w	obY(a0),d0
		sub.w	d3,d0
		bra.w	PtfmNormal3
; ---------------------------------------------------------------------------

PtfmNormalHeight:
		lea	(v_objspace).w,a1
		tst.w	obVelY(a1)
		bmi.w	locret_5048
		move.w	obX(a1),d0
		sub.w	obX(a0),d0
		add.w	d1,d0
		bmi.w	locret_5048
		add.w	d1,d1
		cmp.w	d1,d0
		bhs.w	locret_5048
		move.w	obY(a0),d0
		sub.w	d3,d0
		bra.w	PtfmNormal3

		include "_incObj/11 Bridge (part 2).asm"
; ---------------------------------------------------------------------------

PtfmCheckExit:
		move.w	d1,d2

PtfmCheckExit2:
		add.w	d2,d2
		lea	(v_objspace).w,a1
		btst	#1,obStatus(a1)
		bne.s	loc_510A
		move.w	obX(a1),d0
		sub.w	obX(a0),d0
		add.w	d1,d0
		bmi.s	loc_510A
		cmp.w	d2,d0
		bcs.s	locret_511C

loc_510A:
		bclr	#3,obStatus(a1)
		move.b	#2,obRoutine(a0)
		bclr	#3,obStatus(a0)

locret_511C:
		rts

		include "_incObj/11 Bridge (part 3).asm"
MapBridge:	include "_maps/Bridge.asm"

		include "_incObj/15 Swinging Platform.asm"
Map_Swing_GHZ:	include "_maps/Swinging Platforms (GHZ).asm"
Map_Swing_SLZ:	include "_maps/Swinging Platforms (SLZ).asm"

		include "_incObj/17 Spiked Pole Helix.asm"
Map_Hel:	include "_maps/Spiked Pole Helix.asm"

		include "_incObj/18 Platforms.asm"
		include "_maps/Platforms (unused).asm"
Map_Plat_GHZ:	include "_maps/Platforms (GHZ).asm"
Map_Plat_SZ:	include "_maps/Platforms (SZ).asm"
Map_Plat_SLZ:	include "_maps/Platforms (SLZ).asm"

		include "_incObj/19 GHZ Ball.asm"
Map_GBall:	include "_maps/GHZ Ball.asm"

		include "_incObj/1A Collapsing Ledge (part 1).asm"
		include "_incObj/53 Collapsing Floors.asm"
; ---------------------------------------------------------------------------

loc_612A:
		move.b	#0,ledge_collapse_flag(a0)

loc_6130:
		lea	(CFlo_Data1).l,a4
		moveq	#$18,d1
		addq.b	#2,obFrame(a0)

loc_613C:
		moveq	#0,d0
		move.b	obFrame(a0),d0
		add.w	d0,d0
		movea.l	obMap(a0),a3
		adda.w	(a3,d0.w),a3
		addq.w	#1,a3
		bset	#5,obRender(a0)
		_move.b	obID(a0),d4
		move.b	obRender(a0),d5
		movea.l	a0,a1
		bra.s	loc_6168
; ---------------------------------------------------------------------------

loc_6160:
		bsr.w	FindFreeObj
		bne.s	loc_61A8
		addq.w	#5,a3

loc_6168:
		move.b	#6,obRoutine(a1)
		_move.b	d4,obID(a1)
		move.l	a3,obMap(a1)
		move.b	d5,obRender(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		move.w	obGfx(a0),obGfx(a1)
		move.b	obPriority(a0),obPriority(a1)
		move.b	obActWid(a0),obActWid(a1)
		move.b	(a4)+,ledge_timedelay(a1)
		cmpa.l	a0,a1
		bhs.s	loc_61A4
		bsr.w	DisplaySprite1

loc_61A4:
		dbf	d1,loc_6160

loc_61A8:
		bsr.w	DisplaySprite
		move.w	#sfx_Collapse,d0
		jmp	(PlaySound_Special).l
; ---------------------------------------------------------------------------

CFlo_Data1:	dc.b $1C, $18, $14, $10, $1A, $16, $12, $E, $A, 6, $18
		dc.b $14, $10, $C, 8, 4, $16, $12, $E, $A, 6, 2, $14, $10
		dc.b $C, 0
		even
CFlo_Data2:	dc.b $1E, $16, $E, 6, $1A, $12, $A, 2
		even
CFlo_Data3:	dc.b $16, $1E, $1A, $12, 6, $E, $A, 2
		even
; ---------------------------------------------------------------------------

sub_61E0:
		lea	(v_objspace).w,a1
		btst	#3,obStatus(a1)
		beq.s	locret_6224
		move.w	obX(a1),d0
		sub.w	obX(a0),d0
		add.w	d1,d0
		lsr.w	#1,d0
		btst	#0,obRender(a0)
		beq.s	loc_6204
		not.w	d0
		add.w	d1,d0

loc_6204:
		moveq	#0,d1
		move.b	(a2,d0.w),d1
		move.w	obY(a0),d0
		sub.w	d1,d0
		moveq	#0,d1
		move.b	obHeight(a1),d1
		sub.w	d1,d0
		move.w	d0,obY(a1)
		sub.w	obX(a0),d2
		sub.w	d2,obX(a1)

locret_6224:
		rts
; ---------------------------------------------------------------------------

ObjCollapsePtfm_Slope:dc.b $20, $20, $20, $20, $20, $20, $20, $20, $21, $21
		dc.b $22, $22, $23, $23, $24, $24, $25, $25, $26, $26
		dc.b $27, $27, $28, $28, $29, $29, $2A, $2A, $2B, $2B
		dc.b $2C, $2C, $2D, $2D, $2E, $2E, $2F, $2F, $30, $30
		dc.b $30, $30, $30, $30, $30, $30, $30, $30
		even

		include "_maps/06256.asm"
Map_Ledge:	include "_maps/Collapsing Ledge.asm"
Map_CFlo:	include "_maps/Collapsing Floors.asm"

		include "_incObj/1B.asm"
Map_1B:		include "_maps/1B.asm"

		include "_incObj/1C Scenery.asm"
Map_Scen:	include "_maps/Scenery.asm"

		include "_incObj/1D Unused Switch.asm"
Map_UnkSwitch:	include "_maps/Unknown Switch.asm"

		include "_incObj/2A Switch Door.asm"
; ---------------------------------------------------------------------------

sub_6936:
		tst.w	(v_debuguse).w
		bne.w	locret_69A6
		cmpi.b	#6,(v_player+obRoutine).w
		bhs.s	locret_69A6
		bsr.w	Obj44_SolidWall2
		beq.s	loc_698C
		bmi.w	loc_69A8
		tst.w	d0
		beq.w	loc_6976
		bmi.s	loc_6960
		tst.w	obVelX(a1)
		bmi.s	loc_6976
		bra.s	loc_6966
; ---------------------------------------------------------------------------

loc_6960:
		tst.w	obVelX(a1)
		bpl.s	loc_6976

loc_6966:
		sub.w	d0,obX(a1)
		move.w	#0,obInertia(a1)
		move.w	#0,obVelX(a1)

loc_6976:
		btst	#1,obStatus(a1)
		bne.s	loc_699A
		bset	#5,obStatus(a1)
		bset	#5,obStatus(a0)
		rts
; ---------------------------------------------------------------------------

loc_698C:
		btst	#5,obStatus(a0)
		beq.s	locret_69A6
		move.w	#id_Run,obAnim(a1)

loc_699A:
		bclr	#5,obStatus(a0)
		bclr	#5,obStatus(a1)

locret_69A6:
		rts
; ---------------------------------------------------------------------------

loc_69A8:
		tst.w	obVelY(a1)
		beq.s	loc_69C0
		bpl.s	locret_69BE
		tst.w	d3
		bpl.s	locret_69BE
		sub.w	d3,obY(a1)
		move.w	#0,obVelY(a1)

locret_69BE:
		rts
; ---------------------------------------------------------------------------

loc_69C0:
		move.l	a0,-(sp)
		movea.l	a1,a0
		jsr	(loc_FD78).l
		movea.l	(sp)+,a0
		rts
; ---------------------------------------------------------------------------

Obj44_SolidWall2:
		lea	(v_player).w,a1
		move.w	obX(a1),d0
		sub.w	obX(a0),d0
		add.w	d1,d0
		bmi.s	loc_6A28
		move.w	d1,d3
		add.w	d3,d3
		cmp.w	d3,d0
		bhi.s	loc_6A28
		move.b	obHeight(a1),d3
		ext.w	d3
		add.w	d3,d2
		move.w	obY(a1),d3
		sub.w	obY(a0),d3
		add.w	d2,d3
		bmi.s	loc_6A28
		move.w	d2,d4
		add.w	d4,d4
		cmp.w	d4,d3
		bhs.s	loc_6A28
		move.w	d0,d5
		cmp.w	d0,d1
		bhs.s	loc_6A10
		add.w	d1,d1
		sub.w	d1,d0
		move.w	d0,d5
		neg.w	d5

loc_6A10:
		move.w	d3,d1
		cmp.w	d3,d2
		bhs.s	loc_6A1C
		sub.w	d4,d3
		move.w	d3,d1
		neg.w	d1

loc_6A1C:
		cmp.w	d1,d5
		bhi.s	loc_6A24
		moveq	#1,d4
		rts
; ---------------------------------------------------------------------------

loc_6A24:
		moveq	#-1,d4
		rts
; ---------------------------------------------------------------------------

loc_6A28:
		moveq	#0,d4
		rts
; ---------------------------------------------------------------------------
Map_2A:		include "_maps/2A.asm"

		include "_incObj/0E Title Screen Sonic.asm"
		include "_incObj/0F Press Start.asm"
		include "_anim/Title Screen Sonic.asm"
		include "_anim/Press Start.asm"
; ---------------------------------------------------------------------------

AnimateSprite:
		moveq	#0,d0
		move.b	obAnim(a0),d0
		cmp.b	obNextAni(a0),d0
		beq.s	loc_6B54
		move.b	d0,obNextAni(a0)
		move.b	#0,obAniFrame(a0)
		move.b	#0,obTimeFrame(a0)

loc_6B54:
		add.w	d0,d0
		adda.w	(a1,d0.w),a1
		subq.b	#1,obTimeFrame(a0)
		bpl.s	locret_6B94
		move.b	(a1),obTimeFrame(a0)
		moveq	#0,d1
		move.b	obAniFrame(a0),d1
		move.b	1(a1,d1.w),d0
		bmi.s	loc_6B96

loc_6B70:
		move.b	d0,d1
		andi.b	#$1F,d0
		move.b	d0,obFrame(a0)
		move.b	obStatus(a0),d0
		andi.b	#3,d0
		andi.b	#$FC,obRender(a0)
		lsr.b	#5,d1
		eor.b	d0,d1
		or.b	d1,obRender(a0)
		addq.b	#1,obAniFrame(a0)

locret_6B94:
		rts
; ---------------------------------------------------------------------------

loc_6B96:
		addq.b	#1,d0
		bne.s	loc_6BA6
		move.b	#0,obAniFrame(a0)
		move.b	obRender(a1),d0
		bra.s	loc_6B70
; ---------------------------------------------------------------------------

loc_6BA6:
		addq.b	#1,d0
		bne.s	loc_6BBA
		move.b	2(a1,d1.w),d0
		sub.b	d0,obAniFrame(a0)
		sub.b	d0,d1
		move.b	1(a1,d1.w),d0
		bra.s	loc_6B70
; ---------------------------------------------------------------------------

loc_6BBA:
		addq.b	#1,d0
		bne.s	loc_6BC4
		move.b	2(a1,d1.w),obAnim(a0)

loc_6BC4:
		addq.b	#1,d0
		bne.s	loc_6BCC
		addq.b	#2,obRoutine(a0)

loc_6BCC:
		addq.b	#1,d0
		bne.s	locret_6BDA
		move.b	#0,obAniFrame(a0)
		clr.b	ob2ndRout(a0)

locret_6BDA:
		rts
; ---------------------------------------------------------------------------
Map_TitleText:	include "_maps/Press Start.asm"
Map_TitleSonic:	include "_maps/Title Screen Sonic.asm"

		include "_incObj/1E Ballhog.asm"
		include "_incObj/20 Ballhog's Bomb.asm"
		include "_incObj/24, 27 & 3F Explosions.asm"
		include "_anim/Ball Hog.asm"
Map_Hog:	include "_maps/Ball Hog.asm"
		include "_maps/Ball Hog's Bomb.asm"
		include "_maps/Ball Hog's Bomb Explosion.asm"
		include "_maps/Explosions.asm"

		include "_incObj/28 Animals.asm"
		include "_incObj/29 Points.asm"
Map_Animal1:	include "_maps/Animals 1.asm"
Map_Animal2:	include "_maps/Animals 2.asm"
Map_Animal3:	include "_maps/Animals 3.asm"
Map_Poi:	include "_maps/Points.asm"

		include "_incObj/1F Crabmeat.asm"
		include "_anim/Crabmeat.asm"
Map_Crab:	include "_maps/Crabmeat.asm"

		include "_incObj/22 Buzz Bomber.asm"
		include "_incObj/23 Buzz Bomber Missile.asm"
		include "_anim/Buzz Bomber.asm"
		include "_anim/Buzz Bomber Missile.asm"
Map_Buzz:	include "_maps/Buzz Bomber.asm"
Map_Missile:	include "_maps/Buzz Bomber Missile.asm"

		include "_incObj/25 & 37 Rings.asm"
		include "_incObj/4B Giant Ring Flash.asm"
		include "_anim/Rings.asm"
Map_Ring:	include "_maps/Rings.asm"
Map_GRing:	include "_maps/Giant Ring.asm"

		include "_incObj/26 Monitor.asm"
		include "_incObj/2E Monitor Content Power-Up.asm"
		include "_incObj/26 Monitor (SolidSides subroutine).asm"
		include "_anim/Monitor.asm"
Map_Monitor:	include "_maps/Monitor.asm"
; ---------------------------------------------------------------------------

ExecuteObjects:
		lea	(v_objspace).w,a0
		moveq	#(v_objspace_end-v_objspace)/object_size-1,d7
		moveq	#0,d0
		cmpi.b	#6,(v_player+obRoutine).w	; has sonic died?
		bhs.s	loc_8560			; if so, branch

sub_8546:
		move.b	obID(a0),d0
		beq.s	loc_8556
		add.w	d0,d0
		add.w	d0,d0
		movea.l	Obj_Index-4(pc,d0.w),a1
		jsr	(a1)
		moveq	#0,d0

loc_8556:
		lea	object_size(a0),a0
		dbf	d7,sub_8546
		rts
; ---------------------------------------------------------------------------

loc_8560:
		moveq	#(v_lvlobjspace-v_objspace)/object_size-1,d7
		bsr.s	sub_8546
		moveq	#(v_lvlobjend-v_lvlobjspace)/object_size-1,d7

loc_8566:
		moveq	#0,d0
		move.b	obID(a0),d0
		beq.s	loc_8576
		tst.b	obRender(a0)
		bpl.s	loc_8576
		bsr.w	DisplaySprite

loc_8576:
		lea	object_size(a0),a0
		dbf	d7,loc_8566
		rts
; ---------------------------------------------------------------------------
Obj_Index:
		include "_inc/Object Pointers.asm"
		include "_incObj/sub ObjectFall.asm"
		include "_incObj/sub SpeedToPos.asm"
		include "_incObj/sub DisplaySprite.asm"
		include "_incObj/sub DeleteObject.asm"
; ---------------------------------------------------------------------------

off_8796:	dc.l 0
		dc.l v_screenposx&$FFFFFF
		dc.l v_bgscreenposx&$FFFFFF
		dc.l v_bg3screenposx&$FFFFFF
; ---------------------------------------------------------------------------

BuildSprites:
		lea	(v_spritetablebuffer).w,a2
		moveq	#0,d5
		lea	(v_spritequeue).w,a4
		moveq	#7,d7

loc_87B2:
		tst.w	(a4)
		beq.w	loc_8876
		moveq	#2,d6

loc_87BA:
		movea.w	(a4,d6.w),a0
		tst.b	(a0)
		beq.w	loc_886E
		bclr	#7,obRender(a0)
		move.b	obRender(a0),d0
		move.b	d0,d4
		andi.w	#$C,d0
		beq.s	loc_8826
		movea.l	off_8796(pc,d0.w),a1
		moveq	#0,d0
		move.b	obActWid(a0),d0
		move.w	obX(a0),d3
		sub.w	(a1),d3
		move.w	d3,d1
		add.w	d0,d1
		bmi.w	loc_886E
		move.w	d3,d1
		sub.w	d0,d1
		cmpi.w	#320,d1
		bge.s	loc_886E
		addi.w	#$80,d3
		btst	#4,d4
		beq.s	loc_8830
		moveq	#0,d0
		move.b	obHeight(a0),d0
		move.w	obY(a0),d2
		sub.w	obMap(a1),d2
		move.w	d2,d1
		add.w	d0,d1
		bmi.s	loc_886E
		move.w	d2,d1
		sub.w	d0,d1
		cmpi.w	#224,d1
		bge.s	loc_886E
		addi.w	#$80,d2
		bra.s	loc_8848
; ---------------------------------------------------------------------------

loc_8826:
		move.w	obScreenY(a0),d2
		move.w	obX(a0),d3
		bra.s	loc_8848
; ---------------------------------------------------------------------------

loc_8830:
		move.w	obY(a0),d2
		sub.w	obMap(a1),d2
		addi.w	#$80,d2
		cmpi.w	#96,d2
		bcs.s	loc_886E
		cmpi.w	#384,d2
		bhs.s	loc_886E

loc_8848:
		movea.l	obMap(a0),a1
		moveq	#0,d1
		btst	#5,d4
		bne.s	loc_8864
		move.b	obFrame(a0),d1
		add.b	d1,d1
		adda.w	(a1,d1.w),a1
		move.b	(a1)+,d1
		subq.b	#1,d1
		bmi.s	loc_8868

loc_8864:
		bsr.w	sub_8898

loc_8868:
		bset	#7,obRender(a0)

loc_886E:
		addq.w	#2,d6
		subq.w	#2,(a4)
		bne.w	loc_87BA

loc_8876:
		lea	$80(a4),a4
		dbf	d7,loc_87B2
		move.b	d5,(v_spritecount).w
		cmpi.b	#$50,d5
		beq.s	loc_8890
		move.l	#0,(a2)
		rts
; ---------------------------------------------------------------------------

loc_8890:
		move.b	#0,-5(a2)
		rts
; ---------------------------------------------------------------------------

sub_8898:
		movea.w	obGfx(a0),a3
		btst	#0,d4
		bne.s	loc_88DE
		btst	#1,d4
		bne.w	loc_892C

sub_88AA:
		cmpi.b	#$50,d5
		beq.s	locret_88DC
		move.b	(a1)+,d0
		ext.w	d0
		add.w	d2,d0
		move.w	d0,(a2)+
		move.b	(a1)+,(a2)+
		addq.b	#1,d5
		move.b	d5,(a2)+
		move.b	(a1)+,d0
		lsl.w	#8,d0
		move.b	(a1)+,d0
		add.w	a3,d0
		move.w	d0,(a2)+
		move.b	(a1)+,d0
		ext.w	d0
		add.w	d3,d0
		andi.w	#$1FF,d0
		bne.s	loc_88D6
		addq.w	#1,d0

loc_88D6:
		move.w	d0,(a2)+
		dbf	d1,sub_88AA

locret_88DC:
		rts
; ---------------------------------------------------------------------------

loc_88DE:
		btst	#1,d4
		bne.w	loc_8972

loc_88E6:
		cmpi.b	#$50,d5
		beq.s	locret_892A
		move.b	(a1)+,d0
		ext.w	d0
		add.w	d2,d0
		move.w	d0,(a2)+
		move.b	(a1)+,d4
		move.b	d4,(a2)+
		addq.b	#1,d5
		move.b	d5,(a2)+
		move.b	(a1)+,d0
		lsl.w	#8,d0
		move.b	(a1)+,d0
		add.w	a3,d0
		eori.w	#$800,d0
		move.w	d0,(a2)+
		move.b	(a1)+,d0
		ext.w	d0
		neg.w	d0
		add.b	d4,d4
		andi.w	#$18,d4
		addq.w	#8,d4
		sub.w	d4,d0
		add.w	d3,d0
		andi.w	#$1FF,d0
		bne.s	loc_8924
		addq.w	#1,d0

loc_8924:
		move.w	d0,(a2)+
		dbf	d1,loc_88E6

locret_892A:
		rts
; ---------------------------------------------------------------------------

loc_892C:
		cmpi.b	#$50,d5
		beq.s	locret_8970
		move.b	(a1)+,d0
		move.b	(a1),d4
		ext.w	d0
		neg.w	d0
		lsl.b	#3,d4
		andi.w	#$18,d4
		addq.w	#8,d4
		sub.w	d4,d0
		add.w	d2,d0
		move.w	d0,(a2)+
		move.b	(a1)+,(a2)+
		addq.b	#1,d5
		move.b	d5,(a2)+
		move.b	(a1)+,d0
		lsl.w	#8,d0
		move.b	(a1)+,d0
		add.w	a3,d0
		eori.w	#$1000,d0
		move.w	d0,(a2)+
		move.b	(a1)+,d0
		ext.w	d0
		add.w	d3,d0
		andi.w	#$1FF,d0
		bne.s	loc_896A
		addq.w	#1,d0

loc_896A:
		move.w	d0,(a2)+
		dbf	d1,loc_892C

locret_8970:
		rts
; ---------------------------------------------------------------------------

loc_8972:
		cmpi.b	#$50,d5
		beq.s	locret_89C4
		move.b	(a1)+,d0
		move.b	(a1),d4
		ext.w	d0
		neg.w	d0
		lsl.b	#3,d4
		andi.w	#$18,d4
		addq.w	#8,d4
		sub.w	d4,d0
		add.w	d2,d0
		move.w	d0,(a2)+
		move.b	(a1)+,d4
		move.b	d4,(a2)+
		addq.b	#1,d5
		move.b	d5,(a2)+
		move.b	(a1)+,d0
		lsl.w	#8,d0
		move.b	(a1)+,d0
		add.w	a3,d0
		eori.w	#$1800,d0
		move.w	d0,(a2)+
		move.b	(a1)+,d0
		ext.w	d0
		neg.w	d0
		add.b	d4,d4
		andi.w	#$18,d4
		addq.w	#8,d4
		sub.w	d4,d0
		add.w	d3,d0
		andi.w	#$1FF,d0
		bne.s	loc_89BE
		addq.w	#1,d0

loc_89BE:
		move.w	d0,(a2)+
		dbf	d1,loc_8972

locret_89C4:
		rts
; ---------------------------------------------------------------------------

ObjectChkOffscreen:
		move.w	obX(a0),d0
		sub.w	(v_screenposx).w,d0
		bmi.s	.offscreen
		cmpi.w	#320,d0
		bge.s	.offscreen
		move.w	obY(a0),d1
		sub.w	(v_screenposy).w,d1
		bmi.s	.offscreen
		cmpi.w	#224,d1
		bge.s	.offscreen
		moveq	#0,d0
		rts
; ---------------------------------------------------------------------------

.offscreen:
		moveq	#1,d0
		rts
; ---------------------------------------------------------------------------

ObjPosLoad:
		moveq	#0,d0
		move.b	(v_opl_routine).w,d0
		move.w	off_89FC(pc,d0.w),d0
		jmp	off_89FC(pc,d0.w)
; ---------------------------------------------------------------------------

off_89FC:	dc.w loc_8A00-off_89FC, loc_8A44-off_89FC
; ---------------------------------------------------------------------------

loc_8A00:
		addq.b	#2,(v_opl_routine).w
		move.w	(v_zone).w,d0
		lsl.b	#6,d0
		lsr.w	#4,d0
		lea	(ObjPos_Index).l,a0
		movea.l	a0,a1
		adda.w	(a0,d0.w),a0
		move.l	a0,(v_opl_data).w
		move.l	a0,(v_opl_data+4).w
		adda.w	2(a1,d0.w),a1
		move.l	a1,(v_opl_data+8).w
		move.l	a1,(v_opl_data+$C).w
		lea	(v_objstate).w,a2
		move.w	#$101,(a2)+
		; Bug: The last 2 bytes of v_objstate are not accounted for.
		move.w	#bytesToWcnt(v_objstate_end-v_objstate-2),d0

loc_8A38:
		clr.l	(a2)+
		dbf	d0,loc_8A38
		move.w	#-1,(v_opl_screen).w

loc_8A44:
		lea	(v_objstate).w,a2
		moveq	#0,d2
		move.w	(v_screenposx).w,d6
		andi.w	#-$80,d6
		cmp.w	(v_opl_screen).w,d6
		beq.w	locret_8B20
		bge.s	loc_8ABA
		move.w	d6,(v_opl_screen).w
		movea.l	(v_opl_data+4).w,a0
		subi.w	#$80,d6
		bcs.s	loc_8A96

loc_8A6A:
		cmp.w	-6(a0),d6
		bge.s	loc_8A96
		subq.w	#6,a0
		tst.b	4(a0)
		bpl.s	loc_8A80
		subq.b	#1,1(a2)
		move.b	1(a2),d2

loc_8A80:
		bsr.w	sub_8B22
		bne.s	loc_8A8A
		subq.w	#6,a0
		bra.s	loc_8A6A
; ---------------------------------------------------------------------------

loc_8A8A:
		tst.b	4(a0)
		bpl.s	loc_8A94
		addq.b	#1,1(a2)

loc_8A94:
		addq.w	#6,a0

loc_8A96:
		move.l	a0,(v_opl_data+4).w
		movea.l	(v_opl_data).w,a0
		addi.w	#$300,d6

loc_8AA2:
		cmp.w	-6(a0),d6
		bgt.s	loc_8AB4
		tst.b	-2(a0)
		bpl.s	loc_8AB0
		subq.b	#1,(a2)

loc_8AB0:
		subq.w	#6,a0
		bra.s	loc_8AA2
; ---------------------------------------------------------------------------

loc_8AB4:
		move.l	a0,(v_opl_data).w
		rts
; ---------------------------------------------------------------------------

loc_8ABA:
		move.w	d6,(v_opl_screen).w
		movea.l	(v_opl_data).w,a0
		addi.w	#$280,d6

loc_8AC6:
		cmp.w	(a0),d6
		bls.s	loc_8ADA
		tst.b	4(a0)
		bpl.s	loc_8AD4
		move.b	(a2),d2
		addq.b	#1,(a2)

loc_8AD4:
		bsr.w	sub_8B22
		beq.s	loc_8AC6

loc_8ADA:
		move.l	a0,(v_opl_data).w
		movea.l	(v_opl_data+4).w,a0
		subi.w	#$300,d6
		bcs.s	loc_8AFA

loc_8AE8:
		cmp.w	(a0),d6
		bls.s	loc_8AFA
		tst.b	4(a0)
		bpl.s	loc_8AF6
		addq.b	#1,1(a2)

loc_8AF6:
		addq.w	#6,a0
		bra.s	loc_8AE8
; ---------------------------------------------------------------------------

loc_8AFA:
		move.l	a0,(v_opl_data+4).w
		rts
; ---------------------------------------------------------------------------

loc_8B00:
		movea.l	(v_opl_data+8).w,a0
		move.w	(v_bg3screenposx).w,d0
		addi.w	#$200,d0
		andi.w	#-$80,d0
		cmp.w	(a0),d0
		bcs.s	locret_8B20
		bsr.w	sub_8B22
		move.l	a0,(v_opl_data+8).w
		bra.w	loc_8B00
; ---------------------------------------------------------------------------

locret_8B20:
		rts
; ---------------------------------------------------------------------------

sub_8B22:
		tst.b	4(a0)
		bpl.s	loc_8B36
		bset	#7,2(a2,d2.w)
		beq.s	loc_8B36
		addq.w	#6,a0
		moveq	#0,d0
		rts
; ---------------------------------------------------------------------------

loc_8B36:
		bsr.w	FindFreeObj
		bne.s	locret_8B70
		move.w	(a0)+,obX(a1)
		move.w	(a0)+,d0
		move.w	d0,d1
		andi.w	#$FFF,d0
		move.w	d0,obY(a1)
		rol.w	#2,d1
		andi.b	#3,d1
		move.b	d1,obRender(a1)
		move.b	d1,obStatus(a1)
		move.b	(a0)+,d0
		bpl.s	loc_8B66
		andi.b	#$7F,d0
		move.b	d2,obRespawnNo(a1)

loc_8B66:
		_move.b	d0,obID(a1)
		move.b	(a0)+,obSubtype(a1)
		moveq	#0,d0

locret_8B70:
		rts
; ---------------------------------------------------------------------------

FindFreeObj:
		lea	(v_lvlobjspace).w,a1
		move.w	#(v_lvlobjend-v_lvlobjspace)/object_size-1,d0

loc_8B7A:
		tst.b	obID(a1)
		beq.s	locret_8B86
		lea	object_size(a1),a1
		dbf	d0,loc_8B7A

locret_8B86:
		rts
; ---------------------------------------------------------------------------

FindNextFreeObj:
		movea.l	a0,a1
		move.w	#v_lvlobjend,d0
		sub.w	a0,d0
		lsr.w	#object_size_bits,d0
		subq.w	#1,d0
		bcs.s	locret_8BA2

loc_8B96:
		tst.b	obID(a1)
		beq.s	locret_8BA2
		lea	object_size(a1),a1
		dbf	d0,loc_8B96

locret_8BA2:
		rts

		include "_incObj/2B Chopper.asm"
		include "_anim/Chopper.asm"
Map_Chop:	include "_maps/Chopper.asm"

		include "_incObj/2C Jaws.asm"
		include "_anim/Jaws.asm"
Map_Jaws:	include "_maps/Jaws.asm"

		include "_incObj/2D Burrobot.asm"
		include "_anim/Burrobot.asm"
Map_Burro:	include "_maps/Burrobot.asm"

		include "_incObj/2F MZ Large Grassy Platforms.asm"

		include "_incObj/35 Burning Grass.asm"
		include "_anim/Burning Grass.asm"
Map_LGrass:	include "_maps/MZ Large Grassy Platforms.asm"
Map_Fire:	include "_maps/Fireballs.asm"

		include "_incObj/30 MZ Large Green Glass Blocks.asm"
Map_Glass:	include "_maps/MZ Large Green Glass Blocks.asm"

		include "_incObj/31 Chained Stompers.asm"
		include "_incObj/45 Sideways Stomper.asm"
Map_CStom:	include "_maps/Chained Stompers.asm"
Map_SStom:	include "_maps/Sideways Stomper.asm"

		include "_incObj/32 Button.asm"
		include "_maps/Button.asm"

		include "_incObj/33 Pushable Blocks.asm"
Map_Push:	include "_maps/Pushable Blocks.asm"

		include "_incObj/sub SolidObject.asm"

		include "_incObj/34 Title Cards.asm"
		include "_incObj/39 Game Over.asm"
		include "_incObj/3A Got Through Act.asm"

Map_TitleCard:	dc.w byte_A8A4-Map_TitleCard, byte_A8D2-Map_TitleCard, byte_A900-Map_TitleCard
		dc.w byte_A920-Map_TitleCard, byte_A94E-Map_TitleCard, byte_A97C-Map_TitleCard
		dc.w byte_A9A6-Map_TitleCard, byte_A9BC-Map_TitleCard, byte_A9C7-Map_TitleCard
		dc.w byte_A9D2-Map_TitleCard, byte_A9DD-Map_TitleCard
byte_A8A4:	dc.b 9
		dc.b $F8, 5, 0, $18, $B4
		dc.b $F8, 5, 0, $3A, $C4
		dc.b $F8, 5, 0, $10, $D4
		dc.b $F8, 5, 0, $10, $E4
		dc.b $F8, 5, 0, $2E, $F4
		dc.b $F8, 5, 0, $1C, $14
		dc.b $F8, 1, 0, $20, $24
		dc.b $F8, 5, 0, $26, $2C
		dc.b $F8, 5, 0, $26, $3C
byte_A8D2:	dc.b 9
		dc.b $F8, 5, 0, $26, $BC
		dc.b $F8, 5, 0, 0, $CC
		dc.b $F8, 5, 0, 4, $DC
		dc.b $F8, 5, 0, $4A, $EC
		dc.b $F8, 5, 0, $3A, $FC
		dc.b $F8, 1, 0, $20, $C
		dc.b $F8, 5, 0, $2E, $14
		dc.b $F8, 5, 0, $42, $24
		dc.b $F8, 5, 0, $1C, $34
byte_A900:	dc.b 6
		dc.b $F8, 5, 0, $2A, $CF
		dc.b $F8, 5, 0, 0, $E0
		dc.b $F8, 5, 0, $3A, $F0
		dc.b $F8, 5, 0, 4, 0
		dc.b $F8, 5, 0, $26, $10
		dc.b $F8, 5, 0, $10, $20
		even
byte_A920:	dc.b 9
		dc.b $F8, 5, 0, $3E, $B4
		dc.b $F8, 5, 0, $42, $C4
		dc.b $F8, 5, 0, 0, $D4
		dc.b $F8, 5, 0, $3A, $E4
		dc.b $F8, 5, 0, $26, 4
		dc.b $F8, 1, 0, $20, $14
		dc.b $F8, 5, 0, $18, $1C
		dc.b $F8, 5, 0, $1C, $2C
		dc.b $F8, 5, 0, $42, $3C
byte_A94E:	dc.b 9
		dc.b $F8, 5, 0, $3E, $BC
		dc.b $F8, 5, 0, $36, $CC
		dc.b $F8, 5, 0, 0, $DC
		dc.b $F8, 5, 0, $3A, $EC
		dc.b $F8, 5, 0, $22, $FC
		dc.b $F8, 5, 0, $26, $C
		dc.b $F8, 1, 0, $20, $1C
		dc.b $F8, 5, 0, $2E, $24
		dc.b $F8, 5, 0, $18, $34
byte_A97C:	dc.b 8
		dc.b $F8, 5, 0, 8, $B0
		dc.b $F8, 5, 0, $26, $C0
		dc.b $F8, 5, 0, $32, $D0
		dc.b $F8, 5, 0, 8, $E0
		dc.b $F8, 5, 0, $22, $F0
		dc.b $F8, 5, 0, $32, $20
		dc.b $F8, 5, 0, $3A, $30
		dc.b $F8, 5, 0, $22, $40
		even
byte_A9A6:	dc.b 4
		dc.b $F8, 5, 0, $4E, $E0
		dc.b $F8, 5, 0, $32, $F0
		dc.b $F8, 5, 0, $2E, 0
		dc.b $F8, 5, 0, $10, $10
		even
byte_A9BC:	dc.b 2
		dc.b 4, $C, 0, $53, $EC
		dc.b $F4, 2, 0, $57, $C
byte_A9C7:	dc.b 2
		dc.b 4, $C, 0, $53, $EC
		dc.b $F4, 6, 0, $5A, 8
byte_A9D2:	dc.b 2
		dc.b 4, $C, 0, $53, $EC
		dc.b $F4, 6, 0, $60, 8
byte_A9DD:	dc.b $D
		dc.b $E4, $C, 0, $70, $F4
		dc.b $E4, 2, 0, $74, $14
		dc.b $EC, 4, 0, $77, $EC
		dc.b $F4, 5, 0, $79, $E4
		dc.b $14, $C, $18, $70, $EC
		dc.b 4, 2, $18, $74, $E4
		dc.b $C, 4, $18, $77, 4
		dc.b $FC, 5, $18, $79, $C
		dc.b $EC, 8, 0, $7D, $FC
		dc.b $F4, $C, 0, $7C, $F4
		dc.b $FC, 8, 0, $7C, $F4
		dc.b 4, $C, 0, $7C, $EC
		dc.b $C, 8, 0, $7C, $EC
		even

Map_Over:	include "_maps/Game Over.asm"

; ---------------------------------------------------------------------------
; Sprite mappings - "SONIC HAS PASSED" title card
; ---------------------------------------------------------------------------
Map_Got:	dc.w M_Got_SonicHas-Map_Got
		dc.w byte_AA75-Map_Got
		dc.w byte_AA94-Map_Got
		dc.w byte_AAB3-Map_Got
		dc.w byte_AAD7-Map_Got
		dc.w byte_A9DD-Map_Got
		dc.w byte_A9BC-Map_Got
		dc.w byte_A9C7-Map_Got
		dc.w byte_A9D2-Map_Got
M_Got_SonicHas:	dc.b 8
		dc.b $F8, 5, 0, $3E, $B8
		dc.b $F8, 5, 0, $32, $C8
		dc.b $F8, 5, 0, $2E, $D8
		dc.b $F8, 1, 0, $20, $E8
		dc.b $F8, 5, 0, 8, $F0
		dc.b $F8, 5, 0, $1C, $10
		dc.b $F8, 5, 0, 0, $20
		dc.b $F8, 5, 0, $3E, $30
byte_AA75:	dc.b 6
		dc.b $F8, 5, 0, $36, $D0
		dc.b $F8, 5, 0, 0, $E0
		dc.b $F8, 5, 0, $3E, $F0
		dc.b $F8, 5, 0, $3E, 0
		dc.b $F8, 5, 0, $10, $10
		dc.b $F8, 5, 0, $C, $20
byte_AA94:	dc.b 6
		dc.b $F8, $D, 1, $4A, $B0
		dc.b $F8, 1, 1, $62, $D0
		dc.b $F8, 9, 1, $64, $18
		dc.b $F8, $D, 1, $6A, $30
		dc.b $F7, 4, 0, $6E, $CD
		dc.b $FF, 4, $18, $6E, $CD
byte_AAB3:	dc.b 7
		dc.b $F8, $D, 1, $5A, $B0
		dc.b $F8, $D, 0, $66, $D9
		dc.b $F8, 1, 1, $4A, $F9
		dc.b $F7, 4, 0, $6E, $F6
		dc.b $FF, 4, $18, $6E, $F6
		dc.b $F8, $D, $FF, $F0, $28
		dc.b $F8, 1, 1, $70, $48
byte_AAD7:	dc.b 7
		dc.b $F8, $D, 1, $52, $B0
		dc.b $F8, $D, 0, $66, $D9
		dc.b $F8, 1, 1, $4A, $F9
		dc.b $F7, 4, 0, $6E, $F6
		dc.b $FF, 4, $18, $6E, $F6
		dc.b $F8, $D, $FF, $F8, $28
		dc.b $F8, 1, 1, $70, $48
		even

		include "_incObj/36 Spikes.asm"
		include "_maps/Spikes.asm"

		include "_incObj/3B Purple Rock.asm"
		include "_incObj/49 Waterfall Sound.asm"

Map_PRock:	include "_maps/Purple Rock.asm"

		include "_incObj/3C Smashable Wall.asm"
		include "_incObj/sub SmashObject.asm"

ObjSmashWall_FragRight:
		dc.w $400, -$500
		dc.w $600, -$100
		dc.w $600, $100
		dc.w $400, $500
		dc.w $600, -$600
		dc.w $800, -$200
		dc.w $800, $200
		dc.w $600, $600
		even

ObjSmashWall_FragLeft:
		dc.w -$600, -$600
		dc.w -$800, -$200
		dc.w -$800, $200
		dc.w -$600, $600
		dc.w -$400, -$500
		dc.w -$600, -$100
		dc.w -$600, $100
		dc.w -$400, $500
		even

MapSmashWall:	include "_maps/Smashable Walls.asm"

		include "_incObj/3D Boss - Green Hill (part 1).asm"

sub_B146:
		move.b	(v_vbla_byte).w,d0
		andi.b	#7,d0
		bne.s	locret_B186
		bsr.w	FindFreeObj
		bne.s	locret_B186
		_move.b	#id_ExplosionBomb,obID(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		jsr	(RandomNumber).l
		move.w	d0,d1
		moveq	#0,d1
		move.b	d0,d1
		lsr.b	#2,d1
		subi.w	#$20,d1
		add.w	d1,obX(a1)
		lsr.w	#8,d0
		lsr.b	#3,d0
		add.w	d0,obY(a1)

locret_B186:
		rts
; ---------------------------------------------------------------------------

BossMove:
		move.l	obBossX(a0),d2
		move.l	obBossY(a0),d3
		move.w	obVelX(a0),d0
		ext.l	d0
		asl.l	#8,d0
		add.l	d0,d2
		move.w	obVelY(a0),d0
		ext.l	d0
		asl.l	#8,d0
		add.l	d0,d3
		move.l	d2,obBossX(a0)
		move.l	d3,obBossY(a0)
		rts

		include "_incObj/3D Boss - Green Hill (part 2).asm"
		include "_incObj/48 Eggman's Swinging Ball.asm"

		include "_anim/Eggman.asm"
Map_Eggman:	include "_maps/Eggman.asm"

Map_BossItems:	include "_maps/Boss Items.asm"

		include "_incObj/3E Prison Capsule.asm"

		include "_anim/Prison Capsule.asm"
Map_Pri:	include "_maps/Prison Capsule.asm"

		include "_incObj/40 Motobug.asm"

		include "_anim/Moto Bug.asm"
Map_Moto:	include "_maps/Moto Bug.asm"

		include "_incObj/41 Springs.asm"

		include "_anim/Springs.asm"
Map_Spring:	include "_maps/Springs.asm"

		include "_incObj/42 Newtron.asm"

		include "_anim/Newtron.asm"
Map_Newt:	include "_maps/Newtron.asm"

		include "_incObj/43 Roller.asm"
		include "_anim/Roller.asm"
Map_Roll:	include "_maps/Roller.asm"

		include "_incObj/44 GHZ Edge Walls.asm"
Map_Edge:	include "_maps/GHZ Edge Walls.asm"

		include "_incObj/13 Lava Ball Maker.asm"
		include "_incObj/14 Lava Ball.asm"
		include "_anim/Fireballs.asm"

		include "_incObj/46 MZ Bricks.asm"
Map_Brick:	include "_maps/MZ Bricks.asm"

		include "_incObj/12 Light.asm"
Map_Light:	include "_maps/Light.asm"

		include "_incObj/47 Bumper.asm"
		include "_anim/Bumper.asm"
Map_Bump:	include "_maps/Bumper.asm"

		include "_incObj/0D Signpost.asm"
Ani_Sign:	include "_anim/Signpost.asm"
Map_Sign:	include "_maps/Signpost.asm"

		include "_incObj/4C & 4D Lava Geyser Maker.asm"

		include "_incObj/4E Wall of Lava.asm"

		include "_incObj/54 Lava Tag.asm"
Map_LTag:	include "_maps/Lava Tag.asm"
		include "_anim/Lava Geyser.asm"
		include "_anim/Wall of Lava.asm"
Map_Geyser:	include "_maps/Lava Geyser.asm"
Map_LWall:	include "_maps/Wall of Lava.asm"

		include "_incObj/4F Splats.asm"
Map_Splats:	include "_maps/Splats.asm"

		include "_incObj/50 Yadrin.asm"
Ani_Yadrin:	include "_anim/Yadrin.asm"
Map_Yadrin:	include "_maps/Yadrin.asm"

		include "_incObj/51 Smashable Green Block.asm"

ObjSmashBlock_Frag:
		dc.w -$200, -$200
		dc.w -$100, -$100
		dc.w $200, -$200
		dc.w $100, -$100
		even

MapSmashBlock:	include "_maps/Smashable Green Block.asm"

		include "_incObj/52 Moving Blocks.asm"
MapMovingPtfm:	include "_maps/Moving Blocks (MZ).asm"

		include "_incObj/55 Basaran.asm"
		include "_anim/Basaran.asm"
Map_Bas:	include "_maps/Basaran.asm"

		include "_incObj/56 Floating Blocks and Doors.asm"
Map_FBlock:	include "_maps/Floating Blocks and Doors.asm"

		include "_incObj/57 Spiked Ball and Chain.asm"
		include "_maps/Spiked Ball and Chain (SZ).asm"

		include "_incObj/58 Big Spiked Ball.asm"
		include "_maps/Big Spiked Ball.asm"

		include "_incObj/59 SLZ Elevators.asm"
Map_Elev:	include "_maps/SLZ Elevators.asm"

		include "_incObj/5A SLZ Circling Platform.asm"
Map_Circ:	include "_maps/SLZ Circling Platform.asm"

		include "_incObj/5B Staircase.asm"
Map_Stair:	include "_maps/Staircase.asm"

		include "_incObj/5C Pylon.asm"
Map_Pylon:	include "_maps/Pylon.asm"

		include "_incObj/5D Fan.asm"
Map_Fan:	include "_maps/Fan.asm"

		include "_incObj/5E Seesaw.asm"

ObjSeeSaw_SlopeTilt:dc.b $24, $24, $26, $28, $2A, $2C, $2A, $28, $26, $24
		dc.b $23, $22, $21, $20, $1F, $1E, $1D, $1C, $1B, $1A
		dc.b $19, $18, $17, $16, $15, $14, $13, $12, $11, $10
		dc.b $F, $E, $D, $C, $B, $A, 9, 8, 7, 6, 5, 4, 3, 2, 2
		dc.b 2, 2, 2
		even

ObjSeeSaw_SlopeLine:dc.b $15, $15, $15, $15, $15, $15, $15, $15, $15, $15
		dc.b $15, $15, $15, $15, $15, $15, $15, $15, $15, $15
		dc.b $15, $15, $15, $15, $15, $15, $15, $15, $15, $15
		dc.b $15, $15, $15, $15, $15, $15, $15, $15, $15, $15
		dc.b $15, $15, $15, $15, $15, $15, $15, $15
		even

Map_Seesaw:	include "_maps/Seesaw.asm"
; ---------------------------------------------------------------------------

SonicPlayer:
		tst.w	(v_debuguse).w
		bne.w	DebugMode
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	off_E826(pc,d0.w),d1
		jmp	off_E826(pc,d1.w)
; ---------------------------------------------------------------------------

off_E826:	dc.w loc_E830-off_E826
		dc.w loc_E872-off_E826
		dc.w Sonic_Hurt-off_E826
		dc.w Sonic_Death-off_E826
		dc.w Sonic_ResetLevel-off_E826
; ---------------------------------------------------------------------------

loc_E830:
		addq.b	#2,obRoutine(a0)
		move.b	#$13,obHeight(a0)
		move.b	#9,obWidth(a0)
		move.l	#Map_Sonic,obMap(a0)
		move.w	#$780,obGfx(a0)
		move.b	#2,obPriority(a0)
		move.b	#$18,obActWid(a0)
		move.b	#4,obRender(a0)
		move.w	#$600,(v_sonspeedmax).w
		move.w	#$C,(v_sonspeedacc).w
		move.w	#$40,(v_sonspeeddec).w

loc_E872:
		andi.w	#$7FF,obY(a0)
		andi.w	#$7FF,(v_screenposy).w
		tst.w	(f_debugmode).w
		beq.s	loc_E892
		btst	#bitB,(v_jpadpress2).w
		beq.s	loc_E892
		move.w	#1,(v_debuguse).w

loc_E892:
		moveq	#0,d0
		move.b	obStatus(a0),d0
		andi.w	#6,d0
		move.w	off_E8C8(pc,d0.w),d1
		jsr	off_E8C8(pc,d1.w)
		bsr.s	sub_E8D6
		bsr.w	sub_E952
		move.b	(v_angle_primary).w,objoff_36(a0)
		move.b	(v_angle_secondary).w,objoff_37(a0)
		bsr.w	Sonic_Animate
		bsr.w	TouchObjects
		bsr.w	Sonic_SpecialChunk
		bsr.w	Sonic_DynTiles
		rts
; ---------------------------------------------------------------------------

off_E8C8:	dc.w sub_E96C-off_E8C8
		dc.w sub_E98E-off_E8C8
		dc.w loc_E9A8-off_E8C8
		dc.w loc_E9C6-off_E8C8

MusicList2:	dc.b bgm_GHZ
		dc.b bgm_LZ
		dc.b bgm_MZ
		dc.b bgm_SLZ
		dc.b bgm_SZ
		dc.b bgm_CWZ
		even

		include "_incObj/Sonic Display.asm"
		include "_incObj/Sonic RecordPosition.asm"
; ---------------------------------------------------------------------------

sub_E96C:
		bsr.w	Sonic_Jump
		bsr.w	Sonic_SlopeResist
		bsr.w	Sonic_Move
		bsr.w	Sonic_Roll
		bsr.w	Sonic_LevelBound
		bsr.w	SpeedToPos
		bsr.w	Sonic_AnglePos
		bsr.w	Sonic_SlopeRepel
		rts
; ---------------------------------------------------------------------------

sub_E98E:
		bsr.w	Sonic_JumpHeight
		bsr.w	Sonic_ChgJumpDirection
		bsr.w	Sonic_LevelBound
		bsr.w	ObjectFall
		bsr.w	Sonic_JumpAngle
		bsr.w	Sonic_Floor
		rts
; ---------------------------------------------------------------------------

loc_E9A8:
		bsr.w	Sonic_Jump
		bsr.w	Sonic_RollRepel
		bsr.w	Sonic_RollSpeed
		bsr.w	Sonic_LevelBound
		bsr.w	SpeedToPos
		bsr.w	Sonic_AnglePos
		bsr.w	Sonic_SlopeRepel
		rts
; ---------------------------------------------------------------------------

loc_E9C6:
		bsr.w	Sonic_JumpHeight
		bsr.w	Sonic_ChgJumpDirection
		bsr.w	Sonic_LevelBound
		bsr.w	ObjectFall
		bsr.w	Sonic_JumpAngle
		bsr.w	Sonic_Floor
		rts

		include "_incObj/Sonic Move.asm"
		include "_incObj/Sonic RollSpeed.asm"
		include "_incObj/Sonic JumpDirection.asm"
; ---------------------------------------------------------------------------

;Sonic_Squish:
		move.b	obAngle(a0),d0
		addi.b	#$20,d0
		andi.b	#$C0,d0
		bne.s	locret_EDF8
		bsr.w	Sonic_NoRunningOnWalls
		tst.w	d1
		bpl.s	locret_EDF8
		move.w	#0,obInertia(a0)
		move.w	#0,obVelX(a0)
		move.w	#0,obVelY(a0)
		move.b	#id_Warp3,obAnim(a0)

locret_EDF8:
		rts

		include "_incObj/Sonic LevelBound.asm"
		include "_incObj/Sonic Roll.asm"
		include "_incObj/Sonic Jump.asm"
		include "_incObj/Sonic JumpHeight.asm"
		include "_incObj/Sonic SlopeResist.asm"
		include "_incObj/Sonic RollRepel.asm"
		include "_incObj/Sonic SlopeRepel.asm"
		include "_incObj/Sonic JumpAngle.asm"
		include "_incObj/Sonic Floor.asm"
		include "_incObj/Sonic ResetOnFloor.asm"
; ---------------------------------------------------------------------------

;loc_F26A:
		lea	(v_objslot10).w,a1
		move.w	obX(a0),d0
		bsr.w	sub_F290
		lea	(v_objslot14).w,a1
		move.w	obY(a0),d0
		bsr.w	sub_F290
		lea	(v_objslot18).w,a1
		move.w	obInertia(a0),d0
		bsr.w	sub_F290
		rts
; ---------------------------------------------------------------------------

sub_F290:
		swap	d0
		rol.l	#4,d0
		andi.b	#$F,d0
		move.b	d0,$1A(a1)
		rol.l	#4,d0
		andi.b	#$F,d0
		move.b	d0,$5A(a1)
		rol.l	#4,d0
		andi.b	#$F,d0
		move.b	d0,$9A(a1)
		rol.l	#4,d0
		andi.b	#$F,d0
		move.b	d0,$DA(a1)
		rts

		include "_incObj/Sonic (part 2).asm"
; ---------------------------------------------------------------------------
		dc.b $12
		dc.b 9
		dc.b $A
		dc.b $12
		dc.b 9
		dc.b $A
		dc.b $12
		dc.b 9
		dc.b $A
		dc.b $12
		dc.b 9
		dc.b $A
		dc.b $12
		dc.b 9
		dc.b $A
		dc.b $12
		dc.b 9
		dc.b $12
		dc.b $E
		dc.b 7
		dc.b $A
		dc.b $E
		dc.b 7
		dc.b $A
		even

		include "_incObj/Sonic Loops.asm"
		include "_incObj/Sonic Animate.asm"
; ---------------------------------------------------------------------------
Ani_Sonic:
		include "_anim/Sonic.asm"
		include "_incObj/Sonic LoadGfx.asm"

		include "_incObj/38 Shield and Invincibility.asm"
		include "_incObj/4A Giant Ring.asm"

		include "_anim/Shield.asm"
		include "_maps/Shield.asm"
		even
		include "_anim/Special Stage Entry (Unused).asm"
Map_Vanish:	include "_maps/Special Stage Entry (Unused).asm"

		include "_incObj/sub ReactToItem.asm"

		include "_incObj/Sonic AnglePos.asm"

		include "_incObj/sub FindNearestTile.asm"
		include "_incObj/sub FindFloor.asm"
		include "_incObj/sub FindWall.asm"
; ---------------------------------------------------------------------------

LogCollision:
		rts
; ---------------------------------------------------------------------------
		lea	(colWidth).l,a1
		lea	(colWidth).l,a2
		move.w	#$100-1,d3

loc_1044E:
		moveq	#$10,d5
		move.w	#$10-1,d2

loc_10454:
		moveq	#0,d4
		move.w	#$10-1,d1

loc_1045A:
		move.w	(a1)+,d0
		lsr.l	d5,d0
		addx.w	d4,d4
		dbf	d1,loc_1045A
		move.w	d4,(a2)+
		suba.w	#$20,a1
		subq.w	#1,d5
		dbf	d2,loc_10454
		adda.w	#$20,a1
		dbf	d3,loc_1044E
		lea	(colWidth).l,a1
		lea	(colHeight).l,a2
		bsr.s	sub_10492
		lea	(colWidth).l,a1
		lea	(colWidth).l,a2
; ---------------------------------------------------------------------------

sub_10492:
		move.w	#$FFF,d3

loc_10496:
		moveq	#0,d2
		move.w	#$10-1,d1
		move.w	(a1)+,d0
		beq.s	loc_104C4
		bmi.s	loc_104AE

loc_104A2:
		lsr.w	#1,d0
		bhs.s	loc_104A8
		addq.b	#1,d2

loc_104A8:
		dbf	d1,loc_104A2
		bra.s	loc_104C6
; ---------------------------------------------------------------------------

loc_104AE:
		cmpi.w	#-1,d0
		beq.s	loc_104C0

loc_104B4:
		lsl.w	#1,d0
		bhs.s	loc_104BA
		subq.b	#1,d2

loc_104BA:
		dbf	d1,loc_104B4
		bra.s	loc_104C6
; ---------------------------------------------------------------------------

loc_104C0:
		move.w	#$10,d0

loc_104C4:
		move.w	d0,d2

loc_104C6:
		move.b	d2,(a2)+
		dbf	d3,loc_10496
		rts
; ---------------------------------------------------------------------------

Sonic_WalkSpeed:
		move.l	obX(a0),d3
		move.l	obY(a0),d2
		move.w	obVelX(a0),d1
		ext.l	d1
		asl.l	#8,d1
		add.l	d1,d3
		move.w	obVelY(a0),d1
		ext.l	d1
		asl.l	#8,d1
		add.l	d1,d2
		swap	d2
		swap	d3
		move.b	d0,(v_angle_primary).w
		move.b	d0,(v_angle_secondary).w
		move.b	d0,d1
		addi.b	#$20,d0
		andi.b	#$C0,d0
		beq.w	loc_105C8
		cmpi.b	#$80,d0
		beq.w	loc_10754
		andi.b	#$38,d1
		bne.s	loc_10514
		addq.w	#8,d2

loc_10514:
		cmpi.b	#$40,d0
		beq.w	loc_10822
		bra.w	loc_10694
; ---------------------------------------------------------------------------

sub_10520:
		move.b	d0,(v_angle_primary).w
		move.b	d0,(v_angle_secondary).w
		addi.b	#$20,d0
		andi.b	#$C0,d0
		cmpi.b	#$40,d0
		beq.w	loc_107AE
		cmpi.b	#$80,d0
		beq.w	Sonic_NoRunningOnWalls
		cmpi.b	#$C0,d0
		beq.w	loc_10628

Sonic_HitFloor:
		move.w	obY(a0),d2
		move.w	obX(a0),d3
		moveq	#0,d0
		move.b	obHeight(a0),d0
		ext.w	d0
		add.w	d0,d2
		move.b	obWidth(a0),d0
		ext.w	d0
		add.w	d0,d3
		lea	(v_angle_primary).w,a4
		movea.w	#$10,a3
		move.w	#0,d6
		moveq	#$D,d5
		bsr.w	sub_101BE
		move.w	d1,-(sp)
		move.w	obY(a0),d2
		move.w	obX(a0),d3
		moveq	#0,d0
		move.b	obHeight(a0),d0
		ext.w	d0
		add.w	d0,d2
		move.b	obWidth(a0),d0
		ext.w	d0
		sub.w	d0,d3
		lea	(v_angle_secondary).w,a4
		movea.w	#$10,a3
		move.w	#0,d6
		moveq	#$D,d5
		bsr.w	sub_101BE
		move.w	(sp)+,d0
		move.b	#0,d2

loc_105A8:
		move.b	(v_angle_secondary).w,d3
		cmp.w	d0,d1
		ble.s	loc_105B6
		move.b	(v_angle_primary).w,d3
		move.w	d0,d1

loc_105B6:
		btst	#0,d3
		beq.s	locret_105BE
		move.b	d2,d3

locret_105BE:
		rts
; ---------------------------------------------------------------------------
		move.w	obY(a0),d2
		move.w	obX(a0),d3

loc_105C8:
		addi.w	#$A,d2
		lea	(v_angle_primary).w,a4
		movea.w	#$10,a3
		move.w	#0,d6
		moveq	#$E,d5
		bsr.w	sub_101BE
		move.b	#0,d2

loc_105E2:
		move.b	(v_angle_primary).w,d3
		btst	#0,d3
		beq.s	locret_105EE
		move.b	d2,d3

locret_105EE:
		rts
; ---------------------------------------------------------------------------

ObjectHitFloor:
		move.w	obX(a0),d3

ObjectHitFloor2:
		move.w	obY(a0),d2
		moveq	#0,d0
		move.b	obHeight(a0),d0
		ext.w	d0
		add.w	d0,d2
		lea	(v_angle_primary).w,a4
		move.b	#0,(a4)
		movea.w	#$10,a3
		move.w	#0,d6
		moveq	#$D,d5
		bsr.w	sub_101BE
		move.b	(v_angle_primary).w,d3
		btst	#0,d3
		beq.s	locret_10626
		move.b	#0,d3

locret_10626:
		rts
; ---------------------------------------------------------------------------

loc_10628:
		move.w	obY(a0),d2
		move.w	obX(a0),d3
		moveq	#0,d0
		move.b	obWidth(a0),d0
		ext.w	d0
		sub.w	d0,d2
		move.b	obHeight(a0),d0
		ext.w	d0
		add.w	d0,d3
		lea	(v_angle_primary).w,a4
		movea.w	#$10,a3
		move.w	#0,d6
		moveq	#$E,d5
		bsr.w	FindFloor
		move.w	d1,-(sp)
		move.w	obY(a0),d2
		move.w	obX(a0),d3
		moveq	#0,d0
		move.b	obWidth(a0),d0
		ext.w	d0
		add.w	d0,d2
		move.b	obHeight(a0),d0
		ext.w	d0
		add.w	d0,d3
		lea	(v_angle_secondary).w,a4
		movea.w	#$10,a3
		move.w	#0,d6
		moveq	#$E,d5
		bsr.w	FindFloor
		move.w	(sp)+,d0
		move.b	#$C0,d2
		bra.w	loc_105A8
; ---------------------------------------------------------------------------

sub_1068C:
		move.w	obY(a0),d2
		move.w	obX(a0),d3

loc_10694:
		addi.w	#$A,d3
		lea	(v_angle_primary).w,a4
		movea.w	#$10,a3
		move.w	#0,d6
		moveq	#$E,d5
		bsr.w	FindFloor
		move.b	#$C0,d2
		bra.w	loc_105E2
; ---------------------------------------------------------------------------

ObjectHitWallRight:
		add.w	obX(a0),d3
		move.w	obY(a0),d2
		lea	(v_angle_primary).w,a4
		move.b	#0,(a4)
		movea.w	#$10,a3
		move.w	#0,d6
		moveq	#$E,d5
		bsr.w	FindFloor
		move.b	(v_angle_primary).w,d3
		btst	#0,d3
		beq.s	locret_106DE
		move.b	#$C0,d3

locret_106DE:
		rts
; ---------------------------------------------------------------------------

Sonic_NoRunningOnWalls:
		move.w	obY(a0),d2
		move.w	obX(a0),d3
		moveq	#0,d0
		move.b	obHeight(a0),d0
		ext.w	d0
		sub.w	d0,d2
		eori.w	#$F,d2
		move.b	obWidth(a0),d0
		ext.w	d0
		add.w	d0,d3
		lea	(v_angle_primary).w,a4
		movea.w	#-$10,a3
		move.w	#$1000,d6
		moveq	#$E,d5
		bsr.w	sub_101BE
		move.w	d1,-(sp)
		move.w	obY(a0),d2
		move.w	obX(a0),d3
		moveq	#0,d0
		move.b	obHeight(a0),d0
		ext.w	d0
		sub.w	d0,d2
		eori.w	#$F,d2
		move.b	obWidth(a0),d0
		ext.w	d0
		sub.w	d0,d3
		lea	(v_angle_secondary).w,a4
		movea.w	#-$10,a3
		move.w	#$1000,d6
		moveq	#$E,d5
		bsr.w	sub_101BE
		move.w	(sp)+,d0
		move.b	#$80,d2
		bra.w	loc_105A8
; ---------------------------------------------------------------------------
		move.w	obY(a0),d2
		move.w	obX(a0),d3

loc_10754:
		subi.w	#$A,d2
		eori.w	#$F,d2
		lea	(v_angle_primary).w,a4
		movea.w	#-$10,a3
		move.w	#$1000,d6
		moveq	#$E,d5
		bsr.w	sub_101BE
		move.b	#$80,d2
		bra.w	loc_105E2
; ---------------------------------------------------------------------------

ObjectHitCeiling:
		move.w	obY(a0),d2
		move.w	obX(a0),d3
		moveq	#0,d0
		move.b	obHeight(a0),d0
		ext.w	d0
		sub.w	d0,d2
		eori.w	#$F,d2
		lea	(v_angle_primary).w,a4
		movea.w	#-$10,a3
		move.w	#$1000,d6
		moveq	#$E,d5
		bsr.w	sub_101BE
		move.b	(v_angle_primary).w,d3
		btst	#0,d3
		beq.s	locret_107AC
		move.b	#$80,d3

locret_107AC:
		rts
; ---------------------------------------------------------------------------

loc_107AE:
		move.w	obY(a0),d2
		move.w	obX(a0),d3
		moveq	#0,d0
		move.b	obWidth(a0),d0
		ext.w	d0
		sub.w	d0,d2
		move.b	obHeight(a0),d0
		ext.w	d0
		sub.w	d0,d3
		eori.w	#$F,d3
		lea	(v_angle_primary).w,a4
		movea.w	#-$10,a3
		move.w	#$800,d6
		moveq	#$E,d5
		bsr.w	FindFloor
		move.w	d1,-(sp)
		move.w	obY(a0),d2
		move.w	obX(a0),d3
		moveq	#0,d0
		move.b	obWidth(a0),d0
		ext.w	d0
		add.w	d0,d2
		move.b	obHeight(a0),d0
		ext.w	d0
		sub.w	d0,d3
		eori.w	#$F,d3
		lea	(v_angle_secondary).w,a4
		movea.w	#-$10,a3
		move.w	#$800,d6
		moveq	#$E,d5
		bsr.w	FindFloor
		move.w	(sp)+,d0
		move.b	#$40,d2
		bra.w	loc_105A8
; ---------------------------------------------------------------------------

Sonic_HitWall:
		move.w	obY(a0),d2
		move.w	obX(a0),d3

loc_10822:
		subi.w	#$A,d3
		eori.w	#$F,d3
		lea	(v_angle_primary).w,a4
		movea.w	#-$10,a3
		move.w	#$800,d6
		moveq	#$E,d5
		bsr.w	FindFloor
		move.b	#$40,d2
		bra.w	loc_105E2
; ---------------------------------------------------------------------------

ObjectHitWallLeft:
		add.w	obX(a0),d3
		move.w	obY(a0),d2
		lea	(v_angle_primary).w,a4
		move.b	#0,(a4)
		movea.w	#-$10,a3
		move.w	#$800,d6
		moveq	#$E,d5
		bsr.w	FindFloor
		move.b	(v_angle_primary).w,d3
		btst	#0,d3
		beq.s	locret_10870
		move.b	#$40,d3

locret_10870:
		rts
; ---------------------------------------------------------------------------

Special_ShowLayout:
		bsr.w	Special_AniWallsandRings
		bsr.w	Special_AniItems
		move.w	d5,-(sp)
		lea	(v_ssbuffer3).w,a1
		move.b	(v_ssangle).w,d0
		andi.b	#$FC,d0
		jsr	(CalcSine).l
		move.w	d0,d4
		move.w	d1,d5
		muls.w	#$18,d4
		muls.w	#$18,d5
		moveq	#0,d2
		move.w	(v_screenposx).w,d2
		divu.w	#$18,d2
		swap	d2
		neg.w	d2
		addi.w	#-$B4,d2
		moveq	#0,d3
		move.w	(v_screenposy).w,d3
		divu.w	#$18,d3
		swap	d3
		neg.w	d3
		addi.w	#-$B4,d3
		move.w	#$10-1,d7

loc_108C2:
		movem.w	d0-d2,-(sp)
		movem.w	d0-d1,-(sp)
		neg.w	d0
		muls.w	d2,d1
		muls.w	d3,d0
		move.l	d0,d6
		add.l	d1,d6
		movem.w	(sp)+,d0-d1
		muls.w	d2,d0
		muls.w	d3,d1
		add.l	d0,d1
		move.l	d6,d2
		move.w	#$10-1,d6

loc_108E4:
		move.l	d2,d0
		asr.l	#8,d0
		move.w	d0,(a1)+
		move.l	d1,d0
		asr.l	#8,d0
		move.w	d0,(a1)+
		add.l	d5,d2
		add.l	d4,d1
		dbf	d6,loc_108E4

		movem.w	(sp)+,d0-d2
		addi.w	#$18,d3
		dbf	d7,loc_108C2

		move.w	(sp)+,d5
		lea	(v_ssbuffer1).l,a0
		moveq	#0,d0
		move.w	(v_screenposy).w,d0
		divu.w	#$18,d0
		mulu.w	#$80,d0
		adda.l	d0,a0
		moveq	#0,d0
		move.w	(v_screenposx).w,d0
		divu.w	#$18,d0
		adda.w	d0,a0
		lea	(v_ssbuffer3).w,a4
		move.w	#$10-1,d7

loc_10930:
		move.w	#$10-1,d6

loc_10934:
		moveq	#0,d0
		move.b	(a0)+,d0
		beq.s	loc_10986
		move.w	(a4),d3
		addi.w	#$120,d3
		cmpi.w	#$70,d3
		bcs.s	loc_10986
		cmpi.w	#$1D0,d3
		bhs.s	loc_10986
		move.w	2(a4),d2
		addi.w	#$F0,d2
		cmpi.w	#$70,d2
		bcs.s	loc_10986
		cmpi.w	#$170,d2
		bhs.s	loc_10986
		lea	(v_ssbuffer2).l,a5
		lsl.w	#3,d0
		lea	(a5,d0.w),a5
		movea.l	(a5)+,a1
		move.w	(a5)+,d1
		add.w	d1,d1
		adda.w	(a1,d1.w),a1
		movea.w	(a5)+,a3
		moveq	#0,d1
		move.b	(a1)+,d1
		subq.b	#1,d1
		bmi.s	loc_10986
		jsr	(sub_88AA).l

loc_10986:
		addq.w	#4,a4
		dbf	d6,loc_10934

		lea	$70(a0),a0
		dbf	d7,loc_10930

		move.b	d5,(v_spritecount).w
		cmpi.b	#$50,d5
		beq.s	loc_109A6
		move.l	#0,(a2)
		rts
; ---------------------------------------------------------------------------

loc_109A6:
		move.b	#0,-5(a2)
		rts
; ---------------------------------------------------------------------------

Special_AniWallsandRings:
		lea	(v_ssblocktypes+$C).l,a1
		moveq	#0,d0
		move.b	(v_ssangle).w,d0
		lsr.b	#2,d0
		andi.w	#$F,d0
		moveq	#$F,d1

loc_109C2:
		move.w	d0,(a1)
		addq.w	#8,a1
		dbf	d1,loc_109C2

		subq.b	#1,(v_ani1_time).w
		bpl.s	loc_109E0
		move.b	#7,(v_ani1_time).w
		addq.b	#1,(v_ani1_frame).w
		andi.b	#3,(v_ani1_frame).w

loc_109E0:
		move.b	(v_ani1_frame).w,1(a1)
		addq.w	#8,a1
		addq.w	#8,a1
		subq.b	#1,(v_ani2_time).w
		bpl.s	loc_10A02
		move.b	#7,(v_ani2_time).w
		bra.s	loc_10A02
; ---------------------------------------------------------------------------
		addq.b	#1,(v_ani2_frame).w		; the GOAL blocks were meant to flash yellow
		andi.b	#1,(v_ani2_frame).w

loc_10A02:
		move.b	(v_ani2_frame).w,1(a1)
		addq.w	#8,a1
		move.b	(v_ani2_frame).w,1(a1)
		subq.b	#1,(v_ani0_time).w
		bpl.s	loc_10A26
		move.b	#7,(v_ani0_time).w
		subq.b	#1,(v_ani0_frame).w
		andi.b	#3,(v_ani0_frame).w

loc_10A26:
		lea	(v_ssblocktypes+$2E).l,a1
		lea	(SS_WaRiVramSet).l,a0
		moveq	#0,d0
		move.b	(v_ani0_frame).w,d0
		add.w	d0,d0
		lea	(a0,d0.w),a0
		move.w	(a0),(a1)
		move.w	2(a0),8(a1)
		move.w	4(a0),$10(a1)
		move.w	6(a0),$18(a1)
		adda.w	#$10,a0
		adda.w	#$20,a1
		move.w	(a0),(a1)
		move.w	2(a0),8(a1)
		move.w	4(a0),$10(a1)
		move.w	6(a0),$18(a1)
		adda.w	#$10,a0
		adda.w	#$20,a1
		move.w	(a0),(a1)
		move.w	2(a0),8(a1)
		move.w	4(a0),$10(a1)
		move.w	6(a0),$18(a1)
		rts
; ---------------------------------------------------------------------------

SS_WaRiVramSet:	dc.w $142, $142, $142, $2142
		dc.w $142, $142, $142, $142
		dc.w $2142, $2142, $2142, $142
		dc.w $2142, $2142, $2142, $2142
		dc.w $4142, $4142, $4142, $2142
		dc.w $4142, $4142, $4142, $4142
		dc.w $6142, $6142, $6142, $2142
		dc.w $6142, $6142, $6142, $6142
		even
; ---------------------------------------------------------------------------

sub_10ACC:
		lea	(v_ssitembuffer).l,a2
		move.w	#bytesToXcnt(v_ssitembuffer_end-v_ssitembuffer,8),d0

loc_10AD6:
		tst.b	(a2)
		beq.s	locret_10AE0
		addq.w	#8,a2
		dbf	d0,loc_10AD6

locret_10AE0:
		rts
; ---------------------------------------------------------------------------

Special_AniItems:
		lea	(v_ssitembuffer).l,a0
		move.w	#bytesToXcnt(v_ssitembuffer_end-v_ssitembuffer,8),d7

loc_10AEC:
		moveq	#0,d0
		move.b	(a0),d0
		beq.s	loc_10AFA
		lsl.w	#2,d0
		movea.l	SS_AniIndex-4(pc,d0.w),a1
		jsr	(a1)

loc_10AFA:
		addq.w	#8,a0

loc_10AFC:
		dbf	d7,loc_10AEC
		rts
; ---------------------------------------------------------------------------
SS_AniIndex:	dc.l SS_AniRingSparks
		dc.l SS_AniBumper
; ---------------------------------------------------------------------------

SS_AniRingSparks:
		subq.b	#1,2(a0)
		bpl.s	locret_10B32
		move.b	#5,2(a0)
		moveq	#0,d0
		move.b	3(a0),d0
		addq.b	#1,3(a0)
		movea.l	4(a0),a1
		move.b	byte_10B34(pc,d0.w),d0
		move.b	d0,(a1)
		bne.s	locret_10B32
		clr.l	(a0)
		clr.l	4(a0)

locret_10B32:
		rts
; ---------------------------------------------------------------------------

byte_10B34:	dc.b $17, $18, $19, $1A, 0, 0
		even
; ---------------------------------------------------------------------------

SS_AniBumper:
		subq.b	#1,2(a0)
		bpl.s	locret_10B68
		move.b	#7,2(a0)
		moveq	#0,d0
		move.b	3(a0),d0
		addq.b	#1,3(a0)
		movea.l	4(a0),a1
		move.b	byte_10B6A(pc,d0.w),d0
		bne.s	loc_10B66
		clr.l	(a0)
		clr.l	4(a0)
		move.b	#$12,(a1)
		rts
; ---------------------------------------------------------------------------

loc_10B66:
		move.b	d0,(a1)

locret_10B68:
		rts
; ---------------------------------------------------------------------------
byte_10B6A:	dc.b $1B, $1C, $1B, $1C, 0, 0
		even
; ---------------------------------------------------------------------------

SS_Load:
		lea	(v_ssbuffer1).l,a1
		move.w	#bytesToLcnt(v_ssbuffer2-v_ssbuffer1),d0

loc_10B7A:
		clr.l	(a1)+
		dbf	d0,loc_10B7A

		lea	(v_sslayout).l,a1
		lea	(SS_1).l,a0
		moveq	#$24-1,d1

loc_10B8E:
		moveq	#bytesToLcnt($24),d2

loc_10B90:
		move.l	(a0)+,(a1)+
		dbf	d2,loc_10B90

		lea	$5C(a1),a1
		dbf	d1,loc_10B8E

		lea	(v_ssblocktypes+8).l,a1
		lea	(SS_MapIndex).l,a0
		moveq	#bytesToXcnt(SS_MapIndex_End-SS_MapIndex,6),d1

loc_10BAC:
		move.l	(a0)+,(a1)+
		move.w	#0,(a1)+
		move.b	-4(a0),-1(a1)
		move.w	(a0)+,(a1)+
		dbf	d1,loc_10BAC

		lea	(v_ssitembuffer).l,a1
		move.w	#bytesToLcnt(v_ssitembuffer_end-v_ssitembuffer),d1

loc_10BC8:

		clr.l	(a1)+
		dbf	d1,loc_10BC8

		rts
; ---------------------------------------------------------------------------

		include "_inc/Special Stage Mappings & VRAM Pointers.asm"

;sub_10C98:
		lea	(v_ssblockbuffer).l,a1
		lea	(SS_1).l,a0
		moveq	#$40-1,d1

loc_10CA6:
		moveq	#bytesToLcnt($40),d2

loc_10CA8:
		move.l	(a0)+,(a1)+
		dbf	d2,loc_10CA8
		lea	$40(a1),a1
		dbf	d1,loc_10CA6
		rts

		include "_incObj/09 Sonic in Special Stage.asm"
		include "_incObj/10 Sonic Animation Test.asm"

		include "_inc/AnimateLevelGfx.asm"

		include "_incObj/21 HUD.asm"
Map_HUD:	include "_maps/HUD.asm"
; ---------------------------------------------------------------------------

ScoreAdd:
		move.b	#1,(f_scorecount).w
		lea	(v_scorecopy).w,a2
		lea	(v_score).w,a3
		add.l	d0,(a3)
		move.l	#999999,d1
		cmp.l	(a3),d1
		bhi.w	loc_1166E
		move.l	d1,(a3)
		move.l	d1,(a2)

loc_1166E:
		move.l	(a3),d0
		cmp.l	(a2),d0
		bcs.w	locret_11678
		move.l	d0,(a2)

locret_11678:
		rts
; ---------------------------------------------------------------------------
; Subroutine to	update the HUD
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||

hudVRAM:	macro loc
		move.l	#($40000000+((loc&$3FFF)<<16)+((loc&$C000)>>14)),d0
		endm


UpdateHUD:
		tst.w	(f_debugmode).w
		bne.w	loc_11746
		tst.b	(f_scorecount).w
		beq.s	loc_1169A
		clr.b	(f_scorecount).w
		hudVRAM $DC80
		move.l	(v_score).w,d1
		bsr.w	sub_1187E

loc_1169A:
		tst.b	(f_extralife).w
		beq.s	loc_116BA
		bpl.s	loc_116A6
		bsr.w	sub_117B2

loc_116A6:
		clr.b	(f_extralife).w
		hudVRAM $DF40
		moveq	#0,d1
		move.w	(v_rings).w,d1
		bsr.w	sub_11874

loc_116BA:
		tst.b	(f_timecount).w
		beq.s	loc_1170E
		tst.w	(f_pause).w
		bmi.s	loc_1170E
		lea	(v_score).w,a1
		addq.b	#1,-(a1)
		cmpi.b	#60,(a1)
		bcs.s	loc_1170E
		move.b	#0,(a1)
		addq.b	#1,-(a1)
		cmpi.b	#60,(a1)
		bcs.s	loc_116EE
		move.b	#0,(a1)
		addq.b	#1,-(a1)
		cmpi.b	#9,(a1)
		bcs.s	loc_116EE
		move.b	#9,(a1)

loc_116EE:
		hudVRAM $DE40
		moveq	#0,d1
		move.b	(v_timemin).w,d1
		bsr.w	sub_118F4
		hudVRAM $DEC0
		moveq	#0,d1
		move.b	(v_timesec).w,d1
		bsr.w	sub_118FE

loc_1170E:
		tst.b	(f_lifecount).w
		beq.s	loc_1171C
		clr.b	(f_lifecount).w
		bsr.w	sub_119BA

loc_1171C:
		tst.b	(f_endactbonus).w
		beq.s	locret_11744
		clr.b	(f_endactbonus).w
		locVRAM $AE00
		moveq	#0,d1
		move.w	(v_timebonus).w,d1
		bsr.w	sub_11958
		moveq	#0,d1
		move.w	(v_ringbonus).w,d1
		bsr.w	sub_11958

locret_11744:
		rts
; ---------------------------------------------------------------------------

loc_11746:
		bsr.w	sub_1181E
		tst.b	(f_extralife).w
		beq.s	loc_1176A
		bpl.s	loc_11756
		bsr.w	sub_117B2

loc_11756:
		clr.b	(f_extralife).w
		hudVRAM $DF40
		moveq	#0,d1
		move.w	(v_rings).w,d1
		bsr.w	sub_11874

loc_1176A:
		hudVRAM $DEC0
		moveq	#0,d1
		move.b	(v_spritecount).w,d1
		bsr.w	sub_118FE
		tst.b	(f_lifecount).w
		beq.s	loc_11788
		clr.b	(f_lifecount).w
		bsr.w	sub_119BA

loc_11788:
		tst.b	(f_endactbonus).w
		beq.s	locret_117B0
		clr.b	(f_endactbonus).w
		locVRAM $AE00
		moveq	#0,d1
		move.w	(v_timebonus).w,d1
		bsr.w	sub_11958
		moveq	#0,d1
		move.w	(v_ringbonus).w,d1
		bsr.w	sub_11958

locret_117B0:
		rts
; ---------------------------------------------------------------------------

sub_117B2:
		locVRAM $DF40
		lea	byte_1181A(pc),a2
		move.w	#2,d2
		bra.s	loc_117E2
; ---------------------------------------------------------------------------

sub_117C6:
		lea	(vdp_data_port).l,a6
		bsr.w	sub_119BA
		locVRAM $DC40
		lea	byte_1180E(pc),a2
		move.w	#$E,d2

loc_117E2:
		lea	byte_11A26(pc),a1

loc_117E6:
		move.w	#$F,d1
		move.b	(a2)+,d0
		bmi.s	loc_11802
		ext.w	d0
		lsl.w	#5,d0
		lea	(a1,d0.w),a3

loc_117F6:
		move.l	(a3)+,(a6)
		dbf	d1,loc_117F6

loc_117FC:
		dbf	d2,loc_117E6
		rts
; ---------------------------------------------------------------------------

loc_11802:
		move.l	#0,(a6)
		dbf	d1,loc_11802
		bra.s	loc_117FC
; ---------------------------------------------------------------------------

byte_1180E:	dc.b $16, $FF, $FF, $FF, $FF, $FF, $FF, 0, 0, $14, 0, 0
		even
byte_1181A:	dc.b $FF, $FF, 0, 0
		even
; ---------------------------------------------------------------------------

sub_1181E:
		locVRAM $DC40
		move.w	(v_screenposx).w,d1
		swap	d1
		move.w	(v_player+obX).w,d1
		bsr.s	sub_1183E
		move.w	(v_screenposy).w,d1
		swap	d1
		move.w	(v_player+obY).w,d1

sub_1183E:
		moveq	#7,d6
		lea	(Art_Text).l,a1

loc_11846:
		rol.w	#4,d1
		move.w	d1,d2
		andi.w	#$F,d2
		cmpi.w	#$A,d2
		bcs.s	loc_11856
		addq.w	#7,d2

loc_11856:
		lsl.w	#5,d2
		lea	(a1,d2.w),a3
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		swap	d1
		dbf	d6,loc_11846
		rts
; ---------------------------------------------------------------------------

sub_11874:
		lea	(Hud_100).l,a2
		moveq	#2,d6
		bra.s	loc_11886
; ---------------------------------------------------------------------------

sub_1187E:
		lea	(Hud_100000).l,a2
		moveq	#5,d6

loc_11886:
		moveq	#0,d4
		lea	byte_11A26(pc),a1

loc_1188C:
		moveq	#0,d2
		move.l	(a2)+,d3

loc_11890:
		sub.l	d3,d1
		bcs.s	loc_11898
		addq.w	#1,d2
		bra.s	loc_11890
; ---------------------------------------------------------------------------

loc_11898:
		add.l	d3,d1
		tst.w	d2
		beq.s	loc_118A2
		move.w	#1,d4

loc_118A2:
		tst.w	d4
		beq.s	loc_118D0
		lsl.w	#6,d2
		move.l	d0,4(a6)
		lea	(a1,d2.w),a3
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)

loc_118D0:
		addi.l	#$400000,d0
		dbf	d6,loc_1188C
		rts
; ---------------------------------------------------------------------------

Hud_100000:	dc.l 100000
Hud_10000:	dc.l 10000
Hud_1000:	dc.l 1000
Hud_100:	dc.l 100
Hud_10:		dc.l 10
Hud_1:		dc.l 1
; ---------------------------------------------------------------------------

sub_118F4:
		lea	(Hud_1).l,a2
		moveq	#0,d6
		bra.s	loc_11906
; ---------------------------------------------------------------------------

sub_118FE:
		lea	(Hud_10).l,a2
		moveq	#1,d6

loc_11906:
		moveq	#0,d4
		lea	byte_11A26(pc),a1

loc_1190C:
		moveq	#0,d2
		move.l	(a2)+,d3

loc_11910:
		sub.l	d3,d1
		bcs.s	loc_11918
		addq.w	#1,d2
		bra.s	loc_11910
; ---------------------------------------------------------------------------

loc_11918:
		add.l	d3,d1
		tst.w	d2
		beq.s	loc_11922
		move.w	#1,d4

loc_11922:
		lsl.w	#6,d2
		move.l	d0,4(a6)
		lea	(a1,d2.w),a3
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		addi.l	#$400000,d0
		dbf	d6,loc_1190C
		rts
; ---------------------------------------------------------------------------

sub_11958:
		lea	(Hud_1000).l,a2
		moveq	#3,d6
		moveq	#0,d4
		lea	byte_11A26(pc),a1

loc_11966:
		moveq	#0,d2
		move.l	(a2)+,d3

loc_1196A:
		sub.l	d3,d1
		bcs.s	loc_11972
		addq.w	#1,d2
		bra.s	loc_1196A
; ---------------------------------------------------------------------------

loc_11972:
		add.l	d3,d1
		tst.w	d2
		beq.s	loc_1197C
		move.w	#1,d4

loc_1197C:
		tst.w	d4
		beq.s	loc_119AC
		lsl.w	#6,d2
		lea	(a1,d2.w),a3
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)

loc_119A6:
		dbf	d6,loc_11966
		rts
; ---------------------------------------------------------------------------

loc_119AC:
		moveq	#$F,d5

loc_119AE:
		move.l	#0,(a6)
		dbf	d5,loc_119AE
		bra.s	loc_119A6
; ---------------------------------------------------------------------------

sub_119BA:
		hudVRAM $FBA0
		moveq	#0,d1
		move.b	(v_lives).w,d1
		lea	(Hud_10).l,a2
		moveq	#1,d6
		moveq	#0,d4
		lea	byte_11D26(pc),a1

loc_119D4:
		move.l	d0,4(a6)
		moveq	#0,d2
		move.l	(a2)+,d3

loc_119DC:
		sub.l	d3,d1
		bcs.s	loc_119E4
		addq.w	#1,d2
		bra.s	loc_119DC
; ---------------------------------------------------------------------------

loc_119E4:
		add.l	d3,d1
		tst.w	d2
		beq.s	loc_119EE
		move.w	#1,d4

loc_119EE:
		tst.w	d4
		beq.s	loc_11A14

loc_119F2:
		lsl.w	#5,d2
		lea	(a1,d2.w),a3
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)

loc_11A08:
		addi.l	#$400000,d0
		dbf	d6,loc_119D4
		rts
; ---------------------------------------------------------------------------

loc_11A14:
		tst.w	d6
		beq.s	loc_119F2
		moveq	#7,d5

loc_11A1A:
		move.l	#0,(a6)
		dbf	d5,loc_11A1A
		bra.s	loc_11A08
; ---------------------------------------------------------------------------

byte_11A26:	binclude "artunc/HUD Numbers.bin"
		even
byte_11D26:	binclude "artunc/Lives Counter Numbers.bin"
		even

		include "_incObj/DebugMode.asm"
		include "_inc/DebugList.asm"
		include "_inc/LevelHeaders.asm"
		include "_inc/Pattern Load Cues.asm"

		align $8000				; Padding
; ===========================================================================
; Unused 8x8 Font Art
; ===========================================================================
;byte_18000:
		binclude "leftovers/8x8 Compressed Font.bin"	; Some similar art to this is used in other prototypes, such as Sonic 2 Nick Arcade
		even
; ===========================================================================
; Sega Screen/Title Screen Art and Mappings
; ===========================================================================
Nem_SegaLogo:	binclude "artnem/Sega Logo.nem"
		even
Eni_SegaLogo:	binclude "tilemaps/Sega Logo.bin"
		even
Unc_Title:	binclude "tilemaps/Title Screen.bin"
		even
Nem_TitleFg:	binclude "artnem/Title Screen Foreground.nem"
		even
Nem_TitleSonic:	binclude "artnem/Title Screen Sonic.nem"
		even
Map_Sonic:	include "_maps/Sonic.asm"
SonicDynPLC:	include "_maps/Sonic - Dynamic Gfx Script.asm"

; ---------------------------------------------------------------------------
; Uncompressed graphics	- Sonic
; ---------------------------------------------------------------------------
Art_Sonic:	binclude "artunc/Sonic.bin"
		even
; ---------------------------------------------------------------------------
; Compressed graphics - various
; ---------------------------------------------------------------------------
Nem_Smoke:	binclude "artnem/Smoke.nem"
		even
Nem_Shield:	binclude "artnem/Shield.nem"
		even
Nem_Stars:	binclude "artnem/Stars.nem"
		even
Nem_Flash:	binclude "artnem/Flash.nem"
		even
;Nem_Goggles:
		binclude "artnem/Unused - Goggles.nem"
		even

		align $400				; Padding

; ---------------------------------------------------------------------------
; Compressed graphics - GHZ stuff
; ---------------------------------------------------------------------------
byte_27400:	binclude "artnem/ghz flower stalk.nem"
		even
byte_2744A:	binclude "artnem/GHZ Swinging Platform.nem"
		even
ArtBridge:	binclude "artnem/GHZ Bridge.nem"
		even
byte_27698:	binclude "artnem/GHZ Giant Ball.nem"
		even
ArtSpikes:	binclude "artnem/Spikes.nem"
		even
ArtSpikeLogs:	binclude "artnem/GHZ Spiked Log.nem"
		even
ArtPurpleRock:	binclude "artnem/GHZ Purple Rock.nem"
		even
ArtSmashWall:	binclude "artnem/GHZ Breakable Wall.nem"
		even
ArtWall:	binclude "artnem/GHZ Edge Wall.nem"
		even
; ---------------------------------------------------------------------------
; Compressed graphics - MZ stuff
; ---------------------------------------------------------------------------
ArtChainPtfm:	binclude "artnem/MZ Metal Blocks.nem"
		even
ArtButtonMZ:	binclude "artnem/MZ Switch.nem"
		even
byte_2816E:	binclude "artnem/MZ Green Glass Block.nem"
		even
		binclude "artnem/Unused - Grass.nem"
		even
byte_2827A:	binclude "artnem/Fireballs.nem"
		even
byte_28558:	binclude "artnem/mz lava.nem"
		even
byte_28E6E:	binclude "artnem/MZ Green Pushable Block.nem"
		even
		binclude "artnem/Unused - MZ Background.nem"
		even
; ---------------------------------------------------------------------------
; Compressed graphics - SLZ stuff
; ---------------------------------------------------------------------------
ArtSeesaw:	binclude "artnem/SLZ Seesaw.nem"
		even
ArtFan:		binclude "artnem/SLZ Fan.nem"
		even
byte_294DA:	binclude "artnem/SLZ Breakable Wall.nem"
		even
byte_2953C:	binclude "artnem/slz girders.nem"
		even
byte_2961E:	binclude "artnem/SLZ Swinging Platform.nem"
		even
Nem_SLZ_Platfm:	binclude "artnem/SLZ Platforms.nem"
		even
byte_29D4A:	binclude "artnem/slz metal block.nem"
		even
; ---------------------------------------------------------------------------
; Compressed graphics - SZ stuff
; ---------------------------------------------------------------------------
ArtBumper:	binclude "artnem/SZ Bumper.nem"
		even
byte_29FC0:	binclude "artnem/SZ Small Spikeball.nem"
		even
ArtButton:	binclude "artnem/Switch.nem"
		even
byte_2A104:	binclude "artnem/SZ Large Spikeball.nem"
		even
; ---------------------------------------------------------------------------
; Compressed graphics - enemies
; ---------------------------------------------------------------------------
;Nem_BallHog:
		binclude "artnem/Unused - Enemy Ball Hog.nem"
		even
Nem_Crabmeat:	binclude "artnem/Enemy Crabmeat.nem"
		even
Nem_Buzzbomber:	binclude "artnem/Enemy Buzz Bomber.nem"
		even
;Nem_Ball_Explosion:
		binclude "artnem/Unused - Ball Hog's Bomb Explosion.nem"
		even
Nem_Burrobot:	binclude "artnem/Enemy Burrobot.nem"
		even
ArtChopper:	binclude "artnem/Enemy Chopper.nem"
		even
Nem_Jaws:	binclude "artnem/Enemy Jaws.nem"
		even
;Nem_BallBomb:
		binclude "artnem/Unused - Ball Hog's Bomb.nem"
		even
Nem_Roller:	binclude "artnem/Enemy Roller.nem"
		even
ArtMotobug:	binclude "artnem/Enemy Motobug.nem"
		even
ArtNewtron:	binclude "artnem/Enemy Newtron.nem"
		even
ArtYardin:	binclude "artnem/Enemy Yadrin.nem"
		even
ArtBasaran:	binclude "artnem/Enemy Basaran.nem"
		even
ArtSplats:	binclude "artnem/Enemy Splats.nem"
		even
; ---------------------------------------------------------------------------
; Compressed graphics - various
; ---------------------------------------------------------------------------
Nem_TitleCard:	binclude "artnem/Title Cards.nem"
		even
Nem_HUD:	binclude "artnem/HUD.nem"
		even
Nem_Lives:	binclude "artnem/HUD - Life Counter Icon.nem"
		even
Nem_Rings:	binclude "artnem/Rings.nem"
		even
Nem_Monitors:	binclude "artnem/Monitors.nem"
		even
ArtExplosions:	binclude "artnem/Explosion.nem"
		even
byte_2E6C8:	binclude "artnem/score points.nem"
		even
ArtGameOver:	binclude "artnem/Game Over.nem"
		even
ArtSpringHoriz:	binclude "artnem/Spring Horizontal.nem"
		even
ArtSpringVerti:	binclude "artnem/Spring Vertical.nem"
		even
ArtSignPost:	binclude "artnem/Signpost.nem"
		even
; ---------------------------------------------------------------------------
; Compressed graphics - animals
; ---------------------------------------------------------------------------
ArtAnimalPocky:	binclude "artnem/Animal Rabbit.nem"
		even
ArtAnimalCucky:	binclude "artnem/Animal Chicken.nem"
		even
ArtAnimalPecky:	binclude "artnem/Animal Blackbird.nem"
		even
ArtAnimalRocky:	binclude "artnem/Animal Seal.nem"
		even
ArtAnimalPicky:	binclude "artnem/Animal Pig.nem"
		even
ArtAnimalFlicky:binclude "artnem/Animal Flicky.nem"
		even
ArtAnimalRicky:	binclude "artnem/Animal Squirrel.nem"
		even

		align $1000				; Padding
; ---------------------------------------------------------------------------
; Compressed graphics - primary patterns
; Blocks are Uncompressed
; ---------------------------------------------------------------------------
Blk16_GHZ:	binclude "map16/GHZ.bin"
		even
Nem_GHZ_1st:	binclude "artnem/8x8 - GHZ1.nem"
		even
Nem_GHZ_2nd:	binclude "artnem/8x8 - GHZ2.nem"
		even
Blk256_GHZ:	binclude "map256/GHZ.kos"
		even
Blk16_LZ:	binclude "map16/LZ.bin"
		even
Nem_LZ:		binclude "artnem/8x8 - LZ.nem"
		even
Blk256_LZ:	binclude "map256/LZ.kos"
		even
Blk16_MZ:	binclude "map16/MZ.bin"
		even
Nem_MZ:		binclude "artnem/8x8 - MZ.nem"
		even
Blk256_MZ:	binclude "map256/MZ.kos"
		even
;0x3DA48
; end chunk data
		dc.w $F0, 0, 0, 0, 0, 0, 0, 0
;0x3DA58
		binclude "leftovers/map256/Chunk Data.kos"
		even
;0x3DB78
		binclude "unknown/3DB78.dat"
		even
Blk16_SLZ:	binclude "map16/SLZ.bin"
		even
Nem_SLZ:	binclude "artnem/8x8 - SLZ.nem"
		even
Blk256_SLZ:	binclude "map256/SLZ.kos"
		even
Blk16_SZ:	binclude "map16/SZ.bin"
		even
Nem_SZ:		binclude "artnem/8x8 - SZ.nem"
		even
Blk256_SZ:	binclude "map256/SZ.kos"
		even
Blk16_CWZ:	binclude "map16/CWZ.bin"
		even
Nem_CWZ:	binclude "artnem/8x8 - CWZ.nem"
		even
Blk256_CWZ:	binclude "map256/CWZ.kos"
		even
;0x570DC
; duplicate cut-off chunk data from CWZ
		dc.w $FFF8, $FCAA, $AAFF, $F8FC, $FFF8, $FCFF, $F8FC, $FFF8
		dc.w $FC00, $F001, $FFF8, $FCFF, $F8FC, $FFF8, $FC02, $FF
		dc.w $F89F, $F0, 0, 0, 0, 0, 0, 0
; and a duplicate of a duplicate end of chunk data pointer
		dc.w $F89F, $F0, 0, 0, 0, 0, 0, 0
		
;0x5711C
		binclude "unknown/5711C.dat"
		even
; ---------------------------------------------------------------------------
; Compressed graphics - bosses and ending sequence
; ---------------------------------------------------------------------------
byte_60000:	binclude "artnem/Boss - Main.nem"
		even
byte_60864:	binclude "artnem/Boss - Weapons.nem"
		even
byte_60BB0:	binclude "artnem/Prison Capsule.nem"
		even
; ===========================================================================
; Demos
; ===========================================================================
byte_61434:	binclude "demodata/Intro - GHZ.bin"	; Green Hill's demo (act 2?)
		even
byte_614C6:	binclude "demodata/Intro - MZ.bin"	; Marble's demo
		even
byte_61578:	binclude "demodata/Intro - SZ.bin"	; Sparkling's demo (?)
		even
byte_6161E:	binclude "demodata/Intro - Special Stage.bin" ; Special stage demo
		even

		align $3000				; Padding

		include "_maps/SS Walls.asm"

; ---------------------------------------------------------------------------
; Compressed graphics - special stage
; ---------------------------------------------------------------------------
ArtSpecialBlocks:binclude "artnem/Art Blocks.nem"
		even
byte_639B8:	binclude "tilemaps/SS Background 1.bin"
		even
ArtSpecialAnimals:binclude "artnem/Special Birds & Fish.nem"
		even
byte_6477C:	binclude "tilemaps/SS Background 2.bin"
		even
byte_64A7C:	binclude "artnem/ss bg misc.nem"
		even
ArtSpecialGoal:	binclude "artnem/Special GOAL.nem"
		even
ArtSpecialR:	binclude "artnem/Special R.nem"
		even
ArtSpecialSkull:binclude "artnem/Special Skull.nem"
		even
ArtSpecialU:	binclude "artnem/Special U.nem"
		even
ArtSpecial1up:	binclude "artnem/Special 1UP.nem"
		even
ArtSpecialStars:binclude "artnem/Art Stars.nem"
		even
byte_65432:	binclude "artnem/ss red white.nem"
		even
ArtSpecialZone1:binclude "artnem/Special ZONE1.nem"
		even
ArtSpecialZone2:binclude "artnem/Special ZONE2.nem"
		even
ArtSpecialZone3:binclude "artnem/Special ZONE3.nem"
		even
ArtSpecialZone4:binclude "artnem/Special ZONE4.nem"
		even
ArtSpecialZone5:binclude "artnem/Special ZONE5.nem"
		even
ArtSpecialZone6:binclude "artnem/Special ZONE6.nem"
		even
ArtSpecialUpDown:binclude "artnem/Special UP-DOWN.nem"
		even
ArtSpecialEmerald:binclude "artnem/Special Emeralds.nem"
		even

		align $4000				; Padding
; ---------------------------------------------------------------------------
; Collision data
; ---------------------------------------------------------------------------
colAngles:	binclude "collide/Angle Map.bin"
		even
colWidth:	binclude "collide/Collision Array (Normal).bin"
		even
colHeight:	binclude "collide/Collision Array (Rotated).bin"
		even
colGHZ:		binclude "collide/GHZ.bin"
		even
colLZ:		binclude "collide/LZ.bin"
		even
colMZ:		binclude "collide/MZ.bin"
		even
colSLZ:		binclude "collide/SLZ.bin"
		even
colSZ:		binclude "collide/SZ.bin"
		even
colCWZ:		binclude "collide/CWZ.bin"
		even
; ---------------------------------------------------------------------------
; Special Stage layout (uncompressed)
; ---------------------------------------------------------------------------
SS_1:		binclude "sslayout/1.bin"
SS_1_End:	even
; ---------------------------------------------------------------------------
; Animated uncompressed graphics
; ---------------------------------------------------------------------------
Art_GhzWater:	binclude "artunc/GHZ Waterfall.bin"
		even
Art_GhzFlower1:	binclude "artunc/GHZ Flower Large.bin"
		even
Art_GhzFlower2:	binclude "artunc/GHZ Flower Small.bin"
		even
Art_MzLava1:	binclude "artunc/MZ Lava Surface.bin"
		even
Art_MzLava2:	binclude "artunc/MZ Lava.bin"
		even
Art_MzSaturns:	binclude "artunc/MZ Saturns.bin"
		even
Art_MzTorch:	binclude "artunc/MZ Background torch.bin"
		even

; ---------------------------------------------------------------------------
; Level	layout index
; ---------------------------------------------------------------------------
LayoutArray:	; GHZ
		dc.w LayoutGHZ1FG-LayoutArray, LayoutGHZ1BG-LayoutArray, byte_6CE54-LayoutArray
		dc.w LayoutGHZ2FG-LayoutArray, LayoutGHZ2BG-LayoutArray, byte_6CF3C-LayoutArray
		dc.w LayoutGHZ3FG-LayoutArray, LayoutGHZ3BG-LayoutArray, byte_6D084-LayoutArray
		dc.w byte_6D088-LayoutArray, byte_6D088-LayoutArray, byte_6D088-LayoutArray
		; LZ
		dc.w LayoutLZ1FG-LayoutArray, LayoutLZBG-LayoutArray, byte_6D190-LayoutArray
		dc.w LayoutLZ2FG-LayoutArray, LayoutLZBG-LayoutArray, byte_6D216-LayoutArray
		dc.w LayoutLZ3FG-LayoutArray, LayoutLZBG-LayoutArray, byte_6D31C-LayoutArray
		dc.w byte_6D320-LayoutArray, byte_6D320-LayoutArray, byte_6D320-LayoutArray
		; MZ
		dc.w LayoutMZ1FG-LayoutArray, LayoutMZ1BG-LayoutArray, LayoutMZ1FG-LayoutArray
		dc.w LayoutMZ2FG-LayoutArray, LayoutMZ2BG-LayoutArray, byte_6D614-LayoutArray
		dc.w LayoutMZ3FG-LayoutArray, LayoutMZ3BG-LayoutArray, byte_6D7DC-LayoutArray
		dc.w byte_6D7E0-LayoutArray, byte_6D7E0-LayoutArray, byte_6D7E0-LayoutArray
		; SLZ
		dc.w LayoutSLZ1FG-LayoutArray, LayoutSLZBG-LayoutArray, byte_6DBE4-LayoutArray
		dc.w LayoutSLZ2FG-LayoutArray, LayoutSLZBG-LayoutArray, byte_6DBE4-LayoutArray
		dc.w LayoutSLZ3FG-LayoutArray, LayoutSLZBG-LayoutArray, byte_6DBE4-LayoutArray
		dc.w byte_6DBE4-LayoutArray, byte_6DBE4-LayoutArray, byte_6DBE4-LayoutArray
		; SZ
		dc.w LayoutSZ1FG-LayoutArray, LayoutSZBG-LayoutArray, byte_6DCD8-LayoutArray
		dc.w LayoutSZ2FG-LayoutArray, LayoutSZBG-LayoutArray, byte_6DDDA-LayoutArray
		dc.w LayoutSZ3FG-LayoutArray, LayoutSZBG-LayoutArray, byte_6DF30-LayoutArray
		dc.w byte_6DF34-LayoutArray, byte_6DF34-LayoutArray, byte_6DF34-LayoutArray
		; CWZ
		dc.w LayoutCWZ1-LayoutArray, LayoutCWZ2-LayoutArray, LayoutCWZ2-LayoutArray
		dc.w LayoutCWZ2-LayoutArray, byte_6E33C-LayoutArray, byte_6E33C-LayoutArray
		dc.w LayoutCWZ3-LayoutArray, LayoutCWZ3-LayoutArray, LayoutCWZ3-LayoutArray
		dc.w byte_6E344-LayoutArray, byte_6E344-LayoutArray, byte_6E344-LayoutArray
		; Ending
		dc.w LayoutTest-LayoutArray, byte_6E3CA-LayoutArray, byte_6E3CA-LayoutArray
		dc.w byte_6E3CE-LayoutArray, byte_6E3CE-LayoutArray, byte_6E3CE-LayoutArray
		dc.w byte_6E3D2-LayoutArray, byte_6E3D2-LayoutArray, byte_6E3D2-LayoutArray
		dc.w byte_6E3D6-LayoutArray, byte_6E3D6-LayoutArray, byte_6E3D6-LayoutArray

LayoutGHZ1FG:	binclude "levels/ghz1.bin"
		even
LayoutGHZ1BG:	binclude "levels/ghzbg1.bin"
		even

byte_6CE54:	dc.l 0
LayoutGHZ2FG:	binclude "levels/ghz2.bin"
		even
LayoutGHZ2BG:	binclude "levels/ghzbg2.bin"
		even

byte_6CF3C:	dc.l 0
LayoutGHZ3FG:	binclude "levels/ghz3.bin"
		even
LayoutGHZ3BG:	binclude "levels/ghzbg3.bin"
		even

byte_6D084:	dc.l 0
byte_6D088:	dc.l 0
LayoutLZ1FG:	binclude "levels/lz1.bin"
		even
LayoutLZBG:	binclude "levels/lzbg.bin"
		even

byte_6D190:	dc.l 0
LayoutLZ2FG:	binclude "levels/lz2.bin"
		even

byte_6D216:	dc.l 0
LayoutLZ3FG:	binclude "levels/lz3.bin"
		even

byte_6D31C:	dc.l 0
byte_6D320:	dc.l 0
LayoutMZ1FG:	binclude "levels/mz1.bin"
		even
LayoutMZ1BG:	binclude "levels/mzbg1.bin"
		even
LayoutMZ2FG:	binclude "levels/mz2.bin"
		even
LayoutMZ2BG:	binclude "levels/mzbg2.bin"
		even

byte_6D614:	dc.l 0
LayoutMZ3FG:	binclude "levels/mz3.bin"
		even
LayoutMZ3BG:	binclude "levels/mzbg3.bin"
		even

byte_6D7DC:	dc.l 0
byte_6D7E0:	dc.l 0
LayoutSLZ1FG:	binclude "levels/slz1.bin"
		even
LayoutSLZBG:	binclude "levels/slzbg.bin"
		even
LayoutSLZ2FG:	binclude "levels/slz2.bin"
		even
LayoutSLZ3FG:	binclude "levels/slz3.bin"
		even

byte_6DBE4:	dc.l 0
LayoutSZ1FG:	binclude "levels/sz1.bin"
		even
LayoutSZBG:	binclude "levels/szbg.bin"
		even

byte_6DCD8:	dc.l 0
LayoutSZ2FG:	binclude "levels/sz2.bin"
		even

byte_6DDDA:	dc.l 0
LayoutSZ3FG:	binclude "levels/sz3.bin"
		even

byte_6DF30:	dc.l 0
byte_6DF34:	dc.l 0
LayoutCWZ1:	binclude "levels/cwz1.bin"
		even
LayoutCWZ2:	binclude "levels/cwz2.bin"
		even
byte_6E33C:	binclude "levels/cwz2bg.bin"
		even
LayoutCWZ3:	binclude "levels/cwz3.bin"
		even

byte_6E344:	dc.l 0
LayoutTest:	binclude "leftovers/levels/test.bin"		; Seems to be a test layout
		even

byte_6E3CA:	dc.l 0
byte_6E3CE:	dc.l 0
byte_6E3D2:	dc.l 0
byte_6E3D6:	dc.l 0

		align $2000				; Padding
; ===========================================================================
; Object Layout Index
; ===========================================================================
ObjPos_Index:	; GHZ
		dc.w ObjPos_GHZ1-ObjPos_Index, ObjPos_Null-ObjPos_Index
		dc.w ObjPos_GHZ2-ObjPos_Index, ObjPos_Null-ObjPos_Index
		dc.w ObjPos_GHZ3-ObjPos_Index, ObjPos_Null-ObjPos_Index
		dc.w ObjPos_GHZ1-ObjPos_Index, ObjPos_Null-ObjPos_Index
		; LZ
		dc.w ObjPos_LZ1-ObjPos_Index, ObjPos_Null-ObjPos_Index
		dc.w ObjPos_LZ2-ObjPos_Index, ObjPos_Null-ObjPos_Index
		dc.w ObjPos_LZ3-ObjPos_Index, ObjPos_Null-ObjPos_Index
		dc.w ObjPos_LZ1-ObjPos_Index, ObjPos_Null-ObjPos_Index
		; MZ
		dc.w ObjPos_MZ1-ObjPos_Index, ObjPos_Null-ObjPos_Index
		dc.w ObjPos_MZ2-ObjPos_Index, ObjPos_Null-ObjPos_Index
		dc.w ObjPos_MZ3-ObjPos_Index, ObjPos_Null-ObjPos_Index
		dc.w ObjPos_MZ1-ObjPos_Index, ObjPos_Null-ObjPos_Index
		; SLZ
		dc.w ObjPos_SLZ1-ObjPos_Index, ObjPos_Null-ObjPos_Index
		dc.w ObjPos_SLZ2-ObjPos_Index, ObjPos_Null-ObjPos_Index
		dc.w ObjPos_SLZ3-ObjPos_Index, ObjPos_Null-ObjPos_Index
		dc.w ObjPos_SLZ1-ObjPos_Index, ObjPos_Null-ObjPos_Index
		; SZ
		dc.w ObjPos_SZ1-ObjPos_Index, ObjPos_Null-ObjPos_Index
		dc.w ObjPos_SZ2-ObjPos_Index, ObjPos_Null-ObjPos_Index
		dc.w ObjPos_SZ3-ObjPos_Index, ObjPos_Null-ObjPos_Index
		dc.w ObjPos_SZ1-ObjPos_Index, ObjPos_Null-ObjPos_Index
		; CWZ
		dc.w ObjPos_CWZ1-ObjPos_Index, ObjPos_Null-ObjPos_Index
		dc.w ObjPos_CWZ2-ObjPos_Index, ObjPos_Null-ObjPos_Index
		dc.w ObjPos_CWZ3-ObjPos_Index, ObjPos_Null-ObjPos_Index
		dc.w ObjPos_CWZ1-ObjPos_Index, ObjPos_Null-ObjPos_Index
		dc.w $FFFF, 0, 0

ObjPos_GHZ1:	binclude "objpos/ghz1.bin"
		even
ObjPos_GHZ2:	binclude "objpos/ghz2.bin"
		even
ObjPos_GHZ3:	binclude "objpos/ghz3.bin"
		even
ObjPos_LZ1:	binclude "objpos/lz1.bin"
		even
ObjPos_LZ2:	binclude "objpos/lz2.bin"
		even
ObjPos_LZ3:	binclude "objpos/lz3.bin"
		even
ObjPos_MZ1:	binclude "objpos/mz1.bin"
		even
ObjPos_MZ2:	binclude "objpos/mz2.bin"
		even
ObjPos_MZ3:	binclude "objpos/mz3.bin"
		even
ObjPos_SLZ1:	binclude "objpos/slz1.bin"
		even
ObjPos_SLZ2:	binclude "objpos/slz2.bin"
		even
ObjPos_SLZ3:	binclude "objpos/slz3.bin"
		even
ObjPos_SZ1:	binclude "objpos/sz1.bin"
		even
ObjPos_SZ2:	binclude "objpos/sz2.bin"
		even
;0x729CA
		binclude "leftovers/levels/sz1.bin"		; Leftover from earlier builds
		even
ObjPos_SZ3:	binclude "objpos/sz3.bin"
		even
ObjPos_CWZ1:	binclude "objpos/cwz1.bin"
		even
ObjPos_CWZ2:	binclude "objpos/cwz2.bin"
		even
ObjPos_CWZ3:	binclude "objpos/cwz3.bin"
		even

ObjPos_Null:	dc.w $FFFF, 0, 0

		align $2000				; Padding

		include "s1.sounddriver.asm"

		cnop -1,2<<lastbit(*-1)
		dc.b $FF

EndOfROM:

	END
