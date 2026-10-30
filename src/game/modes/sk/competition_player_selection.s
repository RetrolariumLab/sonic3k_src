; Owner: game/modes/sk
; Responsibility: Competition character and player-count selection, animated character widgets and input prompts
; Source provenance and ranges: config/reconstruction/source_layout.json
Competition_PlayerSelect:
                jsr     (Pal_FadeToBlack).l
                move    #$2700,sr
                move.w  (VDP_reg_1_command).w,d0
                andi.b  #$BF,d0
                move.w  d0,(VDP_control_port).l
                jsr     (Clear_DisplayData).l
                lea     (VDP_control_port).l,a6
                move.w  #$8004,(a6)
                move.w  #$8230,(a6)
                move.w  #$8407,(a6)
                move.w  #$8700,(a6)
                move.w  #$8B00,(a6)
                move.w  #$8C89,(a6)
                move.w  #$9011,(a6)
                jsr     sub_C02A(pc)
                move.w  #VRAM_Plane_A_Name_Table+$220,d0
                jsr     sub_C04C(pc)
                move.w  #VRAM_Plane_A_Name_Table+$820,d0
                jsr     sub_C04C(pc)
                clearRAM Sprite_table_input,(Sprite_table_input_end-Sprite_table_input)
                clearRAM Object_RAM,(Kos_decomp_buffer-Object_RAM)
                clr.w   (DMA_queue).w
                move.l  #DMA_queue,(DMA_queue_slot).w
                clr.w   (Level_frame_counter).w
                move.w  #-1,(Events_bg+$10).w
                clr.w   (Events_bg+$12).w
                lea     (MapEni_S3MenuBG).l,a0
                lea     (RAM_start).l,a1
                move.w  #make_art_tile(ArtTile_S3MenuBG,0,0),d0
                jsr     (Eni_Decomp).l
                lea     (RAM_start).l,a1
                move.l  #vdpComm(VRAM_Plane_B_Name_Table,VRAM,WRITE),d0
                moveq   #40-1,d1
                moveq   #28-1,d2
                jsr     (Plane_Map_To_VRAM).l
                lea     (ArtKos_S3MenuBG).l,a0          ; Decompress source
                lea     (RAM_start).l,a1                ; Decompress destination/Transfer source
                movea.w #tiles_to_bytes(ArtTile_S3MenuBG),a2  ; Transfer destination
                jsr     KosArt_To_VDP(pc)
                move.l  #locret_A85C,(_unkEF44_1).w
                move.b  #VInt_ID_1E,(V_int_routine).w
                jsr     (Wait_VSync).l
                lea     (ArtKos_CompetitionLevel).l,a0  ; Decompress source
                lea     (RAM_start).l,a1                ; Decompress destination/Transfer source, used by the next KosArt_To_VDP also
                movea.w #tiles_to_bytes(ArtTile_Competition_LevSel),a2  ; Transfer destination
                jsr     KosArt_To_VDP(pc)
                lea     (ArtKos_CompetitionPlayer).l,a0  ; Decompress source
                movea.w #tiles_to_bytes(ArtTile_Competition_CharSel),a2  ; Transfer destination
                jsr     KosArt_To_VDP(pc)
                move.b  #VInt_ID_1E,(V_int_routine).w
                jsr     (Wait_VSync).l
                lea     (Pal_CompetitionMenuBG).l,a0
                lea     (Target_palette).w,a1
                moveq   #bytesToLcnt($20),d0

loc_B3E8:
                move.l  (a0)+,(a1)+
                dbf     d0,loc_B3E8
                lea     (Pal_Competition2).l,a0
                moveq   #bytesToLcnt($60),d0

loc_B3F6:
                move.l  (a0)+,(a1)+
                dbf     d0,loc_B3F6
                lea     (Player_2).w,a0
                lea     ObjDat_B6C8(pc),a1
                move.w  (a1)+,d0

