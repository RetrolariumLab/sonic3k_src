; Owner: objects/zones/aiz/sk
; Responsibility: Normal Angel Island ride-vine motion, player contact, handle state and positioning helpers
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_AIZRideVine:
                movea.l a0,a1
                move.l  #SKRideVine_WaitForRider,(a1)
                bsr.w   InitializeAizRideVineSprite
                move.b  #$21,mapping_frame(a1)
                move.w  x_pos(a0),d2
                move.w  y_pos(a0),d3
                moveq   #0,d1
                move.b  subtype(a0),d1
                andi.w  #$7F,d1
                lsl.w   #4,d1
                add.w   d2,d1
                move.w  d1,$46(a0)
                moveq   #3,d1
                addq.w  #1,d1
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   SKRideVine_JoinHandleWait
                move.w  a1,$3E(a0)
                move.l  #SKRideVine_PickLeadOscillation,(a1)
                move.w  a0,$3C(a1)
                bra.s   SKRideVine_InitNextLink
; ---------------------------------------------------------------------------

SKRideVine_TryAllocateNextLink:
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   SKRideVine_JoinHandleWait
                move.l  #SKRideVine_UpdateLinkFromParent,(a1)
                move.w  a2,$3C(a1)
                move.w  a1,$3E(a2)

SKRideVine_InitNextLink:
                movea.l a1,a2
                bsr.s   InitializeAizRideVineSprite
                move.w  d2,x_pos(a1)
                move.w  d3,y_pos(a1)
                addi.w  #$10,d3
                addq.w  #1,$36(a0)
                move.w  $36(a0),$36(a1)
                dbf     d1,SKRideVine_TryAllocateNextLink
                move.l  #Obj_AIZRideVineHandle,(a1)
                move.b  #$20,mapping_frame(a1)
                move.w  a1,$40(a0)

SKRideVine_JoinHandleWait:
                bra.s   SKRideVine_WaitForRider

; =============== S U B R O U T I N E =======================================

InitializeAizRideVineSprite:
                move.b  #4,render_flags(a1)
                move.b  #8,width_pixels(a1)
                move.b  #8,height_pixels(a1)
                move.w  #$200,priority(a1)
                move.l  #Map_AIZMHZRideVine,mappings(a1)
                move.w  #make_art_tile(ArtTile_AIZSwingVine,0,0),art_tile(a1)
                rts
; End of function InitializeAizRideVineSprite

; ---------------------------------------------------------------------------

SKRideVine_WaitForRider:
                movea.w $40(a0),a1
                tst.w   $32(a1)
                beq.s   SKRideVine_DrawAfterHandleWait
                move.l  #SKRideVine_MoveToEndpoint,(a0)
                movea.w $3E(a0),a1
                move.w  #1,$2E(a1)
                move.w  #0,$38(a1)

SKRideVine_DrawAfterHandleWait:
                bra.w   SKRideVine_CullChainOrDrawRoot
; ---------------------------------------------------------------------------

SKRideVine_MoveToEndpoint:
                addi.l  #$80000,x_pos(a0)
                addi.l  #$20000,y_pos(a0)
                move.w  x_pos(a0),d0
                cmp.w   $46(a0),d0
                blo.w   SKRideVine_DrawAfterTravel
                tst.b   subtype(a0)
                bpl.s   SKRideVine_StartSwingAndTangentRelease
                move.l  #SKRideVine_UpdateDroppedRoot,(a0)
                move.w  #$800,x_vel(a0)
                move.w  #$200,y_vel(a0)
                move.l  #Map_AnimatedStillSprites,mappings(a0)
                move.w  #make_art_tile(ArtTile_AIZMisc2,3,0),art_tile(a0)
                move.b  #8,width_pixels(a0)
                move.b  #$C,height_pixels(a0)
                move.b  #0,mapping_frame(a0)
                move.w  #1,anim(a0)
                movea.w $40(a0),a1
                lea     $32(a1),a2
                tst.b   (a2)
                beq.s   SKRideVine_TryForceReleaseP2
                move.b  #$81,(a2)

