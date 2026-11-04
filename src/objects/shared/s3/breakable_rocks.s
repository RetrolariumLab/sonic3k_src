; Owner: objects/shared/s3
; Responsibility: Shared Angel Island, Lava Reef and Endless Mine rock states, player breakage, fragments and mapping resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------
S3Rock_RockShapeSizePairs:
                dc.b    $18, $27
                dc.b    $18, $17
                dc.b    $18,  $F
                dc.b    $E,  $F
; ---------------------------------------------------------------------------

Obj_AIZLRZEMZRock:
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsr.w   #4,d0
                andi.b  #7,d0
                move.b  d0,mapping_frame(a0)
                add.w   d0,d0
                move.b  S3Rock_RockShapeSizePairs(pc,d0.w),width_pixels(a0)
                move.b  S3Rock_RockShapeSizePairs+1(pc,d0.w),d1
                move.b  d1,height_pixels(a0)
                move.b  d1,y_radius(a0)
                move.l  #Map_AIZRock,mappings(a0)
                move.w  #make_art_tile(ArtTile_AIZMisc1,1,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.w  #$200,priority(a0)
                move.w  x_pos(a0),$2E(a0)
                move.w  #$40,child_dx(a0)
                cmpi.w  #1,(Current_zone_and_act).w
                bne.s   S3Rock_SelectEndlessMineMapOverride
                move.l  #Map_AIZRock2,mappings(a0)
                move.w  #make_art_tile(ArtTile_AIZMisc2,2,0),art_tile(a0)

S3Rock_SelectEndlessMineMapOverride:
                cmpi.w  #$1200,(Current_zone_and_act).w
                bne.s   S3Rock_SelectOrdinaryOrSideBreakMode
                move.l  #Map_EMZRock,mappings(a0)
                move.w  #make_art_tile(ArtTile_EMZMisc,3,1),art_tile(a0)
                move.b  #0,mapping_frame(a0)

S3Rock_SelectOrdinaryOrSideBreakMode:
                move.l  #S3Rock_CachePlayersAndCollideRock,(a0)
                btst    #2,subtype(a0)
                beq.s   S3Rock_RestoreSavedLeftPushDisplacement
                move.l  #S3Rock_UpdateSideBreakRockCollision,(a0)
                bra.w   S3Rock_UpdateSideBreakRockCollision
; ---------------------------------------------------------------------------

S3Rock_RestoreSavedLeftPushDisplacement:
                move.w  respawn_addr(a0),d0
                beq.s   S3Rock_CachePlayersAndCollideRock
                movea.w d0,a2
                move.b  (a2),d0
                andi.w  #$7F,d0
                beq.s   S3Rock_CachePlayersAndCollideRock
                sub.w   d0,x_pos(a0)
                neg.w   d0
                addi.w  #$40,d0
                move.w  d0,child_dx(a0)
                jsr     (ObjCheckFloorDist).l
                add.w   d1,y_pos(a0)

S3Rock_CachePlayersAndCollideRock:
                move.w  (Chain_bonus_counter).w,$38(a0)
                move.b  (Player_1+anim).w,$32(a0)
                move.b  (Player_2+anim).w,$33(a0)
                move.b  (Player_1+status).w,$3A(a0)
                move.b  (Player_2+status).w,$3B(a0)
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                addi.w  #$B,d1
                moveq   #0,d2
                move.b  height_pixels(a0),d2
                move.w  d2,d3
                addq.w  #1,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                btst    #1,subtype(a0)
                beq.s   S3Rock_GateTopBreakBySubtypeAndStanding
                bsr.w   UpdatePlayersPushingRockLeft

S3Rock_GateTopBreakBySubtypeAndStanding:
                btst    #0,subtype(a0)
                beq.s   S3Rock_DrawByAnchorOutsideComp
                move.b  status(a0),d0
                andi.b  #standing_mask,d0
                bne.s   S3Rock_CheckRollWithBothRiders

S3Rock_DrawByAnchorOutsideComp:
                tst.w   (Competition_mode).w
                bne.s   S3Rock_DrawCompetitionRockDirectly
                move.w  $2E(a0),d0
                jmp     (Sprite_OnScreen_Test2).l
; ---------------------------------------------------------------------------

S3Rock_DrawCompetitionRockDirectly:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

