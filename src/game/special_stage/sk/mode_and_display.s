; Owner: game/special_stage/sk
; Responsibility: Special stage entry, layout preparation, active mode loop and palette/map display updates
; Source provenance and ranges: config/reconstruction/source_layout.json
SpecialStage:
                moveq   #signextendB(cmd_Stop),d0
                bsr.w   Play_Music
                clr.w   (Kos_decomp_queue_count).w
                clearRAM Kos_decomp_stored_registers,(Kos_decomp_module_end-Kos_decomp_stored_registers)
                bsr.w   Clear_Nem_Queue
                bsr.w   Pal_FadeToWhite
                move    #$2700,sr
                lea     (VDP_control_port).l,a6
                move.w  #$8004,(a6)
                move.w  #$8230,(a6)
                move.w  #$8407,(a6)
                move.w  #$9001,(a6)
                move.w  #$9200,(a6)
                move.w  #$8B00,(a6)
                move.w  #$8720,(a6)
                clr.b   (Water_full_screen_flag).w
                move.w  #$8C81,(a6)
                bsr.w   Clear_DisplayData
                clearRAM Sprite_table_input,(Sprite_table_input_end-Sprite_table_input)
                clearRAM Object_RAM,(Kos_decomp_buffer-Object_RAM)
                clearRAM Oscillating_table,(AIZ_vine_angle-Oscillating_table)
                clearRAM Stat_table,(Pos_table-Stat_table)
                moveq   #0,d0
                move.l  d0,(LRZ_rocks_addr_front).w
                move.l  d0,(LRZ_rocks_addr_back).w
                jsr     (Init_SpriteTable).l
                clr.w   (DMA_queue).w
                move.l  #DMA_queue,(DMA_queue_slot).w
                lea     (Pal_SStage_Main).l,a1
                lea     (Target_palette).w,a2
                move.w  #bytesToWcnt(Target_palette_end-Target_palette),d0

loc_8284:
                move.w  (a1)+,(a2)+
                dbf     d0,loc_8284
                cmpi.w  #3,(Player_mode).w
                bne.s   loc_82A6
                lea     (Pal_SStage_Knux).l,a1
                lea     (Target_palette+$10).w,a2
                move.w  #bytesToWcnt($10),d0

loc_82A0:
                move.w  (a1)+,(a2)+
                dbf     d0,loc_82A0

