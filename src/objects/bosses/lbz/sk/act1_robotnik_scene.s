; Owner: objects/bosses/lbz/sk
; Responsibility: Launch Base act-one Robotnik and miniboss-box scene states, helpers and private object records
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_LBZ1Robotnik:
                cmpi.b  #2,(Player_1+character_id).w
                beq.s   loc_8CB90
                lea     word_8CB96(pc),a1
                jsr     Check_CameraInRange(pc)
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  LBZ1Robotnik_Index(pc,d0.w),d1
                jsr     LBZ1Robotnik_Index(pc,d1.w)
                jsr     (UpdateLBZAct1RobotnikHitCooldown).l
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------
LBZ1Robotnik_Index:
                dc.w    loc_8CB9E-LBZ1Robotnik_Index
                dc.w    loc_8CBF2-LBZ1Robotnik_Index
                dc.w    loc_8CC2E-LBZ1Robotnik_Index
                dc.w    loc_8CC5A-LBZ1Robotnik_Index
                dc.w    loc_8CC84-LBZ1Robotnik_Index
                dc.w    loc_8CCB4-LBZ1Robotnik_Index
                dc.w    loc_8CCE8-LBZ1Robotnik_Index
                dc.w    loc_8CD30-LBZ1Robotnik_Index
; ---------------------------------------------------------------------------

loc_8CB90:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------
word_8CB96:
                dc.w    $500,  $5E0, $3820, $3AC0
; ---------------------------------------------------------------------------

loc_8CB9E:
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
                jsr     (CreateChild1_Normal).l
                lea     ChildObjDat_8D254(pc),a2
                jmp     (CreateChild3_NormalRepeated).l
; ---------------------------------------------------------------------------

loc_8CBF2:
                lea     (Player_1).w,a1
                jsr     (Find_OtherObject).l
                tst.w   d1
                beq.s   loc_8CC20
                cmpi.w  #$70,d2
                bhs.s   loc_8CC14
                cmpi.w  #$60,d3
                bhs.s   loc_8CC14
                btst    #Status_InAir,status(a1)
                beq.s   loc_8CC20

loc_8CC14:
                jsr     (Swing_UpAndDown).l
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

loc_8CC20:
                move.b  #4,routine(a0)
                move.w  #-$400,y_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_8CC2E:
                cmpi.w  #$300,y_pos(a0)
                blo.s   loc_8CC3C
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

loc_8CC3C:
                move.b  #6,routine(a0)
                bset    #0,render_flags(a0)
                move.w  #$3EC0,x_pos(a0)
                move.w  #$1A0,y_pos(a0)
                jmp     (Swing_Setup1).l
; ---------------------------------------------------------------------------

loc_8CC5A:
                lea     (Player_1).w,a1
                cmpi.w  #$3B40,(Camera_X_pos).w
                blo.s   locret_8CC76
                cmpi.w  #$1C0,y_pos(a1)
                blo.s   locret_8CC76
                btst    #Status_InAir,status(a1)
                beq.s   loc_8CC78

locret_8CC76:
                rts
; ---------------------------------------------------------------------------

loc_8CC78:
                move.b  #8,routine(a0)
                st      (Events_fg_4).w
                rts
; ---------------------------------------------------------------------------

loc_8CC84:
                tst.w   (Events_fg_4).w
                beq.s   loc_8CC8C
                rts
; ---------------------------------------------------------------------------

loc_8CC8C:
                move.b  #$A,routine(a0)
                lea     (ArtKosM_LBZMinibossBox).l,a1
                move.w  #tiles_to_bytes(ArtTile_LBZMinibossBox),d2
                jsr     (Queue_Kos_Module).l
                move.w  #$3EA0,(Camera_stored_max_X_pos).w
                lea     (Child6_IncLevX).l,a2
                jmp     (CreateChild6_Simple).l
; ---------------------------------------------------------------------------

loc_8CCB4:
                move.w  (Camera_X_pos).w,d0
                cmpi.w  #$3E50,d0
                bhs.s   loc_8CCC2
                move.w  d0,(Camera_min_X_pos).w

