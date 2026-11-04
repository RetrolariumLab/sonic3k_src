; Owner: game/modes/ending/sk
; Responsibility: Closing credit text stream, relative offset index and display positions for Sonic 3 & Knuckles
; Source provenance and ranges: config/reconstruction/source_layout.json
CreditsText_Part2:
                dc.w    LockCredits_ComposersHeading-CreditsText_Part2
                dc.w    LockCredits_ComposerBuxer-CreditsText_Part2
                dc.w    LockCredits_ComposerBrooks-CreditsText_Part2
                dc.w    LockCredits_ComposerRoss-CreditsText_Part2
                dc.w    LockCredits_ComposerGrace-CreditsText_Part2
                dc.w    LockCredits_ComposerGrigsby-CreditsText_Part2
                dc.w    LockCredits_ComposerScirocco-CreditsText_Part2
                dc.w    LockCredits_ComposerDrossin-CreditsText_Part2
                dc.w    LockCredits_SegaSoundHeading-CreditsText_Part2
                dc.w    SKCreditsLockonClosing_SoundTeamBo-CreditsText_Part2
                dc.w    LockCredits_SoundOgawa-CreditsText_Part2
                dc.w    SKCreditsLockonClosing_SoundTeamMilpo-CreditsText_Part2
                dc.w    LockCredits_SoundSetsumaru-CreditsText_Part2
                dc.w    LockCredits_SoundMaeda-CreditsText_Part2
                dc.w    LockCredits_SoundSawada-CreditsText_Part2
                dc.w    LockCredits_SoundNagao-CreditsText_Part2
                dc.w    LockCredits_SoundSenoue-CreditsText_Part2
                dc.w    LockCredits_SoundCoordinatorHeading-CreditsText_Part2
                dc.w    LockCredits_SoundCoordinatorNimiya-CreditsText_Part2
                dc.w    LockCredits_ExecManagementHeading-CreditsText_Part2
                dc.w    LockCredits_ExecManagementIrimajiri-CreditsText_Part2
                dc.w    LockCredits_ExecManagementKalinske-CreditsText_Part2
                dc.w    LockCredits_ExecManagementRioux-CreditsText_Part2
                dc.w    LockCredits_ProductManagerHeading-CreditsText_Part2
                dc.w    LockCredits_ProductManagerKelly-CreditsText_Part2
                dc.w    LockCredits_ExecCoordinatorHeading-CreditsText_Part2
                dc.w    LockCredits_ExecCoordShigeta-CreditsText_Part2
                dc.w    LockCredits_ExecCoordTakami-CreditsText_Part2
                dc.w    LockCredits_ExecCoordFornasier-CreditsText_Part2
                dc.w    LockCredits_ExecCoordHector-CreditsText_Part2
                dc.w    LockCredits_ExecCoordUtsunomiya-CreditsText_Part2
                dc.w    SKCreditsLockonClosing_TestersHeading-CreditsText_Part2
                dc.w    SKCreditsLockonClosing_TesterJasonKuo-CreditsText_Part2
                dc.w    SKCreditsLockonClosing_TesterRickGreer-CreditsText_Part2
                dc.w    LockCredits_TesterWilliams-CreditsText_Part2
                dc.w    LockCredits_SoundThanksHeading-CreditsText_Part2
                dc.w    LockCredits_SoundThanksNinaSakazaki-CreditsText_Part2
                dc.w    SKCreditsLockonClosing_SoundThanksMrm-CreditsText_Part2
                dc.w    LockCredits_SoundThanksCubeCorp-CreditsText_Part2
                dc.w    LockCredits_SoundThanksOpusCorp-CreditsText_Part2
                dc.w    LockCredits_SoundThanksNakayama-CreditsText_Part2
                dc.w    LockCredits_SoundThanksStudioWho-CreditsText_Part2
                dc.w    LockCredits_SpecialThanksHeading-CreditsText_Part2
                dc.w    LockCredits_SpecialThanksIshiwatari-CreditsText_Part2
                dc.w    LockCredits_SpecialThanksKawamura-CreditsText_Part2
                dc.w    LockCredits_SpecialThanksMcCracken-CreditsText_Part2
                dc.w    LockCredits_SpecialThanksMakino-CreditsText_Part2
                dc.w    LockCredits_PresentedByHeading-CreditsText_Part2
                dc.w    SKCreditsLockonClosing_PresentedBySega-CreditsText_Part2
                dc.w    SKCreditsLockonClosing_TrailingBlankLine-CreditsText_Part2
                dc.w    LockCredits_FinishStream-CreditsText_Part2
