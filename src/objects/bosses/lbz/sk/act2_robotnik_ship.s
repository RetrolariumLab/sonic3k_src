; Owner: objects/bosses/lbz/sk
; Responsibility: Launch Base act-two Robotnik escape ship, children and private animation or object data
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_LBZ2RobotnikShip:
                move.w  a0,(Events_bg+$00).w
                lea     ObjDat_LBZ2RobotnikShip(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #loc_8D2B6,(a0)
                bset    #0,render_flags(a0)

loc_8D2B6:
                moveq   #0,d0
                move.b  collision_property(a0),d0
                beq.w   loc_8D33E
                clr.b   collision_property(a0)
                cmpi.b  #2,d0
                beq.w   loc_8D33E
                lea     (Player_1).w,a1
                tst.b   object_control(a1)
                bne.w   loc_8D33E
                move.l  #loc_8D370,(a0)
                move.b  #$83,object_control(a1)
                bclr    #0,render_flags(a1)
                bclr    #Status_Facing,status(a1)
                move.b  #5,anim(a1)
                bset    #7,art_tile(a1)
                move.w  #-$100,y_vel(a0)
                move.w  #$3F,$2E(a0)
                move.l  #loc_8D344,$34(a0)
                moveq   #signextendB(sfx_Rising),d0
                jsr     (Play_SFX).l
                st      (Anim_Counters+$F).w
                move.w  #$6000,(Camera_stored_max_X_pos).w
                lea     (Child6_IncLevX).l,a2
                jsr     (CreateChild6_Simple).l
                lea     (Child1_MakeRoboShipFlame).l,a2
                jsr     (CreateChild1_Normal).l
                jsr     LBZShip_SetPlayerCarryFrame(pc)

loc_8D33E:
                jmp     (Sprite_CheckDeleteTouch).l
; ---------------------------------------------------------------------------

loc_8D344:
                move.l  #loc_8D36A,(a0)
                move.w  y_pos(a0),$3A(a0)
                move.w  #$100,x_vel(a0)
                move.w  #$1DF,$2E(a0)
                move.l  #loc_8D38A,$34(a0)
                jmp     (Swing_Setup1).l
; ---------------------------------------------------------------------------

loc_8D36A:
                jsr     (Swing_UpAndDown).l

loc_8D370:
                jsr     (MoveSprite2).l
                bsr.w   AttachPlayer1PositionToLBZRobotnikShip
                jsr     (Obj_Wait).l
                jsr     LBZShip_SetPlayerCarryFrame(pc)
                jmp     (Sprite_CheckDeleteTouch).l
; ---------------------------------------------------------------------------

loc_8D38A:
                move.w  #$3F,$2E(a0)
                clr.w   x_vel(a0)
                move.l  #loc_8D39E,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_8D39E:
                move.l  #loc_8D3AC,(a0)
                move.w  #$100,x_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_8D3AC:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                bsr.w   AttachPlayer1PositionToLBZRobotnikShip
                movea.w (_unkFAA4).w,a1
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                cmpi.w  #$50,d0
                bhs.s   loc_8D3E8
                bset    #1,$38(a1)
                move.l  #loc_8D36A,(a0)
                move.w  #$1F,$2E(a0)
                move.l  #loc_8D3F2,$34(a0)

loc_8D3E8:
                jsr     LBZShip_SetPlayerCarryFrame(pc)
                jmp     (Sprite_CheckDeleteTouch).l
; ---------------------------------------------------------------------------

loc_8D3F2:
                move.l  #loc_8D40E,(a0)
                move.w  #-$200,x_vel(a0)
                move.w  #-$200,y_vel(a0)
                moveq   #signextendB(sfx_Thump),d0
                jsr     (Play_SFX).l
                rts
; ---------------------------------------------------------------------------

loc_8D40E:
                jsr     (MoveSprite_LightGravity).l
                bsr.w   AttachPlayer1PositionToLBZRobotnikShip
                tst.w   y_vel(a0)
                bmi.s   loc_8D446
                move.w  y_pos(a0),d0
                cmp.w   $3A(a0),d0
                blo.s   loc_8D446
                move.l  #loc_8D36A,(a0)
                clr.w   x_vel(a0)
                move.w  #$5F,$2E(a0)
                move.l  #loc_8D450,$34(a0)
                jsr     (Swing_Setup1).l

loc_8D446:
                jsr     LBZShip_SetPlayerCarryFrame(pc)
                jmp     (Sprite_CheckDeleteTouch).l
; ---------------------------------------------------------------------------

loc_8D450:
                move.l  #loc_8D36A,(a0)
                st      (Screen_shake_flag).w
                st      (Events_fg_5).w
                move.w  #$FF,$2E(a0)
                move.l  #loc_8D46E,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_8D46E:
                move.l  #loc_8D47C,(a0)
                move.w  #$100,x_vel(a0)

locret_8D47A:
                rts
; ---------------------------------------------------------------------------

loc_8D47C:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                bsr.w   AttachPlayer1PositionToLBZRobotnikShip
                cmpi.w  #$4440,x_pos(a0)
                blo.s   loc_8D4C2
                move.l  #loc_8D4CC,(a0)
                clr.w   (Screen_shake_flag).w
                lea     (Player_1).w,a1
                clr.b   object_control(a1)
                bset    #Status_InAir,status(a1)
                move.w  #-$100,x_vel(a1)
                move.w  #-$600,y_vel(a1)
                move.b  #2,anim(a1)
                clr.b   jumping(a1)

loc_8D4C2:
                jsr     LBZShip_SetPlayerCarryFrame(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_8D4CC:
                tst.b   render_flags(a0)
                bpl.s   loc_8D4E4
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                jmp     (Sprite_CheckDeleteTouch2).l
; ---------------------------------------------------------------------------

loc_8D4E4:
                jsr     (AllocateObject).l
                bne.w   locret_8D47A
                move.l  #Obj_LBZFinalBoss1,(a1)
                move.w  #$44A0,x_pos(a1)
                move.w  #$780,y_pos(a1)
                jmp     (Go_Delete_Sprite_2).l

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

loc_8D522:                                              ; used in Sonic 3, unused in Sonic 3 & Knuckles
                lea     (Player_2).w,a1
                tst.l   (a1)
                beq.s   loc_8D538
                tst.b   render_flags(a1)
                bpl.s   loc_8D532
                rts
; ---------------------------------------------------------------------------

loc_8D532:
                clr.l   (a1)
                clr.l   (Tails_tails).w

loc_8D538:
                jmp     (Delete_Current_Sprite).l

; =============== S U B R O U T I N E =======================================

; Force the character-specific carry pose and invalidate its pattern cache before reloading
LBZShip_SetPlayerCarryFrame:
                lea     (Player_1).w,a1
                moveq   #0,d0
                move.b  character_id(a1),d0
                move.b  RawAni_8D55C(pc,d0.w),mapping_frame(a1)
                add.w   d0,d0
                movea.w word_8D55E(pc,d0.w),a2
                clr.b   (a2)
                jmp     (Player_Load_PLC).l
; End of function LBZShip_SetPlayerCarryFrame

; ---------------------------------------------------------------------------
RawAni_8D55C:
                dc.b    $BA, $AD
                even
word_8D55E:
                dc.w    Player_prev_frame, Player_prev_frame_P2
ObjDat_LBZ2RobotnikShip:
                dc.l    Map_RobotnikShip
                dc.w    make_art_tile(ArtTile_RobotnikShip,0,1)
                dc.w    $80
                dc.b    $20, $20,  $A, $CA
                dc.w    1-1
                dc.l    Obj_LBZ2RobotnikShip
                dc.b    0,   0
                dc.b    0,   5
                dc.b    1,   5
                dc.b    2,   5
                dc.b    3,   5
                dc.b    $FC
                even
