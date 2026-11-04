; Owner: game/level/sk
; Responsibility: Active-character loading, level-owned HUD and power-up creation, and player spawn setup
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

LevelLoad_ActiveCharacter:
                cmpi.b  #GameMode_Demo+$80,(Game_mode).w
                beq.s   SKLevel_PickDemoCharacterMode
                tst.w   (Competition_mode).w
                bne.s   SKLevel_PickDemoCharacterMode
                move.w  (Player_option).w,(Player_mode).w  ; Move selected character to active character
                rts
; ---------------------------------------------------------------------------

SKLevel_PickDemoCharacterMode:
                move.w  #3,(Player_mode).w              ; If loading a demo OR 2P mode enabled (?)
                cmpi.b  #7,(Current_zone).w
                beq.s   SKLevel_CharacterModeReturn
                move.w  #0,(Player_mode).w
                tst.w   (SK_alone_flag).w
                beq.s   SKLevel_CharacterModeReturn
                move.w  #1,(Player_mode).w

SKLevel_CharacterModeReturn:
                rts
; End of function LevelLoad_ActiveCharacter

; =============== S U B R O U T I N E =======================================

SpawnLevelMainSprites:
                move.l  #Obj_ResetCollisionResponseList,(Reserved_object_3).w
                bsr.w   SpawnLevelMainSprites_SpawnPlayers
                bsr.w   SpawnLevelMainSprites_SpawnPowerup
                tst.b   (Last_star_post_hit).w
                bne.w   SKLevel_ReturnFromMainSpriteSpawning
                tst.b   (Special_bonus_entry_flag).w
                bne.w   SKLevel_ReturnFromMainSpriteSpawning
                lea     (Player_1).w,a1
                lea     (Player_2).w,a2
                cmpi.w  #0,(Current_zone_and_act).w
                bne.s   SKLevel_TryHCZArrivalPose
                cmpi.w  #2,(Player_mode).w
                bhs.s   SKLevel_ReturnAfterAIZIntroDecision
                move.l  #Obj_AIZPlaneIntro,(Dynamic_object_RAM+(object_size*2)).w
                clr.b   (Level_started_flag).w

SKLevel_ReturnAfterAIZIntroDecision:
                rts
; ---------------------------------------------------------------------------

SKLevel_TryHCZArrivalPose:
                cmpi.w  #$100,(Current_zone_and_act).w
                bne.s   SKLevel_ChooseLRZNonKnucklesArrivalPose
                move.b  #$1B,anim(a1)
                cmpi.w  #3,(Player_mode).w
                bne.s   SKLevel_MarkHCZMainPlayerAirborne
                move.w  #($21<<8)|$21,anim(a1)          ; and prev_anim
                move.b  #1,anim_frame(a1)
; Bug: this tries to clear Knuckles' anim_frame_timer, but Knuckles is in a1
                move.b  #0,anim_frame_timer(a0)

SKLevel_MarkHCZMainPlayerAirborne:
                bset    #Status_InAir,status(a1)
                cmpi.w  #2,(Player_mode).w
                bne.s   SKLevel_SetActiveCompanionHCZArrivalPose
                move.b  #1,jumping(a1)

SKLevel_SetActiveCompanionHCZArrivalPose:
                tst.l   (a2)
                beq.s   SKLevel_ChooseLRZNonKnucklesArrivalPose
                move.b  #$1B,anim(a2)
                bset    #Status_InAir,status(a2)
                move.b  #1,jumping(a2)

SKLevel_ChooseLRZNonKnucklesArrivalPose:
                cmpi.w  #$900,(Current_zone_and_act).w
                bne.s   SKLevel_TryEncounterOrMGZPose
                cmpi.w  #3,(Player_mode).w
                bne.s   SKLevel_SetPlayersAirborne

SKLevel_TryEncounterOrMGZPose:
                cmpi.w  #$1600,(Current_zone_and_act).w
                beq.s   SKLevel_SetPlayersAirborne
                cmpi.w  #$200,(Current_zone_and_act).w
                bne.s   SKLevel_ChooseCombinedMHZCompanionEntry

SKLevel_SetPlayersAirborne:
                move.b  #$1B,anim(a1)
                bset    #Status_InAir,status(a1)
                tst.l   (a2)
                beq.s   SKLevel_ChooseCombinedMHZCompanionEntry
                move.b  #$1B,anim(a2)
                bset    #Status_InAir,status(a2)

