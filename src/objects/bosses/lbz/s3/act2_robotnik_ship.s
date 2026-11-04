; Owner: objects/bosses/lbz/s3
; Responsibility: Launch Base act-two Robotnik escape ship, children and private animation or object data
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_LBZ2RobotnikShip:
                move.w  a0,(Events_bg+$00).w
                lea     ObjDat_LBZ2RobotnikShip(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #LBZShipS3_CapturePlayerOnContact,(a0)
                bset    #0,render_flags(a0)

LBZShipS3_CapturePlayerOnContact:
                moveq   #0,d0
                move.b  collision_property(a0),d0
                beq.w   LBZAct2ShipS3_Capture_CullTouchAndDraw
                clr.b   collision_property(a0)
                cmpi.b  #2,d0
                beq.w   LBZAct2ShipS3_Capture_CullTouchAndDraw
                lea     (Player_1).w,a1
                tst.b   object_control(a1)
                bne.w   LBZAct2ShipS3_Capture_CullTouchAndDraw
                move.l  #LBZShipS3_MoveAttachAndDrawCarry,(a0)
                move.b  #$83,object_control(a1)
                bclr    #0,render_flags(a1)
                bclr    #Status_Facing,status(a1)
                move.b  #5,anim(a1)
                bset    #7,art_tile(a1)
                move.w  #-$100,y_vel(a0)
                move.w  #$3F,$2E(a0)
                move.l  #LBZShipS3_BeginLongCarrySwing,$34(a0)
                moveq   #signextendB(sfx_Rising),d0
                jsr     (Play_SFX).l
                st      (Anim_Counters+$F).w
                move.w  #$6000,(Camera_stored_max_X_pos).w
                lea     Child6_IncLevX(pc),a2
                jsr     CreateChild6_Simple(pc)
                lea     (Child1_MakeRoboShipFlame).l,a2
                jsr     CreateChild1_Normal(pc)
                st      (Ctrl_2_locked).w
                jsr     (AllocateObject).l
                bne.s   LBZShipS3_CaptureLoadCarryGraphics
                move.l  #LBZShipS3_WaitForP2Offscreen,(a1)

LBZShipS3_CaptureLoadCarryGraphics:
                jsr     LBZShip_SetPlayerCarryFrame(pc)

LBZAct2ShipS3_Capture_CullTouchAndDraw:
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------

LBZShipS3_BeginLongCarrySwing:
                move.l  #LBZShipS3_SwingDuringCarry,(a0)
                move.w  y_pos(a0),$3A(a0)
                move.w  #$100,x_vel(a0)
                move.w  #$1DF,$2E(a0)
                move.l  #LBZShipS3_BeginCarryPause,$34(a0)
                jmp     (Swing_Setup1).l
; ---------------------------------------------------------------------------

LBZShipS3_SwingDuringCarry:
                jsr     (Swing_UpAndDown).l

LBZShipS3_MoveAttachAndDrawCarry:
                jsr     (MoveSprite2).l
                bsr.w   AttachPlayer1PositionToLBZRobotnikShip
                jsr     (Obj_Wait).l
                jsr     LBZShip_SetPlayerCarryFrame(pc)
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------

LBZShipS3_BeginCarryPause:
                move.w  #$3F,$2E(a0)
                clr.w   x_vel(a0)
                move.l  #LBZAct2ShipS3_Carry_SelectTargetApproach,$34(a0)
                rts
; ---------------------------------------------------------------------------

LBZAct2ShipS3_Carry_SelectTargetApproach:
                move.l  #LBZShipS3_ApproachTargetAndSignalImpact,(a0)
                move.w  #$100,x_vel(a0)
                rts
; ---------------------------------------------------------------------------

LBZShipS3_ApproachTargetAndSignalImpact:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                bsr.w   AttachPlayer1PositionToLBZRobotnikShip
                movea.w (_unkFAA4).w,a1
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                cmpi.w  #$50,d0
                bhs.s   LBZShipS3_DrawAfterImpactCheck
                bset    #1,$38(a1)
                move.l  #LBZShipS3_SwingDuringCarry,(a0)
                move.w  #$1F,$2E(a0)
                move.l  #LBZShipS3_BeginBackwardBounce,$34(a0)

LBZShipS3_DrawAfterImpactCheck:
                jsr     LBZShip_SetPlayerCarryFrame(pc)
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------

LBZShipS3_BeginBackwardBounce:
                move.l  #LBZShipS3_BounceToSavedHeight,(a0)
                move.w  #-$200,x_vel(a0)
                move.w  #-$200,y_vel(a0)
                moveq   #signextendB(sfx_Thump),d0
                jsr     (Play_SFX).l
                rts
; ---------------------------------------------------------------------------

LBZShipS3_BounceToSavedHeight:
                jsr     (MoveSprite_LightGravity).l
                bsr.w   AttachPlayer1PositionToLBZRobotnikShip
                tst.w   y_vel(a0)
                bmi.s   LBZShipS3_DrawAfterBounce
                move.w  y_pos(a0),d0
                cmp.w   $3A(a0),d0
                blo.s   LBZShipS3_DrawAfterBounce
                move.l  #LBZShipS3_SwingDuringCarry,(a0)
                clr.w   x_vel(a0)
                move.w  #$5F,$2E(a0)
                move.l  #LBZShipS3_BeginShakeAndEventWait,$34(a0)
                jsr     (Swing_Setup1).l

LBZShipS3_DrawAfterBounce:
                jsr     LBZShip_SetPlayerCarryFrame(pc)
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------

LBZShipS3_BeginShakeAndEventWait:
                move.l  #LBZShipS3_SwingDuringCarry,(a0)
                st      (Screen_shake_flag).w
                st      (Events_fg_5).w
                move.w  #$FF,$2E(a0)
                move.l  #LBZShipS3_BeginDepartureToReleaseX,$34(a0)
                rts
; ---------------------------------------------------------------------------

LBZShipS3_BeginDepartureToReleaseX:
                move.l  #LBZShipS3_MoveAndLaunchPlayerAtX,(a0)
                move.w  #$100,x_vel(a0)
                rts
; ---------------------------------------------------------------------------

LBZShipS3_MoveAndLaunchPlayerAtX:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                bsr.w   AttachPlayer1PositionToLBZRobotnikShip
                cmpi.w  #$4440,x_pos(a0)
                blo.s   LBZShipS3_DrawCarryPoseAfterRelease
                move.l  #LBZShipS3_MoveEmptyShip,(a0)
                clr.w   (Screen_shake_flag).w
                lea     (Player_1).w,a1
                clr.b   object_control(a1)
                bset    #Status_InAir,status(a1)
                move.w  #-$100,x_vel(a1)
                move.w  #-$600,y_vel(a1)
                move.b  #2,anim(a1)
                clr.b   jumping(a1)
                jsr     (AllocateObject).l
                bne.s   LBZShipS3_DrawCarryPoseAfterRelease
                move.l  #Obj_LBZFinalBoss1,(a1)
                move.w  #$44A0,x_pos(a1)
                move.w  #$780,y_pos(a1)

; The carry graphics are still forced on the update that releases player one
LBZShipS3_DrawCarryPoseAfterRelease:
                jsr     LBZShip_SetPlayerCarryFrame(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

LBZShipS3_MoveEmptyShip:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                jmp     Sprite_CheckDeleteTouch2(pc)

; =============== S U B R O U T I N E =======================================

AttachPlayer1PositionToLBZRobotnikShip:
                lea     (Player_1).w,a1
                move.w  x_pos(a0),d0
                subq.w  #4,d0
                move.w  d0,x_pos(a1)
                move.w  y_pos(a0),d0
                subi.w  #$12,d0
                move.w  d0,y_pos(a1)
                rts
; End of function AttachPlayer1PositionToLBZRobotnikShip

; ---------------------------------------------------------------------------

LBZShipS3_WaitForP2Offscreen:
                lea     (Player_2).w,a1
                tst.l   (a1)
                beq.s   LBZShipS3_DeleteP2Cleanup
                tst.b   render_flags(a1)
                bpl.s   LBZShipS3_ClearP2AndTailsHandlers
                rts
; ---------------------------------------------------------------------------

LBZShipS3_ClearP2AndTailsHandlers:
                clr.l   (a1)
                clr.l   (Tails_tails).w

LBZShipS3_DeleteP2Cleanup:
                jmp     (Delete_Current_Sprite).l

; =============== S U B R O U T I N E =======================================

; Force the character-specific carry pose and invalidate its pattern cache before reloading
LBZShip_SetPlayerCarryFrame:
                lea     (Player_1).w,a1
                moveq   #0,d0
                move.b  character_id(a1),d0
                move.b  LBZShipS3_CarryFramesByCharacter(pc,d0.w),mapping_frame(a1)
                add.w   d0,d0
                movea.w LBZShipS3_PreviousFrameAddresses(pc,d0.w),a2
                clr.b   (a2)
                jmp     (Player_Load_PLC).l
; End of function LBZShip_SetPlayerCarryFrame

; ---------------------------------------------------------------------------
LBZShipS3_CarryFramesByCharacter:
                dc.b    $BA, $AD
                even
LBZShipS3_PreviousFrameAddresses:
                dc.w    Player_prev_frame, Player_prev_frame_P2
ObjDat_LBZ2RobotnikShip:
                dc.l    Map_RobotnikShip
                dc.w    make_art_tile(ArtTile_RobotnikShip,0,1)
                dc.w    $80
                dc.b    $20, $20,  $A, $CA

; unused
                dc.w    1-1
                dc.l    Obj_LBZ2RobotnikShip
                dc.b    0,   0

; unused
                dc.b    0,   5
                dc.b    1,   5
                dc.b    2,   5
                dc.b    3,   5
                dc.b    $FC
                even