loc_82A6:
                move.l  #vdpComm(tiles_to_bytes($000),VRAM,WRITE),(VDP_control_port).l
                lea     (ArtNem_SStageLayout).l,a0
                bsr.w   Nem_Decomp
                bsr.w   sub_85B0
                lea     (RAM_start+$5500).l,a1
                lea     (MapEni_SStageLayout).l,a0
                move.w  #make_art_tile($000,0,0),d0
                bsr.w   Eni_Decomp
                lea     (RAM_start+$5500).l,a1
                move.l  #vdpComm(VRAM_Plane_A_Name_Table,VRAM,WRITE),d0
                moveq   #40-1,d1
                moveq   #28-1,d2
                jsr     (Plane_Map_To_VRAM).l
                move.l  #vdpComm(tiles_to_bytes(ArtTile_SStage_Sphere),VRAM,WRITE),(VDP_control_port).l
                lea     (ArtNem_SStageSphere).l,a0
                bsr.w   Nem_Decomp
                move.l  #vdpComm(tiles_to_bytes(ArtTile_SStage_Ring),VRAM,WRITE),(VDP_control_port).l
                lea     (ArtNem_SStageRing).l,a0
                bsr.w   Nem_Decomp
                move.l  #vdpComm(tiles_to_bytes(ArtTile_SStage_BG),VRAM,WRITE),(VDP_control_port).l
                lea     (ArtNem_SStageBG).l,a0
                bsr.w   Nem_Decomp
                move.l  #vdpComm(tiles_to_bytes(ArtTile_SStage_GetBlueSpheres),VRAM,WRITE),(VDP_control_port).l
                lea     (ArtNem_GetBlueSpheres).l,a0
                bsr.w   Nem_Decomp
                move.l  #vdpComm(tiles_to_bytes(ArtTile_SStage_GetBlueSpheres+$199),VRAM,WRITE),(VDP_control_port).l
                lea     (ArtNem_GBSArrow).l,a0
                bsr.w   Nem_Decomp
                move.l  #vdpComm(tiles_to_bytes(ArtTile_SStage_Digits),VRAM,WRITE),(VDP_control_port).l
                lea     (ArtNem_SStageDigits).l,a0
                bsr.w   Nem_Decomp
                lea     (ArtNem_SStageDigits).l,a0
                lea     (H_scroll_buffer+$20).w,a4
                bsr.w   Nem_Decomp_To_RAM
                move.l  #vdpComm(tiles_to_bytes(ArtTile_SStage_Icons),VRAM,WRITE),(VDP_control_port).l
                lea     (ArtNem_SStageIcons).l,a0
                bsr.w   Nem_Decomp
                move.l  #vdpComm(tiles_to_bytes(ArtTile_SStage_Shadow),VRAM,WRITE),(VDP_control_port).l
                lea     (ArtNem_SStageShadow).l,a0
                bsr.w   Nem_Decomp
                lea     (MapUnc_SSNum000).l,a1
                move.l  #vdpComm(VRAM_Plane_A_Name_Table+$084,VRAM,WRITE),d0
                moveq   #8-1,d1
                moveq   #3-1,d2
                jsr     (Plane_Map_To_VRAM).l
                lea     (MapUnc_SSNum000).l,a1
                move.l  #vdpComm(VRAM_Plane_A_Name_Table+$0BC,VRAM,WRITE),d0
                moveq   #8-1,d1
                moveq   #3-1,d2
                jsr     (Plane_Map_To_VRAM).l
                lea     (RAM_start).l,a1
                lea     (MapEni_SStageBG).l,a0
                move.w  #make_art_tile(ArtTile_SStage_BG,2,0),d0
                bsr.w   Eni_Decomp
                lea     (RAM_start).l,a1
                move.l  #vdpComm(VRAM_Plane_B_Name_Table,VRAM,WRITE),d0
                moveq   #64-1,d1
                moveq   #32-1,d2
                jsr     (Plane_Map_To_VRAM).l
                lea     (SStageKos_PerspectiveMaps).l,a0
                lea     (RAM_start).l,a1
                bsr.w   Kos_Decomp
                bsr.w   sub_9EA0
                bsr.w   Load_SSSprite_Mappings
                clr.b   (Level_started_flag).w
                move.b  #$FF,(Special_stage_sphere_HUD_flag).w
                move.b  #$80,(Special_stage_extra_life_flags).w
                move.w  #$1000,(Special_stage_rate).w
                move.w  #30*60,(Special_stage_rate_timer).w
                tst.b   (Blue_spheres_stage_flag).w
                beq.s   loc_842C
                move.w  #45*60,(Special_stage_rate_timer).w

loc_842C:
                move.w  #0,(Camera_X_pos_copy).w
                move.w  #0,(Camera_Y_pos_copy).w
                move.w  #-1,(Screen_Y_wrap_value).w
                move.l  #Obj_SStage_8FAA,(Player_1).w
                tst.w   (Player_mode).w
                bne.s   loc_8454
                move.l  #Obj_SStage_9212,(Player_2).w

loc_8454:
                move.l  #Obj_SStage_8DF8,(Reserved_object_3).w
                move.l  #Obj_SStage_8E40,(Dynamic_object_RAM).w
                jsr     (Process_Sprites).l
                bsr.w   Animate_SSRings
                bsr.w   Touch_SSSprites
                jsr     (Render_Sprites).l
                jsr     Draw_SSSprites(pc)
                bsr.w   sub_9D5E
                move.b  #1,(Special_stage_fade_timer).w
                move.b  #VInt_ID_1C,(V_int_routine).w
                bsr.w   Wait_VSync
                move.b  #0,(Special_stage_fade_timer).w
                move.w  #$8C89,(VDP_control_port).l
                move.w  #30*60,(Demo_timer).w
                jsr     (GetDemoPtr).l
                moveq   #signextendB(mus_SpecialStage),d0
                bsr.w   Play_Music
                move.w  (VDP_reg_1_command).w,d0
                ori.b   #$40,d0
                move.w  d0,(VDP_control_port).l
                bsr.w   Pal_FadeFromWhite