LockCredits_ComposersHeading:   dc.b    2
                dc.b    $D
                dc.b    "MUSIC COMPOSERS",0
                even
LockCredits_ComposerBuxer:  dc.b    4
                dc.b    $16
                dc.b    "BRAD BUXER",0
                even
LockCredits_ComposerBrooks: dc.b    5
                dc.b    $12
                dc.b    "BOBBY BROOKS",0
                even
LockCredits_ComposerRoss:   dc.b    6
                dc.b    $14
                dc.b    "DARRYL ROSS",0
                even
LockCredits_ComposerGrace:  dc.b    7
                dc.b    $14
                dc.b    "GEOFF GRACE",0
                even
LockCredits_ComposerGrigsby:    dc.b    8
                dc.b    $E
                dc.b    "DOUG GRIGSBY III",0
                even
LockCredits_ComposerScirocco:   dc.b    9
                dc.b    $1A
                dc.b    "SCIROCCO",0
                even
LockCredits_ComposerDrossin:    dc.b    $A
                dc.b    $E
                dc.b    "HOWARD DROSSIN",0
                even
LockCredits_SegaSoundHeading:   dc.b    $1A
                dc.b    $D
                dc.b    "SEGA SOUND TEAM",0
                even
SKCreditsLockonClosing_SoundTeamBo: dc.b    $1C
                dc.b    $24
                dc.b    "BO",0
                even
LockCredits_SoundOgawa: dc.b    $1D
                dc.b    $12
                dc.b    "SACHIO OGAWA",0
                even
SKCreditsLockonClosing_SoundTeamMilpo:  dc.b    $1E
                dc.b    $20
                dc.b    "MILPO",0
                even
LockCredits_SoundSetsumaru: dc.b    $1F
                dc.b    $A
                dc.b    "MASARU SETSUMARU",0
                even
LockCredits_SoundMaeda: dc.b    $20
                dc.b    $C
                dc.b    "TATSUYUKI MAEDA",0
                even
LockCredits_SoundSawada:    dc.b    $21
                dc.b    $C
                dc.b    "TOMONORI SAWADA",0
                even
LockCredits_SoundNagao: dc.b    $22
                dc.b    $E
                dc.b    "MASAYUKI NAGAO",0
                even
LockCredits_SoundSenoue:    dc.b    $23
                dc.b    $16
                dc.b    "JUN SENOUE",0
                even
LockCredits_SoundCoordinatorHeading:    dc.b    $33
                dc.b    9
                dc.b    "SOUND COORDINATOR",0
                even
LockCredits_SoundCoordinatorNimiya: dc.b    $35
                dc.b    $14
                dc.b    "HISAKI NIMIYA",0
                even
LockCredits_ExecManagementHeading:  dc.b    $45
                dc.b    3
                dc.b    "EXECUTIVE MANAGEMENT",0
                even
LockCredits_ExecManagementIrimajiri:    dc.b    $47
                dc.b    6
                dc.b    "SHOUICHIROU IRIMAJIRI",0
                even
LockCredits_ExecManagementKalinske: dc.b    $48
                dc.b    $12
                dc.b    "TOM KALINSKE",0
                even
LockCredits_ExecManagementRioux:    dc.b    $49
                dc.b    $16
                dc.b    "PAUL RIOUX",0
                even
LockCredits_ProductManagerHeading:  dc.b    $59
                dc.b    $D
                dc.b    "PRODUCT MANAGER",0
                even
