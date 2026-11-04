; Owner: game/modes/ending/sk
; Responsibility: Opening credit text stream, relative offset index and display positions for Sonic 3 & Knuckles
; Source provenance and ranges: config/reconstruction/source_layout.json
CreditsText_Part1:
                dc.w    LockCredits_ExecProducerHeading-CreditsText_Part1
                dc.w    LockCredits_ExecProducerNakayama-CreditsText_Part1
                dc.w    LockCredits_ProjectManagersHeading-CreditsText_Part1
                dc.w    LockCredits_ProjectManagerSuzuki-CreditsText_Part1
                dc.w    LockCredits_ProjectManagerToyoda-CreditsText_Part1
                dc.w    LockCredits_ProjectManagerYoshii-CreditsText_Part1
                dc.w    SKCreditsLockonOpening_ProducerHeading-CreditsText_Part1
                dc.w    SKCreditsLockonOpening_ProducerYujiNaka-CreditsText_Part1
                dc.w    SKCreditsLockonOpening_DirectorHeading-CreditsText_Part1
                dc.w    LockCredits_DirectorYasuhara-CreditsText_Part1
                dc.w    LockCredits_LeadDesignerHeading-CreditsText_Part1
                dc.w    LockCredits_LeadDesignerYasuhara-CreditsText_Part1
                dc.w    LockCredits_SeniorDesignersHeading-CreditsText_Part1
                dc.w    LockCredits_SeniorDesignerYoshida-CreditsText_Part1
                dc.w    LockCredits_SeniorDesignerIizuka-CreditsText_Part1
                dc.w    LockCredits_LeadProgrammerHeading-CreditsText_Part1
                dc.w    LockCredits_LeadProgrammerNaka-CreditsText_Part1
                dc.w    LockCredits_SeniorProgrammersHeading-CreditsText_Part1
                dc.w    LockCredits_SeniorProgrammerHamano-CreditsText_Part1
                dc.w    LockCredits_SeniorProgrammerYamamoto-CreditsText_Part1
                dc.w    LockCredits_CharacterDesignerHeading-CreditsText_Part1
                dc.w    LockCredits_CharacterDesignerYuda-CreditsText_Part1
                dc.w    SKCreditsLockonOpening_CgArtistHeading-CreditsText_Part1
                dc.w    LockCredits_CGArtistKAoki-CreditsText_Part1
                dc.w    LockCredits_EnemyArtistHeading-CreditsText_Part1
                dc.w    LockCredits_EnemyArtistYokokawa-CreditsText_Part1
                dc.w    LockCredits_SceneArtistsHeading-CreditsText_Part1
                dc.w    LockCredits_SceneArtistKAoki-CreditsText_Part1
                dc.w    LockCredits_SceneArtistYoshida-CreditsText_Part1
                dc.w    LockCredits_SceneArtistTAoki-CreditsText_Part1
                dc.w    LockCredits_SceneArtistOkada-CreditsText_Part1
                dc.w    LockCredits_SceneArtistYuda-CreditsText_Part1
                dc.w    LockCredits_SceneArtistYokokawa-CreditsText_Part1
                dc.w    LockCredits_ArtAssistantHeading-CreditsText_Part1
                dc.w    LockCredits_ArtAssistantOhashi-CreditsText_Part1
                dc.w    LockCredits_SwitchToClosingPart-CreditsText_Part1
LockCredits_ExecProducerHeading:    dc.b    $F
                dc.b    7
                dc.b    "EXECUTIVE PRODUCER",0
                even
LockCredits_ExecProducerNakayama:   dc.b    $11
                dc.b    $E
                dc.b    "HAYAO NAKAYAMA",0
                even
LockCredits_ProjectManagersHeading: dc.b    $21
                dc.b    $B
                dc.b    "PROJECT MANAGERS",0
                even
LockCredits_ProjectManagerSuzuki:   dc.b    $23
                dc.b    $10
                dc.b    "HISASHI SUZUKI",0
                even
LockCredits_ProjectManagerToyoda:   dc.b    $24
                dc.b    $E
                dc.b    "SHINOBU TOYODA",0
                even
LockCredits_ProjectManagerYoshii:   dc.b    $25
                dc.b    $E
                dc.b    "MASAHARU YOSHII",0
                even
SKCreditsLockonOpening_ProducerHeading: dc.b    $35
                dc.b    $19
                dc.b    "PRODUCER",0
                even
SKCreditsLockonOpening_ProducerYujiNaka:    dc.b    $37
                dc.b    $18
                dc.b    "YUJI NAKA",0
                even
SKCreditsLockonOpening_DirectorHeading: dc.b    $47
                dc.b    $1B
                dc.b    "DIRECTOR",0
                even
LockCredits_DirectorYasuhara:   dc.b    $49
                dc.b    8
                dc.b    "HIROKAZU YASUHARA",0
                even
LockCredits_LeadDesignerHeading:    dc.b    $59
                dc.b    9
                dc.b    "LEAD GAME DESIGNER",0
                even
LockCredits_LeadDesignerYasuhara:   dc.b    $5B
                dc.b    8
                dc.b    "HIROKAZU YASUHARA",0
                even
LockCredits_SeniorDesignersHeading: dc.b    $6B
                dc.b    3
                dc.b    "SENIOR GAME DESIGNERS",0
                even
LockCredits_SeniorDesignerYoshida:  dc.b    $6D
                dc.b    $A
                dc.b    "HISAYOSHI YOSHIDA",0
                even
LockCredits_SeniorDesignerIizuka:   dc.b    $6E
                dc.b    $10
                dc.b    "TAKASHI IIZUKA",0
                even
LockCredits_LeadProgrammerHeading:  dc.b    $7E
                dc.b    $B
                dc.b    "LEAD PROGRAMMER",0
                even
LockCredits_LeadProgrammerNaka: dc.b    $80
                dc.b    $18
                dc.b    "YUJI NAKA",0
                even
LockCredits_SeniorProgrammersHeading:   dc.b    $90
                dc.b    7
                dc.b    "SENIOR PROGRAMMERS",0
                even
LockCredits_SeniorProgrammerHamano: dc.b    $92
                dc.b    $C
                dc.b    "TAKAHIRO HAMANO",0
                even
LockCredits_SeniorProgrammerYamamoto:   dc.b    $93
                dc.b    8
                dc.b    "MASANOBU YAMAMOTO",0
                even
LockCredits_CharacterDesignerHeading:   dc.b    $A3
                dc.b    7
                dc.b    "CHARACTER DESIGNER",0
                even
LockCredits_CharacterDesignerYuda:  dc.b    $A5
                dc.b    6
                dc.b    "TAKASHI THOMAS YUDA",0
                even
SKCreditsLockonOpening_CgArtistHeading: dc.b    $B5
                dc.b    $17
                dc.b    "C.G. ARTIST",0
                even
LockCredits_CGArtistKAoki:  dc.b    $B7
                dc.b    $12
                dc.b    "KUNITAKE AOKI",0
                even
LockCredits_EnemyArtistHeading: dc.b    $C7
                dc.b    $13
                dc.b    "ENEMY ARTIST",0
                even
LockCredits_EnemyArtistYokokawa:    dc.b    $C9
                dc.b    $A
                dc.b    "SATOSHI YOKOKAWA",0
                even
LockCredits_SceneArtistsHeading:    dc.b    $D9
                dc.b    $11
                dc.b    "SCENE ARTISTS",0
                even
LockCredits_SceneArtistKAoki:   dc.b    $DB
                dc.b    $12
                dc.b    "KUNITAKE AOKI",0
                even
LockCredits_SceneArtistYoshida: dc.b    $DC
                dc.b    $14
                dc.b    "CHIE YOSHIDA",0
                even
LockCredits_SceneArtistTAoki:   dc.b    $DD
                dc.b    $12
                dc.b    "TSUNEKO AOKI",0
                even
LockCredits_SceneArtistOkada:   dc.b    $DE
                dc.b    $10
                dc.b    "SHIGERU OKADA",0
                even
LockCredits_SceneArtistYuda:    dc.b    $DF
                dc.b    6
                dc.b    "TAKASHI THOMAS YUDA",0
                even
LockCredits_SceneArtistYokokawa:    dc.b    $E0
                dc.b    $A
                dc.b    "SATOSHI YOKOKAWA",0
                even
LockCredits_ArtAssistantHeading:    dc.b    $F0
                dc.b    $11
                dc.b    "ART ASSISTANT",0
                even
LockCredits_ArtAssistantOhashi: dc.b    $F2
                dc.b    $12
                dc.b    "OSAMU OHASHI",0
                even
LockCredits_SwitchToClosingPart:    dc.b    $FF
                dc.b    $F8