SKRideVine_TryForceReleaseP2:
                addq.w  #1,a2
                tst.b   (a2)
                beq.s   SKRideVine_DrawAfterDropSetup
                move.b  #$81,(a2)

SKRideVine_DrawAfterDropSetup:
                bra.s   SKRideVine_DrawAfterTravel
; ---------------------------------------------------------------------------

SKRideVine_StartSwingAndTangentRelease:
                move.l  #SKRideVine_UpdateOccupiedSwing,(a0)
                movea.w $3E(a0),a1
                move.l  #SKRideVine_PlaceRootDrivenLead,(a1)
                move.w  #0,$3A(a1)
                movea.w $40(a0),a1
                move.w  #1,$30(a1)
                move.w  #0,angle(a0)
                move.w  #$400,$3A(a0)

SKRideVine_DrawAfterTravel:
                bra.w   SKRideVine_CullChainOrDrawRoot
; ---------------------------------------------------------------------------

SKRideVine_UpdateDroppedRoot:
                jsr     (MoveSprite).l
                tst.b   render_flags(a0)
                bmi.s   SKRideVine_AnimateDroppedRoot
                move.w  #$7FF0,x_pos(a0)

SKRideVine_AnimateDroppedRoot:
                lea     (Ani_AnimatedStillSprites).l,a1
                jsr     (Animate_Sprite).l
                bra.w   SKRideVine_CullChainOrDrawRoot
; ---------------------------------------------------------------------------

SKRideVine_UpdateOccupiedSwing:
                movea.w $40(a0),a1
                move.w  $3A(a0),d0
                move.b  angle(a0),d1
                ext.w   d1
                bpl.s   SKRideVine_StepSwingAndCheckEmpty
                neg.w   d1

SKRideVine_StepSwingAndCheckEmpty:
                add.w   d1,d1
                sub.w   d1,d0
                sub.w   d0,angle(a0)
                tst.w   $32(a1)
                bne.s   SKRideVine_DrawAfterSwing
                move.b  angle(a0),d0
                addq.b  #8,d0
                cmpi.b  #$10,d0
                bhs.s   SKRideVine_DrawAfterSwing
                move.l  #SKRideVine_StepDampedSwing,(a0)
                move.w  #0,$42(a0)
                move.w  #-$300,$44(a0)
                move.w  #$1000,$38(a0)
                move.w  #0,$2E(a0)
                movea.w $40(a0),a1
                move.w  #2,$30(a1)

SKRideVine_DrawAfterSwing:
                bra.w   SKRideVine_CullChainOrDrawRoot
; ---------------------------------------------------------------------------

SKRideVine_StepDampedSwing:
                moveq   #0,d2
                move.b  $38(a0),d2
                move.w  $44(a0),d0
                move.w  #0,d1
                tst.w   $2E(a0)
                bne.s   SKRideVine_StepDampedSwingNegative
                add.w   d2,d0
                move.w  d0,$44(a0)
                add.w   d0,$42(a0)
                cmp.b   $42(a0),d1
                bgt.s   SKRideVine_ApplyDampedAngle
                asr.w   #4,d0
                sub.w   d0,$44(a0)
                move.w  #1,$2E(a0)
                cmpi.w  #$C00,$38(a0)
                beq.s   SKRideVine_RestoreIdleHandle
                subi.w  #$40,$38(a0)
                bra.s   SKRideVine_ApplyDampedAngle
; ---------------------------------------------------------------------------

SKRideVine_RestoreIdleHandle:
                move.l  #SKRideVine_StepIdleSwing,(a0)
                move.w  #0,$38(a0)
                movea.w $40(a0),a1
                move.w  #0,$30(a1)
                bra.s   SKRideVine_ApplyDampedAngle
; ---------------------------------------------------------------------------

