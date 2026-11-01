; Owner: objects/bosses/lbz/final_boss_2/sk
; Responsibility: Launch Base final boss battle controller, player capture or release, defeat and scene transition
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_LBZFinalBoss2:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  LBZFinalBoss2_Index(pc,d0.w),d1
                jsr     LBZFinalBoss2_Index(pc,d1.w)
                jsr     (HandleLBZFinalBoss2SixColorHitOrDefeat).l
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------
LBZFinalBoss2_Index:
                dc.w    loc_742A8-LBZFinalBoss2_Index
                dc.w    loc_7430E-LBZFinalBoss2_Index
                dc.w    loc_7430E-LBZFinalBoss2_Index
                dc.w    loc_7432A-LBZFinalBoss2_Index
                dc.w    loc_7430E-LBZFinalBoss2_Index
                dc.w    loc_743CE-LBZFinalBoss2_Index
                dc.w    loc_74412-LBZFinalBoss2_Index
                dc.w    loc_74442-LBZFinalBoss2_Index
                dc.w    loc_74456-LBZFinalBoss2_Index
                dc.w    loc_7447A-LBZFinalBoss2_Index
                dc.w    loc_744A4-LBZFinalBoss2_Index
                dc.w    loc_744E4-LBZFinalBoss2_Index
                dc.w    loc_744FC-LBZFinalBoss2_Index
                dc.w    loc_74528-LBZFinalBoss2_Index
                dc.w    loc_74542-LBZFinalBoss2_Index
                dc.w    loc_7455C-LBZFinalBoss2_Index
                dc.w    loc_74576-LBZFinalBoss2_Index
                dc.w    loc_745A2-LBZFinalBoss2_Index
                dc.w    loc_745E2-LBZFinalBoss2_Index
                dc.w    loc_74618-LBZFinalBoss2_Index
                dc.w    loc_7463A-LBZFinalBoss2_Index
                dc.w    loc_746C8-LBZFinalBoss2_Index
; ---------------------------------------------------------------------------

