SndD2_Header:
	smpsHeaderStartSong 1
	smpsHeaderVoice     SndD2_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	smpsHeaderSFXChannel cFM4, SndD2_FM4,	$00, $14

; FM4 Data
SndD2_FM4:
	smpsSetvoice        $00

SndD2_Jump00:
	dc.b	nE0, $0E, nFs0, $0F
	smpsJump            SndD2_Jump00

SndD2_Voices:
;	Voice $00
;	$21
;	$73, $59, $60, $41, 	$1F, $15, $1F, $14, 	$05, $14, $03, $02
;	$0F, $0F, $0F, $0F, 	$1F, $2F, $4F, $1F, 	$16, $12, $13, $80
	smpsVcAlgorithm     $01
	smpsVcFeedback      $04
	smpsVcUnusedBits    $00
	smpsVcDetune        $04, $06, $05, $07
	smpsVcCoarseFreq    $01, $00, $09, $03
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $14, $1F, $15, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $02, $03, $14, $05
	smpsVcDecayRate2    $0F, $0F, $0F, $0F
	smpsVcDecayLevel    $01, $04, $02, $01
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $13, $12, $16

; Unused voice
;	Voice $01
;	$00
;	$1F, $01, $01, $80, 	$C0, $00, $0A, $00, 	$01, $F3, $E7, $F0
;	$01, $01, $03, $08, 	$A7, $01, $FB, $01, 	$F7, $00, $1A, $FF
	smpsVcAlgorithm     $00
	smpsVcFeedback      $00
	smpsVcUnusedBits    $00
	smpsVcDetune        $08, $00, $00, $01
	smpsVcCoarseFreq    $00, $01, $01, $0F
	smpsVcRateScale     $00, $00, $00, $03
	smpsVcAttackRate    $00, $0A, $00, $00
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $F0, $E7, $F3, $01
	smpsVcDecayRate2    $08, $03, $01, $01
	smpsVcDecayLevel    $00, $00, $00, $00
	smpsVcReleaseRate   $01, $FB, $01, $A7
	smpsVcTotalLevel    $FF, $1A, $00, $F7

; Unreachable
;	smpsCall            $14F7
	dc.b	$F8
        dc.w	$14F7-1
	dc.b	$FF, $FD
	smpsStop