loc_84C2:
                bsr.w   Pause_Game
                move.b  #VInt_ID_1C,(V_int_routine).w
                jsr     (Process_Kos_Queue).l
                bsr.w   Wait_VSync
                addq.w  #1,(Level_frame_counter).w
                jsr     (Demo_PlayRecord).l
                jsr     (Process_Sprites).l
                bsr.w   Animate_SSRings
                bsr.w   Touch_SSSprites
                jsr     (Render_Sprites).l
                jsr     Draw_SSSprites(pc)
                bsr.w   Draw_SSShadows
                bsr.w   sub_9D5E
                bsr.w   sub_9B62
                bsr.w   Process_Nem_Queue_Init
                jsr     (Process_Kos_Module_Queue).l
                tst.w   (Demo_mode_flag).w
                beq.s   loc_851A
                tst.w   (Demo_timer).w
                beq.s   loc_8522

loc_851A:
                cmpi.b  #GameMode_SpecialStage,(Game_mode).w
                beq.s   loc_84C2

loc_8522:
                tst.w   (Demo_mode_flag).w
                beq.s   loc_852E
                move.b  #GameMode_SegaScreen,(Game_mode).w

loc_852E:
                move.w  #60,(Demo_timer).w
                move.w  #$40-1,(Palette_fade_info).w
                clr.w   (Pal_fade_delay).w

loc_853E:
                move.b  #VInt_ID_1C,(V_int_routine).w
                bsr.w   Wait_VSync
                jsr     (Demo_PlayRecord).l
                jsr     (Process_Sprites).l
                bsr.w   Animate_SSRings
                bsr.w   Touch_SSSprites
                jsr     (Render_Sprites).l
                jsr     Draw_SSSprites(pc)
                bsr.w   sub_9D5E
                bsr.w   sub_9B62
                bsr.w   Process_Nem_Queue_Init
                jsr     (Process_Kos_Module_Queue).l
                subq.w  #1,(Pal_fade_delay).w
                bpl.s   loc_8588
                move.w  #2,(Pal_fade_delay).w
                bsr.w   Pal_ToWhite

loc_8588:
                tst.w   (Demo_timer).w
                bne.s   loc_853E
                rts
; ---------------------------------------------------------------------------
SSLayoutOffs_RAM:
                dc.l    RAM_start+$0000
                dc.l    RAM_start+$0408
                dc.l    RAM_start+$0810
                dc.l    RAM_start+$0C18
                dc.l    RAM_start+$1020
                dc.l    RAM_start+$1428
                dc.l    RAM_start+$1830
                dc.l    RAM_start+$1C38

; =============== S U B R O U T I N E =======================================

sub_85B0:
                tst.b   (Blue_spheres_stage_flag).w
                bne.w   loc_86C8
                lea     (SSCompressedLayoutPtrs).l,a0
                movea.l (a0),a0
                lea     (RAM_start).l,a1
                bsr.w   Kos_Decomp
                lea     (SStageLayoutPtrs).l,a2
                move.b  (Chaos_emerald_count).w,d3
                tst.w   (SK_alone_flag).w
                beq.s   loc_85E4
                lea     (SSLayoutOffs_RAM).l,a2
                moveq   #0,d2
                bra.s   loc_85F4
; ---------------------------------------------------------------------------

loc_85E4:
                move.b  (SK_special_stage_flag).w,d2
                beq.s   loc_85F4
                lea     (SSLayoutOffs_RAM).l,a2
                move.b  (Super_emerald_count).w,d3

loc_85F4:
                tst.b   (Debug_cheat_flag).w
                beq.s   loc_8606
                move.w  (Sound_test_sound).w,d0
                btst    #button_A,(Ctrl_1).w
                bne.s   loc_8630

loc_8606:
                moveq   #0,d0
                move.b  (Current_special_stage).w,d0
                cmpi.b  #7,d3
                bhs.s   loc_8630
                moveq   #5,d1
                lea     (Collected_emeralds_array).w,a1
                add.b   d2,d2

loc_861A:
                cmp.b   (a1,d0.w),d2
                beq.s   loc_8630
                addq.w  #1,d0
                cmpi.w  #7,d0
                blo.s   loc_861A
                moveq   #0,d0
                dbf     d1,loc_861A
                moveq   #7,d0

