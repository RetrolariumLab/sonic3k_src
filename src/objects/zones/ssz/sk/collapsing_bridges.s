; Owner: objects/zones/ssz/sk
; Responsibility: Normal and diagonal collapsing bridge segment state and player collision
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_SSZCollapsingBridge:
                move.l  #SKSSZFlatBridge_CheckSolidAndCollapse,(a0)
                bset    #2,render_flags(a0)
                move.b  #$10,height_pixels(a0)
                move.b  #$20,width_pixels(a0)
                move.w  #$180,priority(a0)
                move.w  #make_art_tile(ArtTile_SSZMisc+$20,2,1),art_tile(a0)
                move.l  #Map_SSZCollapsingBridge,mappings(a0)
                bset    #7,status(a0)

SKSSZFlatBridge_CheckSolidAndCollapse:
                moveq   #$20,d1
                moveq   #$10,d2
                moveq   #9,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectTop).l
                tst.b   subtype(a0)
                bmi.s   SKSSZFlatBridge_DrawIntactBridge
                move.b  status(a0),d0
                andi.w  #standing_mask,d0
                bne.s   SKSSZFlatBridge_SelectStandingRider

SKSSZFlatBridge_DrawIntactBridge:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

SKSSZFlatBridge_SelectStandingRider:
                lea     (Player_1).w,a1
                btst    #p1_standing_bit,d0
                bne.s   SKSSZFlatBridge_SelectShardOrder
                lea     (Player_2).w,a1

SKSSZFlatBridge_SelectShardOrder:
                moveq   #$18,d1
                moveq   #$10,d2
                move.w  #$102,d3
                move.w  x_pos(a0),d4
                cmp.w   x_pos(a1),d4
                scc     $2E(a0)
                bcs.s   SKSSZFlatBridge_SetStartXAndFrameOrder
                neg.w   d1
                neg.w   d2
                ror.w   #8,d3

SKSSZFlatBridge_SetStartXAndFrameOrder:
                add.w   d4,d1
                btst    #0,render_flags(a0)
                beq.s   SKSSZFlatBridge_TrySpawnFirstShard
                ror.w   #8,d3

SKSSZFlatBridge_TrySpawnFirstShard:
                moveq   #6,d4
                moveq   #4-1,d5
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   SKSSZFlatBridge_BeginCollisionShrink

SKSSZFlatBridge_InitAndTryNextShard:
                move.l  #SKSSZBridgeShard_InitVisibleShard,(a1)
                move.b  render_flags(a0),render_flags(a1)
                move.w  d1,x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.b  d3,mapping_frame(a1)
                move.w  d4,$2E(a1)
                sub.w   d2,d1
                ror.w   #8,d3
                addi.w  #6,d4
                jsr     (CreateNewSprite4).l
                dbne    d5,SKSSZFlatBridge_InitAndTryNextShard

SKSSZFlatBridge_BeginCollisionShrink:
                move.l  #SKSSZFlatBridge_TickCollisionShrink,(a0)
                move.w  #6,$30(a0)
                move.w  #$20,$32(a0)
                rts
; ---------------------------------------------------------------------------

SKSSZFlatBridge_TickCollisionShrink:
                subq.w  #1,$30(a0)
                bne.s   SKSSZFlatBridge_CheckReducedSolidAndCull
                move.w  #6,$30(a0)
                subq.w  #8,$32(a0)
                bne.s   SKSSZFlatBridge_SelectRetreatX
                move.w  #$7FFF,x_pos(a0)

SKSSZFlatBridge_SelectRetreatX:
                moveq   #8,d0
                tst.b   $2E(a0)
                bne.s   SKSSZFlatBridge_ShiftCollisionRoot
                neg.w   d0

SKSSZFlatBridge_ShiftCollisionRoot:
                add.w   d0,x_pos(a0)

SKSSZFlatBridge_CheckReducedSolidAndCull:
                move.w  $32(a0),d1
                moveq   #$10,d2
                moveq   #9,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectTop).l
                jmp     (Delete_Sprite_If_Not_In_Range).l
