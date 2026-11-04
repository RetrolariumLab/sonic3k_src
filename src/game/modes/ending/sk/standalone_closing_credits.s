; Owner: game/modes/ending/sk
; Responsibility: Closing credit text stream, relative offset index and display positions for standalone S&K
; Source provenance and ranges: config/reconstruction/source_layout.json
CreditsText_Part2_SK:
                dc.w    SoloCredits_ComposersHeading-CreditsText_Part2_SK
                dc.w    SoloCredits_ComposerDrossin-CreditsText_Part2_SK
                dc.w    SoloCredits_SegaSoundHeading-CreditsText_Part2_SK
                dc.w    SKCreditsStandaloneClosing_SoundTeamBo-CreditsText_Part2_SK
                dc.w    SoloCredits_SoundOgawa-CreditsText_Part2_SK
                dc.w    SoloCredits_SoundMilpo-CreditsText_Part2_SK
                dc.w    SoloCredits_SoundSetsumaru-CreditsText_Part2_SK
                dc.w    SoloCredits_SoundMaeda-CreditsText_Part2_SK
                dc.w    SoloCredits_SoundSawada-CreditsText_Part2_SK
                dc.w    SoloCredits_SoundNagao-CreditsText_Part2_SK
                dc.w    SoloCredits_SoundSenoue-CreditsText_Part2_SK
                dc.w    SoloCredits_ExecManagementHeading-CreditsText_Part2_SK
                dc.w    SoloCredits_ExecManagementIrimajiri-CreditsText_Part2_SK
                dc.w    SoloCredits_ExecManagementKalinske-CreditsText_Part2_SK
                dc.w    SoloCredits_ExecManagementRioux-CreditsText_Part2_SK
                dc.w    SoloCredits_ProductManagerHeading-CreditsText_Part2_SK
                dc.w    SoloCredits_ProductManagerKelly-CreditsText_Part2_SK
                dc.w    SoloCredits_ExecCoordinatorHeading-CreditsText_Part2_SK
                dc.w    SoloCredits_ExecCoordShigeta-CreditsText_Part2_SK
                dc.w    SoloCredits_ExecCoordTakami-CreditsText_Part2_SK
                dc.w    SoloCredits_ExecCoordFornasier-CreditsText_Part2_SK
                dc.w    SoloCredits_ExecCoordHector-CreditsText_Part2_SK
                dc.w    SoloCredits_ExecCoordUtsunomiya-CreditsText_Part2_SK
                dc.w    SoloCredits_TestersHeading-CreditsText_Part2_SK
                dc.w    SoloCredits_TesterKuo-CreditsText_Part2_SK
                dc.w    SoloCredits_TesterGreer-CreditsText_Part2_SK
                dc.w    SoloCredits_TesterWilliams-CreditsText_Part2_SK
                dc.w    SoloCredits_SoundThanksHeading-CreditsText_Part2_SK
                dc.w    SoloCredits_SoundThanksCubeCorp-CreditsText_Part2_SK
                dc.w    SoloCredits_SoundThanksOpusCorp-CreditsText_Part2_SK
                dc.w    SoloCredits_SoundThanksNakayama-CreditsText_Part2_SK
                dc.w    SoloCredits_SoundThanksStudioWho-CreditsText_Part2_SK
                dc.w    SoloCredits_SpecialThanksHeading-CreditsText_Part2_SK
                dc.w    SoloCredits_SpecialThanksIshiwatari-CreditsText_Part2_SK
                dc.w    SoloCredits_SpecialThanksKawamura-CreditsText_Part2_SK
                dc.w    SoloCredits_SpecialThanksMcCracken-CreditsText_Part2_SK
                dc.w    SoloCredits_SpecialThanksMakino-CreditsText_Part2_SK
                dc.w    SoloCredits_PresentedByHeading-CreditsText_Part2_SK
                dc.w    SoloCredits_PresentedBySega-CreditsText_Part2_SK
                dc.w    SoloCredits_TrailingBlankLine-CreditsText_Part2_SK
                dc.w    SoloCredits_FinishStream-CreditsText_Part2_SK
SoloCredits_ComposersHeading:   dc.b    2
                dc.b    $D
                dc.b    "MUSIC COMPOSERS",0
                even
SoloCredits_ComposerDrossin:    dc.b    4
                dc.b    $E
                dc.b    "HOWARD DROSSIN",0
                even
SoloCredits_SegaSoundHeading:   dc.b    $14
                dc.b    $D
                dc.b    "SEGA SOUND TEAM",0
                even
SKCreditsStandaloneClosing_SoundTeamBo: dc.b    $16
                dc.b    $24
                dc.b    "BO",0
                even
SoloCredits_SoundOgawa: dc.b    $17
                dc.b    $12
                dc.b    "SACHIO OGAWA",0
                even
SoloCredits_SoundMilpo: dc.b    $18
                dc.b    $20
                dc.b    "MILPO",0
                even
SoloCredits_SoundSetsumaru: dc.b    $19
                dc.b    $A
                dc.b    "MASARU SETSUMARU",0
                even
