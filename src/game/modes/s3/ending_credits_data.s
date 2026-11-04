; Owner: game/modes/s3
; Responsibility: Ending credit text, plane maps, palettes, animation records and checked art resources
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------
S3CreditsText_TryAgain:
                dc.w    1-1
                dc.w    $996
                dc.b    "TRY  AGAIN",0
                even
S3CreditsText_Main:
                dc.w    S3CreditsPage_SonicThreeStaff-S3CreditsText_Main
                dc.w    S3CreditsPage_ExecProducerNakayama-S3CreditsText_Main
                dc.w    S3CreditsPage_ProjectManagerSuzuki-S3CreditsText_Main
                dc.w    S3CreditsPage_ProjectManagerToyoda-S3CreditsText_Main
                dc.w    S3CreditsPage_ProjectManagerYoshii-S3CreditsText_Main
                dc.w    S3CreditsPage_ProducerYujiNaka-S3CreditsText_Main
                dc.w    S3CreditsPage_DirectorHirokazuYasuhara-S3CreditsText_Main
                dc.w    S3CreditsPage_LeadDesignerYasuhara-S3CreditsText_Main
                dc.w    S3CreditsPage_SeniorGameDesigners-S3CreditsText_Main
                dc.w    S3CreditsPage_LeadProgrammerYujiNaka-S3CreditsText_Main
                dc.w    S3CreditsPage_SeniorProgrammers-S3CreditsText_Main
                dc.w    S3CreditsPage_CharacterDesignerYuda-S3CreditsText_Main
                dc.w    S3CreditsPage_CgArtistKunitakeAoki-S3CreditsText_Main
                dc.w    S3CreditsPage_AnimatorTakashiThomasYuda-S3CreditsText_Main
                dc.w    S3CreditsPage_EnemyArtistSatoshiYokokawa-S3CreditsText_Main
                dc.w    S3CreditsPage_SceneArtistsKAokiYoshida-S3CreditsText_Main
                dc.w    S3CreditsPage_SceneArtistsTAokiOkada-S3CreditsText_Main
                dc.w    S3CreditsPage_SceneArtistsYudaYokokawa-S3CreditsText_Main
                dc.w    S3CreditsPage_ArtAssistantOsamuOhashi-S3CreditsText_Main
                dc.w    S3CreditsPage_ComposersBuxerBrooks-S3CreditsText_Main
                dc.w    S3CreditsPage_ComposersRossGrace-S3CreditsText_Main
                dc.w    S3CreditsPage_ComposersGrigsbyScirocco-S3CreditsText_Main
                dc.w    S3CreditsPage_SegaSoundTeamBoSachioOgawa-S3CreditsText_Main
                dc.w    S3CreditsPage_SoundMilpoSetsumaru-S3CreditsText_Main
                dc.w    S3CreditsPage_SoundMaedaSawada-S3CreditsText_Main
                dc.w    S3CreditsPage_SoundNagaoSenoue-S3CreditsText_Main
                dc.w    S3CreditsPage_SoundCoordinatorNimiya-S3CreditsText_Main
                dc.w    S3CreditsPage_MarketingPamelaKelly-S3CreditsText_Main
                dc.w    S3CreditsPage_ExecutiveManagement-S3CreditsText_Main
                dc.w    S3CreditsPage_ExecCoordShigetaTakami-S3CreditsText_Main
                dc.w    S3CreditsPage_ExecCoordFornasierHector-S3CreditsText_Main
                dc.w    S3CreditsPage_ExecCoordUtsunomiya-S3CreditsText_Main
                dc.w    S3CreditsPage_SoundThanksNinaSakazaki-S3CreditsText_Main
                dc.w    S3CreditsPage_SoundThanksCubeOpus-S3CreditsText_Main
                dc.w    S3CreditsPage_ThanksNakayamaStudioWho-S3CreditsText_Main
                dc.w    S3CreditsPage_SoundThanksHowardDrossin-S3CreditsText_Main
                dc.w    S3CreditsPage_SpecialThanksMcCrackenEmi-S3CreditsText_Main
                dc.w    S3CreditsPage_SpecialThanksIshiwatari-S3CreditsText_Main
                dc.w    S3CreditsPage_PresentedBySega-S3CreditsText_Main
                dc.w    0
S3CreditsPage_SonicThreeStaff:  dc.w    2-1
                dc.w    $598
                dc.b    "SONIC  III",0
                even
                dc.w    $8A2
                dc.b    "staff",0
                even
S3CreditsPage_ExecProducerNakayama: dc.w    2-1
                dc.w    $48E
                dc.b    "    executive producer",0
                even
                dc.w    $78A
                dc.b    "HAYAO  NAKAYAMA",0
                even
S3CreditsPage_ProjectManagerSuzuki: dc.w    2-1
                dc.w    $490
                dc.b    "    project manager",0
                even
                dc.w    $78E
                dc.b    "HISASHI  SUZUKI",0
                even
S3CreditsPage_ProjectManagerToyoda: dc.w    2-1
                dc.w    $490
                dc.b    "    project manager",0
                even
                dc.w    $78A
                dc.b    "SHINOBU  TOYODA",0
                even
S3CreditsPage_ProjectManagerYoshii: dc.w    2-1
                dc.w    $490
                dc.b    "    project manager",0
                even
                dc.w    $78A
                dc.b    "MASAHARU  YOSHII",0
                even
S3CreditsPage_ProducerYujiNaka: dc.w    2-1
                dc.w    $4A0
                dc.b    "producer",0
                even
                dc.w    $798
                dc.b    "YUJ I  NAKA",0
                even
