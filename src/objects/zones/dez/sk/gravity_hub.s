; Owner: objects/zones/dez/sk
; Responsibility: Gravity hub player contact, directional control and release
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

Obj_DEZGravityHub:
                lea     $30(a0),a2
                lea     (Player_1).w,a1
                move.w  (Ctrl_1_logical).w,d1
                bsr.s   UpdatePlayerInDezGravityHub
                lea     $32(a0),a2
                lea     (Player_2).w,a1
                move.w  (Ctrl_2_logical).w,d1
                bsr.s   UpdatePlayerInDezGravityHub
                jmp     (Delete_Sprite_If_Not_In_Range).l

; =============== S U B R O U T I N E =======================================

UpdatePlayerInDezGravityHub:
                move.b  (a2),d0
                bne.s   SKDEZGravHub_CenterOrReleaseRider
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                addi.w  #$20,d0
                cmpi.w  #$40,d0
                bhs.s   SKDEZGravHub_CaptureReturn
                move.w  y_pos(a1),d1
                sub.w   y_pos(a0),d1
                addi.w  #$20,d1
                cmpi.w  #$40,d1
                bhs.s   SKDEZGravHub_CaptureReturn
                btst    #Status_OnObj,status(a1)
                bne.s   SKDEZGravHub_CaptureReturn
                cmpi.b  #6,routine(a1)
                bhs.s   SKDEZGravHub_CaptureReturn
                tst.w   (Debug_placement_mode).w
                bne.s   SKDEZGravHub_CaptureReturn
                bset    #Status_InAir,status(a1)
                move.w  #0,x_vel(a1)
                move.w  #0,y_vel(a1)
                move.w  #0,ground_vel(a1)
                move.w  #0,angle(a1)                    ; and flip_angle
                andi.b  #$FC,render_flags(a1)
                move.w  #1,anim(a1)                     ; and prev_anim
                move.b  #$83,object_control(a1)
                move.b  #1,(a2)

SKDEZGravHub_CaptureReturn:
                rts
; ---------------------------------------------------------------------------

SKDEZGravHub_CenterOrReleaseRider:
                cmpi.b  #7,d0
                bhs.w   SKDEZGravHub_CheckDirectionOrDeparture
                moveq   #8,d1
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                bpl.s   SKDEZGravHub_TrySnapRiderX
                neg.w   d0
                neg.w   d1

SKDEZGravHub_TrySnapRiderX:
                cmpi.w  #8,d0
                bhs.s   SKDEZGravHub_StepXAndMeasureY
                move.w  x_pos(a0),x_pos(a1)
                moveq   #0,d1
                bset    #1,(a2)

SKDEZGravHub_StepXAndMeasureY:
                sub.w   d1,x_pos(a1)
                moveq   #8,d1
                move.w  y_pos(a1),d0
                sub.w   y_pos(a0),d0
                bpl.s   SKDEZGravHub_TrySnapRiderY
                neg.w   d0
                neg.w   d1

SKDEZGravHub_TrySnapRiderY:
                cmpi.w  #8,d0
                bhs.s   SKDEZGravHub_StepRiderY
                move.w  y_pos(a0),y_pos(a1)
                moveq   #0,d1
                bset    #2,(a2)

SKDEZGravHub_StepRiderY:
                sub.w   d1,y_pos(a1)

SKDEZGravHub_TickHumAndAnimateRider:
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #$F,d0
                bne.s   SKDEZGravHub_TickRiderPoseCounter
                moveq   #signextendB(sfx_GravityTunnel),d0
                jsr     (Play_SFX).l

SKDEZGravHub_TickRiderPoseCounter:
                moveq   #0,d2
                move.b  1(a2),d2
                addq.b  #1,1(a2)
                cmpi.b  #$60,1(a2)
                blo.s   SKDEZGravHub_ApplyRiderPose
                move.b  #0,1(a2)

SKDEZGravHub_ApplyRiderPose:
                lsr.w   #2,d2
                move.b  SKDEZGravHub_RiderFrames(pc,d2.w),mapping_frame(a1)
                moveq   #0,d0
                move.b  mapping_frame(a1),d0
                jmp     (Perform_Player_DPLC).l
; ---------------------------------------------------------------------------
SKDEZGravHub_RiderFrames:
                dc.b    $34, $35, $36, $37, $38, $39, $3A, $3B, $3C, $31, $32, $33, $76, $77, $6C, $6D, $6E, $6F, $70, $71
                dc.b    $72, $73, $74, $75
                even
; ---------------------------------------------------------------------------

SKDEZGravHub_CheckDirectionOrDeparture:
                cmpi.b  #8,d0
                beq.s   SKDEZGravHub_CheckDepartureBounds
                and.b   subtype(a0),d1
                beq.s   SKDEZGravHub_TickHumAndAnimateRider
                move.b  #8,(a2)
                lea     (SKDEZGravHub_LaunchVelocityPairs-4).l,a3

; When several directions are allowed, the lowest pressed direction bit wins
SKDEZGravHub_LaunchInFirstDirection:
                addq.w  #4,a3
                lsr.b   #1,d1
                bcc.s   SKDEZGravHub_LaunchInFirstDirection
                move.w  (a3)+,x_vel(a1)
                move.w  (a3)+,y_vel(a1)
                move.b  #0,object_control(a1)
                bra.w   SKDEZGravHub_TickHumAndAnimateRider
; ---------------------------------------------------------------------------
SKDEZGravHub_LaunchVelocityPairs:
                dc.w    0, -$C00
                dc.w    0,  $C00
                dc.w    -$C00,     0
                dc.w    $C00,     0
; ---------------------------------------------------------------------------

SKDEZGravHub_CheckDepartureBounds:
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                addi.w  #$20,d0
                cmpi.w  #$40,d0
                bhs.s   SKDEZGravHub_ResetRiderState
                move.w  y_pos(a1),d1
                sub.w   y_pos(a0),d1
                addi.w  #$20,d1
                cmpi.w  #$40,d1
                blo.w   SKDEZGravHub_TickHumAndAnimateRider

SKDEZGravHub_ResetRiderState:
                move.w  #0,(a2)
                rts
; End of function UpdatePlayerInDezGravityHub
