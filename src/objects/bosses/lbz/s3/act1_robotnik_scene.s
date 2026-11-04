; Owner: objects/bosses/lbz/s3
; Responsibility: Launch Base act-one Robotnik and miniboss-box scene states, helpers and private object records
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_LBZ1Robotnik:
                lea     word_5A2F0(pc),a1
                jsr     Check_CameraInRange(pc)
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  LBZ1Robotnik_Index(pc,d0.w),d1
                jsr     LBZ1Robotnik_Index(pc,d1.w)
                jsr     (UpdateLBZAct1RobotnikHitCooldown).l
                jmp     Draw_And_Touch_Sprite(pc)
; ---------------------------------------------------------------------------
LBZ1Robotnik_Index:
                dc.w    loc_5A2F8-LBZ1Robotnik_Index
                dc.w    loc_5A348-LBZ1Robotnik_Index
                dc.w    loc_5A380-LBZ1Robotnik_Index
                dc.w    loc_5A3AC-LBZ1Robotnik_Index
                dc.w    loc_5A3D6-LBZ1Robotnik_Index
                dc.w    loc_5A406-LBZ1Robotnik_Index
                dc.w    loc_5A436-LBZ1Robotnik_Index
                dc.w    loc_5A47E-LBZ1Robotnik_Index
word_5A2F0:
                dc.w    $500,  $5E0, $3820, $3AC0
; ---------------------------------------------------------------------------

