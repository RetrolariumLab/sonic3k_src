; Owner: game/level/sk
; Responsibility: Background deformation, horizontal and vertical camera tracking and two-player camera updates
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

DeformBgLayer:
                tst.b   (Deform_lock).w
                beq.s   SKCamera_ClearDeltasAndPickView
                rts
; ---------------------------------------------------------------------------

SKCamera_ClearDeltasAndPickView:
                clr.w   (Camera_RAM).w
                clr.w   (V_scroll_amount).w
                clr.w   (H_scroll_amount_P2).w
                clr.w   (V_scroll_amount_P2).w
                tst.w   (Competition_mode).w
                bne.w   SKCamera_TryTrackCompP1
                tst.b   (Scroll_lock).w
                bne.s   SKCamera_RunSingleResizeEvents
                lea     (Player_1).w,a0
                tst.b   (Scroll_force_positions).w
                beq.s   SKCamera_SetSingleViewport
                move.b  #0,(Scroll_force_positions).w
                move.w  #0,(H_scroll_frame_offset).w
                lea     (Scroll_forced_X_pos-x_pos).w,a0  ; is now a player address

SKCamera_SetSingleViewport:
                lea     (Camera_X_pos).w,a1
                lea     (Camera_min_X_pos).w,a2
                lea     (Camera_RAM).w,a4
                lea     (H_scroll_frame_offset).w,a5
                lea     (Pos_table).w,a6
                bsr.w   MoveCameraX
                lea     (Camera_Y_pos).w,a1
                lea     (Camera_min_X_pos).w,a2
                lea     (V_scroll_amount).w,a4
                move.w  (Distance_from_top).w,d3
                cmpi.w  #2,(Player_mode).w
                bne.s   SKCamera_TrackSingleY
                move.w  (Distance_from_top_P2).w,d3

SKCamera_TrackSingleY:
                bsr.w   MoveCameraY

SKCamera_RunSingleResizeEvents:
                bra.w   Do_ResizeEvents
; ---------------------------------------------------------------------------

SKCamera_TryTrackCompP1:
                tst.b   (Scroll_lock).w
                bne.s   SKCamera_TryTrackCompP2
                lea     (Player_1).w,a0
                lea     (Camera_X_pos).w,a1
                lea     (Camera_min_X_pos).w,a2
                lea     (Camera_RAM).w,a4
                lea     (H_scroll_frame_offset).w,a5
                lea     (Pos_table).w,a6
                bsr.w   MoveCameraX_2P
                lea     (Camera_Y_pos).w,a1
                lea     (Camera_min_X_pos).w,a2
                lea     (V_scroll_amount).w,a4
                move.w  (Distance_from_top).w,d3
                cmpi.w  #2,(Player_mode).w
                bne.s   SKCamera_RunPrimarySplitVerticalCamera
                move.w  (Distance_from_top_P2).w,d3

SKCamera_RunPrimarySplitVerticalCamera:
                bsr.w   MoveCameraY

SKCamera_TryTrackCompP2:
                tst.b   (Scroll_lock_P2).w
                bne.s   SKCamera_RunCompResizeEvents
                lea     (Player_2).w,a0
                lea     (Camera_X_pos_P2).w,a1
                lea     (Camera_min_X_pos_P2).w,a2
                lea     (H_scroll_amount_P2).w,a4
                lea     (H_scroll_frame_offset_P2).w,a5
                lea     (Stat_table).w,a6
                bsr.w   MoveCameraX_2P
                lea     (Camera_Y_pos_P2).w,a1
                lea     (Camera_min_X_pos_P2).w,a2
                lea     (V_scroll_amount_P2).w,a4
                move.w  (Distance_from_top_P2).w,d3
                bsr.w   MoveCameraY

SKCamera_RunCompResizeEvents:
                bra.w   Do_ResizeEvents
; End of function DeformBgLayer

; =============== S U B R O U T I N E =======================================

MoveCameraX:
                move.w  (a1),d4
                tst.b   (Teleport_active_flag).w
                bne.s   SKCamera_TrackXReturn
                move.w  (a5),d1
                beq.s   SKCamera_ReadLiveActorX
                subi.w  #$100,d1
                move.w  d1,(a5)
                moveq   #0,d1
                move.b  (a5),d1
                lsl.b   #2,d1
                addq.b  #4,d1
                move.w  2(a5),d0
                sub.b   d1,d0
                move.w  (a6,d0.w),d0
                andi.w  #$7FFF,d0
                bra.s   SKCamera_CheckXDeadband
; ---------------------------------------------------------------------------

SKCamera_ReadLiveActorX:
                move.w  x_pos(a0),d0