loc_742A8:
                lea     ObjDat_LBZFinalBoss2(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.b  #8,collision_property(a0)
                bset    #3,$38(a0)
                st      (Disable_death_plane).w
                move.w  (Camera_X_pos).w,d0
                addi.w  #$A0,d0
                move.w  d0,x_pos(a0)
                move.w  (Camera_Y_pos).w,d0
                subi.w  #$50,d0
                move.w  d0,y_pos(a0)
                move.w  #$59,$2E(a0)
                move.l  #loc_74314,$34(a0)
                lea     Pal_LBZFinalBoss2(pc),a1
                jsr     (PalLoad_Line1).l
                lea     (ArtKosM_LBZFinalBoss2).l,a1
                move.w  #tiles_to_bytes(ArtTile_LBZFinalBoss2),d2
                jsr     (Queue_Kos_Module).l
                lea     (Child1_MakeRoboHead4).l,a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_7430E:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_74314:
                move.b  #6,routine(a0)
                move.b  #8,mapping_frame(a0)
                lea     ChildObjDat_75122(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_7432A:
                jsr     (MoveSprite_LightGravity).l
                move.w  (Camera_Y_pos).w,d0
                addi.w  #$120,d0
                cmp.w   y_pos(a0),d0
                blo.s   loc_74340
                rts
; ---------------------------------------------------------------------------

loc_74340:
                bset    #7,art_tile(a0)
                clr.w   y_vel(a0)
                move.b  #$F,$28(a0)
                bchg    #0,render_flags(a0)
                lea     ChildObjDat_7513C(pc),a2
                jsr     (CreateChild1_Normal).l

loc_74360:
                move.b  #8,routine(a0)
                move.w  #$7F,$2E(a0)
                move.l  #loc_74376,$34(a0)

locret_74374:
                rts
; ---------------------------------------------------------------------------

loc_74376:
                bchg    #0,render_flags(a0)
                move.b  $39(a0),d0
                addq.b  #1,$39(a0)
                btst    #2,d0
                bne.s   loc_743AE
                move.b  #$A,routine(a0)
                bclr    #3,$38(a0)
                bclr    #2,$38(a0)
                move.w  #$AF,$2E(a0)
                move.l  #loc_74360,$34(a0)
                bra.w   loc_74F24
; ---------------------------------------------------------------------------

loc_743AE:
                move.b  #$C,routine(a0)
                clr.b   $39(a0)
                clr.w   y_vel(a0)
                move.l  #loc_74428,$34(a0)
                move.w  (Camera_Y_pos).w,y_pos(a0)
                bra.w   loc_74F82
; ---------------------------------------------------------------------------

loc_743CE:
                move.w  $3A(a0),d0
                move.w  off_743E6(pc,d0.w),d0
                jsr     off_743E6(pc,d0.w)
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------
off_743E6:
                dc.w    locret_743F4-off_743E6
                dc.w    loc_743F0-off_743E6
                dc.w    loc_743F6-off_743E6
                dc.w    locret_743F4-off_743E6
                dc.w    loc_7440C-off_743E6
; ---------------------------------------------------------------------------

loc_743F0:
                subq.w  #4,y_vel(a0)

locret_743F4:
                rts
; ---------------------------------------------------------------------------

loc_743F6:
                move.w  y_vel(a0),d0
                add.w   $3C(a0),d0
                move.w  d0,y_vel(a0)
                bne.s   locret_7440A
                move.w  #2,$3C(a0)

locret_7440A:
                rts
; ---------------------------------------------------------------------------

loc_7440C:
                subq.w  #4,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

loc_74412:
                moveq   #$50,d1
                move.w  #$F0,d2
                bsr.w   ReverseLBZFinalBoss2AtCameraRelativeBounds
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_74428:
                move.b  #$E,routine(a0)
                clr.w   x_vel(a0)
                move.w  #$1F,$2E(a0)
                move.l  #loc_74448,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_74442:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_74448:
                move.b  #$10,routine(a0)
                bset    #3,$38(a0)
                rts
; ---------------------------------------------------------------------------

loc_74456:
                jsr     (MoveSprite_LightGravity).l
                move.w  (Camera_Y_pos_copy).w,d0
                addi.w  #$C0,d0
                cmp.w   y_pos(a0),d0
                blo.s   loc_7446C
                rts
; ---------------------------------------------------------------------------

loc_7446C:
                move.b  #$12,routine(a0)
                bset    #2,$38(a0)
                rts
; ---------------------------------------------------------------------------

loc_7447A:
                addi.w  #-$80,y_vel(a0)
                jsr     (MoveSprite2).l
                tst.w   y_vel(a0)
                bpl.s   locret_7449A
                move.w  (Camera_Y_pos_copy).w,d0
                addi.w  #$E0,d0
                cmp.w   y_pos(a0),d0
                bhs.s   loc_7449C

locret_7449A:
                rts
; ---------------------------------------------------------------------------

loc_7449C:
                move.b  #$14,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_744A4:
                addi.w  #$40,y_vel(a0)
                jsr     (MoveSprite2).l
                tst.w   y_vel(a0)
                bmi.s   locret_744C4
                move.w  (Camera_Y_pos_copy).w,d0
                addi.w  #$D0,d0
                cmp.w   y_pos(a0),d0
                bls.s   loc_744C6

locret_744C4:
                rts
; ---------------------------------------------------------------------------

loc_744C6:
                move.b  #$16,routine(a0)
                move.w  d0,y_pos(a0)
                clr.w   y_vel(a0)
                move.w  #$1F,$2E(a0)
                move.l  #loc_744EA,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_744E4:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_744EA:
                move.b  #$18,routine(a0)
                move.l  #loc_74512,$34(a0)
                bra.w   loc_74F82
; ---------------------------------------------------------------------------

loc_744FC:
                moveq   #$30,d1
                move.w  #$110,d2
                bsr.w   ReverseLBZFinalBoss2AtCameraRelativeBounds
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_74512:
                move.b  #$1A,routine(a0)
                move.w  #$1F,$2E(a0)
                move.l  #loc_7452E,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_74528:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_7452E:
                move.b  #$1C,routine(a0)
                move.w  #-$400,y_vel(a0)
                bclr    #3,$38(a0)
                rts
; ---------------------------------------------------------------------------

loc_74542:
                jsr     (MoveSprite2).l
                move.w  (Camera_Y_pos).w,d0
                subi.w  #$60,d0
                cmp.w   y_pos(a0),d0
                bhs.s   loc_74558
                rts
; ---------------------------------------------------------------------------

loc_74558:
                bra.w   loc_74360
; ---------------------------------------------------------------------------

loc_7455C:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_74562:
                move.b  #$20,routine(a0)
                move.w  #-$400,y_vel(a0)
                bchg    #1,$39(a0)
                rts
; ---------------------------------------------------------------------------

loc_74576:
                jsr     (MoveSprite2).l
                move.w  (Camera_Y_pos).w,d0
                subi.w  #$60,d0
                cmp.w   y_pos(a0),d0
                bhs.s   loc_7458C
                rts
; ---------------------------------------------------------------------------

loc_7458C:
                move.b  #$22,routine(a0)
                move.w  #$3F,$2E(a0)
                move.l  #loc_745A8,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_745A2:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_745A8:
                move.b  #$24,routine(a0)
                movea.w $44(a0),a1
                clr.b   $3C(a1)
                move.w  (Camera_X_pos).w,d0
                move.w  d0,d1
                addi.w  #$A0,d0
                bclr    #0,render_flags(a0)
                move.w  #$E0,d2
                cmp.w   x_pos(a0),d0
                blo.s   loc_745DA
                bset    #0,render_flags(a0)
                move.w  #$60,d2

loc_745DA:
                add.w   d2,d1
                move.w  d1,x_pos(a0)
                rts
; ---------------------------------------------------------------------------

loc_745E2:
                move.w  (Camera_Y_pos_copy).w,d0
                addi.w  #$88,d0
                cmp.w   y_pos(a0),d0
                bls.s   loc_745F6
                addq.w  #8,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

loc_745F6:
                move.b  #$26,routine(a0)
                bset    #1,$38(a0)
                move.w  #$14,(Screen_shake_flag).w
                move.w  #3,$2E(a0)
                moveq   #signextendB(sfx_BossHitFloor),d0
                jsr     (Play_SFX).l
                rts
; ---------------------------------------------------------------------------

loc_74618:
                addq.w  #4,y_pos(a0)
                subq.w  #1,$2E(a0)
                bmi.s   loc_74624
                rts
; ---------------------------------------------------------------------------

loc_74624:
                move.b  #$28,routine(a0)
                move.w  #7,$2E(a0)
                move.l  #loc_74640,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_7463A:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_74640:
                move.b  #$2A,routine(a0)
                clr.b   $30(a0)
                subi.w  #$10,y_pos(a0)
                bclr    #1,$38(a0)
                move.w  #$400,d0
                btst    #0,render_flags(a0)
                beq.s   loc_74664
                neg.w   d0

loc_74664:
                move.w  d0,x_vel(a0)
                move.w  #-$600,y_vel(a0)
                move.w  #$3F,$2E(a0)
                btst    #Status_Invincible,(Player_1+status_secondary).w
                bne.s   loc_7468C
                movea.l a0,a2
                lea     (Player_1).w,a0
                jsr     (HurtCharacter).l
                movea.l a2,a0
                rts
; ---------------------------------------------------------------------------

loc_7468C:
                lea     (Player_1).w,a1
                clr.b   object_control(a1)
                neg.w   d0
                move.w  d0,x_vel(a1)
                move.w  #-$400,y_vel(a1)
                bset    #Status_InAir,status(a1)
                bclr    #Status_OnObj,status(a1)
                clr.b   jumping(a1)
                clr.b   spin_dash_flag(a1)
                move.b  #2,anim(a1)
                move.b  #2,routine(a1)
                moveq   #signextendB(sfx_Spring),d0
                jmp     (Play_SFX).l
; ---------------------------------------------------------------------------

loc_746C8:
                jsr     (MoveSprite).l
                subq.w  #1,$2E(a0)
                bmi.w   loc_74360
                rts
; ---------------------------------------------------------------------------

loc_746D8:
                move.l  #loc_746F4,(a0)
                move.b  #5,mapping_frame(a0)
                bset    #4,$38(a0)
                lea     ChildObjDat_7515E(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_746F4:
                move.w  y_pos(a0),d0
                subq.w  #1,d0
                move.w  d0,y_pos(a0)
                move.w  (Camera_Y_pos).w,d1
                subi.w  #$40,d1
                cmp.w   d1,d0
                blo.s   loc_74710
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_74710:
                move.l  #loc_7473A,(a0)
                bclr    #7,render_flags(a0)
                bset    #5,$38(a0)
                bset    #0,render_flags(a0)
                move.w  (Camera_X_pos).w,d2
                addi.w  #$40,d2
                move.w  d2,x_pos(a0)
                jmp     (loc_694AA).l
; ---------------------------------------------------------------------------

loc_7473A:
                tst.b   (_unkFAA8).w
                bne.w   locret_74374
                tst.b   (_unkFAA2).w
                beq.w   locret_74374
                move.l  #loc_74768,(a0)
                jsr     QueueLBZFinalBossExtraShipAndExplosionGraphics(pc)
                bclr    #7,status(a0)
                jsr     (Restore_PlayerControl).l
                clr.w   (Ctrl_1_logical).w
                st      (Ctrl_1_locked).w

loc_74768:
                lea     (Player_1).w,a1
                move.w  #(button_right_mask<<8)|button_right_mask,d0
                move.w  (Camera_X_pos).w,d1
                addi.w  #$50,d1
                sub.w   x_pos(a1),d1
                bcc.s   loc_74784
                move.w  #(button_left_mask<<8)|button_left_mask,d0
                neg.w   d1

loc_74784:
                move.w  d0,(Ctrl_1_logical).w
                cmpi.w  #8,d1
                bhs.w   locret_74374
                move.l  #loc_747D6,(a0)
                clr.w   (Ctrl_1_logical).w
                bset    #0,render_flags(a1)
                bset    #Status_Facing,status(a1)
                jsr     (Stop_Object).l
                moveq   #PLCID_71,d0
                jsr     (Load_PLC).l
                lea     (ArtKosM_EggRoboHead).l,a1
                move.w  #tiles_to_bytes(ArtTile_RobotnikShip),d2
                jsr     (Queue_Kos_Module).l
                bclr    #5,$38(a0)
                lea     (Child1_MakeRoboHead4).l,a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_747D6:
                move.w  #(button_up_mask<<8)|button_up_mask,(Ctrl_1_logical).w
                move.w  y_pos(a0),d0
                addq.w  #1,d0
                move.w  (Camera_Y_pos).w,d1
                addi.w  #$40,d1
                cmp.w   d1,d0
                bhs.s   loc_747F8
                move.w  d0,y_pos(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_747F8:
                move.l  #loc_7481C,(a0)
                move.w  #$200,x_vel(a0)
                jsr     (Swing_Setup1).l
                lea     (Child1_MakeRoboShipFlame).l,a2
                jsr     (CreateChild1_Normal).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_7481C:
                move.w  #(button_up_mask<<8)|button_up_mask,(Ctrl_1_logical).w
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                move.w  x_pos(a0),d0
                lea     (Player_1).w,a1
                bclr    #0,render_flags(a1)
                bclr    #Status_Facing,status(a1)
                cmp.w   x_pos(a1),d0
                bhs.s   loc_74854
                bset    #0,render_flags(a1)
                bset    #Status_Facing,status(a1)

loc_74854:
                move.w  (Camera_X_pos).w,d1
                addi.w  #$A0,d1
                cmp.w   d1,d0
                bhs.s   loc_74866
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_74866:
                move.w  d0,x_pos(a0)
                move.l  #loc_74894,(a0)
                move.w  #$1F,$2E(a0)
                move.l  #loc_748A0,$34(a0)
                bclr    #3,$38(a0)
                lea     ChildObjDat_7517E(pc),a2
                jsr     (CreateChild1_Normal).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_74894:
                jsr     (Obj_Wait).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_748A0:
                move.l  #loc_748AE,(a0)
                move.w  #$400,x_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_748AE:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                move.w  x_pos(a0),d0
                move.w  (Camera_X_pos).w,d1
                addi.w  #$1C0,d1
                cmp.w   d1,d0
                bhs.s   loc_748D0
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_748D0:
                move.l  #loc_748F4,(a0)
                bset    #6,status(a0)
                bset    #4,$38(a0)
                bset    #5,$38(a0)
                clr.b   (Boss_flag).w
                bclr    #7,render_flags(a0)
                rts
; ---------------------------------------------------------------------------

loc_748F4:
                btst    #3,$38(a0)
                beq.s   locret_74908
                move.l  #loc_7490A,(a0)
                move.w  #(button_right_mask<<8)|button_right_mask,(Ctrl_1_logical).w

locret_74908:
                rts
; ---------------------------------------------------------------------------

loc_7490A:
                cmpi.w  #$4510,(Player_1+x_pos).w
                blo.s   locret_74950
                move.l  #loc_74952,(a0)
                lea     (Player_1).w,a1
                move.w  x_pos(a1),x_pos(a0)
                move.w  y_pos(a1),y_pos(a0)
                move.b  #$83,object_control(a1)
                move.b  #$8C,mapping_frame(a1)
                jsr     (Player_Load_PLC).l
                clr.b   anim_frame(a0)
                move.b  #$A,anim_frame_timer(a0)
                move.w  #$200,x_vel(a0)
                move.w  #-$400,y_vel(a0)

locret_74950:
                rts
; ---------------------------------------------------------------------------

loc_74952:
                jsr     (MoveSprite_LightGravity).l
                lea     (Player_1).w,a1
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   loc_7498E
                move.b  #$A,anim_frame_timer(a0)
                addq.b  #1,anim_frame(a0)
                moveq   #signextendB($8C),d0
                btst    #0,anim_frame(a0)
                bne.s   loc_74984
                moveq   #signextendB($8D),d0

loc_74984:
                move.b  d0,mapping_frame(a1)
                jsr     (Player_Load_PLC).l

loc_7498E:
                move.w  (_unkFAB0).w,d0
                addi.w  #$200,d0
                cmp.w   (Player_1+y_pos).w,d0
                bhi.w   locret_74374
                move.w  #$700,d0
                jsr     (StartNewLevel).l
                jmp     (Delete_Current_Sprite).l
