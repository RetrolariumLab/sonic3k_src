; Owner: objects/bosses/hcz/end_boss/sk
; Responsibility: Hydrocity end-boss attack actors, movement states, geyser effects and player transition
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

loc_6B3DE:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_6B3F6(pc,d0.w),d1
                jsr     off_6B3F6(pc,d1.w)
                bsr.w   MarkHCZBossVortexDetachedWhenColumnDies
                jmp     (Child_Draw_Sprite2).l
; ---------------------------------------------------------------------------
off_6B3F6:
                dc.w    loc_6B3FC-off_6B3F6
                dc.w    loc_6B410-off_6B3F6
                dc.w    loc_6B440-off_6B3F6
; ---------------------------------------------------------------------------

loc_6B3FC:
                lea     word_6BD46(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #byte_6BE19,$30(a0)
                rts
; ---------------------------------------------------------------------------

loc_6B410:
                bsr.w   CaptureBothPlayersInHCZBossVortex
                bsr.w   PullBothPlayersTowardHCZBossVortex
                bsr.w   SynchronizeHCZBossVortexHeightVisual
                jsr     (Animate_Raw).l
                movea.w parent3(a0),a1
                btst    #3,$38(a1)
                bne.s   loc_6B430
                rts
; ---------------------------------------------------------------------------

loc_6B430:
                move.b  #4,routine(a0)
                move.w  x_vel(a1),x_vel(a0)
                bra.w   loc_6BB1E
; ---------------------------------------------------------------------------

loc_6B440:
                bsr.w   SynchronizeHCZBossVortexHeightVisual
                move.w  x_vel(a1),x_vel(a0)
                jsr     (MoveSprite2).l
                jmp     (Animate_Raw).l
; ---------------------------------------------------------------------------

loc_6B456:
                lea     word_6BD4C(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #loc_6B47A,(a0)
                move.l  #byte_6BE32,$30(a0)

loc_6B46E:
                move.w  (Water_level).w,d0
                subq.w  #4,d0
                move.w  d0,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

loc_6B47A:
                jsr     (Animate_Raw).l
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  word_6B49E(pc,d0.w),d0
                movea.w parent3(a0),a1
                move.w  x_pos(a1),d1
                add.w   d0,d1
                move.w  d1,x_pos(a0)
                jmp     (Child_Draw_Sprite2).l
; ---------------------------------------------------------------------------
word_6B49E:
                dc.w    -4,     4
; ---------------------------------------------------------------------------

loc_6B4A2:
                lea     word_6BD52(pc),a1
                jsr     (SetUp_ObjAttributes2).l
                move.l  #AnimateRaw_DrawTouch,(a0)
                move.l  #byte_6BE36,$30(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                bra.s   loc_6B46E
; ---------------------------------------------------------------------------

loc_6B4C4:
                lea     ObjDat3_6BD5A(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #Obj_Wait,(a0)
                move.l  #loc_6B4F2,$34(a0)
                bsr.w   ConfigureHCZBossGeyserLayerFromSubtype
                tst.b   subtype(a0)
                bne.w   locret_6AF0A
                lea     ChildObjDat_6BDCA(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_6B4F2:
                move.l  #loc_6B502,(a0)
                move.l  #Go_Delete_Sprite_2,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_6B502:
                bsr.w   ApplyHCZBossGeyserToBothPlayers
                jmp     (AnimateRaw_DrawTouch).l
; ---------------------------------------------------------------------------

loc_6B50C:
                lea     ObjDat3_6BD72(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #loc_6B56C,(a0)
                jsr     (Random_Number).l
                andi.w  #$FF,d0
                ext.w   d0
                add.w   d0,x_pos(a0)
                swap    d0
                move.w  (Water_level).w,d1
                andi.w  #$1F,d0
                add.w   d0,d1
                move.w  d1,y_pos(a0)
                andi.w  #3,d0
                move.b  d0,mapping_frame(a0)
                lsl.w   #2,d0
                move.l  off_6B55C(pc,d0.w),$30(a0)
                move.w  #$1F,$2E(a0)
                move.l  #loc_6B586,$34(a0)
                rts
; ---------------------------------------------------------------------------
off_6B55C:
                dc.l    byte_6AE46
                dc.l    byte_6AE4A
                dc.l    byte_6AE4E
                dc.l    byte_6AE52
; ---------------------------------------------------------------------------

loc_6B56C:
                movea.w parent3(a0),a3
                bsr.w   AccelerateHCZBossBubbleTowardParentX
                jsr     (Animate_Raw).l
                jsr     (Obj_Wait).l
                jmp     (Child_Draw_Sprite2).l
; ---------------------------------------------------------------------------

loc_6B586:
                move.l  #loc_6B598,(a0)
                movea.l $30(a0),a1
                move.b  1(a1),mapping_frame(a0)
                rts
; ---------------------------------------------------------------------------

loc_6B598:
                movea.w parent3(a0),a3
                btst    #3,$38(a3)
                bne.s   loc_6B5AE
                bsr.w   AccelerateHCZBossBubbleTowardParentX
                jmp     (Child_Draw_Sprite2).l
; ---------------------------------------------------------------------------

loc_6B5AE:
                move.l  #loc_6B56C,(a0)
                move.w  #$1F,$2E(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_6B5C4:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_6B5D8(pc,d0.w),d1
                jsr     off_6B5D8(pc,d1.w)
                jmp     (Child_DrawTouch_Sprite).l
; ---------------------------------------------------------------------------
off_6B5D8:
                dc.w    loc_6B5E6-off_6B5D8
                dc.w    loc_6B600-off_6B5D8
                dc.w    loc_6B644-off_6B5D8
                dc.w    loc_6B678-off_6B5D8
                dc.w    loc_6B6E6-off_6B5D8
                dc.w    loc_6B70E-off_6B5D8
                dc.w    loc_6B734-off_6B5D8
; ---------------------------------------------------------------------------

loc_6B5E6:
                lea     word_6BD38(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.b  #8,y_radius(a0)
                bsr.w   SetHCZBossBombStackPriority
                jmp     (Refresh_ChildPositionAdjusted).l
; ---------------------------------------------------------------------------

loc_6B600:
                jsr     (Refresh_ChildPositionAdjusted).l
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                bne.s   loc_6B614
                rts
; ---------------------------------------------------------------------------

loc_6B614:
                move.b  #4,routine(a0)
                tst.b   subtype(a0)
                beq.s   loc_6B622
                rts
; ---------------------------------------------------------------------------

loc_6B622:
                move.b  #6,routine(a0)
                move.w  #3,$2E(a0)
                move.l  #loc_6B6BA,$34(a0)
                move.b  #1,$40(a0)
                move.b  #0,$41(a0)
                rts
; ---------------------------------------------------------------------------

loc_6B644:
                jsr     (Refresh_ChildPositionAdjusted).l
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                beq.s   loc_6B658
                rts
; ---------------------------------------------------------------------------

loc_6B658:
                move.b  #6,routine(a0)
                subq.b  #2,subtype(a0)
                move.w  #7,$2E(a0)
                move.l  #loc_6B694,$34(a0)
                bsr.w   SetHCZBossBombStackPriority
                bra.w   loc_6B904
; ---------------------------------------------------------------------------

loc_6B678:
                move.b  $40(a0),d0
                add.b   d0,$42(a0)
                move.b  $41(a0),d0
                add.b   d0,$43(a0)
                jsr     (Refresh_ChildPositionAdjusted).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_6B694:
                move.b  #2,routine(a0)
                tst.b   subtype(a0)
                bne.s   locret_6B6B8
                lea     ChildObjDat_6BDAA(pc),a2
                jsr     (CreateChild7_Normal2).l
                bne.s   locret_6B6B8
                move.w  parent3(a0),parent3(a1)
                move.b  #4,subtype(a1)

locret_6B6B8:
                rts
; ---------------------------------------------------------------------------

loc_6B6BA:
                move.b  #8,routine(a0)
                move.l  #loc_6B71C,$34(a0)
                move.w  #$100,x_vel(a0)
                movea.w parent3(a0),a1
                bclr    #1,$38(a1)
                btst    #0,render_flags(a1)
                beq.s   locret_6B6E4
                neg.w   x_vel(a0)

locret_6B6E4:
                rts
; ---------------------------------------------------------------------------

loc_6B6E6:
                move.w  y_pos(a0),d0
                cmp.w   (Water_level).w,d0
                bhs.s   loc_6B6FE
                jsr     (MoveSprite_LightGravity).l
                jsr     (ObjHitFloor_DoRoutine).l
                rts
; ---------------------------------------------------------------------------

loc_6B6FE:
                move.b  #$A,routine(a0)
                lea     ChildObjDat_6BDD8(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_6B70E:
                jsr     (MoveSprite_LightGravity).l
                jsr     (ObjHitFloor_DoRoutine).l
                rts
; ---------------------------------------------------------------------------

loc_6B71C:
                move.b  #$C,routine(a0)
                move.l  #byte_6BE07,$30(a0)
                move.l  #loc_6B73A,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_6B734:
                jmp     (Animate_RawGetFaster).l
; ---------------------------------------------------------------------------

loc_6B73A:
                lea     ChildObjDat_6BDE0(pc),a2
                jsr     (CreateChild6_Simple).l
                moveq   #signextendB(sfx_MissileExplode),d0
                jsr     (Play_SFX).l
                lea     ChildObjDat_6BDB2(pc),a2
                jsr     (CreateChild1_Normal).l
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

loc_6B75C:
                lea     word_6BD2C(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #loc_6B76E,(a0)
                rts
; ---------------------------------------------------------------------------

loc_6B76E:
                jsr     (Refresh_ChildPositionAdjusted).l
                moveq   #0,d0
                jmp     (Child_Draw_Sprite2_FlickerMove).l
; ---------------------------------------------------------------------------

loc_6B77C:
                lea     ObjDat3_6BD66(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #loc_6B7A2,(a0)
                move.l  #byte_6BF02,$30(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------

loc_6B7A2:
                jsr     (Animate_Raw).l
                cmpi.b  #3,mapping_frame(a0)
                bhs.s   loc_6B7B6
                jsr     (Add_SpriteToCollisionResponseList).l

loc_6B7B6:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_6B7BC:
                lea     (ArtKosM_HCZGeyserVert).l,a1
                move.w  #tiles_to_bytes(ArtTile_HCZCutsceneGeyser),d2
                jsr     (Queue_Kos_Module).l
                move.l  #loc_6B7D2,(a0)

loc_6B7D2:
                move.l  #loc_6B7EC,(a0)
                move.w  #$5F,$2E(a0)
                move.l  #loc_6B804,$34(a0)
                st      (Screen_shake_flag).w
                rts
; ---------------------------------------------------------------------------

loc_6B7EC:
                move.b  (V_int_run_count+3).w,d0
                andi.b  #7,d0
                bne.s   loc_6B7FE
                moveq   #signextendB(sfx_Rumble2),d0
                jsr     (Play_SFX).l

loc_6B7FE:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_6B804:
                jsr     (AllocateObject).l
                bne.s   loc_6B81C
                move.l  #loc_6B824,(a1)
                st      subtype(a1)
                move.w  #4,$2E(a1)

loc_6B81C:
                lea     loc_6B832(pc),a1
                move.l  a1,(a0)
                jmp     (a1)
; ---------------------------------------------------------------------------

loc_6B824:
                subq.w  #1,$2E(a0)
                bpl.w   locret_6AF0A
                move.l  #loc_6B832,(a0)

loc_6B832:
                lea     ObjDat3_6BD7E(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #loc_6B882,(a0)
                tst.b   subtype(a0)
                bne.s   loc_6B860
                st      (Palette_cycle_counters+$00).w
                st      (Screen_shake_flag).w
                moveq   #signextendB(sfx_Geyser),d0
                jsr     (Play_SFX).l
                lea     (Player_1).w,a1
                bra.w   loc_6B864
; ---------------------------------------------------------------------------

loc_6B860:
                lea     (Player_2).w,a1

loc_6B864:
                move.w  a1,$44(a0)
                move.w  x_pos(a1),d0
                move.w  d0,x_pos(a0)
                move.w  (Camera_Y_pos).w,d1
                addi.w  #$130,d1
                move.w  d1,y_pos(a0)
                jmp     (loc_6BCB2).l
; ---------------------------------------------------------------------------

loc_6B882:
                movea.w $44(a0),a1
                move.w  y_pos(a0),d0
                subq.w  #6,d0
                move.w  d0,y_pos(a0)
                subi.w  #$60,d0
                cmp.w   y_pos(a1),d0
                bhs.s   loc_6B8B2
                move.b  #$81,object_control(a1)
                move.b  #$1A,anim(a1)
                move.l  #loc_6B8C8,(a0)
                move.w  #$5F,$2E(a0)

loc_6B8B2:
                tst.b   subtype(a0)
                bne.s   loc_6B8C2
                move.l  a0,-(sp)
                jsr     (AnPal_HCZ1).l
                movea.l (sp)+,a0

loc_6B8C2:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_6B8C8:
                movea.w $44(a0),a1
                subq.w  #6,y_pos(a0)
                subq.w  #6,y_pos(a1)
                tst.b   subtype(a0)
                bne.s   loc_6B8C2
                subq.w  #1,$2E(a0)
                bpl.s   loc_6B8B2
                move.w  #$200,d0
                jsr     (StartNewLevel).l
                jmp     (Delete_Current_Sprite).l
