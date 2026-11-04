; Owner: objects/enemies/sk
; Responsibility: Rockn enemy and attached rock actors, player contact, movement and private object resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_Rockn:
                jsr     (Obj_WaitOffscreen).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Rockn_Index(pc,d0.w),d1
                jsr     Rockn_Index(pc,d1.w)
                jmp     (Sprite_CheckDeleteTouch).l
; ---------------------------------------------------------------------------
Rockn_Index:
                dc.w    SKRockn_InitBodyAndBounds-Rockn_Index
                dc.w    SKRockn_WaitForCoverRise-Rockn_Index
                dc.w    SKRockn_AnimateAndCheckP1-Rockn_Index
; ---------------------------------------------------------------------------

SKRockn_InitBodyAndBounds:
                lea     RocknSK_Body_FullAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.b  #7,y_radius(a0)
                move.b  subtype(a0),d0
                bne.s   RocknSK_Body_ComputeNibblePatrolBounds
                clr.w   $3A(a0)
                move.w  #$7FFF,$3C(a0)
                bra.w   SKRockn_SelectStartSpeed
; ---------------------------------------------------------------------------

RocknSK_Body_ComputeNibblePatrolBounds:
                move.b  d0,d1
                andi.w  #$F0,d0
                neg.w   d0
                add.w   x_pos(a0),d0
                move.w  d0,$3A(a0)
                andi.w  #$F,d1
                lsl.w   #4,d1
                add.w   x_pos(a0),d1
                move.w  d1,$3C(a0)

SKRockn_SelectStartSpeed:
                moveq   #-$80,d0
                btst    #0,render_flags(a0)
                beq.s   SKRockn_InitSpeedAndSpawnCover
                neg.w   d0

