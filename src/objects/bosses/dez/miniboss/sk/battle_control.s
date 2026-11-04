; Owner: objects/bosses/dez/miniboss/sk
; Responsibility: Death Egg miniboss controller, flight, attack and coordinated child state progression
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_DEZMiniboss:
                lea     DEZMiniboss_CameraTriggerAndArenaBounds(pc),a1
                jsr     (Check_CameraInRange).l
                move.b  #mus_Miniboss,boss_saved_mus(a0)
                jsr     (Boss_BeginCameraTransition).l
                move.l  #loc_7DE28,(a0)
                move.l  #loc_7DE2C,$34(a0)
                lea     ObjDat_DEZMiniboss(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                clr.b   routine(a0)
                clr.b   collision_property(a0)
                clr.b   $42(a0)
                move.w  #$4000,$3A(a0)
                move.w  #$8000,$3C(a0)
                lea     ChildObjDat_7EF8E(pc),a2
                jsr     CreateChild1_Normal(pc)
                lea     ChildObjDat_7EF96(pc),a2
                jsr     CreateChild6_Simple(pc)
                moveq   #PLCID_7B,d0
                jsr     (Load_PLC).l
                lea     (ArtKosM_DEZMinibossMisc).l,a1
                move.w  #tiles_to_bytes(ArtTile_DEZMiniboss),d2
                jsr     (Queue_Kos_Module).l
                lea     Pal_DEZMiniboss1(pc),a1
                jmp     PalLoad_Line1(pc)
; ---------------------------------------------------------------------------

loc_7DE28:
                jmp     SKEndCamera_TickAndSaveMusic(pc)
; ---------------------------------------------------------------------------

loc_7DE2C:
                move.l  #loc_7DE46,(a0)
                addi.w  #$E0,(_unkFAB2).w
                addi.w  #$40,(_unkFAB4).w
                addi.w  #$100,(_unkFAB6).w

locret_7DE44:
                rts
; ---------------------------------------------------------------------------

loc_7DE46:
                addq.b  #4,$3C(a0)
                bpl.s   loc_7DE4E
                rts
; ---------------------------------------------------------------------------

loc_7DE4E:
                move.l  #loc_7DE6E,(a0)

loc_7DE54:
                move.b  #0,routine(a0)
                clr.w   $3C(a0)
                move.w  #$7F,$2E(a0)
                move.l  #loc_7DEA6,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_7DE6E:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_7DE92(pc,d0.w),d1
                jsr     off_7DE92(pc,d1.w)
                move.b  (V_int_run_count+3).w,d0
                andi.b  #$1F,d0
                bne.s   loc_7DE8E
                moveq   #signextendB(sfx_GravityTunnel),d0
                jsr     (Play_SFX).l

loc_7DE8E:
                bra.w   loc_7EE36
; ---------------------------------------------------------------------------
off_7DE92:
                dc.w    loc_7DEA2-off_7DE92
                dc.w    loc_7DEC6-off_7DE92
                dc.w    loc_7DEA2-off_7DE92
                dc.w    loc_7DF14-off_7DE92
                dc.w    loc_7DEA2-off_7DE92
                dc.w    loc_7DF40-off_7DE92
                dc.w    loc_7DEA2-off_7DE92
                dc.w    loc_7DF84-off_7DE92
; ---------------------------------------------------------------------------

loc_7DEA2:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_7DEA6:
                move.b  #2,routine(a0)
                move.w  #$F,$2E(a0)
                move.l  #loc_7DEF6,$34(a0)
                move.b  #2,$39(a0)
                clr.w   $40(a0)
                rts
; ---------------------------------------------------------------------------

loc_7DEC6:
                move.w  $40(a0),d0
                move.w  $3C(a0),d1
                addi.w  #$20,d0
                add.w   d0,d1
                cmpi.w  #$7000,d1
                blo.s   loc_7DEEC
                move.w  #$7000,d1
                lsr.w   #1,d0
                neg.w   d0
                subq.b  #1,$39(a0)
                bpl.s   loc_7DEEC
                bsr.w   loc_7DEF6

loc_7DEEC:
                move.w  d0,$40(a0)
                move.w  d1,$3C(a0)
                rts
; ---------------------------------------------------------------------------

loc_7DEF6:
                move.b  #4,routine(a0)
                move.w  #$9F,$2E(a0)
                move.l  #loc_7DF0C,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_7DF0C:
                move.b  #6,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_7DF14:
                move.b  $3A(a0),d0
                addq.b  #2,d0
                bmi.s   loc_7DF22
                move.b  d0,$3A(a0)
                rts
; ---------------------------------------------------------------------------

loc_7DF22:
                move.b  #8,routine(a0)
                move.w  #$1F,$2E(a0)
                move.l  #loc_7DF38,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_7DF38:
                move.b  #$A,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_7DF40:
                move.b  $3A(a0),d0
                subq.b  #4,d0
                cmpi.b  #$40,d0
                bls.s   loc_7DF52
                move.b  d0,$3A(a0)
                rts
; ---------------------------------------------------------------------------

loc_7DF52:
                move.b  #$40,$3A(a0)
                move.b  #$C,routine(a0)
                move.w  #$9F,$2E(a0)
                move.l  #loc_7DF6E,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_7DF6E:
                move.b  #$E,routine(a0)
                move.w  #$1B,$2E(a0)
                move.l  #loc_7DE54,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_7DF84:
                subq.b  #4,$3C(a0)
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_7DF8C:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_7DF9A(pc,d0.w),d1
                jmp     off_7DF9A(pc,d1.w)
; ---------------------------------------------------------------------------
off_7DF9A:
                dc.w    loc_7DFA2-off_7DF9A
                dc.w    loc_7E00C-off_7DF9A
                dc.w    loc_7E006-off_7DF9A
                dc.w    loc_7E00C-off_7DF9A
; ---------------------------------------------------------------------------

loc_7DFA2:
                move.b  (V_int_run_count+3).w,d0
                andi.b  #7,d0
                bne.s   loc_7DFB4
                lea     ChildObjDat_7EFA2(pc),a2
                jsr     CreateChild6_Simple(pc)

loc_7DFB4:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_7DFB8:
                move.b  #2,routine(a0)
                move.w  #$5F,$2E(a0)
                move.l  #loc_7DFDE,$34(a0)
                st      (Events_fg_4).w
                lea     ChildObjDat_7EFA8(pc),a2
                jsr     CreateChild1_Normal(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_7DFDE:
                move.b  #4,routine(a0)
                bset    #5,$38(a0)
                move.w  #-$80,x_vel(a0)
                move.w  #$40,y_vel(a0)
                move.w  #$1F,$2E(a0)
                move.l  #loc_7E016,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_7E006:
                jsr     (MoveSprite2).l

loc_7E00C:
                jsr     Obj_Wait(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_7E016:
                move.b  #6,routine(a0)
                move.w  #$1F,$2E(a0)
                move.l  #loc_7E044,$34(a0)
                move.w  #0,$3A(a0)
                move.w  #$200,$3C(a0)
                move.w  #$100,$26(a0)
                lea     ChildObjDat_7EFB6(pc),a2
                jmp     CreateChild8_TreeListRepeated(pc)
; ---------------------------------------------------------------------------

loc_7E044:
                move.l  #loc_7E0A6,(a0)
                clr.b   routine(a0)
                bclr    #6,status(a0)
                clr.b   collision_property(a0)
                clr.b   $42(a0)
                move.w  y_pos(a0),$30(a0)
                bclr    #5,$38(a0)
                jsr     (AllocateObject).l
                bne.s   ResetDEZMinibossVerticalSwing
                move.w  a0,parent3(a1)
                move.l  #Obj_SpriteMask,(a1)
                move.w  #$3740,x_pos(a1)
                move.w  #$360,y_pos(a1)
                move.b  #$89,subtype(a1)

; =============== S U B R O U T I N E =======================================

ResetDEZMinibossVerticalSwing:
                move.w  #$80,d0
                move.w  d0,$3E(a0)
                move.w  d0,y_vel(a0)
                move.w  #8,$40(a0)
                bclr    #0,$38(a0)
                rts
; End of function ResetDEZMinibossVerticalSwing

; ---------------------------------------------------------------------------

loc_7E0A6:
                move.b  (V_int_run_count+3).w,d0
                andi.b  #$3F,d0
                bne.s   loc_7E0B8
                moveq   #signextendB(sfx_WaveHover),d0
                jsr     (Play_SFX).l

loc_7E0B8:
                bsr.w   DEZMiniForm2_ReactToHitOrDefeat
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_7E0CA(pc,d0.w),d1
                jmp     off_7E0CA(pc,d1.w)
; ---------------------------------------------------------------------------
off_7E0CA:
                dc.w    loc_7E0D6-off_7E0CA
                dc.w    loc_7E108-off_7E0CA
                dc.w    loc_7E13C-off_7E0CA
                dc.w    loc_7E186-off_7E0CA
                dc.w    loc_7E1AC-off_7E0CA
                dc.w    loc_7E1FC-off_7E0CA
; ---------------------------------------------------------------------------

loc_7E0D6:
                jsr     Swing_UpAndDown(pc)
                jsr     (MoveSprite2).l
                bsr.w   DEZMini_ReversePastArenaXBounds
                bsr.w   DEZMini_RetargetPlatformSpin
                btst    #1,$38(a0)
                beq.s   loc_7E0F4
                bsr.w   DEZMini_BeginPlatformExpansion

loc_7E0F4:
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

DEZMini_BeginPlatformExpansion:
                move.b  #2,routine(a0)
                bset    #7,$38(a0)
                rts
; End of function DEZMini_BeginPlatformExpansion

; ---------------------------------------------------------------------------

loc_7E108:
                jsr     Run_PalRotationScript(pc)
                jsr     Swing_UpAndDown(pc)
                jsr     (MoveSprite2).l
                bsr.w   DEZMini_SetPursuitVelWithinBounds
                bsr.w   DEZMini_RetargetPlatformSpin
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_7E124:
                move.b  #4,routine(a0)
                clr.w   x_vel(a0)
                bclr    #1,$38(a0)
                bset    #3,$38(a0)
                rts
; ---------------------------------------------------------------------------

loc_7E13C:
                jsr     Swing_UpAndDown(pc)
                jsr     (MoveSprite2).l
                btst    #1,$38(a0)
                bne.s   loc_7E15C
                btst    #3,$38(a0)
                beq.s   loc_7E16A
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_7E15C:
                bsr.s   DEZMini_BeginPlatformExpansion
                bclr    #3,$38(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_7E16A:
                move.b  #6,routine(a0)
                clr.w   x_vel(a0)
                move.w  #-$400,y_vel(a0)
                bset    #2,$38(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_7E186:
                btst    #1,$38(a0)
                bne.s   loc_7E1A0
                addi.w  #$20,y_vel(a0)
                jsr     (MoveSprite2).l
                tst.w   y_vel(a0)
                bmi.s   loc_7E1A6

loc_7E1A0:
                move.b  #8,routine(a0)

loc_7E1A6:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_7E1AC:
                btst    #2,$38(a0)
                bne.s   loc_7E1DE
                move.b  #$A,routine(a0)
                move.w  #$100,y_vel(a0)
                clr.w   $3A(a0)
                btst    #1,$38(a0)
                bne.s   loc_7E1E4
                bset    #6,$38(a0)
                move.w  #$100,$26(a0)
                move.w  #$100,$3C(a0)

loc_7E1DE:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_7E1E4:
                bset    #7,$38(a0)
                move.w  #$800,$26(a0)
                move.w  #$800,$3C(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_7E1FC:
                jsr     (MoveSprite2).l
                move.w  $30(a0),d0
                cmp.w   y_pos(a0),d0
                bhi.s   loc_7E236
                move.w  d0,y_pos(a0)
                move.b  #0,routine(a0)
                bclr    #6,$38(a0)
                lea     (Player_1).w,a1
                jsr     Find_OtherObject(pc)
                move.w  #-$80,d1
                tst.w   d0
                beq.s   loc_7E22E
                neg.w   d1

loc_7E22E:
                move.w  d1,x_vel(a0)
                bsr.w   ResetDEZMinibossVerticalSwing

loc_7E236:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_7E23C:
                jsr     (AllocateObject).l
                bne.s   loc_7E24A
                move.l  #loc_7E25C,(a1)

loc_7E24A:
                bset    #5,$38(a0)
                lea     ChildObjDat_7EFD2(pc),a2
                jsr     CreateChild1_Normal(pc)
                jmp     Obj_EndSignControl(pc)
; ---------------------------------------------------------------------------

loc_7E25C:
                tst.b   (_unkFAA8).w
                beq.w   locret_7DE44
                move.l  #loc_7E26A,(a0)

loc_7E26A:
                tst.b   (_unkFAA8).w
                bne.w   locret_7DE44
                move.l  #loc_7E298,(a0)
                st      (Ctrl_1_locked).w
                jsr     (AllocateObject).l
                bne.s   loc_7E28A
                move.l  #SKInput_LockP2IfActive,(a1)

loc_7E28A:
                cmpi.w  #$140,(Player_1+x_pos).w
                blo.s   loc_7E298
                bset    #3,$38(a0)

loc_7E298:
                lea     (Player_1).w,a1
                move.w  #$140,d0
                tst.w   x_vel(a0)
                btst    #3,$38(a0)
                bne.s   loc_7E2CA
                cmp.w   x_pos(a1),d0
                bls.s   loc_7E2E8
                moveq   #0,d1
                btst    #Status_Push,status(a1)
                beq.s   loc_7E2C0
                ori.w   #(button_A_mask<<8)|button_A_mask,d1

loc_7E2C0:
                ori.w   #(button_right_mask<<8)|button_right_mask,d1
                move.w  d1,(Ctrl_1_logical).w
                rts
; ---------------------------------------------------------------------------

loc_7E2CA:
                cmp.w   x_pos(a1),d0
                bhs.s   loc_7E2E8
                moveq   #0,d1
                btst    #Status_Push,status(a1)
                beq.s   loc_7E2DE
                ori.w   #(button_A_mask<<8)|button_A_mask,d1

loc_7E2DE:
                ori.w   #(button_left_mask<<8)|button_left_mask,d1
                move.w  d1,(Ctrl_1_logical).w
                rts
; ---------------------------------------------------------------------------

loc_7E2E8:
                move.w  d0,x_pos(a1)
                move.l  #loc_7E342,(a0)
                jsr     Stop_Object(pc)
                clr.w   (Ctrl_1_logical).w
                move.w  #$1F,$2E(a0)
                jsr     (AllocateObject).l
                bne.s   loc_7E320
                move.l  #Obj_CreateBossExplosion,(a1)
                move.w  #$100,x_pos(a1)
                move.w  #$760,y_pos(a1)
                move.b  #$14,subtype(a1)

loc_7E320:
                jsr     (AllocateObject).l
                bne.s   locret_7E340
                move.l  #Obj_CreateBossExplosion,(a1)
                move.w  #$180,x_pos(a1)
                move.w  #$760,y_pos(a1)
                move.b  #$14,subtype(a1)

locret_7E340:
                rts
; ---------------------------------------------------------------------------

loc_7E342:
                subq.w  #1,$2E(a0)
                bpl.s   locret_7E382
                move.l  #loc_7E384,(a0)
                st      (Events_fg_4).w
                move.w  #0,(Camera_stored_min_Y_pos).w
                jsr     (AllocateObject).l
                bne.s   loc_7E366
                move.l  #Obj_DecLevStartYGradual,(a1)

loc_7E366:
                move.w  #$2000,(Camera_stored_max_Y_pos).w
                jsr     (AllocateObject).l
                bne.s   loc_7E37A
                move.l  #Obj_IncLevEndYGradual,(a1)

loc_7E37A:
                moveq   #signextendB(sfx_BigRumble),d0
                jsr     (Play_SFX).l

locret_7E382:
                rts
; ---------------------------------------------------------------------------

loc_7E384:
                lea     (Player_1).w,a1
                cmpi.w  #$360,y_pos(a1)
                blo.s   locret_7E3C8
                btst    #1,status(a1)
                bne.s   locret_7E3C8
                move.l  #loc_7E3CA,(a0)
                move.b  #$83,object_control(a1)
                move.b  #0,anim(a1)
                jsr     (Stop_Object).l
                bclr    #Status_Push,status(a1)
                bset    #Status_InAir,status(a1)
                bclr    #Status_Facing,status(a1)
                bclr    #0,render_flags(a1)

locret_7E3C8:
                rts
; ---------------------------------------------------------------------------

loc_7E3CA:
                addq.w  #8,$1C(a0)
                cmpi.w  #$300,$1C(a0)
                bne.s   loc_7E3E8
                move.l  #loc_7E3EC,(a0)
                move.w  #$24,$2E(a0)
                bclr    #7,(Player_1+art_tile).w

loc_7E3E8:
                bra.w   DEZPostBoss_AdvancePlayerSpin
; ---------------------------------------------------------------------------

loc_7E3EC:
                subq.w  #1,$2E(a0)
                bpl.s   loc_7E416
                move.l  #loc_7E420,(a0)
                move.w  #-$1000,y_vel(a0)
                lea     (Player_1).w,a1
                move.w  x_pos(a1),x_pos(a0)
                move.w  y_pos(a1),y_pos(a0)
                moveq   #signextendB(sfx_SuperTransform),d0
                jsr     (Play_SFX).l

loc_7E416:
                subi.w  #$10,(Player_1+y_pos).w
                bra.w   DEZPostBoss_AdvancePlayerSpin
; ---------------------------------------------------------------------------

loc_7E420:
                bsr.w   DEZPostBoss_AdvancePlayerSpin
                tst.w   y_vel(a0)
                bmi.s   loc_7E44C
                move.l  #loc_7E44C,(a0)
                jsr     (Ending_SetP1PoseAndLoadArt).l
                lea     (Player_1).w,a1
                bclr    #0,render_flags(a1)
                bclr    #Status_Facing,status(a1)
                move.w  #5<<8,anim(a1)                  ; and prev_anim

loc_7E44C:
                jsr     (MoveSprite).l
                tst.w   y_vel(a0)
                bmi.s   loc_7E490
                move.w  #$3AC,d0
                cmpi.w  #2,(Player_mode).w
                bne.s   loc_7E468
                move.w  #$3B0,d0

loc_7E468:
                cmp.w   y_pos(a0),d0
                bhi.s   loc_7E490
                move.w  d0,y_pos(a0)
                move.l  #loc_7E4A2,(a0)
                move.w  #(2*60)-1,$2E(a0)
                jsr     (AllocateObject).l
                bne.s   loc_7E490
                move.l  #Obj_TitleCard,(a1)
                st      $3E(a1)

loc_7E490:
                lea     (Player_1).w,a1
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                rts
; ---------------------------------------------------------------------------

loc_7E4A2:
                subq.w  #1,$2E(a0)
                bpl.w   locret_7DE44
                lea     (Pal_DEZMiniboss2).l,a1
                lea     (Normal_palette_line_2).w,a2
                moveq   #bytesToLcnt($20),d6

loc_7E4B6:
                move.l  (a1)+,(a2)+
                dbf     d6,loc_7E4B6
                clr.b   (Player_1+object_control).w
                clr.b   (Ctrl_1_locked).w
                clr.b   (Ctrl_2_locked).w
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_7E4CE:
                lea     word_7EF70(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                addi.w  #$C,y_pos(a0)
                move.b  #0,child_dx(a0)
                move.b  #$C,child_dy(a0)
                move.w  #-$200,d0
                moveq   #-$40,d1
                tst.b   subtype(a0)
                beq.s   loc_7E4F8
                neg.w   d0
                moveq   #$40,d1

loc_7E4F8:
                move.w  d0,x_vel(a0)
                move.b  d1,$3C(a0)
                move.w  #$1F,$2E(a0)
                move.l  #loc_7E52A,$34(a0)
                move.l  #loc_7E51C,(a0)
                lea     ChildObjDat_7EFBC(pc),a2
                jsr     CreateChild1_Normal(pc)

loc_7E51C:
                jsr     (MoveSprite2).l
                jsr     Obj_Wait(pc)
                bra.w   loc_7EC46
; ---------------------------------------------------------------------------

loc_7E52A:
                move.l  #loc_7E566,(a0)
                tst.b   subtype(a0)
                beq.s   locret_7E54A
                move.l  #loc_7E54C,(a0)
                movea.w parent3(a0),a1
                move.w  a0,$44(a1)
                move.w  $44(a0),parent3(a0)

locret_7E54A:
                rts
; ---------------------------------------------------------------------------

loc_7E54C:
                movea.w parent3(a0),a1
                btst    #7,$38(a1)
                bne.s   loc_7E582
                bclr    #3,$38(a0)
                bne.w   loc_7E63E
                bra.w   loc_7EBF2
; ---------------------------------------------------------------------------

loc_7E566:
                movea.w parent3(a0),a1
                btst    #7,$38(a1)
                bne.s   loc_7E582
                btst    #3,$38(a1)
                bne.s   loc_7E590

loc_7E57A:
                bsr.w   DEZMiniPlatform_AccelAndStepAngle
                bra.w   loc_7EBF2
; ---------------------------------------------------------------------------

loc_7E582:
                move.l  #loc_7E6E8,(a0)
                move.w  #$4000,$3A(a0)
                bra.s   loc_7E57A
; ---------------------------------------------------------------------------

loc_7E590:
                move.l  #loc_7E598,(a0)
                bra.s   loc_7E57A
; ---------------------------------------------------------------------------

loc_7E598:
                movea.w parent3(a0),a1
                btst    #7,$38(a1)
                bne.s   loc_7E582
                bsr.w   DEZMiniPlatform_AccelAndStepAngle
                movea.w parent3(a0),a1
                move.b  $3C(a0),d0
                tst.w   $3C(a1)
                bmi.s   loc_7E5C4
                subi.b  #$40,d0
                cmpi.b  #$10,d0
                bls.s   loc_7E5CE
                bra.w   loc_7E5D4
; ---------------------------------------------------------------------------

loc_7E5C4:
                subi.b  #$30,d0
                cmpi.b  #$10,d0
                bhi.s   loc_7E5D4

loc_7E5CE:
                move.l  #loc_7E5D8,(a0)

loc_7E5D4:
                bra.w   loc_7EBF2
; ---------------------------------------------------------------------------

loc_7E5D8:
                movea.w parent3(a0),a1
                move.w  $3C(a0),d0
                btst    #7,$38(a1)
                bne.s   loc_7E582
                move.w  $3A(a1),d1
                move.w  $3C(a1),d2
                bmi.s   loc_7E606
                subi.w  #$100,d1
                add.w   d1,d0
                tst.w   d1
                bpl.s   loc_7E616
                cmpi.w  #$4000,d0
                blo.s   loc_7E622
                bra.w   loc_7E616
; ---------------------------------------------------------------------------

loc_7E606:
                addi.w  #$100,d1
                add.w   d1,d0
                tst.w   d1
                bmi.s   loc_7E616
                cmpi.w  #$4000,d0
                bhi.s   loc_7E622

loc_7E616:
                move.w  d0,$3C(a0)
                move.w  d1,$3A(a1)
                bra.w   loc_7EBF2
; ---------------------------------------------------------------------------

loc_7E622:
                move.w  #$4000,d0
                move.w  d0,$3C(a0)
                move.w  d1,$3A(a1)
                bclr    #3,$38(a1)
                movea.w $44(a0),a2
                bset    #3,$38(a2)

loc_7E63E:
                move.l  #loc_7E64C,(a0)
                clr.w   x_vel(a0)
                bra.w   loc_7EBF2
; ---------------------------------------------------------------------------

loc_7E64C:
                movea.w parent3(a0),a1
                btst    #2,$38(a1)
                beq.s   loc_7E664
                move.l  #loc_7E668,(a0)
                move.w  #7,$2E(a0)

loc_7E664:
                bra.w   loc_7EC46
; ---------------------------------------------------------------------------

loc_7E668:
                subq.w  #1,$2E(a0)
                bpl.s   loc_7E67A
                move.l  #loc_7E67E,(a0)
                move.w  #-$400,y_vel(a0)

loc_7E67A:
                bra.w   loc_7EC46
; ---------------------------------------------------------------------------

loc_7E67E:
                addi.w  #$20,y_vel(a0)
                jsr     (MoveSprite2).l
                movea.w parent3(a0),a1
                move.w  y_pos(a1),d0
                addi.w  #$C,d0
                tst.w   y_vel(a0)
                bpl.s   loc_7E6A2
                cmp.w   y_pos(a0),d0
                blo.s   loc_7E6B2

loc_7E6A2:
                move.w  d0,y_pos(a0)
                move.l  #loc_7E6B6,(a0)
                bclr    #2,$38(a1)

loc_7E6B2:
                bra.w   loc_7EC46
; ---------------------------------------------------------------------------

loc_7E6B6:
                movea.w parent3(a0),a1
                btst    #7,$38(a1)
                bne.w   loc_7E582
                btst    #6,$38(a1)
                beq.s   loc_7E6D0
                bsr.w   DEZMiniPlatform_RestoreIdleBySide

loc_7E6D0:
                bra.w   loc_7EBF2
