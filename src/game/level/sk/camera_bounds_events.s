; Owner: game/level/sk
; Responsibility: Zone and act camera-bound event dispatch, character-specific limits and shared maximum-height adjustment
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

Do_ResizeEvents:
                moveq   #0,d0
                move.w  (Current_zone_and_act).w,d0
                ror.b   #1,d0
                lsr.w   #6,d0
; Bug: this clamps the array index too hard, causing Competition and bonus
; stages to execute resize routines meant for the early game levels
                andi.w  #$3E,d0
                move.w  LevelResizeArray(pc,d0.w),d0
                jsr     LevelResizeArray(pc,d0.w)
                moveq   #2,d1
                move.w  (Camera_target_max_Y_pos).w,d0
                sub.w   (Camera_max_Y_pos).w,d0
                beq.s   SKBounds_StepMaxYReturn
                bcc.s   SKBounds_PickMaxYGrowthRate
                neg.w   d1
                move.w  (Camera_Y_pos).w,d0
                cmp.w   (Camera_target_max_Y_pos).w,d0
                bls.s   SKBounds_LowerMaxY
                move.w  d0,(Camera_max_Y_pos).w
                andi.w  #$FFFE,(Camera_max_Y_pos).w

SKBounds_LowerMaxY:
                add.w   d1,(Camera_max_Y_pos).w
                move.b  #1,(Camera_max_Y_pos_changing).w

SKBounds_StepMaxYReturn:
                rts
; ---------------------------------------------------------------------------

SKBounds_PickMaxYGrowthRate:
                move.w  (Camera_Y_pos).w,d0
                addi.w  #8,d0
                cmp.w   (Camera_max_Y_pos).w,d0
                blo.s   SKBounds_RaiseMaxY
                btst    #1,(Player_1+status).w
                beq.s   SKBounds_RaiseMaxY
                add.w   d1,d1
                add.w   d1,d1

SKBounds_RaiseMaxY:
                add.w   d1,(Camera_max_Y_pos).w
                move.b  #1,(Camera_max_Y_pos_changing).w
                rts
; ---------------------------------------------------------------------------
LevelResizeArray:
                dc.w    AIZ1_Resize-LevelResizeArray
                dc.w    AIZ2_Resize-LevelResizeArray
                dc.w    HCZ1_Resize-LevelResizeArray
                dc.w    HCZ2_Resize-LevelResizeArray
                dc.w    MGZ1_Resize-LevelResizeArray
                dc.w    MGZ2_Resize-LevelResizeArray
                dc.w    CNZ1_Resize-LevelResizeArray
                dc.w    CNZ2_Resize-LevelResizeArray
                dc.w    FBZ1_Resize-LevelResizeArray
                dc.w    FBZ2_Resize-LevelResizeArray
                dc.w    ICZ1_Resize-LevelResizeArray
                dc.w    ICZ2_Resize-LevelResizeArray
                dc.w    LBZ1_Resize-LevelResizeArray
                dc.w    LBZ2_Resize-LevelResizeArray
                dc.w    No_Resize-LevelResizeArray
                dc.w    No_Resize-LevelResizeArray
                dc.w    No_Resize-LevelResizeArray
                dc.w    No_Resize-LevelResizeArray
                dc.w    No_Resize-LevelResizeArray
                dc.w    No_Resize-LevelResizeArray
                dc.w    No_Resize-LevelResizeArray
                dc.w    No_Resize-LevelResizeArray
                dc.w    No_Resize-LevelResizeArray
                dc.w    No_Resize-LevelResizeArray
                dc.w    No_Resize-LevelResizeArray
                dc.w    No_Resize-LevelResizeArray
                dc.w    No_Resize-LevelResizeArray
                dc.w    No_Resize-LevelResizeArray
                dc.w    No_Resize-LevelResizeArray
                dc.w    No_Resize-LevelResizeArray
                dc.w    No_Resize-LevelResizeArray
                dc.w    No_Resize-LevelResizeArray
                dc.w    No_Resize-LevelResizeArray
                dc.w    No_Resize-LevelResizeArray
                dc.w    No_Resize-LevelResizeArray
                dc.w    No_Resize-LevelResizeArray
                dc.w    No_Resize-LevelResizeArray
                dc.w    No_Resize-LevelResizeArray
                dc.w    No_Resize-LevelResizeArray
                dc.w    No_Resize-LevelResizeArray
                dc.w    No_Resize-LevelResizeArray
                dc.w    No_Resize-LevelResizeArray
                dc.w    No_Resize-LevelResizeArray
                dc.w    No_Resize-LevelResizeArray
                dc.w    No_Resize-LevelResizeArray
                dc.w    No_Resize-LevelResizeArray
                dc.w    No_Resize-LevelResizeArray
                dc.w    No_Resize-LevelResizeArray
