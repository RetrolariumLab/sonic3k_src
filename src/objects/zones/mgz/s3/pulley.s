; Owner: objects/zones/mgz/s3
; Responsibility: Marble Garden pulley travel, player attachment, coordinated sprites and release
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_MGZPulley:
                move.l  #Map_MGZPulley,mappings(a0)
                move.w  #make_art_tile(ArtTile_MGZMisc1,1,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.b  #$20,width_pixels(a0)
                move.b  #$20,height_pixels(a0)
                move.w  #$280,priority(a0)
                bset    #6,render_flags(a0)
                move.w  #1,mainspr_childsprites(a0)
                lea     sub2_x_pos(a0),a2
                move.w  x_pos(a0),(a2)+
                move.w  y_pos(a0),(a2)+
                move.w  #0,(a2)+
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsl.w   #3,d0
                move.w  d0,$40(a0)
                move.w  d0,$3C(a0)
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   S3MGZPulley_StartActivePulley
                move.l  #S3MGZPulley_CullOrDrawRope,(a1)
                move.l  mappings(a0),mappings(a1)
                move.w  art_tile(a0),art_tile(a1)
                move.b  render_flags(a0),render_flags(a1)
                move.b  #$60,width_pixels(a1)
                move.b  #$C0,height_pixels(a1)
                move.w  #$300,priority(a1)
                move.w  x_pos(a0),$12(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                subi.w  #$78,x_pos(a1)
                btst    #0,status(a0)
                beq.s   S3MGZPulley_InitRopeDisplay
                addi.w  #2*$78,x_pos(a1)

S3MGZPulley_InitRopeDisplay:
                addi.w  #$D0,y_pos(a1)
                bset    #6,render_flags(a1)
                move.w  #8,mainspr_childsprites(a1)
                lea     sub2_x_pos(a1),a2
                moveq   #8-1,d0
                move.w  x_pos(a0),d2
                move.w  y_pos(a0),d3
                subi.w  #$C,d2
                subi.w  #8,d3
                subi.w  #$18,d2
                addi.w  #$30,d3

S3MGZPulley_WriteInitialRopeSection:
                move.w  d2,(a2)+
                move.w  d3,(a2)+
                move.w  #5,(a2)+
                subi.w  #$18,d2
                addi.w  #$30,d3
                dbf     d0,S3MGZPulley_WriteInitialRopeSection
                move.w  #6,-2(a2)
                move.w  a1,$3E(a0)

S3MGZPulley_StartActivePulley:
                move.l  #S3MGZPulley_PickOccupiedMotion,(a0)

S3MGZPulley_PickOccupiedMotion:
                moveq   #0,d4
                tst.b   $38(a0)
                bne.s   S3MGZPulley_LiftOrWaitForPrepull
                move.w  $3C(a0),d0
                cmp.w   $40(a0),d0
                beq.s   S3MGZPulley_ClearMainFrame
                bcc.s   S3MGZPulley_ShortenEmptyRope
                addq.w  #2,$3C(a0)
                move.b  #-1,d4
                bra.s   S3MGZPulley_StepRotorAnim
; ---------------------------------------------------------------------------

S3MGZPulley_ShortenEmptyRope:
                move.b  #1,d4
                subq.w  #2,$3C(a0)
                bra.s   S3MGZPulley_StepRotorAnim
; ---------------------------------------------------------------------------

S3MGZPulley_LiftOrWaitForPrepull:
                tst.w   $34(a0)
                bne.s   S3MGZPulley_TickPrepullAndTryExtend
                tst.w   $3C(a0)
                beq.s   S3MGZPulley_ClearMainFrame
                move.b  #1,d4
                subq.w  #4,$3C(a0)
                bcc.s   S3MGZPulley_StepRotorAnim
                move.w  #0,$3C(a0)
                bra.s   S3MGZPulley_StepRotorAnim
; ---------------------------------------------------------------------------

S3MGZPulley_TickPrepullAndTryExtend:
                subq.w  #1,$34(a0)
                cmpi.w  #$C,$34(a0)
                blo.s   S3MGZPulley_ClearMainFrame
                move.w  $40(a0),d0
                addq.w  #8,d0
                cmp.w   $3C(a0),d0
                beq.s   S3MGZPulley_ClearMainFrame
                addq.w  #2,$3C(a0)
                move.b  #-1,d4

S3MGZPulley_StepRotorAnim:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   S3MGZPulley_UpdateMainGraphic
                move.b  #1,anim_frame_timer(a0)
                add.b   d4,$1D(a0)
                andi.b  #3,$1D(a0)

S3MGZPulley_UpdateMainGraphic:
                tst.b   mapping_frame(a0)
                bne.s   S3MGZPulley_ClearMainFrame
                tst.w   d4
                beq.s   S3MGZPulley_UpdateRopeAndRiders
                move.b  #4,mapping_frame(a0)
                bra.s   S3MGZPulley_UpdateRopeAndRiders
; ---------------------------------------------------------------------------

S3MGZPulley_ClearMainFrame:
                move.b  #0,mapping_frame(a0)

S3MGZPulley_UpdateRopeAndRiders:
                bsr.w   BuildMgzPulleyRopeSegments
                bsr.w   UpdatePlayersOnMgzPulley
                jmp     (Sprite_OnScreen_Test).l

; =============== S U B R O U T I N E =======================================

UpdatePlayersOnMgzPulley:
                lea     $38(a0),a2
                lea     (Player_1).w,a1
                move.w  (Ctrl_1).w,d0
                bsr.s   UpdatePlayerOnMgzPulley
                addq.w  #1,a2
                lea     (Player_2).w,a1
                move.w  (Ctrl_2).w,d0
; End of function UpdatePlayersOnMgzPulley

; =============== S U B R O U T I N E =======================================

UpdatePlayerOnMgzPulley:
                tst.b   (a2)
                beq.w   S3MGZPulley_TickRegrabCooldown
                tst.b   render_flags(a1)
                bpl.s   S3MGZPulley_DetachRider
                cmpi.b  #4,routine(a1)
                bhs.s   S3MGZPulley_DetachRider
                andi.b  #button_A_mask|button_B_mask|button_C_mask,d0
                beq.w   S3MGZPulley_CalcHeldRiderPosition
                clr.b   object_control(a1)
                clr.b   (a2)
                move.b  #60,2(a2)
                move.w  #-$400,x_vel(a1)
                btst    #0,status(a0)
                beq.s   S3MGZPulley_JumpReleaseRider
                neg.w   x_vel(a1)

S3MGZPulley_JumpReleaseRider:
                move.w  #-$600,y_vel(a1)
                bset    #Status_InAir,status(a1)
                move.b  #$E,y_radius(a1)
                move.b  #7,x_radius(a1)
                move.b  #2,anim(a1)
                bset    #Status_Roll,status(a1)
                rts
; ---------------------------------------------------------------------------

S3MGZPulley_DetachRider:
                clr.b   object_control(a1)
                clr.b   (a2)
                move.b  #60,2(a2)
                rts
; ---------------------------------------------------------------------------

S3MGZPulley_CalcHeldRiderPosition:
                move.w  x_pos(a0),d2
                move.w  y_pos(a0),d3
                subi.w  #$26,d2
                addi.w  #$2E,d3
                move.w  $3C(a0),d0
                add.w   d0,d3
                lsr.w   #1,d0
                btst    #0,status(a0)
                beq.s   S3MGZPulley_StoreRiderPosition
                addi.w  #2*$26,d2
                neg.w   d0

S3MGZPulley_StoreRiderPosition:
                sub.w   d0,d2
                move.w  d2,x_pos(a1)
                move.w  d3,y_pos(a1)
                rts
; ---------------------------------------------------------------------------

S3MGZPulley_TickRegrabCooldown:
                tst.b   2(a2)
                beq.s   S3MGZPulley_CalcGrabPoint
                subq.b  #1,2(a2)
                bne.w   S3MGZPulley_GrabReturn

S3MGZPulley_CalcGrabPoint:
                move.w  x_pos(a0),d2
                move.w  y_pos(a0),d3
                subi.w  #$26,d2
                addi.w  #$2E,d3
                move.w  $3C(a0),d0
                add.w   d0,d3
                lsr.w   #1,d0
                btst    #0,status(a0)
                beq.s   S3MGZPulley_CheckGrabWindow
                addi.w  #2*$26,d2
                neg.w   d0

S3MGZPulley_CheckGrabWindow:
                sub.w   d0,d2
                move.w  x_pos(a1),d0
                sub.w   d2,d0
                addi.w  #$C,d0
                cmpi.w  #$18,d0
                bhs.w   S3MGZPulley_GrabReturn
                move.w  y_pos(a1),d1
                sub.w   d3,d1
                addi.w  #$C,d1
                cmpi.w  #$18,d1
                bhs.w   S3MGZPulley_GrabReturn
                tst.b   object_control(a1)
                bne.s   S3MGZPulley_GrabReturn
                cmpi.b  #4,routine(a1)
                bhs.s   S3MGZPulley_GrabReturn
                tst.w   (Debug_placement_mode).w
                bne.s   S3MGZPulley_GrabReturn
                move.w  x_vel(a1),d0
                btst    #0,status(a0)
                beq.s   S3MGZPulley_TryGrabWithApproachSpeed
                neg.w   d0

S3MGZPulley_TryGrabWithApproachSpeed:
                tst.w   d0
                bpl.s   S3MGZPulley_GrabReturn
                clr.w   x_vel(a1)
                clr.w   y_vel(a1)
                clr.w   ground_vel(a1)
                move.w  d2,x_pos(a1)
                move.w  d3,y_pos(a1)
                move.b  #$B,anim(a1)
                move.b  #1,object_control(a1)
                bclr    #Status_Facing,status(a1)
                btst    #0,status(a0)
                beq.s   S3MGZPulley_CommitGrabAndPrepull
                bset    #Status_Facing,status(a1)

S3MGZPulley_CommitGrabAndPrepull:
                move.w  #$10,$34(a0)
                move.b  #1,(a2)
                moveq   #signextendB(sfx_PulleyGrab),d0
                jsr     (Play_SFX).l

S3MGZPulley_GrabReturn:
                rts
; End of function UpdatePlayerOnMgzPulley

; =============== S U B R O U T I N E =======================================

BuildMgzPulleyRopeSegments:
                btst    #0,status(a0)
                bne.s   S3MGZPulley_SetUpFlippedRope
                movea.w $3E(a0),a1
                moveq   #0,d0
                move.w  $3C(a0),d0
                addi.w  #$18,d0
                divu.w  #$30,d0
                move.w  d0,mainspr_childsprites(a1)
                move.w  d0,d1
                lea     sub2_x_pos(a1),a2
                move.w  x_pos(a0),d2
                move.w  y_pos(a0),d3
                subi.w  #$C,d2
                subi.w  #8,d3
                swap    d0
                cmpi.w  #8,d1
                bne.s   S3MGZPulley_AddNormalRopeSection
                move.w  #$30,d0
                moveq   #8-1,d1
                bra.s   S3MGZPulley_OffsetNormalRopeStart
; ---------------------------------------------------------------------------

S3MGZPulley_AddNormalRopeSection:
                addq.w  #1,mainspr_childsprites(a1)

S3MGZPulley_OffsetNormalRopeStart:
                add.w   d0,d3
                lsr.w   #1,d0
                sub.w   d0,d2

S3MGZPulley_WriteNormalRopeSection:
                move.w  d2,(a2)+
                move.w  d3,(a2)+
                move.w  #5,(a2)+
                subi.w  #$18,d2
                addi.w  #$30,d3
                dbf     d1,S3MGZPulley_WriteNormalRopeSection
                move.w  #6,-2(a2)
                rts
; ---------------------------------------------------------------------------

S3MGZPulley_SetUpFlippedRope:
                movea.w $3E(a0),a1
                moveq   #0,d0
                move.w  $3C(a0),d0
                addi.w  #$18,d0
                divu.w  #$30,d0
                move.w  d0,mainspr_childsprites(a1)
                move.w  d0,d1
                lea     sub2_x_pos(a1),a2
                move.w  x_pos(a0),d2
                move.w  y_pos(a0),d3
                addi.w  #$C,d2
                subi.w  #8,d3
                swap    d0
                cmpi.w  #8,d1
                bne.s   S3MGZPulley_AddFlippedRopeSection
                move.w  #$30,d0
                moveq   #8-1,d1
                bra.s   S3MGZPulley_OffsetFlippedRopeStart
; ---------------------------------------------------------------------------

S3MGZPulley_AddFlippedRopeSection:
                addq.w  #1,mainspr_childsprites(a1)

S3MGZPulley_OffsetFlippedRopeStart:
                add.w   d0,d3
                lsr.w   #1,d0
                add.w   d0,d2

S3MGZPulley_WriteFlippedRopeSection:
                move.w  d2,(a2)+
                move.w  d3,(a2)+
                move.w  #5,(a2)+
                addi.w  #$18,d2
                addi.w  #$30,d3
                dbf     d1,S3MGZPulley_WriteFlippedRopeSection
                move.w  #6,-2(a2)
                rts
; End of function BuildMgzPulleyRopeSegments

; ---------------------------------------------------------------------------

; Read the original X from the position fraction word for culling
S3MGZPulley_CullOrDrawRope:
                move.w  $12(a0),d0
                jmp     (Sprite_OnScreen_Test2).l
; ---------------------------------------------------------------------------
Map_MGZPulley:
                include "src/objects/shared/zones/mgz/mappings/pulley.s"