S3CreditsPage_DirectorHirokazuYasuhara: dc.w    2-1
                dc.w    $498
                dc.b    "    director",0
                even
                dc.w    $786
                dc.b    "HIROKAZU  YASUHARA",0
                even
S3CreditsPage_LeadDesignerYasuhara: dc.w    2-1
                dc.w    $48C
                dc.b    "     lead game designer",0
                even
                dc.w    $786
                dc.b    "HIROKAZU  YASUHARA",0
                even
S3CreditsPage_SeniorGameDesigners:  dc.w    3-1
                dc.w    $48A
                dc.b    "    senior game designers",0
                even
                dc.w    $688
                dc.b    "HISAYOSHI YOSHIDA",0
                even
                dc.w    $990
                dc.b    "TAKASHI  IIZUKA",0
                even
S3CreditsPage_LeadProgrammerYujiNaka:   dc.w    2-1
                dc.w    $498
                dc.b    "lead programmer",0
                even
                dc.w    $796
                dc.b    "YUJ I  NAKA",0
                even
S3CreditsPage_SeniorProgrammers:    dc.w    3-1
                dc.w    $48E
                dc.b    "    senior programmers",0
                even
                dc.w    $688
                dc.b    "HIROSHI NIKAIDOH",0
                even
                dc.w    $980
                dc.b    "MASANOBU YAMAMOTO",0
                even
S3CreditsPage_CharacterDesignerYuda:    dc.w    2-1
                dc.w    $496
                dc.b    "character designer",0
                even
                dc.w    $784
                dc.b    "TAKASHI THOMAS YUDA",0
                even
S3CreditsPage_CgArtistKunitakeAoki: dc.w    2-1
                dc.w    $496
                dc.b    "    cg  artist",0
                even
                dc.w    $78E
                dc.b    "KUNITAKE   AOKI",0
                even
S3CreditsPage_AnimatorTakashiThomasYuda:    dc.w    2-1
                dc.w    $4A0
                dc.b    "animator",0
                even
                dc.w    $784
                dc.b    "TAKASHI THOMAS YUDA",0
                even
S3CreditsPage_EnemyArtistSatoshiYokokawa:   dc.w    2-1
                dc.w    $49A
                dc.b    "enemy artist",0
                even
                dc.w    $786
                dc.b    "SATOSHI YOKOKAWA",0
                even
S3CreditsPage_SceneArtistsKAokiYoshida: dc.w    3-1
                dc.w    $498
                dc.b    "scene artists",0
                even
                dc.w    $690
                dc.b    "KUNITAKE  AOKI",0
                even
                dc.w    $992
                dc.b    "CHIE YOSHIDA",0
                even
S3CreditsPage_SceneArtistsTAokiOkada:   dc.w    3-1
                dc.w    $49A
                dc.b    "scene artists",0
                even
                dc.w    $690
                dc.b    "TSUNEKO  AOKI",0
                even
                dc.w    $990
                dc.b    "SHIGERU  OKADA",0
                even
S3CreditsPage_SceneArtistsYudaYokokawa: dc.w    3-1
                dc.w    $49A
                dc.b    "scene artists",0
                even
                dc.w    $684
                dc.b    "TAKASHI THOMAS YUDA",0
                even
                dc.w    $986
                dc.b    "SATOSHI YOKOKAWA",0
                even
S3CreditsPage_ArtAssistantOsamuOhashi:  dc.w    2-1
                dc.w    $498
                dc.b    "art assistant",0
                even
                dc.w    $78E
                dc.b    "OSAMU  OHASHI",0
                even
S3CreditsPage_ComposersBuxerBrooks: dc.w    3-1
                dc.w    $498
                dc.b    "music composers",0
                even
                dc.w    $694
                dc.b    "BRAD  BUXER",0
                even
                dc.w    $98E
                dc.b    "BOBBY BROOKS",0
                even
S3CreditsPage_ComposersRossGrace:   dc.w    3-1
                dc.w    $498
                dc.b    "music composers",0
                even
                dc.w    $692
                dc.b    "DARRYL  ROSS",0
                even
                dc.w    $992
                dc.b    "GEOFF GRACE",0
                even
S3CreditsPage_ComposersGrigsbyScirocco: dc.w    3-1
                dc.w    $498
                dc.b    "music composers",0
                even
                dc.w    $68C
                dc.b    "DOUG  GRIGSBY III",0
                even
                dc.w    $996
                dc.b    "SCIROCCO",0
                even
S3CreditsPage_SegaSoundTeamBoSachioOgawa:   dc.w    3-1
                dc.w    $498
                dc.b    "sega sound team",0
                even
                dc.w    $6A2
                dc.b    "BO",0
                even
                dc.w    $98E
                dc.b    "SACHIO  OGAWA",0
                even
S3CreditsPage_SoundMilpoSetsumaru:  dc.w    3-1
                dc.w    $498
                dc.b    "sega sound team",0
                even
                dc.w    $69C
                dc.b    "MILPO",0
                even
                dc.w    $986
                dc.b    "MASARU  SETSUMARU",0
                even
S3CreditsPage_SoundMaedaSawada: dc.w    3-1
                dc.w    $498
                dc.b    "sega sound team",0
                even
                dc.w    $68A
                dc.b    "TATSUYUKI  MAEDA",0
                even
                dc.w    $986
                dc.b    "TOMONORI  SAWADA",0
                even