LockCredits_ProductManagerKelly:    dc.b    $5B
                dc.b    $12
                dc.b    "PAMELA KELLY",0
                even
LockCredits_ExecCoordinatorHeading: dc.b    $6B
                dc.b    3
                dc.b    "EXECUTIVE COORDINATOR",0
                even
LockCredits_ExecCoordShigeta:   dc.b    $6D
                dc.b    $E
                dc.b    "MAMORU SHIGETA",0
                even
LockCredits_ExecCoordTakami:    dc.b    $6E
                dc.b    $14
                dc.b    "TOMIO TAKAMI",0
                even
LockCredits_ExecCoordFornasier: dc.b    $6F
                dc.b    $A
                dc.b    "DIANE A. FORNASIER ",0
                even
LockCredits_ExecCoordHector:    dc.b    $70
                dc.b    $12
                dc.b    "ROGER HECTOR",0
                even
LockCredits_ExecCoordUtsunomiya:    dc.b    $71
                dc.b    4
                dc.b    "TAKAHARU UTSUNOMIYA",0
                even
SKCreditsLockonClosing_TestersHeading:  dc.b    $81
                dc.b    $1B
                dc.b    "TESTERS",0
                even
SKCreditsLockonClosing_TesterJasonKuo:  dc.b    $83
                dc.b    $16
                dc.b    "JASON KUO",0
                even
SKCreditsLockonClosing_TesterRickGreer: dc.b    $84
                dc.b    $16
                dc.b    "RICK GREER",0
                even
LockCredits_TesterWilliams: dc.b    $85
                dc.b    $12
                dc.b    "MIKE WILLIAMS",0
                even
LockCredits_SoundThanksHeading: dc.b    $95
                dc.b    5
                dc.b    "SOUND SPECIAL THANKS",0
                even
LockCredits_SoundThanksNinaSakazaki:    dc.b    $97
                dc.b    6
                dc.b    "MAYUMI NINA SAKAZAKI",0
                even
SKCreditsLockonClosing_SoundThanksMrm:  dc.b    $98
                dc.b    $20
                dc.b    "(MRM)",0
                even
LockCredits_SoundThanksCubeCorp:    dc.b    $99
                dc.b    $16
                dc.b    "CUBE CORP.",0
                even
LockCredits_SoundThanksOpusCorp:    dc.b    $9A
                dc.b    $16
                dc.b    "OPUS CORP.",0
                even
LockCredits_SoundThanksNakayama:    dc.b    $9B
                dc.b    8
                dc.b    "MASANORI NAKAYAMA",0
                even
LockCredits_SoundThanksStudioWho:   dc.b    $9C
                dc.b    $14
                dc.b    "(STUDIO WHO)",0
                even
LockCredits_SpecialThanksHeading:   dc.b    $AC
                dc.b    $F
                dc.b    "SPECIAL THANKS",0
                even
LockCredits_SpecialThanksIshiwatari:    dc.b    $AE
                dc.b    $10
                dc.b    "JINA ISHIWATARI",0
                even
LockCredits_SpecialThanksKawamura:  dc.b    $AF
                dc.b    $12
                dc.b    "EMI KAWAMURA",0
                even
LockCredits_SpecialThanksMcCracken: dc.b    $B0
                dc.b    8
                dc.b    "DEBORAH MCCRACKEN",0
                even
LockCredits_SpecialThanksMakino:    dc.b    $B1
                dc.b    $14
                dc.b    "TAKU MAKINO",0
                even
LockCredits_PresentedByHeading: dc.b    $C5
                dc.b    $13
                dc.b    "PRESENTED BY",0
                even
SKCreditsLockonClosing_PresentedBySega: dc.b    $C7
                dc.b    $20
                dc.b    "SEGA",0
                even
SKCreditsLockonClosing_TrailingBlankLine:   dc.b    $D7
                dc.b    $20
                dc.b    "  ",0
                even
LockCredits_FinishStream:   dc.b    $FF
                dc.b    $F4
