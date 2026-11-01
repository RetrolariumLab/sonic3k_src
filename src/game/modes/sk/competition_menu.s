; Owner: game/modes/sk
; Responsibility: Competition entry menu, shared menu objects, palette and menu-object mapping storage
; Source provenance and ranges: config/reconstruction/source_layout.json
Competition_Menu:
                bsr.w   Pal_FadeToBlack
                move    #$2700,sr
                move.w  (VDP_reg_1_command).w,d0
                andi.b  #$BF,d0
                move.w  d0,(VDP_control_port).l
                jsr     (Clear_DisplayData).l
                lea     (VDP_control_port).l,a6
                move.w  #$8004,(a6)
                move.w  #$8230,(a6)
                move.w  #$8407,(a6)
                move.w  #$8730,(a6)
                move.w  #$8B00,(a6)
                move.w  #$8C81,(a6)
                move.w  #$9011,(a6)
                jsr     Menu_FillPlaneAWithPriorityBlankTiles(pc)
                clearRAM Sprite_table_input,(Sprite_table_input_end-Sprite_table_input)
                clearRAM Object_RAM,(Kos_decomp_buffer-Object_RAM)
                clr.w   (DMA_queue).w
                move.l  #DMA_queue,(DMA_queue_slot).w
                clr.w   (Level_frame_counter).w
                cmpi.b  #3,(Competition_menu_selection).w
                blo.s   loc_A8DC
                clr.b   (Competition_menu_selection).w

loc_A8DC:
                lea     (MapEni_S3MenuBG).l,a0
                lea     (RAM_start).l,a1
                move.w  #make_art_tile(ArtTile_S3MenuBG,3,0),d0
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
                lea     (ArtKos_CompetitionMode).l,a0   ; Decompress source
                movea.w #tiles_to_bytes(ArtTile_Competition_ModeSel),a2  ; Transfer destination
                jsr     KosArt_To_VDP(pc)
                move.b  #VInt_ID_1E,(V_int_routine).w
                jsr     (Wait_VSync).l
                lea     (Pal_Competition1).l,a0
                lea     (Target_palette).w,a1
                moveq   #bytesToLcnt($60),d0

loc_A96A:
                move.l  (a0)+,(a1)+
                dbf     d0,loc_A96A
                lea     (Pal_CompetitionMenuBG).l,a0
                moveq   #bytesToLcnt($20),d0

loc_A978:
                move.l  (a0)+,(a1)+
                dbf     d0,loc_A978
                lea     (Object_RAM).w,a0
                lea     ObjDat_AB48(pc),a1
                move.w  (a1)+,d0

loc_A988:
                move.l  (a1)+,(a0)
                move.w  #make_art_tile(ArtTile_Competition_ModeSel,0,0),art_tile(a0)
                move.l  #Map_CompetitionObject,mappings(a0)
                move.w  (a1)+,x_pos(a0)
                move.w  (a1)+,y_pos(a0)
                move.b  (a1)+,mapping_frame(a0)
                move.b  (a1)+,$2E(a0)
                lea     next_object(a0),a0
                dbf     d0,loc_A988
                jsr     (Init_SpriteTable).l
                jsr     (Process_Sprites).l
                jsr     (Render_Sprites).l
                moveq   #signextendB(mus_CompetitionMenu),d0
                jsr     (Play_Music).l
                move.b  #VInt_ID_1E,(V_int_routine).w
                jsr     (Wait_VSync).l
                move.w  (VDP_reg_1_command).w,d0
                ori.b   #$40,d0
                move.w  d0,(VDP_control_port).l
                bsr.w   Pal_FadeFromBlack

loc_A9E8:
                move.b  #VInt_ID_1E,(V_int_routine).w
                jsr     (Wait_VSync).l
                addq.w  #1,(Level_frame_counter).w
                jsr     (Process_Sprites).l
                jsr     (Render_Sprites).l
                move.b  (Ctrl_1_pressed).w,d0
                or.b    (Ctrl_2_pressed).w,d0
                move.b  d0,d1
                andi.b  #button_A_mask|button_B_mask|button_C_mask|button_start_mask,d1
                beq.w   loc_AAA6
                btst    #button_B,d1
                bne.s   loc_AA2E
                moveq   #0,d2
                move.b  (Competition_menu_selection).w,d2
                add.w   d2,d2
                jmp     loc_AA28(pc,d2.w)
; ---------------------------------------------------------------------------

loc_AA28:
                bra.s   loc_AA36
; ---------------------------------------------------------------------------
                bra.s   loc_AA54
; ---------------------------------------------------------------------------
                bra.s   loc_AA74
; ---------------------------------------------------------------------------

loc_AA2E:
                move.b  #GameMode_TitleScreen,(Game_mode).w
                rts
; ---------------------------------------------------------------------------