; When both standing bits are set, require the cached rolling animation from at least one rider
S3Rock_CheckRollWithBothRiders:
                cmpi.b  #$18,d0
                bne.s   S3Rock_CheckSingleFirstPlayerTopBreak
                cmpi.b  #2,$32(a0)
                beq.s   S3Rock_ReleaseBothTopRiders
                cmpi.b  #2,$33(a0)
                bne.s   S3Rock_DrawByAnchorOutsideComp

S3Rock_ReleaseBothTopRiders:
                lea     (Player_1).w,a1
                move.b  $32(a0),d0
                bsr.s   ReleaseRockRiderWithConditionalBounce
                lea     (Player_2).w,a1
                move.b  $33(a0),d0
                bsr.s   ReleaseRockRiderWithConditionalBounce
                bra.w   S3Rock_RestoreChainAndShatterTop
; ---------------------------------------------------------------------------

S3Rock_CheckSingleFirstPlayerTopBreak:
                move.b  d0,d1
                andi.b  #8,d1
                beq.s   S3Rock_CheckSingleSecondPlayerTopBreak
                cmpi.b  #2,$32(a0)
                bne.s   S3Rock_DrawByAnchorOutsideComp
                lea     (Player_1).w,a1
                bsr.s   BouncePlayerAfterRockTopBreak
                bra.s   S3Rock_RestoreChainAndShatterTop

; =============== S U B R O U T I N E =======================================

ReleaseRockRiderWithConditionalBounce:
                cmpi.b  #2,d0
                bne.s   S3Rock_FinishRockRiderAirborneRelease
; End of function ReleaseRockRiderWithConditionalBounce

; =============== S U B R O U T I N E =======================================

BouncePlayerAfterRockTopBreak:
                bset    #Status_Roll,status(a1)
                move.b  #$E,y_radius(a1)
                move.b  #7,x_radius(a1)
                move.b  #2,anim(a1)
                move.w  #-$300,y_vel(a1)

S3Rock_FinishRockRiderAirborneRelease:
                bset    #Status_InAir,status(a1)
                bclr    #Status_OnObj,status(a1)
                move.b  #2,routine(a1)
                rts
; End of function BouncePlayerAfterRockTopBreak

; ---------------------------------------------------------------------------

S3Rock_CheckSingleSecondPlayerTopBreak:
                andi.b  #$10,d0
                beq.w   S3Rock_DrawByAnchorOutsideComp
                cmpi.b  #2,$33(a0)
                bne.w   S3Rock_DrawByAnchorOutsideComp
                lea     (Player_2).w,a1
                bsr.s   BouncePlayerAfterRockTopBreak

S3Rock_RestoreChainAndShatterTop:
                move.w  $38(a0),(Chain_bonus_counter).w
                andi.b  #$E7,status(a0)
                tst.w   (Competition_mode).w
                bne.w   S3Rock_CloneCompetitionRockThenShatter
                move.l  #S3Rock_TickOrdinaryRockDebrisFrameCycle,(a0)
                bsr.w   ShatterRockWithDefaultVelocities

S3Rock_TickOrdinaryRockDebrisFrameCycle:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   S3Rock_MoveDebrisAndApplyGravity
                move.b  #2,anim_frame_timer(a0)
                move.b  mapping_frame(a0),d0
                addq.b  #1,d0
                cmpi.b  #7,d0
                blo.s   S3Rock_StoreOrdinaryDebrisAnimationFrame
                moveq   #3,d0

S3Rock_StoreOrdinaryDebrisAnimationFrame:
                move.b  d0,mapping_frame(a0)

S3Rock_MoveDebrisAndApplyGravity:
                jsr     (MoveSprite2).l
                addi.w  #$18,y_vel(a0)
                tst.b   render_flags(a0)
                bpl.w   S3Rock_DeleteOffscreenDebris
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3Rock_DeleteOffscreenDebris:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

S3Rock_CloneCompetitionRockThenShatter:
                bsr.s   CloneCompetitionRockForRespawn
                move.b  #3,mapping_frame(a0)
                move.l  #S3Rock_MoveStaticFrameCompDebris,(a0)
                bsr.w   ShatterRockWithDefaultVelocities

