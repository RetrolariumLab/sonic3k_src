; Owner: game/modes/s3
; Responsibility: Ending and credits mode, scene coordination, logo and text actors and text drawing helpers
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

S3Credits:
                moveq   #signextendB(cmd_Stop),d0
                jsr     (Play_Music).l
                jsr     (Clear_Nem_Queue).l
                jsr     (Pal_FadeToBlack).l
                lea     (VDP_control_port).l,a6
                move.w  #$8004,(a6)
                move.w  #$8230,(a6)
                move.w  #$8407,(a6)
                move.w  #$8700,(a6)
                move.w  #$8B03,(a6)
                move.w  #$8C81,(a6)
                move.w  #$9011,(a6)
                move.w  #$9200,(a6)
                clr.b   (Water_full_screen_flag).w
                clr.w   (Competition_mode).w
                move    #$2700,sr
                move.w  (VDP_reg_1_command).w,d0
                andi.b  #$BF,d0
                move.w  d0,(VDP_control_port).l
                jsr     (Clear_DisplayData).l
; Bug: this should be Sprite_table_End-Sprite_table
                clearRAM Sprite_table,(Sprite_table_end-Sprite_table)+4
; Bug: this should be Collision_response_list_End-H_scroll_buffer
                clearRAM H_scroll_buffer,(Collision_response_list_end-H_scroll_buffer)+4
                clearRAM Sprite_table_input,(Sprite_table_input_end-Sprite_table_input)
                clearRAM Player_1,(Kos_decomp_buffer-Player_1)
                clearRAM RAM_start+$2000,$2000
                clearRAM _unkFA80,(DMA_queue-_unkFA80)
                clr.w   (DMA_queue).w
                move.l  #DMA_queue,(DMA_queue_slot).w
                clr.w   (Player_mode).w
                clr.b   (Current_act_2P).w
                clr.w   (Results_screen_2P).w
                clr.b   (Level_started_flag).w
                clr.w   (Anim_Counters).w
                clr.w   (_unkFF98).w
                clr.w   (Competition_mode).w
                clr.l   (Camera_X_pos).w
                clr.l   (Camera_Y_pos).w
                clr.l   (V_scroll_value).w
                clr.l   (_unkF61A).w
                jsr     (Init_SpriteTable).l
                move.l  #vdpComm(tiles_to_bytes(ArtTile_S3Fonts_SmallText),VRAM,WRITE),(VDP_control_port).l
                lea     (ArtNem_S38x16Font).l,a0
                jsr     (Nem_Decomp).l
                move.l  #vdpComm(tiles_to_bytes(ArtTile_S3Fonts_BigText),VRAM,WRITE),(VDP_control_port).l
                lea     (ArtNem_S3CreditsText).l,a0
                jsr     (Nem_Decomp).l
                move.l  #vdpComm(tiles_to_bytes(ArtTile_Ending_Sprites),VRAM,WRITE),(VDP_control_port).l
                lea     (ArtNem_EndingGraphics).l,a0
                jsr     (Nem_Decomp).l
                lea     (ArtKosM_AIZIntroEmeralds).l,a1
                move.w  #tiles_to_bytes(ArtTile_Ending_Emeralds),d2
                jsr     (Queue_Kos_Module).l
                lea     S3CreditsText_Main(pc),a1
                move.w  (a1),d0
                adda.w  d0,a1
                bsr.w   sub_40A4A
                lea     (Pal_Ending).l,a1
                lea     (Target_palette).w,a2
                moveq   #bytesToLcnt($40),d6

loc_404AC:
                move.l  (a1)+,(a2)+
                dbf     d6,loc_404AC
                moveq   #signextendB(mus_Credits3),d0
                jsr     (Play_Music).l
                move.w  #3*60,(_unkFA82).w
                move.b  #VInt_ID_18,(V_int_routine).w
                jsr     (Wait_VSync).l
                move.w  (VDP_reg_1_command).w,d0
                ori.b   #$40,d0
                move.w  d0,(VDP_control_port).l
                jsr     (Pal_FadeFromBlack).l

