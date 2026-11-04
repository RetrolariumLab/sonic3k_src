; Owner: objects/bosses/shared/sk
; Responsibility: Robotnik ship variants, escape or falling states, flames and shared difficulty-screen ship actors
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_RobotnikShip:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  RobotnikShip_Index(pc,d0.w),d1
                jsr     RobotnikShip_Index(pc,d1.w)
                btst    #6,$38(a0)
                bne.w   Obj_RobotnikHeadEnd
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
RobotnikShip_Index:
                dc.w    RobotnikSK_InitHiddenShipAndHead-RobotnikShip_Index
                dc.w    RobotnikSK_HiddenShipFollowAndTestDefeat-RobotnikShip_Index
                dc.w    RobotnikSK_HiddenShipWaitForRelease-RobotnikShip_Index
                dc.w    RobotnikSK_HiddenShipMoveAndTickFall-RobotnikShip_Index
; ---------------------------------------------------------------------------

RobotnikSK_InitHiddenShipAndHead:
                lea     ObjDat_RobotnikShip(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.b  subtype(a0),mapping_frame(a0)
                lea     (Child1_MakeRoboHead2).l,a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

RobotnikSK_HiddenShipFollowAndTestDefeat:
                jsr     (Refresh_ChildPositionAdjusted).l
                jsr     (Child_SyncDraw).l
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   RobotnikSK_HiddenShipBeginDefeat
                rts
; ---------------------------------------------------------------------------

RobotnikSK_HiddenShipBeginDefeat:
                move.b  #4,routine(a0)
                cmpi.b  #0,(Current_zone).w
                beq.s   RobotnikSK_HiddenShipTryAIZExplosion
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild6_Simple).l
                bne.s   RobotnikSK_HiddenShipExplosionReturn
                move.b  #4,subtype(a1)

RobotnikSK_HiddenShipExplosionReturn:
                rts
; ---------------------------------------------------------------------------

RobotnikSK_HiddenShipTryAIZExplosion:
                lea     (Child6_CreateBossExplosion).l,a2  ; if in Angel Island
                jsr     (CreateChild6_Simple).l
                bne.s   RobotnikSK_HiddenShipAIZExplosionReturn
                move.b  #$12,subtype(a1)

RobotnikSK_HiddenShipAIZExplosionReturn:
                rts
; ---------------------------------------------------------------------------

RobotnikSK_HiddenShipWaitForRelease:
                movea.w parent3(a0),a1
                btst    #4,$38(a1)
                bne.s   RobotnikSK_HiddenShipBeginBreakaway
                jsr     (Child_SyncDraw).l
                jmp     (Refresh_ChildPositionAdjusted).l
; ---------------------------------------------------------------------------

RobotnikSK_HiddenShipBeginBreakaway:
                move.b  #6,routine(a0)
                move.b  #5,mapping_frame(a0)
                move.w  #-$200,y_vel(a0)
                move.w  #$7F,$2E(a0)
                rts
; ---------------------------------------------------------------------------

RobotnikSK_HiddenShipMoveAndTickFall:
                jsr     (MoveSprite).l
                subq.w  #1,$2E(a0)
                bmi.s   RobotnikSK_HiddenShipSignalDone
                rts
; ---------------------------------------------------------------------------

RobotnikSK_HiddenShipSignalDone:
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
                bne.s   RobotnikSK_UnusedShipSetReadyFrame
                rts
; ---------------------------------------------------------------------------

RobotnikSK_UnusedShipSetReadyFrame:
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
                bne.s   RobotnikSK_Ship3ScheduleDeleteOnRelease
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
RobotnikShip3_Index:
                dc.w    Obj_RobotnikShipInit-RobotnikShip3_Index
                dc.w    Obj_RobotnikShipMain-RobotnikShip3_Index
                dc.w    Obj_RobotnikShipWait-RobotnikShip3_Index
                dc.w    Obj_RobotnikShipReady-RobotnikShip3_Index
                dc.w    Obj_RobotnikShipEscape-RobotnikShip3_Index
; ---------------------------------------------------------------------------

RobotnikSK_Ship3ScheduleDeleteOnRelease:
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
                bne.s   RobotnikSK_FollowShipBeginDefeat
                rts
; ---------------------------------------------------------------------------

RobotnikSK_FollowShipBeginDefeat:
                move.b  #4,routine(a0)
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild1_Normal).l
                bne.s   RobotnikSK_FollowShipExplosionReturn
                move.b  #4,subtype(a1)

RobotnikSK_FollowShipExplosionReturn:
                rts
; ---------------------------------------------------------------------------

Obj_RobotnikShipWait:
                movea.w parent3(a0),a1
                btst    #4,$38(a1)
                bne.s   RobotnikSK_FollowShipSetReadyFrame
                jmp     (Refresh_ChildPositionAdjusted).l
; ---------------------------------------------------------------------------

RobotnikSK_FollowShipSetReadyFrame:
                move.b  #6,routine(a0)
                move.b  #$A,mapping_frame(a0)
                rts
; ---------------------------------------------------------------------------

