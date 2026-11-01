; Owner: objects/bosses/lbz/s3
; Responsibility: Launch Base end-boss lifecycle, attacks, child actors, helpers and private resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_LBZEndBoss:
                lea     word_5043C(pc),a1
                jsr     (Check_CameraInRange).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  LBZEndBoss_Index(pc,d0.w),d1
                jsr     LBZEndBoss_Index(pc,d1.w)
                bsr.w   HandleLBZEndBossSingleColorHitOrEscape
                jmp     Draw_And_Touch_Sprite(pc)
; ---------------------------------------------------------------------------
LBZEndBoss_Index:
                dc.w    loc_50444-LBZEndBoss_Index
                dc.w    loc_504AE-LBZEndBoss_Index
                dc.w    loc_504CA-LBZEndBoss_Index
                dc.w    loc_504DC-LBZEndBoss_Index
                dc.w    loc_5051C-LBZEndBoss_Index
                dc.w    loc_50548-LBZEndBoss_Index
                dc.w    loc_50574-LBZEndBoss_Index
word_5043C:
                dc.w    $480,  $660, $3900, $3A20
; ---------------------------------------------------------------------------

loc_50444:
                lea     ObjDat_LBZEndBoss(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.b  #8,collision_property(a0)
                move.b  #1,(Boss_flag).w
                moveq   #signextendB(cmd_FadeOut),d0
                jsr     (Play_Music).l
                move.w  #2*60,$2E(a0)
                move.b  #mus_EndBoss,$26(a0)
                move.w  #$5A0,(Camera_target_max_Y_pos).w
                move.w  #$3A20,$1C(a0)
                move.w  #$3A20,(Camera_max_X_pos).w
                move.l  #loc_504B4,$34(a0)
                lea     ChildObjDat_50BD8(pc),a2
                jsr     CreateChild1_Normal(pc)
                moveq   #PLCID_77,d0
                jsr     (Load_PLC).l
                lea     (ArtKosM_LBZEndBoss).l,a1
                move.w  #tiles_to_bytes(ArtTile_LBZEndBoss),d2
                jsr     (Queue_Kos_Module).l
                lea     Pal_LBZEndBoss(pc),a1
                jmp     PalLoad_Line1(pc)
; ---------------------------------------------------------------------------

loc_504AE:
                jmp     (loc_541C8).l
; ---------------------------------------------------------------------------

loc_504B4:
                move.b  #4,routine(a0)
                lea     ChildObjDat_50C16(pc),a2
                jsr     CreateChild4_LinkListRepeated(pc)
                lea     ChildObjDat_50BE6(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

loc_504CA:
                btst    #7,$38(a0)
                bne.s   loc_504D4
                rts
; ---------------------------------------------------------------------------

loc_504D4:
                move.b  #6,routine(a0)

locret_504DA:
                rts
; ---------------------------------------------------------------------------

loc_504DC:
                move.w  (Camera_max_X_pos).w,d0
                subq.w  #1,d0
                cmpi.w  #$39F0,d0
                bls.s   loc_504F2
                move.w  d0,(Camera_min_X_pos).w
                move.w  d0,(Camera_max_X_pos).w
                rts
; ---------------------------------------------------------------------------

loc_504F2:
                move.b  #8,routine(a0)
                moveq   #signextendB(sfx_Rising),d0
                jsr     (Play_SFX).l
                move.w  #-$40,y_vel(a0)
                move.w  #$DF,$2E(a0)
                move.l  #loc_50526,$34(a0)
                lea     ChildObjDat_50BEE(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

loc_5051C:
                jsr     (MoveSprite2).l
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_50526:
                bset    #2,$38(a0)
                move.b  #$F,$28(a0)

loc_50532:
                move.b  #$A,routine(a0)
                move.w  #7,$2E(a0)
                move.l  #loc_5054C,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_50548:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_5054C:
                bset    #1,$38(a0)
                move.w  #$3F,$2E(a0)
                move.l  #loc_50562,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_50562:
                move.b  #$C,routine(a0)
                moveq   #signextendB(sfx_TubeLauncher),d0
                jsr     (Play_SFX).l
                bra.w   loc_509B6
; ---------------------------------------------------------------------------

loc_50574:
                btst    #1,$38(a0)
                beq.s   loc_50532
                rts
; ---------------------------------------------------------------------------

loc_5057E:
                addi.w  #$20,y_vel(a0)
                jsr     (MoveSprite2).l
                jsr     Obj_Wait(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_50594:
                bset    #5,$38(a0)
                bclr    #7,render_flags(a0)
                clr.b   (Boss_flag).w
                jsr     Restore_LevelMusic(pc)
                lea     (Player_2).w,a1
                bclr    #Status_RollJump,status(a1)
                move.l  #Go_Delete_Sprite_2,(a0)
                rts
; ---------------------------------------------------------------------------

loc_505BA:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_505E8(pc,d0.w),d1
                jsr     off_505E8(pc,d1.w)
                jsr     Animate_Raw(pc)
                btst    #7,status(a0)
                bne.s   loc_505E4
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                beq.s   loc_505E4
                bsr.w   loc_50690

loc_505E4:
                jmp     Child_DrawTouch_Sprite(pc)
; ---------------------------------------------------------------------------
off_505E8:
                dc.w    loc_505F0-off_505E8
                dc.w    Move_WaitNoFall-off_505E8
                dc.w    loc_50628-off_505E8
                dc.w    loc_50650-off_505E8
; ---------------------------------------------------------------------------

loc_505F0:
                lea     word_50BB6(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #byte_50C80,$30(a0)
                move.b  #$10,y_radius(a0)
                move.w  #$F,$2E(a0)
                move.l  #loc_50618,$34(a0)
                bra.w   loc_509DA
; ---------------------------------------------------------------------------

loc_50618:
                move.b  #4,routine(a0)
                move.l  #loc_50638,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_50628:
                addi.w  #$20,y_vel(a0)
                jsr     (MoveSprite2).l
                jmp     ObjHitFloor_DoRoutine(pc)
; ---------------------------------------------------------------------------

loc_50638:
                move.b  #6,routine(a0)
                move.l  #loc_50690,$34(a0)
                move.w  angle(a0),d0
                clr.w   y_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_50650:
                move.w  #$10,d3
                jsr     ObjHitWall_DoRoutine(pc)
                jsr     ObjHitFloor2_DoRoutine(pc)
                tst.b   d3
                beq.s   loc_50666
                addi.w  #$10,x_vel(a0)

loc_50666:
                jsr     (MoveSprite2).l
                move.w  x_vel(a0),d0
                addi.w  #$200,d0
                cmpi.w  #$400,d0
                blo.w   locret_504DA
                move.w  (V_int_run_count+2).w,d0
                andi.w  #3,d0
                bne.w   locret_504DA
                lea     ChildObjDat_50C24(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

loc_50690:
                move.l  #Delete_Current_Sprite,(a0)
                bset    #7,status(a0)
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l
                lea     ChildObjDat_50C2C(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

loc_506AC:
                lea     word_50BBC(pc),a1
                jsr     SetUp_ObjAttributes2(pc)
                move.l  #loc_506E6,(a0)
                move.l  #byte_50C84,$30(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                bne.s   loc_506DA
                move.w  #-$200,y_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_506DA:
                subi.w  #$10,d0
                add.w   d0,d0
                neg.w   d0
                move.w  d0,$2E(a0)

loc_506E6:
                addq.w  #1,$2E(a0)
                bmi.w   locret_504DA
                jsr     (MoveSprite2).l
                jsr     Animate_Raw(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_506FE:
                lea     word_50BC4(pc),a1
                jsr     SetUp_ObjAttributes2(pc)
                move.l  #Obj_FlickerMove,(a0)
                bra.w   loc_50A14
; ---------------------------------------------------------------------------

loc_50710:
                jsr     Refresh_ChildPositionAdjusted(pc)
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_50726(pc,d0.w),d1
                jsr     off_50726(pc,d1.w)
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------
off_50726:
                dc.w    loc_5072C-off_50726
                dc.w    loc_50744-off_50726
                dc.w    loc_5076A-off_50726
; ---------------------------------------------------------------------------

loc_5072C:
                lea     word_50BA8(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsr.w   #1,d0
                addq.w  #2,d0
                move.b  d0,mapping_frame(a0)
                rts
; ---------------------------------------------------------------------------

loc_50744:
                movea.w parent3(a0),a1
                btst    #2,$38(a1)
                beq.s   loc_50758
                move.b  #4,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_50758:
                move.w  $2E(a0),d0
                addq.w  #1,$2E(a0)
                andi.w  #3,d0
                sub.w   d0,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

loc_5076A:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   loc_50778
                rts
; ---------------------------------------------------------------------------

loc_50778:
                lea     ChildObjDat_50C02(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

loc_50780:
                lea     word_50BAE(pc),a1
                jsr     SetUp_ObjAttributes2(pc)
                move.l  #Obj_FlickerMove,(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  word_507A6(pc,d0.w),x_vel(a0)
                move.w  #-$200,y_vel(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
word_507A6:
                dc.w    -$100
                dc.w    $200
                dc.w    -$200
; ---------------------------------------------------------------------------

loc_507AC:
                movea.w parent3(a0),a1
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_507CA(pc,d0.w),d1
                jsr     off_507CA(pc,d1.w)
                lea     locret_504DA(pc),a2
                bsr.w   MoveAndSolidifyLBZEndBossTopPlatform
                bra.w   loc_50B26
; ---------------------------------------------------------------------------
off_507CA:
                dc.w    loc_507D4-off_507CA
                dc.w    loc_507F6-off_507CA
                dc.w    loc_50808-off_507CA
                dc.w    loc_5082C-off_507CA
                dc.w    loc_50838-off_507CA
; ---------------------------------------------------------------------------

loc_507D4:
                lea     ObjDat3_50BCC(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                subi.w  #$14,x_pos(a0)
                addi.w  #$40,y_pos(a0)
                tst.b   subtype(a0)
                beq.s   locret_507F4
                move.l  #loc_5084E,(a0)

locret_507F4:
                rts
; ---------------------------------------------------------------------------

loc_507F6:
                btst    #1,$38(a1)
                bne.s   loc_50800
                rts
; ---------------------------------------------------------------------------

loc_50800:
                move.b  #4,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_50808:
                subq.b  #1,$3C(a0)
                cmpi.b  #-$40,$3C(a0)
                bls.s   loc_50816
                rts
; ---------------------------------------------------------------------------

loc_50816:
                move.b  #6,routine(a0)
                move.w  #$80,$2E(a0)
                move.l  #loc_50830,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_5082C:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_50830:
                move.b  #8,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_50838:
                addq.b  #1,$3C(a0)
                beq.s   loc_50840
                rts
; ---------------------------------------------------------------------------

loc_50840:
                move.b  #2,routine(a0)
                bclr    #1,$38(a1)
                rts
; ---------------------------------------------------------------------------

loc_5084E:
                lea     loc_5085A(pc),a2
                bsr.w   MoveAndSolidifyLBZEndBossTopPlatform
                bra.w   loc_50B26
; ---------------------------------------------------------------------------

loc_5085A:
                movea.w parent3(a0),a1
                move.b  $3C(a1),$3C(a0)
                moveq   #4,d2
                jmp     MoveSprite_CircularSimple(pc)
; ---------------------------------------------------------------------------

loc_5086A:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_5087E(pc,d0.w),d1
                jsr     off_5087E(pc,d1.w)
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------
off_5087E:
                dc.w    loc_50884-off_5087E
                dc.w    Move_AnimateRaw_Wait-off_5087E
                dc.w    loc_508CC-off_5087E
; ---------------------------------------------------------------------------

loc_50884:
                lea     ObjDat3_50B84(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.w  #-$180,x_vel(a0)
                move.l  #byte_50C76,$30(a0)
                move.w  #$15,$2E(a0)
                move.l  #loc_508AA,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_508AA:
                move.b  #4,routine(a0)
                move.b  #3,mapping_frame(a0)
                move.w  #-$200,y_vel(a0)
                move.w  #$29,$2E(a0)
                move.l  #loc_508D4,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_508CC:
                jsr     MoveSprite_LightGravity(pc)
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_508D4:
                move.l  #Delete_Current_Sprite,(a0)
                move.b  #0,mapping_frame(a0)
                movea.w parent3(a0),a1
                bset    #7,$38(a1)
                rts
; ---------------------------------------------------------------------------

loc_508EC:
                jsr     Refresh_ChildPositionAdjusted(pc)
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_50904(pc,d0.w),d1
                jsr     off_50904(pc,d1.w)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
off_50904:
                dc.w    loc_5090C-off_50904
                dc.w    loc_50914-off_50904
                dc.w    loc_50938-off_50904
                dc.w    loc_50966-off_50904
; ---------------------------------------------------------------------------

loc_5090C:
                lea     ObjDat3_50B90(pc),a1
                jmp     SetUp_ObjAttributes(pc)
; ---------------------------------------------------------------------------

loc_50914:
                movea.w parent3(a0),a1
                btst    #7,$38(a1)
                bne.s   loc_50922
                rts
; ---------------------------------------------------------------------------

loc_50922:
                move.b  #4,routine(a0)
                move.b  #0,mapping_frame(a0)
                move.l  #byte_50C7C,$30(a0)
                rts
; ---------------------------------------------------------------------------

loc_50938:
                movea.w parent3(a0),a1
                btst    #6,status(a1)
                bne.s   loc_50950
                btst    #7,status(a1)
                bne.s   loc_50958
                jmp     Animate_Raw(pc)
; ---------------------------------------------------------------------------

loc_50950:
                move.b  #2,mapping_frame(a0)
                rts
; ---------------------------------------------------------------------------

loc_50958:
                move.b  #6,routine(a0)
                move.b  #3,$22(a0)
                rts
; ---------------------------------------------------------------------------

loc_50966:
                movea.w parent3(a0),a1
                btst    #5,$38(a1)
                bne.s   loc_50974
                rts
; ---------------------------------------------------------------------------

loc_50974:
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

loc_5097A:
                lea     ObjDat3_50B9C(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #loc_5098A,(a0)
                rts
; ---------------------------------------------------------------------------

loc_5098A:
                moveq   #$13,d1
                moveq   #$14,d2
                moveq   #0,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                movea.w parent3(a0),a1
                btst    #4,$38(a1)
                bne.s   loc_509AC
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_509AC:
                jsr     Displace_PlayerOffObject(pc)
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_509B6:
                lea     ChildObjDat_50C1C(pc),a2
                jsr     CreateChild1_Normal(pc)
                move.b  $39(a0),d0
                addq.b  #1,$39(a0)
                andi.w  #7,d0
                move.b  byte_509D2(pc,d0.w),subtype(a1)
                rts
; ---------------------------------------------------------------------------
byte_509D2:
                dc.b    0,   2,   1,   2,   0,   1,   2,   1
                even
; ---------------------------------------------------------------------------

loc_509DA:
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsl.w   #3,d0
                lea     word_509FC(pc,d0.w),a1
                move.w  (a1)+,d0
                add.w   d0,x_pos(a0)
                move.w  (a1)+,d0
                add.w   d0,y_pos(a0)
                move.w  (a1)+,x_vel(a0)
                move.w  (a1)+,y_vel(a0)
                rts
; ---------------------------------------------------------------------------
word_509FC:
                dc.w    -$10,   $60, -$600, -$200
                dc.w    -$10,   $60, -$400, -$100
                dc.w    -$10,   $90, -$400,     0
; ---------------------------------------------------------------------------

loc_50A14:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  d0,d1
                move.w  d0,d2
                cmpi.b  #8,d0
                blo.s   loc_50A30
                move.b  #$B,mapping_frame(a0)
                subi.w  #8,d2
                move.w  d2,d1

loc_50A30:
                add.w   d0,d0
                lea     word_50A46(pc,d0.w),a1
                move.w  (a1)+,x_vel(a0)
                move.w  (a1)+,y_vel(a0)
                lsr.w   #1,d1
                or.b    d1,render_flags(a0)
                rts
; ---------------------------------------------------------------------------
word_50A46:
                dc.w    -$300, -$300
                dc.w    $300, -$300
                dc.w    -$300, -$200
                dc.w    $300, -$200
                dc.w    -$400, -$400
                dc.w    $400, -$400
                dc.w    -$400, -$300
                dc.w    $400, -$300

; =============== S U B R O U T I N E =======================================

MoveAndSolidifyLBZEndBossTopPlatform:
                move.w  x_pos(a0),-(sp)
                jsr     (a2)
                moveq   #$12,d1
                moveq   #7,d2
                moveq   #7,d3
                move.w  (sp)+,d4
                jmp     (SolidObjectTop).l
; End of function MoveAndSolidifyLBZEndBossTopPlatform

; =============== S U B R O U T I N E =======================================

HandleLBZEndBossSingleColorHitOrEscape:
                tst.l   (a0)
                beq.s   locret_50AD0
                tst.b   collision_flags(a0)
                bne.s   locret_50AD0
                tst.b   collision_property(a0)
                beq.s   loc_50AD2
                tst.b   $20(a0)
                bne.s   loc_50A9E
                move.b  #$20,$20(a0)
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l

loc_50A9E:
                bset    #6,status(a0)
                lea     (Normal_palette_line_2+$16).w,a1
                move.w  #$222,d0
                btst    #0,$20(a0)
                bne.s   loc_50AB8
                move.w  #$EEE,d0

loc_50AB8:
                move.w  d0,(a1)
                subq.b  #1,$20(a0)
                bne.s   locret_50AD0
                bclr    #6,status(a0)
                move.w  #$222,(a1)
                move.b  $25(a0),collision_flags(a0)

locret_50AD0:
                rts
; ---------------------------------------------------------------------------

loc_50AD2:
                move.l  #loc_5057E,(a0)
                moveq   #100,d0
                jsr     (HUD_AddToScore).l
                bclr    #7,render_flags(a0)
                move.w  #$7F,$2E(a0)
                bset    #4,$38(a0)
                move.w  #make_art_tile(ArtTile_LBZEndBoss,1,1),art_tile(a0)
                move.w  #-$200,y_vel(a0)
                move.l  #loc_50594,$34(a0)
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     CreateChild1_Normal(pc)
                bne.s   loc_50B18
                move.b  #4,subtype(a1)

loc_50B18:
                move.w  #$3AB8,(Camera_stored_max_X_pos).w
                lea     Child6_IncLevX(pc),a2
                jmp     CreateChild6_Simple(pc)
; End of function HandleLBZEndBossSingleColorHitOrEscape

; ---------------------------------------------------------------------------

loc_50B26:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   loc_50B38
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_50B38:
                move.l  #MoveChkDel,(a0)
                bset    #7,status(a0)
                move.w  #make_art_tile(ArtTile_LBZEndBoss,1,1),art_tile(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  word_50B70(pc,d0.w),x_vel(a0)
                move.w  #-$200,y_vel(a0)
                jsr     Displace_PlayerOffObject(pc)
                lea     (Player_2).w,a1
                bclr    #Status_RollJump,status(a1)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
word_50B70:
                dc.w    $300,  $200, -$200, -$300
ObjDat_LBZEndBoss:
                dc.l    Map_LBZEndBoss
                dc.w    make_art_tile(ArtTile_LBZEndBoss,1,0)
                dc.w    $280
                dc.b    $20, $10,   0, $18
ObjDat3_50B84:
                dc.l    Map_FBZRobotnikRun
                dc.w    make_art_tile(ArtTile_FBZRobotnikRun,0,0)
                dc.w    $280
                dc.b    $20, $20,   0,   0
ObjDat3_50B90:
                dc.l    Map_RobotnikShip
                dc.w    make_art_tile(ArtTile_RobotnikShip,0,1)
                dc.w    $300
                dc.b    $10,   8,   4,   0
ObjDat3_50B9C:
                dc.l    Map_LBZEndBoss
                dc.w    make_art_tile(ArtTile_LBZEndBoss,1,0)
                dc.w    $300
                dc.b    8, $20,  $C,   0
word_50BA8:
                dc.w    $280
                dc.b    8, $18,   2,   0
word_50BAE:
                dc.w    make_art_tile(ArtTile_LBZEndBoss,1,1)
                dc.w    $200
                dc.b    8,   8,  $D,   0
word_50BB6:
                dc.w    $280
                dc.b    $10, $10,   5, $9A
word_50BBC:
                dc.w    make_art_tile(ArtTile_LBZEndBoss,0,0)
                dc.w    $200
                dc.b    8,   8,   7,   0
word_50BC4:
                dc.w    make_art_tile(ArtTile_LBZEndBoss,1,1)
                dc.w    $200
                dc.b    8,   8,  $A,   0
ObjDat3_50BCC:
                dc.l    Map_LBZEndBoss
                dc.w    make_art_tile(ArtTile_LBZEndBoss,2,0)
                dc.w    $280
                dc.b    8,   8,  $E,   0
ChildObjDat_50BD8:
                dc.w    2-1
                dc.l    loc_508EC
                dc.b    0,  -8
                dc.l    loc_5097A
                dc.b    -$18,-$10
ChildObjDat_50BE6:
                dc.w    1-1
                dc.l    loc_5086A
                dc.b    $60,-$18
ChildObjDat_50BEE:
                dc.w    3-1
                dc.l    loc_50710
                dc.b    -$18, $38
                dc.l    loc_50710
                dc.b    $18, $38
                dc.l    loc_50710
                dc.b    0, $38
ChildObjDat_50C02:
                dc.w    3-1
                dc.l    loc_50780
                dc.b    0,-$18
                dc.l    loc_50780
                dc.b    0,  -8
                dc.l    loc_50780
                dc.b    0,   8
ChildObjDat_50C16:
                dc.w    4-1
                dc.l    loc_507AC
ChildObjDat_50C1C:
                dc.w    1-1
                dc.l    loc_505BA
                dc.b    0,   0
ChildObjDat_50C24:
                dc.w    1-1
                dc.l    loc_506AC
                dc.b    0, $10
ChildObjDat_50C2C:
                dc.w    $C-1
                dc.l    loc_506FE
                dc.b    -8,  -8
                dc.l    loc_506FE
                dc.b    8,  -8
                dc.l    loc_506FE
                dc.b    -8,   8
                dc.l    loc_506FE
                dc.b    8,   8
                dc.l    loc_506FE
                dc.b    -$10,-$10
                dc.l    loc_506FE
                dc.b    $10,-$10
                dc.l    loc_506FE
                dc.b    -$10, $10
                dc.l    loc_506FE
                dc.b    $10, $10
                dc.l    loc_506AC
                dc.b    -8,   6
                dc.l    loc_506AC
                dc.b    6,   8
                dc.l    loc_506AC
                dc.b    -8,  -6
                dc.l    loc_506AC
                dc.b    6,  -8
byte_50C76:
                dc.b    7,   0,   1,   2,   1, $FC
byte_50C7C:
                dc.b    7,   0,   1, $FC
byte_50C80:
                dc.b    0,   5,   6, $FC
byte_50C84:
                dc.b    5,   7,   7,   8,   9, $F4
                even
Pal_LBZEndBoss:
                binclude "data/Levels/LBZ/Palettes/End Boss.bin"
                even
