; Owner: objects/zones/hpz/sk
; Responsibility: Hidden Palace Super Emerald variants, collection state, palette and interaction helpers
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_HPZSuperEmerald:
                lea     ObjDat_HPZSuperEmerald(pc),a1
                jsr     (SetUp_ObjAttributes).l
                moveq   #0,d0
                move.b  subtype(a0),d0
                lea     (Collected_emeralds_array).w,a1
                moveq   #0,d1
                move.b  (a1,d0.w),d1
                move.w  d1,d2
                add.w   d2,d2
                move.w  HPZSuper_CollectionStateDispatch(pc,d2.w),d2
                jmp     HPZSuper_CollectionStateDispatch(pc,d2.w)
; ---------------------------------------------------------------------------
HPZSuper_CollectionStateDispatch:
                dc.w    HPZSuper_DeleteUncollectedState-HPZSuper_CollectionStateDispatch
                dc.w    HPZSuper_InitializeGrayEligibleState-HPZSuper_CollectionStateDispatch
                dc.w    HPZSuper_InitializeGrayEligibleState-HPZSuper_CollectionStateDispatch
                dc.w    HPZSuper_InitializeCompletedColoredState-HPZSuper_CollectionStateDispatch
; ---------------------------------------------------------------------------

HPZSuper_DeleteUncollectedState:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

HPZSuper_InitializeGrayEligibleState:
                move.l  #HPZSuper_TopSolidAndArmStageEntry,(a0)
                move.w  #make_art_tile(ArtTile_HPZGrayEmerald,0,1),art_tile(a0)
                bset    #0,$38(a0)
                bsr.w   PlaceHpzSuperEmeraldAtDisplaySlot
                bsr.w   SetHpzSuperEmeraldSpritePriority
                btst    #7,$38(a0)
                beq.s   HPZSuper_DrawAfterGrayInitialization
                move.l  #HPZSuper_WaitForBeamAndApplyGray,(a0)
                move.b  d0,mapping_frame(a0)
                bsr.w   SelectHpzSuperEmeraldArtPalette

HPZSuper_DrawAfterGrayInitialization:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

HPZSuper_InitializeCompletedColoredState:
                move.b  d0,mapping_frame(a0)
                move.l  #HPZSuper_CheckGlobalGrayColorOverride,(a0)
                bsr.w   PlaceHpzSuperEmeraldAtDisplaySlot
                bsr.w   SetHpzSuperEmeraldSpritePriority
                bsr.w   SelectHpzSuperEmeraldArtPalette
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

SelectHpzSuperEmeraldArtPalette:
                move.w  d0,d1
                lsl.w   #2,d1
                cmpi.w  #3,(Player_mode).w
                bne.s   HPZSuper_ApplySelectedArtAndCache
                addq.w  #2,d1

HPZSuper_ApplySelectedArtAndCache:
                move.w  HPZSuper_ModePairedArtWords(pc,d1.w),d0
                move.w  d0,art_tile(a0)
                move.w  d0,$3A(a0)
                rts
; End of function SelectHpzSuperEmeraldArtPalette

; ---------------------------------------------------------------------------
HPZSuper_ModePairedArtWords:
                dc.w    make_art_tile(ArtTile_HPZEmeraldMisc,2,1)
                dc.w    make_art_tile(ArtTile_HPZEmeraldMisc,2,1)
                dc.w    make_art_tile(ArtTile_HPZEmeraldMisc,0,1)
                dc.w    make_art_tile(ArtTile_HPZEmeraldMisc,1,1)
                dc.w    make_art_tile(ArtTile_HPZEmeraldMisc,2,1)
                dc.w    make_art_tile(ArtTile_HPZEmeraldMisc,2,1)
                dc.w    make_art_tile(ArtTile_HPZEmeraldMisc,0,1)
                dc.w    make_art_tile(ArtTile_HPZEmeraldMisc,1,1)
                dc.w    make_art_tile(ArtTile_HPZEmeraldMisc,0,1)
                dc.w    make_art_tile(ArtTile_HPZEmeraldMisc,0,1)
                dc.w    make_art_tile(ArtTile_HPZEmeraldMisc,1,1)
                dc.w    make_art_tile(ArtTile_HPZEmeraldMisc,0,1)
                dc.w    make_art_tile(ArtTile_HPZEmeraldMisc,3,1)
                dc.w    make_art_tile(ArtTile_HPZEmeraldMisc,3,1)

; =============== S U B R O U T I N E =======================================

SetHpzSuperEmeraldSpritePriority:
                move.w  d0,d1
                add.w   d1,d1
                move.w  HPZSuper_DisplayQueuePriorities(pc,d1.w),priority(a0)
                rts
; End of function SetHpzSuperEmeraldSpritePriority

; ---------------------------------------------------------------------------
HPZSuper_DisplayQueuePriorities:
                dc.w    $200
                dc.w    $80
                dc.w    $80
                dc.w    $200
                dc.w    $200
                dc.w    $200
                dc.w    $200
                dc.w    $200

; =============== S U B R O U T I N E =======================================

PlaceHpzSuperEmeraldAtDisplaySlot:
                move.w  d0,d1
                lsl.w   #2,d1
                lea     HPZSuper_DisplaySlotCoordinates(pc,d1.w),a1
                move.w  (a1)+,x_pos(a0)
                move.w  (a1)+,y_pos(a0)
                rts
; End of function PlaceHpzSuperEmeraldAtDisplaySlot

; ---------------------------------------------------------------------------
HPZSuper_DisplaySlotCoordinates:
                dc.w    $1640,  $368
                dc.w    $15E0,  $3A0
                dc.w    $16A0,  $3A0
                dc.w    $15A0,  $350
                dc.w    $16E0,  $350
                dc.w    $1550,  $390
                dc.w    $1730,  $390
                dc.w    $1640,  $3AC
; ---------------------------------------------------------------------------

HPZSuper_WaitForBeamAndApplyGray:
                btst    #5,$38(a0)
                beq.s   HPZSuper_CheckGlobalGrayColorOverride
                move.l  #HPZSuper_TopSolidAndArmStageEntry,(a0)
                move.b  #$1E,mapping_frame(a0)
                move.w  #make_art_tile(ArtTile_HPZGrayEmerald,0,1),art_tile(a0)
                bra.w   HPZSuper_TopSolidAndArmStageEntry
; ---------------------------------------------------------------------------

HPZSuper_CheckGlobalGrayColorOverride:
                move.b  (_unkFAC0).w,d0
                bpl.s   HPZSuper_SelectColoredOrParityFrame
                bclr    #7,d0
                cmp.b   subtype(a0),d0
                bne.s   HPZSuper_SelectColoredOrParityFrame
                move.b  #$1E,mapping_frame(a0)
                move.w  #make_art_tile(ArtTile_HPZGrayEmerald,0,1),art_tile(a0)
                bra.w   HPZSuper_TopSolidAndArmStageEntry
; ---------------------------------------------------------------------------

HPZSuper_SelectColoredOrParityFrame:
                move.b  subtype(a0),mapping_frame(a0)
                move.w  $3A(a0),art_tile(a0)
                btst    #0,(V_int_run_count+3).w
                beq.s   HPZSuper_TopSolidAndArmStageEntry
                move.b  #7,mapping_frame(a0)
                move.w  #make_art_tile(ArtTile_HPZEmeraldMisc,0,1),art_tile(a0)

HPZSuper_TopSolidAndArmStageEntry:
                move.w  #$1B,d1
                move.w  #$10,d2
                move.w  #$10,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectTop).l
                btst    #p1_standing_bit,status(a0)
                beq.s   HPZSuper_DrawAfterTopSolid
                btst    #0,$38(a0)
                beq.s   HPZSuper_DrawAfterTopSolid
                move.l  #HPZSuper_CountDownAndRequestSpecialStage,(a0)
                move.w  #$F,$2E(a0)
                lea     (Player_1).w,a1
                move.b  #$81,object_control(a1)
                move.w  #5<<8,anim(a1)                  ; and prev_anim

HPZSuper_DrawAfterTopSolid:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

HPZSuper_CountDownAndRequestSpecialStage:
                subq.w  #1,$2E(a0)
                bpl.s   HPZSuper_DrawDuringStageRequest
                moveq   #signextendB(sfx_EnterSS),d0
                jsr     (Play_SFX).l
                move.b  subtype(a0),(Current_special_stage).w
                move.b  #1,(Special_bonus_entry_flag).w
                move.b  #GameMode_SpecialStage,(Game_mode).w
                move.b  #1,(Respawn_table_keep).w
                move.b  #1,(SK_special_stage_flag).w
                move.b  (Saved2_last_star_post_hit).w,(Last_star_post_hit).w
                move.b  (Player_1+status_secondary).w,(Saved2_status_secondary).w

HPZSuper_DrawDuringStageRequest:
                jmp     (Draw_Sprite).l
; End of function HPZSuper_WaitForBeamAndApplyGray
