; Owner: game/level/zones/lbz/s3
; Responsibility: Launch Base act-one screen control, invisible barrier object, background events and deformation
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

LBZ1_ScreenInit:
                move.w  4(a3),d0
                subi.w  #$76,d0
                move.w  d0,$70(a3)
                move.w  d0,$74(a3)
                move.w  d0,$78(a3)
                move.w  d0,$7C(a3)
                lea     (HScroll_table+$148).w,a1
                moveq   #$E-1,d0

S3LBZ_ActOneClearInitialVerticalOffsets:
                clr.l   (a1)+                           ; Clear VScroll
                dbf     d0,S3LBZ_ActOneClearInitialVerticalOffsets
                jsr     LBZ1_EventVScroll(pc)
                lea     (HScroll_table+$100).w,a1
                moveq   #$C-1,d0

S3LBZ1Screen_InitMaskedVScroll:
                move.w  (a1)+,d1
                and.w   (Camera_Y_pos_mask).w,d1
                move.w  d1,(a1)+                        ; Set up tile offsets for VScroll array
                dbf     d0,S3LBZ1Screen_InitMaskedVScroll
                cmpi.w  #3,(Player_mode).w
                beq.s   S3LBZ1Screen_ApplyInitialEndingLayout
                cmpi.w  #$3B60,(Camera_X_pos_copy).w    ; Skip this if Knuckles
                blo.s   S3LBZ1Screen_InitForeground
                jsr     (AllocateObject).l
                bne.s   S3LBZ1Screen_ApplyInitialEndingLayout
                move.l  #Obj_LBZ1InvisibleBarrier,(a1)

S3LBZ1Screen_ApplyInitialEndingLayout:
                jsr     LBZ1_ModEndingLayout(pc)

S3LBZ1Screen_InitForeground:
                move.w  (Player_1+x_pos).w,d0
                move.w  (Player_1+y_pos).w,d1
                moveq   #0,d2
                jsr     LBZ1_CheckLayoutMod(pc)
                jsr     Reset_TileOffsetPositionActual(pc)
                jmp     Refresh_PlaneFull(pc)
; ---------------------------------------------------------------------------

LBZ1_ScreenEvent:
                move.w  (Screen_shake_offset).w,d0
                add.w   d0,(Camera_Y_pos_copy).w
                cmpi.w  #$55,(Events_fg_4).w
                bne.s   S3LBZ_ActOneUpdateLayoutFromPlayerRegion
                clr.w   (Events_fg_4).w
                cmpi.w  #$540,(Camera_Y_pos_copy).w
                bcc.s   S3LBZ1Screen_PatchLowerBossChunk
                movea.w 8(a3),a1
                move.b  #$DA,$7D(a1)                    ; Changes the chunk where the boss appears
                jmp     Refresh_PlaneScreenDirect(pc)
; ---------------------------------------------------------------------------

S3LBZ1Screen_PatchLowerBossChunk:
                movea.w $4C(a3),a1
                move.b  #$DB,$79(a1)
                jmp     Refresh_PlaneScreenDirect(pc)
; ---------------------------------------------------------------------------

S3LBZ_ActOneUpdateLayoutFromPlayerRegion:
                move.w  (Player_1+x_pos).w,d0           ; Normal level operation
                move.w  (Player_1+y_pos).w,d1
                move.w  (Events_bg+$00).w,d2
                bne.s   S3LBZ_ActOneTestActiveLayoutExitInterval
                jsr     LBZ1_CheckLayoutMod(pc)
                tst.w   d3
                bmi.s   S3LBZ1Screen_DrawVertDeformedFg
                jmp     Refresh_PlaneScreenDirect(pc)   ; Refresh screen when a layout mod is made
; ---------------------------------------------------------------------------

