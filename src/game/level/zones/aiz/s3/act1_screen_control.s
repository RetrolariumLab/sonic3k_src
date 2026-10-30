; Owner: game/level/zones/aiz/s3
; Responsibility: Angel Island act-one screen initialization, event control and introductory tree-reveal objects
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

AIZ1_ScreenInit:
                jsr     Reset_TileOffsetPositionActual(pc)
                jmp     Refresh_PlaneFull(pc)
; ---------------------------------------------------------------------------

AIZ1_ScreenEvent:
                jsr     DrawTilesAsYouMove(pc)
                move.w  (Events_fg_4).w,d0
                beq.w   locret_3AB48
                cmpi.w  #$2D30,(Camera_X_pos_copy).w    ; perform the tree tile manipulation routine when signaled
                bhs.w   AIZ1SE_ChangeChunk1
                cmpi.w  #$39,d0
                bhs.w   AIZ1SE_ChangeChunk1
                cmpi.w  #$34,d0
                blo.s   loc_3AACC
                bsr.w   AIZ1SE_ChangeChunk2
                bra.s   loc_3AAE2
; ---------------------------------------------------------------------------

loc_3AACC:
                cmpi.w  #$24,d0
                blo.s   loc_3AAD8
                bsr.w   AIZ1SE_ChangeChunk3
                bra.s   loc_3AAE2
; ---------------------------------------------------------------------------

loc_3AAD8:
                cmpi.w  #$14,d0
                blo.s   loc_3AAE2
                bsr.w   AIZ1SE_ChangeChunk4

loc_3AAE2:
                lea     AIZ_TreeRevealArray(pc),a6
                btst    #0,d0
                bne.s   loc_3AAF0
                lea     $10(a6),a6

loc_3AAF0:
                subq.w  #1,d0
                lsr.w   #1,d0
                move.w  d0,(Events_bg+$00).w
                cmpi.w  #3,d0
                blo.s   loc_3AB04
                move.w  #2,(Events_bg+$00).w

loc_3AB04:
                lsl.w   #4,d0
                neg.w   d0
                addi.w  #$470,d0

loc_3AB0C:
                cmp.w   (Camera_Y_pos_rounded).w,d0
                bhs.s   loc_3AB22
                lea     $20(a6),a6
                addi.w  #$10,d0
                subq.w  #1,(Events_bg+$00).w
                bpl.s   loc_3AB0C
                bra.s   AIZ1SE_ChangeChunk1
; ---------------------------------------------------------------------------

loc_3AB22:
                move.w  #$2C80,d1
                moveq   #$10,d6
                move.l  a0,-(sp)
                jsr     Setup_TileRowDraw(pc)
                movea.l (sp)+,a0
                subi.w  #$280,d0
                moveq   #0,d1
                moveq   #$F,d6
                bsr.s   AIZ_TreeReveal
                lea     $10(a6),a6
                addi.w  #$290,d0
                subq.w  #1,(Events_bg+$00).w
                bpl.s   loc_3AB0C

locret_3AB48:
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

; =============== S U B R O U T I N E =======================================

AIZ_TreeReveal:
                asr.w   #4,d1
                move.w  d1,d2
                asr.w   #3,d1
                add.w   d2,d2
                andi.w  #$E,d2
                addq.w  #4,a0
                movea.l a0,a1
                lea     $40(a0),a0
                jsr     Get_LevelAddrChunkRow(pc)

loc_3ABAE:
                move.w  (a5,d2.w),d3
                move.w  d3,d4
                andi.w  #$3FF,d3
                lsl.w   #3,d3
                move.l  (a2,d3.w),d5
                move.l  4(a2,d3.w),d3
                btst    #$B,d4
                beq.s   loc_3ABD6
                eori.l  #$10001000,d5
                eori.l  #$10001000,d3
                exg     d3,d5

loc_3ABD6:
                btst    #$A,d4
                beq.s   loc_3ABEC
                eori.l  #$8000800,d5
                eori.l  #$8000800,d3
                swap    d5
                swap    d3

loc_3ABEC:
                tst.b   (a6)+
                beq.s   loc_3ABF2
                move.l  d5,(a1)

loc_3ABF2:
                addq.w  #4,a1
                tst.b   $F(a6)
                beq.s   loc_3ABFC
                move.l  d3,(a0)

loc_3ABFC:
                addq.w  #4,a0
                addq.w  #2,d2
                andi.w  #$E,d2
                bne.s   loc_3AC0C
                addq.w  #1,d1
                jsr     Get_ChunkRow(pc)

loc_3AC0C:
                dbf     d6,loc_3ABAE
                clr.w   (a0)
                rts
; End of function AIZ_TreeReveal

; ---------------------------------------------------------------------------

Obj_AIZ1TreeRevealControl:
                tst.w   $2E(a0)
                beq.s   loc_3AC26
                tst.w   (Events_fg_4).w
                bne.s   loc_3AC26
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_3AC26:
                subq.w  #1,$2E(a0)
                move.w  #$480,d0
                sub.w   (Player_1+y_pos).w,d0
                lsr.w   #3,d0
                addq.w  #3,d0
                cmp.w   (Events_fg_4).w,d0
                bhs.s   loc_3AC44
                btst    #0,$2F(a0)
                beq.s   locret_3AC48

loc_3AC44:
                addq.w  #1,(Events_fg_4).w

locret_3AC48:
                rts
; ---------------------------------------------------------------------------
AIZ_TreeRevealArray:
                dc.b    0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
                dc.b    0,   0,   0,   0,   0,   1,   1,   1,   1,   1,   1,   0,   0,   0,   0,   0
                dc.b    0,   0,   0,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   0,   0,   0
                dc.b    0,   0,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   0,   0
                dc.b    0,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   0
                dc.b    1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1
                dc.b    1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1
                even
; ---------------------------------------------------------------------------

AIZ1_BackgroundInit:
                cmpi.w  #$1300,(Camera_X_pos_copy).w
                bhs.s   loc_3ACE6
                lea     (HScroll_table).w,a1            ; Intro deformation
                moveq   #bytesToLcnt($28),d0

loc_3ACC8:
                clr.l   (a1)+
                dbf     d0,loc_3ACC8
                jsr     AIZ1_IntroDeform(pc)
                jsr     Reset_TileOffsetPositionEff(pc)
                jsr     Refresh_PlaneFull(pc)
                lea     AIZ1_IntroDeformArray(pc),a4
                lea     (HScroll_table+$028).w,a5
                jmp     ApplyDeformation(pc)
; ---------------------------------------------------------------------------

loc_3ACE6:
                move.w  #8,(Events_routine_bg).w        ; If not in the intro
                jsr     AIZ1_Deform(pc)
                jsr     Reset_TileOffsetPositionEff(pc)
                clr.l   (HScroll_table).w
                move.w  d2,(HScroll_table+$006).w
                lea     AIZ1_BGDrawArray(pc),a4
                lea     (HScroll_table).w,a5
                jsr     Refresh_PlaneTileDeform(pc)
                jmp     AIZ1_ApplyDeformWater(pc)
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
                beq.s   loc_3AD66
                tst.w   (Kos_decomp_queue_count).w
                bne.w   loc_3AD66
                clr.w   (Events_fg_5).w
                jsr     AIZ1_Deform(pc)                 ; Set up normal deformation when intro is over
                jsr     Reset_TileOffsetPositionEff(pc)
                clr.l   (HScroll_table).w
                move.w  d2,(HScroll_table+$006).w
                addi.w  #$E0,d0
                and.w   (Camera_Y_pos_mask).w,d0
                move.w  d0,(Draw_delayed_position).w
                move.w  #$F,(Draw_delayed_rowcount).w
                addq.w  #4,(Events_routine_bg).w        ; Next routine
                bra.s   loc_3AD8A
; ---------------------------------------------------------------------------

loc_3AD66:
                jsr     AIZ1_IntroDeform(pc)
                lea     AIZ1_IntroDrawArray(pc),a4
                lea     (HScroll_table).w,a5
                moveq   #$20,d6
                moveq   #$A,d5
                jsr     Draw_BG(pc)
                lea     AIZ1_IntroDeformArray(pc),a4
                lea     (HScroll_table+$028).w,a5
                jmp     ApplyDeformation(pc)
; ---------------------------------------------------------------------------

AIZ1BGE_NormalRefresh:
                jsr     AIZ1_Deform(pc)

loc_3AD8A:
                lea     AIZ1_BGDrawArray(pc),a4
                lea     (HScroll_table-$04).w,a5
                move.w  (Camera_Y_pos_BG_copy).w,d1
                jsr     Draw_PlaneVertBottomUpComplex(pc)
                bpl.s   loc_3ADAC
                addq.w  #4,(Events_routine_bg).w
                bra.s   loc_3ADAC
