; Owner: objects/cutscenes/sk
; Responsibility: Standalone Knuckles opening sequence, skip input and startup scene actors
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

CutsceneKnux_SKIntro:
                cmpi.b  #2,(Player_1+character_id).w
                bne.w   CutsceneKnux_Delete
                tst.b   (Last_star_post_hit).w
                bne.w   CutsceneKnux_Delete
                tst.w   (SK_alone_flag).w
                beq.w   CutsceneKnux_Delete
                move.l  #loc_63466,(a0)

loc_63466:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_63486(pc,d0.w),d1
                jsr     off_63486(pc,d1.w)
                move.w  $42(a0),d0
                move.w  off_63494(pc,d0.w),d0
                jsr     off_63494(pc,d0.w)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
off_63486:
                dc.w    loc_634CA-off_63486
                dc.w    loc_63526-off_63486
                dc.w    loc_63562-off_63486
                dc.w    loc_6358E-off_63486
                dc.w    loc_635C8-off_63486
                dc.w    loc_635F6-off_63486
                dc.w    loc_63620-off_63486
off_63494:
                dc.w    loc_6349A-off_63494
                dc.w    loc_634AC-off_63494
                dc.w    loc_634B8-off_63494
; ---------------------------------------------------------------------------

loc_6349A:
                move.l  #Map_KnuxIntroLay,mappings(a0)
                lea     DPLCPtr_KnuxIntroLay(pc),a2
                jmp     (Perform_DPLC).l
; ---------------------------------------------------------------------------

loc_634AC:
                move.l  #Map_Knuckles,mappings(a0)
                bra.w   Knuckles_Load_PLC_6618A
; ---------------------------------------------------------------------------

loc_634B8:
                move.l  #Map_HPZKnucklesGrab,mappings(a0)
                lea     DPLCPtr_HPZKnucklesGrab(pc),a2
                jmp     (Perform_DPLC).l
; ---------------------------------------------------------------------------

loc_634CA:
                lea     ObjSlot_KnuxIntroLay(pc),a1
                jsr     (SetUp_ObjAttributesSlotted).l
                move.w  #$EF,$2E(a0)
                move.b  #$83,(Player_1+object_control).w
                move.w  #$560,(Camera_X_pos).w
                move.w  #$948,(Camera_Y_pos).w
                st      (Scroll_lock).w
                move.l  (V_int_run_count).w,(RNG_seed).w
                clr.b   (Level_started_flag).w
                jsr     (AllocateObject).l
                bne.s   loc_63508
                move.l  #Obj_SkipIntro,(a1)

loc_63508:
                lea     ChildObjDat_66656(pc),a2
                jsr     (CreateChild6_Simple).l
                lea     (Pal_SKIntroBomb).l,a1
                lea     (Target_palette_line_2).w,a2
                moveq   #bytesToLcnt($20),d6

loc_6351E:
                move.l  (a1)+,(a2)+
                dbf     d6,loc_6351E
                rts
; ---------------------------------------------------------------------------

loc_63526:
                btst    #0,(_unkFAB8).w
                bne.s   loc_6354C
                subq.w  #1,$2E(a0)
                bne.s   loc_63542
                jsr     (AllocateObject).l
                bne.s   loc_63542
                move.l  #loc_63790,(a1)

loc_63542:
                lea     byte_668C3(pc),a1
                jmp     (Animate_RawNoSST).l
; ---------------------------------------------------------------------------

loc_6354C:
                move.b  #4,routine(a0)
                move.b  #4,mapping_frame(a0)
                lea     byte_668C7(pc),a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

loc_63562:
                btst    #1,(_unkFAB8).w
                bne.s   loc_63570
                jmp     (Animate_RawMultiDelay).l
; ---------------------------------------------------------------------------

loc_63570:
                move.b  #6,routine(a0)
                move.w  #2,$42(a0)
                move.b  #$8D,mapping_frame(a0)
                move.w  #-$100,x_vel(a0)
                move.w  #-$100,y_vel(a0)

loc_6358E:
                btst    #2,(_unkFAB8).w
                bne.s   loc_635A2
                addi.w  #8,y_vel(a0)
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

loc_635A2:
                move.b  #8,routine(a0)
                move.w  #4,$42(a0)
                move.b  #3,mapping_frame(a0)
                subq.w  #8,y_pos(a0)
                move.b  #$13,y_radius(a0)
                move.w  #-$100,x_vel(a0)
                clr.w   y_vel(a0)

loc_635C8:
                jsr     (MoveSprite_LightGravity).l
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.w   locret_6206C
                add.w   d1,y_pos(a0)
                move.b  #$A,routine(a0)
                move.l  #loc_635FC,$34(a0)
                lea     byte_668D0(pc),a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

loc_635F6:
                jmp     (Animate_RawMultiDelay).l
; ---------------------------------------------------------------------------

loc_635FC:
                move.b  #$C,routine(a0)
                move.w  #2,$42(a0)
                move.b  #7,mapping_frame(a0)
                clr.w   x_vel(a0)
                clr.w   y_vel(a0)
                lea     byte_6682F(pc),a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

loc_63620:
                move.w  x_vel(a0),d0
                addi.w  #$C,d0
                cmpi.w  #$400,d0
                bhi.s   loc_63632
                move.w  d0,x_vel(a0)

loc_63632:
                jsr     (MoveSprite2).l
                jsr     (Animate_RawCheckResult).l
                move.w  (Camera_X_pos).w,d0
                addi.w  #$180,d0
                cmp.w   x_pos(a0),d0
                bhs.w   locret_6206C

loc_6364E:
                move.b  #1,(Last_star_post_hit).w
                move.w  #$6F4,(Saved_X_pos).w
                move.w  #$9EC,(Saved_Y_pos).w
                jsr     (Save_Level_Data).l
                clr.l   (Saved_timer).w
                move.w  #$700,d0
                move.w  d0,(Current_zone_and_act).w
                move.w  d0,(Apparent_zone_and_act).w
                move.w  #1,(Restart_level_flag).w
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

Obj_SkipIntro:
                btst    #button_start,(Ctrl_1_pressed).w
                bne.s   loc_6364E
                btst    #button_start,(Ctrl_2_pressed).w
                bne.s   loc_6364E
                rts
; ---------------------------------------------------------------------------

loc_63694:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  word_636F4(pc,d0.w),x_pos(a0)
                move.w  #$9F4,y_pos(a0)
                moveq   #0,d1
                cmpi.w  #8,d0
                blo.s   loc_636B0
                moveq   #4,d1

loc_636B0:
                move.l  word_63704(pc,d1.w),$3A(a0)
                lea     off_6370C(pc),a1
                move.b  #$C,y_radius(a0)
                andi.w  #2,d0
                beq.s   loc_636D0
                adda.w  #$A,a1
                move.b  #$A,y_radius(a0)

loc_636D0:
                move.l  (a1)+,(a0)
                move.l  (a1)+,mappings(a0)
                move.w  (a1)+,art_tile(a0)
                bset    #2,render_flags(a0)
                move.w  #$200,priority(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #$10,height_pixels(a0)
                rts
; ---------------------------------------------------------------------------
word_636F4:
                dc.w    $5F0
                dc.w    $600
                dc.w    $610
                dc.w    $620
                dc.w    $660
                dc.w    $670
                dc.w    $680
                dc.w    $690
word_63704:
                dc.w    $5E8
                dc.w    $628
                dc.w    $658
                dc.w    $698
off_6370C:
                dc.l    loc_63720
                dc.l    Map_Animals2
                dc.w    make_art_tile(ArtTile_Animals1,0,0)
                dc.l    loc_63750
                dc.l    Map_Animals1
                dc.w    make_art_tile(ArtTile_Animals2,0,0)
; ---------------------------------------------------------------------------

