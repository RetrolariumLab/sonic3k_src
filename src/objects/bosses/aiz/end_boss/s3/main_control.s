; Owner: objects/bosses/aiz/end_boss/s3
; Responsibility: Angel Island end-boss initialization, battle state, defeat sequence and player transition
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_AIZEndBoss:
                move.w  #$4880,d0
                cmp.w   (Camera_X_pos).w,d0
                bls.s   AIZBossS3_LockCameraAndQueueBossArt  ; Only branch if Sonic has reached the boss area
                rts
; ---------------------------------------------------------------------------

AIZBossS3_LockCameraAndQueueBossArt:
                move.w  d0,(Camera_min_X_pos).w
                move.w  d0,(Camera_max_X_pos).w
                move.l  #Obj_Wait,(a0)                  ; Set up object to wait $78 frames
                move.w  #2*60,$2E(a0)
                move.l  #Obj_AIZEndBossMusic,$34(a0)
                moveq   #signextendB(cmd_FadeOut),d0
                jsr     (Play_Music).l
                move.b  #1,(Boss_flag).w                ; Lock the screen
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
                rts
; ---------------------------------------------------------------------------

Obj_AIZEndBossMain:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  AIZ_EndBossIndex(pc,d0.w),d1
                jsr     AIZ_EndBossIndex(pc,d1.w)
                btst    #6,$38(a0)
                bne.w   AIZBossS3_SharedReturn          ; Only draw and touch when boss has revealed itself
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------
AIZ_EndBossIndex:
                dc.w    Obj_AIZEndBossInit-AIZ_EndBossIndex
                dc.w    AIZBossS3_AnimateRevealBlink-AIZ_EndBossIndex
                dc.w    AIZBossS3_AnimateEmergenceAndCheckHit-AIZ_EndBossIndex
                dc.w    AIZBossS3_SwingMoveAndCheckHit-AIZ_EndBossIndex
                dc.w    AIZBossS3_CheckHitAndTickWait-AIZ_EndBossIndex
                dc.w    AIZBossS3_AnimateRevealBlink-AIZ_EndBossIndex
                dc.w    AIZBossS3_AdvanceTransitCameraMax-AIZ_EndBossIndex
                dc.w    AIZBossS3_MoveAndTickTransit-AIZ_EndBossIndex
; ---------------------------------------------------------------------------

