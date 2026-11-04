; Owner: objects/bosses/fbz/sk
; Responsibility: Flying Battery act-two subboss state machine, attack actors and collision or movement helpers with their private lookup constants
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_FBZ2Subboss:
                lea     word_6FCFC(pc),a1
                jsr     (Check_CameraInRange).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  FBZ2Subboss_Index(pc,d0.w),d1
                jsr     FBZ2Subboss_Index(pc,d1.w)
                bsr.w   FlashAndResetFBZAct2SubbossHitState
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------
FBZ2Subboss_Index:
                dc.w    loc_6FD38-FBZ2Subboss_Index
                dc.w    loc_6FDC0-FBZ2Subboss_Index
                dc.w    loc_6FE00-FBZ2Subboss_Index
                dc.w    loc_6FE22-FBZ2Subboss_Index
                dc.w    loc_6FEB2-FBZ2Subboss_Index
; ---------------------------------------------------------------------------

loc_6FD38:
                lea     ObjDat_FBZ2Subboss(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.b  #$7F,collision_property(a0)
                move.b  #6,$39(a0)
                move.b  #1,(Boss_flag).w
                move.w  (Camera_target_max_Y_pos).w,(Camera_stored_max_Y_pos).w
                move.w  #$2900,(Camera_min_X_pos).w
                move.w  #$5E0,(Camera_target_max_Y_pos).w
                lea     PLC_FBZ2Subboss_SonicTails(pc),a1
                cmpi.b  #2,(Player_1+character_id).w
                bne.s   loc_6FD76
                lea     PLC_FBZ2Subboss_Knuckles(pc),a1

loc_6FD76:
                jsr     (Load_PLC_Raw).l
                lea     Pal_FBZ2Subboss(pc),a1
                jsr     (PalLoad_Line1).l
                jsr     (AllocateObject).l
                bne.s   loc_6FD9A
                move.l  #Obj_Song_Fade_Transition,(a1)
                move.b  #mus_Miniboss,subtype(a1)

loc_6FD9A:
                lea     ChildObjDat_703D0(pc),a2
                jsr     (CreateChild1_Normal).l
                lea     ChildObjDat_703DE(pc),a2
                jsr     (CreateChild6_Simple).l
                bne.s   loc_6FDB6
                move.b  #$49,subtype(a1)

loc_6FDB6:
                lea     ChildObjDat_703C8(pc),a2
                jmp     (CreateChild3_NormalRepeated).l
; ---------------------------------------------------------------------------

loc_6FDC0:
                lea     (Player_1).w,a1
                jsr     (Find_OtherObject).l
                cmpi.w  #$18,d2
                blo.s   loc_6FDD2
                rts
; ---------------------------------------------------------------------------

loc_6FDD2:
                move.b  #4,routine(a0)
                move.w  #$80,y_vel(a0)
                move.w  #$37,$2E(a0)
                move.l  #loc_6FE0C,$34(a0)

loc_6FDEC:
                bset    #7,$38(a0)
                bne.w   locret_6FE20
                lea     ChildObjDat_703E4(pc),a2
                jmp     (CreateChild3_NormalRepeated).l
; ---------------------------------------------------------------------------

loc_6FE00:
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_6FE0C:
                move.b  #6,routine(a0)
                move.w  #$3F,$2E(a0)
                move.l  #loc_6FE3A,$34(a0)

locret_6FE20:
                rts
; ---------------------------------------------------------------------------

loc_6FE22:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_6FE28:
                subq.b  #1,$39(a0)
                bmi.s   loc_6FE6E
                bset    #3,$38(a0)
                bclr    #6,status(a0)

loc_6FE3A:
                move.b  #8,routine(a0)
                bclr    #1,$38(a0)
                clr.w   y_vel(a0)
                lea     ChildObjDat_703EC(pc),a2
                jsr     (CreateChild1_Normal).l

; =============== S U B R O U T I N E =======================================

SetFBZAct2SubbossChaseVelocity:
                lea     (Player_1).w,a1
                jsr     (Find_OtherObject).l
                move.w  #$100,d1
                tst.w   d0
                bne.s   loc_6FE68
                neg.w   d1

loc_6FE68:
                move.w  d1,x_vel(a0)
                rts
; End of function SetFBZAct2SubbossChaseVelocity

; ---------------------------------------------------------------------------

loc_6FE6E:
                move.l  #Wait_Draw,(a0)
                bset    #7,status(a0)
                bset    #5,$38(a0)
                move.w  #$5F,$2E(a0)
                move.l  #loc_6FF10,$34(a0)
                lea     PLCKosM_FBZ2Subboss(pc),a6
                move.w  (a6)+,d6

loc_6FE94:
                movea.l (a6)+,a1
                move.w  (a6)+,d2
                jsr     (Queue_Kos_Module).l
                dbf     d6,loc_6FE94
                rts
; ---------------------------------------------------------------------------
PLCKosM_FBZ2Subboss:    plrlistheader
                plreq   ArtTile_FBZCloud, ArtKosM_FBZCloud
                plreq   ArtTile_FBZBossPillar, ArtKosM_FBZBossPillar
PLCKosM_FBZ2Subboss_End:
; ---------------------------------------------------------------------------

loc_6FEB2:
                btst    #1,$38(a0)
                bne.s   loc_6FEFA
                move.b  (V_int_run_count+3).w,d0
                andi.b  #$1F,d0
                bne.s   loc_6FEC6
                bsr.s   SetFBZAct2SubbossChaseVelocity

loc_6FEC6:
                move.w  #$100,d0
                movea.w $44(a0),a1
                move.w  x_pos(a1),d1
                move.w  x_pos(a0),d2
                addi.w  #$20,d1
                cmp.w   d1,d2
                blo.s   loc_6FEF0
                movea.w parent3(a0),a1
                move.w  x_pos(a1),d1
                subi.w  #$20,d1
                cmp.w   d1,d2
                blo.s   loc_6FEF4
                neg.w   d0

loc_6FEF0:
                move.w  d0,x_vel(a0)

loc_6FEF4:
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

loc_6FEFA:
                move.b  #6,routine(a0)
                move.w  #$7F,$2E(a0)
                move.l  #loc_6FE28,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_6FF10:
                bset    #4,$38(a0)
                move.w  #$5F,$2E(a0)
                move.l  #loc_6FF34,$34(a0)
                jsr     (AllocateObject).l
                bne.s   locret_6FF32
                move.l  #Obj_Song_Fade_ToLevelMusic,(a1)

locret_6FF32:
                rts
; ---------------------------------------------------------------------------

loc_6FF34:
                bset    #2,$38(a0)
                clr.b   (Boss_flag).w
                move.l  #loc_6FF50,(a0)
                lea     (PLC_Monitors).l,a1
                jmp     (Load_PLC_Raw).l
; ---------------------------------------------------------------------------

loc_6FF50:
                move.w  (Camera_X_pos).w,(Camera_min_X_pos).w
                jmp     (Sprite_CheckDeleteXY).l
; ---------------------------------------------------------------------------

loc_6FF5C:
                lea     word_703A2(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #loc_6FF70,(a0)
                bra.w   loc_702EA
; ---------------------------------------------------------------------------

loc_6FF70:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   loc_6FFB0
                btst    #1,subtype(a0)
                bne.s   loc_6FFAA
                movea.w parent3(a0),a1
                btst    #3,$38(a1)
                beq.s   loc_6FFAA
                move.l  #loc_6FFB8,(a0)
                move.w  #$1F,$2E(a0)
                move.l  #loc_6FFCA,$34(a0)
                move.w  #$100,x_vel(a0)

loc_6FFAA:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_6FFB0:
                move.l  #Sprite_OnScreen_Test,(a0)
                rts
; ---------------------------------------------------------------------------

loc_6FFB8:
                jsr     (MoveSprite2).l
                jsr     (Obj_Wait).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_6FFCA:
                move.l  #loc_6FF70,(a0)
                movea.w parent3(a0),a1
                bclr    #3,$38(a1)
                rts
; ---------------------------------------------------------------------------

loc_6FFDC:
                lea     word_703A8(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #loc_6FFFA,(a0)
                addi.w  #$CC,x_pos(a0)
                addi.w  #$7C,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

loc_6FFFA:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   loc_7000C
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_7000C:
                move.l  #Sprite_OnScreen_Test,(a0)
                move.b  #3,mapping_frame(a0)
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild1_Normal).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_7002A:
                lea     ObjDat3_703BC(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #loc_70068,(a0)
                move.l  #loc_700EA,$34(a0)
                addi.w  #$D8,x_pos(a0)
                addi.w  #$74,y_pos(a0)
                move.l  #byte_703F4,$30(a0)
                cmpi.b  #2,(Player_1+character_id).w
                bne.s   locret_70066
                move.l  #Map_EggRoboStand,mappings(a0)

locret_70066:
                rts
; ---------------------------------------------------------------------------

loc_70068:
                jsr     (Animate_RawMultiDelay).l
                movea.w parent3(a0),a1
                btst    #6,status(a1)
                beq.s   loc_70080
                move.b  #2,mapping_frame(a0)

loc_70080:
                btst    #7,status(a1)
                beq.s   loc_70094
                move.l  #loc_7009A,(a0)
                move.b  #3,mapping_frame(a0)

loc_70094:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_7009A:
                movea.w parent3(a0),a1
                btst    #4,$38(a1)
                beq.s   loc_700E4
                move.l  $34(a0),(a0)
                subq.w  #4,y_pos(a0)
                move.w  #$200,x_vel(a0)
                move.l  #Map_FBZRobotnikRun,mappings(a0)
                move.w  #make_art_tile(ArtTile_FBZRobotnikRun,0,1),art_tile(a0)
                clr.b   mapping_frame(a0)
                clr.b   anim_frame_timer(a0)
                clr.b   anim_frame(a0)
                bset    #0,render_flags(a0)
                cmpi.b  #2,(Player_1+character_id).w
                bne.s   loc_700E4
                move.l  #Map_EggRoboRun,mappings(a0)

loc_700E4:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_700EA:
                tst.b   render_flags(a0)
                bpl.s   loc_70106
                lea     byte_70419(pc),a1
                jsr     (Animate_RawNoSST).l
                jsr     (MoveSprite2).l
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

loc_70106:
                lea     (PLC_MonitorsSpikesSprings).l,a1
                jsr     (Load_PLC_Raw).l
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_70118:
                lea     word_703AE(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #loc_70152,(a0)
                move.w  #$B0,d0
                move.b  subtype(a0),d1
                bne.s   loc_70134
                neg.w   d0

loc_70134:
                add.w   d0,x_pos(a0)
                addi.w  #$60,y_pos(a0)
                movea.w parent3(a0),a1
                moveq   #$44,d0
                tst.b   d1
                beq.s   loc_7014A
                moveq   #parent3,d0

loc_7014A:
                move.w  (a1,d0.w),$44(a0)
                rts
; ---------------------------------------------------------------------------

loc_70152:
                movea.w parent3(a0),a1
                btst    #2,$38(a1)
                bne.s   loc_7018C
                move.w  x_pos(a0),-(sp)
                movea.w $44(a0),a1
                move.w  x_pos(a1),x_pos(a0)
                moveq   #$13,d1
                moveq   #$50,d2
                move.w  #$60,d3
                move.w  (sp)+,d4
                jsr     (SolidObjectFull).l
                btst    #0,(V_int_run_count+3).w
                bne.w   locret_6FE20
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_7018C:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_70192:
                lea     word_703B4(pc),a1
                jsr     (SetUp_ObjAttributes2).l
                move.l  #loc_701B4,(a0)
                move.l  #byte_70401,$30(a0)
                move.l  #loc_701EE,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_701B4:
                jsr     (Refresh_ChildPosition).l
                jsr     (Animate_RawGetFaster).l
                tst.w   d2
                beq.s   loc_701E8
                bmi.s   loc_701D6
                cmpi.b  #4,$2E(a0)
                bne.s   loc_701E8
                moveq   #signextendB(sfx_Charging),d0
                jsr     (Play_SFX).l

loc_701D6:
                cmpi.b  #$20,$2F(a0)
                bne.s   loc_701E8
                movea.w parent3(a0),a1
                bset    #1,$38(a1)

loc_701E8:
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------

loc_701EE:
                move.l  #loc_70220,(a0)
                move.b  #6,mapping_frame(a0)
                move.l  #byte_70406,$30(a0)
                addi.w  #$3C,y_pos(a0)
                move.w  #$1F,$2E(a0)
                move.l  #loc_70262,$34(a0)
                moveq   #signextendB(sfx_BossLaser),d0
                jsr     (Play_SFX).l
                rts
; ---------------------------------------------------------------------------

loc_70220:
                clr.b   collision_flags(a0)
                cmpi.b  #8,mapping_frame(a0)
                bne.s   loc_70232
                move.b  #$AC,collision_flags(a0)

loc_70232:
                lea     (Player_1).w,a2
                cmpi.b  #4,routine(a2)
                beq.s   loc_7024A
                lea     (Player_2).w,a2
                cmpi.b  #4,routine(a2)
                bne.s   loc_70250

loc_7024A:
                bset    #6,status(a0)

loc_70250:
                jsr     (Animate_Raw).l
                jsr     (Obj_Wait).l
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------

loc_70262:
                move.l  #loc_70294,$34(a0)
                move.w  #$1F,$2E(a0)
                jsr     (AllocateObject).l
                bne.s   loc_7027E
                move.l  #SKLevel_InitializeScreenShakeRumbleActor,(a1)

loc_7027E:
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild1_Normal).l
                bne.s   locret_70292
                addi.w  #$60,y_pos(a1)

locret_70292:
                rts
; ---------------------------------------------------------------------------

loc_70294:
                move.l  #byte_70412,$30(a0)
                move.l  #loc_702C0,$34(a0)
                clr.b   anim_frame_timer(a0)
                clr.b   anim_frame(a0)
                btst    #6,status(a0)
                bne.s   locret_702BE
                movea.w parent3(a0),a1
                bset    #6,status(a1)

locret_702BE:
                rts
; ---------------------------------------------------------------------------

loc_702C0:
                move.l  #Obj_Wait,(a0)
                move.w  #$1F,$2E(a0)
                move.l  #loc_702D6,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_702D6:
                movea.w parent3(a0),a1
                tst.b   $39(a1)
                bmi.s   loc_702E4
                clr.w   (Screen_shake_flag).w

loc_702E4:
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

loc_702EA:
                movea.w parent3(a0),a1
                moveq   #0,d0
                move.b  subtype(a0),d0
                cmpi.w  #4,d0
                bhs.s   loc_7030C
                moveq   #$44,d1
                tst.b   d0
                beq.s   loc_70302
                moveq   #parent3,d1

loc_70302:
                move.w  a0,(a1,d1.w)
                bset    #1,render_flags(a0)

loc_7030C:
                add.w   d0,d0
                lea     word_70320(pc,d0.w),a1
                move.w  (a1)+,d0
                add.w   d0,x_pos(a0)
                move.w  (a1)+,d0
                add.w   d0,y_pos(a0)
                rts
; ---------------------------------------------------------------------------
word_70320:
                dc.w    -$B0,   $18
                dc.w    $B0,   $18
                dc.w    -$B0,   $A8
                dc.w    $B0,   $A8

; =============== S U B R O U T I N E =======================================

FlashAndResetFBZAct2SubbossHitState:
                tst.b   collision_flags(a0)
                bne.s   locret_70360
                tst.b   $20(a0)
                bne.s   loc_7034A
                move.b  #$20,$20(a0)
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l

loc_7034A:
                bsr.w   CopyFBZAct2SubbossFlashPalette
                subq.b  #1,$20(a0)
                bne.s   locret_70360
                move.b  $25(a0),collision_flags(a0)
                move.b  #$7F,collision_property(a0)

locret_70360:
                rts
; End of function FlashAndResetFBZAct2SubbossHitState

; =============== S U B R O U T I N E =======================================

CopyFBZAct2SubbossFlashPalette:
                moveq   #0,d0
                btst    #0,$20(a0)
                bne.s   loc_70376
                btst    #7,status(a0)
                bne.s   loc_70376
                addq.w  #2*3,d0

loc_70376:
                lea     word_70384(pc),a1
                lea     word_7038A(pc,d0.w),a2
                jmp     (CopyWordData_3).l
; End of function CopyFBZAct2SubbossFlashPalette

; ---------------------------------------------------------------------------
word_70384:
                dc.w    Normal_palette_line_2+$18, Normal_palette_line_2+$1A, Normal_palette_line_2+$1C
word_7038A:
                dc.w    $866,  $644,   $20
                dc.w    $EEE,  $EEE,  $EEE
