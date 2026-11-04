; Owner: objects/zones/lrz/sk
; Responsibility: Wall-riding player contact, movement, character pose and release
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_LRZWallRide:
                move.b  #$D0,width_pixels(a0)
                move.l  #SKLRZWallRide_UpdateRidersAndCull,(a0)

SKLRZWallRide_UpdateRidersAndCull:
                bsr.s   UpdatePlayersOnLrzWallRide
                jmp     (Delete_Sprite_If_Not_In_Range).l

; =============== S U B R O U T I N E =======================================

UpdatePlayersOnLrzWallRide:
                lea     (Player_1).w,a1
                lea     $30(a0),a2
                moveq   #p1_standing_bit,d6
                bsr.s   UpdatePlayerOnLrzWallRide
                lea     (Player_2).w,a1
                lea     $34(a0),a2
; Bug: if player 1 was riding the object, then d6 may have become dirty from
; a call to Perform_Player_DPLC, causing player 2 to behave erratically
                addq.b  #p2_standing_bit-p1_standing_bit,d6
; End of function UpdatePlayersOnLrzWallRide

; =============== S U B R O U T I N E =======================================

UpdatePlayerOnLrzWallRide:
                btst    d6,status(a0)
                bne.w   SKLRZWallRide_CheckDebugExit
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                addi.w  #$10,d0
                cmpi.w  #$20,d0
                bhs.s   SKLRZWallRide_CaptureReturn
                move.w  y_pos(a1),d0
                sub.w   y_pos(a0),d0
                addi.w  #$10,d0
                cmpi.w  #$20,d0
                bhs.s   SKLRZWallRide_CaptureReturn
                btst    #0,status(a0)
                bne.s   SKLRZWallRide_CheckMirroredEntry
                tst.b   object_control(a1)
                bne.s   SKLRZWallRide_CaptureReturn
                btst    #Status_InAir,status(a1)
                bne.s   SKLRZWallRide_CaptureReturn
                tst.w   ground_vel(a1)
                bmi.w   SKLRZWallRide_CaptureReturn
                cmpi.w  #$400,ground_vel(a1)
                bge.w   SKLRZWallRide_CaptureForwardRider
                move.w  #$400,ground_vel(a1)

SKLRZWallRide_CaptureForwardRider:
                bsr.s   AttachPlayerToLrzWallRide
                move.l  #0,(a2)
                bclr    #Status_Facing,status(a1)
                andi.b  #$FC,render_flags(a1)
                move.b  #$43,object_control(a1)

SKLRZWallRide_CaptureReturn:
                rts
; ---------------------------------------------------------------------------

SKLRZWallRide_CheckMirroredEntry:
                tst.b   object_control(a1)
                bne.s   SKLRZWallRide_CaptureReturn
                btst    #Status_InAir,status(a1)
                bne.s   SKLRZWallRide_CaptureReturn
                tst.w   ground_vel(a1)
                bpl.w   SKLRZWallRide_CaptureReturn
                cmpi.w  #-$400,ground_vel(a1)
                ble.w   SKLRZWallRide_CaptureMirroredRider
                move.w  #-$400,ground_vel(a1)

SKLRZWallRide_CaptureMirroredRider:
                bsr.s   AttachPlayerToLrzWallRide
                move.l  #0,(a2)
                neg.w   ground_vel(a1)
                bset    #Status_Facing,status(a1)
                andi.b  #$FC,render_flags(a1)
                ori.b   #1,render_flags(a1)
                move.b  #$43,object_control(a1)
                rts
; End of function UpdatePlayerOnLrzWallRide

; =============== S U B R O U T I N E =======================================

AttachPlayerToLrzWallRide:
                btst    #Status_OnObj,status(a1)
                beq.s   SKLRZWallRide_InitRiderState
                movea.w interact(a1),a3
                bclr    d6,status(a3)