Obj_AIZEndBossInit:
                lea     ObjDat_AIZEndBoss(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.b  #8,collision_property(a0)       ; 8 hits defeats it
                bset    #0,render_flags(a0)
                lea     (Child1_MakeRoboShip).l,a2
                jsr     (CreateChild1_Normal).l
                bne.s   AIZBossS3_SpawnSideAttachments
                move.b  #8,subtype(a1)

AIZBossS3_SpawnSideAttachments:
                lea     AIZBossS3_SideAttachmentChildren(pc),a2
                jsr     (CreateChild1_Normal).l

AIZBossS3_BeginRevealAndSplash:
                move.b  #2,routine(a0)
                moveq   #signextendB(sfx_WaterfallSplash),d0
                jsr     (Play_SFX).l
                ori.b   #$48,$38(a0)
                move.l  #AIZBossS3_EnableCollisionAndEmerge,$34(a0)
                clr.b   collision_flags(a0)
                bsr.w   ResetAIZBossHitFlashPalette
                bclr    #0,render_flags(a0)
                cmpi.w  #8,angle(a0)
                bhs.s   AIZEndBossS3_Root_TryRevealSplashChild
                bset    #0,render_flags(a0)

AIZEndBossS3_Root_TryRevealSplashChild:
                lea     AIZEndBossS3_Root_OneSplashNormalRecord(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

; Frame $2B suppresses the boss draw
AIZBossS3_AnimateRevealBlink:
                lea     AIZBossS3_SubmergedBlinkAnim(pc),a1
                jsr     (Animate_RawNoSSTMultiDelay).l
                bclr    #6,$38(a0)
                cmpi.b  #$2B,mapping_frame(a0)
                bne.s   AIZBossS3_RevealBlinkReturn
                bset    #6,$38(a0)

AIZBossS3_RevealBlinkReturn:
                rts
; ---------------------------------------------------------------------------

AIZBossS3_EnableCollisionAndEmerge:
                move.b  #4,routine(a0)
                bclr    #6,$38(a0)
                bset    #7,art_tile(a0)
                move.b  #$16,collision_flags(a0)
                move.l  #AIZBossS3_BeginExposedSwing,$34(a0)
                lea     AIZBossS3_EmergenceEffectChild(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

AIZBossS3_AnimateEmergenceAndCheckHit:
                lea     AIZBossS3_BodyEmergeAnim(pc),a1
                jsr     (Animate_RawNoSSTMultiDelay).l
                bra.w   HandleAIZBossHitFlashOrDefeat
; ---------------------------------------------------------------------------

AIZBossS3_BeginExposedSwing:
                move.b  #6,routine(a0)
                move.w  #$1F,$2E(a0)
                move.l  #AIZBossS3_RequestAttackAndSetWait,$34(a0)
                move.w  #$C0,d0
                move.w  d0,$3E(a0)
                move.w  d0,y_vel(a0)
                move.w  #$10,$40(a0)
                bclr    #0,$38(a0)

AIZBossS3_SharedReturn:
                rts
; ---------------------------------------------------------------------------

AIZBossS3_SwingMoveAndCheckHit:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                jsr     (Obj_Wait).l
                bra.w   HandleAIZBossHitFlashOrDefeat
; ---------------------------------------------------------------------------

AIZBossS3_RequestAttackAndSetWait:
                bset    #1,$38(a0)
                btst    #7,$38(a0)
                bne.s   AIZBossS3_SetRepeatAttackWait
                move.w  #4,angle(a0)
                move.w  #$2F,$2E(a0)
                move.l  #AIZBossS3_SignalBridgeAndExtendWait,$34(a0)
                rts
; ---------------------------------------------------------------------------

AIZBossS3_SetRepeatAttackWait:
                move.w  #$BF,$2E(a0)
                move.l  #AIZBossS3_BeginStationaryWait,$34(a0)
                rts
; ---------------------------------------------------------------------------

AIZBossS3_BeginStationaryWait:
                move.b  #8,routine(a0)
                move.w  #$3F,$2E(a0)
                move.l  #AIZBossS3_BeginSubmergeAndSplash,$34(a0)
                andi.b  #$F5,$38(a0)
                rts
; ---------------------------------------------------------------------------

AIZBossS3_SignalBridgeAndExtendWait:
                st      (_unkFAA2).w
                move.w  #$8F,$2E(a0)
                move.l  #AIZBossS3_BeginStationaryWait,$34(a0)
                rts
; ---------------------------------------------------------------------------

; Run the wait even when the hit handler has changed the object routine
AIZBossS3_CheckHitAndTickWait:
                bsr.w   HandleAIZBossHitFlashOrDefeat
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

AIZBossS3_BeginSubmergeAndSplash:
                move.b  #$A,routine(a0)
                moveq   #signextendB(sfx_WaterfallSplash),d0
                jsr     (Play_SFX).l
                move.l  #AIZBossS3_SelectFirstOrRepeatTransit,$34(a0)
                clr.b   collision_flags(a0)
                bsr.w   ResetAIZBossHitFlashPalette
                lea     AIZEndBossS3_Root_OneSplashNormalRecord(pc),a2
                jsr     (CreateChild1_Normal).l
                move.b  #2,subtype(a1)
                rts
; ---------------------------------------------------------------------------

AIZBossS3_SelectFirstOrRepeatTransit:
                move.b  #$C,routine(a0)
                bset    #7,$38(a0)
                beq.s   AIZBossS3_ChooseHiddenTransitTarget
                move.b  #$E,routine(a0)

AIZBossS3_ChooseHiddenTransitTarget:
                move.l  #AIZBossS3_StopTransitAndReveal,$34(a0)
                bclr    #7,art_tile(a0)
                move.b  #0,mapping_frame(a0)
                bra.w   AIZBossS3_ChooseNewTransitTarget
; ---------------------------------------------------------------------------

AIZBossS3_AdvanceTransitCameraMax:
                move.w  (Camera_max_X_pos).w,d0
                addq.w  #2,d0
                cmpi.w  #$49A0,d0
                bcc.s   AIZBossS3_AdvanceTransitCameraMin
                move.w  d0,(Camera_max_X_pos).w

AIZBossS3_AdvanceTransitCameraMin:
                move.w  (Camera_min_X_pos).w,d0
                addq.w  #2,d0
                cmpi.w  #$48E0,d0
                bcc.s   AIZBossS3_MoveAndTickTransit
                move.w  d0,(Camera_min_X_pos).w

AIZBossS3_MoveAndTickTransit:
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

AIZBossS3_StopTransitAndReveal:
                clr.w   x_vel(a0)
                clr.w   y_vel(a0)
                bra.w   AIZBossS3_BeginRevealAndSplash
; ---------------------------------------------------------------------------

AIZBossS3_BeginDefeatDebris:
                move.l  #AIZBossS3_InstallCapsuleWatcher,$34(a0)
                st      (_unkFAA3).w
                move.l  #Obj_Wait,(a0)
                bset    #4,$38(a0)
                move.w  #$7F,$2E(a0)
                moveq   #signextendB(cmd_FadeOut),d0
                jsr     (Play_Music).l
                lea     AIZBossS3_DefeatDebrisChildren(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

AIZBossS3_InstallCapsuleWatcher:
                move.l  #AIZBossS3_WaitCapsuleAndOpenExit,(a0)

AIZBossS3_SignalAndSpawnCapsule:
                st      (_unkFAA8).w
                clr.b   (Boss_flag).w
                jsr     (Restore_LevelMusic).l
                lea     (PLC_EggCapsule).l,a1
                jsr     (Load_PLC_Raw).l
                lea     AIZBossS3_DefeatCapsuleChild(pc),a2
                jsr     (CreateChild6_Simple).l
                bset    #1,render_flags(a1)
                jmp     (PLCLoad_AnimalsAndExplosion).l
; ---------------------------------------------------------------------------

AIZBossS3_WaitCapsuleAndOpenExit:
                tst.b   (_unkFAA8).w
                bne.w   AIZBossS3_SharedReturn
                move.l  #AIZBossS3_WalkPlayerToExitGate,(a0)
                clr.b   (_unkFAA8).w
                jsr     (Restore_PlayerControl).l
                lea     (Player_2).w,a1
                jsr     (Restore_PlayerControl2).l
                clr.w   (Ctrl_1_logical).w
                st      (Ctrl_1_locked).w
                move.w  #$48E0+$158,(Camera_stored_max_X_pos).w
                lea     (Child6_IncLevX).l,a2
                jmp     (CreateChild6_Simple).l
; ---------------------------------------------------------------------------

AIZBossS3_WalkPlayerToExitGate:
                move.b  #5,(Flying_picking_Sonic_timer).w
                lea     (Player_1).w,a1
                cmpi.w  #$48E0+$1F8,x_pos(a1)
                bcc.s   AIZBossS3_StopPlayerAndSpawnKnuckles
                move.w  #(button_right_mask<<8)|button_right_mask,(Ctrl_1_logical).w
                rts
; ---------------------------------------------------------------------------

AIZBossS3_StopPlayerAndSpawnKnuckles:
                move.l  #AIZBossS3_HoldUpUntilInputUnlock,(a0)
                clr.w   x_vel(a1)
                clr.w   y_vel(a1)
                clr.w   ground_vel(a1)
                lea     AIZBossS3_CutsceneKnucklesChild(pc),a2
                jsr     (CreateChild6_Simple).l
                move.b  #4,subtype(a1)
                lea     (PLC_Explosion).l,a1
                jmp     (Load_PLC_Raw).l
; ---------------------------------------------------------------------------

AIZBossS3_HoldUpUntilInputUnlock:
                move.b  #5,(Flying_picking_Sonic_timer).w
                tst.b   (Ctrl_1_locked).w
                beq.s   AIZBossS3_InstallExitHeightWait
                move.w  #(button_up_mask<<8)|button_up_mask,(Ctrl_1_logical).w
                rts
; ---------------------------------------------------------------------------

AIZBossS3_InstallExitHeightWait:
                move.l  #AIZBossS3_WaitExitHeight,(a0)
                rts
; ---------------------------------------------------------------------------

AIZBossS3_WaitExitHeight:
                move.b  #5,(Flying_picking_Sonic_timer).w
                cmpi.w  #$15A+$1E6,(Player_1+y_pos).w
                bcc.s   AIZBossS3_StartHCZAndDelete
                rts
; ---------------------------------------------------------------------------

AIZBossS3_StartHCZAndDelete:
                move.w  #$100,d0
                jsr     (StartNewLevel).l
                jmp     (Delete_Current_Sprite).l
; End of function AIZBossS3_WaitExitHeight