SKCamera_CheckXDeadband:
                sub.w   (a1),d0
                subi.w  #$90,d0
                blt.s   SKCamera_LimitLeftStep24
                subi.w  #$10,d0
                bge.s   SKCamera_LimitRightStep24
                clr.w   (a4)

SKCamera_TrackXReturn:
                rts
; ---------------------------------------------------------------------------

SKCamera_LimitLeftStep24:
                cmpi.w  #-$18,d0
                bgt.s   SKCamera_ClampCandidateMinX
                move.w  #-$18,d0

SKCamera_ClampCandidateMinX:
                add.w   (a1),d0
                cmp.w   (a2),d0
                bgt.s   SKCamera_CommitXAndScrollDelta
                move.w  (a2),d0
                bra.s   SKCamera_CommitXAndScrollDelta
; ---------------------------------------------------------------------------

SKCamera_LimitRightStep24:
                cmpi.w  #$18,d0
                blo.s   SKCamera_ClampCandidateMaxX
                move.w  #$18,d0

SKCamera_ClampCandidateMaxX:
                add.w   (a1),d0
                cmp.w   2(a2),d0
                blt.s   SKCamera_CommitXAndScrollDelta
                move.w  2(a2),d0

; Store the X displacement as a word with eight fractional bits
SKCamera_CommitXAndScrollDelta:
                move.w  d0,d1
                sub.w   (a1),d1
                asl.w   #8,d1
                move.w  d0,(a1)
                move.w  d1,(a4)
                rts
; End of function MoveCameraX

; =============== S U B R O U T I N E =======================================

MoveCameraY:
                moveq   #0,d1
                move.w  y_pos(a0),d0
                sub.w   (a1),d0
                cmpi.w  #-$100,(Camera_min_Y_pos).w
                bne.s   SKCamera_TryApplyRollYBias
                and.w   (Screen_Y_wrap_value).w,d0

SKCamera_TryApplyRollYBias:
                btst    #Status_Roll,status(a0)
                beq.s   SKCamera_PickYTargetDistance
                subq.w  #5,d0

SKCamera_PickYTargetDistance:
                move.w  d3,d1
                tst.w   (Competition_mode).w
                beq.s   SKCamera_CheckAirborneYWindow
                lsr.w   #1,d1

SKCamera_CheckAirborneYWindow:
                btst    #Status_InAir,status(a0)
                beq.s   SKCamera_CheckGroundedYDelta
                addi.w  #$20,d0
                sub.w   d1,d0
                bcs.s   SKCamera_UseYRate24
                subi.w  #$40,d0
                bcc.s   SKCamera_UseYRate24
                tst.b   (Camera_max_Y_pos_changing).w
                bne.s   SKCamera_RecheckChangedYLimit
                bra.s   SKCamera_ClearYDeltaAndReturn
; ---------------------------------------------------------------------------

SKCamera_CheckGroundedYDelta:
                sub.w   d1,d0
                bne.s   SKCamera_PickYFollowRate
                tst.b   (Camera_max_Y_pos_changing).w
                bne.s   SKCamera_RecheckChangedYLimit

SKCamera_ClearYDeltaAndReturn:
                clr.w   (a4)
                rts
; ---------------------------------------------------------------------------

SKCamera_PickYFollowRate:
                cmpi.w  #$60,d3
                bne.s   SKCamera_UseYRate2
                tst.b   (Fast_V_scroll_flag).w
                bne.s   SKCamera_UseYRate24
                move.w  ground_vel(a0),d1
                bpl.s   SKCamera_PickYRate6Or24
                neg.w   d1

SKCamera_PickYRate6Or24:
                cmpi.w  #$800,d1
                bhs.s   SKCamera_UseYRate24
                move.w  #$600,d1
                cmpi.w  #6,d0
                bgt.s   SKCamera_StepCameraDown
                cmpi.w  #-6,d0
                blt.s   SKCamera_StepCameraUp
                bra.s   SKCamera_MakeIntegerYCandidate
; ---------------------------------------------------------------------------

SKCamera_UseYRate2:
                move.w  #$200,d1
                cmpi.w  #2,d0
                bgt.s   SKCamera_StepCameraDown
                cmpi.w  #-2,d0
                blt.s   SKCamera_StepCameraUp
                bra.s   SKCamera_MakeIntegerYCandidate
; ---------------------------------------------------------------------------

SKCamera_UseYRate24:
                move.w  #$1800,d1
                cmpi.w  #$18,d0
                bgt.s   SKCamera_StepCameraDown
                cmpi.w  #-$18,d0
                blt.s   SKCamera_StepCameraUp
                bra.s   SKCamera_MakeIntegerYCandidate
; ---------------------------------------------------------------------------