S3CreditsPage_SoundNagaoSenoue: dc.w    3-1
                dc.w    $498
                dc.b    "sega sound team",0
                even
                dc.w    $68C
                dc.b    "MASAYUKI NAGAO",0
                even
                dc.w    $994
                dc.b    "J UN SENOUE",0
                even
S3CreditsPage_SoundCoordinatorNimiya:   dc.w    2-1
                dc.w    $490
                dc.b    "sound project coordinator",0
                even
                dc.w    $78A
                dc.b    "    HISAKI  NIMIYA",0
                even
S3CreditsPage_MarketingPamelaKelly: dc.w    2-1
                dc.w    $490
                dc.b    "       marketing      ",0
                even
                dc.w    $78A
                dc.b    "    PAMELA  KELLY",0
                even
S3CreditsPage_ExecutiveManagement:  dc.w    3-1
                dc.w    $490
                dc.b    " executive management ",0
                even
                dc.w    $680
                dc.b    " SHOUICHIROU IRIMAJ IRI",0
                even
                dc.w    $98A
                dc.b    "  TOM  KAL INSKE  ",0
                even
S3CreditsPage_ExecCoordShigetaTakami:   dc.w    3-1
                dc.w    $490
                dc.b    " executive coordinator",0
                even
                dc.w    $680
                dc.b    "     MAMORU  SHIGETA    ",0
                even
                dc.w    $98A
                dc.b    "  TOMIO  TAKAMI  ",0
                even
S3CreditsPage_ExecCoordFornasierHector: dc.w    3-1
                dc.w    $490
                dc.b    " executive coordinator",0
                even
                dc.w    $680
                dc.b    "    DIANE  A  FORNASIER   ",0
                even
                dc.w    $980
                dc.b    "       ROGER  HECTOR      ",0
                even
S3CreditsPage_ExecCoordUtsunomiya:  dc.w    2-1
                dc.w    $490
                dc.b    " executive coordinator",0
                even
                dc.w    $780
                dc.b    " TAKAHARU  UTSUNOMIYA",0
                even
S3CreditsPage_SoundThanksNinaSakazaki:  dc.w    3-1
                dc.w    $490
                dc.b    " sound special thanks ",0
                even
                dc.w    $680
                dc.b    " MAYUMI NINA SAKAZAKI",0
                even
                dc.w    $98A
                dc.b    "        (MRM)",0
                even
S3CreditsPage_SoundThanksCubeOpus:  dc.w    3-1
                dc.w    $490
                dc.b    " sound special thanks ",0
                even
                dc.w    $680
                dc.b    "         CUBE  CORP.   ",0
                even
                dc.w    $980
                dc.b    "         OPUS CORP.   ",0
                even
S3CreditsPage_ThanksNakayamaStudioWho:  dc.w    3-1
                dc.w    $490
                dc.b    " sound special thanks ",0
                even
                dc.w    $680
                dc.b    "  MASANORI  NAKAYAMA",0
                even
                dc.w    $980
                dc.b    "       (STUDIO WHO) ",0
                even
S3CreditsPage_SoundThanksHowardDrossin: dc.w    2-1
                dc.w    $490
                dc.b    " sound special thanks ",0
                even
                dc.w    $780
                dc.b    "     HOWARD  DROSSIN",0
                even
S3CreditsPage_SpecialThanksMcCrackenEmi:    dc.w    3-1
                dc.w    $490
                dc.b    "    special thanks    ",0
                even
                dc.w    $680
                dc.b    "   DEBORAH MCCRACKEN  ",0
                even
                dc.w    $980
                dc.b    "       EMI  KAWAMURA  ",0
                even
S3CreditsPage_SpecialThanksIshiwatari:  dc.w    2-1
                dc.w    $490
                dc.b    "    special thanks    ",0
                even
                dc.w    $780
                dc.b    "       J INA  ISHIWATARI",0
                even
S3CreditsPage_PresentedBySega:  dc.w    2-1
                dc.w    $490
                dc.b    "     presented by",0
                even
                dc.w    $78A
                dc.b    "          SEGA           ",0
                even
S3CreditsText_Dummy:
                dc.w    S3CreditsDummyPage_LetterA-S3CreditsText_Dummy
                dc.w    S3CreditsDummyPage_LetterB-S3CreditsText_Dummy
                dc.w    S3CreditsDummyPage_LetterC-S3CreditsText_Dummy
                dc.w    S3CreditsDummyPage_LetterD-S3CreditsText_Dummy
                dc.w    S3CreditsDummyPage_LetterE-S3CreditsText_Dummy
                dc.w    S3CreditsDummyPage_LetterF-S3CreditsText_Dummy
                dc.w    0
S3CreditsDummyPage_LetterA: dc.w    2-1
                dc.w    $1310
                dc.b    "a",0
                even
                dc.w    $1710
                dc.b    "A",0
                even
S3CreditsDummyPage_LetterB: dc.w    2-1
                dc.w    $1310
                dc.b    "b",0
                even
                dc.w    $1710
                dc.b    "B",0
                even
S3CreditsDummyPage_LetterC: dc.w    2-1
                dc.w    $1310
                dc.b    "c",0
                even
                dc.w    $1710
                dc.b    "C",0
                even
S3CreditsDummyPage_LetterD: dc.w    2-1
                dc.w    $310
                dc.b    "d",0
                even
                dc.w    $710
                dc.b    "D",0
                even
S3CreditsDummyPage_LetterE: dc.w    2-1
                dc.w    $1310
                dc.b    "e",0
                even
                dc.w    $1710
                dc.b    "E",0
                even
