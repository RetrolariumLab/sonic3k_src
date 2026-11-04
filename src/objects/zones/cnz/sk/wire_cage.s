; Owner: objects/zones/cnz/sk
; Responsibility: Carnival Night wire-cage player capture, spin, motion and release
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

Obj_CNZWireCage:
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsl.w   #3,d0
                move.w  d0,$38(a0)
                add.w   d0,d0
                move.w  d0,$3A(a0)
                moveq   #1,d1
                btst    #0,status(a0)
                bne.s   SKCNZCage_SetVerticalDriftAndStart
                neg.w   d1

SKCNZCage_SetVerticalDriftAndStart:
                move.w  d1,y_vel(a0)
                move.l  #SKCNZCage_UpdateBothRiders,(a0)

; Derive P2's standing bit from d6 as returned by the P1 update
SKCNZCage_UpdateBothRiders:
                lea     (Player_1).w,a1
                lea     $30(a0),a2
                moveq   #p1_standing_bit,d6
                move.w  (Ctrl_1_logical).w,d5
                bsr.s   UpdatePlayerOnCnzWireCage
                lea     (Player_2).w,a1
                lea     $34(a0),a2
; Bug: if player 1 was riding the object, then d6 may have become dirty from
; a call to Perform_Player_DPLC, causing player 2 to behave erratically
                addq.b  #p2_standing_bit-p1_standing_bit,d6
                move.w  (Ctrl_2_logical).w,d5
                bsr.s   UpdatePlayerOnCnzWireCage
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #$3F,d0
                bne.s   CNZWireCageSK_CullWireCageWithoutDrawing
                move.w  x_pos(a0),d0
                sub.w   (Camera_X_pos).w,d0
                addi.w  #$40,d0
                cmpi.w  #$1C0,d0
                bhs.s   CNZWireCageSK_CullWireCageWithoutDrawing
                move.w  y_pos(a1),d0
                sub.w   y_pos(a0),d0
                add.w   $38(a0),d0
                addi.w  #$40,d0
                move.w  $3A(a0),d1
                addi.w  #$80,d1
                cmp.w   d1,d0
                bhs.s   CNZWireCageSK_CullWireCageWithoutDrawing
                moveq   #signextendB(sfx_WaveHover),d0
                jsr     (Play_SFX).l

CNZWireCageSK_CullWireCageWithoutDrawing:
                jmp     (Delete_Sprite_If_Not_In_Range).l

; =============== S U B R O U T I N E =======================================

UpdatePlayerOnCnzWireCage:
                btst    d6,status(a0)
                bne.w   SKCNZCage_UpdateCapturedRider
                tst.b   1(a2)
                beq.s   SKCNZCage_CheckCaptureWindow
                subq.b  #1,1(a2)
                rts
; ---------------------------------------------------------------------------

SKCNZCage_CheckCaptureWindow:
                moveq   #0,d1
                move.b  y_radius(a1),d1
                addi.w  #$44,d1
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                add.w   d1,d1
                cmp.w   d1,d0
                bhs.w   CNZWireCageSK_ReturnAfterCageCaptureGate
                move.w  y_pos(a1),d0
                sub.w   y_pos(a0),d0
                add.w   $38(a0),d0
                cmp.w   $3A(a0),d0
                bhs.w   CNZWireCageSK_ReturnAfterCageCaptureGate
                tst.b   object_control(a1)
                bne.w   CNZWireCageSK_ReturnAfterCageCaptureGate
                tst.w   (Debug_placement_mode).w
                bne.w   CNZWireCageSK_ReturnAfterCageCaptureGate
                subi.w  #$10,d0
                bcc.s   SKCNZCage_SelectCaptureMode
                sub.w   d0,y_pos(a1)

SKCNZCage_SelectCaptureMode:
                btst    #Status_InAir,status(a1)
                beq.w   SKCNZCage_AttachAndSetSidePhase
                tst.b   angle(a1)
                beq.s   SKCNZCage_LatchPassiveMode
                bclr    #Status_InAir,status(a1)
                move.w  ground_vel(a1),d0
                bpl.s   SKCNZCage_CheckAirEntrySpeed
                neg.w   d0

SKCNZCage_CheckAirEntrySpeed:
                cmpi.w  #$400,d0
                bhs.s   SKCNZCage_AttachAndSetSidePhase
                bset    #Status_InAir,status(a1)

SKCNZCage_LatchPassiveMode:
                move.b  #1,1(a2)
                bset    #0,object_control(a1)

SKCNZCage_AttachAndSetSidePhase:
                bsr.w   AttachPlayerToScriptedRideObject
                move.b  #$80,(a2)
                move.b  #-$40,angle(a1)
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                bcs.s   SKCNZCage_SetRiderFlags
                move.b  #$40,angle(a1)
                move.b  #0,(a2)

