; Owner: objects/bosses/lbz/s3
; Responsibility: Launch Base act-two Robotnik escape ship, children and private animation or object data
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_LBZ2RobotnikShip:
                move.w  a0,(Events_bg+$00).w
                lea     ObjDat_LBZ2RobotnikShip(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #loc_5A84E,(a0)
                bset    #0,render_flags(a0)

loc_5A84E:
                moveq   #0,d0
                move.b  collision_property(a0),d0
                beq.w   loc_5A8E2
                clr.b   collision_property(a0)
                cmpi.b  #2,d0
                beq.w   loc_5A8E2
                lea     (Player_1).w,a1
                tst.b   object_control(a1)
                bne.w   loc_5A8E2
                move.l  #loc_5A912,(a0)
                move.b  #$83,object_control(a1)
                bclr    #0,render_flags(a1)
                bclr    #Status_Facing,status(a1)
                move.b  #5,anim(a1)
                bset    #7,art_tile(a1)
                move.w  #-$100,y_vel(a0)
                move.w  #$3F,$2E(a0)
                move.l  #loc_5A8E6,$34(a0)
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
                bne.s   loc_5A8DE
                move.l  #loc_5AAAE,(a1)

loc_5A8DE:
                jsr     sub_5AACA(pc)

loc_5A8E2:
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------

loc_5A8E6:
                move.l  #loc_5A90C,(a0)
                move.w  y_pos(a0),$3A(a0)
                move.w  #$100,x_vel(a0)
                move.w  #$1DF,$2E(a0)
                move.l  #loc_5A92A,$34(a0)
                jmp     (Swing_Setup1).l
; ---------------------------------------------------------------------------

loc_5A90C:
                jsr     (Swing_UpAndDown).l

loc_5A912:
                jsr     (MoveSprite2).l
                bsr.w   sub_5AA92
                jsr     (Obj_Wait).l
                jsr     sub_5AACA(pc)
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------

loc_5A92A:
                move.w  #$3F,$2E(a0)
                clr.w   x_vel(a0)
                move.l  #loc_5A93E,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_5A93E:
                move.l  #loc_5A94C,(a0)
                move.w  #$100,x_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_5A94C:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                bsr.w   sub_5AA92
                movea.w (_unkFAA4).w,a1
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                cmpi.w  #$50,d0
                bhs.s   loc_5A988
                bset    #1,$38(a1)
                move.l  #loc_5A90C,(a0)
                move.w  #$1F,$2E(a0)
                move.l  #loc_5A990,$34(a0)

loc_5A988:
                jsr     sub_5AACA(pc)
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------

loc_5A990:
                move.l  #loc_5A9AC,(a0)
                move.w  #-$200,x_vel(a0)
                move.w  #-$200,y_vel(a0)
                moveq   #signextendB(sfx_Thump),d0
                jsr     (Play_SFX).l
                rts
; ---------------------------------------------------------------------------

loc_5A9AC:
                jsr     (MoveSprite_LightGravity).l
                bsr.w   sub_5AA92
                tst.w   y_vel(a0)
                bmi.s   loc_5A9E4
                move.w  y_pos(a0),d0
                cmp.w   $3A(a0),d0
                blo.s   loc_5A9E4
                move.l  #loc_5A90C,(a0)
                clr.w   x_vel(a0)
                move.w  #$5F,$2E(a0)
                move.l  #loc_5A9EC,$34(a0)
                jsr     (Swing_Setup1).l

loc_5A9E4:
                jsr     sub_5AACA(pc)
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------

loc_5A9EC:
                move.l  #loc_5A90C,(a0)
                st      (Screen_shake_flag).w
                st      (Events_fg_5).w
                move.w  #$FF,$2E(a0)
                move.l  #loc_5AA0A,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_5AA0A:
                move.l  #loc_5AA18,(a0)
                move.w  #$100,x_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_5AA18:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                bsr.w   sub_5AA92
                cmpi.w  #$4440,x_pos(a0)
                blo.s   loc_5AA78
                move.l  #loc_5AA82,(a0)
                clr.w   (Screen_shake_flag).w
                lea     (Player_1).w,a1
                clr.b   object_control(a1)
                bset    #Status_InAir,status(a1)
                move.w  #-$100,x_vel(a1)
                move.w  #-$600,y_vel(a1)
                move.b  #2,anim(a1)
                clr.b   jumping(a1)
                jsr     (AllocateObject).l
                bne.s   loc_5AA78
                move.l  #Obj_LBZFinalBoss1,(a1)
                move.w  #$44A0,x_pos(a1)
                move.w  #$780,y_pos(a1)

loc_5AA78:
                jsr     sub_5AACA(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_5AA82:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                jmp     Sprite_CheckDeleteTouch2(pc)

; =============== S U B R O U T I N E =======================================

sub_5AA92:
                lea     (Player_1).w,a1
                move.w  x_pos(a0),d0
                subq.w  #4,d0
                move.w  d0,x_pos(a1)
                move.w  y_pos(a0),d0
                subi.w  #$12,d0
                move.w  d0,y_pos(a1)
                rts
; End of function sub_5AA92

; ---------------------------------------------------------------------------

loc_5AAAE:
                lea     (Player_2).w,a1
                tst.l   (a1)
                beq.s   loc_5AAC4
                tst.b   render_flags(a1)
                bpl.s   loc_5AABE
                rts
; ---------------------------------------------------------------------------

loc_5AABE:
                clr.l   (a1)
                clr.l   (Tails_tails).w

loc_5AAC4:
                jmp     (Delete_Current_Sprite).l

; =============== S U B R O U T I N E =======================================

sub_5AACA:
                lea     (Player_1).w,a1
                moveq   #0,d0
                move.b  character_id(a1),d0
                move.b  RawAni_5AAE8(pc,d0.w),mapping_frame(a1)
                add.w   d0,d0
                movea.w word_5AAEA(pc,d0.w),a2
                clr.b   (a2)
                jmp     (Player_Load_PLC).l
; End of function sub_5AACA

; ---------------------------------------------------------------------------
RawAni_5AAE8:
                dc.b    $BA, $AD
                even
word_5AAEA:
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
