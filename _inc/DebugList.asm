DebugLists:
                dc.w .GHZ-DebugLists
                dc.w .LZ-DebugLists
		dc.w .MZ-DebugLists
		dc.w .SLZ-DebugLists
		dc.w .SZ-DebugLists
		dc.w .CWZ-DebugLists

dbug:	macro map,object,subtype,frame,vram
	dc.l map+(object<<24)
	dc.b subtype,frame
	dc.w vram
	endm

.GHZ:
	dc.w (.GHZend-.GHZ-2)/8

;		mappings	object		subtype	frame	VRAM setting
	dbug 	MapRing,	id_Rings,	0,	0,	$27B2
	dbug	MapMonitor,	id_Monitor,	0,	0,	$680
	dbug	Map_Crab,	id_Crabmeat,	0,	0,	$400
	dbug	Map_Buzz,	id_BuzzBomber,	0,	0,	$444
	dbug	Map_Chop,	id_Chopper,	0,	0,	$47B
	dbug	MapSpikes,	id_Spikes,	0,	0,	$51B
	dbug	Map_Plat_GHZ,	id_BasicPlatform,	0,	0,	$4000
	dbug	MapPRock,	id_PurpleRock,	0,	0,	$63D0
	dbug	Map_Moto,	id_MotoBug,	0,	0,	$4F0
	dbug	Map_Spring,	id_Springs,	0,	0,	$523
	dbug	Map_Newt,	id_Newtron,	0,	0,	$249B
	dbug	Map_Edge,	id_EdgeWalls,	0,	0,	$434C
	dbug	Map_GBall,	id_GBall,	0,	0,	$43AA
	.GHZend:

.LZ:
	dc.w (.LZend-.LZ-2)/8

;		mappings	object		subtype	frame	VRAM setting
	dbug 	MapRing,	id_Rings,	0,	0,	$27B2
	dbug	MapMonitor,	id_Monitor,	0,	0,	$680
	dbug	Map_Crab,	id_Crabmeat,	0,	0,	$400
	.LZend:

.MZ:
	dc.w (.MZend-.MZ-2)/8

;		mappings	object		subtype	frame	VRAM setting
	dbug 	MapRing,	id_Rings,	0,	0,	$27B2
	dbug	MapMonitor,	id_Monitor,	0,	0,	$680
	dbug	Map_Buzz,	id_BuzzBomber,	0,	0,	$444
	dbug	MapSpikes,	id_Spikes,	0,	0,	$51B
	dbug	Map_Spring,	id_Springs,	0,	0,	$523
	dbug	Map_Fire,	id_LavaMaker,	0,	0,	$345
	dbug	Map_Brick,	id_MarbleBrick,	0,	0,	$4000
	dbug	Map_Geyser,	id_GeyserMaker,	0,	0,	$63A8
	dbug	Map_LWall,	id_LavaWall,	0,	0,	$63A8
	dbug	Map_Push,	id_PushBlock,	0,	0,	$42B8
	dbug	Map4F,		id_Splats,	0,	0,	$4E4
	dbug	MapYadrin,	id_Yadrin,	0,	0,	$47B
	dbug	MapSmashBlock,	id_SmashBlock,	0,	0,	$42B8
	dbug	MapMovingPtfm,	id_MovingBlock,	0,	0,	$2B8
	dbug	Map_CFlo,	id_CollapseFloor,	0,	0,	$62B8
	dbug	Map_LTag,	id_LavaTag,	0,	0,	$8680
	dbug	Map_Bas,	id_Basaran,	0,	0,	$24B8
	.MZend:

.SLZ:
	dc.w (.SLZend-.SLZ-2)/8

;		mappings	object		subtype	frame	VRAM setting
	dbug 	MapRing,	id_Rings,	0,	0,	$27B2
	dbug	MapMonitor,	id_Monitor,	0,	0,	$680
	dbug	Map_Elev,	id_Elevator,	0,	0,	$4480
	dbug	Map_CFlo,	id_CollapseFloor,	0,	2,	$44E0
	dbug	Map_Plat_SLZ,	id_BasicPlatform,	0,	0,	$4480
	dbug	Map_Circ,	id_CirclingPlatform,	0,	0,	$4480
	dbug	Map_Stair,	id_Staircase,	0,	0,	$4480
	dbug	Map_Fan,	id_Fan,		0,	0,	$43A0
	dbug	Map_Seesaw,	id_Seesaw,	0,	0,	$374
	dbug	Map_Spring,	id_Springs,	0,	0,	$523
	dbug	Map_Fire,	id_LavaMaker,	0,	0,	$345
	dbug	Map_Crab,	id_Crabmeat,	0,	0,	$400
	dbug	Map_Buzz,	id_BuzzBomber,	0,	0,	$444
	.SLZend:

.SZ:
	dc.w (.SZend-.SZ-2)/8

;		mappings	object		subtype	frame	VRAM setting
	dbug 	MapRing,	id_Rings,	0,	0,	$27B2
	dbug	MapMonitor,	id_Monitor,	0,	0,	$680
	dbug	MapSpikes,	id_Spikes,	0,	0,	$51B
	dbug	Map_Spring,	id_Springs,	0,	0,	$523
	dbug	Map_Roll,	id_Roller,	0,	0,	$24B8
	dbug	Map_Light,	id_SpinningLight,	0,	0,	0
	dbug	Map_Bump,	id_Bumper,	0,	0,	$380
	dbug	Map_Crab,	id_Crabmeat,	0,	0,	$400
	dbug	Map_Buzz,	id_BuzzBomber,	0,	0,	$444
	dbug	MapYadrin,	id_Yadrin,	0,	0,	$47B
	dbug	Map_Plat_SZ,	id_BasicPlatform,	0,	0,	$4000
	dbug	Map_FBlock,	id_FloatingBlock,	0,	0,	$4000
	dbug	MapSwitch,	id_Button,	0,	0,	$513
	.SZend:

.CWZ:
	dc.w (.CWZend-.CWZ-2)/8

;		mappings	object		subtype	frame	VRAM setting
	dbug 	MapRing,	id_Rings,	0,	0,	$27B2
	dbug	MapMonitor,	id_Monitor,	0,	0,	$680
	dbug	Map_Crab,	id_Crabmeat,	0,	0,	$400
	.CWZend:

;.DebugUnk:
;		mappings	object		subtype	frame	VRAM setting
	dbug 	MapBallhog,	id_BallHog,	0,	0,	$2400
	dbug	Map_Jaws,	id_Jaws,	0,	0,	$47B
	dbug	Map_Burro,	id_Burrobot,	0,	0,	$247B
;	.DebugUnkend:
