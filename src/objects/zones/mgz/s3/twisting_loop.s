; Owner: objects/zones/mgz/s3
; Responsibility: Marble Garden twisting loop player capture, scripted rotation and release
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

Obj_MGZTwistingLoop:
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsl.w   #4,d0
                move.w  d0,$3A(a0)
                move.l  #S3MGZLoop_UpdateRidersAndCull,(a0)

S3MGZLoop_UpdateRidersAndCull:
                lea     (Player_1).w,a1
                lea     $30(a0),a2
                moveq   #p1_standing_bit,d6
                move.w  (Ctrl_1_logical).w,d5
                bsr.s   UpdatePlayerInMgzTwistingLoop
                jmp     (Delete_Sprite_If_Not_In_Range).l
; ---------------------------------------------------------------------------
; unused
                lea     (Player_2).w,a1
                lea     $36(a0),a2
                addq.b  #p2_standing_bit-p1_standing_bit,d6
                move.w  (Ctrl_2_logical).w,d5
                bsr.s   UpdatePlayerInMgzTwistingLoop
                jmp     (Delete_Sprite_If_Not_In_Range).l

; =============== S U B R O U T I N E =======================================

UpdatePlayerInMgzTwistingLoop:
                btst    d6,status(a0)
                bne.w   S3MGZLoop_PickReleaseOrOrbit
                tst.b   4(a2)
                beq.s   S3MGZLoop_TryEnterLoop
                subq.b  #1,4(a2)
                bne.s   S3MGZLoop_MoveReleasedRider
                bclr    #0,object_control(a1)

S3MGZLoop_MoveReleasedRider:
                move.w  x_vel(a1),d0
                ext.l   d0
                lsl.l   #8,d0
                add.l   d0,x_pos(a1)
                move.w  y_vel(a1),d0
                addi.w  #$38,y_vel(a1)
                ext.l   d0
                lsl.l   #8,d0
                add.l   d0,y_pos(a1)
                rts
; ---------------------------------------------------------------------------

S3MGZLoop_TryEnterLoop:
                moveq   #0,d1
                move.b  y_radius(a1),d1
                addi.w  #$24,d1
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                add.w   d1,d1
                cmp.w   d1,d0
                bhs.w   S3MGZLoop_EntryReturn
                move.w  y_pos(a1),d0
                sub.w   y_pos(a0),d0
                cmpi.w  #$20,d0
                bhs.s   S3MGZLoop_EntryReturn
                tst.b   object_control(a1)
                bne.s   S3MGZLoop_EntryReturn
                tst.w   (Debug_placement_mode).w
                bne.s   S3MGZLoop_EntryReturn
                btst    #Status_InAir,status(a1)
                bne.s   S3MGZLoop_EntryReturn
                move.b  angle(a1),d0
                andi.b  #$7F,d0
                cmpi.w  #$40,d0
                bne.s   S3MGZLoop_EntryReturn
                move.l  y_pos(a1),(a2)
                move.w  (a2),d0
                sub.w   y_pos(a0),d0
                move.w  d0,(a2)
                bsr.w   AttachPlayerToScriptedRideObject
                move.b  #$C0,angle(a1)
                bclr    #0,render_flags(a1)
                move.b  #$80,5(a2)
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                bcs.s   S3MGZLoop_SetInvertedRideFlags
                move.b  #$40,angle(a1)
                bset    #0,render_flags(a1)
                move.b  #0,5(a2)

S3MGZLoop_SetInvertedRideFlags:
                bset    #1,render_flags(a1)
                bset    #6,object_control(a1)
                bset    #1,object_control(a1)

S3MGZLoop_EntryReturn:
                rts
; ---------------------------------------------------------------------------

S3MGZLoop_PickReleaseOrOrbit:
                tst.w   (Debug_placement_mode).w
                bne.w   S3MGZLoop_AdjustExitAngle
                andi.w  #button_A_mask|button_B_mask|button_C_mask,d5
                beq.s   S3MGZLoop_EnforceNegativeMinSpeed
                move.b  #8,4(a2)
                bset    #0,object_control(a1)
                bset    #Status_InAir,status(a1)
                move.b  #0,jumping(a1)
                move.w  #-$800,x_vel(a1)
                move.w  #-$200,y_vel(a1)
                bset    #Status_Facing,status(a1)
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                bcs.w   S3MGZLoop_AdjustExitAngle
                neg.w   x_vel(a1)
                bclr    #Status_Facing,status(a1)
                bra.w   S3MGZLoop_AdjustExitAngle
; ---------------------------------------------------------------------------

S3MGZLoop_EnforceNegativeMinSpeed:
                move.w  ground_vel(a1),d0
                bpl.s   S3MGZLoop_EnforcePositiveMinSpeed
                neg.w   d0
                cmpi.w  #$400,d0
                bhs.s   S3MGZLoop_CheckExitYAndSpeed
                move.w  #-$400,ground_vel(a1)
                bra.s   S3MGZLoop_CheckExitYAndSpeed
; ---------------------------------------------------------------------------

S3MGZLoop_EnforcePositiveMinSpeed:
                cmpi.w  #$400,d0
                bhs.s   S3MGZLoop_CheckExitYAndSpeed
                move.w  #$400,ground_vel(a1)