S3Rock_MoveStaticFrameCompDebris:
                jsr     (MoveSprite2).l
                addi.w  #$18,y_vel(a0)
                tst.b   render_flags(a0)
                bpl.w   S3Rock_DeleteOffscreenDebris
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

CloneCompetitionRockForRespawn:
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   S3Rock_ReturnFromCompetitionCloneAttempt
                moveq   #$48,d0

S3Rock_CopyEntireCompetitionRockSlot:
                move.w  (a0,d0.w),(a1,d0.w)
                subq.w  #2,d0
                bcc.s   S3Rock_CopyEntireCompetitionRockSlot
                move.l  (a0),$44(a1)
                move.l  #S3Rock_WaitForCompCloneOffscreen,(a1)
                move.b  #7,mapping_frame(a1)
                moveq   #0,d0

S3Rock_ReturnFromCompetitionCloneAttempt:
                rts
; End of function CloneCompetitionRockForRespawn

; ---------------------------------------------------------------------------

S3Rock_WaitForCompCloneOffscreen:
                tst.b   render_flags(a0)
                bmi.s   S3Rock_DrawCompetitionRespawnClone
                move.l  $44(a0),(a0)
                move.b  #0,mapping_frame(a0)

S3Rock_DrawCompetitionRespawnClone:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3Rock_UpdateSideBreakRockCollision:
                move.w  (Player_1+x_vel).w,$30(a0)
                move.w  (Player_2+x_vel).w,$36(a0)
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                addi.w  #$B,d1
                moveq   #0,d2
                move.b  height_pixels(a0),d2
                move.w  d2,d3
                addq.w  #1,d3
                move.w  x_pos(a0),d4
                bsr.w   SolidObjectFull
                swap    d6
                andi.w  #3,d6
                bne.s   S3Rock_CheckFirstPlayerSideRockContact

S3Rock_DrawSideBreakRockByMode:
                tst.w   (Competition_mode).w
                bne.s   S3Rock_DrawCompetitionSideBreakRock
                move.w  $2E(a0),d0
                jmp     (Sprite_OnScreen_Test2).l
; ---------------------------------------------------------------------------

S3Rock_DrawCompetitionSideBreakRock:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3Rock_CheckFirstPlayerSideRockContact:
                lea     (Player_1).w,a1
                move.w  $30(a0),d1
                move.w  d6,d0
                andi.w  #1,d0
                beq.w   S3Rock_CheckP2SideBreak
                tst.b   subtype(a0)
                bpl.s   S3Rock_CheckFirstUnrestrictedRockImpact
                cmpi.b  #2,character_id(a1)
                beq.s   S3Rock_BreakFromP1AndRestoreP2
                bra.s   S3Rock_CheckP2SideBreak
; ---------------------------------------------------------------------------

S3Rock_CheckFirstUnrestrictedRockImpact:
                tst.b   (Super_Sonic_Knux_flag).w
                bne.s   S3Rock_BreakFromP1AndRestoreP2
                btst    #Status_FireShield,status_secondary(a1)
                bne.s   S3Rock_RequireFirstRockBreakerRolling
                cmpi.b  #2,character_id(a1)
                beq.s   S3Rock_BreakFromP1AndRestoreP2
                btst    #p1_pushing_bit,status(a0)
                beq.s   S3Rock_CheckP2SideBreak

S3Rock_RequireFirstRockBreakerRolling:
                cmpi.b  #2,anim(a1)
                bne.s   S3Rock_CheckP2SideBreak
                move.w  d1,d0
                bpl.s   S3Rock_CheckP1BreakSpeed
                neg.w   d0

; Require an unsigned speed magnitude of at least $480
S3Rock_CheckP1BreakSpeed:
                cmpi.w  #$480,d0
                blo.s   S3Rock_CheckP2SideBreak

S3Rock_BreakFromP1AndRestoreP2:
                bclr    #p1_pushing_bit,status(a0)
                bsr.w   BreakRockFromSideImpact
                btst    #p2_pushing_bit,status(a0)
                beq.s   S3Rock_DrawSideBreakRockByMode
                lea     (Player_2).w,a1
                cmpi.b  #2,character_id(a1)
                beq.s   S3Rock_RestoreP2AfterBreak
                cmpi.b  #2,anim(a1)
                bne.w   S3Rock_DrawSideBreakRockByMode

