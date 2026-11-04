; Owner: objects/bosses/hcz/miniboss/sk
; Responsibility: Hydrocity miniboss initialization, battle control and looping chassis states
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_HCZMiniboss:
                lea     HCZMiniSK_InitialCameraTriggers(pc),a1
                jsr     (Check_CameraInRange).l
                move.l  #HCZMiniSK_LatchCameraYGate,(a0)
                move.b  #1,(Boss_flag).w
                st      (Events_bg+$16).w
                moveq   #PLCID_5B,d0
                jsr     (Load_PLC).l
                move.w  #$300,(Camera_min_Y_pos).w
                lea     HCZMiniSK_VortexChild(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------
HCZMiniSK_InitialCameraTriggers:
                dc.w    $300,  $400, $3500, $3700
; ---------------------------------------------------------------------------

HCZMiniSK_LatchCameraYGate:
                btst    #0,$38(a0)
                bne.s   HCZMiniSK_TrackCameraMinXAndLatch
                move.w  #$638,d0
                cmp.w   (Camera_Y_pos).w,d0
                bhi.s   HCZMiniSK_TrackCameraMinXAndLatch
                bset    #0,$38(a0)
                move.w  d0,(Camera_min_Y_pos).w
                move.w  d0,(Camera_max_Y_pos).w
                move.w  d0,(Camera_target_max_Y_pos).w

HCZMiniSK_TrackCameraMinXAndLatch:
                btst    #1,$38(a0)
                move.w  #$3680,d0
                move.w  (Camera_X_pos).w,d1
                move.w  d1,(Camera_min_X_pos).w
                cmp.w   d1,d0
                bhi.s   HCZMiniSK_CheckBothCameraGates
                bset    #1,$38(a0)
                move.w  d0,(Camera_min_X_pos).w
                move.w  d0,(Camera_max_X_pos).w

; Enter the music delay only when the flag byte is exactly 3
HCZMiniSK_CheckBothCameraGates:
                cmpi.b  #3,$38(a0)
                beq.s   HCZMiniSK_SaveBaselineAndFadeMusic
                rts
; ---------------------------------------------------------------------------

HCZMiniSK_SaveBaselineAndFadeMusic:
                move.w  (Camera_max_X_pos).w,(Camera_stored_max_X_pos).w
                move.w  y_pos(a0),$44(a0)
                move.l  #Obj_Wait,(a0)
                move.w  #2*60,$2E(a0)
                move.l  #HCZMiniSK_BeginFightLoopAndMusic,$34(a0)
                moveq   #signextendB(cmd_FadeOut),d0
                jsr     (Play_Music).l
                bset    #3,$38(a0)
                lea     Pal_HCZMiniboss(pc),a1
                jmp     (PalLoad_Line1).l
; ---------------------------------------------------------------------------

HCZMiniSK_BeginFightLoopAndMusic:
                move.l  #Obj_HCZ_MinibossLoop,(a0)
                moveq   #signextendB(mus_Miniboss),d0
                jsr     (Play_Music).l
                move.b  #mus_Miniboss,(Current_music+1).w

HCZMiniSK_SharedReturn:
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
                dc.w    HCZMiniSK_InitFightAndSpawnRockets-HCZ_MinibossLoop_Index
                dc.w    HCZMiniSK_MoveAndTickTransit-HCZ_MinibossLoop_Index
                dc.w    HCZMiniSK_TickStationaryWait-HCZ_MinibossLoop_Index
                dc.w    HCZMiniSK_MoveAndTickTransit-HCZ_MinibossLoop_Index
                dc.w    HCZMiniSK_TickStationaryWait-HCZ_MinibossLoop_Index
                dc.w    HCZMiniSK_TryDiveSurfaceSplash-HCZ_MinibossLoop_Index
                dc.w    HCZMiniSK_SweepSnapToFloorAndWait-HCZ_MinibossLoop_Index
                dc.w    HCZMiniSK_RiseToBaselineAndRedive-HCZ_MinibossLoop_Index
                dc.w    HCZMiniSK_RiseToVortexEntryY-HCZ_MinibossLoop_Index
                dc.w    HCZMiniSK_MoveArcWithGravity-HCZ_MinibossLoop_Index
                dc.w    HCZMiniSK_TickStationaryWait-HCZ_MinibossLoop_Index
                dc.w    HCZMiniSK_RiseToBaselineAndRelane-HCZ_MinibossLoop_Index
; ---------------------------------------------------------------------------

HCZMiniSK_InitFightAndSpawnRockets:
                lea     ObjDat_HCZMiniboss_Loop(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.b  #6,collision_property(a0)
                move.b  #$28,y_radius(a0)
                bset    #3,$38(a0)
                move.w  #$100,y_vel(a0)
                move.w  #$DF,$2E(a0)
                move.l  #HCZMiniSK_StopDescentAndWait,$34(a0)
                lea     Child1_HCZMiniboss_RocketsEngine(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

HCZMiniSK_MoveAndTickTransit:
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

HCZMiniSK_StopDescentAndWait:
                move.b  #4,routine(a0)
                clr.w   y_vel(a0)
                move.w  #60-1,$2E(a0)
                move.l  #HCZMiniSK_BeginFastRise,$34(a0)
                rts
; ---------------------------------------------------------------------------

HCZMiniSK_TickStationaryWait:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

HCZMiniSK_BeginFastRise:
                move.b  #6,routine(a0)
                move.w  #-$400,y_vel(a0)
                move.w  #$37,$2E(a0)
                move.l  #HCZMiniSK_BeginDiveLaneWait,$34(a0)
                rts
; ---------------------------------------------------------------------------

HCZMiniSK_BeginDiveLaneWait:
                move.b  #8,routine(a0)
                move.w  #60-1,$2E(a0)
                move.l  #HCZMiniSK_ChooseLaneAndDive,$34(a0)
                rts
; ---------------------------------------------------------------------------

HCZMiniSK_ChooseLaneAndDive:
                bsr.w   SelectHCZBossDiveLaneAndRepeatCount

HCZMiniSK_BeginFloorDive:
                move.b  #$A,routine(a0)
                moveq   #signextendB(sfx_Roll),d0
                jsr     (Play_SFX).l
                bset    #6,$38(a0)
                bclr    #7,$38(a0)
                move.w  #$400,y_vel(a0)
                move.w  #$47,$2E(a0)
                move.l  #HCZMiniSK_BeginAlternatingFloorSweep,$34(a0)
                rts
; ---------------------------------------------------------------------------

HCZMiniSK_TryDiveSurfaceSplash:
                btst    #7,$38(a0)
                bne.s   HCZMiniSK_MoveDiveAndCheckFloor
                move.w  y_pos(a0),d0
                cmp.w   (Water_level).w,d0
                blo.s   HCZMiniSK_MoveDiveAndCheckFloor
                bsr.w   CreateHCZBossSurfaceSplash

HCZMiniSK_MoveDiveAndCheckFloor:
                jsr     (MoveSprite2).l
                jmp     (ObjHitFloor_DoRoutine).l
; ---------------------------------------------------------------------------

HCZMiniSK_BeginAlternatingFloorSweep:
                move.b  #$C,routine(a0)
                move.w  $40(a0),x_vel(a0)
                neg.w   $40(a0)
                clr.w   y_vel(a0)
                move.w  #$2F,$2E(a0)
                move.l  #HCZMiniSK_BeginRiseAndTickDiveCount,$34(a0)
                bclr    #7,$38(a0)
                rts
; ---------------------------------------------------------------------------

HCZMiniSK_SweepSnapToFloorAndWait:
                jsr     (MoveSprite2).l
                jsr     (ObjCheckFloorDist).l
                add.w   d1,y_pos(a0)
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

HCZMiniSK_BeginRiseAndTickDiveCount:
                move.w  #-$400,y_vel(a0)
                clr.w   x_vel(a0)
                subq.b  #1,$39(a0)
                bmi.s   HCZMiniSK_BeginFinalRiseToVortex
                move.b  #$E,routine(a0)
                rts
; ---------------------------------------------------------------------------

HCZMiniSK_BeginFinalRiseToVortex:
                move.b  #$10,routine(a0)
                rts
; ---------------------------------------------------------------------------

HCZMiniSK_RiseToBaselineAndRedive:
                bsr.w   TriggerHCZBossSplashIfSubmerged
                jsr     (MoveSprite2).l
                move.w  y_pos(a0),d0
                cmp.w   $44(a0),d0
                bls.w   HCZMiniSK_BeginFloorDive
                rts
; ---------------------------------------------------------------------------

HCZMiniSK_RiseToVortexEntryY:
                bsr.w   TriggerHCZBossSplashIfSubmerged
                jsr     (MoveSprite2).l
                move.w  $44(a0),d0
                addi.w  #$108,d0
                cmp.w   y_pos(a0),d0
                bhs.s   HCZMiniSK_ClampYAndChooseArcSpeed
                rts
; ---------------------------------------------------------------------------

HCZMiniSK_ClampYAndChooseArcSpeed:
                move.b  #$12,routine(a0)
                bclr    #7,$38(a0)
                move.w  d0,y_pos(a0)
                move.w  #$180,d0
                tst.w   $40(a0)
                bpl.s   HCZMiniSK_StoreArcSpeedAndWait
                neg.w   d0

HCZMiniSK_StoreArcSpeedAndWait:
                move.w  d0,x_vel(a0)
                move.w  #$3F,$2E(a0)
                move.l  #HCZMiniSK_CloseRocketsAndWait,$34(a0)
                rts
; ---------------------------------------------------------------------------

HCZMiniSK_MoveArcWithGravity:
                addi.w  #$20,y_vel(a0)
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

HCZMiniSK_CloseRocketsAndWait:
                move.b  #$14,routine(a0)
                moveq   #signextendB(sfx_DoorClose),d0
                jsr     (Play_SFX).l
                bclr    #3,$38(a0)
                move.w  #$9F,$2E(a0)
                move.l  #HCZMiniSK_StartVortexHold,$34(a0)
                clr.w   x_vel(a0)
                rts
; ---------------------------------------------------------------------------

HCZMiniSK_StartVortexHold:
                bset    #2,$38(a0)
                move.w  #$17F,$2E(a0)
                move.l  #HCZMiniSK_StopVortexAndWait,$34(a0)
                rts
; ---------------------------------------------------------------------------

HCZMiniSK_StopVortexAndWait:
                bclr    #2,$38(a0)
                move.w  #$7F,$2E(a0)
                move.l  #HCZMiniSK_ReopenRocketsAndWait,$34(a0)
                rts
; ---------------------------------------------------------------------------

HCZMiniSK_ReopenRocketsAndWait:
                bset    #3,$38(a0)
                move.w  #$3F,$2E(a0)
                move.l  #HCZMiniSK_ReopenRocketsAndWait,$34(a0)
                move.l  #HCZMiniSK_BeginSlowReturnRise,$34(a0)
                rts
; ---------------------------------------------------------------------------

HCZMiniSK_BeginSlowReturnRise:
                move.b  #2,routine(a0)
                move.w  #-$20,y_vel(a0)
                move.w  #$7F,$2E(a0)
                move.l  #HCZMiniSK_BeginFastReturnRise,$34(a0)
                rts
; ---------------------------------------------------------------------------

HCZMiniSK_BeginFastReturnRise:
                move.b  #$16,routine(a0)
                bclr    #6,$38(a0)
                move.w  #-$400,y_vel(a0)
                moveq   #signextendB(sfx_LavaBall),d0
                jsr     (Play_SFX).l
                rts
; ---------------------------------------------------------------------------

HCZMiniSK_RiseToBaselineAndRelane:
                jsr     (MoveSprite2).l
                move.w  y_pos(a0),d0
                cmp.w   $44(a0),d0
                bls.w   HCZMiniSK_ChooseLaneAndDive
                rts
; ---------------------------------------------------------------------------

HCZMiniSK_FreezeWaterAndTryExit:
                st      (_unkFAA2).w
                jsr     (Obj_EndSignControl).l
                jsr     (AllocateObject).l
                bne.s   HCZMiniSK_SpawnDefeatFragments
                move.l  #HCZMiniSK_WaitResultsAndLockInputs,(a1)

HCZMiniSK_SpawnDefeatFragments:
                lea     HCZMiniSK_BossFragmentChildren(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

HCZMiniSK_WaitResultsAndLockInputs:
                tst.b   (_unkFAA8).w
                bne.w   HCZMiniSK_SharedReturn
                move.l  #HCZMiniSK_SelectExitTransportGroup,(a0)
                clr.w   (Ctrl_1_logical).w
                clr.w   (Ctrl_2_logical).w
                st      (Ctrl_1_locked).w
                st      (Ctrl_2_locked).w
                move.b  #$80,(Player_1+object_control).w

HCZMiniSK_SelectExitTransportGroup:
                tst.b   (End_of_level_flag).w
                beq.w   HCZMiniSK_SharedReturn
                move.l  #HCZMiniSK_SpawnExitParticlesAndTick,(a0)
                lea     HCZMiniSK_ExitTransportPairChildren(pc),a2
                tst.b   (Player_mode+1).w
                beq.s   HCZMiniSK_SpawnTransportAndSetWait
                lea     HCZMiniSK_ExitTransportSoloChild(pc),a2

HCZMiniSK_SpawnTransportAndSetWait:
                jsr     (CreateChild6_Simple).l
                move.w  #$2F,$2E(a0)
                move.l  #Go_Delete_Sprite,$34(a0)

; Begin the particle and timer updates only after a transport signals readiness
HCZMiniSK_SpawnExitParticlesAndTick:
                btst    #0,$38(a0)
                beq.w   HCZMiniSK_SharedReturn
                lea     HCZMiniSK_WaterExitParticleChild(pc),a2
                jsr     (CreateChild6_Simple).l
                jmp     (Obj_Wait).l