; ---------------------------------------------------------------------------

AIZ1_Resize:
                moveq   #0,d0
                move.b  (Dynamic_resize_routine).w,d0
                move.w  AIZ1_Resize_Index(pc,d0.w),d0
                jmp     AIZ1_Resize_Index(pc,d0.w)
; ---------------------------------------------------------------------------
AIZ1_Resize_Index:
                dc.w    SKBounds_AIZ1_TryExitIntroPalette-AIZ1_Resize_Index
                dc.w    SKBounds_AIZ1_TryQueueMainArt-AIZ1_Resize_Index
                dc.w    SKBounds_AIZ1_UpdateHeightAndPalette-AIZ1_Resize_Index
                dc.w    SKBounds_AIZ1_WaitForFlameArt-AIZ1_Resize_Index
                dc.w    SKBounds_AIZ1_FollowMinX-AIZ1_Resize_Index
; ---------------------------------------------------------------------------

SKBounds_AIZ1_TryExitIntroPalette:
                move.b  #1,(AIZ1_palette_cycle_flag).w
                cmpi.w  #$1000,(Camera_X_pos).w
                blo.s   SKBounds_AIZ1_IntroPaletteReturn
                move.b  #0,(AIZ1_palette_cycle_flag).w
                move.w  (Camera_X_pos).w,(Camera_min_X_pos).w
                cmpi.w  #$1308,(Camera_X_pos).w
                blo.s   SKBounds_AIZ1_IntroPaletteReturn
                tst.b   (Last_star_post_hit).w
                bne.s   SKBounds_AIZ1_LoadIntroPalette
                cmpi.w  #2,(Player_mode).w
                bhs.s   SKBounds_AIZ1_LoadIntroPalette
                moveq   #PLCID_0B,d0
                jsr     (Load_PLC).l

SKBounds_AIZ1_LoadIntroPalette:
                moveq   #PalID_AIZ,d0
                jsr     (LoadPalette_Immediate).l
                cmpi.w  #3,(Player_mode).w
                bne.s   SKBounds_AIZ1_ReleaseTailsAndAdvance
                lea     (Normal_palette_line_4+$10).w,a1
                lea     (SKAIZ1Screen_KnuxPalettePrefix).l,a2
                move.l  (a2)+,(a1)+
                move.l  (a2),(a1)

SKBounds_AIZ1_ReleaseTailsAndAdvance:
                move.w  #2,(Tails_CPU_routine).w
                addq.b  #2,(Dynamic_resize_routine).w

SKBounds_AIZ1_IntroPaletteReturn:
                rts
; ---------------------------------------------------------------------------

SKBounds_AIZ1_TryQueueMainArt:
                move.w  #$1308,(Camera_min_X_pos).w
                cmpi.w  #$1400,(Camera_X_pos).w
                blo.s   SKBounds_AIZ1_MainArtReturn
                tst.b   (Last_star_post_hit).w
                bne.s   SKBounds_AIZ1_SetIntroCheckpoint
                cmpi.w  #2,(Player_mode).w
                bhs.s   SKBounds_AIZ1_SetIntroCheckpoint
                lea     (AIZ1_16x16_MainLevel_Kos).l,a1
                lea     (Block_table+$268).w,a2
                jsr     (Queue_Kos).l
                lea     (AIZ1_8x8_MainLevel_KosM).l,a1
                move.w  #tiles_to_bytes($0BE),d2
                jsr     (Queue_Kos_Module).l
                st      (Events_fg_5).w
                move.w  #$500,(Anim_Counters).w
                move.w  #$500,(Anim_Counters+2).w
                move.w  #$500,(Anim_Counters+4).w

SKBounds_AIZ1_SetIntroCheckpoint:
                move.b  #1,(Last_star_post_hit).w
                move.w  #$13A0,(Saved_X_pos).w
                move.w  #$41A,(Saved_Y_pos).w
                jsr     (Save_Level_Data).l
                move.l  #0,(Saved_timer).w
                moveq   #PLCID_08,d0
                jsr     (Load_PLC).l
                addq.b  #2,(Dynamic_resize_routine).w

SKBounds_AIZ1_MainArtReturn:
                rts
; ---------------------------------------------------------------------------

SKBounds_AIZ1_UpdateHeightAndPalette:
                lea     (SKBounds_AIZ1_MaxYByX).l,a1
                bsr.w   Resize_MaxYFromX
                move.w  #0,(Camera_min_Y_pos).w
                move.w  #$20E,(Target_palette_line_3+$1E).w
                tst.b   (Game_mode).w
                bmi.s   SKBounds_AIZ1_TryOverrideColor
                tst.w   (Palette_fade_timer).w
                bne.s   SKBounds_AIZ1_TryOverrideColor
                move.w  #$20E,(Normal_palette_line_3+$1E).w