SKCNZCage_SetRiderFlags:
                bclr    #Status_Facing,status(a1)
                bclr    #0,render_flags(a1)
                bclr    #1,render_flags(a1)
                bset    #6,object_control(a1)
                bset    #1,object_control(a1)
                move.b  #0,anim(a1)

CNZWireCageSK_ReturnAfterCageCaptureGate:
                rts
; ---------------------------------------------------------------------------

SKCNZCage_UpdateCapturedRider:
                tst.b   1(a2)
                bne.w   SKCNZCage_UpdatePassiveRider
                tst.w   (Debug_placement_mode).w
                bne.s   SKCNZCage_ReleaseActiveRider
                move.w  ground_vel(a1),d0
                bpl.s   SKCNZCage_TrySlowRiderToPassive
                neg.w   d0

SKCNZCage_TrySlowRiderToPassive:
                cmpi.w  #$300,d0
                bhs.s   SKCNZCage_TryLaunchActiveRider
                move.b  #1,1(a2)
                bset    #0,object_control(a1)
                bra.w   SKCNZCage_UpdatePassiveRider
; ---------------------------------------------------------------------------

SKCNZCage_TryLaunchActiveRider:
                btst    #Status_InAir,status(a1)
                beq.s   SKCNZCage_CheckActiveRideHeight
                move.w  #-$800,x_vel(a1)
                move.w  #-$200,y_vel(a1)
                bset    #Status_Facing,status(a1)
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                bcs.s   SKCNZCage_ReleaseActiveRider
                neg.w   x_vel(a1)
                bclr    #Status_Facing,status(a1)
                bra.s   SKCNZCage_ReleaseActiveRider
; ---------------------------------------------------------------------------

SKCNZCage_CheckActiveRideHeight:
                move.w  y_pos(a1),d0
                sub.w   y_pos(a0),d0
                add.w   $38(a0),d0
                cmp.w   $3A(a0),d0
                blo.s   SKCNZCage_TryDriftActiveRider

SKCNZCage_ReleaseActiveRider:
                move.b  #0,angle(a1)
                bclr    #Status_Roll,status(a1)
                move.b  #$13,y_radius(a1)
                move.b  #9,x_radius(a1)
                move.w  #1,anim(a1)                     ; and prev_anim
                bclr    #Status_OnObj,status(a1)
                bclr    d6,status(a0)
                bclr    #6,object_control(a1)
                bclr    #1,object_control(a1)
                andi.w  #drawing_mask,art_tile(a1)
                move.b  #$10,1(a2)
                rts
; ---------------------------------------------------------------------------

SKCNZCage_TryDriftActiveRider:
                move.w  y_vel(a0),d1
                bpl.s   SKCNZCage_DriftActiveY
                cmpi.w  #$10,d0
                bls.s   SKCNZCage_KeepActiveBelowTop

SKCNZCage_DriftActiveY:
                add.w   d1,y_pos(a1)

SKCNZCage_KeepActiveBelowTop:
                subi.w  #$10,d0
                bcc.s   SKCNZCage_ProjectActiveRiderX
                sub.w   d0,y_pos(a1)

SKCNZCage_ProjectActiveRiderX:
                moveq   #0,d0
                move.b  (a2),d0
                addq.b  #4,(a2)
                jsr     (GetSineCosine).l
                move.w  d1,d3
                asr.w   #2,d1
                add.w   x_pos(a0),d1
                moveq   #0,d0
                move.b  y_radius(a1),d0
                muls.w  d3,d0
                asr.w   #8,d0
                add.w   d0,d1
                move.w  d1,x_pos(a1)
                moveq   #0,d0
                move.b  (a2),d0
                andi.w  #drawing_mask,art_tile(a1)
                cmpi.b  #$80,d0
                blo.s   SKCNZCage_ApplyActivePose
                ori.w   #high_priority,art_tile(a1)

SKCNZCage_ApplyActivePose:
                addi.b  #$40,d0
                neg.b   d0
                andi.w  #$FF,d0
                divu.w  #$B,d0
                move.b  SKCNZCage_ActivePoseFrames(pc,d0.w),mapping_frame(a1)
                moveq   #0,d0
                move.b  mapping_frame(a1),d0
                jmp     (Perform_Player_DPLC).l
; ---------------------------------------------------------------------------
; unused
                rts
; ---------------------------------------------------------------------------
SKCNZCage_ActivePoseFrames:
                dc.b    $76, $76, $77, $77, $6C, $6C, $6D, $6D, $6E, $6E, $6F, $6F, $70, $70, $71, $71, $72, $72, $73, $73
                dc.b    $74, $74, $75, $75
                even
; ---------------------------------------------------------------------------