S3Rock_RestoreP2AfterBreak:
                move.w  $36(a0),x_vel(a1)
                move.w  x_vel(a1),ground_vel(a1)
                bclr    #p2_pushing_bit,status(a0)
                bclr    #Status_Push,status(a1)
                bra.w   S3Rock_DrawSideBreakRockByMode
; ---------------------------------------------------------------------------

S3Rock_CheckP2SideBreak:
                lea     (Player_2).w,a1
                move.w  $36(a0),d1
                btst    #p2_pushing_bit,status(a0)
                beq.w   S3Rock_DrawSideBreakRockByMode
                tst.b   subtype(a0)
                bpl.s   S3Rock_CheckSecondUnrestrictedRockImpact
                cmpi.b  #2,character_id(a1)
                beq.s   S3Rock_ClearP2PushAndBreak
                bra.w   S3Rock_DrawSideBreakRockByMode
; ---------------------------------------------------------------------------

S3Rock_CheckSecondUnrestrictedRockImpact:
                cmpi.b  #2,character_id(a1)
                beq.s   S3Rock_ClearP2PushAndBreak
                cmpi.b  #2,anim(a1)
                bne.w   S3Rock_DrawSideBreakRockByMode
                move.w  d1,d0
                bpl.s   S3Rock_CheckP2BreakSpeed
                neg.w   d0

; Require an unsigned speed magnitude of at least $480
S3Rock_CheckP2BreakSpeed:
                cmpi.w  #$480,d0
                blo.w   S3Rock_DrawSideBreakRockByMode

S3Rock_ClearP2PushAndBreak:
                bclr    #p2_pushing_bit,status(a0)

; =============== S U B R O U T I N E =======================================

BreakRockFromSideImpact:
                bsr.w   DetachPlayersStandingOnRock
                tst.w   (Competition_mode).w
                bne.s   S3Rock_SelectCompFragmentVel
                move.w  d1,x_vel(a1)
                addq.w  #4,x_pos(a1)
                lea     (S3Rock_ShapeZeroAndPrimarySideVelocities).l,a4
                move.w  x_pos(a0),d0
                cmp.w   x_pos(a1),d0
                blo.s   S3Rock_FinishOrdinaryRockSideImpact
                subi.w  #8,x_pos(a1)
                lea     (S3Rock_AlternatePositiveSideVelocities).l,a4

S3Rock_FinishOrdinaryRockSideImpact:
                move.w  x_vel(a1),ground_vel(a1)
                bclr    #Status_Push,status(a1)
                move.l  #S3Rock_TickOrdinaryRockDebrisFrameCycle,(a0)
                moveq   #0,d0
                move.b  mapping_frame(a0),d0
                add.w   d0,d0
                bsr.w   SpawnRockFragments
                bra.w   S3Rock_TickOrdinaryRockDebrisFrameCycle
; ---------------------------------------------------------------------------

S3Rock_SelectCompFragmentVel:
                move.w  d1,x_vel(a1)
                addq.w  #4,x_pos(a1)
                lea     (S3Rock_CompFragmentLeftVel).l,a4
                move.w  x_pos(a0),d0
                cmp.w   x_pos(a1),d0
                blo.s   S3Rock_CloneAndSpawnCompFragments
                subi.w  #8,x_pos(a1)
                lea     (S3Rock_CompFragmentRightVel).l,a4

S3Rock_CloneAndSpawnCompFragments:
                move.w  x_vel(a1),ground_vel(a1)
                bclr    #Status_Push,status(a1)
                bsr.w   CloneCompetitionRockForRespawn
                move.l  #S3Rock_MoveStaticFrameCompDebris,(a0)
                move.b  #3,mapping_frame(a0)
                moveq   #0,d0
                move.b  mapping_frame(a0),d0
                add.w   d0,d0
                bsr.w   SpawnRockFragments
                bra.w   S3Rock_MoveStaticFrameCompDebris
; End of function BreakRockFromSideImpact

; =============== S U B R O U T I N E =======================================

DetachPlayersStandingOnRock:
                bclr    #p1_standing_bit,status(a0)
                beq.s   S3Rock_DetachSecondRockTopRider
                bset    #Status_InAir,(Player_1+status).w
                bclr    #Status_OnObj,(Player_1+status).w