loc_8CCC2:
                jsr     (Find_SonicTails).l
                cmpi.w  #$60,d2
                blo.s   loc_8CCDA
                jsr     (Swing_UpAndDown).l
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

loc_8CCDA:
                move.b  #$C,routine(a0)
                move.w  #-$400,y_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_8CCE8:
                cmpi.w  #$12C,y_pos(a0)
                bls.s   loc_8CCF6
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

loc_8CCF6:
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

loc_8CD30:
                jsr     (MoveSprite2).l
                cmpi.w  #$1B8,y_pos(a0)
                bhs.s   loc_8CD40
                rts
; ---------------------------------------------------------------------------

loc_8CD40:
                move.l  #loc_8CD4C,(a0)
                clr.w   y_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_8CD4C:
                jsr     (MoveSprite2).l
                jsr     (UpdateLBZAct1RobotnikHitCooldown).l
                jmp     Sprite_CheckDeleteTouch2(pc)
; ---------------------------------------------------------------------------

loc_8CD5C:
                move.l  #loc_8CD6C,(a0)
                lea     ChildObjDat_8D25C(pc),a2
                jmp     (CreateChild3_NormalRepeated).l
; ---------------------------------------------------------------------------

loc_8CD6C:
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                beq.s   loc_8CD92
                move.l  #Obj_Wait,(a0)
                move.w  #$1F,$2E(a0)
                move.l  #loc_8CD98,$34(a0)
                move.w  #$160,y_pos(a0)

loc_8CD92:
                jmp     (Refresh_ChildPosition).l
; ---------------------------------------------------------------------------

loc_8CD98:
                bsr.w   ScheduleLBZMinibossMusicTransition

loc_8CD9C:
                bset    #3,$38(a0)
                moveq   #signextendB(sfx_BossActivate),d0
                jsr     (Play_SFX).l
                lea     ChildObjDat_8D264(pc),a2
                jsr     (CreateChild1_Normal).l
                jmp     Go_Delete_Sprite_2(pc)
; ---------------------------------------------------------------------------

Obj_LBZMinibossBox:
                cmpi.b  #2,(Player_1+character_id).w
                beq.s   loc_8CDEA
                tst.b   (_unkFAAB).w
                bne.s   loc_8CDEA
                move.l  #loc_8CDF2,(a0)
                move.w  #$3EA0,(Camera_max_X_pos).w
                move.w  #$3C00,(Camera_min_X_pos).w
                lea     ChildObjDat_8D25C(pc),a2
                jsr     (CreateChild3_NormalRepeated).l
                bsr.w   ScheduleLBZMinibossMusicTransition
                bra.w   QueueLBZMinibossBoxAndExplosionGraphics
; ---------------------------------------------------------------------------

loc_8CDEA:
                move.l  #Delete_Sprite_If_Not_In_Range,(a0)
                rts
; ---------------------------------------------------------------------------

loc_8CDF2:
                lea     (Player_1).w,a1
                jsr     (Find_OtherObject).l
                cmpi.w  #$70,d2
                bhs.s   loc_8CE1C
                move.l  #Obj_Wait,(a0)
                move.w  #$3DA0,(Camera_min_X_pos).w
                move.w  #$1F,$2E(a0)
                move.l  #loc_8CD9C,$34(a0)

loc_8CE1C:
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.s   loc_8CE30
                rts
; ---------------------------------------------------------------------------

loc_8CE30:
                jmp     SKCull_ReleaseRespawnForStatusDelete(pc)
; ---------------------------------------------------------------------------

loc_8CE34:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_8CE58(pc,d0.w),d1
                jsr     off_8CE58(pc,d1.w)
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   loc_8CE54
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_8CE54:
                jmp     Go_Delete_Sprite(pc)
; ---------------------------------------------------------------------------
off_8CE58:
                dc.w    loc_8CE64-off_8CE58
                dc.w    loc_8CE72-off_8CE58
                dc.w    loc_8CE9A-off_8CE58
                dc.w    loc_8CEA8-off_8CE58
                dc.w    loc_8CEF4-off_8CE58
                dc.w    loc_8CF0A-off_8CE58
