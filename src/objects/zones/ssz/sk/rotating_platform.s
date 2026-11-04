; Owner: objects/zones/ssz/sk
; Responsibility: Rotating platform movement, player riding and collision
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

Obj_SSZRotatingPlatform:
                move.l  #SKSSZRotatePost_CullAndSignalLowerRide,(a0)
                move.b  #4,render_flags(a0)
                move.b  #$20,height_pixels(a0)
                move.b  #$C,width_pixels(a0)
                move.w  #$100,priority(a0)
                move.w  #make_art_tile(ArtTile_SSZMisc+$AA,2,0),art_tile(a0)
                move.l  #Map_SSZRotatingPlatform,mappings(a0)
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   SKSSZRotatePost_CullAndSignalLowerRide
                move.w  a1,$32(a0)
                move.l  #SKSSZLowerRide_InitLowerSurface,(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.b  subtype(a0),subtype(a1)

SKSSZRotatePost_CullAndSignalLowerRide:
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bls.s   SKSSZRotatePost_AnimateAndUpdateRiders
                move.w  $32(a0),d0
                beq.s   SKSSZRotatePost_ClearPlacementRespawn
                movea.w d0,a1
                st      routine(a1)

SKSSZRotatePost_ClearPlacementRespawn:
                move.w  respawn_addr(a0),d0
                beq.s   SKSSZRotatePost_DeletePost
                movea.w d0,a1
                bclr    #7,(a1)

SKSSZRotatePost_DeletePost:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

SKSSZRotatePost_AnimateAndUpdateRiders:
                lea     Ani_SSZRotatingPlatform(pc),a1
                jsr     (Animate_Sprite).l
                moveq   #$10,d1
                moveq   #$21,d2
                moveq   #$21,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectTop).l
                lea     (Player_1).w,a1
                lea     (Ctrl_1_logical).w,a2
                lea     $2E(a0),a3
                moveq   #p1_standing_bit,d6
                bsr.s   UpdatePlayerOnSszRotatingPost
                lea     (Player_2).w,a1
                lea     (Ctrl_2_logical).w,a2
                lea     $30(a0),a3
                moveq   #p2_standing_bit,d6
                bsr.s   UpdatePlayerOnSszRotatingPost
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

UpdatePlayerOnSszRotatingPost:
                tst.b   (a3)
                bne.s   SKSSZRotatePost_CheckPendingCapture
                btst    d6,status(a0)
                beq.w   SKSSZRotatePost_RiderUpdateReturn
                move.w  #$100,(a3)
                bra.w   SKSSZRotatePost_RiderUpdateReturn
; ---------------------------------------------------------------------------

SKSSZRotatePost_CheckPendingCapture:
                tst.b   (a3)
                bmi.s   SKSSZRotatePost_HoldRiderOrJump
                btst    d6,status(a0)
                bne.s   SKSSZRotatePost_HoldRiderOrJump
                clr.b   (a3)
                bra.s   SKSSZRotatePost_RiderUpdateReturn
; ---------------------------------------------------------------------------

SKSSZRotatePost_HoldRiderOrJump:
                st      (a3)
                clr.w   x_vel(a1)
                clr.w   ground_vel(a1)
                clr.b   $3D(a1)
                clr.b   anim(a1)
                bclr    #Status_Roll,status(a1)
                move.b  #3,object_control(a1)
                move.w  (a2),d0
                andi.w  #button_A_mask|button_B_mask|button_C_mask,d0
                beq.s   SKSSZRotatePost_SelectCenteringStep
                clr.b   (a3)
                move.w  #-$680,y_vel(a1)
                clr.b   object_control(a1)
                bset    #Status_Roll,status(a1)
                bset    #Status_InAir,status(a1)
                move.b  #1,jumping(a1)
                move.b  #2,anim(a1)
                move.b  #$E,y_radius(a1)
                move.b  #7,x_radius(a1)
                moveq   #signextendB(sfx_Jump),d0
                jmp     (Play_SFX).l
; ---------------------------------------------------------------------------

SKSSZRotatePost_SelectCenteringStep:
                moveq   #1,d1
                move.w  x_pos(a1),d0
                cmp.w   x_pos(a0),d0
                beq.s   SKSSZRotatePost_StepRiderPose
                bmi.s   SKSSZRotatePost_ApplyCenteringStep
                neg.w   d1

SKSSZRotatePost_ApplyCenteringStep:
                add.w   d1,x_pos(a1)

SKSSZRotatePost_StepRiderPose:
                addq.b  #2,1(a3)
                move.b  1(a3),d0
                jmp     SKSSZRotatingRide_ApplyRiderPose(pc)
; ---------------------------------------------------------------------------

SKSSZRotatePost_RiderUpdateReturn:
                rts
; ---------------------------------------------------------------------------

SKSSZLowerRide_InitLowerSurface:
                move.l  #SKSSZLowerRide_CheckDeleteSignal,(a0)
                addi.w  #$30,y_pos(a0)
                moveq   #$60,d0
                btst    #0,subtype(a0)
                beq.s   SKSSZLowerRide_SetSurfaceHalfWidth
                move.w  #$A0,d0

SKSSZLowerRide_SetSurfaceHalfWidth:
                move.b  d0,width_pixels(a0)

SKSSZLowerRide_CheckDeleteSignal:
                tst.b   routine(a0)
                beq.s   SKSSZLowerRide_CheckSolidAndUpdateRiders
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

