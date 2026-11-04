; Owner: objects/ending/sk
; Responsibility: Select ending result programs by product, character and emerald state, then sequence the palette fade
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

EndingResults_SelectProgramAndStartDelay:
                move.l  #EndResults_TickDelayAndSignalExit,(a0)
                move.w  #$1FF,$2E(a0)
                clr.b   (Super_palette_status).w
                move.w  (Player_mode).w,d0
                moveq   #0,d1
                andi.w  #3,d0
                subq.w  #2,d0
                bmi.s   EndResults_SelectStandaloneOrLockOn
                beq.s   EndResults_AddCharacterProgramStride
                addi.w  #$30,d1

EndResults_AddCharacterProgramStride:
                addi.w  #$30,d1

EndResults_SelectStandaloneOrLockOn:
                tst.w   (SK_alone_flag).w
                bne.s   EndingResults_SelectEmeraldOutcomeStride
                addi.w  #$18,d1

EndingResults_SelectEmeraldOutcomeStride:
                tst.b   (_unkFA88).w
                bmi.s   EndingResults_StartSelectedInitializer
                beq.s   EndingResults_AddOutcomeRecordStride
                addi.w  #8,d1

EndingResults_AddOutcomeRecordStride:
                addi.w  #8,d1

EndingResults_StartSelectedInitializer:
                lea     EndResults_InitAndAfterFadePrograms(pc,d1.w),a1
                movea.l (a1)+,a2
                move.l  (a1)+,$34(a0)
                jmp     (a2)
; ---------------------------------------------------------------------------
EndResults_InitAndAfterFadePrograms:
                dc.l    EndResults_SpawnSKBannerAtPlacement2, EndResults_StartEggmanEmeraldEyecatch
                dc.l    EndResults_SpawnSKBannerAtPlacement2, EndingResults_StartEggRoboEyecatch
                dc.l    EndResults_SpawnSKBannerAtPlacement2, EndingResults_StartEggRoboEyecatch
                dc.l    EndResults_SpawnS3KBannerAtPlacement2, EndResults_StartEggmanEmeraldEyecatch
                dc.l    EndResults_SpawnS3KBannerAtPlacement2, EndingResults_StartEggRoboEyecatch
                dc.l    EndResults_SpawnS3KBannerAtPlacement2, EndResults_StartDelayedS3Graphics
                dc.l    EndResults_SpawnS3KBannerAtPlacement2, EndResults_StartEggmanEmeraldEyecatch
                dc.l    EndResults_SpawnS3KBannerAtPlacement2, EndingResults_StartEggRoboEyecatch
                dc.l    EndResults_SpawnS3KBannerAtPlacement2, EndResults_StartDelayedS3Graphics
                dc.l    EndResults_SpawnS3KBannerAtPlacement2, EndResults_StartEggmanEmeraldEyecatch
                dc.l    EndResults_SpawnS3KBannerAtPlacement2, EndingResults_StartEggRoboEyecatch
                dc.l    EndResults_SpawnS3KBannerAtPlacement2, EndResults_StartDelayedS3Graphics
                dc.l    EndResults_SpawnSKBannerAtPlacement3, EndResults_StartMechaEmeraldEyecatch
                dc.l    EndResults_SpawnKnuxPoseForSK, EndingResults_ReturnToSegaScreen
                dc.l    EndResults_SpawnKnuxPoseForSK, EndingResults_ReturnToSegaScreen
                dc.l    EndResults_SpawnS3KBannerAtPlacement3, EndResults_StartMechaEmeraldEyecatch
                dc.l    EndResults_SpawnKnuxPoseForS3K, EndingResults_ReturnToSegaScreen
                dc.l    EndResults_SpawnKnuxPoseForS3K, EndResults_StartDelayedS3Graphics
; ---------------------------------------------------------------------------

EndResults_SpawnSKBannerAtPlacement2:
                jsr     (AllocateObject).l
                bne.s   EndResults_SKPlacement2Return
                move.l  #EndBanner_InitSKPlacementAndPalette,(a1)
                move.b  #4,subtype(a1)

EndResults_SKPlacement2Return:
                rts
; ---------------------------------------------------------------------------

EndResults_SpawnS3KBannerAtPlacement2:
                jsr     (AllocateObject).l
                bne.s   EndResults_S3KPlacement2Return
                move.l  #EndBanner_InitS3KPlacementAndPalette,(a1)
                move.b  #4,subtype(a1)

EndResults_S3KPlacement2Return:
                rts
; ---------------------------------------------------------------------------

EndResults_SpawnKnuxPoseForSK:
                jsr     (AllocateObject).l
                bne.s   EndResults_TrySKBannerAfterKnuxPose
                move.l  #EndingKnucklesSoloPose_Initialize,(a1)

EndResults_TrySKBannerAfterKnuxPose:
                jsr     (AllocateObject).l
                bne.s   EndResults_KnuxSKSpawnReturn
                move.l  #EndBanner_InitSKPlacementAndPalette,(a1)