SKCamera_RecheckChangedYLimit:
                moveq   #0,d0
                move.b  d0,(Camera_max_Y_pos_changing).w

SKCamera_MakeIntegerYCandidate:
                moveq   #0,d1
                move.w  d0,d1
                add.w   (a1),d1
                tst.w   d0
                bpl.w   SKCamera_ClampOrWrapMaxY
                bra.w   SKCamera_ClampOrWrapMinY
; ---------------------------------------------------------------------------

SKCamera_StepCameraUp:
                neg.w   d1
                ext.l   d1
                asl.l   #8,d1
                add.l   (a1),d1
                swap    d1

SKCamera_ClampOrWrapMinY:
                cmp.w   4(a2),d1
                bgt.s   SKCamera_CommitYAndScrollDelta
                cmpi.w  #-$100,d1
                bgt.s   SKCamera_ClampToMinY
                and.w   (Screen_Y_wrap_value).w,d1
                bra.s   SKCamera_CommitYAndScrollDelta
; ---------------------------------------------------------------------------

SKCamera_ClampToMinY:
                move.w  4(a2),d1
                bra.s   SKCamera_CommitYAndScrollDelta
; ---------------------------------------------------------------------------

SKCamera_StepCameraDown:
                ext.l   d1
                asl.l   #8,d1
                add.l   (a1),d1
                swap    d1

SKCamera_ClampOrWrapMaxY:
                cmp.w   6(a2),d1
                blt.s   SKCamera_CommitYAndScrollDelta
                move.w  (Screen_Y_wrap_value).w,d3
                addq.w  #1,d3
                sub.w   d3,d1
                bcs.s   SKCamera_ClampToMaxY
                sub.w   d3,(a1)
                bra.s   SKCamera_CommitYAndScrollDelta
; ---------------------------------------------------------------------------

SKCamera_ClampToMaxY:
                move.w  6(a2),d1

SKCamera_CommitYAndScrollDelta:
                move.w  (a1),d4
                swap    d1
                move.l  d1,d3
                sub.l   (a1),d3
                ror.l   #8,d3
                move.w  d3,(a4)
                move.l  d1,(a1)
                tst.w   (Competition_mode).w
                beq.s   SKCamera_TrackYReturn
                swap    d1
                and.w   (Screen_Y_wrap_value).w,d1
                move.w  d1,(a1)

SKCamera_TrackYReturn:
                rts
; End of function MoveCameraY

; =============== S U B R O U T I N E =======================================

MoveCameraX_2P:
                move.w  (a1),d4
                tst.b   (Teleport_active_flag).w
                bne.s   SKCamera_TrackCompXReturn
                move.w  (a5),d1
                beq.s   SKCamera_ReadLiveCompActorX
                subi.w  #$100,d1
                move.w  d1,(a5)
                moveq   #0,d1
                move.b  (a5),d1
                lsl.b   #2,d1
                addq.b  #4,d1
                move.w  2(a5),d0
                sub.b   d1,d0
                move.w  (a6,d0.w),d0
                andi.w  #$7FFF,d0
                bra.s   SKCamera_CheckCompXDeadband
; ---------------------------------------------------------------------------

SKCamera_ReadLiveCompActorX:
                move.w  x_pos(a0),d0

SKCamera_CheckCompXDeadband:
                move.w  (Screen_X_wrap_value).w,d2
                sub.w   (a1),d0
                and.w   d2,d0
                subi.w  #$90,d0
                blt.s   SKCamera_LimitCompLeftStep16
                subi.w  #$10,d0
                bge.s   SKCamera_LimitCompRightStep16
                clr.w   (a4)

SKCamera_TrackCompXReturn:
                rts
; ---------------------------------------------------------------------------

SKCamera_LimitCompLeftStep16:
                cmpi.w  #-$10,d0
                bgt.s   SKCamera_ApplyCompLeftStep
                move.w  #-$10,d0

SKCamera_ApplyCompLeftStep:
                add.w   (a1),d0
                bra.s   SKCamera_CommitWrappedCompX
; ---------------------------------------------------------------------------

SKCamera_LimitCompRightStep16:
                cmpi.w  #$10,d0
                blo.s   SKCamera_ApplyCompRightStep
                move.w  #$10,d0

SKCamera_ApplyCompRightStep:
                add.w   (a1),d0

; Compute the scroll delta before masking the camera position
SKCamera_CommitWrappedCompX:
                move.w  d0,d1
                sub.w   (a1),d1
                asl.w   #8,d1
                and.w   d2,d0
                addi.w  #$400,d0
                move.w  d0,(a1)
                move.w  d1,(a4)
                rts
; End of function MoveCameraX_2P
