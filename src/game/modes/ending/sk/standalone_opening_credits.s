; Owner: game/modes/ending/sk
; Responsibility: Opening credit text stream, relative offset index and display positions for standalone S&K
; Source provenance and ranges: config/reconstruction/source_layout.json
CreditsText_Part1_SK:
                dc.w    SoloCredits_ExecProducerHeading-CreditsText_Part1_SK
                dc.w    SoloCredits_ExecProducerNakayama-CreditsText_Part1_SK
                dc.w    SoloCredits_ProjectManagersHeading-CreditsText_Part1_SK
                dc.w    SoloCredits_ProjectManagerSuzuki-CreditsText_Part1_SK
                dc.w    SoloCredits_ProjectManagerToyoda-CreditsText_Part1_SK
                dc.w    SoloCredits_ProjectManagerYoshii-CreditsText_Part1_SK
                dc.w    SoloCredits_ProducerHeading-CreditsText_Part1_SK
                dc.w    SoloCredits_ProducerNaka-CreditsText_Part1_SK
                dc.w    SoloCredits_DirectorHeading-CreditsText_Part1_SK
                dc.w    SoloCredits_DirectorYasuhara-CreditsText_Part1_SK
                dc.w    SoloCredits_LeadDesignerHeading-CreditsText_Part1_SK
                dc.w    SoloCredits_LeadDesignerYasuhara-CreditsText_Part1_SK
                dc.w    SoloCredits_SeniorDesignersHeading-CreditsText_Part1_SK
                dc.w    SoloCredits_SeniorDesignerYoshida-CreditsText_Part1_SK
                dc.w    SoloCredits_SeniorDesignerIizuka-CreditsText_Part1_SK
                dc.w    SoloCredits_LeadProgrammerHeading-CreditsText_Part1_SK
                dc.w    SoloCredits_LeadProgrammerNaka-CreditsText_Part1_SK
                dc.w    SoloCredits_SeniorProgrammersHeading-CreditsText_Part1_SK
                dc.w    SoloCredits_SeniorProgrammerHamano-CreditsText_Part1_SK
                dc.w    SoloCredits_SeniorProgrammerYamamoto-CreditsText_Part1_SK
                dc.w    SoloCredits_CharacterDesignerHeading-CreditsText_Part1_SK
                dc.w    SoloCredits_CharacterDesignerYuda-CreditsText_Part1_SK
                dc.w    SoloCredits_CGArtistHeading-CreditsText_Part1_SK
                dc.w    SoloCredits_CGArtistKAoki-CreditsText_Part1_SK
                dc.w    SoloCredits_EnemyArtistHeading-CreditsText_Part1_SK
                dc.w    SoloCredits_EnemyArtistYokokawa-CreditsText_Part1_SK
                dc.w    SoloCredits_SceneArtistsHeading-CreditsText_Part1_SK
                dc.w    SoloCredits_SceneArtistKAoki-CreditsText_Part1_SK
                dc.w    SoloCredits_SceneArtistYoshida-CreditsText_Part1_SK
                dc.w    SoloCredits_SceneArtistTAoki-CreditsText_Part1_SK
                dc.w    SoloCredits_SceneArtistOkada-CreditsText_Part1_SK
                dc.w    SoloCredits_SceneArtistYuda-CreditsText_Part1_SK
                dc.w    SoloCredits_SceneArtistYokokawa-CreditsText_Part1_SK
                dc.w    SoloCredits_ArtAssistantHeading-CreditsText_Part1_SK
                dc.w    SoloCredits_ArtAssistantOhashi-CreditsText_Part1_SK
                dc.w    SoloCredits_SwitchToClosingPart-CreditsText_Part1_SK
SoloCredits_ExecProducerHeading:    dc.b    $F
                dc.b    7
                dc.b    "EXECUTIVE PRODUCER",0
                even
SoloCredits_ExecProducerNakayama:   dc.b    $11
                dc.b    $E
                dc.b    "HAYAO NAKAYAMA",0
                even
SoloCredits_ProjectManagersHeading: dc.b    $21
                dc.b    $B
                dc.b    "PROJECT MANAGERS",0
                even
SoloCredits_ProjectManagerSuzuki:   dc.b    $23
                dc.b    $10
                dc.b    "HISASHI SUZUKI",0
                even
SoloCredits_ProjectManagerToyoda:   dc.b    $24
                dc.b    $E
                dc.b    "SHINOBU TOYODA",0
                even
SoloCredits_ProjectManagerYoshii:   dc.b    $25
                dc.b    $E
                dc.b    "MASAHARU YOSHII",0
                even