S3Rock_DetachSecondRockTopRider:
                bclr    #p2_standing_bit,status(a0)
                beq.s   S3Rock_ReturnFromRockTopRiderDetach
                bset    #Status_InAir,(Player_2+status).w
                bclr    #Status_OnObj,(Player_2+status).w

S3Rock_ReturnFromRockTopRiderDetach:
                rts
; End of function DetachPlayersStandingOnRock

; =============== S U B R O U T I N E =======================================

UpdatePlayersPushingRockLeft:
                move.b  status(a0),d3
                andi.b  #pushing_mask,d3
                beq.w   S3Rock_ReturnFromRockLeftPushPass
                move.w  x_pos(a0),d2
                lea     (Player_1).w,a1
                move.b  $3A(a0),d0
                moveq   #p1_pushing_bit,d6
                bsr.s   StepPushableRockLeftForPlayer
                lea     (Player_2).w,a1
                move.b  $3B(a0),d0
                moveq   #p2_pushing_bit,d6
                bsr.s   StepPushableRockLeftForPlayer

S3Rock_ReturnFromRockLeftPushPass:
                rts
; End of function UpdatePlayersPushingRockLeft

; =============== S U B R O U T I N E =======================================

StepPushableRockLeftForPlayer:
                btst    d6,d3
                beq.s   S3Rock_ReturnFromSingleRockLeftPushStep
                cmp.w   x_pos(a1),d2
                bhs.s   S3Rock_ReturnFromSingleRockLeftPushStep
                btst    #5,d0
                beq.s   S3Rock_ReturnFromSingleRockLeftPushStep
                subq.w  #1,$40(a0)
                bpl.s   S3Rock_ReturnFromSingleRockLeftPushStep
                move.w  #$10,$40(a0)
                tst.w   $42(a0)
                beq.s   S3Rock_ReturnFromSingleRockLeftPushStep
                subq.w  #1,$42(a0)
                subq.w  #1,x_pos(a0)
                subq.w  #1,x_pos(a1)
                jsr     (ObjCheckFloorDist).l
                add.w   d1,y_pos(a0)
                move.w  respawn_addr(a0),d0
                beq.s   S3Rock_ReturnFromSingleRockLeftPushStep
                movea.w d0,a2
                move.b  $43(a0),d0
                subi.b  #$40,d0
                neg.b   d0
                move.b  d0,(a2)
                bset    #7,(a2)

S3Rock_ReturnFromSingleRockLeftPushStep:
                rts
; End of function StepPushableRockLeftForPlayer

; =============== S U B R O U T I N E =======================================

ShatterRockWithDefaultVelocities:
                moveq   #0,d0
                move.b  mapping_frame(a0),d0
                add.w   d0,d0
                lea     (S3Rock_DefaultFragmentVelocityOffsets).l,a4
                adda.w  (a4,d0.w),a4
; End of function ShatterRockWithDefaultVelocities

; =============== S U B R O U T I N E =======================================

SpawnRockFragments:
                lea     (S3Rock_FragmentLayoutOffsets).l,a3
                adda.w  (a3,d0.w),a3
                move.w  (a3)+,d1
                move.l  (a0),d4
                move.b  render_flags(a0),d5
                move.w  x_pos(a0),d2
                move.w  y_pos(a0),d3
                move.w  #3,d6
                movea.l a0,a1
                bra.s   S3Rock_InitializeOrdinaryRockFragment
; ---------------------------------------------------------------------------

S3Rock_AllocateNextOrdinaryRockFragment:
                bsr.w   AllocateObjectAfterCurrent
                bne.s   S3Rock_PlaySoundAfterOrdinaryRockShatter

S3Rock_InitializeOrdinaryRockFragment:
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
                blo.s   S3Rock_LoopOrdinaryRockFragmentCount
                move.w  #3,d6

S3Rock_LoopOrdinaryRockFragmentCount:
                dbf     d1,S3Rock_AllocateNextOrdinaryRockFragment

S3Rock_PlaySoundAfterOrdinaryRockShatter:
                moveq   #signextendB(sfx_Collapse),d0
                jmp     (Play_SFX).l
; End of function SpawnRockFragments

