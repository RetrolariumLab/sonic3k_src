; Owner: objects/rings/sk
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
                beq.s   SKRings_AwardP1LatchedRingThresholdLife  ; if it was clear before, branch
                cmpi.w  #200,(Ring_count).w             ; does the player 1 have less than 200 rings?
                blo.s   JmpTo_Play_SFX                  ; if yes, play the ring sound
                bset    #2,(Extra_life_flags).w         ; test and set the flag for the second extra life
                bne.s   JmpTo_Play_SFX                  ; if it was set before, play the ring sound

SKRings_AwardP1LatchedRingThresholdLife:
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
                bhs.s   SKRingReward_TryIncrementP2
                addq.w  #1,(Total_ring_count_P2).w

SKRingReward_TryIncrementP2:
                cmpi.w  #999,(Ring_count_P2).w
                bhs.s   SKRingReward_SelectP2CreditPath
                addq.w  #1,(Ring_count_P2).w

SKRingReward_SelectP2CreditPath:
                tst.w   (Competition_mode).w
                beq.s   GiveRing_1P
                ori.b   #1,(RingCollectionWriteOnlyStickyBit).w
                move.w  #sfx_RingRight,d0
                cmpi.w  #100,(Ring_count_P2).w
                blo.s   SKRings_RequestCompetitionP2RingSound
                bset    #1,(Extra_life_flags_P2).w
                beq.s   SKRingReward_AwardCompP2Life
                cmpi.w  #200,(Ring_count_P2).w
                blo.s   SKRings_RequestCompetitionP2RingSound
                bset    #2,(Extra_life_flags_P2).w
                bne.s   SKRings_RequestCompetitionP2RingSound

SKRingReward_AwardCompP2Life:
                addq.b  #1,(Life_count_P2).w
                moveq   #signextendB(mus_ExtraLife),d0
                jmp     (Play_Music).l
; ---------------------------------------------------------------------------

SKRings_RequestCompetitionP2RingSound:
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
                dc.w    SKRingSpill_SelectGravityHandler-Bouncing_Ring_Index
                dc.w    SKRingSpill_MoveAndTryFloorBounce-Bouncing_Ring_Index
                dc.w    SKRingSpill_CollectAndSparkle-Bouncing_Ring_Index
                dc.w    SKRingSpill_DrawSparkle-Bouncing_Ring_Index
                dc.w    SKRingSpill_Delete-Bouncing_Ring_Index
; ---------------------------------------------------------------------------

Obj_Bouncing_Ring_Reverse_Gravity:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Bouncing_Ring_Reverse_Gravity_Index(pc,d0.w),d1
                jmp     Bouncing_Ring_Reverse_Gravity_Index(pc,d1.w)
; ---------------------------------------------------------------------------
Bouncing_Ring_Reverse_Gravity_Index:
                dc.w    SKRingSpill_SelectGravityHandler-Bouncing_Ring_Reverse_Gravity_Index
                dc.w    SKRingSpill_MoveAndTryCeilingBounce-Bouncing_Ring_Reverse_Gravity_Index
                dc.w    SKRingSpill_CollectAndSparkle-Bouncing_Ring_Reverse_Gravity_Index
                dc.w    SKRingSpill_DrawSparkle-Bouncing_Ring_Reverse_Gravity_Index
                dc.w    SKRingSpill_Delete-Bouncing_Ring_Reverse_Gravity_Index
; ---------------------------------------------------------------------------

SKRingSpill_SelectGravityHandler:
                move.l  #Obj_Bouncing_Ring,d6
                tst.b   (Reverse_gravity_flag).w
                beq.s   SKRingSpill_SelectLedger
                move.l  #Obj_Bouncing_Ring_Reverse_Gravity,d6

SKRingSpill_SelectLedger:
                movea.l a0,a1
                moveq   #0,d5
                move.w  (Ring_count).w,d5
                tst.b   $3F(a0)
                beq.s   SKRingSpill_CapAt32
                move.w  (Ring_count_P2).w,d5

SKRingSpill_CapAt32:
                moveq   #$20,d0
                cmp.w   d0,d5
                blo.s   SKRingSpill_InitCountAndFanSeed
                move.w  d0,d5

SKRingSpill_InitCountAndFanSeed:
                subq.w  #1,d5
                move.w  #$288,d4
                bra.s   SKRingSpill_InitRingAndFanVel
; ---------------------------------------------------------------------------

SKRingSpill_TryNextRing:
                bsr.w   AllocateObjectAfterCurrent
                bne.w   SKRingSpill_PlayLossAndMoveFirst

