; Owner: objects/zones/mhz/sk
; Responsibility: Mushroom Hill swing-vine motion, character launch, player positioning and shared vine mapping storage
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_MHZSwingVine:
                movea.l a0,a1
                move.l  #SKMHZSwingVine_WaitForFastCapture,(a1)
                bsr.w   InitializeMhzSwingVineSprite
                move.b  #$23,mapping_frame(a1)
                move.w  x_pos(a0),d2
                move.w  y_pos(a0),d3
                moveq   #0,d1
                addq.w  #1,d1
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   SKMHZSwingVine_EnterSwingWait
                move.w  a1,$3E(a0)
                move.l  #SKMHZSwingVine_FollowPreviousLink,(a1)
                move.w  a0,$3C(a1)
                bra.s   SKMHZSwingVine_InitLinkAndUpdateEnd
; ---------------------------------------------------------------------------

SKMHZSwingVine_TryAllocateNextLink:
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   SKMHZSwingVine_EnterSwingWait
                move.w  a2,$3C(a1)
                move.w  a1,$3E(a2)

SKMHZSwingVine_InitLinkAndUpdateEnd:
                movea.l a1,a2
                bsr.s   InitializeMhzSwingVineSprite
                move.w  d2,x_pos(a1)
                move.w  d3,y_pos(a1)
                addi.w  #$10,d3
                addq.w  #1,$36(a0)
                move.w  $36(a0),$36(a1)
                dbf     d1,SKMHZSwingVine_TryAllocateNextLink
                move.l  #SKMHZSwingVine_MoveEndAndSaveOldX,(a1)
                move.b  #$22,mapping_frame(a1)
                move.w  x_pos(a1),$42(a1)
                move.w  y_pos(a1),$44(a1)
                move.w  a1,$40(a0)

; Enter the wait state even when only a prefix of the chain could be allocated
SKMHZSwingVine_EnterSwingWait:
                bra.s   SKMHZSwingVine_WaitForFastCapture

; =============== S U B R O U T I N E =======================================

InitializeMhzSwingVineSprite:
                move.b  #4,render_flags(a1)
                move.b  #8,width_pixels(a1)
                move.b  #8,height_pixels(a1)
                move.w  #$200,priority(a1)
                move.l  #Map_AIZMHZRideVine,mappings(a1)
                move.w  #make_art_tile(ArtTile_MHZMisc+$10E,0,0),art_tile(a1)
                rts
; End of function InitializeMhzSwingVineSprite

; ---------------------------------------------------------------------------

SKMHZSwingVine_WaitForFastCapture:
                movea.w $40(a0),a1
                tst.w   $32(a1)
                beq.s   SKMHZSwingVine_DrawAfterWait
                bmi.s   SKMHZSwingVine_BeginPoweredSwing
                tst.b   $33(a1)
                bpl.s   SKMHZSwingVine_DrawAfterWait

SKMHZSwingVine_BeginPoweredSwing:
                move.l  #SKMHZSwingVine_CalcAbsPoweredAngle,(a0)
                movea.w $40(a0),a1
                move.w  #1,$30(a1)
                move.w  #0,angle(a0)
                move.w  #$800,$3A(a0)

SKMHZSwingVine_DrawAfterWait:
                bra.w   SKMHZSwingVine_DrawOrCullChain
; ---------------------------------------------------------------------------

SKMHZSwingVine_CalcAbsPoweredAngle:
                movea.w $40(a0),a1
                move.w  $3A(a0),d0
                move.b  angle(a0),d1
                ext.w   d1
                bpl.s   SKMHZSwingVine_StepPoweredSwing
                neg.w   d1

SKMHZSwingVine_StepPoweredSwing:
                add.w   d1,d1
                sub.w   d1,d0
                sub.w   d0,angle(a0)
                move.b  angle(a0),d0
                andi.b  #$F8,d0
                cmpi.b  #$40,d0
                bne.s   SKMHZSwingVine_SetPoweredPriority
                moveq   #signextendB(sfx_GroundSlide),d0
                jsr     (Play_SFX).l

SKMHZSwingVine_SetPoweredPriority:
                move.w  #$200,priority(a0)
                tst.w   angle(a0)
                bpl.s   SKMHZSwingVine_TryForceP1Camera
                move.w  #$280,priority(a0)

SKMHZSwingVine_TryForceP1Camera:
                tst.b   $32(a1)
                beq.s   SKMHZSwingVine_TryBeginDamping
                move.b  #1,(Scroll_force_positions).w
                move.w  x_pos(a0),(Scroll_forced_X_pos).w
                move.w  y_pos(a0),(Scroll_forced_Y_pos).w

