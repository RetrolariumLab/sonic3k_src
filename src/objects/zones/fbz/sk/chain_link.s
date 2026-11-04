; Owner: objects/zones/fbz/sk
; Responsibility: Chain-link traversal, player attachment, coordinated motion and release
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_FBZChainLink:
                move.b  subtype(a0),d0
                bpl.s   SKFBZChain_InitVerticalChain
                andi.w  #$3F,d0
                lsl.w   #4,d0
                move.w  d0,$3E(a0)
                move.l  #SKFBZChain_UpdateHorizontalRiders,(a0)
                bra.w   SKFBZChain_UpdateHorizontalRiders
; ---------------------------------------------------------------------------

SKFBZChain_InitVerticalChain:
                move.b  #4,render_flags(a0)
                move.b  #$10,width_pixels(a0)
                move.w  #$80,priority(a0)
                move.b  #$80,height_pixels(a0)
                move.w  y_pos(a0),$46(a0)
                move.l  #Map_FBZChainLink,mappings(a0)
                move.w  #make_art_tile(ArtTile_FBZMisc,2,0),art_tile(a0)
                move.b  subtype(a0),d0
                andi.w  #$7F,d0
                lsl.w   #3,d0
                move.w  d0,$2E(a0)
                move.w  #2,$3C(a0)
                move.b  subtype(a0),d0
                bpl.s   SKFBZChain_StartVerticalChain
                move.w  $2E(a0),d0
                move.w  d0,$3A(a0)
                move.b  #1,$38(a0)
                add.w   d0,y_pos(a0)
                lsr.w   #4,d0
                addq.w  #1,d0
                move.b  d0,mapping_frame(a0)

SKFBZChain_StartVerticalChain:
                move.l  #SKFBZChain_PickTravelByOccupancy,(a0)

SKFBZChain_PickTravelByOccupancy:
                tst.b   $38(a0)
                beq.s   SKFBZChain_CheckNormalPolarity
                tst.w   $30(a0)
                bne.s   SKFBZChain_TryRetractChain
                bra.s   SKFBZChain_TryExtendChain
; ---------------------------------------------------------------------------

SKFBZChain_CheckNormalPolarity:
                tst.w   $30(a0)
                beq.s   SKFBZChain_TryRetractChain

SKFBZChain_TryExtendChain:
                move.w  $3A(a0),d2
                cmp.w   $2E(a0),d2
                beq.s   SKFBZChain_UpdateVerticalRiders
                add.w   $3C(a0),d2
                bra.s   SKFBZChain_SetExtensionAndY
; ---------------------------------------------------------------------------

SKFBZChain_TryRetractChain:
                move.w  $3A(a0),d2
                beq.s   SKFBZChain_UpdateVerticalRiders
                sub.w   $3C(a0),d2

SKFBZChain_SetExtensionAndY:
                move.w  d2,$3A(a0)
                move.w  $46(a0),d0
                add.w   d2,d0
                move.w  d0,y_pos(a0)
                move.w  d2,d0
                beq.s   SKFBZChain_SetLengthFrame
                lsr.w   #4,d0
                addq.w  #1,d0

SKFBZChain_SetLengthFrame:
                move.b  d0,mapping_frame(a0)

SKFBZChain_UpdateVerticalRiders:
                lea     $30(a0),a2
                lea     (Player_1).w,a1
                move.w  (Ctrl_1_logical).w,d0
                bsr.w   UpdatePlayerHangingFromFbzVerticalChain
                lea     (Player_2).w,a1
                addq.w  #1,a2
                move.w  (Ctrl_2_logical).w,d0
                bsr.w   UpdatePlayerHangingFromFbzVerticalChain
                jmp     (Sprite_OnScreen_Test).l

; =============== S U B R O U T I N E =======================================

