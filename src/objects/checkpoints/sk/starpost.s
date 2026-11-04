; Owner: objects/checkpoints/sk
; Responsibility: Checkpoint post activation, star sprites, saved player state and restart support
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_StarPost:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  StarPost_Index(pc,d0.w),d1
                jmp     StarPost_Index(pc,d1.w)
; ---------------------------------------------------------------------------
StarPost_Index:
                dc.w    SKStarpost_InitAndCheckSavedPost-StarPost_Index
                dc.w    SKStarpost_TryActivateP1-StarPost_Index
                dc.w    SKStarpost_AnimateAndCull-StarPost_Index
                dc.w    SKStarpostSpin_TickLifeAndParent-StarPost_Index
                dc.w    SKStarpostStar_TryBonusRestart-StarPost_Index
; ---------------------------------------------------------------------------

SKStarpost_InitAndCheckSavedPost:
                addq.b  #2,routine(a0)
                move.l  #Map_StarPost,mappings(a0)
                move.w  #make_art_tile(ArtTile_StarPost+8,0,0),art_tile(a0)
                move.b  #4,render_flags(a0)
                move.b  #8,width_pixels(a0)
                move.b  #$28,height_pixels(a0)
                move.w  #$280,priority(a0)
                movea.w respawn_addr(a0),a2
                btst    #0,(a2)
                bne.s   SKStarpost_MarkAlreadyActive
                move.b  (Last_star_post_hit).w,d1
                andi.b  #$7F,d1
                move.b  subtype(a0),d2
                andi.b  #$7F,d2
                cmp.b   d2,d1
                blo.s   SKStarpost_TryActivateP1

SKStarpost_MarkAlreadyActive:
                bset    #0,(a2)
                move.b  #2,anim(a0)

SKStarpost_TryActivateP1:
                tst.w   (Debug_placement_mode).w
                bne.w   SKStarpost_AnimateAndCull
                lea     (Player_1).w,a3
                move.b  (Last_star_post_hit).w,d1
                bsr.s   SKStarpost_TryActivateForP1
                bra.w   SKStarpost_AnimateAndCull

; =============== S U B R O U T I N E =======================================

; Only a higher-numbered post can activate. Record the restart snapshot and start the available spin or bonus stars
SKStarpost_TryActivateForP1:
                andi.b  #$7F,d1
                move.b  subtype(a0),d2
                andi.b  #$7F,d2
                cmp.b   d2,d1
                bhs.w   SKStarpost_SetReachedAnimIfIdle
                move.w  x_pos(a3),d0
                sub.w   x_pos(a0),d0
                addi.w  #8,d0
                cmpi.w  #$10,d0
                bhs.w   SKStarpost_ActivationReturn
                move.w  y_pos(a3),d0
                sub.w   y_pos(a0),d0
                addi.w  #$40,d0
                cmpi.w  #$68,d0
                bhs.w   SKStarpost_ActivationReturn
                moveq   #signextendB(sfx_Starpost),d0
                jsr     (Play_SFX).l
                jsr     (AllocateObject).l
                bne.s   SKStarpost_CommitActivation
                move.l  #Obj_StarPost,(a1)
                move.b  #6,routine(a1)
                move.w  x_pos(a0),$30(a1)
                move.w  y_pos(a0),$32(a1)
                subi.w  #$14,$32(a1)
                move.l  mappings(a0),mappings(a1)
                move.w  art_tile(a0),art_tile(a1)
                move.b  #4,render_flags(a1)
                move.b  #8,width_pixels(a1)
                move.b  #8,height_pixels(a1)
                move.w  #$200,priority(a1)
                move.b  #2,mapping_frame(a1)
                move.w  #$20,$36(a1)
                move.w  a0,$3E(a1)
                cmpi.w  #20,(Ring_count).w
                blo.s   SKStarpost_CommitActivation
                bsr.w   SKStarpost_SpawnBonusStarsAndArt

; Save the checkpoint even when the optional child allocation fails
SKStarpost_CommitActivation:
                move.b  #1,anim(a0)
                bsr.w   SKStarpost_SaveCheckpoint
                move.b  #4,routine(a0)
                movea.w respawn_addr(a0),a2
                bset    #0,(a2)

SKStarpost_ActivationReturn:
                rts