S3CreditsDummyPage_LetterF: dc.w    2-1
                dc.w    $310
                dc.b    "f",0
                even
                dc.w    $710
                dc.b    "F",0
                even
S3Credits_PlaneMapSmall:
                dc.w    make_art_tile(ArtTile_S3Fonts_SmallText,0,0),     make_art_tile(ArtTile_S3Fonts_SmallText+1,0,0)  ; a
                dc.w    make_art_tile(ArtTile_S3Fonts_SmallText+2,0,0),   make_art_tile(ArtTile_S3Fonts_SmallText+3,0,0)  ; b
                dc.w    make_art_tile(ArtTile_S3Fonts_SmallText+4,0,0),   make_art_tile(ArtTile_S3Fonts_SmallText+5,0,0)  ; c
                dc.w    make_art_tile(ArtTile_S3Fonts_SmallText+6,0,0),   make_art_tile(ArtTile_S3Fonts_SmallText+7,0,0)  ; d
                dc.w    make_art_tile(ArtTile_S3Fonts_SmallText+8,0,0),   make_art_tile(ArtTile_S3Fonts_SmallText+9,0,0)  ; e
                dc.w    make_art_tile(ArtTile_S3Fonts_SmallText+8,0,0),   make_art_tile(ArtTile_S3Fonts_SmallText+$A,0,0)  ; f
                dc.w    make_art_tile(ArtTile_S3Fonts_SmallText+$B,0,0),  make_art_tile(ArtTile_S3Fonts_SmallText+5,0,0)  ; g
                dc.w    make_art_tile(ArtTile_S3Fonts_SmallText+$C,0,0),  make_art_tile(ArtTile_S3Fonts_SmallText+1,0,0)  ; h
                dc.w    make_art_tile(ArtTile_S3Fonts_SmallText+$D,0,0),  make_art_tile(ArtTile_S3Fonts_SmallText+$E,0,0)  ; i
                dc.w    make_art_tile(ArtTile_S3Fonts_SmallText+$F,0,0),  make_art_tile(ArtTile_S3Fonts_SmallText+5,0,0)  ; j
                dc.w    make_art_tile(ArtTile_S3Fonts_SmallText+$10,0,0), make_art_tile(ArtTile_S3Fonts_SmallText+$11,0,0)  ; k
                dc.w    make_art_tile(ArtTile_S3Fonts_SmallText+$12,0,0), make_art_tile(ArtTile_S3Fonts_SmallText+$13,0,0)  ; l
                dc.w    make_art_tile(ArtTile_S3Fonts_SmallText+$14,0,0), make_art_tile(ArtTile_S3Fonts_SmallText+$15,0,0)  ; m
                dc.w    make_art_tile(ArtTile_S3Fonts_SmallText+$16,0,0), make_art_tile(ArtTile_S3Fonts_SmallText+$17,0,0)  ; n
                dc.w    make_art_tile(ArtTile_S3Fonts_SmallText+$18,0,0), make_art_tile(ArtTile_S3Fonts_SmallText+5,0,0)  ; o
                dc.w    make_art_tile(ArtTile_S3Fonts_SmallText+$19,0,0), make_art_tile(ArtTile_S3Fonts_SmallText+$A,0,0)  ; p
                dc.w    make_art_tile(ArtTile_S3Fonts_SmallText+$1A,0,0), make_art_tile(ArtTile_S3Fonts_SmallText+$1B,0,0)  ; q
                dc.w    make_art_tile(ArtTile_S3Fonts_SmallText+2,0,0),   make_art_tile(ArtTile_S3Fonts_SmallText+1,0,0)  ; r
                dc.w    make_art_tile(ArtTile_S3Fonts_SmallText+$1C,0,0), make_art_tile(ArtTile_S3Fonts_SmallText+5,0,0)  ; s
                dc.w    make_art_tile(ArtTile_S3Fonts_SmallText+$1D,0,0), make_art_tile(ArtTile_S3Fonts_SmallText+$E,0,0)  ; t
                dc.w    make_art_tile(ArtTile_S3Fonts_SmallText+$1E,0,0), make_art_tile(ArtTile_S3Fonts_SmallText+5,0,0)  ; u
                dc.w    make_art_tile(ArtTile_S3Fonts_SmallText+$1E,0,0), make_art_tile(ArtTile_S3Fonts_SmallText+$1F,0,0)  ; v
                dc.w    make_art_tile(ArtTile_S3Fonts_SmallText+$20,0,0), make_art_tile(ArtTile_S3Fonts_SmallText+$21,0,0)  ; w
                dc.w    make_art_tile(ArtTile_S3Fonts_SmallText+$22,0,0), make_art_tile(ArtTile_S3Fonts_SmallText+$17,0,0)  ; x
                dc.w    make_art_tile(ArtTile_S3Fonts_SmallText+$23,0,0), make_art_tile(ArtTile_S3Fonts_SmallText+$E,0,0)  ; y
                dc.w    make_art_tile(ArtTile_S3Fonts_SmallText+$24,0,0), make_art_tile(ArtTile_S3Fonts_SmallText+$25,0,0)  ; z
