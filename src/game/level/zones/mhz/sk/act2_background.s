; Owner: game/level/zones/mhz/sk
; Responsibility: Mushroom Hill act-two background initialization, events, deformation and private sequence data
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

MHZ2_BackgroundInit:
                move.w  (Camera_X_pos_copy).w,(Events_fg_0).w
                move.w  (Camera_X_pos_copy).w,(Events_fg_1).w
                cmpi.w  #$3700,(Player_1+x_pos).w
                blo.s   loc_55198
                cmpi.w  #$500,(Player_1+y_pos).w
                bhs.s   loc_55198
                move.w  #8,(Events_routine_bg).w
                jsr     BuildMhz2ChaseBackgroundCoordinates(pc)
                bra.s   loc_5519C
; ---------------------------------------------------------------------------

loc_55198:
                jsr     MHZ_Deform(pc)

loc_5519C:
                jsr     Reset_TileOffsetPositionEff(pc)
                moveq   #0,d1
                jsr     Refresh_PlaneFull(pc)
                jmp     PlainDeformation(pc)
; ---------------------------------------------------------------------------

MHZ2_BackgroundEvent:
                lea     (Events_fg_0).w,a1
                move.w  (Camera_X_pos_copy).w,d0
                move.w  #$100,d2
                move.w  #$200,d3
                jsr     Adjust_BGDuringLoop(pc)
                move.w  (Events_routine_bg).w,d0
                jmp     MHZ2_BackgroundEvent_Index(pc,d0.w)
; ---------------------------------------------------------------------------

MHZ2_BackgroundEvent_Index:
                bra.w   loc_551EE
; ---------------------------------------------------------------------------
                bra.w   loc_55236
; ---------------------------------------------------------------------------
                bra.w   loc_55250
; ---------------------------------------------------------------------------
                bra.w   loc_552F8
; ---------------------------------------------------------------------------
                bra.w   loc_55312
; ---------------------------------------------------------------------------
                bra.w   loc_553B6
; ---------------------------------------------------------------------------
                bra.w   loc_55424
; ---------------------------------------------------------------------------
                bra.w   loc_5543A
; ---------------------------------------------------------------------------
                bra.w   loc_5545A
; ---------------------------------------------------------------------------
                bra.w   loc_55486
; ---------------------------------------------------------------------------

loc_551EE:
                cmpi.w  #$3700,(Player_1+x_pos).w
                blo.s   loc_5521E
                cmpi.w  #$500,(Player_1+y_pos).w
                bhs.s   loc_5521E
                jsr     BuildMhz2ChaseBackgroundCoordinates(pc)
                jsr     Reset_TileOffsetPositionEff(pc)
                addi.w  #$E0,d0
                and.w   (Camera_Y_pos_mask).w,d0
                move.w  d0,(Draw_delayed_position).w
                move.w  #$F,(Draw_delayed_rowcount).w
                addq.w  #4,(Events_routine_bg).w
                bra.s   loc_5523A
; ---------------------------------------------------------------------------

loc_5521E:
                jsr     MHZ_Deform(pc)

loc_55222:
                lea     (Camera_Y_pos_BG_copy).w,a6
                lea     (Camera_Y_pos_BG_rounded).w,a5
                moveq   #0,d1
                moveq   #$20,d6
                jsr     Draw_TileRow(pc)
                jmp     PlainDeformation(pc)
; ---------------------------------------------------------------------------

loc_55236:
                jsr     BuildMhz2ChaseBackgroundCoordinates(pc)

loc_5523A:
                moveq   #0,d1
                move.w  (Camera_Y_pos_BG_copy).w,d2
                jsr     Draw_PlaneVertSingleBottomUp(pc)
                bpl.w   loc_552E4
                addq.w  #4,(Events_routine_bg).w
                bra.w   loc_552E4
; ---------------------------------------------------------------------------

loc_55250:
                cmpi.w  #$500,(Player_1+y_pos).w
                blo.s   loc_5527A
                jsr     MHZ_Deform(pc)
                jsr     Reset_TileOffsetPositionEff(pc)
                addi.w  #$E0,d0
                and.w   (Camera_Y_pos_mask).w,d0
                move.w  d0,(Draw_delayed_position).w
                move.w  #$F,(Draw_delayed_rowcount).w
                addq.w  #4,(Events_routine_bg).w
                bra.w   loc_552FC