SKMHZSwingVine_TryBeginDamping:
                tst.w   $32(a1)
                bne.s   SKMHZSwingVine_DrawAfterPoweredSwing
                move.b  angle(a0),d0
                addq.b  #8,d0
                cmpi.b  #$10,d0
                bhs.s   SKMHZSwingVine_DrawAfterPoweredSwing
                move.l  #SKMHZSwingVine_StepPositiveDamping,(a0)
                move.w  #0,$42(a0)
                move.w  #-$300,$44(a0)
                move.w  #$1000,$38(a0)
                move.w  #0,$2E(a0)
                movea.w $40(a0),a1
                move.w  #2,$30(a1)

SKMHZSwingVine_DrawAfterPoweredSwing:
                bra.w   SKMHZSwingVine_DrawOrCullChain
; ---------------------------------------------------------------------------

SKMHZSwingVine_StepPositiveDamping:
                moveq   #0,d2
                move.b  $38(a0),d2
                move.w  $44(a0),d0
                move.w  #0,d1
                tst.w   $2E(a0)
                bne.s   SKMHZSwingVine_StepNegativeDamping
                add.w   d2,d0
                move.w  d0,$44(a0)
                add.w   d0,$42(a0)
                cmp.b   $42(a0),d1
                bgt.s   SKMHZSwingVine_ApplySettlingAngle
                asr.w   #4,d0
                sub.w   d0,$44(a0)
                move.w  #1,$2E(a0)
                cmpi.w  #$C00,$38(a0)
                beq.s   SKMHZSwingVine_FinishDamping
                subi.w  #$40,$38(a0)
                bra.s   SKMHZSwingVine_ApplySettlingAngle
; ---------------------------------------------------------------------------

SKMHZSwingVine_FinishDamping:
                move.l  #SKMHZSwingVine_WaitForFastCapture,(a0)
                move.w  #0,$38(a0)
                movea.w $40(a0),a1
                move.w  #0,$30(a1)
                move.w  x_pos(a1),$42(a1)
                move.w  y_pos(a1),$44(a1)
                bra.s   SKMHZSwingVine_ApplySettlingAngle
; ---------------------------------------------------------------------------

SKMHZSwingVine_StepNegativeDamping:
                sub.w   d2,d0
                move.w  d0,$44(a0)
                add.w   d0,$42(a0)
                cmp.b   $42(a0),d1
                ble.s   SKMHZSwingVine_ApplySettlingAngle
                asr.w   #4,d0
                sub.w   d0,$44(a0)
                move.w  #0,$2E(a0)
                cmpi.w  #$C00,$38(a0)
                beq.s   SKMHZSwingVine_FinishDamping
                subi.w  #$40,$38(a0)

SKMHZSwingVine_ApplySettlingAngle:
                move.w  $42(a0),d0
                move.w  d0,angle(a0)
                move.w  #$200,priority(a0)
                tst.w   angle(a0)
                bpl.s   SKMHZSwingVine_SetDampingAndTestRestart
                move.w  #$280,priority(a0)

SKMHZSwingVine_SetDampingAndTestRestart:
                asr.w   #3,d0
                move.w  d0,$3A(a0)
                movea.w $3E(a0),a1
                move.w  $3A(a0),$3A(a1)
                movea.w $40(a0),a1
                tst.w   $32(a1)
                beq.s   SKMHZSwingVine_DrawOrCullChain
                bmi.s   SKMHZSwingVine_RestartPoweredSwing
                tst.b   $33(a1)
                bpl.s   SKMHZSwingVine_DrawOrCullChain

SKMHZSwingVine_RestartPoweredSwing:
                move.l  #SKMHZSwingVine_CalcAbsPoweredAngle,(a0)
                move.w  #1,$30(a1)
                move.w  #$800,$3A(a0)

SKMHZSwingVine_DrawOrCullChain:
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   SKMHZSwingVine_BeginChainCleanup
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKMHZSwingVine_BeginChainCleanup:
                move.w  $36(a0),d2
                subq.w  #1,d2
                bcs.s   SKMHZSwingVine_ClearRootRespawnBit
                movea.w $3E(a0),a2

SKMHZSwingVine_DeleteChainLink:
                movea.l a2,a1
                movea.w $3E(a1),a2
                jsr     (Delete_Referenced_Sprite).l
                dbf     d2,SKMHZSwingVine_DeleteChainLink