S3Credits_PlaneMapLarge:
                dc.w    S3CreditsLargeGlyph_A-S3Credits_PlaneMapLarge  ; A
                dc.w    S3CreditsLargeGlyph_B-S3Credits_PlaneMapLarge  ; B
                dc.w    S3CreditsLargeGlyph_C-S3Credits_PlaneMapLarge  ; C
                dc.w    S3CreditsLargeGlyph_D-S3Credits_PlaneMapLarge  ; D
                dc.w    S3CreditsLargeGlyph_E-S3Credits_PlaneMapLarge  ; E
                dc.w    S3CreditsLargeGlyph_F-S3Credits_PlaneMapLarge  ; F
                dc.w    S3CreditsLargeGlyph_G-S3Credits_PlaneMapLarge  ; G
                dc.w    S3CreditsLargeGlyph_H-S3Credits_PlaneMapLarge  ; H
                dc.w    S3CreditsLargeGlyph_I-S3Credits_PlaneMapLarge  ; I
                dc.w    S3CreditsLargeGlyph_J-S3Credits_PlaneMapLarge  ; J
                dc.w    S3CreditsLargeGlyph_K-S3Credits_PlaneMapLarge  ; K
                dc.w    S3CreditsLargeGlyph_L-S3Credits_PlaneMapLarge  ; L
                dc.w    S3CreditsLargeGlyph_M-S3Credits_PlaneMapLarge  ; M
                dc.w    S3CreditsLargeGlyph_N-S3Credits_PlaneMapLarge  ; N
                dc.w    S3CreditsLargeGlyph_O-S3Credits_PlaneMapLarge  ; O
                dc.w    S3CreditsLargeGlyph_P-S3Credits_PlaneMapLarge  ; P
                dc.w    S3CreditsLargeGlyph_Q-S3Credits_PlaneMapLarge  ; Q
                dc.w    S3CreditsLargeGlyph_R-S3Credits_PlaneMapLarge  ; R
                dc.w    S3CreditsLargeGlyph_S-S3Credits_PlaneMapLarge  ; S
                dc.w    S3CreditsLargeGlyph_T-S3Credits_PlaneMapLarge  ; T
                dc.w    S3CreditsLargeGlyph_U-S3Credits_PlaneMapLarge  ; U
                dc.w    S3CreditsLargeGlyph_V-S3Credits_PlaneMapLarge  ; V
                dc.w    S3CreditsLargeGlyph_W-S3Credits_PlaneMapLarge  ; W
                dc.w    S3CreditsLargeGlyph_X-S3Credits_PlaneMapLarge  ; X
                dc.w    S3CreditsLargeGlyph_Y-S3Credits_PlaneMapLarge  ; Y
                dc.w    S3CreditsLargeGlyph_Z-S3Credits_PlaneMapLarge  ; Z
                dc.w    S3CreditsLargeGlyph_Period-S3Credits_PlaneMapLarge  ;
                dc.w    S3CreditsLargeGlyph_LeftParenthesis-S3Credits_PlaneMapLarge  ; (
                dc.w    S3CreditsLargeGlyph_RightParenthesis-S3Credits_PlaneMapLarge  ; )
                dc.w    S3CreditsLargeGlyph_Space-S3Credits_PlaneMapLarge  ; space
S3CreditsLargeGlyph_A:  dc.w    2-1
                dc.w    make_art_tile(ArtTile_S3Fonts_BigText,1,0),           make_art_tile(ArtTile_S3Fonts_BigText+1,1,0),         make_art_tile(ArtTile_S3Fonts_BigText+2,1,0)
                dc.w    make_art_tile(ArtTile_S3Fonts_BigText+3,1,0),         make_art_tile(ArtTile_S3Fonts_BigText+4,1,0),         make_art_tile(ArtTile_S3Fonts_BigText+3,1,0)
S3CreditsLargeGlyph_B:  dc.w    2-1
                dc.w    make_art_tile(ArtTile_S3Fonts_BigText+5,1,0),         make_art_tile(ArtTile_S3Fonts_BigText+6,1,0),         make_art_tile(ArtTile_S3Fonts_BigText+7,1,0)
                dc.w    make_art_tile(ArtTile_S3Fonts_BigText+8,1,0),         make_art_tile(ArtTile_S3Fonts_BigText+9,1,0),         make_art_tile(ArtTile_S3Fonts_BigText+$A,1,0)
S3CreditsLargeGlyph_C:  dc.w    2-1
                dc.w    make_art_tile(ArtTile_S3Fonts_BigText+$B,1,0),        make_art_tile(ArtTile_S3Fonts_BigText+$C,1,0),        make_art_tile(ArtTile_S3Fonts_BigText+$D,1,0)
                dc.w    make_art_tile(ArtTile_S3Fonts_BigText+$E,1,0),        make_art_tile(ArtTile_S3Fonts_BigText+$F,1,0),        make_art_tile(ArtTile_S3Fonts_BigText+$10,1,0)
S3CreditsLargeGlyph_D:  dc.w    2-1
                dc.w    make_art_tile(ArtTile_S3Fonts_BigText+$11,1,0),       make_art_tile(ArtTile_S3Fonts_BigText+$B,1,0)|$800,   make_art_tile(ArtTile_S3Fonts_BigText+$12,1,0)
                dc.w    make_art_tile(ArtTile_S3Fonts_BigText+$D,1,0)|$800,   make_art_tile(ArtTile_S3Fonts_BigText+$13,1,0),       make_art_tile(ArtTile_S3Fonts_BigText+$F,1,0)|$800
S3CreditsLargeGlyph_E:  dc.w    2-1
                dc.w    make_art_tile(ArtTile_S3Fonts_BigText+$14,1,0),       make_art_tile(ArtTile_S3Fonts_BigText+$15,1,0),       make_art_tile(ArtTile_S3Fonts_BigText+4,1,0)
                dc.w    make_art_tile(ArtTile_S3Fonts_BigText+$E,1,0),        make_art_tile(ArtTile_S3Fonts_BigText+$16,1,0),       make_art_tile(ArtTile_S3Fonts_BigText+$17,1,0)