; ---------------------------------------------------------------------------

Obj_SSZCollapsingBridgeDiagonal:
                move.l  #SKSSZDiagBridge_CheckSlopeAndSaveRiders,(a0)
                ori.b   #$44,render_flags(a0)
                move.b  #$20,height_pixels(a0)
                move.b  #$40,width_pixels(a0)
                move.w  #$180,priority(a0)
                move.w  #make_art_tile(ArtTile_SSZMisc+$20,2,1),art_tile(a0)
                move.l  #Map_SSZCollapsingBridge,mappings(a0)
                move.b  #3,mapping_frame(a0)
                bset    #7,status(a0)

SKSSZDiagBridge_CheckSlopeAndSaveRiders:
                move.b  status(a0),d0
                move.w  d0,-(sp)
                moveq   #$40,d1
                lea     SKSSZDiagBridge_SlopeHeights(pc),a2
                move.w  x_pos(a0),d4
                jsr     (SolidObjectTopSloped2).l
                move.w  (sp)+,d0
                btst    #p1_standing_bit,d0
                beq.s   SKSSZDiagBridge_TryClearP2AirFlag
                lea     (Player_1).w,a1
                btst    #Status_InAir,status(a1)
                beq.s   SKSSZDiagBridge_TryClearP2AirFlag
                tst.b   jumping(a1)
                bne.s   SKSSZDiagBridge_TryClearP2AirFlag
                bclr    #Status_InAir,status(a1)

SKSSZDiagBridge_TryClearP2AirFlag:
                btst    #p2_standing_bit,d0
                beq.s   SKSSZDiagBridge_TryCollapseUnderRiders
                lea     (Player_2).w,a1
                btst    #Status_InAir,status(a1)
                beq.s   SKSSZDiagBridge_TryCollapseUnderRiders
                tst.b   jumping(a1)
                bne.s   SKSSZDiagBridge_TryCollapseUnderRiders
                bclr    #Status_InAir,status(a1)

SKSSZDiagBridge_TryCollapseUnderRiders:
                tst.b   subtype(a0)
                bmi.s   SKSSZDiagBridge_DrawIntactSlope
                move.b  status(a0),d0
                andi.w  #standing_mask,d0
                bne.s   SKSSZDiagBridge_SelectStandingRider

SKSSZDiagBridge_DrawIntactSlope:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

SKSSZDiagBridge_SelectStandingRider:
                lea     (Player_1).w,a1
                btst    #p1_standing_bit,d0
                bne.s   SKSSZDiagBridge_SetShardOrderAndSlope
                lea     (Player_2).w,a1

SKSSZDiagBridge_SetShardOrderAndSlope:
                moveq   #$38,d1
                moveq   #$10,d2
                move.w  #$405,d3
                moveq   #-8,d6
                move.w  x_pos(a0),d4
                cmp.w   x_pos(a1),d4
                scc     $2E(a0)
                bcs.s   SKSSZDiagBridge_TryMirrorShardSlope
                neg.w   d1
                neg.w   d2
                ror.w   #8,d3
                neg.l   d6

SKSSZDiagBridge_TryMirrorShardSlope:
                add.w   d4,d1
                btst    #0,render_flags(a0)
                beq.s   SKSSZDiagBridge_AdjustInitialShardY
                ror.w   #8,d3
                neg.l   d6

SKSSZDiagBridge_AdjustInitialShardY:
                tst.l   d6
                bmi.s   SKSSZDiagBridge_TrySpawnFirstShard
                addq.l  #8,d6

SKSSZDiagBridge_TrySpawnFirstShard:
                moveq   #6,d4
                moveq   #8-1,d5
                swap    d7
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   SKSSZDiagBridge_BeginSlopeShrink