SKMHZSwingVine_ClearRootRespawnBit:
                move.w  respawn_addr(a0),d0
                beq.s   SKMHZSwingVine_DeleteSwingRoot
                movea.w d0,a2
                bclr    #7,(a2)

SKMHZSwingVine_DeleteSwingRoot:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

SKMHZSwingVine_FollowPreviousLink:
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

; =============== S U B R O U T I N E =======================================

PositionMhzSwingVineEndFromPreviousLink:
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
; End of function PositionMhzSwingVineEndFromPreviousLink

; ---------------------------------------------------------------------------

SKMHZSwingVine_MoveEndAndSaveOldX:
                move.w  x_pos(a0),d4
                move.w  y_pos(a0),d5
                bsr.w   PositionMhzSwingVineEndFromPreviousLink
                cmp.w   x_pos(a0),d4
                beq.s   SKMHZSwingVine_TrySaveOldEndY
                move.w  d4,$42(a0)

SKMHZSwingVine_TrySaveOldEndY:
                cmp.w   y_pos(a0),d5
                beq.s   SKMHZSwingVine_UpdateEndRiders
                move.w  d5,$44(a0)

SKMHZSwingVine_UpdateEndRiders:
                lea     $32(a0),a2
                lea     (Player_1).w,a1
                move.w  (Ctrl_1_logical).w,d0
                bsr.s   SKMHZSwingVine_UpdateRiderOrCapture
                lea     (Player_2).w,a1
                addq.w  #1,a2
                move.w  (Ctrl_2_logical).w,d0
                bsr.s   SKMHZSwingVine_UpdateRiderOrCapture
                tst.w   $32(a0)
                beq.s   SKMHZSwingVine_DrawEmptyOrIdleEnd
                tst.w   $30(a0)
                bne.s   SKMHZSwingVine_SkipOccupiedEndDraw

SKMHZSwingVine_DrawEmptyOrIdleEnd:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKMHZSwingVine_SkipOccupiedEndDraw:
                rts
; ---------------------------------------------------------------------------

SKMHZSwingVine_UpdateRiderOrCapture:
                tst.b   (a2)
                beq.w   SKMHZSwingVine_TickCaptureCooldown
                tst.b   render_flags(a1)
                bpl.w   SKMHZSwingVine_DetachWithoutJump
                cmpi.b  #4,routine(a1)
                bhs.w   SKMHZSwingVine_DetachWithoutJump
                tst.w   (Debug_placement_mode).w
                bne.w   SKMHZSwingVine_DetachWithoutJump
                andi.b  #button_A_mask|button_B_mask|button_C_mask,d0
                beq.w   SKMHZSwingVine_PlaceIdleRider
                clr.b   object_control(a1)
                clr.b   (a2)
                cmpi.w  #1,$30(a0)
                beq.s   SKMHZSwingVine_LaunchAlongLink
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
                beq.s   SKMHZSwingVine_TrySetJumpRight
                move.w  #-$200,x_vel(a1)

SKMHZSwingVine_TrySetJumpRight:
                btst    #button_right+8,d0
                beq.s   SKMHZSwingVine_AddJumpImpulseY
                move.w  #$200,x_vel(a1)

SKMHZSwingVine_AddJumpImpulseY:
                addi.w  #-$380,y_vel(a1)

SKMHZSwingVine_SetJumpReleasePose:
                bset    #Status_InAir,status(a1)
                move.b  #1,$40(a1)
                move.b  #$E,y_radius(a1)
                move.b  #7,x_radius(a1)
                move.b  #2,anim(a1)
                bset    #Status_Roll,status(a1)
                rts
; ---------------------------------------------------------------------------

SKMHZSwingVine_LaunchAlongLink:
                move.b  #$3C,2(a2)
                movea.w $3C(a0),a3
                move.b  angle(a3),d0
                jsr     (GetSineCosine).l
                asl.w   #2,d1
                move.w  d1,d2
                asl.w   #1,d1
                add.w   d2,d1
                move.w  d1,x_vel(a1)
                asl.w   #2,d0
                move.w  d0,d2
                asl.w   #1,d0
                add.w   d2,d0
                move.w  d0,y_vel(a1)
                bra.s   SKMHZSwingVine_SetJumpReleasePose
; ---------------------------------------------------------------------------

SKMHZSwingVine_DetachWithoutJump:
                clr.b   $2E(a1)
                clr.b   (a2)
                move.b  #$3C,2(a2)
                rts
; ---------------------------------------------------------------------------

