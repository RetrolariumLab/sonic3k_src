; Owner: game/level/zones/lrz/sk
; Responsibility: Lava Reef act-two screen and background initialization, event dispatch and deformation
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

LRZ2_ScreenInit:
                jsr     (Reset_TileOffsetPositionActual).l
                jmp     (Refresh_PlaneFull).l
; ---------------------------------------------------------------------------

LRZ2_ScreenEvent:
                move.w  (Screen_shake_offset).w,d0
                add.w   d0,(Camera_Y_pos_copy).w
                jmp     (DrawTilesAsYouMove).l
; ---------------------------------------------------------------------------

LRZ2_BackgroundInit:
                jsr     (AllocateObject).l
                bne.s   loc_56FD2
                move.l  #loc_5711E,(a1)
                move.w  a1,(Events_bg+$06).w

loc_56FD2:
                move.w  #8,(Events_routine_bg).w
                jsr     BuildLrz2ParallaxAndPositionDeathEggBackdrop(pc)
                jsr     (Reset_TileOffsetPositionEff).l
                moveq   #0,d1
                jsr     (Refresh_PlaneFull).l
                lea     LRZ2_BGDeformArray(pc),a4
                lea     (HScroll_table).w,a5
                jmp     (ApplyDeformation).l
; ---------------------------------------------------------------------------

LRZ2_BackgroundEvent:
                move.w  (Events_routine_bg).w,d0
                jmp     LRZ2_BackgroundEvent_Index(pc,d0.w)
; ---------------------------------------------------------------------------

LRZ2_BackgroundEvent_Index:
                bra.w   loc_5700C
; ---------------------------------------------------------------------------
                bra.w   loc_57040
; ---------------------------------------------------------------------------
                bra.w   loc_57058
; ---------------------------------------------------------------------------

loc_5700C:
                jsr     (AllocateObject).l
                bne.s   loc_5701E
                move.l  #loc_5711E,(a1)
                move.w  a1,(Events_bg+$06).w

loc_5701E:
                jsr     BuildLrz2ParallaxAndPositionDeathEggBackdrop(pc)
                jsr     (Reset_TileOffsetPositionEff).l
                addi.w  #$E0,d0
                and.w   (Camera_Y_pos_mask).w,d0
                move.w  d0,(Draw_delayed_position).w
                move.w  #$F,(Draw_delayed_rowcount).w
                addq.w  #4,(Events_routine_bg).w
                bra.s   loc_57044
; ---------------------------------------------------------------------------

loc_57040:
                jsr     BuildLrz2ParallaxAndPositionDeathEggBackdrop(pc)

loc_57044:
                moveq   #0,d1
                move.w  (Camera_Y_pos_BG_copy).w,d2
                jsr     (Draw_PlaneVertBottomUp).l
                bpl.s   loc_5705C
                addq.w  #4,(Events_routine_bg).w
                bra.s   loc_5705C
; ---------------------------------------------------------------------------

loc_57058:
                jsr     BuildLrz2ParallaxAndPositionDeathEggBackdrop(pc)

loc_5705C:
                lea     (Camera_Y_pos_BG_copy).w,a6
                lea     (Camera_Y_pos_BG_rounded).w,a5
                moveq   #0,d1
                moveq   #$20,d6
                jsr     (Draw_TileRow).l
                lea     LRZ2_BGDeformArray(pc),a4
                lea     (HScroll_table).w,a5
                jsr     (ApplyDeformation).l
                jmp     (ShakeScreen_Setup).l

; =============== S U B R O U T I N E =======================================

BuildLrz2ParallaxAndPositionDeathEggBackdrop:
                move.w  (Camera_Y_pos_copy).w,d0
                move.w  (Screen_shake_offset).w,d1
                sub.w   d1,d0
                swap    d0
                clr.w   d0
                asr.l   #3,d0
                move.l  d0,d2
                asr.l   #2,d2
                sub.l   d2,d0
                swap    d0
                add.w   d1,d0
                move.w  d0,(Camera_Y_pos_BG_copy).w
                move.w  (Camera_X_pos_copy).w,d0
                swap    d0
                clr.w   d0
                asr.l   #3,d0
                move.l  d0,d1
                move.l  d0,d2
                asr.l   #2,d0
                swap    d1
                move.w  d1,(Camera_X_pos_BG_copy).w
                swap    d1
                sub.l   d0,d1
                swap    d1
                move.w  d1,(Events_bg+$10).w
                swap    d1
                sub.l   d0,d1
                swap    d1
                move.w  d1,(Events_bg+$12).w
                lea     (HScroll_table+$010).w,a1
                move.l  d2,d1
                moveq   #8-1,d3

loc_570D2:
                swap    d1
                move.w  d1,-(a1)
                swap    d1
                add.l   d0,d1
                dbf     d3,loc_570D2
                lea     (HScroll_table+$010).w,a1
                add.l   d0,d2
                add.l   d0,d0
                moveq   #5-1,d3

loc_570E8:
                swap    d2
                move.w  d2,(a1)+
                swap    d2
                add.l   d0,d2
                dbf     d3,loc_570E8
                move.w  (Events_bg+$06).w,d0
                beq.s   locret_5711C
                movea.w d0,a1
                move.w  #$678,d0
                sub.w   (HScroll_table+$004).w,d0
                cmpi.w  #-$7E0,d0
                ble.s   loc_5710C
                moveq   #0,d0

loc_5710C:
                move.w  d0,$10(a1)
                move.w  #$C0,d0
                sub.w   (Camera_Y_pos_BG_copy).w,d0
                move.w  d0,$14(a1)

locret_5711C:
                rts
; End of function BuildLrz2ParallaxAndPositionDeathEggBackdrop

; ---------------------------------------------------------------------------

loc_5711E:
                cmpi.w  #3,(Player_mode).w
                bne.s   loc_57130
                clr.w   (Events_bg+$06).w
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_57130:
                move.l  #loc_57156,(a0)
                move.b  #$40,height_pixels(a0)
                move.b  #$50,width_pixels(a0)
                move.w  #$380,priority(a0)
                move.w  #make_art_tile(ArtTile_LRZ2DeathEggBG,3,0),art_tile(a0)
                move.l  #Map_LRZ2DeathEggBG,mappings(a0)

loc_57156:
                tst.w   $2E(a0)
                bne.s   loc_57176
                tst.w   x_pos(a0)
                beq.s   locret_57182
                lea     (ArtKosM_LRZ2DeathEggBG).l,a1
                move.w  #tiles_to_bytes(ArtTile_LRZ2DeathEggBG),d2
                jsr     (Queue_Kos_Module).l
                st      $2E(a0)

loc_57176:
                tst.w   x_pos(a0)
                beq.s   locret_57182
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

locret_57182:
                rts
; ---------------------------------------------------------------------------
LRZ2_BGDeformArray:
                dc.w    $20,   $20,   $20,   $10,   $10,   $10,   $10,   $F0,   $10,   $10,   $10,   $20, $7FFF
Map_LRZ2DeathEggBG:
                include "src/objects/shared/zones/lrz/act2/mappings/bg_death_egg.s"