loc_B406:
                move.l  (a1)+,(a0)
                move.l  #Map_CompetitionSelect,mappings(a0)
                move.w  (a1),x_pos(a0)
                move.w  (a1)+,$12(a0)
                move.w  (a1),y_pos(a0)
                move.w  (a1)+,$16(a0)
                move.w  (a1)+,d1
                addi.w  #make_art_tile(ArtTile_Competition_LevSel,0,1),d1
                move.w  d1,art_tile(a0)
                move.b  (a1)+,mapping_frame(a0)
                move.b  (a1)+,$2E(a0)
                lea     next_object(a0),a0
                dbf     d0,loc_B406
                moveq   #0,d0
                move.b  (P1_character).w,d0
                mulu.w  #$55,d0
                addi.b  #$40,d0
                move.b  d0,(Reserved_object_3+objoff_2E).w
                moveq   #0,d0
                move.b  (P2_character).w,d0
                mulu.w  #$55,d0
                addi.b  #$40,d0
                move.b  d0,(Dynamic_object_RAM+(object_size*4)+objoff_2E).w
                jsr     (Init_SpriteTable).l
                jsr     (Process_Sprites).l
                jsr     (Render_Sprites).l
                jsr     sub_C0AE(pc)
                jsr     (Process_Sprites).l
                jsr     (Render_Sprites).l
                moveq   #signextendB(mus_CompetitionMenu),d0
                jsr     (Play_Music).l
                move.b  #VInt_ID_1E,(V_int_routine).w
                jsr     (Wait_VSync).l
                move.w  (VDP_reg_1_command).w,d0
                ori.b   #$40,d0
                move.w  d0,(VDP_control_port).l
                jsr     (Pal_FadeFromBlack).l

loc_B4A8:
                move.b  #VInt_ID_1E,(V_int_routine).w
                jsr     (Wait_VSync).l
                addq.w  #1,(Level_frame_counter).w
                jsr     (Process_Sprites).l
                jsr     sub_C0AE(pc)
                jsr     (Render_Sprites).l
                move.b  (Events_bg+$12).w,d0
                beq.s   loc_B4D4
                move.b  d0,(Game_mode).w
                rts
; ---------------------------------------------------------------------------

loc_B4D4:
                move.w  (Events_bg+$10).w,d0
                tst.b   (Not_ghost_flag).w
                bne.s   loc_B4E0
                lsr.w   #8,d0

loc_B4E0:
                tst.w   d0
                bne.s   loc_B4A8
                move.w  #$E00,(Current_zone_and_act).w
                jsr     sub_C104(pc)
                move.b  #GameMode_Level,(Game_mode).w
                rts
; ---------------------------------------------------------------------------