UpdatePlayerHangingFromFbzVerticalChain:
                tst.b   (a2)
                beq.w   SKFBZChain_TickVerticalCooldown
                tst.b   render_flags(a1)
                bpl.w   SKFBZChain_DropVerticalRider
                tst.w   (Debug_placement_mode).w
                bne.w   SKFBZChain_DropVerticalRider
                cmpi.b  #4,routine(a1)
                bhs.s   SKFBZChain_DropVerticalRider
                andi.b  #button_A_mask|button_B_mask|button_C_mask,d0
                beq.w   SKFBZChain_TryFaceVerticalLeft
                clr.b   object_control(a1)
                clr.b   (a2)
                move.b  #$12,2(a2)
                andi.w  #(button_up_mask|button_down_mask|button_left_mask|button_right_mask)<<8,d0
                beq.w   SKFBZChain_TrySetVerticalJumpLeft
                move.b  #$3C,2(a2)

SKFBZChain_TrySetVerticalJumpLeft:
                btst    #button_left+8,d0
                beq.s   SKFBZChain_TrySetVerticalJumpRight
                move.w  #-$200,x_vel(a1)

SKFBZChain_TrySetVerticalJumpRight:
                btst    #button_right+8,d0
                beq.s   SKFBZChain_JumpFromVerticalChain
                move.w  #$200,x_vel(a1)

SKFBZChain_JumpFromVerticalChain:
                move.w  #-$380,y_vel(a1)
                bset    #Status_InAir,status(a1)
                move.b  #1,jumping(a1)
                move.b  #$E,y_radius(a1)
                move.b  #7,x_radius(a1)
                move.b  #2,anim(a1)
                bset    #Status_Roll,status(a1)
                bclr    #Status_RollJump,status(a1)
                move.b  #0,flip_angle(a1)
                bclr    #3,status(a1)
                move.w  #0,interact(a1)
                rts
; ---------------------------------------------------------------------------

SKFBZChain_DropVerticalRider:
                clr.b   object_control(a1)
                clr.b   (a2)
                move.b  #$3C,2(a2)
                bclr    #Status_OnObj,status(a1)
                move.w  #0,interact(a1)
                rts
; ---------------------------------------------------------------------------

SKFBZChain_TryFaceVerticalLeft:
                btst    #button_left+8,d0
                beq.s   SKFBZChain_TryFaceVerticalRight
                bset    #0,status(a1)

SKFBZChain_TryFaceVerticalRight:
                btst    #button_right+8,d0
                beq.s   SKFBZChain_SyncVerticalFacingAndY
                bclr    #Status_Facing,status(a1)

SKFBZChain_SyncVerticalFacingAndY:
                move.b  status(a1),d0
                andi.b  #1,d0
                andi.b  #$FE,render_flags(a1)
                or.b    d0,render_flags(a1)
                move.w  y_pos(a0),y_pos(a1)
                addi.w  #$9C,y_pos(a1)
                rts
; ---------------------------------------------------------------------------

SKFBZChain_TickVerticalCooldown:
                tst.b   2(a2)
                beq.s   SKFBZChain_TryVerticalCapture
                subq.b  #1,2(a2)
                bne.w   SKFBZChain_VerticalCaptureReturn

SKFBZChain_TryVerticalCapture:
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                addi.w  #$10,d0
                cmpi.w  #$20,d0
                bhs.w   SKFBZChain_VerticalCaptureReturn
                move.w  y_pos(a1),d1
                sub.w   y_pos(a0),d1
                subi.w  #$90,d1
                cmpi.w  #$18,d1
                bhs.w   SKFBZChain_VerticalCaptureReturn
                tst.b   object_control(a1)
                bmi.s   SKFBZChain_VerticalCaptureReturn
                cmpi.b  #4,routine(a1)
                bhs.s   SKFBZChain_VerticalCaptureReturn
                tst.w   (Debug_placement_mode).w
                bne.s   SKFBZChain_VerticalCaptureReturn
                btst    #Status_OnObj,status(a1)
                beq.s   SKFBZChain_AttachAtVerticalEnd
                movea.w interact(a1),a3
                cmpi.l  #SKFBZChain_UpdateHorizontalRiders,(a3)
                bne.s   SKFBZChain_AttachAtVerticalEnd
                move.w  a2,d0
                sub.w   a0,d0
                adda.w  d0,a3
                tst.b   4(a3)
                bne.s   SKFBZChain_VerticalCaptureReturn
                clr.b   (a3)
                move.b  #$3C,2(a3)

