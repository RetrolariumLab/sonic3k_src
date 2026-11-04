; Owner: objects/enemies/aiz/sk
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
                dc.w    SKRhinobot_InitArtAndPatrol-Rhinobot_Index
                dc.w    SKRhinobot_RunPatrol-Rhinobot_Index
                dc.w    RhinobotSK_Charge_CountPreparationWait-Rhinobot_Index
                dc.w    SKRhinobot_RunCharge-Rhinobot_Index
; ---------------------------------------------------------------------------

SKRhinobot_InitArtAndPatrol:
                lea     ObjSlot_Rhinobot(pc),a1
                jsr     SetUp_ObjAttributesSlotted(pc)
                move.b  #8,x_radius(a0)
                move.b  #$10,y_radius(a0)
                move.w  #-$10,d0
                move.w  #-$300,d1
                btst    #0,render_flags(a0)
                beq.s   SKRhinobot_SetPatrolSpeedAndCallback
                neg.w   d0
                neg.w   d1
                bset    #3,$38(a0)
                bset    #2,$38(a0)

SKRhinobot_SetPatrolSpeedAndCallback:
                move.w  d0,$40(a0)
                move.w  d1,$3E(a0)
                move.l  #SKRhinobot_ReversePatrolAccel,$34(a0)
                rts
; ---------------------------------------------------------------------------

SKRhinobot_RunPatrol:
                lea     SKRhinobot_BeginChargeWindup(pc),a3
                bsr.w   TriggerRhinobotChargeForPlayerAhead
                lea     SKRhinobot_SetTurnaroundPhase(pc),a3
                bsr.w   FollowRhinobotFloorOrAbortState
                move.w  $40(a0),d0
                add.w   d0,x_vel(a0)
                jsr     (MoveSprite2).l
                bsr.w   DispatchRhinobotVelocityMilestone
                bra.w   SKRhinobot_PickPatrolFrame
; ---------------------------------------------------------------------------

RhinobotSK_Charge_CountPreparationWait:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

SKRhinobot_RunCharge:
                lea     SKRhinobot_AbortChargeToPatrol(pc),a3
                bsr.w   FollowRhinobotFloorOrAbortState
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

SKRhinobot_UpdateDust:
                cmpi.w  #1,(Current_zone_and_act).w
                beq.s   SKRhinobot_DeleteDustInAct2
                jsr     Refresh_ChildPositionAdjusted(pc)
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  RhinobotSK_Dust_TwoRelativeStateOffsets(pc,d0.w),d1
                jsr     RhinobotSK_Dust_TwoRelativeStateOffsets(pc,d1.w)
                lea     DPLCPtr_AIZRhinobot(pc),a2
                jsr     Perform_DPLC(pc)
                jmp     Child_Remember_Draw_Sprite(pc)
; ---------------------------------------------------------------------------
RhinobotSK_Dust_TwoRelativeStateOffsets:
                dc.w    SKRhinobot_InitDustArtSlot-RhinobotSK_Dust_TwoRelativeStateOffsets
                dc.w    SKRhinobot_AnimateDust-RhinobotSK_Dust_TwoRelativeStateOffsets
; ---------------------------------------------------------------------------

SKRhinobot_DeleteDustInAct2:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

SKRhinobot_InitDustArtSlot:
                lea     RhinobotSK_Dust_SlottedAttributeRecord(pc),a1
                jsr     SetUp_ObjAttributesSlotted(pc)
                move.l  #Go_Delete_SpriteSlotted3,$34(a0)

SKRhinobot_AnimateDust:
                jmp     Animate_Raw(pc)
; ---------------------------------------------------------------------------

SKRhinobot_ReversePatrolAccel:
                bchg    #2,$38(a0)
                move.l  #SKRhinobot_FlipPatrolFacing,$34(a0)
                neg.w   $40(a0)
                neg.w   $3E(a0)
                rts
; ---------------------------------------------------------------------------

SKRhinobot_FlipPatrolFacing:
                bchg    #3,$38(a0)
                bchg    #0,render_flags(a0)
                bclr    #1,$38(a0)
                move.l  #SKRhinobot_ReversePatrolAccel,$34(a0)
                rts