S3LBZ_ActOneTestActiveLayoutExitInterval:
                lea     LBZ1_LayoutModExitRange-4(pc),a1  ; If already in a layout
                adda.w  d2,a1
                cmp.w   (a1)+,d0
                blo.s   S3LBZ1Screen_RestoreLayoutAndRefresh
                cmp.w   (a1)+,d0
                bhi.s   S3LBZ1Screen_RestoreLayoutAndRefresh
                bra.s   S3LBZ1Screen_DrawVertDeformedFg
; ---------------------------------------------------------------------------

S3LBZ1Screen_RestoreLayoutAndRefresh:
                clr.w   (Events_bg+$00).w
                lsr.w   #1,d2
                jsr     S3LBZ1Screen_LayoutExitBranches-2(pc,d2.w)
                jmp     Refresh_PlaneScreenDirect(pc)
; ---------------------------------------------------------------------------

S3LBZ1Screen_LayoutExitBranches:
                bra.s   LBZ1_LayoutExitMod1
; ---------------------------------------------------------------------------
                bra.s   LBZ1_LayoutExitMod2
; ---------------------------------------------------------------------------
                bra.s   LBZ1_LayoutExitMod3
; ---------------------------------------------------------------------------
                bra.s   LBZ1_LayoutExitMod4
; ---------------------------------------------------------------------------

LBZ1_LayoutExitMod1:
                movea.w (a3),a5
                lea     $88(a5),a5
                bra.w   LBZ1_DoMod1
; ---------------------------------------------------------------------------

LBZ1_LayoutExitMod2:
                movea.w $24(a3),a5
                lea     $8A(a5),a5
                bra.w   LBZ1_DoMod2
; ---------------------------------------------------------------------------

LBZ1_LayoutExitMod3:
                movea.w (a3),a5
                lea     $98(a5),a5
                bra.w   LBZ1_DoMod3
; ---------------------------------------------------------------------------

LBZ1_LayoutExitMod4:
                movea.w $30(a3),a5
                lea     $9A(a5),a5
                bra.w   LBZ1_DoMod4
; ---------------------------------------------------------------------------

S3LBZ1Screen_DrawVertDeformedFg:
                jsr     LBZ1_EventVScroll(pc)           ; Do the vscroll deformation, if necessary
                lea     LBZ1_FGVScrollArray(pc),a4
                lea     (HScroll_table+$100).w,a5
                moveq   #$F,d6
                moveq   #$C,d5
                jmp     DrawTilesVDeform(pc)

; =============== S U B R O U T I N E =======================================

LBZ1_EventVScroll:
                tst.w   (Events_fg_4).w
                beq.w   S3LBZ_ActOnePrepareVerticalOffsetExport
                bpl.s   S3LBZ_ActOnePrepareCollapseIntegration
                move.w  #1,(Events_fg_4).w
                move.w  #4,(Special_V_int_routine).w
                jsr     (AllocateObject).l
                bne.s   S3LBZ_ActOnePrepareCollapseIntegration
                move.l  #Obj_LBZ1InvisibleBarrier,(a1)

S3LBZ_ActOnePrepareCollapseIntegration:
                lea     (HScroll_table+$14C).w,a1
                lea     LBZ1_CollapseScrollSpeed(pc),a5
                move.l  $2C(a1),d0
                addi.l  #$100,$2C(a1)
                move.w  $30(a1),d1
                addq.w  #1,$30(a1)
                asr.w   #6,d1
                moveq   #$A,d2
                moveq   #$A-1,d3

S3LBZ_ActOneIntegrateOneCollapseStrip:
                addq.w  #2,d1
                andi.w  #$E,d1
                move.w  (a5,d1.w),d4
                ext.l   d4
                lsl.l   #4,d4
                move.l  (a1),d5
                sub.l   d4,d5
                sub.l   d0,d5
                swap    d5
                cmpi.w  #-$300,d5
                bgt.s   S3LBZ1Screen_StoreCollapseStrip
                move.w  #-$300,d5
                subq.w  #1,d2