SKRideVine_StepDampedSwingNegative:
                sub.w   d2,d0
                move.w  d0,$44(a0)
                add.w   d0,$42(a0)
                cmp.b   $42(a0),d1
                ble.s   SKRideVine_ApplyDampedAngle
                asr.w   #4,d0
                sub.w   d0,$44(a0)
                move.w  #0,$2E(a0)
                cmpi.w  #$C00,$38(a0)
                beq.s   SKRideVine_RestoreIdleHandle
                subi.w  #$40,$38(a0)

SKRideVine_ApplyDampedAngle:
                move.w  $42(a0),d0
                move.w  d0,angle(a0)
                asr.w   #3,d0
                move.w  d0,$3A(a0)
                movea.w $3E(a0),a1
                move.w  $3A(a0),$3A(a1)
                bra.w   SKRideVine_CullChainOrDrawRoot
; ---------------------------------------------------------------------------

SKRideVine_StepIdleSwing:
                move.b  $38(a0),d0
                addi.w  #$200,$38(a0)
                jsr     (GetSineCosine).l
                asl.w   #2,d0
                cmpi.w  #$400,d0
                bne.s   SKRideVine_ApplyIdleAngle
                move.w  #$3FF,d0

SKRideVine_ApplyIdleAngle:
                move.w  d0,angle(a0)
                move.w  d0,$3A(a0)
                movea.w $3E(a0),a1
                move.w  $3A(a0),$3A(a1)

SKRideVine_CullChainOrDrawRoot:
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   SKRideVine_BeginDeleteChain
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKRideVine_BeginDeleteChain:
                move.w  $36(a0),d2
                subq.w  #1,d2
                bcs.s   SKRideVine_ClearRootRespawn
                movea.w $3E(a0),a2

SKRideVine_DeleteLinkAndAdvance:
                movea.l a2,a1
                movea.w $3E(a1),a2
                jsr     (Delete_Referenced_Sprite).l
                dbf     d2,SKRideVine_DeleteLinkAndAdvance

SKRideVine_ClearRootRespawn:
                move.w  respawn_addr(a0),d0
                beq.s   SKRideVine_DeleteRoot
                movea.w d0,a2
                bclr    #7,(a2)

SKRideVine_DeleteRoot:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

SKRideVine_PickLeadOscillation:
                tst.w   $2E(a0)
                bne.s   SKRideVine_StepLeadTravelSine
                move.b  $38(a0),d0
                addi.w  #$200,$38(a0)
                jsr     (GetSineCosine).l
                asl.w   #2,d0
                cmpi.w  #$400,d0
                bne.s   SKRideVine_StoreLeadIdleStep
                move.w  #$3FF,d0

SKRideVine_StoreLeadIdleStep:
                move.w  d0,$3A(a0)
                bra.s   SKRideVine_PlaceOscillatingLead
; ---------------------------------------------------------------------------

SKRideVine_StepLeadTravelSine:
                move.b  $38(a0),d0
                addi.w  #$100,$38(a0)
                jsr     (GetSineCosine).l
                asl.w   #3,d0
                move.w  d0,$3A(a0)