SKBounds_AIZ1_TryOverrideColor:
                cmpi.w  #$2B00,(Camera_X_pos).w
                blo.s   SKBounds_AIZ1_TryRaiseMinY
                move.w  #4,(Normal_palette_line_3+$1E).w

SKBounds_AIZ1_TryRaiseMinY:
                cmpi.w  #$2C00,(Camera_X_pos).w
                blo.s   SKBounds_AIZ1_PickFlameEntryColor
                move.w  #$2E0,(Camera_min_Y_pos).w

SKBounds_AIZ1_PickFlameEntryColor:
                cmpi.w  #$2D80,(Camera_X_pos).w
                blo.s   SKBounds_AIZ1_PreFlameReturn
                move.w  #$C02,d0
                cmpi.w  #3,(Player_mode).w
                bne.s   SKBounds_AIZ1_StartFlameLoad
                move.w  (SKAIZ1Screen_KnuxPaletteSharedColor).l,d0

SKBounds_AIZ1_StartFlameLoad:
                move.w  d0,(Normal_palette_line_3+$1E).w
                move.w  #$2D80,(Camera_min_X_pos).w
                moveq   #PLCID_5A,d0
                jsr     (Load_PLC).l
                addq.b  #2,(Dynamic_resize_routine).w

SKBounds_AIZ1_PreFlameReturn:
                rts
; ---------------------------------------------------------------------------

SKBounds_AIZ1_WaitForFlameArt:
                lea     (SKBounds_AIZ1_MaxYByX).l,a1
                bsr.w   Resize_MaxYFromX
                move.w  (Camera_X_pos).w,(Camera_min_X_pos).w
                cmpi.w  #$2E00,(Camera_X_pos).w
                blo.s   SKBounds_AIZ1_FlameArtReturn
                tst.b   (Kos_modules_left).w
                bne.s   SKBounds_AIZ1_FlameArtReturn
                lea     (AIZ1_8x8_Flames_KosM).l,a1
                move.w  #tiles_to_bytes($500),d2
                jsr     (Queue_Kos_Module).l
                moveq   #PLCID_0C,d0
                jsr     (Load_PLC).l
                addq.b  #2,(Dynamic_resize_routine).w

SKBounds_AIZ1_FlameArtReturn:
                rts
; ---------------------------------------------------------------------------

SKBounds_AIZ1_FollowMinX:
                move.w  (Camera_X_pos).w,(Camera_min_X_pos).w
                rts
; ---------------------------------------------------------------------------
; The upper X limit is inclusive. Bit 15 of the height word requests an immediate change
SKBounds_AIZ1_MaxYByX:
                dc.w    $8390, $1650
                dc.w    $83B0, $1B00
                dc.w    $8430, $2000
                dc.w    $84C0, $2B00
                dc.w    $83B0, $2D80
                dc.w    $82E0, $FFFF
; ---------------------------------------------------------------------------

AIZ2_Resize:
                moveq   #0,d0
                move.b  (Dynamic_resize_routine).w,d0
                move.w  AIZ2_Resize_Index(pc,d0.w),d0
                jmp     AIZ2_Resize_Index(pc,d0.w)
; ---------------------------------------------------------------------------
AIZ2_Resize_Index:
                dc.w    SKBounds_AIZ2_PickResizeGraph-AIZ2_Resize_Index  ; 0
                dc.w    AIZ2_SonicResize1-AIZ2_Resize_Index  ; 2
                dc.w    AIZ2_SonicResize2-AIZ2_Resize_Index  ; 4
                dc.w    AIZ2_SonicResize3-AIZ2_Resize_Index  ; 6
                dc.w    AIZ2_SonicResize4-AIZ2_Resize_Index  ; 8
                dc.w    AIZ2_SonicResize5-AIZ2_Resize_Index  ; A
                dc.w    AIZ2_SonicResize6-AIZ2_Resize_Index  ; C
                dc.w    AIZ2_SonicResize7-AIZ2_Resize_Index  ; E
                dc.w    AIZ2_SonicResizeEnd-AIZ2_Resize_Index  ; 10
                dc.w    AIZ2_KnuxResize1-AIZ2_Resize_Index  ; 12
                dc.w    AIZ2_KnuxResize2-AIZ2_Resize_Index  ; 14
                dc.w    AIZ2_KnuxResize3-AIZ2_Resize_Index  ; 16
                dc.w    AIZ2_KnuxResize4-AIZ2_Resize_Index  ; 18
                dc.w    AIZ2_KnuxResize5-AIZ2_Resize_Index  ; 1A
                dc.w    AIZ2_KnuxResizeEnd-AIZ2_Resize_Index  ; 1C
