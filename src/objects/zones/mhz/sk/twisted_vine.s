; Owner: objects/zones/mhz/sk
; Responsibility: Twisted vine player capture, path traversal, character pose and release
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_MHZTwistedVine:
                move.b  #$D0,width_pixels(a0)
                btst    #0,status(a0)
                beq.s   SKMHZTwistVine_StartOrdinaryVine
                move.l  #SKMHZTwistVine_UpdateInvertedRiders,(a0)
                bra.w   SKMHZTwistVine_UpdateInvertedRiders
; ---------------------------------------------------------------------------

SKMHZTwistVine_StartOrdinaryVine:
                move.l  #SKMHZTwistVine_UpdateOrdinaryRiders,(a0)

SKMHZTwistVine_UpdateOrdinaryRiders:
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d6
                bsr.s   UpdatePlayerOnMhzTwistedVine
                lea     (Player_2).w,a1
                addq.b  #p2_standing_bit-p1_standing_bit,d6
                bsr.s   UpdatePlayerOnMhzTwistedVine
                jmp     (Delete_Sprite_If_Not_In_Range).l

; =============== S U B R O U T I N E =======================================

UpdatePlayerOnMhzTwistedVine:
                btst    d6,status(a0)
                bne.w   SKMHZTwistVine_GetOrdinaryAbsSpeed
                btst    #Status_InAir,status(a1)
                bne.w   SKMHZTwistVine_OrdinaryRideReturn
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                tst.w   x_vel(a1)
                beq.w   SKMHZTwistVine_OrdinaryRideReturn
                bmi.s   SKMHZTwistVine_TryCaptureFromRight
                cmpi.w  #-$30,d0
                bgt.w   SKMHZTwistVine_OrdinaryRideReturn
                cmpi.w  #-$40,d0
                blt.w   SKMHZTwistVine_OrdinaryRideReturn
                move.w  y_pos(a1),d1
                sub.w   y_pos(a0),d1
                addi.w  #$30,d1
                cmpi.w  #$20,d1
                bhs.w   SKMHZTwistVine_OrdinaryRideReturn
                tst.b   object_control(a1)
                bne.s   SKMHZTwistVine_OrdinaryRideReturn
                bclr    #0,status(a1)
                jsr     (RideObject_SetRide).l
                move.b  #$80,flip_type(a1)
                move.w  #20,move_lock(a1)
                move.w  ground_vel(a1),d0
                cmpi.w  #$600,d0
                bhs.s   SKMHZTwistVine_OrdinaryRideReturn
                move.w  #$600,ground_vel(a1)
                rts
; ---------------------------------------------------------------------------

SKMHZTwistVine_TryCaptureFromRight:
                cmpi.w  #$30,d0
                blt.s   SKMHZTwistVine_OrdinaryRideReturn
                cmpi.w  #$40,d0
                bgt.s   SKMHZTwistVine_OrdinaryRideReturn
                move.w  y_pos(a1),d1
                sub.w   y_pos(a0),d1
                subi.w  #$10,d1
                cmpi.w  #$20,d1
                bhs.s   SKMHZTwistVine_OrdinaryRideReturn
                tst.b   object_control(a1)
                bne.s   SKMHZTwistVine_OrdinaryRideReturn
                bset    #Status_Facing,status(a1)
                jsr     (RideObject_SetRide).l
                move.b  #$80,flip_angle(a1)
                move.b  #$80,flip_type(a1)
                move.w  ground_vel(a1),d0
                neg.w   d0
                cmpi.w  #$600,d0
                bhs.s   SKMHZTwistVine_OrdinaryRideReturn
                move.w  #-$600,ground_vel(a1)
                move.w  #20,move_lock(a1)

SKMHZTwistVine_OrdinaryRideReturn:
                rts
; ---------------------------------------------------------------------------

SKMHZTwistVine_GetOrdinaryAbsSpeed:
                move.w  ground_vel(a1),d0
                bpl.s   SKMHZTwistVine_CheckOrdinaryRide
                neg.w   d0

SKMHZTwistVine_CheckOrdinaryRide:
                cmpi.w  #$500,d0
                blo.s   SKMHZTwistVine_ClearOrdinarySlowFlip
                btst    #Status_InAir,status(a1)
                bne.s   SKMHZTwistVine_ReleaseOrdinaryRider
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                addi.w  #$40,d0
                bmi.s   SKMHZTwistVine_ReleaseOrdinaryLeftEnd
                cmpi.w  #$80,d0
                blo.s   SKMHZTwistVine_ProjectOrdinaryRider
                bclr    #Status_OnObj,status(a1)
                bclr    d6,status(a0)
                move.b  #$80,angle(a1)
                move.b  #0,flip_angle(a1)
                move.b  #0,flip_type(a1)
                neg.w   ground_vel(a1)
                neg.w   x_vel(a1)
                bset    #0,status(a1)
                rts
; ---------------------------------------------------------------------------

SKMHZTwistVine_ReleaseOrdinaryLeftEnd:
                bclr    #Status_OnObj,status(a1)
                bclr    d6,status(a0)
                move.b  #0,angle(a1)
                move.b  #0,flip_angle(a1)
                move.b  #0,flip_type(a1)
                rts
; ---------------------------------------------------------------------------

SKMHZTwistVine_ClearOrdinarySlowFlip:
                move.b  #0,flip_angle(a1)

SKMHZTwistVine_ReleaseOrdinaryRider:
                bclr    #Status_OnObj,status(a1)
                bclr    d6,status(a0)
                move.b  #0,flips_remaining(a1)
                move.b  #4,flip_speed(a1)
                move.b  #0,flip_type(a1)
                rts
; ---------------------------------------------------------------------------

SKMHZTwistVine_ProjectOrdinaryRider:
                btst    #Status_OnObj,status(a1)
                beq.w   SKMHZTwistVine_OrdinaryRideReturn
                move.w  d0,d2
                addi.b  #$80,d0
                jsr     (GetSineCosine).l
                move.w  d1,d3
                asr.w   #4,d1
                add.w   y_pos(a0),d1
                moveq   #0,d0
                move.b  y_radius(a1),d0
                muls.w  d3,d0
                asr.w   #8,d0
                add.w   d0,d1
                move.w  d1,y_pos(a1)
                move.b  d2,flip_angle(a1)
                rts
; End of function UpdatePlayerOnMhzTwistedVine

; ---------------------------------------------------------------------------

SKMHZTwistVine_UpdateInvertedRiders:
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d6
                bsr.s   UpdatePlayerOnMhzInvertedTwistedVine
                lea     (Player_2).w,a1
                addq.b  #p2_standing_bit-p1_standing_bit,d6
                bsr.s   UpdatePlayerOnMhzInvertedTwistedVine
                jmp     (Delete_Sprite_If_Not_In_Range).l

; =============== S U B R O U T I N E =======================================

UpdatePlayerOnMhzInvertedTwistedVine:
                btst    d6,status(a0)
                bne.w   SKMHZTwistVine_GetInvertedAbsSpeed
                btst    #Status_InAir,status(a1)
                bne.w   SKMHZTwistVine_InvertedRideReturn
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                tst.w   x_vel(a1)
                beq.w   SKMHZTwistVine_InvertedRideReturn
                bpl.s   SKMHZTwistVine_TryCaptureFromLeft
                cmpi.w  #$30,d0
                blt.s   SKMHZTwistVine_InvertedRideReturn
                cmpi.w  #$40,d0
                bgt.s   SKMHZTwistVine_InvertedRideReturn
                move.w  y_pos(a1),d1
                sub.w   y_pos(a0),d1
                addi.w  #$30,d1
                cmpi.w  #$20,d1
                bhs.s   SKMHZTwistVine_InvertedRideReturn
                tst.b   object_control(a1)
                bne.s   SKMHZTwistVine_InvertedRideReturn
                bset    #Status_Facing,status(a1)
                jsr     (RideObject_SetRide).l
                move.b  #$84,flip_type(a1)
                move.w  #20,move_lock(a1)
                move.w  ground_vel(a1),d0
                neg.w   d0
                cmpi.w  #$600,d0
                bhs.s   SKMHZTwistVine_InvertedRideReturn
                move.w  #-$600,ground_vel(a1)