SKLRZWallRide_InitRiderState:
                move.w  a0,interact(a1)
                bset    d6,status(a0)
                move.w  #0,x_vel(a1)
                move.w  #0,y_vel(a1)
                move.b  default_y_radius(a1),y_radius(a1)
                move.b  default_x_radius(a1),x_radius(a1)
                andi.b  #$89,status(a1)
                bset    #Status_OnObj,status(a1)
                bset    #Status_InAir,status(a1)
                move.b  #0,jumping(a1)
                move.w  #0,(Chain_bonus_counter).w
                move.b  #0,angle(a1)
                move.b  #0,flip_angle(a1)
                move.b  #0,flip_type(a1)
                move.b  #0,flips_remaining(a1)
                move.b  #0,scroll_delay_counter(a1)
                move.b  #0,double_jump_flag(a1)
                move.b  #0,anim(a1)
                rts
; End of function AttachPlayerToLrzWallRide

; ---------------------------------------------------------------------------

SKLRZWallRide_CheckDebugExit:
                tst.w   (Debug_placement_mode).w
                beq.s   SKLRZWallRide_AdvanceCurveProgress

SKLRZWallRide_SelectExitState:
                andi.b  #$80,status(a1)
                bset    #Status_InAir,status(a1)
                btst    #Status_Facing,status(a0)
                bne.s   SKLRZWallRide_ReleaseAndSetExitSpeed
                bclr    #Status_InAir,status(a1)
                bset    #Status_Facing,status(a1)
                neg.w   ground_vel(a1)

SKLRZWallRide_ReleaseAndSetExitSpeed:
                bclr    d6,status(a0)
                move.w  #1,anim(a1)                     ; and prev_anim
                move.b  #0,object_control(a1)
                move.w  ground_vel(a1),x_vel(a1)
                move.w  #0,y_vel(a1)
                rts
; ---------------------------------------------------------------------------

SKLRZWallRide_AdvanceCurveProgress:
                move.w  ground_vel(a1),d0
                ext.l   d0
                lsl.l   #7,d0
                add.l   d0,(a2)
                bmi.s   SKLRZWallRide_SelectExitState
                cmpi.w  #$100,(a2)
                bhs.s   SKLRZWallRide_SelectExitState
                cmpi.w  #$1000,ground_vel(a1)
                bge.s   SKLRZWallRide_CalcCurveXAndYScale
                addi.w  #$10,ground_vel(a1)

; D2 starts with the player's old X, then is overwritten with the curve scale used in the X velocity subtraction
SKLRZWallRide_CalcCurveXAndYScale:
                move.w  x_pos(a1),d2
                move.w  (a2),d0
                lsr.w   #1,d0
                jsr     (GetSineCosine).l
                muls.w  #$A00,d0
                asl.l   #4,d0
                swap    d0
                move.w  #$165,d2
                btst    #0,status(a0)
                beq.s   SKLRZWallRide_ApplyCurveAndPose
                move.w  #$142,d2
                neg.w   d0

SKLRZWallRide_ApplyCurveAndPose:
                add.w   x_pos(a0),d0
                move.w  d0,x_pos(a1)
                sub.w   d2,d0
                asl.w   #8,d0
                move.w  d0,x_vel(a1)
                neg.w   d1
                addi.w  #$100,d1
                lsr.w   #1,d1
                mulu.w  d2,d1
                lsr.l   #8,d1
                move.w  d1,d0
                move.w  y_pos(a1),d2
                add.w   y_pos(a0),d0
                move.w  d0,y_pos(a1)
                sub.w   d2,d0
                asl.w   #8,d0
                move.w  d0,y_vel(a1)
                moveq   #0,d0
                move.w  (a2),d0
                lsr.w   #1,d0
                andi.w  #$FF,d0
                divu.w  #$16,d0
                move.b  SKLRZWallRide_RiderFrames(pc,d0.w),mapping_frame(a1)
                moveq   #0,d0
                move.b  mapping_frame(a1),d0
                jmp     (Perform_Player_DPLC).l
; ---------------------------------------------------------------------------
SKLRZWallRide_RiderFrames:
                dc.b    $EF, $DF, $E0, $E1, $E2, $E3, $F5, $F4, $F3, $F2, $F1, $F0
                even
