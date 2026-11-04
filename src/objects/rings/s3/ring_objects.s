; Owner: objects/rings/s3
; Responsibility: Dynamic ring objects, collection rewards, bouncing lost rings and attracted ring motion
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_Ring:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Ring_Index(pc,d0.w),d1
                jmp     Ring_Index(pc,d1.w)
; ---------------------------------------------------------------------------
Ring_Index:
                dc.w    Obj_RingInit-Ring_Index
                dc.w    Obj_RingAnimate-Ring_Index
                dc.w    Obj_RingCollect-Ring_Index
                dc.w    Obj_RingSparkle-Ring_Index
                dc.w    Obj_RingDelete-Ring_Index
; ---------------------------------------------------------------------------

Obj_RingInit:
                addq.b  #2,routine(a0)
                move.l  #Map_Ring,mappings(a0)
                move.w  #make_art_tile(ArtTile_Ring,1,1),art_tile(a0)
                move.b  #4,render_flags(a0)
                move.w  #$100,priority(a0)
                move.b  #$47,collision_flags(a0)
                move.b  #8,width_pixels(a0)
                tst.w   (Competition_mode).w
                beq.s   Obj_RingAnimate
                move.w  #make_art_tile(ArtTile_2PArt_3+$C,3,0),art_tile(a0)

Obj_RingAnimate:
                move.b  (Rings_frame).w,mapping_frame(a0)
                bra.w   Sprite_CheckDeleteTouch3
; ---------------------------------------------------------------------------

Obj_RingCollect:
                addq.b  #2,routine(a0)
                move.b  #0,collision_flags(a0)
                move.w  #$80,priority(a0)
                bsr.s   GiveRing

Obj_RingSparkle:
                lea     (Ani_RingSparkle).l,a1
                bsr.w   Animate_Sprite
                bra.w   Draw_Sprite
; ---------------------------------------------------------------------------

Obj_RingDelete:
                bra.w   Delete_Current_Sprite

; =============== S U B R O U T I N E =======================================

GiveRing:
                cmpi.w  #999,(Total_ring_count).w       ; did Sonic collect 999 or more rings?
                bhs.s   GiveRing_1P                     ; if yes, branch
                addq.w  #1,(Total_ring_count).w         ; add 1 to the number of collected rings

GiveRing_1P:
                move.w  #sfx_RingRight,d0               ; prepare to play the ring sound
                cmpi.w  #999,(Ring_count).w             ; does the player 1 have 999 or more rings?
                bhs.s   JmpTo_Play_SFX                  ; if yes, play the ring sound
                addq.w  #1,(Ring_count).w               ; add 1 to the ring count
                ori.b   #1,(Update_HUD_ring_count).w    ; set flag to update the ring counter in the HUD
                cmpi.w  #100,(Ring_count).w             ; does the player 1 have less than 100 rings?
                blo.s   JmpTo_Play_SFX                  ; if yes, play the ring sound
                bset    #1,(Extra_life_flags).w         ; test and set the flag for the first extra life
                beq.s   S3Rings_AwardP1RingThresholdExtraLife  ; if it was clear before, branch
                cmpi.w  #200,(Ring_count).w             ; does the player 1 have less than 200 rings?
                blo.s   JmpTo_Play_SFX                  ; if yes, play the ring sound
                bset    #2,(Extra_life_flags).w         ; test and set the flag for the second extra life
                bne.s   JmpTo_Play_SFX                  ; if it was set before, play the ring sound

S3Rings_AwardP1RingThresholdExtraLife:
                addq.b  #1,(Life_count).w               ; add 1 to the life count
                addq.b  #1,(Update_HUD_life_count).w    ; add 1 to the displayed life count
                moveq   #signextendB(mus_ExtraLife),d0  ; prepare to play the extra life jingle
                jmp     (Play_Music).l                  ; Sonic 2 wound up putting music in the stereo sound queue, this would have fixed it
; ---------------------------------------------------------------------------

JmpTo_Play_SFX:
                jmp     (Play_SFX).l
; ---------------------------------------------------------------------------
; unused
                rts
; ---------------------------------------------------------------------------