S3CreditsLargeGlyph_F:  dc.w    2-1
                dc.w    make_art_tile(ArtTile_S3Fonts_BigText+$14,1,0),       make_art_tile(ArtTile_S3Fonts_BigText+$15,1,0),       make_art_tile(ArtTile_S3Fonts_BigText+4,1,0)
                dc.w    make_art_tile(ArtTile_S3Fonts_BigText+$E,1,0),        make_art_tile(ArtTile_S3Fonts_BigText+4,1,0),         make_art_tile(ArtTile_S3Fonts_BigText+$E,1,0)
S3CreditsLargeGlyph_G:  dc.w    2-1
                dc.w    make_art_tile(ArtTile_S3Fonts_BigText+$18,1,0),       make_art_tile(ArtTile_S3Fonts_BigText+$19,1,0),       make_art_tile(ArtTile_S3Fonts_BigText+$1A,1,0)
                dc.w    make_art_tile(ArtTile_S3Fonts_BigText+4,1,0),         make_art_tile(ArtTile_S3Fonts_BigText+$1B,1,0),       make_art_tile(ArtTile_S3Fonts_BigText+$1C,1,0)
S3CreditsLargeGlyph_H:  dc.w    2-1
                dc.w    make_art_tile(ArtTile_S3Fonts_BigText+$1D,1,0),       make_art_tile(ArtTile_S3Fonts_BigText+$1E,1,0),       make_art_tile(ArtTile_S3Fonts_BigText+4,1,0)
                dc.w    make_art_tile(ArtTile_S3Fonts_BigText+3,1,0),         make_art_tile(ArtTile_S3Fonts_BigText+4,1,0),         make_art_tile(ArtTile_S3Fonts_BigText+3,1,0)
S3CreditsLargeGlyph_I:  dc.w    1-1
                dc.w    make_art_tile(ArtTile_S3Fonts_BigText+$1F,1,0),       make_art_tile(ArtTile_S3Fonts_BigText+$12,1,0),       make_art_tile(ArtTile_S3Fonts_BigText+$12,1,0)
S3CreditsLargeGlyph_J:  dc.w    1-1
                dc.w    make_art_tile(ArtTile_S3Fonts_BigText+$20,1,0),       make_art_tile(ArtTile_S3Fonts_BigText+3,1,0)|$800,    make_art_tile(ArtTile_S3Fonts_BigText+$21,1,0)
S3CreditsLargeGlyph_K:  dc.w    2-1
                dc.w    make_art_tile(ArtTile_S3Fonts_BigText+$22,1,0),       make_art_tile(ArtTile_S3Fonts_BigText+$23,1,0),       make_art_tile(ArtTile_S3Fonts_BigText+$24,1,0)
                dc.w    make_art_tile(ArtTile_S3Fonts_BigText+$25,1,0),       make_art_tile(ArtTile_S3Fonts_BigText+$26,1,0),       make_art_tile(ArtTile_S3Fonts_BigText+$27,1,0)
S3CreditsLargeGlyph_L:  dc.w    1-1
                dc.w    make_art_tile(ArtTile_S3Fonts_BigText+$1F,1,0),       make_art_tile(ArtTile_S3Fonts_BigText+$12,1,0),       make_art_tile(ArtTile_S3Fonts_BigText+$28,1,0)
S3CreditsLargeGlyph_M:  dc.w    3-1
                dc.w    make_art_tile(ArtTile_S3Fonts_BigText+$29,1,0),       make_art_tile(ArtTile_S3Fonts_BigText+$2A,1,0),       make_art_tile(ArtTile_S3Fonts_BigText+$2B,1,0)
                dc.w    make_art_tile(ArtTile_S3Fonts_BigText+$2C,1,0),       make_art_tile(ArtTile_S3Fonts_BigText+$2D,1,0),       make_art_tile(ArtTile_S3Fonts_BigText+$2E,1,0)
                dc.w    make_art_tile(ArtTile_S3Fonts_BigText+$2C,1,0)|$1800, make_art_tile(ArtTile_S3Fonts_BigText+$2F,1,0),       make_art_tile(ArtTile_S3Fonts_BigText+$30,1,0)
S3CreditsLargeGlyph_N:  dc.w    2-1
                dc.w    make_art_tile(ArtTile_S3Fonts_BigText+$31,1,0),       make_art_tile(ArtTile_S3Fonts_BigText+$1E,1,0),       make_art_tile(ArtTile_S3Fonts_BigText+$12,1,0)
                dc.w    make_art_tile(ArtTile_S3Fonts_BigText+3,1,0),         make_art_tile(ArtTile_S3Fonts_BigText+$12,1,0),       make_art_tile(ArtTile_S3Fonts_BigText+3,1,0)
S3CreditsLargeGlyph_O:  dc.w    3-1
                dc.w    make_art_tile(ArtTile_S3Fonts_BigText+$32,1,0),       make_art_tile(ArtTile_S3Fonts_BigText+$33,1,0),       make_art_tile(ArtTile_S3Fonts_BigText+$32,1,0)|$800
                dc.w    make_art_tile(ArtTile_S3Fonts_BigText+$1A,1,0),       make_art_tile(ArtTile_S3Fonts_BigText+$E,1,0),        make_art_tile(ArtTile_S3Fonts_BigText+$1A,1,0)|$800
                dc.w    make_art_tile(ArtTile_S3Fonts_BigText+$34,1,0),       make_art_tile(ArtTile_S3Fonts_BigText+$35,1,0),       make_art_tile(ArtTile_S3Fonts_BigText+$34,1,0)|$800
