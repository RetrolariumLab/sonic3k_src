; Owner: objects/zones/lbz/s3
; Responsibility: Launch Base rolling drum movement, player collision and control
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_LBZRollingDrum:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  d0,$32(a0)
                neg.w   d0
                move.w  d0,$30(a0)
                move.b  #$80,width_pixels(a0)
                move.l  #S3LBZDrum_UpdateDrumRiders,(a0)

S3LBZDrum_UpdateDrumRiders:
                lea     (Player_1).w,a1
                lea     (_unkF7B0+2).w,a2
                moveq   #p1_standing_bit,d6
                bsr.s   UpdatePlayerOnLbzRollingDrum
                lea     (Player_2).w,a1
                lea     (_unkF7B0+3).w,a2
                addq.b  #p2_standing_bit-p1_standing_bit,d6
                bsr.s   UpdatePlayerOnLbzRollingDrum
                jmp     (Delete_Sprite_If_Not_In_Range).l

; =============== S U B R O U T I N E =======================================

UpdatePlayerOnLbzRollingDrum:
                btst    d6,status(a0)
                bne.w   S3LBZDrum_CheckRiderBounds
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                cmp.w   $30(a0),d0
                blt.s   S3LBZDrum_EntryReturn
                cmp.w   $32(a0),d0
                bge.s   S3LBZDrum_EntryReturn
                move.w  y_pos(a1),d0
                sub.w   y_pos(a0),d0
                addi.w  #$53,d0
                cmpi.w  #$A6,d0
                bhs.s   S3LBZDrum_EntryReturn
                cmpi.w  #$53,d0
                bhs.s   S3LBZDrum_CheckLowerEntrySpeed
                tst.w   y_vel(a1)
                bmi.s   S3LBZDrum_EntryReturn
                bra.s   S3LBZDrum_TrySeedTopEntryPhase
; ---------------------------------------------------------------------------

S3LBZDrum_CheckLowerEntrySpeed:
                cmpi.w  #$38,y_vel(a1)
                bgt.s   S3LBZDrum_EntryReturn

S3LBZDrum_TrySeedTopEntryPhase:
                cmpi.b  #6,routine(a1)
                bhs.s   S3LBZDrum_EntryReturn
                tst.w   (Debug_placement_mode).w
                bne.s   S3LBZDrum_EntryReturn
                cmpi.w  #8,d0
                bhs.s   S3LBZDrum_TrySeedBottomEntryPhase
                move.b  #$81,(a2)

S3LBZDrum_TrySeedBottomEntryPhase:
                cmpi.w  #$9E,d0
                blo.s   S3LBZDrum_AttachRiderAndSetPose
                move.b  #1,(a2)

S3LBZDrum_AttachRiderAndSetPose:
                jsr     (RideObject_SetRide).l
                move.b  #$80,flip_type(a1)
                move.w  #1,anim(a1)                     ; and prev_anim
                tst.w   ground_vel(a1)
                bne.s   S3LBZDrum_EntryReturn
                move.w  #1,ground_vel(a1)

S3LBZDrum_EntryReturn:
                rts
; ---------------------------------------------------------------------------

S3LBZDrum_CheckRiderBounds:
                btst    #Status_InAir,status(a1)
                bne.s   S3LBZDrum_TryPushDownAirborneRider
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                cmp.w   $30(a0),d0
                blt.s   S3LBZDrum_ReleaseRider
                cmp.w   $32(a0),d0
                blt.s   S3LBZDrum_ProjectAndAdvanceRider

S3LBZDrum_ReleaseRider:
                bclr    #Status_OnObj,status(a1)
                bclr    d6,status(a0)
                move.b  #0,flips_remaining(a1)
                move.b  #4,flip_speed(a1)
                bset    #Status_InAir,status(a1)
                rts
; ---------------------------------------------------------------------------

S3LBZDrum_TryPushDownAirborneRider:
                move.w  y_pos(a1),d0
                sub.w   y_pos(a0),d0
                bmi.s   S3LBZDrum_ReleaseRider
                move.w  #$400,y_vel(a1)
                bra.s   S3LBZDrum_ReleaseRider
; ---------------------------------------------------------------------------

S3LBZDrum_ProjectAndAdvanceRider:
                btst    #Status_OnObj,status(a1)
                beq.s   S3LBZDrum_EntryReturn
                move.b  (a2),d0
                jsr     (GetSineCosine).l
                moveq   #0,d2
                move.b  y_radius(a1),d2
                lsl.w   #8,d2
                addi.w  #$4000,d2
                muls.w  d2,d1
                swap    d1
                add.w   y_pos(a0),d1
                move.w  d1,y_pos(a1)
                move.b  (a2),d0
                addi.b  #$80,d0
                move.b  d0,flip_angle(a1)
                addq.b  #2,(a2)
                move.b  #$80,flip_type(a1)
                tst.w   ground_vel(a1)
                bne.s   S3LBZDrum_SetRiderDrawPriority
                move.w  #1,ground_vel(a1)
                move.b  #$81,flip_type(a1)

S3LBZDrum_SetRiderDrawPriority:
                bset    #7,art_tile(a1)
                tst.b   d0
                bpl.s   S3LBZDrum_RiderPoseReturn
                bclr    #7,art_tile(a1)

S3LBZDrum_RiderPoseReturn:
                rts
; End of function UpdatePlayerOnLbzRollingDrum