loc_404E0:
                move.b  #VInt_ID_18,(V_int_routine).w
                jsr     (Process_Kos_Queue).l
                jsr     (Wait_VSync).l
                addq.w  #1,(Level_frame_counter).w
                jsr     (Process_Sprites).l
                jsr     (Render_Sprites).l
                bsr.w   sub_4051E
                jsr     (Process_Nem_Queue_Init).l
                jsr     (Process_Kos_Module_Queue).l
                cmpi.b  #GameMode_S3Credits,(Game_mode).w
                beq.w   loc_404E0
                rts

; =============== S U B R O U T I N E =======================================

sub_4051E:
                move.w  (_unkFA86).w,d0
                move.w  off_4052A(pc,d0.w),d0
                jmp     off_4052A(pc,d0.w)
; End of function sub_4051E

; ---------------------------------------------------------------------------
off_4052A:
                dc.w    loc_40530-off_4052A
                dc.w    loc_405AE-off_4052A
                dc.w    locret_4069C-off_4052A
; ---------------------------------------------------------------------------

loc_40530:
                subq.w  #1,(_unkFA82).w
                bmi.s   loc_40538
                rts
; ---------------------------------------------------------------------------

loc_40538:
                move.w  #3*60,(_unkFA82).w
                jsr     (Pal_FadeToBlack).l
                clearRAM RAM_start+$2000,$1000
                move.w  (_unkFA84).w,d0
                addq.w  #2,d0
                move.w  d0,(_unkFA84).w
                lea     S3CreditsText_Main(pc),a1
                move.w  (a1,d0.w),d0
                beq.w   loc_405FA
                lea     (a1,d0.w),a1
                bsr.w   sub_40A4A
                move.b  #VInt_ID_18,(V_int_routine).w
                jsr     (Wait_VSync).l
                jmp     (Pal_FadeFromBlack).l
; ---------------------------------------------------------------------------
; unused
                move.w  #2,(_unkFA86).w
                lea     S3CreditsText_Dummy(pc),a1
                move.w  (a1),d0
                adda.w  d0,a1
                bsr.w   sub_40A4A
                lea     (Target_palette).w,a1
                lea     (Normal_palette).w,a2
                moveq   #bytesToLcnt($80),d6

loc_405A2:
                move.l  (a1)+,(a2)+
                dbf     d6,loc_405A2
                clr.w   (_unkFA84).w
                rts
; ---------------------------------------------------------------------------

loc_405AE:
                move.w  (V_scroll_value).w,d0
                addq.w  #1,d0
                move.w  d0,(V_scroll_value).w
                andi.w  #$FF,d0
                beq.s   loc_405C0
                rts
; ---------------------------------------------------------------------------

loc_405C0:
                move.w  (_unkFA84).w,d0
                addq.w  #2,d0
                move.w  d0,(_unkFA84).w
                lea     (RAM_start+$2000).l,a2
                btst    #1,d0
                bne.s   loc_405DC
                lea     (RAM_start+$3000).l,a2

loc_405DC:
                moveq   #0,d2
                move.w  #bytesToLcnt($1000),d3

loc_405E2:
                move.l  d2,(a2)+
                dbf     d3,loc_405E2
                lea     S3CreditsText_Dummy(pc),a1
                move.w  (a1,d0.w),d0
                beq.s   loc_405FA
                lea     (a1,d0.w),a1
                bra.w   sub_40A4A
; ---------------------------------------------------------------------------

loc_405FA:
                jsr     (Pal_FadeToBlack).l
                move.w  #4,(_unkFA86).w
                lea     Pal_EndingEyecatchKnuckles(pc),a1
                cmpi.w  #7,(Chaos_emerald_count).w
                bne.s   loc_40616
                lea     Pal_EndingS3Logo(pc),a1

loc_40616:
                lea     (Target_palette_line_3).w,a2
                moveq   #bytesToLcnt($40),d0

loc_4061C:
                move.l  (a1)+,(a2)+
                dbf     d0,loc_4061C
                clearRAM RAM_start+$2000,$2000
                bset    #0,(_unkFA88).w
                clr.l   (V_scroll_value).w
                lea     Child6_EndingS3Logo(pc),a1
                cmpi.w  #7,(Chaos_emerald_count).w
                beq.s   loc_40656
                lea     S3CreditsText_TryAgain(pc),a1
                bsr.w   sub_40A4A
                lea     Child6_EndingTryAgain(pc),a1

