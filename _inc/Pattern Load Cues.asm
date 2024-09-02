; ---------------------------------------------------------------------------
; Pattern load cues
; ---------------------------------------------------------------------------
ArtLoadCues:

ptr_PLC_Main:           dc.w PLC_Main-ArtLoadCues
ptr_PLC_Main2:          dc.w PLC_Main2-ArtLoadCues
ptr_PLC_Explode:        dc.w PLC_Explode-ArtLoadCues
ptr_PLC_GameOver:       dc.w PLC_GameOver-ArtLoadCues
PLC_Levels:
ptr_PLC_GHZ:		dc.w PLC_GHZ-ArtLoadCues
ptr_PLC_GHZ2:		dc.w PLC_GHZ2-ArtLoadCues
ptr_PLC_LZ:		dc.w PLC_LZ-ArtLoadCues
ptr_PLC_LZ2:		dc.w PLC_LZ2-ArtLoadCues
ptr_PLC_MZ:		dc.w PLC_MZ-ArtLoadCues
ptr_PLC_MZ2:		dc.w PLC_MZ2-ArtLoadCues
ptr_PLC_SLZ:		dc.w PLC_SLZ-ArtLoadCues
ptr_PLC_SLZ2:		dc.w PLC_SLZ2-ArtLoadCues
ptr_PLC_SZ:		dc.w PLC_SZ-ArtLoadCues
ptr_PLC_SZ2:		dc.w PLC_SZ2-ArtLoadCues
ptr_PLC_CWZ:		dc.w PLC_CWZ-ArtLoadCues
ptr_PLC_CWZ2:		dc.w PLC_CWZ2-ArtLoadCues

ptr_PLC_TitleCard:      dc.w PLC_TitleCard-ArtLoadCues
ptr_PLC_Boss:           dc.w PLC_Boss-ArtLoadCues
ptr_PLC_Signpost:       dc.w PLC_Signpost-ArtLoadCues
ptr_PLC_Warp:           dc.w PLC_Warp-ArtLoadCues
ptr_PLC_SpecialStage:   dc.w PLC_SpecialStage-ArtLoadCues
PLC_Animals:
ptr_PLC_GHZAnimals:	dc.w PLC_GHZAnimals-ArtLoadCues
ptr_PLC_LZAnimals:	dc.w PLC_LZAnimals-ArtLoadCues
ptr_PLC_MZAnimals:	dc.w PLC_MZAnimals-ArtLoadCues
ptr_PLC_SLZAnimals:	dc.w PLC_SLZAnimals-ArtLoadCues
ptr_PLC_SZAnimals:	dc.w PLC_SZAnimals-ArtLoadCues
ptr_PLC_CWZAnimals:	dc.w PLC_CWZAnimals-ArtLoadCues
		
plcm:	macro gfx,vram
	dc.l gfx
	dc.w vram
	endm

; ---------------------------------------------------------------------------
; Pattern load cues - standard block 1
; ---------------------------------------------------------------------------
PLC_Main:	dc.w ((PLC_Mainend-PLC_Main-2)/6)-1
		plcm    Nem_Smoke, $F400
		plcm    Nem_HUD, $D940
		plcm    Nem_Lives, $FA80
		plcm    Nem_Rings, $F640
		plcm    byte_2E6C8, $F2E0
	PLC_Mainend:
; ---------------------------------------------------------------------------
; Pattern load cues - standard block 2
; ---------------------------------------------------------------------------
PLC_Main2:	dc.w ((PLC_Main2end-PLC_Main2-2)/6)-1
		plcm    Nem_Monitors, $D000
		plcm    Nem_Shield, $A820
		plcm    Nem_Stars, $AB80
	PLC_Main2end:
; ---------------------------------------------------------------------------
; Pattern load cues - explosion
; ---------------------------------------------------------------------------
PLC_Explode:	dc.w ((PLC_Explodeend-PLC_Explode-2)/6)-1
		plcm    ArtExplosions, $B400
	PLC_Explodeend:
; ---------------------------------------------------------------------------
; Pattern load cues - game/time	over
; ---------------------------------------------------------------------------
PLC_GameOver:	dc.w ((PLC_GameOverend-PLC_GameOver-2)/6)-1
		plcm    ArtGameOver, $B000
	PLC_GameOverend:
; ---------------------------------------------------------------------------
; Pattern load cues - Green Hill
; ---------------------------------------------------------------------------
PLC_GHZ:	dc.w ((PLC_GHZ2-PLC_GHZ-2)/6)-1
		plcm    Nem_GHZ_1st, 0
		plcm    Nem_GHZ_2nd, $39A0
		plcm    byte_27400, $6B00
		plcm    ArtPurpleRock, $7A00
		plcm    Nem_Crabmeat, $8000
		plcm    Nem_Buzzbomber, $8880
		plcm    ArtChopper, $8F60
		plcm    ArtNewtron, $9360
		plcm    ArtMotobug, $9E00
		plcm    ArtSpikes, $A360
		plcm    ArtSpringHoriz, $A460
		plcm    ArtSpringVerti, $A660

PLC_GHZ2:	dc.w ((PLC_GHZ2end-PLC_GHZ2-2)/6)-1
		plcm    byte_2744A, $7000
		plcm    ArtBridge, $71C0
		plcm    ArtSpikeLogs, $7300
		plcm    byte_27698, $7540
		plcm    ArtSmashWall, $A1E0
		plcm    ArtWall, $6980
	PLC_GHZ2end:
; ---------------------------------------------------------------------------
; Pattern load cues - Labyrinth
; ---------------------------------------------------------------------------
PLC_LZ:		dc.w ((PLC_LZ2-PLC_LZ-2)/6)-1
		plcm    Nem_LZ, 0

PLC_LZ2:	dc.w ((PLC_LZ2end-PLC_LZ2-2)/6)-1
		plcm    Nem_Jaws, $99C0
	PLC_LZ2end:
; ---------------------------------------------------------------------------
; Pattern load cues - Marble
; ---------------------------------------------------------------------------
PLC_MZ:		dc.w ((PLC_MZ2-PLC_MZ-2)/6)-1
		plcm    Nem_MZ, 0
		plcm    ArtChainPtfm, $6000
		plcm    byte_2827A, $68A0
		plcm    byte_2744A, $7000
		plcm    byte_2816E, $71C0
		plcm    byte_28558, $7500
		plcm    Nem_Buzzbomber, $8880
		plcm    ArtYardin, $8F60
		plcm    ArtBasaran, $9700
		plcm    ArtSplats, $9C80

PLC_MZ2:	dc.w ((PLC_MZ2end-PLC_MZ2-2)/6)-1
		plcm    ArtButtonMZ, $A260
		plcm    ArtSpikes, $A360
		plcm    ArtSpringHoriz, $A460
		plcm    ArtSpringVerti, $A660
		plcm    byte_28E6E, $5700
	PLC_MZ2end:
; ---------------------------------------------------------------------------
; Pattern load cues - Star Light
; ---------------------------------------------------------------------------
PLC_SLZ:	dc.w ((PLC_SLZ2-PLC_SLZ-2)/6)-1
		plcm    Nem_SLZ, 0
		plcm    byte_2827A, $68A0
		plcm    Nem_Crabmeat, $8000
		plcm    Nem_Buzzbomber, $8880
		plcm    Nem_SLZ_Platfm, $9000
		plcm    byte_29D4A, $9C00
		plcm    ArtMotobug, $9E00
		plcm    byte_294DA, $A260
		plcm    ArtSpikes, $A360
		plcm    ArtSpringHoriz, $A460
		plcm    ArtSpringVerti, $A660

PLC_SLZ2:	dc.w ((PLC_SLZ2end-PLC_SLZ2-2)/6)-1
		plcm    ArtSeesaw, ArtTile_SLZ_Seesaw*tile_size
		plcm    ArtFan, ArtTile_SLZ_Fan*tile_size
		plcm    byte_2953C, ArtTile_SLZ_Pylon*tile_size
		plcm    byte_2961E, ArtTile_SLZ_Swing*tile_size
	PLC_SLZ2end:
; ---------------------------------------------------------------------------
; Pattern load cues - Sparkling
; ---------------------------------------------------------------------------
PLC_SZ:         dc.w ((PLC_SZ2-PLC_SZ-2)/6)-1
		plcm    Nem_SZ, 0
		plcm    Nem_Crabmeat, $8000
		plcm    Nem_Buzzbomber, $8880
		plcm    ArtYardin, $8F60
		plcm    Nem_Roller, $9700

