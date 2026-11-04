; Owner: objects/cutscenes/hpz/sk
; Responsibility: Hidden Palace Knuckles encounter setup, combat movement, attack and defeat transition state program
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

CutsceneKnux_HPZ:
                movea.l a0,a1
                move.l  #HPZKnux_CheckCameraAndBeginEncounter,(a1)
                lea     (Dynamic_object_RAM+(object_size*45)).w,a2
                move.w  a2,(_unkFAA4).w
                moveq   #bytesToWcnt(object_size),d0

HPZKnux_CopyRelocatedActorAndDelete:
                move.w  (a1)+,(a2)+
                dbf     d0,HPZKnux_CopyRelocatedActorAndDelete
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

HPZKnux_CheckCameraAndBeginEncounter:
                cmpi.b  #2,(Player_1+character_id).w
                beq.w   CutsceneKnux_Delete
                lea     LRZ2Scene_HPZCameraBoundsAndSplit(pc),a1
                jsr     (Check_CameraInRange).l
                jsr     (Boss_BeginCameraTransition).l
                jsr     (AllocateObject).l
                bne.s   HPZKnux_InitEncounterAndPalette
                move.l  #SKEndCamera_TickAndSaveMusic,(a1)
                move.l  #HPZKnux_SignalCameraReadyAndDelete,$34(a1)
                move.b  #mus_Knuckles,boss_saved_mus(a1)
                move.w  #2*60,$2E(a1)
                move.b  $27(a0),$27(a1)

HPZKnux_InitEncounterAndPalette:
                move.l  #HPZKnux_DispatchLoadArtAndDraw,(a0)
                move.l  #Map_Knuckles,mappings(a0)
                move.w  #make_art_tile(ArtTile_CutsceneKnux,1,0),art_tile(a0)
                move.w  #$100,priority(a0)
                move.b  #$18,width_pixels(a0)
                move.b  #$18,height_pixels(a0)
                move.b  #$13,y_radius(a0)
                move.b  #9,x_radius(a0)
                move.b  #4,render_flags(a0)
                bset    #0,render_flags(a0)
                move.b  #$D8,mapping_frame(a0)
                move.b  #8,collision_property(a0)
                move.l  #SKSceneAnim_HPZEncounterOpening,$30(a0)
                clr.w   $44(a0)
                lea     (Normal_palette_line_2).w,a1
                lea     (Target_palette_line_2).w,a2
                moveq   #bytesToLcnt($20),d6

HPZKnux_CopyAndLoadScenePalette:
                move.l  (a1)+,(a2)+
                dbf     d6,HPZKnux_CopyAndLoadScenePalette
                lea     Pal_CutsceneKnux(pc),a1
                jsr     (PalLoad_Line1).l
                move.w  #$88,(Normal_palette_line_2+$C).w
                rts
; ---------------------------------------------------------------------------

HPZKnux_SignalCameraReadyAndDelete:
                bset    #0,(_unkFAB8).w
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

HPZKnux_DispatchLoadArtAndDraw:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  SKHPZKnuckles_StateRelativeWordTable(pc,d0.w),d1
                jsr     SKHPZKnuckles_StateRelativeWordTable(pc,d1.w)
                move.w  $44(a0),d0
                move.w  HPZKnux_GraphicsLoaderOffsets(pc,d0.w),d0
                jsr     HPZKnux_GraphicsLoaderOffsets(pc,d0.w)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
HPZKnux_GraphicsLoaderOffsets:
                dc.w    HPZKnux_LoadNormalCutsceneArt-HPZKnux_GraphicsLoaderOffsets
                dc.w    SKHPZKnuckles_LoadHPZGrabCutsceneArt-HPZKnux_GraphicsLoaderOffsets
                dc.w    SKHPZKnuckles_LoadSSZTiredCutsceneArt-HPZKnux_GraphicsLoaderOffsets
; ---------------------------------------------------------------------------

HPZKnux_LoadNormalCutsceneArt:
                bra.w   SKScene_LoadKnuxArtToSceneTiles
; ---------------------------------------------------------------------------

SKHPZKnuckles_LoadHPZGrabCutsceneArt:
                lea     DPLCPtr_HPZKnucklesGrab(pc),a2
                jmp     (Perform_DPLC).l
