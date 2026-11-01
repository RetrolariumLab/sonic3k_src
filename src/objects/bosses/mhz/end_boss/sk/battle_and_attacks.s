; Owner: objects/bosses/mhz/end_boss/sk
; Responsibility: Mushroom Hill end-boss controller, attached actors, attack and defeat states
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_MHZEndBoss:
                lea     word_769F4(pc),a1
                jsr     (Check_CameraInRange).l
                move.l  #loc_75FD4,(a0)
                move.w  (Camera_X_pos).w,(Camera_min_X_pos).w
                move.b  #1,(Boss_flag).w
                jsr     (loc_85D7E).l
                addi.w  #$C0,x_pos(a0)
                lea     ObjDat_MHZEndBoss(pc),a1
                jsr     (SetUp_ObjAttributes).l
                clr.b   routine(a0)
                clr.b   (_unkFAA9).w
                lea     (ArtKosM_MHZEndBoss).l,a1
                move.w  #tiles_to_bytes(ArtTile_MHZEndBoss),d2
                jsr     (Queue_Kos_Module).l
                moveq   #PLCID_7B,d0
                jsr     (Load_PLC).l
                lea     Pal_MHZEndBoss(pc),a1
                jsr     (PalLoad_Line1).l
                lea     ChildObjDat_7699C(pc),a2
                jsr     (CreateChild1_Normal).l
                lea     ChildObjDat_76982(pc),a2
                jsr     (CreateChild1_Normal).l
                lea     ChildObjDat_7697C(pc),a2
                jsr     (CreateChild6_Simple).l
                lea     ChildObjDat_76976(pc),a2
                jmp     (CreateChild6_Simple).l
; ---------------------------------------------------------------------------

loc_75FD4:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_75FF4(pc,d0.w),d1
                jsr     off_75FF4(pc,d1.w)
                move.w  (Level_repeat_offset).w,d0
                sub.w   d0,x_pos(a0)
                bsr.w   HandleMHZEndBossPairedHitFlashAndEscapeThreshold
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------
off_75FF4:
                dc.w    loc_76004-off_75FF4
                dc.w    loc_7601A-off_75FF4
                dc.w    loc_76038-off_75FF4
                dc.w    loc_76062-off_75FF4
                dc.w    loc_76088-off_75FF4
                dc.w    loc_76088-off_75FF4
                dc.w    loc_76106-off_75FF4
                dc.w    loc_76088-off_75FF4
; ---------------------------------------------------------------------------

loc_76004:
                move.b  #$F,collision_flags(a0)
                move.b  #9,collision_property(a0)
                move.b  collision_flags(a0),$25(a0)
                clr.b   (_unkFA88).w

loc_7601A:
                btst    #2,$38(a0)
                beq.s   locret_76036
                move.b  #4,routine(a0)
                move.w  #$3F,$2E(a0)
                move.l  #loc_7603E,$34(a0)

locret_76036:
                rts
; ---------------------------------------------------------------------------

loc_76038:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_7603E:
                move.b  #6,routine(a0)
                move.w  #-$200,y_vel(a0)
                move.w  #$23,$2E(a0)
                move.l  #loc_7606E,$34(a0)
                moveq   #signextendB(sfx_Rising),d0
                jsr     (Play_SFX).l

locret_76060:
                rts
; ---------------------------------------------------------------------------

loc_76062:
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_7606E:
                move.b  #8,routine(a0)
                move.w  #$3F,$2E(a0)
                move.l  #loc_7609A,$34(a0)
                jmp     (Swing_Setup1).l
; ---------------------------------------------------------------------------

loc_76088:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_7609A:
                move.b  #$A,routine(a0)
                bset    #6,$38(a0)
                move.w  #$400,x_vel(a0)
                move.w  #$3F,$2E(a0)
                move.l  #loc_760C4,$34(a0)
                moveq   #signextendB(sfx_Dash),d0
                jsr     (Play_SFX).l
                rts
; ---------------------------------------------------------------------------

loc_760C4:
                move.b  #$C,routine(a0)
                bset    #7,$38(a0)
                move.w  #$4180,x_pos(a0)
                move.w  #$2E0,y_pos(a0)
                bset    #3,$38(a0)
                clr.w   x_vel(a0)
                jsr     (AllocateObject).l
                bne.s   loc_760F4
                move.l  #loc_76896,(a1)

loc_760F4:
                move.w  #$45A0,(Camera_stored_max_X_pos).w
                lea     (Child6_IncLevX).l,a2
                jmp     (CreateChild6_Simple).l
; ---------------------------------------------------------------------------

loc_76106:
                move.w  (Camera_X_pos).w,d0
                addi.w  #$E0,d0
                cmp.w   x_pos(a0),d0
                bhs.s   loc_76120
                jsr     (Swing_UpAndDown).l
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

