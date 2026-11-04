; Owner: objects/special_stage/sk
; Responsibility: Special-stage entry ring and flash state machines, player interaction, transition checks and private pattern or animation records
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_SSEntryRing:
                move.b  subtype(a0),d0
                move.l  (Collected_special_ring_array).w,d1
                btst    d0,d1
                beq.s   SKSSRing_WaitForVisibilityThenDispatch  ; only make the ring if it hasn't already been collected
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

SKSSRing_WaitForVisibilityThenDispatch:
                jsr     (Obj_WaitOffscreen).l           ; Don't start anything until the ring is explicitly onscreen
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  SSEntryRing_Index(pc,d0.w),d1
                jsr     SSEntryRing_Index(pc,d1.w)
                bra.w   SSEntryRing_Display
; ---------------------------------------------------------------------------
SSEntryRing_Index:
                dc.w    SSEntryRing_Init-SSEntryRing_Index
                dc.w    SSEntryRing_Main-SSEntryRing_Index
                dc.w    SSEntryRing_Animate-SSEntryRing_Index
; ---------------------------------------------------------------------------

SSEntryRing_Init:
                lea     ObjSlot_SSEntryRing(pc),a1
                jsr     (SetUp_ObjAttributesSlotted).l  ; Only one special stage ring can be loaded at one time, period
                move.l  #AniRaw_SSEntryRing,$30(a0)
                tst.b   subtype(a0)
                bmi.s   SKSSRing_SetSuperFlagAndPaletteScripts  ; If negative, then ALWAYS make this a Super Emerald ring
                tst.w   (SK_alone_flag).w               ; Probably only used in MHZ for the first rings
                bne.s   SSEntryRing_Main                ; If only Sonic & Knuckles, skip ahead
                bsr.w   SSEntry_CheckLevel
                beq.s   SSEntryRing_Main                ; If in an S3 level, skip ahead since it's a normal ring
                cmpi.b  #7,(Chaos_emerald_count).w
                bne.s   SSEntryRing_Main                ; Only make this a Super Emerald ring if you actually have 7 Chaos Emeralds

SKSSRing_SetSuperFlagAndPaletteScripts:
                bset    #6,$38(a0)                      ; Make this a Super Emerald ring
                lea     (PalSPtr_SSEntry).l,a1
                lea     (Palette_rotation_data).w,a2
                move.l  (a1)+,(a2)+
                move.l  (a1)+,(a2)+
                lea     (PalSPtr_SSEntry2).l,a1
                move.l  (a1)+,(a2)+
                move.l  (a1)+,(a2)+
                clr.w   (a2)                            ; Set up the palette script pointers

SSEntryRing_Main:
                jsr     (Animate_Raw).l
                tst.w   (Debug_placement_mode).w
                bne.s   SKSSRing_ActivationReturn       ; If in debug mode, don't allow collision
                cmpi.b  #8,mapping_frame(a0)
                blo.s   SKSSRing_ActivationReturn       ; If ring hasn't finished forming, don't allow collision
                lea     SSEntry_Range(pc),a1
                jsr     (Check_PlayerInRange).l
                tst.w   d0
                bne.s   SKSSRing_PlayRingSoundAndSelectOutcome

SKSSRing_ActivationReturn:
                rts
; ---------------------------------------------------------------------------

SKSSRing_PlayRingSoundAndSelectOutcome:
                lea     (Player_1).w,a1                 ; If collision was made
                cmpi.b  #6,routine(a1)
                bhs.s   SKSSRing_ActivationReturn       ; If player has died for whatever reason, don't do anything
                moveq   #signextendB(sfx_BigRing),d0
                jsr     (Play_SFX).l                    ; Play the ring swish sound
                cmpi.b  #7,(Chaos_emerald_count).w
                bne.s   SKSSRing_SetPrimaryAndOptionalP2State  ; If Chaos Emeralds aren't collected, branch
                tst.w   (SK_alone_flag).w
                bne.s   SKSSRing_MarkCollectedAndAward50  ; If only Sonic & Knuckles and the emeralds are collected, go claim 50 rings
                bsr.w   SSEntry_CheckLevel
                beq.s   SKSSRing_MarkCollectedAndAward50  ; Otherwise, only do so if on an S3 level
                cmpi.b  #7,(Super_emerald_count).w
                beq.s   SKSSRing_MarkCollectedAndAward50  ; Only collect rings in an SK level if the Super Emeralds are collected as well

SKSSRing_SetPrimaryAndOptionalP2State:
                move.b  #4,routine(a0)
                move.b  #-1,(Player_prev_frame).w       ; Make the player disappear and lock input
                lea     (Player_1).w,a1
                move.b  #0,mapping_frame(a1)
                move.b  #$1C,anim(a1)
                move.b  #$53,object_control(a1)
                tst.b   (Flying_carrying_Sonic_flag).w
                beq.s   SKSSRing_TryAllocateTransitionFlash
                lea     (Player_2).w,a1
                move.b  #0,mapping_frame(a1)
                move.b  #$1C,anim(a1)
                move.b  #$53,object_control(a1)         ; Lock both players, etc