GiveRing_Tails:
                cmpi.w  #999,(Total_ring_count_P2).w
                bhs.s   S3Rings_SaturateP2CurrentRingCountAt999
                addq.w  #1,(Total_ring_count_P2).w

S3Rings_SaturateP2CurrentRingCountAt999:
                cmpi.w  #999,(Ring_count_P2).w
                bhs.s   S3RingReward_SelectP2CreditPath
                addq.w  #1,(Ring_count_P2).w

S3RingReward_SelectP2CreditPath:
                tst.w   (Competition_mode).w
                beq.s   GiveRing_1P
                ori.b   #1,(_unkFEBE).w
                move.w  #sfx_RingRight,d0
                cmpi.w  #100,(Ring_count_P2).w
                blo.s   S3Rings_PlayP2CompetitionRingPickupSound
                bset    #1,(Extra_life_flags_P2).w
                beq.s   S3RingReward_AwardCompP2Life
                cmpi.w  #200,(Ring_count_P2).w
                blo.s   S3Rings_PlayP2CompetitionRingPickupSound
                bset    #2,(Extra_life_flags_P2).w
                bne.s   S3Rings_PlayP2CompetitionRingPickupSound

S3RingReward_AwardCompP2Life:
                addq.b  #1,(Life_count_P2).w
                moveq   #signextendB(mus_ExtraLife),d0
                jmp     (Play_Music).l
; ---------------------------------------------------------------------------

S3Rings_PlayP2CompetitionRingPickupSound:
                jmp     (Play_SFX).l
; End of function GiveRing

; ---------------------------------------------------------------------------

Obj_Bouncing_Ring:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Bouncing_Ring_Index(pc,d0.w),d1
                jmp     Bouncing_Ring_Index(pc,d1.w)
; ---------------------------------------------------------------------------
Bouncing_Ring_Index:
                dc.w    S3RingSpill_SelectLedger-Bouncing_Ring_Index
                dc.w    S3RingSpill_MoveAndTryFloorBounce-Bouncing_Ring_Index
                dc.w    S3RingSpill_CollectAndSparkle-Bouncing_Ring_Index
                dc.w    S3RingSpill_DrawSparkle-Bouncing_Ring_Index
                dc.w    S3Rings_DeleteExpiredOrFinishedLostRing-Bouncing_Ring_Index
; ---------------------------------------------------------------------------

; The raw owner low byte chooses the ring ledger. The current object becomes the first spilled ring
S3RingSpill_SelectLedger:
                movea.l a0,a1
                moveq   #0,d5
                move.w  (Ring_count).w,d5
                tst.b   $3F(a0)
                beq.s   S3RingSpill_CapAt32
                move.w  (Ring_count_P2).w,d5

S3RingSpill_CapAt32:
                moveq   #$20,d0
                cmp.w   d0,d5
                blo.s   S3RingSpill_InitCountAndFanSeed
                move.w  d0,d5

S3RingSpill_InitCountAndFanSeed:
                subq.w  #1,d5
                move.w  #$288,d4
                bra.s   S3RingSpill_InitRingAndFanVel
; ---------------------------------------------------------------------------

S3RingSpill_TryNextRing:
                bsr.w   AllocateObjectAfterCurrent
                bne.w   S3RingSpill_PlayLossAndClearP1

S3RingSpill_InitRingAndFanVel:
                move.l  #Obj_Bouncing_Ring,(a1)
                addq.b  #2,routine(a1)
                move.b  #8,y_radius(a1)
                move.b  #8,x_radius(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.l  #Map_Ring,mappings(a1)
                move.w  #make_art_tile(ArtTile_Ring,1,1),art_tile(a1)
                move.b  #$84,render_flags(a1)
                move.w  #$180,priority(a1)
                move.b  #$47,collision_flags(a1)
                move.b  #8,width_pixels(a1)
                move.b  #-1,(Ring_spill_anim_counter).w
                tst.w   d4
                bmi.s   S3RingSpill_StoreVelAndMirrorX
                move.w  d4,d0
                jsr     (GetSineCosine).l
                move.w  d4,d2
                lsr.w   #8,d2
                asl.w   d2,d0
                asl.w   d2,d1
                move.w  d0,d2
                move.w  d1,d3
                addi.b  #$10,d4
                bcc.s   S3RingSpill_StoreVelAndMirrorX
                subi.w  #$80,d4
                bcc.s   S3RingSpill_StoreVelAndMirrorX
                move.w  #$288,d4

S3RingSpill_StoreVelAndMirrorX:
                move.w  d2,x_vel(a1)
                move.w  d3,y_vel(a1)
                neg.w   d2
                neg.w   d4
                dbf     d5,S3RingSpill_TryNextRing

; Clear the Player 1 ledger even when the spill count came from Player 2
S3RingSpill_PlayLossAndClearP1:
                move.w  #signextendB(sfx_RingLoss),d0
                jsr     (Play_SFX).l
                move.w  #0,(Ring_count).w
                move.b  #$80,(Update_HUD_ring_count).w
                move.b  #0,(Extra_life_flags).w

S3RingSpill_MoveAndTryFloorBounce:
                move.b  (Ring_spill_anim_frame).w,mapping_frame(a0)
                bsr.w   MoveSprite2
                addi.w  #$18,y_vel(a0)
                bmi.s   S3RingSpill_CullOrQueueTouch
                move.b  (V_int_run_count+3).w,d0
                add.b   d7,d0
                andi.b  #7,d0
                bne.s   S3RingSpill_CullOrQueueTouch
                tst.b   render_flags(a0)
                bpl.s   S3RingSpill_CullOrQueueTouch
                jsr     (RingCheckFloorDist).l
                tst.w   d1
                bpl.s   S3RingSpill_CullOrQueueTouch
                add.w   d1,y_pos(a0)
                move.w  y_vel(a0),d0
                asr.w   #2,d0
                sub.w   d0,y_vel(a0)
                neg.w   y_vel(a0)

S3RingSpill_CullOrQueueTouch:
                tst.b   (Ring_spill_anim_counter).w
                beq.s   S3Rings_DeleteExpiredOrFinishedLostRing
                move.w  (Camera_max_Y_pos).w,d0
                addi.w  #$E0,d0
                cmp.w   y_pos(a0),d0
                blo.s   S3Rings_DeleteExpiredOrFinishedLostRing
                bsr.w   Add_SpriteToCollisionResponseList
                move.w  (Level_repeat_offset).w,d0
                sub.w   d0,x_pos(a0)
                bra.w   Draw_Sprite
; ---------------------------------------------------------------------------

S3RingSpill_CollectAndSparkle:
                addq.b  #2,routine(a0)
                move.b  #0,collision_flags(a0)
                move.w  #$80,priority(a0)
                bsr.w   GiveRing

S3RingSpill_DrawSparkle:
                lea     (Ani_RingSparkle).l,a1
                bsr.w   Animate_Sprite
                bra.w   Draw_Sprite
; ---------------------------------------------------------------------------

S3Rings_DeleteExpiredOrFinishedLostRing:
                bra.w   Delete_Current_Sprite
; ---------------------------------------------------------------------------

Obj_Attracted_Ring:
; init
                move.l  #Map_Ring,mappings(a0)
                move.w  #make_art_tile(ArtTile_Ring,1,1),art_tile(a0)
                move.b  #4,render_flags(a0)
                move.w  #$100,priority(a0)
                move.b  #$47,collision_flags(a0)
                move.b  #8,width_pixels(a0)
                move.b  #8,height_pixels(a0)
                move.b  #8,y_radius(a0)
                move.b  #8,x_radius(a0)
                move.l  #S3AttractedRing_MoveOrRelease,(a0)

S3AttractedRing_MoveOrRelease:
                tst.b   routine(a0)
                bne.s   AttractedRing_GiveRing
                bsr.w   AttractedRing_Move
                btst    #Status_LtngShield,(Player_1+status_secondary).w  ; Does player still have a lightning shield?
                bne.s   Obj_Attracted_RingAnimate
                move.l  #Obj_Bouncing_Ring,(a0)         ; If not, change object
                move.b  #2,routine(a0)
                move.b  #-1,(Ring_spill_anim_counter).w