SKLevel_ChooseCombinedMHZCompanionEntry:
                cmpi.w  #$700,(Current_zone_and_act).w
                bne.s   SKLevel_ChooseCNZCompanionEntry
                tst.w   (SK_alone_flag).w
                beq.s   SKLevel_SpawnIntroTailsForSoloSonic

SKLevel_ChooseCNZCompanionEntry:
                cmpi.w  #$300,(Current_zone_and_act).w
                bne.s   SKLevel_PickICZIntro

SKLevel_SpawnIntroTailsForSoloSonic:
                cmpi.w  #1,(Player_mode).w
                bne.s   SKLevel_SelectIntroTailsCPURoutine
                move.l  #Obj_Tails,(Player_2).w
                move.w  (Player_1+x_pos).w,(Player_2+x_pos).w
                move.w  (Player_1+y_pos).w,(Player_2+y_pos).w
                move.w  #0,(Tails_CPU_routine).w
                bra.s   SKLevel_PickICZIntro
; ---------------------------------------------------------------------------

SKLevel_SelectIntroTailsCPURoutine:
                cmpi.w  #2,(Player_mode).w
                bne.s   SKLevel_PickICZIntro
                move.w  #$20,(Tails_CPU_routine).w

SKLevel_PickICZIntro:
                cmpi.w  #$500,(Current_zone_and_act).w
                bne.s   SKLevel_InstallLBZGroundLaunchIntro
                cmpi.w  #2,(Player_mode).w
                blo.s   SKLevel_InstallRegularICZIntroActor
                bne.s   SKLevel_InstallLBZGroundLaunchIntro
                move.l  #Obj_LevelIntroICZ1Tails,(Dynamic_object_RAM+(object_size*2)).w
                bra.s   SKLevel_InstallLBZGroundLaunchIntro
; ---------------------------------------------------------------------------

SKLevel_InstallRegularICZIntroActor:
                move.l  #Obj_LevelIntroICZ1,(Dynamic_object_RAM+(object_size*2)).w

SKLevel_InstallLBZGroundLaunchIntro:
                cmpi.w  #$600,(Current_zone_and_act).w
                bne.s   SKLevel_SetKnucklesMHZArrivalPose
                move.l  #Obj_LevelIntro_PlayerLaunchFromGround,(Dynamic_object_RAM+(object_size*2)).w

SKLevel_SetKnucklesMHZArrivalPose:
                cmpi.w  #$700,(Current_zone_and_act).w
                bne.s   SKLevel_InstallSOZGroundFallIntro
                cmpi.w  #3,(Player_mode).w
                bne.s   SKLevel_InstallSOZGroundFallIntro
                move.b  #$1B,anim(a1)
                bset    #Status_InAir,status(a1)

SKLevel_InstallSOZGroundFallIntro:
                cmpi.w  #$800,(Current_zone_and_act).w
                bne.s   SKLevel_PickRunningIntro
                move.l  #Obj_LevelIntro_PlayerFallIntoGround,(Dynamic_object_RAM+(object_size*2)).w
                move.b  #2,anim(a1)
                bset    #Status_InAir,status(a1)
                tst.l   (a2)
                beq.s   SKLevel_PickRunningIntro
                move.b  #2,anim(a2)
                bset    #Status_InAir,status(a2)

SKLevel_PickRunningIntro:
                cmpi.w  #$300,(Current_zone_and_act).w
                beq.s   SKLevel_TryKnuxRunningIntro
                cmpi.w  #$B00,(Current_zone_and_act).w
                beq.s   SKLevel_InstallPlayerRunningIntro
                cmpi.w  #$1601,(Current_zone_and_act).w
                beq.s   SKLevel_InstallPlayerRunningIntro
                cmpi.w  #$900,(Current_zone_and_act).w
                bne.s   SKLevel_ReturnFromMainSpriteSpawning

SKLevel_TryKnuxRunningIntro:
                cmpi.w  #3,(Player_mode).w
                bne.s   SKLevel_ReturnFromMainSpriteSpawning

SKLevel_InstallPlayerRunningIntro:
                move.l  #Obj_LevelIntro_PlayerRun,(Dynamic_object_RAM+(object_size*2)).w

SKLevel_ReturnFromMainSpriteSpawning:
                rts
; End of function SpawnLevelMainSprites

; =============== S U B R O U T I N E =======================================