SKRockn_InitSpeedAndSpawnCover:
                move.w  d0,x_vel(a0)
                lea     RocknSK_Body_OneNormalCoveringRockRecord(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

SKRockn_WaitForCoverRise:
                btst    #2,$38(a0)
                beq.s   SKRockn_EmergenceWaitReturn
                move.b  #4,routine(a0)
                move.b  #$D9,collision_flags(a0)
                move.l  #SKRockn_TurnOrStopAtFloorGap,$34(a0)

SKRockn_EmergenceWaitReturn:
                rts
; ---------------------------------------------------------------------------

SKRockn_AnimateAndCheckP1:
                lea     (RocknSK_Body_UniformWalkingFrames).l,a1
                jsr     (Animate_RawNoSST).l
                bclr    #0,$38(a0)
                lea     (Player_1).w,a1
                move.w  x_pos(a1),d0
                cmp.w   $3A(a0),d0
                blo.s   SKRockn_TryProbeAheadFloor
                cmp.w   $3C(a0),d0
                bhs.s   SKRockn_TryProbeAheadFloor
                move.w  y_pos(a1),d1
                sub.w   y_pos(a0),d1
                bpl.s   SKRockn_CheckP1YAndChooseSpeed
                neg.w   d1

SKRockn_CheckP1YAndChooseSpeed:
                cmpi.w  #$10,d1
                bhs.s   SKRockn_TryProbeAheadFloor
                bset    #0,$38(a0)
                moveq   #-$80,d1
                sub.w   x_pos(a0),d0
                bcs.s   SKRockn_StorePursuitSpeed
                neg.w   d1

SKRockn_StorePursuitSpeed:
                move.w  d1,x_vel(a0)

SKRockn_TryProbeAheadFloor:
                tst.w   x_vel(a0)
                beq.s   SKRockn_SelectPatrolOrPursuit
                jsr     (ObjHitFloor2_DoRoutine).l

SKRockn_SelectPatrolOrPursuit:
                move.w  x_pos(a0),d0
                move.w  x_vel(a0),d1
                bne.s   SKRockn_CheckRightwardPatrol
                btst    #0,$38(a0)
                bne.s   SKRockn_CheckRangeAndP1Attack
                tst.w   d1

; Branch left using the flags from the current X velocity
SKRockn_CheckRightwardPatrol:
                bmi.s   SKRockn_CheckLeftwardPatrol
                move.w  #$80,d1
                bset    #0,render_flags(a0)
                cmp.w   $3C(a0),d0
                bhs.s   SKRockn_ReversePatrol
                bra.w   RocknSK_Body_StoreResolvedSpeedAndMove
; ---------------------------------------------------------------------------

SKRockn_CheckLeftwardPatrol:
                moveq   #-$80,d1
                bclr    #0,render_flags(a0)
                cmp.w   $3A(a0),d0
                bhs.s   RocknSK_Body_StoreResolvedSpeedAndMove

SKRockn_ReversePatrol:
                neg.w   d1
                bchg    #0,render_flags(a0)

RocknSK_Body_StoreResolvedSpeedAndMove:
                move.w  d1,x_vel(a0)
                jsr     (MoveSprite2).l

SKRockn_CheckRangeAndP1Attack:
                lea     SKRockn_AttackContactBounds(pc),a1
                jsr     (Check_PlayerInRange).l
                tst.w   d0
                beq.s   SKRockn_CheckP2Attack
                bsr.w   DefeatRocknForGroundedAttackingPlayer

SKRockn_CheckP2Attack:
                swap    d0
                tst.w   d0
                beq.s   SKRockn_AttackCheckReturn

; =============== S U B R O U T I N E =======================================

DefeatRocknForGroundedAttackingPlayer:
                movea.w d0,a1
                jsr     (Check_PlayerAttack).l
                beq.s   SKRockn_AttackCheckReturn
                btst    #Status_InAir,status(a1)
                bne.s   SKRockn_AttackCheckReturn
                move.w  a1,$44(a0)
                jsr     (EnemyDefeated).l
                addq.w  #4,sp

SKRockn_AttackCheckReturn:
                rts
; End of function DefeatRocknForGroundedAttackingPlayer

; ---------------------------------------------------------------------------
SKRockn_AttackContactBounds:
                dc.w    -$29,   $52,  -$10,   $20
; ---------------------------------------------------------------------------

SKRockn_TurnOrStopAtFloorGap:
                btst    #0,$38(a0)
                bne.s   SKRockn_StopPursuit
                moveq   #-$80,d0
                bchg    #0,render_flags(a0)
                bne.s   RocknSK_Body_StoreFloorResponseVelocity
                neg.w   d0

RocknSK_Body_StoreFloorResponseVelocity:
                move.w  d0,x_vel(a0)
                rts
; ---------------------------------------------------------------------------

SKRockn_StopPursuit:
                clr.w   x_vel(a0)
                rts
; ---------------------------------------------------------------------------

SKRocknCover_DispatchCoverAndCheckSolid:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  SKRocknCover_CoverStateOffsets(pc,d0.w),d1
                move.w  x_pos(a0),-(sp)
                jsr     SKRocknCover_CoverStateOffsets(pc,d1.w)
                moveq   #$23,d1
                moveq   #$10,d2
                moveq   #$11,d3
                move.w  (sp)+,d4
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   SKRocknCover_ReleaseRidersAndDelete
                jsr     (SolidObjectFull).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKRocknCover_ReleaseRidersAndDelete:
                jsr     (Displace_PlayerOffObject).l
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------
SKRocknCover_CoverStateOffsets:
                dc.w    SKRocknCover_InitCoverAndFollow-SKRocknCover_CoverStateOffsets
                dc.w    SKRocknCover_CheckP1AndSpawnVisual-SKRocknCover_CoverStateOffsets
                dc.w    SKRocknCover_TickRiseDelay-SKRocknCover_CoverStateOffsets
                dc.w    SKRocknCover_StepCoverRise-SKRocknCover_CoverStateOffsets
                dc.w    SKRocknCover_SelectCoverOffset-SKRocknCover_CoverStateOffsets
; ---------------------------------------------------------------------------

SKRocknCover_InitCoverAndFollow:
                lea     RocknSK_CoverRock_FullSandRockAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                jmp     (Refresh_ChildPositionAdjusted).l
; ---------------------------------------------------------------------------

SKRocknCover_CheckP1AndSpawnVisual:
                lea     (Player_1).w,a1
                jsr     (Find_OtherObject).l
                cmpi.w  #$28,d2
                bhi.w   SKRockn_EmergenceWaitReturn
                cmpi.w  #$40,d3
                bhi.w   SKRockn_EmergenceWaitReturn
                move.b  #4,routine(a0)
                move.w  #7,$2E(a0)
                lea     RocknSK_CoverRock_OneSimpleVisualRecord(pc),a2
                jmp     (CreateChild6_Simple).l
; ---------------------------------------------------------------------------

SKRocknCover_TickRiseDelay:
                subq.w  #1,$2E(a0)
                bpl.s   RocknSK_CoverRock_ReturnAfterPauseGate
                move.b  #6,routine(a0)
                move.w  #7,$2E(a0)

RocknSK_CoverRock_ReturnAfterPauseGate:
                rts
; ---------------------------------------------------------------------------

SKRocknCover_StepCoverRise:
                subq.w  #2,y_pos(a0)
                subq.w  #1,$2E(a0)
                bmi.s   SKRocknCover_SignalBodyEmergence
                rts
; ---------------------------------------------------------------------------

SKRocknCover_SignalBodyEmergence:
                move.b  #8,routine(a0)
                movea.w parent3(a0),a1
                bset    #2,$38(a1)
                rts
; ---------------------------------------------------------------------------

SKRocknCover_SelectCoverOffset:
                movea.w parent3(a0),a1
                moveq   #-$18,d0
                tst.b   mapping_frame(a1)
                beq.s   SKRocknCover_ApplyCoverOffset
                moveq   #-$17,d0

SKRocknCover_ApplyCoverOffset:
                move.b  d0,child_dy(a0)
                jmp     (Refresh_ChildPositionAdjusted).l
; ---------------------------------------------------------------------------

SKRocknCoverFx_InitCoverVisual:
                lea     RocknSK_CoverVisual_FullAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #SKRocknCoverFx_TickVisualDelay,(a0)
                move.w  #5,$2E(a0)

SKRocknCoverFx_TickVisualDelay:
                subq.w  #1,$2E(a0)
                bpl.s   SKRocknCoverFx_FollowAndDrawWaiting
                move.l  #SKRocknCoverFx_FollowAndDrawRaised,(a0)
                move.b  #3,mapping_frame(a0)

SKRocknCoverFx_FollowAndDrawWaiting:
                jsr     (Refresh_ChildPositionAdjusted).l
                jmp     (Child_Draw_Sprite).l
; ---------------------------------------------------------------------------

SKRocknCoverFx_FollowAndDrawRaised:
                jsr     (Refresh_ChildPositionAdjusted).l
                jmp     (Child_Draw_Sprite).l
; ---------------------------------------------------------------------------
RocknSK_Body_FullAttributes:
                dc.l    Map_Rockn
                dc.w    make_art_tile(ArtTile_Rockn,1,0)
                dc.w    $280
                dc.b    $10,   8,   0,   0
RocknSK_CoverRock_FullSandRockAttributes:
                dc.l    Map_SOZBreakableSandRock
                dc.w    make_art_tile(ArtTile_SOZMisc+$10,2,0)
                dc.w    $200
                dc.b    $18, $10,   0,   0
RocknSK_CoverVisual_FullAttributes:
                dc.l    Map_Rockn
                dc.w    make_art_tile(ArtTile_Rockn,1,0)
                dc.w    $180
                dc.b    $18, $10,   4,   0
RocknSK_Body_OneNormalCoveringRockRecord:
                dc.w    1-1
                dc.l    SKRocknCover_DispatchCoverAndCheckSolid
                dc.b    0,  -8
RocknSK_CoverRock_OneSimpleVisualRecord:
                dc.w    1-1
                dc.l    SKRocknCoverFx_InitCoverVisual
RocknSK_Body_UniformWalkingFrames:
                dc.b    8,   0,   1,   0,   2, $FC
                even
Map_Rockn:
                include "src/objects/shared/rockn/mappings/rock_n.s"
