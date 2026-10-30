; Owner: objects/bosses/common/s3
; Responsibility: Shared Robotnik ship variants, flight and escape states, flame actors and sprite resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_RobotnikShip:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  RobotnikShip_Index(pc,d0.w),d1
                jsr     RobotnikShip_Index(pc,d1.w)
                btst    #6,$38(a0)
                bne.w   locret_45EE0
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
RobotnikShip_Index:
                dc.w    loc_460A6-RobotnikShip_Index
                dc.w    loc_460C2-RobotnikShip_Index
                dc.w    loc_460F8-RobotnikShip_Index
                dc.w    loc_4612A-RobotnikShip_Index
; ---------------------------------------------------------------------------

loc_460A6:
                lea     ObjDat_RobotnikShip(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.b  subtype(a0),mapping_frame(a0)
                lea     (Child1_MakeRoboHead2).l,a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_460C2:
                jsr     (Refresh_ChildPositionAdjusted).l
                jsr     (Child_SyncDraw).l
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   loc_460DC
                rts
; ---------------------------------------------------------------------------

loc_460DC:
                move.b  #4,routine(a0)
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild1_Normal).l
                bne.s   locret_460F6
                move.b  #4,subtype(a1)

locret_460F6:
                rts
; ---------------------------------------------------------------------------

loc_460F8:
                movea.w parent3(a0),a1
                btst    #4,$38(a1)
                bne.s   loc_46110
                jsr     (Child_SyncDraw).l
                jmp     (Refresh_ChildPositionAdjusted).l
; ---------------------------------------------------------------------------

loc_46110:
                move.b  #6,routine(a0)
                move.b  #5,mapping_frame(a0)
                move.w  #-$200,y_vel(a0)
                move.w  #$7F,$2E(a0)
                rts
; ---------------------------------------------------------------------------

loc_4612A:
                jsr     (MoveSprite).l
                subq.w  #1,$2E(a0)
                bmi.s   loc_46138
                rts
; ---------------------------------------------------------------------------

loc_46138:
                bset    #5,$38(a0)
                clr.b   (Boss_flag).w
                jmp     (Go_Delete_Sprite_2).l
; ---------------------------------------------------------------------------

Obj_RobotnikShip2:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  RobotnikShip2_Index(pc,d0.w),d1
                jsr     RobotnikShip2_Index(pc,d1.w)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
RobotnikShip2_Index:
                dc.w    Obj_RobotnikShipInit-RobotnikShip2_Index
                dc.w    Obj_RobotnikShipMain-RobotnikShip2_Index
                dc.w    Obj_RobotnikShip2Wait-RobotnikShip2_Index
                dc.w    Obj_RobotnikShipReady-RobotnikShip2_Index
                dc.w    Obj_RobotnikShipEscape-RobotnikShip2_Index
; ---------------------------------------------------------------------------

Obj_RobotnikShip2Wait:
                movea.w parent3(a0),a1
                btst    #4,$38(a1)
                bne.s   loc_46174
                rts
; ---------------------------------------------------------------------------

loc_46174:
                move.b  #6,routine(a0)
                move.b  #5,mapping_frame(a0)
                rts
; ---------------------------------------------------------------------------

Obj_RobotnikShip3:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  RobotnikShip3_Index(pc,d0.w),d1
                jsr     RobotnikShip3_Index(pc,d1.w)
                movea.w parent3(a0),a1
                btst    #5,$38(a1)
                bne.s   loc_461AC
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
RobotnikShip3_Index:
                dc.w    Obj_RobotnikShipInit-RobotnikShip3_Index
                dc.w    Obj_RobotnikShipMain-RobotnikShip3_Index
                dc.w    Obj_RobotnikShipWait-RobotnikShip3_Index
                dc.w    Obj_RobotnikShipReady-RobotnikShip3_Index
                dc.w    Obj_RobotnikShipEscape-RobotnikShip3_Index
; ---------------------------------------------------------------------------

loc_461AC:
                jmp     (Go_Delete_Sprite_2).l
; ---------------------------------------------------------------------------