; ---------------------------------------------------------------------------

SKHPZKnuckles_LoadSSZTiredCutsceneArt:
                lea     DPLCPtr_SSZKnucklesTired(pc),a2
                jmp     (Perform_DPLC).l
; ---------------------------------------------------------------------------
SKHPZKnuckles_StateRelativeWordTable:
                dc.w    HPZKnux_AnimateIdleAndCountLoops-SKHPZKnuckles_StateRelativeWordTable
                dc.w    HPZKnux_AnimateGuardAndCheckTarget-SKHPZKnuckles_StateRelativeWordTable
                dc.w    HPZKnux_UpdateRecoilMotion-SKHPZKnuckles_StateRelativeWordTable
                dc.w    HPZKnux_TickShortHoldAndCheckContact-SKHPZKnuckles_StateRelativeWordTable
                dc.w    HPZKnux_AnimateJumpPreparation-SKHPZKnuckles_StateRelativeWordTable
                dc.w    HPZKnux_JumpAndSwitchAtApex-SKHPZKnuckles_StateRelativeWordTable
                dc.w    HPZKnux_AirRushAndCheckPassedTarget-SKHPZKnuckles_StateRelativeWordTable
                dc.w    HPZKnux_TurnaroundFallAndCheckFloor-SKHPZKnuckles_StateRelativeWordTable
                dc.w    HPZKnux_AnimateLandingAndCheckGuard-SKHPZKnuckles_StateRelativeWordTable
                dc.w    HPZKnux_PlayPeriodicChargeSound-SKHPZKnuckles_StateRelativeWordTable
                dc.w    HPZKnux_DashAndCheckCameraMargin-SKHPZKnuckles_StateRelativeWordTable
                dc.w    HPZKnux_HitBounceAndCheckLanding-SKHPZKnuckles_StateRelativeWordTable
                dc.w    HPZKnux_DefeatBounceAndCheckFloor-SKHPZKnuckles_StateRelativeWordTable
                dc.w    HPZKnux_AnimateDefeatLanding-SKHPZKnuckles_StateRelativeWordTable
                dc.w    HPZKnux_PlayPeriodicCollapseSound-SKHPZKnuckles_StateRelativeWordTable
                dc.w    SKHPZKnuckles_CountResetPoseDelay-SKHPZKnuckles_StateRelativeWordTable
                dc.w    HPZKnux_TickPreRunAnimDelay-SKHPZKnuckles_StateRelativeWordTable
                dc.w    HPZKnux_AnimateAndAccelerateRight-SKHPZKnuckles_StateRelativeWordTable
                dc.w    HPZKnux_AnimateAndWaitForShipReady-SKHPZKnuckles_StateRelativeWordTable
                dc.w    HPZKnux_JumpTowardShipAndCheckFloor-SKHPZKnuckles_StateRelativeWordTable
                dc.w    SKHPZKnuckles_CountShortLandedJumpPause-SKHPZKnuckles_StateRelativeWordTable
                dc.w    HPZKnux_JumpLeftAndCheckHeight-SKHPZKnuckles_StateRelativeWordTable
                dc.w    HPZKnux_TickGrabPauseBeforeRun-SKHPZKnuckles_StateRelativeWordTable
                dc.w    HPZKnux_AnimateAndCapRightRun-SKHPZKnuckles_StateRelativeWordTable
                dc.w    HPZKnux_TickGrabHoldBeforeJump-SKHPZKnuckles_StateRelativeWordTable
                dc.w    HPZKnux_JumpAndCheckShipContact-SKHPZKnuckles_StateRelativeWordTable
                dc.w    HPZKnux_ReboundAndCheckHeight-SKHPZKnuckles_StateRelativeWordTable
                dc.w    HPZKnux_AccelerateTowardEmerald-SKHPZKnuckles_StateRelativeWordTable
                dc.w    HPZKnux_JumpAndCheckEmeraldContact-SKHPZKnuckles_StateRelativeWordTable
                dc.w    HPZKnux_CheckShipReleaseSignal-SKHPZKnuckles_StateRelativeWordTable
                dc.w    HPZKnux_TickHoldAndSelectParityFrame-SKHPZKnuckles_StateRelativeWordTable
                dc.w    HPZKnux_SelectParityFrameBeforeFall-SKHPZKnuckles_StateRelativeWordTable
                dc.w    HPZKnux_AnimatePostReleaseLanding-SKHPZKnuckles_StateRelativeWordTable
                dc.w    HPZKnux_WaitForGuideRumbleSignal-SKHPZKnuckles_StateRelativeWordTable
                dc.w    HPZKnux_TickRumbleDelay-SKHPZKnuckles_StateRelativeWordTable
                dc.w    HPZKnux_FallAndCheckRumbleFloor-SKHPZKnuckles_StateRelativeWordTable
                dc.w    HPZKnux_AnimateRumbleLanding-SKHPZKnuckles_StateRelativeWordTable
                dc.w    HPZKnux_AnimateExtendedPause-SKHPZKnuckles_StateRelativeWordTable
                dc.w    HPZKnux_TickPoseResetDelay-SKHPZKnuckles_StateRelativeWordTable
                dc.w    HPZKnux_AccelerateLeftToWorldX-SKHPZKnuckles_StateRelativeWordTable
                dc.w    HPZKnux_AnimateGrabUntilRetreat-SKHPZKnuckles_StateRelativeWordTable
                dc.w    HPZKnux_AnimateRetreatAndSignalPlatform-SKHPZKnuckles_StateRelativeWordTable
                dc.w    HPZKnux_RetreatRunToCameraLeft-SKHPZKnuckles_StateRelativeWordTable
                dc.w    HPZKnux_AnimateTiredAndCheckDeparture-SKHPZKnuckles_StateRelativeWordTable
                dc.w    HPZKnux_UpdateFinalJumpToWorldX-SKHPZKnuckles_StateRelativeWordTable
                dc.w    HPZKnux_AnimateTiredAndWaitForBeam-SKHPZKnuckles_StateRelativeWordTable
                dc.w    HPZKnux_AnimateTerminalWait-SKHPZKnuckles_StateRelativeWordTable