loc_40656:
                move.w  (a1)+,d0
                lea     (Dynamic_object_RAM+object_size).w,a2

loc_4065C:
                move.l  (a1)+,(a2)
                lea     next_object(a2),a2
                dbf     d0,loc_4065C
                jsr     (Process_Sprites).l
                jsr     (Render_Sprites).l
                move.b  #VInt_ID_18,(V_int_routine).w
                jsr     (Wait_VSync).l
                jmp     (Pal_FadeFromBlack).l
; ---------------------------------------------------------------------------
Child6_EndingS3Logo:
                dc.w    3-1
                dc.l    loc_4069E
                dc.l    loc_4078C
                dc.l    loc_407FC
Child6_EndingTryAgain:
                dc.w    2-1
                dc.l    loc_40896
                dc.l    loc_409A2
; ---------------------------------------------------------------------------

locret_4069C:
                rts
; ---------------------------------------------------------------------------

loc_4069E:
                move.l  #loc_406E2,(a0)
                move.w  a0,(_unkFAA4).w
                move.l  #Map_EndingGraphics,mappings(a0)
                move.w  #make_art_tile(ArtTile_Ending_Sprites,2,1),art_tile(a0)
                move.w  #$280,priority(a0)
                move.b  #$40,width_pixels(a0)
                move.b  #$40,height_pixels(a0)
                move.b  #0,mapping_frame(a0)
                move.w  #$120,x_pos(a0)
                move.w  #$40,y_pos(a0)
                move.w  #60,$2E(a0)
                rts
; ---------------------------------------------------------------------------

loc_406E2:
                subq.w  #1,$2E(a0)
                bmi.s   loc_406EA
                rts
; ---------------------------------------------------------------------------

loc_406EA:
                move.l  #loc_406F0,(a0)

loc_406F0:
                jsr     (MoveSprite).l
                cmpi.w  #$F0,y_pos(a0)
                bcs.s   loc_40712
                move.w  y_vel(a0),d0
                bmi.s   loc_40712
                asr.w   #1,d0
                cmpi.w  #$80,d0
                bcs.s   loc_40718
                neg.w   d0
                move.w  d0,y_vel(a0)

loc_40712:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_40718:
                move.l  #loc_40728,(a0)
                move.w  #$F0,y_pos(a0)
                clr.w   $2E(a0)

loc_40728:
                subq.w  #1,$2E(a0)
                bmi.s   loc_40734
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_40734:
                move.w  #1,$2E(a0)
                move.w  $3A(a0),d0
                cmpi.w  #6,d0
                bcc.s   loc_40762
                addq.w  #1,$3A(a0)
                lsl.w   #5,d0
                lea     Pal_EndingS3LogoFlash(pc),a1
                adda.w  d0,a1
                lea     (Normal_palette_line_3).w,a2
                moveq   #bytesToLcnt($20),d0

loc_40756:
                move.l  (a1)+,(a2)+
                dbf     d0,loc_40756
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_40762:
                move.l  #loc_40774,(a0)
                move.w  #6*60,$2E(a0)
                bset    #5,$38(a0)

loc_40774:
                subq.w  #1,$2E(a0)
                bmi.s   loc_40780
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_40780:
                move.b  #GameMode_SegaScreen,(Game_mode).w
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_4078C:
                move.l  #loc_407CC,(a0)
                move.l  #Map_EndingGraphics,mappings(a0)
                move.w  #make_art_tile(ArtTile_Ending_Sprites,3,1),art_tile(a0)
                move.w  #$100,priority(a0)
                move.b  #$18,width_pixels(a0)
                move.b  #$18,height_pixels(a0)
                move.b  #1,mapping_frame(a0)
                move.w  #$100,x_pos(a0)
                move.w  #$11C,y_pos(a0)
                move.l  #AniRaw_41932,$30(a0)

loc_407CC:
                bsr.w   sub_407DC
                jsr     (Animate_Raw).l
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

sub_407DC:
                movea.w (_unkFAA4).w,a1
                btst    #5,$38(a1)
                beq.s   locret_407FA
                clr.b   anim_frame_timer(a0)
                clr.b   anim_frame(a0)
                move.l  #AniRaw_41936,$30(a0)
                move.l  (sp),(a0)