; ---------------------------------------------------------------------------

SKRhinobot_SetTurnaroundPhase:
                bclr    #2,$38(a0)
                btst    #3,$38(a0)
                bne.s   SKRhinobot_StopAndTurnAround
                bset    #2,$38(a0)

SKRhinobot_StopAndTurnAround:
                clr.w   x_vel(a0)
                clr.w   y_vel(a0)
                bra.s   SKRhinobot_FlipPatrolFacing
; ---------------------------------------------------------------------------

; Load $20 into the wait counter. The callback runs after the counter underflows
SKRhinobot_BeginChargeWindup:
                move.b  #4,routine(a0)
                move.b  #0,mapping_frame(a0)
                move.w  #$20,$2E(a0)
                move.l  #SKRhinobot_PickChargeVelocity,$34(a0)
                bset    #1,$38(a0)
                moveq   #signextendB(sfx_Blast),d0
                jsr     (Play_SFX).l
                lea     SKRhinobot_ChargeDustChildRecord(pc),a2
                jsr     CreateChild1_Normal(pc)
                bne.s   SKRhinobot_ChargeWindupReturn
                move.l  #SKRhinobot_ChargeDustAnim,$30(a1)

SKRhinobot_ChargeWindupReturn:
                rts
; ---------------------------------------------------------------------------

SKRhinobot_PickChargeVelocity:
                move.b  #6,routine(a0)
                move.w  #$400,d0
                btst    #3,$38(a0)
                bne.s   SKRhinobot_StoreChargeVelocity
                neg.w   d0

SKRhinobot_StoreChargeVelocity:
                move.w  d0,x_vel(a0)
                rts
; ---------------------------------------------------------------------------

SKRhinobot_AbortChargeToPatrol:
                move.b  #2,routine(a0)
                move.b  #0,mapping_frame(a0)
                bra.w   SKRhinobot_SetTurnaroundPhase

; =============== S U B R O U T I N E =======================================

DispatchRhinobotVelocityMilestone:
                move.w  x_vel(a0),d0
                beq.s   RhinobotSK_Milestone_TailCurrentCallback
                btst    #2,$38(a0)
                beq.s   SKRhinobot_CheckLowerSpeedTarget
                cmp.w   $3E(a0),d0
                bge.s   RhinobotSK_Milestone_TailCurrentCallback
                rts
; ---------------------------------------------------------------------------

SKRhinobot_CheckLowerSpeedTarget:
                cmp.w   $3E(a0),d0
                ble.s   RhinobotSK_Milestone_TailCurrentCallback
                rts
; ---------------------------------------------------------------------------

RhinobotSK_Milestone_TailCurrentCallback:
                movea.l $34(a0),a1
                jmp     (a1)
; End of function DispatchRhinobotVelocityMilestone

; ---------------------------------------------------------------------------

SKRhinobot_PickPatrolFrame:
                moveq   #0,d1
                btst    #3,$38(a0)
                beq.s   SKRhinobot_PickPatrolFrameLeft
                btst    #2,$38(a0)
                beq.s   SKRhinobot_PickBrakeFrameRight
                cmpi.w  #$80,x_vel(a0)
                bgt.s   SKRhinobot_StorePatrolFrame
                moveq   #1,d1
                bra.w   SKRhinobot_StorePatrolFrame
; ---------------------------------------------------------------------------

SKRhinobot_PickBrakeFrameRight:
                moveq   #1,d1
                cmpi.w  #$280,x_vel(a0)
                bgt.s   SKRhinobot_StorePatrolFrame
                moveq   #2,d1
                bset    #1,$38(a0)
                beq.s   SKRhinobot_StoreFrameAndTryDust
                bra.w   SKRhinobot_StorePatrolFrame
; ---------------------------------------------------------------------------

SKRhinobot_PickPatrolFrameLeft:
                btst    #2,$38(a0)
                bne.s   SKRhinobot_PickBrakeFrameLeft
                cmpi.w  #-$80,x_vel(a0)
                ble.s   SKRhinobot_StorePatrolFrame
                moveq   #1,d1
                bra.w   SKRhinobot_StorePatrolFrame