S3LBZ1Screen_StoreCollapseStrip:
                swap    d5
                move.l  d5,(a1)+
                dbf     d3,S3LBZ_ActOneIntegrateOneCollapseStrip
                move.w  (Level_frame_counter).w,d0
                subq.w  #1,d0
                andi.w  #$F,d0
                bne.s   S3LBZ1Screen_TryFinishCollapse
                tst.w   d2
                beq.s   S3LBZ1Screen_TryFinishCollapse
                moveq   #signextendB(sfx_BigRumble),d0
                jsr     (Play_SFX).l

S3LBZ1Screen_TryFinishCollapse:
                tst.w   d2
                bne.s   S3LBZ_ActOnePrepareVerticalOffsetExport
                clr.w   (Screen_shake_flag).w
                clr.w   (Events_fg_4).w
                move.w  #$C,(Special_V_int_routine).w
                jsr     LBZ1_ModEndingLayout(pc)
                lea     (HScroll_table+$148).w,a1
                moveq   #$E-1,d0

S3LBZ_ActOneClearFinishedCollapseOffsets:
                clr.l   (a1)+
                dbf     d0,S3LBZ_ActOneClearFinishedCollapseOffsets
                moveq   #signextendB(sfx_Crash),d0
                jsr     (Play_SFX).l

S3LBZ_ActOnePrepareVerticalOffsetExport:
                lea     (HScroll_table+$100).w,a1
                lea     (HScroll_table+$130).w,a4
                lea     (HScroll_table+$148).w,a5
                move.w  (Camera_Y_pos_copy).w,d0
                moveq   #$C-1,d1

S3LBZ_ActOnePublishVerticalScrollColumns:
                move.w  (a5),d2
                add.w   d0,d2
                move.w  d2,(a1)
                move.w  d2,(a4)+
                addq.w  #4,a1
                addq.w  #4,a5
                dbf     d1,S3LBZ_ActOnePublishVerticalScrollColumns
                rts
; End of function LBZ1_EventVScroll

; =============== S U B R O U T I N E =======================================

LBZ1_CheckLayoutMod:
                lea     LBZ1_LayoutModRange(pc),a1
                moveq   #4-1,d3

S3LBZ_ActOneScanInclusiveLayoutRectangle:
                lea     (a1),a5
                cmp.w   (a5)+,d0
                bcs.s   S3LBZ1Screen_NextLayoutRegion
                cmp.w   (a5)+,d0
                bhi.s   S3LBZ1Screen_NextLayoutRegion
                cmp.w   (a5)+,d1
                bcs.s   S3LBZ1Screen_NextLayoutRegion
                cmp.w   (a5)+,d1
                bhi.s   S3LBZ1Screen_NextLayoutRegion
                tst.w   d2
                bne.s   S3LBZ1Screen_DispatchLayoutCopy
                cmpi.w  #$1580,d0                       ; The first layout mod range ignores a small corner on the lower right
                bcs.s   S3LBZ1Screen_DispatchLayoutCopy
                cmpi.w  #$400,d1
                bcs.s   S3LBZ1Screen_DispatchLayoutCopy

S3LBZ1Screen_NextLayoutRegion:
                addq.w  #8,a1
                addq.w  #4,d2
                dbf     d3,S3LBZ_ActOneScanInclusiveLayoutRectangle
                rts
; ---------------------------------------------------------------------------

S3LBZ1Screen_DispatchLayoutCopy:
                addq.w  #4,d2
                move.w  d2,(Events_bg+$00).w
                lsr.w   #1,d2
                jmp     LBZ1_LayoutModBranch-2(pc,d2.w)
; ---------------------------------------------------------------------------

LBZ1_LayoutModBranch:
                bra.s   LBZ1_LayoutMod1
; ---------------------------------------------------------------------------
                bra.s   LBZ1_LayoutMod2
; ---------------------------------------------------------------------------
                bra.s   LBZ1_LayoutMod3
; ---------------------------------------------------------------------------
                bra.s   LBZ1_LayoutMod4
; ---------------------------------------------------------------------------

LBZ1_LayoutMod1:
                movea.w (a3),a5
                lea     $80(a5),a5
                bra.w   LBZ1_DoMod1