SKRingSpill_InitRingAndFanVel:
                move.l  d6,(a1)
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
                bmi.s   SKRingSpill_StoreVelAndMirrorX
                move.w  d4,d0
                jsr     (GetSineCosine).l
                move.w  d4,d2
                lsr.w   #8,d2
                asl.w   d2,d0
                asl.w   d2,d1
                move.w  d0,d2
                move.w  d1,d3
                addi.b  #$10,d4
                bcc.s   SKRingSpill_StoreVelAndMirrorX
                subi.w  #$80,d4
                bcc.s   SKRingSpill_StoreVelAndMirrorX
                move.w  #$288,d4

SKRingSpill_StoreVelAndMirrorX:
                move.w  d2,x_vel(a1)
                move.w  d3,y_vel(a1)
                neg.w   d2
                neg.w   d4
                dbf     d5,SKRingSpill_TryNextRing

; Clear Player 1's ring ledger, then move the original object immediately
SKRingSpill_PlayLossAndMoveFirst:
                move.w  #signextendB(sfx_RingLoss),d0
                jsr     (Play_SFX).l
                move.w  #0,(Ring_count).w
                move.b  #$80,(Update_HUD_ring_count).w
                move.b  #0,(Extra_life_flags).w
                tst.b   (Reverse_gravity_flag).w
                bne.w   SKRingSpill_MoveAndTryCeilingBounce

SKRingSpill_MoveAndTryFloorBounce:
                move.b  (Ring_spill_anim_frame).w,mapping_frame(a0)
                bsr.w   MoveSprite2
                addi.w  #$18,y_vel(a0)
                bmi.s   SKRingSpill_DrawNormalAndQueueTouch
                move.b  (V_int_run_count+3).w,d0
                add.b   d7,d0
                andi.b  #7,d0
                bne.s   SKRingSpill_DrawNormalAndQueueTouch
                tst.b   render_flags(a0)
                bpl.s   SKRingSpill_CheckLifetimeAndMaxY
                jsr     (RingCheckFloorDist).l
                tst.w   d1
                bpl.s   SKRingSpill_CheckLifetimeAndMaxY
                add.w   d1,y_pos(a0)
                move.w  y_vel(a0),d0
                asr.w   #2,d0
                sub.w   d0,y_vel(a0)
                neg.w   y_vel(a0)

SKRingSpill_CheckLifetimeAndMaxY:
                tst.b   (Ring_spill_anim_counter).w
                beq.s   SKRingSpill_Delete
                move.w  (Camera_max_Y_pos).w,d0
                addi.w  #$E0,d0
                cmp.w   y_pos(a0),d0
                blo.s   SKRingSpill_Delete

SKRingSpill_DrawNormalAndQueueTouch:
                jsr     (Add_SpriteToCollisionResponseList).l
                move.w  (Level_repeat_offset).w,d0
                sub.w   d0,x_pos(a0)
                bra.w   Draw_Sprite
; ---------------------------------------------------------------------------

SKRingSpill_CollectAndSparkle:
                addq.b  #2,routine(a0)
                move.b  #0,collision_flags(a0)
                move.w  #$80,priority(a0)
                bsr.w   GiveRing

SKRingSpill_DrawSparkle:
                lea     (Ani_RingSparkle).l,a1
                bsr.w   Animate_Sprite
                bra.w   Draw_Sprite
; ---------------------------------------------------------------------------

SKRingSpill_Delete:
                bra.w   Delete_Current_Sprite
; ---------------------------------------------------------------------------

SKRingSpill_MoveAndTryCeilingBounce:
                move.b  (Ring_spill_anim_frame).w,mapping_frame(a0)
                bsr.w   MoveSprite_TestGravity2
                addi.w  #$18,y_vel(a0)
                bmi.s   SKRingSpill_DrawReverseAndQueueTouch
                move.b  (V_int_run_count+3).w,d0
                add.b   d7,d0
                andi.b  #7,d0
                bne.s   SKRingSpill_DrawReverseAndQueueTouch
                tst.b   render_flags(a0)
                bpl.s   SKRingSpill_CheckReverseLifetime
                jsr     (RingCheckFloorDist_ReverseGravity).l
                tst.w   d1
                bpl.s   SKRingSpill_CheckReverseLifetime
                sub.w   d1,y_pos(a0)
                move.w  y_vel(a0),d0
                asr.w   #2,d0
                sub.w   d0,y_vel(a0)
                neg.w   y_vel(a0)