loc_8630:
                andi.w  #7,d0
                move.b  d0,(Current_special_stage).w
                move.w  d0,d1
                lsl.w   #2,d0
                movea.l (a2,d0.w),a2
                tst.w   (SK_alone_flag).w
                bne.s   loc_8652
                tst.b   (SK_special_stage_flag).w
                bne.s   loc_8652
                adda.l  #LockOnROM_Start,a2

loc_8652:
                lea     (SStage_layout_buffer).w,a3
                moveq   #0,d2
                move.w  #bytesToLcnt($100),d0

loc_865C:
                move.l  d2,(a3)+
                dbf     d0,loc_865C
                move.w  #bytesToLcnt($400),d0

loc_8666:
                move.l  (a2)+,(a3)+
                dbf     d0,loc_8666
                move.w  #bytesToLcnt($100),d0

loc_8670:
                move.l  d2,(a3)+
                dbf     d0,loc_8670
                move.w  (a2)+,(Special_stage_angle).w
                move.w  (a2)+,(Special_stage_X_pos).w
                move.w  (a2)+,(Special_stage_Y_pos).w
                move.w  (a2)+,(Special_stage_rings_left).w
                lsl.w   #4,d1
                lea     (SS_Pal_Map_Ptrs).l,a1
                lea     (Target_palette).w,a2
                movea.l 4(a1,d1.w),a1
                tst.w   (SK_alone_flag).w
                bne.s   loc_86A2
                tst.b   (SK_special_stage_flag).w
                beq.s   loc_86A6

loc_86A2:
                lea     $130(a1),a1

loc_86A6:
                move.l  a1,(Special_stage_palette_addr).w
                move.l  (a1)+,$70(a2)
                move.l  (a1)+,$74(a2)
                move.l  (a1)+,$78(a2)
                move.l  (a1)+,$7C(a2)
                move.l  $10(a1),$50(a2)
                move.w  $14(a1),$54(a2)
                rts
; ---------------------------------------------------------------------------

loc_86C8:
                lea     (SSCompressedLayoutPtrs).l,a0
                movea.l 4(a0),a0
                lea     (RAM_start).l,a1
                bsr.w   Kos_Decomp
                lea     (SStage_layout_buffer).w,a3
                moveq   #0,d2
                move.w  #bytesToLcnt($600),d0

loc_86E6:
                move.l  d2,(a3)+
                dbf     d0,loc_86E6
                move.b  #0,(Current_special_stage).w
                move.w  #$4000,(Special_stage_angle).w
                move.w  #$1000,(Special_stage_X_pos).w
                move.w  #$300,(Special_stage_Y_pos).w
                clr.w   (Special_stage_rings_left).w
                clr.w   (Blue_spheres_difficulty).w
                lea     (Blue_spheres_current_stage).w,a4
                lea     word_87BA(pc),a1
                moveq   #4-1,d7

loc_8716:
                lea     (RAM_start).l,a2
                move.b  (a4)+,d0
                andi.w  #$7F,d0
                moveq   #0,d1
                move.b  (a2,d0.w),d1
                add.w   d1,(Special_stage_rings_left).w
                lea     $80(a2),a2
                moveq   #0,d1
                move.b  (a2,d0.w),d1
                add.w   d1,(Blue_spheres_difficulty).w
                lea     $80(a2),a2
                lsl.w   #8,d0
                lea     (a2,d0.w),a2
                move.w  (a1)+,d3
                move.w  (a1)+,d4
                move.w  (a1)+,d5
                move.w  (a1)+,d0
                lea     (SStage_layout_buffer+$100).w,a3
                lea     (a3,d0.w),a3
                moveq   #$F,d0

loc_8756:
                move.w  d4,d2
                moveq   #$10-1,d1

loc_875A:
                move.b  (a2,d2.w),(a3)+
                add.w   d3,d2
                dbf     d1,loc_875A
                lea     $10(a3),a3
                add.w   d5,d4
                dbf     d0,loc_8756
                dbf     d7,loc_8716
                moveq   #0,d1
                move.b  (Blue_spheres_current_stage+2).w,d1
                move.w  d1,d2
                andi.w  #7,d1
                lsl.w   #4,d1
                lea     (SS_Pal_Map_Ptrs).l,a1
                lea     (Target_palette).w,a2
                movea.l 4(a1,d1.w),a1
                andi.w  #8,d2
                beq.s   loc_8798
                lea     $130(a1),a1