Obj_Competition_StaticSprite:
                move.w  $12(a0),d0
                add.w   (H_scroll_buffer).w,d0
                move.w  d0,x_pos(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

Obj_Competition_2PSelect:
                lea     (Ctrl_2_pressed).w,a1
                lea     (Events_bg+$11).w,a2
                lea     (P2_character).w,a3
                tst.b   (Not_ghost_flag).w
                bne.s   loc_B538
                tst.w   (Events_bg+$14).w
                bne.s   loc_B526
                tst.b   (a1)
                smi     (Not_ghost_flag).w

loc_B526:
                moveq   #0,d0
                bra.w   loc_B638
; ---------------------------------------------------------------------------

Obj_Competition_1PSelect:
                lea     (Ctrl_1_pressed).w,a1
                lea     (Events_bg+$10).w,a2
                lea     (P1_character).w,a3

loc_B538:
                tst.w   (H_scroll_buffer).w
                bne.w   loc_B626
                tst.b   $2F(a0)
                beq.s   loc_B558
                btst    #button_B,(a1)
                beq.w   loc_B626
                sf      $2F(a0)
                st      (a2)
                bra.w   loc_B626
; ---------------------------------------------------------------------------

loc_B558:
                tst.b   $30(a0)
                bne.s   loc_B5D0
                move.b  (a1),d0
                andi.w  #button_left_mask|button_right_mask,d0
                beq.w   loc_B602
                move.l  d0,-(sp)
                moveq   #signextendB(sfx_GravityTunnel),d0
                jsr     (Play_SFX).l
                move.l  (sp)+,d0
                clr.b   $34(a0)
                move.b  $2E(a0),$35(a0)
                btst    #button_left,d0
                bne.s   loc_B5AC
                move.b  #1,$30(a0)
                move.b  (a3),d0
                addq.b  #1,d0
                cmpi.b  #2,d0
                bls.s   loc_B596
                moveq   #0,d0

loc_B596:
                move.b  d0,(a3)
                mulu.w  #$55,d0
                bne.s   loc_B5A2
                move.w  #$100,d0

loc_B5A2:
                addi.w  #$40,d0
                move.w  d0,$32(a0)
                bra.s   loc_B5D0
; ---------------------------------------------------------------------------

loc_B5AC:
                move.b  #-1,$30(a0)
                move.b  (a3),d0
                subq.b  #1,d0
                bcc.s   loc_B5BA
                moveq   #2,d0

loc_B5BA:
                move.b  d0,(a3)
                mulu.w  #$55,d0
                cmpi.w  #$80,d0
                blo.s   loc_B5C8
                ext.w   d0

loc_B5C8:
                addi.w  #$40,d0
                move.w  d0,$32(a0)

loc_B5D0:
                move.w  $34(a0),d0
                move.w  $32(a0),d1
                tst.b   $30(a0)
                bmi.s   loc_B5EC
                addq.w  #5,d0
                cmp.w   d0,d1
                bgt.s   loc_B5F8
                move.w  d1,d0
                clr.b   $30(a0)
                bra.s   loc_B5F8
; ---------------------------------------------------------------------------

loc_B5EC:
                subq.w  #5,d0
                cmp.w   d0,d1
                blt.s   loc_B5F8
                move.w  d1,d0
                clr.b   $30(a0)

loc_B5F8:
                move.w  d0,$34(a0)
                move.b  d0,$2E(a0)
                bra.s   loc_B626
; ---------------------------------------------------------------------------

loc_B602:
                btst    #button_B,(a1)
                beq.s   loc_B610
                move.b  #$38,(Events_bg+$12).w
                bra.s   loc_B626
; ---------------------------------------------------------------------------

loc_B610:
                move.b  (a1),d0
                andi.w  #button_A_mask|button_C_mask|button_start_mask,d0
                beq.s   loc_B626
                st      $2F(a0)
                sf      (a2)
                moveq   #signextendB(sfx_Starpost),d0
                jsr     (Play_SFX).l

loc_B626:
                moveq   #1,d0
                tst.b   $2F(a0)
                bne.s   loc_B638
                move.w  (Level_frame_counter).w,d0
                lsr.w   #3,d0
                andi.w  #1,d0

loc_B638:
                move.b  d0,mapping_frame(a0)
                move.w  $12(a0),d0
                add.w   (H_scroll_buffer).w,d0
                move.w  d0,x_pos(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

Obj_CompetitionPlayerSprite2P:
                tst.b   (Not_ghost_flag).w
                bne.s   Obj_CompetitionPlayerSprite
                rts
; ---------------------------------------------------------------------------

Obj_CompetitionPlayerSprite:
                move.l  #Map_CompetitionPlayerSprite,mappings(a0)
                move.w  #make_art_tile(ArtTile_Competition_CharSel,1,0),art_tile(a0)
                moveq   #0,d0
                moveq   #-$55,d1
                moveq   #0,d2
                move.b  $2E(a0),d2

loc_B66E:
                addi.w  #object_size,d0
                addi.w  #$55,d1
                dbf     d2,loc_B66E
                neg.w   d0
                move.b  $2E(a0,d0.w),d0
                add.b   d1,d0
                jsr     (GetSineCosine).l
                asr.w   #4,d1
                add.w   $12(a0),d1
                add.w   (H_scroll_buffer).w,d1
                move.w  d1,x_pos(a0)
                asr.w   #5,d0
                add.w   $16(a0),d0
                move.w  d0,y_pos(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

Obj_Competition_PRESSSTART:
                tst.b   (Not_ghost_flag).w
                bne.s   locret_B6C6
                btst    #5,(Level_frame_counter+1).w
                beq.s   locret_B6C6
                move.w  $12(a0),d0
                add.w   (H_scroll_buffer).w,d0
                move.w  d0,x_pos(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

locret_B6C6:
                rts
; ---------------------------------------------------------------------------
ObjDat_B6C8:
                dc.w    $B-1
                dc.l    Obj_Competition_StaticSprite
                dc.w    $120,   $A9, palette_line_1
                dc.b    3,   0
                dc.l    Obj_Competition_1PSelect
                dc.w    $125,   $C1, palette_line_0
                dc.b    0,   0
                dc.l    Obj_CompetitionPlayerSprite
                dc.w    $125,   $D5, palette_line_0
                dc.b    0,   0
                dc.l    Obj_CompetitionPlayerSprite
                dc.w    $125,   $D5, palette_line_0
                dc.b    2,   1
                dc.l    Obj_CompetitionPlayerSprite
                dc.w    $125,   $D5, palette_line_0
                dc.b    1,   2
                dc.l    Obj_Competition_StaticSprite
                dc.w    $122,  $109, palette_line_1
                dc.b    4,   0
                dc.l    Obj_Competition_2PSelect
                dc.w    $125,  $121, palette_line_0
                dc.b    0,   0
                dc.l    Obj_CompetitionPlayerSprite2P
                dc.w    $125,  $135, palette_line_0
                dc.b    0,   0
                dc.l    Obj_CompetitionPlayerSprite2P
                dc.w    $125,  $135, palette_line_0
                dc.b    2,   1
                dc.l    Obj_CompetitionPlayerSprite2P
                dc.w    $125,  $135, palette_line_0
                dc.b    1,   2
                dc.l    Obj_Competition_PRESSSTART
                dc.w    $121,  $126, palette_line_1
                dc.b    5,   0
; ---------------------------------------------------------------------------