; ---------------------------------------------------------------------------

HPZKnux_AnimateIdleAndCountLoops:
                jsr     (Animate_Raw2MultiDelay).l
                tst.w   d2
                bpl.s   HPZKnux_FaceTargetAndCheckRange
                btst    #0,(_unkFAB8).w
                beq.s   HPZKnux_FaceTargetAndCheckRange
                move.b  $39(a0),d0
                addq.b  #1,d0
                cmpi.b  #2,d0
                bhs.w   HPZKnux_Begin59TickCharge
                move.b  d0,$39(a0)

HPZKnux_FaceTargetAndCheckRange:
                jsr     (Find_SonicTails).l
                bsr.w   HPZKnucklesFaceTargetFromSideWord
                cmpi.w  #$40,d3
                bhs.w   SKAIZScene_SharedSceneReturn
                cmpi.w  #$30,d2
                bhs.w   SKAIZScene_SharedSceneReturn
                bra.w   HPZKnux_StartTwoSecondGuard
; ---------------------------------------------------------------------------

HPZKnux_ResetIdleAndStop:
                move.b  #0,routine(a0)
                clr.b   $39(a0)
                clr.w   x_vel(a0)
                clr.w   y_vel(a0)
                lea     SKSceneAnim_HPZEncounterOpening(pc),a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

HPZKnux_AnimateGuardAndCheckTarget:
                jsr     (Animate_RawCheckResult).l
                jsr     (Find_SonicTails).l
                bsr.w   HPZKnucklesFaceTargetFromSideWord
                cmpi.w  #$10,d3
                bhs.s   HPZKnux_TickGuardOrDispatchContact
                cmpi.w  #$20,d2
                bhs.s   HPZKnux_TickGuardOrDispatchContact
                cmpi.b  #2,anim(a1)
                bne.w   HPZKnux_BeginAttackIfPlayerNotHurt

HPZKnux_TickGuardOrDispatchContact:
                subq.w  #1,$2E(a0)
                bmi.w   HPZKnux_BeginJumpPreparation
                lea     HPZKnux_GuardContactHandlers(pc),a3
                bra.w   SKScene_HPZCheckPackedPlayerContacts
