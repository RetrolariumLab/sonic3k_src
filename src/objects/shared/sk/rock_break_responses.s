; Owner: objects/shared/sk
; Responsibility: Additional standing and character break responses, push recovery, fragment creation and shared fragment or mapping tables
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

SKRock_UpdateVerticalResponseBreakRock:
                move.w  (Player_1+y_vel).w,$30(a0)
                move.w  (Player_2+y_vel).w,$36(a0)
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                addi.w  #$B,d1
                moveq   #0,d2
                move.b  height_pixels(a0),d2
                move.w  d2,d3
                addq.w  #1,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                swap    d6
                andi.w  #4|8,d6
                bne.s   SKRock_RestoreP1ImpactYVel
                move.w  $2E(a0),d0
                jmp     (Sprite_OnScreen_Test2).l
; ---------------------------------------------------------------------------

SKRock_RestoreP1ImpactYVel:
                move.b  d6,d0
                andi.b  #4,d0
                beq.s   SKRock_RestoreP2ImpactYVel
                lea     (Player_1).w,a1
                move.w  $30(a0),y_vel(a1)
                andi.b  #8,d6
                beq.s   SKRock_ReleaseP1BeforeShatter
                lea     (Player_2).w,a1
                move.w  $36(a0),y_vel(a1)
                bra.s   SKRock_ReleaseP1BeforeShatter
; ---------------------------------------------------------------------------

SKRock_RestoreP2ImpactYVel:
                andi.b  #8,d6
                beq.s   SKRock_DrawVerticalBreakRockUsingAnchor
                lea     (Player_2).w,a1
                move.w  $36(a0),y_vel(a1)
                bra.s   SKRock_ReleaseP1BeforeShatter
; ---------------------------------------------------------------------------

SKRock_DrawVerticalBreakRockUsingAnchor:
                move.w  $2E(a0),d0
                jmp     (Sprite_OnScreen_Test2).l
; ---------------------------------------------------------------------------

SKRock_ReleaseP1BeforeShatter:
                btst    #p1_standing_bit,status(a0)
                beq.s   SKRock_ReleaseP2BeforeShatter
                lea     (Player_1).w,a1
                bset    #Status_InAir,status(a1)
                bclr    #Status_OnObj,status(a1)

SKRock_ReleaseP2BeforeShatter:
                btst    #p2_standing_bit,status(a0)
                beq.s   SKRock_StartDefaultVerticalRockShatter
                lea     (Player_2).w,a1
                bset    #Status_InAir,status(a1)
                bclr    #Status_OnObj,status(a1)

SKRock_StartDefaultVerticalRockShatter:
                move.l  #SKRock_DispatchRockDebrisAnimationByZone,(a0)
                bsr.w   ShatterRockWithDefaultVelocities
                bra.w   SKRock_DispatchRockDebrisAnimationByZone
; ---------------------------------------------------------------------------

SKRock_UpdateP1KnucklesStandingBreakRock:
                move.w  (Chain_bonus_counter).w,$38(a0)
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                addi.w  #$B,d1
                moveq   #0,d2
                move.b  height_pixels(a0),d2
                move.w  d2,d3
                addq.w  #1,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                move.b  status(a0),d0
                andi.b  #p1_standing,d0
                bne.s   SKRock_BounceKnuxAndP2

SKRock_DrawKnucklesTopBreakRockInRange:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

SKRock_BounceKnuxAndP2:
                lea     (Player_1).w,a1
                cmpi.b  #2,character_id(a1)
                bne.s   SKRock_DrawKnucklesTopBreakRockInRange
                bsr.s   BouncePlayerAfterKnucklesRockTopBreak
                btst    #p2_standing_bit,status(a0)
                beq.s   SKRock_ShatterKnuxTopAndRestoreChain
                lea     (Player_2).w,a1
                bsr.s   BouncePlayerAfterKnucklesRockTopBreak
                bra.w   SKRock_ShatterKnuxTopAndRestoreChain

; =============== S U B R O U T I N E =======================================

BouncePlayerAfterKnucklesRockTopBreak:
                bset    #Status_Roll,status(a1)
                move.b  #$E,y_radius(a1)
                move.b  #7,x_radius(a1)
                move.b  #2,anim(a1)
                move.w  #-$300,y_vel(a1)
                bset    #Status_InAir,status(a1)
                bclr    #Status_OnObj,status(a1)
                move.b  #2,routine(a1)
                rts
; End of function BouncePlayerAfterKnucklesRockTopBreak

; ---------------------------------------------------------------------------

SKRock_ShatterKnuxTopAndRestoreChain:
                move.w  $38(a0),(Chain_bonus_counter).w
                andi.b  #$E7,status(a0)
                move.l  #SKRock_DispatchRockDebrisAnimationByZone,(a0)
                bsr.w   ShatterRockWithDefaultVelocities
                bra.w   SKRock_DispatchRockDebrisAnimationByZone