S3MGZLoop_CheckExitYAndSpeed:
                move.w  y_pos(a1),d0
                sub.w   y_pos(a0),d0
                cmp.w   $3A(a0),d0
                blo.w   S3MGZLoop_ClampNegativeOrbitSpeed
                move.w  ground_vel(a1),d0
                bpl.s   S3MGZLoop_ClampPositiveExitSpeed
                neg.w   d0
                cmpi.w  #$C00,d0
                blo.s   S3MGZLoop_CalcExitX
                move.w  #-$C00,ground_vel(a1)
                move.w  #$C00,y_vel(a1)
                bra.s   S3MGZLoop_CalcExitX
; ---------------------------------------------------------------------------

S3MGZLoop_ClampPositiveExitSpeed:
                cmpi.w  #$C00,d0
                blo.s   S3MGZLoop_CalcExitX
                move.w  #$C00,ground_vel(a1)
                move.w  #$C00,y_vel(a1)

; Use the next progress candidate without storing it in the rider record
S3MGZLoop_CalcExitX:
                move.w  y_vel(a1),d0
                ext.l   d0
                lsl.l   #6,d0
                move.l  d0,d1
                add.l   d0,d0
                add.l   d1,d0
                add.l   (a2),d0
                swap    d0
                moveq   #0,d2
                mulu.w  #$155,d0
                lsr.l   #8,d0
                move.w  d0,d2
                add.b   5(a2),d0
                jsr     (GetSineCosine).l
                move.w  d1,d3
                asr.w   #3,d1
                add.w   x_pos(a0),d1
                moveq   #0,d0
                move.b  y_radius(a1),d0
                muls.w  d3,d0
                asr.w   #8,d0
                add.w   d0,d1
                move.w  d1,x_pos(a1)

S3MGZLoop_AdjustExitAngle:
                btst    #0,status(a0)
                beq.s   S3MGZLoop_ClearRideAndRestoreRadii
                addi.b  #$80,angle(a1)

S3MGZLoop_ClearRideAndRestoreRadii:
                bclr    #Status_Roll,status(a1)
                move.b  #$13,y_radius(a1)
                move.b  #9,x_radius(a1)
                move.w  #1,anim(a1)                     ; and prev_anim
                bclr    #Status_OnObj,status(a1)
                bclr    d6,status(a0)
                bclr    #6,object_control(a1)
                bclr    #1,object_control(a1)
                andi.w  #drawing_mask,art_tile(a1)
                rts
; ---------------------------------------------------------------------------

S3MGZLoop_ClampNegativeOrbitSpeed:
                move.w  ground_vel(a1),d0
                bpl.s   S3MGZLoop_ClampPositiveOrbitSpeed
                neg.w   d0
                cmpi.w  #$C00,d0
                blo.s   S3MGZLoop_UpdateOrbitAndDepth
                move.w  #-$C00,ground_vel(a1)
                move.w  #$C00,y_vel(a1)
                bra.s   S3MGZLoop_UpdateOrbitAndDepth
; ---------------------------------------------------------------------------

S3MGZLoop_ClampPositiveOrbitSpeed:
                cmpi.w  #$C00,d0
                blo.s   S3MGZLoop_UpdateOrbitAndDepth
                move.w  #$C00,ground_vel(a1)
                move.w  #$C00,y_vel(a1)

S3MGZLoop_UpdateOrbitAndDepth:
                move.w  y_vel(a1),d0
                ext.l   d0
                lsl.l   #6,d0
                move.l  d0,d1
                add.l   d0,d0
                add.l   d1,d0
                add.l   d0,(a2)
                moveq   #0,d0
                moveq   #0,d2
                move.w  (a2),d0
                mulu.w  #$155,d0
                lsr.l   #8,d0
                move.w  d0,d2
                add.b   5(a2),d0
                jsr     (GetSineCosine).l
                move.w  d1,d3
                asr.w   #3,d1
                add.w   x_pos(a0),d1
                moveq   #0,d0
                move.b  y_radius(a1),d0
                muls.w  d3,d0
                asr.w   #8,d0
                add.w   d0,d1
                move.w  d1,x_pos(a1)
                move.w  (a2),d0
                add.w   y_pos(a0),d0
                move.w  d0,y_pos(a1)
                moveq   #0,d0
                andi.w  #drawing_mask,art_tile(a1)
                cmpi.b  #$80,d2
                bhs.s   S3MGZLoop_PickOrbitFrameAndLoadArt
                ori.w   #high_priority,art_tile(a1)

S3MGZLoop_PickOrbitFrameAndLoadArt:
                subi.b  #$40,d2
                neg.b   d2
                andi.w  #$FF,d2
                divu.w  #$B,d2
                move.b  S3MGZLoop_OrbitFramesByPhase(pc,d2.w),mapping_frame(a1)
                moveq   #0,d0
                move.b  mapping_frame(a1),d0
                jmp     (Perform_Player_DPLC).l
; End of function UpdatePlayerInMgzTwistingLoop

; ---------------------------------------------------------------------------
; unused
                rts
; ---------------------------------------------------------------------------
S3MGZLoop_OrbitFramesByPhase:
                dc.b    $76, $76, $77, $77, $6C, $6C, $6D, $6D, $6E, $6E, $6F, $6F, $70, $70, $71, $71, $72, $72, $73, $73
                dc.b    $74, $74, $75, $75
                even