Obj_RobotnikShipInit:
                lea     ObjDat_RobotnikShip(pc),a1
                jsr     (SetUp_ObjAttributes).l
                jsr     (Child_SyncDraw).l
                move.b  subtype(a0),mapping_frame(a0)
                lea     (Child1_MakeRoboHead).l,a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

Obj_RobotnikShipMain:
                jsr     (Refresh_ChildPositionAdjusted).l
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   loc_461E8
                rts
; ---------------------------------------------------------------------------

loc_461E8:
                move.b  #4,routine(a0)
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild1_Normal).l
                bne.s   locret_46202
                move.b  #4,subtype(a1)

locret_46202:
                rts
; ---------------------------------------------------------------------------

Obj_RobotnikShipWait:
                movea.w parent3(a0),a1
                btst    #4,$38(a1)
                bne.s   loc_46216
                jmp     (Refresh_ChildPositionAdjusted).l
; ---------------------------------------------------------------------------

loc_46216:
                move.b  #6,routine(a0)
                move.b  #$A,mapping_frame(a0)
                rts
; ---------------------------------------------------------------------------

Obj_RobotnikShipReady:
                move.w  (Camera_Y_pos).w,d0
                addi.w  #$40,d0
                cmp.w   y_pos(a0),d0
                bhs.s   loc_46238
                subq.w  #1,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

loc_46238:
                move.b  #8,routine(a0)