; =============== S U B R O U T I N E =======================================

UpdatePlayersPushingRockLeft:
                move.b  status(a0),d3
                andi.b  #pushing_mask,d3
                beq.w   SKRock_ReturnFromRockLeftPushPass
                move.w  x_pos(a0),d2
                lea     (Player_1).w,a1
                move.b  $3A(a0),d0
                moveq   #p1_pushing_bit,d6
                bsr.s   StepPushableRockLeftForPlayer
                lea     (Player_2).w,a1
                move.b  $3B(a0),d0
                moveq   #p2_pushing_bit,d6
                bsr.s   StepPushableRockLeftForPlayer

SKRock_ReturnFromRockLeftPushPass:
                rts
; End of function UpdatePlayersPushingRockLeft

; =============== S U B R O U T I N E =======================================

StepPushableRockLeftForPlayer:
                btst    d6,d3
                beq.s   SKRock_ReturnFromSingleRockLeftPushStep
                cmp.w   x_pos(a1),d2
                bhs.s   SKRock_ReturnFromSingleRockLeftPushStep
                btst    #5,d0
                beq.s   SKRock_ReturnFromSingleRockLeftPushStep
                subq.w  #1,$40(a0)
                bpl.s   SKRock_ReturnFromSingleRockLeftPushStep
                move.w  #$10,$40(a0)
                tst.w   $42(a0)
                beq.s   SKRock_ReturnFromSingleRockLeftPushStep
                subq.w  #1,$42(a0)
                subq.w  #1,x_pos(a0)
                subq.w  #1,x_pos(a1)
                jsr     (ObjCheckFloorDist).l
                add.w   d1,y_pos(a0)
                move.w  respawn_addr(a0),d0
                beq.s   SKRock_ReturnFromSingleRockLeftPushStep
                movea.w d0,a2
                move.b  $43(a0),d0
                subi.b  #$40,d0
                neg.b   d0
                move.b  d0,(a2)
                bset    #7,(a2)

SKRock_ReturnFromSingleRockLeftPushStep:
                rts
; End of function StepPushableRockLeftForPlayer

; =============== S U B R O U T I N E =======================================

ShatterRockWithDefaultVelocities:
                cmpi.b  #9,(Current_zone).w
                beq.w   SKRock_SelectLRZFragmentData
                moveq   #0,d0
                move.b  mapping_frame(a0),d0
                add.w   d0,d0
                lea     (SKRock_DefaultFragmentVelocityOffsets).l,a4
                adda.w  (a4,d0.w),a4
; End of function ShatterRockWithDefaultVelocities

; =============== S U B R O U T I N E =======================================

SpawnRockFragments:
                lea     (SKRock_FragmentLayoutOffsets).l,a3
                adda.w  (a3,d0.w),a3
                move.w  (a3)+,d1
                move.l  (a0),d4
                move.b  render_flags(a0),d5
                move.w  x_pos(a0),d2
                move.w  y_pos(a0),d3
                move.w  #3,d6
                movea.l a0,a1
                bra.s   SKRock_InitializeOrdinaryRockFragment
; ---------------------------------------------------------------------------

SKRock_AllocateNextOrdinaryRockFragment:
                bsr.w   AllocateObjectAfterCurrent
                bne.s   SKRock_PlaySoundAfterOrdinaryRockShatter

SKRock_InitializeOrdinaryRockFragment:
                move.l  d4,(a1)
                move.l  mappings(a0),mappings(a1)
                move.b  d5,render_flags(a1)
                move.b  (a3)+,d0
                ext.w   d0
                add.w   d2,d0
                move.w  d0,x_pos(a1)
                move.b  (a3)+,d0
                ext.w   d0
                add.w   d3,d0
                move.w  d0,y_pos(a1)
                move.w  art_tile(a0),art_tile(a1)
                ori.w   #high_priority,art_tile(a1)
                move.w  #$80,priority(a1)
                move.b  #$18,width_pixels(a1)
; Bug: This only covers the width, when it
; should be covering the height as the width
; has already been defined
                move.b  #$18,width_pixels(a1)
                move.w  (a4)+,x_vel(a1)
                move.w  (a4)+,y_vel(a1)
                move.b  d6,mapping_frame(a1)
                addq.b  #1,d6
                cmpi.b  #7,d6
                blo.s   SKRock_LoopOrdinaryRockFragmentCount
                move.w  #3,d6

SKRock_LoopOrdinaryRockFragmentCount:
                dbf     d1,SKRock_AllocateNextOrdinaryRockFragment