SoloCredits_SoundMaeda: dc.b    $1A
                dc.b    $C
                dc.b    "TATSUYUKI MAEDA",0
                even
SoloCredits_SoundSawada:    dc.b    $1B
                dc.b    $C
                dc.b    "TOMONORI SAWADA",0
                even
SoloCredits_SoundNagao: dc.b    $1C
                dc.b    $E
                dc.b    "MASAYUKI NAGAO",0
                even
SoloCredits_SoundSenoue:    dc.b    $1D
                dc.b    $16
                dc.b    "JUN SENOUE",0
                even
SoloCredits_ExecManagementHeading:  dc.b    $2D
                dc.b    3
                dc.b    "EXECUTIVE MANAGEMENT",0
                even
SoloCredits_ExecManagementIrimajiri:    dc.b    $2F
                dc.b    6
                dc.b    $53
                dc.b    "HOUICHIROU IRIMAJIRI",0
                even
SoloCredits_ExecManagementKalinske: dc.b    $30
                dc.b    $12
                dc.b    "TOM KALINSKE",0
                even
SoloCredits_ExecManagementRioux:    dc.b    $31
                dc.b    $16
                dc.b    "PAUL RIOUX",0
                even
SoloCredits_ProductManagerHeading:  dc.b    $41
                dc.b    $D
                dc.b    "PRODUCT MANAGER",0
                even
SoloCredits_ProductManagerKelly:    dc.b    $43
                dc.b    $12
                dc.b    "PAMELA KELLY",0
                even
SoloCredits_ExecCoordinatorHeading: dc.b    $53
                dc.b    3
                dc.b    "EXECUTIVE COORDINATOR",0
                even
SoloCredits_ExecCoordShigeta:   dc.b    $55
                dc.b    $E
                dc.b    "MAMORU SHIGETA",0
                even
SoloCredits_ExecCoordTakami:    dc.b    $56
                dc.b    $14
                dc.b    "TOMIO TAKAMI",0
                even
SoloCredits_ExecCoordFornasier: dc.b    $57
                dc.b    $A
                dc.b    "DIANE A. FORNASIER ",0
                even
SoloCredits_ExecCoordHector:    dc.b    $58
                dc.b    $12
                dc.b    "ROGER HECTOR",0
                even
SoloCredits_ExecCoordUtsunomiya:    dc.b    $59
                dc.b    4
                dc.b    "TAKAHARU UTSUNOMIYA",0
                even
SoloCredits_TestersHeading: dc.b    $69
                dc.b    $1B
                dc.b    "TESTERS",0
                even
SoloCredits_TesterKuo:  dc.b    $6B
                dc.b    $16
                dc.b    "JASON KUO",0
                even
SoloCredits_TesterGreer:    dc.b    $6C
                dc.b    $16
                dc.b    "RICK GREER",0
                even
SoloCredits_TesterWilliams: dc.b    $6D
                dc.b    $12
                dc.b    "MIKE WILLIAMS",0
                even
SoloCredits_SoundThanksHeading: dc.b    $7D
                dc.b    5
                dc.b    "SOUND SPECIAL THANKS",0
                even
SoloCredits_SoundThanksCubeCorp:    dc.b    $7F
                dc.b    $16
                dc.b    "CUBE CORP.",0
                even
SoloCredits_SoundThanksOpusCorp:    dc.b    $80
                dc.b    $16
                dc.b    "OPUS CORP.",0
                even
SoloCredits_SoundThanksNakayama:    dc.b    $81
                dc.b    8
                dc.b    "MASANORI NAKAYAMA",0
                even
SoloCredits_SoundThanksStudioWho:   dc.b    $82
                dc.b    $14
                dc.b    "(STUDIO WHO)",0
                even
SoloCredits_SpecialThanksHeading:   dc.b    $92
                dc.b    $F
                dc.b    "SPECIAL THANKS",0
                even
SoloCredits_SpecialThanksIshiwatari:    dc.b    $94
                dc.b    $10
                dc.b    "JINA ISHIWATARI",0
                even
SoloCredits_SpecialThanksKawamura:  dc.b    $95
                dc.b    $12
                dc.b    "EMI KAWAMURA",0
                even
SoloCredits_SpecialThanksMcCracken: dc.b    $96
                dc.b    8
                dc.b    "DEBORAH MCCRACKEN",0
                even
SoloCredits_SpecialThanksMakino:    dc.b    $97
                dc.b    $14
                dc.b    "TAKU MAKINO",0
                even
SoloCredits_PresentedByHeading: dc.b    $AB
                dc.b    $13
                dc.b    "PRESENTED BY",0
                even
SoloCredits_PresentedBySega:    dc.b    $AD
                dc.b    $20
                dc.b    "SEGA",0
                even
SoloCredits_TrailingBlankLine:  dc.b    $BD
                dc.b    $20
                dc.b    "  ",0
                even
SoloCredits_FinishStream:   dc.b    $FF
                dc.b    $F4