; ---------------------------------------------------------------------------

loc_8CE64:
                lea     ObjDat3_8D23C(pc),a1
                jsr     (SetUp_ObjAttributes).l
                bra.w   loc_8D12C
; ---------------------------------------------------------------------------

loc_8CE72:
                movea.w parent3(a0),a1
                btst    #3,$38(a1)
                bne.s   loc_8CE84
                jmp     (Refresh_ChildPosition).l
; ---------------------------------------------------------------------------

loc_8CE84:
                move.b  #4,routine(a0)
                cmpi.b  #2,(Player_1+character_id).w
                beq.s   locret_8CE98
                move.w  #$55,(Events_fg_4).w

locret_8CE98:
                rts
; ---------------------------------------------------------------------------

loc_8CE9A:
                subq.w  #1,$2E(a0)
                bpl.s   locret_8CEA6
                move.b  #6,routine(a0)

locret_8CEA6:
                rts
; ---------------------------------------------------------------------------

loc_8CEA8:
                jmp     (Animate_Raw).l
; ---------------------------------------------------------------------------

loc_8CEAE:
                move.b  #8,routine(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                subi.w  #$C,d0
                move.w  word_8CEEC(pc,d0.w),y_vel(a0)
                add.w   d0,d0
                move.l  off_8CEDC(pc,d0.w),$30(a0)
                move.l  #loc_8CF10,$34(a0)
                move.w  #$5F,$2E(a0)
                rts
; ---------------------------------------------------------------------------
off_8CEDC:
                dc.l    byte_8D28A
                dc.l    byte_8D28A
                dc.l    byte_8D28F
                dc.l    byte_8D28F
word_8CEEC:
                dc.w    -$40,   $40,  -$40,   $40
; ---------------------------------------------------------------------------

loc_8CEF4:
                jsr     (MoveSprite2).l
                subq.w  #1,$2E(a0)
                bmi.s   loc_8CF02
                rts
; ---------------------------------------------------------------------------

loc_8CF02:
                move.b  #$A,routine(a0)

locret_8CF08:
                rts
; ---------------------------------------------------------------------------

loc_8CF0A:
                jmp     (Animate_Raw).l
; ---------------------------------------------------------------------------

loc_8CF10:
                move.l  #loc_8CF1E,(a0)
                move.w  #$380,priority(a0)
                rts
; ---------------------------------------------------------------------------

loc_8CF1E:
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.s   loc_8CF36
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_8CF36:
                cmpi.b  #2,(Player_1+character_id).w
                beq.s   loc_8CF52
                cmpi.b  #$C,subtype(a0)
                bne.s   loc_8CF5C
                lea     (PLC_MonitorsSpikesSprings).l,a1
                jsr     (Load_PLC_Raw).l

loc_8CF52:
                lea     PLC_LBZRobotnikAfter(pc),a1
                jsr     (Load_PLC_Raw).l

loc_8CF5C:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------
PLC_LBZRobotnikAfter:   plrlistheader
                plreq   ArtTile_Bubbles, ArtNem_Bubbles
PLC_LBZRobotnikAfter_End:
                plreq   ArtTile_LBZMisc, ArtNem_LBZMisc

word_8CF70:
                dc.w    $7B6,  $9C0, $3BA0, $3CA0
                dc.w    $7B6,  $936, $3BC0, $3C80
; ---------------------------------------------------------------------------

Obj_LBZMinibossBoxKnux:
                lea     word_8CF70(pc),a1
                jsr     (Check_CameraInRange).l
                move.w  (a1)+,(Camera_min_Y_pos).w
                move.w  (a1),(Camera_max_Y_pos).w
                move.w  (a1)+,(Camera_target_max_Y_pos).w
                move.w  (a1)+,(Camera_min_X_pos).w
                move.w  (a1)+,(Camera_max_X_pos).w
                bsr.w   QueueLBZMinibossBoxAndExplosionGraphics
                lea     ChildObjDat_8D26C(pc),a2
                jsr     (CreateChild1_Normal).l
                move.l  #loc_8CFB2,(a0)