SpawnLevelMainSprites_SpawnPowerup:
                cmpi.w  #$D01,(Current_zone_and_act).w
                beq.s   SKLevel_RestoreShieldReturn
                cmpi.b  #$13,(Current_zone).w
                beq.s   SKLevel_ReadAndClearSavedShields
                cmpi.b  #$14,(Current_zone).w
                beq.s   SKLevel_ReadAndClearSavedShields
                cmpi.b  #$16,(Current_zone).w
                bhs.s   SKLevel_ReadAndClearSavedShields
                cmpi.b  #$E,(Current_zone).w
                bhs.s   SKLevel_RestoreShieldReturn

; Read and clear the secondary slot only if the first slot lacks an elemental shield
SKLevel_ReadAndClearSavedShields:
                lea     (Player_1).w,a1
                move.b  (Saved_status_secondary).w,d0
                clr.b   (Saved_status_secondary).w
                andi.b  #(1<<Status_FireShield)|(1<<Status_LtngShield)|(1<<Status_BublShield),d0
                bne.s   SKLevel_RestoreSavedFireShieldFirst
                move.b  (Saved2_status_secondary).w,d0
                clr.b   (Saved2_status_secondary).w
                andi.b  #(1<<Status_FireShield)|(1<<Status_LtngShield)|(1<<Status_BublShield),d0
                bne.s   SKLevel_RestoreSavedFireShieldFirst

SKLevel_RestoreShieldReturn:
                rts
; ---------------------------------------------------------------------------

SKLevel_RestoreSavedFireShieldFirst:
                btst    #Status_FireShield,d0
                beq.s   SKLevel_TryRestoreLightningShield
                andi.b  #$8E,status_secondary(a1)
                bset    #Status_Shield,status_secondary(a1)
                bset    #Status_FireShield,status_secondary(a1)
                move.l  #Obj_FireShield,(Shield).w
                move.w  a1,(Shield+parent).w
                rts
; ---------------------------------------------------------------------------

SKLevel_TryRestoreLightningShield:
                btst    #Status_LtngShield,d0
                beq.s   SKLevel_RestoreSavedBubbleShieldLast
                andi.b  #$8E,status_secondary(a1)
                bset    #Status_Shield,status_secondary(a1)
                bset    #Status_LtngShield,status_secondary(a1)
                move.l  #Obj_LightningShield,(Shield).w
                move.w  a1,(Shield+parent).w
                rts
; ---------------------------------------------------------------------------

SKLevel_RestoreSavedBubbleShieldLast:
                btst    #Status_BublShield,d0
                beq.s   SKLevel_ReturnAfterSavedShieldSelection
                andi.b  #$8E,status_secondary(a1)
                bset    #Status_Shield,status_secondary(a1)
                bset    #Status_BublShield,status_secondary(a1)
                move.l  #Obj_BubbleShield,(Shield).w
                move.w  a1,(Shield+parent).w
                rts
; ---------------------------------------------------------------------------

SKLevel_ReturnAfterSavedShieldSelection:
                rts
; End of function SpawnLevelMainSprites_SpawnPowerup

; =============== S U B R O U T I N E =======================================

SpawnLevelMainSprites_SpawnPlayers:
                cmpi.w  #$1300,(Current_zone_and_act).w
                blo.s   SKLevel_TryInitPachinko
                cmpi.w  #$1600,(Current_zone_and_act).w
                bhs.s   SKLevel_TryInitPachinko
                clr.b   (Update_HUD_timer).w

SKLevel_TryInitPachinko:
                cmpi.w  #$1400,(Current_zone_and_act).w
                bne.s   SKLevel_PickPlayerSpawn
                move.l  #Obj_PachinkoEnergyTrap,(Dynamic_object_RAM+(object_size*2)).w
                move.w  #$78,(Dynamic_object_RAM+(object_size*2)+x_pos).w
                move.w  #$F30,(Dynamic_object_RAM+(object_size*2)+y_pos).w
                move.w  (Saved_ring_count).w,(Ring_count).w
                move.b  (Saved_extra_life_flags).w,(Extra_life_flags).w
                move.b  #1,(Update_HUD_ring_count).w

