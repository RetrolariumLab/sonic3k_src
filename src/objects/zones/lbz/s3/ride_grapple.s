; Owner: objects/zones/lbz/s3
; Responsibility: Launch Base riding grapple initialization, constrained travel, player attachment and release
; Source provenance and ranges: config/reconstruction/source_layout.json
LBZRideGrapple_Range:
                dc.w    $A08,  $C78                     ; 0
                dc.w    $1208, $14F8                    ; 1
                dc.w    $1A08, $1BB8                    ; 2
                dc.w    $1C48, $2078                    ; 3
                dc.w    $2688, $2878                    ; 4
                dc.w    $2988, $2DF8                    ; 5
                dc.w    $2F88, $3178                    ; 6
                dc.w    $E68, $1098                     ; 7
                dc.w    $CE8, $1498                     ; 8
                dc.w    $E68, $1398                     ; 9
                dc.w    $20E8, $2418                    ; A
                dc.w    $2B08, $2E98                    ; B
                dc.w    $39E8, $3C98                    ; C
; ---------------------------------------------------------------------------

Obj_LBZRideGrapple:
                move.b  #4,render_flags(a0)
                move.b  #$10,width_pixels(a0)
                move.w  #$80,priority(a0)
                move.b  #$20,height_pixels(a0)
                move.w  x_pos(a0),$38(a0)
                move.b  subtype(a0),d0
                andi.w  #$7F,d0
                lsl.w   #2,d0
                move.l  LBZRideGrapple_Range(pc,d0.w),$34(a0)
                move.l  #Map_LBZRideGrapple,mappings(a0)
                move.w  #make_art_tile(ArtTile_LBZMisc+$70,1,0),art_tile(a0)
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   S3LBZRideGrip_StartIdleGrapple
                move.l  #S3LBZRideGrip_DrawChainVisual,(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.l  mappings(a0),mappings(a1)
                move.w  art_tile(a0),art_tile(a1)
                move.b  render_flags(a0),render_flags(a1)
                move.w  priority(a0),priority(a1)
                bset    #6,render_flags(a1)
                move.b  #$10,width_pixels(a1)
                move.b  #$20,height_pixels(a1)
                moveq   #6,d1
                move.w  d1,mainspr_childsprites(a1)
                subq.b  #1,d1
                lea     sub2_x_pos(a1),a2

S3LBZRideGrip_InitChainSprites:
                move.w  x_pos(a1),(a2)+
                move.w  y_pos(a1),(a2)+
                move.w  #1,(a2)+
                dbf     d1,S3LBZRideGrip_InitChainSprites
                move.b  #2,mapping_frame(a1)
                move.w  a1,$3C(a0)

; Start the grapple even if the chain visual fails to allocate
S3LBZRideGrip_StartIdleGrapple:
                move.l  #S3LBZRideGrip_UpdateIdleAndTryTravel,(a0)

S3LBZRideGrip_UpdateIdleAndTryTravel:
                bsr.w   UpdateLbzRideGrappleSwingAndChain
                bsr.w   UpdatePlayersOnLbzRideGrapple
                tst.w   $30(a0)
                beq.s   S3LBZRideGrip_TryDrawFromCurrentX
                cmpi.w  #$28,$3A(a0)
                bne.s   S3LBZRideGrip_TryDrawFromCurrentX
                move.l  #S3LBZRideGrip_MoveAndAccelerate,(a0)