loc_4623E:
                bset    #0,render_flags(a0)
                move.w  #$300,x_vel(a0)
                clr.w   y_vel(a0)
                move.w  #$100,$2E(a0)
                lea     Child1_MakeRoboShipFlame(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

Obj_RobotnikShipEscape:
                jsr     (MoveSprite2).l
                subq.w  #1,$2E(a0)
                bmi.s   loc_4626C
                rts
; ---------------------------------------------------------------------------

loc_4626C:
                bset    #5,$38(a0)
                clr.b   (Boss_flag).w
                jmp     (Go_Delete_Sprite_2).l
; ---------------------------------------------------------------------------

Obj_RobotnikShip4:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  RobotnikShip4_Index(pc,d0.w),d1
                jsr     RobotnikShip4_Index(pc,d1.w)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
RobotnikShip4_Index:
                dc.w    Obj_RobotnikShipInit-RobotnikShip4_Index
                dc.w    Obj_RobotnikShipMain-RobotnikShip4_Index
                dc.w    Obj_RobotnikShipWait-RobotnikShip4_Index
                dc.w    Obj_RobotnikShipReady-RobotnikShip4_Index
                dc.w    Obj_RobotnikShipEscape-RobotnikShip4_Index
; ---------------------------------------------------------------------------

Obj_FBZRobotnikShip:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  FBZRobotnikShip_Index(pc,d0.w),d1
                jsr     FBZRobotnikShip_Index(pc,d1.w)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
FBZRobotnikShip_Index:
                dc.w    Obj_FBZRobotnikShipInit-FBZRobotnikShip_Index
                dc.w    Obj_FBZRobotnikShipMain-FBZRobotnikShip_Index
                dc.w    Obj_FBZRobotnikShipWait-FBZRobotnikShip_Index
                dc.w    Obj_FBZRobotnikShipFall-FBZRobotnikShip_Index
                dc.w    Obj_FBZRobotnikShipRise-FBZRobotnikShip_Index
                dc.w    Obj_RobotnikShipEscape-FBZRobotnikShip_Index
; ---------------------------------------------------------------------------

Obj_FBZRobotnikShipInit:
                lea     ObjDat_RobotnikShip(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.b  subtype(a0),mapping_frame(a0)
                lea     (Child1_MakeFBZRoboHead).l,a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

Obj_FBZRobotnikShipMain:
                jsr     (Refresh_ChildPosition).l
                jsr     (Child_GetPriority).l
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   loc_462F0
                rts
; ---------------------------------------------------------------------------

loc_462F0:
                move.b  #4,routine(a0)
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild1_Normal).l
                bne.s   locret_4630A
                move.b  #4,subtype(a1)

locret_4630A:
                rts
; ---------------------------------------------------------------------------

Obj_FBZRobotnikShipWait:
                movea.w parent3(a0),a1
                btst    #4,$38(a1)
                bne.s   loc_46324
                jsr     (Child_GetPriority).l
                jmp     (Refresh_ChildPosition).l
; ---------------------------------------------------------------------------

loc_46324:
                move.b  #6,routine(a0)
                move.b  #5,mapping_frame(a0)
                clr.w   x_vel(a0)
                move.w  #-$200,y_vel(a0)
                move.w  #$2F,$2E(a0)
                move.l  #Obj_FBZRobotnikShipReadyGo,$34(a0)
                rts
; ---------------------------------------------------------------------------

Obj_FBZRobotnikShipFall:
                jsr     (MoveSprite).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

Obj_FBZRobotnikShipReadyGo:
                move.b  #8,routine(a0)
                bset    #0,render_flags(a0)
                rts
; ---------------------------------------------------------------------------

Obj_FBZRobotnikShipRise:
                move.w  (Camera_Y_pos).w,d0
                addi.w  #$C0,d0
                cmp.w   y_pos(a0),d0
                bhs.s   loc_46378
                subq.w  #1,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

loc_46378:
                move.b  #$A,routine(a0)
                bra.w   loc_4623E
; ---------------------------------------------------------------------------

Obj_RobotnikShipFlame:
                lea     ObjDat3_RoboShipFlame(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #Obj_RobotnikShipFlameMain,(a0)
                rts
; ---------------------------------------------------------------------------

Obj_RobotnikShipFlameMain:
                movea.w parent3(a0),a1
                btst    #4,$38(a1)
                bne.s   loc_463B6
                jsr     (Refresh_ChildPositionAdjusted).l
                btst    #0,(V_int_run_count+3).w
                bne.w   locret_45EE0
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_463B6:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------
ObjDat_RobotnikHead:
                dc.l    Map_RobotnikShip
                dc.w    make_art_tile(ArtTile_RobotnikShip,0,0)
                dc.w    $280
                dc.b    $10,   8,   0,   0
ObjDat_FBZRobotnikHead:
                dc.l    Map_FBZRobotnikHead
                dc.w    make_art_tile(ArtTile_FBZRobotnikHead-$20,0,0)
                dc.w    $280
                dc.b    $10,   8,   0,   0
ObjDat_RobotnikShip:
                dc.l    Map_RobotnikShip
                dc.w    make_art_tile(ArtTile_RobotnikShip,0,0)
                dc.w    $280
                dc.b    $1C, $20,   8,   0
ObjDat3_RoboShipFlame:
                dc.w    $280
                dc.b    8,   4,   6,   0
Child1_MakeRoboHead:
                dc.w    1-1
                dc.l    Obj_RobotnikHead
                dc.b    0,-$1C
Child1_MakeRoboHead2:
                dc.w    1-1
                dc.l    Obj_RobotnikHead2
                dc.b    0,-$1C
Child1_MakeFBZRoboHead:
                dc.w    1-1
                dc.l    Obj_FBZRobotnikHead
                dc.b    0,-$1C
Child1_MakeRoboHead3:
                dc.w    1-1
                dc.l    Obj_RobotnikHead3
                dc.b    0,-$1C
Child1_MakeRoboHead4:
                dc.w    1-1
                dc.l    Obj_RobotnikHead4
                dc.b    0,-$1C
Child1_MakeRoboShip:
                dc.w    1-1
                dc.l    Obj_RobotnikShip
                dc.b    0,-$14
Child1_MakeRoboShip2:                                   ; unused
                dc.w    1-1
                dc.l    Obj_RobotnikShip2
                dc.b    0,   0
Child1_MakeRoboShip3:
                dc.w    1-1
                dc.l    Obj_RobotnikShip3
                dc.b    -6,   4
Child1_MakeRoboShip4:
                dc.w    1-1
                dc.l    Obj_RobotnikShip4
                dc.b    0,  -8
Child1_MakeFBZRoboShip:
                dc.w    1-1
                dc.l    Obj_FBZRobotnikShip
                dc.b    0,   4
Child1_MakeRoboShipFlame:
                dc.w    1-1
                dc.l    Obj_RobotnikShipFlame
                dc.b    $1E,   0
AniRaw_RobotnikHead:
                dc.b    5,   0,   1, $FC
                even