locret_407FA:
                rts
; End of function sub_407DC

; ---------------------------------------------------------------------------

loc_407FC:
                move.l  #loc_40844,(a0)
                move.l  #Map_EndingGraphics,mappings(a0)
                move.w  #make_art_tile(ArtTile_Ending_Sprites,3,1),art_tile(a0)
                move.w  #$100,priority(a0)
                move.b  #$C,width_pixels(a0)
                move.b  #$18,height_pixels(a0)
                move.b  #1,mapping_frame(a0)
                bset    #0,render_flags(a0)
                move.w  #$140,x_pos(a0)
                move.w  #$11C,y_pos(a0)
                lea     ChildObjDat_4192A(pc),a2
                jsr     (CreateChild1_Normal).l

loc_40844:
                lea     AniRaw_41941(pc),a1
                jsr     (Animate_RawNoSST).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_40854:
                move.l  #loc_40886,(a0)
                move.l  #Map_EndingGraphics,mappings(a0)
                move.w  #make_art_tile(ArtTile_Ending_Sprites,3,1),art_tile(a0)
                move.w  #$180,priority(a0)
                move.b  #$C,width_pixels(a0)
                move.b  #$C,height_pixels(a0)
                move.b  #1,mapping_frame(a0)
                bset    #0,render_flags(a0)

loc_40886:
                lea     AniRaw_41945(pc),a1
                jsr     (Animate_RawNoSST).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_40896:
                move.l  #loc_408D6,(a0)
                move.l  #Map_EndingGraphics,mappings(a0)
                move.w  #make_art_tile(ArtTile_Ending_Sprites,2,1),art_tile(a0)
                move.w  #$100,priority(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #$14,height_pixels(a0)
                move.b  #$C,mapping_frame(a0)
                move.w  #$12C,x_pos(a0)
                move.w  #$E8,y_pos(a0)
                move.l  #loc_408E6,$34(a0)

loc_408D6:
                lea     AniRaw_41950(pc),a1
                jsr     (Animate_RawNoSSTMultiDelay).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_408E6:
                move.l  #loc_408F0,(a0)
                bra.w   loc_40A02
; ---------------------------------------------------------------------------

loc_408F0:
                movea.w $44(a0),a1
                btst    #7,status(a1)
                beq.s   loc_4090A
                move.l  #loc_40910,(a0)
                move.l  #loc_40920,$34(a0)

loc_4090A:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_40910:
                lea     AniRaw_41959(pc),a1
                jsr     (Animate_RawNoSSTMultiDelay).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_40920:
                move.l  #loc_408D6,(a0)
                move.l  #loc_408E6,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_40930:
                move.l  #loc_40962,(a0)
                move.l  #Map_AIZIntroEmeralds,mappings(a0)
                move.w  #make_art_tile(ArtTile_Ending_Emeralds,3,1),art_tile(a0)
                move.w  #$80,priority(a0)
                move.b  #4,width_pixels(a0)
                move.b  #4,height_pixels(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                add.w   d0,d0
                move.w  d0,$2E(a0)

loc_40962:
                subq.w  #1,$2E(a0)
                bpl.s   loc_40974
                move.l  #loc_4097A,(a0)
                move.w  #-$300,y_vel(a0)

loc_40974:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_4097A:
                jsr     (MoveSprite_LightGravity).l
                tst.w   y_vel(a0)
                bmi.s   loc_4099C
                movea.w $46(a0),a1
                move.w  y_pos(a1),d0
                subq.w  #4,d0
                cmp.w   y_pos(a0),d0
                bhi.s   loc_4099C
                jsr     (Go_Delete_Sprite).l

loc_4099C:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_409A2:
                move.l  #loc_409E0,(a0)
                move.l  #Map_EndingGraphics,mappings(a0)
                move.w  #make_art_tile(ArtTile_Ending_Sprites,2,1),art_tile(a0)
                move.w  #$180,priority(a0)
                move.b  #$14,width_pixels(a0)
                move.b  #$1C,height_pixels(a0)
                move.b  #$E,mapping_frame(a0)
                move.w  #$118,x_pos(a0)
                move.w  #$E0,y_pos(a0)
                move.w  #6*60,$2E(a0)

