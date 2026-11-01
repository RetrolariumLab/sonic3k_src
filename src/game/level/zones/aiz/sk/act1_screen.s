; Owner: game/level/zones/aiz/sk
; Responsibility: Angel Island act-one screen and background setup, events, tree reveal and transition floor
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

AIZ1_ScreenInit:
                jsr     Adjust_AIZ1Chunks(pc)
                jsr     Reset_TileOffsetPositionActual(pc)
                jmp     Refresh_PlaneFull(pc)
; ---------------------------------------------------------------------------

AIZ1_ScreenEvent:
                jsr     DrawTilesAsYouMove(pc)
                move.w  (Events_fg_4).w,d0
                beq.w   locret_4F9BE
                cmpi.w  #$2D30,(Camera_X_pos).w         ; perform the tree tile manipulation routine when signaled
                bhs.w   AIZ1SE_ChangeChunk1
                cmpi.w  #$39,d0
                bhs.w   AIZ1SE_ChangeChunk1
                cmpi.w  #$34,d0
                blo.s   loc_4F93C
                bsr.w   AIZ1SE_ChangeChunk2
                bra.s   loc_4F952
; ---------------------------------------------------------------------------

loc_4F93C:
                cmpi.w  #$24,d0
                blo.s   loc_4F948
                bsr.w   AIZ1SE_ChangeChunk3
                bra.s   loc_4F952
; ---------------------------------------------------------------------------

loc_4F948:
                cmpi.w  #$14,d0
                blo.s   loc_4F952
                bsr.w   AIZ1SE_ChangeChunk4

loc_4F952:
                lea     (AIZ_TreeRevealArray).l,a6
                btst    #0,d0
                bne.s   loc_4F962
                lea     $10(a6),a6

loc_4F962:
                subq.w  #1,d0
                lsr.w   #1,d0
                move.w  d0,(Events_bg+$00).w
                cmpi.w  #3,d0
                blo.s   loc_4F976
                move.w  #2,(Events_bg+$00).w

loc_4F976:
                lsl.w   #4,d0
                neg.w   d0
                addi.w  #$470,d0

loc_4F97E:
                cmp.w   (Camera_Y_pos_rounded).w,d0
                bhs.s   loc_4F994
                lea     $20(a6),a6
                addi.w  #$10,d0
                subq.w  #1,(Events_bg+$00).w
                bpl.s   loc_4F97E
                bra.s   AIZ1SE_ChangeChunk1
; ---------------------------------------------------------------------------

loc_4F994:
                move.w  #$2C80,d1
                moveq   #$10,d6
                move.l  a0,-(sp)
                jsr     Setup_TileRowDraw(pc)
                movea.l (sp)+,a0
                subi.w  #$280,d0
                moveq   #0,d1
                moveq   #$F,d6
                jsr     (AIZ_TreeReveal).l
                lea     $10(a6),a6
                addi.w  #$290,d0
                subq.w  #1,(Events_bg+$00).w
                bpl.s   loc_4F97E

locret_4F9BE:
                rts
; ---------------------------------------------------------------------------

AIZ1SE_ChangeChunk1:
                clr.w   (Events_fg_4).w                 ; When this is run, all chunks have been changed and the routine need not be run anymore
                movea.w $14(a3),a1
                movea.w (a3),a5
                move.b  (a5),$59(a1)
                move.b  1(a5),$5A(a1)

; =============== S U B R O U T I N E =======================================

AIZ1SE_ChangeChunk2:
                movea.w $18(a3),a1
                movea.w 4(a3),a5
                move.b  (a5),$59(a1)
                move.b  1(a5),$5A(a1)
; End of function AIZ1SE_ChangeChunk2

; =============== S U B R O U T I N E =======================================

AIZ1SE_ChangeChunk3:
                movea.w $1C(a3),a1
                movea.w 8(a3),a5
                move.b  (a5),$59(a1)
                move.b  1(a5),$5A(a1)
; End of function AIZ1SE_ChangeChunk3

; =============== S U B R O U T I N E =======================================

AIZ1SE_ChangeChunk4:
                movea.w $20(a3),a1
                movea.w $C(a3),a5
                move.b  (a5),$59(a1)
                move.b  1(a5),$5A(a1)
                rts
; End of function AIZ1SE_ChangeChunk4

; ---------------------------------------------------------------------------