; ---------------------------------------------------------------------------

SKBounds_AIZ2_PickResizeGraph:
                cmpi.w  #3,(Player_mode).w
                bne.s   SKBounds_AIZ2_StartSonicResize
                move.b  #$12,(Dynamic_resize_routine).w  ; If playing as Knuckles
                bra.w   AIZ2_KnuxResize1
; ---------------------------------------------------------------------------

SKBounds_AIZ2_StartSonicResize:
                addq.b  #2,(Dynamic_resize_routine).w

AIZ2_SonicResize1:
                cmpi.w  #$2E0,(Camera_X_pos).w
                blo.s   SKBounds_AIZ2_SonicInitialHeightReturn
                move.w  #$590,d0
                move.w  d0,(Camera_max_Y_pos).w
                move.w  d0,(Camera_target_max_Y_pos).w
                addq.b  #2,(Dynamic_resize_routine).w   ; Set level height to normal when past the open field
                cmpi.w  #1,(Apparent_zone_and_act).w    ; If non-internal level is not AIZ2, then the miniboss hasn't been defeated yet
                bne.s   SKBounds_AIZ2_SonicInitialHeightReturn
                move.w  #$F50,(Camera_min_X_pos).w      ; Put $F50 as the start X
                addq.b  #2,(Dynamic_resize_routine).w

SKBounds_AIZ2_SonicInitialHeightReturn:
                rts
; ---------------------------------------------------------------------------

AIZ2_SonicResize2:
                move.w  #$590,d0
                cmpi.w  #$ED0,(Camera_X_pos).w
                blo.s   SKBounds_AIZ2_TrySpawnSonicMiniboss
                move.w  #$2B8,d0                        ; Set level height to 2B8 when boss is approached

SKBounds_AIZ2_TrySpawnSonicMiniboss:
                move.w  d0,(Camera_max_Y_pos).w
                move.w  d0,(Camera_target_max_Y_pos).w
                cmpi.w  #$F50,(Camera_X_pos).w
                blo.s   SKBounds_AIZ2_SonicArenaReturn
                move.w  #$F50,(Camera_min_X_pos).w      ; When boss has been reached, lock the screen
                tst.w   (Debug_placement_mode).w        ; If in debug mode, don't load boss
                bne.s   SKBounds_AIZ2_AdvanceSonicAfterSpawn
                jsr     (AllocateObject).l
                bne.s   SKBounds_AIZ2_AdvanceSonicAfterSpawn
                move.l  #Obj_AIZMiniboss,(a1)           ; Make the miniboss
                move.w  #$11F0,x_pos(a1)
                move.w  #$289,y_pos(a1)                 ; Set the position for Sonic's area area

; Advance even if the miniboss object was not allocated
SKBounds_AIZ2_AdvanceSonicAfterSpawn:
                addq.b  #2,(Dynamic_resize_routine).w

SKBounds_AIZ2_SonicArenaReturn:
                rts
; ---------------------------------------------------------------------------

AIZ2_SonicResize3:
                cmpi.w  #$1500,(Camera_X_pos).w
                blo.s   SKBounds_AIZ2_SonicAfterBossReturn
                move.w  #$630,(Camera_max_Y_pos).w      ; Set the level height to $630 when playing as Sonic past $1500
                move.w  #$630,(Camera_target_max_Y_pos).w
                addq.b  #2,(Dynamic_resize_routine).w

SKBounds_AIZ2_SonicAfterBossReturn:
                rts
; ---------------------------------------------------------------------------

AIZ2_SonicResize4:
                cmpi.w  #$3C00,(Camera_X_pos).w
                blo.s   SKBounds_AIZ2_SonicBombershipReturn
                tst.b   (Kos_modules_left).w            ; When $3C00 X is passed
                bne.s   SKBounds_AIZ2_SonicBombershipReturn
                lea     (AIZ2_16x16_BomberShip_Kos).l,a1  ; If KosM queue is clear
                lea     (Block_table+$AB8).w,a2
                jsr     (Queue_Kos).l
                lea     (AIZ2_8x8_BomberShip_KosM).l,a1
                move.w  #tiles_to_bytes($1FC),d2
                jsr     (Queue_Kos_Module).l
                lea     (ArtKosM_AIZ2Bombership2_8x8).l,a1
                move.w  #tiles_to_bytes(ArtTile_AIZ2Bombership),d2
                jsr     (Queue_Kos_Module).l            ; Load all battleship art
                moveq   #PalID_AIZBoss,d0
                jsr     (LoadPalette_Immediate).l       ; Load palette
                st      (Events_fg_5).w                 ; Send signal to background event
                addq.b  #2,(Dynamic_resize_routine).w

SKBounds_AIZ2_SonicBombershipReturn:
                rts
; ---------------------------------------------------------------------------