loc_76120:
                move.b  #$E,routine(a0)
                move.l  #loc_76136,$34(a0)
                clr.w   $2E(a0)
                bra.w   loc_76088
; ---------------------------------------------------------------------------

loc_76136:
                move.w  #$5F,$2E(a0)
                move.w  #$400,d0
                cmpi.b  #2,(Player_1+character_id).w
                bne.s   loc_7614C
                move.w  #$500,d0

loc_7614C:
                move.w  #$100,d1
                bchg    #6,$38(a0)
                beq.s   loc_7615C
                move.w  #-$100,d1

loc_7615C:
                add.w   d1,d0
                move.w  d0,x_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_76164:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                cmpi.w  #$44D0,x_pos(a0)
                blo.s   loc_761A4
                move.l  #Wait_FadeToLevelMusic,(a0)
                bset    #7,status(a0)
                move.w  #$14,(Screen_shake_flag).w
                move.l  #loc_761B2,$34(a0)
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild6_Simple).l
                jsr     (BossDefeated_StopTimer).l

loc_761A4:
                move.w  (Level_repeat_offset).w,d0
                sub.w   d0,x_pos(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_761B2:
                move.l  #loc_761E8,(a0)
                move.w  #$100,priority(a0)
                bset    #7,art_tile(a0)
                clr.w   x_vel(a0)
                move.w  #-$200,y_vel(a0)
                bset    #4,$38(a0)
                lea     PLC_MHZEndBoss_Explosion(pc),a1
                jsr     (Load_PLC_Raw).l
                lea     ChildObjDat_769B0(pc),a2
                jmp     (CreateChild6_Simple).l
; ---------------------------------------------------------------------------

loc_761E8:
                jsr     (MoveSprite).l
                move.w  (Camera_Y_pos).w,d0
                addi.w  #$120,d0
                cmp.w   y_pos(a0),d0
                bhs.s   loc_76236
                move.l  #loc_7623C,(a0)
                bset    #0,(_unkFA88).w
                st      (_unkFAA8).w
                clr.b   (Boss_flag).w
                bset    #5,$38(a0)
                jsr     (PLCLoad_AnimalsAndExplosion).l
                jsr     (AllocateObject).l
                bne.s   loc_76236
                move.l  #Obj_EggCapsule,(a1)
                move.w  #$4640,x_pos(a1)
                move.w  #$320,y_pos(a1)

loc_76236:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_7623C:
                move.w  (Camera_X_pos).w,d0
                addq.w  #4,d0
                move.w  #$45A0,d1
                cmp.w   d1,d0
                blo.s   loc_7626A
                move.l  #loc_76270,(a0)
                move.w  d1,d0
                move.w  d1,(Camera_min_X_pos).w
                move.w  d1,(Camera_max_X_pos).w
                clr.b   (Scroll_lock).w
                clr.b   (Ctrl_1_locked).w
                clr.b   (Ctrl_2_locked).w
                clr.w   (Ctrl_1_logical).w

loc_7626A:
                move.w  d0,(Camera_X_pos).w
                rts
; ---------------------------------------------------------------------------

loc_76270:
                tst.b   (_unkFAA8).w
                bne.w   locret_76060
                move.l  #loc_76310,(a0)
                clr.b   (_unkFAA9).w
                move.w  (Camera_X_pos).w,d0
                subi.w  #$40,d0
                move.w  d0,x_pos(a0)
                move.w  (Camera_Y_pos).w,d0
                addi.w  #$40,d0
                move.w  d0,y_pos(a0)
                jsr     (Restore_PlayerControl).l
                bset    #7,art_tile(a1)
                lea     (Player_2).w,a1
                bset    #7,art_tile(a1)
                jsr     (Restore_PlayerControl2).l
                jsr     (Restore_LevelMusic).l
                st      (Ctrl_1_locked).w
                move.w  #(button_up_mask<<8)|button_up_mask,(Ctrl_1_logical).w
                st      (Ctrl_2_locked).w
                move.w  #(button_up_mask<<8)|button_up_mask,(Ctrl_2_logical).w
                jsr     (FacePlayersTowardObject).l
                move.w  #$1BF,$2E(a0)
                move.w  #$55,(Events_fg_4).w
                move.w  #$5000,(Camera_stored_max_X_pos).w
                bclr    #5,$38(a0)
                lea     ChildObjDat_7699C(pc),a2
                jsr     (CreateChild1_Normal).l
                lea     (PLC_RobotnikShip).l,a1
                jsr     (Load_PLC_Raw).l
                lea     (Child6_IncLevX).l,a2
                jmp     (CreateChild6_Simple).l
; ---------------------------------------------------------------------------

loc_76310:
                subq.w  #1,$2E(a0)
                bmi.s   loc_76318
                rts
; ---------------------------------------------------------------------------

loc_76318:
                move.l  #loc_76356,(a0)
                bclr    #7,status(a0)
                bclr    #4,$38(a0)
                bset    #0,render_flags(a0)
                move.w  #$400,x_vel(a0)
                clr.w   y_vel(a0)
                lea     (Child1_MakeRoboShipFlame).l,a2
                jsr     (CreateChild1_Normal).l
                cmpi.b  #2,(Player_1+character_id).w
                bne.w   locret_76060
                jmp     (loc_67B1C).l
; ---------------------------------------------------------------------------

loc_76356:
                moveq   #signextendB(sfx_RobotnikSiren),d0
                jsr     (Play_SFX_Continuous).l
                jsr     (FacePlayersTowardObject).l
                moveq   #0,d1
                move.w  (Camera_X_pos).w,d0
                addi.w  #$80,d0
                cmp.w   x_pos(a0),d0
                bhs.s   loc_76376
                moveq   #-$10,d1

loc_76376:
                jsr     (MoveSprite_CustomGravity).l
                move.w  (Camera_Y_pos).w,d0
                subi.w  #$40,d0
                cmp.w   y_pos(a0),d0
                blo.s   loc_763A4
                move.l  #loc_763B2,(a0)
                bset    #5,$38(a0)
                jsr     (AllocateObject).l
                bne.s   loc_763A4
                move.l  #loc_863C0,(a1)

loc_763A4:
                move.w  (Level_repeat_offset).w,d0
                sub.w   d0,x_pos(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_763B2:
                lea     (Player_1).w,a1
                cmpi.w  #$4778,x_pos(a1)
                bhs.s   loc_763C4
                jmp     (loc_86334).l
; ---------------------------------------------------------------------------

loc_763C4:
                move.l  #loc_763D8,(a0)
                clr.w   (Ctrl_1_logical).w
                lea     (Player_1).w,a1
                jmp     (Stop_Object).l
; ---------------------------------------------------------------------------

loc_763D8:
                move.w  #(button_up_mask<<8)|button_up_mask,(Ctrl_1_logical).w
                move.w  #(button_up_mask<<8)|button_up_mask,(Ctrl_2).w
                tst.b   (_unkFAA9).w
                beq.w   locret_76060
                move.l  #loc_76404,(a0)
                move.w  #(button_C_mask<<8)|button_C_mask,(Ctrl_1_logical).w
                lea     (Player_1).w,a1
                move.w  #$200,x_vel(a1)
                rts
; ---------------------------------------------------------------------------

loc_76404:
                move.w  #button_C_mask<<8,(Ctrl_1_logical).w
                lea     (Player_1).w,a1
                tst.w   y_vel(a1)
                bmi.w   locret_76060
                move.l  #loc_76456,(a0)
                jsr     (Stop_Object).l
                move.b  #$81,object_control(a1)
                move.b  #$11,anim(a1)
                bset    #0,render_flags(a1)
                bset    #Status_Facing,status(a1)
                move.w  #$5F,$2E(a0)
                moveq   #signextendB(sfx_Grab),d0
                jsr     (Play_SFX).l
                jsr     (AllocateObject).l
                bne.s   loc_76456
                move.l  #loc_7646E,(a1)

loc_76456:
                subq.w  #1,$2E(a0)
                bmi.s   loc_7645E
                rts
; ---------------------------------------------------------------------------

loc_7645E:
                move.w  #$400,d0
                jsr     (StartNewLevel).l
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_7646E:
                move.l  #loc_76492,(a0)
                lea     (Player_2).w,a1
                move.b  #$81,object_control(a1)
                move.b  #$20,anim(a1)
                bclr    #0,render_flags(a1)
                bclr    #Status_Facing,status(a1)
                rts
; ---------------------------------------------------------------------------

loc_76492:
                lea     (Player_2).w,a1
                addq.w  #1,x_pos(a1)
                subq.w  #1,y_pos(a1)
                rts
; ---------------------------------------------------------------------------

loc_764A0:
                lea     word_76964(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #loc_764C4,(a0)
                movea.w parent3(a0),a1
                move.w  a0,$44(a1)
                move.b  collision_flags(a0),$25(a0)
                move.b  #-1,collision_property(a0)

loc_764C4:
                jsr     (Refresh_ChildPositionAdjusted).l
                jmp     (Child_AddToTouchList).l
; ---------------------------------------------------------------------------

loc_764D0:
                lea     ObjDat3_76934(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #loc_764E0,(a0)

loc_764E0:
                movea.w parent3(a0),a1
                btst    #3,$38(a1)
                beq.s   loc_764F8
                move.l  #loc_764F8,(a0)
                bset    #7,art_tile(a0)

loc_764F8:
                bsr.w   SyncMHZEndBossOverlayPositionAndHorizontalFlip
                jmp     (Child_Draw_Sprite2).l
; ---------------------------------------------------------------------------

loc_76502:
                lea     ObjDat3_76934(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #loc_76516,(a0)
                bsr.w   SelectMHZEndBossOverlayLayerBySubtype

loc_76516:
                bsr.w   SyncMHZEndBossOverlayPositionAndHorizontalFlip
                jmp     (Child_Draw_Sprite2).l
; ---------------------------------------------------------------------------

loc_76520:
                lea     ObjDat3_76940(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #loc_7654A,(a0)
                move.b  #1,collision_property(a0)
                lea     ChildObjDat_769A4(pc),a2
                jsr     (CreateChild6_Simple).l
                lea     ChildObjDat_769AA(pc),a2
                jsr     (CreateChild6_Simple).l

loc_7654A:
                tst.b   collision_flags(a0)
                beq.s   loc_76574
                subq.w  #1,$2E(a0)
                bpl.s   loc_7656E
                jsr     (Random_Number).l
                andi.w  #$F,d0
                addq.w  #8,d0
                move.w  d0,$2E(a0)
                moveq   #signextendB(sfx_WeatherMachine),d0
                jsr     (Play_SFX).l

loc_7656E:
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------

loc_76574:
                move.l  #Wait_Draw,(a0)
                move.w  #$3F,$2E(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                movea.w parent3(a0),a1
                bset    #2,$38(a1)
                lea     (Normal_palette).w,a1
                lea     (Target_palette).w,a2
                moveq   #bytesToLcnt($20),d6

loc_7659C:
                move.l  (a1)+,(a2)+
                dbf     d6,loc_7659C
                lea     (Pal_MHZEndBoss).l,a1
                lea     (Target_palette_line_2).w,a2
                moveq   #bytesToLcnt($20),d6

loc_765AE:
                move.l  (a1)+,(a2)+
                dbf     d6,loc_765AE
                lea     (Pal_MHZ1+$20).l,a1
                lea     (Target_palette_line_3).w,a2
                moveq   #bytesToLcnt($40),d6

loc_765C0:
                move.l  (a1)+,(a2)+
                dbf     d6,loc_765C0
                jsr     (AllocateObject).l
                bne.s   loc_765DE
                move.l  #loc_85E64,(a1)
                st      subtype(a1)
                move.w  #3,$3A(a1)

loc_765DE:
                jsr     (AllocateObject).l
                bne.s   loc_765F2
                move.l  #Obj_Song_Fade_Transition,(a1)
                move.b  #mus_EndBoss,subtype(a1)

loc_765F2:
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild6_Simple).l
                clr.b   (_unkF7C1).w
                rts
; ---------------------------------------------------------------------------

loc_76604:
                lea     word_76958(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #byte_769B6,$30(a0)
                tst.b   subtype(a0)
                beq.s   loc_76624
                move.l  #byte_769C1,$30(a0)

loc_76624:
                move.l  #loc_7662A,(a0)

loc_7662A:
                jsr     (Animate_RawMultiDelay).l
                jmp     (Child_Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_76636:
                lea     word_7695E(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #loc_76652,(a0)
                move.l  #byte_769CE,$30(a0)
                bsr.w   OffsetMHZWeatherMachineEffectBySubtype

loc_76652:
                jsr     (Animate_Raw).l
                jmp     (Child_Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_7665E:
                lea     ObjDat3_7694C(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #loc_76674,(a0)
                bset    #4,shield_reaction(a0)

loc_76674:
                jsr     (Refresh_ChildPositionAdjusted).l
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   loc_766C4
                move.b  #$8B,collision_flags(a0)
                btst    #6,status(a1)
                beq.s   loc_76698
                clr.b   collision_flags(a0)

loc_76698:
                btst    #0,(V_int_run_count+3).w
                sne     d0
                tst.b   subtype(a0)
                beq.s   loc_766A8
                not.b   d0

loc_766A8:
                tst.b   d0
                bne.w   locret_76060
                btst    #6,$38(a1)
                beq.w   locret_76060
                jsr     (Add_SpriteToCollisionResponseList).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_766C4:
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

loc_766CA:
                lea     ObjDat3_7696A(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #Obj_FlickerMove,(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                add.w   d0,d0
                lea     word_766FC(pc,d0.w),a1
                move.w  (a1)+,priority(a0)
                move.b  (a1)+,mapping_frame(a0)
                moveq   #8,d0
                jsr     (Set_IndexedVelocity).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
word_766FC:
                dc.w    $200
                dc.b    $12
                even
                dc.w    $200
                dc.b    $13
                even
                dc.w    $300
                dc.b    $14
                even
                dc.w    $300
                dc.b    $15
                even
                dc.w    $200
                dc.b    $16
                even
                dc.w    $200
                dc.b    $17
                even
