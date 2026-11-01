; Owner: game/level/zones/hpz/sk
; Responsibility: Hidden Palace special screen and background initialization and event state
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

HPZS_ScreenInit:
                tst.b   (Chaos_emerald_count).w
                beq.s   loc_5AA14
                move.b  (Current_special_stage).w,d0
                ori.b   #$80,d0
                move.b  d0,(HPZ_current_special_stage).w

loc_5AA14:
                movea.w $10(a3),a1
                clr.b   $29(a1)
                clr.b   $2B(a1)
                movea.w $14(a3),a1
                clr.b   $29(a1)
                jsr     (Reset_TileOffsetPositionActual).l
                jmp     (Refresh_PlaneFull).l
; ---------------------------------------------------------------------------

HPZS_ScreenEvent:
                move.w  (Screen_shake_offset).w,d0
                add.w   d0,(Camera_Y_pos_copy).w
                jmp     (DrawTilesAsYouMove).l
; ---------------------------------------------------------------------------

HPZS_BackgroundInit:
                jsr     BuildHpzRightRegionParallax(pc)
                jsr     (Reset_TileOffsetPositionEff).l
                lea     (HScroll_table).w,a1
                move.w  (a1)+,(a1)
                andi.w  #$FFF0,(a1)+
                move.w  (a1)+,(a1)
                andi.w  #$FFF0,(a1)
                lea     HPZ_BGDrawArray(pc),a4
                lea     (HScroll_table).w,a5
                jsr     (Refresh_PlaneTileDeform).l
                lea     HPZ_BGDeformArray(pc),a4
                lea     (HScroll_table+$008).w,a5
                jmp     (ApplyDeformation).l
; ---------------------------------------------------------------------------

HPZS_BackgroundEvent:
                jsr     BuildHpzRightRegionParallax(pc)
                lea     HPZ_BGDrawArray(pc),a4
                lea     (HScroll_table).w,a5
                moveq   #$20,d6
                moveq   #2,d5
                jsr     (Draw_BG).l
                lea     HPZ_BGDeformArray(pc),a4
                lea     (HScroll_table+$008).w,a5
                jsr     (ApplyDeformation).l
                jmp     (ShakeScreen_Setup).l
; End of function HPZS_ScreenInit