SKSSRing_TryAllocateTransitionFlash:
                jsr     (AllocateObject).l
                bne.s   SKSSRing_FlashAllocationReturn
                move.l  #Obj_SSEntryFlash,(a1)
                move.w  a0,parent3(a1)                  ; Set ring as parent

SKSSRing_FlashAllocationReturn:
                rts
; ---------------------------------------------------------------------------
SSEntry_Range:
                dc.w    -$18,   $30,  -$28,   $50
; ---------------------------------------------------------------------------

; The reward path requests the ring sound again after the initial contact sound
SKSSRing_MarkCollectedAndAward50:
                moveq   #signextendB(sfx_BigRing),d0
                jsr     (Play_SFX).l
                move.b  subtype(a0),d0
                move.l  (Collected_special_ring_array).w,d1
                bset    d0,d1
                move.l  d1,(Collected_special_ring_array).w  ; Set the special stage ring as collected
                bset    #5,$38(a0)
                moveq   #50,d0                          ; Add 50 rings
                jmp     (AddRings).l
; ---------------------------------------------------------------------------

SSEntryRing_Animate:
                jmp     (Animate_Raw).l
; ---------------------------------------------------------------------------

Obj_SSEntryFlash:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  SSEntryFlash_Index(pc,d0.w),d1
                jsr     SSEntryFlash_Index(pc,d1.w)
                lea     DPLCPtr_SSEntryFlash(pc),a2
                jsr     (Perform_DPLC).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
SSEntryFlash_Index:
                dc.w    SSEntryFlash_Init-SSEntryFlash_Index
                dc.w    SSEntryFlash_Main-SSEntryFlash_Index
; ---------------------------------------------------------------------------

SSEntryFlash_Init:
                lea     ObjSlot_SSEntryFlash(pc),a1
                jsr     (SetUp_ObjAttributesSlotted).l
                move.l  #AniRaw_SSEntryFlash,$30(a0)
                move.l  #SSEntryFlash_Finished,$34(a0)
                movea.w parent3(a0),a1
                move.w  x_pos(a1),x_pos(a0)
                move.w  y_pos(a1),y_pos(a0)
                move.b  subtype(a1),subtype(a0)         ; Copy positional data from parent ring
                move.w  (Player_1+x_pos).w,d0
                cmp.w   x_pos(a0),d0
                blo.s   SKSSRing_FlashOrientationReturn
                bset    #0,render_flags(a1)             ; Set direction based on where player approached

SKSSRing_FlashOrientationReturn:
                rts
; ---------------------------------------------------------------------------

SSEntryFlash_Main:
                move.b  mapping_frame(a0),d6
                jsr     (Animate_RawAdjustFlipX).l
                cmp.b   mapping_frame(a0),d6
                beq.s   SKSSRing_FlashParentCheckReturn
                cmpi.b  #3,anim_frame(a0)
                bne.s   SKSSRing_FlashParentCheckReturn
                movea.w parent3(a0),a1                  ; Set parent to be deleted in the middle of the animation
                bset    #5,$38(a1)

SKSSRing_FlashParentCheckReturn:
                rts
; ---------------------------------------------------------------------------

SSEntryFlash_Finished:
                move.l  #Obj_Wait,(a0)                  ; This is performed when animation is finished
                move.w  #$20,$2E(a0)
                move.l  #SSEntryFlash_GoSS,$34(a0)
                rts
; ---------------------------------------------------------------------------

SSEntryFlash_GoSS:
                moveq   #signextendB(sfx_EnterSS),d0
                jsr     (Play_SFX).l                    ; Play the special stage entry sound (you know the one)
                jsr     (Clear_SpriteRingMem).l
                jsr     (Save_Level_Data2).l
                tst.b   subtype(a0)
                bmi.s   SKSSRing_RequestHiddenPalaceRestart  ; If negative, always go to HPZ
                moveq   #0,d0
                tst.w   (SK_alone_flag).w
                bne.s   SKSSRing_StoreVariantAndEnterStage  ; If SK alone, go directly to special stage
                bsr.w   SSEntry_CheckLevel
                beq.s   SKSSRing_StoreVariantAndEnterStage  ; Otherwise, do so if S3 levels
                cmpi.b  #7,(Chaos_emerald_count).w
                bne.s   SKSSRing_StoreVariantAndEnterStage  ; or if Chaos Emeralds aren't collected
                bra.w   SKSSRing_RequestHiddenPalaceRestart  ; When conditions are met, go to HPZ
; ---------------------------------------------------------------------------
; unused
                moveq   #1,d0

SKSSRing_StoreVariantAndEnterStage:
                move.b  d0,(SK_special_stage_flag).w    ; Regular ring takes you directly to special stage
                move.b  #1,(Special_bonus_entry_flag).w
                move.b  #GameMode_SpecialStage,(Game_mode).w
                move.b  #1,(Respawn_table_keep).w
                bra.w   SKSSRing_MarkCollectedAndScheduleDelete
; ---------------------------------------------------------------------------

; Keep the secondary player's saved snapshot for this restart
SKSSRing_RequestHiddenPalaceRestart:
                move.b  #2,(Special_bonus_entry_flag).w  ; Super Emerald takes you to HPZ
                move.w  #$1701,(Current_zone_and_act).w
                move.w  #$1701,(Apparent_zone_and_act).w
                move.b  #0,(Last_star_post_hit).w
                move.b  #1,(Restart_level_flag).w
                move.b  #1,(Respawn_table_keep).w

SKSSRing_MarkCollectedAndScheduleDelete:
                move.b  subtype(a0),d0
                move.l  (Collected_special_ring_array).w,d1
                bset    d0,d1
                move.l  d1,(Collected_special_ring_array).w  ; Set SS ring as collected
                jmp     (Go_Delete_SpriteSlotted2).l

; =============== S U B R O U T I N E =======================================

SSEntry_CheckLevel:
                cmpi.b  #7,(Current_zone).w
                bhs.s   SKSSEntry_ReturnNonS3ZoneClassification
                cmpi.b  #4,(Current_zone).w
                beq.s   SKSSEntry_ReturnNonS3ZoneClassification
                moveq   #0,d1                           ; 0 is S3 levels
                rts
; ---------------------------------------------------------------------------

SKSSEntry_ReturnNonS3ZoneClassification:
                moveq   #1,d1                           ; 1 is SK levels
                rts
; End of function SSEntry_CheckLevel

; ---------------------------------------------------------------------------

SSEntryRing_Display:
                btst    #5,$38(a0)
                bne.s   SKSSRing_RestoreColorsAndArtThenDelete
                tst.b   4(a0)
                bpl.s   SKSSRing_DrawWithinCameraWindow
                btst    #6,$38(a0)
                beq.s   SKSSRing_RefreshDPLCAndDraw
                jsr     (Run_PalRotationScript).l       ; Only run the rotation script if this is a Super Emerald ring

SKSSRing_RefreshDPLCAndDraw:
                lea     DPLCPtr_SSEntryRing(pc),a2
                jsr     (Perform_DPLC).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKSSRing_DrawWithinCameraWindow:
                move.w  x_pos(a0),d0                    ; If off-screen
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.s   SKSSRing_RestoreColorsAndArtThenDelete
                move.w  y_pos(a0),d0
                move.w  (Camera_Y_pos).w,d1
                move.w  y_pos(a0),d0
                sub.w   (Camera_Y_pos).w,d0
                addi.w  #$80,d0
                cmpi.w  #$200,d0
                bhi.w   SKSSRing_RestoreColorsAndArtThenDelete  ; Jump below when far enough off-screen
                move.l  #$EE0088,(Normal_palette_line_2+$A).w
                move.w  #$44,(Normal_palette_line_2+$1E).w
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKSSRing_RestoreColorsAndArtThenDelete:
                move.l  #$EE0088,(Normal_palette_line_2+$A).w
                move.w  #$44,(Normal_palette_line_2+$1E).w  ; Restore the part of the palette that was changed
                lea     (ArtKosM_BadnikExplosion).l,a1
                move.w  #tiles_to_bytes(ArtTile_Explosion),d2
                jsr     (Queue_Kos_Module).l            ; Restore the overwritten badnik explosion art
                jmp     (Go_Delete_SpriteSlotted).l
; ---------------------------------------------------------------------------
ObjSlot_SSEntryRing:
                dc.w    1-1
                dc.w    make_art_tile(ArtTile_Explosion,1,0)
                dc.w    $40,     4
                dc.l    Map_SSEntryRing
                dc.w    $280
                dc.b    $20, $20,   0,   0
ObjSlot_SSEntryFlash:
                dc.w    1-1
                dc.w    make_art_tile(ArtTile_Player_1,1,0)
                dc.w    $18,     6
                dc.l    Map_SSEntryFlash
                dc.w    $200
                dc.b    $20, $20,   0,   0
DPLCPtr_SSEntryRing:
                dc.l    ArtUnc_SSEntryRing
                dc.l    DPLC_SSEntryRing
DPLCPtr_SSEntryFlash:
                dc.l    ArtUnc_SSEntryFlash
                dc.l    DPLC_SSEntryFlash
AniRaw_SSEntryRing:
                dc.b    4,   0,   0,   1,   2,   3,   4,   5,   6,   7
                dc.b    $F8, .jump-AniRaw_SSEntryRing

                .jump:
                dc.b    6,  $A,   9,   8,  $B, $FC
AniRaw_SSEntryFlash:
                dc.b    0,   0,   0,   1,   2,   3|$40,   3,   2,   1,   0, $F4
                even