; ---------------------------------------------------------------------------

AIZ1BGE_Normal:
                tst.w   (Events_fg_5).w
                bne.s   AIZ1_AIZ2_Transition            ; Wait for signal to start level transition
                jsr     AIZ1_Deform(pc)

loc_3ADAC:
                lea     AIZ1_BGDrawArray(pc),a4
                lea     (HScroll_table).w,a5
                moveq   #$20,d6
                moveq   #2,d5
                jsr     Draw_BG(pc)
                jmp     AIZ1_ApplyDeformWater(pc)
; ---------------------------------------------------------------------------

AIZ1_AIZ2_Transition:
                clr.w   (Events_fg_5).w
                lea     (Normal_palette_line_4+2).w,a1
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
                bne.s   loc_3AE18
                move.w  (Events_bg+$00).w,d0
                swap    d0
                clr.w   d0
                sub.l   (Camera_Y_pos_BG_copy).w,d0
                asr.l   #5,d0
                add.l   d0,(Camera_Y_pos_BG_copy).w
                cmpi.l  #$1400,d0
                bhs.s   loc_3AE1C

loc_3AE18:
                jsr     AIZ1_FireRise(pc)

loc_3AE1C:
                lea     (Camera_Y_pos_BG_copy).w,a6
                lea     (Camera_Y_pos_BG_rounded).w,a5
                move.w  #$1000,d1
                moveq   #$20,d6
                jsr     Draw_TileRow(pc)
                cmpi.w  #$190,(Camera_Y_pos_BG_copy).w
                blo.w   loc_3AECA
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
                bne.s   loc_3AEB8
                move.l  #Obj_AIZTransitionFloor,(a1)
                move.w  #$2FB0,x_pos(a1)
                move.w  #$3A0,y_pos(a1)

loc_3AEB8:
                move.w  #$F0,(Draw_delayed_position).w
                move.w  #$F,(Draw_delayed_rowcount).w
                addq.w  #4,(Events_routine_bg).w
                bra.s   loc_3AED6
; ---------------------------------------------------------------------------

loc_3AECA:
                jsr     AIZTrans_WavyFlame(pc)
                jmp     PlainDeformation(pc)
; ---------------------------------------------------------------------------

AIZ1BGE_FireRefresh:
                jsr     AIZ1_FireRise(pc)

loc_3AED6:
                lea     (Level_layout_main).w,a3
                move.w  #VRAM_Plane_A_Name_Table,d7
                move.w  #$180,d1
                moveq   #0,d2
                jsr     Draw_PlaneVertBottomUp(pc)      ; Refresh main plane
                bpl.s   loc_3AEF6
                addq.w  #2,a3
                move.w  #VRAM_Plane_B_Name_Table,d7
                addq.w  #4,(Events_routine_bg).w
                bra.s   loc_3AF02
; ---------------------------------------------------------------------------

loc_3AEF6:
                jsr     AIZTrans_WavyFlame(pc)
                jmp     PlainDeformation(pc)
; ---------------------------------------------------------------------------

AIZ1BGE_Finish:
                jsr     AIZ1_FireRise(pc)

loc_3AF02:
                tst.b   (Kos_modules_left).w
                bne.w   loc_3AFCA                       ; Wait for the art to be loaded
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
                sub.w   d0,(Camera_X_pos).w
                sub.w   d1,(Camera_Y_pos).w
                sub.w   d0,(Camera_X_pos_copy).w
                sub.w   d1,(Camera_Y_pos_copy).w        ; Offset objects and camera positions
                move.l  #$100010,d0
                move.l  #$260,d1
                move.l  d0,(Camera_min_X_pos).w
                move.l  d0,(Camera_target_min_X_pos).w
                move.l  d1,(Camera_min_Y_pos).w
                move.l  d1,(Camera_target_min_Y_pos).w
                move.w  (Camera_X_pos_copy).w,(Events_fg_0).w
                move.w  (Camera_X_pos_copy).w,(Events_fg_1).w
                jsr     Reset_TileOffsetPositionActual(pc)
                addi.w  #$E0,d0
                and.w   (Camera_Y_pos_mask).w,d0
                move.w  d0,(Draw_delayed_position).w
                move.w  #$F,(Draw_delayed_rowcount).w
                clr.w   (Events_routine_bg).w

loc_3AFCA:
                jsr     AIZTrans_WavyFlame(pc)
                jmp     PlainDeformation(pc)