loc_AA36:
                clr.b   (Competition_type).w
                move.b  (Competition_menu_items).w,(Competition_items).w
                move.b  (Ctrl_2_pressed).w,d0
                andi.b  #button_A_mask|button_C_mask|button_start_mask,d0
                sne     (Not_ghost_flag).w
                move.b  #GameMode_CompetitionPlayerSelect,(Game_mode).w
                bra.s   loc_AA8E
; ---------------------------------------------------------------------------

loc_AA54:
                move.b  #3,(Competition_type).w
                move.b  (Competition_menu_items).w,(Competition_items).w
                move.b  (Ctrl_2_pressed).w,d0
                andi.b  #button_A_mask|button_C_mask|button_start_mask,d0
                sne     (Not_ghost_flag).w
                move.b  #GameMode_CompetitionLevelSelect,(Game_mode).w
                bra.s   loc_AA8E
; ---------------------------------------------------------------------------

loc_AA74:
                move.b  (Ctrl_1_pressed).w,d2
                andi.w  #button_A_mask|button_C_mask|button_start_mask,d2
                beq.s   loc_AAA6
                move.w  #-1,(Competition_settings).w
                clr.b   (Not_ghost_flag).w
                move.b  #GameMode_CompetitionLevelSelect+$80,(Game_mode).w

loc_AA8E:
                lea     ((RAM_start+$7800)&$FFFFFF).l,a1
                moveq   #0,d0
                moveq   #bytesToLcnt($28),d1

loc_AA98:
                move.l  d0,(a1)+
                dbf     d1,loc_AA98
                moveq   #signextendB(sfx_Starpost),d0
                jmp     (Play_SFX).l
; ---------------------------------------------------------------------------

loc_AAA6:
                moveq   #0,d2
                move.b  (Competition_menu_selection).w,d1
                lsr.w   #1,d0
                bcc.s   loc_AABA
                moveq   #signextendB(sfx_Switch),d2
                subq.b  #1,d1
                bcc.s   loc_AACA
                moveq   #3,d1
                bra.s   loc_AACA
; ---------------------------------------------------------------------------

loc_AABA:
                lsr.w   #1,d0
                bcc.s   loc_AACA
                moveq   #signextendB(sfx_Switch),d2
                addq.b  #1,d1
                cmpi.b  #3,d1
                bls.s   loc_AACA
                moveq   #0,d1

loc_AACA:
                move.b  d1,(Competition_menu_selection).w
                move.w  d2,d0
                beq.s   loc_AAD8
                jsr     (Play_SFX).l

loc_AAD8:
                bra.w   loc_A9E8
; ---------------------------------------------------------------------------

Obj_Competition_AADC:
                move.b  $2E(a0),d0
                bmi.s   loc_AAFA
                andi.w  #$9FFF,art_tile(a0)
                move.w  #palette_line_1,d1
                cmp.b   (Competition_menu_selection).w,d0
                bne.s   loc_AAF6
                move.w  #palette_line_2,d1

loc_AAF6:
                or.w    d1,art_tile(a0)

loc_AAFA:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

Obj_Competition_AB00:
                cmpi.b  #1,(Competition_menu_selection).w
                bhi.s   locret_AB46
                move.b  (Ctrl_1_pressed).w,d0
                or.b    (Ctrl_2_pressed).w,d0
                andi.w  #button_left_mask|button_right_mask,d0
                beq.s   loc_AB26
                tst.b   (Competition_menu_items).w
                seq     (Competition_menu_items).w
                moveq   #signextendB(sfx_Switch),d0
                jsr     (Play_SFX).l

loc_AB26:
                move.w  #$15C,d0
                tst.b   (Competition_menu_items).w
                beq.s   loc_AB34
                addi.w  #$20,d0

loc_AB34:
                move.w  d0,x_pos(a0)
                btst    #3,(Level_frame_counter+1).w
                beq.s   locret_AB46
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

locret_AB46:
                rts
; ---------------------------------------------------------------------------
ObjDat_AB48:
                dc.w    7-1
                dc.l    Obj_Competition_AADC
                dc.w    $114,   $A0
                dc.b    0,   0
                dc.l    Obj_Competition_AADC
                dc.w    $10C,   $C0
                dc.b    1,   1
                dc.l    Obj_Competition_AADC
                dc.w    $108,   $E0
                dc.b    2,   2
                dc.l    Obj_Competition_AADC
                dc.w    $13C,  $120
                dc.b    3,   3
                dc.l    Obj_Competition_AADC
                dc.w    $164,   $B0
                dc.b    4, $FF
                dc.l    Obj_Competition_AADC
                dc.w    $184,   $B0
                dc.b    5, $FF
                dc.l    Obj_Competition_AB00
                dc.w    0,   $A8
                dc.b    6, $FF
; ---------------------------------------------------------------------------
