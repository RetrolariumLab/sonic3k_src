; Owner: objects/bosses/dez/end_boss/sk
; Responsibility: Death Egg end-boss controller, player interaction and coordinated attack state progression
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_DEZEndBoss:
                lea     word_7F0BE(pc),a1
                jsr     (Check_CameraInRange).l
                move.l  #loc_7F0CE,(a0)
                move.l  #loc_7F0D2,$34(a0)
                lea     word_7F0C6(pc),a1
                move.b  #mus_EndBoss,boss_saved_mus(a0)
                jsr     BeginBossCameraTransitionSaveBoundsAndFadeMusic(pc)
                clr.b   (_unkFAB8).w
                moveq   #PLCID_76,d0
                jsr     (Load_PLC).l
                lea     (ArtKosM_DEZEndBoss).l,a1
                move.w  #tiles_to_bytes(ArtTile_DEZEndBoss),d2
                jsr     (Queue_Kos_Module).l
                lea     Pal_DEZEndBoss(pc),a1
                jsr     PalLoad_Line1(pc)
                lea     ChildObjDat_7FC8C(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------
word_7F0BE:
                dc.w    $198,  $498, $33E0, $3480
word_7F0C6:
                dc.w    $218,  $288, $3400, $34E0
; ---------------------------------------------------------------------------

loc_7F0CE:
                jmp     loc_85CA4(pc)
; ---------------------------------------------------------------------------

loc_7F0D2:
                move.l  #loc_7F0DA,(a0)

locret_7F0D8:
                rts
; ---------------------------------------------------------------------------

loc_7F0DA:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_7F102(pc,d0.w),d1
                jsr     off_7F102(pc,d1.w)
                bsr.w   ConsumeDEZEndBossReturnedCapsuleHitLatch
                move.b  (V_int_run_count+3).w,d0
                andi.b  #$3F,d0
                bne.s   loc_7F0FE
                moveq   #signextendB(sfx_WaveHover),d0
                jsr     (Play_SFX).l

loc_7F0FE:
                jmp     Draw_And_Touch_Sprite(pc)
; ---------------------------------------------------------------------------
off_7F102:
                dc.w    loc_7F10E-off_7F102
                dc.w    loc_7F150-off_7F102
                dc.w    loc_7F182-off_7F102
                dc.w    loc_7F1CC-off_7F102
                dc.w    loc_7F182-off_7F102
                dc.w    loc_7F1CC-off_7F102
; ---------------------------------------------------------------------------

loc_7F10E:
                lea     ObjDat_DEZEndBoss(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.b  #8,collision_property(a0)
                move.w  #$100,y_vel(a0)
                move.w  #$BF,$2E(a0)
                move.l  #loc_7F15A,$34(a0)
                lea     ChildObjDat_7FC9A(pc),a2
                jsr     CreateChild6_Simple(pc)
                tst.l   (Player_2).w
                beq.s   locret_7F14E
                lea     ChildObjDat_7FC9A(pc),a2
                jsr     CreateChild6_Simple(pc)
                bne.s   locret_7F14E
                move.b  #2,subtype(a1)

locret_7F14E:
                rts
; ---------------------------------------------------------------------------

loc_7F150:
                jsr     (MoveSprite2).l
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_7F15A:
                jsr     (Swing_Setup1).l
                move.w  #$100,x_vel(a0)

loc_7F166:
                move.b  #4,routine(a0)
                andi.b  #$F3,$38(a0)
                move.w  #$B3,$2E(a0)
                move.l  #loc_7F194,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_7F182:
                jsr     Swing_UpAndDown(pc)
                jsr     (MoveSprite2).l
                bsr.w   ReverseDEZEndBossAtInclusiveWorldXBounds
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_7F194:
                cmpi.b  #3,$39(a0)
                bhs.s   loc_7F1C4
                move.b  #6,routine(a0)
                addq.b  #1,$39(a0)
                bset    #3,$38(a0)
                move.l  #loc_7F1DE,$34(a0)
                lea     byte_7FCD4(pc),a1
                jsr     Set_Raw_Animation(pc)
                lea     ChildObjDat_7FCA0(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

loc_7F1C4:
                move.w  #$F,$2E(a0)
                rts
; ---------------------------------------------------------------------------

loc_7F1CC:
                jsr     Swing_UpAndDown(pc)
                jsr     (MoveSprite2).l
                bsr.w   ReverseDEZEndBossAtInclusiveWorldXBounds
                jmp     Animate_Raw(pc)
; ---------------------------------------------------------------------------

loc_7F1DE:
                move.b  #8,routine(a0)
                bset    #2,$38(a0)
                move.w  #$3F,$2E(a0)
                move.l  #loc_7F1FA,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_7F1FA:
                move.b  #$A,routine(a0)
                move.l  #loc_7F166,$34(a0)
                lea     byte_7FCD9(pc),a1
                jmp     Set_Raw_Animation(pc)
; ---------------------------------------------------------------------------

loc_7F210:
                move.l  #loc_7F220,(a0)
                clr.w   x_vel(a0)
                clr.w   y_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_7F220:
                jsr     (MoveSprite_LightGravity).l
                cmpi.w  #$318,y_pos(a0)
                bhs.s   loc_7F234
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_7F234:
                move.l  #loc_7F266,(a0)
                bclr    #7,render_flags(a0)
                lea     ChildObjDat_7FCCE(pc),a2
                jsr     CreateChild6_Simple(pc)
                lea     ChildObjDat_7FCC8(pc),a2
                jsr     CreateChild6_Simple(pc)
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild6_Simple).l
                moveq   #signextendB(cmd_FadeOut),d0
                jsr     (Play_Music).l
                rts
; ---------------------------------------------------------------------------

loc_7F266:
                btst    #1,(_unkFAB8).w
                beq.s   locret_7F298
                move.l  #loc_7F29A,(a0)
                bset    #4,$38(a0)
                move.w  #$3F,$2E(a0)
                move.w  #$35D0,x_pos(a0)
                move.w  #$328,y_pos(a0)
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild6_Simple).l

locret_7F298:
                rts
; ---------------------------------------------------------------------------

loc_7F29A:
                move.w  $2E(a0),d0
                subq.w  #1,d0
                move.w  d0,$2E(a0)
                beq.s   loc_7F2B4
                cmpi.w  #$30,$2E(a0)
                bne.s   locret_7F2DA
                st      (Events_fg_4).w
                rts
; ---------------------------------------------------------------------------

loc_7F2B4:
                move.l  #loc_7F2DC,(a0)
                clr.b   (Boss_flag).w
                moveq   #signextendB(mus_DEZ2),d0
                jsr     (Play_Music).l
                move.w  #$3620,(Camera_stored_max_X_pos).w
                jsr     (AllocateObject).l
                bne.s   locret_7F2DA
                move.l  #Obj_IncLevEndXGradual,(a1)

locret_7F2DA:
                rts
; ---------------------------------------------------------------------------

loc_7F2DC:
                move.w  (Camera_X_pos).w,(Camera_min_X_pos).w
                cmpi.w  #$3620,(Camera_X_pos).w
                blo.s   locret_7F2FC
                move.l  #loc_7F2FE,(a0)
                move.b  #1,(Scroll_lock).w
                addi.w  #$40,(Camera_max_X_pos).w

locret_7F2FC:
                rts
; ---------------------------------------------------------------------------

loc_7F2FE:
                move.w  (Camera_X_pos).w,d0
                addi.w  #$160,d0
                cmp.w   (Player_1+x_pos).w,d0
                bls.w   loc_7F310
                rts
; ---------------------------------------------------------------------------

loc_7F310:
                st      (Act3_flag).w
                move.w  (Ring_count).w,(Act3_ring_count).w
                move.l  (Timer).w,(Act3_timer).w
                move.b  (Player_1+status_secondary).w,(Saved2_status_secondary).w
                move.w  #$1700,d0
                jsr     (StartNewLevel).l
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_7F336:
                lea     word_7FC50(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #loc_7F344,(a0)

loc_7F344:
                lea     (Player_1).w,a2
                tst.b   subtype(a0)
                beq.s   loc_7F352
                lea     (Player_2).w,a2

loc_7F352:
                movea.w parent3(a0),a1
                jsr     GetApproximateObjectBearing(pc)
                movea.w parent3(a0),a1
                btst    #3,$38(a1)
                beq.s   loc_7F37C
                move.b  d0,d1
                smi     d2
                addi.b  #$30,d1
                cmpi.b  #$60,d1
                bhs.s   loc_7F37C
                moveq   #$30,d0
                tst.b   d2
                beq.s   loc_7F37C
                moveq   #-$30,d0

loc_7F37C:
                move.b  d0,$3C(a0)
                lea     (byte_7FD28).l,a2
                jsr     MoveSprite_AtAngleLookup(pc)
                bsr.w   LaunchPlayerFromDEZBossBumperContact
                bsr.w   SelectDEZBossBumperFrameAndFlipFromAngle
                moveq   #8,d0
                jmp     Child_DrawTouch_Sprite_FlickerMove(pc)
; ---------------------------------------------------------------------------

loc_7F398:
                lea     word_7FC62(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #loc_7F3B0,(a0)
                move.b  #$B,y_radius(a0)
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------

loc_7F3B0:
                movea.w parent3(a0),a1
                btst    #2,$38(a1)
                bne.s   loc_7F3C4
                jsr     Refresh_ChildPosition(pc)
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------

loc_7F3C4:
                move.l  #loc_7F3D0,(a0)
                move.w  #$10,$2E(a0)

loc_7F3D0:
                subq.w  #1,$2E(a0)
                bmi.s   loc_7F3EA
                bchg    #2,$38(a0)
                bne.s   loc_7F3E2
                addq.b  #1,child_dy(a0)

loc_7F3E2:
                jsr     Refresh_ChildPosition(pc)
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------

loc_7F3EA:
                move.l  #loc_7F3F6,(a0)
                move.w  #7,$2E(a0)

loc_7F3F6:
                subq.w  #1,$2E(a0)
                bpl.s   loc_7F40A
                move.l  #loc_7F414,(a0)
                moveq   #signextendB(sfx_MushroomBounce),d0
                jsr     (Play_SFX).l

loc_7F40A:
                movea.w parent3(a0),a1
                move.w  x_pos(a1),x_pos(a0)

loc_7F414:
                bsr.w   DEZCapsule_MoveWithGravity
                tst.w   y_vel(a0)
                bpl.s   loc_7F430
                jsr     (ObjCheckCeilingDist).l
                tst.w   d1
                bpl.s   loc_7F43E
                bsr.w   LandDEZBossCapsuleAgainstCeiling
                bra.w   loc_7F43E
; ---------------------------------------------------------------------------

loc_7F430:
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.s   loc_7F43E
                bsr.w   LandDEZBossCapsuleAgainstFloor

loc_7F43E:
                movea.w parent3(a0),a1
                btst    #7,status(a0)
                bne.s   DEZCapsule_ExplodeThenDelete
                btst    #0,(V_int_run_count+3).w
                bne.w   locret_7F0D8
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

LandDEZBossCapsuleAgainstCeiling:
                sub.w   d1,y_pos(a0)
                move.b  #0,routine(a0)
                move.b  #$C6,collision_flags(a0)
                st      $3A(a0)
                bra.w   loc_7F486
; End of function LandDEZBossCapsuleAgainstCeiling

; =============== S U B R O U T I N E =======================================

LandDEZBossCapsuleAgainstFloor:
                add.w   d1,y_pos(a0)
                move.b  #2,routine(a0)
                move.b  #$C6,collision_flags(a0)
                clr.b   $3A(a0)

loc_7F486:
                move.l  #loc_7F4FA,(a0)
                move.w  #(10*60)-1,$2E(a0)
                jsr     (Random_Number).l
                move.w  #$80,d1
                tst.b   d0
                bpl.s   loc_7F4A2
                neg.w   d1

loc_7F4A2:
                move.w  d1,x_vel(a0)
                clr.w   y_vel(a0)
                rts
; End of function LandDEZBossCapsuleAgainstFloor

; =============== S U B R O U T I N E =======================================

DEZCapsule_ExplodeThenDelete:
                move.l  #Go_Delete_Sprite,$34(a0)
                bra.w   loc_7F4C0
; End of function DEZCapsule_ExplodeThenDelete
