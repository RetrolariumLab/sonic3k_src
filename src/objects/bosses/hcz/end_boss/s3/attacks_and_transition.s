; Owner: objects/bosses/hcz/end_boss/s3
; Responsibility: Hydrocity end-boss attack actors, movement states, geyser effects and player transition
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

loc_491E8:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_49200(pc,d0.w),d1
                jsr     off_49200(pc,d1.w)
                bsr.w   MarkHCZBossVortexDetachedWhenColumnDies
                jmp     (Child_Draw_Sprite2).l
; ---------------------------------------------------------------------------
off_49200:
                dc.w    loc_49206-off_49200
                dc.w    loc_4921A-off_49200
                dc.w    loc_4924A-off_49200
; ---------------------------------------------------------------------------

loc_49206:
                lea     word_49B88(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #byte_49C61,$30(a0)
                rts
; ---------------------------------------------------------------------------

loc_4921A:
                bsr.w   CaptureBothPlayersInHCZBossVortex
                bsr.w   PullBothPlayersTowardHCZBossVortex
                bsr.w   SynchronizeHCZBossVortexHeightVisual
                jsr     (Animate_Raw).l
                movea.w parent3(a0),a1
                btst    #3,$38(a1)
                bne.s   loc_4923A
                rts
; ---------------------------------------------------------------------------

loc_4923A:
                move.b  #4,routine(a0)
                move.w  x_vel(a1),x_vel(a0)
                bra.w   loc_49960
; ---------------------------------------------------------------------------

loc_4924A:
                bsr.w   SynchronizeHCZBossVortexHeightVisual
                move.w  x_vel(a1),x_vel(a0)
                jsr     (MoveSprite2).l
                jmp     (Animate_Raw).l
; ---------------------------------------------------------------------------

loc_49260:
                lea     word_49B8E(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #loc_49284,(a0)
                move.l  #byte_49C7A,$30(a0)

loc_49278:
                move.w  (Water_level).w,d0
                subq.w  #4,d0
                move.w  d0,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

loc_49284:
                jsr     (Animate_Raw).l
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  word_492A8(pc,d0.w),d0
                movea.w parent3(a0),a1
                move.w  x_pos(a1),d1
                add.w   d0,d1
                move.w  d1,x_pos(a0)
                jmp     (Child_Draw_Sprite2).l
; ---------------------------------------------------------------------------
word_492A8:
                dc.w    -4,     4
; ---------------------------------------------------------------------------

loc_492AC:
                lea     word_49B94(pc),a1
                jsr     (SetUp_ObjAttributes2).l
                move.l  #AnimateRaw_DrawTouch,(a0)
                move.l  #byte_49C7E,$30(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                bra.s   loc_49278
; ---------------------------------------------------------------------------

loc_492CE:
                lea     ObjDat3_49B9C(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #Obj_Wait,(a0)
                move.l  #loc_492FC,$34(a0)
                bsr.w   ConfigureHCZBossGeyserLayerFromSubtype
                tst.b   subtype(a0)
                bne.w   locret_48D3A
                lea     ChildObjDat_49C0C(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_492FC:
                move.l  #loc_4930C,(a0)
                move.l  #Go_Delete_Sprite_2,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_4930C:
                bsr.w   ApplyHCZBossGeyserToBothPlayers
                jmp     (AnimateRaw_DrawTouch).l
; ---------------------------------------------------------------------------

loc_49316:
                lea     ObjDat3_49BB4(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #loc_49376,(a0)
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
                move.l  off_49366(pc,d0.w),$30(a0)
                move.w  #$1F,$2E(a0)
                move.l  #loc_49390,$34(a0)
                rts
; ---------------------------------------------------------------------------
off_49366:
                dc.l    byte_48C8A
                dc.l    byte_48C8E
                dc.l    byte_48C92
                dc.l    byte_48C96
; ---------------------------------------------------------------------------

loc_49376:
                movea.w parent3(a0),a3
                bsr.w   AccelerateHCZBossBubbleTowardParentX
                jsr     (Animate_Raw).l
                jsr     (Obj_Wait).l
                jmp     (Child_Draw_Sprite2).l
; ---------------------------------------------------------------------------

loc_49390:
                move.l  #loc_493A2,(a0)
                movea.l $30(a0),a1
                move.b  1(a1),mapping_frame(a0)
                rts
; ---------------------------------------------------------------------------

loc_493A2:
                movea.w parent3(a0),a3
                btst    #3,$38(a3)
                bne.s   loc_493B8
                bsr.w   AccelerateHCZBossBubbleTowardParentX
                jmp     (Child_Draw_Sprite2).l
; ---------------------------------------------------------------------------

loc_493B8:
                move.l  #loc_49376,(a0)
                move.w  #$1F,$2E(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_493CE:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_493E2(pc,d0.w),d1
                jsr     off_493E2(pc,d1.w)
                jmp     (Child_DrawTouch_Sprite).l
; ---------------------------------------------------------------------------
off_493E2:
                dc.w    loc_493F0-off_493E2
                dc.w    loc_4940A-off_493E2
                dc.w    loc_4944E-off_493E2
                dc.w    loc_49482-off_493E2
                dc.w    loc_494F0-off_493E2
                dc.w    loc_49518-off_493E2
                dc.w    loc_4953E-off_493E2
; ---------------------------------------------------------------------------

loc_493F0:
                lea     word_49B7A(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.b  #8,y_radius(a0)
                bsr.w   SetHCZBossBombStackPriority
                jmp     (Refresh_ChildPositionAdjusted).l
; ---------------------------------------------------------------------------

loc_4940A:
                jsr     (Refresh_ChildPositionAdjusted).l
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                bne.s   loc_4941E
                rts
; ---------------------------------------------------------------------------

loc_4941E:
                move.b  #4,routine(a0)
                tst.b   subtype(a0)
                beq.s   loc_4942C
                rts
; ---------------------------------------------------------------------------

loc_4942C:
                move.b  #6,routine(a0)
                move.w  #3,$2E(a0)
                move.l  #loc_494C4,$34(a0)
                move.b  #1,$40(a0)
                move.b  #0,$41(a0)
                rts
; ---------------------------------------------------------------------------

loc_4944E:
                jsr     (Refresh_ChildPositionAdjusted).l
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                beq.s   loc_49462
                rts
; ---------------------------------------------------------------------------

loc_49462:
                move.b  #6,routine(a0)
                subq.b  #2,subtype(a0)
                move.w  #7,$2E(a0)
                move.l  #loc_4949E,$34(a0)
                bsr.w   SetHCZBossBombStackPriority
                bra.w   loc_49740
; ---------------------------------------------------------------------------

loc_49482:
                move.b  $40(a0),d0
                add.b   d0,$42(a0)
                move.b  $41(a0),d0
                add.b   d0,$43(a0)
                jsr     (Refresh_ChildPositionAdjusted).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_4949E:
                move.b  #2,routine(a0)
                tst.b   subtype(a0)
                bne.s   locret_494C2
                lea     ChildObjDat_49BEC(pc),a2
                jsr     (CreateChild7_Normal2).l
                bne.s   locret_494C2
                move.w  parent3(a0),parent3(a1)
                move.b  #4,subtype(a1)

locret_494C2:
                rts
; ---------------------------------------------------------------------------

loc_494C4:
                move.b  #8,routine(a0)
                move.l  #loc_49526,$34(a0)
                move.w  #$100,x_vel(a0)
                movea.w parent3(a0),a1
                bclr    #1,$38(a1)
                btst    #0,render_flags(a1)
                beq.s   locret_494EE
                neg.w   x_vel(a0)

locret_494EE:
                rts
; ---------------------------------------------------------------------------

loc_494F0:
                move.w  y_pos(a0),d0
                cmp.w   (Water_level).w,d0
                bhs.s   loc_49508
                jsr     (MoveSprite_LightGravity).l
                jsr     (ObjHitFloor_DoRoutine).l
                rts
; ---------------------------------------------------------------------------

loc_49508:
                move.b  #$A,routine(a0)
                lea     ChildObjDat_49C1A(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_49518:
                jsr     (MoveSprite_LightGravity).l
                jsr     (ObjHitFloor_DoRoutine).l
                rts
; ---------------------------------------------------------------------------

loc_49526:
                move.b  #$C,routine(a0)
                move.l  #byte_49C4F,$30(a0)
                move.l  #loc_49544,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_4953E:
                jmp     (Animate_RawGetFaster).l
; ---------------------------------------------------------------------------

loc_49544:
                lea     ChildObjDat_49C22(pc),a2
                jsr     (CreateChild6_Simple).l
                moveq   #signextendB(sfx_MissileExplode),d0
                jsr     (Play_SFX).l
                lea     ChildObjDat_49BF4(pc),a2
                jsr     (CreateChild1_Normal).l
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

loc_49566:
                lea     word_49B6E(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #loc_49578,(a0)
                rts
; ---------------------------------------------------------------------------

loc_49578:
                jsr     (Refresh_ChildPositionAdjusted).l
                moveq   #0,d0
                jmp     (Child_Draw_Sprite2_FlickerMove).l
; ---------------------------------------------------------------------------

loc_49586:
                lea     ObjDat3_49BA8(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #loc_495AC,(a0)
                move.l  #byte_49D4A,$30(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------

loc_495AC:
                jsr     (Animate_Raw).l
                cmpi.b  #3,mapping_frame(a0)
                bhs.s   loc_495C0
                jsr     (Add_SpriteToCollisionResponseList).l

loc_495C0:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_495C6:
                lea     (ArtKosM_HCZGeyserVert).l,a1
                move.w  #tiles_to_bytes(ArtTile_HCZCutsceneGeyser),d2
                jsr     (Queue_Kos_Module).l
                move.l  #loc_495DC,(a0)

loc_495DC:
                tst.b   (Kos_modules_left).w
                bne.w   locret_48D3A
                move.l  #loc_495FE,(a0)
                move.w  #$5F,$2E(a0)
                move.l  #loc_49616,$34(a0)
                st      (Screen_shake_flag).w
                rts
; ---------------------------------------------------------------------------

loc_495FE:
                move.b  (V_int_run_count+3).w,d0
                andi.b  #7,d0
                bne.s   loc_49610
                moveq   #signextendB(sfx_Rumble2),d0
                jsr     (Play_SFX).l

loc_49610:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_49616:
                move.l  #loc_4961C,(a0)

loc_4961C:
                lea     ObjDat3_49BC0(pc),a1
                jsr     (SetUp_ObjAttributes).l
                st      (Screen_shake_flag).w
                moveq   #signextendB(sfx_Geyser),d0
                jsr     (Play_SFX).l
                lea     (Player_1).w,a1
                move.w  x_pos(a1),d0
                move.w  d0,x_pos(a0)
                move.w  (Camera_Y_pos).w,d1
                addi.w  #$130,d1
                move.w  d1,y_pos(a0)
                clr.w   $44(a0)
                lea     (Player_2).w,a1
                addi.w  #$30,d0
                sub.w   x_pos(a1),d0
                cmpi.w  #$60,d0
                bcc.s   loc_49664
                move.w  a1,$44(a0)

loc_49664:
                jsr     (SpawnS3HCZExitGeyserEightDebrisPieces).l
                move.l  #loc_49674,(a0)
                st      (Palette_cycle_counters+$00).w

loc_49674:
                lea     (Player_1).w,a1
                move.w  y_pos(a0),d0
                subq.w  #6,d0
                move.w  d0,y_pos(a0)
                subi.w  #$60,d0
                cmp.w   y_pos(a1),d0
                bhs.s   loc_496A4
                move.b  #$81,object_control(a1)
                move.b  #$1A,anim(a1)
                move.l  #loc_496B8,(a0)
                move.w  #$5F,$2E(a0)

loc_496A4:
                bsr.w   CaptureAndLiftSecondaryPlayerWithS3HCZExitGeyser
                move.l  a0,-(sp)
                jsr     (AnPal_HCZ1).l
                movea.l (sp)+,a0
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_496B8:
                lea     (Player_1).w,a1
                move.b  #$1A,anim(a1)
                subq.w  #6,y_pos(a0)
                subq.w  #6,(Player_1+y_pos).w
                bsr.w   CaptureAndLiftSecondaryPlayerWithS3HCZExitGeyser
                subq.w  #1,$2E(a0)
                bmi.s   loc_496E4
                move.l  a0,-(sp)
                jsr     (AnPal_HCZ1).l
                movea.l (sp)+,a0
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_496E4:
                move.w  #$200,d0
                jsr     (StartNewLevel).l
                jmp     (Delete_Current_Sprite).l