Obj_AIZ1TreeRevealControl:
                tst.w   $2E(a0)
                beq.s   loc_4FA1E
                tst.w   (Events_fg_4).w
                bne.s   loc_4FA1E
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_4FA1E:
                subq.w  #1,$2E(a0)
                move.w  #$480,d0
                sub.w   (Player_1+y_pos).w,d0
                lsr.w   #3,d0
                addq.w  #3,d0
                cmp.w   (Events_fg_4).w,d0
                bhs.s   loc_4FA3C
                btst    #0,$2F(a0)
                beq.s   locret_4FA40

loc_4FA3C:
                addq.w  #1,(Events_fg_4).w

locret_4FA40:
                rts

; =============== S U B R O U T I N E =======================================

Adjust_AIZ1Chunks:
                cmpi.w  #3,(Player_mode).w
                beq.s   Adjust_AIZ1Chunks2              ; Make changes to AIZ's chunk data if playing as Knuckles
                rts
; End of function Adjust_AIZ1Chunks

; =============== S U B R O U T I N E =======================================

Adjust_AIZ1Chunks2:
                lea     (Target_palette_line_4+$10).w,a1
                lea     word_4FAE4(pc),a5
                move.l  (a5)+,(a1)+
                move.l  (a5),(a1)
                lea     ((RAM_start+$4C70)&$FFFFFF).l,a1
                bsr.s   FillEightAiz1ChunkWordsWithBlock4B
                lea     ((RAM_start+$4CF0)&$FFFFFF).l,a1
                bsr.s   FillEightAiz1ChunkWordsWithBlock4B
                lea     ((RAM_start+$4D70)&$FFFFFF).l,a1
                bsr.s   FillEightAiz1ChunkWordsWithBlock4B
                lea     ((RAM_start+$52F0)&$FFFFFF).l,a1
                bsr.s   FillEightAiz1ChunkWordsWithBlock4B
                lea     ((RAM_start+$4980)&$FFFFFF).l,a1
                bsr.s   FillEightAiz1ChunkWordsWithBlock4B
                lea     ((RAM_start+$4D80)&$FFFFFF).l,a1
                bsr.s   FillEightAiz1ChunkWordsWithBlock4B
                lea     ((RAM_start+$3420)&$FFFFFF).l,a1
                bsr.s   FillEightAiz1ChunkWordsWithBlock4B
                move.w  #$402,(a1)+
                moveq   #6-1,d1
                bsr.s   FillAiz1ChunkWordsWithBlock4B
                move.w  #2,(a1)
                lea     ((RAM_start+$3FA0)&$FFFFFF).l,a1
                bsr.s   FillEightAiz1ChunkWordsWithBlock4B
                addq.w  #4,a1
                move.w  #$C,(a1)+
                move.w  #$406,(a1)+
                move.w  #$4B,(a1)+
                move.w  #$4B,(a1)+
                move.w  #$40A,2(a1)
                lea     ((RAM_start+$5820)&$FFFFFF).l,a1
                move.w  #$40B,(a1)+
                moveq   #6-1,d1
                bsr.s   FillAiz1ChunkWordsWithBlock4B
                addq.w  #6,a1
                move.w  #$C,(a1)+
                move.w  #$406,(a1)+
                moveq   #2-1,d1
                bra.s   FillAiz1ChunkWordsWithBlock4B
; End of function Adjust_AIZ1Chunks2

; =============== S U B R O U T I N E =======================================

FillEightAiz1ChunkWordsWithBlock4B:
                moveq   #8-1,d1
; End of function FillEightAiz1ChunkWordsWithBlock4B

; =============== S U B R O U T I N E =======================================

FillAiz1ChunkWordsWithBlock4B:
                moveq   #$4B,d0

loc_4FADC:
                move.w  d0,(a1)+
                dbf     d1,loc_4FADC
                rts
; End of function FillAiz1ChunkWordsWithBlock4B

; ---------------------------------------------------------------------------
word_4FAE4:
                dc.w    $EE4,  $EA6,  $E62
word_4FAEA:
                dc.w    $E40
; ---------------------------------------------------------------------------

AIZ1_BackgroundInit:
                cmpi.w  #$1300,(Camera_X_pos).w
                bhs.s   loc_4FB1C
                lea     (HScroll_table).w,a1            ; Intro deformation
                moveq   #bytesToLcnt($28),d0

loc_4FAFA:
                clr.l   (a1)+
                dbf     d0,loc_4FAFA
                jsr     (AIZ1_IntroDeform).l
                jsr     Reset_TileOffsetPositionEff(pc)
                jsr     Refresh_PlaneFull(pc)
                lea     (AIZ1_IntroDeformArray).l,a4
                lea     (HScroll_table+$028).w,a5
                jmp     ApplyDeformation(pc)
; ---------------------------------------------------------------------------