; ---------------------------------------------------------------------------

SKStarpost_SetReachedAnimIfIdle:
                tst.b   anim(a0)
                bne.s   SKStarpost_ReachedAnimReturn
                move.b  #2,anim(a0)

SKStarpost_ReachedAnimReturn:
                rts
; End of function SKStarpost_TryActivateForP1

; ---------------------------------------------------------------------------

SKStarpost_AnimateAndCull:
                lea     (Ani_Starpost).l,a1
                jsr     (Animate_Sprite).l
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

SKStarpostSpin_TickLifeAndParent:
                subq.w  #1,$36(a0)
                bpl.s   SKStarpostSpin_PositionFromOldAngle
                movea.w $3E(a0),a1
                cmpi.l  #Obj_StarPost,(a1)
                bne.s   SKStarpostSpin_DeleteExpired
                move.b  #2,anim(a1)
                move.b  #0,mapping_frame(a1)

SKStarpostSpin_DeleteExpired:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

; Use the angle sampled before decrement and the signed high words of the products
SKStarpostSpin_PositionFromOldAngle:
                move.b  angle(a0),d0
                subi.b  #$10,angle(a0)
                subi.b  #$40,d0
                jsr     (GetSineCosine).l
                muls.w  #$C00,d1
                swap    d1
                add.w   $30(a0),d1
                move.w  d1,x_pos(a0)
                muls.w  #$C00,d0
                swap    d0
                add.w   $32(a0),d0
                move.w  d0,y_pos(a0)
                jmp     (Sprite_OnScreen_Test).l

; =============== S U B R O U T I N E =======================================

; Write the post ID and position, then fall through to Save_Level_Data for the full restart snapshot
SKStarpost_SaveCheckpoint:
                move.b  subtype(a0),(Last_star_post_hit).w
                move.w  x_pos(a0),(Saved_X_pos).w
                move.w  y_pos(a0),(Saved_Y_pos).w
; End of function SKStarpost_SaveCheckpoint

; =============== S U B R O U T I N E =======================================

Save_Level_Data:
                move.b  (Last_star_post_hit).w,(Saved_last_star_post_hit).w
                move.w  (Current_zone_and_act).w,(Saved_zone_and_act).w
                move.w  (Apparent_zone_and_act).w,(Saved_apparent_zone_and_act).w
                move.w  (Player_1+art_tile).w,(Saved_art_tile).w
                move.w  (Player_1+top_solid_bit).w,(Saved_solid_bits).w
                move.w  (Ring_count).w,(Saved_ring_count).w
                move.b  (Extra_life_flags).w,(Saved_extra_life_flags).w
                move.l  (Timer).w,(Saved_timer).w
                move.b  (Dynamic_resize_routine).w,(Saved_dynamic_resize_routine).w
                move.w  (Camera_max_Y_pos).w,(Saved_camera_max_Y_pos).w
                move.w  (Camera_X_pos).w,(Saved_camera_X_pos).w
                move.w  (Camera_Y_pos).w,(Saved_camera_Y_pos).w
                move.w  (Mean_water_level).w,(Saved_mean_water_level).w
                move.b  (Water_full_screen_flag).w,(Saved_water_full_screen_flag).w
                rts
; End of function Save_Level_Data

; =============== S U B R O U T I N E =======================================

Save_Level_Data2:
                move.b  (Last_star_post_hit).w,(Saved2_last_star_post_hit).w
                move.w  (Current_zone_and_act).w,(Saved2_zone_and_act).w
                move.w  (Apparent_zone_and_act).w,(Saved2_apparent_zone_and_act).w
                move.w  x_pos(a0),(Saved2_X_pos).w
                move.w  y_pos(a0),(Saved2_Y_pos).w
                move.w  (Player_1+art_tile).w,(Saved2_art_tile).w
                move.w  (Player_1+top_solid_bit).w,(Saved2_solid_bits).w
                move.w  (Ring_count).w,(Saved2_ring_count).w
                move.b  (Extra_life_flags).w,(Saved2_extra_life_flags).w
                move.l  (Timer).w,(Saved2_timer).w
                move.b  (Dynamic_resize_routine).w,(Saved2_dynamic_resize_routine).w
                move.w  (Camera_max_Y_pos).w,(Saved2_camera_max_Y_pos).w
                move.w  (Camera_X_pos).w,(Saved2_camera_X_pos).w
                move.w  (Camera_Y_pos).w,(Saved2_camera_Y_pos).w
                move.w  (Mean_water_level).w,(Saved2_mean_water_level).w
                move.b  (Water_full_screen_flag).w,(Saved2_water_full_screen_flag).w
                move.b  (Player_1+status_secondary).w,(Saved2_status_secondary).w
                rts
; End of function Save_Level_Data2

; =============== S U B R O U T I N E =======================================

Load_Starpost_Settings:
                tst.b   (Special_bonus_entry_flag).w
                bne.w   SKStarpost_RestoreSecondarySnapshot
                move.b  (Saved_last_star_post_hit).w,(Last_star_post_hit).w
                move.w  (Saved_zone_and_act).w,(Current_zone_and_act).w
                move.w  (Saved_apparent_zone_and_act).w,(Apparent_zone_and_act).w
                move.w  (Saved_X_pos).w,(Player_1+x_pos).w
                move.w  (Saved_Y_pos).w,(Player_1+y_pos).w
                move.w  (Saved_ring_count).w,(Ring_count).w
                move.b  (Saved_extra_life_flags).w,(Extra_life_flags).w
                tst.b   (Respawn_table_keep).w
                bne.s   SKStarpost_RestoreTimerAndCamera
                clr.w   (Ring_count).w
                clr.b   (Extra_life_flags).w

; Set the frame byte to 59 and decrement seconds as a byte with wrap
SKStarpost_RestoreTimerAndCamera:
                move.l  (Saved_timer).w,(Timer).w
                move.b  #60-1,(Timer_frame).w
                subq.b  #1,(Timer_second).w
                move.w  (Saved_art_tile).w,(Player_1+art_tile).w
                move.w  (Saved_solid_bits).w,(Player_1+top_solid_bit).w
                move.b  (Saved_dynamic_resize_routine).w,(Dynamic_resize_routine).w
                move.w  (Saved_camera_max_Y_pos).w,(Camera_max_Y_pos).w
                move.w  (Saved_camera_max_Y_pos).w,(Camera_target_max_Y_pos).w
                move.w  (Saved_camera_X_pos).w,(Camera_X_pos).w
                move.w  (Saved_camera_Y_pos).w,(Camera_Y_pos).w
                tst.b   (Water_flag).w
                beq.s   SKStarpost_PrimaryRestoreReturn
                move.w  (Saved_mean_water_level).w,(Mean_water_level).w
                move.b  (Saved_water_full_screen_flag).w,(Water_full_screen_flag).w

SKStarpost_PrimaryRestoreReturn:
                rts
; ---------------------------------------------------------------------------

; The secondary entry snapshot leaves the last-post identifier untouched
SKStarpost_RestoreSecondarySnapshot:
                clr.b   (Special_bonus_entry_flag).w
                move.w  (Saved2_zone_and_act).w,(Current_zone_and_act).w
                move.w  (Saved2_apparent_zone_and_act).w,(Apparent_zone_and_act).w
                move.w  (Saved2_X_pos).w,(Player_1+x_pos).w
                move.w  (Saved2_Y_pos).w,(Player_1+y_pos).w
                move.w  (Saved2_ring_count).w,(Ring_count).w
                move.b  (Saved2_extra_life_flags).w,(Extra_life_flags).w
                move.l  (Saved2_timer).w,(Timer).w
                move.b  #60-1,(Timer_frame).w
                subq.b  #1,(Timer_second).w
                move.w  (Saved2_art_tile).w,(Player_1+art_tile).w
                move.w  (Saved2_solid_bits).w,(Player_1+top_solid_bit).w
                move.b  (Saved2_dynamic_resize_routine).w,(Dynamic_resize_routine).w
                move.w  (Saved2_camera_max_Y_pos).w,(Camera_max_Y_pos).w
                move.w  (Saved2_camera_max_Y_pos).w,(Camera_target_max_Y_pos).w
                move.w  (Saved2_camera_X_pos).w,(Camera_X_pos).w
                move.w  (Saved2_camera_Y_pos).w,(Camera_Y_pos).w
                tst.b   (Water_flag).w
                beq.s   SKStarpost_SecondaryRestoreReturn
                move.w  (Saved2_mean_water_level).w,(Mean_water_level).w
                move.b  (Saved2_water_full_screen_flag).w,(Water_full_screen_flag).w

SKStarpost_SecondaryRestoreReturn:
                rts
; End of function Load_Starpost_Settings

; ---------------------------------------------------------------------------
Ani_Starpost:
                include "src/objects/shared/starpost/animations/starpost.s"
Map_StarPost:
                include "src/objects/shared/starpost/mappings/starpost.s"
Map_StarpostStars:
                include "src/objects/shared/starpost/mappings/stars.s"

; =============== S U B R O U T I N E =======================================

; Try to allocate a four-phase ring and queue art for the bonus stage selected by the ring count
SKStarpost_SpawnBonusStarsAndArt:
                moveq   #4-1,d1
                moveq   #0,d2

SKStarpostQuartet_SpawnOrbitStars:
                jsr     (AllocateObject).l
                bne.s   SKStarpostQuartet_SelectArt
                move.l  (a0),(a1)
                move.l  #Map_StarpostStars,mappings(a1)
                move.w  #make_art_tile(ArtTile_StarPost+8,0,0),art_tile(a1)
                move.b  #4,render_flags(a1)
                move.b  #8,routine(a1)
                move.w  x_pos(a0),d0
                move.w  d0,x_pos(a1)
                move.w  d0,$30(a1)
                move.w  y_pos(a0),d0
                subi.w  #$30,d0
                move.w  d0,y_pos(a1)
                move.w  d0,$32(a1)
                move.w  priority(a0),priority(a1)
                move.b  #8,width_pixels(a1)
                move.b  #1,mapping_frame(a1)
                move.w  #-$400,x_vel(a1)
                move.w  #0,y_vel(a1)
                move.w  d2,$34(a1)
                addi.w  #$40,d2
                dbf     d1,SKStarpostQuartet_SpawnOrbitStars

; Use the live ring band even when only a prefix of the four stars could be allocated
SKStarpostQuartet_SelectArt:
                lea     (ArtKosM_StarPostStars3).l,a1
                move.w  (Ring_count).w,d0
                subi.w  #20,d0
                divu.w  #15,d0
                ext.l   d0
                moveq   #2,d2
                tst.w   (SK_alone_flag).w
                bne.s   SKStarpostQuartet_PickArtRemainder
                moveq   #3,d2

; Use a divisor of two for standalone and three for lock-on
SKStarpostQuartet_PickArtRemainder:
                divu.w  d2,d0
                swap    d0
                tst.w   d0
                beq.s   SKStarpostQuartet_QueueArt
                lea     (ArtKosM_StarPost_Stars1).l,a1
                cmpi.w  #1,d0
                beq.s   SKStarpostQuartet_QueueArt
                tst.w   (SK_alone_flag).w
                bne.s   SKStarpostQuartet_QueueArt
                lea     (ArtKosM_StarPostStars2).l,a1

SKStarpostQuartet_QueueArt:
                move.w  #tiles_to_bytes(ArtTile_StarPost+8),d2
                jmp     (Queue_Kos_Module).l
; End of function SKStarpost_SpawnBonusStarsAndArt

; ---------------------------------------------------------------------------

; Only contact bit 0 enters the bonus restart path
SKStarpostStar_TryBonusRestart:
                move.b  collision_property(a0),d0
                beq.w   SKStarpostStar_BuildOrbitBase
                andi.b  #1,d0
                beq.s   SKStarpostStar_ClearContacts
                move.b  #2,(Special_bonus_entry_flag).w
                move.w  #$1500,d1
                move.w  (Saved_ring_count).w,d0
                subi.w  #20,d0
                divu.w  #15,d0
                ext.l   d0
                moveq   #2,d2
                tst.w   (SK_alone_flag).w
                bne.s   SKStarpostStar_PickBonusZone
                moveq   #3,d2

; Select the zone from the saved ring band modulo two in standalone or three in lock-on
SKStarpostStar_PickBonusZone:
                divu.w  d2,d0
                swap    d0
                tst.w   d0
                beq.s   SKStarpostStar_SaveBonusEntry
                move.w  #$1400,d1
                cmpi.w  #1,d0
                beq.s   SKStarpostStar_SaveBonusEntry
                tst.w   (SK_alone_flag).w
                bne.s   SKStarpostStar_SaveBonusEntry
                move.w  #$1300,d1

; Preserve live rings, extra-life flags and the $71-masked power flags before restart
SKStarpostStar_SaveBonusEntry:
                move.w  d1,(Current_zone_and_act).w
                move.w  d1,(Apparent_zone_and_act).w
                move.w  (Ring_count).w,(Saved_ring_count).w
                move.b  (Extra_life_flags).w,(Saved_extra_life_flags).w
                move.b  #0,(Last_star_post_hit).w
                move.b  #1,(Restart_level_flag).w
                move.b  (Player_1+status_secondary).w,d0
                andi.b  #$71,d0
                move.b  d0,(Saved2_status_secondary).w
                move.b  d0,(Saved_status_secondary).w
                move.b  #1,(Respawn_table_keep).w
                jsr     (Clear_SpriteRingMem).l

SKStarpostStar_ClearContacts:
                clr.b   collision_property(a0)

SKStarpostStar_BuildOrbitBase:
                addi.w  #$A,$34(a0)
                move.w  $34(a0),d0
                andi.w  #$FF,d0
                jsr     (GetSineCosine).l
                asr.w   #5,d0
                asr.w   #3,d1
                move.w  d1,d3
                move.w  $34(a0),d2
                andi.w  #$3E0,d2
                lsr.w   #5,d2
                moveq   #2,d5
                moveq   #0,d4
                cmpi.w  #$10,d2
                ble.s   SKStarpostStar_FoldPhaseTo8
                neg.w   d1

SKStarpostStar_FoldPhaseTo8:
                andi.w  #$F,d2
                cmpi.w  #8,d2
                ble.s   SKStarpostStar_TryAddCosine
                neg.w   d2
                andi.w  #7,d2

SKStarpostStar_TryAddCosine:
                lsr.w   #1,d2
                beq.s   SKStarpostStar_FinishWarpAndAge
                add.w   d1,d4

SKStarpostStar_FinishWarpAndAge:
                asl.w   #1,d1
                dbf     d5,SKStarpostStar_TryAddCosine
                asr.w   #4,d4
                add.w   d4,d0
                addq.w  #1,$36(a0)
                move.w  $36(a0),d1
                cmpi.w  #$80,d1
                beq.s   SKStarpostStar_EnableContactAt128
                bgt.s   SKStarpostStar_CheckOrbitShrink

; Shift the low words of the signed products by seven
SKStarpostStar_ScaleOrbitLowWords:
                muls.w  d1,d0
                muls.w  d1,d3
                asr.w   #7,d0
                asr.w   #7,d3
                bra.s   SKStarpostStar_SetPosAndFrameBits
; ---------------------------------------------------------------------------

SKStarpostStar_EnableContactAt128:
                move.b  #$D8,collision_flags(a0)

SKStarpostStar_CheckOrbitShrink:
                cmpi.w  #$180,d1
                ble.s   SKStarpostStar_SetPosAndFrameBits
                neg.w   d1
                addi.w  #$200,d1
                bmi.w   SKStarpostStar_DeleteAfterShrink
                bra.s   SKStarpostStar_ScaleOrbitLowWords
; ---------------------------------------------------------------------------

SKStarpostStar_SetPosAndFrameBits:
                move.w  $30(a0),d2
                add.w   d3,d2
                move.w  d2,x_pos(a0)
                move.w  $32(a0),d2
                add.w   d0,d2
                move.w  d2,y_pos(a0)
                addq.b  #1,anim_frame(a0)
                move.b  anim_frame(a0),d0
                andi.w  #6,d0
                lsr.w   #1,d0
                cmpi.b  #3,d0
                bne.s   SKStarpostStar_SetFrameAndQueueTouch
                moveq   #1,d0

SKStarpostStar_SetFrameAndQueueTouch:
                move.b  d0,mapping_frame(a0)
                jmp     (Sprite_CheckDeleteTouch3).l
; ---------------------------------------------------------------------------

SKStarpostStar_DeleteAfterShrink:
                jmp     (Delete_Current_Sprite).l
