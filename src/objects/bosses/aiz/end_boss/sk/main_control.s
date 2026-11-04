; Owner: objects/bosses/aiz/end_boss/sk
; Responsibility: Angel Island end-boss initialization, battle state, defeat sequence and player transition
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_AIZEndBoss:
                move.l  #Obj_AIZEndBossWait,(a0)
                lea     AIZBossSonicDat(pc),a1
                cmpi.b  #2,(Player_1+character_id).w
                bne.s   AIZBossSK_CopyCharacterArenaBase
                lea     AIZBossKnuxDat(pc),a1

; Copy the trigger X, arena X and exit Y selected for the current character
AIZBossSK_CopyCharacterArenaBase:
                lea     (_unkFA82).w,a2
                move.w  (a1)+,(a2)+
                move.w  (a1)+,(a2)+
                move.w  (a1)+,(a2)+                     ; Load relative positional data depending on the character

Obj_AIZEndBossWait:
                move.w  (_unkFA82).w,d0
                cmp.w   (Camera_X_pos).w,d0
                bls.s   AIZBossSK_LockCameraAndQueueBossArt  ; Only branch if Sonic has reached the boss area
                rts
; ---------------------------------------------------------------------------

AIZBossSK_LockCameraAndQueueBossArt:
                move.w  d0,(Camera_min_X_pos).w
                move.w  d0,(Camera_max_X_pos).w
                move.l  #Obj_Wait,(a0)                  ; Set up object to wait $78 frames
                move.w  #2*60,$2E(a0)
                move.l  #Obj_AIZEndBossMusic,$34(a0)
                moveq   #signextendB(cmd_FadeOut),d0
                jsr     (Play_Music).l
                move.b  #1,(Boss_flag).w                ; Lock the screen
                clr.b   (_unkFAA2).w
                clr.b   (_unkFAA3).w
                moveq   #PLCID_6B,d0
                jsr     (Load_PLC).l                    ; Load Robotnik's ship and explosions
                lea     (ArtKosM_AIZEndBoss).l,a1
                move.w  #tiles_to_bytes(ArtTile_AIZEndBoss),d2
                jsr     (Queue_Kos_Module).l            ; Load the AIZ boss ship
                lea     Pal_AIZEndBoss(pc),a1
                jmp     (PalLoad_Line1).l               ; Load the AIZ boss palette
; ---------------------------------------------------------------------------

Obj_AIZEndBossMusic:
                move.l  #Obj_AIZEndBossMain,(a0)
                moveq   #signextendB(mus_EndBoss),d0    ; Play the boss music
                jsr     (Play_Music).l
                move.b  #mus_EndBoss,(Current_music+1).w
                rts
; ---------------------------------------------------------------------------

Obj_AIZEndBossMain:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  AIZ_EndBossIndex(pc,d0.w),d1
                jsr     AIZ_EndBossIndex(pc,d1.w)
                btst    #6,$38(a0)
                bne.w   AIZBossSK_SharedReturn          ; Only draw and touch when boss has revealed itself
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------
AIZ_EndBossIndex:
                dc.w    Obj_AIZEndBossInit-AIZ_EndBossIndex
                dc.w    AIZBossSK_AnimateRevealBlink-AIZ_EndBossIndex
                dc.w    AIZBossSK_AnimateEmergenceAndCheckHit-AIZ_EndBossIndex
                dc.w    AIZBossSK_SwingMoveAndCheckHit-AIZ_EndBossIndex
                dc.w    AIZBossSK_CheckHitAndTickWait-AIZ_EndBossIndex
                dc.w    AIZBossSK_AnimateRevealBlink-AIZ_EndBossIndex
                dc.w    AIZBossSK_CheckTransitCameraMin-AIZ_EndBossIndex
                dc.w    AIZBossSK_MoveAndTickTransit-AIZ_EndBossIndex
; ---------------------------------------------------------------------------