SKCNZCage_UpdatePassiveRider:
                tst.w   (Debug_placement_mode).w
                bne.s   SKCNZCage_ReleasePassiveRider
                andi.w  #button_A_mask|button_B_mask|button_C_mask,d5
                beq.s   SKCNZCage_TryPassiveBottomExit
                bset    #Status_InAir,status(a1)
                move.b  #0,jumping(a1)
                move.w  #-$800,x_vel(a1)
                move.w  #-$200,y_vel(a1)
                bset    #Status_Facing,status(a1)
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                bcs.s   SKCNZCage_ReleasePassiveRider
                neg.w   x_vel(a1)
                bclr    #Status_Facing,status(a1)
                bra.s   SKCNZCage_ReleasePassiveRider
; ---------------------------------------------------------------------------

SKCNZCage_TryPassiveBottomExit:
                btst    #Status_InAir,status(a1)
                bne.s   SKCNZCage_ReleasePassiveRider
                move.w  y_pos(a1),d0
                sub.w   y_pos(a0),d0
                add.w   $38(a0),d0
                cmp.w   $3A(a0),d0
                blo.s   SKCNZCage_TryDriftPassiveRider
                bne.s   SKCNZCage_ReleasePassiveRider
                move.b  (a2),d0
                andi.b  #$7F,d0
                bne.s   SKCNZCage_ProjectPassiveRiderX
                move.w  #-$100,x_vel(a1)
                move.w  #0,y_vel(a1)
                tst.b   (a2)
                bmi.s   SKCNZCage_SetPassiveExitSpeed
                neg.w   x_vel(a1)

SKCNZCage_SetPassiveExitSpeed:
                move.w  x_vel(a1),ground_vel(a1)
                bset    #Status_InAir,status(a1)

SKCNZCage_ReleasePassiveRider:
                move.b  #0,angle(a1)
                bclr    #Status_Roll,status(a1)
                move.b  #$13,y_radius(a1)
                move.b  #9,x_radius(a1)
                move.w  #1,anim(a1)                     ; and prev_anim
                bclr    #Status_OnObj,status(a1)
                bclr    d6,status(a0)
                bclr    #6,object_control(a1)
                bclr    #1,object_control(a1)
                bclr    #0,object_control(a1)
                andi.w  #drawing_mask,art_tile(a1)
                move.b  #$10,1(a2)
                rts
; ---------------------------------------------------------------------------

SKCNZCage_TryDriftPassiveRider:
                move.w  y_vel(a0),d1
                bpl.s   SKCNZCage_DriftPassiveY
                cmpi.w  #$10,d0
                bls.s   SKCNZCage_ProjectPassiveRiderX

SKCNZCage_DriftPassiveY:
                add.w   d1,y_pos(a1)

SKCNZCage_ProjectPassiveRiderX:
                moveq   #0,d0
                move.b  (a2),d0
                addq.b  #4,(a2)
                jsr     (GetSineCosine).l
                move.w  d1,d3
                asr.w   #2,d1
                add.w   x_pos(a0),d1
                moveq   #0,d0
                move.b  y_radius(a1),d0
                muls.w  d3,d0
                asr.w   #8,d0
                add.w   d0,d1
                move.w  d1,x_pos(a1)
                moveq   #0,d0
                move.b  (a2),d0
                andi.w  #drawing_mask,art_tile(a1)
                cmpi.b  #$80,d0
                blo.s   SKCNZCage_ApplyPassivePose
                ori.w   #high_priority,art_tile(a1)

SKCNZCage_ApplyPassivePose:
                addi.b  #$40,d0
                neg.b   d0
                andi.w  #$FF,d0
                divu.w  #$B,d0
                move.b  SKCNZCage_PassivePoseFrames(pc,d0.w),mapping_frame(a1)
                move.b  #0,anim(a1)
                moveq   #0,d0
                move.b  mapping_frame(a1),d0
                jmp     (Perform_Player_DPLC).l
; End of function UpdatePlayerOnCnzWireCage

; ---------------------------------------------------------------------------
; unused
                rts
; ---------------------------------------------------------------------------
SKCNZCage_PassivePoseFrames:
                dc.b    $5E, $5E, $5E, $5F, $5F, $5F, $5F, $60, $60, $60, $60, $60, $61, $61, $61, $61, $5C, $5C, $5C, $5C
                dc.b    $5D, $5D, $5D, $5D
                even

; =============== S U B R O U T I N E =======================================

AttachPlayerToScriptedRideObject:
                btst    #Status_OnObj,status(a1)
                beq.s   SKCNZCage_SetInteractionAndLand
                movea.w interact(a1),a3
                bclr    d6,status(a3)

SKCNZCage_SetInteractionAndLand:
                move.w  a0,interact(a1)
                btst    #Status_InAir,status(a1)
                beq.s   SKCNZCage_SetStandingFlags
                move.w  #0,x_vel(a1)
                move.l  a0,-(sp)
                movea.l a1,a0
                jsr     (Player_TouchFloor).l
                movea.l (sp)+,a0

SKCNZCage_SetStandingFlags:
                bset    #Status_OnObj,status(a1)
                bclr    #Status_InAir,status(a1)
                bset    d6,status(a0)
                rts
; End of function AttachPlayerToScriptedRideObject
