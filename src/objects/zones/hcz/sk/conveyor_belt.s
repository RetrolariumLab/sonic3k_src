; Owner: objects/zones/hcz/sk
; Responsibility: Hydrocity conveyor belt player transport and coordinated conveyor spike motion
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------
SKConveyorBelt_ExtentsBySubtype:
                dc.w    $B28,  $CD8
                dc.w    $BA8,  $CD8
                dc.w    $BA8,  $CD8
                dc.w    $EA8, $1058
                dc.w    $11A8, $12D8
                dc.w    $1928, $19D8
                dc.w    $21A8, $2358
                dc.w    $21A8, $2358
                dc.w    $22A8, $2458
                dc.w    $23A8, $2558
                dc.w    $2528, $26D8
                dc.w    $26A8, $27D8
                dc.w    $26A8, $2958
                dc.w    $2728, $28D8
                dc.w    $3328, $3458
                dc.w    $3328, $33D8
; ---------------------------------------------------------------------------

Obj_HCZConveyorBelt:
                lea     (Conveyor_belt_load_array).w,a1
                moveq   #0,d0
                move.b  subtype(a0),d0
                tst.b   (a1,d0.w)
                beq.s   SKConveyorBelt_ClaimLoadSlotAndSetLeft
                move.w  respawn_addr(a0),d0
                beq.s   SKConveyorBelt_DeleteDuplicateController
                movea.w d0,a2
                bclr    #7,(a2)

SKConveyorBelt_DeleteDuplicateController:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

SKConveyorBelt_ClaimLoadSlotAndSetLeft:
                move.b  #1,(a1,d0.w)
                andi.w  #$F,d0
                lsl.w   #2,d0
                lea     SKConveyorBelt_ExtentsBySubtype(pc,d0.w),a1
                move.w  (a1)+,d0
                move.w  d0,$3C(a0)
                btst    #0,status(a0)
                bne.s   SKConveyorBelt_SetCaptureLeftAndRight
                subq.w  #8,d0

SKConveyorBelt_SetCaptureLeftAndRight:
                move.w  d0,$40(a0)
                move.w  (a1)+,d0
                move.w  d0,$3E(a0)
                btst    #0,status(a0)
                beq.s   SKConveyorBelt_StartInvisibleController
                addq.w  #8,d0

SKConveyorBelt_StartInvisibleController:
                move.w  d0,$42(a0)
                move.l  #SKConveyorBelt_UpdateRidersAndCull,(a0)

SKConveyorBelt_UpdateRidersAndCull:
                lea     $32(a0),a2
                lea     (Player_1).w,a1
                move.w  (Ctrl_1_logical).w,d1
                moveq   #0,d2
                bsr.s   UpdatePlayerOnHczConveyorBelt
                addq.w  #1,a2
                lea     (Player_2).w,a1
                move.w  (Ctrl_2_logical).w,d1
                moveq   #1,d2
                bsr.s   UpdatePlayerOnHczConveyorBelt
                move.w  (Camera_X_pos_coarse_back).w,d1
                move.w  $3C(a0),d0
                andi.w  #$FF80,d0
                subi.w  #$280,d0
                cmp.w   d0,d1
                blo.s   SKConveyorBelt_ClearLoadSlotAndRespawn
                move.w  $3E(a0),d0
                andi.w  #$FF80,d0
                cmp.w   d0,d1
                bhi.s   SKConveyorBelt_ClearLoadSlotAndRespawn
                rts
; ---------------------------------------------------------------------------

SKConveyorBelt_ClearLoadSlotAndRespawn:
                lea     (Conveyor_belt_load_array).w,a1
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.b  #0,(a1,d0.w)
                move.w  respawn_addr(a0),d0
                beq.s   SKConveyorBelt_DeleteController
                movea.w d0,a2
                bclr    #7,(a2)

SKConveyorBelt_DeleteController:
                jmp     (Delete_Current_Sprite).l

; =============== S U B R O U T I N E =======================================

UpdatePlayerOnHczConveyorBelt:
                tst.b   (a2)
                beq.w   SKConveyorBelt_TickRegrabDelay
                tst.w   (Debug_placement_mode).w
                bne.w   SKConveyorBelt_DetachAndSetRegrabDelay
                cmpi.b  #4,routine(a1)
                bhs.w   SKConveyorBelt_DetachAndSetRegrabDelay
                btst    #button_left+8,d1
                beq.s   SKConveyorBelt_TryWalkRight
                subq.w  #1,x_pos(a1)
                subq.b  #1,6(a2)
                bpl.s   SKConveyorBelt_TryWalkRight
                move.b  #7,6(a2)
                addi.b  #$10,8(a2)
                andi.b  #$10,8(a2)

SKConveyorBelt_TryWalkRight:
                btst    #button_right+8,d1
                beq.s   SKConveyorBelt_PickJumpOrBeltDrift
                addq.w  #1,x_pos(a1)
                subq.b  #1,6(a2)
                bpl.s   SKConveyorBelt_PickJumpOrBeltDrift
                move.b  #7,6(a2)
                addi.b  #$10,8(a2)
                andi.b  #$10,8(a2)

SKConveyorBelt_PickJumpOrBeltDrift:
                andi.w  #button_A_mask|button_B_mask|button_C_mask,d1
                bne.w   SKConveyorBelt_PickReleaseJumpSpeed
                moveq   #2,d0
                btst    #0,status(a0)
                beq.s   SKConveyorBelt_MoveAndPoseRider
                neg.w   d0

SKConveyorBelt_MoveAndPoseRider:
                add.w   d0,x_pos(a1)
                move.w  x_pos(a1),d0
                cmp.w   $40(a0),d0
                blo.s   SKConveyorBelt_DetachAndSetRegrabDelay
                cmp.w   $42(a0),d0
                bhs.s   SKConveyorBelt_DetachAndSetRegrabDelay
                bsr.w   PositionPlayerAroundHczConveyor
                moveq   #0,d0
                move.b  mapping_frame(a1),d0
                move.l  a2,-(sp)
                jsr     (Perform_Player_DPLC).l
                movea.l (sp)+,a2
                rts
; ---------------------------------------------------------------------------

SKConveyorBelt_PickReleaseJumpSpeed:
                move.w  #-$500,y_vel(a1)
                btst    #Status_Underwater,status(a1)
                beq.s   SKConveyorBelt_DetachAndSetRegrabDelay
                move.w  #-$200,y_vel(a1)

; Use 90 updates underwater and 60 otherwise
SKConveyorBelt_DetachAndSetRegrabDelay:
                clr.b   (a2)
                move.b  #60,2(a2)
                btst    #Status_Underwater,status(a1)
                beq.s   SKConveyorBelt_SetDetachedJumpState
                move.b  #90,2(a2)

SKConveyorBelt_SetDetachedJumpState:
                andi.b  #$FC,object_control(a1)
                bset    #Status_InAir,status(a1)
                move.b  #1,jumping(a1)
                move.b  #$E,y_radius(a1)
                move.b  #7,x_radius(a1)
                move.b  #2,anim(a1)
                bset    #Status_Roll,status(a1)
                bclr    #Status_RollJump,status(a1)
                move.b  #0,flip_angle(a1)
                rts
; ---------------------------------------------------------------------------

SKConveyorBelt_TickRegrabDelay:
                tst.b   2(a2)
                beq.s   SKConveyorBelt_CheckXAndPickEntry
                subq.b  #1,2(a2)
                rts
; ---------------------------------------------------------------------------

SKConveyorBelt_CheckXAndPickEntry:
                move.w  x_pos(a1),d0
                cmp.w   $40(a0),d0
                blo.w   SKConveyorBelt_CaptureReturn
                cmp.w   $42(a0),d0
                bhs.w   SKConveyorBelt_CaptureReturn
                cmpi.w  #1,ground_vel(a1)
                beq.w   SKConveyorBelt_TryCaptureFromAbove
                move.w  y_pos(a0),d0
                addi.w  #$14,d0
                cmp.w   y_pos(a1),d0
                bhs.s   SKConveyorBelt_CaptureReturn
                addi.w  #$10,d0
                cmp.w   y_pos(a1),d0
                blo.s   SKConveyorBelt_CaptureReturn
                tst.w   (Debug_placement_mode).w
                bne.s   SKConveyorBelt_CaptureReturn
                cmpi.b  #4,routine(a1)
                bhs.s   SKConveyorBelt_CaptureReturn
                tst.b   object_control(a1)
                bne.s   SKConveyorBelt_CaptureReturn
                tst.w   y_vel(a1)
                bmi.s   SKConveyorBelt_CaptureReturn
                clr.w   x_vel(a1)
                clr.w   y_vel(a1)
                clr.w   ground_vel(a1)
                andi.b  #$FC,render_flags(a1)
                move.w  y_pos(a0),d0
                addi.w  #$14,d0
                move.w  d0,y_pos(a1)
                move.b  #0,anim(a1)
                move.b  #3,object_control(a1)
                move.b  #$63,mapping_frame(a1)
                move.b  #0,4(a2)
                move.b  #0,6(a2)
                move.b  #0,8(a2)
                move.b  #1,(a2)
                moveq   #0,d0
                move.b  mapping_frame(a1),d0
                move.l  a2,-(sp)
                jsr     (Perform_Player_DPLC).l
                movea.l (sp)+,a2

SKConveyorBelt_CaptureReturn:
                rts
; ---------------------------------------------------------------------------

; The caller selects this path for a ground velocity word of exactly 1
SKConveyorBelt_TryCaptureFromAbove:
                move.w  y_pos(a0),d0
                subi.w  #$14,d0
                cmp.w   y_pos(a1),d0
                bhs.s   SKConveyorBelt_CaptureReturn
                addi.w  #$10,d0
                cmp.w   y_pos(a1),d0
                blo.s   SKConveyorBelt_CaptureReturn
                tst.w   (Debug_placement_mode).w
                bne.s   SKConveyorBelt_CaptureReturn
                cmpi.b  #4,routine(a1)
                bhs.s   SKConveyorBelt_CaptureReturn
                tst.b   object_control(a1)
                bne.s   SKConveyorBelt_CaptureReturn
                clr.w   x_vel(a1)
                clr.w   y_vel(a1)
                clr.w   ground_vel(a1)
                andi.b  #$FC,render_flags(a1)
                move.w  y_pos(a0),d0
                subi.w  #$14,d0
                move.w  d0,y_pos(a1)
                move.b  #0,anim(a1)
                move.b  #3,object_control(a1)
                move.b  #$65,mapping_frame(a1)
                move.b  #$80,4(a2)
                move.b  #0,6(a2)
                move.b  #0,8(a2)
                move.b  #1,(a2)
                moveq   #0,d0
                move.b  mapping_frame(a1),d0
                move.l  a2,-(sp)
                jsr     (Perform_Player_DPLC).l
                movea.l (sp)+,a2
                rts
; End of function UpdatePlayerOnHczConveyorBelt

; =============== S U B R O U T I N E =======================================

PositionPlayerAroundHczConveyor:
                tst.w   ground_vel(a1)
                bne.s   SKConveyorBelt_StepTowardHalfTurn
                move.b  4(a2),d0
                beq.s   SKConveyorBelt_JoinPoseAtZeroTarget
                bpl.s   SKConveyorBelt_StepPhaseDownToZero
                addi.b  #6,d0
                bcc.s   SKConveyorBelt_JoinZeroPhaseStore
                moveq   #0,d0

SKConveyorBelt_JoinZeroPhaseStore:
                bra.s   SKConveyorBelt_StorePhaseTowardZero
; ---------------------------------------------------------------------------

SKConveyorBelt_StepPhaseDownToZero:
                subi.b  #6,d0
                bcc.s   SKConveyorBelt_StorePhaseTowardZero
                moveq   #0,d0

SKConveyorBelt_StorePhaseTowardZero:
                move.b  d0,4(a2)

SKConveyorBelt_JoinPoseAtZeroTarget:
                bra.s   SKConveyorBelt_PickRiderFrameAndY
; ---------------------------------------------------------------------------