SKMHZTwistVine_InvertedRideReturn:
                rts
; ---------------------------------------------------------------------------

SKMHZTwistVine_TryCaptureFromLeft:
                cmpi.w  #-$30,d0
                bgt.s   SKMHZTwistVine_InvertedRideReturn
                cmpi.w  #-$40,d0
                blt.s   SKMHZTwistVine_InvertedRideReturn
                move.w  y_pos(a1),d1
                sub.w   y_pos(a0),d1
                subi.w  #$10,d1
                cmpi.w  #$20,d1
                bhs.s   SKMHZTwistVine_InvertedRideReturn
                tst.b   object_control(a1)
                bne.s   SKMHZTwistVine_InvertedRideReturn
                bclr    #Status_Facing,status(a1)
                jsr     (RideObject_SetRide).l
                move.b  #$80,flip_angle(a1)
                move.b  #$84,flip_type(a1)
                move.w  ground_vel(a1),d0
                cmpi.w  #$600,d0
                bhs.s   SKMHZTwistVine_InvertedRideReturn
                move.w  #$600,ground_vel(a1)
                move.w  #20,move_lock(a1)
                rts
; ---------------------------------------------------------------------------

SKMHZTwistVine_GetInvertedAbsSpeed:
                move.w  ground_vel(a1),d0
                bpl.s   SKMHZTwistVine_CheckInvertedRide
                neg.w   d0

SKMHZTwistVine_CheckInvertedRide:
                cmpi.w  #$500,d0
                blo.s   SKMHZTwistVine_ClearInvertedSlowFlip
                btst    #Status_InAir,status(a1)
                bne.s   SKMHZTwistVine_ReleaseInvertedRider
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                addi.w  #$40,d0
                bmi.s   SKMHZTwistVine_ReflectInvertedLeftExit
                cmpi.w  #$80,d0
                blo.w   SKMHZTwistVine_ProjectInvertedRider
                bclr    #Status_OnObj,status(a1)
                bclr    d6,status(a0)
                move.b  #0,angle(a1)
                move.b  #0,flip_angle(a1)
                move.b  #0,flip_type(a1)
                rts
; ---------------------------------------------------------------------------

SKMHZTwistVine_ReflectInvertedLeftExit:
                bclr    #Status_OnObj,status(a1)
                bclr    d6,status(a0)
                move.b  #$80,angle(a1)
                move.b  #0,flip_angle(a1)
                move.b  #0,flip_type(a1)
                neg.w   ground_vel(a1)
                neg.w   x_vel(a1)
                bclr    #Status_Facing,status(a1)
                rts
; ---------------------------------------------------------------------------

SKMHZTwistVine_ClearInvertedSlowFlip:
                move.b  #0,flip_angle(a1)

SKMHZTwistVine_ReleaseInvertedRider:
                bclr    #Status_OnObj,status(a1)
                bclr    d6,status(a0)
                move.b  #0,flips_remaining(a1)
                move.b  #4,flip_speed(a1)
                move.b  #0,flip_type(a1)
                rts
; ---------------------------------------------------------------------------

SKMHZTwistVine_ProjectInvertedRider:
                btst    #Status_OnObj,status(a1)
                beq.w   SKMHZTwistVine_InvertedRideReturn
                move.w  d0,d2
                jsr     (GetSineCosine).l
                move.w  d1,d3
                asr.w   #4,d1
                add.w   y_pos(a0),d1
                moveq   #0,d0
                move.b  y_radius(a1),d0
                muls.w  d3,d0
                asr.w   #8,d0
                add.w   d0,d1
                move.w  d1,y_pos(a1)
                subi.b  #$80,d2
                neg.b   d2
                move.b  d2,flip_angle(a1)
                rts
; End of function UpdatePlayerOnMhzInvertedTwistedVine