; ---------------------------------------------------------------------------
HPZKnux_GuardContactHandlers:
                dc.l    HPZKnux_BeginRecoilAndReversePlayer
                dc.l    HPZKnux_BeginAttackIfPlayerNotHurt
                dc.l    HPZKnux_TakeHitAndSelectRecoil
                dc.l    SKScene_HPZCheckHurtInvulnTimer
; ---------------------------------------------------------------------------

HPZKnux_StartTwoSecondGuard:
                move.b  #2,routine(a0)
                move.b  #$DA,mapping_frame(a0)
                move.w  #(2*60)-1,$2E(a0)
                lea     SKHpzKnuckles_FrontContactBodyFrameLoop(pc),a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

HPZKnux_UpdateRecoilMotion:
                jsr     (HPZKnux_StopAtCameraXMargins).l
                move.w  x_vel(a0),d0
                beq.s   HPZKnux_AnimateRecoilAndCheckResult
                move.w  $40(a0),d1
                add.w   d1,d0
                move.w  d0,x_vel(a0)
                jsr     (MoveSprite2).l

HPZKnux_AnimateRecoilAndCheckResult:
                jsr     (Animate_Raw2MultiDelay).l
                bmi.w   SKAIZScene_SharedSceneReturn
                lea     HPZKnux_RecoilContactHandlers(pc),a3
                bra.w   SKScene_HPZCheckPackedPlayerContacts
; ---------------------------------------------------------------------------
HPZKnux_RecoilContactHandlers:
                dc.l    HPZKnux_BeginRecoilAndReversePlayer
                dc.l    SKScene_HPZCheckHurtInvulnTimer
                dc.l    HPZKnux_TakeHitAndSelectRecoil
                dc.l    SKScene_HPZCheckHurtInvulnTimer
; ---------------------------------------------------------------------------

HPZKnux_BeginRecoilAndReversePlayer:
                move.b  #4,routine(a0)
                move.l  #HPZKnux_ResetIdleAndStop,$34(a0)
                move.w  #$2C0,d3
                move.w  #-$20,d4
                btst    #0,render_flags(a0)
                bne.s   HPZKnux_StoreRecoilAndChooseMinSpeed
                neg.w   d3
                neg.w   d4

HPZKnux_StoreRecoilAndChooseMinSpeed:
                move.w  d3,x_vel(a0)
                move.w  d4,$40(a0)
                move.w  x_vel(a1),d0
                move.w  #$100,d1
                move.w  #-$100,d2
                cmp.w   d2,d0
                blt.s   HPZKnux_ReversePlayerAndSetRecoilAnim
                cmp.w   d1,d0
                bge.s   HPZKnux_ReversePlayerAndSetRecoilAnim
                tst.w   d0
                bpl.s   HPZKnux_ApplyMinimumPlayerXSpeed
                move.w  d2,d1

HPZKnux_ApplyMinimumPlayerXSpeed:
                move.w  d1,d0

HPZKnux_ReversePlayerAndSetRecoilAnim:
                neg.w   d0
                move.w  d0,x_vel(a1)
                neg.w   y_vel(a1)
                neg.w   ground_vel(a1)
                lea     SKSceneAnim_HPZFrontCounterRecoil(pc),a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

HPZKnux_TickShortHoldAndCheckContact:
                subq.w  #1,$2E(a0)
                bmi.w   HPZKnux_ResetIdleAndStop
                lea     HPZKnux_ShortHoldContactHandlers(pc),a3
                bra.w   SKScene_HPZCheckPackedPlayerContacts
; ---------------------------------------------------------------------------
HPZKnux_ShortHoldContactHandlers:
                dc.l    SKScene_HPZCheckHurtInvulnTimer
                dc.l    SKScene_HPZCheckHurtInvulnTimer
                dc.l    HPZKnux_TakeHitAndSelectRecoil
                dc.l    SKScene_HPZCheckHurtInvulnTimer
; ---------------------------------------------------------------------------