EndResults_KnuxSKSpawnReturn:
                rts
; ---------------------------------------------------------------------------

EndResults_SpawnSKBannerAtPlacement3:
                jsr     (AllocateObject).l
                bne.s   EndResults_SKPlacement3Return
                move.l  #EndBanner_InitSKPlacementAndPalette,(a1)
                move.b  #8,subtype(a1)

EndResults_SKPlacement3Return:
                rts
; ---------------------------------------------------------------------------

EndResults_SpawnKnuxPoseForS3K:
                jsr     (AllocateObject).l
                bne.s   EndResults_TryS3KBannerAfterKnuxPose
                move.l  #EndingKnucklesSoloPose_Initialize,(a1)

EndResults_TryS3KBannerAfterKnuxPose:
                jsr     (AllocateObject).l
                bne.s   EndResults_KnuxS3KSpawnReturn
                move.l  #EndBanner_InitS3KPlacementAndPalette,(a1)

EndResults_KnuxS3KSpawnReturn:
                rts
; ---------------------------------------------------------------------------

EndResults_SpawnS3KBannerAtPlacement3:
                jsr     (AllocateObject).l
                bne.s   EndResults_S3KPlacement3Return
                move.l  #EndBanner_InitS3KPlacementAndPalette,(a1)
                move.b  #8,subtype(a1)

EndResults_S3KPlacement3Return:
                rts
; ---------------------------------------------------------------------------

EndingResults_ReturnToSegaScreen:
                move.b  #GameMode_SegaScreen,(Game_mode).w
                rts
; ---------------------------------------------------------------------------

EndResults_StartEggmanEmeraldEyecatch:
                jsr     (AllocateObject).l
                bne.s   EndResults_TryEmeraldAtPlacement2
                move.l  #EndingEggmanEyecatch_Initialize,(a1)

EndResults_TryEmeraldAtPlacement2:
                jsr     (AllocateObject).l
                bne.s   EndResults_EggmanEmeraldSpawnReturn
                move.l  #EndResultEmerald_InitPlacementAndArt,(a1)
                move.b  #4,subtype(a1)

EndResults_EggmanEmeraldSpawnReturn:
                rts
; ---------------------------------------------------------------------------

EndingResults_StartEggRoboEyecatch:
                jsr     (AllocateObject).l
                bne.s   EndingResults_ReturnAfterEggRoboAttempt
                move.l  #EndVillain_DispatchEggRoboAndDraw,(a1)

EndingResults_ReturnAfterEggRoboAttempt:
                rts
; ---------------------------------------------------------------------------

EndResults_StartDelayedS3Graphics:
                jsr     (AllocateObject).l
                bne.s   EndResults_DelayedGraphicsSpawnReturn
                move.l  #EndingDelayedS3ResultBanner_Initialize,(a1)

EndResults_DelayedGraphicsSpawnReturn:
                rts
; ---------------------------------------------------------------------------

EndResults_StartMechaEmeraldEyecatch:
                jsr     (AllocateObject).l
                bne.s   EndResults_TryEmeraldAtDefaultPlacement
                move.l  #EndMecha_DispatchLoadArtAndDraw,(a1)

EndResults_TryEmeraldAtDefaultPlacement:
                jsr     (AllocateObject).l
                bne.s   EndResults_MechaEmeraldSpawnReturn
                move.l  #EndResultEmerald_InitPlacementAndArt,(a1)

EndResults_MechaEmeraldSpawnReturn:
                rts
; ---------------------------------------------------------------------------

EndResults_TickDelayAndSignalExit:
                subq.w  #1,$2E(a0)
                bmi.s   EndingResults_AttemptFadeAndInstallWait
                cmpi.w  #$40,$2E(a0)
                bne.s   EndResults_ExitDelayReturn
                bset    #2,(_unkFAB8).w

EndResults_ExitDelayReturn:
                rts
; ---------------------------------------------------------------------------

EndingResults_AttemptFadeAndInstallWait:
                move.l  #EndResults_WaitFadeAndHandOff,(a0)
                st      (Palette_cycle_counters+$00).w
                jsr     (AllocateObject).l
                bne.s   EndResults_ExitDelayReturn
                move.w  a1,$44(a0)
                move.l  #Obj_FadeSelectedToBlack,(a1)
                move.w  #5,$3A(a1)
                move.w  #$3F,$3C(a1)
                move.w  #Normal_palette,$30(a1)
                rts
; ---------------------------------------------------------------------------

EndResults_WaitFadeAndHandOff:
                movea.w $44(a0),a1
                btst    #7,status(a1)
                beq.w   EndingScene_SharedReturn
                move.l  #EndingResults_NoOpAfterProgramHandoff,(a0)
                bset    #3,(_unkFAB8).w
                movea.l $34(a0),a1
                jmp     (a1)
; ---------------------------------------------------------------------------

EndingResults_NoOpAfterProgramHandoff:
                rts
