; Owner: objects/zones/lbz/s3
; Responsibility: Unused Launch Base bar platform movement, player riding and mapping resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_LBZUnusedBarPlatform:
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   S3LBZUnusedBar_StartMovingPlatform
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.b  status(a0),status(a1)
                move.l  #Map_LBZUnusedBarPlatform,mappings(a1)
                move.w  #make_art_tile(ArtTile_LBZ2Misc,2,0),art_tile(a1)
                move.b  #4,render_flags(a1)
                move.w  #$180,priority(a1)
                move.b  #$20,width_pixels(a1)
                move.b  #$10,height_pixels(a1)
                move.w  a0,$3E(a1)
                move.l  #S3LBZUnusedBar_FollowAndUpdateRiders,(a1)
                move.w  a1,$3E(a0)
                move.b  #1,$3D(a0)

S3LBZUnusedBar_StartMovingPlatform:
                bra.w   Obj_LBZMovingPlatform
; ---------------------------------------------------------------------------

; Update P2 before P1 using the same platform displacement
S3LBZUnusedBar_FollowAndUpdateRiders:
                move.w  x_pos(a0),d4
                movea.w $3E(a0),a1
                move.w  x_pos(a1),x_pos(a0)
                move.w  y_pos(a1),y_pos(a0)
                sub.w   x_pos(a1),d4
                bsr.s   UpdatePlayersHangingFromLbzUnusedBar
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

UpdatePlayersHangingFromLbzUnusedBar:
                lea     $33(a0),a2
                lea     (Player_2).w,a1
                move.w  (Ctrl_2).w,d0
                bsr.s   UpdatePlayerHangingFromLbzUnusedBar
                lea     (Player_1).w,a1
                subq.w  #1,a2
                move.w  (Ctrl_1).w,d0
; End of function UpdatePlayersHangingFromLbzUnusedBar

; =============== S U B R O U T I N E =======================================

UpdatePlayerHangingFromLbzUnusedBar:
                tst.b   (a2)
                beq.w   S3LBZUnusedBar_TickCaptureCooldown
                tst.b   render_flags(a1)
                bpl.s   S3LBZUnusedBar_DetachAndStartCooldown
                cmpi.b  #4,routine(a1)
                bhs.s   S3LBZUnusedBar_DetachAndStartCooldown
                andi.b  #button_A_mask|button_B_mask|button_C_mask,d0
                beq.w   S3LBZUnusedBar_CarryHangingRider
                clr.b   object_control(a1)
                clr.b   (a2)
                move.b  #$12,2(a2)
                andi.w  #(button_up_mask|button_down_mask|button_left_mask|button_right_mask)<<8,d0
                beq.w   S3LBZUnusedBar_TrySetJumpLeft
                move.b  #$3C,2(a2)

S3LBZUnusedBar_TrySetJumpLeft:
                btst    #button_left+8,d0
                beq.s   S3LBZUnusedBar_TrySetJumpRight
                move.w  #-$200,x_vel(a1)

S3LBZUnusedBar_TrySetJumpRight:
                btst    #button_right+8,d0
                beq.s   S3LBZUnusedBar_JumpFromBar
                move.w  #$200,x_vel(a1)

S3LBZUnusedBar_JumpFromBar:
                move.w  #-$380,y_vel(a1)
                bset    #1,status(a1)
                rts
; ---------------------------------------------------------------------------

S3LBZUnusedBar_DetachAndStartCooldown:
                clr.b   object_control(a1)
                clr.b   (a2)
                move.b  #$3C,2(a2)
                rts
; ---------------------------------------------------------------------------

S3LBZUnusedBar_CarryHangingRider:
                sub.w   d4,x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                addi.w  #$24,y_pos(a1)
                rts
; ---------------------------------------------------------------------------

S3LBZUnusedBar_TickCaptureCooldown:
                tst.b   2(a2)
                beq.s   S3LBZUnusedBar_TryCaptureAtBar
                subq.b  #1,2(a2)
                bne.w   S3LBZUnusedBar_CaptureReturn

S3LBZUnusedBar_TryCaptureAtBar:
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                addi.w  #$1C,d0
                cmpi.w  #$38,d0
                bhs.w   S3LBZUnusedBar_CaptureReturn
                move.w  y_pos(a1),d1
                sub.w   y_pos(a0),d1
                subi.w  #$18,d1
                cmpi.w  #$18,d1
                bhs.w   S3LBZUnusedBar_CaptureReturn
                tst.b   object_control(a1)
                bne.s   S3LBZUnusedBar_CaptureReturn
                cmpi.b  #4,routine(a1)
                bhs.s   S3LBZUnusedBar_CaptureReturn
                tst.w   (Debug_placement_mode).w
                bne.s   S3LBZUnusedBar_CaptureReturn
                clr.w   x_vel(a1)
                clr.w   y_vel(a1)
                clr.w   ground_vel(a1)
                move.w  y_pos(a0),y_pos(a1)
                addi.w  #$24,y_pos(a1)
                move.b  #$14,anim(a1)
                move.b  #1,object_control(a1)
                move.b  #1,(a2)

S3LBZUnusedBar_CaptureReturn:
                rts
; End of function UpdatePlayerHangingFromLbzUnusedBar

; ---------------------------------------------------------------------------
Map_LBZUnusedBarPlatform:
                include "src/objects/shared/zones/lbz/mappings/unused_bar_platform.s"