; ---------------------------------------------------------------------------

SKRhinobot_PickBrakeFrameLeft:
                moveq   #1,d1
                cmpi.w  #-$280,x_vel(a0)
                ble.s   SKRhinobot_StorePatrolFrame
                moveq   #2,d1
                bset    #1,$38(a0)
                beq.s   SKRhinobot_StoreFrameAndTryDust

SKRhinobot_StorePatrolFrame:
                move.b  d1,mapping_frame(a0)
                rts
; ---------------------------------------------------------------------------

SKRhinobot_StoreFrameAndTryDust:
                move.b  d1,mapping_frame(a0)
                moveq   #signextendB(sfx_Blast),d0
                jsr     (Play_SFX).l
                lea     SKRhinobot_PatrolDustChildRecord(pc),a2
                jsr     CreateChild1_Normal(pc)
                bne.s   SKRhinobot_PatrolDustReturn
                move.l  #SKRhinobot_PatrolDustAnim,$30(a1)

SKRhinobot_PatrolDustReturn:
                rts

; =============== S U B R O U T I N E =======================================

TriggerRhinobotChargeForPlayerAhead:
                jsr     Find_SonicTails(pc)
                cmpi.w  #$20,d3
                bhi.s   SKRhinobot_ChargeTriggerReturn
                cmpi.w  #$60,d2
                bhi.s   SKRhinobot_ChargeTriggerReturn
                btst    #3,$38(a0)
                bne.s   SKRhinobot_CheckNearestPlayerSide
                subq.w  #2,d0

SKRhinobot_CheckNearestPlayerSide:
                tst.w   d0
                bne.s   SKRhinobot_EnterChargeAndSkipPatrol

SKRhinobot_ChargeTriggerReturn:
                rts
; ---------------------------------------------------------------------------

; Discard the caller's return address after the setup callback
SKRhinobot_EnterChargeAndSkipPatrol:
                jsr     (a3)
                addq.w  #4,sp
                rts
; End of function TriggerRhinobotChargeForPlayerAhead

; =============== S U B R O U T I N E =======================================

FollowRhinobotFloorOrAbortState:
                moveq   #4,d0
                btst    #3,$38(a0)
                bne.s   SKRhinobot_ProbeFloorAhead
                neg.w   d0

SKRhinobot_ProbeFloorAhead:
                move.w  x_pos(a0),d3
                add.w   d0,d3
                move.l  a3,-(sp)
                jsr     (ObjCheckFloorDist2).l
                movea.l (sp)+,a3
                cmpi.w  #-1,d1
                blt.s   SKRhinobot_AbortAndSkipStateTail
                cmpi.w  #$C,d1
                bge.s   SKRhinobot_AbortAndSkipStateTail
                add.w   d1,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

; Discard the caller's return address after the floor-abort callback
SKRhinobot_AbortAndSkipStateTail:
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
RhinobotSK_Dust_SlottedAttributeRecord:
                dc.w    2-1
                dc.w    make_art_tile(ArtTile_Rhinobot-$B6,0,0)
                dc.w    6,     2
                dc.l    Map_Rhinobot
                dc.w    $200
                dc.b    $C,   8,   4,   0
SKRhinobot_PatrolDustChildRecord:
                dc.w    1-1
                dc.l    SKRhinobot_UpdateDust
                dc.b    $C,   8
SKRhinobot_ChargeDustChildRecord:
                dc.w    1-1
                dc.l    SKRhinobot_UpdateDust
                dc.b    $10,   8
DPLCPtr_AIZRhinobot:
                dc.l    ArtUnc_AIZRhinobot
                dc.l    DPLC_Rhinobot
SKRhinobot_PatrolDustAnim:
                dc.b    2,   4,   4,   5,   6,   7,   4,   5,   6,   7,   4,   5,   6,   7, $F4
                even
SKRhinobot_ChargeDustAnim:
                dc.b    2,   4,   4,   5,   6,   7,   4,   5,   6,   7, $F4
                even