loc_4FB1C:
                move.w  #8,(Events_routine_bg).w        ; If not in the intro
                jsr     (AIZ1_Deform).l
                jsr     Reset_TileOffsetPositionEff(pc)
                clr.l   (HScroll_table).w
                move.w  d2,(HScroll_table+$006).w
                lea     (AIZ1_BGDrawArray).l,a4
                lea     (HScroll_table).w,a5
                jsr     Refresh_PlaneTileDeform(pc)
                jmp     (AIZ1_ApplyDeformWater).l
; ---------------------------------------------------------------------------

AIZ1_BackgroundEvent:
                move.w  (Events_routine_bg).w,d0
                jmp     AIZ1_BackgroundEvent_Index(pc,d0.w)
; ---------------------------------------------------------------------------

AIZ1_BackgroundEvent_Index:
                bra.w   AIZ1BGE_Intro
; ---------------------------------------------------------------------------
                bra.w   AIZ1BGE_NormalRefresh
; ---------------------------------------------------------------------------
                bra.w   AIZ1BGE_Normal
; ---------------------------------------------------------------------------
                bra.w   AIZ1BGE_FireTransition
; ---------------------------------------------------------------------------
                bra.w   AIZ1BGE_FireRefresh
; ---------------------------------------------------------------------------
                bra.w   AIZ1BGE_Finish
; ---------------------------------------------------------------------------

AIZ1BGE_Intro:
                tst.w   (Events_fg_5).w
                beq.s   loc_4FBA4
                tst.w   (Kos_decomp_queue_count).w
                bne.w   loc_4FBA4
                clr.w   (Events_fg_5).w
                jsr     (AIZ1_Deform).l                 ; Set up normal deformation when intro is over
                jsr     Reset_TileOffsetPositionEff(pc)
                clr.l   (HScroll_table).w
                move.w  d2,(HScroll_table+$006).w
                addi.w  #$E0,d0
                and.w   (Camera_Y_pos_mask).w,d0
                move.w  d0,(Draw_delayed_position).w
                move.w  #$F,(Draw_delayed_rowcount).w
                addq.w  #4,(Events_routine_bg).w        ; Next routine
                bra.s   loc_4FBD0
; ---------------------------------------------------------------------------

loc_4FBA4:
                jsr     (AIZ1_IntroDeform).l
                lea     (AIZ1_IntroDrawArray).l,a4
                lea     (HScroll_table).w,a5
                moveq   #$20,d6
                moveq   #$A,d5
                jsr     Draw_BG(pc)
                lea     (AIZ1_IntroDeformArray).l,a4
                lea     (HScroll_table+$028).w,a5
                jmp     ApplyDeformation(pc)
; ---------------------------------------------------------------------------

AIZ1BGE_NormalRefresh:
                jsr     (AIZ1_Deform).l

loc_4FBD0:
                lea     (AIZ1_BGDrawArray).l,a4
                lea     (HScroll_table-$04).w,a5
                move.w  (Camera_Y_pos_BG_copy).w,d1
                jsr     Draw_PlaneVertBottomUpComplex(pc)
                bpl.s   loc_4FBF6
                addq.w  #4,(Events_routine_bg).w
                bra.s   loc_4FBF6
; ---------------------------------------------------------------------------

AIZ1BGE_Normal:
                tst.w   (Events_fg_5).w
                bne.s   AIZ1_AIZ2_Transition            ; Wait for signal to start level transition
                jsr     (AIZ1_Deform).l

loc_4FBF6:
                lea     (AIZ1_BGDrawArray).l,a4
                lea     (HScroll_table).w,a5
                moveq   #$20,d6
                moveq   #2,d5
                jsr     Draw_BG(pc)
                jmp     (AIZ1_ApplyDeformWater).l
; ---------------------------------------------------------------------------

AIZ1_AIZ2_Transition:
                clr.w   (Events_fg_5).w
                lea     (Normal_palette_line_4+$2).w,a1
                move.l  #$4E006E,(a1)+
                move.l  #$AE00CE,(a1)+
                move.l  #$2EE0AEE,(a1)
                move.l  #$200000,(Camera_Y_pos_BG_copy).w
                move.w  #$10,(Camera_Y_pos_BG_rounded).w
                move.w  #$68,(Events_bg+$00).w
                move.w  #4,(Special_V_int_routine).w
                addq.w  #4,(Events_routine_bg).w