PLC_SZ2:	dc.w ((PLC_SZ2end-PLC_SZ2-2)/6)-1
		plcm    ArtBumper, $7000
		plcm    byte_2A104, $72C0
		plcm    byte_29FC0, $7740
		plcm    ArtButton, $A1E0
		plcm    ArtSpikes, $A360
		plcm    ArtSpringHoriz, $A460
		plcm    ArtSpringVerti, $A660
	PLC_SZ2end:
; ---------------------------------------------------------------------------
; Pattern load cues - Clock Work
; ---------------------------------------------------------------------------
PLC_CWZ:	dc.w ((PLC_CWZ2-PLC_CWZ-2)/6)-1
		plcm    Nem_CWZ, 0

PLC_CWZ2:	dc.w ((PLC_CWZ2end-PLC_CWZ2-2)/6)-1
		plcm    Nem_Jaws, $99C0
	PLC_CWZ2end:
; ---------------------------------------------------------------------------
; Pattern load cues - title card
; ---------------------------------------------------------------------------
PLC_TitleCard:	dc.w ((PLC_TitleCardend-PLC_TitleCard-2)/6)-1
		plcm    Nem_TitleCard, $B000
	PLC_TitleCardend:
; ---------------------------------------------------------------------------
; Pattern load cues - act 3 boss
; ---------------------------------------------------------------------------
PLC_Boss:	dc.w ((PLC_Bossend-PLC_Boss-2)/6)-1
		plcm    byte_60000, $8000
		plcm    byte_60864, $8D80
		plcm    byte_60BB0, $93A0
	PLC_Bossend:
; ---------------------------------------------------------------------------
; Pattern load cues - act 1/2 signpost
; ---------------------------------------------------------------------------
PLC_Signpost:	dc.w ((PLC_Signpostend-PLC_Signpost-2)/6)-1
		plcm    ArtSignPost, $D000
	PLC_Signpostend:
; ---------------------------------------------------------------------------
; Pattern load cues - special stage warp effect
; ---------------------------------------------------------------------------
PLC_Warp:	dc.w ((PLC_Warpend-PLC_Warp-2)/6)-1
		plcm    Nem_Flash, $A820
	PLC_Warpend:
; ---------------------------------------------------------------------------
; Pattern load cues - special stage
; ---------------------------------------------------------------------------
PLC_SpecialStage:	dc.w ((PLC_SpeStageend-PLC_SpecialStage-2)/6)-1
		plcm    byte_64A7C, 0
		plcm    ArtSpecialAnimals, $A20
		plcm    ArtSpecialBlocks, $2840
		plcm    ArtBumper, $4760
		plcm    ArtSpecialGoal, $4A20
		plcm    ArtSpecialUpDown, $4C60
		plcm    ArtSpecialR, $5E00
		plcm    ArtSpecial1up, $6E00
		plcm    ArtSpecialStars, $7E00
		plcm    byte_65432, $8E00
		plcm    ArtSpecialSkull, $9E00
		plcm    ArtSpecialU, $AE00
	PLC_SpeStageend:
		plcm    ArtSpecialEmerald, 0
		plcm    ArtSpecialZone1, 0
		plcm    ArtSpecialZone2, 0
		plcm    ArtSpecialZone3, 0
		plcm    ArtSpecialZone4, 0
		plcm    ArtSpecialZone5, 0
		plcm    ArtSpecialZone6, 0
; ---------------------------------------------------------------------------
; Pattern load cues - GHZ animals
; ---------------------------------------------------------------------------
PLC_GHZAnimals:	dc.w ((PLC_GHZAnimalsend-PLC_GHZAnimals-2)/6)-1
		plcm    ArtAnimalPocky, $B000
		plcm    ArtAnimalCucky, $B240
	PLC_GHZAnimalsend:
; ---------------------------------------------------------------------------
; Pattern load cues - LZ animals
; ---------------------------------------------------------------------------
PLC_LZAnimals:	dc.w ((PLC_LZAnimalsend-PLC_LZAnimals-2)/6)-1
		plcm    ArtAnimalPecky, $B000
		plcm    ArtAnimalRocky, $B240
	PLC_LZAnimalsend:
; ---------------------------------------------------------------------------
; Pattern load cues - MZ animals
; ---------------------------------------------------------------------------
PLC_MZAnimals:	dc.w ((PLC_MZAnimalsend-PLC_MZAnimals-2)/6)-1
		plcm    ArtAnimalPicky, $B000
		plcm    ArtAnimalFlicky, $B240
	PLC_MZAnimalsend:
; ---------------------------------------------------------------------------
; Pattern load cues - SLZ animals
; ---------------------------------------------------------------------------
PLC_SLZAnimals:	dc.w ((PLC_SLZAnimalsend-PLC_SLZAnimals-2)/6)-1
		plcm    ArtAnimalRicky, $B000
		plcm    ArtAnimalRocky, $B240
	PLC_SLZAnimalsend:
; ---------------------------------------------------------------------------
; Pattern load cues - SZ animals
; ---------------------------------------------------------------------------
PLC_SZAnimals:	dc.w ((PLC_SZAnimalsend-PLC_SZAnimals-2)/6)-1
		plcm    ArtAnimalPicky, $B000
		plcm    ArtAnimalCucky, $B240
	PLC_SZAnimalsend:
; ---------------------------------------------------------------------------
; Pattern load cues - CWZ animals
; ---------------------------------------------------------------------------
PLC_CWZAnimals:	dc.w ((PLC_CWZAnimalsend-PLC_CWZAnimals-2)/6)-1
		plcm    ArtAnimalPocky, $B000
		plcm    ArtAnimalFlicky, $B240
	PLC_CWZAnimalsend:
	        even
                
; ---------------------------------------------------------------------------
; Pattern load cue IDs
; ---------------------------------------------------------------------------
plcid_Main:		= (ptr_PLC_Main-ArtLoadCues)/2 ; 0
plcid_Main2:		= (ptr_PLC_Main2-ArtLoadCues)/2 ; 1
plcid_Explode:		= (ptr_PLC_Explode-ArtLoadCues)/2 ; 2
plcid_GameOver:		= (ptr_PLC_GameOver-ArtLoadCues)/2 ; 3
plcid_GHZ:		= (ptr_PLC_GHZ-ArtLoadCues)/2	; 4
plcid_GHZ2:		= (ptr_PLC_GHZ2-ArtLoadCues)/2 ; 5
plcid_LZ:		= (ptr_PLC_LZ-ArtLoadCues)/2	; 6
plcid_LZ2:		= (ptr_PLC_LZ2-ArtLoadCues)/2	; 7
plcid_MZ:		= (ptr_PLC_MZ-ArtLoadCues)/2	; 8
plcid_MZ2:		= (ptr_PLC_MZ2-ArtLoadCues)/2	; 9
plcid_SLZ:		= (ptr_PLC_SLZ-ArtLoadCues)/2	; $A
plcid_SLZ2:		= (ptr_PLC_SLZ2-ArtLoadCues)/2 ; $B
plcid_SZ:		= (ptr_PLC_SZ-ArtLoadCues)/2	; $C
plcid_SZ2:		= (ptr_PLC_SZ2-ArtLoadCues)/2	; $D
plcid_CWZ:		= (ptr_PLC_CWZ-ArtLoadCues)/2	; $E
plcid_CWZ2:		= (ptr_PLC_CWZ2-ArtLoadCues)/2 ; $F
plcid_TitleCard:	= (ptr_PLC_TitleCard-ArtLoadCues)/2 ; $10
plcid_Boss:		= (ptr_PLC_Boss-ArtLoadCues)/2 ; $11
plcid_Signpost:		= (ptr_PLC_Signpost-ArtLoadCues)/2 ; $12
plcid_Warp:		= (ptr_PLC_Warp-ArtLoadCues)/2 ; $13
plcid_SpecialStage:	= (ptr_PLC_SpecialStage-ArtLoadCues)/2 ; $14
plcid_GHZAnimals:	= (ptr_PLC_GHZAnimals-ArtLoadCues)/2 ; $15
plcid_LZAnimals:	= (ptr_PLC_LZAnimals-ArtLoadCues)/2 ; $16
plcid_MZAnimals:	= (ptr_PLC_MZAnimals-ArtLoadCues)/2 ; $17
plcid_SLZAnimals:	= (ptr_PLC_SLZAnimals-ArtLoadCues)/2 ; $18
plcid_SZAnimals:	= (ptr_PLC_SZAnimals-ArtLoadCues)/2 ; $19
plcid_CWZAnimals:	= (ptr_PLC_CWZAnimals-ArtLoadCues)/2 ; $1A