HPZKnux_BeginAttackIfPlayerNotHurt:
                tst.b   $34(a1)
                bne.w   SKAIZScene_SharedSceneReturn
                move.b  #6,routine(a0)
                move.b  #$DE,mapping_frame(a0)
                move.w  #7,$2E(a0)
                bra.w   SKScene_HPZHurtUnlessInvincible
; ---------------------------------------------------------------------------

HPZKnux_AnimateJumpPreparation:
                jmp     (Animate_RawCheckResult).l
; ---------------------------------------------------------------------------

HPZKnux_LaunchVerticalJump:
                move.b  #$A,routine(a0)
                move.w  #-$600,y_vel(a0)
                moveq   #signextendB(sfx_Jump),d0
                jsr     (Play_SFX).l
                lea     SKSceneAnim_KnuxJumpAndFastTravel(pc),a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

HPZKnux_JumpAndSwitchAtApex:
                jsr     (Animate_RawCheckResult).l
                jsr     (MoveSprite).l
                tst.w   y_vel(a0)
                bpl.w   HPZKnux_BeginAirRushAtApex
                lea     HPZKnux_HurtContactHandlers(pc),a3
                bra.w   SKScene_HPZCheckPackedPlayerContacts
; ---------------------------------------------------------------------------
HPZKnux_HurtContactHandlers:
                dc.l    SKScene_HPZCheckHurtInvulnTimer
                dc.l    SKScene_HPZCheckHurtInvulnTimer
                dc.l    SKScene_HPZCheckHurtInvulnTimer
                dc.l    SKScene_HPZCheckHurtInvulnTimer
; ---------------------------------------------------------------------------

HPZKnux_BeginJumpPreparation:
                move.b  #8,routine(a0)
                jsr     (Find_SonicTails).l
                bsr.w   HPZKnucklesFaceTargetFromSideWord
                clr.w   x_vel(a0)
                clr.w   y_vel(a0)
                move.l  #HPZKnux_LaunchVerticalJump,$34(a0)
                lea     SKHpzKnuckles_PreJumpBodyFrameSequence(pc),a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

HPZKnux_AirRushAndCheckPassedTarget:
                jsr     (HPZKnux_StopAtCameraXMargins).l
                jsr     (MoveSprite2).l
                tst.w   x_vel(a0)
                beq.w   HPZKnux_BeginTurnaroundFall
                jsr     (Find_SonicTails).l
                cmpi.w  #$30,d2
                blo.s   SKHPZKnuckles_DispatchAirRushContact
                btst    #0,render_flags(a0)
                sne     d4
                tst.w   d0
                beq.s   HPZKnux_CheckRushFacingAgainstTarget
                not.b   d4

HPZKnux_CheckRushFacingAgainstTarget:
                tst.b   d4
                beq.w   HPZKnux_BeginTurnaroundFall

SKHPZKnuckles_DispatchAirRushContact:
                lea     HPZKnux_AirRushContactHandlers(pc),a3
                bra.w   SKScene_HPZCheckPackedPlayerContacts
; ---------------------------------------------------------------------------
HPZKnux_AirRushContactHandlers:
                dc.l    SKScene_HPZCheckHurtInvulnTimer
                dc.l    SKScene_HPZCheckHurtInvulnTimer
                dc.l    HPZKnux_TakeHitAndSelectRecoil
                dc.l    SKScene_HPZCheckHurtInvulnTimer
; ---------------------------------------------------------------------------

HPZKnux_BeginAirRushAtApex:
                move.b  #$C,routine(a0)
                move.b  #$C0,mapping_frame(a0)
                move.w  #$400,d0
                btst    #0,render_flags(a0)
                beq.s   SKHPZKnuckles_StoreAirRushSpeeds
                neg.w   d0

SKHPZKnuckles_StoreAirRushSpeeds:
                move.w  d0,x_vel(a0)
                move.w  #$80,y_vel(a0)
                rts
; ---------------------------------------------------------------------------

HPZKnux_TurnaroundFallAndCheckFloor:
                jsr     (Animate_Raw2MultiDelay).l
                jsr     (MoveSprite).l
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bmi.w   HPZKnux_LandTurnaroundAndSetIdle
                lea     HPZKnux_TurnaroundContactHandlers(pc),a3
                bra.w   SKScene_HPZCheckPackedPlayerContacts
