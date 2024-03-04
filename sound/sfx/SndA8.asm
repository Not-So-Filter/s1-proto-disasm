EnterGiantRing_Header:
	smpsHeaderStartSong 1, 1
	smpsHeaderVoice     EnterGiantRing_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	smpsHeaderSFXChannel cPSG3, EnterGiantRing_PSG3,	$00, $01

; PSG3 Data
EnterGiantRing_PSG3:
	smpsPSGvoice        $00
	smpsModSet          $01, $02, $02, $FF
	smpsPSGform         $E7
	dc.b	nMaxPSG, $7F

EnterGiantRing_Loop00:
	smpsPSGAlterVol     $01
	dc.b	smpsNoAttack, nA1, $0F
	smpsLoop            $00, $08, EnterGiantRing_Loop00
	smpsStop

; Song seems to not use any FM voices
EnterGiantRing_Voices:
