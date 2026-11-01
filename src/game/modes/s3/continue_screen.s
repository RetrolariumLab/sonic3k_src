; Owner: game/modes/s3
; Responsibility: Continue screen mode, character and icon actors, countdown display and private art resources
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
                jsr     (Clear_DisplayData).l
                move.l  #vdpComm(tiles_to_bytes(ArtTile_Continue_Digits),VRAM,WRITE),(VDP_control_port).l
                lea     (ArtNem_ContinueDigits).l,a0
                jsr     (Nem_Decomp).l
                move.l  #vdpComm(tiles_to_bytes(ArtTile_S3Fonts_BigText),VRAM,WRITE),(VDP_control_port).l
                lea     (ArtNem_S3CreditsText).l,a0
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
                clearRAM (RAM_start+$2000),$2000
                jsr     (Init_SpriteTable).l
                move.w  #(11*60)-1,(Demo_timer).w
                lea     (Pal_ContinueScreen).l,a1
                lea     (Target_palette).w,a2
                moveq   #bytesToLcnt($80),d6

loc_3F0F4:
                move.l  (a1)+,(a2)+
                dbf     d6,loc_3F0F4
                lea     aCONTINUE(pc),a1
                jsr     S3CreditsDrawCountedTextPageAndRequestPlaneUpload(pc)
                move.l  #Obj_Continue_SonicWTails,(Player_1).w
                move.l  #Obj_Continue_TailsWSonic,(Player_2).w
                move.l  #loc_3F47E,(Reserved_object_3).w
                lea     (Dynamic_object_RAM).w,a1
                move.l  #loc_3F1D4,(a1)
                move.w  a1,(_unkFAA4).w
                move.l  #loc_3F500,(Dynamic_object_RAM+object_size).w
                bsr.w   S3ContinueClampCountAndCreateRemainingLifeIcons
                jsr     (Process_Sprites).l
                jsr     (Render_Sprites).l
                move.b  #VInt_ID_18,(V_int_routine).w
                jsr     (Wait_VSync).l
                move.w  (VDP_reg_1_command).w,d0
                ori.b   #$40,d0
                move.w  d0,(VDP_control_port).l
                moveq   #signextendB(mus_Continue),d0
                jsr     (Play_Music).l
                jsr     (Pal_FadeFromBlack).l

loc_3F168:
                move.b  #VInt_ID_18,(V_int_routine).w
                jsr     (Wait_VSync).l
                jsr     (Process_Sprites).l
                jsr     (Render_Sprites).l
                move.b  (_unkFAA9).w,d0
                beq.s   loc_3F168
                subq.b  #1,d0
                beq.s   loc_3F192
                move.b  #GameMode_SegaScreen,(Game_mode).w
                rts
; ---------------------------------------------------------------------------

loc_3F192:
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

locret_3F1D2:
                rts
; ---------------------------------------------------------------------------

loc_3F1D4:
                move.l  #loc_3F1E4,(a0)
                clr.w   (_unkFA82).w
                move.b  #$A,(_unkFA84).w

loc_3F1E4:
                btst    #button_start,(Ctrl_1_pressed).w
                bne.s   loc_3F21A
                btst    #button_start,(Ctrl_2_pressed).w
                bne.s   loc_3F21A
                subq.w  #1,(_unkFA82).w
                bpl.s   locret_3F210
                move.w  #60-1,(_unkFA82).w
                move.b  (_unkFA84).w,d0
                subq.b  #1,d0
                bmi.s   loc_3F212
                move.b  d0,(_unkFA84).w
                bsr.w   S3ContinueWriteTwoNibbleTimerTileMapAndRequestUpload

locret_3F210:
                rts
; ---------------------------------------------------------------------------

loc_3F212:
                move.b  #2,(_unkFAA9).w
                rts
; ---------------------------------------------------------------------------

loc_3F21A:
                move.l  #locret_3F226,(a0)
                bset    #3,$38(a0)

locret_3F226:
                rts
; ---------------------------------------------------------------------------

Obj_Continue_SonicWTails:
                move.l  #Map_ContinueSprites,mappings(a0)
                move.w  #make_art_tile(ArtTile_Continue_Misc,0,0),art_tile(a0)
                move.w  #$280,priority(a0)
                move.b  #$C,width_pixels(a0)
                move.b  #$14,height_pixels(a0)
                move.w  #$118,x_pos(a0)
                move.w  #$120,y_pos(a0)
                move.l  #loc_3F25A,(a0)

loc_3F25A:
                movea.w (_unkFAA4).w,a1
                btst    #3,$38(a1)
                bne.s   loc_3F280
                move.b  #0,mapping_frame(a0)
                btst    #4,(V_int_run_count+3).w
                beq.s   loc_3F27A
                move.b  #1,mapping_frame(a0)

loc_3F27A:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_3F280:
                move.l  #loc_3F286,(a0)

loc_3F286:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_3F2A0(pc,d0.w),d1
                jsr     off_3F2A0(pc,d1.w)
                jsr     (Sonic_Load_PLC).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
off_3F2A0:
                dc.w    loc_3F2AA-off_3F2A0
                dc.w    loc_3F2CE-off_3F2A0
                dc.w    loc_3F32A-off_3F2A0
                dc.w    loc_3F340-off_3F2A0
                dc.w    locret_3F35C-off_3F2A0
; ---------------------------------------------------------------------------

loc_3F2AA:
                addq.b  #2,routine(a0)
                move.l  #Map_Sonic,mappings(a0)
                move.w  #make_art_tile(ArtTile_Player_1,0,0),art_tile(a0)
                clr.b   (Player_prev_frame).w
                move.b  #$5A,mapping_frame(a0)
                move.b  #6,anim_frame_timer(a0)
                rts
; ---------------------------------------------------------------------------

loc_3F2CE:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   locret_3F304
                move.b  #6,anim_frame_timer(a0)
                moveq   #0,d0
                move.b  anim_frame(a0),d0
                addq.w  #2,d0
                cmpi.b  #$A,d0
                bhs.s   loc_3F306
                move.b  d0,anim_frame(a0)
                lea     RawAni_3F320(pc,d0.w),a2
                move.b  (a2)+,mapping_frame(a0)
                bclr    #0,render_flags(a0)
                tst.b   (a2)
                beq.s   locret_3F304
                bset    #0,render_flags(a0)

locret_3F304:
                rts
; ---------------------------------------------------------------------------

loc_3F306:
                move.b  #4,routine(a0)
                move.w  #1,anim(a0)
                move.w  #$600,ground_vel(a0)
                move.w  #$F,$2E(a0)
                rts
; ---------------------------------------------------------------------------
RawAni_3F320:
                dc.b    $5A,   1
                dc.b    $59,   1
                dc.b    $55,   0
                dc.b    $56,   0
                dc.b    $57,   0
                even
; ---------------------------------------------------------------------------

loc_3F32A:
                jsr     (Animate_Sonic).l
                subq.w  #1,$2E(a0)
                bmi.s   loc_3F338
                rts
; ---------------------------------------------------------------------------

loc_3F338:
                move.b  #6,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_3F340:
                jsr     (Animate_Sonic).l
                addq.w  #6,x_pos(a0)
                cmpi.w  #$1E0,x_pos(a0)
                bhs.s   loc_3F354
                rts
; ---------------------------------------------------------------------------

loc_3F354:
                move.b  #8,routine(a0)
                rts
; ---------------------------------------------------------------------------

locret_3F35C:
                rts
; ---------------------------------------------------------------------------

Obj_Continue_TailsWSonic:
                move.l  #Map_ContinueSprites,mappings(a0)
                move.w  #make_art_tile(ArtTile_Continue_Misc,0,0),art_tile(a0)
                move.w  #$200,priority(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #$14,height_pixels(a0)
                move.w  #$12C,x_pos(a0)
                move.w  #$120,y_pos(a0)
                move.l  #loc_3F390,(a0)

loc_3F390:
                movea.w (_unkFAA4).w,a1
                btst    #3,$38(a1)
                bne.s   loc_3F3B6
                move.b  #5,mapping_frame(a0)
                btst    #5,(V_int_run_count+3).w
                beq.s   loc_3F3B0
                move.b  #6,mapping_frame(a0)

loc_3F3B0:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_3F3B6:
                move.l  #loc_3F3D6,(a0)
                addq.w  #4,y_pos(a0)
                lea     (Tails_tails).w,a1
                move.l  #Obj_Tails_Tail,(a1)
                move.w  a0,$30(a1)
                move.l  #loc_3F472,(Dust).w

loc_3F3D6:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_3F3F0(pc,d0.w),d1
                jsr     off_3F3F0(pc,d1.w)
                jsr     (Tails_Load_PLC).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
off_3F3F0:
                dc.w    loc_3F3F8-off_3F3F0
                dc.w    loc_3F428-off_3F3F0
                dc.w    loc_3F448-off_3F3F0
                dc.w    loc_3F45A-off_3F3F0
; ---------------------------------------------------------------------------

loc_3F3F8:
                addq.b  #2,routine(a0)
                move.l  #Map_Tails,mappings(a0)
                move.w  #make_art_tile(ArtTile_Player_2,0,0),art_tile(a0)
                move.w  #$280,priority(a0)
                clr.b   (Player_prev_frame_P2).w
                move.w  #5<<8,anim(a0)                  ; and prev_anim
                move.w  #$AD<<8,mapping_frame(a0)       ; and anim_frame
                move.w  #40-1,$2E(a0)
                rts
; ---------------------------------------------------------------------------

loc_3F428:
                subq.w  #1,$2E(a0)
                bpl.w   locret_3F1D2
                move.b  #4,routine(a0)
                move.b  #0,anim(a0)
                move.w  #$600,ground_vel(a0)
                move.w  #20-1,$2E(a0)

loc_3F448:
                subq.w  #1,$2E(a0)
                bpl.s   loc_3F454
                move.b  #6,routine(a0)

loc_3F454:
                jmp     (Animate_Tails).l
; ---------------------------------------------------------------------------

loc_3F45A:
                addq.w  #6,x_pos(a0)
                cmpi.w  #$1E0,x_pos(a0)
                blo.s   loc_3F46C
                move.b  #1,(_unkFAA9).w

loc_3F46C:
                jmp     (Animate_Tails).l
; ---------------------------------------------------------------------------

loc_3F472:
                bclr    #2,(Tails_tails+render_flags).w
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_3F47E:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_3F49E(pc,d0.w),d1
                jsr     off_3F49E(pc,d1.w)
                lea     (DPLCPtr_CutsceneKnux).l,a2
                jsr     (Perform_DPLC).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
off_3F49E:
                dc.w    loc_3F4A6-off_3F49E
                dc.w    loc_3F4CA-off_3F49E
                dc.w    loc_3F4DE-off_3F49E
                dc.w    locret_3F4FE-off_3F49E
; ---------------------------------------------------------------------------

loc_3F4A6:
                lea     (ObjSlot_CutsceneKnux).l,a1
                jsr     (SetUp_ObjAttributesSlotted).l
                move.w  #make_art_tile(ArtTile_CutsceneKnux,3,0),art_tile(a0)
                bclr    #2,render_flags(a0)
                move.w  #$40,x_pos(a0)
                move.w  #$120,y_pos(a0)

loc_3F4CA:
                movea.w (_unkFAA4).w,a1
                btst    #3,$38(a1)
                bne.s   loc_3F4D8
                rts
; ---------------------------------------------------------------------------

loc_3F4D8:
                move.b  #4,routine(a0)

loc_3F4DE:
                move.w  x_pos(a0),d0
                addq.w  #6,d0
                move.w  d0,x_pos(a0)
                cmpi.w  #$1E0,d0
                bhs.s   loc_3F4F8
                lea     byte_3F83A(pc),a1
                jmp     (Animate_RawNoSST).l
; ---------------------------------------------------------------------------

loc_3F4F8:
                move.b  #6,routine(a0)

locret_3F4FE:
                rts
; ---------------------------------------------------------------------------

loc_3F500:
                move.l  #Map_ContinueSprites,mappings(a0)
                move.w  #make_art_tile(ArtTile_Continue_Misc,2,0),art_tile(a0)
                move.w  #$280,priority(a0)
                move.b  #7,mapping_frame(a0)
                move.b  #8,width_pixels(a0)
                move.b  #8,height_pixels(a0)
                move.w  #$120,x_pos(a0)
                move.w  #$F5,y_pos(a0)
                move.l  #loc_3F538,(a0)

loc_3F538:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_3F53E:
                move.l  #Map_ContinueIcons,mappings(a0)
                move.w  #make_art_tile(ArtTile_Continue_Icons,0,0),art_tile(a0)
                move.w  #$280,priority(a0)
                move.b  #8,width_pixels(a0)
                move.b  #8,height_pixels(a0)
                bsr.w   S3ContinuePositionIconByEvenSubtypeTable
                move.w  #$D8,y_pos(a0)
                move.l  #loc_3F572,(a0)
                bsr.w   S3ContinueSelectCharacterIconFramesAndTailsChild

loc_3F572:
                moveq   #0,d0
                btst    #4,(V_int_run_count+3).w
                beq.s   loc_3F57E
                addq.w  #1,d0

loc_3F57E:
                movea.l $30(a0),a1
                move.b  (a1,d0.w),mapping_frame(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

Obj_3F58E:
                move.l  #Map_ContinueIcons,mappings(a0)
                move.w  #make_art_tile(ArtTile_Continue_Icons,0,0),art_tile(a0)
                move.w  #$280,priority(a0)
                move.b  #8,width_pixels(a0)
                move.b  #8,height_pixels(a0)
                move.l  #loc_3F5B4,(a0)

loc_3F5B4:
                lea     byte_3F840(pc),a1
                jsr     (Animate_RawNoSST).l
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

S3ContinueWriteTwoNibbleTimerTileMapAndRequestUpload:
                move.b  (_unkFA84).w,d0
                move.b  d0,d1
                andi.w  #$F0,d0
                lsr.w   #3,d0
                andi.w  #$F,d1
                add.w   d1,d1
                move.w  #1,d2
                lea     (RAM_start+$2726).l,a1
                add.w   d2,d0
                move.w  d0,(a1)
                addq.w  #1,d0
                move.w  d0,$80(a1)
                add.w   d2,d1
                move.w  d1,2(a1)
                addq.w  #1,d1
                move.w  d1,$82(a1)
                bset    #0,(_unkFA88).w
                rts
; End of function S3ContinueWriteTwoNibbleTimerTileMapAndRequestUpload

; =============== S U B R O U T I N E =======================================

S3ContinueClampCountAndCreateRemainingLifeIcons:
                moveq   #0,d0
                move.b  (Continue_count).w,d0
                beq.s   loc_3F60C
                cmpi.b  #$A,d0
                bls.s   loc_3F612

loc_3F60C:
                moveq   #$A,d0
                move.b  d0,(Continue_count).w

loc_3F612:
                lea     (Dynamic_object_RAM+(object_size*2)).w,a1
                moveq   #0,d1

loc_3F618:
                subq.b  #1,d0
                beq.w   locret_3F1D2
                move.l  #loc_3F53E,(a1)
                move.b  d1,subtype(a1)
                addq.w  #2,d1
                lea     next_object(a1),a1
                bra.s   loc_3F618
; End of function S3ContinueClampCountAndCreateRemainingLifeIcons

; =============== S U B R O U T I N E =======================================

S3ContinuePositionIconByEvenSubtypeTable:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  word_3F63E(pc,d0.w),x_pos(a0)
                rts
; End of function S3ContinuePositionIconByEvenSubtypeTable

; ---------------------------------------------------------------------------
word_3F63E:
                dc.w    $120
                dc.w    $138
                dc.w    $108
                dc.w    $150
                dc.w    $F0
                dc.w    $168
                dc.w    $D8
                dc.w    $180
                dc.w    $C0

; =============== S U B R O U T I N E =======================================

S3ContinueSelectCharacterIconFramesAndTailsChild:
                move.w  (Player_mode).w,d4
                cmpi.b  #2,d4
                bne.s   loc_3F664
                lea     ChildObjDat_3F66E(pc),a2
                jsr     (CreateChild6_Simple).l

loc_3F664:
                lsl.w   #2,d4
                move.l  off_3F674(pc,d4.w),$30(a0)
                rts
; End of function S3ContinueSelectCharacterIconFramesAndTailsChild

; ---------------------------------------------------------------------------
ChildObjDat_3F66E:
                dc.w    1-1
                dc.l    Obj_3F58E
off_3F674:
                dc.l    byte_3F834
                dc.l    byte_3F834
                dc.l    byte_3F836
                dc.l    byte_3F838
aCONTINUE:
                dc.w    0
                dc.w    $292
                dc.b    "C O N T I N U E",0
                even
Pal_ContinueScreen:
                binclude "data/General/Continue/Palettes/Palette S3.bin"
                even