AIZ1BGE_FireTransition:
                tst.w   (Events_bg+$02).w
                bne.s   loc_4FC6E
                cmpi.b  #6,(Player_1+routine).w
                bhs.s   loc_4FC74
                move.w  (Events_bg+$00).w,d0
                swap    d0
                clr.w   d0
                sub.l   (Camera_Y_pos_BG_copy).w,d0
                asr.l   #5,d0
                add.l   d0,(Camera_Y_pos_BG_copy).w
                cmpi.l  #$1400,d0
                bhs.s   loc_4FC74

loc_4FC6E:
                jsr     (AIZ1_FireRise).l

loc_4FC74:
                lea     (Camera_Y_pos_BG_copy).w,a6
                lea     (Camera_Y_pos_BG_rounded).w,a5
                move.w  #$1000,d1
                moveq   #$20,d6
                jsr     Draw_TileRow(pc)
                cmpi.w  #$190,(Camera_Y_pos_BG_copy).w
                blo.w   loc_4FD22
                movem.l d7-a0/a2-a3,-(sp)
                lea     (AIZ2_128x128_Kos).l,a1
                lea     (RAM_start).l,a2
                jsr     (Queue_Kos).l
                lea     (AIZ2_16x16_Primary_Kos).l,a1
                lea     (Block_table).w,a2
                jsr     (Queue_Kos).l
                lea     (AIZ2_16x16_Secondary_Kos).l,a1
                lea     (Block_table+$AB8).w,a2
                jsr     (Queue_Kos).l
                lea     (AIZ2_8x8_Primary_KosM).l,a1
                move.w  #tiles_to_bytes($000),d2
                jsr     (Queue_Kos_Module).l
                lea     (AIZ2_8x8_Secondary_KosM).l,a1
                move.w  #tiles_to_bytes($1FC),d2
                jsr     (Queue_Kos_Module).l
                lea     (PLC_SpikesSprings).l,a1
                jsr     (Load_PLC_Raw).l
                movem.l (sp)+,d7-a0/a2-a3
                jsr     (AllocateObject).l
                bne.s   loc_4FD10
                move.l  #Obj_AIZTransitionFloor,(a1)
                move.w  #$2FB0,x_pos(a1)
                move.w  #$3A0,y_pos(a1)

loc_4FD10:
                move.w  #$F0,(Draw_delayed_position).w
                move.w  #$F,(Draw_delayed_rowcount).w
                addq.w  #4,(Events_routine_bg).w
                bra.s   loc_4FD32
; ---------------------------------------------------------------------------

loc_4FD22:
                jsr     (AIZTrans_WavyFlame).l
                jmp     PlainDeformation(pc)
; ---------------------------------------------------------------------------

AIZ1BGE_FireRefresh:
                jsr     (AIZ1_FireRise).l

loc_4FD32:
                lea     (Level_layout_main).w,a3
                move.w  #VRAM_Plane_A_Name_Table,d7
                move.w  #$180,d1
                moveq   #0,d2
                jsr     Draw_PlaneVertBottomUp(pc)      ; Refresh main plane
                bpl.s   loc_4FD52
                addq.w  #2,a3
                move.w  #VRAM_Plane_B_Name_Table,d7
                addq.w  #4,(Events_routine_bg).w
                bra.s   loc_4FD62
; ---------------------------------------------------------------------------

loc_4FD52:
                jsr     (AIZTrans_WavyFlame).l
                jmp     PlainDeformation(pc)
; ---------------------------------------------------------------------------

AIZ1BGE_Finish:
                jsr     (AIZ1_FireRise).l

loc_4FD62:
                tst.b   (Kos_modules_left).w
                bne.w   loc_4FE2E                       ; Wait for the art to be loaded
                move.w  #1,(Current_zone_and_act).w     ; Officially change this to act 2
                clr.b   (Dynamic_resize_routine).w
                clr.b   (Object_load_routine).w
                clr.b   (Rings_manager_routine).w
                clr.b   (Boss_flag).w
                clr.b   (Respawn_table_keep).w
                jsr     Clear_Switches(pc)
                movem.l d7-a0/a2-a3,-(sp)
                jsr     (Load_Level).l
                jsr     (LoadSolids).l
                jsr     (CheckLevelForWater).l
                moveq   #PalID_AIZFire,d0
                jsr     (LoadPalette_Immediate).l
                movem.l (sp)+,d7-a0/a2-a3
                jsr     Adjust_AIZ2Layout(pc)
                lea     (Normal_palette_line_4+$2).w,a1
                move.l  #$4E006E,(a1)+
                move.l  #$AE00CE,(a1)+
                move.l  #$2EE0AEE,(a1)
                move.w  #$2F00,d0
                move.w  #$80,d1
                sub.w   d0,(Player_1+x_pos).w
                sub.w   d1,(Player_1+y_pos).w
                sub.w   d0,(Player_2+x_pos).w
                sub.w   d1,(Player_2+y_pos).w
                jsr     Offset_SomeObjectsDuringTransition(pc)
                sub.w   d0,(Camera_X_pos).w
                sub.w   d1,(Camera_Y_pos).w
                sub.w   d0,(Camera_X_pos_copy).w
                sub.w   d1,(Camera_Y_pos_copy).w        ; Offset objects and camera positions
                move.l  #$100010,d0
                move.l  d0,(Camera_min_X_pos).w
                move.l  #$260,d0
                move.l  d0,(Camera_min_Y_pos).w
                move.w  d0,(Camera_target_max_Y_pos).w
                move.w  (Camera_X_pos_copy).w,(Events_fg_0).w
                move.w  (Camera_X_pos_copy).w,(Events_fg_1).w
                jsr     Reset_TileOffsetPositionActual(pc)
                addi.w  #$E0,d0
                and.w   (Camera_Y_pos_mask).w,d0
                move.w  d0,(Draw_delayed_position).w
                move.w  #$F,(Draw_delayed_rowcount).w
                clr.w   (Events_routine_bg).w

