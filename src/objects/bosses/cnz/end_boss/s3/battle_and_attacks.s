; Owner: objects/bosses/cnz/end_boss/s3
; Responsibility: Carnival Night end-boss battle state, attacks and coordinated child actors
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_CNZEndBoss:
                lea     word_4BFEC(pc),a1
                jsr     (Check_CameraInRange).l
                move.l  #loc_4BFF4,(a0)
                move.b  #1,(Boss_flag).w
                moveq   #signextendB(cmd_FadeOut),d0
                jsr     (Play_Music).l
                move.w  #2*60,$2E(a0)
                move.b  #mus_EndBoss,$26(a0)
                move.w  (Camera_target_max_Y_pos).w,(Camera_stored_max_Y_pos).w
                move.w  #$240,(Camera_target_max_Y_pos).w
                move.w  #$4760,$1C(a0)
                move.w  #$47E0,(Camera_max_X_pos).w
                move.l  #loc_4BFFA,$34(a0)
                moveq   #PLCID_6E,d0
                jsr     (Load_PLC).l
                lea     Pal_CNZEndBoss(pc),a1
                jmp     (PalLoad_Line1).l
; ---------------------------------------------------------------------------
word_4BFEC:
                dc.w    0,  $300, $4780, $4900
; ---------------------------------------------------------------------------

loc_4BFF4:
                jmp     (S3EndCamera_TickMusicDelay).l
; ---------------------------------------------------------------------------

loc_4BFFA:
                move.l  #loc_4C002,(a0)

locret_4C000:
                rts
; ---------------------------------------------------------------------------

loc_4C002:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_4C01C(pc,d0.w),d1
                jsr     off_4C01C(pc,d1.w)
                bsr.w   PullBothPlayersWithCNZBossMagnet
                bsr.w   HandleCNZEndBossFourColorHitOrDefeat
                jmp     Draw_And_Touch_Sprite(pc)
; ---------------------------------------------------------------------------
off_4C01C:
                dc.w    loc_4C02C-off_4C01C
                dc.w    loc_4C07A-off_4C01C
                dc.w    loc_4C0A2-off_4C01C
                dc.w    loc_4C0E2-off_4C01C
                dc.w    loc_4C102-off_4C01C
                dc.w    loc_4C154-off_4C01C
                dc.w    loc_4C1A4-off_4C01C
                dc.w    loc_4C1CE-off_4C01C
; ---------------------------------------------------------------------------