SKFBZChain_AttachAtVerticalEnd:
                move.w  a0,interact(a1)
                bset    #Status_OnObj,status(a1)
                clr.w   x_vel(a1)
                clr.w   y_vel(a1)
                clr.w   ground_vel(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                addi.w  #$9C,y_pos(a1)
                move.b  #$14,anim(a1)
                move.b  #1,object_control(a1)
                move.b  #1,(a2)
                moveq   #signextendB(sfx_Grab),d0
                jsr     (Play_SFX).l

SKFBZChain_VerticalCaptureReturn:
                rts
; ---------------------------------------------------------------------------

SKFBZChain_UpdateHorizontalRiders:
                lea     $30(a0),a2
                lea     (Player_1).w,a1
                move.w  (Ctrl_1_logical).w,d0
                bsr.w   UpdatePlayerTraversingFbzHorizontalChain
                lea     (Player_2).w,a1
                addq.w  #1,a2
                move.w  (Ctrl_2_logical).w,d0
                bsr.w   UpdatePlayerTraversingFbzHorizontalChain
                jmp     (Delete_Sprite_If_Not_In_Range).l
; End of function UpdatePlayerHangingFromFbzVerticalChain

; =============== S U B R O U T I N E =======================================

UpdatePlayerTraversingFbzHorizontalChain:
                tst.b   (a2)
                beq.w   SKFBZChain_TickHorizontalCooldown
                tst.b   render_flags(a1)
                bpl.w   SKFBZChain_DropHorizontalRider
                tst.w   (Debug_placement_mode).w
                bne.w   SKFBZChain_DropHorizontalRider
                cmpi.b  #4,routine(a1)
                bhs.w   SKFBZChain_DropHorizontalRider
                andi.b  #button_A_mask|button_B_mask|button_C_mask,d0
                beq.w   SKFBZChain_UpdateTraversal
                clr.b   object_control(a1)
                clr.b   (a2)
                move.b  #$12,2(a2)
                andi.w  #(button_up_mask|button_down_mask|button_left_mask|button_right_mask)<<8,d0
                beq.w   SKFBZChain_TrySetHorizJumpLeft
                move.b  #$3C,2(a2)

SKFBZChain_TrySetHorizJumpLeft:
                btst    #button_left+8,d0
                beq.s   SKFBZChain_TrySetHorizJumpRight
                move.w  #-$200,x_vel(a1)

SKFBZChain_TrySetHorizJumpRight:
                btst    #button_right+8,d0
                beq.s   SKFBZChain_JumpFromHorizontalChain
                move.w  #$200,x_vel(a1)

SKFBZChain_JumpFromHorizontalChain:
                move.w  #-$380,y_vel(a1)
                bset    #1,status(a1)
                move.b  #1,jumping(a1)
                move.b  #$E,y_radius(a1)
                move.b  #7,x_radius(a1)
                move.b  #2,anim(a1)
                move.b  #$96,mapping_frame(a1)
                bset    #Status_Roll,status(a1)
                bclr    #Status_RollJump,status(a1)
                move.b  #0,flip_angle(a1)
                bclr    #Status_OnObj,status(a1)
                move.w  #0,interact(a1)
                bra.w   SKFBZChain_UploadTraversalTiles
; ---------------------------------------------------------------------------

SKFBZChain_DropHorizontalRider:
                clr.b   object_control(a1)
                clr.b   (a2)
                move.b  #$3C,2(a2)
                bclr    #Status_OnObj,status(a1)
                move.w  #0,interact(a1)
                rts
; ---------------------------------------------------------------------------

SKFBZChain_UpdateTraversal:
                tst.b   4(a2)
                bne.s   SKFBZChain_TickTraversalStep

SKFBZChain_TryTraverseLeft:
                move.w  $3E(a0),d2
                subi.w  #$10,d2
                btst    #button_left+8,d0
                beq.s   SKFBZChain_TryTraverseRight
                bset    #Status_Facing,status(a1)
                move.w  x_pos(a1),d1
                sub.w   x_pos(a0),d1
                add.w   d2,d1
                beq.s   SKFBZChain_TryTraverseRight
                move.b  #4,4(a2)
                move.b  #1,2(a2)

SKFBZChain_TryTraverseRight:
                btst    #button_right+8,d0
                beq.s   SKFBZChain_SyncHorizFacingAndY
                bclr    #Status_Facing,status(a1)
                move.w  x_pos(a1),d1
                sub.w   x_pos(a0),d1
                add.w   d2,d1
                add.w   d2,d2
                cmp.w   d2,d1
                beq.w   SKFBZChain_SyncHorizFacingAndY
                move.b  #4,4(a2)
                move.b  #0,2(a2)

SKFBZChain_SyncHorizFacingAndY:
                move.b  status(a1),d0
                andi.b  #1,d0
                andi.b  #$FC,render_flags(a1)
                or.b    d0,render_flags(a1)
                move.w  y_pos(a0),y_pos(a1)
                addi.w  #$12,y_pos(a1)
                tst.b   4(a2)
                beq.s   SKFBZChain_UploadTraversalTiles

SKFBZChain_TickTraversalStep:
                subq.b  #1,6(a2)
                bpl.s   SKFBZChain_UploadTraversalTiles
                move.b  #7,6(a2)
                move.b  #0,anim(a1)
                moveq   #0,d1
                move.b  4(a2),d1
                cmpi.b  #2,d1
                bne.s   SKFBZChain_TrySetHangingPose
                moveq   #signextendB(sfx_Grab),d0
                jsr     (Play_SFX).l

SKFBZChain_TrySetHangingPose:
                subq.w  #1,d1
                bne.s   SKFBZChain_LookupTraversalPose
                move.b  #$14,anim(a1)

SKFBZChain_LookupTraversalPose:
                add.b   8(a2),d1
                move.b  SKFBZChain_TraversalFrames(pc,d1.w),mapping_frame(a1)
                move.b  SKFBZChain_TraversalSteps(pc,d1.w),d1
                ext.w   d1
                tst.b   2(a2)
                beq.s   SKFBZChain_ApplyTraversalStep
                neg.w   d1

SKFBZChain_ApplyTraversalStep:
                add.w   d1,x_pos(a1)
                subq.b  #1,4(a2)
                bne.s   SKFBZChain_UploadTraversalTiles
                bsr.s   ReleaseFbzChainPlayerAtOneWayEndpoint
                move.b  #0,6(a2)
                bchg    #2,8(a2)
                andi.w  #(button_left_mask|button_right_mask)<<8,d0
                bne.w   SKFBZChain_TryTraverseLeft

SKFBZChain_UploadTraversalTiles:
                moveq   #0,d0
                move.b  mapping_frame(a1),d0
                move.l  a2,-(sp)
                jsr     (Perform_Player_DPLC).l
                movea.l (sp)+,a2
                rts
; End of function UpdatePlayerTraversingFbzHorizontalChain

; ---------------------------------------------------------------------------
SKFBZChain_TraversalFrames:
                dc.b    $91, $81, $80, $85, $91, $84, $83, $82
SKFBZChain_TraversalSteps:
                dc.b    4,  $C,  $A,   6,   4,  $C,  $C,   4
                even

; =============== S U B R O U T I N E =======================================

ReleaseFbzChainPlayerAtOneWayEndpoint:
                btst    #6,subtype(a0)
                beq.s   SKFBZChain_EndpointReleaseReturn
                move.w  $3E(a0),d2
                subi.w  #$10,d2
                btst    #0,status(a0)
                beq.s   SKFBZChain_TryReleaseAtRightEnd
                move.w  x_pos(a1),d1
                sub.w   x_pos(a0),d1
                add.w   d2,d1
                bne.s   SKFBZChain_EndpointReleaseReturn
                bra.w   SKFBZChain_DropHorizontalRider
; ---------------------------------------------------------------------------

SKFBZChain_TryReleaseAtRightEnd:
                move.w  x_pos(a1),d1
                sub.w   x_pos(a0),d1
                add.w   d2,d1
                add.w   d2,d2
                cmp.w   d2,d1
                bne.s   SKFBZChain_EndpointReleaseReturn
                bra.w   SKFBZChain_DropHorizontalRider
; ---------------------------------------------------------------------------

SKFBZChain_EndpointReleaseReturn:
                rts
; End of function ReleaseFbzChainPlayerAtOneWayEndpoint

; ---------------------------------------------------------------------------

SKFBZChain_TickHorizontalCooldown:
                tst.b   2(a2)
                beq.s   SKFBZChain_TryHorizontalCapture
                subq.b  #1,2(a2)
                bne.w   SKFBZChain_HorizontalCaptureReturn

SKFBZChain_TryHorizontalCapture:
                move.w  $3E(a0),d2
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d2,d0
                add.w   d2,d2
                cmp.w   d2,d0
                bhs.w   SKFBZChain_HorizontalCaptureReturn
                move.w  y_pos(a1),d1
                sub.w   y_pos(a0),d1
                cmpi.w  #$18,d1
                bhs.w   SKFBZChain_HorizontalCaptureReturn
                tst.b   object_control(a1)
                bmi.w   SKFBZChain_HorizontalCaptureReturn
                cmpi.b  #4,routine(a1)
                bhs.w   SKFBZChain_HorizontalCaptureReturn
                tst.w   (Debug_placement_mode).w
                bne.w   SKFBZChain_HorizontalCaptureReturn
                btst    #Status_OnObj,status(a1)
                beq.s   SKFBZChain_SnapEntryAndCheckOneWay
                movea.w interact(a1),a3
                cmpi.l  #SKFBZChain_PickTravelByOccupancy,(a3)
                beq.w   SKFBZChain_HorizontalCaptureReturn

SKFBZChain_SnapEntryAndCheckOneWay:
                andi.w  #$FFE0,d0
                btst    #6,subtype(a0)
                beq.s   SKFBZChain_AttachHorizontalRider
                btst    #0,status(a0)
                beq.s   SKFBZChain_RejectOneWayRightEnd
                tst.w   d0
                beq.w   SKFBZChain_HorizontalCaptureReturn
                bra.s   SKFBZChain_AttachHorizontalRider
; ---------------------------------------------------------------------------

SKFBZChain_RejectOneWayRightEnd:
                subi.w  #$20,d2
                cmp.w   d2,d0
                beq.w   SKFBZChain_HorizontalCaptureReturn

SKFBZChain_AttachHorizontalRider:
                addi.w  #$10,d0
                sub.w   $3E(a0),d0
                add.w   x_pos(a0),d0
                move.w  d0,x_pos(a1)
                move.w  a0,interact(a1)
                bset    #3,status(a1)
                clr.w   x_vel(a1)
                clr.w   y_vel(a1)
                clr.w   ground_vel(a1)
                move.w  y_pos(a0),y_pos(a1)
                addi.w  #$12,y_pos(a1)
                move.b  #$14,anim(a1)
                move.b  #3,object_control(a1)
                andi.b  #$FD,render_flags(a1)
                move.b  #1,(a2)
                move.b  #0,2(a2)
                move.b  #0,4(a2)
                move.b  #0,6(a2)
                move.b  #$91,mapping_frame(a1)
                moveq   #0,d0
                move.b  mapping_frame(a1),d0
                move.l  a2,-(sp)
                jsr     (Perform_Player_DPLC).l
                movea.l (sp)+,a2
                moveq   #signextendB(sfx_Grab),d0
                jsr     (Play_SFX).l

SKFBZChain_HorizontalCaptureReturn:
                rts
; ---------------------------------------------------------------------------
Map_FBZChainLink:
                include "src/objects/shared/zones/fbz/mappings/chain_link.s"
