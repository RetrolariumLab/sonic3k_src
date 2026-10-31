; Owner: game/modes/continue/sk
; Responsibility: Continue mode video and palette setup, countdown input and scene creation
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

ContinueScreen:
                jsr     (Pal_FadeToBlack).l
                move    #$2700,sr
                move.w  (VDP_reg_1_command).w,d0
                andi.b  #$BF,d0
                move.w  d0,(VDP_control_port).l
                lea     (VDP_control_port).l,a6
                move.w  #$8004,(a6)
                move.w  #$8700,(a6)
                clr.w   (Kos_decomp_queue_count).w
                clearRAM Kos_decomp_stored_registers,(Kos_decomp_module_end-Kos_decomp_stored_registers)
                jsr     (Clear_Nem_Queue).l
                jsr     (Clear_DisplayData).l
                move.l  #vdpComm(tiles_to_bytes(ArtTile_Continue_Digits),VRAM,WRITE),(VDP_control_port).l
                lea     (ArtNem_ContinueDigits).l,a0
                jsr     (Nem_Decomp).l
                move.l  #vdpComm(tiles_to_bytes(ArtTile_Continue_Text),VRAM,WRITE),(VDP_control_port).l
                lea     (ArtNem_CreditsText).l,a0
                jsr     (Nem_Decomp).l
                move.l  #vdpComm(tiles_to_bytes(ArtTile_Continue_Misc),VRAM,WRITE),(VDP_control_port).l
                lea     (ArtNem_ContinueSprites).l,a0
                jsr     (Nem_Decomp).l
                move.l  #vdpComm(tiles_to_bytes(ArtTile_Continue_Icons),VRAM,WRITE),(VDP_control_port).l
                lea     (ArtNem_ContinueIcons).l,a0
                jsr     (Nem_Decomp).l
                clr.b   (Level_started_flag).w
                clr.b   (_unkFAA9).w
                clr.b   (_unkFA88).w
                clearRAM Player_1,(Kos_decomp_buffer-Player_1)
                moveq   #0,d0
                move.l  d0,(LRZ_rocks_addr_front).w
                move.l  d0,(LRZ_rocks_addr_back).w
                jsr     (Init_SpriteTable).l
                move.w  #(11*60)-1,(Demo_timer).w
                lea     (Pal_ContinueScreen).l,a1
                lea     (Target_palette).w,a2
                moveq   #bytesToLcnt($80),d6

loc_5C3BC:
                move.l  (a1)+,(a2)+
                dbf     d6,loc_5C3BC
                lea     aCONTINUE(pc),a1
                move.w  #$292,d2
                move.w  #make_art_tile(ArtTile_Continue_Text,0,1),d6
                jsr     (sub_5B318).l
                cmpi.w  #3,(Player_mode).w
                beq.s   loc_5C3FE
                tst.w   (SK_alone_flag).w
                beq.s   loc_5C3EE
                move.l  #Obj_Continue_SonicAlone,(Player_1).w
                bra.w   loc_5C3FE
; ---------------------------------------------------------------------------

loc_5C3EE:
                move.l  #Obj_Continue_SonicWTails,(Player_1).w
                move.l  #Obj_Continue_TailsWSonic,(Player_2).w

loc_5C3FE:
                move.l  #loc_5C838,(Reserved_object_3).w
                lea     (Dynamic_object_RAM).w,a1
                move.l  #loc_5C4D6,(a1)
                move.w  a1,(_unkFAA4).w
                move.l  #loc_5C9DC,(Dynamic_object_RAM+object_size).w
                bsr.w   sub_5CB1C
                jsr     (Process_Sprites).l
                jsr     (Render_Sprites).l
                move.b  #VInt_ID_16,(V_int_routine).w
                jsr     (Wait_VSync).l
                move.w  (VDP_reg_1_command).w,d0
                ori.b   #$40,d0
                move.w  d0,(VDP_control_port).l
                moveq   #signextendB(mus_Continue),d0
                jsr     (Play_Music).l
                jsr     (Pal_FadeFromBlack).l

loc_5C454:
                move.b  #VInt_ID_16,(V_int_routine).w
                jsr     (Process_Kos_Queue).l
                jsr     (Wait_VSync).l
                jsr     (Process_Sprites).l
                jsr     (Render_Sprites).l
                jsr     (Process_Kos_Module_Queue).l
                move.b  (_unkFAA9).w,d0
                beq.s   loc_5C454
                subq.b  #1,d0
                beq.s   loc_5C48A
                move.b  #GameMode_SegaScreen,(Game_mode).w
                rts
; ---------------------------------------------------------------------------

loc_5C48A:
                move.b  #GameMode_Level,(Game_mode).w
                move.b  #3,(Life_count).w
                move.b  #3,(Life_count_P2).w
                moveq   #0,d0
                move.w  d0,(Ring_count).w
                move.l  d0,(Timer).w
                move.l  d0,(Score).w
                move.w  d0,(Ring_count_P2).w
                move.l  d0,(Timer_P2).w
                move.l  d0,(Score_P2).w
                move.l  #5000,(Next_extra_life_score).w
                move.l  #5000,(Next_extra_life_score_P2).w
                subq.b  #1,(Continue_count).w
                st      (SRAM_mask_interrupts_flag).w
                jsr     (SaveGame_LivesContinues).l

locret_5C4D4:
                rts
; ---------------------------------------------------------------------------

loc_5C4D6:
                move.l  #loc_5C4E6,(a0)
                clr.w   (_unkFA82).w
                move.b  #$A,(_unkFA84).w

loc_5C4E6:
                btst    #button_start,(Ctrl_1_pressed).w
                bne.s   loc_5C51C
                btst    #button_start,(Ctrl_2_pressed).w
                bne.s   loc_5C51C
                subq.w  #1,(_unkFA82).w
                bpl.s   locret_5C512
                move.w  #60-1,(_unkFA82).w
                move.b  (_unkFA84).w,d0
                subq.b  #1,d0
                bmi.s   loc_5C514
                move.b  d0,(_unkFA84).w
                bsr.w   sub_5CAAE

locret_5C512:
                rts
; ---------------------------------------------------------------------------

loc_5C514:
                move.b  #2,(_unkFAA9).w
                rts
; ---------------------------------------------------------------------------

loc_5C51C:
                move.l  #locret_5C528,(a0)
                bset    #3,$38(a0)

locret_5C528:
                rts