SKLevel_PickPlayerSpawn:
                cmpi.b  #$15,(Current_zone).w
                beq.w   SKLevel_InitSlotsPlayerAndLayout
                tst.w   (Competition_mode).w
                bne.w   SKLevel_SpawnCompetitionPlayersAndDust
                move.w  (Player_mode).w,d0
                bne.s   SKLevel_ChooseSingleSonicSpawn
                move.l  #Obj_Sonic,(Player_1).w
                move.l  #Obj_DashDust,(Dust).w
                move.l  #Obj_InstaShield,(Shield).w
                move.w  #Player_1,(Shield+parent).w
                move.l  #Obj_Tails,(Player_2).w
                move.w  (Player_1+x_pos).w,(Player_2+x_pos).w
                move.w  (Player_1+y_pos).w,(Player_2+y_pos).w
                subi.w  #$20,(Player_2+x_pos).w
                addi.w  #4,(Player_2+y_pos).w
                move.l  #Obj_DashDust,(Dust_P2).w
                move.w  #0,(Tails_CPU_routine).w
                rts
; ---------------------------------------------------------------------------

SKLevel_ChooseSingleSonicSpawn:
                subq.w  #1,d0
                bne.s   SKLevel_ChooseSingleTailsSpawn
                move.l  #Obj_Sonic,(Player_1).w
                move.l  #Obj_DashDust,(Dust).w
                move.l  #Obj_InstaShield,(Shield).w
                move.w  #Player_1,(Shield+parent).w
                rts
; ---------------------------------------------------------------------------

SKLevel_ChooseSingleTailsSpawn:
                subq.w  #1,d0
                bne.s   SKLevel_SpawnFallbackKnuckles
                move.l  #Obj_Tails,(Player_1).w
                move.l  #Obj_DashDust,(Dust_P2).w
                addi.w  #4,(Player_1+y_pos).w
                move.w  #0,(Tails_CPU_routine).w
                rts
; ---------------------------------------------------------------------------

SKLevel_SpawnFallbackKnuckles:
                move.l  #Obj_Knuckles,(Player_1).w
                move.l  #Obj_DashDust,(Dust).w
                rts
; ---------------------------------------------------------------------------

SKLevel_InitSlotsPlayerAndLayout:
                moveq   #0,d0
                move.b  d0,(SStage_scalar_result_0+2).w
                move.w  d0,(SStage_scalar_result_0).w
                move.l  #Obj_Sonic_RotatingSlotBonus,(Player_1).w
                jsr     (Slots_InitLayoutDescriptorsAndCage).l
                st      (Deform_lock).w
                rts
; ---------------------------------------------------------------------------

SKLevel_SpawnCompetitionPlayersAndDust:
                move.b  (P1_character).w,d0
                bsr.s   SKComp_SelectPlayerHandler
                move.l  d1,(Player_1).w
                move.b  (P1_character).w,(Player_1+character_id).w
                move.w  (Player_1+x_pos).w,(Player_2+x_pos).w
                move.w  (Player_1+y_pos).w,(Player_2+y_pos).w
                move.l  #Obj_DashDust2P,(Dust).w
                tst.b   (Not_ghost_flag).w
                beq.s   SKLevel_JoinCompetitionPaletteUpload
                move.b  (P2_character).w,d0
                bsr.s   SKComp_SelectPlayerHandler
                move.l  d1,(Player_2).w
                move.b  (P2_character).w,(Player_2+character_id).w
                move.l  #Obj_DashDust2P,(Dust_P2).w

SKLevel_JoinCompetitionPaletteUpload:
                bra.s   SKLevel_PrepareCompetitionPaletteLineTwo
; End of function SpawnLevelMainSprites_SpawnPlayers

; =============== S U B R O U T I N E =======================================

; Character byte 1 selects Tails2P. Every other value selects Sonic2P
SKComp_SelectPlayerHandler:
                tst.b   d0
                bne.s   SKLevel_TestCompetitionCharacterForTails
                move.l  #Obj_Sonic2P,d1

SKLevel_TestCompetitionCharacterForTails:
                subq.b  #1,d0
                bne.s   SKLevel_SelectFallbackCompetitionSonic
                move.l  #Obj_Tails2P,d1
                rts
; ---------------------------------------------------------------------------

SKLevel_SelectFallbackCompetitionSonic:
                move.l  #Obj_Sonic2P,d1
                rts
; End of function SKComp_SelectPlayerHandler

; ---------------------------------------------------------------------------

SKLevel_PrepareCompetitionPaletteLineTwo:
                lea     (Target_palette_line_2).w,a2
                lea     (Pal_Level_2P).l,a1
                move.w  #bytesToWcnt($20),d0

SKLevel_CopyCompPaletteLine2:
                move.w  (a1)+,(a2)+
                dbf     d0,SKLevel_CopyCompPaletteLine2
                rts