SKConveyorBelt_StepTowardHalfTurn:
                clr.w   ground_vel(a1)
                move.b  4(a2),d0
                subi.b  #$80,d0
                beq.s   SKConveyorBelt_PickRiderFrameAndY
                bpl.s   SKConveyorBelt_StepHalfTurnResidualDown
                addi.b  #6,d0
                bcc.s   SKConveyorBelt_JoinHalfTurnStore
                moveq   #0,d0

SKConveyorBelt_JoinHalfTurnStore:
                bra.s   SKConveyorBelt_StorePhaseTowardHalfTurn
; ---------------------------------------------------------------------------

SKConveyorBelt_StepHalfTurnResidualDown:
                subi.b  #6,d0
                bcc.s   SKConveyorBelt_StorePhaseTowardHalfTurn
                moveq   #0,d0

SKConveyorBelt_StorePhaseTowardHalfTurn:
                addi.b  #$80,d0
                move.b  d0,4(a2)

SKConveyorBelt_PickRiderFrameAndY:
                moveq   #0,d0
                move.b  4(a2),d0
                lsr.b   #4,d0
                add.b   8(a2),d0
                move.b  SKConveyorBelt_RiderFrameBanks(pc,d0.w),d1
                move.b  d1,mapping_frame(a1)
                andi.w  #$F,d0
                move.b  SKConveyorBelt_RiderOffsetsByPhase(pc,d0.w),d1
                ext.w   d1
                add.w   y_pos(a0),d1
                move.w  d1,y_pos(a1)
                rts
; End of function PositionPlayerAroundHczConveyor

; ---------------------------------------------------------------------------
SKConveyorBelt_RiderFrameBanks:
                dc.b    $94, $63, $64, $64, $65, $65, $65, $66, $66, $66, $66, $67, $67, $67, $68, $68, $95, $63, $64, $64
                dc.b    $65, $65, $65, $66, $66, $66, $66, $67, $67, $67, $68, $68
SKConveyorBelt_RiderOffsetsByPhase:
                dc.b    $14, $14,  $B,  $B, -$F, -$F, -$F,-$14,-$14,-$14,-$14, -$C, -$C, -$C,  -2,  -2
; ---------------------------------------------------------------------------

Obj_HCZConveryorSpike:
                moveq   #0,d0
                move.b  subtype(a0),d0
                andi.w  #$F,d0
                lsl.w   #2,d0
                lea     SKConveyorBelt_ExtentsBySubtype(pc),a1
                lea     (a1,d0.w),a1
                move.w  (a1)+,$3C(a0)
                move.w  (a1)+,$3E(a0)
                move.l  #Map_HCZConveyorSpike,mappings(a0)
                move.w  #make_art_tile(ArtTile_HCZSpikeBall,1,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.w  #$280,priority(a0)
                move.b  #$C,width_pixels(a0)
                move.b  #$C,height_pixels(a0)
                move.b  #$8B,collision_flags(a0)
                move.w  x_pos(a0),$30(a0)
                move.w  y_pos(a0),$32(a0)
                btst    #0,status(a0)
                beq.s   SKConveyorBelt_StartSpikeUpperRun
                addi.w  #$18,y_pos(a0)
                move.l  #SKConveyorBelt_StepSpikeLeft,(a0)
                bra.w   SKConveyorBelt_StepSpikeLeft
; ---------------------------------------------------------------------------

SKConveyorBelt_StartSpikeUpperRun:
                subi.w  #$18,y_pos(a0)
                move.w  #$40,angle(a0)
                move.l  #SKConveyorBelt_StepSpikeRight,(a0)

SKConveyorBelt_StepSpikeRight:
                addq.w  #2,x_pos(a0)
                move.w  x_pos(a0),d0
                cmp.w   $3E(a0),d0
                bne.s   SKConveyorBelt_JoinSpikeDrawFromRight
                move.l  #SKConveyorBelt_StepSpikeRightTurn,(a0)
                move.w  x_pos(a0),$30(a0)

SKConveyorBelt_JoinSpikeDrawFromRight:
                bra.w   SKConveyorBelt_CullOrDrawSpike