; ---------------------------------------------------------------------------
HPZKnux_TurnaroundContactHandlers:
                dc.l    HPZKnux_TakeHitAndSelectRecoil
                dc.l    SKScene_HPZCheckHurtInvulnTimer
                dc.l    HPZKnux_TakeHitAndSelectRecoil
                dc.l    SKScene_HPZCheckHurtInvulnTimer
; ---------------------------------------------------------------------------

HPZKnux_BeginTurnaroundFall:
                move.b  #$E,routine(a0)
                bchg    #0,render_flags(a0)
                clr.w   x_vel(a0)
                lea     SKHpzKnuckles_DescendingBodyTimedLoop(pc),a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

HPZKnux_AnimateLandingAndCheckGuard:
                jsr     (Animate_RawCheckResult).l
                jsr     (Find_SonicTails).l
                bsr.w   HPZKnucklesFaceTargetFromSideWord
                lea     HPZKnux_GuardContactHandlers(pc),a3
                bra.w   SKScene_HPZCheckPackedPlayerContacts
; ---------------------------------------------------------------------------

HPZKnux_LandTurnaroundAndSetIdle:
                add.w   d1,y_pos(a0)
                move.b  #$10,routine(a0)
                clr.w   y_vel(a0)
                move.l  #HPZKnux_ResetIdleAndStop,$34(a0)
                lea     SKHpzKnuckles_LandingBodyFrameSequence(pc),a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

HPZKnux_PlayPeriodicChargeSound:
                move.b  (V_int_run_count+3).w,d0
                andi.b  #$F,d0
                bne.s   HPZKnux_AnimateChargeAndSpawnDust
                moveq   #signextendB(sfx_Roll),d0
                jsr     (Play_SFX).l

; Spawn dust only when the decremented charge timer equals 43
HPZKnux_AnimateChargeAndSpawnDust:
                jsr     (Animate_RawCheckResult).l
                subq.w  #1,$2E(a0)
                bmi.w   HPZKnux_BeginFastDashAndCloseDust
                cmpi.w  #43,$2E(a0)
                bne.s   SKHPZKnuckles_DispatchChargeHurtContact
                bclr    #0,$38(a0)
                lea     SKHpzEncounter_SpinPhaseDustSpawnList(pc),a2
                jsr     (CreateChild6_Simple).l

SKHPZKnuckles_DispatchChargeHurtContact:
                lea     HPZKnux_HurtContactHandlers(pc),a3
                bra.w   SKScene_HPZCheckPackedPlayerContacts
; ---------------------------------------------------------------------------

HPZKnux_Begin59TickCharge:
                move.b  #$12,routine(a0)
                jsr     (Find_SonicTails).l
                bsr.w   HPZKnucklesFaceTargetFromSideWord
                clr.w   x_vel(a0)
                clr.w   y_vel(a0)
                move.w  #60-1,$2E(a0)
                lea     SKSceneAnim_HPZTravelWindupWithTailLoop(pc),a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

HPZKnux_DashAndCheckCameraMargin:
                jsr     (Animate_RawCheckResult).l
                jsr     (HPZKnux_StopAtCameraXMargins).l
                tst.w   x_vel(a0)
                bne.s   HPZKnux_AccelerateDashAndCheckHurt
                bchg    #0,render_flags(a0)
                subq.w  #4,y_pos(a0)
                bra.w   HPZKnux_ResetIdleAndStop
; ---------------------------------------------------------------------------

HPZKnux_AccelerateDashAndCheckHurt:
                move.w  $40(a0),d0
                add.w   d0,x_vel(a0)
                jsr     (MoveSprite2).l
                lea     HPZKnux_HurtContactHandlers(pc),a3
                bra.w   SKScene_HPZCheckPackedPlayerContacts
; ---------------------------------------------------------------------------

HPZKnux_BeginFastDashAndCloseDust:
                move.b  #$14,routine(a0)
                bset    #0,$38(a0)
                move.w  #$800,d0
                move.w  #-$10,d1
                btst    #0,render_flags(a0)
                beq.s   HPZKnux_StoreDashSpeedAndAccel
                neg.w   d0
                neg.w   d1

