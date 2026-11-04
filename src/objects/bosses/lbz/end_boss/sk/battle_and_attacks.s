; Owner: objects/bosses/lbz/end_boss/sk
; Responsibility: Launch Base end-boss controller, attached attack actors and battle progression
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_LBZEndBoss:
                lea     word_738C6(pc),a1
                jsr     (Check_CameraInRange).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  LBZEndBoss_Index(pc,d0.w),d1
                jsr     LBZEndBoss_Index(pc,d1.w)
                bsr.w   HandleLBZEndBossSingleColorHitOrEscape
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------
LBZEndBoss_Index:
                dc.w    loc_73906-LBZEndBoss_Index
                dc.w    loc_7395A-LBZEndBoss_Index
                dc.w    loc_7397A-LBZEndBoss_Index
                dc.w    loc_7399E-LBZEndBoss_Index
                dc.w    loc_739E6-LBZEndBoss_Index
                dc.w    loc_73A1A-LBZEndBoss_Index
                dc.w    loc_73A48-LBZEndBoss_Index
; ---------------------------------------------------------------------------

loc_73906:
                lea     ObjDat_LBZEndBoss(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.b  #8,collision_property(a0)
                move.l  #loc_73960,$34(a0)
                lea     word_738CE(pc),a1
                move.b  #mus_EndBoss,boss_saved_mus(a0)
                jsr     (Boss_BeginCameraTransition).l
                lea     ChildObjDat_7414C(pc),a2
                jsr     (CreateChild1_Normal).l
                moveq   #PLCID_77,d0
                jsr     (Load_PLC).l
                lea     (ArtKosM_LBZEndBoss).l,a1
                move.w  #tiles_to_bytes(ArtTile_LBZEndBoss),d2
                jsr     (Queue_Kos_Module).l
                lea     Pal_LBZEndBoss(pc),a1
                jmp     (PalLoad_Line1).l
; ---------------------------------------------------------------------------

loc_7395A:
                jmp     (SKEndCamera_TickAndSaveMusic).l
; ---------------------------------------------------------------------------

loc_73960:
                move.b  #4,routine(a0)
                lea     ChildObjDat_7418A(pc),a2
                jsr     (CreateChild4_LinkListRepeated).l
                lea     ChildObjDat_7415A(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_7397A:
                btst    #7,$38(a0)
                bne.s   loc_73984
                rts
; ---------------------------------------------------------------------------

loc_73984:
                move.b  #6,routine(a0)
                move.b  #1,(Scroll_lock).w
                move.w  #$39F0,d0
                move.w  d0,(Camera_min_X_pos).w
                move.w  d0,(Camera_max_X_pos).w

locret_7399C:
                rts
; ---------------------------------------------------------------------------

loc_7399E:
                move.w  #$39F0,d0
                move.w  (Camera_X_pos).w,d1
                subq.w  #2,d1
                cmp.w   d0,d1
                bls.s   loc_739B2
                move.w  d1,(Camera_X_pos).w
                rts
; ---------------------------------------------------------------------------

loc_739B2:
                move.w  d0,(Camera_X_pos).w
                move.b  #8,routine(a0)
                clr.b   (Scroll_lock).w
                moveq   #signextendB(sfx_Rising),d0
                jsr     (Play_SFX).l
                move.w  #-$40,y_vel(a0)
                move.w  #$DF,$2E(a0)
                move.l  #loc_739F2,$34(a0)
                lea     ChildObjDat_74162(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_739E6:
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_739F2:
                bset    #2,$38(a0)
                move.b  #$F,$28(a0)
                bset    #3,$38(a0)

loc_73A04:
                move.b  #$A,routine(a0)
                move.w  #7,$2E(a0)
                move.l  #loc_73A20,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_73A1A:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_73A20:
                bset    #1,$38(a0)
                move.w  #$3F,$2E(a0)
                move.l  #loc_73A36,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_73A36:
                move.b  #$C,routine(a0)
                moveq   #signextendB(sfx_TubeLauncher),d0
                jsr     (Play_SFX).l
                bra.w   loc_73F1C
; ---------------------------------------------------------------------------

loc_73A48:
                btst    #1,$38(a0)
                beq.s   loc_73A04
                rts
; ---------------------------------------------------------------------------

loc_73A52:
                addi.w  #$20,y_vel(a0)
                jsr     (MoveSprite2).l
                jsr     (Obj_Wait).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_73A6A:
                bset    #5,$38(a0)
                bclr    #7,render_flags(a0)
                clr.b   (Boss_flag).w
                jsr     (Restore_LevelMusic).l
                lea     (Player_2).w,a1
                bclr    #Status_RollJump,status(a1)
                move.l  #Go_Delete_Sprite_2,(a0)
                rts
; ---------------------------------------------------------------------------

loc_73A92:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_73AC4(pc,d0.w),d1
                jsr     off_73AC4(pc,d1.w)
                jsr     (Animate_Raw).l
                btst    #7,status(a0)
                bne.s   loc_73ABE
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                beq.s   loc_73ABE
                bsr.w   loc_73B82

loc_73ABE:
                jmp     (Child_DrawTouch_Sprite).l
; ---------------------------------------------------------------------------
off_73AC4:
                dc.w    loc_73ACC-off_73AC4
                dc.w    loc_73AF6-off_73AC4
                dc.w    loc_73B12-off_73AC4
                dc.w    loc_73B3C-off_73AC4
; ---------------------------------------------------------------------------

loc_73ACC:
                lea     word_7412A(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #byte_741F4,$30(a0)
                move.b  #$10,y_radius(a0)
                move.w  #$F,$2E(a0)
                move.l  #loc_73B02,$34(a0)
                bra.w   loc_73F42
; ---------------------------------------------------------------------------

loc_73AF6:
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_73B02:
                move.b  #4,routine(a0)
                move.l  #loc_73B24,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_73B12:
                addi.w  #$20,y_vel(a0)
                jsr     (MoveSprite2).l
                jmp     (ObjHitFloor_DoRoutine).l
; ---------------------------------------------------------------------------

loc_73B24:
                move.b  #6,routine(a0)
                move.l  #loc_73B82,$34(a0)
                move.w  angle(a0),d0
                clr.w   y_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_73B3C:
                move.w  #$10,d3
                jsr     (ObjHitWall_DoRoutine).l
                jsr     (ObjHitFloor2_DoRoutine).l
                tst.b   d3
                beq.s   loc_73B56
                addi.w  #$10,x_vel(a0)

loc_73B56:
                jsr     (MoveSprite2).l
                move.w  x_vel(a0),d0
                addi.w  #$200,d0
                cmpi.w  #$400,d0
                blo.w   locret_7399C
                move.w  (V_int_run_count+2).w,d0
                andi.w  #3,d0
                bne.w   locret_7399C
                lea     ChildObjDat_74198(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_73B82:
                move.l  #Delete_Current_Sprite,(a0)
                bset    #7,status(a0)
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l
                lea     ChildObjDat_741A0(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_73BA0:
                lea     word_74130(pc),a1
                jsr     (SetUp_ObjAttributes2).l
                move.l  #loc_73BDC,(a0)
                move.l  #byte_741F8,$30(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                bne.s   loc_73BD0
                move.w  #-$200,y_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_73BD0:
                subi.w  #$10,d0
                add.w   d0,d0
                neg.w   d0
                move.w  d0,$2E(a0)

loc_73BDC:
                addq.w  #1,$2E(a0)
                bmi.w   locret_7399C
                jsr     (MoveSprite2).l
                jsr     (Animate_Raw).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_73BF6:
                lea     word_74138(pc),a1
                jsr     (SetUp_ObjAttributes2).l
                move.l  #Obj_FlickerMove,(a0)
                bra.w   loc_73F7C
; ---------------------------------------------------------------------------

loc_73C0A:
                jsr     (Refresh_ChildPositionAdjusted).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_73C24(pc,d0.w),d1
                jsr     off_73C24(pc,d1.w)
                jmp     (Child_Draw_Sprite).l
; ---------------------------------------------------------------------------
off_73C24:
                dc.w    loc_73C2A-off_73C24
                dc.w    loc_73C44-off_73C24
                dc.w    loc_73C6A-off_73C24
; ---------------------------------------------------------------------------

loc_73C2A:
                lea     word_7411C(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsr.w   #1,d0
                addq.w  #2,d0
                move.b  d0,mapping_frame(a0)
                rts
; ---------------------------------------------------------------------------

loc_73C44:
                movea.w parent3(a0),a1
                btst    #2,$38(a1)
                beq.s   loc_73C58
                move.b  #4,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_73C58:
                move.w  $2E(a0),d0
                addq.w  #1,$2E(a0)
                andi.w  #3,d0
                sub.w   d0,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

loc_73C6A:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   loc_73C78
                rts
; ---------------------------------------------------------------------------

loc_73C78:
                lea     ChildObjDat_74176(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_73C82:
                lea     word_74122(pc),a1
                jsr     (SetUp_ObjAttributes2).l
                move.l  #Obj_FlickerMove,(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  word_73CAA(pc,d0.w),x_vel(a0)
                move.w  #-$200,y_vel(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
word_73CAA:
                dc.w    -$100
                dc.w    $200
                dc.w    -$200
; ---------------------------------------------------------------------------

loc_73CB0:
                movea.w parent3(a0),a1
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_73CCE(pc,d0.w),d1
                jsr     off_73CCE(pc,d1.w)
                lea     locret_7399C(pc),a2
                bsr.w   MoveAndSolidifyLBZEndBossTopPlatform
                bra.w   loc_74098
; ---------------------------------------------------------------------------
off_73CCE:
                dc.w    loc_73CD8-off_73CCE
                dc.w    loc_73CFC-off_73CCE
                dc.w    loc_73D0E-off_73CCE
                dc.w    loc_73D32-off_73CCE
                dc.w    loc_73D40-off_73CCE
; ---------------------------------------------------------------------------

loc_73CD8:
                lea     ObjDat3_74140(pc),a1
                jsr     (SetUp_ObjAttributes).l
                subi.w  #$14,x_pos(a0)
                addi.w  #$40,y_pos(a0)
                tst.b   subtype(a0)
                beq.s   locret_73CFA
                move.l  #loc_73D56,(a0)

locret_73CFA:
                rts
; ---------------------------------------------------------------------------

loc_73CFC:
                btst    #1,$38(a1)
                bne.s   loc_73D06
                rts
; ---------------------------------------------------------------------------

loc_73D06:
                move.b  #4,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_73D0E:
                subq.b  #1,$3C(a0)
                cmpi.b  #-$40,$3C(a0)
                bls.s   loc_73D1C
                rts
; ---------------------------------------------------------------------------

loc_73D1C:
                move.b  #6,routine(a0)
                move.w  #$80,$2E(a0)
                move.l  #loc_73D38,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_73D32:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_73D38:
                move.b  #8,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_73D40:
                addq.b  #1,$3C(a0)
                beq.s   loc_73D48
                rts
; ---------------------------------------------------------------------------

loc_73D48:
                move.b  #2,routine(a0)
                bclr    #1,$38(a1)
                rts
; ---------------------------------------------------------------------------

loc_73D56:
                lea     loc_73D62(pc),a2
                bsr.w   MoveAndSolidifyLBZEndBossTopPlatform
                bra.w   loc_74098
; ---------------------------------------------------------------------------

loc_73D62:
                movea.w parent3(a0),a1
                move.b  $3C(a1),$3C(a0)
                moveq   #4,d2
                jmp     (MoveSprite_CircularSimple).l
; ---------------------------------------------------------------------------

loc_73D74:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_73D88(pc,d0.w),d1
                jsr     off_73D88(pc,d1.w)
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------
off_73D88:
                dc.w    loc_73D8E-off_73D88
                dc.w    loc_73DB6-off_73D88
                dc.w    loc_73DEA-off_73D88
; ---------------------------------------------------------------------------

loc_73D8E:
                lea     ObjDat3_740F8(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.w  #-$180,x_vel(a0)
                move.l  #byte_741EA,$30(a0)
                move.w  #$1F,$2E(a0)
                move.l  #loc_73DC8,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_73DB6:
                jsr     (MoveSprite2).l
                jsr     (Animate_Raw).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_73DC8:
                move.b  #4,routine(a0)
                move.b  #3,mapping_frame(a0)
                move.w  #-$200,y_vel(a0)
                move.w  #$29,$2E(a0)
                move.l  #loc_73DF6,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_73DEA:
                jsr     (MoveSprite_LightGravity).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_73DF6:
                move.l  #Delete_Current_Sprite,(a0)
                move.b  #0,mapping_frame(a0)
                movea.w parent3(a0),a1
                bset    #7,$38(a1)
                rts
; ---------------------------------------------------------------------------

loc_73E0E:
                jsr     (Refresh_ChildPositionAdjusted).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_73E28(pc,d0.w),d1
                jsr     off_73E28(pc,d1.w)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
off_73E28:
                dc.w    loc_73E30-off_73E28
                dc.w    loc_73E3A-off_73E28
                dc.w    loc_73E5E-off_73E28
                dc.w    loc_73E8E-off_73E28
; ---------------------------------------------------------------------------

loc_73E30:
                lea     ObjDat3_74104(pc),a1
                jmp     (SetUp_ObjAttributes).l
; ---------------------------------------------------------------------------

loc_73E3A:
                movea.w parent3(a0),a1
                btst    #7,$38(a1)
                bne.s   loc_73E48
                rts
; ---------------------------------------------------------------------------

loc_73E48:
                move.b  #4,routine(a0)
                move.b  #0,mapping_frame(a0)
                move.l  #byte_741F0,$30(a0)
                rts
; ---------------------------------------------------------------------------

loc_73E5E:
                movea.w parent3(a0),a1
                btst    #6,status(a1)
                bne.s   loc_73E78
                btst    #7,status(a1)
                bne.s   loc_73E80
                jmp     (Animate_Raw).l
; ---------------------------------------------------------------------------

loc_73E78:
                move.b  #2,mapping_frame(a0)
                rts
; ---------------------------------------------------------------------------

loc_73E80:
                move.b  #6,routine(a0)
                move.b  #3,mapping_frame(a0)
                rts
; ---------------------------------------------------------------------------

loc_73E8E:
                movea.w parent3(a0),a1
                btst    #5,$38(a1)
                bne.s   loc_73E9C
                rts
; ---------------------------------------------------------------------------

loc_73E9C:
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

loc_73EA2:
                lea     ObjDat3_74110(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #loc_73EB4,(a0)
                rts
; ---------------------------------------------------------------------------

loc_73EB4:
                movea.w parent3(a0),a1
                btst    #4,$38(a1)
                bne.s   loc_73F10
                btst    #3,$38(a1)
                bne.s   loc_73EE2
                moveq   #$13,d1
                move.w  #$80,d2
                move.w  #$120,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_73EE2:
                move.l  #loc_73EEE,(a0)
                addi.w  #$60,y_pos(a0)

loc_73EEE:
                movea.w parent3(a0),a1
                btst    #4,$38(a1)
                bne.s   loc_73F10
                moveq   #$13,d1
                moveq   #$14,d2
                moveq   #0,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_73F10:
                jsr     (Displace_PlayerOffObject).l
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_73F1C:
                lea     ChildObjDat_74190(pc),a2
                jsr     (CreateChild1_Normal).l
                move.b  $39(a0),d0
                addq.b  #1,$39(a0)
                andi.w  #7,d0
                move.b  byte_73F3A(pc,d0.w),subtype(a1)
                rts
; ---------------------------------------------------------------------------
byte_73F3A:
                dc.b    0,   2,   1,   2,   0,   1,   2,   1
                even
; ---------------------------------------------------------------------------

loc_73F42:
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsl.w   #3,d0
                lea     word_73F64(pc,d0.w),a1
                move.w  (a1)+,d0
                add.w   d0,x_pos(a0)
                move.w  (a1)+,d0
                add.w   d0,y_pos(a0)
                move.w  (a1)+,x_vel(a0)
                move.w  (a1)+,y_vel(a0)
                rts
; ---------------------------------------------------------------------------
word_73F64:
                dc.w    -$10,   $60, -$600, -$200
                dc.w    -$10,   $60, -$400, -$100
                dc.w    -$10,   $90, -$400,     0
; ---------------------------------------------------------------------------

loc_73F7C:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  d0,d1
                move.w  d0,d2
                cmpi.b  #8,d0
                blo.s   loc_73F98
                move.b  #$B,mapping_frame(a0)
                subi.w  #8,d2
                move.w  d2,d1

loc_73F98:
                add.w   d0,d0
                lea     word_73FAE(pc,d0.w),a1
                move.w  (a1)+,x_vel(a0)
                move.w  (a1)+,y_vel(a0)
                lsr.w   #1,d1
                or.b    d1,render_flags(a0)
                rts
; ---------------------------------------------------------------------------
word_73FAE:
                dc.w    -$300, -$300
                dc.w    $300, -$300
                dc.w    -$300, -$200
                dc.w    $300, -$200
                dc.w    -$400, -$400
                dc.w    $400, -$400
                dc.w    -$400, -$300
                dc.w    $400, -$300