; ---------------------------------------------------------------------------

loc_5527A:
                cmpi.w  #$420,(Player_1+y_pos).w
                bls.s   loc_5528A
                btst    #1,(Player_1+status).w
                bne.s   loc_552E0

loc_5528A:
                movem.l d7-a0/a2-a3,-(sp)
                lea     (MHZ_Custom_Layout).l,a1
                lea     (Level_layout_header).w,a2
                move.w  #$200-1,d0

loc_5529C:
                move.l  (a1)+,(a2)+
                move.l  (a1)+,(a2)+
                dbf     d0,loc_5529C
                lea     (MHZ_128x128_Custom_Kos).l,a1
                lea     (Chunk_table+$2280).l,a2
                jsr     (Queue_Kos).l
                lea     (MHZ_16x16_Custom_Kos).l,a1
                lea     (Block_table+$B28).w,a2
                jsr     (Queue_Kos).l
                lea     (ArtKosM_MHZ_Custom).l,a1
                move.w  #tiles_to_bytes($222),d2
                jsr     (Queue_Kos_Module).l
                movem.l (sp)+,d7-a0/a2-a3
                addq.w  #8,(Events_routine_bg).w
                bra.s   loc_55312
; ---------------------------------------------------------------------------

loc_552E0:
                jsr     BuildMhz2ChaseBackgroundCoordinates(pc)

loc_552E4:
                lea     (Camera_Y_pos_BG_copy).w,a6
                lea     (Camera_Y_pos_BG_rounded).w,a5
                moveq   #0,d1
                moveq   #$20,d6
                jsr     Draw_TileRow(pc)
                jmp     PlainDeformation(pc)
; ---------------------------------------------------------------------------

loc_552F8:
                jsr     MHZ_Deform(pc)

loc_552FC:
                moveq   #0,d1
                move.w  (Camera_Y_pos_BG_copy).w,d2
                jsr     Draw_PlaneVertSingleBottomUp(pc)
                bpl.w   loc_55222
                clr.w   (Events_routine_bg).w
                bra.w   loc_55222
; ---------------------------------------------------------------------------

loc_55312:
                tst.b   (Events_bg+$00).w
                bne.s   loc_55380
                cmpi.w  #$3F00,(Camera_X_pos).w
                blo.w   loc_55486
                addq.w  #4,(Events_routine_fg).w
                clr.l   (HScroll_table).w
                move.w  (Camera_X_pos_copy).w,d0
                move.w  d0,(HScroll_table+$004).w
                andi.w  #$FFF0,d0
                move.w  d0,(HScroll_table+$006).w
                move.w  #$1A0,(Draw_delayed_position).w
                move.w  #2,(Draw_delayed_rowcount).w
                st      (Events_bg+$00).w
                lea     word_558E8(pc),a1
                cmpi.w  #3,(Player_mode).w
                bne.s   loc_5535A
                lea     $10(a1),a1

loc_5535A:
                move.b  (a1),(Events_bg+$07).w
                st      (Scroll_lock).w
                move.w  #$C,(Special_events_routine).w
                movem.l d7-a0/a2-a3,-(sp)
                lea     (ArtKosM_MHZEndBossPillar).l,a1
                move.w  #tiles_to_bytes(ArtTile_MHZEndBossPillar),d2
                jsr     (Queue_Kos_Module).l
                movem.l (sp)+,d7-a0/a2-a3

loc_55380:
                move.w  #$4000,d1
                move.w  #$180,d2
                lea     (Level_layout_main).w,a3
                move.w  #VRAM_Plane_A_Name_Table,d7
                jsr     Draw_PlaneVertSingleBottomUp(pc)
                addq.w  #2,a3
                move.w  #VRAM_Plane_B_Name_Table,d7
                tst.w   (Draw_delayed_rowcount).w
                bpl.w   loc_55486
                move.w  #$80,(Draw_delayed_position).w
                move.w  #2,(Draw_delayed_rowcount).w
                st      (Events_bg+$01).w
                addq.w  #4,(Events_routine_bg).w

