; Owner: objects/bosses/icz/s3
; Responsibility: IceCap miniboss lifecycle, attacks, child actors, helpers and private resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_ICZMiniboss:
                cmpi.w  #$501,(Apparent_zone_and_act).w
                beq.s   ICZMiniS3_DeleteForAct0501
                lea     ICZMiniS3_ArenaCameraTriggerBounds(pc),a1
                jsr     (Check_CameraInRange).l
                move.l  #ICZMiniS3_TickArenaTransition,(a0)
                move.b  #1,(Boss_flag).w
                moveq   #signextendB(cmd_FadeOut),d0
                jsr     (Play_Music).l
                move.w  #2*60,$2E(a0)
                move.b  #mus_Miniboss,$26(a0)
                move.w  (Camera_max_X_pos).w,(Camera_stored_max_X_pos).w
                move.w  (Camera_target_max_Y_pos).w,(Camera_stored_max_Y_pos).w
                move.w  #$2B8,(Camera_target_max_Y_pos).w
                move.w  #$6F0,$1C(a0)
                move.w  #$6F0,(Camera_max_X_pos).w
                move.l  #ICZMiniS3_InstallBattleDispatcher,$34(a0)
                moveq   #PLCID_5F,d0
                jsr     (Load_PLC).l
                lea     Pal_ICZMiniboss(pc),a1
                jmp     PalLoad_Line1(pc)
; ---------------------------------------------------------------------------

ICZMiniS3_DeleteForAct0501:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------
ICZMiniS3_ArenaCameraTriggerBounds:
                dc.w    0,  $380,  $690,  $6F0
; ---------------------------------------------------------------------------

ICZMiniS3_TickArenaTransition:
                jmp     (S3EndCamera_TickMusicDelay).l
; ---------------------------------------------------------------------------

ICZMiniS3_InstallBattleDispatcher:
                move.l  #ICZMiniS3_BattleDispatchHitAndDraw,(a0)

ICZMiniS3_SharedReturn:
                rts
; ---------------------------------------------------------------------------

ICZMiniS3_BattleDispatchHitAndDraw:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  ICZMiniS3_BattleStateOffsets(pc,d0.w),d1
                jsr     ICZMiniS3_BattleStateOffsets(pc,d1.w)
                bsr.w   HandleICZMinibossTwoColorHitOrDefeat
                jmp     Draw_And_Touch_Sprite(pc)
; ---------------------------------------------------------------------------
ICZMiniS3_BattleStateOffsets:
                dc.w    ICZMiniS3_InitBodyOrbAndTrim-ICZMiniS3_BattleStateOffsets
                dc.w    ICZMiniS3_MoveAndTickTransit-ICZMiniS3_BattleStateOffsets
                dc.w    ICZMiniS3_TickPaletteStartWait-ICZMiniS3_BattleStateOffsets
                dc.w    ICZMiniS3_RunPaletteAndTickWait-ICZMiniS3_BattleStateOffsets
                dc.w    ICZMiniS3_DescendRunPaletteAndWait-ICZMiniS3_BattleStateOffsets
                dc.w    ICZMiniS3_RunPaletteAndMoveArc-ICZMiniS3_BattleStateOffsets
                dc.w    ICZMiniS3_RunPaletteAndTickWait-ICZMiniS3_BattleStateOffsets
                dc.w    ICZMiniS3_RunPaletteAndPollOrbRelease-ICZMiniS3_BattleStateOffsets
                dc.w    ICZMiniS3_RunPaletteUntilCallback-ICZMiniS3_BattleStateOffsets
                dc.w    ICZMiniS3_TickPostReleaseCooldown-ICZMiniS3_BattleStateOffsets
                dc.w    ICZMiniS3_MoveAndTickTransit-ICZMiniS3_BattleStateOffsets
; ---------------------------------------------------------------------------