loc_409E0:
                subq.w  #1,$2E(a0)
                bmi.s   loc_409F6
                lea     AniRaw_4194C(pc),a1
                jsr     (Animate_RawNoSST).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_409F6:
                move.b  #GameMode_SegaScreen,(Game_mode).w
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_40A02:
                lea     (Collected_emeralds_array).w,a2
                moveq   #0,d1
                moveq   #0,d2
                moveq   #7-1,d3

loc_40A0C:
                tst.b   (a2)+
                bne.s   loc_40A42
                jsr     (AllocateObject).l
                bne.s   loc_40A42
                move.l  #loc_40930,(a1)
                move.b  d1,mapping_frame(a1)
                move.b  d2,subtype(a1)
                move.w  x_pos(a0),d4
                addi.w  #$C,d4
                move.w  d4,x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.w  a0,$46(a1)
                addq.b  #2,d2
                move.w  a1,$44(a0)

loc_40A42:
                addq.b  #1,d1
                dbf     d3,loc_40A0C
                rts

; =============== S U B R O U T I N E =======================================

sub_40A4A:
                move.w  (a1)+,d6

loc_40A4C:
                bsr.w   sub_40A5C
                dbf     d6,loc_40A4C
                bset    #0,(_unkFA88).w
                rts
; End of function sub_40A4A

; =============== S U B R O U T I N E =======================================

sub_40A5C:
                lea     (RAM_start+$2000).l,a2
                move.w  (a1)+,d0
                adda.w  d0,a2

loc_40A66:
                moveq   #0,d0
                move.b  (a1)+,d0
                beq.w   loc_40B10
                move.w  d0,d1
                subi.b  #"a",d0
                bcs.s   loc_40A9A
                lea     (S3Credits_PlaneMapSmall).l,a3
                lsl.w   #2,d0
                adda.w  d0,a3
                move.w  (a3)+,(a2)+
                move.l  a2,d2
                addi.w  #$7E,d2
                andi.l  #$FFFF3FFF,d2
                ori.l   #$2000,d2
                movea.l d2,a4
                move.w  (a3)+,(a4)
                bra.s   loc_40A66
; ---------------------------------------------------------------------------

loc_40A9A:
                cmpi.b  #" ",d1
                bne.s   loc_40AA6
                moveq   #$1D,d1
                bra.w   loc_40ACE
; ---------------------------------------------------------------------------

loc_40AA6:
                cmpi.b  #".",d1
                bne.s   loc_40AB2
                moveq   #$1A,d1
                bra.w   loc_40ACE
; ---------------------------------------------------------------------------

loc_40AB2:
                cmpi.b  #"(",d1
                bne.s   loc_40ABE
                moveq   #$1B,d1
                bra.w   loc_40ACE
; ---------------------------------------------------------------------------

loc_40ABE:
                cmpi.b  #")",d1
                bne.s   loc_40ACA
                moveq   #$1C,d1
                bra.w   loc_40ACE
; ---------------------------------------------------------------------------

loc_40ACA:
                subi.b  #"A",d1

loc_40ACE:
                add.w   d1,d1
                lea     (S3Credits_PlaneMapLarge).l,a3
                move.w  (a3,d1.w),d1
                lea     (a3,d1.w),a3
                move.w  (a3)+,d0
                movea.l a2,a4
                moveq   #2,d3

loc_40AE4:
                move.w  d0,d1
                movea.l a4,a5

loc_40AE8:
                move.w  (a3)+,(a5)+
                dbf     d1,loc_40AE8
                move.l  a4,d2
                addi.w  #$80,d2
                andi.l  #$FFFF3FFF,d2
                ori.l   #$2000,d2
                movea.l d2,a4
                dbf     d3,loc_40AE4
                addq.w  #1,d0
                add.w   d0,d0
                adda.w  d0,a2
                bra.w   loc_40A66
; ---------------------------------------------------------------------------

loc_40B10:
                move.l  a1,d0
                btst    #0,d0
                beq.s   locret_40B1A
                addq.l  #1,a1

locret_40B1A:
                rts
; End of function sub_40A5C