loc_553B6:
                move.w  #$200,d1
                move.w  #$80,d2
                jsr     Draw_PlaneVertTopDown(pc)
                bpl.w   loc_55486
                lea     (HScroll_table+$008).w,a5
                clr.l   (a5)
                clr.l   4(a5)
                jsr     (AllocateObject).l
                bne.s   loc_55420
                move.l  #loc_556F8,(a1)
                jsr     (CreateNewSprite4).l
                bne.s   loc_55420
                move.l  #loc_55732,(a1)
                move.w  a1,(a5)+
                moveq   #2,d1

loc_553F0:
                jsr     (CreateNewSprite4).l
                bne.s   loc_55420
                move.l  #loc_5577C,(a1)
                move.w  d1,$2E(a1)
                move.w  a1,(a5)+
                jsr     (CreateNewSprite4).l
                bne.s   loc_55420
                move.l  #loc_5577C,(a1)
                move.w  d1,$2E(a1)
                st      $30(a1)
                move.w  a1,(a5)+
                dbf     d1,loc_553F0

loc_55420:
                addq.w  #4,(Events_routine_bg).w

loc_55424:
                tst.w   (Events_fg_5).w
                bpl.s   loc_55486
                move.w  #$180,(Draw_delayed_position).w
                move.w  #2,(Draw_delayed_rowcount).w
                addq.w  #4,(Events_routine_bg).w

loc_5543A:
                moveq   #0,d1
                move.w  #$180,d2
                jsr     Draw_PlaneVertTopDown(pc)
                bpl.s   loc_55486
                clr.b   (Events_bg+$01).w
                move.w  #$280,(Draw_delayed_position).w
                move.w  #2,(Draw_delayed_rowcount).w
                addq.w  #4,(Events_routine_bg).w

loc_5545A:
                move.w  #$4080,d1
                move.w  #$280,d2
                lea     (Level_layout_main).w,a3
                move.w  #VRAM_Plane_A_Name_Table,d7
                jsr     Draw_PlaneVertTopDown(pc)
                addq.w  #2,a3
                move.w  #VRAM_Plane_B_Name_Table,d7
                tst.w   (Draw_delayed_rowcount).w
                bpl.s   loc_55486
                clr.b   (Events_bg+$00).w
                clr.w   (Events_routine_fg).w
                addq.w  #4,(Events_routine_bg).w

loc_55486:
                jsr     BuildMhz2ChaseBackgroundCoordinates(pc)
                lea     (Camera_Y_pos_BG_copy).w,a6
                lea     (Camera_Y_pos_BG_rounded).w,a5
                moveq   #0,d1
                moveq   #$20,d6
                jsr     Draw_TileRow(pc)
                jsr     ComposeMhz2ShipAndBossPerspectiveScroll(pc)
                cmpi.w  #$10,(Events_routine_fg).w
                bne.s   loc_554B4
                move.w  (_unkEE9C).w,(V_scroll_value).w
                move.w  (Camera_Y_pos_BG_copy).w,(V_scroll_value_BG).w
                addq.w  #4,sp

loc_554B4:
                jmp     ShakeScreen_Setup(pc)

; =============== S U B R O U T I N E =======================================

BuildMhz2ChaseBackgroundCoordinates:
                move.w  (Camera_Y_pos_copy).w,d0
                subi.w  #$280,d0
                swap    d0
                clr.w   d0
                asr.l   #3,d0
                move.l  d0,d1
                asr.l   #2,d1
                add.l   d1,d0
                swap    d0
                addi.w  #$180,d0
                move.w  d0,(Camera_Y_pos_BG_copy).w
                move.w  (Events_fg_1).w,d0
                move.w  (Screen_shake_offset).w,d2
                sub.w   d2,d0
                swap    d0
                clr.w   d0
                asr.l   #1,d0
                move.l  d0,d1
                asr.l   #2,d1
                sub.l   d1,d0
                asr.l   #1,d1
                swap    d0
                add.w   d2,d0
                move.w  d0,(Camera_X_pos_BG_copy).w
                swap    d0
                sub.l   d1,d0
                swap    d0
                move.w  d0,(Events_bg+$10).w
                swap    d0
                sub.l   d1,d0
                swap    d0
                move.w  d0,(Events_bg+$12).w
                rts
; End of function BuildMhz2ChaseBackgroundCoordinates

; =============== S U B R O U T I N E =======================================

ComposeMhz2ShipAndBossPerspectiveScroll:
                jsr     PlainDeformation(pc)
                cmpi.w  #$10,(Events_routine_fg).w
                bne.s   loc_55534
                lea     (H_scroll_buffer).w,a1
                move.w  (HScroll_table).w,d0
                neg.w   d0
                moveq   #$40-1,d1

loc_55524:
                move.w  d0,(a1)
                addq.w  #4,a1
                move.w  d0,(a1)
                addq.w  #4,a1
                dbf     d1,loc_55524
                bra.w   locret_5560A
; ---------------------------------------------------------------------------

loc_55534:
                tst.b   (Events_bg+$00).w
                beq.s   loc_55552
                lea     (H_scroll_buffer).w,a1
                move.w  (Camera_X_pos_BG_copy).w,d0
                neg.w   d0
                moveq   #$18-1,d1

loc_55546:
                move.w  d0,(a1)
                addq.w  #4,a1
                move.w  d0,(a1)
                addq.w  #4,a1
                dbf     d1,loc_55546

loc_55552:
                tst.b   (Events_bg+$01).w
                beq.w   locret_5560A
                move.w  (Camera_X_pos).w,d0
                subi.w  #$4180,d0
                cmpi.w  #-$140,d0
                blt.w   loc_555FC
                move.w  d0,d1
                muls.w  #$5600,d1
                add.l   d1,d1
                swap    d1
                sub.w   d1,d0
                subi.w  #$18,d0
                swap    d0
                clr.w   d0
                tst.l   d0
                smi     d3
                bpl.s   loc_55586
                neg.l   d0

loc_55586:
                moveq   #0,d2
                swap    d0
                move.w  d0,d2
                divu.w  #$30,d2
                move.w  d2,d1
                swap    d0
                move.w  d0,d2
                divu.w  #$30,d2
                swap    d1
                move.w  d2,d1
                tst.b   d3
                beq.s   loc_555A4
                neg.l   d1

loc_555A4:
                lea     (H_scroll_buffer+2).w,a1
                move.w  (Camera_X_pos_copy).w,d0
                subi.w  #$80,d0
                neg.w   d0
                swap    d0
                clr.w   d0
                moveq   #$30-1,d2

loc_555B8:
                swap    d0
                move.w  d0,(a1)
                swap    d0
                add.l   d1,d0
                addq.w  #4,a1
                dbf     d2,loc_555B8
                lea     (HScroll_table+$008).w,a1
                lea     (H_scroll_buffer+$BE).w,a5
                moveq   #$1C,d0
                moveq   #7-1,d1

loc_555D2:
                move.w  (a1)+,d2
                beq.s   locret_5560A
                movea.w d2,a6
                move.w  (a5),d2
                subi.w  #$48,d2
                andi.w  #$1FF,d2
                add.w   (Camera_X_pos).w,d2
                move.w  d2,$10(a6)
                btst    #0,d1
                bne.s   loc_555F6
                suba.w  d0,a5
                addi.w  #$C,d0

loc_555F6:
                dbf     d1,loc_555D2
                bra.s   locret_5560A
; ---------------------------------------------------------------------------

loc_555FC:
                lea     (H_scroll_buffer+2).w,a1
                moveq   #$30-1,d0

loc_55602:
                clr.w   (a1)
                addq.w  #4,a1
                dbf     d0,loc_55602

locret_5560A:
                rts
; End of function ComposeMhz2ShipAndBossPerspectiveScroll

; ---------------------------------------------------------------------------

loc_5560C:
                clr.w   (Level_repeat_offset).w
                move.w  (Camera_X_pos).w,d0
                addq.w  #4,d0
                cmpi.w  #3,(Player_mode).w
                bne.s   loc_55620
                addq.w  #1,d0

loc_55620:
                cmpi.w  #$4280,d0
                blo.s   loc_5569A
                tst.w   (Events_fg_5).w
                beq.s   loc_5564A
                st      (Events_fg_5).w
                cmpi.w  #$4420,d0
                blo.s   loc_5569A
                move.w  #$4420,d0
                move.w  #$45A0,(Camera_max_X_pos).w
                st      (Scroll_lock).w
                clr.w   (Special_events_routine).w
                bra.s   loc_5569E
