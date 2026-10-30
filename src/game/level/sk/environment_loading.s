; Owner: game/level/sk
; Responsibility: Per-level descriptor loading, water applicability and underwater palette selection
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

LoadLevelLoadBlock:
                move.w  (Current_zone_and_act).w,d0
                bne.s   loc_782A
                cmpi.w  #2,(Player_mode).w
                bhs.s   loc_7826
                tst.b   (Last_star_post_hit).w
                beq.s   loc_782A

loc_7826:
                move.w  #$D00,d0

loc_782A:
                ror.b   #1,d0
                lsr.w   #4,d0
                andi.w  #$1F8,d0
                move.w  d0,d1
                add.w   d0,d0
                add.w   d1,d0
                lea     (LevelLoadBlock).l,a4
                lea     (a4,d0.w),a4
                move.l  (a4)+,d0
                andi.l  #$FFFFFF,d0
                move.l  d0,d7
                movea.l d0,a1
                move.w  (a1),d4
                move.w  #0,d2
                jsr     (Queue_Kos_Module).l
                move.l  (a4)+,d0
                andi.l  #$FFFFFF,d0
                cmp.l   d0,d7
                beq.s   loc_7870
                movea.l d0,a1
                move.w  d4,d2
                jsr     (Queue_Kos_Module).l

loc_7870:
                move.b  #VInt_ID_C,(V_int_routine).w
                jsr     (Process_Kos_Queue).l
                bsr.w   Wait_VSync
                bsr.w   Process_Nem_Queue_Init
                jsr     (Process_Kos_Module_Queue).l
                tst.b   (Kos_modules_left).w
                bne.s   loc_7870
                rts
; End of function LoadLevelLoadBlock

; =============== S U B R O U T I N E =======================================

CheckLevelForWater:
                cmpi.w  #0,(Current_zone_and_act).w
                beq.s   loc_78F2
                cmpi.w  #1,(Current_zone_and_act).w
                bne.s   loc_78B2
                cmpi.w  #1,(Apparent_zone_and_act).w
                bne.s   loc_78F2
                cmpi.w  #3,(Player_mode).w
                bne.s   loc_78F2

loc_78B2:
                cmpi.b  #1,(Current_zone).w
                beq.s   loc_78F2
                cmpi.w  #$301,(Current_zone_and_act).w
                bne.s   loc_78CA
                cmpi.w  #3,(Player_mode).w
                bne.s   loc_78F2

loc_78CA:
                cmpi.w  #$501,(Current_zone_and_act).w
                beq.s   loc_78F2
                cmpi.w  #$601,(Current_zone_and_act).w
                beq.s   loc_78F2
                move.w  #$1000,d0
                move.w  d0,(Water_level).w
                move.w  d0,(Mean_water_level).w
                move.w  d0,(Target_water_level).w
                move.b  #0,(Water_flag).w
                rts
; ---------------------------------------------------------------------------

loc_78F2:
                move.b  #1,(Water_flag).w
                move.w  #0,(Competition_mode).w
                tst.b   (Water_flag).w
                beq.s   LoadWaterPalette
                move.w  #$4EF9,(H_int_jump).w
                move.l  #HInt2,(H_int_addr).w
                cmpi.b  #1,(Current_zone).w
                beq.s   loc_7932
                move.l  #HInt3,(H_int_addr).w
                cmpi.w  #$1000,(V_blank_cycles).w
                blo.s   loc_7932
                move.l  #HInt4,(H_int_addr).w

loc_7932:
                move.l  #WaterTransition_AIZ1,(Water_palette_data_addr).w
                moveq   #0,d0
                move.w  (Current_zone_and_act).w,d0
                ror.b   #1,d0
                lsr.w   #6,d0
                andi.w  #$FFFE,d0
                lea     (StartingWaterHeights).l,a1
                move.w  (a1,d0.w),d0
                move.w  d0,(Water_level).w
                move.w  d0,(Mean_water_level).w
                move.w  d0,(Target_water_level).w
                clr.b   (Water_entered_counter).w
                clr.b   (Water_full_screen_flag).w
                move.b  #1,(Water_speed).w
; End of function CheckLevelForWater

; =============== S U B R O U T I N E =======================================

LoadWaterPalette:
                tst.b   (Water_flag).w
                beq.w   locret_7A20
                moveq   #PalID_AIZ_Water,d0
                cmpi.w  #0,(Current_zone_and_act).w
                beq.w   loc_7A00
                moveq   #PalID_AIZ2_Water,d0
                move.l  #WaterTransition_AIZ2,(Water_palette_data_addr).w
                cmpi.w  #1,(Current_zone_and_act).w
                beq.s   loc_7A00
                moveq   #PalID_HCZ1_Water,d0
                move.l  #WaterTransition_HCZLBZ1,(Water_palette_data_addr).w
                cmpi.w  #$100,(Current_zone_and_act).w
                beq.s   loc_7A00
                moveq   #PalID_HCZ2_Water,d0
                move.l  #WaterTransition_HCZLBZ1,(Water_palette_data_addr).w
                cmpi.w  #$101,(Current_zone_and_act).w
                beq.s   loc_7A00
                moveq   #PalID_CNZ_Water,d0
                move.l  #WaterTransition_CNZ2ICZ2,(Water_palette_data_addr).w
                cmpi.w  #$301,(Current_zone_and_act).w
                beq.s   loc_7A00
                moveq   #PalID_ICZ2_Water,d0
                move.l  #WaterTransition_CNZ2ICZ2,(Water_palette_data_addr).w
                cmpi.w  #$501,(Current_zone_and_act).w
                beq.s   loc_7A00
                moveq   #PalID_LBZ_Water,d0
                move.l  #WaterTransition_HCZLBZ1,(Water_palette_data_addr).w
                cmpi.w  #$600,(Current_zone_and_act).w
                beq.s   loc_7A00
                moveq   #PalID_LBZ2_Water,d0
                move.l  #WaterTransition_LBZ2,(Water_palette_data_addr).w
                cmpi.w  #$601,(Current_zone_and_act).w
                beq.s   loc_7A00
                nop

loc_7A00:
                move.w  d0,d1
                bsr.w   LoadPalette2
                move.w  d1,d0
                bsr.w   LoadPalette2_Immediate
                tst.b   (Last_star_post_hit).w
                beq.s   loc_7A18
                move.b  (Saved_water_full_screen_flag).w,(Water_full_screen_flag).w

loc_7A18:
                cmpi.w  #3,(Player_mode).w
                beq.s   loc_7A22

locret_7A20:
                rts
; ---------------------------------------------------------------------------

loc_7A22:
                moveq   #0,d0
                move.b  (Current_zone).w,d0
                move.w  d0,d1
                add.w   d0,d0
                add.w   d1,d0
                add.w   d0,d0
                lea     Pal_WaterKnux(pc,d0.w),a1
                move.l  (a1),(Water_palette+$4).w
                move.w  4(a1),(Water_palette+$8).w
                move.l  (a1),(Target_water_palette+$4).w
                move.w  4(a1),(Target_water_palette+$8).w
                rts
; End of function LoadWaterPalette

; ---------------------------------------------------------------------------
Pal_WaterKnux:
                binclude "data/Levels/Misc/Palettes/Water Knuckles Patch.bin"
                even
; ---------------------------------------------------------------------------