AIZ2_SonicResize5:
                cmpi.w  #$3F00,(Camera_X_pos).w
                blo.s   SKBounds_AIZ2_SonicMinYLockReturn
                move.w  #$15A,d0                        ; When past $3F00 X, set top of level to $15A
                move.w  d0,(Camera_min_Y_pos).w
                move.w  d0,(Camera_target_min_Y_pos).w
                addq.b  #2,(Dynamic_resize_routine).w

SKBounds_AIZ2_SonicMinYLockReturn:
                rts
; ---------------------------------------------------------------------------

AIZ2_SonicResize6:
                cmpi.w  #$4000,(Camera_X_pos).w
                blo.s   SKBounds_AIZ2_SonicMaxYLockReturn
                move.w  #$15A,d0
                move.w  d0,(Camera_max_Y_pos).w         ; When past $4000 X, set bottom of level to $15A
                move.w  d0,(Camera_target_max_Y_pos).w
                addq.b  #2,(Dynamic_resize_routine).w

SKBounds_AIZ2_SonicMaxYLockReturn:
                rts
; ---------------------------------------------------------------------------

AIZ2_SonicResize7:
                cmpi.w  #$4160,(Camera_X_pos).w
                blo.s   AIZ2_SonicResizeEnd
                st      (Events_fg_4).w                 ; When past $4160, send signal to screen event to start the battleship sequence
                addq.b  #2,(Dynamic_resize_routine).w

AIZ2_SonicResizeEnd:
                rts
; ---------------------------------------------------------------------------

AIZ2_KnuxResize1:
                cmpi.w  #$2E0,(Camera_X_pos).w
                blo.s   SKBounds_AIZ2_KnuxInitialHeightReturn
                move.w  #$590,d0
                move.w  d0,(Camera_max_Y_pos).w
                move.w  d0,(Camera_target_max_Y_pos).w  ; Set level height to normal when past the open field
                addq.b  #2,(Dynamic_resize_routine).w
                cmpi.w  #1,(Apparent_zone_and_act).w
                bne.s   SKBounds_AIZ2_KnuxInitialHeightReturn
                move.w  #$1040,(Camera_min_X_pos).w     ; Knuckles boss is slightly more to the right than Sonic's
                addq.b  #2,(Dynamic_resize_routine).w

SKBounds_AIZ2_KnuxInitialHeightReturn:
                rts
; ---------------------------------------------------------------------------

AIZ2_KnuxResize2:
                move.w  #$590,d0
                cmpi.w  #$E80,(Camera_X_pos).w
                blo.s   SKBounds_AIZ2_TrySpawnKnuxMiniboss
                move.w  #$450,d0

SKBounds_AIZ2_TrySpawnKnuxMiniboss:
                move.w  d0,(Camera_max_Y_pos).w
                move.w  d0,(Camera_target_max_Y_pos).w
                cmpi.w  #$1040,(Camera_X_pos).w
                blo.s   SKBounds_AIZ2_KnuxArenaReturn
                move.w  #$1040,(Camera_min_X_pos).w
                tst.w   (Debug_placement_mode).w
                bne.s   SKBounds_AIZ2_AdvanceKnuxAfterSpawn
                jsr     (AllocateObject).l
                bne.s   SKBounds_AIZ2_AdvanceKnuxAfterSpawn
                move.l  #Obj_AIZMiniboss,(a1)
                move.w  #$11D0,x_pos(a1)                ; Knuckles' version of the boss is further down obviously
                move.w  #$420,y_pos(a1)

; Set the water target and advance even if the miniboss object was not allocated
SKBounds_AIZ2_AdvanceKnuxAfterSpawn:
                move.w  #$F80,(Target_water_level).w
                addq.b  #2,(Dynamic_resize_routine).w

SKBounds_AIZ2_KnuxArenaReturn:
                rts
; ---------------------------------------------------------------------------

AIZ2_KnuxResize3:
                cmpi.w  #$11A0,(Camera_X_pos).w
                blo.s   SKBounds_AIZ2_KnuxAfterBossReturn
                move.w  #$820,(Camera_target_max_Y_pos).w  ; Set level height to $820 when playing as Knuckles
                addq.b  #2,(Dynamic_resize_routine).w

SKBounds_AIZ2_KnuxAfterBossReturn:
                rts
; ---------------------------------------------------------------------------

