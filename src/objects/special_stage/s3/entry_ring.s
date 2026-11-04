; Owner: objects/special_stage/s3
; Responsibility: Special-stage entry ring collection, entry flash, player transition and sprite resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_SSEntryRing:
                move.b  subtype(a0),d0
                move.l  (Collected_special_ring_array).w,d1
                btst    d0,d1
                beq.s   S3SSRing_WaitForVisibilityThenDispatch  ; only make the ring if it hasn't already been collected
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

S3SSRing_WaitForVisibilityThenDispatch:
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

SSEntryRing_Main:
                jsr     (Animate_Raw).l
                tst.w   (Debug_placement_mode).w
                bne.s   S3SSRing_ActivationReturn       ; If in debug mode, don't allow collision
                cmpi.b  #8,mapping_frame(a0)
                blo.s   S3SSRing_ActivationReturn       ; If ring hasn't finished forming, don't allow collision
                lea     SSEntry_Range(pc),a1
                jsr     (Check_PlayerInRange).l
                tst.w   d0
                bne.s   S3SSRing_CheckSevenChaosOrEnterStage

S3SSRing_ActivationReturn:
                rts
; ---------------------------------------------------------------------------

S3SSRing_CheckSevenChaosOrEnterStage:
                lea     (Player_1).w,a1                 ; If collision was made
                cmpi.b  #6,routine(a1)
                bhs.s   S3SSRing_ActivationReturn       ; If player has died for whatever reason, don't do anything
                cmpi.w  #7,(Chaos_emerald_count).w      ; If the emeralds are collected, go claim 50 rings
                beq.s   S3SSRing_MarkCollectedAndAward50
                move.b  #4,routine(a0)
                move.b  #-1,(Player_prev_frame).w       ; Make the player disappear and lock input
                lea     (Player_1).w,a1
                move.b  #0,mapping_frame(a1)
                move.b  #$1C,anim(a1)
                move.b  #$53,object_control(a1)
                lea     S3SSEntry_FlashSimpleChildDescriptor(pc),a2
                jsr     (CreateChild6_Simple).l
                move.w  (Player_1+x_pos).w,d0
                cmp.w   x_pos(a0),d0
                bcs.s   S3SSRing_ActivationReturn
                bset    #0,render_flags(a1)
                moveq   #signextendB(sfx_BigRing),d0
                jsr     (Play_SFX).l                    ; Play the ring swish sound
                rts
; ---------------------------------------------------------------------------
SSEntry_Range:
                dc.w    -$18,   $30,  -$28,   $50
; ---------------------------------------------------------------------------

S3SSRing_MarkCollectedAndAward50:
                moveq   #signextendB(sfx_BigRing),d0
                jsr     (Play_SFX).l
                move.b  subtype(a0),d0
                move.l  (Collected_special_ring_array).w,d1
                bset    d0,d1
                move.l  d1,(Collected_special_ring_array).w  ; Set the special stage ring as collected
                bset    #0,$38(a0)
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
                move.l  #AniRaw_SSEntryFlash,$30(a0)
                move.l  #SSEntryFlash_Finished,$34(a0)
                movea.w parent3(a0),a1
                move.b  subtype(a1),subtype(a0)
                lea     ObjSlot_SSEntryFlash(pc),a1
                jmp     (SetUp_ObjAttributesSlotted).l
; ---------------------------------------------------------------------------

SSEntryFlash_Main:
                move.b  mapping_frame(a0),d6
                jsr     (Animate_RawAdjustFlipX).l
                cmp.b   mapping_frame(a0),d6
                beq.s   S3SSRing_FlashParentCheckReturn
                cmpi.b  #3,anim_frame(a0)
                bne.s   S3SSRing_FlashParentCheckReturn
                movea.w parent3(a0),a1                  ; Set parent to be deleted in the middle of the animation
                bset    #0,$38(a1)

S3SSRing_FlashParentCheckReturn:
                rts
; ---------------------------------------------------------------------------

SSEntryFlash_Finished:
                move.l  #Obj_Wait,(a0)                  ; This is performed when animation is finished
                move.w  #$20,$2E(a0)
                move.l  #SSEntryFlash_GoSS,$34(a0)
                rts
; ---------------------------------------------------------------------------

SSEntryFlash_GoSS:
                cmpi.w  #7,(Chaos_emerald_count).w
                beq.s   S3SSRing_ScheduleFlashTrackedDelete
                moveq   #signextendB(sfx_EnterSS),d0
                jsr     (Play_SFX).l                    ; Play the special stage entry sound (you know the one)
                jsr     (Clear_SpriteRingMem).l
                jsr     (Save_Level_Data2).l
                move.b  #1,(Special_bonus_entry_flag).w
                move.b  #GameMode_SpecialStage3,(Game_mode).w
                move.b  #1,(Respawn_table_keep).w
                move.b  subtype(a0),d0
                move.l  (Collected_special_ring_array).w,d1
                bset    d0,d1
                move.l  d1,(Collected_special_ring_array).w  ; Set SS ring as collected

S3SSRing_ScheduleFlashTrackedDelete:
                jmp     (Go_Delete_SpriteSlotted2).l
; ---------------------------------------------------------------------------

SSEntryRing_Display:
                btst    #0,$38(a0)
                bne.s   S3SSRing_RestoreExplosionArtAndDelete
                tst.b   render_flags(a0)
                bpl.s   S3SSRing_DrawWithinCameraWindow
                lea     DPLCPtr_SSEntryRing(pc),a2
                jsr     (Perform_DPLC).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3SSRing_DrawWithinCameraWindow:
                move.w  x_pos(a0),d0                    ; If off-screen
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.s   S3SSRing_RestoreExplosionArtAndDelete
                move.w  y_pos(a0),d0
                move.w  (Camera_Y_pos).w,d1
                move.w  y_pos(a0),d0
                sub.w   (Camera_Y_pos).w,d0
                addi.w  #$80,d0
                cmpi.w  #$200,d0
                bhi.w   S3SSRing_RestoreExplosionArtAndDelete  ; Jump below when far enough off-screen
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3SSRing_RestoreExplosionArtAndDelete:
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
S3SSEntry_FlashSimpleChildDescriptor:
                dc.w    1-1
                dc.l    Obj_SSEntryFlash
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
Map_SSEntryRing:
                include "src/objects/shared/ss_entry/mappings/entry_ring.s"
DPLC_SSEntryRing:
                include "src/objects/shared/ss_entry/dplc/ring.s"
Map_SSEntryFlash:
                include "src/objects/shared/ss_entry/mappings/entry_flash.s"
DPLC_SSEntryFlash:
                include "src/objects/shared/ss_entry/dplc/flash.s"
