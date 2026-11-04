; Owner: objects/enemies/hcz/sk
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
                dc.w    SKTurboSpiker_InitBodyAndPickHiddenMode-TurboSpiker_Index
                dc.w    SKTurboSpiker_CheckTargetOrPatrol-TurboSpiker_Index
                dc.w    HCZTurboSpikerSK_CountManualTurnPause-TurboSpiker_Index
                dc.w    HCZTurboSpikerSK_CountRetreatChargePause-TurboSpiker_Index
                dc.w    SKTurboSpiker_StepRushAndProbeFloor-TurboSpiker_Index
                dc.w    SKTurboSpiker_WaitHiddenForPlayer-TurboSpiker_Index
                dc.w    SKTurboSpiker_TickEmergenceDelay-TurboSpiker_Index
                dc.w    HCZTurboSpikerSK_CountFinalEmergenceWait-TurboSpiker_Index
; ---------------------------------------------------------------------------

SKTurboSpiker_InitBodyAndPickHiddenMode:
                lea     ObjDat_TurboSpiker(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                bclr    #1,render_flags(a0)
                beq.s   SKTurboSpiker_InitPatrolAndTrySpike
                move.b  #$A,routine(a0)
                lea     SKTurboSpiker_HiddenCoverRecord(pc),a2
                jsr     CreateChild1_Normal(pc)

SKTurboSpiker_InitPatrolAndTrySpike:
                move.b  #$10,x_radius(a0)
                move.b  #$F,y_radius(a0)
                move.l  #SKTurboSpiker_SlowBodyAnim,$30(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                add.w   d0,d0
                move.w  d0,$2E(a0)
                add.w   d0,d0
                move.w  d0,$3C(a0)
                move.l  #SKTurboSpiker_StartTurnWait,$34(a0)
                move.w  #-$80,d4
                jsr     Set_VelocityXTrackSonic(pc)
                lea     SKTurboSpiker_AttachedSpikeRecord(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

SKTurboSpiker_CheckTargetOrPatrol:
                jsr     Find_SonicTails(pc)
                cmpi.w  #$60,d2
                bhs.s   SKTurboSpiker_StepPatrolAndProbeFloor
                btst    #0,render_flags(a0)
                beq.s   SKTurboSpiker_CheckAdjustedTargetSide
                subq.w  #2,d0

SKTurboSpiker_CheckAdjustedTargetSide:
                tst.w   d0
                beq.s   SKTurboSpiker_StartRetreat

SKTurboSpiker_StepPatrolAndProbeFloor:
                jsr     Animate_Raw(pc)
                jsr     (MoveSprite2).l
                jsr     Obj_Wait(pc)
                jmp     ObjHitFloor2_DoRoutine(pc)
; ---------------------------------------------------------------------------

SKTurboSpiker_StartTurnWait:
                move.b  routine(a0),d0
                cmpi.b  #4,d0
                beq.s   SKTurboSpiker_TurnOrTrailReturn
                move.b  d0,$3A(a0)
                move.b  #4,routine(a0)
                move.w  #$F,$2E(a0)

SKTurboSpiker_TurnOrTrailReturn:
                rts
; ---------------------------------------------------------------------------

SKTurboSpiker_StartRetreat:
                move.b  #6,routine(a0)
                move.w  #$F,$2E(a0)
                move.w  #$200,d0
                bchg    #0,render_flags(a0)
                beq.s   SKTurboSpiker_StoreRetreatVelocity
                neg.w   d0

SKTurboSpiker_StoreRetreatVelocity:
                move.w  d0,x_vel(a0)
                rts
; ---------------------------------------------------------------------------

HCZTurboSpikerSK_CountManualTurnPause:
                subq.w  #1,$2E(a0)
                bmi.s   SKTurboSpiker_ReverseAndRestorePatrol
                rts
; ---------------------------------------------------------------------------

SKTurboSpiker_ReverseAndRestorePatrol:
                move.b  $3A(a0),routine(a0)
                neg.w   x_vel(a0)
                bchg    #0,render_flags(a0)
                move.w  $3C(a0),$2E(a0)
                rts
; ---------------------------------------------------------------------------

HCZTurboSpikerSK_CountRetreatChargePause:
                subq.w  #1,$2E(a0)
                bmi.s   SKTurboSpiker_ReleaseSpikeAndStartRush
                rts
; ---------------------------------------------------------------------------

SKTurboSpiker_ReleaseSpikeAndStartRush:
                move.b  #8,routine(a0)
                bset    #1,$38(a0)
                move.l  #SKTurboSpiker_FastBodyAnim,$30(a0)
                rts
; ---------------------------------------------------------------------------

SKTurboSpiker_StepRushAndProbeFloor:
                jsr     Animate_Raw(pc)
                jsr     (MoveSprite2).l
                jmp     ObjHitFloor2_DoRoutine(pc)
; ---------------------------------------------------------------------------

SKTurboSpiker_WaitHiddenForPlayer:
                jsr     Find_SonicTails(pc)
                cmpi.w  #$60,d2
                blo.s   SKTurboSpiker_EmergeAndTrySplashes
                rts
; ---------------------------------------------------------------------------

SKTurboSpiker_EmergeAndTrySplashes:
                move.b  #$C,routine(a0)
                bset    #0,$38(a0)
                move.w  #3,$2E(a0)
                lea     SKTurboSpiker_EmergenceSplashRecords(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

SKTurboSpiker_TickEmergenceDelay:
                subq.w  #1,$2E(a0)
                bmi.s   SKTurboSpiker_RaisePriorityAndWait
                rts
; ---------------------------------------------------------------------------

SKTurboSpiker_RaisePriorityAndWait:
                move.b  #$E,routine(a0)
                move.w  #$180,priority(a0)
                move.w  #$F,$2E(a0)
                rts
; ---------------------------------------------------------------------------

HCZTurboSpikerSK_CountFinalEmergenceWait:
                subq.w  #1,$2E(a0)
                bmi.s   SKTurboSpiker_ResumePatrolAfterEmerge
                rts
; ---------------------------------------------------------------------------

SKTurboSpiker_ResumePatrolAfterEmerge:
                move.b  #2,routine(a0)
                rts
; ---------------------------------------------------------------------------

SKTurboSpiker_InitAttachedSpike:
                lea     HCZTurboSpikerSK_SpikePartialAttributes(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #SKTurboSpiker_FollowUntilSpikeRelease,(a0)
                jmp     Child_DrawTouch_Sprite(pc)
; ---------------------------------------------------------------------------

SKTurboSpiker_FollowUntilSpikeRelease:
                jsr     Refresh_ChildPositionAdjusted(pc)
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                bne.s   SKTurboSpiker_StartSpikeFlight
                jmp     Child_DrawTouch_Sprite(pc)
; ---------------------------------------------------------------------------

SKTurboSpiker_StartSpikeFlight:
                move.l  #SKTurboSpiker_MoveAndDrawFlyingSpike,(a0)
                move.w  #$100,d0
                btst    #0,render_flags(a0)
                beq.s   SKTurboSpiker_LaunchSpikeAndTryTrail
                neg.w   d0

SKTurboSpiker_LaunchSpikeAndTryTrail:
                move.w  d0,x_vel(a0)
                move.w  #-$400,y_vel(a0)
                moveq   #signextendB(sfx_FloorLauncher),d0
                jsr     (Play_SFX).l
                lea     SKTurboSpiker_SpikeTrailRecord(pc),a2
                jsr     CreateChild1_Normal(pc)
                jmp     Sprite_CheckDeleteTouchXY(pc)
; ---------------------------------------------------------------------------

SKTurboSpiker_MoveAndDrawFlyingSpike:
                jsr     (MoveSprite2).l
                jmp     Sprite_CheckDeleteTouchXY(pc)
; ---------------------------------------------------------------------------

SKTurboSpiker_InitSpikeTrail:
                lea     HCZTurboSpikerSK_TrailPartialAttributes(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #SKTurboSpiker_UpdateTrailAndTryPuff,(a0)
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------

; Draw based on the bit value before toggling it
SKTurboSpiker_UpdateTrailAndTryPuff:
                jsr     Refresh_ChildPositionAdjusted(pc)
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   SKTurboSpiker_DeleteTrailAfterSpike
                bsr.w   SpawnTurboSpikerTrailPuffOnVblankPhase
                bchg    #0,$38(a0)
                beq.w   SKTurboSpiker_TurnOrTrailReturn
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKTurboSpiker_DeleteTrailAfterSpike:
                jmp     Go_Delete_Sprite(pc)

; =============== S U B R O U T I N E =======================================

SpawnTurboSpikerTrailPuffOnVblankPhase:
                move.b  (V_int_run_count+3).w,d0
                andi.b  #3,d0
                bne.s   SKTurboSpiker_PuffSpawnReturn
                lea     SKTurboSpiker_TrailPuffRecord(pc),a2
                jsr     CreateChild1_Normal(pc)
                bne.s   SKTurboSpiker_PuffSpawnReturn
                jsr     (Random_Number).l
                andi.w  #7,d0
                subq.w  #3,d0
                add.w   d0,x_pos(a1)
                swap    d0
                andi.w  #7,d0
                subq.w  #3,d0
                add.w   d0,y_pos(a1)

SKTurboSpiker_PuffSpawnReturn:
                rts
; End of function SpawnTurboSpikerTrailPuffOnVblankPhase

; ---------------------------------------------------------------------------

SKTurboSpiker_InitPuff:
                lea     HCZTurboSpikerSK_PuffPartialAttributes(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #SKTurboSpiker_AnimateAndDrawPuff,(a0)
                move.l  #SKTurboSpiker_PuffAnim,$30(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKTurboSpiker_AnimateAndDrawPuff:
                jsr     Animate_Raw(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKTurboSpiker_InitEmergenceSplash:
                lea     SKTurboSpiker_SplashAttrs(pc),a1
                jsr     SetUp_ObjAttributes2(pc)
                move.l  #SKTurboSpiker_TickSplashDelay,(a0)
                move.b  subtype(a0),$2F(a0)
                moveq   #signextendB(sfx_Splash),d0
                jsr     (Play_SFX).l
                rts
; ---------------------------------------------------------------------------

; Initialization writes the low byte. The countdown uses the full word
SKTurboSpiker_TickSplashDelay:
                subq.w  #1,$2E(a0)
                bmi.s   SKTurboSpiker_StartSplashAnim
                rts
; ---------------------------------------------------------------------------

SKTurboSpiker_StartSplashAnim:
                move.l  #HCZTurboSpikerSK_SplashAnimateThenDraw,(a0)
                move.l  #SKTurboSpiker_SplashAnim,$30(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                rts
; ---------------------------------------------------------------------------

HCZTurboSpikerSK_SplashAnimateThenDraw:
                jsr     Animate_Raw(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKTurboSpiker_InitHiddenCover:
                move.l  #SKTurboSpiker_DrawCoverUntilEmerge,(a0)
                lea     SKTurboSpiker_HiddenCoverAttrs(pc),a1
                jmp     SetUp_ObjAttributes(pc)
; ---------------------------------------------------------------------------

SKTurboSpiker_DrawCoverUntilEmerge:
                movea.w parent3(a0),a1
                btst    #0,$38(a1)
                bne.s   SKTurboSpiker_DeleteCover
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------

SKTurboSpiker_DeleteCover:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------
ObjDat_TurboSpiker:
                dc.l    Map_TurboSpiker
                dc.w    make_art_tile(ArtTile_TurboSpiker,1,0)
                dc.w    $280
                dc.b    $20, $20,   0, $1A
HCZTurboSpikerSK_SpikePartialAttributes:
                dc.w    $280
                dc.b    8, $10,   3, $9E
HCZTurboSpikerSK_TrailPartialAttributes:
                dc.w    $200
                dc.b    4,   8,   4,   0
HCZTurboSpikerSK_PuffPartialAttributes:
                dc.w    $280
                dc.b    4,   4,   5,   0
SKTurboSpiker_SplashAttrs:
                dc.w    make_art_tile(ArtTile_TurboSpiker,0,1)
                dc.w    $200
                dc.b    8,   8,   8,   0
SKTurboSpiker_HiddenCoverAttrs:
                dc.l    Map_TurboSpikerHidden
                dc.w    make_art_tile($001,2,1)
                dc.w    $180
                dc.b    $10, $10,   0,   0
SKTurboSpiker_AttachedSpikeRecord:
                dc.w    1-1
                dc.l    SKTurboSpiker_InitAttachedSpike
                dc.b    4,   0
SKTurboSpiker_SpikeTrailRecord:
                dc.w    1-1
                dc.l    SKTurboSpiker_InitSpikeTrail
                dc.b    -4, $14
SKTurboSpiker_TrailPuffRecord:
                dc.w    1-1
                dc.l    SKTurboSpiker_InitPuff
                dc.b    0,   4
SKTurboSpiker_EmergenceSplashRecords:
                dc.w    5-1
                dc.l    SKTurboSpiker_InitEmergenceSplash
                dc.b    4,  -8
                dc.l    SKTurboSpiker_InitEmergenceSplash
                dc.b    -6,   0
                dc.l    SKTurboSpiker_InitEmergenceSplash
                dc.b    6,   0
                dc.l    SKTurboSpiker_InitEmergenceSplash
                dc.b    -8,   0
                dc.l    SKTurboSpiker_InitEmergenceSplash
                dc.b    8,   0
SKTurboSpiker_HiddenCoverRecord:
                dc.w    1-1
                dc.l    SKTurboSpiker_InitHiddenCover
                dc.b    0,   0
SKTurboSpiker_SlowBodyAnim:
                dc.b    5,   0,   1,   2, $FC
SKTurboSpiker_FastBodyAnim:
                dc.b    1,   0,   1,   2, $FC
SKTurboSpiker_PuffAnim:
                dc.b    0,   5,   5,   5,   6,   7, $F4
SKTurboSpiker_SplashAnim:
                dc.b    1,   8,   9,  $A,  $B,  $C,  $D, $F4
                even
Map_TurboSpikerHidden:
                include "src/objects/shared/turbo_spiker/mappings/hidden.s"
