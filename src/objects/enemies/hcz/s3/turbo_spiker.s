; Owner: objects/enemies/hcz/s3
; Responsibility: Turbo Spiker attack states, detached spikes, motion helpers and private resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_TurboSpiker:
                jsr     (Obj_WaitOffscreen).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  TurboSpiker_Index(pc,d0.w),d1
                jsr     TurboSpiker_Index(pc,d1.w)
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------
TurboSpiker_Index:
                dc.w    S3TurboSpiker_InitBodyAndPickHiddenMode-TurboSpiker_Index
                dc.w    S3TurboSpiker_CheckTargetOrPatrol-TurboSpiker_Index
                dc.w    HCZTurboSpikerS3_CountManualTurnPause-TurboSpiker_Index
                dc.w    HCZTurboSpikerS3_CountRetreatChargePause-TurboSpiker_Index
                dc.w    S3TurboSpiker_StepRushAndProbeFloor-TurboSpiker_Index
                dc.w    S3TurboSpiker_WaitHiddenForPlayer-TurboSpiker_Index
                dc.w    S3TurboSpiker_TickEmergenceDelay-TurboSpiker_Index
                dc.w    HCZTurboSpikerS3_CountFinalEmergenceWait-TurboSpiker_Index
; ---------------------------------------------------------------------------