; ---------------------------------------------------------------------------
S3Rock_FragmentLayoutOffsets:
                dc.w    S3Rock_ShapeZeroFragmentOffsets-S3Rock_FragmentLayoutOffsets
                dc.w    S3Rock_ShapeOneFragmentOffsets-S3Rock_FragmentLayoutOffsets
                dc.w    S3Rock_ShapeTwoFragmentOffsets-S3Rock_FragmentLayoutOffsets
                dc.w    S3Rock_CompShape3FragmentOffsets-S3Rock_FragmentLayoutOffsets
S3Rock_ShapeZeroFragmentOffsets:
                dc.w    8-1
                dc.b    -8, -$18
                dc.b    $B, -$1C
                dc.b    -4,  -$C
                dc.b    $C,   -4
                dc.b    -$C,    4
                dc.b    4,   $C
                dc.b    -$C,  $1C
                dc.b    $C,  $1C
S3Rock_ShapeOneFragmentOffsets:
                dc.w    5-1
                dc.b    -4,  -$C
                dc.b    $B,  -$C
                dc.b    -4,   -4
                dc.b    -$C,   $C
                dc.b    $C,   $C
S3Rock_ShapeTwoFragmentOffsets:
                dc.w    4-1
                dc.b    -4,   -4
                dc.b    $C,   -4
                dc.b    -$C,    4
                dc.b    $C,    4
S3Rock_CompShape3FragmentOffsets:
                dc.w    6-1
                dc.b    -8,   -8
                dc.b    8,   -8
                dc.b    -8,    0
                dc.b    8,    0
                dc.b    -8,    8
                dc.b    8,    8
S3Rock_DefaultFragmentVelocityOffsets:
                dc.w    S3Rock_ShapeZeroAndPrimarySideVelocities-S3Rock_DefaultFragmentVelocityOffsets
                dc.w    S3Rock_ShapeOneDefaultVelocities-S3Rock_DefaultFragmentVelocityOffsets
                dc.w    S3Rock_ShapeTwoDefaultVelocities-S3Rock_DefaultFragmentVelocityOffsets
                dc.w    S3Rock_ShapeThreeDefaultVelocities-S3Rock_DefaultFragmentVelocityOffsets
S3Rock_ShapeZeroAndPrimarySideVelocities:
                dc.w    -$300, -$300
                dc.w    -$2C0, -$280
                dc.w    -$2C0, -$280
                dc.w    -$280, -$200
                dc.w    -$280, -$180
                dc.w    -$240, -$180
                dc.w    -$240, -$100
                dc.w    -$200, -$100
S3Rock_AlternatePositiveSideVelocities:
                dc.w    $300, -$300
                dc.w    $2C0, -$280
                dc.w    $2C0, -$280
                dc.w    $280, -$200
                dc.w    $280, -$180
                dc.w    $240, -$180
                dc.w    $240, -$100
                dc.w    $200, -$100
S3Rock_ShapeOneDefaultVelocities:
                dc.w    -$200, -$200
                dc.w    $200, -$200
                dc.w    -$100, -$1E0
                dc.w    -$1B0, -$1C0
                dc.w    $1C0, -$1C0
S3Rock_ShapeTwoDefaultVelocities:
                dc.w    -$100, -$200
                dc.w    $100, -$1E0
                dc.w    -$1B0, -$1C0
                dc.w    $1C0, -$1C0
S3Rock_ShapeThreeDefaultVelocities:
                dc.w    -$B0, -$1E0
                dc.w    $B0, -$1D0
                dc.w    -$80, -$200
                dc.w    $80, -$1E0
                dc.w    -$D8, -$1C0
                dc.w    $E0, -$1C0
S3Rock_CompFragmentLeftVel:
                dc.w    -$2C0, -$280
                dc.w    -$280, -$200
                dc.w    -$280, -$180
                dc.w    -$240, -$180
                dc.w    -$240, -$100
                dc.w    -$200, -$100
S3Rock_CompFragmentRightVel:
                dc.w    $2C0, -$280
                dc.w    $280, -$200
                dc.w    $280, -$180
                dc.w    $240, -$180
                dc.w    $240, -$100
                dc.w    $200, -$100
Map_AIZRock:
                include "src/objects/shared/zones/aiz/mappings/rock.s"
Map_AIZRock2:
                include "src/objects/shared/zones/aiz/mappings/rock_2.s"
Map_EMZRock:
                include "src/objects/shared/zones/emz/mappings/rock.s"
