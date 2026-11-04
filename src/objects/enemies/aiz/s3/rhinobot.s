; Owner: objects/enemies/aiz/s3
; Responsibility: Rhinobot charge and tracking states, movement helpers and sprite pattern resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_Rhinobot:
                jsr     (Obj_WaitOffscreen).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Rhinobot_Index(pc,d0.w),d1
                jsr     Rhinobot_Index(pc,d1.w)
                lea     DPLCPtr_AIZRhinobot(pc),a2
                jsr     Perform_DPLC(pc)
                jmp     Sprite_CheckDeleteTouchSlotted(pc)
; ---------------------------------------------------------------------------
Rhinobot_Index:
                dc.w    S3Rhinobot_InitArtAndPatrol-Rhinobot_Index
                dc.w    S3Rhinobot_RunPatrol-Rhinobot_Index
                dc.w    RhinobotS3_Charge_CountPreparationWait-Rhinobot_Index
                dc.w    S3Rhinobot_RunCharge-Rhinobot_Index
; ---------------------------------------------------------------------------

S3Rhinobot_InitArtAndPatrol:
                lea     ObjSlot_Rhinobot(pc),a1
                jsr     SetUp_ObjAttributesSlotted(pc)
                move.b  #8,x_radius(a0)
                move.b  #$10,y_radius(a0)
                move.w  #-$10,d0
                move.w  #-$300,d1
                btst    #0,render_flags(a0)
                beq.s   S3Rhinobot_SetPatrolSpeedAndCallback
                neg.w   d0
                neg.w   d1
                bset    #3,$38(a0)
                bset    #2,$38(a0)

S3Rhinobot_SetPatrolSpeedAndCallback:
                move.w  d0,$40(a0)
                move.w  d1,$3E(a0)
                move.l  #S3Rhinobot_ReversePatrolAccel,$34(a0)
                rts
; ---------------------------------------------------------------------------

S3Rhinobot_RunPatrol:
                lea     S3Rhinobot_BeginChargeWindup(pc),a3
                bsr.w   TriggerRhinobotChargeForPlayerAhead
                lea     S3Rhinobot_SetTurnaroundPhase(pc),a3
                bsr.w   FollowRhinobotFloorOrAbortState
                move.w  $40(a0),d0
                add.w   d0,x_vel(a0)
                jsr     (MoveSprite2).l
                bsr.w   DispatchRhinobotVelocityMilestone
                bra.w   S3Rhinobot_PickPatrolFrame
; ---------------------------------------------------------------------------

RhinobotS3_Charge_CountPreparationWait:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

S3Rhinobot_RunCharge:
                lea     S3Rhinobot_AbortChargeToPatrol(pc),a3
                bsr.w   FollowRhinobotFloorOrAbortState
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

S3Rhinobot_UpdateDust:
                cmpi.w  #1,(Current_zone_and_act).w
                beq.s   S3Rhinobot_DeleteDustInAct2
                jsr     Refresh_ChildPositionAdjusted(pc)
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  RhinobotS3_Dust_TwoRelativeStateOffsets(pc,d0.w),d1
                jsr     RhinobotS3_Dust_TwoRelativeStateOffsets(pc,d1.w)
                lea     DPLCPtr_AIZRhinobot(pc),a2
                jsr     Perform_DPLC(pc)
                jmp     Child_Remember_Draw_Sprite(pc)
; ---------------------------------------------------------------------------
RhinobotS3_Dust_TwoRelativeStateOffsets:
                dc.w    S3Rhinobot_InitDustArtSlot-RhinobotS3_Dust_TwoRelativeStateOffsets
                dc.w    S3Rhinobot_AnimateDust-RhinobotS3_Dust_TwoRelativeStateOffsets
; ---------------------------------------------------------------------------

S3Rhinobot_DeleteDustInAct2:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

S3Rhinobot_InitDustArtSlot:
                lea     RhinobotS3_Dust_SlottedAttributeRecord(pc),a1
                jsr     SetUp_ObjAttributesSlotted(pc)
                move.l  #Go_Delete_SpriteSlotted3,$34(a0)

S3Rhinobot_AnimateDust:
                jmp     Animate_Raw(pc)
; ---------------------------------------------------------------------------

S3Rhinobot_ReversePatrolAccel:
                bchg    #2,$38(a0)
                move.l  #S3Rhinobot_FlipPatrolFacing,$34(a0)
                neg.w   $40(a0)
                neg.w   $3E(a0)
                rts