Obj_RobotnikShipReady:
                move.w  (Camera_Y_pos).w,d0
                addi.w  #$40,d0
                cmp.w   y_pos(a0),d0
                bhs.s   RobotnikSK_FollowShipBeginEscape
                subq.w  #1,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

RobotnikSK_FollowShipBeginEscape:
                move.b  #8,routine(a0)

RobotnikSK_ShipLaunchAndTryFlame:
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
                bmi.s   RobotnikSK_EscapeShipSignalDone
                rts
; ---------------------------------------------------------------------------

RobotnikSK_EscapeShipSignalDone:
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
                bne.s   RobotnikSK_FBZShipBeginDefeat
                rts
; ---------------------------------------------------------------------------

RobotnikSK_FBZShipBeginDefeat:
                move.b  #4,routine(a0)
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild1_Normal).l
                bne.s   RobotnikSK_FBZShipExplosionReturn
                move.b  #4,subtype(a1)

RobotnikSK_FBZShipExplosionReturn:
                rts
; ---------------------------------------------------------------------------

Obj_FBZRobotnikShipWait:
                movea.w parent3(a0),a1
                btst    #4,$38(a1)
                bne.s   RobotnikSK_FBZShipBeginFall
                jsr     (Child_GetPriority).l
                jmp     (Refresh_ChildPosition).l
; ---------------------------------------------------------------------------

RobotnikSK_FBZShipBeginFall:
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
                bhs.s   RobotnikSK_FBZShipLaunchAtCameraHeight
                subq.w  #1,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

RobotnikSK_FBZShipLaunchAtCameraHeight:
                move.b  #$A,routine(a0)
                bra.w   RobotnikSK_ShipLaunchAndTryFlame
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
                bne.s   RobotnikSK_ShipFlameDeleteOnRelease
                jsr     (Refresh_ChildPositionAdjusted).l
                btst    #0,(V_int_run_count+3).w
                bne.w   Obj_RobotnikHeadEnd
                tst.w   x_vel(a1)
                beq.w   Obj_RobotnikHeadEnd
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

RobotnikSK_ShipFlameDeleteOnRelease:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

Obj_Difficulty_Ship:
                move.l  #RobotnikSK_DifficultyShipSwingAndDraw,(a0)
                move.l  #Map_RobotnikShip,mappings(a0)
                move.w  #make_art_tile(ArtTile_BlueSphere_Difficulty+$EF,1,0),art_tile(a0)
                move.w  #$280,priority(a0)
                move.b  #$20,width_pixels(a0)
                move.b  #$20,height_pixels(a0)
                move.b  #$A,mapping_frame(a0)
                move.w  #$188,x_pos(a0)
                move.w  #$C0,y_pos(a0)
                jsr     (Swing_Setup1).l
                lea     Child1_DifficultyShipHead(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

RobotnikSK_DifficultyShipSwingAndDraw:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

Obj_Difficulty_ShipHead:
                move.l  #RobotnikSK_DifficultyHeadAnimateEggRobo,(a0)
                move.w  #$280,priority(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #8,height_pixels(a0)
                rts
; ---------------------------------------------------------------------------

RobotnikSK_DifficultyHeadAnimateEggRobo:
                jsr     (Refresh_ChildPositionAdjusted).l
                lea     AniRaw_EggRoboHead(pc),a1
                jsr     (Animate_RawNoSST).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
ObjDat_RobotnikHead:
                dc.l    Map_RobotnikShip
                dc.w    make_art_tile(ArtTile_RobotnikShip,0,0)
                dc.w    $280
                dc.b    $10,   8,   0,   0
ObjDat_FBZRobotnikHead:
                dc.l    Map_FBZRobotnikHead
                dc.w    make_art_tile(ArtTile_FBZRobotnikHead,0,0)
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
ObjDat_MechaSonicHead:
                dc.l    Map_MechaSonicHead
                dc.w    make_art_tile(ArtTile_RobotnikShip,1,0)
                dc.w    $280
                dc.b    $14, $10,   0,   0
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
Child1_MakeMechaHead:
                dc.w    1-1
                dc.l    Obj_MechaSonicHead
                dc.b    0,-$20
Child1_DifficultyShipHead:
                dc.w    1-1
                dc.l    Obj_Difficulty_ShipHead
                dc.b    0,-$1C
AniRaw_RobotnikHead:
                dc.b    5,   0,   1, $FC
AniRaw_EggRoboHead:
                dc.b    $F,   0,   1, $FC
                even
Map_EggRoboHead:
                include "src/objects/shared/egg_robo/mappings/head.s"
Map_MechaSonicHead:
                include "src/objects/shared/mecha_sonic/mappings/head.s"
Map_RobotnikShip:
                include "src/objects/shared/robotnik/mappings/ship.s"
Map_FBZRobotnikRun:
                include "src/objects/shared/robotnik/mappings/fbz_robotnik_run.s"
Map_FBZRobotnikHead:
                include "src/objects/shared/robotnik/mappings/fbz_robotnik_head.s"
Map_FBZRobotnikStand:
                include "src/objects/shared/robotnik/mappings/fbz_robotnik_stand.s"