ICZMiniS3_InitBodyOrbAndTrim:
                lea     ICZMiniS3_BodyAttributes(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.b  #6,collision_property(a0)
                move.w  #$200,$3E(a0)
                move.w  #$80,y_vel(a0)
                move.w  #$BF,$2E(a0)
                move.l  #ICZMiniS3_RequestTrimSeparation,$34(a0)
                lea     ICZMinibossS3_Root_EightSimpleOrbRecord(pc),a2
                jsr     CreateChild6_Simple(pc)
                lea     ICZMinibossS3_Root_SixNormalTrimRecords(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

ICZMiniS3_MoveAndTickTransit:
                jsr     (MoveSprite2).l
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

ICZMiniS3_RequestTrimSeparation:
                move.b  #4,routine(a0)
                bset    #3,$38(a0)
                move.w  #$1F,$2E(a0)
                move.l  #ICZMiniS3_BeginForwardPaletteWait,$34(a0)
                rts
; ---------------------------------------------------------------------------

ICZMiniS3_TickPaletteStartWait:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

ICZMiniS3_BeginForwardPaletteWait:
                move.b  #6,routine(a0)
                move.w  #$3F,$2E(a0)
                move.l  #ICZMiniS3_RequestOrbAssembly,$34(a0)
                lea     (S3ICZMinibossPal_PulseAccel).l,a1

; Copy two longwords and clear the following word in palette rotation RAM
ICZMiniS3_CopyPaletteScriptSlot:
                lea     (Palette_rotation_data).w,a2
                move.l  (a1)+,(a2)+
                move.l  (a1)+,(a2)+
                clr.w   (a2)
                rts
; ---------------------------------------------------------------------------

ICZMiniS3_RunPaletteAndTickWait:
                jsr     Run_PalRotationScript(pc)
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

ICZMiniS3_RequestOrbAssembly:
                bset    #2,$38(a0)
                move.w  #$7F,$2E(a0)
                move.l  #ICZMiniS3_BeginFastDescent,$34(a0)
                moveq   #signextendB(sfx_TunnelBooster),d0
                jsr     (Play_SFX).l
                rts
; ---------------------------------------------------------------------------

ICZMiniS3_BeginFastDescent:
                move.b  #8,routine(a0)
                move.w  #$300,y_vel(a0)
                move.w  #7,$2E(a0)
                move.l  #ICZMiniS3_LoadArcRepeatCount,$34(a0)
                rts
; ---------------------------------------------------------------------------

ICZMiniS3_DescendRunPaletteAndWait:
                jsr     (MoveSprite2).l
                jsr     Run_PalRotationScript(pc)
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

ICZMiniS3_LoadArcRepeatCount:
                bsr.w   SelectICZMinibossArcRepeatCount

ICZMiniS3_ReverseXAndBeginArc:
                move.b  #$A,routine(a0)
                move.w  #$300,y_vel(a0)
                neg.w   $3E(a0)
                move.w  $3E(a0),x_vel(a0)
                move.w  #$5F,$2E(a0)
                moveq   #signextendB(sfx_BossRotate),d0
                jsr     (Play_SFX).l
                rts
; ---------------------------------------------------------------------------

ICZMiniS3_RunPaletteAndMoveArc:
                jsr     Run_PalRotationScript(pc)
                subq.w  #1,$2E(a0)
                bmi.s   ICZMiniS3_BeginArcRepeatWait
                addi.w  #-$10,y_vel(a0)
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

ICZMiniS3_BeginArcRepeatWait:
                move.b  #$C,routine(a0)
                move.w  #$3F,$2E(a0)
                move.l  #ICZMiniS3_RepeatArcOrReleaseOrbs,$34(a0)
                rts
; ---------------------------------------------------------------------------
; unused
                jsr     Run_PalRotationScript(pc)
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

ICZMiniS3_RepeatArcOrReleaseOrbs:
                subq.b  #1,$39(a0)
                bpl.s   ICZMiniS3_ReverseXAndBeginArc
                move.b  #$E,routine(a0)
                bset    #1,$38(a0)
                cmpi.w  #$6F0+$A0,x_pos(a0)
                scs     $43(a0)
                rts
; ---------------------------------------------------------------------------

ICZMiniS3_RunPaletteAndPollOrbRelease:
                btst    #1,$38(a0)
                beq.s   ICZMiniS3_BeginReversePalette
                jmp     Run_PalRotationScript(pc)
; ---------------------------------------------------------------------------

ICZMiniS3_BeginReversePalette:
                move.b  #$10,routine(a0)
                bclr    #2,$38(a0)
                move.l  #ICZMiniS3_ResetPaletteAndBeginCooldown,(Palette_rotation_custom).w
                lea     (S3ICZMinibossPal_PulseDecel).l,a1
                bra.w   ICZMiniS3_CopyPaletteScriptSlot
; ---------------------------------------------------------------------------

ICZMiniS3_RunPaletteUntilCallback:
                jmp     Run_PalRotationScript(pc)
; ---------------------------------------------------------------------------

ICZMiniS3_ResetPaletteAndBeginCooldown:
                move.b  #$12,routine(a0)
                move.w  #$222,(Normal_palette_line_2+$14).w
                move.w  #$3F,$2E(a0)
                move.l  #ICZMiniS3_BeginVerticalReturn,$34(a0)
                rts
; ---------------------------------------------------------------------------

ICZMiniS3_TickPostReleaseCooldown:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

ICZMiniS3_BeginVerticalReturn:
                move.b  #$14,routine(a0)
                move.w  #-$100,y_vel(a0)
                clr.w   x_vel(a0)
                move.w  #$17,$2E(a0)
                move.l  #ICZMiniS3_HoldBeforePaletteRestart,$34(a0)
                rts
; ---------------------------------------------------------------------------

ICZMiniS3_HoldBeforePaletteRestart:
                move.b  #4,routine(a0)
                move.w  #$FF,$2E(a0)
                move.l  #ICZMiniS3_BeginForwardPaletteWait,$34(a0)
                rts
; ---------------------------------------------------------------------------

ICZMiniS3_StartSignAndStopSnow:
                jsr     (Obj_EndSignControl).l
                movea.w (_unkFAAE).w,a1
                cmpi.l  #S3ICZSnowPile_UpdateCameraSnowEmitter,(a1)
                bne.s   ICZMiniS3_TryDefeatPaletteActor
                bset    #5,$38(a1)

ICZMiniS3_TryDefeatPaletteActor:
                jsr     (AllocateObject).l
                bne.s   ICZMiniS3_SpawnBreakupFragments
                move.l  #ICZMiniS3_InitDefeatPaletteActor,(a1)

ICZMiniS3_SpawnBreakupFragments:
                lea     ICZMiniS3_DefeatFragmentChildren(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

ICZMiniS3_InitDefeatPaletteActor:
                move.l  #ICZMiniS3_DefeatPaletteActorUpdate,(a0)
                lea     (ICZMiniS3_DefeatPaletteScript).l,a1
                lea     (Palette_rotation_data).w,a2
                move.l  (a1)+,(a2)+
                move.l  (a1)+,(a2)+
                clr.w   (a2)
                move.l  #Go_Delete_Sprite,(Palette_rotation_custom).w
                rts
; ---------------------------------------------------------------------------

ICZMiniS3_DefeatPaletteActorUpdate:
                jmp     Run_PalRotationScript(pc)
; ---------------------------------------------------------------------------

ICZMiniS3_TrimFollowDispatchAndDraw:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  ICZMiniS3_TrimStateOffsets(pc,d0.w),d1
                jsr     ICZMiniS3_TrimStateOffsets(pc,d1.w)
                jsr     Refresh_ChildPosition(pc)
                moveq   #0,d0
                jmp     Child_Draw_Sprite2_FlickerMove(pc)
; ---------------------------------------------------------------------------
ICZMiniS3_TrimStateOffsets:
                dc.w    ICZMiniS3_InitTrimBySubtype-ICZMiniS3_TrimStateOffsets
                dc.w    ICZMiniS3_TrimWaitForSeparation-ICZMiniS3_TrimStateOffsets
                dc.w    ICZMiniS3_TrimApplyByteStepsAndWait-ICZMiniS3_TrimStateOffsets
                dc.w    ICZMinibossS3_Trim_ReturnFromFinalIdle-ICZMiniS3_TrimStateOffsets
; ---------------------------------------------------------------------------

ICZMiniS3_InitTrimBySubtype:
                lea     ICZMiniS3_TrimAttributes(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                bra.w   ICZMiniS3_TrimSelectSubtypeFrame
; ---------------------------------------------------------------------------

ICZMiniS3_TrimWaitForSeparation:
                movea.w parent3(a0),a1
                btst    #3,$38(a1)
                bne.s   ICZMiniS3_TrimBeginOffsetMotion
                rts
; ---------------------------------------------------------------------------

ICZMiniS3_TrimBeginOffsetMotion:
                move.b  #4,routine(a0)
                move.l  #ICZMinibossS3_Trim_SelectFinalOffsetIdle,$34(a0)
                bra.w   ICZMiniS3_TrimLoadStepsAndWait
; ---------------------------------------------------------------------------

ICZMiniS3_TrimApplyByteStepsAndWait:
                move.b  x_vel(a0),d0
                add.b   d0,child_dx(a0)
                move.b  x_vel+1(a0),d0
                add.b   d0,child_dy(a0)
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

ICZMinibossS3_Trim_SelectFinalOffsetIdle:
                move.b  #6,routine(a0)
                rts
; ---------------------------------------------------------------------------

ICZMinibossS3_Trim_ReturnFromFinalIdle:
                rts
; ---------------------------------------------------------------------------

ICZMiniS3_OrbDispatchAndDraw:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  ICZMiniS3_OrbStateOffsets(pc,d0.w),d1
                jsr     ICZMiniS3_OrbStateOffsets(pc,d1.w)
                moveq   #0,d0
                jmp     Child_DrawTouch_Sprite2_FlickerMove(pc)
; ---------------------------------------------------------------------------
ICZMiniS3_OrbStateOffsets:
                dc.w    ICZMiniS3_InitOrbAtLowerBand-ICZMiniS3_OrbStateOffsets
                dc.w    ICZMiniS3_OrbWaitForAssembly-ICZMiniS3_OrbStateOffsets
                dc.w    ICZMiniS3_OrbApplyVIntJitter-ICZMiniS3_OrbStateOffsets
                dc.w    ICZMiniS3_OrbMoveAndTickFlight-ICZMiniS3_OrbStateOffsets
                dc.w    ICZMiniS3_OrbOrbitOrAlignForRelease-ICZMiniS3_OrbStateOffsets
                dc.w    ICZMiniS3_OrbChooseReleaseTilt-ICZMiniS3_OrbStateOffsets
                dc.w    ICZMiniS3_OrbOrbitAndCheckAck-ICZMiniS3_OrbStateOffsets
                dc.w    ICZMiniS3_OrbWaitForDispersalPhase-ICZMiniS3_OrbStateOffsets
                dc.w    ICZMiniS3_OrbMoveAndTickFlight-ICZMiniS3_OrbStateOffsets
                dc.w    ICZMiniS3_OrbWaitBeforeDrop-ICZMiniS3_OrbStateOffsets
                dc.w    ICZMiniS3_OrbMoveAndTickFlight-ICZMiniS3_OrbStateOffsets
                dc.w    ICZMiniS3_OrbFinalIdle-ICZMiniS3_OrbStateOffsets
; ---------------------------------------------------------------------------

ICZMiniS3_InitOrbAtLowerBand:
                lea     ICZMiniS3_OrbAttributes(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                bra.w   ICZMiniS3_OrbSetLowerSpawnBand
; ---------------------------------------------------------------------------

ICZMiniS3_OrbWaitForAssembly:
                movea.w parent3(a0),a1
                btst    #2,$38(a1)
                bne.s   ICZMiniS3_OrbBeginJitteredRise
                rts
; ---------------------------------------------------------------------------

ICZMiniS3_OrbBeginJitteredRise:
                move.b  #4,routine(a0)
                move.w  #-$40,y_vel(a0)
                move.w  #$3F,$2E(a0)
                move.l  #ICZMiniS3_OrbBeginOrbitApproach,$34(a0)
                rts
; ---------------------------------------------------------------------------

ICZMiniS3_OrbApplyVIntJitter:
                moveq   #1,d0
                btst    #0,(V_int_run_count+3).w
                beq.s   ICZMinibossS3_Orb_AddJitterMoveThenWait
                neg.w   d0

ICZMinibossS3_Orb_AddJitterMoveThenWait:
                add.w   d0,x_pos(a0)
                jsr     (MoveSprite2).l
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

ICZMiniS3_OrbBeginOrbitApproach:
                move.b  #6,routine(a0)
                move.w  #$180,priority(a0)
                bsr.w   SetICZMinibossOrbApproachVelocity
                move.w  #$1F,$2E(a0)
                move.l  #ICZMiniS3_OrbEnableCollisionAndOrbit,$34(a0)
                rts
; ---------------------------------------------------------------------------

ICZMiniS3_OrbMoveAndTickFlight:
                jsr     (MoveSprite2).l
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

ICZMiniS3_OrbEnableCollisionAndOrbit:
                move.b  #8,routine(a0)
                move.b  #$8B,collision_flags(a0)
                moveq   #signextendB(sfx_BossRotate),d0
                jsr     (Play_SFX).l
                rts
; ---------------------------------------------------------------------------

ICZMiniS3_OrbOrbitOrAlignForRelease:
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                bne.s   ICZMiniS3_OrbBeginReleaseAlignment
                bra.w   ICZMiniS3_OrbAdvanceTiltAndProject
; ---------------------------------------------------------------------------

ICZMiniS3_OrbBeginReleaseAlignment:
                move.b  #$A,routine(a0)
                rts
; ---------------------------------------------------------------------------

ICZMiniS3_OrbChooseReleaseTilt:
                movea.w parent3(a0),a1
                moveq   #0,d0
                tst.b   $43(a1)
                bne.s   ICZMiniS3_OrbWaitForReleaseTilt
                moveq   #-$80,d0

ICZMiniS3_OrbWaitForReleaseTilt:
                cmp.b   $3D(a0),d0
                beq.s   ICZMiniS3_OrbBeginReleaseOrbit
                bra.w   ICZMiniS3_OrbAdvanceTiltAndProject
; ---------------------------------------------------------------------------

ICZMiniS3_OrbBeginReleaseOrbit:
                move.b  #$C,routine(a0)
                rts
; ---------------------------------------------------------------------------

ICZMiniS3_OrbOrbitAndCheckAck:
                addq.b  #4,$3C(a0)
                lea     (ICZMiniboss_OrbAngleLookup).l,a2
                jsr     MoveSprite_AtAngleLookup(pc)
                moveq   #0,d0
                bsr.w   TiltAndDepthSortICZMinibossOrb
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                beq.s   ICZMiniS3_OrbAckAndLoadDispersal
                tst.b   subtype(a0)
                bne.w   ICZMiniS3_SharedReturn
                moveq   #0,d0
                tst.b   $43(a1)
                bne.s   ICZMiniS3_OrbZeroCheckReleasePhase
                moveq   #-$80,d0

; Only orb zero clears the shared request when it reaches the phase for the selected side
ICZMiniS3_OrbZeroCheckReleasePhase:
                cmp.b   $3C(a0),d0
                bne.w   ICZMiniS3_SharedReturn

ICZMiniS3_OrbAckAndLoadDispersal:
                move.b  #$E,routine(a0)
                bclr    #1,$38(a1)
                bra.w   ICZMiniS3_OrbChooseDispersalPlan
; ---------------------------------------------------------------------------

ICZMiniS3_OrbWaitForDispersalPhase:
                move.b  $3C(a0),d0
                cmp.b   $42(a0),d0
                beq.s   ICZMiniS3_OrbBeginDispersalFlight
                addq.b  #4,$3C(a0)
                lea     (ICZMiniboss_OrbAngleLookup).l,a2
                jsr     MoveSprite_AtAngleLookup(pc)
                moveq   #0,d0
                bra.w   TiltAndDepthSortICZMinibossOrb
; ---------------------------------------------------------------------------

ICZMiniS3_OrbBeginDispersalFlight:
                move.b  #$10,routine(a0)
                move.w  #$3F,$2E(a0)
                move.l  #ICZMiniS3_OrbRandomizeUpperDropPoint,$34(a0)
                rts
; ---------------------------------------------------------------------------

ICZMiniS3_OrbRandomizeUpperDropPoint:
                move.b  #$12,routine(a0)
                move.w  #$7F,$2E(a0)
                move.l  #ICZMiniS3_OrbBeginVerticalDrop,$34(a0)
                bra.w   ICZMiniS3_OrbSetUpperSpawnBand
; ---------------------------------------------------------------------------

ICZMiniS3_OrbWaitBeforeDrop:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

ICZMiniS3_OrbBeginVerticalDrop:
                move.b  #$14,routine(a0)
                moveq   #signextendB(sfx_LevelProjectile),d0
                jsr     (Play_SFX).l
                move.w  #$400,y_vel(a0)
                clr.w   x_vel(a0)
                move.w  #$45,$2E(a0)
                move.l  #ICZMiniS3_OrbDisableAndRearmAssembly,$34(a0)
                rts
; ---------------------------------------------------------------------------

ICZMiniS3_OrbDisableAndRearmAssembly:
                move.b  #2,routine(a0)
                clr.b   collision_flags(a0)
                rts
; ---------------------------------------------------------------------------

ICZMiniS3_OrbFinalIdle:
                rts
; ---------------------------------------------------------------------------

ICZMiniS3_InitDefeatFragment:
                lea     ICZMiniS3_FragmentAttributes(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #Obj_FlickerMove,(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsr.w   #1,d0
                addi.b  #$B,d0
                move.b  d0,mapping_frame(a0)
                moveq   #8,d0
                jmp     Set_IndexedVelocity(pc)
; ---------------------------------------------------------------------------

ICZMiniS3_TrimSelectSubtypeFrame:
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsr.w   #1,d0
                move.b  ICZMiniS3_TrimFramesBySubtype(pc,d0.w),mapping_frame(a0)
                rts
; ---------------------------------------------------------------------------
ICZMiniS3_TrimFramesBySubtype:
                dc.b    1,   9,   3,   2,  $A,   4
                even
; ---------------------------------------------------------------------------

ICZMiniS3_TrimLoadStepsAndWait:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  ICZMiniS3_TrimPackedOffsetSteps(pc,d0.w),x_vel(a0)
                move.w  ICZMiniS3_TrimOffsetStepWaits(pc,d0.w),$2E(a0)
                rts
; ---------------------------------------------------------------------------
ICZMiniS3_TrimPackedOffsetSteps:
                dc.w    -1,  $1FF,     1,    -1,  $1FF,     1
ICZMiniS3_TrimOffsetStepWaits:
                dc.w    2,     2,     3,     6,     6,     8
; ---------------------------------------------------------------------------

ICZMiniS3_OrbSetLowerSpawnBand:
                move.w  #$2B8+$D8,y_pos(a0)

ICZMiniS3_OrbRandomizeLaneAndHeight:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  ICZMiniS3_OrbLaneXOffsets(pc,d0.w),d2
                jsr     (Random_Number).l
                andi.w  #7,d0
                subq.w  #3,d0
                add.w   d0,d2
                move.w  #$6F0,x_pos(a0)
                add.w   d2,x_pos(a0)
                swap    d0
                andi.w  #7,d0
                subq.w  #3,d0
                add.w   d0,y_pos(a0)
                rts
; ---------------------------------------------------------------------------
ICZMiniS3_OrbLaneXOffsets:
                dc.w    -$20
                dc.w    $20
                dc.w    $60
                dc.w    $A0
                dc.w    $E0
                dc.w    $120
                dc.w    $160
                dc.w    $1A0

; =============== S U B R O U T I N E =======================================

SetICZMinibossOrbApproachVelocity:
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsl.w   #4,d0
                move.b  d0,$3C(a0)
                move.w  x_pos(a0),d0
                move.w  y_pos(a0),d1
                movem.w d0-d1,-(sp)
                lea     (ICZMiniboss_OrbAngleLookup).l,a2
                jsr     MoveSprite_AtAngleLookup(pc)
                moveq   #0,d0
                moveq   #0,d1
                moveq   #0,d2
                moveq   #0,d3
                movem.w (sp)+,d0-d1
                move.w  x_pos(a0),d2
                move.w  y_pos(a0),d3
                move.w  d0,x_pos(a0)
                move.w  d1,y_pos(a0)
                swap    d0
                swap    d1
                swap    d2
                swap    d3
                sub.l   d0,d2
                sub.l   d1,d3
                lsl.l   #3,d2
                lsl.l   #3,d3
                swap    d2
                swap    d3
                move.w  d2,x_vel(a0)
                move.w  d3,y_vel(a0)
                rts
; End of function SetICZMinibossOrbApproachVelocity

; ---------------------------------------------------------------------------

ICZMiniS3_OrbAdvanceTiltAndProject:
                addq.b  #4,$3C(a0)
                lea     (ICZMiniboss_OrbAngleLookup).l,a2
                jsr     MoveSprite_AtAngleLookup(pc)
                move.b  $3D(a0),d0
                addq.b  #1,d0
                move.b  d0,$3D(a0)

; =============== S U B R O U T I N E =======================================

TiltAndDepthSortICZMinibossOrb:
                jsr     (GetSineCosine).l
                tst.w   d1
                bpl.s   ICZMiniS3_TiltGetYDistanceAndSide
                neg.w   d1

ICZMiniS3_TiltGetYDistanceAndSide:
                move.w  y_pos(a0),d2
                move.w  y_pos(a1),d4
                sub.w   d4,d2
                scs     d3
                bcc.s   ICZMiniS3_TiltScaleYDistance
                neg.w   d2

; Invert the projection sign for tilt angles in the middle half-turn
ICZMiniS3_TiltScaleYDistance:
                mulu.w  d1,d2
                lsr.l   #8,d2
                cmpi.b  #$40,$3D(a0)
                blo.s   ICZMiniS3_TiltRestoreYOffsetSign
                cmpi.b  #-$40,$3D(a0)
                bhs.s   ICZMiniS3_TiltRestoreYOffsetSign
                not.b   d3

ICZMiniS3_TiltRestoreYOffsetSign:
                tst.b   d3
                beq.s   ICZMiniS3_TiltStoreYAndChooseSide
                neg.w   d2

ICZMiniS3_TiltStoreYAndChooseSide:
                add.w   d2,d4
                move.w  d4,y_pos(a0)
                move.b  $3D(a0),d0
                spl     d3
                cmpi.b  #$40,$3C(a0)
                blo.s   ICZMiniS3_TiltChooseOrbFrame
                cmpi.b  #-$40,$3C(a0)
                bhs.s   ICZMiniS3_TiltChooseOrbFrame
                not.b   d3

ICZMiniS3_TiltChooseOrbFrame:
                move.b  #6,mapping_frame(a0)
                cmpi.b  #$20,d0
                blo.s   ICZMiniS3_TiltChooseSpritePriority
                cmpi.b  #$60,d0
                blo.s   ICZMiniS3_TiltChooseSideFrame
                cmpi.b  #-$60,d0
                blo.s   ICZMiniS3_TiltChooseSpritePriority
                cmpi.b  #-$20,d0
                bhs.s   ICZMiniS3_TiltChooseSpritePriority

ICZMiniS3_TiltChooseSideFrame:
                move.b  #5,mapping_frame(a0)
                tst.b   d3
                bne.s   ICZMiniS3_TiltChooseSpritePriority
                move.b  #8,mapping_frame(a0)

ICZMiniS3_TiltChooseSpritePriority:
                move.w  #$180,priority(a0)
                tst.b   d3
                bne.s   ICZMiniS3_TiltProjectionReturn
                move.w  #$300,priority(a0)

ICZMiniS3_TiltProjectionReturn:
                rts
; End of function TiltAndDepthSortICZMinibossOrb

; =============== S U B R O U T I N E =======================================

SelectICZMinibossArcRepeatCount:
                move.b  $3A(a0),d0
                addq.b  #1,$3A(a0)
                andi.w  #7,d0
                move.b  ICZMiniS3_ArcRepeatCounts(pc,d0.w),$39(a0)
                rts
; End of function SelectICZMinibossArcRepeatCount

; ---------------------------------------------------------------------------
ICZMiniS3_ArcRepeatCounts:
                dc.b    1,   0,   1,   1,   0,   1,   0,   0
                even
; ---------------------------------------------------------------------------

ICZMiniS3_OrbChooseDispersalPlan:
                movea.w parent3(a0),a1
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  d0,d1
                lsr.w   #1,d1
                tst.b   $43(a1)
                bne.s   ICZMiniS3_OrbApplyDispersalPlan
                addq.w  #8,d1

ICZMiniS3_OrbApplyDispersalPlan:
                move.b  ICZMiniS3_OrbDispersalPhaseBanks(pc,d1.w),$42(a0)
                add.w   d0,d0
                move.l  ICZMiniS3_OrbDispersalVelocities(pc,d0.w),x_vel(a0)  ; and y_vel
                tst.b   $43(a1)
                bne.s   ICZMiniS3_OrbDispersalSetupReturn
                neg.w   x_vel(a0)

ICZMiniS3_OrbDispersalSetupReturn:
                rts
; ---------------------------------------------------------------------------
ICZMiniS3_OrbDispersalPhaseBanks:
                dc.b    $60, $5C, $58, $54, $50, $4C, $48, $44
                dc.b    $E0, $DC, $D8, $D4, $D0, $CC, $C8, $C4
                even
ICZMiniS3_OrbDispersalVelocities:
                dc.w    -$300, -$400
                dc.w    -$200, -$400
                dc.w    -$100, -$400
                dc.w    0, -$400
                dc.w    $100, -$400
                dc.w    $200, -$400
                dc.w    $300, -$400
                dc.w    $400, -$400
; ---------------------------------------------------------------------------

ICZMiniS3_OrbSetUpperSpawnBand:
                move.w  #$2B8-$40,y_pos(a0)
                bra.w   ICZMiniS3_OrbRandomizeLaneAndHeight

; =============== S U B R O U T I N E =======================================

HandleICZMinibossTwoColorHitOrDefeat:
                tst.b   collision_flags(a0)
                bne.s   ICZMiniS3_HitUpdateReturn
                tst.b   collision_property(a0)
                beq.s   ICZMiniS3_BeginDefeatWaitAndExplosion
                tst.b   $20(a0)
                bne.s   ICZMiniS3_HitChooseFlashRow
                move.b  #$20,$20(a0)
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l

ICZMiniS3_HitChooseFlashRow:
                bset    #6,status(a0)
                moveq   #0,d0
                btst    #0,$20(a0)
                bne.s   ICZMiniS3_HitCopyColorsAndTick
                addi.w  #2*2,d0

ICZMiniS3_HitCopyColorsAndTick:
                bsr.w   CopyICZMinibossTwoColorPalette
                subq.b  #1,$20(a0)
                bne.s   ICZMiniS3_HitUpdateReturn
                bclr    #6,status(a0)
                move.b  $25(a0),collision_flags(a0)

ICZMiniS3_HitUpdateReturn:
                rts
; ---------------------------------------------------------------------------

ICZMiniS3_BeginDefeatWaitAndExplosion:
                move.l  #Wait_Draw,(a0)
                move.l  #ICZMiniS3_StartSignAndStopSnow,$34(a0)
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     CreateChild1_Normal(pc)
                jmp     BossDefeated_StopTimer(pc)
; End of function HandleICZMinibossTwoColorHitOrDefeat

; =============== S U B R O U T I N E =======================================

CopyICZMinibossTwoColorPalette:
                lea     ICZMiniS3_HitPaletteDestinations(pc),a1
                lea     ICZMiniS3_HitPaletteColorRows(pc,d0.w),a2
                rept    2
                movea.w (a1)+,a3
                move.w  (a2)+,(a3)+
                endm
                rts
; End of function CopyICZMinibossTwoColorPalette

; ---------------------------------------------------------------------------
ICZMiniS3_HitPaletteDestinations:
                dc.w    Normal_palette_line_2+$14, Normal_palette_line_2+$16
ICZMiniS3_HitPaletteColorRows:
                dc.w    $222,   $20
                dc.w    $EEE,  $EEE
ICZMiniS3_BodyAttributes:
                dc.l    Map_ICZMiniboss
                dc.w    make_art_tile(ArtTile_ICZMiniboss,1,1)
                dc.w    $280
                dc.b    $18, $18,   0,   6
ICZMiniS3_TrimAttributes:
                dc.w    $280
                dc.b    $10,  $C,   1,   0
ICZMiniS3_OrbAttributes:
                dc.l    Map_ICZMiniboss
                dc.w    make_art_tile(ArtTile_ICZMiniboss,2,0)
                dc.w    $280
                dc.b    $C,  $C,   6,   0
ICZMiniS3_FragmentAttributes:
                dc.w    $180
                dc.b    $C,  $C,  $B,   0
ICZMinibossS3_Root_SixNormalTrimRecords:
                dc.w    6-1
                dc.l    ICZMiniS3_TrimFollowDispatchAndDraw
                dc.b    -$E, -$B
                dc.l    ICZMiniS3_TrimFollowDispatchAndDraw
                dc.b    $E, -$B
                dc.l    ICZMiniS3_TrimFollowDispatchAndDraw
                dc.b    0, $12
                dc.l    ICZMiniS3_TrimFollowDispatchAndDraw
                dc.b    -$E, -$B
                dc.l    ICZMiniS3_TrimFollowDispatchAndDraw
                dc.b    $E, -$B
                dc.l    ICZMiniS3_TrimFollowDispatchAndDraw
                dc.b    0,  $E
ICZMinibossS3_Root_EightSimpleOrbRecord:
                dc.w    8-1
                dc.l    ICZMiniS3_OrbDispatchAndDraw
ICZMiniS3_DefeatFragmentChildren:
                dc.w    4-1
                dc.l    ICZMiniS3_InitDefeatFragment
                dc.b    -$C, -$C
                dc.l    ICZMiniS3_InitDefeatFragment
                dc.b    $C, -$C
                dc.l    ICZMiniS3_InitDefeatFragment
                dc.b    -$C,  $C
                dc.l    ICZMiniS3_InitDefeatFragment
                dc.b    $C,  $C
                dc.b    0
                dc.b    3
                dc.b    1
                dc.b    3
                dc.b    2
                dc.b    3
                dc.b    3
                dc.b    3
                dc.b    4
                dc.b    3
                dc.b    5
                dc.b    3
                dc.b    6
                dc.b    3
                dc.b    $F4
                even
Pal_ICZMiniboss:
                binclude "data/Levels/ICZ/Palettes/Miniboss.bin"
                even