; ---------------------------------------------------------------------------

loc_5564A:
                move.w  #$200,d1
                move.w  d1,(Level_repeat_offset).w
                sub.w   d1,(Player_1+x_pos).w
                sub.w   d1,(Player_2+x_pos).w
                sub.w   d1,d0
                move.w  d0,d1
                andi.w  #$FFF0,d1
                subi.w  #$10,d1
                move.w  d1,(Camera_X_pos_rounded).w
                addq.w  #1,(Events_bg+$08).w
                move.w  (Events_bg+$08).w,d1
                andi.w  #$F,d1
                lea     word_558E8(pc),a1
                cmpi.w  #3,(Player_mode).w
                bne.s   loc_55686
                lea     $10(a1),a1

loc_55686:
                move.b  (a1,d1.w),(Events_bg+$07).w
                tst.b   (_unkFAA9).w
                beq.s   loc_5569A
                st      (Events_bg+$0A).w
                clr.b   (_unkFAA9).w

loc_5569A:
                move.w  d0,(Camera_max_X_pos).w

loc_5569E:
                move.w  d0,(Camera_X_pos).w
                move.w  d0,(Camera_X_pos_copy).w
                move.w  d0,(Camera_min_X_pos).w
                move.w  d0,d1
                lea     (Player_1).w,a1
                bsr.s   ClampPlayerToMhz2ChaseWindow
                move.w  d1,d0
                lea     (Player_2).w,a1

; =============== S U B R O U T I N E =======================================

ClampPlayerToMhz2ChaseWindow:
                cmpi.b  #5,anim(a1)
                bne.s   loc_556C4
                clr.b   anim(a1)

loc_556C4:
                addi.w  #$18,d0
                cmp.w   x_pos(a1),d0
                bls.s   loc_556E8
                move.w  d0,x_pos(a1)
                move.w  #$400,ground_vel(a1)
                cmpi.w  #3,(Player_mode).w
                bne.s   locret_556F6
                move.w  #$500,ground_vel(a1)
                bra.s   locret_556F6
; ---------------------------------------------------------------------------

loc_556E8:
                addi.w  #$A8,d0
                cmp.w   x_pos(a1),d0
                bhi.s   locret_556F6
                move.w  d0,x_pos(a1)

locret_556F6:
                rts
; End of function ClampPlayerToMhz2ChaseWindow

; ---------------------------------------------------------------------------

loc_556F8:
                move.l  #loc_5576A,(a0)
                move.b  #4,render_flags(a0)
                move.b  #$18,height_pixels(a0)
                move.b  #$18,width_pixels(a0)
                move.w  #$80,priority(a0)
                move.w  #make_art_tile(ArtTile_MHZEndBossPillar,3,1),art_tile(a0)
                move.l  #Map_MHZEndBossMisc,mappings(a0)
                move.w  #$4238,x_pos(a0)
                move.w  #$2F0,y_pos(a0)
                bra.s   loc_5576A
; ---------------------------------------------------------------------------

loc_55732:
                move.l  #loc_5576A,(a0)
                move.b  #$44,render_flags(a0)
                move.b  #$80,height_pixels(a0)
                move.b  #$C,width_pixels(a0)
                move.w  #$380,priority(a0)
                move.w  #make_art_tile(ArtTile_MHZEndBossPillar,3,0),art_tile(a0)
                move.l  #Map_MHZEndBossMisc,mappings(a0)
                move.w  #$300,y_pos(a0)
                move.b  #1,mapping_frame(a0)

loc_5576A:
                tst.b   (Events_bg+$01).w
                bne.s   loc_55776
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_55776:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_5577C:
                move.l  #loc_557C8,(a0)
                move.b  #$44,render_flags(a0)
                move.b  #$10,height_pixels(a0)
                move.b  #$10,width_pixels(a0)
                move.w  #make_art_tile(ArtTile_MHZEndBossSpikes,1,0),art_tile(a0)
                move.l  #Map_MHZEndBossMisc,mappings(a0)
                move.b  #$8B,collision_flags(a0)
                move.w  #$80,d0
                moveq   #4,d1
                move.w  $2E(a0),d2
                subq.w  #1,d2
                bcs.s   loc_557C0