loc_4C02C:
                lea     ObjDat_CNZEndBoss(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.b  #8,collision_property(a0)
                move.w  y_pos(a0),$3A(a0)
                move.w  #$7F,$2E(a0)
                move.l  #loc_4C08C,$34(a0)
                move.w  #-$100,x_vel(a0)
                jsr     Swing_Setup1(pc)
                lea     (Child1_MakeRoboShip4).l,a2
                jsr     CreateChild1_Normal(pc)
                bne.s   loc_4C06A
                move.b  #9,subtype(a1)

loc_4C06A:
                lea     ChildObjDat_4C8A2(pc),a2
                jsr     CreateChild1_Normal(pc)
                lea     ChildObjDat_4C8AA(pc),a2
                jmp     CreateChild3_NormalRepeated(pc)
; ---------------------------------------------------------------------------

loc_4C07A:
                jsr     Swing_UpAndDown(pc)
                jsr     (MoveSprite2).l
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_4C088:
                jsr     Swing_Setup1(pc)

loc_4C08C:
                move.b  #4,routine(a0)
                move.w  #3*60,$2E(a0)
                move.l  #loc_4C0D0,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_4C0A2:
                jsr     Find_SonicTails(pc)
                addi.w  #$10,d2
                cmpi.w  #$20,d2
                blo.s   loc_4C0CA
                move.w  #$100,d1
                bset    #0,render_flags(a0)
                tst.w   d0
                bne.s   loc_4C0C6
                neg.w   d1
                bclr    #0,render_flags(a0)

loc_4C0C6:
                move.w  d1,x_vel(a0)

loc_4C0CA:
                jmp     (Swing_MoveWaitNoFall).l
; ---------------------------------------------------------------------------

loc_4C0D0:
                move.b  #6,routine(a0)
                bset    #1,$38(a0)
                clr.w   x_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_4C0E2:
                jsr     Swing_UpAndDown(pc)
                jsr     (MoveSprite2).l
                btst    #1,$38(a0)
                beq.s   loc_4C0F6
                rts
; ---------------------------------------------------------------------------

loc_4C0F6:
                move.b  #8,routine(a0)
                clr.w   x_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_4C102:
                jsr     Swing_UpAndDown(pc)
                jsr     (MoveSprite2).l
                move.w  x_pos(a0),d0
                movea.w $44(a0),a1
                cmp.w   x_pos(a1),d0
                beq.s   loc_4C138
                bhi.s   loc_4C12A
                addq.w  #1,d0
                move.w  d0,x_pos(a0)
                bset    #0,render_flags(a0)
                rts
; ---------------------------------------------------------------------------

loc_4C12A:
                subq.w  #1,d0
                bclr    #0,render_flags(a0)
                move.w  d0,x_pos(a0)
                rts
; ---------------------------------------------------------------------------

loc_4C138:
                move.b  #$A,routine(a0)
                bset    #3,$38(a0)
                move.w  #$BF,$2E(a0)
                move.l  #loc_4C158,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_4C154:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_4C158:
                bset    #2,$38(a0)
                move.w  #$FF,$2E(a0)
                move.l  #loc_4C174,$34(a0)
                lea     ChildObjDat_4C8BA(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

loc_4C174:
                bclr    #2,$38(a0)
                bset    #7,$38(a0)
                move.w  #$FF,$2E(a0)
                move.l  #loc_4C190,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_4C190:
                move.b  #$C,routine(a0)
                bclr    #3,$38(a0)
                bclr    #7,$38(a0)
                rts
; ---------------------------------------------------------------------------

loc_4C1A4:
                move.w  y_pos(a0),d0
                addq.w  #1,d0
                movea.w $44(a0),a1
                move.w  y_pos(a1),d1
                subi.w  #$14,d1
                cmp.w   d1,d0
                bhs.s   loc_4C1C0
                move.w  d0,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

loc_4C1C0:
                move.b  #$E,routine(a0)
                bset    #3,$38(a0)
                rts
; ---------------------------------------------------------------------------

loc_4C1CE:
                move.w  y_pos(a0),d0
                subq.w  #1,d0
                cmp.w   $3A(a0),d0
                bls.s   loc_4C1E0
                move.w  d0,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

loc_4C1E0:
                move.w  $3A(a0),y_pos(a0)
                bra.w   loc_4C088
; ---------------------------------------------------------------------------

loc_4C1EA:
                move.l  #Obj_Wait,(a0)
                bclr    #7,render_flags(a0)
                bset    #4,$38(a0)
                move.w  #$7F,$2E(a0)
                move.l  #loc_4C21A,$34(a0)
                moveq   #signextendB(cmd_FadeOut),d0
                jsr     (Play_Music).l
                lea     ChildObjDat_4C8D6(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

loc_4C21A:
                move.l  #loc_4C240,(a0)
                st      (_unkFAA8).w
                clr.b   (Boss_flag).w
                jsr     (Restore_LevelMusic).l
                move.w  #$48F0,(Camera_stored_max_X_pos).w
                lea     (Child6_IncLevX).l,a2
                jmp     (CreateChild6_Simple).l
; ---------------------------------------------------------------------------

loc_4C240:
                move.w  (Camera_X_pos).w,(Camera_min_X_pos).w
                tst.b   (_unkFAA8).w
                bne.w   locret_4C000
                move.l  #loc_4C28C,(a0)
                clr.b   (_unkFAA8).w
                jsr     (Restore_PlayerControl).l
                lea     (Player_2).w,a1
                jsr     (Restore_PlayerControl2).l
                move.w  #$200,(Camera_stored_min_Y_pos).w
                lea     (Child6_DecLevY).l,a2
                jsr     (CreateChild6_Simple).l
                move.w  #$4A70,(Camera_stored_max_X_pos).w
                lea     (Child6_IncLevX).l,a2
                jmp     (CreateChild6_Simple).l
; ---------------------------------------------------------------------------

loc_4C28C:
                cmpi.w  #$4A30,(Player_1+x_pos).w
                blo.s   locret_4C2C8
                move.l  #loc_4C2CA,(a0)
                lea     (ArtKosM_BadnikExplosion).l,a1
                move.w  #tiles_to_bytes(ArtTile_Explosion),d2
                jsr     (Queue_Kos_Module).l
                jsr     (AllocateObject).l
                bne.s   locret_4C2C8
                move.w  a1,$44(a0)
                move.l  #Obj_CNZCannon,(a1)
                move.w  #$4B20,x_pos(a1)
                move.w  #$2A8,y_pos(a1)

locret_4C2C8:
                rts
; ---------------------------------------------------------------------------

loc_4C2CA:
                move.w  (Camera_X_pos).w,(Camera_min_X_pos).w
                movea.w $44(a0),a1
                cmpi.b  #1,$30(a1)
                bne.w   locret_4C000
                move.l  #loc_4C2F4,(a0)
                move.w  #$200,d0
                move.w  d0,(Camera_target_max_Y_pos).w
                move.w  #$BF,$2E(a0)
                rts
; ---------------------------------------------------------------------------

loc_4C2F4:
                subq.w  #1,$2E(a0)
                bpl.w   locret_4C000
                movea.w $44(a0),a1
                cmpi.b  #$12,angle(a1)
                bne.w   locret_4C000
                move.l  #loc_4C31C,(a0)
                move.w  #((button_A_mask|button_B_mask|button_C_mask)<<8)|(button_A_mask|button_B_mask|button_C_mask),(Ctrl_1_logical).w
                st      (Ctrl_1_locked).w
                rts
; ---------------------------------------------------------------------------

loc_4C31C:
                move.w  (Camera_Y_pos).w,d0
                addi.w  #$20,d0
                cmp.w   (Player_1+y_pos).w,d0
                blo.w   locret_4C000
                move.w  #$500,d0
                jsr     (StartNewLevel).l
                jmp     (Go_Delete_Sprite_2).l
; ---------------------------------------------------------------------------

loc_4C33C:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_4C352(pc,d0.w),d1
                jsr     off_4C352(pc,d1.w)
                bsr.w   BreakCNZBossDroppedCoreWhenParentDefeats
                jmp     Draw_And_Touch_Sprite(pc)
; ---------------------------------------------------------------------------
off_4C352:
                dc.w    loc_4C35E-off_4C352
                dc.w    loc_4C376-off_4C352
                dc.w    loc_4C3AA-off_4C352
                dc.w    loc_4C3EE-off_4C352
                dc.w    loc_4C404-off_4C352
                dc.w    loc_4C424-off_4C352
; ---------------------------------------------------------------------------

loc_4C35E:
                lea     ObjDat3_4C872(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.b  #$10,y_radius(a0)
                move.l  #byte_4C8F3,$30(a0)
                rts
; ---------------------------------------------------------------------------

loc_4C376:
                jsr     Refresh_ChildPositionAdjusted(pc)
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                bne.s   loc_4C388
                rts
; ---------------------------------------------------------------------------

loc_4C388:
                move.b  #4,routine(a0)
                move.l  #loc_4C3BC,$34(a0)
                jsr     Find_SonicTails(pc)
                move.w  #$100,d1
                tst.w   d0
                bne.s   loc_4C3A4
                neg.w   d1

loc_4C3A4:
                move.w  d1,x_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_4C3AA:
                jsr     (MoveSprite).l
                tst.w   y_vel(a0)
                bmi.w   locret_4C000
                jmp     ObjHitFloor_DoRoutine(pc)
; ---------------------------------------------------------------------------

loc_4C3BC:
                moveq   #signextendB(sfx_FloorThump),d0
                jsr     (Play_SFX).l
                move.w  y_vel(a0),d0
                cmpi.w  #$80,d0
                blo.s   loc_4C3D8
                asr.w   #1,d0
                neg.w   d0
                move.w  d0,y_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_4C3D8:
                move.b  #6,routine(a0)
                movea.w parent3(a0),a1
                move.w  a0,$44(a1)
                bclr    #1,$38(a1)
                rts
; ---------------------------------------------------------------------------

loc_4C3EE:
                movea.w parent3(a0),a1
                btst    #3,$38(a1)
                bne.s   loc_4C3FC
                rts
; ---------------------------------------------------------------------------

loc_4C3FC:
                move.b  #8,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_4C404:
                movea.w parent3(a0),a1
                btst    #3,$38(a1)
                beq.s   loc_4C414
                jmp     Animate_RawMultiDelay(pc)
; ---------------------------------------------------------------------------

loc_4C414:
                move.b  #$A,routine(a0)
                move.b  #4,mapping_frame(a0)
                bra.w   loc_4C5BC
; ---------------------------------------------------------------------------

loc_4C424:
                movea.w parent3(a0),a1
                bclr    #3,$38(a1)
                bne.s   loc_4C432
                rts
; ---------------------------------------------------------------------------

loc_4C432:
                move.b  #2,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_4C43A:
                lea     word_4C87E(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #Obj_FlickerMove,(a0)
                tst.b   subtype(a0)
                beq.s   loc_4C454
                bset    #0,render_flags(a0)

loc_4C454:
                moveq   #8,d0
                jmp     (Set_IndexedVelocity).l
; ---------------------------------------------------------------------------

loc_4C45C:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_4C484(pc,d0.w),d1
                jsr     off_4C484(pc,d1.w)
                lea     (CNZEndBossMagnet_AngleX).l,a1
                jsr     MoveSprite_AngleXLookupOffset(pc)
                bsr.w   SetCNZBossMagnetDepthFromPhase
                bsr.w   SelectCNZBossMagnetPhaseFrame
                bsr.w   DetachCNZBossMagnetAfterParentDefeat
                jmp     Draw_And_Touch_Sprite(pc)
; ---------------------------------------------------------------------------
off_4C484:
                dc.w    loc_4C492-off_4C484
                dc.w    loc_4C4AE-off_4C484
                dc.w    loc_4C4DE-off_4C484
                dc.w    loc_4C51C-off_4C484
                dc.w    loc_4C550-off_4C484
                dc.w    loc_4C582-off_4C484
                dc.w    loc_4C5A0-off_4C484
; ---------------------------------------------------------------------------

loc_4C492:
                lea     ObjDat3_4C88A(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.b  subtype(a0),d0
                lsl.b   #5,d0
                move.b  d0,$3C(a0)
                move.l  #byte_4C8E4,$30(a0)
                rts
; ---------------------------------------------------------------------------

loc_4C4AE:
                movea.w parent3(a0),a1
                btst    #3,$38(a1)
                bne.s   loc_4C4BC
                rts
; ---------------------------------------------------------------------------

loc_4C4BC:
                move.b  #4,routine(a0)
                move.b  #1,$40(a0)
                move.w  #$40,$2E(a0)
                move.l  #loc_4C510,$34(a0)
                move.b  $3C(a0),$3A(a0)
                rts
; ---------------------------------------------------------------------------

loc_4C4DE:
                movea.w parent3(a0),a1
                btst    #2,$38(a1)
                bne.s   loc_4C4FA
                move.b  $40(a0),d0
                add.b   d0,$3C(a0)
                jsr     Animate_RawMultiDelay(pc)
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_4C4FA:
                move.b  #6,routine(a0)
                lea     ChildObjDat_4C8B2(pc),a2
                jsr     CreateChild1_Normal(pc)
                move.b  subtype(a0),subtype(a1)
                rts
; ---------------------------------------------------------------------------

loc_4C510:
                addq.b  #1,$40(a0)
                move.w  #$40,$2E(a0)
                rts
; ---------------------------------------------------------------------------

loc_4C51C:
                movea.w parent3(a0),a1
                btst    #2,$38(a1)
                beq.s   loc_4C534
                move.b  $40(a0),d0
                add.b   d0,$3C(a0)
                jmp     Animate_RawMultiDelay(pc)
; ---------------------------------------------------------------------------

loc_4C534:
                move.b  #8,routine(a0)
                bset    #7,$38(a0)
                move.w  #$40,$2E(a0)
                move.l  #loc_4C560,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_4C550:
                move.b  $40(a0),d0
                add.b   d0,$3C(a0)
                jsr     Animate_RawMultiDelay(pc)
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_4C560:
                cmpi.b  #1,$40(a0)
                beq.s   loc_4C574
                subq.b  #1,$40(a0)
                move.w  #$40,$2E(a0)
                rts
; ---------------------------------------------------------------------------

loc_4C574:
                move.b  #$A,routine(a0)
                bclr    #7,$38(a0)
                rts
; ---------------------------------------------------------------------------

loc_4C582:
                jsr     Animate_RawMultiDelay(pc)
                move.b  $3C(a0),d0
                addq.b  #1,d0
                move.b  d0,$3C(a0)
                cmp.b   $3A(a0),d0
                beq.s   loc_4C598
                rts
; ---------------------------------------------------------------------------

loc_4C598:
                move.b  #$C,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_4C5A0:
                movea.w parent3(a0),a1
                btst    #3,$38(a1)
                beq.s   loc_4C5B0
                jmp     Animate_RawMultiDelay(pc)
; ---------------------------------------------------------------------------

loc_4C5B0:
                move.b  #2,routine(a0)
                move.b  #1,mapping_frame(a0)

loc_4C5BC:
                clr.b   anim_frame_timer(a0)
                clr.b   anim_frame(a0)
                rts
; ---------------------------------------------------------------------------

loc_4C5C6:
                lea     ObjDat3_4C896(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                bset    #4,shield_reaction(a0)
                move.l  #byte_4C902,$30(a0)
                move.l  #loc_4C618,$34(a0)
                btst    #1,subtype(a0)
                beq.s   loc_4C5F6
                move.l  #loc_4C5F6,(a0)
                bra.w   CNZBossSpark_TryDelete
; ---------------------------------------------------------------------------

loc_4C5F6:
                move.l  #loc_4C600,(a0)
                bra.w   CNZBossSpark_TryDelete
; ---------------------------------------------------------------------------

loc_4C600:
                moveq   #signextendB(sfx_GravityMachine),d0
                jsr     (Play_SFX_Continuous).l
                jsr     Refresh_ChildPosition(pc)
                jsr     Animate_Raw(pc)
                bsr.w   CNZBossSpark_TryDelete
                jmp     Draw_And_Touch_Sprite(pc)
; ---------------------------------------------------------------------------

loc_4C618:
                move.b  #9,mapping_frame(a0)
                move.b  $39(a0),d0
                addq.b  #1,d0
                move.b  d0,$39(a0)
                andi.b  #3,d0
                andi.b  #$FC,render_flags(a0)
                or.b    d0,render_flags(a0)
                rts
; ---------------------------------------------------------------------------
; unused
                lea     ObjDat3_4C896(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                bset    #4,shield_reaction(a0)
                move.l  #loc_4C618,$34(a0)
                move.b  subtype(a0),d0
                beq.s   loc_4C666
                move.l  #byte_4C911,$30(a0)
                move.l  #loc_4C66E,(a0)
                bra.w   CNZBossSpark_TryDelete
; ---------------------------------------------------------------------------

loc_4C666:
                move.l  #byte_4C908,$30(a0)

loc_4C66E:
                move.l  #loc_4C678,(a0)
                bra.w   CNZBossSpark_TryDelete
; ---------------------------------------------------------------------------

loc_4C678:
                jsr     Refresh_ChildPosition(pc)
                jsr     Animate_RawMultiDelay(pc)
                bsr.w   CNZBossSpark_TryDelete
                jmp     Draw_And_Touch_Sprite(pc)
; ---------------------------------------------------------------------------

loc_4C688:
                lea     word_4C884(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #Obj_FlickerMove,(a0)
                move.b  subtype(a0),d0
                lsr.b   #1,d0
                addi.b  #$B,d0
                move.b  d0,mapping_frame(a0)
                moveq   #0,d0
                jsr     (Set_IndexedVelocity).l
                jmp     (Draw_Sprite).l
; End of function loc_4C688