AIZ2_KnuxResize4:
                cmpi.w  #$3B80,(Camera_X_pos).w
                blo.s   SKBounds_AIZ2_KnuxBombershipReturn
                tst.b   (Kos_modules_left).w
                bne.s   SKBounds_AIZ2_KnuxBombershipReturn
                lea     (AIZ2_16x16_BomberShip_Kos).l,a1
                lea     (Block_table+$AB8).w,a2
                jsr     (Queue_Kos).l
                lea     (AIZ2_8x8_BomberShip_KosM).l,a1
                move.w  #tiles_to_bytes($1FC),d2
                jsr     (Queue_Kos_Module).l            ; I'm guessing the art here is for the trees and/or the waterfall in the boss arena
                moveq   #PalID_AIZBoss,d0
                jsr     (LoadPalette_Immediate).l
                move.w  #$3B80,(Camera_min_X_pos).w
                move.w  #$5DA,(Camera_target_max_Y_pos).w
                st      (Events_fg_5).w                 ; Set the flag for the background event
                addq.b  #2,(Dynamic_resize_routine).w

SKBounds_AIZ2_KnuxBombershipReturn:
                rts
; ---------------------------------------------------------------------------

AIZ2_KnuxResize5:
                move.w  #$3F80,d0
                cmp.w   (Camera_X_pos).w,d0
                bhi.s   AIZ2_KnuxResizeEnd
                move.w  d0,(Camera_min_X_pos).w
                addq.b  #2,(Dynamic_resize_routine).w

AIZ2_KnuxResizeEnd:
                rts
; ---------------------------------------------------------------------------

HCZ1_Resize:
                moveq   #0,d0
                move.b  (Dynamic_resize_routine).w,d0
                move.w  HCZ1_Resize_Index(pc,d0.w),d0
                jmp     HCZ1_Resize_Index(pc,d0.w)
; ---------------------------------------------------------------------------
HCZ1_Resize_Index:
                dc.w    SKBounds_HCZ1_TryLoadStartPalette-HCZ1_Resize_Index
                dc.w    SKBounds_HCZ1_CheckPaletteRegion-HCZ1_Resize_Index
                dc.w    SKCamera_ReturnHczOneTerminalResizeState-HCZ1_Resize_Index
; ---------------------------------------------------------------------------

SKBounds_HCZ1_TryLoadStartPalette:
                cmpi.w  #$360,(Camera_X_pos).w
                bhs.s   SKBounds_HCZ1_StartPaletteReturn
                cmpi.w  #$3E0,(Camera_Y_pos).w
                blo.s   SKBounds_HCZ1_StartPaletteReturn
                lea     (Normal_palette_line_4+$10).w,a1
; Bug: this should be $680
                move.w  #$B80,(a1)+
                move.w  #$240,(a1)+
                move.w  #$220,(a1)+
                addq.b  #2,(Dynamic_resize_routine).w

SKBounds_HCZ1_StartPaletteReturn:
                rts
; ---------------------------------------------------------------------------

SKBounds_HCZ1_CheckPaletteRegion:
                cmpi.w  #$360,(Camera_X_pos).w
                bhs.s   SKBounds_HCZ1_TryFinishPalette
                cmpi.w  #$3E0,(Camera_Y_pos).w
                bhs.s   SKBounds_HCZ1_PaletteRestoreReturn
                subq.b  #2,(Dynamic_resize_routine).w
                bra.s   SKBounds_HCZ1_RestoreStartColors
; ---------------------------------------------------------------------------

SKBounds_HCZ1_TryFinishPalette:
                cmpi.w  #$500,(Camera_Y_pos).w
                blo.s   SKBounds_HCZ1_PaletteRestoreReturn
                cmpi.w  #$900,(Camera_X_pos).w
                blo.s   SKBounds_HCZ1_PaletteRestoreReturn
                addq.b  #2,(Dynamic_resize_routine).w

SKBounds_HCZ1_RestoreStartColors:
                lea     (Normal_palette_line_4+$10).w,a1
                move.w  #$CEE,(a1)+
                move.w  #$ACE,(a1)+
                move.w  #$8A,(a1)+

SKBounds_HCZ1_PaletteRestoreReturn:
                rts
; ---------------------------------------------------------------------------

SKCamera_ReturnHczOneTerminalResizeState:
                rts
; ---------------------------------------------------------------------------

HCZ2_Resize:
                moveq   #0,d0
                move.b  (Dynamic_resize_routine).w,d0
                move.w  HCZ2_Resize_Index(pc,d0.w),d0
                jmp     HCZ2_Resize_Index(pc,d0.w)
; ---------------------------------------------------------------------------
HCZ2_Resize_Index:
                dc.w    SKBounds_HCZ2_TrySignalForeground-HCZ2_Resize_Index
                dc.w    SKCamera_ReturnHczTwoTerminalResizeState-HCZ2_Resize_Index
; ---------------------------------------------------------------------------

SKBounds_HCZ2_TrySignalForeground:
                cmpi.w  #$C00,(Camera_X_pos).w
                blo.s   SKBounds_HCZ2_ForegroundReturn
                st      (Events_fg_5).w
                addq.b  #2,(Dynamic_resize_routine).w