Obj_Attracted_RingAnimate:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   S3AttractedRing_CullOrDraw
                move.b  #3,anim_frame_timer(a0)
                addq.b  #1,mapping_frame(a0)
                andi.b  #3,mapping_frame(a0)

S3AttractedRing_CullOrDraw:
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   S3AttractedRing_ClearLoadedBit
                bsr.w   Add_SpriteToCollisionResponseList
                bra.w   Draw_Sprite
; ---------------------------------------------------------------------------

S3AttractedRing_ClearLoadedBit:
                move.w  respawn_addr(a0),d0
                beq.s   S3AttractedRing_ClearStatusFromVector
                movea.w d0,a2
                bclr    #7,(a2)

; The original status-clear path reads the absolute word at Vectors+$30
S3AttractedRing_ClearStatusFromVector:
; Bug: Probably meant to be $30(a0), as Test_Ring_Collisions_AttractRing
; stores the ring's address in the ring status table there
; This is corrected in Sonic & Knuckles Collection
                move.w  (Vectors+$30).w,d0
                beq.s   S3Rings_DeleteCoarseCulledAttractedRing
                movea.w d0,a2
                move.w  #0,(a2)

S3Rings_DeleteCoarseCulledAttractedRing:
                bra.w   Delete_Current_Sprite
; ---------------------------------------------------------------------------

AttractedRing_GiveRing:
                move.b  #0,collision_flags(a0)
                move.w  #$80,priority(a0)
                subq.w  #1,(Perfect_rings_left).w
                bsr.w   GiveRing
                move.l  #S3AttractedRing_AnimateSparkle,(a0)
                move.b  #0,routine(a0)

S3AttractedRing_AnimateSparkle:
                tst.b   routine(a0)
                bne.s   S3AttractedRing_DeleteAfterSparkle
                lea     (Ani_RingSparkle).l,a1
                bsr.w   Animate_Sprite
                bra.w   Draw_Sprite
; ---------------------------------------------------------------------------

S3AttractedRing_DeleteAfterSparkle:
                bra.w   Delete_Current_Sprite

; =============== S U B R O U T I N E =======================================

AttractedRing_Move:
; Move on X axis
                move.w  #$30,d1
                move.w  (Player_1+x_pos).w,d0
                cmp.w   x_pos(a0),d0
                bhs.s   AttractedRing_MoveRight         ; If ring is to the left of the player, branch

                neg.w   d1
                tst.w   x_vel(a0)
                bmi.s   AttractedRing_ApplyMovementX
                add.w   d1,d1
                add.w   d1,d1
                bra.s   AttractedRing_ApplyMovementX
; ---------------------------------------------------------------------------

AttractedRing_MoveRight:
                tst.w   x_vel(a0)
                bpl.s   AttractedRing_ApplyMovementX
                add.w   d1,d1
                add.w   d1,d1

AttractedRing_ApplyMovementX:
                add.w   d1,x_vel(a0)
; Move on Y axis
                move.w  #$30,d1
                move.w  (Player_1+y_pos).w,d0
                cmp.w   y_pos(a0),d0
                bhs.s   AttractedRing_MoveUp            ; If ring is below the player, branch

                neg.w   d1
                tst.w   y_vel(a0)
                bmi.s   AttractedRing_ApplyMovementY
                add.w   d1,d1
                add.w   d1,d1
                bra.s   AttractedRing_ApplyMovementY
; ---------------------------------------------------------------------------

AttractedRing_MoveUp:
                tst.w   y_vel(a0)
                bpl.s   AttractedRing_ApplyMovementY
                add.w   d1,d1
                add.w   d1,d1

AttractedRing_ApplyMovementY:
                add.w   d1,y_vel(a0)
                jmp     (MoveSprite2).l
; End of function AttractedRing_Move

; ---------------------------------------------------------------------------
Ani_RingSparkle:
                include "src/objects/shared/ring/animations/sparkle.s"
Map_Ring:
                include "src/objects/shared/ring/mappings/ring.s"
