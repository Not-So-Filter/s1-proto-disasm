; +------------------------------------------------------+
; | Sonic the Hedgehog (Prototype)                       |
; | Split/Text Disassembly.                              |
; | Originally done by Mega Drive Developers Collective. |
; +------------------------------------------------------+

; Processor: Motorola 68000 (M68K)
; Sound Processor: Zilog Z80 (Z80)
; Intended for tab width of 8

; ---------------------------------------------------------------------------

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
Date:		dc.b "(C)SEGA 1989.JAN"			; Copyright holder and release date (generally year)
Title_Local:	dc.b "                                                " ; Domestic name (blank)
Title_Int:	dc.b "                                                " ; International name (blank)
Serial:		dc.b "GM 00000000-00"			; Serial\version number
Checksum:	dc.w 0					; Checksum
		dc.b "J               "			; I\O support
RomStartLoc:	dc.l StartOfROM				; Start address of ROM
RomEndLoc:      dc.l EndOfROM-1				; End address of ROM
RamStartLoc:	dc.l $FF0000				; Start address of RAM
RamEndLoc:      dc.l $FFFFFF				; End address of RAM
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
		moveq	#$17,d1

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
		moveq	#$27,d2

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
		moveq	#$1F,d3

loc_278:
		move.l	d0,(a3)
		dbf	d3,loc_278
		move.l	#$40000010,(a4)
		moveq	#$13,d4

loc_286:
		move.l	d0,(a3)
		dbf	d4,loc_286
		moveq	#3,d5

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

		; Z80 initalization
		dc.b $AF				; xor	a
		dc.b $01,$D7,$1F			; ld	bc,1FD7h
		dc.b $11,$29,$00			; ld	de,29h
		dc.b $21,$28,$00			; ld	hl,28h
		dc.b $F9				; ld	sp,hl
		dc.b $77				; ld	(hl),a
		dc.b $ED,$B0				; ldir
		dc.b $DD,$E1				; pop	ix
		dc.b $FD,$E1				; pop	iy
		dc.b $ED,$47				; ld	i,a
		dc.b $ED,$4F				; ld	r,a
		dc.b $08				; ex	af,af'
		dc.b $D9				; exx
		dc.b $F1				; pop	af
		dc.b $C1				; pop	bc
		dc.b $D1				; pop	de
		dc.b $E1				; pop	hl
		dc.b $08				; ex	af,af'
		dc.b $D9				; exx
		dc.b $F1				; pop	af
		dc.b $D1				; pop	de
		dc.b $E1				; pop	hl
		dc.b $F9				; ld	sp,hl
		dc.b $F3				; di
		dc.b $ED,$56				; im	1
		dc.b $36,$E9				; ld	(hl),0E9h
		dc.b $E9				; jp	(hl)

		dc.b $9F,$BF,$DF,$FF			; values for PSG channel volumes
; ---------------------------------------------------------------------------

loc_306:
		btst	#6,(z80_expansion_control+1).l
		beq.s	DoChecksum
		cmpi.l	#'init',(ChecksumStr).w
		beq.w	loc_36A

DoChecksum:
		movea.l	#EndOfHeader,a0
		movea.l	#RomEndLoc,a1
		move.l	(a1),d0
		moveq	#0,d1

loc_32C:
		add.w	(a0)+,d1
		cmp.l	a0,d0
		bcc.s	loc_32C
		movea.l	#Checksum,a1
		cmp.w	(a1),d1
		nop
		nop
		lea	(v_systemstack).w,a6
		moveq	#0,d7
		move.w	#$7F,d6

loc_348:
		move.l	d7,(a6)+
		dbf	d6,loc_348
		move.b	(z80_version).l,d0
		andi.b	#$C0,d0
		move.b	d0,(v_megadrive).w
		move.w	#1,(word_FFFFE0).w
		move.l	#'init',(ChecksumStr).w

loc_36A:
		lea	($FF0000).l,a6
		moveq	#0,d7
		move.w	#$3F7F,d6

loc_376:
		move.l	d7,(a6)+
		dbf	d6,loc_376
		bsr.w	vdpInit
		bsr.w	SoundDriverLoad
		bsr.w	padInit
		move.b	#0,(v_gamemode).w

ScreensLoop:
		move.b	(v_gamemode).w,d0
		andi.w	#$1C,d0
		jsr	ScreensArray(pc,d0.w)
		bra.s	ScreensLoop
; ---------------------------------------------------------------------------

ScreensArray:
		bra.w	GM_Sega
; ---------------------------------------------------------------------------
		bra.w	GM_Title
; ---------------------------------------------------------------------------
		bra.w	GM_Level
; ---------------------------------------------------------------------------
		bra.w	GM_Level
; ---------------------------------------------------------------------------
		bra.w	GM_Special
; ---------------------------------------------------------------------------
		rts
; ---------------------------------------------------------------------------

; Unused, as the checksum check doesn't care if the checksum is wrong.
ChecksumError:
		bsr.w	vdpInit
		move.l	#$C0000000,(vdp_control_port).l	; Set VDP to CRAM write
		moveq	#$3F,d7

.palette:
		move.w	#$E,(vdp_data_port).l		; Write red to data
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
		movem.l	d0-a7,(v_regbuffer).w
		bsr.w	ErrorPrint
		move.l	2(sp),d0
		bsr.w	ErrorPrintAddr
		move.l	(v_spbuffer).w,d0
		bsr.w	ErrorPrintAddr
		bra.s	loc_472
; ---------------------------------------------------------------------------

ErrorNormal:
		disable_ints
		movem.l	d0-a7,(v_regbuffer).w
		bsr.w	ErrorPrint
		move.l	2(sp),d0
		bsr.w	ErrorPrintAddr

loc_472:
		bsr.w	ErrorWaitInput
		movem.l	(v_regbuffer).w,d0-a7
		enable_ints
		rte
; ---------------------------------------------------------------------------

ErrorPrint:
		lea	(vdp_data_port).l,a6
		locVRAM	$F800
		lea	(ArtText).l,a0
		move.w	#$27F,d1

.loadart:
		move.w	(a0)+,(a6)
		dbf	d1,.loadart
		moveq	#0,d0
		move.b	(v_errortype).w,d0
		move.w	ErrorText(pc,d0.w),d0
		lea	ErrorText(pc,d0.w),a0
		locVRAM (vram_fg+$604)
		moveq	#$12,d1

.loadtext:
		moveq	#0,d0
		move.b	(a0)+,d0
		addi.w	#$790,d0
		move.w	d0,(a6)
		dbf	d1,.loadtext
		rts
; ---------------------------------------------------------------------------

ErrorText:	dc.w .exception-ErrorText
                dc.w .bus-ErrorText
		dc.w .address-ErrorText
                dc.w .illinstruct-ErrorText
		dc.w .zerodivide-ErrorText
                dc.w .chkinstruct-ErrorText
		dc.w .trapv-ErrorText
                dc.w .privilege-ErrorText
		dc.w .trace-ErrorText
                dc.w .line1010-ErrorText
		dc.w .line1111-ErrorText
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
		moveq	#7,d2

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
		cmpi.b	#$20,(v_jpadpress1).w
		bne.w	ErrorWaitInput
		rts
; ---------------------------------------------------------------------------
ArtText:	incbin "artunc\menutext.bin"
		even
; ---------------------------------------------------------------------------

VBlank:
		movem.l	d0-a6,-(sp)
		tst.b	(VBlankRoutine).w
		beq.s	loc_B58
		move.w	(vdp_control_port).l,d0
		move.l	#$40000010,(vdp_control_port).l
		move.l	(v_scrposy_dup).w,(vdp_data_port).l
		btst	#6,(v_megadrive).w
		beq.s	loc_B3C
		move.w	#$700,d0
		dbf	d0,*

loc_B3C:
		move.b	(VBlankRoutine).w,d0
		move.b	#0,(VBlankRoutine).w
		move.w	#1,(word_FFF648).w
		andi.w	#$3E,d0
		move.w	VBla_Index(pc,d0.w),d0
		jsr	VBla_Index(pc,d0.w)

loc_B58:
		addq.l	#1,(unk_FFFE0C).w
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
		beq.w	.locret
		subq.w	#1,(v_demolength).w

.locret:
		rts
; ---------------------------------------------------------------------------

VBla_04:
		bsr.w	sub_E78
		bsr.w	sub_43B6
		bsr.w	sub_1438
		tst.w	(v_demolength).w
		beq.w	.locret
		subq.w	#1,(v_demolength).w

.locret:
		rts
; ---------------------------------------------------------------------------

VBla_06:
		bsr.w	sub_E78
		rts
; ---------------------------------------------------------------------------

VBla_10:
		cmpi.b	#$10,(v_gamemode).w
		beq.w	VBla_0A

VBla_08:
		bsr.w	ReadJoypads
		stopZ80
		waitZ80
		writeCRAM       v_pal_dry,$80,0
		writeVRAM	v_hscrolltablebuffer,$380,vram_hscroll
		move.w	#$8407,(a5)
		move.w	(v_hbla_hreg).w,(a5)
		move.w	(word_FFF61E).w,(word_FFF622).w
		writeVRAM	v_spritetablebuffer,$280,vram_sprites
		tst.b	(f_sonframechg).w
		beq.s	loc_C7A
		writeVRAM	v_sgfx_buffer,$2E0,vram_sonic ; load new Sonic gfx
		move.b	#0,(f_sonframechg).w

loc_C7A:
		startZ80
		bsr.w	mapLevelLoad
		jsr	(AnimateLevelGfx).l
		jsr	(UpdateHUD).l
		bsr.w	loc_1454
		moveq	#0,d0
		move.b	(byte_FFF628).w,d0
		move.b	(byte_FFF629).w,d1
		cmp.b	d0,d1
		bcc.s	loc_CA8
		move.b	d0,(byte_FFF629).w

loc_CA8:
		move.b	#0,(byte_FFF628).w
		tst.w	(v_demolength).w
		beq.w	.locret
		subq.w	#1,(v_demolength).w

.locret:
		rts
; ---------------------------------------------------------------------------

VBla_0A:
		bsr.w	ReadJoypads
		stopZ80
		waitZ80
		writeCRAM       v_pal_dry,$80,0
		writeVRAM	v_spritetablebuffer,$280,vram_sprites
		writeVRAM	v_hscrolltablebuffer,$380,vram_hscroll
		startZ80
		bsr.w	SS_PalCycle
		tst.b	(f_sonframechg).w
		beq.s	loc_D7A
		writeVRAM	v_sgfx_buffer,$2E0,vram_sonic ; load new Sonic gfx
		move.b	#0,(f_sonframechg).w

loc_D7A:
		tst.w	(v_demolength).w
		beq.w	.locret
		subq.w	#1,(v_demolength).w

.locret:
		rts
; ---------------------------------------------------------------------------

VBla_0C:
		bsr.w	ReadJoypads
		stopZ80
		waitZ80
		writeCRAM       v_pal_dry,$80,0
		writeVRAM	v_spritetablebuffer,$280,vram_sprites
		writeVRAM	v_hscrolltablebuffer,$380,vram_hscroll
		tst.b	(f_sonframechg).w
		beq.s	loc_E3A
		writeVRAM	v_sgfx_buffer,$2E0,vram_sonic ; load new Sonic gfx
		move.b	#0,(f_sonframechg).w

loc_E3A:
		startZ80
		bsr.w	mapLevelLoad
		jsr	(AnimateLevelGfx).l
		jsr	(UpdateHUD).l
		bsr.w	sub_1438
		rts
; ---------------------------------------------------------------------------

VBla_0E:
		bsr.w	sub_E78
		bsr.w	RunObjects
		bsr.w	ProcessMaps
		addq.b	#1,(byte_FFF628).w
		move.b	#$E,(VBlankRoutine).w
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
		writeCRAM       v_pal_dry,$80,0
		writeVRAM	v_spritetablebuffer,$280,vram_sprites
		writeVRAM	v_hscrolltablebuffer,$380,vram_hscroll
		startZ80
		rts
; ---------------------------------------------------------------------------

HBlank:
		tst.w	(word_FFF648).w
		beq.s	.locret
		move.l	a5,-(sp)
		writeCRAM       v_pal_dry_dup,$80,0
		movem.l	(sp)+,a5
		move.w	#0,(word_FFF648).w

.locret:
		rte
; ---------------------------------------------------------------------------

sub_F3C:
		tst.w	(word_FFF648).w
		beq.s	locret_F7E
		movem.l	d0/a0/a5,-(sp)
		move.w	#0,(word_FFF648).w
		move.w	#$8405,(vdp_control_port).l
		move.w	#$857C,(vdp_control_port).l
		locVRAM $F800
		lea	(v_spritetablebuffer).w,a0
		lea	(vdp_data_port).l,a5
		move.w	#$9F,d0

.loop:
		move.l	(a0)+,(a5)
		dbf	d0,.loop
		movem.l	(sp)+,d0/a0/a5

locret_F7E:
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

vdpInit:
		lea	(vdp_control_port).l,a0
		lea	(vdp_data_port).l,a1
		lea	(vdpInitRegs).l,a2
		moveq	#$12,d7

loc_101E:
		move.w	(a2)+,(a0)
		dbf	d7,loc_101E
		move.w	(vdpInitRegs+2).l,d0
		move.w	d0,(v_vdp_buffer1).w
		moveq	#0,d0
		move.l	#$C0000000,(vdp_control_port).l
		move.w	#$3F,d7

loc_103E:
		move.w	d0,(a1)
		dbf	d7,loc_103E
		clr.l	(v_scrposy_dup).w
		clr.l	(v_scrposx_dup).w
		move.l	d1,-(sp)
		fillVRAM	0,$FFFF,0

loc_1070:
		move.w	(a5),d1
		btst	#1,d1
		bne.s	loc_1070
		move.w	#$8F02,(a5)
		move.l	(sp)+,d1
		rts
; ---------------------------------------------------------------------------

vdpInitRegs:	dc.w $8004
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
; ---------------------------------------------------------------------------

ClearScreen:
		fillVRAM	0,$FFF,vram_fg		; clear foreground namespace

.waitDMA1:
		move.w	(a5),d1
		btst	#1,d1
		bne.s	.waitDMA1
		move.w	#$8F02,(a5)
		fillVRAM	0,$FFF,vram_bg		; clear background namespace

.waitDMA2:
		move.w	(a5),d1
		btst	#1,d1
		bne.s	.waitDMA2
		move.w	#$8F02,(a5)
		move.l	#0,(v_scrposy_dup).w
		move.l	#0,(v_scrposx_dup).w
		lea	(v_spritetablebuffer).w,a1
		moveq	#0,d0
		move.w	#($280/4),d1			; This should be ($280/4)-1

loc_111C:
		move.l	d0,(a1)+
		dbf	d1,loc_111C
		lea	(v_hscrolltablebuffer).w,a1
		moveq	#0,d0
		move.w	#($400/4),d1			; This should be ($400/4)-1, leading to a slight bug (first bit of the Sonic object's RAM is cleared)

loc_112C:
		move.l	d0,(a1)+
		dbf	d1,loc_112C
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
		lea	($A01FF8).l,a1			; Write something (?) to Z80
		move.b	d0,(a1)+
		move.b	#$80,(a1)+
		move.b	#7,(a1)+
		move.b	#$80,(a1)+
		move.b	d0,(a1)+
		move.b	d0,(a1)+
		move.b	d0,(a1)+
		move.b	d0,(a1)+
		resetZ80a
		nop
		nop
		nop
		nop
		resetZ80
		startZ80
		rts
; ---------------------------------------------------------------------------
;unk_119C:
		dc.b 3,0,0,$14,0,0,0,0
; ---------------------------------------------------------------------------

PlayMusic:
		move.b	d0,(v_snddriver_ram+v_soundqueue0).w
		rts
; ---------------------------------------------------------------------------

PlaySFX:
		move.b	d0,(v_snddriver_ram+v_soundqueue1).w
		rts
; ---------------------------------------------------------------------------
PlaySound_Unused:
		move.b	d0,(v_snddriver_ram+v_soundqueue2).w
		rts

                include "_inc\PauseGame.asm"
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

		include "_inc\Nemesis Decompression.asm"

; ---------------------------------------------------------------------------

plcAdd:
		movem.l	a1-a2,-(sp)
		lea	(ArtLoadCues).l,a1
		add.w	d0,d0
		move.w	(a1,d0.w),d0
		lea	(a1,d0.w),a1
		lea	(plcList).w,a2

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
; ---------------------------------------------------------------------------

plcReplace:
		movem.l	a1-a2,-(sp)
		lea	(ArtLoadCues).l,a1
		add.w	d0,d0
		move.w	(a1,d0.w),d0
		lea	(a1,d0.w),a1
		bsr.s	ClearPLC
		lea	(plcList).w,a2
		move.w	(a1)+,d0
		bmi.s	loc_13CE

loc_13C6:
		move.l	(a1)+,(a2)+
		move.w	(a1)+,(a2)+
		dbf	d0,loc_13C6

loc_13CE:
		movem.l	(sp)+,a1-a2
		rts
; ---------------------------------------------------------------------------

ClearPLC:
		lea	(plcList).w,a2
		moveq	#$1F,d0

loc_13DA:
		clr.l	(a2)+
		dbf	d0,loc_13DA
		rts
; ---------------------------------------------------------------------------

RunPLC:
		tst.l	(plcList).w
		beq.s	locret_1436
		tst.w	(unk_FFF6F8).w
		bne.s	locret_1436
		movea.l	(plcList).w,a0
		lea	(NemPCD_WriteRowToVDP).l,a3
		lea	(v_ngfx_buffer).w,a1
		move.w	(a0)+,d2
		bpl.s	loc_1404
		adda.w	#NemPCD_WriteRowToVDP_XOR-NemPCD_WriteRowToVDP,a3

loc_1404:
		andi.w	#$7FFF,d2
		move.w	d2,(unk_FFF6F8).w
		bsr.w	NemDec_BuildCodeTable
		move.b	(a0)+,d5
		asl.w	#8,d5
		move.b	(a0)+,d5
		moveq	#$10,d6
		moveq	#0,d0
		move.l	a0,(plcList).w
		move.l	a3,(unk_FFF6E0).w
		move.l	d0,(unk_FFF6E4).w
		move.l	d0,(unk_FFF6E8).w
		move.l	d0,(unk_FFF6EC).w
		move.l	d5,(unk_FFF6F0).w
		move.l	d6,(unk_FFF6F4).w

locret_1436:
		rts
; ---------------------------------------------------------------------------

sub_1438:
		tst.w	(unk_FFF6F8).w
		beq.w	locret_14D0
		move.w	#9,(unk_FFF6FA).w
		moveq	#0,d0
		move.w	(plcList+4).w,d0
		addi.w	#$120,(plcList+4).w
		bra.s	loc_146C
; ---------------------------------------------------------------------------

loc_1454:
		tst.w	(unk_FFF6F8).w
		beq.s	locret_14D0
		move.w	#3,(unk_FFF6FA).w
		moveq	#0,d0
		move.w	(plcList+4).w,d0
		addi.w	#$60,(plcList+4).w

loc_146C:
		lea	(vdp_control_port).l,a4
		lsl.l	#2,d0
		lsr.w	#2,d0
		ori.w	#$4000,d0
		swap	d0
		move.l	d0,(a4)
		subq.w	#4,a4
		movea.l	(plcList).w,a0
		movea.l	(unk_FFF6E0).w,a3
		move.l	(unk_FFF6E4).w,d0
		move.l	(unk_FFF6E8).w,d1
		move.l	(unk_FFF6EC).w,d2
		move.l	(unk_FFF6F0).w,d5
		move.l	(unk_FFF6F4).w,d6
		lea	(v_ngfx_buffer).w,a1

loc_14A0:
		movea.w	#8,a5
		bsr.w	NemPCD_NewRow
		subq.w	#1,(unk_FFF6F8).w
		beq.s	ShiftPLC
		subq.w	#1,(unk_FFF6FA).w
		bne.s	loc_14A0
		move.l	a0,(plcList).w

loc_14B8:
		move.l	a3,(unk_FFF6E0).w
		move.l	d0,(unk_FFF6E4).w
		move.l	d1,(unk_FFF6E8).w
		move.l	d2,(unk_FFF6EC).w
		move.l	d5,(unk_FFF6F0).w
		move.l	d6,(unk_FFF6F4).w

locret_14D0:
		rts
; ---------------------------------------------------------------------------

ShiftPLC:
		lea	(plcList).w,a0
		moveq	#$15,d0

loc_14D8:
		move.l	6(a0),(a0)+
		dbf	d0,loc_14D8
		rts
; ---------------------------------------------------------------------------

sub_14E2:
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

		include "_inc\Enigma Decompression.asm"
		include "_inc\Kosinski Decompression.asm"
                include "_inc\PaletteCycle.asm"

Cyc_Title:	incbin "palette\Cycle - Title.bin"
		even
Cyc_GHZ:	incbin "palette\Cycle - GHZ.bin"
		even
Cyc_LZ:	        incbin "palette\Cycle - LZ Unused.bin"
		even
Cyc_MZ:	        incbin "palette\Cycle - MZ Unused.bin"
		even
Cyc_SLZ:	incbin "palette\Cycle - SLZ.bin"
		even
Cyc_SZ1:	incbin "palette\Cycle - SZ1.bin"
		even
Cyc_SZ2:	incbin "palette\Cycle - SZ2.bin"
		even
; ---------------------------------------------------------------------------

PaletteWhiteIn:
		move.w	#$3F,(v_pfade_start).w
		moveq	#0,d0
		lea	(v_pal_dry).w,a0
		move.b	(v_pfade_start).w,d0
		adda.w	d0,a0
		moveq	#0,d1
		move.b	(v_pfade_size).w,d0

loc_1968:
		move.w	d1,(a0)+
		dbf	d0,loc_1968
		move.w	#$14,d4

loc_1972:
		move.b	#$12,(VBlankRoutine).w
		bsr.w	WaitForVBla
		bsr.s	sub_1988
		bsr.w	RunPLC
		dbf	d4,loc_1972
		rts
; ---------------------------------------------------------------------------

sub_1988:
		moveq	#0,d0
		lea	(v_pal_dry).w,a0
		lea	(v_pal_dry_dup).w,a1
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
		move.w	#$14,d4

loc_19DC:
		move.b	#$12,(VBlankRoutine).w
		bsr.w	WaitForVBla
		bsr.s	FadeOut_ToBlack
		bsr.w	RunPLC
		dbf	d4,loc_19DC
		rts
; ---------------------------------------------------------------------------

FadeOut_ToBlack:
		moveq	#0,d0
		lea	(v_pal_dry).w,a0
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
		subq.w	#1,(word_FFF634).w
		bpl.s	.locret
		move.w	#3,(word_FFF634).w
		move.w	(word_FFF632).w,d0
		bmi.s	.locret
		subq.w	#2,(word_FFF632).w
		lea	(Cyc_Sega).l,a0
		lea	(v_pal_dry+4).w,a1
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
Cyc_Sega:	incbin "palette\Cycle - Sega.bin"
		even
; ---------------------------------------------------------------------------

PalLoad1:
		lea	(PalPointers).l,a1
		lsl.w	#3,d0
		adda.w	d0,a1
		movea.l	(a1)+,a2
		movea.w	(a1)+,a3
		adda.w	#$80,a3
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

                include "_inc\Palette Pointers.asm"

Pal_SegaBG:	incbin "palette\Sega Screen.bin"
		even
Pal_Title:	incbin "palette\Title Screen.bin"
		even
Pal_LevelSel:	incbin "palette\Level Select.bin"
		even
Pal_Sonic:	incbin "palette\Sonic.bin"
		even
Pal_GHZ:	incbin "palette\Green Hill Zone.bin"
		even
Pal_LZ:		incbin "palette\Labyrinth Zone.bin"
		even
Pal_Ending:	incbin "palette\Ending.bin"
		even
Pal_MZ:		incbin "palette\Marble Zone.bin"
		even
Pal_SLZ:	incbin "palette\Star Light Zone.bin"
		even
Pal_SZ:		incbin "palette\Sparkling Zone.bin"
		even
Pal_CWZ:	incbin "palette\Clock Work Zone.bin"
		even
Pal_Special:	incbin "palette\Special Stage.bin"
		even

; ---------------------------------------------------------------------------

WaitForVBla:
		enable_ints

.wait:
		tst.b	(VBlankRoutine).w
		bne.s	.wait
		rts
; ---------------------------------------------------------------------------

RandomNumber:
		move.l	(RandomSeed).w,d1
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
		move.l	d1,(RandomSeed).w
		rts
; ---------------------------------------------------------------------------

GetSine:
		andi.w	#$FF,d0
		add.w	d0,d0
		addi.w	#$80,d0
		move.w	SineTable(pc,d0.w),d1
		subi.w	#$80,d0
		move.w	SineTable(pc,d0.w),d0
		rts
; ---------------------------------------------------------------------------
SineTable:	incbin "misc\sinetable.dat"
		even
; ---------------------------------------------------------------------------

GetSqrt:						; Leftover in the final game (REV00 only)
		movem.l	d1-d2,-(sp)
		move.w	d0,d1
		swap	d1
		moveq	#0,d0
		move.w	d0,d1
		moveq	#7,d2

loc_22F4:
		rol.l	#2,d1
		add.w	d0,d0
		addq.w	#1,d0
		sub.w	d0,d1
		bcc.s	loc_230E
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
		bcc.w	loc_2350
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
AngleTable:	incbin "misc\angles.bin"
		even
; ---------------------------------------------------------------------------

GM_Sega:
		move.b	#bgm_Fade,d0
		bsr.w	PlaySFX
		bsr.w	ClearPLC
		bsr.w	PaletteFadeOut
		lea	(vdp_control_port).l,a6
		move.w	#$8004,(a6)
		move.w	#$8230,(a6)
		move.w	#$8407,(a6)
		move.w	#$8700,(a6)
		move.w	#$8B00,(a6)
		move.w	v_vdp_buffer1.w,d0
		andi.b	#$BF,d0
		move.w	d0,(vdp_control_port).l

loc_24BC:
		bsr.w	ClearScreen
		locVRAM 0
		lea	(Nem_SegaLogo).l,a0
		bsr.w	NemDec
		lea	($FF0000).l,a1
		lea	(Eni_SegaLogo).l,a0
		move.w	#0,d0
		bsr.w	EniDec

		copyTilemap	$FF0000,$C61C,$B,3

		moveq	#0,d0
		bsr.w	PalLoad2
		move.w	#$28,(word_FFF632).w
		move.w	#0,(word_FFF662).w
		move.w	#0,(word_FFF660).w
		move.w	#$B4,(v_demolength).w
		move.w	(v_vdp_buffer1).w,d0
		ori.b	#$40,d0
		move.w	d0,(vdp_control_port).l

loc_2528:
		move.b	#2,(VBlankRoutine).w
		bsr.w	WaitForVBla
		bsr.w	PalCycSega
		tst.w	(v_demolength).w
		beq.s	loc_2544
		andi.b	#$80,v_jpadpress1.w
		beq.s	loc_2528

loc_2544:
		move.b	#4,(v_gamemode).w
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
		lea	(v_objspace).w,a1
		moveq	#0,d0
		move.w	#$7FF,d1

loc_2592:
		move.l	d0,(a1)+
		dbf	d1,loc_2592
		locVRAM $4000
		lea	(Nem_TitleFg).l,a0
		bsr.w	NemDec
		locVRAM $6000
		lea	(Nem_TitleSonic).l,a0
		bsr.w	NemDec
		lea	(vdp_data_port).l,a6
		locVRAM $D000,4(a6)
		lea	ArtText.l,a5
		move.w	#$28F,d1

loc_25D8:
		move.w	(a5)+,(a6)
		dbf	d1,loc_25D8
		lea	(Unc_Title).l,a1

                copyTilemapUnc	$C206,$21,$15

		move.w	#0,(DebugRoutine).w
		move.w	#0,(DemoMode).w
		move.w	#0,(v_zone).w
		bsr.w	LoadLevelBounds
		bsr.w	DeformLayers
		locVRAM 0
		lea	(Nem_GHZ_1st).l,a0
		bsr.w	NemDec
		lea	(Blk16_GHZ).l,a0
		lea	(v_16x16).w,a4
		move.w	#$5FF,d0

.loadblocks:
		move.l	(a0)+,(a4)+
		dbf	d0,.loadblocks
		lea	(Blk256_GHZ).l,a0
		lea	(v_256x256&$FFFFFF).l,a1
		bsr.w	KosDec
		bsr.w	LoadLayout
		lea	(vdp_control_port).l,a5
		lea	(vdp_data_port).l,a6
		lea	(v_bgscreenposx).w,a3
		lea	(v_lvllayout+$40).w,a4
		move.w	#$6000,d2
		bsr.w	sub_47B0
		moveq	#1,d0
		bsr.w	PalLoad1
		move.b	#bgm_Title,d0
		bsr.w	PlaySFX
		move.b	#0,(f_debugmode).w
		move.w	#$178,(v_demolength).w		; run title screen for $178 frames
		move.b	#$E,(v_objspace+$40).w		; load big sonic object
		move.b	#$F,(v_objspace+$80).w		; load press start button text
		move.b	#$F,(v_objspace+$C0).w		; load object which hides sonic
		move.b	#2,(v_objspace+$DA).w
		moveq	#plcid_Main,d0
		bsr.w	plcReplace
		move.w	(v_vdp_buffer1).w,d0
		ori.b	#$40,d0
		move.w	d0,(vdp_control_port).l
		bsr.w	PaletteWhiteIn

loc_26AE:
		move.b	#4,(VBlankRoutine).w
		bsr.w	WaitForVBla
		bsr.w	RunObjects
		bsr.w	DeformLayers
		bsr.w	ProcessMaps
		bsr.w	PalCycTitle
		bsr.w	RunPLC
		move.w	(v_objspace+8).w,d0
		addq.w	#2,d0				; set object scroll right speed
		move.w	d0,(v_objspace+8).w		; move sonic to the right
		cmpi.w	#$1C00,d0			; has object passed $1C00?
		bcs.s	loc_26E4			; if not, branch
		move.b	#0,(v_gamemode).w		; go to Sega Screen
		rts
; ---------------------------------------------------------------------------

loc_26E4:
		tst.w	(v_demolength).w
		beq.w	loc_27F8
		andi.b	#$80,(v_jpadpress1).w
		beq.w	loc_26AE
		btst	#6,(v_jpadhold1).w
		beq.w	loc_27AA
		moveq	#2,d0
		bsr.w	PalLoad2
		lea	(v_hscrolltablebuffer).w,a1
		moveq	#0,d0
		move.w	#$DF,d1

loc_2710:
		move.l	d0,(a1)+
		dbf	d1,loc_2710
		move.l	d0,(v_scrposy_dup).w
		disable_ints
		lea	(vdp_data_port).l,a6
		move.l	#$60000003,(vdp_control_port).l
		move.w	#$3FF,d1

loc_2732:
		move.l	d0,(a6)
		dbf	d1,loc_2732
		bsr.w	LevSelTextLoad

;loc_273C:
LevelSelect:
		move.b	#4,(VBlankRoutine).w
		bsr.w	WaitForVBla
		bsr.w	sub_28A6
		bsr.w	RunPLC
		tst.l	(plcList).w
		bne.s	LevelSelect
		andi.b	#$F0,(v_jpadpress1).w
		beq.s	LevelSelect
		move.w	(LevSelOption).w,d0
		cmpi.w	#$13,d0
		bne.s	loc_2780
		move.w	(LevSelSound).w,d0
		addi.w	#$80,d0
		cmpi.w	#$93,d0				; There's no pointer for music $92 or $93
		bcs.s	loc_277A			; So the game crashes when played
		cmpi.w	#sfx__First,d0
		bcs.s	LevelSelect

loc_277A:
		bsr.w	PlaySFX
		bra.s	LevelSelect
; ---------------------------------------------------------------------------

loc_2780:
		add.w	d0,d0
		move.w	LevSelOrder(pc,d0.w),d0
		bmi.s	LevelSelect
		cmpi.w	#$700,d0
		bne.s	loc_2796
		move.b	#$10,(v_gamemode).w
		rts
; ---------------------------------------------------------------------------

loc_2796:
		andi.w	#$3FFF,d0
		btst	#4,(v_jpadhold1).w		; Is B pressed?
		beq.s	loc_27A6			; If not, ignore below
		move.w	#3,d0				; Set the zone to Green Hill Act 4

loc_27A6:
		move.w	d0,(v_zone).w

loc_27AA:
		move.b	#$C,(v_gamemode).w
		move.b	#3,(v_lives).w
		moveq	#0,d0
		move.w	d0,(v_rings).w
		move.l	d0,(v_time).w
		move.l	d0,(v_score).w
		move.b	#bgm_Fade,d0
		bsr.w	PlaySFX
		rts
; ---------------------------------------------------------------------------

LevSelOrder:	dc.w 0,    1,    2
		dc.w $100, $101, $102
		dc.w $200, $201, $202
		dc.w $300, $301, $302
		dc.w $400, $401, $402
		dc.w $500, $501,$8500
		dc.w $700, $700,$8000
; ---------------------------------------------------------------------------

loc_27F8:
		move.w	#$1E,(v_demolength).w

loc_27FE:
		move.b	#4,(VBlankRoutine).w
		bsr.w	WaitForVBla
		bsr.w	DeformLayers
		bsr.w	PaletteCycle
		bsr.w	RunPLC
		move.w	(v_objspace+8).w,d0
		addq.w	#2,d0
		move.w	d0,(v_objspace+8).w
		cmpi.w	#$1C00,d0
		bcs.s	loc_282C
		move.b	#0,(v_gamemode).w
		rts
; ---------------------------------------------------------------------------

loc_282C:
		tst.w	(v_demolength).w
		bne.w	loc_27FE
		move.b	#bgm_Fade,d0
		bsr.w	PlaySFX
		move.w	(DemoNum).w,d0
		andi.w	#7,d0
		add.w	d0,d0
		move.w	DemoLevels(pc,d0.w),d0
		move.w	d0,(v_zone).w
		addq.w	#1,(DemoNum).w
		cmpi.w	#6,(DemoNum).w
		bcs.s	loc_2860
		move.w	#0,(DemoNum).w

loc_2860:
		move.w	#1,(DemoMode).w
		move.b	#8,(v_gamemode).w
		cmpi.w	#$600,d0
		bne.s	loc_2878
		move.b	#$10,(v_gamemode).w

loc_2878:
		move.b	#3,(v_lives).w
		moveq	#0,d0
		move.w	d0,(v_rings).w
		move.l	d0,(v_time).w
		move.l	d0,(v_score).w
		rts
; ---------------------------------------------------------------------------

DemoLevels:	dc.w 0, $600, $200, $600, $400, $600, $300, $600, $200
		dc.w $600, $400, $600
; ---------------------------------------------------------------------------

sub_28A6:
		move.b	(v_jpadpress1).w,d1
		andi.b	#3,d1
		bne.s	loc_28B6
		subq.w	#1,(word_FFF666).w
		bpl.s	loc_28F0

loc_28B6:
		move.w	#$B,(word_FFF666).w
		move.b	(v_jpadhold1).w,d1
		andi.b	#3,d1
		beq.s	loc_28F0
		move.w	(LevSelOption).w,d0
		btst	#0,d1
		beq.s	loc_28D6
		subq.w	#1,d0
		bcc.s	loc_28D6
		moveq	#$13,d0

loc_28D6:
		btst	#1,d1
		beq.s	loc_28E6
		addq.w	#1,d0
		cmpi.w	#$14,d0
		bcs.s	loc_28E6
		moveq	#0,d0

loc_28E6:
		move.w	d0,(LevSelOption).w
		bsr.w	LevSelTextLoad
		rts
; ---------------------------------------------------------------------------

loc_28F0:
		cmpi.w	#$13,(LevSelOption).w
		bne.s	locret_292A
		move.b	(v_jpadpress1).w,d1
		andi.b	#$C,d1
		beq.s	locret_292A
		move.w	(LevSelSound).w,d0
		btst	#2,d1
		beq.s	loc_2912
		subq.w	#1,d0
		bcc.s	loc_2912
		moveq	#79,d0

loc_2912:
		btst	#3,d1
		beq.s	loc_2922
		addq.w	#1,d0
		cmpi.w	#80,d0
		bcs.s	loc_2922
		moveq	#0,d0

loc_2922:
		move.w	d0,(LevSelSound).w
		bsr.w	LevSelTextLoad

locret_292A:
		rts
; ---------------------------------------------------------------------------

LevSelTextLoad:
		lea	(LevelSelectText).l,a1
		lea	(vdp_data_port).l,a6
		move.l	#$62100003,d4
		move.w	#$E680,d3
		moveq	#$13,d1

loc_2944:
		move.l	d4,4(a6)
		bsr.w	sub_29CC
		addi.l	#$800000,d4
		dbf	d1,loc_2944
		moveq	#0,d0
		move.w	(LevSelOption).w,d0
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
		cmpi.w	#$13,(LevSelOption).w
		bne.s	loc_2996
		move.w	#$C680,d3

loc_2996:
		move.l	#$6BB00003,(vdp_control_port).l
		move.w	(LevSelSound).w,d0
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
		moveq	#$17,d2

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

LevelSelectText:incbin "misc\Level Select Text.bin"
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
		bsr.w	PlaySFX
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
		bsr.w	plcAdd

loc_2C0A:
		moveq	#plcid_Main2,d0
		bsr.w	plcAdd
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
		lea	(v_objspace).w,a1
		moveq	#0,d0
		move.w	#$7FF,d1

loc_2C4C:
		move.l	d0,(a1)+
		dbf	d1,loc_2C4C
		lea	(v_screenposx).w,a1
		moveq	#0,d0
		move.w	#$3F,d1

loc_2C5C:
		move.l	d0,(a1)+
		dbf	d1,loc_2C5C
		lea	(oscValues+2).w,a1
		moveq	#0,d0
		move.w	#$27,d1

loc_2C6C:
		move.l	d0,(a1)+
		dbf	d1,loc_2C6C
		moveq	#3,d0
		bsr.w	PalLoad2
		moveq	#0,d0
		move.b	(v_zone).w,d0
		lea	(MusicList).l,a1
		move.b	(a1,d0.w),d0
		bsr.w	PlayMusic
		move.b	#$34,(v_objspace+$80).w

loc_2C92:
		move.b	#$C,(VBlankRoutine).w
		bsr.w	WaitForVBla
		bsr.w	RunObjects
		bsr.w	ProcessMaps
		bsr.w	RunPLC
		move.w	(v_objspace+$108).w,d0
		cmp.w	(v_objspace+$130).w,d0
		bne.s	loc_2C92
		tst.l	(plcList).w
		bne.s	loc_2C92
		bsr.w	EarlyDebugLoadArt
		jsr	(sub_117C6).l
		moveq	#3,d0
		bsr.w	PalLoad1
		bsr.w	LoadLevelBounds
		bsr.w	DeformLayers
		bsr.w	LoadLevelData
		bsr.w	LoadAnimatedBlocks
		bsr.w	mapLevelLoadFull
		jsr	(LogCollision).l
		move.l	#colGHZ,(v_collindex).w		; Load Green Hill's collision - what follows are some C style conditional statements, really unnecessary and replaced with a table in the final game
		cmpi.b	#1,(v_zone).w			; Is the current zone Labyrinth?
		bne.s	loc_2CFA			; If not, go to the next condition
		move.l	#colLZ,(v_collindex).w		; Load Labyrinth's collision

loc_2CFA:
		cmpi.b	#2,(v_zone).w			; Is the current zone Marble?
		bne.s	loc_2D0A			; If not, go to the next condition
		move.l	#colMZ,(v_collindex).w		; Load Marble's collision

loc_2D0A:
		cmpi.b	#3,(v_zone).w			; Is the current zone Star Light?
		bne.s	loc_2D1A			; If not, go to the next condition
		move.l	#colSLZ,(v_collindex).w		; Load Star Light's collision

loc_2D1A:
		cmpi.b	#4,(v_zone).w			; Is the current zone Sparkling?
		bne.s	loc_2D2A			; If not, go to the last condition
		move.l	#colSZ,(v_collindex).w		; Load Sparkling's collision

loc_2D2A:
		cmpi.b	#5,(v_zone).w			; Is the current zone Clock Work?
		bne.s	loc_2D3A			; If not, then just skip loading collision
		move.l	#colCWZ,(v_collindex).w		; Load Clock Work's collision

loc_2D3A:
		move.b	#1,(v_objspace).w
		move.b	#$21,(v_objspace+$40).w
		btst	#6,(v_jpadhold1).w
		beq.s	loc_2D54
		move.b	#1,(f_debugmode).w

loc_2D54:
		move.w	#0,(v_jpadhold2).w
		move.w	#0,(v_jpadhold1).w
		bsr.w	ObjPosLoad
		bsr.w	RunObjects
		bsr.w	ProcessMaps
		moveq	#0,d0
		move.w	d0,(v_rings).w
		move.b	d0,(byte_FFFE1B).w
		move.l	d0,(v_time).w
		move.b	d0,(v_shield).w
		move.b	d0,(v_invinc).w
		move.b	d0,(v_shoes).w
		move.b	d0,($FFFFFE2F).w
		move.w	d0,(DebugRoutine).w
		move.w	d0,(LevelRestart).w
		move.w	d0,(LevelFrames).w
		bsr.w	oscInit
		move.b	#1,(byte_FFFE1F).w
		move.b	#1,(f_extralife).w
		move.b	#1,(f_timecount).w
		move.w	#0,(unk_FFF790).w
		lea	(off_3100).l,a1
		moveq	#0,d0
		move.b	(v_zone).w,d0
		lsl.w	#2,d0
		movea.l	(a1,d0.w),a1
		move.b	1(a1),(unk_FFF792).w
		subq.b	#1,(unk_FFF792).w
		move.w	#$708,(v_demolength).w
		move.b	#8,(VBlankRoutine).w
		bsr.w	WaitForVBla
		move.w	#$202F,(v_pfade_start).w
		bsr.w	PaletteWhiteIn+6
		addq.b	#2,(v_objspace+$A4).w
		addq.b	#4,(v_objspace+$E4).w
		addq.b	#4,(v_objspace+$124).w
		addq.b	#4,(v_objspace+$164).w

GM_LevelLoop:
		bsr.w	PauseGame
		move.b	#8,(VBlankRoutine).w
		bsr.w	WaitForVBla
		addq.w	#1,(LevelFrames).w
		bsr.w	LZWaterFeatures
		bsr.w	DemoPlayback
		move.w	(v_jpadhold1).w,(v_jpadhold2).w
		bsr.w	RunObjects
		tst.w	(DebugRoutine).w
		bne.s	loc_2E2A
		cmpi.b	#6,(v_objspace+$24).w
		bcc.s	loc_2E2E

loc_2E2A:
		bsr.w	DeformLayers

loc_2E2E:
		bsr.w	ProcessMaps
		bsr.w	ObjPosLoad
		bsr.w	PaletteCycle
		bsr.w	RunPLC
		bsr.w	oscUpdate
		bsr.w	UpdateTimers
		bsr.w	LoadSignpostPLC
		cmpi.b	#8,(v_gamemode).w
		beq.s	loc_2E66
		tst.w	(LevelRestart).w
		bne.w	GM_Level
		cmpi.b	#$C,(v_gamemode).w
		beq.w	GM_LevelLoop
		rts
; ---------------------------------------------------------------------------

loc_2E66:
		tst.w	(LevelRestart).w
		bne.s	loc_2E84
		tst.w	(v_demolength).w
		beq.s	loc_2E84
		cmpi.b	#8,(v_gamemode).w
		beq.w	GM_LevelLoop
		move.b	#0,(v_gamemode).w
		rts
; ---------------------------------------------------------------------------

loc_2E84:
		cmpi.b	#8,(v_gamemode).w
		bne.s	loc_2E92
		move.b	#0,(v_gamemode).w

loc_2E92:
		move.w	#$3C,(v_demolength).w
		move.w	#$3F,(v_pfade_start).w

loc_2E9E:
		move.b	#8,(VBlankRoutine).w
		bsr.w	WaitForVBla
		bsr.w	DemoPlayback
		bsr.w	RunObjects
		bsr.w	ProcessMaps
		bsr.w	ObjPosLoad
		subq.w	#1,(unk_FFF794).w
		bpl.s	loc_2EC8
		move.w	#2,(unk_FFF794).w
		bsr.w	FadeOut_ToBlack

loc_2EC8:
		tst.w	(v_demolength).w
		bne.s	loc_2E9E
		rts
; ---------------------------------------------------------------------------
                include "leftovers\Early Debug Mappings.asm"
                include "leftovers\Ultra Debug Mappings.asm"
; ---------------------------------------------------------------------------
; Unused, Speculated to have been for a window plane wavy masking effect
; involving writes during HBlank. It writes its tables in the Nemesis GFX
; buffer, only seemingly needing to be called once.
; Discovered by Filter, reconstructed by KatKuriN, Rivet, and ProjectFM
; ---------------------------------------------------------------------------
sub_3018:
		lea	(v_ngfx_buffer).w,a0
		move.w	(f_water).w,d2
		move.w	#$9100,d3
		move.w	#$FF,d7

loc_3028:
		move.w	d2,d0
		bsr.w	GetSine
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

                include "_inc\LZWaterFeatures.asm"

; ---------------------------------------------------------------------------

DemoPlayback:
		tst.w	(DemoMode).w
		bne.s	loc_30B8
		rts
; ---------------------------------------------------------------------------

DemoRecord:
		lea	($80000).l,a1
		move.w	(unk_FFF790).w,d0
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
		addq.w	#2,(unk_FFF790).w
		andi.w	#$3FF,(unk_FFF790).w
		rts
; ---------------------------------------------------------------------------

loc_30B8:
		tst.b	(v_jpadhold1).w
		bpl.s	loc_30C4
		move.b	#4,(v_gamemode).w

loc_30C4:
		lea	(off_3100).l,a1
		moveq	#0,d0
		move.b	(v_zone).w,d0
		lsl.w	#2,d0
		movea.l	(a1,d0.w),a1
		move.w	(unk_FFF790).w,d0
		adda.w	d0,a1
		move.b	(a1),d0
		lea	(v_jpadhold1).w,a0
		move.b	d0,d1
		move.b	(a0),d2
		eor.b	d2,d0
		move.b	d1,(a0)+
		and.b	d1,d0
		move.b	d0,(a0)+
		subq.b	#1,(unk_FFF792).w
		bcc.s	locret_30FE
		move.b	3(a1),(unk_FFF792).w
		addq.w	#2,(unk_FFF790).w

locret_30FE:
		rts
; ---------------------------------------------------------------------------

off_3100:	dc.l byte_614C6
                dc.l byte_614C6
                dc.l byte_614C6
                dc.l byte_61434
                dc.l byte_61578
		dc.l byte_61578
                dc.l byte_6161E

		dc.b 0, $8B, 8, $37, 0, $42, 8, $5C, 0, $6A, 8, $5F, 0, $2F, 8, $2C
		dc.b 0, $21, 8, 3, $28, $30, 8, 8, 0, $2E, 8, $15, 0, $F, 8, $46
		dc.b 0, $1A, 8, $FF, 8, $CA, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
; ---------------------------------------------------------------------------
		cmpi.b	#6,(v_zone).w
		bne.s	locret_3176
		bsr.w	sub_3178
		lea	($FF0900).l,a1
		bsr.s	sub_3166
		lea	($FF3380).l,a1
; ---------------------------------------------------------------------------

sub_3166:
		lea	(Anim16Unk1).l,a0
		move.w	#(Anim16Unk1_end-Anim16Unk1)/2-1,d1

.loadblocks:
		move.w	(a0)+,(a1)+
		dbf	d1,.loadblocks

locret_3176:
		rts
; ---------------------------------------------------------------------------

sub_3178:
		lea	($FF0000).l,a1
		lea	(Anim16Unk2).l,a0
		move.w	#(Anim16Unk2_end-Anim16Unk2)/2-1,d1

.loadblocks2:
		move.w	(a0)+,d0
		ori.w	#$2000,(a1,d0.w)
		dbf	d1,.loadblocks2
		rts
; ---------------------------------------------------------------------------
Anim16Unk1:	incbin "map16\Anim Unknown 1.bin"
Anim16Unk1_end:	even
Anim16Unk2:	incbin "map16\Anim Unknown 2.bin"
Anim16Unk2_end:	even
; ---------------------------------------------------------------------------

LoadAnimatedBlocks:
		cmpi.b	#2,(v_zone).w
		beq.s	.ismz
		cmpi.b	#3,(v_zone).w
		beq.s	.isslz
		tst.b	(v_zone).w
		bne.s	.notghz

.isslz:
		lea	(v_16x16+$1790).w,a1
		lea	(Anim16GHZ).l,a0
		move.w	#(Anim16GHZ_end-Anim16GHZ)/2-1,d1

.loadghz:
		move.w	(a0)+,(a1)+
		dbf	d1,.loadghz

.notghz:
		rts
; ---------------------------------------------------------------------------

.ismz:
		lea	(v_16x16+$17A0).w,a1
		lea	(Anim16MZ).l,a0
		move.w	#(Anim16MZ_end-Anim16MZ)/2-1,d1

.loadmz:
		move.w	(a0)+,(a1)+
		dbf	d1,.loadmz
		rts
; ---------------------------------------------------------------------------
Anim16GHZ:	incbin "map16\Anim GHZ.bin"
Anim16GHZ_end:	even
Anim16MZ:	incbin "map16\Anim MZ.bin"
Anim16MZ_end:	even
; ---------------------------------------------------------------------------

EarlyDebugLoadArt:
		rts					; this was rts'd out to stop it from overwriting the vram at $9E00
; ---------------------------------------------------------------------------
		move.l	#$5E000002,(vdp_control_port).l
		lea	(ArtText).l,a0
		move.w	#$9F,d1
		bsr.s	.loadtext
		lea	(ArtText).l,a0
		adda.w	#$220,a0
		move.w	#$5F,d1
; ---------------------------------------------------------------------------

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

                include "_inc\Oscillatory Routines.asm"

; ---------------------------------------------------------------------------

UpdateTimers:
		subq.b	#1,(unk_FFFEC0).w
		bpl.s	loc_3464
		move.b	#$B,(unk_FFFEC0).w
		subq.b	#1,(unk_FFFEC1).w
		andi.b	#7,(unk_FFFEC1).w

loc_3464:
		subq.b	#1,(RingTimer).w
		bpl.s	loc_347A
		move.b	#7,(RingTimer).w
		addq.b	#1,(RingFrame).w
		andi.b	#3,(RingFrame).w

loc_347A:
		subq.b	#1,(unk_FFFEC4).w
		bpl.s	loc_3498
		move.b	#7,(unk_FFFEC4).w
		addq.b	#1,(unk_FFFEC5).w
		cmpi.b	#6,(unk_FFFEC5).w
		bcs.s	loc_3498
		move.b	#0,(unk_FFFEC5).w

loc_3498:
		tst.b	(RingLossTimer).w
		beq.s	locret_34BA
		moveq	#0,d0
		move.b	(RingLossTimer).w,d0
		add.w	(RingLossAccumulator).w,d0
		move.w	d0,(RingLossAccumulator).w
		rol.w	#7,d0
		andi.w	#3,d0
		move.b	d0,(RingLossFrame).w
		subq.b	#1,(RingLossTimer).w

locret_34BA:
		rts
; ---------------------------------------------------------------------------

LoadSignpostPLC:
		tst.w	(DebugRoutine).w
		bne.w	locret_34FA
		cmpi.w	#$202,(v_zone).w
		beq.s	loc_34D4
		cmpi.b	#2,(v_act).w
		beq.s	locret_34FA

loc_34D4:
		move.w	(v_screenposx).w,d0
		move.w	(unk_FFF72A).w,d1
		subi.w	#$100,d1
		cmp.w	d1,d0
		blt.s	locret_34FA
		tst.b	(f_timecount).w
		beq.s	locret_34FA
		cmp.w	(unk_FFF728).w,d1
		beq.s	locret_34FA
		move.w	d1,(unk_FFF728).w
		moveq	#plcid_Signpost,d0
		bra.w	plcReplace
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
		lea	(vdp_control_port).l,a5
		move.w	#$8F01,(a5)
		move.l	#$946F93FF,(a5)
		move.w	#$9780,(a5)
		move.l	#$50000081,(a5)
		move.w	#0,(vdp_data_port).l

loc_3534:
		move.w	(a5),d1
		btst	#1,d1
		bne.s	loc_3534
		move.w	#$8F02,(a5)
		moveq	#$14,d0
		bsr.w	sub_14E2
		bsr.w	ssLoadBG
		lea	(v_objspace).w,a1
		moveq	#0,d0
		move.w	#$7FF,d1

loc_3554:
		move.l	d0,(a1)+
		dbf	d1,loc_3554
		lea	(v_screenposx).w,a1
		moveq	#0,d0
		move.w	#$3F,d1

loc_3564:
		move.l	d0,(a1)+
		dbf	d1,loc_3564
		lea	(oscValues+2).w,a1
		moveq	#0,d0
		move.w	#$27,d1

loc_3574:
		move.l	d0,(a1)+
		dbf	d1,loc_3574
		lea	(v_ngfx_buffer).w,a1
		moveq	#0,d0
		move.w	#$7F,d1

loc_3584:
		move.l	d0,(a1)+
		dbf	d1,loc_3584
		moveq	#$A,d0
		bsr.w	PalLoad1
		jsr	(SS_Load).l
		move.l	#0,(v_screenposx).w
		move.l	#0,(v_screenposy).w
		move.b	#9,(v_objspace).w
		move.w	#$458,(v_objspace+8).w
		move.w	#$4A0,(v_objspace+$C).w
		lea	(vdp_control_port).l,a6
		move.w	#$8B03,(a6)
		move.w	#$8004,(a6)
		move.w	#$8AAF,(v_hbla_hreg).w
		move.w	#$9011,(a6)
		bsr.w	SS_PalCycle
		clr.w	(unk_FFF780).w
		move.w	#$40,(unk_FFF782).w
		move.w	#bgm_SS,d0
		bsr.w	PlaySFX
		move.w	#0,(unk_FFF790).w
		lea	(off_3100).l,a1
		moveq	#0,d0
		move.b	(v_zone).w,d0
		lsl.w	#2,d0
		movea.l	(a1,d0.w),a1
		move.b	1(a1),(unk_FFF792).w
		subq.b	#1,(unk_FFF792).w
		move.w	#$708,(v_demolength).w
		move.w	(v_vdp_buffer1).w,d0
		ori.b	#$40,d0
		move.w	d0,(vdp_control_port).l
		bsr.w	PaletteWhiteIn

loc_3620:
		bsr.w	PauseGame
		move.b	#$A,(VBlankRoutine).w
		bsr.w	WaitForVBla
		bsr.w	DemoPlayback
		move.w	(v_jpadhold1).w,(v_jpadhold2).w
		bsr.w	RunObjects
		bsr.w	ProcessMaps
		jsr	(GM_Special_ShowLayout).l
		bsr.w	GM_SpecialAnimateBG
		tst.w	(DemoMode).w
		beq.s	loc_3656
		tst.w	(v_demolength).w
		beq.s	loc_3662

loc_3656:
		cmpi.b	#$10,(v_gamemode).w
		beq.w	loc_3620
		rts
; ---------------------------------------------------------------------------

loc_3662:
		move.b	#0,(v_gamemode).w
		rts
; ---------------------------------------------------------------------------

ssLoadBG:
		lea	($FF0000).l,a1
		lea	(byte_639B8).l,a0
		move.w	#$4051,d0
		bsr.w	EniDec
		move.l	#$50000001,d3
		lea	($FF0080).l,a2
		moveq	#6,d7

loc_368C:
		move.l	d3,d0
		moveq	#3,d6
		moveq	#0,d4
		cmpi.w	#3,d7
		bcc.s	loc_369A
		moveq	#1,d4

loc_369A:
		moveq	#7,d5

loc_369C:
		movea.l	a2,a1
		eori.b	#1,d4
		bne.s	loc_36B0
		cmpi.w	#6,d7
		bne.s	loc_36C0
		lea	($FF0000).l,a1

loc_36B0:
		movem.l	d0-d4,-(sp)
		moveq	#7,d1
		moveq	#7,d2
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
		lea	($FF0000).l,a1
		lea	(byte_6477C).l,a0
		move.w	#$4000,d0
		bsr.w	EniDec
		copyTilemap	$FF0000,$C000,$3F,$1F
		copyTilemap	$FF0000,$D000,$3F,$3F
		rts
; ---------------------------------------------------------------------------

SS_PalCycle:
		tst.w	(f_pause).w
		bmi.s	locret_37B4
		subq.w	#1,(unk_FFF79C).w
		bpl.s	locret_37B4
		lea	(vdp_control_port).l,a6
		move.w	(unk_FFF79A).w,d0
		addq.w	#1,(unk_FFF79A).w
		andi.w	#$1F,d0
		lsl.w	#2,d0
		lea	(byte_380A).l,a0
		adda.w	d0,a0
		move.b	(a0)+,d0
		bpl.s	loc_3760
		move.w	#$1FF,d0

loc_3760:
		move.w	d0,(unk_FFF79C).w
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
		lea	(v_pal_dry+$4E).w,a2
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
		lea	(v_pal_dry+$6E).w,a2
		move.l	(a1),(a2)+
		move.l	4(a1),(a2)+
		move.l	8(a1),(a2)+

loc_37E6:
		adda.w	#$C,a1
		lea	(v_pal_dry+$5A).w,a2
		cmpi.w	#$A,d0
		bcs.s	loc_37FC
		subi.w	#$A,d0
		lea	(v_pal_dry+$7A).w,a2

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

byte_388A:	dc.b $10, 1, $18, 0, $18, 1, $20, 0, $20, 1, $28, 0, $28
		dc.b 1

dword_3898:	dc.l $4000600, $6200624, $6640666, $6000820, $A640A68
		dc.l $AA60AAA, $8000C42, $E860ECA, $EEC0EEE, $4000420
		dc.l $6200620, $8640666, $4200620, $8420842, $A860AAA
		dc.l $6200842, $A640C86, $EA80EEE

word_38E0:	incbin "palette\Cycle - SS.bin"
		even
; ---------------------------------------------------------------------------

GM_SpecialAnimateBG:
		move.w	(unk_FFF7A0).w,d0
		bne.s	loc_39C4
		move.w	#0,(v_bgscreenposy).w
		move.w	(v_bgscreenposy).w,(v_scrposy_dup+2).w

loc_39C4:
		cmpi.w	#8,d0
		bcc.s	loc_3A1C
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
		bsr.w	GetSine
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
		lea	($FFFFAB00).w,a3
		move.l	#$18000,d2
		moveq	#6,d1

loc_3A32:
		move.l	(a3),d0
		sub.l	d2,d0
		move.l	d0,(a3)+
		subi.l	#$2000,d2
		dbf	d1,loc_3A32

loc_3A42:
		lea	($FFFFAB00).w,a3
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

byte_3A92:	dc.b 6, $30, $30, $30, $28, $18, $18, $18

byte_3A9A:	dc.b 8, 2, 4, $FF, 2, 3, 8, $FF, 4, 2, 2, 3, 8, $FD, 4
		dc.b 2, 2, 3, 2, $FF
; ---------------------------------------------------------------------------

		include "_inc\LevelSizeLoad & BgScrollSpeed.asm"
		include "_inc\DeformLayers.asm"

; ---------------------------------------------------------------------------

sub_43B6:
		lea	(vdp_control_port).l,a5
		lea	(vdp_data_port).l,a6
		lea	(unk_FFF756).w,a2
		lea	(v_bgscreenposx).w,a3
		lea	(v_lvllayout+$40).w,a4
		move.w	#$6000,d2
		bsr.w	sub_4484
		lea	(unk_FFF758).w,a2
		lea	(v_bg2screenposx).w,a3
		bra.w	sub_4524
; ---------------------------------------------------------------------------

mapLevelLoad:
		lea	(vdp_control_port).l,a5
		lea	(vdp_data_port).l,a6
		lea	(unk_FFF756).w,a2
		lea	(v_bgscreenposx).w,a3
		lea	(v_lvllayout+$40).w,a4
		move.w	#$6000,d2
		bsr.w	sub_4484
		lea	(unk_FFF758).w,a2
		lea	(v_bg2screenposx).w,a3
		bsr.w	sub_4524
		lea	(unk_FFF754).w,a2
		lea	(v_screenposx).w,a3
		lea	(v_lvllayout).w,a4
		move.w	#$4000,d2
		tst.b	(a2)
		beq.s	locret_4482
		bclr	#0,(a2)
		beq.s	loc_4438
		moveq	#-16,d4
		moveq	#-16,d5
		bsr.w	sub_4752
		moveq	#-16,d4
		moveq	#-16,d5
		bsr.w	sub_4608

loc_4438:
		bclr	#1,(a2)
		beq.s	loc_4452
		move.w	#$E0,d4
		moveq	#-16,d5
		bsr.w	sub_4752
		move.w	#$E0,d4
		moveq	#-16,d5
		bsr.w	sub_4608

loc_4452:
		bclr	#2,(a2)
		beq.s	loc_4468
		moveq	#-16,d4
		moveq	#-16,d5
		bsr.w	sub_4752
		moveq	#-16,d4
		moveq	#-16,d5
		bsr.w	sub_4634

loc_4468:
		bclr	#3,(a2)
		beq.s	locret_4482
		moveq	#-16,d4
		move.w	#$140,d5
		bsr.w	sub_4752
		moveq	#-16,d4
		move.w	#$140,d5
		bsr.w	sub_4634

locret_4482:
		rts
; ---------------------------------------------------------------------------

sub_4484:
		tst.b	(a2)
		beq.w	locret_4522
		bclr	#0,(a2)
		beq.s	loc_44A2
		moveq	#-16,d4
		moveq	#-16,d5
		bsr.w	sub_4752
		moveq	#-16,d4
		moveq	#-16,d5
		moveq	#$1F,d6
		bsr.w	sub_460A

loc_44A2:
		bclr	#1,(a2)
		beq.s	loc_44BE
		move.w	#$E0,d4
		moveq	#-16,d5
		bsr.w	sub_4752
		move.w	#$E0,d4
		moveq	#-16,d5
		moveq	#$1F,d6
		bsr.w	sub_460A

loc_44BE:
		bclr	#2,(a2)
		beq.s	loc_44EE
		moveq	#-16,d4
		moveq	#-16,d5
		bsr.w	sub_4752
		moveq	#-16,d4
		moveq	#-16,d5
		move.w	(unk_FFF7F0).w,d6
		move.w	4(a3),d1
		andi.w	#$FFF0,d1
		sub.w	d1,d6
		blt.s	loc_44EE
		lsr.w	#4,d6
		cmpi.w	#$F,d6
		bcs.s	loc_44EA
		moveq	#$F,d6

loc_44EA:
		bsr.w	sub_4636

loc_44EE:
		bclr	#3,(a2)
		beq.s	locret_4522
		moveq	#-16,d4
		move.w	#$140,d5
		bsr.w	sub_4752
		moveq	#-16,d4
		move.w	#$140,d5
		move.w	(unk_FFF7F0).w,d6
		move.w	4(a3),d1
		andi.w	#$FFF0,d1
		sub.w	d1,d6
		blt.s	locret_4522
		lsr.w	#4,d6
		cmpi.w	#$F,d6
		bcs.s	loc_451E
		moveq	#$F,d6

loc_451E:
		bsr.w	sub_4636

locret_4522:
		rts
; ---------------------------------------------------------------------------

sub_4524:
		tst.b	(a2)
		beq.w	locret_45B0
		bclr	#2,(a2)
		beq.s	loc_456E
		cmpi.w	#$10,(a3)
		bcs.s	loc_456E
		move.w	(unk_FFF7F0).w,d4
		move.w	4(a3),d1
		andi.w	#$FFF0,d1
		sub.w	d1,d4
		move.w	d4,-(sp)
		moveq	#-16,d5
		bsr.w	sub_4752
		move.w	(sp)+,d4
		moveq	#-16,d5
		move.w	(unk_FFF7F0).w,d6
		move.w	4(a3),d1
		andi.w	#$FFF0,d1
		sub.w	d1,d6
		blt.s	loc_456E
		lsr.w	#4,d6
		subi.w	#$E,d6
		bcc.s	loc_456E
		neg.w	d6
		bsr.w	sub_4636

loc_456E:
		bclr	#3,(a2)
		beq.s	locret_45B0
		move.w	(unk_FFF7F0).w,d4
		move.w	4(a3),d1
		andi.w	#$FFF0,d1
		sub.w	d1,d4
		move.w	d4,-(sp)
		move.w	#$140,d5
		bsr.w	sub_4752
		move.w	(sp)+,d4
		move.w	#$140,d5
		move.w	(unk_FFF7F0).w,d6
		move.w	4(a3),d1
		andi.w	#$FFF0,d1
		sub.w	d1,d6
		blt.s	locret_45B0
		lsr.w	#4,d6
		subi.w	#$E,d6
		bcc.s	locret_45B0
		neg.w	d6
		bsr.w	sub_4636

locret_45B0:
		rts
; ---------------------------------------------------------------------------
		tst.b	(a2)
		beq.s	locret_4606
		bclr	#2,(a2)
		beq.s	loc_45DC
		move.w	#$D0,d4
		move.w	4(a3),d1
		andi.w	#$FFF0,d1
		sub.w	d1,d4
		move.w	d4,-(sp)
		moveq	#-16,d5
		bsr.w	sub_476E
		move.w	(sp)+,d4
		moveq	#-16,d5
		moveq	#2,d6
		bsr.w	sub_4636

loc_45DC:
		bclr	#3,(a2)
		beq.s	locret_4606
		move.w	#$D0,d4
		move.w	4(a3),d1
		andi.w	#$FFF0,d1
		sub.w	d1,d4
		move.w	d4,-(sp)
		move.w	#$140,d5
		bsr.w	sub_476E
		move.w	(sp)+,d4
		move.w	#$140,d5
		moveq	#2,d6
		bsr.w	sub_4636

locret_4606:
		rts
; ---------------------------------------------------------------------------

sub_4608:
		moveq	#$15,d6
; ---------------------------------------------------------------------------

sub_460A:
		move.l	#$800000,d7
		move.l	d0,d1

loc_4612:
		movem.l	d4-d5,-(sp)
		bsr.w	sub_4706
		move.l	d1,d0
		bsr.w	sub_4662
		addq.b	#4,d1
		andi.b	#$7F,d1
		movem.l	(sp)+,d4-d5
		addi.w	#$10,d5
		dbf	d6,loc_4612
		rts
; ---------------------------------------------------------------------------

sub_4634:
		moveq	#$F,d6
; ---------------------------------------------------------------------------

sub_4636:
		move.l	#$800000,d7
		move.l	d0,d1

loc_463E:
		movem.l	d4-d5,-(sp)
		bsr.w	sub_4706
		move.l	d1,d0
		bsr.w	sub_4662
		addi.w	#$100,d1
		andi.w	#$FFF,d1
		movem.l	(sp)+,d4-d5
		addi.w	#$10,d4
		dbf	d6,loc_463E
		rts
; ---------------------------------------------------------------------------

sub_4662:
		or.w	d2,d0
		swap	d0
		btst	#4,(a0)
		bne.s	loc_469E
		btst	#3,(a0)
		bne.s	loc_467E
		move.l	d0,(a5)
		move.l	(a1)+,(a6)
		add.l	d7,d0
		move.l	d0,(a5)
		move.l	(a1)+,(a6)
		rts
; ---------------------------------------------------------------------------

loc_467E:
		move.l	d0,(a5)
		move.l	(a1)+,d4
		eori.l	#$8000800,d4
		swap	d4
		move.l	d4,(a6)
		add.l	d7,d0
		move.l	d0,(a5)
		move.l	(a1)+,d4
		eori.l	#$8000800,d4
		swap	d4
		move.l	d4,(a6)
		rts
; ---------------------------------------------------------------------------

loc_469E:
		btst	#3,(a0)
		bne.s	loc_46C0
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
; ---------------------------------------------------------------------------

loc_46C0:
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
; ---------------------------------------------------------------------------
		rts
; ---------------------------------------------------------------------------
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
; ---------------------------------------------------------------------------

sub_4706:
		lea	(v_16x16).w,a1
		add.w	4(a3),d4
		add.w	(a3),d5
		move.w	d4,d3
		lsr.w	#1,d3
		andi.w	#$380,d3
		lsr.w	#3,d5
		move.w	d5,d0
		lsr.w	#5,d0
		andi.w	#$7F,d0
		add.w	d3,d0
		moveq	#$FFFFFFFF,d3
		move.b	(a4,d0.w),d3
		andi.b	#$7F,d3
		beq.s	locret_4750
		subq.b	#1,d3
		ext.w	d3
		ror.w	#7,d3
		add.w	d4,d4
		andi.w	#$1E0,d4
		andi.w	#$1E,d5
		add.w	d4,d3
		add.w	d5,d3
		movea.l	d3,a0
		move.w	(a0),d3
		andi.w	#$3FF,d3
		lsl.w	#3,d3
		adda.w	d3,a1

locret_4750:
		rts
; ---------------------------------------------------------------------------

sub_4752:
		add.w	4(a3),d4
		add.w	(a3),d5
		andi.w	#$F0,d4
		andi.w	#$1F0,d5
		lsl.w	#4,d4
		lsr.w	#2,d5
		add.w	d5,d4
		moveq	#3,d0
		swap	d0
		move.w	d4,d0
		rts
; ---------------------------------------------------------------------------

sub_476E:
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
; ---------------------------------------------------------------------------

mapLevelLoadFull:
		lea	(vdp_control_port).l,a5
		lea	(vdp_data_port).l,a6
		lea	(v_screenposx).w,a3
		lea	(v_lvllayout).w,a4
		move.w	#$4000,d2
		bsr.s	sub_47B0
		lea	(v_bgscreenposx).w,a3
		lea	(v_lvllayout+$40).w,a4
		move.w	#$6000,d2
; ---------------------------------------------------------------------------

sub_47B0:
		moveq	#-16,d4
		moveq	#$F,d6

loc_47B4:
		movem.l	d4-d6,-(sp)
		moveq	#0,d5
		move.w	d4,d1
		bsr.w	sub_4752
		move.w	d1,d4
		moveq	#0,d5
		moveq	#$1F,d6
		bsr.w	sub_460A
		movem.l	(sp)+,d4-d6
		addi.w	#$10,d4
		dbf	d6,loc_47B4
		rts
; ---------------------------------------------------------------------------
		lea	(v_bg3screenposx).w,a3
		move.w	#$6000,d2
		move.w	#$B0,d4
		moveq	#2,d6

loc_47E6:
		movem.l	d4-d6,-(sp)
		moveq	#0,d5
		move.w	d4,d1
		bsr.w	sub_476E
		move.w	d1,d4
		moveq	#0,d5
		moveq	#$1F,d6
		bsr.w	sub_460A
		movem.l	(sp)+,d4-d6
		addi.w	#$10,d4
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
		move.w	#$5FF,d0

.loadblocks:
		move.l	(a0)+,(a4)+
		dbf	d0,.loadblocks
		movea.l	(a2)+,a0
		lea	(v_256x256&$FFFFFF).l,a1
		bsr.w	KosDec
		bsr.w	LoadLayout
		move.w	(a2)+,d0
		move.w	(a2),d0
		andi.w	#$FF,d0
		bsr.w	PalLoad1
		movea.l	(sp)+,a2
		addq.w	#4,a2
		moveq	#0,d0
		move.b	(a2),d0
		beq.s	.locret
		bsr.w	plcAdd

.locret:
		rts
; ---------------------------------------------------------------------------
sub_485C:
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
		move.l	#$6CBE0002,(vdp_control_port).l
		move.l	#$8579857A,d2
		bsr.s	sub_489E
		move.l	#$6D3E0002,(vdp_control_port).l
		move.l	#$857B857C,d2
; ---------------------------------------------------------------------------

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

LoadLayout:
		lea	(v_lvllayout).w,a3
		move.w	#$1FF,d1
		moveq	#0,d0

loc_48C4:
		move.l	d0,(a3)+
		dbf	d1,loc_48C4
		lea	(v_lvllayout).w,a3
		moveq	#0,d1
		bsr.w	sub_48DA
		lea	(v_lvllayout+$40).w,a3
		moveq	#2,d1
; ---------------------------------------------------------------------------

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
		lea	$80(a3),a3
		dbf	d2,loc_4900
		rts
; ---------------------------------------------------------------------------

		include "_inc\DynamicLevelEvents.asm"

                include "_incObj\02.asm"
		include "_maps\02.asm"

                include "_incObj\03.asm"
                include "_incObj\04.asm"
                include "_incObj\05.asm"
		include "_maps\05.asm"

                include "_incObj\06.asm"
                include "_incObj\07.asm"
                include "_incObj\11 Bridge (part 1).asm"
; ---------------------------------------------------------------------------

PtfmBridge:
		moveq	#0,d1
		move.b	arg(a0),d1
		lsl.w	#3,d1
		move.w	d1,d2
		addq.w	#8,d1
		add.w	d2,d2
		lea	(v_objspace).w,a1
		tst.w	yvel(a1)
		bmi.w	locret_5048
		move.w	xpos(a1),d0
		sub.w	xpos(a0),d0
		add.w	d1,d0
		bmi.w	locret_5048
		cmp.w	d2,d0
		bcc.w	locret_5048
		bra.s	PtfmNormal2
; ---------------------------------------------------------------------------

PtfmNormal:
		lea	(v_objspace).w,a1
		tst.w	yvel(a1)
		bmi.w	locret_5048
		move.w	xpos(a1),d0
		sub.w	xpos(a0),d0
		add.w	d1,d0
		bmi.w	locret_5048
		add.w	d1,d1
		cmp.w	d1,d0
		bcc.w	locret_5048

PtfmNormal2:
		move.w	ypos(a0),d0
		subq.w	#8,d0

PtfmNormal3:
		move.w	ypos(a1),d2
		move.b	yrad(a1),d1
		ext.w	d1
		add.w	d2,d1
		addq.w	#4,d1
		sub.w	d1,d0
		bhi.w	locret_5048
		cmpi.w	#$FFF0,d0
		bcs.w	locret_5048
		cmpi.b	#6,act(a1)
		bcc.w	locret_5048
		add.w	d0,d2
		addq.w	#3,d2
		move.w	d2,ypos(a1)
		addq.b	#2,act(a0)

loc_4FD4:
		btst	#3,status(a1)
		beq.s	loc_4FFC
		moveq	#0,d0
		move.b	platform(a1),d0
		lsl.w	#6,d0
		addi.l	#v_objspace&$FFFFFF,d0
		movea.l	d0,a2
		cmpi.b	#4,act(a2)
		bne.s	loc_4FFC
		subq.b	#2,act(a2)
		clr.b	subact(a2)

loc_4FFC:
		move.w	a0,d0
		subi.w	#v_objspace,d0
		lsr.w	#6,d0
		andi.w	#$7F,d0
		move.b	d0,platform(a1)
		move.b	#0,angle(a1)
		move.w	#0,yvel(a1)
		move.w	xvel(a1),d0
		asr.w	#2,d0
		sub.w	d0,xvel(a1)
		move.w	xvel(a1),inertia(a1)
		btst	#1,status(a1)
		beq.s	loc_503C
		move.l	a0,-(sp)
		movea.l	a1,a0
		jsr	(Sonic_ResetOnFloor).l
		movea.l	(sp)+,a0

loc_503C:
		bset	#3,status(a1)
		bset	#3,status(a0)

locret_5048:
		rts
; ---------------------------------------------------------------------------

PtfmSloped:
		lea	(v_objspace).w,a1
		tst.w	yvel(a1)
		bmi.w	locret_5048
		move.w	xpos(a1),d0
		sub.w	xpos(a0),d0
		add.w	d1,d0
		bmi.s	locret_5048
		add.w	d1,d1
		cmp.w	d1,d0
		bcc.s	locret_5048
		btst	#0,render(a0)
		beq.s	loc_5074
		not.w	d0
		add.w	d1,d0

loc_5074:
		lsr.w	#1,d0
		moveq	#0,d3
		move.b	(a2,d0.w),d3
		move.w	ypos(a0),d0
		sub.w	d3,d0
		bra.w	PtfmNormal3
; ---------------------------------------------------------------------------

PtfmNormalHeight:
		lea	(v_objspace).w,a1
		tst.w	yvel(a1)
		bmi.w	locret_5048
		move.w	xpos(a1),d0
		sub.w	xpos(a0),d0
		add.w	d1,d0
		bmi.w	locret_5048
		add.w	d1,d1
		cmp.w	d1,d0
		bcc.w	locret_5048
		move.w	ypos(a0),d0
		sub.w	d3,d0
		bra.w	PtfmNormal3

		include "_incObj\11 Bridge (part 2).asm"
; ---------------------------------------------------------------------------

PtfmCheckExit:
		move.w	d1,d2

PtfmCheckExit2:
		add.w	d2,d2
		lea	(v_objspace).w,a1
		btst	#1,status(a1)
		bne.s	loc_510A
		move.w	xpos(a1),d0
		sub.w	xpos(a0),d0
		add.w	d1,d0
		bmi.s	loc_510A
		cmp.w	d2,d0
		bcs.s	locret_511C

loc_510A:
		bclr	#3,status(a1)
		move.b	#2,act(a0)
		bclr	#3,status(a0)

locret_511C:
		rts

                include "_incObj\11 Bridge (part 3).asm"
MapBridge:      include "_maps\Bridge.asm"

		include "_incObj\15 Swinging Platform.asm"
MapSwingPtfm:	include "_maps\Swinging Platforms (GHZ).asm"
MapSwingPtfmSZ: include "_maps\Swinging Platforms (SZ).asm"
; ---------------------------------------------------------------------------

ObjSpikeLogs:
		moveq	#0,d0
		move.b	$24(a0),d0
		move.w	off_5788(pc,d0.w),d1
		jmp	off_5788(pc,d1.w)
; ---------------------------------------------------------------------------

off_5788:	dc.w loc_5792-off_5788, loc_5854-off_5788, loc_5854-off_5788, loc_58C2-off_5788, loc_58C8-off_5788
; ---------------------------------------------------------------------------

loc_5792:
		addq.b	#2,$24(a0)
		move.l	#MapSpikeLogs,4(a0)
		move.w	#$4398,2(a0)
		move.b	#7,$22(a0)
		move.b	#4,1(a0)
		move.b	#3,$19(a0)
		move.b	#8,$18(a0)
		move.w	$C(a0),d2
		move.w	8(a0),d3
		move.b	0(a0),d4
		lea	$28(a0),a2
		moveq	#0,d1
		move.b	(a2),d1
		move.b	#0,(a2)+
		move.w	d1,d0
		lsr.w	#1,d0
		lsl.w	#4,d0
		sub.w	d0,d3
		subq.b	#2,d1
		bcs.s	loc_5854
		moveq	#0,d6

loc_57E2:
		bsr.w	ObjectLoad
		bne.s	loc_5854
		addq.b	#1,$28(a0)
		move.w	a1,d5
		subi.w	#$D000,d5
		lsr.w	#6,d5
		andi.w	#$7F,d5
		move.b	d5,(a2)+

loc_57FA:
		move.b	#8,$24(a1)
		move.b	d4,0(a1)
		move.w	d2,$C(a1)
		move.w	d3,8(a1)
		move.l	4(a0),4(a1)
		move.w	#$4398,2(a1)
		move.b	#4,1(a1)
		move.b	#3,$19(a1)
		move.b	#8,$18(a1)
		move.b	d6,$3E(a1)
		addq.b	#1,d6
		andi.b	#7,d6
		addi.w	#$10,d3
		cmp.w	8(a0),d3
		bne.s	loc_5850
		move.b	d6,$3E(a0)
		addq.b	#1,d6
		andi.b	#7,d6
		addi.w	#$10,d3
		addq.b	#1,$28(a0)

loc_5850:
		dbf	d1,loc_57E2

loc_5854:
		bsr.w	sub_5860
		bsr.w	DisplaySprite
		bra.w	loc_5880
; ---------------------------------------------------------------------------

sub_5860:
		move.b	(unk_FFFEC1).w,d0
		move.b	#0,$20(a0)
		add.b	$3E(a0),d0
		andi.b	#7,d0
		move.b	d0,$1A(a0)
		bne.s	locret_587E
		move.b	#$84,$20(a0)

locret_587E:
		rts
; ---------------------------------------------------------------------------

loc_5880:
		move.w	8(a0),d0
		andi.w	#$FF80,d0
		move.w	(v_screenposx).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0
		cmpi.w	#$280,d0
		bhi.w	loc_58A0
		rts
; ---------------------------------------------------------------------------

loc_58A0:
		moveq	#0,d2
		lea	$28(a0),a2
		move.b	(a2)+,d2
		subq.b	#2,d2
		bcs.s	loc_58C2

loc_58AC:
		moveq	#0,d0
		move.b	(a2)+,d0
		lsl.w	#6,d0
		addi.l	#(v_objspace)&$FFFFFF,d0
		movea.l	d0,a1
		bsr.w	ObjectDeleteA1
		dbf	d2,loc_58AC

loc_58C2:
		bsr.w	DeleteObject
		rts
; ---------------------------------------------------------------------------

loc_58C8:
		bsr.w	sub_5860
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------
		include "levels\GHZ\SpikeLogs\Sprite.map"
		even
; ---------------------------------------------------------------------------

ObjPlatform:
		moveq	#0,d0
		move.b	$24(a0),d0
		move.w	off_5918(pc,d0.w),d1
		jmp	off_5918(pc,d1.w)
; ---------------------------------------------------------------------------

off_5918:	dc.w loc_5922-off_5918, loc_59AE-off_5918, loc_59D2-off_5918, loc_5BCE-off_5918, loc_59C2-off_5918
; ---------------------------------------------------------------------------

loc_5922:
		addq.b	#2,$24(a0)
		move.w	#$4000,2(a0)
		move.l	#MapPlatform1,4(a0)
		move.b	#$20,$18(a0)
		cmpi.b	#4,(v_zone).w
		bne.s	loc_5950
		move.l	#MapPlatform2,4(a0)
		move.b	#$20,$18(a0)

loc_5950:
		cmpi.b	#3,(v_zone).w
		bne.s	loc_5972
		move.l	#MapPlatform3,4(a0)
		move.b	#$20,$18(a0)
		move.w	#$4480,2(a0)
		move.b	#3,$28(a0)

loc_5972:
		move.b	#4,1(a0)
		move.b	#4,$19(a0)
		move.w	$C(a0),$2C(a0)
		move.w	$C(a0),$34(a0)
		move.w	8(a0),$32(a0)
		move.w	#$80,$26(a0)
		moveq	#0,d1
		move.b	$28(a0),d0
		cmpi.b	#$A,d0
		bne.s	loc_59AA
		addq.b	#1,d1
		move.b	#$20,$18(a0)

loc_59AA:
		move.b	d1,$1A(a0)

loc_59AE:
		tst.b	$38(a0)
		beq.s	loc_59B8
		subq.b	#4,$38(a0)

loc_59B8:
		moveq	#0,d1
		move.b	$18(a0),d1
		bsr.w	PtfmNormal

loc_59C2:
		bsr.w	sub_5A1E
		bsr.w	sub_5A04
		bsr.w	DisplaySprite
		bra.w	loc_5BB0
; ---------------------------------------------------------------------------

loc_59D2:
		cmpi.b	#$40,$38(a0)
		beq.s	loc_59DE
		addq.b	#4,$38(a0)

loc_59DE:
		moveq	#0,d1
		move.b	$18(a0),d1
		bsr.w	PtfmCheckExit
		move.w	8(a0),-(sp)
		bsr.w	sub_5A1E
		bsr.w	sub_5A04
		move.w	(sp)+,d2
		bsr.w	ptfmSurfaceNormal
		bsr.w	DisplaySprite
		bra.w	loc_5BB0
; ---------------------------------------------------------------------------
		rts
; ---------------------------------------------------------------------------

sub_5A04:
		move.b	$38(a0),d0
		bsr.w	GetSine
		move.w	#$400,d1
		muls.w	d1,d0
		swap	d0
		add.w	$2C(a0),d0
		move.w	d0,$C(a0)
		rts
; ---------------------------------------------------------------------------

sub_5A1E:
		moveq	#0,d0
		move.b	$28(a0),d0
		andi.w	#$F,d0
		add.w	d0,d0
		move.w	off_5A32(pc,d0.w),d1
		jmp	off_5A32(pc,d1.w)
; ---------------------------------------------------------------------------

off_5A32:	dc.w locret_5A4C-off_5A32, loc_5A5E-off_5A32, loc_5AA4-off_5A32, loc_5ABC-off_5A32, loc_5AE4-off_5A32
		dc.w loc_5A4E-off_5A32, loc_5A94-off_5A32, loc_5B4E-off_5A32, loc_5B7A-off_5A32, locret_5A4C-off_5A32
		dc.w loc_5B92-off_5A32, loc_5A86-off_5A32, loc_5A76-off_5A32
; ---------------------------------------------------------------------------

locret_5A4C:
		rts
; ---------------------------------------------------------------------------

loc_5A4E:
		move.w	$32(a0),d0
		move.b	$26(a0),d1
		neg.b	d1
		addi.b	#$40,d1
		bra.s	loc_5A6A
; ---------------------------------------------------------------------------

loc_5A5E:
		move.w	$32(a0),d0
		move.b	$26(a0),d1
		subi.b	#$40,d1

loc_5A6A:
		ext.w	d1
		add.w	d1,d0
		move.w	d0,8(a0)
		bra.w	loc_5BA8
; ---------------------------------------------------------------------------

loc_5A76:
		move.w	$34(a0),d0
		move.b	(oscValues+$E).w,d1
		neg.b	d1
		addi.b	#$30,d1
		bra.s	loc_5AB0
; ---------------------------------------------------------------------------

loc_5A86:
		move.w	$34(a0),d0
		move.b	(oscValues+$E).w,d1
		subi.b	#$30,d1
		bra.s	loc_5AB0
; ---------------------------------------------------------------------------

loc_5A94:
		move.w	$34(a0),d0
		move.b	$26(a0),d1
		neg.b	d1
		addi.b	#$40,d1
		bra.s	loc_5AB0
; ---------------------------------------------------------------------------

loc_5AA4:
		move.w	$34(a0),d0
		move.b	$26(a0),d1
		subi.b	#$40,d1

loc_5AB0:
		ext.w	d1
		add.w	d1,d0
		move.w	d0,$2C(a0)
		bra.w	loc_5BA8
; ---------------------------------------------------------------------------

loc_5ABC:
		tst.w	$3A(a0)
		bne.s	loc_5AD2
		btst	#3,$22(a0)
		beq.s	locret_5AD0
		move.w	#$1E,$3A(a0)

locret_5AD0:
		rts
; ---------------------------------------------------------------------------

loc_5AD2:
		subq.w	#1,$3A(a0)
		bne.s	locret_5AD0
		move.w	#$20,$3A(a0)
		addq.b	#1,$28(a0)
		rts
; ---------------------------------------------------------------------------

loc_5AE4:
		tst.w	$3A(a0)
		beq.s	loc_5B20
		subq.w	#1,$3A(a0)
		bne.s	loc_5B20
		btst	#3,$22(a0)
		beq.s	loc_5B1A
		bset	#1,$22(a1)
		bclr	#3,$22(a1)
		move.b	#2,$24(a1)
		bclr	#3,$22(a0)
		clr.b	$25(a0)
		move.w	$12(a0),$12(a1)

loc_5B1A:
		move.b	#8,$24(a0)

loc_5B20:
		move.l	$2C(a0),d3
		move.w	$12(a0),d0
		ext.l	d0
		asl.l	#8,d0
		add.l	d0,d3
		move.l	d3,$2C(a0)
		addi.w	#$38,$12(a0)
		move.w	(unk_FFF72E).w,d0
		addi.w	#$E0,d0
		cmp.w	$2C(a0),d0
		bcc.s	locret_5B4C
		move.b	#6,$24(a0)

locret_5B4C:
		rts
; ---------------------------------------------------------------------------

loc_5B4E:
		tst.w	$3A(a0)
		bne.s	loc_5B6E
		lea	(unk_FFF7E0).w,a2
		moveq	#0,d0
		move.b	$28(a0),d0
		lsr.w	#4,d0
		tst.b	(a2,d0.w)
		beq.s	locret_5B6C
		move.w	#$3C,$3A(a0)

locret_5B6C:
		rts
; ---------------------------------------------------------------------------

loc_5B6E:
		subq.w	#1,$3A(a0)
		bne.s	locret_5B6C
		addq.b	#1,$28(a0)
		rts
; ---------------------------------------------------------------------------

loc_5B7A:
		subq.w	#2,$2C(a0)
		move.w	$34(a0),d0
		subi.w	#$200,d0
		cmp.w	$2C(a0),d0
		bne.s	locret_5B90
		clr.b	$28(a0)

locret_5B90:
		rts
; ---------------------------------------------------------------------------

loc_5B92:
		move.w	$34(a0),d0
		move.b	$26(a0),d1
		subi.b	#$40,d1
		ext.w	d1
		asr.w	#1,d1
		add.w	d1,d0
		move.w	d0,$2C(a0)

loc_5BA8:
		move.b	(oscValues+$1A).w,$26(a0)
		rts
; ---------------------------------------------------------------------------

loc_5BB0:
		move.w	$32(a0),d0
		andi.w	#$FF80,d0
		move.w	(v_screenposx).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0
		cmpi.w	#$280,d0
		bhi.s	loc_5BCE
		rts
; ---------------------------------------------------------------------------

loc_5BCE:
		bra.w	DeleteObject
; ---------------------------------------------------------------------------
		include "_maps\05BD2.asm"
		include "levels\shared\Platform\1.map"
		include "levels\shared\Platform\2.map"
		include "levels\shared\Platform\3.map"
		even
; ---------------------------------------------------------------------------

ObjRollingBall:
		moveq	#0,d0
		move.b	$24(a0),d0
		move.w	off_5C8E(pc,d0.w),d1
		jmp	off_5C8E(pc,d1.w)
; ---------------------------------------------------------------------------

off_5C8E:	dc.w loc_5C98-off_5C8E, loc_5D2C-off_5C8E, loc_5D86-off_5C8E, loc_5E4A-off_5C8E, loc_5CEE-off_5C8E
; ---------------------------------------------------------------------------

loc_5C98:
		move.b	#$18,$16(a0)
		move.b	#$C,$17(a0)
		bsr.w	ObjectFall
		jsr	(ObjectHitFloor).l
		tst.w	d1
		bpl.s	locret_5CEC
		add.w	d1,$C(a0)
		move.w	#0,$12(a0)
		move.b	#8,$24(a0)
		move.l	#MapRollingBall,4(a0)
		move.w	#$43AA,2(a0)
		move.b	#4,1(a0)
		move.b	#3,$19(a0)
		move.b	#$18,$18(a0)
		move.b	#1,$1F(a0)
		bsr.w	sub_5DC8

locret_5CEC:
		rts
; ---------------------------------------------------------------------------

loc_5CEE:
		move.w	#$23,d1
		move.w	#$18,d2
		move.w	#$18,d3
		move.w	8(a0),d4
		bsr.w	SolidObject
		btst	#5,$22(a0)
		bne.s	loc_5D14
		move.w	(v_objspace+8).w,d0
		sub.w	8(a0),d0
		bcs.s	loc_5D20

loc_5D14:
		move.b	#2,$24(a0)
		move.w	#$80,$14(a0)

loc_5D20:
		bsr.w	sub_5DC8
		bsr.w	DisplaySprite
		bra.w	loc_5E2A
; ---------------------------------------------------------------------------

loc_5D2C:
		btst	#1,$22(a0)
		bne.w	loc_5D86
		bsr.w	sub_5DC8
		bsr.w	sub_5E50
		bsr.w	SpeedToPos
		move.w	#$23,d1
		move.w	#$18,d2
		move.w	#$18,d3
		move.w	8(a0),d4
		bsr.w	SolidObject
		jsr	(Sonic_AnglePosition).l
		cmpi.w	#$20,8(a0)
		bcc.s	loc_5D70
		move.w	#$20,8(a0)
		move.w	#$400,$14(a0)

loc_5D70:
		btst	#1,$22(a0)
		beq.s	loc_5D7E
		move.w	#$FC00,$12(a0)

loc_5D7E:
		bsr.w	DisplaySprite
		bra.w	loc_5E2A
; ---------------------------------------------------------------------------

loc_5D86:
		bsr.w	sub_5DC8
		bsr.w	SpeedToPos
		move.w	#$23,d1
		move.w	#$18,d2
		move.w	#$18,d3
		move.w	8(a0),d4
		bsr.w	SolidObject
		jsr	(Sonic_Floor).l
		btst	#1,$22(a0)
		beq.s	loc_5DBE
		move.w	$12(a0),d0
		addi.w	#$28,d0
		move.w	d0,$12(a0)
		bra.s	loc_5DC0
; ---------------------------------------------------------------------------

loc_5DBE:
		nop

loc_5DC0:
		bsr.w	DisplaySprite
		bra.w	loc_5E2A
; ---------------------------------------------------------------------------

sub_5DC8:
		tst.b	$1A(a0)
		beq.s	loc_5DD6
		move.b	#0,$1A(a0)
		rts
; ---------------------------------------------------------------------------

loc_5DD6:
		move.b	$14(a0),d0
		beq.s	loc_5E02
		bmi.s	loc_5E0A
		subq.b	#1,$1E(a0)
		bpl.s	loc_5E02
		neg.b	d0
		addq.b	#8,d0
		bcs.s	loc_5DEC
		moveq	#0,d0

loc_5DEC:
		move.b	d0,$1E(a0)
		move.b	$1F(a0),d0
		addq.b	#1,d0
		cmpi.b	#4,d0
		bne.s	loc_5DFE
		moveq	#1,d0

loc_5DFE:
		move.b	d0,$1F(a0)

loc_5E02:
		move.b	$1F(a0),$1A(a0)
		rts
; ---------------------------------------------------------------------------

loc_5E0A:
		subq.b	#1,$1E(a0)
		bpl.s	loc_5E02
		addq.b	#8,d0
		bcs.s	loc_5E16
		moveq	#0,d0

loc_5E16:
		move.b	d0,$1E(a0)
		move.b	$1F(a0),d0
		subq.b	#1,d0
		bne.s	loc_5E24
		moveq	#3,d0

loc_5E24:
		move.b	d0,$1F(a0)
		bra.s	loc_5E02
; ---------------------------------------------------------------------------

loc_5E2A:
		move.w	8(a0),d0
		andi.w	#$FF80,d0
		move.w	(v_screenposx).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0
		cmpi.w	#$280,d0
		bhi.w	DeleteObject
		rts
; ---------------------------------------------------------------------------

loc_5E4A:
		bsr.w	DeleteObject
		rts
; ---------------------------------------------------------------------------

sub_5E50:
		move.b	$26(a0),d0
		bsr.w	GetSine
		move.w	d0,d2
		muls.w	#$38,d2
		asr.l	#8,d2
		add.w	d2,$14(a0)
		muls.w	$14(a0),d1
		asr.l	#8,d1
		move.w	d1,$10(a0)
		muls.w	$14(a0),d0
		asr.l	#8,d0
		move.w	d0,$12(a0)
		rts
; ---------------------------------------------------------------------------
		include "levels\GHZ\RollingBall\Sprite.map"
		even
; ---------------------------------------------------------------------------

ObjCollapsePtfm:
		moveq	#0,d0
		move.b	$24(a0),d0
		move.w	off_5EEE(pc,d0.w),d1
		jmp	off_5EEE(pc,d1.w)
; ---------------------------------------------------------------------------

off_5EEE:	dc.w loc_5EFA-off_5EEE, loc_5F2A-off_5EEE, loc_5F4E-off_5EEE, loc_5F7E-off_5EEE, loc_5FDE-off_5EEE
		dc.w sub_5F60-off_5EEE
; ---------------------------------------------------------------------------

loc_5EFA:
		addq.b	#2,$24(a0)
		move.l	#MapCollapsePtfm,4(a0)
		move.w	#$4000,2(a0)
		ori.b	#4,1(a0)
		move.b	#4,$19(a0)
		move.b	#7,$38(a0)
		move.b	#$64,$18(a0)
		move.b	$28(a0),$1A(a0)

loc_5F2A:
		tst.b	$3A(a0)
		beq.s	loc_5F3C
		tst.b	$38(a0)
		beq.w	loc_612A
		subq.b	#1,$38(a0)

loc_5F3C:
		move.w	#$30,d1
		lea	(ObjCollapsePtfm_Slope).l,a2
		bsr.w	PtfmSloped
		bra.w	ObjectChkDespawn
; ---------------------------------------------------------------------------

loc_5F4E:
		tst.b	$38(a0)
		beq.w	loc_6130
		move.b	#1,$3A(a0)
		subq.b	#1,$38(a0)
; ---------------------------------------------------------------------------

sub_5F60:
		move.w	#$30,d1
		bsr.w	PtfmCheckExit
		move.w	#$30,d1
		lea	(ObjCollapsePtfm_Slope).l,a2
		move.w	8(a0),d2
		bsr.w	sub_61E0
		bra.w	ObjectChkDespawn
; ---------------------------------------------------------------------------

loc_5F7E:
		tst.b	$38(a0)
		beq.s	loc_5FCE
		tst.b	$3A(a0)
		bne.w	loc_5F94
		subq.b	#1,$38(a0)
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

loc_5F94:
		subq.b	#1,$38(a0)
		bsr.w	sub_5F60
		lea	(v_objspace).w,a1
		btst	#3,$22(a1)
		beq.s	loc_5FC0
		tst.b	$38(a0)
		bne.s	locret_5FCC
		bclr	#3,$22(a1)
		bclr	#5,$22(a1)
		move.b	#1,$1D(a1)

loc_5FC0:
		move.b	#0,$3A(a0)
		move.b	#6,$24(a0)

locret_5FCC:
		rts
; ---------------------------------------------------------------------------

loc_5FCE:
		bsr.w	ObjectFall
		bsr.w	DisplaySprite
		tst.b	1(a0)
		bpl.s	loc_5FDE
		rts
; ---------------------------------------------------------------------------

loc_5FDE:
		bsr.w	DeleteObject
		rts
; ---------------------------------------------------------------------------

ObjCollapseFloor:
		moveq	#0,d0
		move.b	$24(a0),d0
		move.w	off_5FF2(pc,d0.w),d1
		jmp	off_5FF2(pc,d1.w)
; ---------------------------------------------------------------------------

off_5FF2:	dc.w loc_5FFE-off_5FF2, loc_603A-off_5FF2, loc_607C-off_5FF2, loc_60A2-off_5FF2, loc_6102-off_5FF2
		dc.w sub_608E-off_5FF2
; ---------------------------------------------------------------------------

loc_5FFE:
		addq.b	#2,$24(a0)
		move.l	#MapCollapseFloor,4(a0)
		move.w	#$42B8,2(a0)
		cmpi.b	#3,(v_zone).w
		bne.s	loc_6022
		move.w	#$44E0,2(a0)
		addq.b	#2,$1A(a0)

loc_6022:
		ori.b	#4,1(a0)
		move.b	#4,$19(a0)
		move.b	#7,$38(a0)
		move.b	#$44,$18(a0)

loc_603A:
		tst.b	$3A(a0)
		beq.s	loc_604C
		tst.b	$38(a0)
		beq.w	loc_6108
		subq.b	#1,$38(a0)

loc_604C:
		move.w	#$20,d1
		bsr.w	PtfmNormal
		tst.b	$28(a0)
		bpl.s	loc_6078
		btst	#3,$22(a1)
		beq.s	loc_6078
		bclr	#0,1(a0)
		move.w	8(a1),d0
		sub.w	8(a0),d0
		bcc.s	loc_6078
		bset	#0,1(a0)

loc_6078:
		bra.w	ObjectChkDespawn
; ---------------------------------------------------------------------------

loc_607C:
		tst.b	$38(a0)
		beq.w	loc_610E
		move.b	#1,$3A(a0)
		subq.b	#1,$38(a0)
; ---------------------------------------------------------------------------

sub_608E:
		move.w	#$20,d1
		bsr.w	PtfmCheckExit
		move.w	8(a0),d2
		bsr.w	ptfmSurfaceNormal
		bra.w	ObjectChkDespawn
; ---------------------------------------------------------------------------

loc_60A2:
		tst.b	$38(a0)
		beq.s	loc_60F2
		tst.b	$3A(a0)
		bne.w	loc_60B8
		subq.b	#1,$38(a0)
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

loc_60B8:
		subq.b	#1,$38(a0)
		bsr.w	sub_608E
		lea	(v_objspace).w,a1
		btst	#3,$22(a1)
		beq.s	loc_60E4
		tst.b	$38(a0)
		bne.s	locret_60F0
		bclr	#3,$22(a1)
		bclr	#5,$22(a1)
		move.b	#1,$1D(a1)

loc_60E4:
		move.b	#0,$3A(a0)
		move.b	#6,$24(a0)

locret_60F0:
		rts
; ---------------------------------------------------------------------------

loc_60F2:
		bsr.w	ObjectFall
		bsr.w	DisplaySprite
		tst.b	1(a0)
		bpl.s	loc_6102
		rts
; ---------------------------------------------------------------------------

loc_6102:
		bsr.w	DeleteObject
		rts
; ---------------------------------------------------------------------------

loc_6108:
		move.b	#0,$3A(a0)

loc_610E:
		lea	(ObjCollapseFloor_Delay2).l,a4
		btst	#0,$28(a0)
		beq.s	loc_6122
		lea	(ObjCollapseFloor_Delay3).l,a4

loc_6122:
		moveq	#7,d1
		addq.b	#1,$1A(a0)
		bra.s	loc_613C
; ---------------------------------------------------------------------------

loc_612A:
		move.b	#0,$3A(a0)

loc_6130:
		lea	(ObjCollapseFloor_Delay1).l,a4
		moveq	#$18,d1
		addq.b	#2,$1A(a0)

loc_613C:
		moveq	#0,d0
		move.b	$1A(a0),d0
		add.w	d0,d0
		movea.l	4(a0),a3
		adda.w	(a3,d0.w),a3
		addq.w	#1,a3
		bset	#5,1(a0)
		move.b	0(a0),d4
		move.b	1(a0),d5
		movea.l	a0,a1
		bra.s	loc_6168
; ---------------------------------------------------------------------------

loc_6160:
		bsr.w	ObjectLoad
		bne.s	loc_61A8
		addq.w	#5,a3

loc_6168:
		move.b	#6,$24(a1)
		move.b	d4,0(a1)
		move.l	a3,4(a1)
		move.b	d5,1(a1)
		move.w	8(a0),8(a1)
		move.w	$C(a0),$C(a1)
		move.w	2(a0),2(a1)
		move.b	$19(a0),$19(a1)
		move.b	$18(a0),$18(a1)
		move.b	(a4)+,$38(a1)
		cmpa.l	a0,a1
		bcc.s	loc_61A4
		bsr.w	DisplaySprite1

loc_61A4:
		dbf	d1,loc_6160

loc_61A8:
		bsr.w	DisplaySprite
		move.w	#sfx_Collapse,d0
		jmp	(PlaySFX).l
; ---------------------------------------------------------------------------

ObjCollapseFloor_Delay1:dc.b $1C, $18, $14, $10, $1A, $16, $12, $E, $A, 6, $18
		dc.b $14, $10, $C, 8, 4, $16, $12, $E, $A, 6, 2, $14, $10
		dc.b $C, 0

ObjCollapseFloor_Delay2:dc.b $1E, $16, $E, 6, $1A, $12, $A, 2

ObjCollapseFloor_Delay3:dc.b $16, $1E, $1A, $12, 6, $E, $A, 2
; ---------------------------------------------------------------------------

sub_61E0:
		lea	(v_objspace).w,a1
		btst	#3,$22(a1)
		beq.s	locret_6224
		move.w	8(a1),d0
		sub.w	8(a0),d0
		add.w	d1,d0
		lsr.w	#1,d0
		btst	#0,1(a0)
		beq.s	loc_6204
		not.w	d0
		add.w	d1,d0

loc_6204:
		moveq	#0,d1
		move.b	(a2,d0.w),d1
		move.w	$C(a0),d0
		sub.w	d1,d0
		moveq	#0,d1
		move.b	$16(a1),d1
		sub.w	d1,d0
		move.w	d0,$C(a1)
		sub.w	8(a0),d2
		sub.w	d2,8(a1)

locret_6224:
		rts
; ---------------------------------------------------------------------------

ObjCollapsePtfm_Slope:dc.b $20, $20, $20, $20, $20, $20, $20, $20, $21, $21
		dc.b $22, $22, $23, $23, $24, $24, $25, $25, $26, $26
		dc.b $27, $27, $28, $28, $29, $29, $2A, $2A, $2B, $2B
		dc.b $2C, $2C, $2D, $2D, $2E, $2E, $2F, $2F, $30, $30
		dc.b $30, $30, $30, $30, $30, $30, $30, $30
		include "_maps\06526.asm"
		include "levels\GHZ\CollapsePtfm\Sprite.map"
		include "levels\GHZ\CollapseFloor\Sprite.map"
		even
; ---------------------------------------------------------------------------

Obj1B:
		moveq	#0,d0
		move.b	act(a0),d0
		move.w	off_6634(pc,d0.w),d1
		jmp	off_6634(pc,d1.w)
; ---------------------------------------------------------------------------

off_6634:	dc.w loc_663E-off_6634, loc_6676-off_6634, loc_668A-off_6634, loc_66CE-off_6634, loc_66D6-off_6634
; ---------------------------------------------------------------------------

loc_663E:
		addq.b	#2,act(a0)
		move.l	#Map1B,map(a0)
		move.w	#$4000,tile(a0)
		move.b	#4,render(a0)
		move.b	#$20,xdisp(a0)
		move.b	#5,$19(a0)
		tst.b	arg(a0)
		bne.s	loc_6676
		move.b	#1,prio(a0)
		move.b	#6,act(a0)
		rts
; ---------------------------------------------------------------------------

loc_6676:
		move.w	#$20,d1
		move.w	#-$14,d3
		bsr.w	PtfmNormalHeight
		bsr.w	DisplaySprite
		bra.w	loc_66A8
; ---------------------------------------------------------------------------

loc_668A:
		move.w	#$20,d1
		bsr.w	PtfmCheckExit
		move.w	8(a0),d2
		move.w	#-$14,d3
		bsr.w	PtfmSurfaceHeight
		bsr.w	DisplaySprite
		bra.w	loc_66A8
; ---------------------------------------------------------------------------
		rts
; ---------------------------------------------------------------------------

loc_66A8:
		move.w	xpos(a0),d0
		andi.w	#$FF80,d0
		move.w	(v_screenposx).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0
		cmpi.w	#640,d0
		bhi.w	loc_66C8
		rts
; ---------------------------------------------------------------------------

loc_66C8:
		bsr.w	DeleteObject
		rts
; ---------------------------------------------------------------------------

loc_66CE:
		bsr.w	DisplaySprite
		bra.w	loc_66A8
; ---------------------------------------------------------------------------

loc_66D6:
		bsr.w	DeleteObject
		rts
; ---------------------------------------------------------------------------

Map1B:		dc.w byte_66E0-Map1B, byte_66F5-Map1B

byte_66E0:	dc.b 4
		dc.b $F0, $A, 0, $89, $E0
		dc.b $F0, $A, 8, $89, 8
		dc.b $F8, 5, 0, $92, $F8
		dc.b 8, $C, 0, $96, $F0

byte_66F5:	dc.b 4
		dc.b $E8, $F, 0, $9A, $E0
		dc.b $E8, $F, 8, $9A, 0
		dc.b 8, $D, 0, $AA, $E0
		dc.b 8, $D, 8, $AA, 0
; ---------------------------------------------------------------------------

ObjScenery:
		moveq	#0,d0
		move.b	act(a0),d0
		move.w	off_6718(pc,d0.w),d1
		jmp	off_6718(pc,d1.w)
; ---------------------------------------------------------------------------

off_6718:	dc.w ObjScenery_Init-off_6718, ObjScenery_Normal-off_6718, ObjScenery_Delete-off_6718, ObjScenery_Delete-off_6718
; ---------------------------------------------------------------------------

ObjScenery_Init:
		addq.b	#2,act(a0)
		moveq	#0,d0
		move.b	arg(a0),d0
		mulu.w	#10,d0
		lea	ObjScenery_Types(pc,d0.w),a1
		move.l	(a1)+,map(a0)
		move.w	(a1)+,tile(a0)
		ori.b	#4,render(a0)
		move.b	(a1)+,frame(a0)
		move.b	(a1)+,xdisp(a0)
		move.b	(a1)+,prio(a0)
		move.b	(a1)+,col(a0)

ObjScenery_Normal:
		bsr.w	DisplaySprite
		move.w	xpos(a0),d0
		andi.w	#$FF80,d0
		move.w	(v_screenposx).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0
		cmpi.w	#640,d0
		bhi.w	ObjScenery_Delete
		rts
; ---------------------------------------------------------------------------

ObjScenery_Delete:
		bsr.w	DeleteObject
		rts
; ---------------------------------------------------------------------------

ObjScenery_Types:dc.l MapScenery
		dc.w $398
		dc.b 0, $10, 4, $82
		dc.l MapScenery
		dc.w $398
		dc.b 1, $14, 4, $83
		dc.l MapScenery
		dc.w $4000
		dc.b 0, $20, 1, 0
		dc.l MapBridge
		dc.w $438E
		dc.b 1, $10, 1, 0
		include "levels\shared\Scenery\Sprite.map"
		even
; ---------------------------------------------------------------------------

ObjUnkSwitch:
		moveq	#0,d0
		move.b	act(a0),d0
		move.w	off_67C8(pc,d0.w),d1
		jmp	off_67C8(pc,d1.w)
; ---------------------------------------------------------------------------

off_67C8:	dc.w loc_67CE-off_67C8, loc_67F8-off_67C8, loc_6836-off_67C8
; ---------------------------------------------------------------------------

loc_67CE:
		addq.b	#2,act(a0)
		move.l	#MapUnkSwitch,map(a0)
		move.w	#$4000,tile(a0)
		move.b	#4,render(a0)
		move.w	ypos(a0),$30(a0)
		move.b	#$10,xdisp(a0)
		move.b	#5,prio(a0)

loc_67F8:
		move.w	$30(a0),ypos(a0)
		move.w	#$10,d1
		bsr.w	sub_683C
		beq.s	loc_6812
		addq.w	#2,ypos(a0)
		moveq	#1,d0
		move.w	d0,(unk_FFF7E0).w

loc_6812:
		bsr.w	DisplaySprite
		move.w	xpos(a0),d0
		andi.w	#$FF80,d0
		move.w	(v_screenposx).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0
		cmpi.w	#640,d0
		bhi.w	loc_6836
		rts
; ---------------------------------------------------------------------------

loc_6836:
		bsr.w	DeleteObject
		rts
; ---------------------------------------------------------------------------

sub_683C:
		lea	(v_objspace).w,a1
		move.w	xpos(a1),d0
		sub.w	xpos(a0),d0
		add.w	d1,d0
		bmi.s	loc_6874
		add.w	d1,d1
		cmp.w	d1,d0
		bcc.s	loc_6874
		move.w	ypos(a1),d2
		move.b	yrad(a1),d1
		ext.w	d1
		add.w	d2,d1
		move.w	ypos(a0),d0
		subi.w	#$10,d0
		sub.w	d1,d0
		bhi.s	loc_6874
		cmpi.w	#$FFF0,d0
		bcs.s	loc_6874
		moveq	#-1,d0
		rts
; ---------------------------------------------------------------------------

loc_6874:
		moveq	#0,d0
		rts
; ---------------------------------------------------------------------------
		include "_maps\Unknown Switch.asm"
		even
; ---------------------------------------------------------------------------

Obj2A:
		moveq	#0,d0
		move.b	act(a0),d0
		move.w	off_689E(pc,d0.w),d1
		jmp	off_689E(pc,d1.w)
; ---------------------------------------------------------------------------

off_689E:	dc.w loc_68A4-off_689E, loc_68F0-off_689E, loc_6912-off_689E
; ---------------------------------------------------------------------------

loc_68A4:
		addq.b	#2,act(a0)
		move.l	#Map2A,map(a0)
		move.w	#0,tile(a0)
		move.b	#4,render(a0)
		move.w	ypos(a0),d0
		subi.w	#$20,d0
		move.w	d0,$30(a0)
		move.b	#$B,xdisp(a0)
		move.b	#5,prio(a0)
		tst.b	arg(a0)
		beq.s	loc_68F0
		move.b	#1,frame(a0)
		move.w	#$4000,tile(a0)
		move.b	#4,prio(a0)
		addq.b	#2,act(a0)

loc_68F0:
		tst.w	(unk_FFF7E0).w
		beq.s	loc_6906
		subq.w	#1,ypos(a0)
		move.w	$30(a0),d0
		cmp.w	ypos(a0),d0
		beq.w	DeleteObject

loc_6906:
		move.w	#$16,d1
		move.w	#$10,d2
		bsr.w	sub_6936

loc_6912:
		bsr.w	DisplaySprite
		move.w	xpos(a0),d0
		andi.w	#$FF80,d0
		move.w	(v_screenposx).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0
		cmpi.w	#640,d0
		bhi.w	DeleteObject
		rts
; ---------------------------------------------------------------------------

sub_6936:
		tst.w	(DebugRoutine).w
		bne.w	locret_69A6
		cmpi.b	#6,(v_objspace+$24).w
		bcc.s	locret_69A6
		bsr.w	sub_69CE
		beq.s	loc_698C
		bmi.w	loc_69A8
		tst.w	d0
		beq.w	loc_6976
		bmi.s	loc_6960
		tst.w	xvel(a1)
		bmi.s	loc_6976
		bra.s	loc_6966
; ---------------------------------------------------------------------------

loc_6960:
		tst.w	xvel(a1)
		bpl.s	loc_6976

loc_6966:
		sub.w	d0,xpos(a1)
		move.w	#0,inertia(a1)
		move.w	#0,xvel(a1)

loc_6976:
		btst	#1,status(a1)
		bne.s	loc_699A
		bset	#5,status(a1)
		bset	#5,status(a0)
		rts
; ---------------------------------------------------------------------------

loc_698C:
		btst	#5,status(a0)
		beq.s	locret_69A6
		move.w	#1,ani(a1)

loc_699A:
		bclr	#5,status(a0)
		bclr	#5,status(a1)

locret_69A6:
		rts
; ---------------------------------------------------------------------------

loc_69A8:
		tst.w	yvel(a1)
		beq.s	loc_69C0
		bpl.s	locret_69BE
		tst.w	d3
		bpl.s	locret_69BE
		sub.w	d3,ypos(a1)
		move.w	#0,yvel(a1)

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

sub_69CE:
		lea	(v_objspace).w,a1
		move.w	xpos(a1),d0
		sub.w	xpos(a0),d0
		add.w	d1,d0
		bmi.s	loc_6A28
		move.w	d1,d3
		add.w	d3,d3
		cmp.w	d3,d0
		bhi.s	loc_6A28
		move.b	yrad(a1),d3
		ext.w	d3
		add.w	d3,d2
		move.w	ypos(a1),d3
		sub.w	ypos(a0),d3
		add.w	d2,d3
		bmi.s	loc_6A28
		move.w	d2,d4
		add.w	d4,d4
		cmp.w	d4,d3
		bcc.s	loc_6A28
		move.w	d0,d5
		cmp.w	d0,d1
		bcc.s	loc_6A10
		add.w	d1,d1
		sub.w	d1,d0
		move.w	d0,d5
		neg.w	d5

loc_6A10:
		move.w	d3,d1
		cmp.w	d3,d2
		bcc.s	loc_6A1C
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
		include "_maps\2A.asm"
		even
; ---------------------------------------------------------------------------

ObjTitleSonic:
		moveq	#0,d0
		move.b	act(a0),d0
		move.w	off_6A64(pc,d0.w),d1
		jmp	off_6A64(pc,d1.w)
; ---------------------------------------------------------------------------

off_6A64:	dc.w loc_6A6C-off_6A64, loc_6AA0-off_6A64, loc_6AB0-off_6A64, loc_6AC6-off_6A64
; ---------------------------------------------------------------------------

loc_6A6C:
		addq.b	#2,act(a0)
		move.w	#$F0,xpos(a0)
		move.w	#$DE,xpix(a0)
		move.l	#MapTitleSonic,map(a0)
		move.w	#$2300,tile(a0)
		move.b	#1,prio(a0)
		move.b	#$1D,$1F(a0)
		lea	(AniTitleSonic).l,a1
		bsr.w	ObjectAnimate

loc_6AA0:
		subq.b	#1,$1F(a0)
		bpl.s	locret_6AAE
		addq.b	#2,act(a0)
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

locret_6AAE:
		rts
; ---------------------------------------------------------------------------

loc_6AB0:
		subq.w	#8,xpix(a0)
		cmpi.w	#$96,xpix(a0)
		bne.s	loc_6AC0
		addq.b	#2,act(a0)

loc_6AC0:
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------
		rts
; ---------------------------------------------------------------------------

loc_6AC6:
		lea	(AniTitleSonic).l,a1
		bsr.w	ObjectAnimate
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------
		rts
; ---------------------------------------------------------------------------

ObjTitleText:
		moveq	#0,d0
		move.b	act(a0),d0
		move.w	off_6AE8(pc,d0.w),d1
		jsr	off_6AE8(pc,d1.w)
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

off_6AE8:	dc.w loc_6AEE-off_6AE8, loc_6B1A-off_6AE8, locret_6B18-off_6AE8
; ---------------------------------------------------------------------------

loc_6AEE:
		addq.b	#2,act(a0)
		move.w	#$D0,xpos(a0)
		move.w	#$130,xpix(a0)
		move.l	#MapTitleText,map(a0)
		move.w	#$200,tile(a0)
		cmpi.b	#2,frame(a0)
		bne.s	loc_6B1A
		addq.b	#2,act(a0)

locret_6B18:
		rts
; ---------------------------------------------------------------------------

loc_6B1A:
		lea	(AniTitleText).l,a1
		bra.w	ObjectAnimate
; ---------------------------------------------------------------------------
		include "screens\title\TitleSonic\Sprite.ani"
		include "screens\title\TitleText\Sprite.ani"
; ---------------------------------------------------------------------------

ObjectAnimate:
		moveq	#0,d0
		move.b	ani(a0),d0
		cmp.b	anilast(a0),d0
		beq.s	loc_6B54
		move.b	d0,anilast(a0)
		move.b	#0,anipos(a0)
		move.b	#0,anidelay(a0)

loc_6B54:
		add.w	d0,d0
		adda.w	(a1,d0.w),a1
		subq.b	#1,anidelay(a0)
		bpl.s	locret_6B94
		move.b	(a1),anidelay(a0)
		moveq	#0,d1
		move.b	anipos(a0),d1
		move.b	1(a1,d1.w),d0
		bmi.s	loc_6B96

loc_6B70:
		move.b	d0,d1
		andi.b	#$1F,d0
		move.b	d0,frame(a0)
		move.b	status(a0),d0
		andi.b	#3,d0
		andi.b	#$FC,render(a0)
		lsr.b	#5,d1
		eor.b	d0,d1
		or.b	d1,render(a0)
		addq.b	#1,anipos(a0)

locret_6B94:
		rts
; ---------------------------------------------------------------------------

loc_6B96:
		addq.b	#1,d0
		bne.s	loc_6BA6
		move.b	#0,anipos(a0)
		move.b	render(a1),d0
		bra.s	loc_6B70
; ---------------------------------------------------------------------------

loc_6BA6:
		addq.b	#1,d0
		bne.s	loc_6BBA
		move.b	2(a1,d1.w),d0
		sub.b	d0,anipos(a0)
		sub.b	d0,d1
		move.b	1(a1,d1.w),d0
		bra.s	loc_6B70
; ---------------------------------------------------------------------------

loc_6BBA:
		addq.b	#1,d0
		bne.s	loc_6BC4
		move.b	2(a1,d1.w),ani(a0)

loc_6BC4:
		addq.b	#1,d0
		bne.s	loc_6BCC
		addq.b	#2,act(a0)

loc_6BCC:
		addq.b	#1,d0
		bne.s	locret_6BDA
		move.b	#0,anipos(a0)
		clr.b	subact(a0)

locret_6BDA:
		rts
; ---------------------------------------------------------------------------
		include "screens\title\TitleText\Sprite.map"
		include "screens\title\TitleSonic\Sprite.map"

                include "_incObj\1E Ballhog.asm"
                include "_incObj\20 Ballhog's Bomb.asm"
                include "_incObj\24 Ballhog's Bomb Explosion.asm"
; ---------------------------------------------------------------------------

ObjExplode:
		moveq	#0,d0
		move.b	act(a0),d0
		move.w	off_7172(pc,d0.w),d1
		jmp	off_7172(pc,d1.w)
; ---------------------------------------------------------------------------

off_7172:	dc.w ObjExplode_Load-off_7172, ObjExplode_Init-off_7172, ObjExplode_Act-off_7172
; ---------------------------------------------------------------------------

ObjExplode_Load:
		addq.b	#2,act(a0)
		bsr.w	ObjectLoad
		bne.s	ObjExplode_Init
		move.b	#$28,id(a1)
		move.w	xpos(a0),xpos(a1)
		move.w	ypos(a0),ypos(a1)

ObjExplode_Init:
		addq.b	#2,act(a0)
		move.l	#MapExplode,map(a0)
		move.w	#$5A0,tile(a0)
		move.b	#4,render(a0)
		move.b	#2,prio(a0)
		move.b	#0,col(a0)
		move.b	#12,xdisp(a0)
		move.b	#7,anidelay(a0)
		move.b	#0,frame(a0)
		move.w	#sfx_BreakItem,d0
		jsr	(PlaySFX).l

ObjExplode_Act:
		subq.b	#1,anidelay(a0)
		bpl.s	.display
		move.b	#7,anidelay(a0)
		addq.b	#1,frame(a0)
		cmpi.b	#5,frame(a0)
		beq.w	DeleteObject

.display:
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

ObjBombExplode:
		moveq	#0,d0
		move.b	act(a0),d0
		move.w	off_7200(pc,d0.w),d1
		jmp	off_7200(pc,d1.w)
; ---------------------------------------------------------------------------

off_7200:	dc.w ObjBomb_Init-off_7200, ObjExplode_Act-off_7200
; ---------------------------------------------------------------------------

ObjBomb_Init:
		addq.b	#2,act(a0)
		move.l	#MapBombExplode,map(a0)
		move.w	#$5A0,tile(a0)
		move.b	#4,render(a0)
		move.b	#2,prio(a0)
		move.b	#0,col(a0)
		move.b	#$C,xdisp(a0)
		move.b	#7,anidelay(a0)
		move.b	#0,frame(a0)
		move.w	#sfx_Bomb,d0
		jmp	(PlaySFX).l
; ---------------------------------------------------------------------------
		include "_anim\BallHog.asm"
		include "_maps\BallHog.asm"
		include "_maps\BallHog's Bomb.asm"
		include "_maps\BallHog's Bomb Explosion.asm"
		include "levels\shared\Explosion\Sprite.map"
		include "levels\shared\Explosion\Bomb.map"
; ---------------------------------------------------------------------------

ObjAnimals:
		moveq	#0,d0
		move.b	act(a0),d0
		move.w	off_732C(pc,d0.w),d1
		jmp	off_732C(pc,d1.w)
; ---------------------------------------------------------------------------

off_732C:	dc.w loc_7382-off_732C, loc_7418-off_732C, loc_7472-off_732C, loc_74A8-off_732C, loc_7472-off_732C
		dc.w loc_7472-off_732C, loc_7472-off_732C, loc_74A8-off_732C, loc_7472-off_732C

byte_733E:	dc.b 0, 1, 2, 3, 4, 5, 6, 3, 4, 1, 0, 5

word_734A:	dc.w $FE00, $FC00
		dc.l MapAnimals1
		dc.w $FE00, $FD00
		dc.l MapAnimals2
		dc.w $FEC0, $FE00
		dc.l MapAnimals1
		dc.w $FF00, $FE80
		dc.l MapAnimals2
		dc.w $FE80, $FD00
		dc.l MapAnimals3
		dc.w $FD00, $FC00
		dc.l MapAnimals2
		dc.w $FD80, $FC80
		dc.l MapAnimals3
; ---------------------------------------------------------------------------

loc_7382:
		addq.b	#2,act(a0)
		bsr.w	RandomNumber
		andi.w	#1,d0
		moveq	#0,d1
		move.b	(v_zone).w,d1
		add.w	d1,d1
		add.w	d0,d1
		move.b	byte_733E(pc,d1.w),d0
		move.b	d0,$30(a0)
		lsl.w	#3,d0
		lea	word_734A(pc,d0.w),a1
		move.w	(a1)+,$32(a0)
		move.w	(a1)+,$34(a0)
		move.l	(a1)+,map(a0)
		move.w	#$580,tile(a0)
		btst	#0,$30(a0)
		beq.s	loc_73C6
		move.w	#$592,tile(a0)

loc_73C6:
		move.b	#$C,yrad(a0)
		move.b	#4,render(a0)
		bset	#0,render(a0)
		move.b	#6,prio(a0)
		move.b	#8,xdisp(a0)
		move.b	#7,anidelay(a0)
		move.b	#2,frame(a0)
		move.w	#-$400,yvel(a0)
		tst.b	(unk_FFF7A7).w
		bne.s	loc_7438
		bsr.w	ObjectLoad
		bne.s	loc_7414
		move.b	#$29,id(a1)
		move.w	xpos(a0),xpos(a1)
		move.w	ypos(a0),ypos(a1)

loc_7414:
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

loc_7418:
		tst.b	render(a0)
		bpl.w	DeleteObject
		bsr.w	ObjectFall
		tst.w	yvel(a0)
		bmi.s	loc_746E
		jsr	(ObjectHitFloor).l
		tst.w	d1
		bpl.s	loc_746E
		add.w	d1,ypos(a0)

loc_7438:
		move.w	$32(a0),xvel(a0)
		move.w	$34(a0),yvel(a0)
		move.b	#1,frame(a0)
		move.b	$30(a0),d0
		add.b	d0,d0
		addq.b	#4,d0
		move.b	d0,act(a0)
		tst.b	(unk_FFF7A7).w
		beq.s	loc_746E
		btst	#4,(byte_FFFE0F).w
		beq.s	loc_746E
		neg.w	xvel(a0)
		bchg	#0,render(a0)

loc_746E:
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

loc_7472:
		bsr.w	ObjectFall
		move.b	#1,frame(a0)
		tst.w	yvel(a0)
		bmi.s	loc_749C
		move.b	#0,frame(a0)
		jsr	(ObjectHitFloor).l
		tst.w	d1
		bpl.s	loc_749C
		add.w	d1,ypos(a0)
		move.w	$34(a0),yvel(a0)

loc_749C:
		tst.b	render(a0)
		bpl.w	DeleteObject
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

loc_74A8:
		bsr.w	SpeedToPos
		addi.w	#$18,yvel(a0)
		tst.w	yvel(a0)
		bmi.s	loc_74CC
		jsr	(ObjectHitFloor).l
		tst.w	d1
		bpl.s	loc_74CC
		add.w	d1,ypos(a0)
		move.w	$34(a0),yvel(a0)

loc_74CC:
		subq.b	#1,anidelay(a0)
		bpl.s	loc_74E2
		move.b	#1,anidelay(a0)
		addq.b	#1,frame(a0)
		andi.b	#1,frame(a0)

loc_74E2:
		tst.b	render(a0)
		bpl.w	DeleteObject
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

ObjPoints:
		moveq	#0,d0
		move.b	act(a0),d0
		move.w	off_7500(pc,d0.w),d1
		jsr	off_7500(pc,d1.w)
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

off_7500:	dc.w ObjPoints_Init-off_7500, ObjPoints_Act-off_7500
; ---------------------------------------------------------------------------

ObjPoints_Init:
		addq.b	#2,act(a0)
		move.l	#MapPoints,map(a0)
		move.w	#$2797,tile(a0)
		move.b	#4,render(a0)
		move.b	#1,prio(a0)
		move.b	#8,xdisp(a0)
		move.w	#-$300,yvel(a0)

ObjPoints_Act:
		tst.w	yvel(a0)
		bpl.w	DeleteObject
		bsr.w	SpeedToPos
		addi.w	#$18,yvel(a0)
		rts
; ---------------------------------------------------------------------------
		include "levels\shared\Animals\1.map"
		include "levels\shared\Animals\2.map"
		include "levels\shared\Animals\3.map"
		include "levels\shared\Points\Sprite.map"
		even
; ---------------------------------------------------------------------------

ObjCrabmeat:
		moveq	#0,d0
		move.b	$24(a0),d0
		move.w	off_75B8(pc,d0.w),d1
		jmp	off_75B8(pc,d1.w)
; ---------------------------------------------------------------------------

off_75B8:	dc.w loc_75C2-off_75B8, loc_7616-off_75B8, loc_7772-off_75B8, loc_7778-off_75B8, loc_77AE-off_75B8
; ---------------------------------------------------------------------------

loc_75C2:
		move.b	#$10,$16(a0)
		move.b	#8,$17(a0)
		move.l	#MapCrabmeat,4(a0)
		move.w	#$400,2(a0)
		move.b	#4,1(a0)
		move.b	#3,$19(a0)
		move.b	#6,$20(a0)
		move.b	#$15,$18(a0)
		bsr.w	ObjectFall
		jsr	(ObjectHitFloor).l
		tst.w	d1
		bpl.s	locret_7614
		add.w	d1,$C(a0)
		move.b	d3,$26(a0)
		move.w	#0,$12(a0)
		addq.b	#2,$24(a0)

locret_7614:
		rts
; ---------------------------------------------------------------------------

loc_7616:
		moveq	#0,d0
		move.b	$25(a0),d0
		move.w	off_7632(pc,d0.w),d1
		jsr	off_7632(pc,d1.w)
		lea	(AniCrabmeat).l,a1
		bsr.w	ObjectAnimate
		bra.w	ObjectChkDespawn
; ---------------------------------------------------------------------------

off_7632:	dc.w loc_7636-off_7632, loc_76D4-off_7632
; ---------------------------------------------------------------------------

loc_7636:
		subq.w	#1,$30(a0)
		bpl.s	locret_7670
		tst.b	1(a0)
		bpl.s	loc_764A
		bchg	#1,$32(a0)
		bne.s	loc_7672

loc_764A:
		addq.b	#2,$25(a0)
		move.w	#$7F,$30(a0)
		move.w	#$80,$10(a0)
		bsr.w	sub_7742
		addq.b	#3,d0
		move.b	d0,$1C(a0)
		bchg	#0,$22(a0)
		bne.s	locret_7670
		neg.w	$10(a0)

locret_7670:
		rts
; ---------------------------------------------------------------------------

loc_7672:
		move.w	#$3B,$30(a0)
		move.b	#6,$1C(a0)
		bsr.w	ObjectLoad
		bne.s	loc_76A8
		move.b	#$1F,0(a1)
		move.b	#6,$24(a1)
		move.w	8(a0),8(a1)
		subi.w	#$10,8(a1)
		move.w	$C(a0),$C(a1)
		move.w	#$FF00,$10(a1)

loc_76A8:
		bsr.w	ObjectLoad
		bne.s	locret_76D2
		move.b	#$1F,0(a1)
		move.b	#6,$24(a1)
		move.w	8(a0),8(a1)
		addi.w	#$10,8(a1)
		move.w	$C(a0),$C(a1)
		move.w	#$100,$10(a1)

locret_76D2:
		rts
; ---------------------------------------------------------------------------

loc_76D4:
		subq.w	#1,$30(a0)
		bmi.s	loc_7728
		bsr.w	SpeedToPos
		bchg	#0,$32(a0)
		bne.s	loc_770E
		move.w	8(a0),d3
		addi.w	#$10,d3
		btst	#0,$22(a0)
		beq.s	loc_76FA
		subi.w	#$20,d3

loc_76FA:
		jsr	(ObjectHitFloor2).l
		cmpi.w	#$FFF8,d1
		blt.s	loc_7728
		cmpi.w	#$C,d1
		bge.s	loc_7728
		rts
; ---------------------------------------------------------------------------

loc_770E:
		jsr	(ObjectHitFloor).l
		add.w	d1,$C(a0)
		move.b	d3,$26(a0)
		bsr.w	sub_7742
		addq.b	#3,d0
		move.b	d0,$1C(a0)
		rts
; ---------------------------------------------------------------------------

loc_7728:
		subq.b	#2,$25(a0)
		move.w	#$3B,$30(a0)

loc_7732:
		move.w	#0,$10(a0)
		bsr.w	sub_7742
		move.b	d0,$1C(a0)
		rts
; ---------------------------------------------------------------------------

sub_7742:
		moveq	#0,d0
		move.b	$26(a0),d3
		bmi.s	loc_775E
		cmpi.b	#6,d3
		bcs.s	locret_775C
		moveq	#1,d0
		btst	#0,$22(a0)
		bne.s	locret_775C
		moveq	#2,d0

locret_775C:
		rts
; ---------------------------------------------------------------------------

loc_775E:
		cmpi.b	#$FA,d3
		bhi.s	locret_7770
		moveq	#2,d0
		btst	#0,$22(a0)
		bne.s	locret_7770
		moveq	#1,d0

locret_7770:
		rts
; ---------------------------------------------------------------------------

loc_7772:
		bsr.w	DeleteObject
		rts
; ---------------------------------------------------------------------------

loc_7778:
		addq.b	#2,$24(a0)
		move.l	#MapCrabmeat,4(a0)
		move.w	#$400,2(a0)
		move.b	#4,1(a0)
		move.b	#3,$19(a0)
		move.b	#$87,$20(a0)
		move.b	#8,$18(a0)
		move.w	#$FC00,$12(a0)
		move.b	#7,$1C(a0)

loc_77AE:
		lea	(AniCrabmeat).l,a1
		bsr.w	ObjectAnimate
		bsr.w	ObjectFall
		bsr.w	DisplaySprite
		move.w	(unk_FFF72E).w,d0
		addi.w	#$E0,d0
		cmp.w	$C(a0),d0
		bcs.s	loc_77D0
		rts
; ---------------------------------------------------------------------------

loc_77D0:
		bra.w	DeleteObject
; ---------------------------------------------------------------------------
		include "levels\GHZ\Crabmeat\Sprite.ani"
		include "levels\GHZ\Crabmeat\Sprite.map"
		even
; ---------------------------------------------------------------------------

ObjBuzzbomber:
		moveq	#0,d0
		move.b	$24(a0),d0
		move.w	off_78A6(pc,d0.w),d1
		jmp	off_78A6(pc,d1.w)
; ---------------------------------------------------------------------------

off_78A6:	dc.w loc_78AC-off_78A6, loc_78D6-off_78A6, loc_79E6-off_78A6
; ---------------------------------------------------------------------------

loc_78AC:
		addq.b	#2,$24(a0)
		move.l	#MapBuzzbomber,4(a0)
		move.w	#$444,2(a0)
		move.b	#4,1(a0)
		move.b	#3,$19(a0)
		move.b	#8,$20(a0)
		move.b	#$18,$18(a0)

loc_78D6:
		moveq	#0,d0
		move.b	$25(a0),d0
		move.w	loc_78F2(pc,d0.w),d1
		jsr	loc_78F2(pc,d1.w)
		lea	(AniBuzzbomber).l,a1
		bsr.w	ObjectAnimate
		bra.w	ObjectChkDespawn
; ---------------------------------------------------------------------------

loc_78F2:
		ori.b	#$9A,d4
		subq.w	#1,$32(a0)
		bpl.s	locret_7926
		btst	#1,$34(a0)
		bne.s	loc_7928
		addq.b	#2,$25(a0)
		move.w	#$7F,$32(a0)
		move.w	#$400,$10(a0)
		move.b	#1,$1C(a0)
		btst	#0,$22(a0)
		bne.s	locret_7926
		neg.w	$10(a0)

locret_7926:
		rts
; ---------------------------------------------------------------------------

loc_7928:
		bsr.w	ObjectLoad
		bne.s	locret_798A
		move.b	#$23,0(a1)
		move.w	8(a0),8(a1)
		move.w	$C(a0),$C(a1)
		addi.w	#$1C,$C(a1)
		move.w	#$200,$12(a1)
		move.w	#$200,$10(a1)
		move.w	#$18,d0
		btst	#0,$22(a0)
		bne.s	loc_7964
		neg.w	d0
		neg.w	$10(a1)

loc_7964:
		add.w	d0,8(a1)
		move.b	$22(a0),$22(a1)
		move.w	#$E,$32(a1)
		move.l	a0,$3C(a1)
		move.b	#1,$34(a0)
		move.w	#$3B,$32(a0)
		move.b	#2,$1C(a0)

locret_798A:
		rts
; ---------------------------------------------------------------------------
		subq.w	#1,$32(a0)
		bmi.s	loc_79C2
		bsr.w	SpeedToPos
		tst.b	$34(a0)
		bne.s	locret_79E4
		move.w	(v_objspace+8).w,d0
		sub.w	8(a0),d0
		bpl.s	loc_79A8
		neg.w	d0

loc_79A8:
		cmpi.w	#$60,d0
		bcc.s	locret_79E4
		tst.b	1(a0)
		bpl.s	locret_79E4
		move.b	#2,$34(a0)
		move.w	#$1D,$32(a0)
		bra.s	loc_79D4
; ---------------------------------------------------------------------------

loc_79C2:
		move.b	#0,$34(a0)
		bchg	#0,$22(a0)
		move.w	#$3B,$32(a0)

loc_79D4:
		subq.b	#2,$25(a0)
		move.w	#0,$10(a0)
		move.b	#0,$1C(a0)

locret_79E4:
		rts
; ---------------------------------------------------------------------------

loc_79E6:
		bsr.w	DeleteObject
		rts
; ---------------------------------------------------------------------------

ObjBuzzMissile:
		moveq	#0,d0
		move.b	$24(a0),d0
		move.w	off_79FA(pc,d0.w),d1
		jmp	off_79FA(pc,d1.w)
; ---------------------------------------------------------------------------

off_79FA:	dc.w loc_7A04-off_79FA, loc_7A4E-off_79FA, loc_7A6C-off_79FA, loc_7AB2-off_79FA, loc_7AB8-off_79FA
; ---------------------------------------------------------------------------

loc_7A04:
		subq.w	#1,$32(a0)
		bpl.s	sub_7A5E
		addq.b	#2,$24(a0)
		move.l	#MapBuzzMissile,4(a0)
		move.w	#$2444,2(a0)
		move.b	#4,1(a0)
		move.b	#3,$19(a0)
		move.b	#8,$18(a0)
		andi.b	#3,$22(a0)
		tst.b	$28(a0)
		beq.s	loc_7A4E
		move.b	#8,$24(a0)
		move.b	#$87,$20(a0)
		move.b	#1,$1C(a0)
		bra.s	loc_7AC2
; ---------------------------------------------------------------------------

loc_7A4E:
		bsr.s	sub_7A5E
		lea	(AniBuzzMissile).l,a1
		bsr.w	ObjectAnimate
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

sub_7A5E:
		movea.l	$3C(a0),a1
		cmpi.b	#$27,0(a1)
		beq.s	loc_7AB2
		rts
; ---------------------------------------------------------------------------

loc_7A6C:
		btst	#7,$22(a0)
		bne.s	loc_7AA2
		move.b	#$87,$20(a0)
		move.b	#1,$1C(a0)
		bsr.w	SpeedToPos
		lea	(AniBuzzMissile).l,a1
		bsr.w	ObjectAnimate
		bsr.w	DisplaySprite
		move.w	(unk_FFF72E).w,d0
		addi.w	#$E0,d0
		cmp.w	$C(a0),d0
		bcs.s	loc_7AB2
		rts
; ---------------------------------------------------------------------------

loc_7AA2:
		move.b	#$24,0(a0)
		move.b	#0,$24(a0)
		bra.w	ObjCannonballExplode
; ---------------------------------------------------------------------------

loc_7AB2:
		bsr.w	DeleteObject
		rts
; ---------------------------------------------------------------------------

loc_7AB8:
		tst.b	1(a0)
		bpl.s	loc_7AB2
		bsr.w	SpeedToPos

loc_7AC2:
		lea	(AniBuzzMissile).l,a1
		bsr.w	ObjectAnimate
		bsr.w	DisplaySprite
		rts
; ---------------------------------------------------------------------------
		include "levels\GHZ\Buzzbomber\Sprite.ani"
		include "levels\GHZ\Buzzbomber\Missile.ani"
		include "levels\GHZ\Buzzbomber\Sprite.map"
		include "levels\GHZ\Buzzbomber\Missile.map"
		even
; ---------------------------------------------------------------------------

ObjRings:
		moveq	#0,d0
		move.b	act(a0),d0
		move.w	off_7BEE(pc,d0.w),d1
		jmp	off_7BEE(pc,d1.w)
; ---------------------------------------------------------------------------

off_7BEE:	dc.w loc_7C18-off_7BEE, loc_7CD0-off_7BEE, loc_7CF8-off_7BEE, loc_7D1E-off_7BEE, loc_7D2C-off_7BEE

byte_7BF8:	dc.b $10, 0
		dc.b $18, 0
		dc.b $20, 0
		dc.b 0, $10
		dc.b 0, $18
		dc.b 0, $20
		dc.b $10, $10
		dc.b $18, $18
		dc.b $20, $20
		dc.b $F0, $10
		dc.b $E8, $18
		dc.b $E0, $20
		dc.b $10, 8
		dc.b $18, $10
		dc.b $F0, 8
		dc.b $E8, $10
; ---------------------------------------------------------------------------

loc_7C18:
		lea	(v_regbuffer).w,a2
		moveq	#0,d0
		move.b	respawn(a0),d0
		lea	2(a2,d0.w),a2
		move.b	(a2),d4
		move.b	arg(a0),d1
		move.b	d1,d0
		andi.w	#7,d1
		cmpi.w	#7,d1
		bne.s	loc_7C3A
		moveq	#6,d1

loc_7C3A:
		swap	d1
		move.w	#0,d1
		lsr.b	#4,d0
		add.w	d0,d0
		move.b	byte_7BF8(pc,d0.w),d5
		ext.w	d5
		move.b	byte_7BF8+1(pc,d0.w),d6
		ext.w	d6
		movea.l	a0,a1
		move.w	xpos(a0),d2
		move.w	ypos(a0),d3
		lsr.b	#1,d4
		bcs.s	loc_7CBC
		bclr	#7,(a2)
		bra.s	loc_7C74
; ---------------------------------------------------------------------------

loc_7C64:
		swap	d1
		lsr.b	#1,d4
		bcs.s	loc_7CBC
		bclr	#7,(a2)
		bsr.w	ObjectLoad
		bne.s	loc_7CC8

loc_7C74:
		move.b	#$25,id(a1)
		addq.b	#2,act(a1)
		move.w	d2,xpos(a1)
		move.w	xpos(a0),$32(a1)
		move.w	d3,ypos(a1)
		move.l	#MapRing,map(a1)
		move.w	#$27B2,tile(a1)
		move.b	#4,render(a1)
		move.b	#2,prio(a1)
		move.b	#$47,col(a1)
		move.b	#8,xdisp(a1)
		move.b	respawn(a0),respawn(a1)
		move.b	d1,$34(a1)

loc_7CBC:
		addq.w	#1,d1
		add.w	d5,d2
		add.w	d6,d3
		swap	d1
		dbf	d1,loc_7C64

loc_7CC8:
		btst	#0,(a2)
		bne.w	DeleteObject

loc_7CD0:
		move.b	(RingFrame).w,frame(a0)
		bsr.w	DisplaySprite
		move.w	$32(a0),d0
		andi.w	#$FF80,d0
		move.w	(v_screenposx).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0
		cmpi.w	#640,d0
		bhi.s	loc_7D2C
		rts
; ---------------------------------------------------------------------------

loc_7CF8:
		addq.b	#2,act(a0)
		move.b	#0,col(a0)
		move.b	#1,prio(a0)
		bsr.w	CollectRing
		lea	(v_regbuffer).w,a2
		moveq	#0,d0
		move.b	respawn(a0),d0
		move.b	$34(a0),d1
		bset	d1,2(a2,d0.w)

loc_7D1E:
		lea	(AniRing).l,a1
		bsr.w	ObjectAnimate
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

loc_7D2C:
		bra.w	DeleteObject
; ---------------------------------------------------------------------------

CollectRing:
		addq.w	#1,(v_rings).w
		ori.b	#1,(f_extralife).w
		move.w	#$B5,d0
		cmpi.w	#50,(v_rings).w
		bcs.s	loc_7D6A
		bset	#0,(byte_FFFE1B).w
		beq.s	loc_7D5E
		cmpi.w	#100,(v_rings).w
		bcs.s	loc_7D6A
		bset	#1,(byte_FFFE1B).w
		bne.s	loc_7D6A

loc_7D5E:
		addq.b	#1,(v_lives).w
		addq.b	#1,(byte_FFFE1C).w
		move.w	#bgm_ExtraLife,d0

loc_7D6A:
		jmp	(PlaySFX).l
; ---------------------------------------------------------------------------

ObjRingLoss:
		moveq	#0,d0
		move.b	act(a0),d0
		move.w	off_7D7E(pc,d0.w),d1
		jmp	off_7D7E(pc,d1.w)
; ---------------------------------------------------------------------------

off_7D7E:	dc.w loc_7D88-off_7D7E, loc_7E48-off_7D7E
		dc.w loc_7E9A-off_7D7E, loc_7EAE-off_7D7E
		dc.w loc_7EBC-off_7D7E
; ---------------------------------------------------------------------------

loc_7D88:
		movea.l	a0,a1
		moveq	#0,d5
		move.w	(v_rings).w,d5
		moveq	#32,d0
		cmp.w	d0,d5
		bcs.s	loc_7D98
		move.w	d0,d5

loc_7D98:
		subq.w	#1,d5
		move.w	#$288,d4
		bra.s	loc_7DA8
; ---------------------------------------------------------------------------

loc_7DA0:
		bsr.w	ObjectLoad
		bne.w	loc_7E2C

loc_7DA8:
		move.b	#$37,id(a1)
		addq.b	#2,act(a1)
		move.b	#8,yrad(a1)
		move.b	#8,xrad(a1)
		move.w	xpos(a0),xpos(a1)
		move.w	ypos(a0),ypos(a1)
		move.l	#MapRing,map(a1)

loc_7DD2:
		move.w	#$27B2,tile(a1)
		move.b	#4,render(a1)
		move.b	#2,prio(a1)
		move.b	#$47,col(a1)
		move.b	#8,xdisp(a1)
		move.b	#$FF,(RingLossTimer).w
		tst.w	d4
		bmi.s	loc_7E1C
		move.w	d4,d0
		bsr.w	GetSine
		move.w	d4,d2
		lsr.w	#8,d2
		asl.w	d2,d0
		asl.w	d2,d1
		move.w	d0,d2
		move.w	d1,d3
		addi.b	#$10,d4
		bcc.s	loc_7E1C
		subi.w	#$80,d4
		bcc.s	loc_7E1C
		move.w	#$288,d4

loc_7E1C:
		move.w	d2,xvel(a1)
		move.w	d3,yvel(a1)
		neg.w	d2
		neg.w	d4
		dbf	d5,loc_7DA0

loc_7E2C:
		move.w	#0,(v_rings).w
		move.b	#$80,(f_extralife).w
		move.b	#0,(byte_FFFE1B).w
		move.w	#sfx_RingLoss,d0
		jsr	(PlaySFX).l

loc_7E48:
		move.b	(RingLossFrame).w,frame(a0)
		bsr.w	SpeedToPos
		addi.w	#$18,yvel(a0)
		bmi.s	loc_7E82
		move.b	(byte_FFFE0F).w,d0
		add.b	d7,d0
		andi.b	#3,d0
		bne.s	loc_7E82
		jsr	(ObjectHitFloor).l
		tst.w	d1
		bpl.s	loc_7E82
		add.w	d1,ypos(a0)
		move.w	yvel(a0),d0
		asr.w	#2,d0
		sub.w	d0,yvel(a0)
		neg.w	yvel(a0)

loc_7E82:
		tst.b	(RingLossTimer).w
		beq.s	loc_7EBC
		move.w	(unk_FFF72E).w,d0
		addi.w	#224,d0
		cmp.w	ypos(a0),d0
		bcs.s	loc_7EBC
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

loc_7E9A:
		addq.b	#2,act(a0)
		move.b	#0,col(a0)
		move.b	#1,prio(a0)
		bsr.w	CollectRing

loc_7EAE:
		lea	(AniRing).l,a1
		bsr.w	ObjectAnimate
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

loc_7EBC:
		bra.w	DeleteObject
; ---------------------------------------------------------------------------

Obj4B:
		moveq	#0,d0
		move.b	act(a0),d0
		move.w	off_7ECE(pc,d0.w),d1
		jmp	off_7ECE(pc,d1.w)
; ---------------------------------------------------------------------------

off_7ECE:	dc.w loc_7ED6-off_7ECE, loc_7F12-off_7ECE, loc_7F3C-off_7ECE, loc_7F4C-off_7ECE
; ---------------------------------------------------------------------------

loc_7ED6:
		lea	(v_regbuffer).w,a2
		moveq	#0,d0
		move.b	respawn(a0),d0
		lea	2(a2,d0.w),a2
		bclr	#7,(a2)
		addq.b	#2,act(a0)
		move.l	#Map4B,map(a0)
		move.w	#$24EC,tile(a0)
		move.b	#4,render(a0)
		move.b	#2,prio(a0)
		move.b	#$52,col(a0)
		move.b	#$C,xdisp(a0)

loc_7F12:
		move.b	(RingFrame).w,frame(a0)
		bsr.w	DisplaySprite
		move.w	xpos(a0),d0
		andi.w	#$FF80,d0
		move.w	(v_screenposx).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0
		cmpi.w	#640,d0
		bhi.w	DeleteObject
		rts
; ---------------------------------------------------------------------------

loc_7F3C:
		addq.b	#2,act(a0)
		move.b	#0,col(a0)
		move.b	#1,prio(a0)

loc_7F4C:
		move.b	#$4A,(v_objspace+$1C0).w
		moveq	#plcid_Warp,d0
		bsr.w	plcAdd
		bra.w	DeleteObject
; ---------------------------------------------------------------------------
		include "_anim\Rings.asm"
		include "_maps\Rings.asm"
		include "_maps\4B.asm"
		even
; ---------------------------------------------------------------------------

ObjMonitor:
		moveq	#0,d0
		move.b	act(a0),d0
		move.w	off_8054(pc,d0.w),d1
		jmp	off_8054(pc,d1.w)
; ---------------------------------------------------------------------------

off_8054:	dc.w loc_805E-off_8054, loc_80C0-off_8054
		dc.w sub_81D2-off_8054, loc_81A4-off_8054
		dc.w loc_81AE-off_8054
; ---------------------------------------------------------------------------

loc_805E:
		addq.b	#2,act(a0)
		move.b	#$E,yrad(a0)
		move.b	#$E,xrad(a0)
		move.l	#MapMonitor,map(a0)
		move.w	#$680,tile(a0)
		move.b	#4,render(a0)
		move.b	#3,prio(a0)
		move.b	#$F,xdisp(a0)
		lea	(v_regbuffer).w,a2
		moveq	#0,d0
		move.b	respawn(a0),d0
		bclr	#7,2(a2,d0.w)
		btst	#0,2(a2,d0.w)
		beq.s	loc_80B4
		move.b	#8,act(a0)
		move.b	#$B,frame(a0)
		rts
; ---------------------------------------------------------------------------

loc_80B4:
		move.b	#$46,col(a0)
		move.b	arg(a0),ani(a0)

loc_80C0:
		move.b	subact(a0),d0
		beq.s	loc_811A
		subq.b	#2,d0
		bne.s	loc_80FA
		moveq	#0,d1
		move.b	xdisp(a0),d1
		addi.w	#$B,d1
		bsr.w	PtfmCheckExit
		btst	#3,status(a1)
		bne.w	loc_80EA
		clr.b	subact(a0)
		bra.w	loc_81A4
; ---------------------------------------------------------------------------

loc_80EA:
		move.w	#$10,d3
		move.w	xpos(a0),d2
		bsr.w	PtfmSurfaceHeight
		bra.w	loc_81A4
; ---------------------------------------------------------------------------

loc_80FA:
		bsr.w	ObjectFall
		jsr	(ObjectHitFloor).l
		tst.w	d1
		bpl.w	loc_81A4
		add.w	d1,ypos(a0)
		clr.w	yvel(a0)
		clr.b	subact(a0)
		bra.w	loc_81A4
; ---------------------------------------------------------------------------

loc_811A:
		move.w	#$1A,d1
		move.w	#$F,d2
		bsr.w	sub_83B4
		beq.w	loc_818A
		tst.w	yvel(a1)
		bmi.s	loc_8138
		cmpi.b	#2,ani(a1)
		beq.s	loc_818A

loc_8138:
		tst.w	d1
		bpl.s	loc_814E
		sub.w	d3,ypos(a1)
		bsr.w	loc_4FD4
		move.b	#2,subact(a0)
		bra.w	loc_81A4
; ---------------------------------------------------------------------------

loc_814E:
		tst.w	d0
		beq.w	loc_8174
		bmi.s	loc_815E
		tst.w	xvel(a1)
		bmi.s	loc_8174
		bra.s	loc_8164
; ---------------------------------------------------------------------------

loc_815E:
		tst.w	xvel(a1)
		bpl.s	loc_8174

loc_8164:
		sub.w	d0,xpos(a1)
		move.w	#0,inertia(a1)
		move.w	#0,xvel(a1)

loc_8174:
		btst	#1,status(a1)
		bne.s	loc_8198
		bset	#5,status(a1)
		bset	#5,status(a0)
		bra.s	loc_81A4
; ---------------------------------------------------------------------------

loc_818A:
		btst	#5,status(a0)
		beq.s	loc_81A4
		move.w	#1,ani(a1)

loc_8198:
		bclr	#5,status(a0)
		bclr	#5,status(a1)

loc_81A4:
		lea	(AniMonitor).l,a1
		bsr.w	ObjectAnimate

loc_81AE:
		bsr.w	DisplaySprite
		move.w	xpos(a0),d0
		andi.w	#$FF80,d0
		move.w	(v_screenposx).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0
		cmpi.w	#640,d0
		bhi.w	DeleteObject
		rts
; ---------------------------------------------------------------------------

sub_81D2:
		addq.b	#2,act(a0)
		move.b	#0,col(a0)
		bsr.w	ObjectLoad
		bne.s	loc_81FA
		move.b	#$2E,id(a1)
		move.w	xpos(a0),xpos(a1)
		move.w	ypos(a0),ypos(a1)
		move.b	ani(a0),ani(a1)

loc_81FA:
		bsr.w	ObjectLoad
		bne.s	loc_8216
		move.b	#$27,id(a1)
		addq.b	#2,act(a1)
		move.w	xpos(a0),xpos(a1)
		move.w	ypos(a0),ypos(a1)

loc_8216:
		lea	(v_regbuffer).w,a2
		moveq	#0,d0
		move.b	respawn(a0),d0
		bset	#0,2(a2,d0.w)
		move.b	#9,ani(a0)
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

ObjMonitorItem:
		moveq	#0,d0
		move.b	act(a0),d0
		move.w	off_8242(pc,d0.w),d1
		jsr	off_8242(pc,d1.w)
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

off_8242:	dc.w loc_8248-off_8242, loc_8288-off_8242
		dc.w loc_83AA-off_8242
; ---------------------------------------------------------------------------

loc_8248:
		addq.b	#2,act(a0)
		move.w	#$680,tile(a0)
		move.b	#$24,render(a0)
		move.b	#3,prio(a0)
		move.b	#8,xdisp(a0)
		move.w	#-$300,yvel(a0)
		moveq	#0,d0
		move.b	ani(a0),d0
		addq.b	#2,d0
		move.b	d0,frame(a0)
		movea.l	#MapMonitor,a1
		add.b	d0,d0
		adda.w	(a1,d0.w),a1
		addq.w	#1,a1
		move.l	a1,map(a0)

loc_8288:
		tst.w	yvel(a0)
		bpl.w	loc_829C
		bsr.w	SpeedToPos
		addi.w	#$18,yvel(a0)
		rts
; ---------------------------------------------------------------------------

loc_829C:
		addq.b	#2,act(a0)
		move.w	#$1D,anidelay(a0)
		move.b	ani(a0),d0
		cmpi.b	#1,d0
		bne.s	loc_82B2
		rts
; ---------------------------------------------------------------------------

loc_82B2:
		cmpi.b	#2,d0
		bne.s	loc_82CA

loc_82B8:
		addq.b	#1,(v_lives).w
		addq.b	#1,(byte_FFFE1C).w
		move.w	#bgm_ExtraLife,d0
		jmp	(PlayMusic).l
; ---------------------------------------------------------------------------

loc_82CA:
		cmpi.b	#3,d0
		bne.s	loc_82F8
		move.b	#1,(v_shoes).w
		move.w	#$4B0,(v_objspace+$34).w
		move.w	#$C00,(unk_FFF760).w
		move.w	#$18,(unk_FFF762).w
		move.w	#$80,(unk_FFF764).w
		move.w	#bgm_Speedup,d0
		jmp	(PlayMusic).l
; ---------------------------------------------------------------------------

loc_82F8:
		cmpi.b	#4,d0
		bne.s	loc_8314
		move.b	#1,(v_shield).w
		move.b	#$38,(v_objspace+$180).w
		move.w	#sfx_Shield,d0
		jmp	(PlayMusic).l
; ---------------------------------------------------------------------------

loc_8314:
		cmpi.b	#5,d0
		bne.s	loc_8360
		move.b	#1,(v_invinc).w
		move.w	#$4B0,(v_objspace+$32).w
		move.b	#$38,(v_objspace+$200).w
		move.b	#1,(v_objspace+$21C).w
		move.b	#$38,(v_objspace+$240).w
		move.b	#2,(v_objspace+$25C).w
		move.b	#$38,(v_objspace+$280).w
		move.b	#3,(v_objspace+$29C).w
		move.b	#$38,(v_objspace+$2C0).w
		move.b	#4,(v_objspace+$2DC).w
		move.w	#bgm_Invincible,d0
		jmp	(PlayMusic).l
; ---------------------------------------------------------------------------

loc_8360:
		cmpi.b	#6,d0
		bne.s	loc_83A0
		addi.w	#10,(v_rings).w
		ori.b	#1,(f_extralife).w
		cmpi.w	#50,(v_rings).w
		bcs.s	loc_8396
		bset	#0,(byte_FFFE1B).w
		beq.w	loc_82B8
		cmpi.w	#100,(v_rings).w
		bcs.s	loc_8396
		bset	#1,(byte_FFFE1B).w
		beq.w	loc_82B8

loc_8396:
		move.w	#sfx_Ring,d0
		jmp	(PlayMusic).l
; ---------------------------------------------------------------------------

loc_83A0:
		cmpi.b	#7,d0
		bne.s	locret_83A8
		nop

locret_83A8:
		rts
; ---------------------------------------------------------------------------

loc_83AA:
		subq.w	#1,anidelay(a0)
		bmi.w	DeleteObject
		rts
; ---------------------------------------------------------------------------

sub_83B4:
		tst.w	(DebugRoutine).w
		bne.w	loc_8400
		lea	(v_objspace).w,a1
		move.w	xpos(a1),d0
		sub.w	xpos(a0),d0
		add.w	d1,d0
		bmi.s	loc_8400
		move.w	d1,d3
		add.w	d3,d3
		cmp.w	d3,d0
		bhi.s	loc_8400
		move.b	yrad(a1),d3
		ext.w	d3
		add.w	d3,d2
		move.w	ypos(a1),d3
		sub.w	ypos(a0),d3
		add.w	d2,d3
		bmi.s	loc_8400
		add.w	d2,d2
		cmp.w	d2,d3
		bcc.s	loc_8400
		cmp.w	d0,d1
		bcc.s	loc_83F6
		add.w	d1,d1
		sub.w	d1,d0

loc_83F6:
		cmpi.w	#$10,d3
		bcs.s	loc_8404

loc_83FC:
		moveq	#1,d1
		rts
; ---------------------------------------------------------------------------

loc_8400:
		moveq	#0,d1
		rts
; ---------------------------------------------------------------------------

loc_8404:
		moveq	#0,d1
		move.b	xdisp(a0),d1
		addq.w	#4,d1
		move.w	d1,d2
		add.w	d2,d2
		add.w	xpos(a1),d1
		sub.w	xpos(a0),d1
		bmi.s	loc_83FC
		cmp.w	d2,d1
		bcc.s	loc_83FC
		moveq	#-1,d1
		rts
; ---------------------------------------------------------------------------
		include "_anim\Monitor.asm"
		include "_maps\Monitor.asm"
; ---------------------------------------------------------------------------

RunObjects:
		lea	(v_objspace).w,a0
		moveq	#$7F,d7
		moveq	#0,d0
		cmpi.b	#6,(v_objspace+$24).w
		bcc.s	loc_8560
; ---------------------------------------------------------------------------

sub_8546:
		move.b	(a0),d0
		beq.s	loc_8556
		add.w	d0,d0
		add.w	d0,d0
		movea.l	loc_857A+2(pc,d0.w),a1
		jsr	(a1)
		moveq	#0,d0

loc_8556:
		lea	size(a0),a0
		dbf	d7,sub_8546
		rts
; ---------------------------------------------------------------------------

loc_8560:
		moveq	#$1F,d7
		bsr.s	sub_8546
		moveq	#$5F,d7

loc_8566:
		moveq	#0,d0
		move.b	(a0),d0
		beq.s	loc_8576
		tst.b	1(a0)
		bpl.s	loc_8576
		bsr.w	DisplaySprite

loc_8576:
		lea	size(a0),a0

loc_857A:
		dbf	d7,loc_8566
		rts
; ---------------------------------------------------------------------------
AllObjects:
                include "_inc\Object Pointers.asm"
                include "_incObj\sub ObjectFall.asm"
                include "_incObj\sub SpeedToPos.asm"
                include "_incObj\sub DisplaySprite.asm"
                include "_incObj\sub DeleteObject.asm"
; ---------------------------------------------------------------------------

off_8796:	dc.l 0
                dc.l (v_screenposx)&$FFFFFF
                dc.l (v_bgscreenposx)&$FFFFFF
                dc.l (v_bg3screenposx)&$FFFFFF
; ---------------------------------------------------------------------------

ProcessMaps:
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
		bclr	#7,render(a0)
		move.b	1(a0),d0
		move.b	d0,d4
		andi.w	#$C,d0
		beq.s	loc_8826
		movea.l	off_8796(pc,d0.w),a1
		moveq	#0,d0
		move.b	xdisp(a0),d0
		move.w	xpos(a0),d3
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
		move.b	yrad(a0),d0
		move.w	ypos(a0),d2
		sub.w	4(a1),d2
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
		move.w	xpix(a0),d2
		move.w	xpos(a0),d3
		bra.s	loc_8848
; ---------------------------------------------------------------------------

loc_8830:
		move.w	ypos(a0),d2
		sub.w	4(a1),d2
		addi.w	#$80,d2
		cmpi.w	#96,d2
		bcs.s	loc_886E
		cmpi.w	#384,d2
		bcc.s	loc_886E

loc_8848:
		movea.l	map(a0),a1
		moveq	#0,d1
		btst	#5,d4
		bne.s	loc_8864
		move.b	frame(a0),d1
		add.b	d1,d1
		adda.w	(a1,d1.w),a1
		move.b	(a1)+,d1
		subq.b	#1,d1
		bmi.s	loc_8868

loc_8864:
		bsr.w	sub_8898

loc_8868:
		bset	#7,render(a0)

loc_886E:
		addq.w	#2,d6
		subq.w	#2,(a4)
		bne.w	loc_87BA

loc_8876:
		lea	$80(a4),a4
		dbf	d7,loc_87B2
		move.b	d5,(byte_FFF62C).w
		cmpi.b	#80,d5
		beq.s	loc_8890
		move.l	#0,(a2)
		rts
; ---------------------------------------------------------------------------

loc_8890:
		move.b	#0,-5(a2)
		rts
; ---------------------------------------------------------------------------

sub_8898:
		movea.w	tile(a0),a3
		btst	#0,d4
		bne.s	loc_88DE
		btst	#1,d4
		bne.w	loc_892C
; ---------------------------------------------------------------------------

sub_88AA:
		cmpi.b	#80,d5
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
		cmpi.b	#80,d5
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
		cmpi.b	#80,d5
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
		cmpi.b	#80,d5
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
		move.w	xpos(a0),d0
		sub.w	(v_screenposx).w,d0
		bmi.s	.offscreen
		cmpi.w	#320,d0
		bge.s	.offscreen
		move.w	ypos(a0),d1
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
		move.b	(unk_FFF76C).w,d0
		move.w	off_89FC(pc,d0.w),d0
		jmp	off_89FC(pc,d0.w)
; ---------------------------------------------------------------------------

off_89FC:	dc.w loc_8A00-off_89FC, loc_8A44-off_89FC
; ---------------------------------------------------------------------------

loc_8A00:
		addq.b	#2,(unk_FFF76C).w
		move.w	(v_zone).w,d0
		lsl.b	#6,d0
		lsr.w	#4,d0
		lea	(ObjPos_Index).l,a0
		movea.l	a0,a1
		adda.w	(a0,d0.w),a0
		move.l	a0,(unk_FFF770).w
		move.l	a0,(unk_FFF774).w
		adda.w	2(a1,d0.w),a1
		move.l	a1,(unk_FFF778).w
		move.l	a1,(unk_FFF77C).w
		lea	(v_regbuffer).w,a2
		move.w	#$101,(a2)+
		move.w	#$5E,d0

loc_8A38:
		clr.l	(a2)+
		dbf	d0,loc_8A38
		move.w	#$FFFF,(unk_FFF76E).w

loc_8A44:
		lea	(v_regbuffer).w,a2
		moveq	#0,d2
		move.w	(v_screenposx).w,d6
		andi.w	#$FF80,d6
		cmp.w	(unk_FFF76E).w,d6
		beq.w	locret_8B20
		bge.s	loc_8ABA
		move.w	d6,(unk_FFF76E).w
		movea.l	(unk_FFF774).w,a0
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
		move.l	a0,(unk_FFF774).w
		movea.l	(unk_FFF770).w,a0
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
		move.l	a0,(unk_FFF770).w
		rts
; ---------------------------------------------------------------------------

loc_8ABA:
		move.w	d6,(unk_FFF76E).w
		movea.l	(unk_FFF770).w,a0
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
		move.l	a0,(unk_FFF770).w
		movea.l	(unk_FFF774).w,a0
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
		move.l	a0,(unk_FFF774).w
		rts
; ---------------------------------------------------------------------------

loc_8B00:
		movea.l	(unk_FFF778).w,a0
		move.w	(v_bg3screenposx).w,d0
		addi.w	#$200,d0
		andi.w	#$FF80,d0
		cmp.w	(a0),d0
		bcs.s	locret_8B20
		bsr.w	sub_8B22
		move.l	a0,(unk_FFF778).w
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
		bsr.w	ObjectLoad
		bne.s	locret_8B70
		move.w	(a0)+,8(a1)
		move.w	(a0)+,d0
		move.w	d0,d1
		andi.w	#$FFF,d0
		move.w	d0,$C(a1)
		rol.w	#2,d1
		andi.b	#3,d1
		move.b	d1,1(a1)
		move.b	d1,$22(a1)
		move.b	(a0)+,d0
		bpl.s	loc_8B66
		andi.b	#$7F,d0
		move.b	d2,$23(a1)

loc_8B66:
		move.b	d0,0(a1)
		move.b	(a0)+,$28(a1)
		moveq	#0,d0

locret_8B70:
		rts
; ---------------------------------------------------------------------------

ObjectLoad:
		lea	(LevelObjectsList).w,a1
		move.w	#$5F,d0

loc_8B7A:
		tst.b	(a1)
		beq.s	locret_8B86
		lea	size(a1),a1
		dbf	d0,loc_8B7A

locret_8B86:
		rts
; ---------------------------------------------------------------------------

LoadNextObject:
		movea.l	a0,a1
		move.w	#$F000,d0
		sub.w	a0,d0
		lsr.w	#6,d0
		subq.w	#1,d0
		bcs.s	locret_8BA2

loc_8B96:
		tst.b	(a1)
		beq.s	locret_8BA2
		lea	size(a1),a1
		dbf	d0,loc_8B96

locret_8BA2:
		rts
; ---------------------------------------------------------------------------

ObjChopper:
		moveq	#0,d0
		move.b	$24(a0),d0
		move.w	off_8BB6(pc,d0.w),d1
		jsr	off_8BB6(pc,d1.w)
		bra.w	ObjectChkDespawn
; ---------------------------------------------------------------------------

off_8BB6:	dc.w loc_8BBA-off_8BB6, loc_8BF0-off_8BB6
; ---------------------------------------------------------------------------

loc_8BBA:
		addq.b	#2,$24(a0)
		move.l	#MapChopper,4(a0)
		move.w	#$47B,2(a0)
		move.b	#4,1(a0)
		move.b	#4,$19(a0)
		move.b	#9,$20(a0)
		move.b	#$10,$18(a0)
		move.w	#$F900,$12(a0)
		move.w	$C(a0),$30(a0)

loc_8BF0:
		lea	(AniChopper).l,a1
		bsr.w	ObjectAnimate
		bsr.w	SpeedToPos
		addi.w	#$18,$12(a0)
		move.w	$30(a0),d0
		cmp.w	$C(a0),d0
		bcc.s	loc_8C18
		move.w	d0,$C(a0)
		move.w	#$F900,$12(a0)

loc_8C18:
		move.b	#1,$1C(a0)
		subi.w	#$C0,d0
		cmp.w	$C(a0),d0
		bcc.s	locret_8C3A
		move.b	#0,$1C(a0)
		tst.w	$12(a0)
		bmi.s	locret_8C3A
		move.b	#2,$1C(a0)

locret_8C3A:
		rts
; ---------------------------------------------------------------------------
		include "levels\GHZ\Chopper\Sprite.ani"
		even
		include "levels\GHZ\Chopper\Sprite.map"
		even

                include "_incObj\2C Jaws.asm"
		include "_anim\Jaws.asm"
		include "_maps\Jaws.asm"
		even

                include "_incObj\2D Burrobot.asm"
		include "levels\LZ\Burrobot\Sprite.ani"
		even
		include "levels\LZ\Burrobot\Sprite.map"
		even
; ---------------------------------------------------------------------------

ObjMZPlatforms:
		moveq	#0,d0
		move.b	$24(a0),d0
		move.w	off_8ECE(pc,d0.w),d1
		jmp	off_8ECE(pc,d1.w)
; ---------------------------------------------------------------------------

off_8ECE:	dc.w loc_8EDE-off_8ECE, loc_8F3C-off_8ECE

off_8ED2:	dc.w ObjMZPlatforms_Slope1-off_8ED2
		dc.b 0, $40
		dc.w ObjMZPlatforms_Slope3-off_8ED2
		dc.b 1, $40
		dc.w ObjMZPlatforms_Slope2-off_8ED2
		dc.b 2, $20
; ---------------------------------------------------------------------------

loc_8EDE:
		addq.b	#2,$24(a0)
		move.l	#MapMZPlatforms,4(a0)
		move.w	#$C000,2(a0)
		move.b	#4,1(a0)
		move.b	#5,$19(a0)
		move.w	$C(a0),$2C(a0)
		move.w	8(a0),$2A(a0)
		moveq	#0,d0
		move.b	$28(a0),d0
		lsr.w	#2,d0

loc_8F10:
		andi.w	#$1C,d0
		lea	off_8ED2(pc,d0.w),a1
		move.w	(a1)+,d0
		lea	off_8ED2(pc,d0.w),a2
		move.l	a2,$30(a0)
		move.b	(a1)+,$1A(a0)
		move.b	(a1),$18(a0)
		andi.b	#$F,$28(a0)
		move.b	#$40,$16(a0)
		bset	#4,1(a0)

loc_8F3C:
		bsr.w	sub_8FA6
		tst.b	$25(a0)
		beq.s	loc_8F7C
		moveq	#0,d1
		move.b	$18(a0),d1
		addi.w	#$B,d1
		bsr.w	PtfmCheckExit
		btst	#3,$22(a1)
		bne.w	loc_8F64
		clr.b	$25(a0)
		bra.s	loc_8F9E
; ---------------------------------------------------------------------------

loc_8F64:
		moveq	#0,d1
		move.b	$18(a0),d1
		addi.w	#$B,d1
		movea.l	$30(a0),a2
		move.w	8(a0),d2
		bsr.w	sub_61E0
		bra.s	loc_8F9E
; ---------------------------------------------------------------------------

loc_8F7C:
		moveq	#0,d1
		move.b	$18(a0),d1
		addi.w	#$B,d1
		move.w	#$20,d2
		cmpi.b	#2,$1A(a0)
		bne.s	loc_8F96
		move.w	#$30,d2

loc_8F96:
		movea.l	$30(a0),a2
		bsr.w	loc_A30C

loc_8F9E:
		bsr.w	DisplaySprite
		bra.w	loc_90C2
; ---------------------------------------------------------------------------

sub_8FA6:
		moveq	#0,d0
		move.b	$28(a0),d0
		andi.w	#7,d0
		add.w	d0,d0
		move.w	off_8FBA(pc,d0.w),d1
		jmp	off_8FBA(pc,d1.w)
; ---------------------------------------------------------------------------

off_8FBA:	dc.w locret_8FC6-off_8FBA, loc_8FC8-off_8FBA, loc_8FD2-off_8FBA, loc_8FDC-off_8FBA, loc_8FE6-off_8FBA
		dc.w loc_9006-off_8FBA
; ---------------------------------------------------------------------------

locret_8FC6:
		rts
; ---------------------------------------------------------------------------

loc_8FC8:
		move.b	(oscValues+2).w,d0
		move.w	#$20,d1
		bra.s	loc_8FEE
; ---------------------------------------------------------------------------

loc_8FD2:
		move.b	(oscValues+6).w,d0
		move.w	#$30,d1
		bra.s	loc_8FEE
; ---------------------------------------------------------------------------

loc_8FDC:
		move.b	(oscValues+$A).w,d0
		move.w	#$40,d1
		bra.s	loc_8FEE
; ---------------------------------------------------------------------------

loc_8FE6:
		move.b	(oscValues+$E).w,d0
		move.w	#$60,d1

loc_8FEE:
		btst	#3,$28(a0)
		beq.s	loc_8FFA
		neg.w	d0
		add.w	d1,d0

loc_8FFA:
		move.w	$2C(a0),d1
		sub.w	d0,d1
		move.w	d1,$C(a0)
		rts
; ---------------------------------------------------------------------------

loc_9006:
		move.b	$34(a0),d0
		tst.b	$25(a0)
		bne.s	loc_9018
		subq.b	#2,d0
		bcc.s	loc_9024
		moveq	#0,d0
		bra.s	loc_9024
; ---------------------------------------------------------------------------

loc_9018:
		addq.b	#4,d0
		cmpi.b	#$40,d0
		bcs.s	loc_9024
		move.b	#$40,d0

loc_9024:
		move.b	d0,$34(a0)
		jsr	(GetSine).l
		lsr.w	#4,d0
		move.w	d0,d1
		add.w	$2C(a0),d0
		move.w	d0,$C(a0)
		cmpi.b	#$20,$34(a0)
		bne.s	loc_9082
		tst.b	$35(a0)
		bne.s	loc_9082
		move.b	#1,$35(a0)
		bsr.w	LoadNextObject
		bne.s	loc_9082
		move.b	#$35,0(a1)
		move.w	8(a0),8(a1)
		move.w	$2C(a0),$2C(a1)
		addq.w	#8,$2C(a1)
		subq.w	#3,$2C(a1)
		subi.w	#$40,8(a1)
		move.l	$30(a0),$30(a1)
		move.l	a0,$38(a1)
		movea.l	a0,a2
		bsr.s	sub_90A4

loc_9082:
		moveq	#0,d2
		lea	$36(a0),a2
		move.b	(a2)+,d2
		subq.b	#1,d2
		bcs.s	locret_90A2

loc_908E:
		moveq	#0,d0
		move.b	(a2)+,d0
		lsl.w	#6,d0
		addi.w	#-$3000,d0
		movea.w	d0,a1
		move.w	d1,$3C(a1)
		dbf	d2,loc_908E

locret_90A2:
		rts
; ---------------------------------------------------------------------------

sub_90A4:
		lea	$36(a2),a2
		moveq	#0,d0
		move.b	(a2),d0
		addq.b	#1,(a2)
		lea	1(a2,d0.w),a2
		move.w	a1,d0
		subi.w	#$D000,d0
		lsr.w	#6,d0
		andi.w	#$7F,d0
		move.b	d0,(a2)
		rts
; ---------------------------------------------------------------------------

loc_90C2:
		tst.b	$35(a0)
		beq.s	loc_90CE
		tst.b	1(a0)
		bpl.s	loc_90EE

loc_90CE:
		move.w	$2A(a0),d0
		andi.w	#$FF80,d0
		move.w	(v_screenposx).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0
		cmpi.w	#$280,d0
		bhi.w	DeleteObject
		rts
; ---------------------------------------------------------------------------

loc_90EE:
		moveq	#0,d2

loc_90F0:
		lea	$36(a0),a2
		move.b	(a2),d2
		clr.b	(a2)+
		subq.b	#1,d2
		bcs.s	locret_911E

loc_90FC:
		moveq	#0,d0
		move.b	(a2),d0
		clr.b	(a2)+
		lsl.w	#6,d0
		addi.w	#-$3000,d0
		movea.w	d0,a1
		bsr.w	ObjectDeleteA1
		dbf	d2,loc_90FC
		move.b	#0,$35(a0)

loc_9118:
		move.b	#0,$34(a0)

locret_911E:
		rts
; ---------------------------------------------------------------------------

ObjMZPlatforms_Slope1:dc.b $20, $20, $20, $20, $20
		dc.b $20, $20, $20, $20, $20
		dc.b $20, $20, $20, $20, $21
		dc.b $22, $23, $24, $25, $26
		dc.b $27, $28, $29, $2A, $2B
		dc.b $2C, $2D, $2E, $2F, $30
		dc.b $30, $30, $30, $30, $30
		dc.b $30, $30, $30, $30, $30
		dc.b $30, $30, $30, $30, $30
		dc.b $30, $30, $2F, $2E, $2D
		dc.b $2C, $2B, $2A, $29, $28
		dc.b $27, $26, $25, $24, $23
		dc.b $22, $21, $20, $20, $20
		dc.b $20, $20, $20, $20, $20
		dc.b $20, $20, $20, $20, $20
		dc.b $20

ObjMZPlatforms_Slope2:dc.b $30, $30, $30, $30, $30
		dc.b $30, $30, $30, $30, $30
		dc.b $30, $30, $30, $30, $30
		dc.b $30, $30, $30, $30, $30
		dc.b $30, $30, $30, $30, $30
		dc.b $30, $30, $30, $30, $30
		dc.b $30, $30, $30, $30, $30
		dc.b $30, $30, $30, $30, $30
		dc.b $30, $30, $30, $30

ObjMZPlatforms_Slope3:dc.b $20, $20, $20, $20, $20
		dc.b $20, $21, $22, $23, $24
		dc.b $25, $26, $27, $28, $29
		dc.b $2A, $2B, $2C, $2D, $2E
		dc.b $2F, $30, $31, $32, $33
		dc.b $34, $35, $36, $37, $38
		dc.b $39, $3A, $3B, $3C, $3D
		dc.b $3E, $3F, $40, $40, $40
		dc.b $40, $40, $40, $40, $40
		dc.b $40, $40, $40, $40, $40
		dc.b $40, $40, $40, $40, $40
		dc.b $3F, $3E, $3D, $3C, $3B
		dc.b $3A, $39, $38, $37, $36
		dc.b $35, $34, $33, $32, $31
		dc.b $30, $30, $30, $30, $30
		dc.b $30
; ---------------------------------------------------------------------------

ObjFloorLavaball:
		moveq	#0,d0
		move.b	$24(a0),d0
		move.w	off_91F2(pc,d0.w),d1
		jmp	off_91F2(pc,d1.w)
; ---------------------------------------------------------------------------

off_91F2:	dc.w loc_91F8-off_91F2, loc_9240-off_91F2, loc_92BA-off_91F2
; ---------------------------------------------------------------------------

loc_91F8:
		addq.b	#2,$24(a0)
		move.l	#MapLavaball,4(a0)
		move.w	#$345,2(a0)
		move.w	8(a0),$2A(a0)
		move.b	#4,1(a0)
		move.b	#1,$19(a0)
		move.b	#$8B,$20(a0)
		move.b	#8,$18(a0)
		move.w	#sfx_Burning,d0
		jsr	(PlaySFX).l
		tst.b	$28(a0)
		beq.s	loc_9240
		addq.b	#2,$24(a0)
		bra.w	loc_92BA
; ---------------------------------------------------------------------------

loc_9240:
		movea.l	$30(a0),a1
		move.w	8(a0),d1
		sub.w	$2A(a0),d1
		addi.w	#$C,d1
		move.w	d1,d0
		lsr.w	#1,d0
		move.b	(a1,d0.w),d0
		neg.w	d0
		add.w	$2C(a0),d0
		move.w	d0,d2
		add.w	$3C(a0),d0
		move.w	d0,$C(a0)
		cmpi.w	#$84,d1
		bcc.s	loc_92B8
		addi.l	#$10000,8(a0)
		cmpi.w	#$80,d1
		bcc.s	loc_92B8
		move.l	8(a0),d0
		addi.l	#$80000,d0
		andi.l	#$FFFFF,d0
		bne.s	loc_92B8
		bsr.w	LoadNextObject
		bne.s	loc_92B8
		move.b	#$35,0(a1)
		move.w	8(a0),8(a1)
		move.w	d2,$2C(a1)
		move.w	$3C(a0),$3C(a1)
		move.b	#1,$28(a1)
		movea.l	$38(a0),a2
		bsr.w	sub_90A4

loc_92B8:
		bra.s	loc_92C6
; ---------------------------------------------------------------------------

loc_92BA:
		move.w	$2C(a0),d0
		add.w	$3C(a0),d0
		move.w	d0,$C(a0)

loc_92C6:
		lea	(AniFloorLavaball).l,a1
		bsr.w	ObjectAnimate
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------
		include "levels\MZ\FloorLavaball\Sprite.ani"
		include "levels\MZ\Platform\Sprite.map"
		include "levels\MZ\FloorLavaball\Sprite.map"
		even
; ---------------------------------------------------------------------------

ObjGlassBlock:
		moveq	#0,d0
		move.b	$24(a0),d0
		move.w	off_93DE(pc,d0.w),d1
		jsr	off_93DE(pc,d1.w)
		bsr.w	DisplaySprite
		move.w	8(a0),d0
		andi.w	#$FF80,d0
		move.w	(v_screenposx).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0
		cmpi.w	#$280,d0
		bhi.w	loc_93D8
		rts
; ---------------------------------------------------------------------------

loc_93D8:
		bsr.w	DeleteObject
		rts
; ---------------------------------------------------------------------------

off_93DE:	dc.w loc_93FA-off_93DE, loc_9498-off_93DE, loc_94B0-off_93DE, loc_94CA-off_93DE, loc_94D8-off_93DE
		dc.w loc_9500-off_93DE

byte_93EA:	dc.b 2, 4, 0
		dc.b 4, $48, 1
		dc.b 6, 4, 2
		even

byte_93F4:	dc.b 8, 0, 3
		dc.b $A, 0, 2
; ---------------------------------------------------------------------------

loc_93FA:
		lea	(byte_93EA).l,a2
		moveq	#2,d1
		cmpi.b	#3,$28(a0)
		bcs.s	loc_9412
		lea	(byte_93F4).l,a2
		moveq	#1,d1

loc_9412:
		movea.l	a0,a1
		bra.s	loc_941C
; ---------------------------------------------------------------------------

loc_9416:
		bsr.w	LoadNextObject
		bne.s	loc_9486

loc_941C:
		move.b	(a2)+,$24(a1)
		move.b	#$30,0(a1)
		move.w	8(a0),8(a1)
		move.b	(a2)+,d0
		ext.w	d0
		add.w	$C(a0),d0
		move.w	d0,$C(a1)
		move.l	#MapGlassBlock,4(a1)
		move.w	#$C38E,2(a1)
		move.b	#4,1(a1)
		move.w	$C(a1),$30(a1)
		move.b	$28(a0),$28(a1)
		move.b	#$20,$18(a1)
		move.b	#4,$19(a1)
		move.b	(a2)+,$1A(a1)
		move.l	a0,$3C(a1)
		dbf	d1,loc_9416
		move.b	#$10,$18(a1)
		move.b	#3,$19(a1)
		addq.b	#8,$28(a1)
		andi.b	#$F,$28(a1)

loc_9486:
		move.w	#$90,$32(a0)
		move.b	#$38,$16(a0)
		bset	#4,1(a0)

loc_9498:
		bsr.w	sub_9514
		move.w	#$2B,d1
		move.w	#$24,d2
		move.w	#$24,d3
		move.w	8(a0),d4
		bra.w	SolidObject
; ---------------------------------------------------------------------------

loc_94B0:
		movea.l	$3C(a0),a1
		move.w	$32(a1),$32(a0)
		bsr.w	sub_9514
		move.w	#$2B,d1
		move.w	#$24,d2
		bra.w	sub_6936
; ---------------------------------------------------------------------------

loc_94CA:
		movea.l	$3C(a0),a1
		move.w	$32(a1),$32(a0)
		bra.w	sub_9514
; ---------------------------------------------------------------------------

loc_94D8:
		bsr.w	sub_9514
		move.w	#$2B,d1
		move.w	#$38,d2
		move.w	#$38,d3
		move.w	8(a0),d4
		bsr.w	SolidObject
		cmpi.b	#8,$24(a0)
		beq.s	locret_94FE
		move.b	#8,$24(a0)

locret_94FE:
		rts
; ---------------------------------------------------------------------------

loc_9500:
		movea.l	$3C(a0),a1
		move.w	$32(a1),$32(a0)
		move.w	$C(a1),$30(a0)
		bra.w	*+4
; ---------------------------------------------------------------------------

sub_9514:
		moveq	#0,d0
		move.b	$28(a0),d0
		andi.w	#7,d0
		add.w	d0,d0
		move.w	off_9528(pc,d0.w),d1
		jmp	off_9528(pc,d1.w)
; ---------------------------------------------------------------------------

off_9528:	dc.w locret_9532-off_9528, loc_9534-off_9528, loc_9540-off_9528
		dc.w loc_9550-off_9528, loc_95D6-off_9528
; ---------------------------------------------------------------------------

locret_9532:
		rts
; ---------------------------------------------------------------------------

loc_9534:
		move.b	(oscValues+$12).w,d0
		move.w	#$40,d1
		bra.w	loc_9616
; ---------------------------------------------------------------------------

loc_9540:
		move.b	(oscValues+$12).w,d0
		move.w	#$40,d1
		neg.w	d0
		add.w	d1,d0
		bra.w	loc_9616
; ---------------------------------------------------------------------------

loc_9550:
		btst	#3,$28(a0)
		beq.s	loc_9564
		move.b	(oscValues+$12).w,d0
		subi.w	#$10,d0
		bra.w	loc_9624
; ---------------------------------------------------------------------------

loc_9564:
		btst	#3,$22(a0)
		bne.s	loc_9574
		bclr	#0,$34(a0)
		bra.s	loc_95A8
; ---------------------------------------------------------------------------

loc_9574:
		tst.b	$34(a0)
		bne.s	loc_95A8
		move.b	#1,$34(a0)
		bset	#0,$35(a0)
		beq.s	loc_95A8
		bset	#7,$34(a0)
		move.w	#$10,$36(a0)
		move.b	#$A,$38(a0)
		cmpi.w	#$40,$32(a0)
		bne.s	loc_95A8
		move.w	#$40,$36(a0)

loc_95A8:
		tst.b	$34(a0)
		bpl.s	loc_95D0
		tst.b	$38(a0)
		beq.s	loc_95BA
		subq.b	#1,$38(a0)
		bne.s	loc_95D0

loc_95BA:
		tst.w	$32(a0)
		beq.s	loc_95CA
		subq.w	#1,$32(a0)
		subq.w	#1,$36(a0)
		bne.s	loc_95D0

loc_95CA:
		bclr	#7,$34(a0)

loc_95D0:
		move.w	$32(a0),d0
		bra.s	loc_9624
; ---------------------------------------------------------------------------

loc_95D6:
		btst	#3,$28(a0)
		beq.s	loc_95E8
		move.b	(oscValues+$12).w,d0
		subi.w	#$10,d0
		bra.s	loc_9624
; ---------------------------------------------------------------------------

loc_95E8:
		tst.b	$34(a0)
		bne.s	loc_9606
		lea	(unk_FFF7E0).w,a2
		moveq	#0,d0
		move.b	$28(a0),d0
		lsr.w	#4,d0
		tst.b	(a2,d0.w)
		beq.s	loc_9610
		move.b	#1,$34(a0)

loc_9606:
		tst.w	$32(a0)
		beq.s	loc_9610
		subq.w	#2,$32(a0)

loc_9610:
		move.w	$32(a0),d0
		bra.s	loc_9624
; ---------------------------------------------------------------------------

loc_9616:
		btst	#3,$28(a0)
		beq.s	loc_9624
		neg.w	d0
		add.w	d1,d0
		lsr.b	#1,d0

loc_9624:
		move.w	$30(a0),d1
		sub.w	d0,d1
		move.w	d1,$C(a0)
		rts
; ---------------------------------------------------------------------------
		include "levels\MZ\GlassBlock\Sprite.map"
		even
; ---------------------------------------------------------------------------

ObjChainPtfm:
		moveq	#0,d0
		move.b	$24(a0),d0
		move.w	off_96C2(pc,d0.w),d1
		jmp	off_96C2(pc,d1.w)
; ---------------------------------------------------------------------------

off_96C2:	dc.w loc_96EA-off_96C2, loc_97D0-off_96C2, loc_9834-off_96C2, loc_9846-off_96C2, loc_9818-off_96C2

byte_96CC:	dc.b 0, 0
		dc.b 1, 0

byte_96D0:	dc.b 2, 0, 0
		dc.b 4, $1C, 1
		dc.b 8, $CC, 3
		dc.b 6, $F0, 2

word_96DC:	dc.w $7000, $A000
		dc.w $5000, $7800
		dc.w $3800, $5800
		dc.w $B800
; ---------------------------------------------------------------------------

loc_96EA:
		moveq	#0,d0
		move.b	$28(a0),d0
		bpl.s	loc_9706
		andi.w	#$7F,d0
		add.w	d0,d0
		lea	byte_96CC(pc,d0.w),a2
		move.b	(a2)+,$3A(a0)
		move.b	(a2)+,d0
		move.b	d0,$28(a0)

loc_9706:
		andi.b	#$F,d0
		add.w	d0,d0
		move.w	word_96DC(pc,d0.w),d2
		tst.w	d0
		bne.s	loc_9718
		move.w	d2,$32(a0)

loc_9718:
		lea	(byte_96D0).l,a2
		movea.l	a0,a1
		moveq	#3,d1
		bra.s	loc_972C
; ---------------------------------------------------------------------------

loc_9724:
		bsr.w	LoadNextObject
		bne.w	loc_97B0

loc_972C:
		move.b	(a2)+,$24(a1)
		move.b	#$31,0(a1)
		move.w	8(a0),8(a1)
		move.b	(a2)+,d0
		ext.w	d0
		add.w	$C(a0),d0
		move.w	d0,$C(a1)
		move.l	#MapChainPtfm,4(a1)
		move.w	#$300,2(a1)
		move.b	#4,1(a1)
		move.w	$C(a1),$30(a1)
		move.b	$28(a0),$28(a1)
		move.b	#$10,$18(a1)
		move.w	d2,$34(a1)
		move.b	#4,$19(a1)
		move.b	(a2)+,$1A(a1)
		cmpi.b	#1,$1A(a1)
		bne.s	loc_97A2
		subq.w	#1,d1
		move.b	$28(a0),d0
		andi.w	#$F0,d0
		cmpi.w	#$20,d0
		beq.s	loc_972C
		move.b	#$38,$18(a1)
		move.b	#$90,$20(a1)
		addq.w	#1,d1

loc_97A2:
		move.l	a0,$3C(a1)
		dbf	d1,loc_9724
		move.b	#3,$19(a1)

loc_97B0:
		moveq	#0,d0
		move.b	$28(a0),d0
		lsr.w	#3,d0
		andi.b	#$E,d0
		lea	byte_97CA(pc,d0.w),a2
		move.b	(a2)+,$18(a0)
		move.b	(a2)+,$1A(a0)
		bra.s	loc_97D0
; ---------------------------------------------------------------------------

byte_97CA:	dc.b $38, 0
		dc.b $30, 9
		dc.b $10, $A
; ---------------------------------------------------------------------------

loc_97D0:
		bsr.w	sub_986A
		move.w	$C(a0),(unk_FFF7A4).w
		moveq	#0,d1
		move.b	$18(a0),d1
		addi.w	#$B,d1
		move.w	#$C,d2
		move.w	#$D,d3
		move.w	8(a0),d4
		bsr.w	SolidObject
		btst	#3,$22(a0)
		beq.s	loc_9810
		cmpi.b	#$10,$32(a0)
		bcc.s	loc_9810
		movea.l	a0,a2
		lea	(v_objspace).w,a0
		bsr.w	loc_FD78
		movea.l	a2,a0

loc_9810:
		bsr.w	DisplaySprite
		bra.w	loc_984A
; ---------------------------------------------------------------------------

loc_9818:
		move.b	#$80,$16(a0)
		bset	#4,1(a0)
		movea.l	$3C(a0),a1
		move.b	$32(a1),d0
		lsr.b	#5,d0
		addq.b	#3,d0
		move.b	d0,$1A(a0)

loc_9834:
		movea.l	$3C(a0),a1
		moveq	#0,d0
		move.b	$32(a1),d0
		add.w	$30(a0),d0
		move.w	d0,$C(a0)

loc_9846:
		bsr.w	DisplaySprite

loc_984A:
		move.w	8(a0),d0
		andi.w	#$FF80,d0
		move.w	(v_screenposx).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0
		cmpi.w	#$280,d0
		bhi.w	DeleteObject
		rts
; ---------------------------------------------------------------------------

sub_986A:
		move.b	$28(a0),d0
		andi.w	#$F,d0
		add.w	d0,d0
		move.w	off_987C(pc,d0.w),d1
		jmp	off_987C(pc,d1.w)
; ---------------------------------------------------------------------------

off_987C:	dc.w loc_988A-off_987C, loc_9926-off_987C, loc_9926-off_987C, loc_99B6-off_987C, loc_9926-off_987C
		dc.w loc_99B6-off_987C, loc_9926-off_987C
; ---------------------------------------------------------------------------

loc_988A:
		lea	(unk_FFF7E0).w,a2
		moveq	#0,d0
		move.b	$3A(a0),d0
		tst.b	(a2,d0.w)
		beq.s	loc_98DE
		tst.w	(unk_FFF7A4).w
		bpl.s	loc_98A8
		cmpi.b	#$10,$32(a0)
		beq.s	loc_98D6

loc_98A8:
		tst.w	$32(a0)
		beq.s	loc_98D6
		move.b	(byte_FFFE0F).w,d0
		andi.b	#$F,d0
		bne.s	loc_98C8
		tst.b	1(a0)
		bpl.s	loc_98C8
		move.w	#sfx_ChainRise,d0
		jsr	(PlaySFX).l

loc_98C8:
		subi.w	#$80,$32(a0)
		bcc.s	loc_9916
		move.w	#0,$32(a0)

loc_98D6:
		move.w	#0,$12(a0)
		bra.s	loc_9916
; ---------------------------------------------------------------------------

loc_98DE:
		move.w	$34(a0),d1
		cmp.w	$32(a0),d1
		beq.s	loc_9916
		move.w	$12(a0),d0
		addi.w	#$70,$12(a0)
		add.w	d0,$32(a0)
		cmp.w	$32(a0),d1
		bhi.s	loc_9916
		move.w	d1,$32(a0)
		move.w	#0,$12(a0)
		tst.b	1(a0)
		bpl.s	loc_9916
		move.w	#sfx_ChainStomp,d0
		jsr	(PlaySFX).l

loc_9916:
		moveq	#0,d0
		move.b	$32(a0),d0
		add.w	$30(a0),d0
		move.w	d0,$C(a0)
		rts
; ---------------------------------------------------------------------------

loc_9926:
		tst.w	$36(a0)
		beq.s	loc_996E
		tst.w	$38(a0)
		beq.s	loc_9938
		subq.w	#1,$38(a0)
		bra.s	loc_99B2
; ---------------------------------------------------------------------------

loc_9938:
		move.b	(byte_FFFE0F).w,d0
		andi.b	#$F,d0
		bne.s	loc_9952
		tst.b	1(a0)
		bpl.s	loc_9952
		move.w	#sfx_ChainRise,d0
		jsr	(PlaySFX).l

loc_9952:
		subi.w	#$80,$32(a0)
		bcc.s	loc_99B2
		move.w	#0,$32(a0)
		move.w	#0,$12(a0)
		move.w	#0,$36(a0)
		bra.s	loc_99B2
; ---------------------------------------------------------------------------

loc_996E:
		move.w	$34(a0),d1
		cmp.w	$32(a0),d1
		beq.s	loc_99B2
		move.w	$12(a0),d0
		addi.w	#$70,$12(a0)
		add.w	d0,$32(a0)
		cmp.w	$32(a0),d1
		bhi.s	loc_99B2
		move.w	d1,$32(a0)
		move.w	#0,$12(a0)
		move.w	#1,$36(a0)
		move.w	#$3C,$38(a0)
		tst.b	1(a0)
		bpl.s	loc_99B2
		move.w	#sfx_ChainStomp,d0
		jsr	(PlaySFX).l

loc_99B2:
		bra.w	loc_9916
; ---------------------------------------------------------------------------

loc_99B6:
		move.w	(v_objspace+8).w,d0
		sub.w	8(a0),d0
		bcc.s	loc_99C2
		neg.w	d0

loc_99C2:
		cmpi.w	#$90,d0
		bcc.s	loc_99CC
		addq.b	#1,$28(a0)

loc_99CC:
		bra.w	loc_9916
; ---------------------------------------------------------------------------

Obj45:
		moveq	#0,d0
		move.b	act(a0),d0
		move.w	off_99DE(pc,d0.w),d1
		jmp	off_99DE(pc,d1.w)
; ---------------------------------------------------------------------------

off_99DE:	dc.w loc_99FA-off_99DE, loc_9A8E-off_99DE, loc_9AC4-off_99DE, loc_9AD8-off_99DE, loc_9AB0-off_99DE

byte_99E8:	dc.b 2, 4, 0
		dc.b 4, $E4, 1
		dc.b 8, $34, 3
		dc.b 6, $28, 2

word_99F4:	dc.w $3800, $A000, $5000
; ---------------------------------------------------------------------------

loc_99FA:
		moveq	#0,d0
		move.b	arg(a0),d0
		add.w	d0,d0
		move.w	word_99F4(pc,d0.w),d2
		lea	(byte_99E8).l,a2
		movea.l	a0,a1
		moveq	#3,d1
		bra.s	loc_9A18
; ---------------------------------------------------------------------------

loc_9A12:
		bsr.w	LoadNextObject
		bne.s	loc_9A88

loc_9A18:
		move.b	(a2)+,act(a1)
		move.b	#$45,id(a1)
		move.w	ypos(a0),ypos(a1)
		move.b	(a2)+,d0
		ext.w	d0
		add.w	xpos(a0),d0
		move.w	d0,xpos(a1)
		move.l	#Map45,map(a1)
		move.w	#$300,tile(a1)
		move.b	#map,render(a1)
		move.w	xpos(a1),$30(a1)
		move.w	xpos(a0),$3A(a1)
		move.b	arg(a0),arg(a1)
		move.b	#$20,xdisp(a1)
		move.w	d2,$34(a1)
		move.b	#4,prio(a1)
		cmpi.b	#1,(a2)
		bne.s	loc_9A76
		move.b	#$91,col(a1)

loc_9A76:
		move.b	(a2)+,frame(a1)
		move.l	a0,$3C(a1)
		dbf	d1,loc_9A12
		move.b	#3,prio(a1)

loc_9A88:
		move.b	#$10,xdisp(a0)

loc_9A8E:
		move.w	xpos(a0),-(sp)
		bsr.w	sub_9AFC
		move.w	#$17,d1
		move.w	#$20,d2
		move.w	#$20,d3
		move.w	(sp)+,d4
		bsr.w	SolidObject
		bsr.w	DisplaySprite
		bra.w	loc_9ADC
; ---------------------------------------------------------------------------

loc_9AB0:
		movea.l	$3C(a0),a1
		move.b	$32(a1),d0
		addi.b	#$10,d0
		lsr.b	#5,d0
		addq.b	#3,d0
		move.b	d0,frame(a0)

loc_9AC4:
		movea.l	$3C(a0),a1
		moveq	#0,d0
		move.b	$32(a1),d0
		neg.w	d0
		add.w	$30(a0),d0
		move.w	d0,xpos(a0)

loc_9AD8:
		bsr.w	DisplaySprite

loc_9ADC:
		move.w	$3A(a0),d0
		andi.w	#$FF80,d0
		move.w	(v_screenposx).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0
		cmpi.w	#640,d0
		bhi.w	DeleteObject
		rts
; ---------------------------------------------------------------------------

sub_9AFC:
		moveq	#0,d0
		move.b	arg(a0),d0
		add.w	d0,d0
		move.w	off_9B0C(pc,d0.w),d1
		jmp	off_9B0C(pc,d1.w)
; ---------------------------------------------------------------------------

off_9B0C:	dc.w loc_9B10-off_9B0C, loc_9B10-off_9B0C
; ---------------------------------------------------------------------------

loc_9B10:
		tst.w	$36(a0)
		beq.s	loc_9B3E
		tst.w	$38(a0)
		beq.s	loc_9B22
		subq.w	#1,$38(a0)
		bra.s	loc_9B72
; ---------------------------------------------------------------------------

loc_9B22:
		subi.w	#$80,$32(a0)
		bcc.s	loc_9B72
		move.w	#0,$32(a0)
		move.w	#0,xvel(a0)
		move.w	#0,$36(a0)
		bra.s	loc_9B72
; ---------------------------------------------------------------------------

loc_9B3E:
		move.w	$34(a0),d1
		cmp.w	$32(a0),d1
		beq.s	loc_9B72
		move.w	xvel(a0),d0
		addi.w	#$70,xvel(a0)
		add.w	d0,$32(a0)
		cmp.w	$32(a0),d1
		bhi.s	loc_9B72
		move.w	d1,$32(a0)
		move.w	#0,xvel(a0)
		move.w	#1,$36(a0)
		move.w	#$3C,$38(a0)

loc_9B72:
		moveq	#0,d0
		move.b	$32(a0),d0
		neg.w	d0
		add.w	$30(a0),d0
		move.w	d0,xpos(a0)
		rts
; ---------------------------------------------------------------------------
		include "levels\MZ\ChainPtfm\Sprite.map"
		even
		include "_maps\45.asm"
		even
		
		include "_incObj\32 Button.asm"

		include "levels\shared\Switch\Sprite.map"
		even
; ---------------------------------------------------------------------------

ObjPushBlock:
		moveq	#0,d0
		move.b	$24(a0),d0
		move.w	off_9F10(pc,d0.w),d1
		jmp	off_9F10(pc,d1.w)
; ---------------------------------------------------------------------------

off_9F10:	dc.w loc_9F1A-off_9F10, loc_9F84-off_9F10, loc_A00C-off_9F10

byte_9F16:	dc.b $10, 0
		dc.b $40, 1
; ---------------------------------------------------------------------------

loc_9F1A:
		addq.b	#2,$24(a0)
		move.b	#$F,$16(a0)
		move.b	#$F,$17(a0)
		move.l	#MapPushBlock,4(a0)
		move.w	#$42B8,2(a0)
		move.b	#4,1(a0)
		move.b	#3,$19(a0)
		moveq	#0,d0
		move.b	$28(a0),d0
		add.w	d0,d0
		andi.w	#$E,d0
		lea	byte_9F16(pc,d0.w),a2
		move.b	(a2)+,$18(a0)
		move.b	(a2)+,$1A(a0)
		tst.b	$28(a0)
		beq.s	loc_9F68
		move.w	#$C2B8,2(a0)

loc_9F68:
		lea	(v_regbuffer).w,a2
		moveq	#0,d0
		move.b	$23(a0),d0
		beq.s	loc_9F84
		bclr	#7,2(a2,d0.w)
		btst	#0,2(a2,d0.w)
		bne.w	DeleteObject

loc_9F84:
		moveq	#0,d1
		move.b	$18(a0),d1
		addi.w	#$B,d1
		move.w	#$10,d2
		move.w	#$11,d3
		move.w	8(a0),d4
		bsr.w	sub_A14E
		cmpi.w	#$200,(v_zone).w
		bne.s	loc_9FD4
		bclr	#7,$28(a0)
		move.w	8(a0),d0
		cmpi.w	#$A20,d0
		bcs.s	loc_9FD4
		cmpi.w	#$AA1,d0
		bcc.s	loc_9FD4
		move.w	(unk_FFF7A4).w,d0
		subi.w	#$1C,d0
		move.w	d0,$C(a0)
		bset	#7,(unk_FFF7A4).w
		bset	#7,$28(a0)

loc_9FD4:
		bsr.w	DisplaySprite
		move.w	8(a0),d0
		andi.w	#$FF80,d0
		move.w	(v_screenposx).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0
		cmpi.w	#$280,d0
		bhi.s	loc_9FF6
		rts
; ---------------------------------------------------------------------------

loc_9FF6:
		lea	(v_regbuffer).w,a2
		moveq	#0,d0
		move.b	$23(a0),d0
		beq.s	loc_A008
		bclr	#0,2(a2,d0.w)

loc_A008:
		bra.w	DeleteObject
; ---------------------------------------------------------------------------

loc_A00C:
		move.w	8(a0),-(sp)
		cmpi.b	#4,$25(a0)
		bcc.s	loc_A01C
		bsr.w	SpeedToPos

loc_A01C:
		btst	#1,$22(a0)
		beq.s	loc_A05E
		addi.w	#$18,$12(a0)
		bsr.w	ObjectHitFloor
		tst.w	d1
		bpl.w	loc_A05C
		add.w	d1,$C(a0)
		clr.w	$12(a0)
		bclr	#1,$22(a0)
		move.w	(a1),d0
		andi.w	#$3FF,d0
		cmpi.w	#$2D2,d0
		bcs.s	loc_A05C
		move.w	$30(a0),d0
		asr.w	#3,d0
		move.w	d0,$10(a0)
		clr.w	$E(a0)

loc_A05C:
		bra.s	loc_A0A0
; ---------------------------------------------------------------------------

loc_A05E:
		tst.w	$10(a0)
		beq.w	loc_A090
		bmi.s	loc_A078
		moveq	#0,d3
		move.b	$18(a0),d3
		bsr.w	ObjectHitWallRight
		tst.w	d1
		bmi.s	loc_A08A
		bra.s	loc_A0A0
; ---------------------------------------------------------------------------

loc_A078:
		moveq	#0,d3
		move.b	$18(a0),d3
		not.w	d3
		bsr.w	ObjectHitWallLeft
		tst.w	d1
		bmi.s	loc_A08A
		bra.s	loc_A0A0
; ---------------------------------------------------------------------------

loc_A08A:
		clr.w	$10(a0)
		bra.s	loc_A0A0
; ---------------------------------------------------------------------------

loc_A090:
		addi.l	#$2001,$C(a0)
		cmpi.b	#$A0,$F(a0)
		bcc.s	loc_A0CC

loc_A0A0:
		moveq	#0,d1
		move.b	$18(a0),d1
		addi.w	#$B,d1
		move.w	#$10,d2
		move.w	#$11,d3
		move.w	(sp)+,d4
		bsr.w	sub_A14E
		cmpi.b	#4,$24(a0)
		beq.s	loc_A0C6
		move.b	#4,$24(a0)

loc_A0C6:
		bsr.s	sub_A0E2
		bra.w	loc_9FD4
; ---------------------------------------------------------------------------

loc_A0CC:
		move.w	(sp)+,d4
		lea	(v_objspace).w,a1
		bclr	#3,$22(a1)
		bclr	#3,$22(a0)
		bra.w	loc_9FF6
; ---------------------------------------------------------------------------

sub_A0E2:
		cmpi.w	#$201,(v_zone).w
		bne.s	loc_A108
		move.w	#$FFE0,d2
		cmpi.w	#$DD0,8(a0)
		beq.s	loc_A126
		cmpi.w	#$CC0,8(a0)
		beq.s	loc_A126
		cmpi.w	#$BA0,8(a0)
		beq.s	loc_A126
		rts
; ---------------------------------------------------------------------------

loc_A108:
		cmpi.w	#$202,(v_zone).w
		bne.s	locret_A124
		move.w	#$20,d2
		cmpi.w	#$560,8(a0)
		beq.s	loc_A126
		cmpi.w	#$5C0,8(a0)
		beq.s	loc_A126

locret_A124:
		rts
; ---------------------------------------------------------------------------

loc_A126:
		bsr.w	ObjectLoad
		bne.s	locret_A14C
		move.b	#$4C,0(a1)
		move.w	8(a0),8(a1)
		add.w	d2,8(a1)
		move.w	$C(a0),$C(a1)
		addi.w	#$10,$C(a1)
		move.l	a0,$3C(a1)

locret_A14C:
		rts
; ---------------------------------------------------------------------------

sub_A14E:
		move.b	$25(a0),d0
		beq.w	loc_A1DE
		subq.b	#2,d0
		bne.s	loc_A172
		bsr.w	PtfmCheckExit
		btst	#3,$22(a1)
		bne.s	loc_A16C
		clr.b	$25(a0)
		rts
; ---------------------------------------------------------------------------

loc_A16C:
		move.w	d4,d2
		bra.w	PtfmSurfaceHeight
; ---------------------------------------------------------------------------

loc_A172:
		subq.b	#2,d0
		bne.s	loc_A1B8
		bsr.w	SpeedToPos
		addi.w	#$18,$12(a0)
		bsr.w	ObjectHitFloor
		tst.w	d1
		bpl.w	locret_A1B6
		add.w	d1,$C(a0)
		clr.w	$12(a0)
		clr.b	$25(a0)
		move.w	(a1),d0
		andi.w	#$3FF,d0
		cmpi.w	#$2D2,d0
		bcs.s	locret_A1B6
		move.w	$30(a0),d0
		asr.w	#3,d0
		move.w	d0,$10(a0)
		move.b	#4,$24(a0)
		clr.w	$E(a0)

locret_A1B6:
		rts
; ---------------------------------------------------------------------------

loc_A1B8:
		bsr.w	SpeedToPos
		move.w	8(a0),d0
		andi.w	#$C,d0
		bne.w	locret_A29A
		andi.w	#$FFF0,8(a0)
		move.w	$10(a0),$30(a0)
		clr.w	$10(a0)
		subq.b	#2,$25(a0)
		rts
; ---------------------------------------------------------------------------

loc_A1DE:
		bsr.w	loc_A37C
		tst.w	d4
		beq.w	locret_A29A
		bmi.w	locret_A29A
		tst.w	d0
		beq.w	locret_A29A
		bmi.s	loc_A222
		btst	#0,$22(a1)
		bne.w	locret_A29A
		move.w	d0,-(sp)
		moveq	#0,d3
		move.b	$18(a0),d3
		bsr.w	ObjectHitWallRight
		move.w	(sp)+,d0
		tst.w	d1
		bmi.w	locret_A29A
		addi.l	#loc_10000,8(a0)
		moveq	#1,d0
		move.w	#$40,d1
		bra.s	loc_A24C
; ---------------------------------------------------------------------------

loc_A222:
		btst	#0,$22(a1)
		beq.s	locret_A29A
		move.w	d0,-(sp)
		moveq	#0,d3
		move.b	$18(a0),d3
		not.w	d3
		bsr.w	ObjectHitWallLeft
		move.w	(sp)+,d0
		tst.w	d1
		bmi.s	locret_A29A
		subi.l	#loc_10000,8(a0)
		moveq	#$FFFFFFFF,d0
		move.w	#$FFC0,d1

loc_A24C:
		lea	(v_objspace).w,a1
		add.w	d0,8(a1)
		move.w	d1,$14(a1)
		move.w	#0,$10(a1)
		move.w	d0,-(sp)
		move.w	#sfx_Push,d0
		jsr	(PlaySFX).l
		move.w	(sp)+,d0
		tst.b	$28(a0)
		bmi.s	locret_A29A
		move.w	d0,-(sp)
		bsr.w	ObjectHitFloor
		move.w	(sp)+,d0
		cmpi.w	#4,d1
		ble.s	loc_A296
		move.w	#$400,$10(a0)
		tst.w	d0
		bpl.s	loc_A28E
		neg.w	$10(a0)

loc_A28E:
		move.b	#6,$25(a0)
		bra.s	locret_A29A
; ---------------------------------------------------------------------------

loc_A296:
		add.w	d1,$C(a0)

locret_A29A:
		rts
; ---------------------------------------------------------------------------
		include "levels\MZ\PushBlock\Sprite.map"
		even
; ---------------------------------------------------------------------------

SolidObject:
		cmpi.b	#6,(v_objspace+$24).w
		bcc.w	loc_A2FE
		tst.b	subact(a0)
		beq.w	loc_A37C
		move.w	d1,d2
		add.w	d2,d2
		lea	(v_objspace).w,a1
		btst	#1,status(a1)
		bne.s	loc_A2EE
		move.w	8(a1),d0
		sub.w	8(a0),d0
		add.w	d1,d0
		bmi.s	loc_A2EE
		cmp.w	d2,d0
		bcs.s	loc_A302

loc_A2EE:
		bclr	#3,status(a1)
		bclr	#3,status(a0)
		clr.b	subact(a0)

loc_A2FE:
		moveq	#0,d4
		rts
; ---------------------------------------------------------------------------

loc_A302:
		move.w	d4,d2
		bsr.w	PtfmSurfaceHeight
		moveq	#0,d4
		rts
; ---------------------------------------------------------------------------

loc_A30C:
		tst.w	(DebugRoutine).w
		bne.w	loc_A448
		tst.b	render(a0)
		bpl.w	loc_A42E
		lea	(v_objspace).w,a1
		move.w	xpos(a1),d0
		sub.w	xpos(a0),d0
		add.w	d1,d0
		bmi.w	loc_A42E
		move.w	d1,d3
		add.w	d3,d3
		cmp.w	d3,d0
		bhi.w	loc_A42E
		move.w	d0,d5
		btst	#0,render(a0)
		beq.s	loc_A346
		not.w	d5
		add.w	d3,d5

loc_A346:
		lsr.w	#1,d5
		moveq	#0,d3
		move.b	(a2,d5.w),d3
		sub.b	(a2),d3
		move.w	ypos(a0),d5
		sub.w	d3,d5
		move.b	yrad(a1),d3
		ext.w	d3
		add.w	d3,d2
		move.w	ypos(a1),d3
		sub.w	d5,d3
		addq.w	#4,d3
		add.w	d2,d3
		bmi.w	loc_A42E
		subq.w	#4,d3
		move.w	d2,d4
		add.w	d4,d4
		cmp.w	d4,d3
		bcc.w	loc_A42E
		bra.w	loc_A3CC
; ---------------------------------------------------------------------------

loc_A37C:
		tst.w	(DebugRoutine).w
		bne.w	loc_A448
		tst.b	render(a0)
		bpl.w	loc_A42E
		lea	(v_objspace).w,a1
		move.w	xpos(a1),d0
		sub.w	xpos(a0),d0
		add.w	d1,d0
		bmi.w	loc_A42E
		move.w	d1,d3
		add.w	d3,d3
		cmp.w	d3,d0
		bhi.w	loc_A42E
		move.b	yrad(a1),d3
		ext.w	d3
		add.w	d3,d2
		move.w	ypos(a1),d3
		sub.w	ypos(a0),d3
		addq.w	#4,d3
		add.w	d2,d3
		bmi.w	loc_A42E
		subq.w	#4,d3
		move.w	d2,d4
		add.w	d4,d4
		cmp.w	d4,d3
		bcc.w	loc_A42E

loc_A3CC:
		move.w	d0,d5
		cmp.w	d0,d1
		bcc.s	loc_A3DA
		add.w	d1,d1
		sub.w	d1,d0
		move.w	d0,d5
		neg.w	d5

loc_A3DA:
		move.w	d3,d1
		cmp.w	d3,d2
		bcc.s	loc_A3E6
		sub.w	d4,d3
		move.w	d3,d1
		neg.w	d1

loc_A3E6:
		cmp.w	d1,d5
		bhi.w	loc_A44C
		tst.w	d0
		beq.s	loc_A40C
		bmi.s	loc_A3FA
		tst.w	xvel(a1)
		bmi.s	loc_A40C
		bra.s	loc_A400
; ---------------------------------------------------------------------------

loc_A3FA:
		tst.w	xvel(a1)
		bpl.s	loc_A40C

loc_A400:
		move.w	#0,inertia(a1)
		move.w	#0,xvel(a1)

loc_A40C:
		sub.w	d0,8(a1)
		btst	#1,status(a1)
		bne.s	loc_A428
		bset	#5,status(a1)
		bset	#5,status(a0)
		moveq	#1,d4
		rts
; ---------------------------------------------------------------------------

loc_A428:
		bsr.s	sub_A43C
		moveq	#1,d4
		rts
; ---------------------------------------------------------------------------

loc_A42E:
		btst	#5,status(a0)
		beq.s	loc_A448
		move.w	#1,ani(a1)
; ---------------------------------------------------------------------------

sub_A43C:
		bclr	#5,status(a0)
		bclr	#5,status(a1)

loc_A448:
		moveq	#0,d4
		rts
; ---------------------------------------------------------------------------

loc_A44C:
		tst.w	d3
		bmi.s	loc_A458

loc_A450:
		cmpi.w	#$10,d3
		bcs.s	loc_A488
		bra.s	loc_A42E
; ---------------------------------------------------------------------------

loc_A458:
		tst.w	yvel(a1)
		beq.s	loc_A472
		bpl.s	loc_A46E
		tst.w	d3
		bpl.s	loc_A46E
		sub.w	d3,ypos(a1)
		move.w	#0,yvel(a1)

loc_A46E:
		moveq	#-1,d4
		rts
; ---------------------------------------------------------------------------

loc_A472:
		btst	#1,status(a1)
		bne.s	loc_A46E
		move.l	a0,-(sp)
		movea.l	a1,a0
		bsr.w	loc_FD78
		movea.l	(sp)+,a0
		moveq	#-1,d4
		rts
; ---------------------------------------------------------------------------

loc_A488:
		moveq	#0,d1
		move.b	xdisp(a0),d1
		addq.w	#4,d1
		move.w	d1,d2
		add.w	d2,d2
		add.w	xpos(a1),d1
		sub.w	xpos(a0),d1
		bmi.s	loc_A4C4
		cmp.w	d2,d1
		bcc.s	loc_A4C4
		tst.w	yvel(a1)
		bmi.s	loc_A4C4
		sub.w	d3,ypos(a1)
		subq.w	#1,ypos(a1)
		bsr.w	loc_4FD4
		move.b	#2,subact(a0)
		bset	#3,status(a0)
		moveq	#-1,d4
		rts
; ---------------------------------------------------------------------------

loc_A4C4:
		moveq	#0,d4
		rts

                include "_incObj\34 Title Cards.asm"

                include "_incObj\39 Game Over.asm"

                include "_incObj\3A Got Through Act.asm"
; ===========================================================================
; Level Order
; ===========================================================================
word_A826:	dc.w $001				; GHZ2
		dc.w $002				; GHZ3
		dc.w $200				; MZ1
		dc.w $000				; Sega Screen
		dc.w $101				; LZ2
		dc.w $102				; LZ3
		dc.w $200				; MZ1
		dc.w $000				; Sega Screen
		dc.w $201				; MZ2
		dc.w $202				; MZ3
		dc.w $400				; SZ1
		dc.w $000				; Sega Screen
		dc.w $000				; Sega Screen
		dc.w $302				; SLZ3
		dc.w $200				; MZ1
		dc.w $000				; Sega Screen
		dc.w $300				; SLZ1
		dc.w $402				; SZ3
		dc.w $500				; CWZ1
		dc.w $000				; Sega Screen
		dc.w $501				; CWZ2
		dc.w $502				; CWZ3
		dc.w $000				; Sega Screen
		dc.w $000				; Sega Screen

word_A856:	dc.w 4, $124, $BC
		dc.b 2, 0
		dc.w $FEE0, $120, $D0
		dc.b 2, 1
		dc.w $40C, $14C, $D6
		dc.b 2, 6
		dc.w $520, $120, $EC
		dc.b 2, 2
		dc.w $540, $120, $FC
		dc.b 2, 3
		dc.w $560, $120, $10C
		dc.b 2, 4
		dc.w $20C, $14C, $CC
		dc.b 2, 5

		include "_maps\Title Cards.asm"
		even
		include "levels\shared\GameOver\Sprite.map"
		include "levels\shared\LevelResults\Sprite.map"
		even

		include "_incObj\36 Spikes.asm"

		include "levels\shared\Spikes\Sprite.map"
		even

		include "_incObj\3B Purple Rock.asm"
		include "_incObj\49 Waterfall Sound.asm"

		include "_maps\Purple Rock.asm"
		even

		include "_incObj\3C Smashable Wall.asm"
		include "_incObj\sub SmashObject.asm"

ObjSmashWall_FragRight:dc.w $400, $FB00
		dc.w $600, $FF00
		dc.w $600, $100
		dc.w $400, $500
		dc.w $600, $FA00
		dc.w $800, $FE00
		dc.w $800, $200
		dc.w $600, $600

ObjSmashWall_FragLeft:dc.w $FA00, $FA00
		dc.w $F800, $FE00
		dc.w $F800, $200
		dc.w $FA00, $600
		dc.w $FC00, $FB00
		dc.w $FA00, $FF00
		dc.w $FA00, $100
		dc.w $FC00, $500

		include "levels\GHZ\SmashWall\Sprite.map"
		even

                include "_incObj\3D Boss - Green Hill (part 1).asm"

sub_B146:
		move.b	(byte_FFFE0F).w,d0
		andi.b	#7,d0
		bne.s	locret_B186
		bsr.w	ObjectLoad
		bne.s	locret_B186
		move.b	#$3F,0(a1)
		move.w	8(a0),8(a1)
		move.w	$C(a0),$C(a1)
		jsr	(RandomNumber).l
		move.w	d0,d1
		moveq	#0,d1
		move.b	d0,d1
		lsr.b	#2,d1
		subi.w	#$20,d1
		add.w	d1,8(a1)
		lsr.w	#8,d0
		lsr.b	#3,d0
		add.w	d0,$C(a1)

locret_B186:
		rts
; ---------------------------------------------------------------------------

BossMove:
		move.l	$30(a0),d2
		move.l	$38(a0),d3
		move.w	$10(a0),d0
		ext.l	d0
		asl.l	#8,d0
		add.l	d0,d2
		move.w	$12(a0),d0
		ext.l	d0
		asl.l	#8,d0
		add.l	d0,d3
		move.l	d2,$30(a0)
		move.l	d3,$38(a0)
		rts

                include "_incObj\3D Boss - Green Hill (part 2).asm"
                include "_incObj\48 Eggman's Swinging Ball.asm"

		include "levels\GHZ\Boss\Sprite.ani"
		include "levels\GHZ\Boss\Sprite.map"
		even
		include "levels\GHZ\Boss\Ball.map"
		even

                include "_incObj\3E Prison Capsule.asm"

		include "levels\shared\Capsule\Sprite.ani"
		include "levels\shared\Capsule\Sprite.map"
		even

		include "_incObj\40 Motobug.asm"

		include "levels\GHZ\Motobug\Sprite.ani"
		include "levels\GHZ\Motobug\Sprite.map"
		even

		include "_incObj\41 Springs.asm"

		include "levels\shared\Spring\Sprite.ani"
		include "levels\shared\Spring\Sprite.map"
		even

		include "_incObj\42 Newtron.asm"

		include "levels\GHZ\Newtron\Sprite.ani"
		include "levels\GHZ\Newtron\Sprite.map"
		even
; ---------------------------------------------------------------------------

ObjRoller:
		moveq	#0,d0
		move.b	$24(a0),d0
		move.w	off_BFB8(pc,d0.w),d1
		jmp	off_BFB8(pc,d1.w)
; ---------------------------------------------------------------------------

off_BFB8:	dc.w loc_BFBE-off_BFB8, loc_C00C-off_BFB8, loc_C0B0-off_BFB8
; ---------------------------------------------------------------------------

loc_BFBE:
		move.b	#$E,$16(a0)
		move.b	#8,$17(a0)
		bsr.w	ObjectFall
		bsr.w	ObjectHitFloor
		tst.w	d1
		bpl.s	locret_C00A
		add.w	d1,$C(a0)
		move.w	#0,$12(a0)
		addq.b	#2,$24(a0)
		move.l	#MapRoller,4(a0)
		move.w	#$24B8,2(a0)
		move.b	#4,1(a0)
		move.b	#4,$19(a0)
		move.b	#$10,$18(a0)
		move.b	#$8E,$20(a0)

locret_C00A:
		rts
; ---------------------------------------------------------------------------

loc_C00C:
		moveq	#0,d0
		move.b	$25(a0),d0
		move.w	off_C028(pc,d0.w),d1
		jsr	off_C028(pc,d1.w)
		lea	(AniRoller).l,a1
		bsr.w	ObjectAnimate
		bra.w	ObjectChkDespawn
; ---------------------------------------------------------------------------

off_C028:	dc.w loc_C030-off_C028, loc_C052-off_C028, loc_C060-off_C028, loc_C08E-off_C028
; ---------------------------------------------------------------------------

loc_C030:
		move.w	(v_objspace+8).w,d0
		sub.w	8(a0),d0
		bcs.s	locret_C050
		cmpi.w	#$20,d0
		bcc.s	locret_C050
		addq.b	#2,$25(a0)
		move.b	#1,$1C(a0)
		move.w	#$400,$10(a0)

locret_C050:
		rts
; ---------------------------------------------------------------------------

loc_C052:
		cmpi.b	#2,$1C(a0)
		bne.s	locret_C05E
		addq.b	#2,$25(a0)

locret_C05E:
		rts
; ---------------------------------------------------------------------------

loc_C060:
		bsr.w	SpeedToPos
		bsr.w	ObjectHitFloor
		cmpi.w	#$FFF8,d1
		blt.s	loc_C07A
		cmpi.w	#$C,d1
		bge.s	loc_C07A
		add.w	d1,$C(a0)
		rts
; ---------------------------------------------------------------------------

loc_C07A:
		addq.b	#2,$25(a0)
		bset	#0,$32(a0)
		beq.s	locret_C08C
		move.w	#$FA00,$12(a0)

locret_C08C:
		rts
; ---------------------------------------------------------------------------

loc_C08E:
		bsr.w	ObjectFall
		tst.w	$12(a0)
		bmi.s	locret_C0AE
		bsr.w	ObjectHitFloor
		tst.w	d1
		bpl.s	locret_C0AE
		add.w	d1,$C(a0)
		subq.b	#2,$25(a0)

loc_C0A8:
		move.w	#0,$12(a0)

locret_C0AE:
		rts
; ---------------------------------------------------------------------------

loc_C0B0:
		bra.w	DeleteObject
; ---------------------------------------------------------------------------
		include "levels\shared\Roller\Sprite.ani"
		even
		include "levels\shared\Roller\Sprite.map"
		even
; ---------------------------------------------------------------------------

ObjWall:
		moveq	#0,d0
		move.b	act(a0),d0
		move.w	off_C10A(pc,d0.w),d1
		jmp	off_C10A(pc,d1.w)
; ---------------------------------------------------------------------------

off_C10A:	dc.w loc_C110-off_C10A, loc_C148-off_C10A, loc_C154-off_C10A
; ---------------------------------------------------------------------------

loc_C110:
		addq.b	#2,act(a0)
		move.l	#MapWall,map(a0)
		move.w	#$434C,tile(a0)
		ori.b	#4,render(a0)
		move.b	#8,xdisp(a0)
		move.b	#6,prio(a0)
		move.b	arg(a0),frame(a0)
		bclr	#4,frame(a0)
		beq.s	loc_C148
		addq.b	#2,act(a0)
		bra.s	loc_C154
; ---------------------------------------------------------------------------

loc_C148:
		move.w	#$13,d1
		move.w	#$28,d2
		bsr.w	sub_6936

loc_C154:
		bsr.w	DisplaySprite
		move.w	xpos(a0),d0
		andi.w	#$FF80,d0
		move.w	(v_screenposx).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0
		cmpi.w	#640,d0
		bhi.w	DeleteObject
		rts
; ---------------------------------------------------------------------------
		include "levels\GHZ\Wall\Sprite.map"
		even
; ---------------------------------------------------------------------------

ObjLavaMaker:
		moveq	#0,d0
		move.b	act(a0),d0
		move.w	off_C1D0(pc,d0.w),d1
		jsr	off_C1D0(pc,d1.w)
		bra.w	loc_C2E6
; ---------------------------------------------------------------------------

off_C1D0:	dc.w loc_C1DA-off_C1D0, loc_C1FA-off_C1D0

byte_C1D4:	dc.b $1E, $3C, $5A, $78, $96, $B4
; ---------------------------------------------------------------------------

loc_C1DA:
		addq.b	#2,act(a0)
		move.b	arg(a0),d0
		lsr.w	#4,d0
		andi.w	#$F,d0
		move.b	byte_C1D4(pc,d0.w),$1F(a0)
		move.b	$1F(a0),$1E(a0)
		andi.b	#$F,arg(a0)

loc_C1FA:
		subq.b	#1,$1E(a0)
		bne.s	locret_C22A
		move.b	$1F(a0),$1E(a0)
		bsr.w	ObjectChkOffscreen
		bne.s	locret_C22A
		bsr.w	ObjectLoad
		bne.s	locret_C22A
		move.b	#$14,id(a1)
		move.w	xpos(a0),xpos(a1)
		move.w	ypos(a0),ypos(a1)
		move.b	arg(a0),arg(a1)

locret_C22A:
		rts
; ---------------------------------------------------------------------------

ObjLavaball:
		moveq	#0,d0
		move.b	$24(a0),d0
		move.w	off_C23E(pc,d0.w),d1
		jsr	off_C23E(pc,d1.w)
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

off_C23E:	dc.w loc_C254-off_C23E, loc_C2C8-off_C23E, j_DeleteObject-off_C23E

word_C244:	dc.w $FC00, $FB00, $FA00, $F900, $FE00, $200, $FE00, $200
; ---------------------------------------------------------------------------

loc_C254:
		addq.b	#2,act(a0)
		move.b	#8,yrad(a0)
		move.b	#8,xrad(a0)
		move.l	#MapLavaball,map(a0)
		move.w	#$345,tile(a0)
		move.b	#4,render(a0)
		move.b	#3,prio(a0)
		move.b	#$8B,col(a0)
		move.w	ypos(a0),$30(a0)
		moveq	#0,d0
		move.b	arg(a0),d0
		add.w	d0,d0
		move.w	word_C244(pc,d0.w),yvel(a0)
		move.b	#8,xdisp(a0)
		cmpi.b	#6,arg(a0)
		bcs.s	loc_C2BE
		move.b	#$10,xdisp(a0)
		move.b	#2,ani(a0)
		move.w	yvel(a0),xvel(a0)
		move.w	#0,yvel(a0)

loc_C2BE:
		move.w	#sfx_Fireball,d0
		jsr	(PlaySFX).l

loc_C2C8:
		moveq	#0,d0
		move.b	arg(a0),d0
		add.w	d0,d0
		move.w	off_C306(pc,d0.w),d1
		jsr	off_C306(pc,d1.w)
		bsr.w	SpeedToPos
		lea	(AniLavaball).l,a1
		bsr.w	ObjectAnimate

loc_C2E6:
		move.w	xpos(a0),d0
		andi.w	#$FF80,d0
		move.w	(v_screenposx).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0
		cmpi.w	#640,d0
		bhi.w	DeleteObject
		rts
; ---------------------------------------------------------------------------

off_C306:	dc.w loc_C318-off_C306, loc_C318-off_C306, loc_C318-off_C306, loc_C318-off_C306, loc_C340-off_C306
		dc.w loc_C362-off_C306, loc_C384-off_C306, loc_C3A8-off_C306, locret_C3CC-off_C306
; ---------------------------------------------------------------------------

loc_C318:
		addi.w	#$18,yvel(a0)
		move.w	$30(a0),d0
		cmp.w	ypos(a0),d0
		bcc.s	loc_C32C
		addq.b	#2,act(a0)

loc_C32C:
		bclr	#1,status(a0)
		tst.w	yvel(a0)
		bpl.s	locret_C33E
		bset	#1,status(a0)

locret_C33E:
		rts
; ---------------------------------------------------------------------------

loc_C340:
		bset	#1,status(a0)
		bsr.w	ObjectHitCeiling
		tst.w	d1
		bpl.s	locret_C360
		move.b	#8,arg(a0)
		move.b	#1,ani(a0)
		move.w	#0,yvel(a0)

locret_C360:
		rts
; ---------------------------------------------------------------------------

loc_C362:
		bclr	#1,status(a0)
		bsr.w	ObjectHitFloor
		tst.w	d1
		bpl.s	locret_C382
		move.b	#8,arg(a0)
		move.b	#1,ani(a0)
		move.w	#0,yvel(a0)

locret_C382:
		rts
; ---------------------------------------------------------------------------

loc_C384:
		bset	#0,status(a0)
		moveq	#-8,d3
		bsr.w	ObjectHitWallLeft
		tst.w	d1
		bpl.s	locret_C3A6
		move.b	#8,arg(a0)
		move.b	#3,ani(a0)
		move.w	#0,xvel(a0)

locret_C3A6:
		rts
; ---------------------------------------------------------------------------

loc_C3A8:
		bclr	#0,status(a0)
		moveq	#8,d3
		bsr.w	ObjectHitWallRight
		tst.w	d1
		bpl.s	locret_C3CA
		move.b	#8,arg(a0)
		move.b	#3,ani(a0)
		move.w	#0,xvel(a0)

locret_C3CA:
		rts
; ---------------------------------------------------------------------------

locret_C3CC:
		rts
; ---------------------------------------------------------------------------
; Attributes: thunk

j_DeleteObject:
		bra.w	DeleteObject
; ---------------------------------------------------------------------------
		include "levels\MZ\LavaBall\Sprite.ani"
		even
; ---------------------------------------------------------------------------

ObjMZBlocks:
		moveq	#0,d0
		move.b	$24(a0),d0
		move.w	off_C3FC(pc,d0.w),d1
		jmp	off_C3FC(pc,d1.w)
; ---------------------------------------------------------------------------

off_C3FC:	dc.w loc_C400-off_C3FC, loc_C43C-off_C3FC
; ---------------------------------------------------------------------------

loc_C400:
		addq.b	#2,$24(a0)
		move.b	#$F,$16(a0)
		move.b	#$F,$17(a0)
		move.l	#MapMZBlocks,4(a0)
		move.w	#$4000,2(a0)
		move.b	#4,1(a0)
		move.b	#3,$19(a0)
		move.b	#$10,$18(a0)
		move.w	$C(a0),$30(a0)
		move.w	#$5C0,$32(a0)

loc_C43C:
		tst.b	1(a0)
		bpl.s	loc_C46A
		moveq	#0,d0
		move.b	$28(a0),d0
		andi.w	#7,d0
		add.w	d0,d0
		move.w	off_C48E(pc,d0.w),d1
		jsr	off_C48E(pc,d1.w)
		move.w	#$1B,d1
		move.w	#$10,d2
		move.w	#$11,d3
		move.w	8(a0),d4
		bsr.w	SolidObject

loc_C46A:
		bsr.w	DisplaySprite
		move.w	8(a0),d0
		andi.w	#$FF80,d0
		move.w	(v_screenposx).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0
		cmpi.w	#$280,d0
		bhi.w	DeleteObject
		rts
; ---------------------------------------------------------------------------

off_C48E:	dc.w locret_C498-off_C48E, loc_C4B2-off_C48E, loc_C49A-off_C48E, loc_C4D2-off_C48E
		dc.w loc_C50E-off_C48E
; ---------------------------------------------------------------------------

locret_C498:
		rts
; ---------------------------------------------------------------------------

loc_C49A:
		move.w	(v_objspace+8).w,d0
		sub.w	8(a0),d0
		bcc.s	loc_C4A6
		neg.w	d0

loc_C4A6:
		cmpi.w	#$90,d0
		bcc.s	loc_C4B2
		move.b	#3,$28(a0)

loc_C4B2:
		moveq	#0,d0
		move.b	(oscValues+$16).w,d0
		btst	#3,$28(a0)
		beq.s	loc_C4C6
		neg.w	d0
		addi.w	#$10,d0

loc_C4C6:
		move.w	$30(a0),d1
		sub.w	d0,d1
		move.w	d1,$C(a0)
		rts
; ---------------------------------------------------------------------------

loc_C4D2:
		bsr.w	SpeedToPos
		addi.w	#$18,$12(a0)
		bsr.w	ObjectHitFloor
		tst.w	d1
		bpl.w	locret_C50C
		add.w	d1,$C(a0)
		clr.w	$12(a0)
		move.w	$C(a0),$30(a0)
		move.b	#4,$28(a0)
		move.w	(a1),d0
		andi.w	#$3FF,d0
		cmpi.w	#$2E8,d0
		bcc.s	locret_C50C
		move.b	#0,$28(a0)

locret_C50C:
		rts
; ---------------------------------------------------------------------------

loc_C50E:
		moveq	#0,d0

loc_C510:
		move.b	(oscValues+$12).w,d0
		lsr.w	#3,d0
		move.w	$30(a0),d1
		sub.w	d0,d1
		move.w	d1,$C(a0)
		rts
; ---------------------------------------------------------------------------
		include "levels\MZ\Blocks\Sprite.map"
		even
; ---------------------------------------------------------------------------

ObjSceneryLamp:
		moveq	#0,d0
		move.b	$24(a0),d0
		move.w	off_C538(pc,d0.w),d1
		jmp	off_C538(pc,d1.w)
; ---------------------------------------------------------------------------

off_C538:	dc.w loc_C53C-off_C538, loc_C560-off_C538
; ---------------------------------------------------------------------------

loc_C53C:
		addq.b	#2,$24(a0)
		move.l	#MapSceneryLamp,4(a0)
		move.w	#0,2(a0)
		move.b	#4,1(a0)
		move.b	#$10,$18(a0)
		move.b	#6,$19(a0)

loc_C560:
		subq.b	#1,$1E(a0)
		bpl.s	loc_C57E
		move.b	#7,$1E(a0)
		addq.b	#1,$1A(a0)
		cmpi.b	#6,$1A(a0)
		bcs.s	loc_C57E
		move.b	#0,$1A(a0)

loc_C57E:
		bsr.w	DisplaySprite
		move.w	8(a0),d0
		andi.w	#$FF80,d0
		move.w	(v_screenposx).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0
		cmpi.w	#$280,d0
		bhi.w	DeleteObject
		rts
; ---------------------------------------------------------------------------
		include "levels\SZ\SceneryLamp\Sprite.map"
		even
; ---------------------------------------------------------------------------

ObjBumper:
		moveq	#0,d0
		move.b	$24(a0),d0
		move.w	off_C5FE(pc,d0.w),d1
		jmp	off_C5FE(pc,d1.w)
; ---------------------------------------------------------------------------

off_C5FE:	dc.w loc_C602-off_C5FE, loc_C62C-off_C5FE
; ---------------------------------------------------------------------------

loc_C602:
		addq.b	#2,$24(a0)
		move.l	#MapBumper,4(a0)
		move.w	#$380,2(a0)
		move.b	#4,1(a0)
		move.b	#$10,$18(a0)
		move.b	#1,$19(a0)
		move.b	#$D7,$20(a0)

loc_C62C:
		tst.b	$21(a0)
		beq.s	loc_C684
		clr.b	$21(a0)
		lea	(v_objspace).w,a1
		move.w	8(a0),d1
		move.w	$C(a0),d2
		sub.w	8(a1),d1
		sub.w	$C(a1),d2
		jsr	(CalcAngle).l
		jsr	(GetSine).l
		muls.w	#$F900,d1
		asr.l	#8,d1
		move.w	d1,$10(a1)
		muls.w	#$F900,d0
		asr.l	#8,d0
		move.w	d0,$12(a1)
		bset	#1,$22(a1)
		clr.b	$3C(a1)
		move.b	#1,$1C(a0)
		move.w	#sfx_Bumper,d0
		jsr	(PlaySFX).l

loc_C684:
		lea	(AniBumper).l,a1
		bsr.w	ObjectAnimate
		bsr.w	DisplaySprite
		move.w	8(a0),d0
		andi.w	#$FF80,d0
		move.w	(v_screenposx).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0

loc_C6A8:
		cmpi.w	#$280,d0
		bhi.w	DeleteObject
		rts
; ---------------------------------------------------------------------------
		include "levels\SZ\Bumper\Sprite.ani"
		even
		include "levels\SZ\Bumper\Sprite.map"
		even

                include "_incObj\0D Signpost.asm"

		include "_anim\Signpost.asm"
		include "_maps\Signpost.asm"
		even
; ---------------------------------------------------------------------------

ObjLavafallMalker:
		moveq	#0,d0
		move.b	$24(a0),d0
		move.w	off_C926(pc,d0.w),d1
		jsr	off_C926(pc,d1.w)
		bra.w	loc_CB28
; ---------------------------------------------------------------------------

off_C926:	dc.w loc_C932-off_C926, loc_C95C-off_C926, loc_C9CE-off_C926, loc_C982-off_C926, loc_C9DA-off_C926
		dc.w loc_C9EA-off_C926
; ---------------------------------------------------------------------------

loc_C932:
		addq.b	#2,$24(a0)
		move.l	#MapLavafall,4(a0)
		move.w	#$E3A8,2(a0)
		move.b	#4,1(a0)
		move.b	#1,$19(a0)
		move.b	#$38,$18(a0)
		move.w	#$78,$34(a0)

loc_C95C:
		subq.w	#1,$32(a0)
		bpl.s	locret_C980
		move.w	$34(a0),$32(a0)
		move.w	(v_objspace+$C).w,d0
		move.w	$C(a0),d1
		cmp.w	d1,d0
		bcc.s	locret_C980
		subi.w	#$170,d1
		cmp.w	d1,d0
		bcs.s	locret_C980
		addq.b	#2,$24(a0)

locret_C980:
		rts
; ---------------------------------------------------------------------------

loc_C982:
		addq.b	#2,$24(a0)
		bsr.w	LoadNextObject
		bne.s	loc_C9A8
		move.b	#$4D,0(a1)
		move.w	8(a0),8(a1)
		move.w	$C(a0),$C(a1)
		move.b	$28(a0),$28(a1)
		move.l	a0,$3C(a1)

loc_C9A8:
		move.b	#1,$1C(a0)
		tst.b	$28(a0)
		beq.s	loc_C9BC
		move.b	#4,$1C(a0)
		bra.s	loc_C9DA
; ---------------------------------------------------------------------------

loc_C9BC:
		movea.l	$3C(a0),a1
		bset	#1,$22(a1)
		move.w	#$FA80,$12(a1)
		bra.s	loc_C9DA
; ---------------------------------------------------------------------------

loc_C9CE:
		tst.b	$28(a0)
		beq.s	loc_C9DA
		addq.b	#2,$24(a0)
		rts
; ---------------------------------------------------------------------------

loc_C9DA:
		lea	(AniLavaFallMaker).l,a1
		bsr.w	ObjectAnimate
		bsr.w	DisplaySprite
		rts
; ---------------------------------------------------------------------------

loc_C9EA:
		move.b	#0,$1C(a0)
		move.b	#2,$24(a0)
		tst.b	$28(a0)
		beq.w	DeleteObject
		rts
; ---------------------------------------------------------------------------

ObjLavafall:
		moveq	#0,d0
		move.b	$24(a0),d0
		move.w	off_CA12(pc,d0.w),d1
		jsr	off_CA12(pc,d1.w)
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

off_CA12:	dc.w loc_CA1E-off_CA12, loc_CB0A-off_CA12, sub_CB8C-off_CA12, loc_CBEA-off_CA12

word_CA1A:	dc.w $FB00, 0
; ---------------------------------------------------------------------------

loc_CA1E:
		addq.b	#2,$24(a0)
		move.w	$C(a0),$30(a0)
		tst.b	$28(a0)
		beq.s	loc_CA34
		subi.w	#$250,$C(a0)

loc_CA34:
		moveq	#0,d0
		move.b	$28(a0),d0
		add.w	d0,d0
		move.w	word_CA1A(pc,d0.w),$12(a0)
		movea.l	a0,a1
		moveq	#1,d1
		bsr.s	sub_CA50
		bra.s	loc_CAA0
; ---------------------------------------------------------------------------

sub_CA4A:
		bsr.w	LoadNextObject
		bne.s	loc_CA9A
; ---------------------------------------------------------------------------

sub_CA50:
		move.b	#$4D,0(a1)
		move.l	#MapLavafall,4(a1)
		move.w	#$63A8,2(a1)
		move.b	#4,1(a1)
		move.b	#$20,$18(a1)
		move.w	8(a0),8(a1)
		move.w	$C(a0),$C(a1)
		move.b	$28(a0),$28(a1)
		move.b	#1,$19(a1)
		move.b	#5,$1C(a1)
		tst.b	$28(a0)
		beq.s	loc_CA9A
		move.b	#2,$1C(a1)

loc_CA9A:
		dbf	d1,sub_CA4A
		rts
; ---------------------------------------------------------------------------

loc_CAA0:
		addi.w	#$60,$C(a1)
		move.w	$30(a0),$30(a1)
		addi.w	#$60,$30(a1)
		move.b	#$93,$20(a1)
		move.b	#$80,$16(a1)
		bset	#4,1(a1)
		addq.b	#4,$24(a1)
		move.l	a0,$3C(a1)
		tst.b	$28(a0)
		beq.s	loc_CB00
		moveq	#0,d1
		bsr.w	sub_CA4A
		addq.b	#2,$24(a1)
		bset	#4,2(a1)
		addi.w	#$100,$C(a1)
		move.b	#0,$19(a1)
		move.w	$30(a0),$30(a1)
		move.l	$3C(a0),$3C(a1)
		move.b	#0,$28(a0)

loc_CB00:
		move.w	#sfx_Burning,d0
		jsr	(PlaySFX).l

loc_CB0A:
		moveq	#0,d0
		move.b	$28(a0),d0
		add.w	d0,d0
		move.w	off_CB48(pc,d0.w),d1
		jsr	off_CB48(pc,d1.w)
		bsr.w	SpeedToPos
		lea	(AniLavaFallMaker).l,a1
		bsr.w	ObjectAnimate

loc_CB28:
		move.w	8(a0),d0
		andi.w	#$FF80,d0
		move.w	(v_screenposx).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0
		cmpi.w	#$280,d0
		bhi.w	DeleteObject
		rts
; ---------------------------------------------------------------------------

off_CB48:	dc.w loc_CB4C-off_CB48, loc_CB6C-off_CB48
; ---------------------------------------------------------------------------

loc_CB4C:
		addi.w	#$18,$12(a0)
		move.w	$30(a0),d0
		cmp.w	$C(a0),d0
		bcc.s	locret_CB6A
		addq.b	#4,$24(a0)
		movea.l	$3C(a0),a1
		move.b	#3,$1C(a1)

locret_CB6A:
		rts
; ---------------------------------------------------------------------------

loc_CB6C:
		addi.w	#$18,$12(a0)
		move.w	$30(a0),d0
		cmp.w	$C(a0),d0
		bcc.s	locret_CB8A
		addq.b	#4,$24(a0)
		movea.l	$3C(a0),a1
		move.b	#1,$1C(a1)

locret_CB8A:
		rts
; ---------------------------------------------------------------------------

sub_CB8C:
		movea.l	$3C(a0),a1
		cmpi.b	#6,$24(a1)
		beq.w	loc_CBEA
		move.w	$C(a1),d0
		addi.w	#$60,d0
		move.w	d0,$C(a0)
		sub.w	$30(a0),d0
		neg.w	d0
		moveq	#8,d1
		cmpi.w	#$40,d0
		bge.s	loc_CBB6
		moveq	#$B,d1

loc_CBB6:
		cmpi.w	#$80,d0
		ble.s	loc_CBBE
		moveq	#$E,d1

loc_CBBE:
		subq.b	#1,$1E(a0)
		bpl.s	loc_CBDC
		move.b	#7,$1E(a0)
		addq.b	#1,$1B(a0)
		cmpi.b	#2,$1B(a0)
		bcs.s	loc_CBDC
		move.b	#0,$1B(a0)

loc_CBDC:
		move.b	$1B(a0),d0
		add.b	d1,d0
		move.b	d0,$1A(a0)
		bra.w	loc_CB28
; ---------------------------------------------------------------------------

loc_CBEA:
		bra.w	DeleteObject
; ---------------------------------------------------------------------------

ObjLavaChase:
		moveq	#0,d0
		move.b	$24(a0),d0
		move.w	off_CBFC(pc,d0.w),d1
		jmp	off_CBFC(pc,d1.w)
; ---------------------------------------------------------------------------

off_CBFC:	dc.w loc_CC06-off_CBFC, loc_CC66-off_CBFC, loc_CCA2-off_CBFC, loc_CD00-off_CBFC, loc_CD1C-off_CBFC
; ---------------------------------------------------------------------------

loc_CC06:
		addq.b	#2,$24(a0)
		movea.l	a0,a1
		moveq	#1,d1
		bra.s	loc_CC16
; ---------------------------------------------------------------------------

loc_CC10:
		bsr.w	LoadNextObject
		bne.s	loc_CC58

loc_CC16:
		move.b	#$4E,0(a1)
		move.l	#MapLavaChase,4(a1)
		move.w	#$63A8,2(a1)
		move.b	#4,1(a1)
		move.b	#$50,$18(a1)
		move.w	8(a0),8(a1)
		move.w	$C(a0),$C(a1)
		move.b	#1,$19(a1)
		move.b	#0,$1C(a1)
		move.b	#$94,$20(a1)
		move.l	a0,$3C(a1)

loc_CC58:
		dbf	d1,loc_CC10
		addq.b	#6,$24(a1)
		move.b	#4,$1A(a1)

loc_CC66:
		move.w	(v_objspace+8).w,d0
		sub.w	8(a0),d0
		bcc.s	loc_CC72
		neg.w	d0

loc_CC72:
		cmpi.w	#$E0,d0
		bcc.s	loc_CC92
		move.w	(v_objspace+$C).w,d0
		sub.w	$C(a0),d0
		bcc.s	loc_CC84
		neg.w	d0

loc_CC84:
		cmpi.w	#$60,d0
		bcc.s	loc_CC92
		move.b	#1,$36(a0)
		bra.s	loc_CCA2
; ---------------------------------------------------------------------------

loc_CC92:
		tst.b	$36(a0)
		beq.s	loc_CCA2
		move.w	#$100,$10(a0)
		addq.b	#2,$24(a0)

loc_CCA2:
		cmpi.w	#$6A0,8(a0)
		bne.s	loc_CCB2
		clr.w	$10(a0)
		clr.b	$36(a0)

loc_CCB2:
		lea	(AniLavaChase).l,a1
		bsr.w	ObjectAnimate
		bsr.w	SpeedToPos
		bsr.w	DisplaySprite
		tst.b	$36(a0)
		bne.s	locret_CCE6
		move.w	8(a0),d0
		andi.w	#$FF80,d0
		move.w	(v_screenposx).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0
		cmpi.w	#$280,d0
		bhi.s	loc_CCE8

locret_CCE6:
		rts
; ---------------------------------------------------------------------------

loc_CCE8:
		lea	(v_regbuffer).w,a2
		moveq	#0,d0
		move.b	$23(a0),d0
		bclr	#7,2(a2,d0.w)
		move.b	#8,$24(a0)
		rts
; ---------------------------------------------------------------------------

loc_CD00:
		movea.l	$3C(a0),a1
		cmpi.b	#8,$24(a1)
		beq.s	loc_CD1C
		move.w	8(a1),8(a0)
		subi.w	#$80,8(a0)
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

loc_CD1C:
		bra.w	DeleteObject
; ---------------------------------------------------------------------------

ObjLavaHurt:
		moveq	#0,d0
		move.b	$24(a0),d0
		move.w	off_CD2E(pc,d0.w),d1
		jmp	off_CD2E(pc,d1.w)
; ---------------------------------------------------------------------------

off_CD2E:	dc.w loc_CD36-off_CD2E, loc_CD6C-off_CD2E

byte_CD32:	dc.b $96, $94, $95, 0
; ---------------------------------------------------------------------------

loc_CD36:
		addq.b	#2,$24(a0)
		moveq	#0,d0
		move.b	$28(a0),d0
		move.b	byte_CD32(pc,d0.w),$20(a0)
		move.l	#MapLavaHurt,4(a0)
		move.w	#$8680,2(a0)
		move.b	#4,1(a0)
		move.b	#$80,$18(a0)
		move.b	#4,$19(a0)
		move.b	$28(a0),$1A(a0)

loc_CD6C:
		tst.w	(DebugRoutine).w
		beq.s	loc_CD76
		bsr.w	DisplaySprite

loc_CD76:
		cmpi.b	#6,(v_objspace+$24).w
		bcc.s	loc_CD84
		bset	#7,1(a0)

loc_CD84:
		move.w	8(a0),d0
		andi.w	#$FF80,d0
		move.w	(v_screenposx).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0
		bmi.w	DeleteObject
		cmpi.w	#$280,d0
		bhi.w	DeleteObject
		rts
; ---------------------------------------------------------------------------
		include "levels\MZ\LavaHurt\Sprite.map"
		include "levels\MZ\LavaFall\Maker.ani"
		include "levels\MZ\LavaChase\Sprite.ani"
		include "levels\MZ\LavaFall\Sprite.map"
		include "levels\MZ\LavaChase\Sprite.map"
		even
; ---------------------------------------------------------------------------

Obj4F:
		moveq	#0,d0
		move.b	act(a0),d0
		move.w	off_D202(pc,d0.w),d1
		jmp	off_D202(pc,d1.w)
; ---------------------------------------------------------------------------

off_D202:	dc.w loc_D20A-off_D202, loc_D246-off_D202, loc_D274-off_D202, loc_D2C8-off_D202
; ---------------------------------------------------------------------------

loc_D20A:
		addq.b	#2,act(a0)
		move.l	#Map4F,map(a0)
		move.w	#$24E4,tile(a0)
		move.b	#4,render(a0)
		move.b	#4,prio(a0)
		move.b	#$C,xdisp(a0)
		move.b	#$14,$16(a0)
		move.b	#2,$20(a0)
		tst.b	arg(a0)
		beq.s	loc_D246
		move.w	#$300,d2
		bra.s	loc_D24A
; ---------------------------------------------------------------------------

loc_D246:
		move.w	#$E0,d2

loc_D24A:
		move.w	#$100,d1
		bset	#0,render(a0)
		move.w	(v_objspace+8).w,d0
		sub.w	xpos(a0),d0
		bcc.s	loc_D268
		neg.w	d0
		neg.w	d1
		bclr	#0,render(a0)

loc_D268:
		cmp.w	d2,d0
		bcc.s	loc_D274
		move.w	d1,xvel(a0)
		addq.b	#2,$24(a0)

loc_D274:
		bsr.w	ObjectFall
		move.b	#1,frame(a0)
		tst.w	yvel(a0)
		bmi.s	loc_D2AE
		move.b	#0,frame(a0)
		bsr.w	ObjectHitFloor
		tst.w	d1
		bpl.s	loc_D2AE
		move.w	(a1),d0
		andi.w	#$3FF,d0
		cmpi.w	#$2D2,d0
		bcs.s	loc_D2A4
		addq.b	#2,act(a0)
		bra.s	loc_D2AE
; ---------------------------------------------------------------------------

loc_D2A4:
		add.w	d1,ypos(a0)
		move.w	#-$400,yvel(a0)

loc_D2AE:
		bsr.w	sub_D2DA
		beq.s	loc_D2C4
		neg.w	xvel(a0)
		bchg	#0,render(a0)
		bchg	#0,status(a0)

loc_D2C4:
		bra.w	ObjectChkDespawn
; ---------------------------------------------------------------------------

loc_D2C8:
		bsr.w	ObjectFall
		bsr.w	DisplaySprite
		tst.b	render(a0)
		bpl.w	DeleteObject
		rts
; ---------------------------------------------------------------------------

sub_D2DA:
		move.w	(LevelFrames).w,d0
		add.w	d7,d0
		andi.w	#3,d0
		bne.s	loc_D308
		moveq	#0,d3
		move.b	xdisp(a0),d3
		tst.w	xvel(a0)
		bmi.s	loc_D2FE
		bsr.w	ObjectHitWallRight
		tst.w	d1
		bpl.s	loc_D308

loc_D2FA:
		moveq	#1,d0
		rts
; ---------------------------------------------------------------------------

loc_D2FE:
		not.w	d3
		bsr.w	ObjectHitWallLeft
		tst.w	d1
		bmi.s	loc_D2FA

loc_D308:
		moveq	#0,d0
		rts
; ---------------------------------------------------------------------------
		include "_maps\Enemy Splats.asm"
		even
; ---------------------------------------------------------------------------

ObjYadrin:
		moveq	#0,d0
		move.b	$24(a0),d0
		move.w	off_D334(pc,d0.w),d1
		jmp	off_D334(pc,d1.w)
; ---------------------------------------------------------------------------

off_D334:	dc.w loc_D338-off_D334, loc_D38C-off_D334
; ---------------------------------------------------------------------------

loc_D338:
		move.l	#MapYadrin,4(a0)
		move.w	#$247B,2(a0)
		move.b	#4,1(a0)
		move.b	#4,$19(a0)
		move.b	#$14,$18(a0)
		move.b	#$11,$16(a0)
		move.b	#8,$17(a0)
		move.b	#$CC,$20(a0)
		bsr.w	ObjectFall
		bsr.w	ObjectHitFloor
		tst.w	d1
		bpl.s	locret_D38A
		add.w	d1,$C(a0)
		move.w	#0,$12(a0)
		addq.b	#2,$24(a0)
		bchg	#0,$22(a0)

locret_D38A:
		rts
; ---------------------------------------------------------------------------

loc_D38C:
		moveq	#0,d0
		move.b	$25(a0),d0
		move.w	off_D3A8(pc,d0.w),d1
		jsr	off_D3A8(pc,d1.w)
		lea	(AniYardin).l,a1
		bsr.w	ObjectAnimate
		bra.w	ObjectChkDespawn
; ---------------------------------------------------------------------------

off_D3A8:	dc.w loc_D3AC-off_D3A8, loc_D3D0-off_D3A8
; ---------------------------------------------------------------------------

loc_D3AC:
		subq.w	#1,$30(a0)
		bpl.s	locret_D3CE
		addq.b	#2,$25(a0)
		move.w	#$FF00,$10(a0)
		move.b	#1,$1C(a0)
		bchg	#0,$22(a0)
		bne.s	locret_D3CE
		neg.w	$10(a0)

locret_D3CE:
		rts
; ---------------------------------------------------------------------------

loc_D3D0:
		bsr.w	SpeedToPos
		bsr.w	ObjectHitFloor
		cmpi.w	#$FFF8,d1
		blt.s	loc_D3F0
		cmpi.w	#$C,d1
		bge.s	loc_D3F0
		add.w	d1,$C(a0)
		bsr.w	sub_D2DA
		bne.s	loc_D3F0
		rts
; ---------------------------------------------------------------------------

loc_D3F0:
		subq.b	#2,$25(a0)
		move.w	#$3B,$30(a0)
		move.w	#0,$10(a0)
		move.b	#0,$1C(a0)
		rts
; ---------------------------------------------------------------------------
		include "levels\shared\Yadrin\Sprite.ani"
		include "levels\shared\Yadrin\Sprite.map"
		even
; ---------------------------------------------------------------------------

ObjSmashBlock:
		moveq	#0,d0
		move.b	$24(a0),d0
		move.w	off_D4D4(pc,d0.w),d1
		jsr	off_D4D4(pc,d1.w)
		bra.w	ObjectChkDespawn
; ---------------------------------------------------------------------------

off_D4D4:	dc.w loc_D4DA-off_D4D4, loc_D504-off_D4D4, loc_D580-off_D4D4
; ---------------------------------------------------------------------------

loc_D4DA:
		addq.b	#2,$24(a0)
		move.l	#MapSmashBlock,4(a0)
		move.w	#$42B8,2(a0)
		move.b	#4,1(a0)
		move.b	#$10,$18(a0)
		move.b	#4,$19(a0)
		move.b	$28(a0),$1A(a0)

loc_D504:
		move.b	(v_objspace+$1C).w,$32(a0)
		move.w	#$1B,d1
		move.w	#$10,d2
		move.w	#$11,d3
		move.w	8(a0),d4
		bsr.w	SolidObject
		btst	#3,$22(a0)
		bne.s	loc_D528

locret_D526:
		rts
; ---------------------------------------------------------------------------

loc_D528:
		cmpi.b	#2,$32(a0)
		bne.s	locret_D526
		bset	#2,$22(a1)
		move.b	#$E,$16(a1)
		move.b	#7,$17(a1)
		move.b	#2,$1C(a1)
		move.w	#$FD00,$12(a1)
		bset	#1,$22(a1)
		bclr	#3,$22(a1)
		move.b	#2,$24(a1)
		bclr	#3,$22(a0)
		clr.b	$25(a0)
		move.b	#1,$1A(a0)
		lea	(ObjSmashBlock_Frag).l,a4
		moveq	#3,d1
		move.w	#$38,d2
		bsr.w	ObjectFragment

loc_D580:
		bsr.w	SpeedToPos
		addi.w	#$38,$12(a0)
		bsr.w	DisplaySprite
		tst.b	1(a0)
		bpl.w	DeleteObject
		rts
; ---------------------------------------------------------------------------

ObjSmashBlock_Frag:dc.w $FE00, $FE00, $FF00, $FF00, $200, $FE00, $100, $FF00
		include "levels\GHZ\SmashBlock\Sprite.map"
		even
; ---------------------------------------------------------------------------

ObjMovingPtfm:
		moveq	#0,d0
		move.b	$24(a0),d0
		move.w	off_D5FC(pc,d0.w),d1
		jsr	off_D5FC(pc,d1.w)
		move.w	$32(a0),d0
		andi.w	#$FF80,d0
		move.w	(v_screenposx).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0
		cmpi.w	#$280,d0
		bhi.w	DeleteObject
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

off_D5FC:	dc.w loc_D606-off_D5FC, loc_D648-off_D5FC, loc_D658-off_D5FC

byte_D602:	dc.b $10, 0
		dc.b $20, 1
; ---------------------------------------------------------------------------

loc_D606:
		addq.b	#2,$24(a0)
		move.l	#MapMovingPtfm,4(a0)
		move.w	#$42B8,2(a0)
		move.b	#4,1(a0)
		moveq	#0,d0
		move.b	$28(a0),d0
		lsr.w	#3,d0
		andi.w	#$1E,d0
		lea	byte_D602(pc,d0.w),a2
		move.b	(a2)+,$18(a0)
		move.b	(a2)+,$1A(a0)
		move.b	#4,$19(a0)
		move.w	8(a0),$32(a0)
		move.w	$C(a0),$30(a0)

loc_D648:
		moveq	#0,d1
		move.b	$18(a0),d1
		jsr	(PtfmNormal).l
		bra.w	sub_D674
; ---------------------------------------------------------------------------

loc_D658:
		moveq	#0,d1
		move.b	$18(a0),d1
		jsr	(PtfmCheckExit).l
		move.w	8(a0),-(sp)
		bsr.w	sub_D674
		move.w	(sp)+,d2
		jmp	(ptfmSurfaceNormal).l
; ---------------------------------------------------------------------------

sub_D674:
		moveq	#0,d0
		move.b	$28(a0),d0
		andi.w	#$F,d0
		add.w	d0,d0
		move.w	off_D688(pc,d0.w),d1
		jmp	off_D688(pc,d1.w)
; ---------------------------------------------------------------------------

off_D688:	dc.w locret_D690-off_D688, loc_D692-off_D688, loc_D6B2-off_D688, loc_D6C0-off_D688
; ---------------------------------------------------------------------------

locret_D690:
		rts
; ---------------------------------------------------------------------------

loc_D692:
		move.b	(oscValues+$E).w,d0
		subi.b	#$60,d1
		btst	#0,$22(a0)
		beq.s	loc_D6A6
		neg.w	d0
		add.w	d1,d0

loc_D6A6:
		move.w	$32(a0),d1
		sub.w	d0,d1
		move.w	d1,8(a0)
		rts
; ---------------------------------------------------------------------------

loc_D6B2:
		cmpi.b	#4,$24(a0)
		bne.s	locret_D6BE
		addq.b	#1,$28(a0)

locret_D6BE:
		rts
; ---------------------------------------------------------------------------

loc_D6C0:
		moveq	#0,d3
		move.b	$18(a0),d3
		bsr.w	ObjectHitWallRight
		tst.w	d1
		bmi.s	loc_D6DA
		addq.w	#1,8(a0)
		move.w	8(a0),$32(a0)
		rts
; ---------------------------------------------------------------------------

loc_D6DA:
		clr.b	$28(a0)
		rts
; ---------------------------------------------------------------------------
		include "levels\GHZ\MovingPtfm\Sprite.map"
		even
; ---------------------------------------------------------------------------

ObjBasaran:
		moveq	#0,d0
		move.b	$24(a0),d0
		move.w	ObjBasaran_Index(pc,d0.w),d1
		jmp	ObjBasaran_Index(pc,d1.w)
; ---------------------------------------------------------------------------

ObjBasaran_Index:dc.w ObjBasaran_Init-ObjBasaran_Index, ObjBasaran_Action-ObjBasaran_Index
; ---------------------------------------------------------------------------

ObjBasaran_Init:
		addq.b	#2,$24(a0)
		move.l	#MapBasaran,4(a0)
		move.w	#$84B8,2(a0)
		move.b	#4,1(a0)
		move.b	#$C,$16(a0)
		move.b	#2,$19(a0)
		move.b	#$B,$20(a0)
		move.b	#$10,$18(a0)

ObjBasaran_Action:
		moveq	#0,d0
		move.b	$25(a0),d0
		move.w	ObjBasaran_Index2(pc,d0.w),d1
		jsr	ObjBasaran_Index2(pc,d1.w)
		lea	(AniBasaran).l,a1
		bsr.w	ObjectAnimate
		bra.w	ObjectChkDespawn
; ---------------------------------------------------------------------------

ObjBasaran_Index2:dc.w ObjBasaran_ChkDrop-ObjBasaran_Index2, ObjBasaran_DropFly-ObjBasaran_Index2, ObjBasaran_PlaySound-ObjBasaran_Index2
		dc.w ObjBasaran_FlyUp-ObjBasaran_Index2
; ---------------------------------------------------------------------------

ObjBasaran_ChkDrop:
		move.w	#$80,d2
		bsr.w	ObjBasaran_CheckPlayer
		bcc.s	ObjBasaran_NotDropped
		move.w	(v_objspace+$C).w,d0
		move.w	d0,$36(a0)
		sub.w	$C(a0),d0
		bcs.s	ObjBasaran_NotDropped
		cmpi.w	#$80,d0
		bcc.s	ObjBasaran_NotDropped
		tst.w	(DebugRoutine).w
		bne.s	ObjBasaran_NotDropped
		move.b	(byte_FFFE0F).w,d0
		add.b	d7,d0
		andi.b	#7,d0
		bne.s	ObjBasaran_NotDropped
		move.b	#1,$1C(a0)
		addq.b	#2,$25(a0)

ObjBasaran_NotDropped:
		rts
; ---------------------------------------------------------------------------

ObjBasaran_DropFly:
		bsr.w	SpeedToPos
		addi.w	#$18,$12(a0)
		move.w	#$80,d2
		bsr.w	ObjBasaran_CheckPlayer
		move.w	$36(a0),d0
		sub.w	$C(a0),d0
		bcs.s	ObjBasaran_Delete
		cmpi.w	#$10,d0
		bcc.s	locret_D7CE
		move.w	d1,$10(a0)
		move.w	#0,$12(a0)
		move.b	#2,$1C(a0)
		addq.b	#2,$25(a0)

locret_D7CE:
		rts
; ---------------------------------------------------------------------------

ObjBasaran_Delete:
		tst.b	1(a0)
		bpl.w	DeleteObject
		rts
; ---------------------------------------------------------------------------

ObjBasaran_PlaySound:
		move.b	(byte_FFFE0F).w,d0
		andi.b	#$F,d0
		bne.s	loc_D7EE
		move.w	#sfx_Basaran,d0
		jsr	(PlaySFX).l

loc_D7EE:
		bsr.w	SpeedToPos
		move.w	(v_objspace+8).w,d0
		sub.w	8(a0),d0
		bcc.s	loc_D7FE
		neg.w	d0

loc_D7FE:
		cmpi.w	#$80,d0
		bcs.s	locret_D814
		move.b	(byte_FFFE0F).w,d0
		add.b	d7,d0
		andi.b	#7,d0
		bne.s	locret_D814
		addq.b	#2,$25(a0)

locret_D814:
		rts
; ---------------------------------------------------------------------------

ObjBasaran_FlyUp:
		bsr.w	SpeedToPos
		subi.w	#$18,$12(a0)
		bsr.w	ObjectHitCeiling
		tst.w	d1
		bpl.s	locret_D842
		sub.w	d1,$C(a0)
		andi.w	#$FFF8,8(a0)
		clr.w	$10(a0)
		clr.w	$12(a0)
		clr.b	$1C(a0)
		clr.b	$25(a0)

locret_D842:
		rts
; ---------------------------------------------------------------------------

ObjBasaran_CheckPlayer:
		move.w	#$100,d1
		bset	#0,$22(a0)
		move.w	(v_objspace+8).w,d0
		sub.w	8(a0),d0
		bcc.s	loc_D862
		neg.w	d0
		neg.w	d1
		bclr	#0,$22(a0)

loc_D862:
		cmp.w	d2,d0
		rts
; ---------------------------------------------------------------------------
		bsr.w	SpeedToPos
		bsr.w	DisplaySprite
		tst.b	1(a0)
		bpl.w	DeleteObject
		rts
; ---------------------------------------------------------------------------
		include "levels\MZ\Basaran\Sprite.ani"
		include "levels\MZ\Basaran\Sprite.map"
		even
; ---------------------------------------------------------------------------

ObjMovingBlocks:
		moveq	#0,d0
		move.b	$24(a0),d0
		move.w	ObjMovingBlocks_Index(pc,d0.w),d1
		jmp	ObjMovingBlocks_Index(pc,d1.w)
; ---------------------------------------------------------------------------

ObjMovingBlocks_Index:dc.w ObjMovingBlocks_Init-ObjMovingBlocks_Index, ObjMovingBlocks_Action-ObjMovingBlocks_Index

ObjMovingBlocks_Variables:dc.b $10, $10
		dc.b $20, $20
		dc.b $10, $20
		dc.b $20, $1A
		dc.b $10, $27
		dc.b $10, $10
; ---------------------------------------------------------------------------

ObjMovingBlocks_Init:
		addq.b	#2,$24(a0)
		move.l	#MapMovingBlocks,4(a0)
		move.w	#$4000,2(a0)
		cmpi.b	#3,(v_zone).w
		bne.s	loc_D912
		move.w	#$4480,2(a0)

loc_D912:
		move.b	#4,1(a0)
		move.b	#3,$19(a0)
		moveq	#0,d0
		move.b	$28(a0),d0
		lsr.w	#3,d0
		andi.w	#$E,d0
		lea	ObjMovingBlocks_Variables(pc,d0.w),a2
		move.b	(a2)+,$18(a0)
		move.b	(a2),$16(a0)
		lsr.w	#1,d0
		move.b	d0,$1A(a0)
		move.w	8(a0),$34(a0)
		move.w	$C(a0),$30(a0)
		moveq	#0,d0
		move.b	(a2),d0
		add.w	d0,d0
		move.w	d0,$3A(a0)
		moveq	#0,d0
		move.b	$28(a0),d0
		andi.w	#$F,d0
		subq.w	#8,d0
		bcs.s	ObjMovingBlocks_IsGone
		lsl.w	#2,d0
		lea	(oscValues+$2C).w,a2
		lea	(a2,d0.w),a2
		tst.w	(a2)
		bpl.s	ObjMovingBlocks_IsGone
		bchg	#0,$22(a0)

ObjMovingBlocks_IsGone:
		move.b	$28(a0),d0
		bpl.s	ObjMovingBlocks_Action
		andi.b	#$F,d0
		move.b	d0,$3C(a0)
		move.b	#5,$28(a0)
		lea	(v_regbuffer).w,a2
		moveq	#0,d0
		move.b	$23(a0),d0
		beq.s	ObjMovingBlocks_Action
		bclr	#7,2(a2,d0.w)
		btst	#0,2(a2,d0.w)
		beq.s	ObjMovingBlocks_Action
		move.b	#6,$28(a0)
		clr.w	$3A(a0)

ObjMovingBlocks_Action:
		move.w	8(a0),-(sp)
		moveq	#0,d0
		move.b	$28(a0),d0
		andi.w	#$F,d0
		add.w	d0,d0
		move.w	ObjBasaran_TypeIndex(pc,d0.w),d1
		jsr	ObjBasaran_TypeIndex(pc,d1.w)
		move.w	(sp)+,d4
		tst.b	1(a0)
		bpl.s	ObjMovingBlocks_ChkDelete
		moveq	#0,d1
		move.b	$18(a0),d1
		addi.w	#$B,d1
		moveq	#0,d2
		move.b	$16(a0),d2
		move.w	d2,d3
		addq.w	#1,d3
		bsr.w	SolidObject

ObjMovingBlocks_ChkDelete:
		bsr.w	DisplaySprite
		move.w	$34(a0),d0
		andi.w	#$FF80,d0
		move.w	(v_screenposx).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0
		cmpi.w	#$280,d0
		bhi.w	DeleteObject
		rts
; ---------------------------------------------------------------------------

ObjBasaran_TypeIndex:dc.w ObjBasaran_Type00-ObjBasaran_TypeIndex, ObjBasaran_Type01-ObjBasaran_TypeIndex, ObjBasaran_Type02-ObjBasaran_TypeIndex
		dc.w ObjBasaran_Type03-ObjBasaran_TypeIndex, ObjBasaran_Type04-ObjBasaran_TypeIndex, ObjBasaran_Type05-ObjBasaran_TypeIndex
		dc.w ObjBasaran_Type06-ObjBasaran_TypeIndex, ObjBasaran_Type07-ObjBasaran_TypeIndex, ObjBasaran_Type08-ObjBasaran_TypeIndex
		dc.w ObjBasaran_Type09-ObjBasaran_TypeIndex, ObjBasaran_Type0A-ObjBasaran_TypeIndex, ObjBasaran_Type0B-ObjBasaran_TypeIndex
; ---------------------------------------------------------------------------

ObjBasaran_Type00:
		rts
; ---------------------------------------------------------------------------

ObjBasaran_Type01:
		move.w	#$40,d1
		moveq	#0,d0
		move.b	(oscValues+$A).w,d0
		bra.s	loc_DA38
; ---------------------------------------------------------------------------

ObjBasaran_Type02:
		move.w	#$80,d1
		moveq	#0,d0
		move.b	(oscValues+$1E).w,d0

loc_DA38:
		btst	#0,$22(a0)
		beq.s	loc_DA44
		neg.w	d0
		add.w	d1,d0

loc_DA44:
		move.w	$34(a0),d1
		sub.w	d0,d1
		move.w	d1,8(a0)
		rts
; ---------------------------------------------------------------------------

ObjBasaran_Type03:
		move.w	#$40,d1
		moveq	#0,d0
		move.b	(oscValues+$A).w,d0
		bra.s	loc_DA62
; ---------------------------------------------------------------------------

ObjBasaran_Type04:
		moveq	#0,d0
		move.b	(oscValues+$1E).w,d0

loc_DA62:
		btst	#0,$22(a0)
		beq.s	loc_DA70
		neg.w	d0
		addi.w	#$80,d0

loc_DA70:
		move.w	$30(a0),d1
		sub.w	d0,d1
		move.w	d1,$C(a0)
		rts
; ---------------------------------------------------------------------------

ObjBasaran_Type05:
		tst.b	$38(a0)
		bne.s	loc_DA9A
		lea	(unk_FFF7E0).w,a2
		moveq	#0,d0
		move.b	$3C(a0),d0
		btst	#0,(a2,d0.w)
		beq.s	loc_DAA4
		move.b	#1,$38(a0)

loc_DA9A:
		tst.w	$3A(a0)
		beq.s	loc_DAB4
		subq.w	#2,$3A(a0)

loc_DAA4:
		move.w	$3A(a0),d0
		move.w	$30(a0),d1
		add.w	d0,d1
		move.w	d1,$C(a0)
		rts
; ---------------------------------------------------------------------------

loc_DAB4:
		addq.b	#1,$28(a0)
		clr.b	$38(a0)
		lea	(v_regbuffer).w,a2
		moveq	#0,d0
		move.b	$23(a0),d0
		beq.s	loc_DAA4
		bset	#0,2(a2,d0.w)
		bra.s	loc_DAA4
; ---------------------------------------------------------------------------

ObjBasaran_Type06:
		tst.b	$38(a0)
		bne.s	loc_DAEC
		lea	(unk_FFF7E0).w,a2
		moveq	#0,d0
		move.b	$3C(a0),d0
		tst.b	(a2,d0.w)
		bpl.s	loc_DAFE
		move.b	#1,$38(a0)

loc_DAEC:
		moveq	#0,d0
		move.b	$16(a0),d0
		add.w	d0,d0
		cmp.w	$3A(a0),d0
		beq.s	loc_DB0E
		addq.w	#2,$3A(a0)

loc_DAFE:
		move.w	$3A(a0),d0
		move.w	$30(a0),d1
		add.w	d0,d1
		move.w	d1,$C(a0)
		rts
; ---------------------------------------------------------------------------

loc_DB0E:
		subq.b	#1,$28(a0)
		clr.b	$38(a0)
		lea	(v_regbuffer).w,a2
		moveq	#0,d0
		move.b	$23(a0),d0
		beq.s	loc_DAFE
		bclr	#0,2(a2,d0.w)
		bra.s	loc_DAFE
; ---------------------------------------------------------------------------

ObjBasaran_Type07:
		tst.b	$38(a0)
		bne.s	loc_DB40
		tst.b	(unk_FFF7EF).w
		beq.s	locret_DB5A
		move.b	#1,$38(a0)
		clr.w	$3A(a0)

loc_DB40:
		addq.w	#1,8(a0)
		move.w	8(a0),$34(a0)
		addq.w	#1,$3A(a0)
		cmpi.w	#$380,$3A(a0)
		bne.s	locret_DB5A
		clr.b	$28(a0)

locret_DB5A:
		rts
; ---------------------------------------------------------------------------

ObjBasaran_Type08:
		move.w	#$10,d1
		moveq	#0,d0
		move.b	(oscValues+$2A).w,d0
		lsr.w	#1,d0
		move.w	(oscValues+$2C).w,d3
		bra.s	ObjBasaran_MoveSquare
; ---------------------------------------------------------------------------

ObjBasaran_Type09:
		move.w	#$30,d1
		moveq	#0,d0
		move.b	(oscValues+$2E).w,d0
		move.w	(oscValues+$30).w,d3
		bra.s	ObjBasaran_MoveSquare
; ---------------------------------------------------------------------------

ObjBasaran_Type0A:
		move.w	#$50,d1
		moveq	#0,d0
		move.b	(oscValues+$32).w,d0
		move.w	(oscValues+$34).w,d3
		bra.s	ObjBasaran_MoveSquare
; ---------------------------------------------------------------------------

ObjBasaran_Type0B:
		move.w	#$70,d1
		moveq	#0,d0
		move.b	(oscValues+$36).w,d0
		move.w	(oscValues+$38).w,d3

ObjBasaran_MoveSquare:
		tst.w	d3
		bne.s	loc_DBAA
		addq.b	#1,$22(a0)
		andi.b	#3,$22(a0)

loc_DBAA:
		move.b	$22(a0),d2
		andi.b	#3,d2
		bne.s	loc_DBCA
		sub.w	d1,d0
		add.w	$34(a0),d0
		move.w	d0,8(a0)
		neg.w	d1
		add.w	$30(a0),d1
		move.w	d1,$C(a0)
		rts
; ---------------------------------------------------------------------------

loc_DBCA:
		subq.b	#1,d2
		bne.s	loc_DBE8
		subq.w	#1,d1
		sub.w	d1,d0
		neg.w	d0
		add.w	$30(a0),d0
		move.w	d0,$C(a0)
		addq.w	#1,d1
		add.w	$34(a0),d1
		move.w	d1,8(a0)
		rts
; ---------------------------------------------------------------------------

loc_DBE8:
		subq.b	#1,d2
		bne.s	loc_DC06
		subq.w	#1,d1
		sub.w	d1,d0
		neg.w	d0
		add.w	$34(a0),d0
		move.w	d0,8(a0)
		addq.w	#1,d1
		add.w	$30(a0),d1
		move.w	d1,$C(a0)
		rts
; ---------------------------------------------------------------------------

loc_DC06:
		sub.w	d1,d0
		add.w	$30(a0),d0
		move.w	d0,$C(a0)
		neg.w	d1
		add.w	$34(a0),d1
		move.w	d1,8(a0)
		rts
; ---------------------------------------------------------------------------
		include "levels\shared\MovingBlocks\Sprite.map"
		even
; ---------------------------------------------------------------------------

ObjSpikedBalls:
		moveq	#0,d0
		move.b	$24(a0),d0
		move.w	ObjSpikedBalls_Index(pc,d0.w),d1
		jmp	ObjSpikedBalls_Index(pc,d1.w)
; ---------------------------------------------------------------------------

ObjSpikedBalls_Index:dc.w ObjSpikedBalls_Init-ObjSpikedBalls_Index, ObjSpikedBalls_Move-ObjSpikedBalls_Index, ObjSpikedBalls_Display-ObjSpikedBalls_Index
; ---------------------------------------------------------------------------

ObjSpikedBalls_Init:
		addq.b	#2,$24(a0)
		move.l	#MapSpikedBalls,4(a0)
		move.w	#$3BA,2(a0)
		move.b	#4,1(a0)
		move.b	#4,$19(a0)
		move.b	#8,$18(a0)
		move.w	8(a0),$3A(a0)
		move.w	$C(a0),$38(a0)
		move.b	#$98,$20(a0)
		move.b	$28(a0),d1
		andi.b	#$F0,d1
		ext.w	d1
		asl.w	#3,d1
		move.w	d1,$3E(a0)
		move.b	$22(a0),d0
		ror.b	#2,d0
		andi.b	#$C0,d0
		move.b	d0,$26(a0)
		lea	$29(a0),a2
		move.b	$28(a0),d1
		andi.w	#7,d1
		move.b	#0,(a2)+
		move.w	d1,d3
		lsl.w	#4,d3
		move.b	d3,$3C(a0)
		subq.w	#1,d1
		bcs.s	loc_DD5E
		btst	#3,$28(a0)
		beq.s	ObjSpikedBalls_MakeChain
		subq.w	#1,d1
		bcs.s	loc_DD5E

ObjSpikedBalls_MakeChain:
		bsr.w	ObjectLoad
		bne.s	loc_DD5E
		addq.b	#1,$29(a0)
		move.w	a1,d5
		subi.w	#$D000,d5
		lsr.w	#6,d5
		andi.w	#$7F,d5
		move.b	d5,(a2)+
		move.b	#4,$24(a1)
		move.b	0(a0),0(a1)
		move.l	4(a0),4(a1)
		move.w	2(a0),2(a1)
		move.b	1(a0),1(a1)
		move.b	$19(a0),$19(a1)
		move.b	$18(a0),$18(a1)
		move.b	$20(a0),$20(a1)
		subi.b	#$10,d3
		move.b	d3,$3C(a1)
		dbf	d1,ObjSpikedBalls_MakeChain

loc_DD5E:
		move.w	a0,d5
		subi.w	#$D000,d5
		lsr.w	#6,d5
		andi.w	#$7F,d5
		move.b	d5,(a2)+

ObjSpikedBalls_Move:
		bsr.w	ObjSpikedBalls_MoveStub
		bra.w	ObjSpikedBalls_ChkDelete
; ---------------------------------------------------------------------------

ObjSpikedBalls_MoveStub:
		move.w	$3E(a0),d0
		add.w	d0,$26(a0)
		move.b	$26(a0),d0
		jsr	(GetSine).l
		move.w	$38(a0),d2
		move.w	$3A(a0),d3
		lea	$29(a0),a2
		moveq	#0,d6
		move.b	(a2)+,d6

ObjSpikedBalls_MoveLoop:
		moveq	#0,d4
		move.b	(a2)+,d4
		lsl.w	#6,d4
		addi.l	#(v_objspace)&$FFFFFF,d4
		movea.l	d4,a1
		moveq	#0,d4
		move.b	$3C(a1),d4
		move.l	d4,d5
		muls.w	d0,d4
		asr.l	#8,d4
		muls.w	d1,d5
		asr.l	#8,d5
		add.w	d2,d4
		add.w	d3,d5
		move.w	d4,$C(a1)
		move.w	d5,8(a1)
		dbf	d6,ObjSpikedBalls_MoveLoop
		rts
; ---------------------------------------------------------------------------

ObjSpikedBalls_ChkDelete:
		move.w	$3A(a0),d0
		andi.w	#$FF80,d0
		move.w	(v_screenposx).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0
		cmpi.w	#$280,d0
		bhi.w	ObjSpikedBalls_Delete
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

ObjSpikedBalls_Delete:
		moveq	#0,d2
		lea	$29(a0),a2
		move.b	(a2)+,d2

ObjSpikedBalls_DeleteLoop:
		moveq	#0,d0
		move.b	(a2)+,d0
		lsl.w	#6,d0
		addi.l	#(v_objspace)&$FFFFFF,d0
		movea.l	d0,a1
		bsr.w	ObjectDeleteA1
		dbf	d2,ObjSpikedBalls_DeleteLoop
		rts
; ---------------------------------------------------------------------------

ObjSpikedBalls_Display:
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------
		include "_maps\Spiked Balls.asm"
		even
; ---------------------------------------------------------------------------

ObjGiantSpikedBalls:
		moveq	#0,d0
		move.b	$24(a0),d0
		move.w	ObjGiantBalls_Index(pc,d0.w),d1
		jmp	ObjGiantBalls_Index(pc,d1.w)
; ---------------------------------------------------------------------------

ObjGiantBalls_Index:dc.w ObjGiantBalls_Init-ObjGiantBalls_Index, ObjGiantBalls_Move-ObjGiantBalls_Index
; ---------------------------------------------------------------------------

ObjGiantBalls_Init:
		addq.b	#2,$24(a0)
		move.l	#MapGiantSpikedBalls,4(a0)
		move.w	#$396,2(a0)
		move.b	#4,1(a0)
		move.b	#4,$19(a0)
		move.b	#$18,$18(a0)
		move.w	8(a0),$3A(a0)
		move.w	$C(a0),$38(a0)
		move.b	#$86,$20(a0)
		move.b	$28(a0),d1
		andi.b	#$F0,d1
		ext.w	d1
		asl.w	#3,d1
		move.w	d1,$3E(a0)
		move.b	$22(a0),d0
		ror.b	#2,d0
		andi.b	#$C0,d0
		move.b	d0,$26(a0)
		move.b	#$50,$3C(a0)

ObjGiantBalls_Move:
		moveq	#0,d0
		move.b	$28(a0),d0
		andi.w	#7,d0
		add.w	d0,d0
		move.w	ObjGiantBalls_TypeIndex(pc,d0.w),d1
		jsr	ObjGiantBalls_TypeIndex(pc,d1.w)
		move.w	$3A(a0),d0
		andi.w	#$FF80,d0
		move.w	(v_screenposx).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0
		cmpi.w	#$280,d0
		bhi.w	DeleteObject
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

ObjGiantBalls_TypeIndex:dc.w ObjGiantBalls_Type00-ObjGiantBalls_TypeIndex, ObjGiantBalls_Type01-ObjGiantBalls_TypeIndex, ObjGiantBalls_Type02-ObjGiantBalls_TypeIndex, ObjGiantBalls_Type03-ObjGiantBalls_TypeIndex
; ---------------------------------------------------------------------------

ObjGiantBalls_Type00:
		rts
; ---------------------------------------------------------------------------

ObjGiantBalls_Type01:
		move.w	#$60,d1
		moveq	#0,d0
		move.b	(oscValues+$E).w,d0
		btst	#0,$22(a0)
		beq.s	loc_DED6
		neg.w	d0
		add.w	d1,d0

loc_DED6:
		move.w	$3A(a0),d1
		sub.w	d0,d1
		move.w	d1,8(a0)
		rts
; ---------------------------------------------------------------------------

ObjGiantBalls_Type02:
		move.w	#$60,d1
		moveq	#0,d0
		move.b	(oscValues+$E).w,d0
		btst	#0,$22(a0)
		beq.s	loc_DEFA
		neg.w	d0
		addi.w	#$80,d0

loc_DEFA:
		move.w	$38(a0),d1
		sub.w	d0,d1
		move.w	d1,$C(a0)
		rts
; ---------------------------------------------------------------------------

ObjGiantBalls_Type03:
		move.w	$3E(a0),d0
		add.w	d0,$26(a0)
		move.b	$26(a0),d0
		jsr	(GetSine).l
		move.w	$38(a0),d2
		move.w	$3A(a0),d3
		moveq	#0,d4
		move.b	$3C(a0),d4
		move.l	d4,d5
		muls.w	d0,d4
		asr.l	#8,d4
		muls.w	d1,d5
		asr.l	#8,d5
		add.w	d2,d4
		add.w	d3,d5
		move.w	d4,$C(a0)
		move.w	d5,8(a0)
		rts
; ---------------------------------------------------------------------------
		include "_maps\Giant Spiked Balls.asm"
		even
; ---------------------------------------------------------------------------

ObjSLZMovingPtfm:
		moveq	#0,d0
		move.b	$24(a0),d0
		move.w	off_DF9A(pc,d0.w),d1
		jsr	off_DF9A(pc,d1.w)
		move.w	$32(a0),d0
		andi.w	#$FF80,d0
		move.w	(v_screenposx).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0
		cmpi.w	#$280,d0
		bhi.w	DeleteObject
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

off_DF9A:	dc.w loc_DFC2-off_DF9A, loc_E03A-off_DF9A, loc_E04A-off_DF9A, loc_E194-off_DF9A

byte_DFA2:	dc.b $28, 0
		dc.b $10, 1
		dc.b $20, 1
		dc.b $34, 1
		dc.b $10, 3
		dc.b $20, 3
		dc.b $34, 3
		dc.b $14, 1
		dc.b $24, 1
		dc.b $2C, 1
		dc.b $14, 3
		dc.b $24, 3
		dc.b $2C, 3
		dc.b $20, 5
		dc.b $20, 7
		dc.b $30, 9
; ---------------------------------------------------------------------------

loc_DFC2:
		addq.b	#2,$24(a0)
		moveq	#0,d0
		move.b	$28(a0),d0
		bpl.s	loc_DFE6
		addq.b	#4,$24(a0)
		andi.w	#$7F,d0
		mulu.w	#6,d0
		move.w	d0,$3C(a0)
		move.w	d0,$3E(a0)
		addq.l	#4,sp
		rts
; ---------------------------------------------------------------------------

loc_DFE6:
		lsr.w	#3,d0
		andi.w	#$1E,d0
		lea	byte_DFA2(pc,d0.w),a2
		move.b	(a2)+,$18(a0)
		move.b	(a2)+,$1A(a0)
		moveq	#0,d0
		move.b	$28(a0),d0
		add.w	d0,d0
		andi.w	#$1E,d0
		lea	byte_DFA2+2(pc,d0.w),a2
		move.b	(a2)+,d0
		lsl.w	#2,d0
		move.w	d0,$3C(a0)
		move.b	(a2)+,$28(a0)
		move.l	#MapSLZMovingPtfm,4(a0)
		move.w	#$4480,2(a0)
		move.b	#4,1(a0)
		move.b	#4,$19(a0)
		move.w	8(a0),$32(a0)
		move.w	$C(a0),$30(a0)

loc_E03A:
		moveq	#0,d1
		move.b	$18(a0),d1
		jsr	(PtfmNormal).l
		bra.w	sub_E06E
; ---------------------------------------------------------------------------

loc_E04A:
		moveq	#0,d1
		move.b	$18(a0),d1
		jsr	(PtfmCheckExit).l
		move.w	8(a0),-(sp)
		bsr.w	sub_E06E
		move.w	(sp)+,d2
		tst.b	0(a0)
		beq.s	locret_E06C
		jmp	(ptfmSurfaceNormal).l
; ---------------------------------------------------------------------------

locret_E06C:
		rts
; ---------------------------------------------------------------------------

sub_E06E:
		moveq	#0,d0
		move.b	$28(a0),d0
		andi.w	#$F,d0
		add.w	d0,d0
		move.w	off_E082(pc,d0.w),d1
		jmp	off_E082(pc,d1.w)
; ---------------------------------------------------------------------------

off_E082:	dc.w locret_E096-off_E082, loc_E098-off_E082, loc_E0A6-off_E082, loc_E098-off_E082
		dc.w loc_E0BA-off_E082, loc_E098-off_E082, loc_E0CC-off_E082, loc_E098-off_E082, loc_E0EE-off_E082
		dc.w loc_E110-off_E082
; ---------------------------------------------------------------------------

locret_E096:
		rts
; ---------------------------------------------------------------------------

loc_E098:
		cmpi.b	#4,$24(a0)
		bne.s	locret_E0A4
		addq.b	#1,$28(a0)

locret_E0A4:
		rts
; ---------------------------------------------------------------------------

loc_E0A6:
		bsr.w	sub_E14A
		move.w	$34(a0),d0
		neg.w	d0
		add.w	$30(a0),d0
		move.w	d0,$C(a0)
		rts
; ---------------------------------------------------------------------------

loc_E0BA:
		bsr.w	sub_E14A
		move.w	$34(a0),d0
		add.w	$30(a0),d0
		move.w	d0,$C(a0)
		rts
; ---------------------------------------------------------------------------

loc_E0CC:
		bsr.w	sub_E14A
		move.w	$34(a0),d0
		asr.w	#1,d0
		neg.w	d0
		add.w	$30(a0),d0
		move.w	d0,$C(a0)
		move.w	$34(a0),d0
		add.w	$32(a0),d0
		move.w	d0,8(a0)
		rts
; ---------------------------------------------------------------------------

loc_E0EE:
		bsr.w	sub_E14A
		move.w	$34(a0),d0
		asr.w	#1,d0
		add.w	$30(a0),d0
		move.w	d0,$C(a0)
		move.w	$34(a0),d0
		neg.w	d0
		add.w	$32(a0),d0
		move.w	d0,8(a0)
		rts
; ---------------------------------------------------------------------------

loc_E110:
		bsr.w	sub_E14A
		move.w	$34(a0),d0
		neg.w	d0
		add.w	$30(a0),d0
		move.w	d0,$C(a0)
		tst.b	$28(a0)
		beq.w	loc_E12C
		rts
; ---------------------------------------------------------------------------

loc_E12C:
		btst	#3,$22(a0)
		beq.s	loc_E146
		bset	#1,$22(a1)
		bclr	#3,$22(a1)
		move.b	#2,$24(a1)

loc_E146:
		bra.w	DeleteObject
; ---------------------------------------------------------------------------

sub_E14A:
		move.w	$38(a0),d0
		tst.b	$3A(a0)
		bne.s	loc_E160
		cmpi.w	#$800,d0
		bcc.s	loc_E168
		addi.w	#$10,d0
		bra.s	loc_E168
; ---------------------------------------------------------------------------

loc_E160:
		tst.w	d0
		beq.s	loc_E168
		subi.w	#$10,d0

loc_E168:
		move.w	d0,$38(a0)
		ext.l	d0
		asl.l	#8,d0
		add.l	$34(a0),d0
		move.l	d0,$34(a0)
		swap	d0
		move.w	$3C(a0),d2
		cmp.w	d2,d0
		bls.s	loc_E188
		move.b	#1,$3A(a0)

loc_E188:
		add.w	d2,d2
		cmp.w	d2,d0
		bne.s	locret_E192
		clr.b	$28(a0)

locret_E192:
		rts
; ---------------------------------------------------------------------------

loc_E194:
		subq.w	#1,$3C(a0)
		bne.s	loc_E1BE
		move.w	$3E(a0),$3C(a0)
		bsr.w	ObjectLoad
		bne.s	loc_E1BE
		move.b	#$59,0(a1)
		move.w	8(a0),8(a1)
		move.w	$C(a0),$C(a1)
		move.b	#$E,$28(a1)

loc_E1BE:
		addq.l	#4,sp
		move.w	8(a0),d0
		andi.w	#$FF80,d0
		move.w	(v_screenposx).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0
		cmpi.w	#$280,d0
		bhi.w	DeleteObject
		rts
; ---------------------------------------------------------------------------
		include "levels\SLZ\MovingPtfm\Srite.map"
		even
; ---------------------------------------------------------------------------

ObjCirclePtfm:
		moveq	#0,d0
		move.b	$24(a0),d0
		move.w	off_E222(pc,d0.w),d1
		jsr	off_E222(pc,d1.w)
		move.w	$32(a0),d0
		andi.w	#$FF80,d0
		move.w	(v_screenposx).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0
		cmpi.w	#$280,d0
		bhi.w	DeleteObject
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

off_E222:	dc.w loc_E228-off_E222, loc_E258-off_E222, loc_E268-off_E222
; ---------------------------------------------------------------------------

loc_E228:
		addq.b	#2,$24(a0)
		move.l	#MapCirclePtfm,4(a0)
		move.w	#$4480,2(a0)
		move.b	#4,1(a0)
		move.b	#4,$19(a0)
		move.b	#$18,$18(a0)
		move.w	8(a0),$32(a0)
		move.w	$C(a0),$30(a0)

loc_E258:
		moveq	#0,d1
		move.b	$18(a0),d1
		jsr	(PtfmNormal).l
		bra.w	sub_E284
; ---------------------------------------------------------------------------

loc_E268:
		moveq	#0,d1
		move.b	$18(a0),d1
		jsr	(PtfmCheckExit).l
		move.w	8(a0),-(sp)
		bsr.w	sub_E284
		move.w	(sp)+,d2
		jmp	(ptfmSurfaceNormal).l
; ---------------------------------------------------------------------------

sub_E284:
		moveq	#0,d0
		move.b	$28(a0),d0
		andi.w	#$C,d0
		lsr.w	#1,d0
		move.w	off_E298(pc,d0.w),d1
		jmp	off_E298(pc,d1.w)
; ---------------------------------------------------------------------------

off_E298:	dc.w loc_E29C-off_E298, loc_E2DA-off_E298
; ---------------------------------------------------------------------------

loc_E29C:
		move.b	(oscValues+$22).w,d1
		subi.b	#$50,d1
		ext.w	d1
		move.b	(oscValues+$26).w,d2
		subi.b	#$50,d2
		ext.w	d2
		btst	#0,$28(a0)
		beq.s	loc_E2BC
		neg.w	d1
		neg.w	d2

loc_E2BC:
		btst	#1,$28(a0)
		beq.s	loc_E2C8
		neg.w	d1
		exg	d1,d2

loc_E2C8:
		add.w	$32(a0),d1
		move.w	d1,8(a0)
		add.w	$30(a0),d2
		move.w	d2,$C(a0)
		rts
; ---------------------------------------------------------------------------

loc_E2DA:
		move.b	(oscValues+$22).w,d1
		subi.b	#$50,d1
		ext.w	d1
		move.b	(oscValues+$26).w,d2
		subi.b	#$50,d2
		ext.w	d2
		btst	#0,$28(a0)
		beq.s	loc_E2FA
		neg.w	d1
		neg.w	d2

loc_E2FA:
		btst	#1,$28(a0)
		beq.s	loc_E306
		neg.w	d1
		exg	d1,d2

loc_E306:
		neg.w	d1
		add.w	$32(a0),d1
		move.w	d1,8(a0)
		add.w	$30(a0),d2
		move.w	d2,$C(a0)
		rts
; ---------------------------------------------------------------------------
		include "levels\SLZ\CirclePtfm\Sprite.map"
		even
; ---------------------------------------------------------------------------

ObjStaircasePtfm:
		moveq	#0,d0
		move.b	$24(a0),d0
		move.w	off_E358(pc,d0.w),d1
		jsr	off_E358(pc,d1.w)
		move.w	$30(a0),d0
		andi.w	#$FF80,d0
		move.w	(v_screenposx).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0
		cmpi.w	#$280,d0
		bhi.w	DeleteObject
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

off_E358:	dc.w loc_E35E-off_E358, loc_E3DE-off_E358, loc_E3F2-off_E358
; ---------------------------------------------------------------------------

loc_E35E:
		addq.b	#2,$24(a0)
		moveq	#$38,d3
		moveq	#1,d4
		btst	#0,$22(a0)
		beq.s	loc_E372
		moveq	#$3B,d3
		moveq	#$FFFFFFFF,d4

loc_E372:
		move.w	8(a0),d2
		movea.l	a0,a1
		moveq	#3,d1
		bra.s	loc_E38A
; ---------------------------------------------------------------------------

loc_E37C:
		bsr.w	LoadNextObject
		bne.w	loc_E3DE
		move.b	#4,$24(a1)

loc_E38A:
		move.b	#$5B,0(a1)
		move.l	#MapStaircasePtfm,4(a1)
		move.w	#$4480,2(a1)
		move.b	#4,1(a1)
		move.b	#3,$19(a1)
		move.b	#$10,$18(a1)
		move.b	$28(a0),$28(a1)
		move.w	d2,8(a1)
		move.w	$C(a0),$C(a1)
		move.w	8(a0),$30(a1)
		move.w	$C(a1),$32(a1)
		addi.w	#$20,d2
		move.b	d3,$37(a1)
		move.l	a0,$3C(a1)
		add.b	d4,d3
		dbf	d1,loc_E37C

loc_E3DE:
		moveq	#0,d0
		move.b	$28(a0),d0
		andi.w	#7,d0
		add.w	d0,d0
		move.w	off_E43A(pc,d0.w),d1
		jsr	off_E43A(pc,d1.w)

loc_E3F2:
		movea.l	$3C(a0),a2
		moveq	#0,d0
		move.b	$37(a0),d0
		move.b	(a2,d0.w),d0
		add.w	$32(a0),d0
		move.w	d0,$C(a0)
		moveq	#0,d1
		move.b	$18(a0),d1
		addi.w	#$B,d1
		move.w	#$10,d2
		move.w	#$11,d3
		move.w	8(a0),d4
		bsr.w	SolidObject
		tst.b	d4
		bpl.s	loc_E42A
		move.b	d4,$36(a2)

loc_E42A:
		btst	#3,$22(a0)
		beq.s	locret_E438
		move.b	#1,$36(a2)

locret_E438:
		rts
; ---------------------------------------------------------------------------

off_E43A:	dc.w loc_E442-off_E43A, loc_E4A8-off_E43A, loc_E464-off_E43A, loc_E4A8-off_E43A
; ---------------------------------------------------------------------------

loc_E442:
		tst.w	$34(a0)
		bne.s	loc_E458
		cmpi.b	#1,$36(a0)
		bne.s	locret_E456
		move.w	#$1E,$34(a0)

locret_E456:
		rts
; ---------------------------------------------------------------------------

loc_E458:
		subq.w	#1,$34(a0)
		bne.s	locret_E456
		addq.b	#1,$28(a0)
		rts
; ---------------------------------------------------------------------------

loc_E464:
		tst.w	$34(a0)
		bne.s	loc_E478
		tst.b	$36(a0)
		bpl.s	locret_E476
		move.w	#$3C,$34(a0)

locret_E476:
		rts
; ---------------------------------------------------------------------------

loc_E478:
		subq.w	#1,$34(a0)
		bne.s	loc_E484
		addq.b	#1,$28(a0)
		rts
; ---------------------------------------------------------------------------

loc_E484:
		lea	$38(a0),a1
		move.w	$34(a0),d0
		lsr.b	#2,d0
		andi.b	#1,d0
		move.b	d0,(a1)+
		eori.b	#1,d0
		move.b	d0,(a1)+
		eori.b	#1,d0
		move.b	d0,(a1)+
		eori.b	#1,d0
		move.b	d0,(a1)+
		rts
; ---------------------------------------------------------------------------

loc_E4A8:
		lea	$38(a0),a1
		cmpi.b	#$80,(a1)
		beq.s	locret_E4D0
		addq.b	#1,(a1)
		moveq	#0,d1
		move.b	(a1)+,d1
		swap	d1
		lsr.l	#1,d1
		move.l	d1,d2
		lsr.l	#1,d1
		move.l	d1,d3
		add.l	d2,d3
		swap	d1
		swap	d2
		swap	d3
		move.b	d3,(a1)+
		move.b	d2,(a1)+
		move.b	d1,(a1)+

locret_E4D0:
		rts
; ---------------------------------------------------------------------------
		rts
; ---------------------------------------------------------------------------
		include "levels\SLZ\StaircasePtfm\Sprite.map"
		even
; ---------------------------------------------------------------------------

ObjSLZGirder:
		moveq	#0,d0
		move.b	$24(a0),d0
		move.w	off_E4EA(pc,d0.w),d1
		jmp	off_E4EA(pc,d1.w)
; ---------------------------------------------------------------------------

off_E4EA:	dc.w loc_E4EE-off_E4EA, loc_E506-off_E4EA
; ---------------------------------------------------------------------------

loc_E4EE:
		addq.b	#2,$24(a0)
		move.l	#MapSLZGirder,4(a0)
		move.w	#$83CC,2(a0)
		move.b	#$10,$18(a0)

loc_E506:
		move.l	(v_screenposx).w,d1
		add.l	d1,d1
		swap	d1
		neg.w	d1
		move.w	d1,8(a0)
		move.l	(v_screenposy).w,d1
		add.l	d1,d1
		swap	d1
		andi.w	#$3F,d1
		neg.w	d1
		addi.w	#$100,d1
		move.w	d1,$A(a0)
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------
		include "levels\SLZ\Girder\Sprite.map"
		even
; ---------------------------------------------------------------------------

ObjFan:
		moveq	#0,d0
		move.b	$24(a0),d0
		move.w	off_E56C(pc,d0.w),d1
		jmp	off_E56C(pc,d1.w)
; ---------------------------------------------------------------------------

off_E56C:	dc.w loc_E570-off_E56C, loc_E594-off_E56C
; ---------------------------------------------------------------------------

loc_E570:
		addq.b	#2,$24(a0)
		move.l	#MapFan,4(a0)
		move.w	#$43A0,2(a0)
		move.b	#4,1(a0)
		move.b	#$10,$18(a0)
		move.b	#4,$19(a0)

loc_E594:
		btst	#1,$28(a0)
		bne.s	loc_E5B6
		subq.w	#1,$30(a0)
		bpl.s	loc_E5B6
		move.w	#$78,$30(a0)
		bchg	#0,$32(a0)
		beq.s	loc_E5B6
		move.w	#$B4,$30(a0)

loc_E5B6:
		tst.b	$32(a0)
		bne.w	loc_E64E
		lea	(v_objspace).w,a1
		move.w	8(a1),d0
		sub.w	8(a0),d0
		btst	#0,$22(a0)
		bne.s	loc_E5D4
		neg.w	d0

loc_E5D4:
		addi.w	#$50,d0
		cmpi.w	#$F0,d0
		bcc.s	loc_E61C
		move.w	$C(a1),d1
		addi.w	#$60,d1
		sub.w	$C(a0),d1
		bcs.s	loc_E61C
		cmpi.w	#$70,d1
		bcc.s	loc_E61C
		subi.w	#$50,d0
		bcc.s	loc_E5FC
		not.w	d0
		add.w	d0,d0

loc_E5FC:
		addi.w	#$60,d0
		btst	#0,$22(a0)
		bne.s	loc_E60A
		neg.w	d0

loc_E60A:
		neg.b	d0
		asr.w	#4,d0
		btst	#0,$28(a0)
		beq.s	loc_E618
		neg.w	d0

loc_E618:
		add.w	d0,8(a1)

loc_E61C:
		subq.b	#1,$1E(a0)
		bpl.s	loc_E64E
		move.b	#0,$1E(a0)
		addq.b	#1,$1B(a0)
		cmpi.b	#3,$1B(a0)
		bcs.s	loc_E63A
		move.b	#0,$1B(a0)

loc_E63A:
		moveq	#0,d0
		btst	#0,$28(a0)
		beq.s	loc_E646
		moveq	#2,d0

loc_E646:
		add.b	$1B(a0),d0
		move.b	d0,$1A(a0)

loc_E64E:
		bsr.w	DisplaySprite
		move.w	8(a0),d0
		andi.w	#$FF80,d0
		move.w	(v_screenposx).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0
		cmpi.w	#$280,d0
		bhi.w	DeleteObject
		rts
; ---------------------------------------------------------------------------
		include "levels\SLZ\Fan\Sprite.map"
		even

                include "_incObj\5E Seesaw.asm"

ObjSeeSaw_SlopeTilt:dc.b $24, $24, $26, $28, $2A, $2C, $2A, $28, $26, $24
		dc.b $23, $22, $21, $20, $1F, $1E, $1D, $1C, $1B, $1A
		dc.b $19, $18, $17, $16, $15, $14, $13, $12, $11, $10
		dc.b $F, $E, $D, $C, $B, $A, 9, 8, 7, 6, 5, 4, 3, 2, 2
		dc.b 2, 2, 2

ObjSeeSaw_SlopeLine:dc.b $15, $15, $15, $15, $15, $15, $15, $15, $15, $15
		dc.b $15, $15, $15, $15, $15, $15, $15, $15, $15, $15
		dc.b $15, $15, $15, $15, $15, $15, $15, $15, $15, $15
		dc.b $15, $15, $15, $15, $15, $15, $15, $15, $15, $15
		dc.b $15, $15, $15, $15, $15, $15, $15, $15
		include "levels\SLZ\Seesaw\Sprite.map"
		even
; ---------------------------------------------------------------------------

ObjSonic:
		tst.w	(DebugRoutine).w
		bne.w	Edit
		moveq	#0,d0
		move.b	$24(a0),d0
		move.w	off_E826(pc,d0.w),d1
		jmp	off_E826(pc,d1.w)
; ---------------------------------------------------------------------------

off_E826:	dc.w loc_E830-off_E826, loc_E872-off_E826, Sonic_Hurt-off_E826, Sonic_Death-off_E826
		dc.w Sonic_ResetLevel-off_E826
; ---------------------------------------------------------------------------

loc_E830:
		addq.b	#2,$24(a0)
		move.b	#$13,$16(a0)
		move.b	#9,$17(a0)
		move.l	#MapSonic,4(a0)
		move.w	#$780,2(a0)
		move.b	#2,$19(a0)
		move.b	#$18,$18(a0)
		move.b	#4,1(a0)
		move.w	#$600,(unk_FFF760).w
		move.w	#$C,(unk_FFF762).w
		move.w	#$40,(unk_FFF764).w

loc_E872:
		andi.w	#$7FF,$C(a0)
		andi.w	#$7FF,(v_screenposy).w
		tst.w	(f_debugmode).w
		beq.s	loc_E892
		btst	#4,(v_jpadpress2).w
		beq.s	loc_E892
		move.w	#1,(DebugRoutine).w

loc_E892:
		moveq	#0,d0
		move.b	$22(a0),d0
		andi.w	#6,d0
		move.w	off_E8C8(pc,d0.w),d1
		jsr	off_E8C8(pc,d1.w)
		bsr.s	sub_E8D6
		bsr.w	sub_E952
		move.b	(unk_FFF768).w,$36(a0)
		move.b	(unk_FFF76A).w,$37(a0)
		bsr.w	Sonic_Animate
		bsr.w	TouchObjects
		bsr.w	Sonic_SpecialChunk
		bsr.w	Sonic_DynTiles
		rts
; ---------------------------------------------------------------------------

off_E8C8:	dc.w sub_E96C-off_E8C8, sub_E98E-off_E8C8, loc_E9A8-off_E8C8, loc_E9C6-off_E8C8

MusicList2:	dc.b bgm_GHZ
                dc.b bgm_LZ
                dc.b bgm_MZ
                dc.b bgm_SLZ
                dc.b bgm_SZ
                dc.b bgm_CWZ
; ---------------------------------------------------------------------------

sub_E8D6:
		move.w	$30(a0),d0
		beq.s	loc_E8E4
		subq.w	#1,$30(a0)
		lsr.w	#3,d0
		bcc.s	loc_E8E8

loc_E8E4:
		bsr.w	DisplaySprite

loc_E8E8:
		tst.b	(v_invinc).w
		beq.s	loc_E91C
		tst.w	$32(a0)
		beq.s	loc_E91C
		subq.w	#1,$32(a0)
		bne.s	loc_E91C
		tst.b	(unk_FFF7AA).w
		bne.s	loc_E916
		moveq	#0,d0
		move.b	(v_zone).w,d0

loc_E906:
		lea	(MusicList2).l,a1
		move.b	(a1,d0.w),d0
		jsr	(PlayMusic).l

loc_E916:
		move.b	#0,(v_invinc).w

loc_E91C:
		tst.b	(v_shoes).w
		beq.s	locret_E950
		tst.w	$34(a0)
		beq.s	locret_E950
		subq.w	#1,$34(a0)
		bne.s	locret_E950
		move.w	#$600,(unk_FFF760).w
		move.w	#$C,(unk_FFF762).w
		move.w	#$40,(unk_FFF764).w
		move.b	#0,(v_shoes).w
		move.w	#bgm_Slowdown,d0
		jmp	(PlaySFX).l
; ---------------------------------------------------------------------------

locret_E950:
		rts
; ---------------------------------------------------------------------------

sub_E952:
		move.w	(unk_FFF7A8).w,d0
		lea	(v_tracksonic).w,a1
		lea	(a1,d0.w),a1
		move.w	8(a0),(a1)+
		move.w	$C(a0),(a1)+
		addq.b	#4,(unk_FFF7A9).w
		rts
; ---------------------------------------------------------------------------

sub_E96C:
		bsr.w	Sonic_Jump
		bsr.w	Sonic_SlopeResist
		bsr.w	Sonic_Move
		bsr.w	Sonic_Roll
		bsr.w	Sonic_LevelBound
		bsr.w	SpeedToPos
		bsr.w	Sonic_AnglePosition
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
		bsr.w	Sonic_AnglePosition
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
; ---------------------------------------------------------------------------

Sonic_Move:
		move.w	(unk_FFF760).w,d6
		move.w	(unk_FFF762).w,d5
		move.w	(unk_FFF764).w,d4
		tst.w	$3E(a0)
		bne.w	Sonic_LookUp
		btst	#2,(v_jpadhold2).w
		beq.s	Sonic_NoLeft
		bsr.w	Sonic_MoveLeft

Sonic_NoLeft:
		btst	#3,(v_jpadhold2).w
		beq.s	Sonic_NoRight
		bsr.w	Sonic_MoveRight

Sonic_NoRight:
		move.b	$26(a0),d0
		addi.b	#$20,d0
		andi.b	#$C0,d0
		bne.w	Sonic_ResetScroll
		tst.w	$14(a0)
		bne.w	Sonic_ResetScroll
		bclr	#5,$22(a0)
		move.b	#5,$1C(a0)
		btst	#3,$22(a0)
		beq.s	Sonic_Balance
		moveq	#0,d0
		move.b	$3D(a0),d0
		lsl.w	#6,d0
		lea	(v_objspace).w,a1
		lea	(a1,d0.w),a1
		tst.b	$22(a1)
		bmi.s	Sonic_LookUp
		moveq	#0,d1
		move.b	$18(a1),d1
		move.w	d1,d2
		add.w	d2,d2
		subq.w	#4,d2
		add.w	8(a0),d1
		sub.w	8(a1),d1
		cmpi.w	#4,d1
		blt.s	loc_EA92
		cmp.w	d2,d1
		bge.s	loc_EA82
		bra.s	Sonic_LookUp
; ---------------------------------------------------------------------------

Sonic_Balance:
		jsr	(ObjectHitFloor).l
		cmpi.w	#$C,d1
		blt.s	Sonic_LookUp
		cmpi.b	#3,$36(a0)
		bne.s	loc_EA8A

loc_EA82:
		bclr	#0,$22(a0)
		bra.s	loc_EA98
; ---------------------------------------------------------------------------

loc_EA8A:
		cmpi.b	#3,$37(a0)
		bne.s	Sonic_LookUp

loc_EA92:
		bset	#0,$22(a0)

loc_EA98:
		move.b	#6,$1C(a0)
		bra.s	Sonic_ResetScroll
; ---------------------------------------------------------------------------

Sonic_LookUp:
		btst	#0,(v_jpadhold2).w
		beq.s	Sonic_Duck
		move.b	#7,$1C(a0)
		cmpi.w	#$C8,(unk_FFF73E).w
		beq.s	loc_EAEA
		addq.w	#2,(unk_FFF73E).w
		bra.s	loc_EAEA
; ---------------------------------------------------------------------------

Sonic_Duck:
		btst	#1,(v_jpadhold2).w
		beq.s	Sonic_ResetScroll
		move.b	#8,$1C(a0)
		cmpi.w	#8,(unk_FFF73E).w
		beq.s	loc_EAEA
		subq.w	#2,(unk_FFF73E).w
		bra.s	loc_EAEA
; ---------------------------------------------------------------------------

Sonic_ResetScroll:
		cmpi.w	#$60,(unk_FFF73E).w
		beq.s	loc_EAEA
		bcc.s	loc_EAE6
		addq.w	#4,(unk_FFF73E).w

loc_EAE6:
		subq.w	#2,(unk_FFF73E).w

loc_EAEA:
		move.b	(v_jpadhold2).w,d0
		andi.b	#$C,d0
		bne.s	loc_EB16
		move.w	$14(a0),d0
		beq.s	loc_EB16
		bmi.s	loc_EB0A
		sub.w	d5,d0
		bcc.s	loc_EB04
		move.w	#0,d0

loc_EB04:
		move.w	d0,$14(a0)
		bra.s	loc_EB16
; ---------------------------------------------------------------------------

loc_EB0A:
		add.w	d5,d0
		bcc.s	loc_EB12
		move.w	#0,d0

loc_EB12:
		move.w	d0,$14(a0)

loc_EB16:
		move.b	$26(a0),d0
		jsr	(GetSine).l
		muls.w	$14(a0),d1
		asr.l	#8,d1
		move.w	d1,$10(a0)
		muls.w	$14(a0),d0
		asr.l	#8,d0
		move.w	d0,$12(a0)

loc_EB34:
		move.b	#$40,d1
		tst.w	$14(a0)
		beq.s	locret_EB8E
		bmi.s	loc_EB42
		neg.w	d1

loc_EB42:
		move.b	$26(a0),d0
		add.b	d1,d0
		move.w	d0,-(sp)
		bsr.w	Sonic_WalkSpeed
		move.w	(sp)+,d0
		tst.w	d1
		bpl.s	locret_EB8E
		move.w	#0,$14(a0)
		bset	#5,$22(a0)
		asl.w	#8,d1
		addi.b	#$20,d0
		andi.b	#$C0,d0
		beq.s	loc_EB8A
		cmpi.b	#$40,d0
		beq.s	loc_EB84
		cmpi.b	#$80,d0
		beq.s	loc_EB7E
		add.w	d1,$10(a0)
		rts
; ---------------------------------------------------------------------------

loc_EB7E:
		sub.w	d1,$12(a0)
		rts
; ---------------------------------------------------------------------------

loc_EB84:
		sub.w	d1,$10(a0)
		rts
; ---------------------------------------------------------------------------

loc_EB8A:
		add.w	d1,$12(a0)

locret_EB8E:
		rts
; ---------------------------------------------------------------------------

Sonic_MoveLeft:
		move.w	$14(a0),d0
		beq.s	loc_EB98
		bpl.s	loc_EBC4

loc_EB98:
		bset	#0,$22(a0)
		bne.s	loc_EBAC
		bclr	#5,$22(a0)
		move.b	#1,$1D(a0)

loc_EBAC:
		sub.w	d5,d0
		move.w	d6,d1
		neg.w	d1
		cmp.w	d1,d0
		bgt.s	loc_EBB8
		move.w	d1,d0

loc_EBB8:
		move.w	d0,$14(a0)
		move.b	#0,$1C(a0)
		rts
; ---------------------------------------------------------------------------

loc_EBC4:
		sub.w	d4,d0
		bcc.s	loc_EBCC
		move.w	#$FF80,d0

loc_EBCC:
		move.w	d0,$14(a0)
		move.b	$26(a0),d0
		addi.b	#$20,d0
		andi.b	#$C0,d0
		bne.s	locret_EBFA
		cmpi.w	#$400,d0
		blt.s	locret_EBFA
		move.b	#$D,$1C(a0)
		bclr	#0,$22(a0)
		move.w	#sfx_Skid,d0
		jsr	(PlaySFX).l

locret_EBFA:
		rts
; ---------------------------------------------------------------------------

Sonic_MoveRight:
		move.w	$14(a0),d0
		bmi.s	loc_EC2A
		bclr	#0,$22(a0)
		beq.s	loc_EC16
		bclr	#5,$22(a0)
		move.b	#1,$1D(a0)

loc_EC16:
		add.w	d5,d0
		cmp.w	d6,d0
		blt.s	loc_EC1E
		move.w	d6,d0

loc_EC1E:
		move.w	d0,$14(a0)
		move.b	#0,$1C(a0)
		rts
; ---------------------------------------------------------------------------

loc_EC2A:
		add.w	d4,d0
		bcc.s	loc_EC32
		move.w	#$80,d0

loc_EC32:
		move.w	d0,$14(a0)
		move.b	$26(a0),d0
		addi.b	#$20,d0
		andi.b	#$C0,d0
		bne.s	locret_EC60
		cmpi.w	#$FC00,d0
		bgt.s	locret_EC60
		move.b	#$D,$1C(a0)
		bset	#0,$22(a0)
		move.w	#sfx_Skid,d0
		jsr	(PlaySFX).l

locret_EC60:
		rts
; ---------------------------------------------------------------------------

Sonic_RollSpeed:
		move.w	(unk_FFF760).w,d6
		asl.w	#1,d6
		move.w	(unk_FFF762).w,d5
		asr.w	#1,d5
		move.w	(unk_FFF764).w,d4
		asr.w	#2,d4
		tst.w	$3E(a0)
		bne.s	loc_EC92
		btst	#2,(v_jpadhold2).w
		beq.s	loc_EC86
		bsr.w	Sonic_RollLeft

loc_EC86:
		btst	#3,(v_jpadhold2).w
		beq.s	loc_EC92
		bsr.w	Sonic_RollRight

loc_EC92:
		move.w	$14(a0),d0
		beq.s	loc_ECB4
		bmi.s	loc_ECA8
		sub.w	d5,d0
		bcc.s	loc_ECA2
		move.w	#0,d0

loc_ECA2:
		move.w	d0,$14(a0)
		bra.s	loc_ECB4
; ---------------------------------------------------------------------------

loc_ECA8:
		add.w	d5,d0
		bcc.s	loc_ECB0
		move.w	#0,d0

loc_ECB0:
		move.w	d0,$14(a0)

loc_ECB4:
		tst.w	$14(a0)
		bne.s	loc_ECD6
		bclr	#2,$22(a0)
		move.b	#$13,$16(a0)
		move.b	#9,$17(a0)
		move.b	#5,$1C(a0)
		subq.w	#5,$C(a0)

loc_ECD6:
		move.b	$26(a0),d0
		jsr	(GetSine).l
		muls.w	$14(a0),d1
		asr.l	#8,d1
		move.w	d1,$10(a0)
		muls.w	$14(a0),d0
		asr.l	#8,d0
		move.w	d0,$12(a0)
		bra.w	loc_EB34
; ---------------------------------------------------------------------------

Sonic_RollLeft:
		move.w	$14(a0),d0
		beq.s	loc_ED00
		bpl.s	loc_ED0E

loc_ED00:
		bset	#0,$22(a0)
		move.b	#2,$1C(a0)
		rts
; ---------------------------------------------------------------------------

loc_ED0E:
		sub.w	d4,d0
		bcc.s	loc_ED16
		move.w	#$FF80,d0

loc_ED16:
		move.w	d0,$14(a0)
		rts
; ---------------------------------------------------------------------------

Sonic_RollRight:
		move.w	$14(a0),d0
		bmi.s	loc_ED30
		bclr	#0,$22(a0)
		move.b	#2,$1C(a0)
		rts
; ---------------------------------------------------------------------------

loc_ED30:
		add.w	d4,d0
		bcc.s	loc_ED38
		move.w	#$80,d0

loc_ED38:
		move.w	d0,$14(a0)
		rts
; ---------------------------------------------------------------------------

Sonic_ChgJumpDirection:
		move.w	(unk_FFF760).w,d6
		move.w	(unk_FFF762).w,d5
		asl.w	#1,d5
		btst	#4,$22(a0)
		bne.s	Sonic_ResetScroll2
		move.w	$10(a0),d0
		btst	#2,(v_jpadhold1).w
		beq.s	loc_ED6E
		bset	#0,$22(a0)
		sub.w	d5,d0
		move.w	d6,d1
		neg.w	d1
		cmp.w	d1,d0
		bgt.s	loc_ED6E
		move.w	d1,d0

loc_ED6E:
		btst	#3,(v_jpadhold1).w
		beq.s	Sonic_JumpMove
		bclr	#0,$22(a0)
		add.w	d5,d0
		cmp.w	d6,d0
		blt.s	Sonic_JumpMove
		move.w	d6,d0

Sonic_JumpMove:
		move.w	d0,$10(a0)

Sonic_ResetScroll2:
		cmpi.w	#$60,(unk_FFF73E).w
		beq.s	loc_ED9A
		bcc.s	loc_ED96
		addq.w	#4,(unk_FFF73E).w

loc_ED96:
		subq.w	#2,(unk_FFF73E).w

loc_ED9A:
		cmpi.w	#$FC00,$12(a0)
		bcs.s	locret_EDC8
		move.w	$10(a0),d0
		move.w	d0,d1
		asr.w	#5,d1
		beq.s	locret_EDC8
		bmi.s	loc_EDBC
		sub.w	d1,d0
		bcc.s	loc_EDB6
		move.w	#0,d0

loc_EDB6:
		move.w	d0,$10(a0)
		rts
; ---------------------------------------------------------------------------

loc_EDBC:
		sub.w	d1,d0
		bcs.s	loc_EDC4
		move.w	#0,d0

loc_EDC4:
		move.w	d0,$10(a0)

locret_EDC8:
		rts
; ---------------------------------------------------------------------------

Sonic_Squish:
		move.b	$26(a0),d0
		addi.b	#$20,d0
		andi.b	#$C0,d0
		bne.s	locret_EDF8
		bsr.w	Sonic_NoRunningOnWalls
		tst.w	d1
		bpl.s	locret_EDF8
		move.w	#0,$14(a0)
		move.w	#0,$10(a0)
		move.w	#0,$12(a0)
		move.b	#$B,$1C(a0)

locret_EDF8:
		rts
; ---------------------------------------------------------------------------

Sonic_LevelBound:
		move.l	8(a0),d1
		move.w	$10(a0),d0
		ext.l	d0
		asl.l	#8,d0
		add.l	d0,d1
		swap	d1
		move.w	(unk_FFF728).w,d0
		addi.w	#$10,d0
		cmp.w	d1,d0
		bhi.s	Sonic_BoundSides
		move.w	(unk_FFF72A).w,d0
		addi.w	#$128,d0
		cmp.w	d1,d0
		bls.s	Sonic_BoundSides
		move.w	(unk_FFF72E).w,d0
		addi.w	#$E0,d0
		cmp.w	$C(a0),d0
		bcs.w	loc_FD78
		rts
; ---------------------------------------------------------------------------

Sonic_BoundSides:
		move.w	d0,8(a0)
		move.w	#0,$A(a0)
		move.w	#0,$10(a0)
		move.w	#0,$14(a0)
		rts
; ---------------------------------------------------------------------------

Sonic_Roll:
		move.w	$14(a0),d0
		bpl.s	loc_EE54
		neg.w	d0

loc_EE54:
		cmpi.w	#$80,d0
		bcs.s	locret_EE6C
		move.b	(v_jpadhold2).w,d0
		andi.b	#$C,d0
		bne.s	locret_EE6C
		btst	#1,(v_jpadhold2).w
		bne.s	Sonic_CheckRoll

locret_EE6C:
		rts
; ---------------------------------------------------------------------------

Sonic_CheckRoll:
		btst	#2,$22(a0)
		beq.s	Sonic_DoRoll
		rts
; ---------------------------------------------------------------------------

Sonic_DoRoll:
		bset	#2,$22(a0)
		move.b	#$E,$16(a0)
		move.b	#7,$17(a0)
		move.b	#2,$1C(a0)
		addq.w	#5,$C(a0)
		move.w	#sfx_Roll,d0
		jsr	(PlaySFX).l
		tst.w	$14(a0)
		bne.s	locret_EEAA
		move.w	#$200,$14(a0)

locret_EEAA:
		rts
; ---------------------------------------------------------------------------

Sonic_Jump:
		move.b	(v_jpadpress2).w,d0
		andi.b	#$70,d0
		beq.w	locret_EF46
		moveq	#0,d0
		move.b	$26(a0),d0
		addi.b	#-$80,d0
		bsr.w	sub_10520
		cmpi.w	#6,d1
		blt.w	locret_EF46
		moveq	#0,d0
		move.b	$26(a0),d0
		subi.b	#$40,d0
		jsr	(GetSine).l
		muls.w	#$680,d1
		asr.l	#8,d1
		add.w	d1,$10(a0)
		muls.w	#$680,d0
		asr.l	#8,d0
		add.w	d0,$12(a0)
		bset	#1,$22(a0)
		bclr	#5,$22(a0)
		addq.l	#4,sp
		move.b	#1,$3C(a0)
		move.w	#sfx_Jump,d0
		jsr	(PlaySFX).l
		move.b	#$13,$16(a0)
		move.b	#9,$17(a0)
		tst.b	(f_victory).w			; has the victory animation flag been set?
		bne.s	loc_EF48			; if not, branch
		btst	#2,$22(a0)			; use "victory leaping" animation
		bne.s	loc_EF50
		move.b	#$E,$16(a0)
		move.b	#7,$17(a0)
		move.b	#2,$1C(a0)			; use "jumping" animation
		bset	#2,$22(a0)
		addq.w	#5,$C(a0)

locret_EF46:
		rts
; ---------------------------------------------------------------------------

loc_EF48:
		move.b	#$13,$1C(a0)
		rts
; ---------------------------------------------------------------------------

loc_EF50:
		bset	#4,$22(a0)
		rts
; ---------------------------------------------------------------------------

Sonic_JumpHeight:
		tst.b	$3C(a0)
		beq.s	loc_EF78
		cmpi.w	#$FC00,$12(a0)
		bge.s	locret_EF76
		move.b	(v_jpadhold2).w,d0
		andi.b	#$70,d0
		bne.s	locret_EF76
		move.w	#$FC00,$12(a0)

locret_EF76:
		rts
; ---------------------------------------------------------------------------

loc_EF78:
		cmpi.w	#$F040,$12(a0)
		bge.s	locret_EF86
		move.w	#$F040,$12(a0)

locret_EF86:
		rts
; ---------------------------------------------------------------------------

Sonic_SlopeResist:
		move.b	$26(a0),d0
		addi.b	#$60,d0
		cmpi.b	#$C0,d0
		bcc.s	locret_EFBC
		move.b	$26(a0),d0
		jsr	(GetSine).l
		muls.w	#$20,d0
		asr.l	#8,d0
		tst.w	$14(a0)
		beq.s	locret_EFBC
		bmi.s	loc_EFB8
		tst.w	d0
		beq.s	locret_EFB6
		add.w	d0,$14(a0)

locret_EFB6:
		rts
; ---------------------------------------------------------------------------

loc_EFB8:
		add.w	d0,$14(a0)

locret_EFBC:
		rts
; ---------------------------------------------------------------------------

Sonic_RollRepel:
		move.b	$26(a0),d0
		addi.b	#$60,d0
		cmpi.b	#$C0,d0
		bcc.s	locret_EFF8
		move.b	$26(a0),d0
		jsr	(GetSine).l
		muls.w	#$50,d0
		asr.l	#8,d0
		tst.w	$14(a0)
		bmi.s	loc_EFEE
		tst.w	d0
		bpl.s	loc_EFE8
		asr.l	#2,d0

loc_EFE8:
		add.w	d0,$14(a0)
		rts
; ---------------------------------------------------------------------------

loc_EFEE:
		tst.w	d0
		bmi.s	loc_EFF4
		asr.l	#2,d0

loc_EFF4:
		add.w	d0,$14(a0)

locret_EFF8:
		rts
; ---------------------------------------------------------------------------

Sonic_SlopeRepel:
		nop
		tst.w	$3E(a0)
		bne.s	loc_F02C
		move.b	$26(a0),d0
		addi.b	#$20,d0
		andi.b	#$C0,d0
		beq.s	locret_F02A
		move.w	$14(a0),d0
		bpl.s	loc_F018
		neg.w	d0

loc_F018:
		cmpi.w	#$280,d0
		bcc.s	locret_F02A
		bset	#1,$22(a0)
		move.w	#$1E,$3E(a0)

locret_F02A:
		rts
; ---------------------------------------------------------------------------

loc_F02C:
		subq.w	#1,$3E(a0)
		rts
; ---------------------------------------------------------------------------

Sonic_JumpAngle:
		move.b	$26(a0),d0
		beq.s	locret_F04C
		bpl.s	loc_F042
		addq.b	#2,d0
		bcc.s	loc_F040
		moveq	#0,d0

loc_F040:
		bra.s	loc_F048
; ---------------------------------------------------------------------------

loc_F042:
		subq.b	#2,d0
		bcc.s	loc_F048
		moveq	#0,d0

loc_F048:
		move.b	d0,$26(a0)

locret_F04C:
		rts
; ---------------------------------------------------------------------------

Sonic_Floor:
		move.w	$10(a0),d1
		move.w	$12(a0),d2
		jsr	(CalcAngle).l
		subi.b	#$20,d0
		andi.b	#$C0,d0
		cmpi.b	#$40,d0
		beq.w	loc_F104
		cmpi.b	#$80,d0
		beq.w	loc_F160
		cmpi.b	#$C0,d0
		beq.w	loc_F1BC

loc_F07C:
		bsr.w	Sonic_HitWall
		tst.w	d1
		bpl.s	loc_F08E
		sub.w	d1,8(a0)
		move.w	#0,$10(a0)

loc_F08E:
		bsr.w	sub_1068C
		tst.w	d1
		bpl.s	loc_F0A0
		add.w	d1,8(a0)
		move.w	#0,$10(a0)

loc_F0A0:
		bsr.w	Sonic_HitFloor
		tst.w	d1
		bpl.s	locret_F102
		move.b	$12(a0),d0
		addq.b	#8,d0
		neg.b	d0
		cmp.b	d0,d1
		blt.s	locret_F102
		add.w	d1,$C(a0)
		move.b	d3,$26(a0)
		bsr.w	Sonic_ResetOnFloor
		move.b	#0,$1C(a0)
		move.b	d3,d0
		addi.b	#$20,d0
		andi.b	#$40,d0
		bne.s	loc_F0E0
		move.w	#0,$12(a0)
		move.w	$10(a0),$14(a0)
		rts
; ---------------------------------------------------------------------------

loc_F0E0:
		move.w	#0,$10(a0)
		cmpi.w	#$FC0,$12(a0)
		ble.s	loc_F0F4
		move.w	#$FC0,$12(a0)

loc_F0F4:
		move.w	$12(a0),$14(a0)
		tst.b	d3
		bpl.s	locret_F102
		neg.w	$14(a0)

locret_F102:
		rts
; ---------------------------------------------------------------------------

loc_F104:
		bsr.w	Sonic_HitWall
		tst.w	d1
		bpl.s	loc_F11E
		sub.w	d1,8(a0)
		move.w	#0,$10(a0)
		move.w	$12(a0),$14(a0)
		rts
; ---------------------------------------------------------------------------

loc_F11E:
		bsr.w	Sonic_NoRunningOnWalls
		tst.w	d1
		bpl.s	loc_F132
		sub.w	d1,$C(a0)
		move.w	#0,$12(a0)
		rts
; ---------------------------------------------------------------------------

loc_F132:
		tst.w	$12(a0)
		bmi.s	locret_F15E
		bsr.w	Sonic_HitFloor
		tst.w	d1
		bpl.s	locret_F15E
		add.w	d1,$C(a0)
		move.b	d3,$26(a0)
		bsr.w	Sonic_ResetOnFloor
		move.b	#0,$1C(a0)
		move.w	#0,$12(a0)
		move.w	$10(a0),$14(a0)

locret_F15E:
		rts
; ---------------------------------------------------------------------------

loc_F160:
		bsr.w	Sonic_HitWall
		tst.w	d1
		bpl.s	loc_F172
		sub.w	d1,8(a0)
		move.w	#0,$10(a0)

loc_F172:
		bsr.w	sub_1068C
		tst.w	d1
		bpl.s	loc_F184
		add.w	d1,8(a0)
		move.w	#0,$10(a0)

loc_F184:
		bsr.w	Sonic_NoRunningOnWalls
		tst.w	d1
		bpl.s	locret_F1BA
		sub.w	d1,$C(a0)
		move.b	d3,d0
		addi.b	#$20,d0
		andi.b	#$40,d0
		bne.s	loc_F1A4
		move.w	#0,$12(a0)
		rts
; ---------------------------------------------------------------------------

loc_F1A4:
		move.b	d3,$26(a0)
		bsr.w	Sonic_ResetOnFloor
		move.w	$12(a0),$14(a0)
		tst.b	d3
		bpl.s	locret_F1BA
		neg.w	$14(a0)

locret_F1BA:
		rts
; ---------------------------------------------------------------------------

loc_F1BC:
		bsr.w	sub_1068C
		tst.w	d1
		bpl.s	loc_F1D6
		add.w	d1,8(a0)
		move.w	#0,$10(a0)
		move.w	$12(a0),$14(a0)
		rts
; ---------------------------------------------------------------------------

loc_F1D6:
		bsr.w	Sonic_NoRunningOnWalls
		tst.w	d1
		bpl.s	loc_F1EA
		sub.w	d1,$C(a0)
		move.w	#0,$12(a0)
		rts
; ---------------------------------------------------------------------------

loc_F1EA:
		tst.w	$12(a0)
		bmi.s	locret_F216
		bsr.w	Sonic_HitFloor
		tst.w	d1
		bpl.s	locret_F216
		add.w	d1,$C(a0)
		move.b	d3,$26(a0)
		bsr.w	Sonic_ResetOnFloor
		move.b	#0,$1C(a0)
		move.w	#0,$12(a0)
		move.w	$10(a0),$14(a0)

locret_F216:
		rts
; ---------------------------------------------------------------------------

Sonic_ResetOnFloor:
		btst	#4,$22(a0)
		beq.s	loc_F226
		nop
		nop
		nop

loc_F226:
		bclr	#5,$22(a0)
		bclr	#1,$22(a0)
		bclr	#4,$22(a0)
		btst	#2,$22(a0)
		beq.s	loc_F25C
		bclr	#2,$22(a0)
		move.b	#$13,$16(a0)
		move.b	#9,$17(a0)
		move.b	#0,$1C(a0)
		subq.w	#5,$C(a0)

loc_F25C:
		move.w	#0,$3E(a0)
		move.b	#0,$3C(a0)
		rts
; ---------------------------------------------------------------------------
loc_F26A:						; Gets Sonic's XY position and adds it to the early debug seen in CC.
		lea	(v_objspace+$400).w,a1
		move.w	8(a0),d0
		bsr.w	sub_F290
		lea	(v_objspace+$500).w,a1
		move.w	$C(a0),d0
		bsr.w	sub_F290
		lea	(v_objspace+$600).w,a1
		move.w	$14(a0),d0
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
; ---------------------------------------------------------------------------

Sonic_Hurt:
		bsr.w	Sonic_HurtStop
		bsr.w	SpeedToPos
		addi.w	#$30,$12(a0)
		bsr.w	Sonic_LevelBound
		bsr.w	sub_E952
		bsr.w	Sonic_Animate
		bsr.w	Sonic_DynTiles
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

Sonic_HurtStop:
		move.w	(unk_FFF72E).w,d0
		addi.w	#$E0,d0
		cmp.w	$C(a0),d0
		bcs.w	loc_FD78
		bsr.w	loc_F07C
		btst	#1,$22(a0)
		bne.s	locret_F318
		moveq	#0,d0
		move.w	d0,$12(a0)
		move.w	d0,$10(a0)
		move.w	d0,$14(a0)
		move.b	#0,$1C(a0)
		subq.b	#2,$24(a0)
		move.w	#$78,$30(a0)

locret_F318:
		rts
; ---------------------------------------------------------------------------

Sonic_Death:
		bsr.w	Sonic_GameOver
		bsr.w	ObjectFall
		bsr.w	sub_E952
		bsr.w	Sonic_Animate
		bsr.w	Sonic_DynTiles
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

Sonic_GameOver:
		move.w	(unk_FFF72E).w,d0
		addi.w	#$100,d0
		cmp.w	$C(a0),d0
		bcc.w	locret_F3AE
		move.w	#$FFC8,$12(a0)
		addq.b	#2,$24(a0)
		addq.b	#1,(byte_FFFE1C).w
		subq.b	#1,(v_lives).w
		bne.s	loc_F380
		move.w	#0,$3A(a0)
		move.b	#$39,(v_objspace+$80).w
		move.b	#$39,(v_objspace+$C0).w
		move.b	#1,(v_objspace+$DA).w
		move.w	#bgm_GameOver,d0
		jsr	(PlaySFX).l
		moveq	#plcid_GameOver,d0
		jmp	(plcAdd).l
; ---------------------------------------------------------------------------

loc_F380:
		move.w	#$3C,$3A(a0)
		rts
; ---------------------------------------------------------------------------
loc_F388:
		move.b	(v_jpadpress2).w,d0
		andi.b	#$70,d0
		beq.s	locret_F3AE
		andi.b	#$40,d0
		bne.s	loc_F3B0
		move.b	#0,$1C(a0)			; Respawns you after a death
		subq.b	#4,$24(a0)			; The lines above seem to make the code do nothing
		move.w	$38(a0),$C(a0)
		move.w	#$78,$30(a0)

locret_F3AE:
		rts
; ---------------------------------------------------------------------------

loc_F3B0:
		move.w	#1,(LevelRestart).w
		rts
; ---------------------------------------------------------------------------

Sonic_ResetLevel:
		tst.w	$3A(a0)
		beq.s	locret_F3CA
		subq.w	#1,$3A(a0)
		bne.s	locret_F3CA
		move.w	#1,(LevelRestart).w

locret_F3CA:
		rts
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
; ---------------------------------------------------------------------------

Sonic_SpecialChunk:
		cmpi.b	#3,(v_zone).w
		beq.s	loc_F3F4
		tst.b	(v_zone).w
		bne.w	locret_F490

loc_F3F4:
		move.w	$C(a0),d0
		lsr.w	#1,d0
		andi.w	#$380,d0
		move.w	8(a0),d1
		move.w	d1,d2
		lsr.w	#8,d1
		andi.w	#$7F,d1
		add.w	d1,d0
		lea	(v_lvllayout).w,a1
		move.b	(a1,d0.w),d1
		cmp.b	(unk_FFF7AE).w,d1
		beq.w	Sonic_CheckRoll
		cmp.b	(unk_FFF7AF).w,d1
		beq.w	Sonic_CheckRoll
		cmp.b	(unk_FFF7AC).w,d1
		beq.s	loc_F448
		cmp.b	(unk_FFF7AD).w,d1
		beq.s	loc_F438
		bclr	#6,1(a0)
		rts
; ---------------------------------------------------------------------------

loc_F438:
		btst	#1,$22(a0)
		beq.s	loc_F448
		bclr	#6,1(a0)
		rts
; ---------------------------------------------------------------------------

loc_F448:
		cmpi.b	#$2C,d2
		bcc.s	loc_F456
		bclr	#6,1(a0)
		rts
; ---------------------------------------------------------------------------

loc_F456:
		cmpi.b	#$E0,d2
		bcs.s	loc_F464
		bset	#6,1(a0)
		rts
; ---------------------------------------------------------------------------

loc_F464:
		btst	#6,1(a0)
		bne.s	loc_F480
		move.b	$26(a0),d1
		beq.s	locret_F490
		cmpi.b	#$80,d1
		bhi.s	locret_F490
		bset	#6,1(a0)
		rts
; ---------------------------------------------------------------------------

loc_F480:
		move.b	$26(a0),d1
		cmpi.b	#$80,d1
		bls.s	locret_F490
		bclr	#6,1(a0)

locret_F490:
		rts
; ---------------------------------------------------------------------------

Sonic_Animate:
		lea	(AniSonic).l,a1
		moveq	#0,d0
		move.b	$1C(a0),d0
		cmp.b	$1D(a0),d0
		beq.s	Sonic_AnimDo
		move.b	d0,$1D(a0)
		move.b	#0,$1B(a0)
		move.b	#0,$1E(a0)

Sonic_AnimDo:
		add.w	d0,d0
		adda.w	(a1,d0.w),a1
		move.b	(a1),d0
		bmi.s	Sonic_AnimateCmd
		move.b	$22(a0),d1
		andi.b	#1,d1
		andi.b	#$FC,1(a0)
		or.b	d1,1(a0)
		subq.b	#1,$1E(a0)
		bpl.s	Sonic_AnimDelay
		move.b	d0,$1E(a0)
; ---------------------------------------------------------------------------

Sonic_AnimDo2:
		moveq	#0,d1
		move.b	$1B(a0),d1
		move.b	1(a1,d1.w),d0
		bmi.s	Sonic_AnimEndFF

Sonic_AnimNext:
		move.b	d0,$1A(a0)
		addq.b	#1,$1B(a0)

Sonic_AnimDelay:
		rts
; ---------------------------------------------------------------------------

Sonic_AnimEndFF:
		addq.b	#1,d0
		bne.s	Sonic_AnimFE
		move.b	#0,$1B(a0)
		move.b	1(a1),d0
		bra.s	Sonic_AnimNext
; ---------------------------------------------------------------------------

Sonic_AnimFE:
		addq.b	#1,d0
		bne.s	Sonic_AnimFD
		move.b	2(a1,d1.w),d0
		sub.b	d0,$1B(a0)
		sub.b	d0,d1
		move.b	1(a1,d1.w),d0
		bra.s	Sonic_AnimNext
; ---------------------------------------------------------------------------

Sonic_AnimFD:
		addq.b	#1,d0
		bne.s	Sonic_AnimEnd
		move.b	2(a1,d1.w),$1C(a0)

Sonic_AnimEnd:
		rts
; ---------------------------------------------------------------------------

Sonic_AnimateCmd:
		subq.b	#1,$1E(a0)
		bpl.s	Sonic_AnimDelay
		addq.b	#1,d0
		bne.w	Sonic_AnimRollJump
		moveq	#0,d1
		move.b	$26(a0),d0
		move.b	$22(a0),d2
		andi.b	#1,d2
		bne.s	loc_F53E
		not.b	d0

loc_F53E:
		addi.b	#$10,d0
		bpl.s	loc_F546
		moveq	#3,d1

loc_F546:
		andi.b	#$FC,1(a0)
		eor.b	d1,d2
		or.b	d2,1(a0)
		btst	#5,$22(a0)
		bne.w	Sonic_AnimPush
		lsr.b	#4,d0
		andi.b	#6,d0
		move.w	$14(a0),d2
		bpl.s	loc_F56A
		neg.w	d2

loc_F56A:
		lea	(byte_F654).l,a1
		cmpi.w	#$600,d2
		bcc.s	loc_F582
		lea	(byte_F64C).l,a1
		move.b	d0,d1
		lsr.b	#1,d1
		add.b	d1,d0

loc_F582:
		add.b	d0,d0
		move.b	d0,d3
		neg.w	d2
		addi.w	#$800,d2
		bpl.s	loc_F590
		moveq	#0,d2

loc_F590:
		lsr.w	#8,d2
		move.b	d2,$1E(a0)
		bsr.w	Sonic_AnimDo2
		add.b	d3,$1A(a0)
		rts
; ---------------------------------------------------------------------------

Sonic_AnimRollJump:
		addq.b	#1,d0
		bne.s	Sonic_AnimPush
		move.w	$14(a0),d2
		bpl.s	loc_F5AC
		neg.w	d2

loc_F5AC:
		lea	(byte_F664).l,a1
		cmpi.w	#$600,d2
		bcc.s	loc_F5BE
		lea	(byte_F65C).l,a1

loc_F5BE:
		neg.w	d2
		addi.w	#$400,d2
		bpl.s	loc_F5C8
		moveq	#0,d2

loc_F5C8:
		lsr.w	#8,d2
		move.b	d2,$1E(a0)
		move.b	$22(a0),d1
		andi.b	#1,d1
		andi.b	#$FC,1(a0)
		or.b	d1,1(a0)
		bra.w	Sonic_AnimDo2
; ---------------------------------------------------------------------------

Sonic_AnimPush:
		move.w	$14(a0),d2
		bmi.s	loc_F5EC
		neg.w	d2

loc_F5EC:
		addi.w	#$800,d2
		bpl.s	loc_F5F4
		moveq	#0,d2

loc_F5F4:
		lsr.w	#6,d2
		move.b	d2,$1E(a0)

loc_F5FA:
		lea	(byte_F66C).l,a1
		move.b	$22(a0),d1
		andi.b	#1,d1
		andi.b	#$FC,1(a0)
		or.b	d1,1(a0)
		bra.w	Sonic_AnimDo2
; ---------------------------------------------------------------------------
AniSonic:
		include "_anim\Sonic.asm"
		even
; ---------------------------------------------------------------------------

Sonic_DynTiles:
		moveq	#0,d0
		move.b	$1A(a0),d0
		cmp.b	(unk_FFF766).w,d0
		beq.s	locret_F744
		move.b	d0,(unk_FFF766).w
		lea	(DynMapSonic).l,a2
		add.w	d0,d0
		adda.w	(a2,d0.w),a2
		moveq	#0,d1
		move.b	(a2)+,d1
		subq.b	#1,d1
		bmi.s	locret_F744
		lea	(v_sgfx_buffer).w,a3
		move.b	#1,(f_sonframechg).w

Sonic_DynReadEntry:
		moveq	#0,d2
		move.b	(a2)+,d2
		move.w	d2,d0
		lsr.b	#4,d0
		lsl.w	#8,d2
		move.b	(a2)+,d2
		lsl.w	#5,d2
		lea	(ArtSonic).l,a1
		adda.l	d2,a1

loc_F730:
		movem.l	(a1)+,d2-d6/a4-a6
		movem.l	d2-d6/a4-a6,(a3)
		lea	$20(a3),a3
		dbf	d0,loc_F730

loc_F740:
		dbf	d1,Sonic_DynReadEntry

locret_F744:
		rts

                include "_incObj\38 Shield and Invincibility.asm"

                include "_incObj\4A Giant Ring.asm"

		include "_anim\Shield.asm"
		include "_maps\Shield.asm"
		even
		include "levels\shared\SpecialRing\Sprite.ani"
		include "levels\shared\SpecialRing\Sprite.map"
		even
; ---------------------------------------------------------------------------

TouchObjects:
		nop
		moveq	#0,d5
		move.b	$16(a0),d5
		subq.b	#3,d5
		move.w	8(a0),d2
		move.w	$C(a0),d3
		subq.w	#8,d2
		sub.w	d5,d3
		move.w	#$10,d4
		add.w	d5,d5
		lea	(LevelObjectsList).w,a1
		move.w	#$5F,d6

loc_FB6E:
		tst.b	1(a1)
		bpl.s	loc_FB7A
		move.b	$20(a1),d0
		bne.s	loc_FBB8			; if nonzero, branch

	loc_FB7A:
		lea	$40(a1),a1			; next object RAM
		dbf	d6,loc_FB6E			; repeat $5F more times

		moveq	#0,d0
		rts
; ---------------------------------------------------------------------------
RTI_sizes:	;   width, height
		dc.b  $14, $14				; $01
		dc.b   $C, $14				; $02
		dc.b  $14,  $C				; $03
		dc.b	4, $10				; $04
		dc.b   $C, $12				; $05
		dc.b  $10, $10				; $06
		dc.b	6,   6				; $07
		dc.b  $18,  $C				; $08
		dc.b   $C, $10				; $09
		dc.b  $10,  $C				; $0A
		dc.b	8,   8				; $0B
		dc.b  $14, $10				; $0C
		dc.b  $14,   8				; $0D
		dc.b   $E,  $E				; $0E
		dc.b  $18, $18				; $0F
		dc.b  $28, $10				; $10
		dc.b  $10, $18				; $11
		dc.b   $C, $20				; $12
		dc.b  $20, $70				; $13
		dc.b  $40, $20				; $14
		dc.b  $80, $20				; $15
		dc.b  $20, $20				; $16
		dc.b	8,   8				; $17
		dc.b	4,   4				; $18
		dc.b  $20,   8				; $19
; ---------------------------------------------------------------------------

loc_FBB8:
		andi.w	#$3F,d0
		add.w	d0,d0
		lea	RTI_sizes-2(pc,d0.w),a2
		moveq	#0,d1
		move.b	(a2)+,d1
		move.w	8(a1),d0
		sub.w	d1,d0
		sub.w	d2,d0
		bcc.s	loc_FBD8
		add.w	d1,d1
		add.w	d1,d0
		bcs.s	loc_FBDC
		bra.s	loc_FB7A
; ---------------------------------------------------------------------------

loc_FBD8:
		cmp.w	d4,d0
		bhi.s	loc_FB7A

loc_FBDC:
		moveq	#0,d1
		move.b	(a2)+,d1
		move.w	$C(a1),d0
		sub.w	d1,d0
		sub.w	d3,d0
		bcc.s	loc_FBF2
		add.w	d1,d1
		add.w	d0,d1
		bcs.s	loc_FBF6
		bra.s	loc_FB7A
; ---------------------------------------------------------------------------

loc_FBF2:
		cmp.w	d5,d0
		bhi.s	loc_FB7A

loc_FBF6:
		move.b	$20(a1),d1
		andi.b	#$C0,d1
		beq.w	loc_FC6A
		cmpi.b	#$C0,d1
		beq.w	loc_FDC4
		tst.b	d1
		bmi.w	loc_FCE0
		move.b	$20(a1),d0
		andi.b	#$3F,d0
		cmpi.b	#6,d0
		beq.s	loc_FC2E
		cmpi.w	#$5A,$30(a0)
		bcc.w	locret_FC2C
		addq.b	#2,$24(a1)

locret_FC2C:
		rts
; ---------------------------------------------------------------------------

loc_FC2E:
		tst.w	$12(a0)
		bpl.s	loc_FC58
		move.w	$C(a0),d0
		subi.w	#$10,d0
		cmp.w	$C(a1),d0
		bcs.s	locret_FC68
		neg.w	$12(a0)
		move.w	#$FE80,$12(a1)
		tst.b	$25(a1)
		bne.s	locret_FC68
		addq.b	#4,$25(a1)
		rts
; ---------------------------------------------------------------------------

loc_FC58:
		cmpi.b	#2,$1C(a0)
		bne.s	locret_FC68
		neg.w	$12(a0)
		addq.b	#2,$24(a1)

locret_FC68:
		rts
; ---------------------------------------------------------------------------

loc_FC6A:
		tst.b	(v_invinc).w
		bne.s	loc_FC78
		cmpi.b	#2,$1C(a0)
		bne.s	loc_FCE0

loc_FC78:
		tst.b	$21(a1)
		beq.s	loc_FCA2
		neg.w	$10(a0)
		neg.w	$12(a0)
		asr	$10(a0)
		asr	$12(a0)
		move.b	#0,$20(a1)
		subq.b	#1,$21(a1)
		bne.s	locret_FCA0
		bset	#7,$22(a1)

locret_FCA0:
		rts
; ---------------------------------------------------------------------------

loc_FCA2:
		bset	#7,$22(a1)
		moveq	#$A,d0
		bsr.w	ScoreAdd
		move.b	#$27,0(a1)
		move.b	#0,$24(a1)
		tst.w	$12(a0)
		bmi.s	loc_FCD0
		move.w	$C(a0),d0
		cmp.w	$C(a1),d0
		bcc.s	loc_FCD8
		neg.w	$12(a0)
		rts
; ---------------------------------------------------------------------------

loc_FCD0:
		addi.w	#$100,$12(a0)
		rts
; ---------------------------------------------------------------------------

loc_FCD8:
		subi.w	#$100,$12(a0)
		rts
; ---------------------------------------------------------------------------

loc_FCE0:
		tst.b	(v_invinc).w
		beq.s	loc_FCEA

loc_FCE6:
		moveq	#-1,d0
		rts
; ---------------------------------------------------------------------------

loc_FCEA:
		nop
		tst.w	$30(a0)
		bne.s	loc_FCE6
		movea.l	a1,a2

loc_FCF4:
		tst.b	(v_shield).w
		bne.s	loc_FD18
		tst.w	(v_rings).w
		beq.s	loc_FD72
		bsr.w	ObjectLoad
		bne.s	loc_FD18
		move.b	#$37,0(a1)
		move.w	8(a0),8(a1)
		move.w	$C(a0),$C(a1)

loc_FD18:
		move.b	#0,(v_shield).w
		move.b	#4,$24(a0)
		bsr.w	Sonic_ResetOnFloor
		bset	#1,$22(a0)
		move.w	#$FC00,$12(a0)
		move.w	#$FE00,$10(a0)
		move.w	8(a0),d0
		cmp.w	8(a2),d0
		bcs.s	loc_FD48
		neg.w	$10(a0)

loc_FD48:
		move.w	#0,$14(a0)
		move.b	#$1A,$1C(a0)
		move.w	#$258,$30(a0)
		move.w	#sfx_Death,d0
		cmpi.b	#$36,(a2)
		bne.s	loc_FD68
		move.w	#sfx_HitSpikes,d0

loc_FD68:
		jsr	(PlaySFX).l
		moveq	#-1,d0
		rts
; ---------------------------------------------------------------------------

loc_FD72:
		tst.w	(f_debugmode).w
		bne.s	loc_FD18

loc_FD78:
		tst.w	(DebugRoutine).w
		bne.s	loc_FDC0
		move.b	#6,$24(a0)
		bsr.w	Sonic_ResetOnFloor
		bset	#1,$22(a0)
		move.w	#$F900,$12(a0)
		move.w	#0,$10(a0)
		move.w	#0,$14(a0)
		move.w	$C(a0),$38(a0)
		move.b	#$18,$1C(a0)
		move.w	#sfx_Death,d0
		cmpi.b	#$36,(a2)
		bne.s	loc_FDBA
		move.w	#sfx_HitSpikes,d0

loc_FDBA:
		jsr	(PlaySFX).l

loc_FDC0:
		moveq	#-1,d0
		rts
; ---------------------------------------------------------------------------

loc_FDC4:
		move.b	$20(a1),d1
		andi.b	#$3F,d1
		cmpi.b	#$C,d1
		beq.s	loc_FDDA
		cmpi.b	#$17,d1
		beq.s	loc_FE0C
		rts
; ---------------------------------------------------------------------------

loc_FDDA:
		sub.w	d0,d5
		cmpi.w	#8,d5
		bcc.s	loc_FE08
		move.w	8(a1),d0
		subq.w	#4,d0
		btst	#0,$22(a1)
		beq.s	loc_FDF4
		subi.w	#$10,d0

loc_FDF4:
		sub.w	d2,d0
		bcc.s	loc_FE00
		addi.w	#$18,d0
		bcs.s	loc_FE04
		bra.s	loc_FE08
; ---------------------------------------------------------------------------

loc_FE00:
		cmp.w	d4,d0
		bhi.s	loc_FE08

loc_FE04:
		bra.w	loc_FCE0
; ---------------------------------------------------------------------------

loc_FE08:
		bra.w	loc_FC6A
; ---------------------------------------------------------------------------

loc_FE0C:
		addq.b	#1,$21(a1)
		rts
; ---------------------------------------------------------------------------

Sonic_AnglePosition:
		btst	#3,$22(a0)
		beq.s	loc_FE26
		moveq	#0,d0
		move.b	d0,(unk_FFF768).w
		move.b	d0,(unk_FFF76A).w
		rts
; ---------------------------------------------------------------------------

loc_FE26:
		moveq	#3,d0
		move.b	d0,(unk_FFF768).w
		move.b	d0,(unk_FFF76A).w
		move.b	$26(a0),d0
		addi.b	#$20,d0
		andi.b	#$C0,d0
		cmpi.b	#$40,d0
		beq.w	Sonic_WalkVertL
		cmpi.b	#$80,d0
		beq.w	Sonic_WalkCeiling
		cmpi.b	#$C0,d0
		beq.w	Sonic_WalkVertR
		move.w	$C(a0),d2
		move.w	8(a0),d3
		moveq	#0,d0
		move.b	$16(a0),d0
		ext.w	d0
		add.w	d0,d2
		move.b	$17(a0),d0
		ext.w	d0
		add.w	d0,d3
		lea	(unk_FFF768).w,a4
		movea.w	#$10,a3
		move.w	#0,d6
		moveq	#$D,d5
		bsr.w	sub_101BE
		move.w	d1,-(sp)
		move.w	$C(a0),d2
		move.w	8(a0),d3
		moveq	#0,d0
		move.b	$16(a0),d0
		ext.w	d0
		add.w	d0,d2
		move.b	$17(a0),d0
		ext.w	d0
		neg.w	d0
		add.w	d0,d3
		lea	(unk_FFF76A).w,a4
		movea.w	#$10,a3
		move.w	#0,d6
		moveq	#$D,d5
		bsr.w	sub_101BE
		move.w	(sp)+,d0
		bsr.w	Sonic_Angle
		tst.w	d1
		beq.s	locret_FEC6
		bpl.s	loc_FEC8
		cmpi.w	#$FFF2,d1
		blt.s	locret_FEE8
		add.w	d1,$C(a0)

locret_FEC6:
		rts
; ---------------------------------------------------------------------------

loc_FEC8:
		cmpi.w	#$E,d1
		bgt.s	loc_FED4
		add.w	d1,$C(a0)
		rts
; ---------------------------------------------------------------------------

loc_FED4:
		bset	#1,$22(a0)
		bclr	#5,$22(a0)
		move.b	#1,$1D(a0)
		rts
; ---------------------------------------------------------------------------

locret_FEE8:
		rts
; ---------------------------------------------------------------------------
		move.l	8(a0),d2
		move.w	$10(a0),d0
		ext.l	d0
		asl.l	#8,d0
		sub.l	d0,d2
		move.l	d2,8(a0)
		move.w	#$38,d0
		ext.l	d0
		asl.l	#8,d0
		sub.l	d0,d3
		move.l	d3,$C(a0)
		rts
; ---------------------------------------------------------------------------

locret_FF0C:
		rts
; ---------------------------------------------------------------------------
		move.l	$C(a0),d3        
		move.w	$12(a0),d0
		subi.w	#$38,d0
		move.w	d0,$12(a0)
		ext.l	d0
		asl.l	#8,d0
		sub.l	d0,d3
		move.l	d3,$C(a0)
		rts
; ---------------------------------------------------------------------------
		rts
; ---------------------------------------------------------------------------

sub_FF2C:
		move.l	8(a0),d2
		move.l	$C(a0),d3
		move.w	$10(a0),d0
		ext.l	d0
		asl.l	#8,d0
		sub.l	d0,d2

loc_FF3E:
		move.w	$12(a0),d0
		ext.l	d0
		asl.l	#8,d0
		sub.l	d0,d3
		move.l	d2,8(a0)
		move.l	d3,$C(a0)
		rts
; ---------------------------------------------------------------------------

Sonic_Angle:
		move.b	(unk_FFF76A).w,d2
		cmp.w	d0,d1
		ble.s	loc_FF60
		move.b	(unk_FFF768).w,d2
		move.w	d0,d1

loc_FF60:
		btst	#0,d2

loc_FF64:
		bne.s	loc_FF6C
		move.b	d2,$26(a0)
		rts
; ---------------------------------------------------------------------------

loc_FF6C:
		move.b	$26(a0),d2
		addi.b	#$20,d2
		andi.b	#$C0,d2
		move.b	d2,$26(a0)
		rts
; ---------------------------------------------------------------------------

Sonic_WalkVertR:
		move.w	$C(a0),d2
		move.w	8(a0),d3
		moveq	#0,d0

loc_FF88:
		move.b	$17(a0),d0
		ext.w	d0
		neg.w	d0
		add.w	d0,d2
		move.b	$16(a0),d0
		ext.w	d0
		add.w	d0,d3
		lea	(unk_FFF768).w,a4
		movea.w	#$10,a3
		move.w	#0,d6
		moveq	#$D,d5
		bsr.w	FindFloor
		move.w	d1,-(sp)

loc_FFAE:
		move.w	$C(a0),d2
		move.w	8(a0),d3
		moveq	#0,d0
		move.b	$17(a0),d0
		ext.w	d0
		add.w	d0,d2
		move.b	$16(a0),d0
		ext.w	d0
		add.w	d0,d3
		lea	(unk_FFF76A).w,a4
		movea.w	#$10,a3
		move.w	#0,d6
		moveq	#$D,d5

loc_FFD6:
		bsr.w	FindFloor
		move.w	(sp)+,d0
		bsr.w	Sonic_Angle
		tst.w	d1
		beq.s	locret_FFF2
		bpl.s	loc_FFF4
		cmpi.w	#$FFF2,d1
		blt.w	locret_FF0C
		add.w	d1,8(a0)

locret_FFF2:
		rts
; ---------------------------------------------------------------------------

loc_FFF4:
		cmpi.w	#$E,d1
		bgt.s	loc_10000
		add.w	d1,8(a0)

locret_FFFE:
		rts
; ---------------------------------------------------------------------------

loc_10000:
		bset	#1,$22(a0)
		bclr	#5,$22(a0)
		move.b	#1,$1D(a0)
		rts
; ---------------------------------------------------------------------------

Sonic_WalkCeiling:
		move.w	$C(a0),d2
		move.w	8(a0),d3
		moveq	#0,d0
		move.b	$16(a0),d0
		ext.w	d0
		sub.w	d0,d2
		eori.w	#$F,d2
		move.b	$17(a0),d0
		ext.w	d0
		add.w	d0,d3
		lea	(unk_FFF768).w,a4
		movea.w	#$FFF0,a3
		move.w	#$1000,d6
		moveq	#$D,d5
		bsr.w	sub_101BE
		move.w	d1,-(sp)
		move.w	$C(a0),d2
		move.w	8(a0),d3
		moveq	#0,d0
		move.b	$16(a0),d0
		ext.w	d0
		sub.w	d0,d2
		eori.w	#$F,d2
		move.b	$17(a0),d0
		ext.w	d0
		sub.w	d0,d3
		lea	(unk_FFF76A).w,a4
		movea.w	#$FFF0,a3
		move.w	#$1000,d6
		moveq	#$D,d5
		bsr.w	sub_101BE
		move.w	(sp)+,d0
		bsr.w	Sonic_Angle
		tst.w	d1
		beq.s	locret_1008E
		bpl.s	loc_10090
		cmpi.w	#$FFF2,d1
		blt.w	locret_FEE8
		sub.w	d1,$C(a0)

locret_1008E:
		rts
; ---------------------------------------------------------------------------

loc_10090:
		cmpi.w	#$E,d1
		bgt.s	loc_1009C
		sub.w	d1,$C(a0)
		rts
; ---------------------------------------------------------------------------

loc_1009C:
		bset	#1,$22(a0)
		bclr	#5,$22(a0)
		move.b	#1,$1D(a0)
		rts
; ---------------------------------------------------------------------------

Sonic_WalkVertL:
		move.w	$C(a0),d2
		move.w	8(a0),d3
		moveq	#0,d0
		move.b	$17(a0),d0
		ext.w	d0
		sub.w	d0,d2
		move.b	$16(a0),d0
		ext.w	d0
		sub.w	d0,d3
		eori.w	#$F,d3
		lea	(unk_FFF768).w,a4
		movea.w	#$FFF0,a3
		move.w	#$800,d6
		moveq	#$D,d5
		bsr.w	FindFloor
		move.w	d1,-(sp)
		move.w	$C(a0),d2
		move.w	8(a0),d3
		moveq	#0,d0
		move.b	$17(a0),d0
		ext.w	d0
		add.w	d0,d2
		move.b	$16(a0),d0
		ext.w	d0
		sub.w	d0,d3
		eori.w	#$F,d3
		lea	(unk_FFF76A).w,a4
		movea.w	#$FFF0,a3
		move.w	#$800,d6
		moveq	#$D,d5
		bsr.w	FindFloor
		move.w	(sp)+,d0
		bsr.w	Sonic_Angle
		tst.w	d1
		beq.s	locret_1012A
		bpl.s	loc_1012C
		cmpi.w	#$FFF2,d1
		blt.w	locret_FF0C
		sub.w	d1,8(a0)

locret_1012A:
		rts
; ---------------------------------------------------------------------------

loc_1012C:
		cmpi.w	#$E,d1
		bgt.s	loc_10138
		sub.w	d1,8(a0)
		rts
; ---------------------------------------------------------------------------

loc_10138:
		bset	#1,$22(a0)
		bclr	#5,$22(a0)
		move.b	#1,$1D(a0)
		rts
; ---------------------------------------------------------------------------

Floor_ChkTile:
		move.w	d2,d0
		lsr.w	#1,d0
		andi.w	#$380,d0
		move.w	d3,d1
		lsr.w	#8,d1
		andi.w	#$7F,d1
		add.w	d1,d0
		moveq	#-1,d1
		lea	(v_lvllayout).w,a1
		move.b	(a1,d0.w),d1
		beq.s	loc_10186
		bmi.s	loc_1018A
		subq.b	#1,d1
		ext.w	d1
		ror.w	#7,d1
		move.w	d2,d0
		add.w	d0,d0
		andi.w	#$1E0,d0
		add.w	d0,d1
		move.w	d3,d0
		lsr.w	#3,d0
		andi.w	#$1E,d0
		add.w	d0,d1

loc_10186:
		movea.l	d1,a1
		rts
; ---------------------------------------------------------------------------

loc_1018A:
		andi.w	#$7F,d1
		btst	#6,render(a0)
		beq.s	loc_101A2
		addq.w	#1,d1
		cmpi.w	#$29,d1
		bne.s	loc_101A2
		move.w	#$51,d1

loc_101A2:
		subq.b	#1,d1
		ror.w	#7,d1
		move.w	d2,d0
		add.w	d0,d0
		andi.w	#$1E0,d0
		add.w	d0,d1
		move.w	d3,d0
		lsr.w	#3,d0
		andi.w	#$1E,d0
		add.w	d0,d1
		movea.l	d1,a1
		rts
; ---------------------------------------------------------------------------

sub_101BE:
		bsr.s	Floor_ChkTile
		move.w	(a1),d0
		move.w	d0,d4
		andi.w	#$7FF,d0
		beq.s	loc_101CE
		btst	d5,d4
		bne.s	loc_101DC

loc_101CE:
		add.w	a3,d2
		bsr.w	sub_10264
		sub.w	a3,d2
		addi.w	#$10,d1
		rts
; ---------------------------------------------------------------------------

loc_101DC:
		movea.l	(v_collindex).w,a2
		move.b	(a2,d0.w),d0
		andi.w	#$FF,d0
		beq.s	loc_101CE
		lea	(colAngles).l,a2
		move.b	(a2,d0.w),(a4)
		lsl.w	#4,d0
		move.w	d3,d1
		btst	#$B,d4
		beq.s	loc_10202
		not.w	d1
		neg.b	(a4)

loc_10202:
		btst	#$C,d4
		beq.s	loc_10212
		addi.b	#$40,(a4)
		neg.b	(a4)
		subi.b	#$40,(a4)

loc_10212:
		andi.w	#$F,d1
		add.w	d0,d1
		lea	(colWidth).l,a2
		move.b	(a2,d1.w),d0
		ext.w	d0
		eor.w	d6,d4
		btst	#$C,d4
		beq.s	loc_1022E
		neg.w	d0

loc_1022E:
		tst.w	d0
		beq.s	loc_101CE
		bmi.s	loc_1024A
		cmpi.b	#$10,d0
		beq.s	loc_10256
		move.w	d2,d1
		andi.w	#$F,d1
		add.w	d1,d0
		move.w	#$F,d1
		sub.w	d0,d1
		rts
; ---------------------------------------------------------------------------

loc_1024A:
		move.w	d2,d1
		andi.w	#$F,d1
		add.w	d1,d0
		bpl.w	loc_101CE

loc_10256:
		sub.w	a3,d2
		bsr.w	sub_10264
		add.w	a3,d2
		subi.w	#$10,d1
		rts
; ---------------------------------------------------------------------------

sub_10264:
		bsr.w	Floor_ChkTile
		move.w	(a1),d0
		move.w	d0,d4
		andi.w	#$7FF,d0
		beq.s	loc_10276
		btst	d5,d4
		bne.s	loc_10284

loc_10276:
		move.w	#$F,d1
		move.w	d2,d0
		andi.w	#$F,d0
		sub.w	d0,d1
		rts
; ---------------------------------------------------------------------------

loc_10284:
		movea.l	(v_collindex).w,a2
		move.b	(a2,d0.w),d0
		andi.w	#$FF,d0
		beq.s	loc_10276
		lea	(colAngles).l,a2
		move.b	(a2,d0.w),(a4)
		lsl.w	#4,d0
		move.w	d3,d1
		btst	#$B,d4
		beq.s	loc_102AA
		not.w	d1
		neg.b	(a4)

loc_102AA:
		btst	#$C,d4
		beq.s	loc_102BA
		addi.b	#$40,(a4)
		neg.b	(a4)
		subi.b	#$40,(a4)

loc_102BA:
		andi.w	#$F,d1
		add.w	d0,d1
		lea	(colWidth).l,a2
		move.b	(a2,d1.w),d0
		ext.w	d0
		eor.w	d6,d4
		btst	#$C,d4
		beq.s	loc_102D6
		neg.w	d0

loc_102D6:
		tst.w	d0
		beq.s	loc_10276
		bmi.s	loc_102EC
		move.w	d2,d1
		andi.w	#$F,d1
		add.w	d1,d0
		move.w	#$F,d1
		sub.w	d0,d1
		rts
; ---------------------------------------------------------------------------

loc_102EC:
		move.w	d2,d1
		andi.w	#$F,d1
		add.w	d1,d0
		bpl.w	loc_10276
		not.w	d1
		rts
; ---------------------------------------------------------------------------

FindFloor:
		bsr.w	Floor_ChkTile
		move.w	(a1),d0
		move.w	d0,d4
		andi.w	#$7FF,d0
		beq.s	loc_1030E
		btst	d5,d4
		bne.s	loc_1031C

loc_1030E:
		add.w	a3,d3
		bsr.w	FindFloor2
		sub.w	a3,d3
		addi.w	#$10,d1
		rts
; ---------------------------------------------------------------------------

loc_1031C:
		movea.l	(v_collindex).w,a2
		move.b	(a2,d0.w),d0
		andi.w	#$FF,d0
		beq.s	loc_1030E
		lea	(colAngles).l,a2
		move.b	(a2,d0.w),(a4)
		lsl.w	#4,d0
		move.w	d2,d1
		btst	#$C,d4
		beq.s	loc_1034A
		not.w	d1
		addi.b	#$40,(a4)
		neg.b	(a4)
		subi.b	#$40,(a4)

loc_1034A:
		btst	#$B,d4
		beq.s	loc_10352
		neg.b	(a4)

loc_10352:
		andi.w	#$F,d1
		add.w	d0,d1
		lea	(colHeight).l,a2
		move.b	(a2,d1.w),d0
		ext.w	d0
		eor.w	d6,d4
		btst	#$B,d4
		beq.s	loc_1036E
		neg.w	d0

loc_1036E:
		tst.w	d0
		beq.s	loc_1030E
		bmi.s	loc_1038A
		cmpi.b	#$10,d0
		beq.s	loc_10396
		move.w	d3,d1
		andi.w	#$F,d1
		add.w	d1,d0
		move.w	#$F,d1
		sub.w	d0,d1
		rts
; ---------------------------------------------------------------------------

loc_1038A:
		move.w	d3,d1
		andi.w	#$F,d1
		add.w	d1,d0
		bpl.w	loc_1030E

loc_10396:
		sub.w	a3,d3
		bsr.w	FindFloor2
		add.w	a3,d3
		subi.w	#$10,d1
		rts
; ---------------------------------------------------------------------------

FindFloor2:
		bsr.w	Floor_ChkTile
		move.w	(a1),d0
		move.w	d0,d4
		andi.w	#$7FF,d0
		beq.s	loc_103B6
		btst	d5,d4
		bne.s	loc_103C4

loc_103B6:
		move.w	#$F,d1
		move.w	d3,d0
		andi.w	#$F,d0
		sub.w	d0,d1
		rts
; ---------------------------------------------------------------------------

loc_103C4:
		movea.l	(v_collindex).w,a2
		move.b	(a2,d0.w),d0
		andi.w	#$FF,d0
		beq.s	loc_103B6
		lea	(colAngles).l,a2
		move.b	(a2,d0.w),(a4)
		lsl.w	#4,d0
		move.w	d2,d1
		btst	#$C,d4
		beq.s	loc_103F2
		not.w	d1
		addi.b	#$40,(a4)
		neg.b	(a4)
		subi.b	#$40,(a4)

loc_103F2:
		btst	#$B,d4
		beq.s	loc_103FA
		neg.b	(a4)

loc_103FA:
		andi.w	#$F,d1
		add.w	d0,d1
		lea	(colHeight).l,a2
		move.b	(a2,d1.w),d0
		ext.w	d0
		eor.w	d6,d4
		btst	#$B,d4
		beq.s	loc_10416
		neg.w	d0

loc_10416:
		tst.w	d0
		beq.s	loc_103B6
		bmi.s	loc_1042C
		move.w	d3,d1
		andi.w	#$F,d1
		add.w	d1,d0
		move.w	#$F,d1
		sub.w	d0,d1
		rts
; ---------------------------------------------------------------------------

loc_1042C:
		move.w	d3,d1
		andi.w	#$F,d1
		add.w	d1,d0
		bpl.w	loc_103B6
		not.w	d1
		rts
; ---------------------------------------------------------------------------

LogCollision:
		rts
; ---------------------------------------------------------------------------
		lea	(colWidth).l,a1			; Logs the Collision.
		lea	(colWidth).l,a2
		move.w	#$FF,d3

loc_1044E:
		moveq	#$10,d5
		move.w	#$F,d2

loc_10454:
		moveq	#0,d4
		move.w	#$F,d1

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
		move.w	#$F,d1
		move.w	(a1)+,d0
		beq.s	loc_104C4
		bmi.s	loc_104AE

loc_104A2:
		lsr.w	#1,d0
		bcc.s	loc_104A8
		addq.b	#1,d2

loc_104A8:
		dbf	d1,loc_104A2
		bra.s	loc_104C6
; ---------------------------------------------------------------------------

loc_104AE:
		cmpi.w	#$FFFF,d0
		beq.s	loc_104C0

loc_104B4:
		lsl.w	#1,d0
		bcc.s	loc_104BA
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
		move.l	8(a0),d3
		move.l	$C(a0),d2
		move.w	$10(a0),d1
		ext.l	d1
		asl.l	#8,d1
		add.l	d1,d3
		move.w	$12(a0),d1
		ext.l	d1
		asl.l	#8,d1
		add.l	d1,d2
		swap	d2
		swap	d3
		move.b	d0,(unk_FFF768).w
		move.b	d0,(unk_FFF76A).w
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
		move.b	d0,(unk_FFF768).w
		move.b	d0,(unk_FFF76A).w
		addi.b	#$20,d0
		andi.b	#$C0,d0
		cmpi.b	#$40,d0
		beq.w	loc_107AE
		cmpi.b	#$80,d0
		beq.w	Sonic_NoRunningOnWalls
		cmpi.b	#$C0,d0
		beq.w	loc_10628

Sonic_HitFloor:
		move.w	$C(a0),d2
		move.w	8(a0),d3
		moveq	#0,d0
		move.b	$16(a0),d0
		ext.w	d0
		add.w	d0,d2
		move.b	$17(a0),d0
		ext.w	d0
		add.w	d0,d3
		lea	(unk_FFF768).w,a4
		movea.w	#$10,a3
		move.w	#0,d6
		moveq	#$D,d5
		bsr.w	sub_101BE
		move.w	d1,-(sp)
		move.w	$C(a0),d2
		move.w	8(a0),d3
		moveq	#0,d0
		move.b	$16(a0),d0
		ext.w	d0
		add.w	d0,d2
		move.b	$17(a0),d0
		ext.w	d0
		sub.w	d0,d3
		lea	(unk_FFF76A).w,a4
		movea.w	#$10,a3
		move.w	#0,d6
		moveq	#$D,d5
		bsr.w	sub_101BE
		move.w	(sp)+,d0
		move.b	#0,d2

loc_105A8:
		move.b	(unk_FFF76A).w,d3
		cmp.w	d0,d1
		ble.s	loc_105B6
		move.b	(unk_FFF768).w,d3
		move.w	d0,d1

loc_105B6:
		btst	#0,d3
		beq.s	locret_105BE
		move.b	d2,d3

locret_105BE:
		rts
; ---------------------------------------------------------------------------
		move.w	$C(a0),d2             
		move.w	8(a0),d3

loc_105C8:
		addi.w	#$A,d2
		lea	(unk_FFF768).w,a4
		movea.w	#$10,a3
		move.w	#0,d6
		moveq	#$E,d5
		bsr.w	sub_101BE
		move.b	#0,d2

loc_105E2:
		move.b	(unk_FFF768).w,d3
		btst	#0,d3
		beq.s	locret_105EE
		move.b	d2,d3

locret_105EE:
		rts
; ---------------------------------------------------------------------------

ObjectHitFloor:
		move.w	8(a0),d3

ObjectHitFloor2:
		move.w	$C(a0),d2
		moveq	#0,d0
		move.b	$16(a0),d0
		ext.w	d0
		add.w	d0,d2
		lea	(unk_FFF768).w,a4
		move.b	#0,(a4)
		movea.w	#$10,a3
		move.w	#0,d6
		moveq	#$D,d5
		bsr.w	sub_101BE
		move.b	(unk_FFF768).w,d3
		btst	#0,d3
		beq.s	locret_10626
		move.b	#0,d3

locret_10626:
		rts
; ---------------------------------------------------------------------------

loc_10628:
		move.w	$C(a0),d2
		move.w	8(a0),d3
		moveq	#0,d0
		move.b	$17(a0),d0
		ext.w	d0
		sub.w	d0,d2
		move.b	$16(a0),d0
		ext.w	d0
		add.w	d0,d3
		lea	(unk_FFF768).w,a4
		movea.w	#$10,a3
		move.w	#0,d6
		moveq	#$E,d5
		bsr.w	FindFloor
		move.w	d1,-(sp)
		move.w	$C(a0),d2
		move.w	8(a0),d3
		moveq	#0,d0
		move.b	$17(a0),d0
		ext.w	d0
		add.w	d0,d2
		move.b	$16(a0),d0
		ext.w	d0
		add.w	d0,d3
		lea	(unk_FFF76A).w,a4
		movea.w	#$10,a3
		move.w	#0,d6
		moveq	#$E,d5
		bsr.w	FindFloor
		move.w	(sp)+,d0
		move.b	#$C0,d2
		bra.w	loc_105A8
; ---------------------------------------------------------------------------

sub_1068C:
		move.w	$C(a0),d2
		move.w	8(a0),d3

loc_10694:
		addi.w	#$A,d3
		lea	(unk_FFF768).w,a4
		movea.w	#$10,a3
		move.w	#0,d6
		moveq	#$E,d5
		bsr.w	FindFloor
		move.b	#$C0,d2
		bra.w	loc_105E2
; ---------------------------------------------------------------------------

ObjectHitWallRight:
		add.w	8(a0),d3
		move.w	$C(a0),d2
		lea	(unk_FFF768).w,a4
		move.b	#0,(a4)
		movea.w	#$10,a3
		move.w	#0,d6
		moveq	#$E,d5
		bsr.w	FindFloor
		move.b	(unk_FFF768).w,d3
		btst	#0,d3
		beq.s	locret_106DE
		move.b	#$C0,d3

locret_106DE:
		rts
; ---------------------------------------------------------------------------

Sonic_NoRunningOnWalls:
		move.w	$C(a0),d2
		move.w	8(a0),d3
		moveq	#0,d0
		move.b	$16(a0),d0
		ext.w	d0
		sub.w	d0,d2
		eori.w	#$F,d2
		move.b	$17(a0),d0
		ext.w	d0
		add.w	d0,d3
		lea	(unk_FFF768).w,a4
		movea.w	#$FFF0,a3
		move.w	#$1000,d6
		moveq	#$E,d5
		bsr.w	sub_101BE
		move.w	d1,-(sp)
		move.w	$C(a0),d2
		move.w	8(a0),d3
		moveq	#0,d0
		move.b	$16(a0),d0
		ext.w	d0
		sub.w	d0,d2
		eori.w	#$F,d2
		move.b	$17(a0),d0
		ext.w	d0
		sub.w	d0,d3
		lea	(unk_FFF76A).w,a4
		movea.w	#$FFF0,a3
		move.w	#$1000,d6
		moveq	#$E,d5
		bsr.w	sub_101BE
		move.w	(sp)+,d0
		move.b	#$80,d2
		bra.w	loc_105A8
; ---------------------------------------------------------------------------
		move.w	$C(a0),d2
		move.w	8(a0),d3

loc_10754:
		subi.w	#$A,d2
		eori.w	#$F,d2
		lea	(unk_FFF768).w,a4
		movea.w	#$FFF0,a3
		move.w	#$1000,d6
		moveq	#$E,d5
		bsr.w	sub_101BE
		move.b	#$80,d2
		bra.w	loc_105E2
; ---------------------------------------------------------------------------

ObjectHitCeiling:
		move.w	$C(a0),d2
		move.w	8(a0),d3
		moveq	#0,d0
		move.b	$16(a0),d0
		ext.w	d0
		sub.w	d0,d2
		eori.w	#$F,d2
		lea	(unk_FFF768).w,a4
		movea.w	#$FFF0,a3
		move.w	#$1000,d6
		moveq	#$E,d5
		bsr.w	sub_101BE
		move.b	(unk_FFF768).w,d3
		btst	#0,d3
		beq.s	locret_107AC
		move.b	#$80,d3

locret_107AC:
		rts
; ---------------------------------------------------------------------------

loc_107AE:
		move.w	$C(a0),d2
		move.w	8(a0),d3
		moveq	#0,d0
		move.b	$17(a0),d0
		ext.w	d0
		sub.w	d0,d2
		move.b	$16(a0),d0
		ext.w	d0
		sub.w	d0,d3
		eori.w	#$F,d3
		lea	(unk_FFF768).w,a4
		movea.w	#$FFF0,a3
		move.w	#$800,d6
		moveq	#$E,d5
		bsr.w	FindFloor
		move.w	d1,-(sp)
		move.w	$C(a0),d2
		move.w	8(a0),d3
		moveq	#0,d0
		move.b	$17(a0),d0
		ext.w	d0
		add.w	d0,d2
		move.b	$16(a0),d0
		ext.w	d0
		sub.w	d0,d3
		eori.w	#$F,d3
		lea	(unk_FFF76A).w,a4
		movea.w	#$FFF0,a3
		move.w	#$800,d6
		moveq	#$E,d5
		bsr.w	FindFloor
		move.w	(sp)+,d0
		move.b	#$40,d2
		bra.w	loc_105A8
; ---------------------------------------------------------------------------

Sonic_HitWall:
		move.w	$C(a0),d2
		move.w	8(a0),d3

loc_10822:
		subi.w	#$A,d3
		eori.w	#$F,d3
		lea	(unk_FFF768).w,a4
		movea.w	#$FFF0,a3
		move.w	#$800,d6
		moveq	#$E,d5
		bsr.w	FindFloor
		move.b	#$40,d2
		bra.w	loc_105E2
; ---------------------------------------------------------------------------

ObjectHitWallLeft:
		add.w	8(a0),d3
		move.w	$C(a0),d2
		lea	(unk_FFF768).w,a4
		move.b	#0,(a4)
		movea.w	#$FFF0,a3
		move.w	#$800,d6
		moveq	#$E,d5
		bsr.w	FindFloor
		move.b	(unk_FFF768).w,d3
		btst	#0,d3
		beq.s	locret_10870
		move.b	#$40,d3

locret_10870:
		rts
; ---------------------------------------------------------------------------

GM_Special_ShowLayout:
		bsr.w	GM_Special_AniWallsandRings
		bsr.w	GM_Special_AniItems
		move.w	d5,-(sp)
		lea	($FFFF8000).w,a1
		move.b	(unk_FFF780).w,d0
		andi.b	#$FC,d0
		jsr	(GetSine).l
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
		move.w	#$F,d7

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
		move.w	#$F,d6

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
		lea	($FF0000).l,a0
		moveq	#0,d0
		move.w	(v_screenposy).w,d0
		divu.w	#$18,d0
		mulu.w	#$80,d0
		adda.l	d0,a0
		moveq	#0,d0
		move.w	(v_screenposx).w,d0
		divu.w	#$18,d0
		adda.w	d0,a0
		lea	($FFFF8000).w,a4
		move.w	#$F,d7

loc_10930:
		move.w	#$F,d6

loc_10934:
		moveq	#0,d0
		move.b	(a0)+,d0
		beq.s	loc_10986
		move.w	(a4),d3
		addi.w	#$120,d3
		cmpi.w	#$70,d3
		bcs.s	loc_10986
		cmpi.w	#$1D0,d3
		bcc.s	loc_10986
		move.w	2(a4),d2
		addi.w	#$F0,d2
		cmpi.w	#$70,d2
		bcs.s	loc_10986
		cmpi.w	#$170,d2
		bcc.s	loc_10986
		lea	($FF4000).l,a5
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
		jsr	sub_88AA

loc_10986:
		addq.w	#4,a4
		dbf	d6,loc_10934

		lea	$70(a0),a0
		dbf	d7,loc_10930

		move.b	d5,(byte_FFF62C).w
		cmpi.b	#$50,d5
		beq.s	loc_109A6
		move.l	#0,(a2)
		rts
; ---------------------------------------------------------------------------

loc_109A6:
		move.b	#0,-5(a2)
		rts
; ---------------------------------------------------------------------------

GM_Special_AniWallsandRings:
		lea	($FF400C).l,a1
		moveq	#0,d0
		move.b	(unk_FFF780).w,d0
		lsr.b	#2,d0
		andi.w	#$F,d0
		moveq	#$F,d1

loc_109C2:
		move.w	d0,(a1)
		addq.w	#8,a1
		dbf	d1,loc_109C2

		subq.b	#1,(RingTimer).w
		bpl.s	loc_109E0
		move.b	#7,(RingTimer).w
		addq.b	#1,(RingFrame).w
		andi.b	#3,(RingFrame).w

loc_109E0:
		move.b	(RingFrame).w,1(a1)
		addq.w	#8,a1
		addq.w	#8,a1
		subq.b	#1,(unk_FFFEC4).w
		bpl.s	loc_10A02
		move.b	#7,(unk_FFFEC4).w
		bra.s	loc_10A02
; ---------------------------------------------------------------------------
		addq.b	#1,(unk_FFFEC5).w
		andi.b	#1,(unk_FFFEC5).w

loc_10A02:
		move.b	(unk_FFFEC5).w,1(a1)
		addq.w	#8,a1
		move.b	(unk_FFFEC5).w,1(a1)
		subq.b	#1,(unk_FFFEC0).w
		bpl.s	loc_10A26
		move.b	#7,(unk_FFFEC0).w
		subq.b	#1,(unk_FFFEC1).w
		andi.b	#3,(unk_FFFEC1).w

loc_10A26:
		lea	($FF402E).l,a1
		lea	(Special_VRAMSet).l,a0
		moveq	#0,d0
		move.b	(unk_FFFEC1).w,d0
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

Special_VRAMSet:dc.w $142, $142, $142, $2142
		dc.w $142, $142, $142, $142
		dc.w $2142, $2142, $2142, $142
		dc.w $2142, $2142, $2142, $2142
		dc.w $4142, $4142, $4142, $2142
		dc.w $4142, $4142, $4142, $4142
		dc.w $6142, $6142, $6142, $2142
		dc.w $6142, $6142, $6142, $6142
; ---------------------------------------------------------------------------

sub_10ACC:
		lea	($FF4400).l,a2
		move.w	#$1F,d0

loc_10AD6:
		tst.b	(a2)
		beq.s	locret_10AE0
		addq.w	#8,a2
		dbf	d0,loc_10AD6

locret_10AE0:
		rts
; ---------------------------------------------------------------------------

GM_Special_AniItems:
		lea	($FF4400).l,a0
		move.w	#$1F,d7

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
; ---------------------------------------------------------------------------

SS_Load:
		lea	($FF0000).l,a1
		move.w	#$FFF,d0

loc_10B7A:
		clr.l	(a1)+
		dbf	d0,loc_10B7A

		lea	($FF172E).l,a1
		lea	(SS_1).l,a0
		moveq	#$23,d1

loc_10B8E:
		moveq	#8,d2

loc_10B90:
		move.l	(a0)+,(a1)+
		dbf	d2,loc_10B90

		lea	$5C(a1),a1
		dbf	d1,loc_10B8E

		lea	($FF4008).l,a1
		lea	(SS_MapIndex).l,a0
		moveq	#$1B,d1

loc_10BAC:
		move.l	(a0)+,(a1)+
		move.w	#0,(a1)+
		move.b	-4(a0),-1(a1)
		move.w	(a0)+,(a1)+
		dbf	d1,loc_10BAC

		lea	($FF4400).l,a1
		move.w	#$3F,d1

loc_10BC8:

		clr.l	(a1)+
		dbf	d1,loc_10BC8

		rts
; ---------------------------------------------------------------------------

                include "_inc\Special Stage Mappings & VRAM Pointers.asm"

		lea	($FF1020).l,a1
		lea	(SS_1).l,a0
		moveq	#$3F,d1

loc_10CA6:
		moveq	#$F,d2

loc_10CA8:
		move.l	(a0)+,(a1)+
		dbf	d2,loc_10CA8
		lea	$40(a1),a1
		dbf	d1,loc_10CA6
		rts

                include "_incObj\09 Sonic in Special Stage.asm"
                include "_incObj\10 Sonic Animation Test.asm"

		include "_inc\AnimateLevelGfx.asm"

                include "_incObj\21 HUD.asm"
		include "levels\shared\HUD\Sprite.map"
; ---------------------------------------------------------------------------

ScoreAdd:
		move.b	#1,(byte_FFFE1F).w
		lea	(unk_FFFE50).w,a2
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

UpdateHUD:
		tst.w	(f_debugmode).w
		bne.w	loc_11746
		tst.b	(byte_FFFE1F).w
		beq.s	loc_1169A
		clr.b	(byte_FFFE1F).w
		move.l	#$5C800003,d0
		move.l	(v_score).w,d1
		bsr.w	sub_1187E

loc_1169A:
		tst.b	(f_extralife).w
		beq.s	loc_116BA
		bpl.s	loc_116A6
		bsr.w	sub_117B2

loc_116A6:
		clr.b	(f_extralife).w
		move.l	#$5F400003,d0
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
		move.l	#$5E400003,d0
		moveq	#0,d1
		move.b	(v_time+1).w,d1
		bsr.w	sub_118F4
		move.l	#$5EC00003,d0
		moveq	#0,d1
		move.b	(v_time+2).w,d1
		bsr.w	sub_118FE

loc_1170E:
		tst.b	(byte_FFFE1C).w
		beq.s	loc_1171C
		clr.b	(byte_FFFE1C).w
		bsr.w	sub_119BA

loc_1171C:
		tst.b	(byte_FFFE58).w
		beq.s	locret_11744
		clr.b	(byte_FFFE58).w
		move.l	#$6E000002,(vdp_control_port).l
		moveq	#0,d1
		move.w	(word_FFFE54).w,d1
		bsr.w	sub_11958
		moveq	#0,d1
		move.w	(word_FFFE56).w,d1
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
		move.l	#$5F400003,d0
		moveq	#0,d1
		move.w	(v_rings).w,d1
		bsr.w	sub_11874

loc_1176A:
		move.l	#$5EC00003,d0
		moveq	#0,d1
		move.b	(byte_FFF62C).w,d1
		bsr.w	sub_118FE
		tst.b	(byte_FFFE1C).w
		beq.s	loc_11788
		clr.b	(byte_FFFE1C).w
		bsr.w	sub_119BA

loc_11788:
		tst.b	(byte_FFFE58).w
		beq.s	locret_117B0
		clr.b	(byte_FFFE58).w
		move.l	#$6E000002,(vdp_control_port).l
		moveq	#0,d1
		move.w	(word_FFFE54).w,d1
		bsr.w	sub_11958
		moveq	#0,d1
		move.w	(word_FFFE56).w,d1
		bsr.w	sub_11958

locret_117B0:
		rts
; ---------------------------------------------------------------------------

sub_117B2:
		move.l	#$5F400003,(vdp_control_port).l
		lea	byte_1181A(pc),a2
		move.w	#2,d2
		bra.s	loc_117E2
; ---------------------------------------------------------------------------

sub_117C6:
		lea	(vdp_data_port).l,a6
		bsr.w	sub_119BA
		move.l	#$5C400003,(vdp_control_port).l
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

byte_1181A:	dc.b $FF, $FF, 0, 0
; ---------------------------------------------------------------------------

sub_1181E:
		move.l	#$5C400003,(vdp_control_port).l
		move.w	(v_screenposx).w,d1
		swap	d1
		move.w	(v_objspace+8).w,d1
		bsr.s	sub_1183E
		move.w	(v_screenposy).w,d1
		swap	d1
		move.w	(v_objspace+$C).w,d1
; ---------------------------------------------------------------------------

sub_1183E:
		moveq	#7,d6
		lea	(ArtText).l,a1

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
Hud_10:	        dc.l 10
Hud_1:	        dc.l 1
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
		move.l	#$7BA00003,d0
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

byte_11A26:	incbin "artunc\HUD Numbers.bin"
                even
byte_11D26:	incbin "artunc\Lives Counter Numbers.bin"
                even

                include "_incObj\DebugMode.asm"
		include "_inc\DebugList.asm"
		include "_inc\LevelHeaders.asm"
		include "_inc\Pattern Load Cues.asm"

		align $8000,$FF				; Padding
; ===========================================================================
; Unused 8x8 Font Art
; ===========================================================================
byte_18000:	incbin "leftovers\0x18000.bin"		; Some similar art to this is used in other prototypes, such as Sonic 2 Nick Arcade
		even
; ===========================================================================
; Sega Screen\Title Screen Art and Mappings
; ===========================================================================
Nem_SegaLogo:	incbin "artnem\Sega Logo.bin"
		even
Eni_SegaLogo:	incbin "tilemaps\Sega Logo.bin"
		even
Unc_Title:	incbin "tilemaps\Title Screen.bin"
		even
Nem_TitleFg:	incbin "artnem\Title Screen Foreground.bin"
		even
Nem_TitleSonic:	incbin "artnem\Title Screen Sonic.bin"
		even
		include "_maps\Sonic.asm"
		include "_maps\Sonic - Dynamic Gfx Script.asm"

ArtSonic:	incbin "artunc\Sonic.bin"
		even
; ===========================================================================
; Nemesis Art
; ===========================================================================
ArtSmoke:	incbin "artnem\Smoke.bin"		; Although this never gets used, it's loaded first in the VRAM at $F400
		even
ArtShield:	incbin "artnem\Shield.bin"
		even
ArtInvinStars:	incbin "artnem\Stars.bin"
		even
ArtFlash:	incbin "artnem\Flash.bin"
		even
byte_26E90:	incbin "artnem\Unused - Goggles.bin"
	        even

                align $400,$FF				; Padding

byte_27400:	incbin "artnem\ghz flower stalk.nem"
		even
byte_2744A:	incbin "artnem\ghz swing.nem"
		even
ArtBridge:	incbin "levels\GHZ\Bridge\Art.nem"
		even
byte_27698:	incbin "artnem\ghz checkered ball.nem"
		even
ArtSpikes:	incbin "levels\shared\Spikes\Art.nem"
		even
ArtSpikeLogs:	incbin "levels\GHZ\SpikeLogs\Art.nem"
		even
ArtPurpleRock:	incbin "levels\GHZ\PurpleRock\Art.nem"
		even
ArtSmashWall:	incbin "levels\GHZ\SmashWall\Art.nem"
		even
ArtWall:	incbin "levels\GHZ\Wall\Art.nem"
		even
ArtChainPtfm:	incbin "levels\MZ\ChainPtfm\Art.nem"
		even
ArtButtonMZ:	incbin "levels\shared\Switch\Art MZ.nem"
		even
byte_2816E:	incbin "artnem\mz piston.nem"
		even
byte_2827A:	incbin "artnem\mz fire ball.nem"
		even
byte_28558:	incbin "artnem\mz lava.nem"
		even
byte_28E6E:	incbin "levels\MZ\PushBlock\Art.nem"
		even
ArtSeesaw:	incbin "levels\SLZ\Seesaw\Art.nem"
		even
ArtFan:		incbin "levels\SLZ\Fan\Art.nem"
		even
byte_294DA:	incbin "artnem\slz platform.nem"
		even
byte_2953C:	incbin "artnem\slz girders.nem"
		even
byte_2961E:	incbin "artnem\slz spiked platforms.nem"
		even
byte_297B6:	incbin "artnem\slz misc platforms.nem"
		even
byte_29D4A:	incbin "artnem\slz metal block.nem"
		even
ArtBumper:	incbin "levels\SZ\Bumper\Art.nem"
		even
byte_29FC0:	incbin "artnem\SZ small spiked ball.nem"
		even
ArtButton:	incbin "levels\shared\Switch\Art.nem"
		even
byte_2A104:	incbin "artnem\swinging spiked ball.nem"
		even
Nem_Ballhog:    incbin "artnem\Enemy Ballhog.bin"
		even
Nem_Crabmeat:	incbin "artnem\Enemy Crabmeat.bin"
		even
Nem_Buzzbomber:	incbin "artnem\Enemy Buzz Bomber.bin"
		even
byte_2ADFE:     incbin "artnem\Ballhog's Bomb Explosion.bin"
		even
Nem_Burrobot:   incbin "artnem\Enemy Burrobot.bin"
		even
ArtChopper:	incbin "artnem\Enemy Chopper.bin"
		even
Nem_Jaws:	incbin "artnem\Enemy Jaws.bin"
		even
byte_2BBC2:     incbin "artnem\Ballhog's Bomb.bin"
		even
Nem_Roller:	incbin "artnem\Enemy Roller.bin"
		even
ArtMotobug:	incbin "artnem\Enemy Motobug.bin"
		even
ArtNewtron:	incbin "artnem\Enemy Newtron.bin"
		even
ArtYardin:	incbin "artnem\Enemy Yadrin.bin"
		even
ArtBasaran:	incbin "artnem\Enemy Basaran.bin"
		even
ArtSplats:	incbin "artnem\Enemy Splats.bin"
		even
Nem_TitleCard:	incbin "artnem\Title Cards.bin"
		even
ArtHUD:		incbin "levels\shared\HUD\Main.nem"
		even
ArtLives:	incbin "levels\shared\HUD\Lives.nem"
		even
ArtRings:	incbin "artnem\Rings.bin"
		even
ArtMonitors:	incbin "artnem\Monitors.bin"
		even
ArtExplosions:	incbin "levels\shared\Explosions\Art.nem"
		even
byte_2E6C8:	incbin "artnem\score points.nem"
		even
ArtGameOver:	incbin "levels\shared\GameOver\Art.nem"
		even
ArtSpringHoriz:	incbin "levels\shared\Spring\Art Horizontal.nem"
		even
ArtSpringVerti:	incbin "levels\shared\Spring\Art Vertical.nem"
		even
ArtSignPost:	incbin "artnem\Signpost.bin"
		even
ArtAnimalPocky:	incbin "levels\shared\Animals\Pocky.nem"
		even
ArtAnimalCucky:	incbin "levels\shared\Animals\Cucky.nem"
		even
ArtAnimalPecky:	incbin "levels\shared\Animals\Pecky.nem"
		even
ArtAnimalRocky:	incbin "levels\shared\Animals\Rocky.nem"
		even
ArtAnimalPicky:	incbin "levels\shared\Animals\Picky.nem"
		even
ArtAnimalFlicky:incbin "levels\shared\Animals\Flicky.nem"
		even
ArtAnimalRicky:	incbin "levels\shared\Animals\Ricky.nem"
		even

		align $1000,$FF				; Padding
; ===========================================================================
; Level Data
; ===========================================================================
Blk16_GHZ:	incbin "map16\GHZ.bin"
		even
Nem_GHZ_1st:	incbin "artnem\8x8 - GHZ1.bin"
		even
Nem_GHZ_2nd:	incbin "artnem\8x8 - GHZ2.bin"
		even
Blk256_GHZ:	incbin "map256\GHZ.bin"
		even
Blk16_LZ:	incbin "map16\LZ.bin"
		even
Nem_LZ:         incbin "artnem\8x8 - LZ.bin"
		even
Blk256_LZ:	incbin "map256\LZ.bin"
		even
Blk16_MZ:	incbin "map16\MZ.bin"
		even
Nem_MZ:         incbin "artnem\8x8 - MZ.bin"
		even
Blk256_MZ:	incbin "map256\MZ.bin"
		even
byte_3DB70:	incbin "unknown\3DB70.dat"
		even
Blk16_SLZ:	incbin "map16\SLZ.bin"
		even
Nem_SLZ:	incbin "artnem\8x8 - SLZ.bin"
		even
Blk256_SLZ:	incbin "map256\SLZ.bin"
		even
Blk16_SZ:	incbin "map16\SZ.bin"
		even
Nem_SZ:	        incbin "artnem\8x8 - SZ.bin"
		even
Blk256_SZ:	incbin "map256\SZ.bin"
		even
Blk16_CWZ:	incbin "map16\CWZ.bin"
		even
Nem_CWZ:	incbin "artnem\8x8 - CWZ.bin"
		even
Blk256_CWZ:	incbin "map256\CWZ.bin"
		even
byte_570FC:	incbin "unknown\570FC.dat"
		even
; ===========================================================================
; Boss Art
; ===========================================================================
byte_60000:	incbin "artnem\Boss - Main.bin"
		even
byte_60864:	incbin "artnem\Boss - Weapons.bin"
		even
byte_60BB0:	incbin "artnem\Prison Capsule.bin"
		even
; ===========================================================================
; Demos
; ===========================================================================
byte_61434:	incbin "demodata\Intro - GHZ.bin"	; Green Hill's demo (act 2?)
		even
byte_614C6:	incbin "demodata\Intro - MZ.bin"	; Marble's demo
		even
byte_61578:	incbin "demodata\Intro - SZ.bin"	; Sparkling's demo (?)
		even
byte_6161E:	incbin "demodata\Intro - Special Stage.bin" ; Special stage demo
		even

		align $3000,$FF				; Padding
; ===========================================================================
; Special Stage Data
; ===========================================================================
                include "_maps\SS Walls.asm"

ArtSpecialBlocks:incbin "artnem\Art Blocks.nem"
		even
byte_639B8:	incbin "tilemaps\SS Background 1.bin"
		even
ArtSpecialAnimals:incbin "artnem\Art Animals.nem"
		even
byte_6477C:	incbin "tilemaps\SS Background 2.bin"
		even
byte_64A7C:	incbin "artnem\ss bg misc.nem"
		even
ArtSpecialGoal:	incbin "artnem\Art Goal.nem"
		even
ArtSpecialR:	incbin "artnem\Art R Block.nem"
		even
ArtSpecialSkull:incbin "artnem\Art Skull.nem"
		even
ArtSpecialU:	incbin "artnem\Art U Block.nem"
		even
ArtSpecial1up:	incbin "artnem\Art 1up.nem"
		even
ArtSpecialStars:incbin "artnem\Art Stars.nem"
		even
byte_65432:	incbin "artnem\ss red white.nem"
		even
ArtSpecialZone1:incbin "artnem\Art Zone 1.nem"
		even
ArtSpecialZone2:incbin "artnem\Art Zone 2.nem"
		even
ArtSpecialZone3:incbin "artnem\Art Zone 3.nem"
		even
ArtSpecialZone4:incbin "artnem\Art Zone 4.nem"
		even
ArtSpecialZone5:incbin "artnem\Art Zone 5.nem"
		even
ArtSpecialZone6:incbin "artnem\Art Zone 6.nem"
		even
ArtSpecialUpDown:incbin "artnem\Art Up Down.nem"
		even
ArtSpecialEmerald:incbin "artnem\Art Emerald.nem"
		even

		align $4000,$FF				; Padding
; ===========================================================================
; Collision Data
; ===========================================================================
colAngles:	incbin "collide\Angle Map.bin"
		even
colWidth:	incbin "collide\Collision Array (Normal).bin"
		even
colHeight:	incbin "collide\Collision Array (Rotated).bin"
		even
colGHZ:		incbin "collide\GHZ.bin"
		even
colLZ:		incbin "collide\LZ.bin"
		even
colMZ:		incbin "collide\MZ.bin"
		even
colSLZ:		incbin "collide\SLZ.bin"
		even
colSZ:		incbin "collide\SZ.bin"
		even
colCWZ:		incbin "collide\CWZ.bin"
		even
; ===========================================================================
; Special Stage Layout (Uncompressed)
; ===========================================================================
SS_1:           incbin "sslayout\1.bin"
		even
; ===========================================================================
; Animated Uncompressed Art
; ===========================================================================
Art_GhzWater:	incbin "artunc\GHZ Waterfall.bin"
		even
Art_GhzFlower1:	incbin "artunc\GHZ Flower Large.bin"
		even
Art_GhzFlower2:	incbin "artunc\GHZ Flower Small.bin"
		even
Art_MzLava1:	incbin "artunc\MZ Lava Surface.bin"
		even
Art_MzLava2:	incbin "artunc\MZ Lava.bin"
		even
Art_MzSaturns:	incbin "artunc\MZ Saturns.bin"
		even
Art_MzTorch:	incbin "artunc\MZ Background torch.bin"
		even
; ===========================================================================
; Level Layout Index
; ===========================================================================
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

LayoutGHZ1FG:	incbin "levels\ghz1.bin"
		even
LayoutGHZ1BG:	incbin "levels\ghzbg1.bin"
		even

byte_6CE54:	dc.l 0
LayoutGHZ2FG:	incbin "levels\ghz2.bin"
		even
LayoutGHZ2BG:	incbin "levels\ghzbg2.bin"
		even

byte_6CF3C:	dc.l 0
LayoutGHZ3FG:	incbin "levels\ghz3.bin"
		even
LayoutGHZ3BG:	incbin "levels\ghzbg3.bin"
		even

byte_6D084:	dc.l 0
byte_6D088:	dc.l 0
LayoutLZ1FG:	incbin "levels\lz1.bin"
		even
LayoutLZBG:	incbin "levels\lzbg.bin"
		even

byte_6D190:	dc.l 0
LayoutLZ2FG:	incbin "levels\lz2.bin"
		even

byte_6D216:	dc.l 0
LayoutLZ3FG:	incbin "levels\lz3.bin"
		even

byte_6D31C:	dc.l 0
byte_6D320:	dc.l 0
LayoutMZ1FG:	incbin "levels\mz1.bin"
		even
LayoutMZ1BG:	incbin "levels\mzbg1.bin"
		even
LayoutMZ2FG:	incbin "levels\mz2.bin"
		even
LayoutMZ2BG:	incbin "levels\mzbg2.bin"
		even

byte_6D614:	dc.l 0
LayoutMZ3FG:	incbin "levels\mz3.bin"
		even
LayoutMZ3BG:	incbin "levels\mzbg3.bin"
		even

byte_6D7DC:	dc.l 0
byte_6D7E0:	dc.l 0
LayoutSLZ1FG:	incbin "levels\slz1.bin"
		even
LayoutSLZBG:	incbin "levels\slzbg.bin"
		even
LayoutSLZ2FG:	incbin "levels\slz2.bin"
		even
LayoutSLZ3FG:	incbin "levels\slz3.bin"
		even

byte_6DBE4:	dc.l 0
LayoutSZ1FG:	incbin "levels\sz1.bin"
		even
LayoutSZBG:	incbin "levels\szbg.bin"
		even

byte_6DCD8:	dc.l 0
LayoutSZ2FG:	incbin "levels\sz2.bin"
		even

byte_6DDDA:	dc.l 0
LayoutSZ3FG:	incbin "levels\sz3.bin"
		even

byte_6DF30:	dc.l 0
byte_6DF34:	dc.l 0
LayoutCWZ1:	incbin "levels\cwz1.bin"
		even
LayoutCWZ2:	incbin "levels\cwz2.bin"
		even
byte_6E33C:	incbin "levels\cwz2bg.bin"
		even
LayoutCWZ3:	incbin "levels\cwz3.bin"
		even

byte_6E344:	dc.l 0
LayoutTest:     incbin "leftovers\test.bin"		; Seems to be a test layout
		even

byte_6E3CA:     dc.l 0
byte_6E3CE:	dc.l 0
byte_6E3D2:	dc.l 0
byte_6E3D6:	dc.l 0

		align $2000,$FF				; Padding
; ===========================================================================
; Object Layout Index
; ===========================================================================
ObjPos_Index:   ; GHZ
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

ObjPos_GHZ1:	incbin "objpos\ghz1.bin"
		even
ObjPos_GHZ2:	incbin "objpos\ghz2.bin"
		even
ObjPos_GHZ3:	incbin "objpos\ghz3.bin"
		even
ObjPos_LZ1:	incbin "objpos\lz1.bin"
		even
ObjPos_LZ2:	incbin "objpos\lz2.bin"
		even
ObjPos_LZ3:	incbin "objpos\lz3.bin"
		even
ObjPos_MZ1:	incbin "objpos\mz1.bin"
		even
ObjPos_MZ2:	incbin "objpos\mz2.bin"
		even
ObjPos_MZ3:	incbin "objpos\mz3.bin"
		even
ObjPos_SLZ1:	incbin "objpos\slz1.bin"
		even
ObjPos_SLZ2:	incbin "objpos\slz2.bin"
		even
ObjPos_SLZ3:	incbin "objpos\slz3.bin"
		even
ObjPos_SZ1:	incbin "objpos\sz1.bin"
		even
ObjPos_SZ2:	incbin "objpos\sz2.bin"
		even
byte_729CA:	incbin "leftovers\sz1.bin"		; Leftover from earlier builds
		even
ObjPos_SZ3:	incbin "objpos\sz3.bin"
		even
ObjPos_CWZ1:	incbin "objpos\cwz1.bin"
		even
ObjPos_CWZ2:	incbin "objpos\cwz2.bin"
		even
ObjPos_CWZ3:	incbin "objpos\cwz3.bin"
		even

ObjPos_Null:	dc.w $FFFF, 0, 0

		align $2000,$FF				; Padding

		include "s1.proto.sounddriver.asm"

		align $4000,$FF				; Padding

EndOfROM:

	END