S3LBZRideGrip_TryDrawFromCurrentX:
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   S3LBZRideGrip_TryDrawFromOriginalX
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3LBZRideGrip_TryDrawFromOriginalX:
                move.w  $38(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   S3LBZRideGrip_TryClearRespawnBit
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3LBZRideGrip_TryClearRespawnBit:
                move.w  respawn_addr(a0),d0
                beq.s   S3LBZRideGrip_TryDeleteChainVisual
                movea.w d0,a2
                bclr    #7,(a2)

S3LBZRideGrip_TryDeleteChainVisual:
                move.w  $3C(a0),d0
                beq.s   S3LBZRideGrip_DeleteGrapple
                movea.w d0,a1
                jsr     (Delete_Referenced_Sprite).l

S3LBZRideGrip_DeleteGrapple:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

S3LBZRideGrip_MoveAndAccelerate:
                jsr     (MoveSprite2).l
                btst    #0,status(a0)
                beq.s   S3LBZRideGrip_AccelerateRight
                subi.w  #$20,x_vel(a0)
                tst.w   x_vel(a0)
                bmi.s   S3LBZRideGrip_CheckLeftEndpoint
                subi.w  #$60,x_vel(a0)
                bra.s   S3LBZRideGrip_CheckLeftEndpoint
; ---------------------------------------------------------------------------

S3LBZRideGrip_AccelerateRight:
                addi.w  #$20,x_vel(a0)
                tst.w   x_vel(a0)
                bpl.s   S3LBZRideGrip_CheckLeftEndpoint
                addi.w  #$60,x_vel(a0)

S3LBZRideGrip_CheckLeftEndpoint:
                move.w  x_pos(a0),d0
                move.w  $34(a0),d1
                cmp.w   d1,d0
                bhi.s   S3LBZRideGrip_CheckRightEndpoint
                move.w  d1,x_pos(a0)
                bsr.s   ReleaseLbzRideGrapplePlayersAtEndpoint
                tst.w   x_vel(a0)
                bpl.s   S3LBZRideGrip_CheckRightEndpoint
                move.w  #0,x_vel(a0)

S3LBZRideGrip_CheckRightEndpoint:
                move.w  $36(a0),d1
                cmp.w   d1,d0
                blo.s   S3LBZRideGrip_UpdateChainRidersAndCull
                move.w  d1,x_pos(a0)
                bsr.s   ReleaseLbzRideGrapplePlayersAtEndpoint
                tst.w   x_vel(a0)
                bmi.s   S3LBZRideGrip_UpdateChainRidersAndCull
                move.w  #0,x_vel(a0)

S3LBZRideGrip_UpdateChainRidersAndCull:
                bsr.w   UpdateLbzRideGrappleSwingAndChain
                bsr.w   UpdatePlayersOnLbzRideGrapple
                bra.w   S3LBZRideGrip_TryDrawFromCurrentX

; =============== S U B R O U T I N E =======================================

ReleaseLbzRideGrapplePlayersAtEndpoint:
                tst.b   subtype(a0)
                bmi.s   S3LBZRideGrip_EndpointReleaseReturn
                lea     $30(a0),a2
                lea     (Player_1).w,a1
                bsr.s   ReleasePlayerFromLbzRideGrappleEndpoint
                lea     (Player_2).w,a1
                addq.w  #1,a2
; End of function ReleaseLbzRideGrapplePlayersAtEndpoint

; =============== S U B R O U T I N E =======================================

ReleasePlayerFromLbzRideGrappleEndpoint:
                tst.b   (a2)
                beq.s   S3LBZRideGrip_EndpointReleaseReturn
                move.w  x_vel(a0),x_vel(a1)
                move.w  #0,y_vel(a1)
                bset    #Status_InAir,status(a1)
                clr.b   object_control(a1)
                clr.b   (a2)
                move.b  #$3C,2(a2)

S3LBZRideGrip_EndpointReleaseReturn:
                rts
; End of function ReleasePlayerFromLbzRideGrappleEndpoint

; ---------------------------------------------------------------------------

S3LBZRideGrip_DrawChainVisual:
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

UpdatePlayersOnLbzRideGrapple:
                movea.w $3C(a0),a3
                lea     $31(a0),a2
                lea     (Player_2).w,a1
                move.w  (Ctrl_2).w,d0
                bsr.s   UpdatePlayerOnLbzRideGrapple
                lea     (Player_1).w,a1
                subq.w  #1,a2
                move.w  (Ctrl_1).w,d0
; End of function UpdatePlayersOnLbzRideGrapple

; =============== S U B R O U T I N E =======================================

UpdatePlayerOnLbzRideGrapple:
                tst.b   (a2)
                beq.w   S3LBZRideGrip_TickCaptureCooldown
                tst.b   render_flags(a1)
                bpl.s   S3LBZRideGrip_DetachWithoutJump
                cmpi.b  #4,routine(a1)
                bhs.s   S3LBZRideGrip_DetachWithoutJump
                andi.b  #button_A_mask|button_B_mask|button_C_mask,d0
                beq.w   S3LBZRideGrip_TryFaceRiderLeft
                clr.b   $2E(a1)
                clr.b   (a2)
                move.b  #$12,2(a2)
                andi.w  #(button_up_mask|button_down_mask|button_left_mask|button_right_mask)<<8,d0
                beq.w   S3LBZRideGrip_JumpWithGrappleSpeed
                move.b  #$3C,2(a2)

S3LBZRideGrip_JumpWithGrappleSpeed:
                move.w  x_vel(a0),x_vel(a1)
                move.w  #-$380,y_vel(a1)
                bset    #Status_InAir,status(a1)
                move.b  #1,jumping(a1)
                move.b  #$E,y_radius(a1)
                move.b  #7,x_radius(a1)
                move.b  #2,anim(a1)
                bset    #Status_Roll,status(a1)
                rts
; ---------------------------------------------------------------------------

S3LBZRideGrip_DetachWithoutJump:
                clr.b   object_control(a1)
                clr.b   (a2)
                move.b  #$3C,2(a2)
                rts
; ---------------------------------------------------------------------------

S3LBZRideGrip_TryFaceRiderLeft:
                btst    #button_left+8,d0
                beq.s   S3LBZRideGrip_TryFaceRiderRight
                bset    #Status_Facing,status(a1)

S3LBZRideGrip_TryFaceRiderRight:
                btst    #button_right+8,d0
                beq.s   S3LBZRideGrip_SyncFacingAndPlaceRider
                bclr    #Status_Facing,status(a1)

S3LBZRideGrip_SyncFacingAndPlaceRider:
                move.b  status(a1),status(a0)
                move.b  status(a1),d0
                andi.b  #1<<Status_Facing,d0
                andi.b  #$FE,render_flags(a1)
                or.b    d0,render_flags(a1)
                move.w  x_pos(a3),x_pos(a1)
                move.w  y_pos(a3),y_pos(a1)
                addi.w  #$24,y_pos(a1)

S3LBZRideGrip_ChooseMirroredPoseAngle:
                moveq   #0,d0
                move.b  angle(a0),d0
                btst    #Status_Facing,status(a1)
                beq.s   S3LBZRideGrip_ApplyPoseAndLoadTiles
                neg.b   d0

S3LBZRideGrip_ApplyPoseAndLoadTiles:
                addq.b  #8,d0
                lsr.w   #4,d0
                move.b  S3LBZRideGrip_RiderPoseFrames(pc,d0.w),mapping_frame(a1)
                moveq   #0,d0
                move.b  mapping_frame(a1),d0
                move.l  a2,-(sp)
                jsr     (Perform_Player_DPLC).l
                movea.l (sp)+,a2
                rts
; ---------------------------------------------------------------------------
S3LBZRideGrip_RiderPoseFrames:
                dc.b    $91, $91, $90, $90, $90, $90, $90, $90, $92, $92, $92, $92, $92, $92, $91, $91
                even
; ---------------------------------------------------------------------------

S3LBZRideGrip_TickCaptureCooldown:
                tst.b   2(a2)
                beq.s   S3LBZRideGrip_TryCaptureRider
                subq.b  #1,2(a2)
                bne.w   S3LBZRideGrip_CaptureReturn

S3LBZRideGrip_TryCaptureRider:
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                addi.w  #$10,d0
                cmpi.w  #$20,d0
                bhs.w   S3LBZRideGrip_CaptureReturn
                move.w  y_pos(a1),d1
                sub.w   y_pos(a0),d1
                subi.w  #$18,d1
                cmpi.w  #$18,d1
                bhs.w   S3LBZRideGrip_CaptureReturn
                tst.b   object_control(a1)
                bne.s   S3LBZRideGrip_CaptureReturn
                cmpi.b  #4,routine(a1)
                bhs.s   S3LBZRideGrip_CaptureReturn
                tst.w   (Debug_placement_mode).w
                bne.s   S3LBZRideGrip_CaptureReturn
                move.b  status(a1),status(a0)
                clr.w   x_vel(a1)
                clr.w   y_vel(a1)
                clr.w   ground_vel(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                addi.w  #$24,y_pos(a1)
                move.b  #$14,anim(a1)
                move.b  #0,spin_dash_flag(a1)
                move.b  #3,object_control(a1)
                move.b  #1,(a2)
                bra.w   S3LBZRideGrip_ChooseMirroredPoseAngle
; ---------------------------------------------------------------------------

S3LBZRideGrip_CaptureReturn:
                rts
; End of function UpdatePlayerOnLbzRideGrapple

; =============== S U B R O U T I N E =======================================

UpdateLbzRideGrappleSwingAndChain:
                tst.w   $30(a0)
                beq.s   S3LBZRideGrip_RetractUnoccupiedChain
                move.w  $3A(a0),d2
                cmpi.w  #$28,d2
                beq.s   S3LBZRideGrip_SelectSwingOrTravelLean
                addq.w  #1,d2
                bra.s   S3LBZRideGrip_SetChainLength
; ---------------------------------------------------------------------------

S3LBZRideGrip_RetractUnoccupiedChain:
                move.w  $3A(a0),d2
                beq.s   S3LBZRideGrip_ResetIdleSwing
                subq.w  #1,d2
                bne.s   S3LBZRideGrip_SetChainLength

S3LBZRideGrip_ResetIdleSwing:
                clr.w   angle(a0)
                clr.b   $40(a0)
                clr.w   $3E(a0)
                move.w  #0,x_vel(a0)
                move.l  #S3LBZRideGrip_UpdateIdleAndTryTravel,(a0)

S3LBZRideGrip_SetChainLength:
                move.w  d2,$3A(a0)

S3LBZRideGrip_SelectSwingOrTravelLean:
                mulu.w  #$33,d2
                move.w  x_vel(a0),d0
                bne.s   S3LBZRideGrip_TrackTravelLean
                tst.b   $40(a0)
                bne.s   S3LBZRideGrip_StepReverseFreeSwing
                move.w  $3E(a0),d1
                addi.w  #$40,d1
                move.w  d1,$3E(a0)
                add.w   d1,angle(a0)
                bmi.s   S3LBZRideGrip_JoinChainProjection
                move.b  #1,$40(a0)
                bra.s   S3LBZRideGrip_JoinChainProjection
; ---------------------------------------------------------------------------

S3LBZRideGrip_StepReverseFreeSwing:
                move.w  $3E(a0),d1
                subi.w  #$40,d1
                move.w  d1,$3E(a0)
                add.w   d1,angle(a0)
                bpl.s   S3LBZRideGrip_JoinChainProjection
                move.b  #0,$40(a0)

S3LBZRideGrip_JoinChainProjection:
                bra.s   S3LBZRideGrip_CalcChainLinkSteps
; ---------------------------------------------------------------------------

S3LBZRideGrip_TrackTravelLean:
                neg.w   d0
                asl.w   #2,d0
                sub.w   angle(a0),d0
                bge.s   S3LBZRideGrip_TryIncreaseTravelLean
                cmpi.w  #-$3000,angle(a0)
                ble.s   S3LBZRideGrip_TryIncreaseTravelLean
                subi.w  #$180,angle(a0)
                bra.s   S3LBZRideGrip_SetSwingPhaseFromTravel
; ---------------------------------------------------------------------------

S3LBZRideGrip_TryIncreaseTravelLean:
                cmpi.w  #$3000,angle(a0)
                bge.s   S3LBZRideGrip_SetSwingPhaseFromTravel
                addi.w  #$180,angle(a0)

S3LBZRideGrip_SetSwingPhaseFromTravel:
                move.b  #0,$40(a0)
                tst.w   x_vel(a0)
                bpl.s   S3LBZRideGrip_ClearAngularSpeed
                move.b  #1,$40(a0)

S3LBZRideGrip_ClearAngularSpeed:
                move.w  #0,$3E(a0)

; Use the stored chain actor pointer directly to place the links
S3LBZRideGrip_CalcChainLinkSteps:
                move.b  angle(a0),d0
                jsr     (GetSineCosine).l
                muls.w  d2,d0
                muls.w  d2,d1
                move.l  x_pos(a0),d2
                move.l  y_pos(a0),d3
                movea.w $3C(a0),a1
                moveq   #6-1,d4
                lea     sub2_x_pos(a1),a2

S3LBZRideGrip_PlaceLinksAndGrip:
                swap    d2
                swap    d3
                move.w  d2,(a2)+
                move.w  d3,(a2)+
                addq.w  #2,a2
                swap    d2
                swap    d3
                add.l   d0,d2
                add.l   d1,d3
                dbf     d4,S3LBZRideGrip_PlaceLinksAndGrip
                move.w  $36(a1),x_pos(a1)
                move.w  $38(a1),y_pos(a1)
                rts
; End of function UpdateLbzRideGrappleSwingAndChain

; ---------------------------------------------------------------------------
Map_LBZRideGrapple:
                include "src/objects/shared/zones/lbz/mappings/ride_grapple.s"