; ---------------------------------------------------------------------------

S3Rhinobot_FlipPatrolFacing:
                bchg    #3,$38(a0)
                bchg    #0,render_flags(a0)
                bclr    #1,$38(a0)
                move.l  #S3Rhinobot_ReversePatrolAccel,$34(a0)
                rts
; ---------------------------------------------------------------------------

S3Rhinobot_SetTurnaroundPhase:
                bclr    #2,$38(a0)
                btst    #3,$38(a0)
                bne.s   S3Rhinobot_StopAndTurnAround
                bset    #2,$38(a0)

S3Rhinobot_StopAndTurnAround:
                clr.w   x_vel(a0)
                clr.w   y_vel(a0)
                bra.s   S3Rhinobot_FlipPatrolFacing
; ---------------------------------------------------------------------------

; Load $20 into the wait counter. The callback runs after the counter underflows
S3Rhinobot_BeginChargeWindup:
                move.b  #4,routine(a0)
                move.b  #0,mapping_frame(a0)
                move.w  #$20,$2E(a0)
                move.l  #S3Rhinobot_PickChargeVelocity,$34(a0)
                bset    #1,$38(a0)
                moveq   #signextendB(sfx_Blast),d0
                jsr     (Play_SFX).l
                lea     S3Rhinobot_ChargeDustChildRecord(pc),a2
                jsr     CreateChild1_Normal(pc)
                bne.s   S3Rhinobot_ChargeWindupReturn
                move.l  #S3Rhinobot_ChargeDustAnim,$30(a1)

S3Rhinobot_ChargeWindupReturn:
                rts
; ---------------------------------------------------------------------------

S3Rhinobot_PickChargeVelocity:
                move.b  #6,routine(a0)
                move.w  #$400,d0
                btst    #3,$38(a0)
                bne.s   S3Rhinobot_StoreChargeVelocity
                neg.w   d0

S3Rhinobot_StoreChargeVelocity:
                move.w  d0,x_vel(a0)
                rts
; ---------------------------------------------------------------------------

S3Rhinobot_AbortChargeToPatrol:
                move.b  #2,routine(a0)
                move.b  #0,mapping_frame(a0)
                bra.w   S3Rhinobot_SetTurnaroundPhase

; =============== S U B R O U T I N E =======================================

DispatchRhinobotVelocityMilestone:
                move.w  x_vel(a0),d0
                beq.s   RhinobotS3_Milestone_TailCurrentCallback
                btst    #2,$38(a0)
                beq.s   S3Rhinobot_CheckLowerSpeedTarget
                cmp.w   $3E(a0),d0
                bge.s   RhinobotS3_Milestone_TailCurrentCallback
                rts
; ---------------------------------------------------------------------------

S3Rhinobot_CheckLowerSpeedTarget:
                cmp.w   $3E(a0),d0
                ble.s   RhinobotS3_Milestone_TailCurrentCallback
                rts
; ---------------------------------------------------------------------------

RhinobotS3_Milestone_TailCurrentCallback:
                movea.l $34(a0),a1
                jmp     (a1)
; End of function DispatchRhinobotVelocityMilestone

; ---------------------------------------------------------------------------

S3Rhinobot_PickPatrolFrame:
                moveq   #0,d1
                btst    #3,$38(a0)
                beq.s   S3Rhinobot_PickPatrolFrameLeft
                btst    #2,$38(a0)
                beq.s   S3Rhinobot_PickBrakeFrameRight
                cmpi.w  #$80,x_vel(a0)
                bgt.s   S3Rhinobot_StorePatrolFrame
                moveq   #1,d1
                bra.w   S3Rhinobot_StorePatrolFrame
; ---------------------------------------------------------------------------

S3Rhinobot_PickBrakeFrameRight:
                moveq   #1,d1
                cmpi.w  #$280,x_vel(a0)
                bgt.s   S3Rhinobot_StorePatrolFrame
                moveq   #2,d1
                bset    #1,$38(a0)
                beq.s   S3Rhinobot_StoreFrameAndTryDust
                bra.w   S3Rhinobot_StorePatrolFrame
; ---------------------------------------------------------------------------

S3Rhinobot_PickPatrolFrameLeft:
                btst    #2,$38(a0)
                bne.s   S3Rhinobot_PickBrakeFrameLeft
                cmpi.w  #-$80,x_vel(a0)
                ble.s   S3Rhinobot_StorePatrolFrame
                moveq   #1,d1
                bra.w   S3Rhinobot_StorePatrolFrame