SoloCredits_ProducerHeading:    dc.b    $35
                dc.b    $19
                dc.b    "PRODUCER",0
                even
SoloCredits_ProducerNaka:   dc.b    $37
                dc.b    $18
                dc.b    "YUJI NAKA",0
                even
SoloCredits_DirectorHeading:    dc.b    $47
                dc.b    $1B
                dc.b    "DIRECTOR",0
                even
SoloCredits_DirectorYasuhara:   dc.b    $49
                dc.b    8
                dc.b    "HIROKAZU YASUHARA",0
                even
SoloCredits_LeadDesignerHeading:    dc.b    $59
                dc.b    9
                dc.b    "LEAD GAME DESIGNER",0
                even
SoloCredits_LeadDesignerYasuhara:   dc.b    $5B
                dc.b    8
                dc.b    "HIROKAZU YASUHARA",0
                even
SoloCredits_SeniorDesignersHeading: dc.b    $6B
                dc.b    3
                dc.b    "SENIOR GAME DESIGNERS",0
                even
SoloCredits_SeniorDesignerYoshida:  dc.b    $6D
                dc.b    $A
                dc.b    "HISAYOSHI YOSHIDA",0
                even
SoloCredits_SeniorDesignerIizuka:   dc.b    $6E
                dc.b    $10
                dc.b    "TAKASHI IIZUKA",0
                even
SoloCredits_LeadProgrammerHeading:  dc.b    $7E
                dc.b    $B
                dc.b    "LEAD PROGRAMMER",0
                even
SoloCredits_LeadProgrammerNaka: dc.b    $80
                dc.b    $18
                dc.b    "YUJI NAKA",0
                even
SoloCredits_SeniorProgrammersHeading:   dc.b    $90
                dc.b    7
                dc.b    "SENIOR PROGRAMMERS",0
                even
SoloCredits_SeniorProgrammerHamano: dc.b    $92
                dc.b    $C
                dc.b    "TAKAHIRO HAMANO",0
                even
SoloCredits_SeniorProgrammerYamamoto:   dc.b    $93
                dc.b    8
                dc.b    "MASANOBU YAMAMOTO",0
                even
SoloCredits_CharacterDesignerHeading:   dc.b    $A3
                dc.b    7
                dc.b    "CHARACTER DESIGNER",0
                even
SoloCredits_CharacterDesignerYuda:  dc.b    $A5
                dc.b    6
                dc.b    "TAKASHI THOMAS YUDA",0
                even
SoloCredits_CGArtistHeading:    dc.b    $B5
                dc.b    $17
                dc.b    "C.G. ARTIST",0
                even
SoloCredits_CGArtistKAoki:  dc.b    $B7
                dc.b    $12
                dc.b    "KUNITAKE AOKI",0
                even
SoloCredits_EnemyArtistHeading: dc.b    $C7
                dc.b    $13
                dc.b    "ENEMY ARTIST",0
                even
SoloCredits_EnemyArtistYokokawa:    dc.b    $C9
                dc.b    $A
                dc.b    "SATOSHI YOKOKAWA",0
                even
SoloCredits_SceneArtistsHeading:    dc.b    $D9
                dc.b    $11
                dc.b    "SCENE ARTISTS",0
                even
SoloCredits_SceneArtistKAoki:   dc.b    $DB
                dc.b    $12
                dc.b    "KUNITAKE AOKI",0
                even
SoloCredits_SceneArtistYoshida: dc.b    $DC
                dc.b    $14
                dc.b    "CHIE YOSHIDA",0
                even
SoloCredits_SceneArtistTAoki:   dc.b    $DD
                dc.b    $12
                dc.b    "TSUNEKO AOKI",0
                even
SoloCredits_SceneArtistOkada:   dc.b    $DE
                dc.b    $10
                dc.b    "SHIGERU OKADA",0
                even
SoloCredits_SceneArtistYuda:    dc.b    $DF
                dc.b    6
                dc.b    "TAKASHI THOMAS YUDA",0
                even
SoloCredits_SceneArtistYokokawa:    dc.b    $E0
                dc.b    $A
                dc.b    "SATOSHI YOKOKAWA",0
                even
SoloCredits_ArtAssistantHeading:    dc.b    $F0
                dc.b    $11
                dc.b    "ART ASSISTANT",0
                even
SoloCredits_ArtAssistantOhashi: dc.b    $F2
                dc.b    $12
                dc.b    "OSAMU OHASHI",0
                even
SoloCredits_SwitchToClosingPart:    dc.b    $FF
                dc.b    $F8