S3CreditsLargeGlyph_P:  dc.w    2-1
                dc.w    make_art_tile(ArtTile_S3Fonts_BigText+$36,1,0),       make_art_tile(ArtTile_S3Fonts_BigText+$37,1,0),       make_art_tile(ArtTile_S3Fonts_BigText+7,1,0)|$1000
                dc.w    make_art_tile(ArtTile_S3Fonts_BigText+8,1,0)|$1000,   make_art_tile(ArtTile_S3Fonts_BigText+$38,1,0),       make_art_tile(ArtTile_S3Fonts_BigText+$E,1,0)
S3CreditsLargeGlyph_Q:  dc.w    3-1
                dc.w    make_art_tile(ArtTile_S3Fonts_BigText+$32,1,0),       make_art_tile(ArtTile_S3Fonts_BigText+$33,1,0),       make_art_tile(ArtTile_S3Fonts_BigText+$32,1,0)|$800
                dc.w    make_art_tile(ArtTile_S3Fonts_BigText+$1A,1,0),       make_art_tile(ArtTile_S3Fonts_BigText+$E,1,0),        make_art_tile(ArtTile_S3Fonts_BigText+$1A,1,0)|$800
                dc.w    make_art_tile(ArtTile_S3Fonts_BigText+$34,1,0),       make_art_tile(ArtTile_S3Fonts_BigText+$39,1,0),       make_art_tile(ArtTile_S3Fonts_BigText+$3A,1,0)
S3CreditsLargeGlyph_R:  dc.w    2-1
                dc.w    make_art_tile(ArtTile_S3Fonts_BigText+$36,1,0),       make_art_tile(ArtTile_S3Fonts_BigText+$37,1,0),       make_art_tile(ArtTile_S3Fonts_BigText+7,1,0)|$1000
                dc.w    make_art_tile(ArtTile_S3Fonts_BigText+8,1,0)|$1000,   make_art_tile(ArtTile_S3Fonts_BigText+$3B,1,0),       make_art_tile(ArtTile_S3Fonts_BigText+$3C,1,0)
S3CreditsLargeGlyph_S:  dc.w    2-1
                dc.w    make_art_tile(ArtTile_S3Fonts_BigText+$3D,1,0),       make_art_tile(ArtTile_S3Fonts_BigText+$3E,1,0),       make_art_tile(ArtTile_S3Fonts_BigText+$3F,1,0)
                dc.w    make_art_tile(ArtTile_S3Fonts_BigText+$40,1,0),       make_art_tile(ArtTile_S3Fonts_BigText+$41,1,0),       make_art_tile(ArtTile_S3Fonts_BigText+$42,1,0)
S3CreditsLargeGlyph_T:  dc.w    2-1
                dc.w    make_art_tile(ArtTile_S3Fonts_BigText+$43,1,0),       make_art_tile(ArtTile_S3Fonts_BigText+$3E,1,0),       make_art_tile(ArtTile_S3Fonts_BigText+4,1,0)|$800
                dc.w    make_art_tile(ArtTile_S3Fonts_BigText+$E,1,0),        make_art_tile(ArtTile_S3Fonts_BigText+4,1,0)|$800,    make_art_tile(ArtTile_S3Fonts_BigText+$E,1,0)
S3CreditsLargeGlyph_U:  dc.w    2-1
                dc.w    make_art_tile(ArtTile_S3Fonts_BigText+$44,1,0),       make_art_tile(ArtTile_S3Fonts_BigText+$45,1,0),       make_art_tile(ArtTile_S3Fonts_BigText+$46,1,0)
                dc.w    make_art_tile(ArtTile_S3Fonts_BigText+$47,1,0),       make_art_tile(ArtTile_S3Fonts_BigText+$48,1,0),       make_art_tile(ArtTile_S3Fonts_BigText+$49,1,0)
S3CreditsLargeGlyph_V:  dc.w    2-1
                dc.w    make_art_tile(ArtTile_S3Fonts_BigText+$4A,1,0),       make_art_tile(ArtTile_S3Fonts_BigText+$4B,1,0),       make_art_tile(ArtTile_S3Fonts_BigText+$2C,1,0)|$1000
                dc.w    make_art_tile(ArtTile_S3Fonts_BigText+$4C,1,0),       make_art_tile(ArtTile_S3Fonts_BigText+$4D,1,0),       make_art_tile(ArtTile_S3Fonts_BigText+$4E,1,0)
S3CreditsLargeGlyph_W:  dc.w    3-1
                dc.w    make_art_tile(ArtTile_S3Fonts_BigText+$4A,1,0),       make_art_tile(ArtTile_S3Fonts_BigText+$4F,1,0),       make_art_tile(ArtTile_S3Fonts_BigText+$50,1,0)
                dc.w    make_art_tile(ArtTile_S3Fonts_BigText+$2C,1,0)|$1000, make_art_tile(ArtTile_S3Fonts_BigText+$2D,1,0)|$1000, make_art_tile(ArtTile_S3Fonts_BigText+$2E,1,0)|$1000
                dc.w    make_art_tile(ArtTile_S3Fonts_BigText+$4D,1,0),       make_art_tile(ArtTile_S3Fonts_BigText+$51,1,0),       make_art_tile(ArtTile_S3Fonts_BigText+$52,1,0)