loc_5A2F8:
                lea     ObjDat_LBZ1Robotnik(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.b  #-1,collision_property(a0)
                st      (_unkFAAB).w
                jsr     (Swing_Setup1).l
                move.w  #$3820,(Camera_min_X_pos).w
                move.w  #$3AE8,(Camera_max_X_pos).w
                moveq   #PLCID_60,d0
                jsr     (Load_PLC).l
                lea     (ArtKosM_LBZMinibossBox).l,a1
                move.w  #tiles_to_bytes(ArtTile_LBZMinibossBox),d2
                jsr     (Queue_Kos_Module).l
                lea     (Child1_MakeRoboHead3).l,a2
                jsr     CreateChild1_Normal(pc)
                lea     ChildObjDat_5A800(pc),a2
                jmp     CreateChild3_NormalRepeated(pc)
; ---------------------------------------------------------------------------

loc_5A348:
                lea     (Player_1).w,a1
                jsr     Find_OtherObject(pc)
                tst.w   d1
                beq.s   loc_5A372
                cmpi.w  #$70,d2
                bhs.s   loc_5A368
                cmpi.w  #$60,d3
                bhs.s   loc_5A368
                btst    #Status_InAir,status(a1)
                beq.s   loc_5A372

loc_5A368:
                jsr     Swing_UpAndDown(pc)
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

loc_5A372:
                move.b  #4,routine(a0)
                move.w  #-$400,y_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_5A380:
                cmpi.w  #$300,y_pos(a0)
                blo.s   loc_5A38E
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

loc_5A38E:
                move.b  #6,routine(a0)
                bset    #0,render_flags(a0)
                move.w  #$3EC0,x_pos(a0)
                move.w  #$1A0,y_pos(a0)
                jmp     (Swing_Setup1).l
; ---------------------------------------------------------------------------

loc_5A3AC:
                lea     (Player_1).w,a1
                cmpi.w  #$3B40,(Camera_X_pos).w
                blo.s   locret_5A3C8
                cmpi.w  #$1C0,y_pos(a1)
                blo.s   locret_5A3C8
                btst    #Status_InAir,status(a1)
                beq.s   loc_5A3CA

locret_5A3C8:
                rts
; ---------------------------------------------------------------------------

loc_5A3CA:
                move.b  #8,routine(a0)
                st      (Events_fg_4).w
                rts
; ---------------------------------------------------------------------------

loc_5A3D6:
                tst.w   (Events_fg_4).w
                beq.s   loc_5A3DE
                rts
; ---------------------------------------------------------------------------

loc_5A3DE:
                move.b  #$A,routine(a0)
                lea     (ArtKosM_LBZMinibossBox).l,a1
                move.w  #tiles_to_bytes(ArtTile_LBZMinibossBox),d2
                jsr     (Queue_Kos_Module).l
                move.w  #$3EA0,(Camera_stored_max_X_pos).w
                lea     (Child6_IncLevX).l,a2
                jmp     (CreateChild6_Simple).l
; ---------------------------------------------------------------------------

loc_5A406:
                move.w  (Camera_X_pos).w,d0
                cmpi.w  #$3E50,d0
                bhs.s   loc_5A414
                move.w  d0,(Camera_min_X_pos).w

loc_5A414:
                jsr     Find_SonicTails(pc)
                cmpi.w  #$60,d2
                blo.s   loc_5A428
                jsr     Swing_UpAndDown(pc)
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

loc_5A428:
                move.b  #$C,routine(a0)
                move.w  #-$400,y_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_5A436:
                cmpi.w  #$12C,y_pos(a0)
                bls.s   loc_5A444
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

loc_5A444:
                move.b  #$E,routine(a0)
                move.w  #$12C,y_pos(a0)
                bset    #1,$38(a0)
                move.w  #$200,x_vel(a0)
                move.w  #$200,y_vel(a0)
                lea     (ArtKosM_LBZMiniboss).l,a1
                move.w  #tiles_to_bytes(ArtTile_LBZMiniboss),d2
                jsr     (Queue_Kos_Module).l
                lea     (Child1_MakeRoboShipFlame).l,a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_5A47E:
                jsr     (MoveSprite2).l
                cmpi.w  #$1B8,y_pos(a0)
                bhs.s   loc_5A48E
                rts
; ---------------------------------------------------------------------------

loc_5A48E:
                move.l  #loc_5A49A,(a0)
                clr.w   y_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_5A49A:
                jsr     (MoveSprite2).l
                jsr     (UpdateLBZAct1RobotnikHitCooldown).l
                jmp     Sprite_CheckDeleteTouch2(pc)
; ---------------------------------------------------------------------------

loc_5A4AA:
                move.l  #loc_5A4BA,(a0)
                lea     ChildObjDat_5A808(pc),a2
                jmp     (CreateChild3_NormalRepeated).l
; ---------------------------------------------------------------------------

loc_5A4BA:
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                beq.s   loc_5A4E0
                move.l  #Obj_Wait,(a0)
                move.w  #$1F,$2E(a0)
                move.l  #loc_5A4E4,$34(a0)
                move.w  #$160,y_pos(a0)

loc_5A4E0:
                jmp     Refresh_ChildPosition(pc)
; ---------------------------------------------------------------------------

loc_5A4E4:
                jsr     (AllocateObject).l
                bne.s   loc_5A4F8
                move.l  #Obj_Song_Fade_Transition,(a1)
                move.b  #mus_Miniboss,subtype(a1)

loc_5A4F8:
                bset    #3,$38(a0)
                moveq   #signextendB(sfx_BossActivate),d0
                jsr     (Play_SFX).l
                lea     ChildObjDat_5A810(pc),a2
                jsr     CreateChild1_Normal(pc)
                jmp     Go_Delete_Sprite_2(pc)
; ---------------------------------------------------------------------------

Obj_LBZMinibossBox:
                tst.b   (_unkFAAB).w
                bne.s   loc_5A572
                move.l  #loc_5A57A,(a0)
                move.w  #$3EA0,(Camera_max_X_pos).w
                move.w  #$3C00,(Camera_min_X_pos).w
                lea     (ArtKosM_LBZMiniboss).l,a1
                move.w  #tiles_to_bytes(ArtTile_LBZMiniboss),d2
                jsr     (Queue_Kos_Module).l
                lea     (ArtKosM_LBZMinibossBox).l,a1
                move.w  #tiles_to_bytes(ArtTile_LBZMinibossBox),d2
                jsr     (Queue_Kos_Module).l
                lea     PLC_BossExplosion(pc),a1
                jsr     (Load_PLC_Raw).l
                jsr     (AllocateObject).l
                bne.s   loc_5A568
                move.l  #Obj_Song_Fade_Transition,(a1)
                move.b  #mus_Miniboss,subtype(a1)

loc_5A568:
                lea     ChildObjDat_5A808(pc),a2
                jmp     (CreateChild3_NormalRepeated).l
; ---------------------------------------------------------------------------

loc_5A572:
                move.l  #Delete_Sprite_If_Not_In_Range,(a0)
                rts
; ---------------------------------------------------------------------------

loc_5A57A:
                lea     (Player_1).w,a1
                jsr     (Find_OtherObject).l
                cmpi.w  #$70,d2
                bhs.s   loc_5A5A4
                move.l  #Obj_Wait,(a0)
                move.w  #$3DA0,(Camera_min_X_pos).w
                move.w  #$1F,$2E(a0)
                move.l  #loc_5A4F8,$34(a0)

loc_5A5A4:
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.s   loc_5A5B8
                rts
; ---------------------------------------------------------------------------

loc_5A5B8:
                jmp     S3Cull_ReleaseRespawnForStatusDelete(pc)
; ---------------------------------------------------------------------------

loc_5A5BC:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_5A5E0(pc,d0.w),d1
                jsr     off_5A5E0(pc,d1.w)
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   loc_5A5DC
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_5A5DC:
                jmp     Go_Delete_Sprite(pc)
; ---------------------------------------------------------------------------
off_5A5E0:
                dc.w    loc_5A5EC-off_5A5E0
                dc.w    loc_5A5FA-off_5A5E0
                dc.w    loc_5A618-off_5A5E0
                dc.w    loc_5A626-off_5A5E0
                dc.w    loc_5A672-off_5A5E0
                dc.w    loc_5A688-off_5A5E0
; ---------------------------------------------------------------------------

loc_5A5EC:
                lea     ObjDat3_5A7F4(pc),a1
                jsr     (SetUp_ObjAttributes).l
                bra.w   loc_5A6E4
; ---------------------------------------------------------------------------

loc_5A5FA:
                movea.w parent3(a0),a1
                btst    #3,$38(a1)
                bne.s   loc_5A60A
                jmp     Refresh_ChildPosition(pc)
; ---------------------------------------------------------------------------

loc_5A60A:
                move.b  #4,routine(a0)
                move.w  #$55,(Events_fg_4).w
                rts
; ---------------------------------------------------------------------------

loc_5A618:
                subq.w  #1,$2E(a0)
                bpl.s   locret_5A624
                move.b  #6,routine(a0)

locret_5A624:
                rts
; ---------------------------------------------------------------------------

loc_5A626:
                jmp     (Animate_Raw).l
; ---------------------------------------------------------------------------

loc_5A62C:
                move.b  #8,routine(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                subi.w  #$C,d0
                move.w  word_5A66A(pc,d0.w),y_vel(a0)
                add.w   d0,d0
                move.l  off_5A65A(pc,d0.w),$30(a0)
                move.l  #loc_5A68E,$34(a0)
                move.w  #$5F,$2E(a0)
                rts
; ---------------------------------------------------------------------------
off_5A65A:
                dc.l    byte_5A822
                dc.l    byte_5A822
                dc.l    byte_5A827
                dc.l    byte_5A827
word_5A66A:
                dc.w    -$40,   $40,  -$40,   $40
; ---------------------------------------------------------------------------

loc_5A672:
                jsr     (MoveSprite2).l
                subq.w  #1,$2E(a0)
                bmi.s   loc_5A680
                rts
; ---------------------------------------------------------------------------

loc_5A680:
                move.b  #$A,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_5A688:
                jmp     (Animate_Raw).l
; ---------------------------------------------------------------------------

loc_5A68E:
                move.l  #loc_5A69C,(a0)
                move.w  #$380,priority(a0)
                rts
; ---------------------------------------------------------------------------

loc_5A69C:
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.s   loc_5A6B4
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_5A6B4:
                cmpi.b  #$C,subtype(a0)
                bne.s   loc_5A6D0
                lea     PLC_MonitorsSpikesSprings(pc),a1
                jsr     (Load_PLC_Raw).l
                lea     PLC_LBZRobotnikAfter(pc),a1
                jsr     (Load_PLC_Raw).l

loc_5A6D0:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------
PLC_LBZRobotnikAfter:   plrlistheader
                plreq   ArtTile_Bubbles, ArtNem_Bubbles
PLC_LBZRobotnikAfter_End:
; unused
                plreq   ArtTile_LBZMisc, ArtNem_LBZMisc
; ---------------------------------------------------------------------------

loc_5A6E4:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  word_5A728(pc,d0.w),$2E(a0)
                add.w   d0,d0
                move.l  off_5A73C(pc,d0.w),$30(a0)
                move.l  off_5A764(pc,d0.w),$34(a0)
                lea     byte_5A78C(pc),a1
                adda.w  d0,a1
                move.b  (a1)+,mapping_frame(a0)
                move.b  (a1)+,d1
                or.b    d1,render_flags(a0)
                move.b  (a1)+,d1
                move.b  d1,child_dx(a0)
                ext.w   d1
                add.w   d1,x_pos(a0)
                move.b  (a1)+,d1
                move.b  d1,child_dy(a0)
                ext.w   d1
                add.w   d1,y_pos(a0)
                rts
; ---------------------------------------------------------------------------
word_5A728:
                dc.w    0
                dc.w    0
                dc.w    $10
                dc.w    $10
                dc.w    $10
                dc.w    $10
                dc.w    $40
                dc.w    $50
                dc.w    $70
                dc.w    $60
off_5A73C:
                dc.l    byte_5A818
                dc.l    byte_5A818
                dc.l    byte_5A81D
                dc.l    byte_5A81D
                dc.l    byte_5A81D
                dc.l    byte_5A81D
                dc.l    byte_5A82C
                dc.l    byte_5A82C
                dc.l    byte_5A830
                dc.l    byte_5A830
off_5A764:
                dc.l    Go_Delete_Sprite
                dc.l    Go_Delete_Sprite
                dc.l    Go_Delete_Sprite
                dc.l    Go_Delete_Sprite
                dc.l    Go_Delete_Sprite
                dc.l    Go_Delete_Sprite
                dc.l    loc_5A62C
                dc.l    loc_5A62C
                dc.l    loc_5A62C
                dc.l    loc_5A62C
byte_5A78C:
                dc.b    6,   0,-$10,   0
                dc.b    6,   2, $10,   0
                dc.b    9,   0,   0, $14
                dc.b    9,   1,   0,  $C
                dc.b    9,   0,   0, -$C
                dc.b    9,   1,   0,-$14
                dc.b    0,   0, -$C,-$10
                dc.b    0,   3,  $C, $10
                dc.b    3,   0, $14, -$C
                dc.b    3,   3,-$14,  $C
                even

; =============== S U B R O U T I N E =======================================

UpdateLBZAct1RobotnikHitCooldown:
                tst.b   collision_flags(a0)
                bne.s   locret_5A7E6
                tst.b   $20(a0)
                bne.s   loc_5A7D4
                move.b  #$20,$20(a0)
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l
                bset    #6,status(a0)

loc_5A7D4:
                subq.b  #1,$20(a0)
                bne.s   locret_5A7E6
                bclr    #6,status(a0)
                move.b  $25(a0),collision_flags(a0)

locret_5A7E6:
                rts
; End of function UpdateLBZAct1RobotnikHitCooldown

; ---------------------------------------------------------------------------
ObjDat_LBZ1Robotnik:
                dc.l    Map_RobotnikShip
                dc.w    make_art_tile(ArtTile_RobotnikShip,0,0)
                dc.w    $100
                dc.b    $20, $20,  $A,  $F
ObjDat3_5A7F4:
                dc.l    Map_LBZMinibossBox
                dc.w    make_art_tile(ArtTile_LBZMinibossBox,2,0)
                dc.w    $100
                dc.b    $14, $14,   0,   0
ChildObjDat_5A800:
                dc.w    1-1
                dc.l    loc_5A4AA
                dc.b    0, $34
ChildObjDat_5A808:
                dc.w    $A-1
                dc.l    loc_5A5BC
                dc.b    0,   0
ChildObjDat_5A810:
                dc.w    1-1
                dc.l    Obj_LBZMiniboss
                dc.b    0,   0
byte_5A818:
                dc.b    0,   6,   7,   8, $F4
byte_5A81D:
                dc.b    0,   9,  $A,  $B, $F4
byte_5A822:
                dc.b    5,   0,   1,   2, $F4
byte_5A827:
                dc.b    5,   3,   4,   5, $F4
byte_5A82C:
                dc.b    0,   0,   0, $F4
byte_5A830:
                dc.b    0,   3,   3, $F4
                even
