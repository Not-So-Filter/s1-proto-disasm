DebugLists:
                dc.w @GHZ-DebugLists
                dc.w @LZ-DebugLists
                dc.w @MZ-DebugLists
                dc.w @SLZ-DebugLists
		dc.w @SZ-DebugLists
                dc.w @CWZ-DebugLists
                
dbug:	macro map,object,subtype,frame,vram
	dc.l map+(object<<24)
	dc.b subtype,frame
	dc.w vram
	endm

@GHZ:
	dc.w (@GHZend-@GHZ-2)/8

;		mappings	object		subtype	frame	VRAM setting
	dbug 	MapRing,	$25,	0,	0,	$27B2
	dbug	MapMonitor,	$26,	0,	0,	$680
	dbug	MapCrabmeat,	$1F,	0,	0,	$400
	dbug	MapBuzzbomber,	$22,	0,	0,	$444
	dbug	MapChopper,	$2B,	0,	0,	$47B
	dbug	MapSpikes,	$36,	0,	0,	$51B
	dbug	MapPlatform1,	$18,    0,	0,	$4000
	dbug	MapPRock,	$3B,	0,	0,	$63D0
	dbug	MapMotobug,	$40,	0,	0,	$4F0
	dbug	MapSpring,	$41,	0,	0,	$523
	dbug	MapNewtron,	$42,	0,	0,	$249B
	dbug	MapWall,	$44,	0,	0,	$434C
	dbug	MapRollingBall,	$19,	0,	0,	$43AA
	@GHZend:

@LZ:	
        dc.w (@LZend-@LZ-2)/8

;		mappings	object		subtype	frame	VRAM setting
	dbug 	MapRing,	$25,	0,	0,	$27B2
	dbug	MapMonitor,	$26,	0,	0,	$680
	dbug	MapCrabmeat,	$1F,	0,	0,	$400
	@LZend:

@MZ:	
        dc.w (@MZend-@MZ-2)/8

;		mappings	object		subtype	frame	VRAM setting
	dbug 	MapRing,	$25,	0,	0,	$27B2
	dbug	MapMonitor,	$26,	0,	0,	$680
	dbug	MapBuzzbomber,	$22,	0,	0,	$444
	dbug	MapSpikes,	$36,	0,	0,	$51B
	dbug	MapSpring,	$41,	0,	0,	$523
	dbug    MapLavaball,    $13,    0,      0,      $345
	dbug    MapMZBlocks,    $46,    0,      0,      $4000
	dbug    MapLavafall,    $4C,    0,      0,      $63A8
	dbug    MapLavaChase,   $4E,    0,      0,      $63A8
	dbug    MapPushBlock,   $33,    0,      0,      $42B8
	dbug    Map4F,          $4F,    0,      0,      $4E4
	dbug    MapYadrin,      $50,    0,      0,      $47B
	dbug    MapSmashBlock,  $51,    0,      0,      $42B8
	dbug    MapMovingPtfm,  $52,    0,      0,      $2B8
	dbug    MapCollapseFloor,$53,   0,      0,      $62B8
	dbug    MapLavaHurt,    $54,    0,      0,      $8680
	dbug    MapBasaran,     $55,    0,      0,      $24B8
	@MZend:

@SLZ:	
        dc.w (@SLZend-@SLZ-2)/8

;		mappings	object		subtype	frame	VRAM setting
	dbug 	MapRing,	$25,	0,	0,	$27B2
	dbug	MapMonitor,	$26,	0,	0,	$680
	dbug    MapSLZMovingPtfm,$59,   0,      0,      $4480
	dbug    MapCollapseFloor,$53,   0,      2,      $44E0
	dbug    MapPlatform3,   $18,    0,      0,      $4480
	dbug    MapCirclePtfm,  $5A,    0,      0,      $4480
	dbug    MapStaircasePtfm,$5B,   0,      0,      $4480
	dbug    MapFan,         $5D,    0,      0,      $43A0
	dbug    MapSeesaw,      $5E,    0,      0,      $374
	dbug    MapSpring,      $41,    0,      0,      $523
	dbug    MapLavaball,    $13,    0,      0,      $345
	dbug	MapCrabmeat,	$1F,	0,	0,	$400
	dbug	MapBuzzbomber,	$22,	0,	0,	$444
	@SLZend:

@SZ:	
        dc.w (@SZend-@SZ-2)/8

;		mappings	object		subtype	frame	VRAM setting
	dbug 	MapRing,	$25,	0,	0,	$27B2
	dbug	MapMonitor,	$26,	0,	0,	$680
	dbug    MapSpikes,      $36,    0,      0,      $51B
	dbug    MapSpring,      $41,    0,      0,      $523
	dbug    MapRoller,      $43,    0,      0,      $24B8
	dbug    MapSceneryLamp, $12,    0,      0,      0
	dbug    MapBumper,      $47,    0,      0,      $380
	dbug	MapCrabmeat,	$1F,	0,	0,	$400
	dbug	MapBuzzbomber,	$22,	0,	0,	$444
	dbug    MapYadrin,      $50,    0,      0,      $47B
	dbug    MapPlatform2,   $18,    0,      0,      $4000
	dbug    MapMovingBlocks,$56,    0,      0,      $4000
	dbug    MapSwitch,      $32,    0,      0,      $513
	@SZend:

@CWZ:
        dc.w (@CWZend-@CWZ-2)/8

;		mappings	object		subtype	frame	VRAM setting
	dbug 	MapRing,	$25,	0,	0,	$27B2
	dbug	MapMonitor,	$26,	0,	0,	$680
	dbug	MapCrabmeat,	$1F,	0,	0,	$400
	@CWZend:

; ===========================================================================
; As seen in the Korean Manual of Sonic 1, Green Hill Zone would've originally used these in an earlier point of development.
; ===========================================================================
@GHZ_Early:
;		mappings	object		subtype	frame	VRAM setting
	dbug 	MapBallhog,	$1E,	0,	0,	$2400
	dbug	MapJaws,	$2C,	0,	0,	$47B
	dbug	MapBurrobot,	$2D,	0,	0,	$247B
	@GHZ_Earlyend:
