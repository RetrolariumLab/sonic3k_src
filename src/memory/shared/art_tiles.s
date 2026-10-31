; Owner: memory/shared
; Responsibility: VDP attribute masks and art tile assignments shared by the sibling engines
; Source provenance and ranges: config/reconstruction/source_layout.json

                padding off
; ---------------------------------------------------------------------------
; Art tile stuff
palette_line_0: equ     (0<<13)
palette_line_1: equ     (1<<13)
palette_line_2: equ     (2<<13)
palette_line_3: equ     (3<<13)
high_priority:  equ     (1<<15)
tile_mask:      equ     $07FF
drawing_mask:   equ     $7FFF

; ---------------------------------------------------------------------------
; VRAM and tile art base addresses
; VRAM Reserved regions
VRAM_Plane_A_Name_Table:    equ     $C000               ; Extends until $CFFF
VRAM_Plane_B_Name_Table:    equ     $E000               ; Extends until $EFFF

; Menu background
ArtTile_S3MenuBG:   equ     $0001

; Competition mode
ArtTile_Competition_LevSel:     equ     $029F
ArtTile_Competition_ModeSel:    equ     $034A
ArtTile_Competition_Results:    equ     $034A
ArtTile_Competition_STKIcons:   equ     $0572
ArtTile_Competition_Text:       equ     $058D
ArtTile_Competition_CharSel:    equ     $05C9

; Save screen
ArtTile_Save_Misc:  equ     $029F
ArtTile_Save_Extra: equ     $0454
ArtTile_Save_Text:  equ     $0562

; Sonic 2 Menus
ArtTile_S2MenuBox:          equ     $0070
ArtTile_S2Sega:             equ     $0080
ArtTile_S2LevelSelectPics:  equ     $0090
ArtTile_S2Signpost:         equ     $0500

; Blue Sphere
ArtTile_BlueSphere_Difficulty:  equ     $0180
ArtTile_BlueSphere_BG:          equ     $0197
ArtTile_BlueSphere_Emeralds:    equ     $01DC
ArtTile_BlueSphere_Misc:        equ     $054E
ArtTile_BlueSphere_TitleText:   equ     $05BF
ArtTile_BlueSphere_Tails:       equ     $07A0

; Special Stage
ArtTile_SStage_GetBlueSpheres:  equ     $055F
ArtTile_SStage_Icons:           equ     $0589
ArtTile_SStage_BG:              equ     $059B
ArtTile_SStage_Ring:            equ     $05A7
ArtTile_SStage_Emerald:         equ     $05A7
ArtTile_SStage_Sphere:          equ     $0680
ArtTile_SStage_Digits:          equ     $0781
ArtTile_SStage_Shadow:          equ     $07A0
ArtTile_SStage_Player2_Tail:    equ     $07B0
ArtTile_SStage_Player1:         equ     $07D4
ArtTile_SStage_Player2:         equ     $07EB

; Title screen
ArtTile_Title_Buffer:           equ     $0300
ArtTile_Title_Misc:             equ     $0400
ArtTile_Title_ANDKnuckles:      equ     $04C0
ArtTile_Title_Banner:           equ     $0500
ArtTile_Title_Menu:             equ     $0680
ArtTile_SKTitle_SonicKnuxStand: equ     $00E2
ArtTile_SKTitle_Menu:           equ     $0462
ArtTile_SKTitle_Sega:           equ     $049C
ArtTile_SKTitle_Banner:         equ     $04EE
ArtTile_SKTitle_SonicFall:      equ     $04EF
ArtTile_SKTitle_DeathEgg:       equ     $0680
ArtTile_SKTitle_Mountain:       equ     $07A0

; Sonic 3 fonts (continue, credits)
ArtTile_S3Fonts_SmallText:  equ     $0001
ArtTile_S3Fonts_BigText:    equ     $0029

; Continue screen
ArtTile_Continue_Digits:    equ     $0001
ArtTile_Continue_Misc:      equ     $008C
ArtTile_Continue_Icons:     equ     $00D9
ArtTile_Continue_Text:      equ     $0347

; Ending
ArtTile_Ending_S3EndPose:           equ     $03D9
ArtTile_Ending_S3Sprites:           equ     $045D
ArtTile_Ending_Sprites:             equ     $008E
ArtTile_Ending_Plane:               equ     $01E3
ArtTile_Ending_Emeralds:            equ     $0211
ArtTile_Ending_PlaneExtra:          equ     $026E
ArtTile_Ending_KnuxEndPose:         equ     $02C1
ArtTile_Ending_IslandLiftGfx:       equ     $02FF
ArtTile_Ending_Animals:             equ     $02FF
ArtTile_Ending_EyecatchEggman:      equ     $0300
ArtTile_Ending_EyecatchEggRobo:     equ     $0300
ArtTile_Ending_SSZKnuckles:         equ     $0310
ArtTile_Ending_CreditsText:         equ     $0347
ArtTile_Ending_SonicTailsEndPose:   equ     $0347
ArtTile_Ending_Cloud:               equ     $03B6
ArtTile_Ending_ANDKnuckles:         equ     $03EF
ArtTile_Ending_Logo:                equ     $0415
ArtTile_Ending_MasterEmerald:       equ     $052E
ArtTile_Ending_Knuckles:            equ     $05E0

; Game objects
ArtTile_AIZEndBoss:             equ     $0180
ArtTile_AIZMisc2:               equ     $02E9
ArtTile_AIZSlideRope:           equ     $0324
ArtTile_AIZMisc1:               equ     $0333
ArtTile_AIZFallingLog:          equ     $03CF
ArtTile_AIZIntroSprites:        equ     $03D1
ArtTile_AIZFloatingPlatform:    equ     $03F7
ArtTile_AIZMiniboss:            equ     $041A
ArtTile_AIZSwingVine:           equ     $041B
ArtTile_AIZBackgroundTree:      equ     $0438
ArtTile_AIZ2FloatingPlatform:   equ     $0440
ArtTile_AIZMinibossSmall:       equ     $0474
ArtTile_AIZBossFire:            equ     $0482
ArtTile_SphereTest:             equ     $04E0
ArtTile_AIZ2Bombership:         equ     $0500
ArtTile_Rhinobot:               equ     $0500
ArtTile_AIZIntroPlane:          equ     $0529
ArtTile_Bloominator:            equ     $052A
ArtTile_MonkeyDude:             equ     $0548
ArtTile_CaterkillerJr:          equ     $055F
ArtTile_Surfboard:              equ     $0585
ArtTile_AIZIntroEmeralds:       equ     $05B1

ArtTile_HCZ2BlockPlat:      equ     $0028
ArtTile_HCZMiniboss:        equ     $0304
ArtTile_HCZEndBoss:         equ     $0320
ArtTile_HCZ1WaterSplash2:   equ     $0344
ArtTile_HCZ2KnuxWall:       equ     $0350
ArtTile_HCZ2Slide:          equ     $035C
ArtTile_HCZCutsceneGeyser:  equ     $036B
ArtTile_HCZ2WaterSplash2:   equ     $036E
ArtTile_HCZWaterRush:       equ     $037A
ArtTile_HCZWaterSplash:     equ     $03B2
ArtTile_HCZMisc:            equ     $03CA
ArtTile_HCZMinibossSplash:  equ     $03FC
ArtTile_HCZButton:          equ     $0426
ArtTile_HCZWaveSplash:      equ     $042E
ArtTile_HCZSpikeBall:       equ     $043E
ArtTile_Buggernaut:         equ     $044C
ArtTile_TurboSpiker:        equ     $0500
ArtTile_HCZGeyser:          equ     $0500
ArtTile_HCZLargeFan:        equ     $0500
ArtTile_Blastoid:           equ     $0539
ArtTile_Jawz:               equ     $0539
ArtTile_MegaChopper:        equ     $054D
ArtTile_Pointdexter:        equ     $0559

ArtTile_MGZEndBoss:             equ     $033F
ArtTile_MGZMisc1:               equ     $035F
ArtTile_MGZMisc2:               equ     $03FF
ArtTile_MGZSigns:               equ     $0451
ArtTile_MGZEndBossDebris:       equ     $045E
ArtTile_MGZEndBossScaled:       equ     $0469
ArtTile_MGZMHZDiagonalSpring:   equ     $0478
ArtTile_MGZSpire:               equ     $0500
ArtTile_BubblesBadnik:          equ     $0500
ArtTile_Spiker:                 equ     $0530
ArtTile_MGZMiniboss:            equ     $054F
ArtTile_Mantis:                 equ     $054F
ArtTile_MGZMiniBossDebris:      equ     $0570

ArtTile_CNZMisc:        equ     $0351
ArtTile_CNZEndBoss:     equ     $0430
ArtTile_CNZPlatform:    equ     $0430
ArtTile_CNZCannon:      equ     $0448
ArtTile_CNZTeleport:    equ     $0500
ArtTile_Clamer:         equ     $0500
ArtTile_Sparkle:        equ     $0524
ArtTile_CNZMiniboss:    equ     $052E
ArtTile_Batbot:         equ     $0552
ArtTile_CNZBalloon:     equ     $0574

ArtTile_S3Snowboard:        equ     $06A4
ArtTile_ICZEndBoss:         equ     $02A6
ArtTile_Snowboard:          equ     $0320
ArtTile_ICZIntroSprites:    equ     $0347
ArtTile_ICZMisc2:           equ     $0377
ArtTile_ICZMisc1:           equ     $03B6
ArtTile_ICZMiniboss:        equ     $04A9
ArtTile_Penguinator:        equ     $0500
ArtTile_StarPointer:        equ     $0548
ArtTile_ICZSnowdust:        equ     $0558
ArtTile_ICZTeleport:        equ     $0570
ArtTile_SnowboardDust:      equ     $06B8

ArtTile_LBZ2Misc:           equ     $02EA
ArtTile_LBZFinalBoss1:      equ     $03AA
ArtTile_LBZMisc:            equ     $03C3
ArtTile_LBZFinalBoss2:      equ     $03D9
ArtTile_LBZEndBoss:         equ     $0425
ArtTile_LBZTubeTrans:       equ     $0455
ArtTile_LBZMinibossBox:     equ     $0456
ArtTile_LBZ2DeathEggSmall:  equ     $04AE
ArtTile_LBZKnuxBomb:        equ     $04D6
ArtTile_LBZMiniboss:        equ     $04D6
ArtTile_Flybot767:          equ     $0500
ArtTile_SnaleBlaster:       equ     $0524
ArtTile_Ribot:              equ     $0547
ArtTile_Corkey:             equ     $0558
ArtTile_Orbinaut:           equ     $056E

ArtTile_MHZ1CutsceneButton: equ     $0341
ArtTile_MHZMisc:            equ     $0347
ArtTile_MHZMiniboss:        equ     $03AD
ArtTile_MHZEndBossSpikes:   equ     $03AF
ArtTile_MHZEndBoss:         equ     $03EC
ArtTile_MHZMinibossLog:     equ     $049F
ArtTile_Cluckoid:           equ     $0500
ArtTile_MHZShipPropeller:   equ     $0500
ArtTile_MHZKnuxPeer:        equ     $0500
ArtTile_Butterdroid:        equ     $0514
ArtTile_MHZKnuxSwitch:      equ     $0528
ArtTile_KnuxIntroBomb:      equ     $052E
ArtTile_Dragonfly:          equ     $0538
ArtTile_Madmole:            equ     $0545
ArtTile_Mushmeanie:         equ     $056D
ArtTile_MHZEndBossPillar:   equ     $0580

ArtTile_FBZSpikes:          equ     $0200
ArtTile_FBZMisc2:           equ     $02D2
ArtTile_FBZOutdoors:        equ     $02E5
ArtTile_FBZEggCapsule:      equ     $035D
ArtTile_FBZMisc:            equ     $0379
ArtTile_FBZCloud:           equ     $03A3
ArtTile_FBZBossPillar:      equ     $03D5
ArtTile_FBZExitDoor:        equ     $03E5
ArtTile_FBZExitHall:        equ     $03F4
ArtTile_FBZEndBoss:         equ     $0400
ArtTile_FBZAnimals1:        equ     $042E
ArtTile_FBZRobotnikHead:    equ     $0430
ArtTile_FBZAnimals2:        equ     $0440
ArtTile_FBZEndBossFlame:    equ     $0450
ArtTile_FBZRobotnikStand:   equ     $0466
ArtTile_FBZRobotnikRun:     equ     $04A9
ArtTile_FBZButton:          equ     $0500
ArtTile_Blaster:            equ     $0506
ArtTile_FBZ2Subboss:        equ     $052E
ArtTile_FBZMiniboss:        equ     $052E
ArtTile_Technosqueek:       equ     $052E

ArtTile_SOZEndBoss:         equ     $03A4
ArtTile_SOZ2Extra:          equ     $03AF
ArtTile_SOZMiniboss:        equ     $03B5
ArtTile_SOZTile:            equ     $03C0
ArtTile_SOZMisc:            equ     $03C9
ArtTile_SOZSand:            equ     $04F3
ArtTile_Rockn:              equ     $0500
ArtTile_SOZGhosts:          equ     $0500
ArtTile_Skorp:              equ     $0536
ArtTile_SOZGhostCapsule:    equ     $0536
ArtTile_Sandworm:           equ     $0557

ArtTile_LRZ2DeathEggBG:     equ     $039F
ArtTile_LRZMisc:            equ     $03A1
ArtTile_LRZ3DeathEggFlash:  equ     $03AB
ArtTile_LRZ2Drum:           equ     $03AD
ArtTile_LRZEndBoss:         equ     $03CC
ArtTile_LRZMiniboss:        equ     $03FB
ArtTile_LRZ2Misc:           equ     $040D
ArtTile_LRZ3Autoscroll:     equ     $0424
ArtTile_LRZBigSpike:        equ     $0442
ArtTile_LRZ3PlatformDebris: equ     $0487
ArtTile_Fireworm:           equ     $0500
ArtTile_LRZKnuxBoulder:     equ     $0500
ArtTile_FirewormSegments:   equ     $0512
ArtTile_LRZRockCrusher:     equ     $052E
ArtTile_Iwamodoki:          equ     $0530
ArtTile_Toxomister:         equ     $0562