SKBounds_HCZ2_ForegroundReturn:
                rts
; ---------------------------------------------------------------------------

SKCamera_ReturnHczTwoTerminalResizeState:
                rts
; ---------------------------------------------------------------------------

MGZ1_Resize:
; Bug: MGZ1 uses a dynamic resize routine meant for MGZ2
; This causes the act 2 boss to spawn in out-of-bounds act 1

MGZ2_Resize:
                moveq   #0,d0
                move.b  (Dynamic_resize_routine).w,d0
                move.w  MGZ2_Resize_Index(pc,d0.w),d0
                jmp     MGZ2_Resize_Index(pc,d0.w)
; ---------------------------------------------------------------------------
MGZ2_Resize_Index:
                dc.w    SKBounds_MGZ_TryLockArena-MGZ2_Resize_Index
                dc.w    SKBounds_MGZ_PickSpawnOrRollback-MGZ2_Resize_Index
                dc.w    SKBounds_MGZ_FinalReturn-MGZ2_Resize_Index
; ---------------------------------------------------------------------------

SKBounds_MGZ_TryLockArena:
                move.w  (Camera_Y_pos).w,d0
                cmpi.w  #$600,d0
                blo.s   SKBounds_MGZ_ArenaEntryReturn
                cmpi.w  #$700,d0
                bhs.s   SKBounds_MGZ_ArenaEntryReturn
                cmpi.w  #$3A00,(Camera_X_pos).w
                blo.s   SKBounds_MGZ_ArenaEntryReturn
                move.w  #$6A0,d0
                move.w  d0,(Camera_min_Y_pos).w
                move.w  d0,(Camera_target_min_Y_pos).w
                move.w  d0,(Camera_max_Y_pos).w
                move.w  d0,(Camera_target_max_Y_pos).w
                move.w  #$3C80,d0
                move.w  d0,(Camera_max_X_pos).w
                move.w  d0,(Camera_target_max_X_pos).w
                addq.b  #2,(Dynamic_resize_routine).w

SKBounds_MGZ_ArenaEntryReturn:
                rts
; ---------------------------------------------------------------------------

SKBounds_MGZ_PickSpawnOrRollback:
                cmpi.w  #$3A00,(Camera_X_pos).w
                blo.s   SKBounds_MGZ_RestoreOpenBounds
                move.w  #$3C80,d0
                cmp.w   (Camera_X_pos).w,d0
                bhi.s   SKBounds_MGZ_ArenaWaitReturn
                move.w  d0,(Camera_min_X_pos).w
                move.w  d0,(Camera_target_min_X_pos).w
                jsr     (AllocateObject).l
                bne.s   SKBounds_MGZ_AdvanceAfterSpawnTry
                move.l  #Obj_MGZEndBoss,(a1)
                move.w  #$3D20,x_pos(a1)
                move.w  #$668,y_pos(a1)

; Advance even if the boss object was not allocated
SKBounds_MGZ_AdvanceAfterSpawnTry:
                addq.b  #2,(Dynamic_resize_routine).w
                rts
; ---------------------------------------------------------------------------

SKBounds_MGZ_RestoreOpenBounds:
                move.l  #$1000,d0
                move.l  d0,(Camera_min_Y_pos).w
                move.l  d0,(Camera_target_min_Y_pos).w
                move.w  #$6000,d0
                move.w  d0,(Camera_max_X_pos).w
                move.w  d0,(Camera_target_max_X_pos).w
                subq.b  #2,(Dynamic_resize_routine).w

SKBounds_MGZ_ArenaWaitReturn:
                rts
; ---------------------------------------------------------------------------

SKBounds_MGZ_FinalReturn:
                rts
; ---------------------------------------------------------------------------

CNZ1_Resize:
CNZ2_Resize:
FBZ1_Resize:
FBZ2_Resize:
                rts
; ---------------------------------------------------------------------------

ICZ1_Resize:
                moveq   #0,d0
                move.b  (Dynamic_resize_routine).w,d0
                move.w  ICZ1_Resize_Index(pc,d0.w),d0
                jmp     ICZ1_Resize_Index(pc,d0.w)
; ---------------------------------------------------------------------------
ICZ1_Resize_Index:
                dc.w    SKBounds_ICZ1_TrySignalFirstScene-ICZ1_Resize_Index
                dc.w    SKBounds_ICZ1_TrySignalSecondScene-ICZ1_Resize_Index
                dc.w    SKBounds_ICZ1_FinalReturn-ICZ1_Resize_Index
; ---------------------------------------------------------------------------