loc_557B6:
                addi.w  #$80,d0
                subq.w  #1,d1
                dbf     d2,loc_557B6

loc_557C0:
                move.w  d0,priority(a0)
                move.b  d1,mapping_frame(a0)

loc_557C8:
                tst.w   (Events_bg+$0A).w
                bne.s   loc_557D4
                tst.b   (Events_bg+$01).w
                bne.s   loc_557DA

loc_557D4:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_557DA:
                move.w  (Events_bg+$06).w,d0
                tst.w   $30(a0)
                beq.s   loc_557EC
                cmpi.w  #4,d0
                bne.s   locret_55812
                moveq   #0,d0

loc_557EC:
                lsl.w   #2,d0
                add.w   $2E(a0),d0
                add.w   d0,d0
                lea     word_558C2(pc),a1
                move.w  (a1,d0.w),y_pos(a0)
                jsr     (Draw_Sprite).l
                cmpi.w  #1,$2E(a0)
                bne.s   locret_55812
                jmp     (Add_SpriteToCollisionResponseList).l
; ---------------------------------------------------------------------------

locret_55812:
                rts
; ---------------------------------------------------------------------------

loc_55814:
                move.l  #loc_5582E,(a0)
                move.w  #$380,priority(a0)
                move.w  #make_art_tile(ArtTile_MHZShipPropeller,1,1),art_tile(a0)
                move.l  #Map_MHZEndBossMisc,mappings(a0)

loc_5582E:
                lea     Ani_MHZEndPropellers(pc),a1
                jsr     (Animate_Sprite).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_5583E:
                addq.b  #1,$3C(a0)
                addi.l  #$C0,$38(a0)
                move.l  $38(a0),d0
                sub.l   d0,(_unkEE98).w
                tst.w   (Events_fg_4).w
                beq.s   loc_55876
                cmpi.l  #$2800,$2E(a0)
                bne.s   loc_55876
                move.w  $32(a0),d0
                move.b  $3C(a0),d1
                andi.w  #3,d1
                bne.s   loc_55888
                addq.w  #1,$32(a0)
                bra.s   loc_55888
; ---------------------------------------------------------------------------

loc_55876:
                move.l  #$2800,d0
                move.l  #$C0,d1
                jsr     (Gradual_SwingOffset).l

loc_55888:
                add.w   (_unkEEA2).w,d0
                addq.w  #5,d0
                move.w  d0,(_unkEE9C).w
                tst.b   (_unkFAA9).w
                bne.s   loc_558AC
                cmpi.w  #-$3E6,(_unkEE98).w
                bgt.s   loc_558AC
                st      (_unkFAA9).w
                st      (Events_fg_4).w
                st      (Scroll_lock).w

loc_558AC:
                move.w  (Level_frame_counter).w,d0
                subq.w  #1,d0
                andi.w  #$F,d0
                bne.s   locret_558C0
                moveq   #signextendB(sfx_LargeShip),d0
                jsr     (Play_SFX).l

locret_558C0:
                rts
; ---------------------------------------------------------------------------
word_558C2:
                dc.w    $336
                dc.w    $334
                dc.w    $333
                dc.w    0
                dc.w    $320
                dc.w    $320
                dc.w    $320
                dc.w    0
                dc.w    $2F6
                dc.w    $2F8
                dc.w    $2FA
                dc.w    0
                dc.w    $2C9
                dc.w    $2CF
                dc.w    $2D4
                dc.w    0
                dc.w    $2C9
                dc.w    $2CF
                dc.w    $2D4
word_558E8:
                dc.w    $102
                dc.w    2
                dc.w    $102
                dc.w    $100
                dc.w    $200
                dc.w    $102
                dc.w    $102
                dc.w    $200
                dc.w    $102
                dc.w    3
                dc.w    $104
                dc.w    $200
                dc.w    $401
                dc.w    $304
                dc.w    $200
                dc.w    $402
Map_MHZEndBossMisc:
                include "src/objects/shared/zones/mhz/boss/mappings/misc.s"
Ani_MHZEndPropellers:
                include "src/objects/shared/zones/mhz/animations/end_propellers.s"