Obj_AIZEndBossInit:
                lea     ObjDat_AIZEndBoss(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.b  #8,collision_property(a0)       ; 8 hits defeats it
                bset    #0,render_flags(a0)
                lea     (Child1_MakeRoboShip).l,a2
                jsr     (CreateChild1_Normal).l
                bne.s   AIZBossSK_SpawnSideAttachments
                move.b  #8,subtype(a1)

AIZBossSK_SpawnSideAttachments:
                lea     AIZBossSK_SideAttachmentChildren(pc),a2
                jsr     (CreateChild1_Normal).l

AIZBossSK_BeginRevealAndSplash:
                move.b  #2,routine(a0)
                moveq   #signextendB(sfx_WaterfallSplash),d0
                jsr     (Play_SFX).l
                ori.b   #$48,$38(a0)
                move.l  #AIZBossSK_EnableCollisionAndEmerge,$34(a0)
                clr.b   collision_flags(a0)
                bsr.w   ResetAIZBossHitFlashPalette
                bclr    #0,render_flags(a0)
                cmpi.w  #8,angle(a0)
                bhs.s   AIZBossSK_SpawnRevealSplash
                bset    #0,render_flags(a0)

AIZBossSK_SpawnRevealSplash:
                lea     AIZEndBossSK_Root_OneSplashNormalRecord(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

; Frame $2B suppresses the boss draw
AIZBossSK_AnimateRevealBlink:
                lea     AIZBossSK_SubmergedBlinkAnim(pc),a1
                jsr     (Animate_RawNoSSTMultiDelay).l
                bclr    #6,$38(a0)
                cmpi.b  #$2B,mapping_frame(a0)
                bne.s   AIZBossSK_RevealBlinkReturn
                bset    #6,$38(a0)

AIZBossSK_RevealBlinkReturn:
                rts
; ---------------------------------------------------------------------------

AIZBossSK_EnableCollisionAndEmerge:
                move.b  #4,routine(a0)
                bclr    #6,$38(a0)
                bset    #7,art_tile(a0)
                move.b  #$16,collision_flags(a0)
                move.l  #AIZBossSK_BeginExposedSwing,$34(a0)
                lea     AIZBossSK_EmergenceEffectChild(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

AIZBossSK_AnimateEmergenceAndCheckHit:
                lea     AIZBossSK_BodyEmergeAnim(pc),a1
                jsr     (Animate_RawNoSSTMultiDelay).l
                bra.w   HandleAIZBossHitFlashOrDefeat
; ---------------------------------------------------------------------------

AIZBossSK_BeginExposedSwing:
                move.b  #6,routine(a0)
                move.w  #$1F,$2E(a0)
                move.l  #AIZBossSK_RequestAttackAndSetWait,$34(a0)
                move.w  #$C0,d0
                move.w  d0,$3E(a0)
                move.w  d0,y_vel(a0)
                move.w  #$10,$40(a0)
                bclr    #0,$38(a0)

AIZBossSK_SharedReturn:
                rts
; ---------------------------------------------------------------------------

AIZBossSK_SwingMoveAndCheckHit:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                jsr     (Obj_Wait).l
                bra.w   HandleAIZBossHitFlashOrDefeat
; ---------------------------------------------------------------------------

AIZBossSK_RequestAttackAndSetWait:
                bset    #1,$38(a0)
                btst    #7,$38(a0)
                bne.s   AIZBossSK_ChooseRepeatAttackWait
                move.w  #4,angle(a0)
                move.w  #$2F,$2E(a0)
                move.l  #AIZBossSK_SignalBridgeAndExtendWait,$34(a0)
                rts
; ---------------------------------------------------------------------------

; Give Knuckles 256 calls, compared with 192 for the other characters
AIZBossSK_ChooseRepeatAttackWait:
                move.w  #$BF,d0
                cmpi.b  #2,(Player_1+character_id).w
                bne.s   AIZBossSK_SetRepeatAttackWait
                move.w  #$FF,d0

AIZBossSK_SetRepeatAttackWait:
                move.w  d0,$2E(a0)
                move.l  #AIZBossSK_BeginStationaryWait,$34(a0)
                rts
; ---------------------------------------------------------------------------

AIZBossSK_BeginStationaryWait:
                move.b  #8,routine(a0)
                move.w  #$3F,$2E(a0)
                move.l  #AIZBossSK_BeginSubmergeAndSplash,$34(a0)
                andi.b  #$F5,$38(a0)
                rts
; ---------------------------------------------------------------------------

AIZBossSK_SignalBridgeAndExtendWait:
                st      (_unkFAA2).w
                move.w  #$8F,$2E(a0)
                move.l  #AIZBossSK_BeginStationaryWait,$34(a0)
                rts
; ---------------------------------------------------------------------------

; Run the wait even when the hit handler has changed the object routine
AIZBossSK_CheckHitAndTickWait:
                bsr.w   HandleAIZBossHitFlashOrDefeat
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

AIZBossSK_BeginSubmergeAndSplash:
                move.b  #$A,routine(a0)
                moveq   #signextendB(sfx_WaterfallSplash),d0
                jsr     (Play_SFX).l
                move.l  #AIZBossSK_SelectFirstOrRepeatTransit,$34(a0)
                clr.b   collision_flags(a0)
                bsr.w   ResetAIZBossHitFlashPalette
                lea     AIZEndBossSK_Root_OneSplashNormalRecord(pc),a2
                jsr     (CreateChild1_Normal).l
                move.b  #2,subtype(a1)
                rts
; ---------------------------------------------------------------------------

AIZBossSK_SelectFirstOrRepeatTransit:
                move.b  #$C,routine(a0)
                bset    #7,$38(a0)
                beq.s   AIZBossSK_ChooseHiddenTransitTarget
                move.b  #$E,routine(a0)

AIZBossSK_ChooseHiddenTransitTarget:
                move.l  #AIZBossSK_StopTransitAndReveal,$34(a0)
                bclr    #7,art_tile(a0)
                move.b  #0,mapping_frame(a0)
                bra.w   AIZBossSK_ChooseNewTransitTarget
; ---------------------------------------------------------------------------

AIZBossSK_CheckTransitCameraMin:
                move.w  (Camera_min_X_pos).w,d0
                addq.w  #2,d0
                cmp.w   (_unkFA84).w,d0
                bhi.s   AIZBossSK_AdvanceTransitCameraMax
                move.w  d0,(Camera_min_X_pos).w

AIZBossSK_AdvanceTransitCameraMax:
                addq.w  #2,(Camera_max_X_pos).w

AIZBossSK_MoveAndTickTransit:
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

AIZBossSK_StopTransitAndReveal:
                clr.w   x_vel(a0)
                clr.w   y_vel(a0)
                bra.w   AIZBossSK_BeginRevealAndSplash
; ---------------------------------------------------------------------------

AIZBossSK_BeginDefeatDebris:
                move.l  #AIZBossSK_InstallCapsuleWatcher,$34(a0)
                st      (_unkFAA3).w
                move.l  #Obj_Wait,(a0)
                bset    #4,$38(a0)
                lea     AIZBossSK_DefeatDebrisChildren(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

AIZBossSK_InstallCapsuleWatcher:
                move.l  #AIZBossSK_WaitCapsuleAndOpenExit,(a0)

AIZBossSK_SignalAndSpawnCapsule:
                st      (_unkFAA8).w
                clr.b   (Boss_flag).w
                lea     (PLC_EggCapsule).l,a1
                jsr     (Load_PLC_Raw).l
                lea     AIZBossSK_DefeatCapsuleChild(pc),a2
                jsr     (CreateChild6_Simple).l
                bset    #1,render_flags(a1)
                jmp     (PLCLoad_AnimalsAndExplosion).l
; ---------------------------------------------------------------------------

AIZBossSK_WaitCapsuleAndOpenExit:
                tst.b   (_unkFAA8).w
                bne.w   AIZBossSK_SharedReturn
                move.l  #AIZBossSK_WalkPlayerToExitGate,(a0)
                jsr     (Restore_PlayerControl).l
                lea     (Player_2).w,a1
                jsr     (Restore_PlayerControl2).l
                jsr     (Restore_LevelMusic).l
                st      (Ctrl_1_locked).w
                clr.w   (Ctrl_1_logical).w
                jsr     (AllocateObject).l
                bne.s   AIZBossSK_ExtendExitCameraMaxX
                move.l  #SKInput_LockP2IfActive,(a1)

AIZBossSK_ExtendExitCameraMaxX:
                move.w  (_unkFA84).w,d0
                addi.w  #$158,d0
                move.w  d0,(Camera_stored_max_X_pos).w
                lea     (Child6_IncLevX).l,a2
                jmp     (CreateChild6_Simple).l
; ---------------------------------------------------------------------------

AIZBossSK_WalkPlayerToExitGate:
                move.b  #5,(Flying_picking_Sonic_timer).w
                lea     (Player_1).w,a1
                move.w  (_unkFA84).w,d0
                addi.w  #$1F8,d0
                cmp.w   x_pos(a1),d0
                bls.s   AIZBossSK_StopPlayerAndRouteExit
                move.w  #(button_right_mask<<8)|button_right_mask,(Ctrl_1_logical).w
                rts
; ---------------------------------------------------------------------------

AIZBossSK_StopPlayerAndRouteExit:
                jsr     (Stop_Object).l
                cmpi.b  #2,(Player_1+character_id).w
                beq.s   AIZBossSK_KnucklesStartExitJump
                move.l  #AIZBossSK_HoldUpUntilInputUnlock,(a0)
                jsr     (AllocateObject).l
                bne.s   AIZBossSK_LoadExitExplosionArt
                move.l  #Obj_CutsceneKnuckles,(a1)
                move.b  #4,subtype(a1)

AIZBossSK_LoadExitExplosionArt:
                lea     (PLC_Explosion).l,a1
                jmp     (Load_PLC_Raw).l
; ---------------------------------------------------------------------------

AIZBossSK_KnucklesStartExitJump:
                move.l  #AIZBossSK_KnucklesWaitForJumpApex,(a0)
                move.w  #(button_C_mask<<8)|button_C_mask,(Ctrl_1_logical).w
                rts
; ---------------------------------------------------------------------------

AIZBossSK_HoldUpUntilInputUnlock:
                move.b  #5,(Flying_picking_Sonic_timer).w
                tst.b   (Ctrl_1_locked).w
                beq.s   AIZBossSK_InstallExitHeightWait
                move.w  #(button_up_mask<<8)|button_up_mask,(Ctrl_1_logical).w
                clr.w   (Ctrl_2_logical).w
                rts
; ---------------------------------------------------------------------------

AIZBossSK_InstallExitHeightWait:
                move.l  #AIZBossSK_RefreshExitPickupDelay,(a0)
                rts
; ---------------------------------------------------------------------------

AIZBossSK_RefreshExitPickupDelay:
                move.b  #5,(Flying_picking_Sonic_timer).w

AIZBossSK_CheckExitHeightAndStartHCZ:
                move.w  (_unkFA86).w,d0
                addi.w  #$1E6,d0
                cmp.w   (Player_1+y_pos).w,d0
                bhi.w   AIZBossSK_SharedReturn
                move.w  #$100,d0
                jsr     (StartNewLevel).l
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

AIZBossSK_KnucklesWaitForJumpApex:
                move.w  #button_C_mask<<8,(Ctrl_1_logical).w
                lea     (Player_1).w,a1
                bset    #7,art_tile(a1)
                tst.w   y_vel(a1)
                bmi.w   AIZBossSK_SharedReturn
                move.l  #AIZBossSK_KnucklesFallToExitHeight,(a0)
                move.b  #$83,object_control(a1)
                move.b  #$CB,mapping_frame(a1)
                jsr     (Player_Load_PLC).l
                move.w  #$1000,d0
                move.w  d0,(Camera_stored_max_Y_pos).w
                move.w  d0,(Camera_target_max_Y_pos).w
                lea     (Child6_IncLevY).l,a2
                jmp     (CreateChild6_Simple).l
; ---------------------------------------------------------------------------

AIZBossSK_KnucklesFallToExitHeight:
                lea     (Player_1).w,a1
                jsr     (MoveSprite_NormGravity).l
                bra.s   AIZBossSK_CheckExitHeightAndStartHCZ