; Reverse gravity shares the lifetime counter and the same unsigned maximum Y test
SKRingSpill_CheckReverseLifetime:
                tst.b   (Ring_spill_anim_counter).w
                beq.s   SKRingSpill_Delete
                move.w  (Camera_max_Y_pos).w,d0
                addi.w  #$E0,d0
                cmp.w   y_pos(a0),d0
                blo.s   SKRingSpill_Delete

SKRingSpill_DrawReverseAndQueueTouch:
                jsr     (Add_SpriteToCollisionResponseList).l
                move.w  (Level_repeat_offset).w,d0
                sub.w   d0,x_pos(a0)
                bra.w   Draw_Sprite
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
                move.l  #SKAttractedRing_MoveOrRelease,(a0)

SKAttractedRing_MoveOrRelease:
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
                bpl.s   SKAttractedRing_CullOrDraw
                move.b  #3,anim_frame_timer(a0)
                addq.b  #1,mapping_frame(a0)
                andi.b  #3,mapping_frame(a0)

SKAttractedRing_CullOrDraw:
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   SKAttractedRing_ClearLoadedBit
                jsr     (Add_SpriteToCollisionResponseList).l
                bra.w   Draw_Sprite
; ---------------------------------------------------------------------------

SKAttractedRing_ClearLoadedBit:
                move.w  respawn_addr(a0),d0
                beq.s   SKAttractedRing_ClearStatusFromVector
                movea.w d0,a2
                bclr    #7,(a2)

; The original status-clear path reads the absolute word at Vectors+$30
SKAttractedRing_ClearStatusFromVector:
; Bug: Probably meant to be $30(a0), as Test_Ring_Collisions_AttractRing
; stores the ring's address in the ring status table there
; This is corrected in Sonic & Knuckles Collection
                move.w  (Vectors+$30).w,d0
                beq.s   SKAttractedRing_DeleteAfterCleanup
                movea.w d0,a2
                move.w  #0,(a2)

SKAttractedRing_DeleteAfterCleanup:
                bra.w   Delete_Current_Sprite
; ---------------------------------------------------------------------------

AttractedRing_GiveRing:
                move.b  #0,collision_flags(a0)
                move.w  #$80,priority(a0)
                subq.w  #1,(Perfect_rings_left).w
                bsr.w   GiveRing
                move.l  #SKAttractedRing_AnimateSparkle,(a0)
                move.b  #0,routine(a0)

SKAttractedRing_AnimateSparkle:
                tst.b   routine(a0)
                bne.s   SKAttractedRing_DeleteAfterSparkle
                lea     (Ani_RingSparkle).l,a1
                bsr.w   Animate_Sprite
                bra.w   Draw_Sprite
; ---------------------------------------------------------------------------

SKAttractedRing_DeleteAfterSparkle:
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
; ---------------------------------------------------------------------------

Obj_SlotRing:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  SlotRing_Index(pc,d0.w),d1
                jmp     SlotRing_Index(pc,d1.w)
; ---------------------------------------------------------------------------
SlotRing_Index:
                dc.w    SKSlotRing_EaseAndRewardAtZero-SlotRing_Index
                dc.w    SKSlotRing_DrawRewardSparkle-SlotRing_Index
                dc.w    SKSlotRing_DeleteAfterReward-SlotRing_Index
; ---------------------------------------------------------------------------

SKSlotRing_EaseAndRewardAtZero:
                moveq   #0,d1
                move.w  $3C(a0),d1
                swap    d1
                move.l  $34(a0),d0
                sub.l   d1,d0
                asr.l   #4,d0
                sub.l   d0,$34(a0)
                move.w  $34(a0),x_pos(a0)
                moveq   #0,d1
                move.w  $3E(a0),d1
                swap    d1
                move.l  $38(a0),d0
                sub.l   d1,d0
                asr.l   #4,d0
                sub.l   d0,$38(a0)
                move.w  $38(a0),y_pos(a0)
                lea     Ani_Ring(pc),a1
                bsr.w   Animate_Sprite
                subq.w  #1,$40(a0)
                bne.w   Draw_Sprite
                movea.l $2E(a0),a1
                subq.w  #1,(a1)
                bsr.w   GiveRing
                addi.b  #2,routine(a0)

SKSlotRing_DrawRewardSparkle:
                lea     Ani_RingSparkle(pc),a1
                bsr.w   Animate_Sprite
                bra.w   Draw_Sprite
; ---------------------------------------------------------------------------

SKSlotRing_DeleteAfterReward:
                bra.w   Delete_Current_Sprite
; ---------------------------------------------------------------------------
Ani_Ring:
                include "src/objects/shared/ring/animations/ring.s"