loc_8CFB2:
                cmpi.w  #$932,(Camera_Y_pos).w
                blo.s   locret_8CFC6
                move.l  #loc_8CFC8,(a0)
                bset    #1,$38(a0)

locret_8CFC6:
                rts
; ---------------------------------------------------------------------------

loc_8CFC8:
                move.b  $38(a0),d0
                andi.b  #5,d0
                cmpi.b  #5,d0
                bne.w   locret_8CF08
                move.l  #loc_8D018,(a0)
                move.w  #$1F,$2E(a0)
                move.w  #$A80,d0
                move.w  d0,(Camera_stored_max_Y_pos).w
                move.w  d0,(Camera_target_max_Y_pos).w
                jsr     (AllocateObject).l
                bne.s   loc_8CFFE
                move.l  #Obj_Song_Fade_ToLevelMusic,(a1)

loc_8CFFE:
                clr.b   (Update_HUD_timer).w
                lea     (Child6_IncLevY).l,a2
                jsr     (CreateChild6_Simple).l
                lea     ChildObjDat_8D27A(pc),a2
                jmp     (CreateChild6_Simple).l
; ---------------------------------------------------------------------------

loc_8D018:
                subq.w  #1,$2E(a0)
                bmi.s   loc_8D020
                rts
; ---------------------------------------------------------------------------

loc_8D020:
                move.l  #loc_8D02E,(a0)
                move.w  #$55,(Events_fg_4).w
                rts
; ---------------------------------------------------------------------------

loc_8D02E:
                cmpi.w  #$A7C,(Camera_Y_pos).w
                blo.s   locret_8D044
                move.l  #Wait_FadeToLevelMusic,(a0)
                move.l  #Obj_EndSignControl,$34(a0)

locret_8D044:
                rts
; ---------------------------------------------------------------------------

loc_8D046:
                move.l  #loc_8D056,(a0)
                lea     ChildObjDat_8D25C(pc),a2
                jmp     (CreateChild3_NormalRepeated).l
; ---------------------------------------------------------------------------

loc_8D056:
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                beq.s   locret_8D080
                move.l  #Obj_Wait,(a0)
                move.w  #(2*60)-1,$2E(a0)
                move.l  #loc_8D082,$34(a0)
                tst.b   subtype(a0)
                bne.s   locret_8D080
                bsr.w   ScheduleLBZMinibossMusicTransition

locret_8D080:
                rts
; ---------------------------------------------------------------------------

loc_8D082:
                bset    #3,$38(a0)
                moveq   #signextendB(sfx_BossActivate),d0
                jsr     (Play_SFX).l
                lea     ChildObjDat_8D264(pc),a2
                jsr     (CreateChild1_Normal).l
                bne.s   loc_8D0AA
                movea.w parent3(a0),a2
                move.w  a2,parent3(a1)
                move.b  subtype(a0),subtype(a1)

loc_8D0AA:
                jmp     Go_Delete_Sprite_2(pc)
; ---------------------------------------------------------------------------

loc_8D0AE:
                move.l  #Obj_Wait,(a0)
                move.w  #$FF,$2E(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  word_8D0E0(pc,d0.w),x_pos(a0)
                move.w  #$A20,y_pos(a0)
                lea     (Child6_CreateBossExplosion).l,a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------
word_8D0E0:
                dc.w    $3C40, $3C80, $3CC0, $3D00, $3D40

; =============== S U B R O U T I N E =======================================

QueueLBZMinibossBoxAndExplosionGraphics:
                lea     (ArtKosM_LBZMiniboss).l,a1
                move.w  #tiles_to_bytes(ArtTile_LBZMiniboss),d2
                jsr     (Queue_Kos_Module).l
                lea     (ArtKosM_LBZMinibossBox).l,a1
                move.w  #tiles_to_bytes(ArtTile_LBZMinibossBox),d2
                jsr     (Queue_Kos_Module).l
                lea     (PLC_BossExplosion).l,a1
                jmp     (Load_PLC_Raw).l