SKMHZSwingVine_PlaceIdleRider:
                tst.w   $30(a0)
                bne.s   SKMHZSwingVine_GetMovingPoseAngle
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                addi.w  #$14,y_pos(a1)
                movea.w $3C(a0),a3
                moveq   #0,d0
                move.b  angle(a3),d0
                btst    #Status_Facing,status(a1)
                beq.s   SKMHZSwingVine_ApplyIdleRiderFrame
                neg.b   d0

SKMHZSwingVine_ApplyIdleRiderFrame:
                addq.b  #8,d0
                lsr.w   #4,d0
                move.b  SKMHZSwingVine_IdleRiderFrames(pc,d0.w),mapping_frame(a1)

SKMHZSwingVine_ApplyFacingAndUploadPose:
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
SKMHZSwingVine_IdleRiderFrames:
                dc.b    $91, $91, $90, $90, $90, $90, $90, $90, $92, $92, $92, $92, $92, $92, $91, $91
                even
; ---------------------------------------------------------------------------

SKMHZSwingVine_GetMovingPoseAngle:
                movea.w $3C(a0),a3
                moveq   #0,d0
                move.b  angle(a3),d0
                btst    #Status_Facing,status(a1)
                beq.s   SKMHZSwingVine_LoadFrameAndPoseOffset
                neg.b   d0

SKMHZSwingVine_LoadFrameAndPoseOffset:
                addi.b  #$10,d0
                lsr.w   #5,d0
                add.w   d0,d0
                move.b  SKMHZSwingVine_MovingRiderFrames(pc,d0.w),mapping_frame(a1)
                move.b  #0,anim(a1)
                andi.w  #$FFFE,d0
                move.b  SKMHZSwingVine_MovingRiderFrames+$10(pc,d0.w),d2
                move.b  SKMHZSwingVine_MovingRiderYOffsets(pc,d0.w),d3
                ext.w   d2
                ext.w   d3
                btst    #Status_Facing,status(a1)
                beq.s   SKMHZSwingVine_ProjectMovingRider
                neg.w   d2

SKMHZSwingVine_ProjectMovingRider:
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
                bra.w   SKMHZSwingVine_ApplyFacingAndUploadPose
; ---------------------------------------------------------------------------
; The X-offset lookup starts 16 bytes into this table, at the last byte before the Y-offset label
SKMHZSwingVine_MovingRiderFrames:
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
                dc.b    0
SKMHZSwingVine_MovingRiderYOffsets:
                dc.b    $18
                dc.b    -$12
                dc.b    $13
                dc.b    -$18
                dc.b    0
                dc.b    -$12
                dc.b    -$13
                dc.b    0
                dc.b    -$18
                dc.b    $12
                dc.b    -$13
                dc.b    $18
                dc.b    0
                dc.b    $12
                dc.b    $13
                even
; ---------------------------------------------------------------------------

SKMHZSwingVine_TickCaptureCooldown:
                tst.b   2(a2)
                beq.s   SKMHZSwingVine_CheckCaptureBounds
                subq.b  #1,2(a2)
                bne.w   SKMHZSwingVine_CaptureReturn

SKMHZSwingVine_CheckCaptureBounds:
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                addi.w  #$10,d0
                cmpi.w  #$20,d0
                bhs.w   SKMHZSwingVine_CaptureReturn
                move.w  y_pos(a1),d1
                sub.w   y_pos(a0),d1
                cmpi.w  #$28,d1
                bhs.w   SKMHZSwingVine_CaptureReturn
                move.w  x_vel(a1),d0
                cmpi.w  #$400,d0
                bge.s   SKMHZSwingVine_CaptureAndCheckFastGrab
                cmpi.w  #$18,d1
                bhs.w   SKMHZSwingVine_CaptureReturn

SKMHZSwingVine_CaptureAndCheckFastGrab:
                tst.b   object_control(a1)
                bne.s   SKMHZSwingVine_CaptureReturn
                cmpi.b  #4,routine(a1)
                bhs.s   SKMHZSwingVine_CaptureReturn
                tst.w   (Debug_placement_mode).w
                bne.s   SKMHZSwingVine_CaptureReturn
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
                cmpi.w  #$400,d0
                blt.s   SKMHZSwingVine_CaptureAndCheckFastGrab
                move.b  #$81,(a2)
                moveq   #signextendB(sfx_Grab),d0
                jsr     (Play_SFX).l

SKMHZSwingVine_CaptureReturn:
                rts
; ---------------------------------------------------------------------------
Map_AIZMHZRideVine:
                include "src/objects/shared/zones/aiz/mappings/mhz_ride_vine.s"