; ---------------------------------------------------------------------------

LBZ1_LayoutMod2:
                movea.w $24(a3),a5
                lea     $80(a5),a5
                bra.s   LBZ1_DoMod2
; ---------------------------------------------------------------------------

LBZ1_LayoutMod3:
                tst.w   (Events_bg+$02).w
                beq.s   S3LBZ1Screen_SelectThirdLayoutSource
                clr.w   (Events_bg+$00).w
                moveq   #-1,d3
                rts
; ---------------------------------------------------------------------------

S3LBZ1Screen_SelectThirdLayoutSource:
                movea.w (a3),a5
                lea     $94(a5),a5
                bra.s   LBZ1_DoMod3
; ---------------------------------------------------------------------------

LBZ1_LayoutMod4:
                movea.w $30(a3),a5
                lea     $94(a5),a5

LBZ1_DoMod4:
                movea.w (a3),a1
                lea     $7A(a1),a1
                move.w  -8(a3),d0
                subq.w  #6,d0
                moveq   #6-1,d1

S3LBZ_ActOneCopyFourthLayoutSixByteRows:
                move.l  (a5)+,(a1)+
                move.w  (a5)+,(a1)+
                adda.w  d0,a5
                adda.w  d0,a1
                dbf     d1,S3LBZ_ActOneCopyFourthLayoutSixByteRows
                rts
; ---------------------------------------------------------------------------

LBZ1_DoMod3:
                movea.w (a3),a1
                lea     $74(a1),a1
                move.w  -8(a3),d0
                subq.w  #4,d0
                moveq   #$C-1,d1

S3LBZ_ActOneCopyThirdLayoutFourByteRows:
                move.l  (a5)+,(a1)+
                adda.w  d0,a5
                adda.w  d0,a1
                dbf     d1,S3LBZ_ActOneCopyThirdLayoutFourByteRows
                rts
; ---------------------------------------------------------------------------

LBZ1_DoMod2:
                movea.w (a3),a1
                lea     $42(a1),a1
                move.w  -8(a3),d0
                subi.w  #$A,d0
                moveq   #$E-1,d1

S3LBZ_ActOneCopySecondLayoutTenByteRows:
                move.l  (a5)+,(a1)+
                move.l  (a5)+,(a1)+
                move.w  (a5)+,(a1)+
                adda.w  d0,a5
                adda.w  d0,a1
                dbf     d1,S3LBZ_ActOneCopySecondLayoutTenByteRows
                rts
; ---------------------------------------------------------------------------

LBZ1_DoMod1:
                movea.w 8(a3),a1
                lea     $26(a1),a1
                move.w  -8(a3),d0
                subq.w  #8,d0
                moveq   #9-1,d1

S3LBZ_ActOneCopyFirstLayoutEightByteRows:
                move.l  (a5)+,(a1)+
                move.l  (a5)+,(a1)+
                adda.w  d0,a5
                adda.w  d0,a1
                dbf     d1,S3LBZ_ActOneCopyFirstLayoutEightByteRows
                rts

; End of function LBZ1_CheckLayoutMod

; =============== S U B R O U T I N E =======================================

LBZ1_ModEndingLayout:
                movea.w (a3),a1                         ; This ensures that when Sonic starts from the starpost before the boss the building behind him disappears
                lea     $74(a1),a1                      ; It also doubles as the layout used by Knuckles in his version of the level
                move.w  -8(a3),d0
                subq.w  #4,d0
                moveq   #$C-1,d1

S3LBZ_ActOneClearEndingLayoutTwelveRows:
                clr.l   (a1)+
                adda.w  d0,a1
                dbf     d1,S3LBZ_ActOneClearEndingLayoutTwelveRows
                st      (Events_bg+$02).w               ; Disable the layout modding for this area (layoutmod3)
                rts
; End of function LBZ1_ModEndingLayout

; ---------------------------------------------------------------------------

Obj_LBZ1InvisibleBarrier:
                cmpi.w  #$3D80,(Camera_X_pos_copy).w
                blo.s   S3LBZ1Screen_ApplyEndingBarrier
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