SKBounds_ICZ1_TrySignalFirstScene:
                cmpi.w  #$3700,(Camera_X_pos).w
                blo.s   SKBounds_ICZ1_FirstSceneReturn
                cmpi.w  #$68C,(Camera_Y_pos).w
                blo.s   SKBounds_ICZ1_FirstSceneReturn
                st      (Events_fg_5).w
                addq.b  #2,(Dynamic_resize_routine).w

SKBounds_ICZ1_FirstSceneReturn:
                rts
; ---------------------------------------------------------------------------

SKBounds_ICZ1_TrySignalSecondScene:
                cmpi.w  #$3940,(Camera_X_pos).w
                blo.s   SKBounds_ICZ1_SecondSceneReturn
                st      (Events_fg_5).w
                addq.b  #2,(Dynamic_resize_routine).w

SKBounds_ICZ1_SecondSceneReturn:
                rts
; ---------------------------------------------------------------------------

SKBounds_ICZ1_FinalReturn:
                rts
; ---------------------------------------------------------------------------

ICZ2_Resize:
                moveq   #0,d0
                move.b  (Dynamic_resize_routine).w,d0
                move.w  ICZ2_Resize_Index(pc,d0.w),d0
                jmp     ICZ2_Resize_Index(pc,d0.w)
; ---------------------------------------------------------------------------
ICZ2_Resize_Index:
                dc.w    SKBounds_ICZ2_TryLockUpperRoute-ICZ2_Resize_Index
                dc.w    SKBounds_ICZ2_FinalReturn-ICZ2_Resize_Index
; ---------------------------------------------------------------------------

SKBounds_ICZ2_TryLockUpperRoute:
                cmpi.w  #$740,(Camera_X_pos).w
                blo.s   SKCamera_ReturnIcecapTwoMinimumXGate
                cmpi.w  #$400,(Camera_Y_pos).w
                bhs.s   SKCamera_ReturnIcecapTwoMinimumXGate
                move.w  #$740,(Camera_min_X_pos).w
                addq.b  #2,(Dynamic_resize_routine).w

SKCamera_ReturnIcecapTwoMinimumXGate:
                rts
; ---------------------------------------------------------------------------

SKBounds_ICZ2_FinalReturn:
                rts
; ---------------------------------------------------------------------------

LBZ1_Resize:
                rts
; ---------------------------------------------------------------------------

LBZ2_Resize:
                moveq   #0,d0
                move.b  (Dynamic_resize_routine).w,d0
                move.w  LBZ2_Resize_Index(pc,d0.w),d0
                jmp     LBZ2_Resize_Index(pc,d0.w)
; ---------------------------------------------------------------------------
LBZ2_Resize_Index:
                dc.w    SKBounds_LBZ2_TryQueueDeathEggArt-LBZ2_Resize_Index
                dc.w    SKBounds_LBZ2_FinalReturn-LBZ2_Resize_Index
; ---------------------------------------------------------------------------

SKBounds_LBZ2_TryQueueDeathEggArt:
                cmpi.w  #$3BC0,(Camera_X_pos).w
                blo.s   SKBounds_LBZ2_DeathEggQueueReturn
                cmpi.w  #$500,(Camera_Y_pos).w
                blo.s   SKBounds_LBZ2_DeathEggQueueReturn
                addq.b  #2,(Dynamic_resize_routine).w
                lea     (LBZ2_16x16_DeathEgg_Kos).l,a1
                lea     (Block_table).w,a2
                jsr     (Queue_Kos).l
                lea     (LBZ2_128x128_DeathEgg_Kos).l,a1
                lea     (RAM_start).l,a2
                jsr     (Queue_Kos).l
                lea     (LBZ2_8x8_DeathEgg_KosM).l,a1
                move.w  #tiles_to_bytes($000),d2
                jsr     (Queue_Kos_Module).l
                lea     (ArtKosM_LBZ2DeathEgg2_8x8).l,a1
                move.w  #tiles_to_bytes(ArtTile_Explosion),d2
                jsr     (Queue_Kos_Module).l

SKBounds_LBZ2_DeathEggQueueReturn:
                rts
; ---------------------------------------------------------------------------

SKBounds_LBZ2_FinalReturn:
                rts
; ---------------------------------------------------------------------------

No_Resize:
                rts

; =============== S U B R O U T I N E =======================================

Resize_MaxYFromX:
                move.w  (Camera_X_pos).w,d0

SKBounds_FindMaxYAtCameraX:
                move.l  (a1)+,d1
                cmp.w   d1,d0
                bhi.s   SKBounds_FindMaxYAtCameraX
                swap    d1
                tst.w   d1
                bpl.s   SKBounds_StoreTargetMaxY
                andi.w  #$7FFF,d1
                move.w  d1,(Camera_max_Y_pos).w

SKBounds_StoreTargetMaxY:
                move.w  d1,(Camera_target_max_Y_pos).w
                rts
; End of function Resize_MaxYFromX