loc_8798:
                move.l  a1,(Special_stage_palette_addr).w
                move.l  (a1)+,$70(a2)
                move.l  (a1)+,$74(a2)
                move.l  (a1)+,$78(a2)
                move.l  (a1)+,$7C(a2)
                move.l  $10(a1),$50(a2)
                move.w  $14(a1),$54(a2)
                rts
; End of function sub_85B0

; ---------------------------------------------------------------------------
word_87BA:
                dc.w    1
                dc.w    0
                dc.w    $10
                dc.w    0
                dc.w    $FFFF
                dc.w    $F
                dc.w    $10
                dc.w    $10
                dc.w    1
                dc.w    $F0
                dc.w    $FFF0
                dc.w    $200
                dc.w    $FFFF
                dc.w    $FF
                dc.w    $FFF0
                dc.w    $210

; =============== S U B R O U T I N E =======================================

Rotate_SSPal:
                tst.b   (Special_stage_fade_timer).w
                bne.s   locret_8818
                move.w  (Special_stage_anim_frame).w,d0
                cmpi.w  #$10,d0
                blo.s   loc_87F8
                tst.b   (Special_stage_turning).w
                bpl.s   locret_8818
                move.b  (Special_stage_palette_frame).w,d0
                andi.w  #$F,d0

loc_87F8:
                andi.w  #$E,d0
                neg.w   d0
                addi.w  #$10,d0
                movea.l (Special_stage_palette_addr).w,a1
                lea     (a1,d0.w),a1
                lea     (Normal_palette_line_4+$10).w,a2
                move.w  #bytesToWcnt($10),d0

loc_8812:
                move.w  (a1)+,(a2)+
                dbf     d0,loc_8812

locret_8818:
                rts
; End of function Rotate_SSPal

; =============== S U B R O U T I N E =======================================

Update_SSMap:
                lea     (VDP_data_port).l,a6
                lea     (SS_Pal_Map_Ptrs).l,a1
                move.w  (Special_stage_anim_frame).w,d0
                cmp.b   (Special_stage_prev_anim_frame).w,d0
                beq.s   loc_8876
                move.b  d0,(Special_stage_prev_anim_frame).w
                lsl.w   #3,d0
                movea.l (a1,d0.w),a3
                lea     $10E(a3),a1
                move.l  #vdpComm(VRAM_Plane_A_Name_Table+$19E,VRAM,WRITE),(VDP_control_port).l  ; VRAM write $C19E
                moveq   #$A-1,d1

loc_884A:
                move.w  (a1)+,(a6)
                dbf     d1,loc_884A
                lea     $140(a3),a3
                move.l  #vdpComm(VRAM_Plane_A_Name_Table+$200,VRAM,WRITE),d0  ; VRAM write $C200
                moveq   #$28-1,d1
                moveq   #$18-1,d2
                move.l  #$80<<16,d4

loc_8864:
                move.l  d0,VDP_control_port-VDP_data_port(a6)
                move.w  d1,d3

loc_886A:
                move.w  (a3)+,(a6)
                dbf     d3,loc_886A
                add.l   d4,d0
                dbf     d2,loc_8864

loc_8876:
                tst.b   (Special_stage_sphere_HUD_flag).w
                beq.s   loc_8890
                move.b  #0,(Special_stage_sphere_HUD_flag).w
                move.l  #vdpComm(VRAM_Plane_A_Name_Table+$086,VRAM,WRITE),d0  ; VRAM write $C086
                move.w  (Special_stage_spheres_left).w,d1
                bsr.w   Draw_SSNum

loc_8890:
                tst.b   (Special_stage_extra_life_flags).w
                bpl.s   locret_88B4
                bclr    #7,(Special_stage_extra_life_flags).w
                move.l  #vdpComm(VRAM_Plane_A_Name_Table+$0BE,VRAM,WRITE),d0  ; VRAM write $C0BE
                move.w  (Special_stage_ring_count).w,d1
                tst.b   (Blue_spheres_stage_flag).w
                beq.s   loc_88B0
                move.w  (Special_stage_rings_left).w,d1

loc_88B0:
                bsr.w   Draw_SSNum

locret_88B4:
                rts
; End of function Update_SSMap