S3LBZ1Screen_ApplyEndingBarrier:
                move.w  #$3BC0,d4
                move.w  d4,x_pos(a0)
                move.w  #$100,y_pos(a0)
                move.b  #$40,width_pixels(a0)
                bset    #7,status(a0)
                moveq   #$4B,d1
                move.w  #$100,d2
                move.w  #$100,d3
                jmp     (SolidObjectFull2).l
; ---------------------------------------------------------------------------
LBZ1_FGVScrollArray:
                dc.w    $3B60,   $10,   $10,   $10,   $10,   $10,   $10,   $10,   $10,   $10,   $10, $7FFF
LBZ1_LayoutModRange:
                dc.w    $13E0, $16A0,  $100,  $580
                dc.w    $2160, $2520,     0,  $700
                dc.w    $3A60, $3BA0,     0,  $600
                dc.w    $3DE0, $3FA0,     0,  $300
LBZ1_LayoutModExitRange:
                dc.w    $1376, $170A
                dc.w    $20F6, $258A
                dc.w    $39F6, $3C0A
                dc.w    $3D76, $400A
LBZ1_CollapseScrollSpeed:
                dc.w    $1EE,  $1F2,   $C7,  $1B3,  $1B7,  $198,    $E,  $139
; ---------------------------------------------------------------------------

LBZ1_BackgroundInit:
                jsr     LBZ1_Deform(pc)
                jsr     Reset_TileOffsetPositionEff(pc)
                move.w  d2,(HScroll_table+$002).w
                clr.l   (HScroll_table+$004).w
                lea     LBZ1_BGDrawArray(pc),a4
                lea     (HScroll_table).w,a5
                jsr     Refresh_PlaneTileDeform(pc)
                lea     LBZ1_BGDeformArray(pc),a4
                lea     (HScroll_table+$008).w,a5
                jmp     ApplyDeformation(pc)
; ---------------------------------------------------------------------------

LBZ1_BackgroundEvent:
                move.w  (Events_routine_bg).w,d0
                jmp     LBZ1_BackgroundEvent_Index(pc,d0.w)
; ---------------------------------------------------------------------------

LBZ1_BackgroundEvent_Index:
                bra.w   LBZ1BGE_Normal
; ---------------------------------------------------------------------------
                bra.w   LBZ1BGE_DoTransition
; ---------------------------------------------------------------------------

LBZ1BGE_Normal:
                tst.w   (Events_fg_5).w
                beq.s   S3LBZ1Screen_DrawBgAndApplyVScroll
                clr.w   (Events_fg_5).w                 ; Yeah, normal transition nonsense for the level change
                movem.l d7-a0/a2-a3,-(sp)
                lea     (LBZ2_128x128_Kos).l,a1
                lea     (RAM_start).l,a2
                jsr     (Queue_Kos).l
                lea     (LBZ2_16x16_Secondary_Kos).l,a1
                lea     (Block_table+$6B8).w,a2
                jsr     (Queue_Kos).l
                lea     (LBZ2_8x8_Secondary_KosM).l,a1
                move.w  #tiles_to_bytes($19D),d2
                jsr     (Queue_Kos_Module).l
                movem.l (sp)+,d7-a0/a2-a3
                addq.w  #4,(Events_routine_bg).w

S3LBZ1Screen_DrawBgAndApplyVScroll:
                jsr     LBZ1_Deform(pc)
                lea     LBZ1_BGDrawArray(pc),a4
                lea     (HScroll_table).w,a5
                moveq   #$20,d6
                moveq   #2,d5
                jsr     Draw_BG(pc)
                lea     LBZ1_BGDeformArray(pc),a4
                lea     (HScroll_table+$008).w,a5
                jsr     ApplyDeformation(pc)
                lea     LBZ1_FGVScrollArray(pc),a4
                lea     (HScroll_table+$12E).w,a5
                jsr     Apply_FGVScroll(pc)
                jmp     ShakeScreen_Setup(pc)