; End of function QueueLBZMinibossBoxAndExplosionGraphics

; =============== S U B R O U T I N E =======================================

ScheduleLBZMinibossMusicTransition:
                jsr     (AllocateObject).l
                bne.s   locret_8D12A
                move.l  #Obj_Song_Fade_Transition,(a1)
                move.b  #mus_Miniboss,subtype(a1)

locret_8D12A:
                rts
; End of function ScheduleLBZMinibossMusicTransition

; ---------------------------------------------------------------------------

loc_8D12C:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  word_8D170(pc,d0.w),$2E(a0)
                add.w   d0,d0
                move.l  off_8D184(pc,d0.w),$30(a0)
                move.l  off_8D1AC(pc,d0.w),$34(a0)
                lea     byte_8D1D4(pc),a1
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
word_8D170:
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
off_8D184:
                dc.l    byte_8D280
                dc.l    byte_8D280
                dc.l    byte_8D285
                dc.l    byte_8D285
                dc.l    byte_8D285
                dc.l    byte_8D285
                dc.l    byte_8D294
                dc.l    byte_8D294
                dc.l    byte_8D298
                dc.l    byte_8D298
off_8D1AC:
                dc.l    Go_Delete_Sprite
                dc.l    Go_Delete_Sprite
                dc.l    Go_Delete_Sprite
                dc.l    Go_Delete_Sprite
                dc.l    Go_Delete_Sprite
                dc.l    Go_Delete_Sprite
                dc.l    loc_8CEAE
                dc.l    loc_8CEAE
                dc.l    loc_8CEAE
                dc.l    loc_8CEAE
byte_8D1D4:
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
                bne.s   locret_8D22E
                tst.b   $20(a0)
                bne.s   loc_8D21C
                move.b  #$20,$20(a0)
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l
                bset    #6,status(a0)

loc_8D21C:
                subq.b  #1,$20(a0)
                bne.s   locret_8D22E
                bclr    #6,status(a0)
                move.b  $25(a0),collision_flags(a0)

locret_8D22E:
                rts
; End of function UpdateLBZAct1RobotnikHitCooldown

; ---------------------------------------------------------------------------
ObjDat_LBZ1Robotnik:
                dc.l    Map_RobotnikShip
                dc.w    make_art_tile(ArtTile_RobotnikShip,0,0)
                dc.w    $100
                dc.b    $20, $20,  $A,  $F
ObjDat3_8D23C:
                dc.l    Map_LBZMinibossBox
                dc.w    make_art_tile(ArtTile_LBZMinibossBox,2,0)
                dc.w    $100
                dc.b    $14, $14,   0,   0
ObjDat3_8D248:                                          ; unused
                dc.l    Map_Ring
                dc.w    make_art_tile(ArtTile_Ring,1,1)
                dc.w    0
                dc.b    8,   8,   0,   0
ChildObjDat_8D254:
                dc.w    1-1
                dc.l    loc_8CD5C
                dc.b    0, $34
ChildObjDat_8D25C:
                dc.w    $A-1
                dc.l    loc_8CE34
                dc.b    0,   0
ChildObjDat_8D264:
                dc.w    1-1
                dc.l    Obj_LBZMiniboss
                dc.b    0,   0
ChildObjDat_8D26C:
                dc.w    2-1
                dc.l    loc_8D046
                dc.b    -$20,   0
                dc.l    loc_8D046
                dc.b    $20,   0
ChildObjDat_8D27A:
                dc.w    5-1
                dc.l    loc_8D0AE
byte_8D280:
                dc.b    0,   6,   7,   8, $F4
byte_8D285:
                dc.b    0,   9,  $A,  $B, $F4
byte_8D28A:
                dc.b    5,   0,   1,   2, $F4
byte_8D28F:
                dc.b    5,   3,   4,   5, $F4
byte_8D294:
                dc.b    0,   0,   0, $F4
byte_8D298:
                dc.b    0,   3,   3, $F4
                even