; ---------------------------------------------------------------------------

SKConveyorBelt_StepSpikeRightTurn:
                subq.w  #2,angle(a0)
                andi.w  #$7E,angle(a0)
                move.w  angle(a0),d0
                bne.s   SKConveyorBelt_PlaceSpikeOnRightArc
                move.l  #SKConveyorBelt_StepSpikeLeft,(a0)

SKConveyorBelt_PlaceSpikeOnRightArc:
                lea     SKConveyorBelt_SpikeArcCoordinates(pc),a1
                move.w  (a1,d0.w),d1
                move.w  $20(a1,d0.w),d2
                add.w   $30(a0),d1
                add.w   $32(a0),d2
                move.w  d1,x_pos(a0)
                move.w  d2,y_pos(a0)
                bra.s   SKConveyorBelt_CullOrDrawSpike
; ---------------------------------------------------------------------------

SKConveyorBelt_StepSpikeLeft:
                subq.w  #2,x_pos(a0)
                move.w  x_pos(a0),d0
                cmp.w   $3C(a0),d0
                bne.s   SKConveyorBelt_JoinSpikeDrawFromLeft
                move.l  #SKConveyorBelt_StepSpikeLeftTurn,(a0)
                move.w  x_pos(a0),$30(a0)

SKConveyorBelt_JoinSpikeDrawFromLeft:
                bra.s   SKConveyorBelt_CullOrDrawSpike
; ---------------------------------------------------------------------------

SKConveyorBelt_StepSpikeLeftTurn:
                subq.w  #2,angle(a0)
                andi.w  #$7E,angle(a0)
                move.w  angle(a0),d0
                cmpi.w  #$40,angle(a0)
                bne.s   SKConveyorBelt_PlaceSpikeOnLeftArc
                move.l  #SKConveyorBelt_StepSpikeRight,(a0)

SKConveyorBelt_PlaceSpikeOnLeftArc:
                lea     SKConveyorBelt_SpikeArcCoordinates(pc),a1
                move.w  (a1,d0.w),d1
                move.w  2*$10(a1,d0.w),d2
                add.w   $30(a0),d1
                add.w   $32(a0),d2
                move.w  d1,x_pos(a0)
                move.w  d2,y_pos(a0)

SKConveyorBelt_CullOrDrawSpike:
                move.w  (Camera_X_pos_coarse_back).w,d1
                move.w  $3C(a0),d0
                andi.w  #$FF80,d0
                subi.w  #$280,d0
                cmp.w   d0,d1
                blo.s   SKConveyorBelt_ClearSpikeRespawn
                move.w  $3E(a0),d0
                andi.w  #$FF80,d0
                cmp.w   d0,d1
                bhi.s   SKConveyorBelt_ClearSpikeRespawn
                jsr     (Add_SpriteToCollisionResponseList).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKConveyorBelt_ClearSpikeRespawn:
                move.w  respawn_addr(a0),d0
                beq.s   SKConveyorBelt_DeleteSpike
                movea.w d0,a2
                bclr    #7,(a2)

SKConveyorBelt_DeleteSpike:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------
; The X and Y lookups share this table with a $20-byte displacement
SKConveyorBelt_SpikeArcCoordinates:
                dc.w    0,     2,     4,     6,     9,    $B,    $D,    $F,   $10,   $12,   $13,   $15,   $16,   $16,   $17,   $17
                dc.w    $18,   $17,   $17,   $16,   $16,   $15,   $13,   $12,   $10,    $F,    $D,    $B,     9,     6,     4,     2
                dc.w    0,    -3,    -5,    -7,   -$A,   -$C,   -$E,  -$10,  -$11,  -$13,  -$14,  -$16,  -$17,  -$17,  -$18,  -$18
                dc.w    -$18,  -$18,  -$18,  -$17,  -$17,  -$16,  -$14,  -$13,  -$11,  -$10,   -$E,   -$C,   -$A,    -7,    -5,    -3
                dc.w    0,     2,     4,     6,     9,    $B,    $D,    $F,   $10,   $12,   $13,   $15,   $16,   $16,   $17,   $17