S3CreditsLargeGlyph_X:  dc.w    2-1
                dc.w    make_art_tile(ArtTile_S3Fonts_BigText+$53,1,0),       make_art_tile(ArtTile_S3Fonts_BigText+$54,1,0),       make_art_tile(ArtTile_S3Fonts_BigText+$55,1,0)
                dc.w    make_art_tile(ArtTile_S3Fonts_BigText+$55,1,0)|$800,  make_art_tile(ArtTile_S3Fonts_BigText+$56,1,0),       make_art_tile(ArtTile_S3Fonts_BigText+$57,1,0)
S3CreditsLargeGlyph_Y:  dc.w    2-1
                dc.w    make_art_tile(ArtTile_S3Fonts_BigText+$58,1,0),       make_art_tile(ArtTile_S3Fonts_BigText+$59,1,0),       make_art_tile(ArtTile_S3Fonts_BigText+3,1,0)|$800
                dc.w    make_art_tile(ArtTile_S3Fonts_BigText+$E,1,0),        make_art_tile(ArtTile_S3Fonts_BigText+3,1,0)|$800,    make_art_tile(ArtTile_S3Fonts_BigText+$E,1,0)
S3CreditsLargeGlyph_Z:  dc.w    2-1
                dc.w    make_art_tile(ArtTile_S3Fonts_BigText+$5A,1,0),       make_art_tile(ArtTile_S3Fonts_BigText+$5B,1,0),       make_art_tile(ArtTile_S3Fonts_BigText+$5C,1,0)
                dc.w    make_art_tile(ArtTile_S3Fonts_BigText+$E,1,0),        make_art_tile(ArtTile_S3Fonts_BigText+$5D,1,0),       make_art_tile(ArtTile_S3Fonts_BigText+$5E,1,0)
S3CreditsLargeGlyph_Period: dc.w    1-1
                dc.w    make_art_tile(ArtTile_S3Fonts_BigText+6,1,0),         make_art_tile(ArtTile_S3Fonts_BigText+$E,1,0),        make_art_tile(ArtTile_S3Fonts_BigText+$5F,1,0)
S3CreditsLargeGlyph_LeftParenthesis:    dc.w    2-1
                dc.w    make_art_tile(ArtTile_S3Fonts_BigText+$60,1,0),       make_art_tile(ArtTile_S3Fonts_BigText+$61,1,0),       make_art_tile(ArtTile_S3Fonts_BigText+$62,1,0)
                dc.w    make_art_tile(ArtTile_S3Fonts_BigText+$E,1,0),        make_art_tile(ArtTile_S3Fonts_BigText+$63,1,0),       make_art_tile(ArtTile_S3Fonts_BigText+$64,1,0)
S3CreditsLargeGlyph_RightParenthesis:   dc.w    2-1
                dc.w    make_art_tile(ArtTile_S3Fonts_BigText+$61,1,0)|$800,  make_art_tile(ArtTile_S3Fonts_BigText+$60,1,0)|$800,  make_art_tile(ArtTile_S3Fonts_BigText+$E,1,0)
                dc.w    make_art_tile(ArtTile_S3Fonts_BigText+$62,1,0)|$800,  make_art_tile(ArtTile_S3Fonts_BigText+$64,1,0)|$800,  make_art_tile(ArtTile_S3Fonts_BigText+$63,1,0)|$800
S3CreditsLargeGlyph_Space:  dc.w    1-1
                dc.w    0,     0,     0
Pal_Ending:
                binclude "data/General/Ending/Palettes/S3 Ending.bin"
                even
Pal_EndingS3Logo:
                binclude "data/General/Ending/Palettes/S3 Logo.bin"
                even
Pal_EndingEyecatchKnuckles:
                binclude "data/General/Ending/Palettes/S3 Knuckles Eyecatch.bin"
                even
Pal_EndingS3LogoFlash:
                binclude "data/General/Ending/Palettes/S3 Logo Flash.bin"
                even
Map_EndingGraphics:
                include "src/ui/shared/ending/mappings/s3_ending_graphics.s"
S3CreditsPage_MirroredOffsetChildRecord:
                dc.w    1-1
                dc.l    S3Credits_InitMirroredOffsetChild
                dc.b    $10,   8
S3CreditsPage_LogoCompanionWaitAnim:
                dc.b    $F,   1,   2, $FC
S3CreditsPage_LogoCompanionReadyAnim:
                dc.b    7,   1,   1,   3,   4
                dc.b    $F8, .jump-S3CreditsPage_LogoCompanionReadyAnim

                .jump:
                dc.b    $7F,   4,   4, $FC
S3CreditsPage_MirroredCompanionAnim:
                dc.b    $F,  $A,  $B, $FC
S3CreditsPage_MirroredOffsetChildAnim:
                dc.b    7,   5,   6,   7,   8,   9, $FC
S3CreditsPage_TryAgainCompanionAnim:
                dc.b    $F,  $C,  $D, $FC
S3CreditsPage_EmeraldThrowerForwardAnim:
                dc.b    $E, $1F,  $E, $1F,  $F,   7, $10,   0, $F4
S3CreditsPage_EmeraldThrowerReverseAnim:
                dc.b    $10, $1F,  $F,   7,  $E,   0, $F4
                even
ArtNem_EndingGraphics:
                binclude "data/General/Ending/Nemesis Art/S3 Ending Graphics.nem"
                even