loc_4FE2E:
                jsr     (AIZTrans_WavyFlame).l
                jmp     PlainDeformation(pc)
; ---------------------------------------------------------------------------

Obj_AIZTransitionFloor:
                tst.b   (Current_act).w
                beq.s   loc_4FE4A
                move.w  #$7FFF,x_pos(a0)
                move.l  #Delete_Current_Sprite,(a0)

loc_4FE4A:
                move.b  #$10,height_pixels(a0)
                bset    #7,status(a0)
                move.w  #$A0,d1
                moveq   #$10,d2
                moveq   #$10,d3
                move.w  x_pos(a0),d4
                jmp     (SolidObjectTop).l

; =============== S U B R O U T I N E =======================================

Adjust_AIZ2Layout:
                cmpi.w  #3,(Player_mode).w
                bne.s   loc_4FECC
                move.w  #$5B,((RAM_start+$1020)&$FFFFFF).l  ; Only do this if playing as Knuckles
                lea     ((RAM_start+$3420)&$FFFFFF).l,a1
                moveq   #8-1,d1
                bsr.s   FillAiz2ChunkWordsWithBlock5B
                move.w  #$CAE,(a1)+
                moveq   #6-1,d1
                bsr.s   FillAiz2ChunkWordsWithBlock5B
                move.w  #$8AE,(a1)
                lea     ((RAM_start+$3FA0)&$FFFFFF).l,a1
                moveq   #8-1,d1
                bsr.s   FillAiz2ChunkWordsWithBlock5B
                addq.w  #4,a1
                move.w  #$4B6,(a1)+
                move.w  #$4CC,(a1)+
                move.w  #$5B,(a1)+
                move.w  #$5B,(a1)+
                move.w  #$4B7,2(a1)
                lea     ((RAM_start+$5822)&$FFFFFF).l,a1
                moveq   #6-1,d1
                bsr.s   FillAiz2ChunkWordsWithBlock5B
                addq.w  #6,a1
                move.w  #$4B6,(a1)+
                move.w  #$4CC,(a1)+
                move.w  #$5B,(a1)+
                move.w  #$5B,(a1)

loc_4FECC:
                movea.w (Level_layout_main+$0C).w,a1
                movea.w (Level_layout_main+$40).w,a5
                move.b  $7F(a1),$63(a5)
                movea.w (Level_layout_main+$0A).w,a1
                movea.w (Level_layout_main+$1E).w,a5
                bsr.s   CopyFourAiz2LayoutChunkIndices
                movea.w (Level_layout_main+$0E).w,a1
                movea.w (Level_layout_main+$22).w,a5
                bsr.s   CopyFourAiz2LayoutChunkIndices
                movea.w (Level_layout_main+$12).w,a1
                movea.w (Level_layout_main+$26).w,a5
; End of function Adjust_AIZ2Layout

; =============== S U B R O U T I N E =======================================

CopyFourAiz2LayoutChunkIndices:
                moveq   #4-1,d0

                .loop:
                move.b  (a1)+,(a5)+
                dbf     d0,.loop
                rts
; End of function CopyFourAiz2LayoutChunkIndices

; =============== S U B R O U T I N E =======================================

FillAiz2ChunkWordsWithBlock5B:
                moveq   #$5B,d0

                .loop:
                move.w  d0,(a1)+
                dbf     d1,.loop
                rts
; End of function FillAiz2ChunkWordsWithBlock5B