HPZKnux_StoreDashSpeedAndAccel:
                move.w  d0,x_vel(a0)
                move.w  d1,$40(a0)
                addq.w  #4,y_pos(a0)
                lea     SKSceneAnim_KnuxJumpAndFastTravel(pc),a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

HPZKnux_HitBounceAndCheckLanding:
                jsr     (Animate_RawCheckResult).l
                jsr     (HPZKnux_StopAtCameraXMargins).l
                jsr     (MoveSprite).l
                tst.w   y_vel(a0)
                bmi.w   SKAIZScene_SharedSceneReturn
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.w   SKAIZScene_SharedSceneReturn
                add.w   d1,y_pos(a0)
                move.w  (Camera_X_pos).w,d0
                addi.w  #$A0,d0
                sub.w   x_pos(a0),d0
                bpl.s   HPZKnux_ChooseChargeOrJump
                neg.w   d0

HPZKnux_ChooseChargeOrJump:
                cmpi.w  #$60,d0
                blo.w   HPZKnux_Begin59TickCharge
                bra.w   HPZKnux_BeginJumpPreparation
; ---------------------------------------------------------------------------

HPZKnux_TakeHitAndSelectRecoil:
                bset    #0,$38(a0)
                moveq   #signextendB(sfx_FloorThump),d0
                jsr     (Play_SFX).l
                move.w  #$300,d3
                move.w  x_pos(a1),d1
                sub.w   x_pos(a0),d1
                bcs.s   HPZKnux_CountHitAndCheckDefeat
                neg.w   d3

HPZKnux_CountHitAndCheckDefeat:
                move.w  d3,x_vel(a0)
                move.w  #-$300,y_vel(a0)
                subq.b  #1,collision_property(a0)
                beq.s   HPZKnux_BeginDefeatArtAndMusic
                move.b  #$16,routine(a0)
                move.w  #0,$44(a0)
                move.l  #Map_Knuckles,mappings(a0)
                move.b  #$8D,mapping_frame(a0)
                lea     SKHpzKnuckles_NonfinalHitBodyFrameLoop(pc),a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

HPZKnux_DefeatBounceAndCheckFloor:
                jsr     (HPZKnux_StopAtCameraXMargins).l
                jsr     (MoveSprite).l
                tst.w   y_vel(a0)
                bmi.w   SKAIZScene_SharedSceneReturn
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bmi.s   HPZKnux_LandDefeatedAndQueueDizzyArt
                rts
; ---------------------------------------------------------------------------

HPZKnux_BeginDefeatArtAndMusic:
                move.b  #$18,routine(a0)
                clr.b   (Update_HUD_timer).w
                move.w  #2,$44(a0)
                move.l  #Map_HPZKnucklesGrab,mappings(a0)
                move.b  #2,mapping_frame(a0)
                bset    #4,$38(a0)
                move.b  #mus_LRZ2,(Current_music+1).w
                jsr     (AllocateObject).l
                bne.s   HPZKnux_DefeatMusicSpawnReturn
                move.l  #Obj_Song_Fade_Transition,(a1)
                move.b  #mus_LRZ2,subtype(a1)

HPZKnux_DefeatMusicSpawnReturn:
                rts
; ---------------------------------------------------------------------------

HPZKnux_AnimateDefeatLanding:
                jmp     (Animate_Raw2MultiDelay).l
; ---------------------------------------------------------------------------

HPZKnux_LandDefeatedAndQueueDizzyArt:
                add.w   d1,y_pos(a0)
                move.b  #$1A,routine(a0)
                move.l  #HPZKnux_StartShakeAndTryExplosions,$34(a0)
                moveq   #signextendB(sfx_DoorMove),d0
                jsr     (Play_SFX).l
                lea     SKSceneAnim_HPZGrabFloorRecovery(pc),a1
                jsr     (Set_Raw_Animation).l
                lea     (ArtKosM_HPZKnuxDizzy).l,a1
                move.w  #tiles_to_bytes(ArtTile_HPZKnuxDizzy),d2
                jmp     (Queue_Kos_Module).l
; End of function HPZKnux_TakeHitAndSelectRecoil