ArtTile_HPZEmeraldMisc:     equ     $03B5
ArtTile_HPZGrayEmerald:     equ     $0477
ArtTile_HPZEntryTeleporter: equ     $0488
ArtTile_HPZSmallEmeralds:   equ     $04AC
ArtTile_HPZKnuxDizzy:       equ     $0500
ArtTile_HPZKnuxBossDust:    equ     $0500
ArtTile_HPZTeleporter:      equ     $052E

ArtTile_SSZMasterEmerald:   equ     $01EE
ArtTile_SSZMisc:            equ     $02D4
ArtTile_SSZSpiralRamp:      equ     $0348
ArtTile_MechaSonic:         equ     $03F4
ArtTile_MechaSonicExtra:    equ     $041C
ArtTile_SSZMTZOrbs:         equ     $041F
ArtTile_SSZGHZMisc:         equ     $0468
ArtTile_SSZCutsceneButton:  equ     $048E
ArtTile_HPZSSZBossCrane:    equ     $04A7
ArtTile_SSZDeathEggCloud:   equ     $04C9
ArtTile_EggRoboBadnik:      equ     $0500
ArtTile_SSZDeathEggSmall:   equ     $0500
ArtTile_EggRoboFlyScaled:   equ     $0500

ArtTile_DEZFinalBossDebris: equ     $0100
ArtTile_DEZMisc2:           equ     $02FC
ArtTile_DEZ2Extra:          equ     $0332
ArtTile_DEZMisc:            equ     $034D
ArtTile_DEZEndBoss:         equ     $038A
ArtTile_DEZFinalBossMisc:   equ     $038F
ArtTile_DEZMiniboss:        equ     $0400
ArtTile_DEZBossCrane:       equ     $049D
ArtTile_Spikebonker:        equ     $0500
ArtTile_Chainspike:         equ     $0542
ArtTile_DEZRobotnikRun:     equ     $058C

ArtTile_DDZMisc:            equ     $02DB
ArtTile_BossMasterEmerald:  equ     $04D0

ArtTile_2PArt_2:        equ     $0391
ArtTile_2PArt_1:        equ     $03AD
ArtTile_2PArt_3:        equ     $03C6
ArtTile_2PTime:         equ     $0600
ArtTile_2PStartPost:    equ     $06BC
ArtTile_2PLapNum:       equ     $0700
ArtTile_2PPosIcon:      equ     $075E

ArtTile_DPZMisc:    equ     $0280
ArtTile_BPZMisc:    equ     $0300
ArtTile_CGZMisc:    equ     $0300
ArtTile_EMZMisc:    equ     $0300

ArtTile_BonusStage:         equ     $015B
ArtTile_PachinkoMain:       equ     $02CD
ArtTile_SlotsBlocks:        equ     $033B
ArtTile_PachinkoGumballs:   equ     $0388

; ---------------------------------------------------------------------------
; Universal locations

; Universal (used on all standard levels)
ArtTile_DiagonalSpring: equ     $043A
ArtTile_GrayButton:     equ     $0456
ArtTile_Bubbles:        equ     $045C
ArtTile_EggCapsule:     equ     $0494
ArtTile_SpikesSprings:  equ     $0494
ArtTile_EndSigns:       equ     $04AC
ArtTile_Monitors:       equ     $04C4
ArtTile_BossExplosion2: equ     $04D2
ArtTile_CutsceneKnux:   equ     $04DA
ArtTile_BossExplosion:  equ     $0500
ArtTile_RobotnikShip:   equ     $052E
ArtTile_Animals1:       equ     $0580
ArtTile_Animals2:       equ     $0592
ArtTile_Explosion:      equ     $05A0
ArtTile_StarPost:       equ     $05E4
ArtTile_Player_1:       equ     $0680
ArtTile_SignpostStub:   equ     $069E
ArtTile_Player_2:       equ     $06A0
ArtTile_Player_2_Tail:  equ     $06B0
ArtTile_Ring:           equ     $06BC
ArtTile_Shield:         equ     $079C
ArtTile_Shield_Sparks:  equ     $07BB
ArtTile_PlayerLifeIcon: equ     $07D4
ArtTile_DashDust:       equ     $07E0
ArtTile_DashDust_P2:    equ     $07F0

; ---------------------------------------------------------------------------