SKSSZDiagBridge_InitStaggeredShard:
                move.l  #SKSSZBridgeShard_InitVisibleShard,(a1)
                move.b  render_flags(a0),d7
                andi.w  #$BF,d7
                move.b  d7,render_flags(a1)
                move.w  d1,x_pos(a1)
                move.w  y_pos(a0),d7
                add.w   d6,d7
                move.w  d7,y_pos(a1)
                move.b  d3,mapping_frame(a1)
                move.w  d4,object_control(a1)
                sub.w   d2,d1
                ror.w   #8,d3
                addi.w  #6,d4
                btst    #0,d5
                bne.s   SKSSZDiagBridge_TryAllocNextShard
                tst.l   d6
                bmi.s   SKSSZDiagBridge_StepNegativeShardY
                subq.w  #8,d6
                bra.s   SKSSZDiagBridge_TryAllocNextShard
; ---------------------------------------------------------------------------

SKSSZDiagBridge_StepNegativeShardY:
                addq.w  #8,d6

SKSSZDiagBridge_TryAllocNextShard:
                jsr     (CreateNewSprite4).l
                dbne    d5,SKSSZDiagBridge_InitStaggeredShard

SKSSZDiagBridge_BeginSlopeShrink:
                swap    d7
                move.l  #SKSSZDiagBridge_TickSlopeShrink,(a0)
                move.w  #6,$30(a0)
                move.w  #$40,$32(a0)
                move.l  #SKSSZDiagBridge_SlopeHeights,$34(a0)
                rts
; ---------------------------------------------------------------------------

SKSSZDiagBridge_TickSlopeShrink:
                subq.w  #1,$30(a0)
                bne.s   SKSSZDiagBridge_CheckReducedSlope
                move.w  #6,$30(a0)
                addq.l  #4,$34(a0)
                subq.w  #8,$32(a0)
                bne.s   SKSSZDiagBridge_SelectRetreatSteps
                move.w  #$7FFF,x_pos(a0)

SKSSZDiagBridge_SelectRetreatSteps:
                moveq   #8,d0
                moveq   #2,d1
                tst.b   $2E(a0)
                bne.s   SKSSZDiagBridge_ShiftXAndMirrorYStep
                neg.w   d0
                neg.w   d1

SKSSZDiagBridge_ShiftXAndMirrorYStep:
                add.w   d0,x_pos(a0)
                btst    #0,render_flags(a0)
                beq.s   SKSSZDiagBridge_ApplyRetreatY
                neg.w   d1

SKSSZDiagBridge_ApplyRetreatY:
                sub.w   d1,y_pos(a0)

; Clear incidental airborne flags for previously standing riders only if they are not jumping
SKSSZDiagBridge_CheckReducedSlope:
                move.b  status(a0),d0
                move.w  d0,-(sp)
                move.w  $32(a0),d1
                movea.l $34(a0),a2
                move.w  x_pos(a0),d4
                jsr     (SolidObjectTopSloped2).l
                move.w  (sp)+,d0
                btst    #p1_standing_bit,d0
                beq.s   SKSSZDiagBridge_TryClearP2ShrinkAirFlag
                lea     (Player_1).w,a1
                btst    #Status_InAir,status(a1)
                beq.s   SKSSZDiagBridge_TryClearP2ShrinkAirFlag
                tst.b   jumping(a1)
                bne.s   SKSSZDiagBridge_TryClearP2ShrinkAirFlag
                bclr    #Status_InAir,status(a1)

SKSSZDiagBridge_TryClearP2ShrinkAirFlag:
                btst    #p2_standing_bit,d0
                beq.s   SKSSZDiagBridge_CullInvisibleSlope
                lea     (Player_2).w,a1
                btst    #Status_InAir,status(a1)
                beq.s   SKSSZDiagBridge_CullInvisibleSlope
                tst.b   jumping(a1)
                bne.s   SKSSZDiagBridge_CullInvisibleSlope
                bclr    #Status_InAir,status(a1)

SKSSZDiagBridge_CullInvisibleSlope:
                jmp     (Delete_Sprite_If_Not_In_Range).l