SKRideVine_PlaceOscillatingLead:
                move.w  $3A(a0),d0
                move.w  d0,angle(a0)
                move.b  angle(a0),d0
                addq.b  #4,d0
                lsr.b   #3,d0
                move.b  d0,mapping_frame(a0)
                movea.w $3C(a0),a1
                move.w  x_pos(a1),x_pos(a0)
                move.w  y_pos(a1),y_pos(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKRideVine_PlaceRootDrivenLead:
                movea.w $3C(a0),a1
                move.w  angle(a1),angle(a0)
                move.b  angle(a0),d0
                addq.b  #4,d0
                lsr.b   #3,d0
                move.b  d0,mapping_frame(a0)
                movea.w $3C(a0),a1
                move.w  x_pos(a1),x_pos(a0)
                move.w  y_pos(a1),y_pos(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKRideVine_UpdateLinkFromParent:
                movea.w $3C(a0),a1
                move.w  $3A(a1),$3A(a0)
                move.w  angle(a1),d0
                add.w   $3A(a0),d0
                move.w  d0,angle(a0)
                move.b  angle(a0),d0
                addq.b  #4,d0
                lsr.b   #3,d0
                move.b  d0,mapping_frame(a0)
                bsr.w   PositionAizRideVineLink
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

PositionAizRideVineLink:
                movea.w $3C(a0),a1
                move.b  angle(a1),d0
                addq.b  #4,d0
                andi.b  #$F8,d0
                jsr     (GetSineCosine).l
                neg.w   d0
                addi.w  #8,d0
                addi.w  #8,d1
                asr.w   #4,d0
                asr.w   #4,d1
                add.w   x_pos(a1),d0
                move.w  d0,x_pos(a0)
                add.w   y_pos(a1),d1
                move.w  d1,y_pos(a0)
                rts
; End of function PositionAizRideVineLink

; ---------------------------------------------------------------------------

Obj_AIZRideVineHandle:
                move.w  x_pos(a0),d4
                move.w  y_pos(a0),d5
                bsr.w   PositionAizRideVineLink
                cmp.w   x_pos(a0),d4
                beq.s   SKRideVine_TryCacheOldHandleY
                move.w  d4,$42(a0)

SKRideVine_TryCacheOldHandleY:
                cmp.w   y_pos(a0),d5
                beq.s   SKRideVine_UpdateBothRiders
                move.w  d5,$44(a0)

SKRideVine_UpdateBothRiders:
                lea     $32(a0),a2
                lea     (Player_1).w,a1
                move.w  (Ctrl_1_logical).w,d0
                bsr.s   UpdatePlayerOnAizVineHandle
                lea     (Player_2).w,a1
                addq.w  #1,a2
                move.w  (Ctrl_2_logical).w,d0
                bsr.s   UpdatePlayerOnAizVineHandle
                tst.w   $32(a0)
                beq.s   SKRideVine_DrawHandle
                tst.w   $30(a0)
                bne.s   SKRideVine_HandleDrawReturn

SKRideVine_DrawHandle:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKRideVine_HandleDrawReturn:
                rts

; =============== S U B R O U T I N E =======================================

UpdatePlayerOnAizVineHandle:
                tst.b   (a2)
                beq.w   SKRideVine_TickRegrabCooldown
                bmi.w   SKRideVine_ForceDiagonalRelease
                tst.b   render_flags(a1)
                bpl.w   SKRideVine_ClearGrabAndStartCooldown
                cmpi.b  #4,routine(a1)
                bhs.w   SKRideVine_ClearGrabAndStartCooldown
                move.b  d0,d1
                andi.b  #button_A_mask|button_B_mask|button_C_mask,d1
                beq.w   SKRideVine_PickRiderPose
                clr.b   object_control(a1)
                clr.b   (a2)
                cmpi.w  #1,$30(a0)
                beq.s   SKRideVine_ReleaseAlongLinkTangent
                move.w  x_pos(a0),d1
                sub.w   $42(a0),d1
                asl.w   #7,d1
                move.w  d1,x_vel(a1)
                move.w  y_pos(a0),d1
                sub.w   $44(a0),d1
                asl.w   #7,d1
                move.w  d1,y_vel(a1)
                move.b  #$3C,2(a2)
                btst    #button_left+8,d0
                beq.s   SKRideVine_TryJumpRightOverride
                move.w  #-$200,x_vel(a1)

; If both directions are held, the right override wins
SKRideVine_TryJumpRightOverride:
                btst    #button_right+8,d0
                beq.s   SKRideVine_AddReleaseJumpBias
                move.w  #$200,x_vel(a1)

SKRideVine_AddReleaseJumpBias:
                addi.w  #-$380,y_vel(a1)

SKRideVine_SetReleasedJumpState:
                bset    #Status_InAir,status(a1)
                move.b  #1,jumping(a1)
                move.b  #$E,y_radius(a1)
                move.b  #7,x_radius(a1)
                move.b  #2,anim(a1)
                bset    #Status_Roll,status(a1)
                rts
; ---------------------------------------------------------------------------

SKRideVine_ReleaseAlongLinkTangent:
                move.b  #$3C,2(a2)
                movea.w $3C(a0),a3
                move.b  angle(a3),d0
                jsr     (GetSineCosine).l
                asl.w   #3,d1
                move.w  d1,x_vel(a1)
                asl.w   #3,d0
                move.w  d0,y_vel(a1)
                bra.s   SKRideVine_SetReleasedJumpState
; ---------------------------------------------------------------------------

SKRideVine_ForceDiagonalRelease:
                move.w  #$300,x_vel(a1)
                move.w  #$200,y_vel(a1)
                bset    #Status_InAir,status(a1)

SKRideVine_ClearGrabAndStartCooldown:
                clr.b   object_control(a1)
                clr.b   (a2)
                move.b  #$3C,2(a2)
                rts
; End of function UpdatePlayerOnAizVineHandle

; =============== S U B R O U T I N E =======================================

CheckAizVineLevelSelectSequence:
                cmpa.w  #Player_1,a1
                bne.s   SKRideVine_CheatReturn
                tst.b   d0
                beq.s   SKRideVine_CheatReturn
                moveq   #0,d1
                move.b  $25(a0),d1
                cmp.b   SKRideVine_LevelSelectInputs(pc,d1.w),d0
                bne.s   SKRideVine_ResetCheatProgress
                addq.b  #1,$25(a0)
                move.b  SKRideVine_LevelSelectInputs+1(pc,d1.w),d1
                bne.s   SKRideVine_CheatReturn

                moveq   #0,d1                           ; what the fuck
                subi.w  #-Level_select_flag,d1
                movea.w d1,a4

                moveq   #1,d1
                move.b  d1,(a4)
                move.b  d1,Slow_motion_flag-Level_select_flag(a4)
                move.w  d0,d1
                moveq   #signextendB(sfx_RingRight),d0
                jsr     (Play_SFX).l
                move.w  d1,d0

SKRideVine_ResetCheatProgress:
                move.b  #0,$25(a0)

SKRideVine_CheatReturn:
                rts
; End of function CheckAizVineLevelSelectSequence

; ---------------------------------------------------------------------------
SKRideVine_LevelSelectInputs:
                dc.b    button_left_mask
                dc.b    button_left_mask
                dc.b    button_left_mask
                dc.b    button_right_mask
                dc.b    button_right_mask
                dc.b    button_right_mask
                dc.b    button_up_mask
                dc.b    button_up_mask
                dc.b    button_up_mask
                dc.b    0
                even
; ---------------------------------------------------------------------------

SKRideVine_PickRiderPose:
                tst.w   $30(a0)
                bne.s   SKRideVine_ComputeSwingPose
                bsr.s   CheckAizVineLevelSelectSequence
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                addi.w  #$14,y_pos(a1)
                movea.w $3C(a0),a3
                moveq   #0,d0
                move.b  angle(a3),d0
                btst    #Status_Facing,status(a1)
                beq.s   SKRideVine_PickIdleHangFrame
                neg.b   d0

SKRideVine_PickIdleHangFrame:
                addq.b  #8,d0
                lsr.w   #4,d0
                move.b  SKRideVine_IdleHangFrames(pc,d0.w),mapping_frame(a1)

SKRideVine_SyncFacingAndDplc:
                move.b  status(a1),d1
                andi.b  #1,d1
                andi.b  #$FC,render_flags(a1)
                or.b    d1,render_flags(a1)
                moveq   #0,d0
                move.b  mapping_frame(a1),d0
                move.l  a2,-(sp)
                jsr     (Perform_Player_DPLC).l
                movea.l (sp)+,a2
                rts
; ---------------------------------------------------------------------------
SKRideVine_IdleHangFrames:
                dc.b    $91, $91, $90, $90, $90, $90, $90, $90, $92, $92, $92, $92, $92, $92, $91, $91
                even
; ---------------------------------------------------------------------------

SKRideVine_ComputeSwingPose:
                movea.w $3C(a0),a3
                moveq   #0,d0
                move.b  angle(a3),d0
                btst    #Status_Facing,status(a1)
                beq.s   SKRideVine_ReadSwingFrameAndOffset
                neg.b   d0

SKRideVine_ReadSwingFrameAndOffset:
                addi.b  #$10,d0
                lsr.w   #5,d0
                add.w   d0,d0
                move.b  SKRideVine_SwingFramePairs(pc,d0.w),mapping_frame(a1)
                move.b  #0,anim(a1)
                andi.w  #$FFFE,d0
                move.b  SKRideVine_SwingPoseOffsets(pc,d0.w),d2
                move.b  SKRideVine_SwingPoseOffsets+1(pc,d0.w),d3
                ext.w   d2
                ext.w   d3
                btst    #Status_Facing,status(a1)
                beq.s   SKRideVine_PlaceSwingPoseFromLink
                neg.w   d2

SKRideVine_PlaceSwingPoseFromLink:
                movea.w $3C(a0),a3
                move.b  angle(a3),d0
                addq.b  #4,d0
                andi.b  #$F8,d0
                jsr     (GetSineCosine).l
                neg.w   d0
                addi.w  #8,d0
                addi.w  #8,d1
                asr.w   #4,d0
                asr.w   #4,d1
                add.w   x_pos(a3),d0
                add.w   d2,d0
                move.w  d0,x_pos(a1)
                add.w   y_pos(a3),d1
                add.w   d3,d1
                move.w  d1,y_pos(a1)
                bra.w   SKRideVine_SyncFacingAndDplc
; ---------------------------------------------------------------------------
SKRideVine_SwingFramePairs:
                dc.b    $78
                dc.b    $78
                dc.b    $7F
                dc.b    $7F
                dc.b    $7E
                dc.b    $7E
                dc.b    $7D
                dc.b    $7D
                dc.b    $7C
                dc.b    $7C
                dc.b    $7B
                dc.b    $7B
                dc.b    $7A
                dc.b    $7A
                dc.b    $79
                dc.b    $79
SKRideVine_SwingPoseOffsets:
                dc.b    0, $18
                dc.b    -$12, $13
                dc.b    -$18,   0
                dc.b    -$12,-$13
                dc.b    0,-$18
                dc.b    $12,-$13
                dc.b    $18,   0
                dc.b    $12, $13
                even
; ---------------------------------------------------------------------------

SKRideVine_TickRegrabCooldown:
                tst.b   2(a2)
                beq.s   SKRideVine_TryGrabHandle
                subq.b  #1,2(a2)
                bne.w   SKRideVine_GrabReturn

SKRideVine_TryGrabHandle:
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                addi.w  #$10,d0
                cmpi.w  #$20,d0
                bhs.w   SKRideVine_GrabReturn
                move.w  y_pos(a1),d1
                sub.w   y_pos(a0),d1
                cmpi.w  #$18,d1
                bhs.w   SKRideVine_GrabReturn
                tst.b   object_control(a1)
                bne.s   SKRideVine_GrabReturn
                cmpi.b  #4,routine(a1)
                bhs.s   SKRideVine_GrabReturn
                tst.w   (Debug_placement_mode).w
                bne.s   SKRideVine_GrabReturn
                clr.w   x_vel(a1)
                clr.w   y_vel(a1)
                clr.w   ground_vel(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                addi.w  #$14,y_pos(a1)
                move.b  #$14,anim(a1)
                move.b  #0,spin_dash_flag(a1)
                move.b  #3,object_control(a1)
                andi.b  #$FD,render_flags(a1)
                move.b  #1,(a2)
                moveq   #signextendB(sfx_Grab),d0
                jsr     (Play_SFX).l

SKRideVine_GrabReturn:
                rts