; ---------------------------------------------------------------------------

S3Rhinobot_PickBrakeFrameLeft:
                moveq   #1,d1
                cmpi.w  #-$280,x_vel(a0)
                ble.s   S3Rhinobot_StorePatrolFrame
                moveq   #2,d1
                bset    #1,$38(a0)
                beq.s   S3Rhinobot_StoreFrameAndTryDust

S3Rhinobot_StorePatrolFrame:
                move.b  d1,mapping_frame(a0)
                rts
; ---------------------------------------------------------------------------

S3Rhinobot_StoreFrameAndTryDust:
                move.b  d1,mapping_frame(a0)
                moveq   #signextendB(sfx_Blast),d0
                jsr     (Play_SFX).l
                lea     S3Rhinobot_PatrolDustChildRecord(pc),a2
                jsr     CreateChild1_Normal(pc)
                bne.s   S3Rhinobot_PatrolDustReturn
                move.l  #S3Rhinobot_PatrolDustAnim,$30(a1)

S3Rhinobot_PatrolDustReturn:
                rts

; =============== S U B R O U T I N E =======================================

TriggerRhinobotChargeForPlayerAhead:
                jsr     Find_SonicTails(pc)
                cmpi.w  #$20,d3
                bhi.s   S3Rhinobot_ChargeTriggerReturn
                cmpi.w  #$60,d2
                bhi.s   S3Rhinobot_ChargeTriggerReturn
                btst    #3,$38(a0)
                bne.s   S3Rhinobot_CheckNearestPlayerSide
                subq.w  #2,d0

S3Rhinobot_CheckNearestPlayerSide:
                tst.w   d0
                bne.s   S3Rhinobot_EnterChargeAndSkipPatrol

S3Rhinobot_ChargeTriggerReturn:
                rts
; ---------------------------------------------------------------------------

; Discard the caller's return address after the setup callback
S3Rhinobot_EnterChargeAndSkipPatrol:
                jsr     (a3)
                addq.w  #4,sp
                rts
; End of function TriggerRhinobotChargeForPlayerAhead

; =============== S U B R O U T I N E =======================================

FollowRhinobotFloorOrAbortState:
                moveq   #4,d0
                btst    #3,$38(a0)
                bne.s   S3Rhinobot_ProbeFloorAhead
                neg.w   d0

S3Rhinobot_ProbeFloorAhead:
                move.w  x_pos(a0),d3
                add.w   d0,d3
                move.l  a3,-(sp)
                jsr     (ObjCheckFloorDist2).l
                movea.l (sp)+,a3
                cmpi.w  #-1,d1
                blt.s   S3Rhinobot_AbortAndSkipStateTail
                cmpi.w  #$C,d1
                bge.s   S3Rhinobot_AbortAndSkipStateTail
                add.w   d1,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

; Discard the caller's return address after the floor-abort callback
S3Rhinobot_AbortAndSkipStateTail:
                jsr     (a3)
                addq.w  #4,sp
                rts
; End of function FollowRhinobotFloorOrAbortState

; ---------------------------------------------------------------------------
ObjSlot_Rhinobot:
                dc.w    2-1
                dc.w    make_art_tile(ArtTile_Rhinobot,1,0)
                dc.w    $15,     0
                dc.l    Map_Rhinobot
                dc.w    $280
                dc.b    $14, $10,   0,  $B
RhinobotS3_Dust_SlottedAttributeRecord:
                dc.w    2-1
                dc.w    make_art_tile(ArtTile_Rhinobot-$B6,0,0)
                dc.w    6,     2
                dc.l    Map_Rhinobot
                dc.w    $200
                dc.b    $C,   8,   4,   0
S3Rhinobot_PatrolDustChildRecord:
                dc.w    1-1
                dc.l    S3Rhinobot_UpdateDust
                dc.b    $C,   8
S3Rhinobot_ChargeDustChildRecord:
                dc.w    1-1
                dc.l    S3Rhinobot_UpdateDust
                dc.b    $10,   8
DPLCPtr_AIZRhinobot:
                dc.l    ArtUnc_AIZRhinobot
                dc.l    DPLC_Rhinobot
S3Rhinobot_PatrolDustAnim:
                dc.b    2,   4,   4,   5,   6,   7,   4,   5,   6,   7,   4,   5,   6,   7, $F4
                even
S3Rhinobot_ChargeDustAnim:
                dc.b    2,   4,   4,   5,   6,   7,   4,   5,   6,   7, $F4
                even