SKSSZLowerRide_CheckSolidAndUpdateRiders:
                moveq   #$B,d1
                add.b   width_pixels(a0),d1
                moveq   #$11,d2
                moveq   #$11,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectTop).l
                lea     (Player_1).w,a1
                lea     (Ctrl_1_logical).w,a2
                lea     $2E(a0),a3
                lea     $34(a0),a4
                moveq   #p1_standing_bit,d6
                bsr.s   SKSSZLowerRide_CheckCaptureOrPriority
                lea     (Player_2).w,a1
                lea     (Ctrl_2_logical).w,a2
                lea     $34(a0),a3
                lea     $2E(a0),a4
                moveq   #p2_standing_bit,d6

SKSSZLowerRide_CheckCaptureOrPriority:
                tst.b   (a3)
                bne.s   SKSSZLowerRide_CheckPendingCapture
                btst    d6,status(a0)
                bne.s   SKSSZLowerRide_CaptureRiderRadius
                tst.b   1(a3)
                beq.s   SKSSZLowerRide_CaptureReturn
                move.w  y_pos(a0),d0
                subi.w  #$64,d0
                cmp.w   y_pos(a1),d0
                bhs.s   SKSSZLowerRide_ResetReleasedPriority
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                addi.w  #$B,d1
                add.w   d1,d0
                add.w   d1,d1
                cmp.w   d1,d0
                blo.s   SKSSZLowerRide_CaptureReturn

SKSSZLowerRide_ResetReleasedPriority:
                clr.b   1(a3)
                move.w  #$100,priority(a1)

SKSSZLowerRide_CaptureReturn:
                rts
; ---------------------------------------------------------------------------

SKSSZLowerRide_CaptureRiderRadius:
                move.w  #$1FF,(a3)
                moveq   #0,d1
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                bpl.s   SKSSZLowerRide_StoreRadiusAndPhase
                neg.w   d0
                moveq   #-$80,d1

SKSSZLowerRide_StoreRadiusAndPhase:
                move.w  d0,4(a3)
                move.b  d1,2(a3)
                rts
; ---------------------------------------------------------------------------

SKSSZLowerRide_CheckPendingCapture:
                tst.b   (a3)
                bmi.s   SKSSZLowerRide_HoldRiderOrJump
                btst    d6,status(a0)
                bne.s   SKSSZLowerRide_HoldRiderOrJump
                clr.b   (a3)
                rts
; ---------------------------------------------------------------------------

SKSSZLowerRide_HoldRiderOrJump:
                st      (a3)
                clr.w   x_vel(a1)
                clr.w   ground_vel(a1)
                clr.b   spin_dash_flag(a1)
                clr.b   anim(a1)
                bclr    #Status_Roll,status(a1)
                move.b  #3,object_control(a1)
                move.w  (a2),d0
                andi.w  #button_A_mask|button_B_mask|button_C_mask,d0
                beq.s   SKSSZLowerRide_StepPhaseAndGrowRadius
                clr.b   (a3)
                move.w  #-$680,y_vel(a1)
                clr.b   object_control(a1)
                bset    #Status_Roll,status(a1)
                bset    #Status_InAir,status(a1)
                move.b  #1,jumping(a1)
                move.b  #2,anim(a1)
                move.b  #$E,y_radius(a1)
                move.b  #7,x_radius(a1)
                moveq   #signextendB(sfx_Jump),d0
                jmp     (Play_SFX).l
; ---------------------------------------------------------------------------

SKSSZLowerRide_StepPhaseAndGrowRadius:
                addq.b  #2,2(a3)
                cmpi.w  #$14,4(a3)
                bhs.s   SKSSZLowerRide_SelectRearPriority
                addq.w  #1,4(a3)

SKSSZLowerRide_SelectRearPriority:
                move.b  2(a3),d0
                cmpi.b  #$80,d0
                blo.s   SKSSZLowerRide_SelectFrontPriority
                move.w  #$180,d1
                tst.b   (a4)
                beq.s   SKSSZLowerRide_PlaceRiderOnOrbit
                move.w  4(a4),d2
                cmp.w   4(a3),d2
                bhs.s   SKSSZLowerRide_PlaceRiderOnOrbit
                move.w  #$200,d1
                bra.s   SKSSZLowerRide_PlaceRiderOnOrbit
; ---------------------------------------------------------------------------

SKSSZLowerRide_SelectFrontPriority:
                move.w  #$100,d1
                tst.b   (a4)
                beq.s   SKSSZLowerRide_PlaceRiderOnOrbit
                move.w  4(a4),d2
                cmp.w   4(a3),d2
                bhs.s   SKSSZLowerRide_PlaceRiderOnOrbit
                move.w  #$80,d1

SKSSZLowerRide_PlaceRiderOnOrbit:
                move.w  d1,priority(a1)
                jsr     (GetSineCosine).l
                muls.w  4(a3),d1
                asr.l   #8,d1
                add.w   x_pos(a0),d1
                move.w  d1,x_pos(a1)
                move.b  2(a3),d0

SKSSZRotatingRide_ApplyRiderPose:
                addi.w  #$A,d0
                andi.w  #$FF,d0
                move.w  d0,d1
                add.w   d0,d0
                add.w   d1,d0
                lsr.w   #5,d0
                andi.w  #$FFFE,d0
                lea     SKSSZRotatingRide_RiderFlipAndFramePairs(pc),a2
                adda.w  d0,a2
                move.b  (a2)+,d0
                andi.b  #$FC,render_flags(a1)
                or.b    d0,render_flags(a1)
                move.b  (a2),d0
                move.b  d0,mapping_frame(a1)
                jmp     (Perform_Player_DPLC).l
; End of function UpdatePlayerOnSszRotatingPost
