LoudWaterfall_Header:
	smpsHeaderStartSong 1
	smpsHeaderVoice     LoudWaterfall_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	smpsHeaderSFXChannel cFM4, LoudWaterfall_FM4,	$00, $0C

; FM4 Data
LoudWaterfall_FM4:
	smpsSetvoice        $00
	dc.b	nG6, $10

LoudWaterfall_Jump00:
	dc.b	smpsNoAttack, $10
	smpsJump            LoudWaterfall_Jump00

LoudWaterfall_Voices:
;	Voice $00
;	$38
;	$0F, $0F, $0F, $0F, 	$1F, $1F, $1F, $0E, 	$00, $00, $00, $00
;	$00, $00, $00, $00, 	$0F, $0F, $0F, $1F, 	$00, $00, $00, $80
	smpsVcAlgorithm     $00
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $00, $00
	smpsVcCoarseFreq    $0F, $0F, $0F, $0F
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $0E, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $00, $00, $00, $00
	smpsVcDecayRate2    $00, $00, $00, $00
	smpsVcDecayLevel    $01, $00, $00, $00
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $00, $00, $00