SKRock_PlaySoundAfterOrdinaryRockShatter:
                moveq   #signextendB(sfx_Collapse),d0
                jmp     (Play_SFX).l
; End of function SpawnRockFragments

; ---------------------------------------------------------------------------

SKRock_SelectLRZFragmentData:
                move.l  #SKRock_TickLRZDebrisFourFrameGroup,(a0)
                moveq   #0,d0
                move.b  mapping_frame(a0),d0
                subq.b  #4,d0
                add.w   d0,d0
                lea     (SKRock_DefaultFragmentVelocityOffsets).l,a4
                adda.w  (a4,d0.w),a4

; =============== S U B R O U T I N E =======================================

SpawnLavaReefRockFragments:
                lea     (SKRock_FragmentLayoutOffsets).l,a3
                adda.w  (a3,d0.w),a3
                move.w  (a3)+,d1
                move.l  (a0),d4
                move.b  render_flags(a0),d5
                move.w  x_pos(a0),d2
                move.w  y_pos(a0),d3
                move.w  #3,d6
                movea.l a0,a1
                bra.s   SKRock_InitializeLRZTripleRecordFragment
; ---------------------------------------------------------------------------

SKRock_AllocateNextLRZRockFragment:
                bsr.w   AllocateObjectAfterCurrent
                bne.s   SKRock_PlaySoundAfterLRZRockShatter

SKRock_InitializeLRZTripleRecordFragment:
                move.l  d4,(a1)
                move.l  mappings(a0),mappings(a1)
                move.b  d5,render_flags(a1)
                move.b  (a3)+,d0
                ext.w   d0
                add.w   d2,d0
                move.w  d0,x_pos(a1)
                move.b  (a3)+,d0
                ext.w   d0
                add.w   d3,d0
                move.w  d0,y_pos(a1)
                move.w  art_tile(a0),art_tile(a1)
                ori.w   #high_priority,art_tile(a1)
                move.w  #$80,priority(a1)
                move.b  #$20,width_pixels(a1)
; Bug: This only covers the width, when it
; should be covering the height as the width
; has already been defined
                move.b  #$20,width_pixels(a1)
                move.w  (a4)+,x_vel(a1)
                move.w  (a4)+,y_vel(a1)
                move.b  (a3)+,mapping_frame(a1)
                move.b  mapping_frame(a1),d0
                andi.b  #$FC,d0
                move.b  d0,$3C(a1)
                move.b  #7,anim_frame_timer(a1)
                dbf     d1,SKRock_AllocateNextLRZRockFragment

SKRock_PlaySoundAfterLRZRockShatter:
                moveq   #signextendB(sfx_Collapse),d0
                jmp     (Play_SFX).l
; End of function SpawnLavaReefRockFragments

; ---------------------------------------------------------------------------
SKRock_FragmentLayoutOffsets:
                dc.w    SKRock_ShapeZeroFragmentOffsets-SKRock_FragmentLayoutOffsets
                dc.w    SKRock_ShapeOneFragmentOffsets-SKRock_FragmentLayoutOffsets
                dc.w    SKRock_ShapeTwoFragmentOffsets-SKRock_FragmentLayoutOffsets
                dc.w    SKRock_CompShape3FragmentOffsets-SKRock_FragmentLayoutOffsets
                dc.w    SKRock_LRZShapeFourFragmentTriples-SKRock_FragmentLayoutOffsets
                dc.w    SKRock_LRZShapesFiveSixSharedTriples-SKRock_FragmentLayoutOffsets
                dc.w    SKRock_LRZShapesFiveSixSharedTriples-SKRock_FragmentLayoutOffsets
                dc.w    SKRock_LRZShapeSevenFragmentTriples-SKRock_FragmentLayoutOffsets
SKRock_ShapeZeroFragmentOffsets:
                dc.w    8-1
                dc.b    -8, -$18
                dc.b    $B, -$1C
                dc.b    -4,  -$C
                dc.b    $C,   -4
                dc.b    -$C,    4
                dc.b    4,   $C
                dc.b    -$C,  $1C
                dc.b    $C,  $1C
SKRock_ShapeOneFragmentOffsets:
                dc.w    5-1
                dc.b    -4,  -$C
                dc.b    $B,  -$C
                dc.b    -4,   -4
                dc.b    -$C,   $C
                dc.b    $C,   $C
SKRock_ShapeTwoFragmentOffsets:
                dc.w    4-1
                dc.b    -4,   -4
                dc.b    $C,   -4
                dc.b    -$C,    4
                dc.b    $C,    4
SKRock_CompShape3FragmentOffsets:
                dc.w    6-1
                dc.b    -8,   -8
                dc.b    8,   -8
                dc.b    -8,    0
                dc.b    8,    0
                dc.b    -8,    8
                dc.b    8,    8
