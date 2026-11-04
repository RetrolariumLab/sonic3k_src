; Owner: objects/bosses/hcz/miniboss/s3
; Responsibility: Hydrocity miniboss initialization, battle control and looping chassis states
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_HCZMiniboss:
                lea     HCZMiniS3_InitialCameraTriggers(pc),a1
                jsr     (Check_CameraInRange).l
                move.l  #HCZMiniS3_LatchCameraYGate,(a0)
                move.b  #1,(Boss_flag).w
                st      (Events_bg+$16).w
                moveq   #PLCID_5B,d0
                jsr     (Load_PLC).l
                move.w  #$300,(Camera_min_Y_pos).w
                lea     HCZMiniS3_VortexChild(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------
HCZMiniS3_InitialCameraTriggers:
                dc.w    $300,  $400, $3500, $3700
; ---------------------------------------------------------------------------

HCZMiniS3_LatchCameraYGate:
                btst    #0,$38(a0)
                bne.s   HCZMiniS3_TrackCameraMinXAndLatch
                move.w  #$638,d0
                cmp.w   (Camera_Y_pos).w,d0
                bhi.s   HCZMiniS3_TrackCameraMinXAndLatch
                bset    #0,$38(a0)
                move.w  d0,(Camera_min_Y_pos).w
                move.w  d0,(Camera_max_Y_pos).w
                move.w  d0,(Camera_target_max_Y_pos).w

HCZMiniS3_TrackCameraMinXAndLatch:
                btst    #1,$38(a0)
                move.w  #$3680,d0
                move.w  (Camera_X_pos).w,d1
                move.w  d1,(Camera_min_X_pos).w
                cmp.w   d1,d0
                bhi.s   HCZMiniS3_CheckBothCameraGates
                bset    #1,$38(a0)
                move.w  d0,(Camera_min_X_pos).w
                move.w  d0,(Camera_max_X_pos).w

; Enter the music delay only when the flag byte is exactly 3
HCZMiniS3_CheckBothCameraGates:
                cmpi.b  #3,$38(a0)
                beq.s   HCZMiniS3_SaveBaselineAndFadeMusic
                rts
; ---------------------------------------------------------------------------

HCZMiniS3_SaveBaselineAndFadeMusic:
                move.w  (Camera_max_X_pos).w,(Camera_stored_max_X_pos).w
                move.w  y_pos(a0),$44(a0)
                move.l  #Obj_Wait,(a0)
                move.w  #2*60,$2E(a0)
                move.l  #HCZMiniS3_BeginFightLoopAndMusic,$34(a0)
                moveq   #signextendB(cmd_FadeOut),d0
                jsr     (Play_Music).l
                bset    #3,$38(a0)
                lea     Pal_HCZMiniboss(pc),a1
                jmp     (PalLoad_Line1).l
; ---------------------------------------------------------------------------

HCZMiniS3_BeginFightLoopAndMusic:
                move.l  #Obj_HCZ_MinibossLoop,(a0)
; Bug: This is incorrectly using the End Boss music for a Miniboss
                moveq   #signextendB(mus_EndBoss),d0
                jsr     (Play_Music).l

HCZMiniS3_SharedReturn:
                rts
; ---------------------------------------------------------------------------

Obj_HCZ_MinibossLoop:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  HCZ_MinibossLoop_Index(pc,d0.w),d1
                jsr     HCZ_MinibossLoop_Index(pc,d1.w)
                bsr.w   HandleHCZMinibossHitFlashOrDefeat
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------
HCZ_MinibossLoop_Index:
                dc.w    HCZMiniS3_InitFightAndSpawnRockets-HCZ_MinibossLoop_Index
                dc.w    HCZMiniS3_MoveAndTickTransit-HCZ_MinibossLoop_Index
                dc.w    HCZMiniS3_TickStationaryWait-HCZ_MinibossLoop_Index
                dc.w    HCZMiniS3_MoveAndTickTransit-HCZ_MinibossLoop_Index
                dc.w    HCZMiniS3_TickStationaryWait-HCZ_MinibossLoop_Index
                dc.w    HCZMiniS3_TryDiveSurfaceSplash-HCZ_MinibossLoop_Index
                dc.w    HCZMiniS3_SweepSnapToFloorAndWait-HCZ_MinibossLoop_Index
                dc.w    HCZMiniS3_RiseToBaselineAndRedive-HCZ_MinibossLoop_Index
                dc.w    HCZMiniS3_RiseToVortexEntryY-HCZ_MinibossLoop_Index
                dc.w    HCZMiniS3_MoveArcWithGravity-HCZ_MinibossLoop_Index
                dc.w    HCZMiniS3_TickStationaryWait-HCZ_MinibossLoop_Index
                dc.w    HCZMiniS3_RiseToBaselineAndRelane-HCZ_MinibossLoop_Index
; ---------------------------------------------------------------------------

HCZMiniS3_InitFightAndSpawnRockets:
                lea     ObjDat_HCZMiniboss_Loop(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.b  #6,collision_property(a0)
                move.b  #$28,y_radius(a0)
                bset    #3,$38(a0)
                move.w  #$100,y_vel(a0)
                move.w  #$DF,$2E(a0)
                move.l  #HCZMiniS3_StopDescentAndWait,$34(a0)
                lea     Child1_HCZMiniboss_RocketsEngine(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

HCZMiniS3_MoveAndTickTransit:
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

HCZMiniS3_StopDescentAndWait:
                move.b  #4,routine(a0)
                clr.w   y_vel(a0)
                move.w  #60-1,$2E(a0)
                move.l  #HCZMiniS3_BeginFastRise,$34(a0)
                rts
; ---------------------------------------------------------------------------

HCZMiniS3_TickStationaryWait:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

HCZMiniS3_BeginFastRise:
                move.b  #6,routine(a0)
                move.w  #-$400,y_vel(a0)
                move.w  #$37,$2E(a0)
                move.l  #HCZMiniS3_BeginDiveLaneWait,$34(a0)
                rts
; ---------------------------------------------------------------------------

HCZMiniS3_BeginDiveLaneWait:
                move.b  #8,routine(a0)
                move.w  #60-1,$2E(a0)
                move.l  #HCZMiniS3_ChooseLaneAndDive,$34(a0)
                rts
; ---------------------------------------------------------------------------

HCZMiniS3_ChooseLaneAndDive:
                bsr.w   SelectHCZBossDiveLaneAndRepeatCount

HCZMiniS3_BeginFloorDive:
                move.b  #$A,routine(a0)
                moveq   #signextendB(sfx_Roll),d0
                jsr     (Play_SFX).l
                bset    #6,$38(a0)
                bclr    #7,$38(a0)
                move.w  #$400,y_vel(a0)
                move.w  #$47,$2E(a0)
                move.l  #HCZMiniS3_BeginAlternatingFloorSweep,$34(a0)
                rts
; ---------------------------------------------------------------------------

HCZMiniS3_TryDiveSurfaceSplash:
                btst    #7,$38(a0)
                bne.s   HCZMiniS3_MoveDiveAndCheckFloor
                move.w  y_pos(a0),d0
                cmp.w   (Water_level).w,d0
                blo.s   HCZMiniS3_MoveDiveAndCheckFloor
                bsr.w   CreateHCZBossSurfaceSplash

HCZMiniS3_MoveDiveAndCheckFloor:
                jsr     (MoveSprite2).l
                jmp     (ObjHitFloor_DoRoutine).l
; ---------------------------------------------------------------------------

HCZMiniS3_BeginAlternatingFloorSweep:
                move.b  #$C,routine(a0)
                move.w  $40(a0),x_vel(a0)
                neg.w   $40(a0)
                clr.w   y_vel(a0)
                move.w  #$2F,$2E(a0)
                move.l  #HCZMiniS3_BeginRiseAndTickDiveCount,$34(a0)
                bclr    #7,$38(a0)
                rts
; ---------------------------------------------------------------------------

HCZMiniS3_SweepSnapToFloorAndWait:
                jsr     (MoveSprite2).l
                jsr     (ObjCheckFloorDist).l
                add.w   d1,y_pos(a0)
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

HCZMiniS3_BeginRiseAndTickDiveCount:
                move.w  #-$400,y_vel(a0)
                clr.w   x_vel(a0)
                subq.b  #1,$39(a0)
                bmi.s   HCZMiniS3_BeginFinalRiseToVortex
                move.b  #$E,routine(a0)
                rts
; ---------------------------------------------------------------------------

HCZMiniS3_BeginFinalRiseToVortex:
                move.b  #$10,routine(a0)
                rts
; ---------------------------------------------------------------------------

HCZMiniS3_RiseToBaselineAndRedive:
                bsr.w   TriggerHCZBossSplashIfSubmerged
                jsr     (MoveSprite2).l
                move.w  y_pos(a0),d0
                cmp.w   $44(a0),d0
                bls.w   HCZMiniS3_BeginFloorDive
                rts
; ---------------------------------------------------------------------------

HCZMiniS3_RiseToVortexEntryY:
                bsr.w   TriggerHCZBossSplashIfSubmerged
                jsr     (MoveSprite2).l
                move.w  $44(a0),d0
                addi.w  #$108,d0
                cmp.w   y_pos(a0),d0
                bhs.s   HCZMiniS3_ClampYAndChooseArcSpeed
                rts
; ---------------------------------------------------------------------------

HCZMiniS3_ClampYAndChooseArcSpeed:
                move.b  #$12,routine(a0)
                bclr    #7,$38(a0)
                move.w  d0,y_pos(a0)
                move.w  #$180,d0
                tst.w   $40(a0)
                bpl.s   HCZMiniS3_StoreArcSpeedAndWait
                neg.w   d0

HCZMiniS3_StoreArcSpeedAndWait:
                move.w  d0,x_vel(a0)
                move.w  #$3F,$2E(a0)
                move.l  #HCZMiniS3_CloseRocketsAndWait,$34(a0)
                rts
; ---------------------------------------------------------------------------

HCZMiniS3_MoveArcWithGravity:
                addi.w  #$20,y_vel(a0)
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

HCZMiniS3_CloseRocketsAndWait:
                move.b  #$14,routine(a0)
                moveq   #signextendB(sfx_DoorClose),d0
                jsr     (Play_SFX).l
                bclr    #3,$38(a0)
                move.w  #$9F,$2E(a0)
                move.l  #HCZMiniS3_StartVortexHold,$34(a0)
                clr.w   x_vel(a0)
                rts
; ---------------------------------------------------------------------------

HCZMiniS3_StartVortexHold:
                bset    #2,$38(a0)
                move.w  #$17F,$2E(a0)
                move.l  #HCZMiniS3_StopVortexAndWait,$34(a0)
                rts
; ---------------------------------------------------------------------------

HCZMiniS3_StopVortexAndWait:
                bclr    #2,$38(a0)
                move.w  #$7F,$2E(a0)
                move.l  #HCZMiniS3_ReopenRocketsAndWait,$34(a0)
                rts
; ---------------------------------------------------------------------------

HCZMiniS3_ReopenRocketsAndWait:
                bset    #3,$38(a0)
                move.w  #$3F,$2E(a0)
                move.l  #HCZMiniS3_ReopenRocketsAndWait,$34(a0)
                move.l  #HCZMiniS3_BeginSlowReturnRise,$34(a0)
                rts
; ---------------------------------------------------------------------------

HCZMiniS3_BeginSlowReturnRise:
                move.b  #2,routine(a0)
                move.w  #-$20,y_vel(a0)
                move.w  #$7F,$2E(a0)
                move.l  #HCZMiniS3_BeginFastReturnRise,$34(a0)
                rts
; ---------------------------------------------------------------------------

HCZMiniS3_BeginFastReturnRise:
                move.b  #$16,routine(a0)
                bclr    #6,$38(a0)
                move.w  #-$400,y_vel(a0)
                moveq   #signextendB(sfx_LavaBall),d0
                jsr     (Play_SFX).l
                rts
; ---------------------------------------------------------------------------

HCZMiniS3_RiseToBaselineAndRelane:
                jsr     (MoveSprite2).l
                move.w  y_pos(a0),d0
                cmp.w   $44(a0),d0
                bls.w   HCZMiniS3_ChooseLaneAndDive
                rts
; ---------------------------------------------------------------------------

HCZMiniS3_FreezeWaterAndTryExit:
                st      (_unkFAA2).w
                jsr     (Obj_EndSignControl).l
                jsr     (AllocateObject).l
                bne.s   HCZMiniS3_SpawnDefeatFragments
                move.l  #HCZMiniS3_WaitResultsAndLockInputs,(a1)

HCZMiniS3_SpawnDefeatFragments:
                lea     HCZMiniS3_BossFragmentChildren(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

HCZMiniS3_WaitResultsAndLockInputs:
                tst.b   (_unkFAA8).w
                bne.w   HCZMiniS3_SharedReturn
                move.l  #HCZMiniS3_SelectExitTransportGroup,(a0)
                clr.w   (Ctrl_1_logical).w
                clr.w   (Ctrl_2_logical).w
                st      (Ctrl_1_locked).w
                st      (Ctrl_2_locked).w
                move.b  #$80,(Player_1+object_control).w

HCZMiniS3_SelectExitTransportGroup:
                tst.b   (End_of_level_flag).w
                beq.w   HCZMiniS3_SharedReturn
                move.l  #HCZMiniS3_SpawnExitParticlesAndTick,(a0)
                lea     HCZMiniS3_ExitTransportPairChildren(pc),a2
                tst.b   (Player_mode+1).w
                beq.s   HCZMiniS3_SpawnTransportAndSetWait
                lea     HCZMiniS3_ExitTransportSoloChild(pc),a2

HCZMiniS3_SpawnTransportAndSetWait:
                jsr     (CreateChild6_Simple).l
                move.w  #$2F,$2E(a0)
                move.l  #Go_Delete_Sprite,$34(a0)

; Begin the particle and timer updates only after a transport signals readiness
HCZMiniS3_SpawnExitParticlesAndTick:
                btst    #0,$38(a0)
                beq.w   HCZMiniS3_SharedReturn
                lea     HCZMiniS3_WaterExitParticleChild(pc),a2
                jsr     (CreateChild6_Simple).l
                jmp     (Obj_Wait).l