; ---------------------------------------------------------------------------

LBZ1BGE_DoTransition:
                tst.b   (Kos_modules_left).w
                bne.w   S3LBZ1Screen_ApplyTransitionDeform
                move.w  #$601,(Current_zone_and_act).w
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
                move.w  #$8014,(VDP_control_port).l     ; Water in this stage yaaay
                moveq   #PalID_LBZ2,d0
                jsr     (LoadPalette_Immediate).l
                movem.l (sp)+,d7-a0/a2-a3
                move.w  #$3A00,d0
                moveq   #0,d1
                sub.w   d0,(Player_1+x_pos).w
                sub.w   d0,(Player_2+x_pos).w
                jsr     Offset_ObjectsDuringTransition(pc)
                sub.w   d0,(Camera_X_pos).w
                sub.w   d0,(Camera_X_pos_copy).w
                sub.w   d0,(Camera_min_X_pos).w
                sub.w   d0,(Camera_max_X_pos).w
                jsr     Reset_TileOffsetPositionActual(pc)
                clr.l   (Events_bg+$00).w
                clr.l   (Events_bg+$14).w
                clr.w   (SceneColumnOrCompBlinkVRAM).w
                clr.w   (Event_LBZ2_DeathEgg).w
                move.w  #$40,(Events_bg+$10).w
                cmpi.w  #$540,(Camera_Y_pos_copy).w
                blo.s   S3LBZ1Screen_InitAct2Waterline
                neg.w   (Events_bg+$10).w

S3LBZ1Screen_InitAct2Waterline:
                movem.l d7-a0/a2-a3,-(sp)
                jsr     (AniLBZ2_InitWaterlineTiles).l  ; Start LBZ2 tile animation
                movem.l (sp)+,d7-a0/a2-a3
                clr.w   (Events_routine_bg).w

S3LBZ1Screen_ApplyTransitionDeform:
                lea     LBZ1_BGDeformArray(pc),a4
                lea     (HScroll_table+$008).w,a5
                jmp     ApplyDeformation(pc)

; =============== S U B R O U T I N E =======================================

LBZ1_Deform:
                move.w  (Camera_Y_pos_copy).w,d0
                move.w  (Screen_shake_offset).w,d1
                sub.w   d1,d0
                asr.w   #4,d0
                add.w   d1,d0
                move.w  d0,(Camera_Y_pos_BG_copy).w
                move.w  (Camera_X_pos_copy).w,d0
                swap    d0
                clr.w   d0
                asr.l   #4,d0
                move.l  d0,d1
                asr.l   #1,d0
                swap    d0
                move.w  d0,(Events_bg+$10).w
                swap    d0
                swap    d1
                move.w  d1,(Camera_X_pos_BG_copy).w
                move.w  d1,(HScroll_table).w
                move.w  d1,(HScroll_table+$008).w
                swap    d1
                lea     (HScroll_table+$00A).w,a1
                add.l   d0,d1
                add.l   d0,d1
                asr.l   #2,d0
                moveq   #4-1,d2

S3LBZ1Screen_WriteBgSlopeSamples:
                swap    d1
                move.w  d1,(a1)+
                swap    d1
                add.l   d0,d1
                dbf     d2,S3LBZ1Screen_WriteBgSlopeSamples
                moveq   #$A,d0
                add.w   d0,(Events_bg+$10).w
                add.w   d0,(Camera_X_pos_BG_copy).w
                add.w   d0,(HScroll_table).w
                add.w   d0,(HScroll_table+$008).w
                lea     (HScroll_table+$00A).w,a1
                addq.w  #4,(a1)+
                subq.w  #2,(a1)+
                addq.w  #7,(a1)
                rts
; End of function LBZ1_Deform

; ---------------------------------------------------------------------------
LBZ1_BGDrawArray:
                dc.w    $D0, $7FFF
LBZ1_BGDeformArray:
                dc.w    $D0,   $18,     8,     8, $7FFF