loc_63720:
                jsr     (MoveSprite).l
                move.b  #1,mapping_frame(a0)
                tst.w   y_vel(a0)
                bmi.s   loc_6374A
                move.b  #0,mapping_frame(a0)
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.s   loc_6374A
                add.w   d1,y_pos(a0)
                bsr.w   OpeningAnimalChooseBoundedRandomBounceVelocity

loc_6374A:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_63750:
                jsr     (MoveSprite2).l
                addi.w  #$18,y_vel(a0)
                tst.w   y_vel(a0)
                bmi.s   loc_63774
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.s   loc_63774
                add.w   d1,y_pos(a0)
                bsr.w   OpeningAnimalChooseBoundedRandomBounceVelocity

loc_63774:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   loc_6378A
                move.b  #1,anim_frame_timer(a0)
                addq.b  #1,mapping_frame(a0)
                andi.b  #1,mapping_frame(a0)

loc_6378A:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_63790:
                lea     ObjDat3_66486(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #loc_637EC,(a0)
                move.b  #$10,y_radius(a0)
                move.w  (Camera_X_pos).w,d0
                addi.w  #$A0,d0
                move.w  d0,x_pos(a0)
                move.w  (Camera_Y_pos).w,d0
                subi.w  #$40,d0
                move.w  d0,y_pos(a0)
                moveq   #signextendB(sfx_MissileThrow),d0
                jsr     (Play_SFX).l
                lea     ChildObjDat_6665C(pc),a2
                jsr     (CreateChild1_Normal).l
                lea     (PLC_BossExplosion).l,a1
                jsr     (Load_PLC_Raw).l
                lea     (ArtKosM_KnuxIntroBomb).l,a1
                move.w  #tiles_to_bytes(ArtTile_KnuxIntroBomb),d2
                jmp     (Queue_Kos_Module).l
; ---------------------------------------------------------------------------

loc_637EC:
                jsr     (MoveSprite).l
                tst.b   render_flags(a0)
                bpl.s   loc_63840
                tst.w   y_vel(a0)
                bmi.s   loc_63840
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.s   loc_63840
                add.w   d1,y_pos(a0)
                bset    #0,(_unkFAB8).w
                moveq   #signextendB(sfx_FloorThump),d0
                jsr     (Play_SFX).l
                move.w  y_vel(a0),d0
                asr.w   #2,d0
                neg.w   d0
                move.w  d0,y_vel(a0)
                cmpi.w  #-$100,d0
                blt.s   loc_63840
                move.l  #loc_63846,(a0)
                move.w  #(2*60)-1,$2E(a0)
                moveq   #signextendB(cmd_FadeOut),d0
                jsr     (Play_Music).l

loc_63840:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_63846:
                subq.w  #1,$2E(a0)
                bpl.s   loc_6389C
                move.l  #loc_638A2,(a0)
                bset    #7,status(a0)
                bset    #1,(_unkFAB8).w
                moveq   #signextendB(sfx_MissileExplode),d0
                jsr     (Play_SFX).l
                lea     (Normal_palette).w,a1
                lea     (Target_palette).w,a2
                moveq   #bytesToLcnt($20),d6

loc_63870:
                move.l  (a1)+,(a2)+
                dbf     d6,loc_63870
                jsr     (AllocateObject).l
                bne.s   loc_6389C
                move.w  a1,$44(a0)
                move.l  #loc_85E64,(a1)
                move.w  #7,$3A(a1)
                st      subtype(a1)
                lea     ChildObjDat_66650(pc),a2
                jsr     (CreateChild6_Simple).l

loc_6389C:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_638A2:
                movea.w $44(a0),a1
                btst    #5,$38(a1)
                beq.w   locret_6206C
                bset    #2,(_unkFAB8).w
                jsr     (AllocateObject).l
                bne.s   loc_638C4
                move.l  #loc_639C8,(a1)

loc_638C4:
                lea     (Pal_SSZ1).l,a1
                lea     (Target_palette_line_2).w,a2
                moveq   #bytesToLcnt($20),d6

loc_638D0:
                move.l  (a1)+,(a2)+
                dbf     d6,loc_638D0
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

loc_638DC:
                move.l  #loc_638EC,(a0)
                lea     word_66492(pc),a1
                jmp     (SetUp_ObjAttributes3).l
; ---------------------------------------------------------------------------

loc_638EC:
                lea     byte_66905(pc),a1
                jsr     (Animate_RawNoSST).l
                jsr     (Refresh_ChildPosition).l
                move.b  (V_int_run_count+3).w,d0
                andi.b  #7,d0
                bne.s   loc_63910
                lea     ChildObjDat_66664(pc),a2
                jsr     (CreateChild6_Simple).l

loc_63910:
                jmp     (Child_Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_63916:
                lea     word_66498(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #loc_63946,(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                jsr     (Random_Number).l
                andi.w  #$7F,d0
                subi.w  #$3F,d0
                move.w  d0,x_vel(a0)
                move.w  #-$100,y_vel(a0)

loc_63946:
                jsr     (MoveSprite2).l
                lea     byte_6690B(pc),a1
                jsr     (Animate_RawNoSST).l
                jmp     (Child_Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_6395C:
                lea     (ObjDat_BossExplosion1).l,a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #Go_Delete_Sprite,$34(a0)
                moveq   #signextendB(sfx_Explode),d0
                jsr     (Play_SFX).l
                moveq   #0,d0
                move.b  subtype(a0),d0
                lea     byte_639A2(pc,d0.w),a1
                lsr.w   #1,d0
                move.w  d0,$2E(a0)
                move.b  (a1)+,d0
                ext.w   d0
                add.w   d0,x_pos(a0)
                move.b  (a1)+,d0
                ext.w   d0
                add.w   d0,y_pos(a0)
                lea     (loc_639B6).l,a1
                move.l  a1,(a0)
                jmp     (a1)
; ---------------------------------------------------------------------------
byte_639A2:
                dc.b    0,   0
                dc.b    8,  -8
                dc.b    -6, -$C
                dc.b    -$A,   4
                dc.b    8,  $A
                dc.b    0, $18
                dc.b    8,-$18
                dc.b    -$C,-$20
                dc.b    -$16,  -4
                dc.b    $18,   0
                even
; ---------------------------------------------------------------------------

loc_639B6:
                subq.w  #1,$2E(a0)
                bpl.w   locret_6206C
                lea     (Obj_BossExplosionAnim).l,a1
                move.l  a1,(a0)
                jmp     (a1)
; ---------------------------------------------------------------------------

loc_639C8:
                lea     (ObjDat3_919A6).l,a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #loc_63A16,(a0)
                move.w  (Camera_X_pos).w,d0
                addi.w  #$110,d0
                move.w  d0,x_pos(a0)
                move.w  (Camera_Y_pos).w,d0
                subi.w  #$60,d0
                move.w  d0,y_pos(a0)
                moveq   #signextendB(mus_EndBoss),d0
                jsr     (Play_Music).l
                lea     (ChildObjDat_919D0).l,a2
                jsr     (CreateChild1_Normal).l
                lea     (ArtKosM_EggRoboBadnik).l,a1
                move.w  #tiles_to_bytes(ArtTile_EggRoboBadnik),d2
                jmp     (Queue_Kos_Module).l
; ---------------------------------------------------------------------------

loc_63A16:
                addq.w  #1,y_pos(a0)
                move.w  (Camera_Y_pos).w,d0
                addi.w  #$40,d0
                cmp.w   y_pos(a0),d0
                bge.s   loc_63A3A
                move.l  #loc_63A46,(a0)
                move.w  #$7F,$2E(a0)
                jsr     (Swing_Setup1).l

loc_63A3A:
                jsr     (SetEggRoboFrameFromVblankParity).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_63A46:
                subq.w  #1,$2E(a0)
                bne.s   loc_63A52
                move.w  #$400,x_vel(a0)

loc_63A52:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                jsr     (SetEggRoboFrameFromVblankParity).l
                jmp     (Sprite_CheckDelete).l
; End of function loc_63694