S3TurboSpiker_InitBodyAndPickHiddenMode:
                lea     ObjDat_TurboSpiker(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                bclr    #1,render_flags(a0)
                beq.s   S3TurboSpiker_InitPatrolAndTrySpike
                move.b  #$A,routine(a0)
                lea     S3TurboSpiker_HiddenCoverRecord(pc),a2
                jsr     CreateChild1_Normal(pc)

S3TurboSpiker_InitPatrolAndTrySpike:
                move.b  #$10,x_radius(a0)
                move.b  #$F,y_radius(a0)
                move.l  #S3TurboSpiker_SlowBodyAnim,$30(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                add.w   d0,d0
                move.w  d0,$2E(a0)
                add.w   d0,d0
                move.w  d0,$3C(a0)
                move.l  #S3TurboSpiker_StartTurnWait,$34(a0)
                move.w  #-$80,d4
                jsr     Set_VelocityXTrackSonic(pc)
                lea     S3TurboSpiker_AttachedSpikeRecord(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

S3TurboSpiker_CheckTargetOrPatrol:
                jsr     Find_SonicTails(pc)
                cmpi.w  #$60,d2
                bhs.s   S3TurboSpiker_StepPatrolAndProbeFloor
                btst    #0,render_flags(a0)
                beq.s   S3TurboSpiker_CheckAdjustedTargetSide
                subq.w  #2,d0

S3TurboSpiker_CheckAdjustedTargetSide:
                tst.w   d0
                beq.s   S3TurboSpiker_StartRetreat

S3TurboSpiker_StepPatrolAndProbeFloor:
                jsr     Animate_Raw(pc)
                jsr     (MoveSprite2).l
                jsr     Obj_Wait(pc)
                jmp     ObjHitFloor2_DoRoutine(pc)
; ---------------------------------------------------------------------------

S3TurboSpiker_StartTurnWait:
                move.b  routine(a0),d0
                cmpi.b  #4,d0
                beq.s   S3TurboSpiker_TurnOrTrailReturn
                move.b  d0,$3A(a0)
                move.b  #4,routine(a0)
                move.w  #$F,$2E(a0)

S3TurboSpiker_TurnOrTrailReturn:
                rts
; ---------------------------------------------------------------------------

S3TurboSpiker_StartRetreat:
                move.b  #6,routine(a0)
                move.w  #$F,$2E(a0)
                move.w  #$200,d0
                bchg    #0,render_flags(a0)
                beq.s   S3TurboSpiker_StoreRetreatVelocity
                neg.w   d0

S3TurboSpiker_StoreRetreatVelocity:
                move.w  d0,x_vel(a0)
                rts
; ---------------------------------------------------------------------------

HCZTurboSpikerS3_CountManualTurnPause:
                subq.w  #1,$2E(a0)
                bmi.s   S3TurboSpiker_ReverseAndRestorePatrol
                rts
; ---------------------------------------------------------------------------

S3TurboSpiker_ReverseAndRestorePatrol:
                move.b  $3A(a0),routine(a0)
                neg.w   x_vel(a0)
                bchg    #0,render_flags(a0)
                move.w  $3C(a0),$2E(a0)
                rts
; ---------------------------------------------------------------------------

HCZTurboSpikerS3_CountRetreatChargePause:
                subq.w  #1,$2E(a0)
                bmi.s   S3TurboSpiker_ReleaseSpikeAndStartRush
                rts
; ---------------------------------------------------------------------------

S3TurboSpiker_ReleaseSpikeAndStartRush:
                move.b  #8,routine(a0)
                bset    #1,$38(a0)
                move.l  #S3TurboSpiker_FastBodyAnim,$30(a0)
                rts
; ---------------------------------------------------------------------------

S3TurboSpiker_StepRushAndProbeFloor:
                jsr     Animate_Raw(pc)
                jsr     (MoveSprite2).l
                jmp     ObjHitFloor2_DoRoutine(pc)
; ---------------------------------------------------------------------------

S3TurboSpiker_WaitHiddenForPlayer:
                jsr     Find_SonicTails(pc)
                cmpi.w  #$60,d2
                blo.s   S3TurboSpiker_EmergeAndTrySplashes
                rts
; ---------------------------------------------------------------------------

S3TurboSpiker_EmergeAndTrySplashes:
                move.b  #$C,routine(a0)
                bset    #0,$38(a0)
                move.w  #3,$2E(a0)
                lea     S3TurboSpiker_EmergenceSplashRecords(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

S3TurboSpiker_TickEmergenceDelay:
                subq.w  #1,$2E(a0)
                bmi.s   S3TurboSpiker_RaisePriorityAndWait
                rts
; ---------------------------------------------------------------------------

S3TurboSpiker_RaisePriorityAndWait:
                move.b  #$E,routine(a0)
                move.w  #$180,priority(a0)
                move.w  #$F,$2E(a0)
                rts
; ---------------------------------------------------------------------------

HCZTurboSpikerS3_CountFinalEmergenceWait:
                subq.w  #1,$2E(a0)
                bmi.s   S3TurboSpiker_ResumePatrolAfterEmerge
                rts
; ---------------------------------------------------------------------------

S3TurboSpiker_ResumePatrolAfterEmerge:
                move.b  #2,routine(a0)
                rts
; ---------------------------------------------------------------------------

S3TurboSpiker_InitAttachedSpike:
                lea     HCZTurboSpikerS3_SpikePartialAttributes(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #S3TurboSpiker_FollowUntilSpikeRelease,(a0)
                jmp     Child_DrawTouch_Sprite(pc)
; ---------------------------------------------------------------------------

S3TurboSpiker_FollowUntilSpikeRelease:
                jsr     Refresh_ChildPositionAdjusted(pc)
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                bne.s   S3TurboSpiker_StartSpikeFlight
                jmp     Child_DrawTouch_Sprite(pc)
; ---------------------------------------------------------------------------

S3TurboSpiker_StartSpikeFlight:
                move.l  #S3TurboSpiker_MoveAndDrawFlyingSpike,(a0)
                move.w  #$100,d0
                btst    #0,render_flags(a0)
                beq.s   S3TurboSpiker_LaunchSpikeAndTryTrail
                neg.w   d0

S3TurboSpiker_LaunchSpikeAndTryTrail:
                move.w  d0,x_vel(a0)
                move.w  #-$400,y_vel(a0)
                moveq   #signextendB(sfx_FloorLauncher),d0
                jsr     (Play_SFX).l
                lea     S3TurboSpiker_SpikeTrailRecord(pc),a2
                jsr     CreateChild1_Normal(pc)
                jmp     Sprite_CheckDeleteTouchXY(pc)
; ---------------------------------------------------------------------------

S3TurboSpiker_MoveAndDrawFlyingSpike:
                jsr     (MoveSprite2).l
                jmp     Sprite_CheckDeleteTouchXY(pc)
; ---------------------------------------------------------------------------

S3TurboSpiker_InitSpikeTrail:
                lea     HCZTurboSpikerS3_TrailPartialAttributes(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #S3TurboSpiker_UpdateTrailAndTryPuff,(a0)
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------

; Draw based on the bit value before toggling it
S3TurboSpiker_UpdateTrailAndTryPuff:
                jsr     Refresh_ChildPositionAdjusted(pc)
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   S3TurboSpiker_DeleteTrailAfterSpike
                bsr.w   SpawnTurboSpikerTrailPuffOnVblankPhase
                bchg    #0,$38(a0)
                beq.w   S3TurboSpiker_TurnOrTrailReturn
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3TurboSpiker_DeleteTrailAfterSpike:
                jmp     Go_Delete_Sprite(pc)

; =============== S U B R O U T I N E =======================================

SpawnTurboSpikerTrailPuffOnVblankPhase:
                move.b  (V_int_run_count+3).w,d0
                andi.b  #3,d0
                bne.s   S3TurboSpiker_PuffSpawnReturn
                lea     S3TurboSpiker_TrailPuffRecord(pc),a2
                jsr     CreateChild1_Normal(pc)
                bne.s   S3TurboSpiker_PuffSpawnReturn
                jsr     (Random_Number).l
                andi.w  #7,d0
                subq.w  #3,d0
                add.w   d0,x_pos(a1)
                swap    d0
                andi.w  #7,d0
                subq.w  #3,d0
                add.w   d0,y_pos(a1)

S3TurboSpiker_PuffSpawnReturn:
                rts
; End of function SpawnTurboSpikerTrailPuffOnVblankPhase

; ---------------------------------------------------------------------------

S3TurboSpiker_InitPuff:
                lea     HCZTurboSpikerS3_PuffPartialAttributes(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #S3TurboSpiker_AnimateAndDrawPuff,(a0)
                move.l  #S3TurboSpiker_PuffAnim,$30(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3TurboSpiker_AnimateAndDrawPuff:
                jsr     Animate_Raw(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3TurboSpiker_InitEmergenceSplash:
                lea     S3TurboSpiker_SplashAttrs(pc),a1
                jsr     SetUp_ObjAttributes2(pc)
                move.l  #S3TurboSpiker_TickSplashDelay,(a0)
                move.b  subtype(a0),$2F(a0)
                moveq   #signextendB(sfx_Splash),d0
                jsr     (Play_SFX).l
                rts
; ---------------------------------------------------------------------------

; Initialization writes the low byte. The countdown uses the full word
S3TurboSpiker_TickSplashDelay:
                subq.w  #1,$2E(a0)
                bmi.s   S3TurboSpiker_StartSplashAnim
                rts
; ---------------------------------------------------------------------------

S3TurboSpiker_StartSplashAnim:
                move.l  #HCZTurboSpikerS3_SplashAnimateThenDraw,(a0)
                move.l  #S3TurboSpiker_SplashAnim,$30(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                rts
; ---------------------------------------------------------------------------

HCZTurboSpikerS3_SplashAnimateThenDraw:
                jsr     Animate_Raw(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3TurboSpiker_InitHiddenCover:
                move.l  #S3TurboSpiker_DrawCoverUntilEmerge,(a0)
                lea     S3TurboSpiker_HiddenCoverAttrs(pc),a1
                jmp     SetUp_ObjAttributes(pc)
; ---------------------------------------------------------------------------

S3TurboSpiker_DrawCoverUntilEmerge:
                movea.w parent3(a0),a1
                btst    #0,$38(a1)
                bne.s   S3TurboSpiker_DeleteCover
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------

S3TurboSpiker_DeleteCover:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------
ObjDat_TurboSpiker:
                dc.l    Map_TurboSpiker
                dc.w    make_art_tile(ArtTile_TurboSpiker,1,0)
                dc.w    $280
                dc.b    $20, $20,   0, $1A
HCZTurboSpikerS3_SpikePartialAttributes:
                dc.w    $280
                dc.b    8, $10,   3, $9E
HCZTurboSpikerS3_TrailPartialAttributes:
                dc.w    $200
                dc.b    4,   8,   4,   0
HCZTurboSpikerS3_PuffPartialAttributes:
                dc.w    $280
                dc.b    4,   4,   5,   0
S3TurboSpiker_SplashAttrs:
                dc.w    make_art_tile(ArtTile_TurboSpiker,0,1)
                dc.w    $200
                dc.b    8,   8,   8,   0
S3TurboSpiker_HiddenCoverAttrs:
                dc.l    Map_TurboSpikerHidden
                dc.w    make_art_tile($001,2,1)
                dc.w    $180
                dc.b    $10, $10,   0,   0
S3TurboSpiker_AttachedSpikeRecord:
                dc.w    1-1
                dc.l    S3TurboSpiker_InitAttachedSpike
                dc.b    4,   0
S3TurboSpiker_SpikeTrailRecord:
                dc.w    1-1
                dc.l    S3TurboSpiker_InitSpikeTrail
                dc.b    -4, $14
S3TurboSpiker_TrailPuffRecord:
                dc.w    1-1
                dc.l    S3TurboSpiker_InitPuff
                dc.b    0,   4
S3TurboSpiker_EmergenceSplashRecords:
                dc.w    5-1
                dc.l    S3TurboSpiker_InitEmergenceSplash
                dc.b    4,  -8
                dc.l    S3TurboSpiker_InitEmergenceSplash
                dc.b    -6,   0
                dc.l    S3TurboSpiker_InitEmergenceSplash
                dc.b    6,   0
                dc.l    S3TurboSpiker_InitEmergenceSplash
                dc.b    -8,   0
                dc.l    S3TurboSpiker_InitEmergenceSplash
                dc.b    8,   0
S3TurboSpiker_HiddenCoverRecord:
                dc.w    1-1
                dc.l    S3TurboSpiker_InitHiddenCover
                dc.b    0,   0
S3TurboSpiker_SlowBodyAnim:
                dc.b    5,   0,   1,   2, $FC
S3TurboSpiker_FastBodyAnim:
                dc.b    1,   0,   1,   2, $FC
S3TurboSpiker_PuffAnim:
                dc.b    0,   5,   5,   5,   6,   7, $F4
S3TurboSpiker_SplashAnim:
                dc.b    1,   8,   9,  $A,  $B,  $C,  $D, $F4
                even
Map_TurboSpikerHidden:
                include "src/objects/shared/turbo_spiker/mappings/hidden.s"