SKRock_LRZShapeFourFragmentTriples:
                dc.w    6-1
                dc.b    0,  $10,   6
                dc.b    0,    0,   7
                dc.b    -8, -$10,   1
                dc.b    8,  $20,   0
                dc.b    0, -$18,   6
                dc.b    0,  $1B,   7
SKRock_LRZShapesFiveSixSharedTriples:
                dc.w    6-1
                dc.b    8,    3,   7
                dc.b    -8,   -5,   1
                dc.b    -$10,    8,   1
                dc.b    -$18,    0,   7
                dc.b    0,    0,   6
                dc.b    $18,    0,   6
SKRock_LRZShapeSevenFragmentTriples:
                dc.w    2-1
                dc.b    0,  $10,   1
                dc.b    0, -$10,   0
SKRock_DefaultFragmentVelocityOffsets:
                dc.w    SKRock_ShapeZeroAndPrimarySideVelocities-SKRock_DefaultFragmentVelocityOffsets
                dc.w    SKRock_ShapeOneDefaultVelocities-SKRock_DefaultFragmentVelocityOffsets
                dc.w    SKRock_ShapeTwoDefaultVelocities-SKRock_DefaultFragmentVelocityOffsets
                dc.w    SKRock_ShapeThreeDefaultVelocities-SKRock_DefaultFragmentVelocityOffsets
                dc.w    SKRock_LRZShape4To7LeftVel-SKRock_DefaultFragmentVelocityOffsets
                dc.w    SKRock_LRZShapesFiveSixMixedVelocities-SKRock_DefaultFragmentVelocityOffsets
                dc.w    SKRock_LRZShapesFiveSixMixedVelocities-SKRock_DefaultFragmentVelocityOffsets
                dc.w    SKRock_LRZShape4To7LeftVel-SKRock_DefaultFragmentVelocityOffsets
SKRock_ShapeZeroAndPrimarySideVelocities:
                dc.w    -$300, -$300
                dc.w    -$2C0, -$280
                dc.w    -$2C0, -$280
                dc.w    -$280, -$200
                dc.w    -$280, -$180
                dc.w    -$240, -$180
                dc.w    -$240, -$100
                dc.w    -$200, -$100
SKRock_AlternatePositiveSideVelocities:
                dc.w    $2C0, -$280
                dc.w    $300, -$300
                dc.w    $280, -$200
                dc.w    $2C0, -$280
                dc.w    $240, -$180
                dc.w    $280, -$180
                dc.w    $200, -$100
                dc.w    $240, -$100
SKRock_ShapeOneDefaultVelocities:
                dc.w    -$200, -$200
                dc.w    $200, -$200
                dc.w    -$100, -$1E0
                dc.w    -$1B0, -$1C0
                dc.w    $1C0, -$1C0
SKRock_ShapeTwoDefaultVelocities:
                dc.w    -$100, -$200
                dc.w    $100, -$1E0
                dc.w    -$1B0, -$1C0
                dc.w    $1C0, -$1C0
SKRock_ShapeThreeDefaultVelocities:
                dc.w    -$B0, -$1E0
                dc.w    $B0, -$1D0
                dc.w    -$80, -$200
                dc.w    $80, -$1E0
                dc.w    -$D8, -$1C0
                dc.w    $E0, -$1C0
SKRock_CompFragmentLeftVel:
                dc.w    -$2C0, -$280
                dc.w    -$280, -$200
                dc.w    -$280, -$180
                dc.w    -$240, -$180
                dc.w    -$240, -$100
                dc.w    -$200, -$100
SKRock_CompFragmentRightVel:
                dc.w    $2C0, -$280
                dc.w    $280, -$200
                dc.w    $280, -$180
                dc.w    $240, -$180
                dc.w    $240, -$100
                dc.w    $200, -$100
SKRock_LRZShape4To7LeftVel:
                dc.w    -$300, -$300
                dc.w    -$2C0, -$280
                dc.w    -$2C0, -$280
                dc.w    -$280, -$200
                dc.w    -$280, -$180
                dc.w    -$240, -$180
                dc.w    -$240, -$100
                dc.w    -$200, -$100
SKRock_LRZShapesFiveSixMixedVelocities:
                dc.w    $C0, -$1E0
                dc.w    -$80, -$1A0
                dc.w    -$A0, -$160
                dc.w    -$100, -$1E0
                dc.w    $40, -$1C0
                dc.w    $100, -$1E0
Map_LRZBreakableRock:
                include "src/objects/shared/zones/lrz/mappings/breakable_rock.s"
Map_LRZBreakableRock2:
                include "src/objects/shared/zones/lrz/mappings/breakable_rock_act2.s"
