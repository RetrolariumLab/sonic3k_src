; Owner: objects/shared/sk
; Responsibility: Shared rock initialization, active state and character contact or release logic
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------
SKRock_RockShapeSizePairs:
                dc.b    $18, $27
                dc.b    $18, $17
                dc.b    $18,  $F
                dc.b    $E,  $F
                dc.b    $10, $28
                dc.b    $28, $10
                dc.b    $28, $10
                dc.b    $10, $20
; ---------------------------------------------------------------------------

Obj_AIZLRZEMZRock:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  d0,d2
                lsr.w   #4,d0
                andi.b  #7,d0
                move.b  d0,mapping_frame(a0)
                add.w   d0,d0
                move.b  SKRock_RockShapeSizePairs(pc,d0.w),width_pixels(a0)
                move.b  SKRock_RockShapeSizePairs+1(pc,d0.w),d1
                move.b  d1,height_pixels(a0)
                move.b  d1,y_radius(a0)
                move.l  #Map_AIZRock,mappings(a0)
                move.w  #make_art_tile(ArtTile_AIZMisc1,1,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.w  #$200,priority(a0)
                move.w  x_pos(a0),$2E(a0)
                move.w  #$40,child_dx(a0)
                cmpi.w  #1,(Current_zone_and_act).w
                bne.s   SKRock_SelectEndlessMineMapOverride
                move.l  #Map_AIZRock2,mappings(a0)
                move.w  #make_art_tile(ArtTile_AIZMisc2,2,0),art_tile(a0)

SKRock_SelectEndlessMineMapOverride:
                cmpi.w  #$1200,(Current_zone_and_act).w
                bne.s   SKRock_SelectLRZWholeRockMap
                move.l  #Map_EMZRock,mappings(a0)
                move.w  #make_art_tile(ArtTile_EMZMisc,3,1),art_tile(a0)
                move.b  #0,mapping_frame(a0)

SKRock_SelectLRZWholeRockMap:
                cmpi.b  #9,(Current_zone).w
                bne.s   SKRock_SelectKnucklesTopBreakNibbleF
                move.l  #Map_LRZBreakableRock,mappings(a0)
                move.w  #make_art_tile($0D3,2,0),art_tile(a0)
                addq.b  #4,mapping_frame(a0)
                tst.b   (Current_act).w
                beq.s   SKRock_SelectKnucklesTopBreakNibbleF
                move.l  #Map_LRZBreakableRock2,mappings(a0)
                move.w  #make_art_tile(ArtTile_LRZ2Misc,3,0),art_tile(a0)

SKRock_SelectKnucklesTopBreakNibbleF:
                andi.w  #$F,d2
                cmpi.w  #$F,d2
                bne.s   SKRock_SelectOrdinaryOrSideBreakMode
                move.l  #SKRock_UpdateP1KnucklesStandingBreakRock,(a0)
                bra.w   SKRock_UpdateP1KnucklesStandingBreakRock
; ---------------------------------------------------------------------------

SKRock_SelectOrdinaryOrSideBreakMode:
                move.l  #SKRock_CachePlayersAndCollideRock,(a0)
                btst    #2,subtype(a0)
                beq.s   SKRock_CheckVerticalBreak
                move.l  #SKRock_UpdateSideBreakRockCollision,(a0)
                bra.w   SKRock_UpdateSideBreakRockCollision
; ---------------------------------------------------------------------------

; Subtype bit 3 selects the vertical-impact handler
SKRock_CheckVerticalBreak:
                btst    #3,subtype(a0)
                beq.s   SKRock_RestoreSavedLeftPushDisplacement
                move.l  #SKRock_UpdateVerticalResponseBreakRock,(a0)
                bra.w   SKRock_UpdateVerticalResponseBreakRock
; ---------------------------------------------------------------------------

SKRock_RestoreSavedLeftPushDisplacement:
                move.w  respawn_addr(a0),d0
                beq.s   SKRock_CachePlayersAndCollideRock
                movea.w d0,a2
                move.b  (a2),d0
                andi.w  #$7F,d0
                beq.s   SKRock_CachePlayersAndCollideRock
                sub.w   d0,x_pos(a0)
                neg.w   d0
                addi.w  #$40,d0
                move.w  d0,child_dx(a0)
                jsr     (ObjCheckFloorDist).l
                add.w   d1,y_pos(a0)

SKRock_CachePlayersAndCollideRock:
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
                beq.s   SKRock_GateTopBreakBySubtypeAndStanding
                bsr.w   UpdatePlayersPushingRockLeft

SKRock_GateTopBreakBySubtypeAndStanding:
                btst    #0,subtype(a0)
                beq.s   SKRock_DrawByAnchorOutsideComp
                move.b  status(a0),d0
                andi.b  #standing_mask,d0
                bne.s   SKRock_CheckRollWithBothRiders

SKRock_DrawByAnchorOutsideComp:
                tst.w   (Competition_mode).w
                bne.s   SKRock_DrawCompetitionRockDirectly
                move.w  $2E(a0),d0
                jmp     (Sprite_OnScreen_Test2).l
; ---------------------------------------------------------------------------

SKRock_DrawCompetitionRockDirectly:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

; When both standing bits are set, require the cached rolling animation from at least one rider
SKRock_CheckRollWithBothRiders:
                cmpi.b  #$18,d0
                bne.s   SKRock_CheckSingleFirstPlayerTopBreak
                cmpi.b  #2,$32(a0)
                beq.s   SKRock_ReleaseBothTopRiders
                cmpi.b  #2,$33(a0)
                bne.s   SKRock_DrawByAnchorOutsideComp

SKRock_ReleaseBothTopRiders:
                lea     (Player_1).w,a1
                move.b  $32(a0),d0
                bsr.s   ReleaseRockRiderWithConditionalBounce
                lea     (Player_2).w,a1
                move.b  $33(a0),d0
                bsr.s   ReleaseRockRiderWithConditionalBounce
                bra.w   SKRock_RestoreChainAndShatterTop
; ---------------------------------------------------------------------------

SKRock_CheckSingleFirstPlayerTopBreak:
                move.b  d0,d1
                andi.b  #8,d1
                beq.s   SKRock_CheckSingleSecondPlayerTopBreak
                cmpi.b  #2,$32(a0)
                bne.s   SKRock_DrawByAnchorOutsideComp
                lea     (Player_1).w,a1
                bsr.s   BouncePlayerAfterRockTopBreak
                bra.s   SKRock_RestoreChainAndShatterTop

; =============== S U B R O U T I N E =======================================

ReleaseRockRiderWithConditionalBounce:
                cmpi.b  #2,d0
                bne.s   SKRock_FinishRockRiderAirborneRelease
; End of function ReleaseRockRiderWithConditionalBounce

; =============== S U B R O U T I N E =======================================

BouncePlayerAfterRockTopBreak:
                bset    #Status_Roll,status(a1)
                move.b  #$E,y_radius(a1)
                move.b  #7,x_radius(a1)
                move.b  #2,anim(a1)
                move.w  #-$300,y_vel(a1)

SKRock_FinishRockRiderAirborneRelease:
                bset    #Status_InAir,status(a1)
                bclr    #Status_OnObj,status(a1)
                move.b  #2,routine(a1)
                rts
; End of function BouncePlayerAfterRockTopBreak

; ---------------------------------------------------------------------------

SKRock_CheckSingleSecondPlayerTopBreak:
                andi.b  #$10,d0
                beq.w   SKRock_DrawByAnchorOutsideComp
                cmpi.b  #2,$33(a0)
                bne.w   SKRock_DrawByAnchorOutsideComp
                lea     (Player_2).w,a1
                bsr.s   BouncePlayerAfterRockTopBreak

SKRock_RestoreChainAndShatterTop:
                move.w  $38(a0),(Chain_bonus_counter).w
                andi.b  #$E7,status(a0)
                tst.w   (Competition_mode).w
                bne.w   SKRock_CloneCompetitionRockThenShatter
                move.l  #SKRock_DispatchRockDebrisAnimationByZone,(a0)
                bsr.w   ShatterRockWithDefaultVelocities

SKRock_DispatchRockDebrisAnimationByZone:
                cmpi.b  #9,(Current_zone).w
                beq.s   SKRock_InstallLRZDebrisGroupAnimation
                move.l  #SKRock_TickOrdinaryRockDebrisFrameCycle,(a0)

SKRock_TickOrdinaryRockDebrisFrameCycle:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   SKRock_MoveDebrisAndApplyGravity
                move.b  #2,anim_frame_timer(a0)
                move.b  mapping_frame(a0),d0
                addq.b  #1,d0
                cmpi.b  #7,d0
                blo.s   SKRock_StoreOrdinaryDebrisAnimationFrame
                moveq   #3,d0

SKRock_StoreOrdinaryDebrisAnimationFrame:
                move.b  d0,mapping_frame(a0)

SKRock_MoveDebrisAndApplyGravity:
                jsr     (MoveSprite2).l
                addi.w  #$18,y_vel(a0)
                tst.b   render_flags(a0)
                bpl.s   SKRock_DeleteOffscreenDebris
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKRock_DeleteOffscreenDebris:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

SKRock_InstallLRZDebrisGroupAnimation:
                move.l  #SKRock_TickLRZDebrisFourFrameGroup,(a0)

SKRock_TickLRZDebrisFourFrameGroup:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   SKRock_MoveLRZDebrisAndAddGravity
                move.b  #7,anim_frame_timer(a0)
                move.b  mapping_frame(a0),d0
                addq.b  #1,d0
                andi.b  #3,d0
                add.b   $3C(a0),d0
                move.b  d0,mapping_frame(a0)

SKRock_MoveLRZDebrisAndAddGravity:
                jsr     (MoveSprite2).l
                addi.w  #$18,y_vel(a0)
                tst.b   render_flags(a0)
                bpl.s   SKRock_DeleteOffscreenDebris
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKRock_CloneCompetitionRockThenShatter:
                bsr.s   CloneCompetitionRockForRespawn
                move.b  #3,mapping_frame(a0)
                move.l  #SKRock_MoveStaticFrameCompDebris,(a0)
                bsr.w   ShatterRockWithDefaultVelocities

SKRock_MoveStaticFrameCompDebris:
                jsr     (MoveSprite2).l
                addi.w  #$18,y_vel(a0)
                tst.b   render_flags(a0)
                bpl.w   SKRock_DeleteOffscreenDebris
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

CloneCompetitionRockForRespawn:
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   SKRock_ReturnFromCompetitionCloneAttempt
                moveq   #$48,d0

SKRock_CopyEntireCompetitionRockSlot:
                move.w  (a0,d0.w),(a1,d0.w)
                subq.w  #2,d0
                bcc.s   SKRock_CopyEntireCompetitionRockSlot
                move.l  (a0),$44(a1)
                move.l  #SKRock_WaitForCompCloneOffscreen,(a1)
                move.b  #7,mapping_frame(a1)
                moveq   #0,d0

SKRock_ReturnFromCompetitionCloneAttempt:
                rts
; End of function CloneCompetitionRockForRespawn

; ---------------------------------------------------------------------------

SKRock_WaitForCompCloneOffscreen:
                tst.b   render_flags(a0)
                bmi.s   SKRock_DrawCompetitionRespawnClone
                move.l  $44(a0),(a0)
                move.b  #0,mapping_frame(a0)

SKRock_DrawCompetitionRespawnClone:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKRock_UpdateSideBreakRockCollision:
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
                bne.s   SKRock_CheckFirstPlayerSideRockContact

SKRock_DrawSideBreakRockByMode:
                tst.w   (Competition_mode).w
                bne.s   SKRock_DrawCompetitionSideBreakRock
                move.w  $2E(a0),d0
                jmp     (Sprite_OnScreen_Test2).l
; ---------------------------------------------------------------------------

SKRock_DrawCompetitionSideBreakRock:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKRock_CheckFirstPlayerSideRockContact:
                lea     (Player_1).w,a1
                move.w  $30(a0),d1
                move.w  d6,d0
                andi.w  #1,d0
                beq.w   SKRock_CheckP2SideBreak
                tst.b   subtype(a0)
                bpl.s   SKRock_CheckFirstUnrestrictedRockImpact
                cmpi.b  #2,character_id(a1)
                beq.s   SKRock_BreakFromP1AndRestoreP2
                bra.w   SKRock_CheckP2SideBreak
; ---------------------------------------------------------------------------

SKRock_CheckFirstUnrestrictedRockImpact:
                tst.b   (Super_Sonic_Knux_flag).w
                bne.s   SKRock_BreakFromP1AndRestoreP2
                cmpi.b  #2,character_id(a1)
                beq.s   SKRock_BreakFromP1AndRestoreP2
                btst    #Status_FireShield,status_secondary(a1)
                bne.s   SKRock_RequireFirstRockBreakerRolling
                btst    #p1_pushing_bit,status(a0)
                beq.s   SKRock_CheckP2SideBreak

SKRock_RequireFirstRockBreakerRolling:
                cmpi.b  #2,anim(a1)
                bne.s   SKRock_CheckP2SideBreak
                move.w  d1,d0
                bpl.s   SKRock_CheckP1BreakSpeed
                neg.w   d0

; Require an unsigned speed magnitude of at least $480
SKRock_CheckP1BreakSpeed:
                cmpi.w  #$480,d0
                blo.s   SKRock_CheckP2SideBreak

SKRock_BreakFromP1AndRestoreP2:
                bclr    #p1_pushing_bit,status(a0)
                bsr.w   BreakRockFromSideImpact
                btst    #p2_pushing_bit,status(a0)
                beq.w   SKRock_DrawSideBreakRockByMode
                lea     (Player_2).w,a1
                cmpi.b  #2,character_id(a1)
                beq.s   SKRock_RestoreP2AfterBreak
                cmpi.b  #2,anim(a1)
                bne.w   SKRock_DrawSideBreakRockByMode

SKRock_RestoreP2AfterBreak:
                move.w  $36(a0),x_vel(a1)
                move.w  x_vel(a1),ground_vel(a1)
                bclr    #p2_pushing_bit,status(a0)
                bclr    #Status_Push,status(a1)
                bra.w   SKRock_DrawSideBreakRockByMode
; ---------------------------------------------------------------------------

SKRock_CheckP2SideBreak:
                lea     (Player_2).w,a1
                move.w  $36(a0),d1
                btst    #p2_pushing_bit,status(a0)
                beq.w   SKRock_DrawSideBreakRockByMode
                tst.b   subtype(a0)
                bpl.s   SKRock_CheckSecondUnrestrictedRockImpact
                cmpi.b  #2,character_id(a1)
                beq.s   SKRock_ClearP2PushAndBreak
                bra.w   SKRock_DrawSideBreakRockByMode
; ---------------------------------------------------------------------------

SKRock_CheckSecondUnrestrictedRockImpact:
                cmpi.b  #2,character_id(a1)
                beq.s   SKRock_ClearP2PushAndBreak
                cmpi.b  #2,anim(a1)
                bne.w   SKRock_DrawSideBreakRockByMode
                move.w  d1,d0
                bpl.s   SKRock_CheckP2BreakSpeed
                neg.w   d0

; Require an unsigned speed magnitude of at least $480
SKRock_CheckP2BreakSpeed:
                cmpi.w  #$480,d0
                blo.w   SKRock_DrawSideBreakRockByMode

SKRock_ClearP2PushAndBreak:
                bclr    #p2_pushing_bit,status(a0)

; =============== S U B R O U T I N E =======================================

BreakRockFromSideImpact:
                bsr.w   DetachPlayersStandingOnRock
                tst.w   (Competition_mode).w
                bne.w   SKRock_SelectCompFragmentVel
                move.w  d1,x_vel(a1)
                addq.w  #4,x_pos(a1)
                lea     (SKRock_ShapeZeroAndPrimarySideVelocities).l,a4
                move.w  x_pos(a0),d0
                cmp.w   x_pos(a1),d0
                blo.s   SKRock_FinishOrdinaryRockSideImpact
                subi.w  #8,x_pos(a1)
                lea     (SKRock_AlternatePositiveSideVelocities).l,a4

SKRock_FinishOrdinaryRockSideImpact:
                move.w  x_vel(a1),ground_vel(a1)
                bclr    #Status_Push,status(a1)
                cmpi.b  #2,character_id(a1)
                bne.s   SKRock_SelectSideImpactLRZEmitter
                cmpi.b  #1,double_jump_flag(a1)
                bne.s   SKRock_SelectSideImpactLRZEmitter
                move.b  #2,double_jump_flag(a1)
                move.b  #$21,anim(a1)
                bclr    #Status_Facing,status(a1)
                tst.w   x_vel(a1)
                bpl.s   SKRock_SelectSideImpactLRZEmitter
                bset    #Status_Facing,status(a1)

SKRock_SelectSideImpactLRZEmitter:
                moveq   #0,d0
                move.b  mapping_frame(a0),d0
                cmpi.b  #9,(Current_zone).w
                bne.s   SKRock_SpawnDefaultSideFragments
                subq.b  #4,d0
                move.l  #SKRock_TickLRZDebrisFourFrameGroup,(a0)
                add.w   d0,d0
                bsr.w   SpawnLavaReefRockFragments
                bra.w   SKRock_TickLRZDebrisFourFrameGroup
; ---------------------------------------------------------------------------

SKRock_SpawnDefaultSideFragments:
                move.l  #SKRock_DispatchRockDebrisAnimationByZone,(a0)
                add.w   d0,d0
                bsr.w   SpawnRockFragments
                bra.w   SKRock_DispatchRockDebrisAnimationByZone
; ---------------------------------------------------------------------------

SKRock_SelectCompFragmentVel:
                move.w  d1,x_vel(a1)
                addq.w  #4,x_pos(a1)
                lea     (SKRock_CompFragmentLeftVel).l,a4
                move.w  x_pos(a0),d0
                cmp.w   x_pos(a1),d0
                blo.s   SKRock_CloneAndSpawnCompFragments
                subi.w  #8,x_pos(a1)
                lea     (SKRock_CompFragmentRightVel).l,a4

SKRock_CloneAndSpawnCompFragments:
                move.w  x_vel(a1),ground_vel(a1)
                bclr    #Status_Push,status(a1)
                bsr.w   CloneCompetitionRockForRespawn
                move.l  #SKRock_MoveStaticFrameCompDebris,(a0)
                move.b  #3,mapping_frame(a0)
                moveq   #0,d0
                move.b  mapping_frame(a0),d0
                add.w   d0,d0
                bsr.w   SpawnRockFragments
                bra.w   SKRock_MoveStaticFrameCompDebris
; End of function BreakRockFromSideImpact

; =============== S U B R O U T I N E =======================================

DetachPlayersStandingOnRock:
                bclr    #p1_standing_bit,status(a0)
                beq.s   SKRock_DetachSecondRockTopRider
                bset    #Status_InAir,(Player_1+status).w
                bclr    #Status_OnObj,(Player_1+status).w

SKRock_DetachSecondRockTopRider:
                bclr    #p2_standing_bit,status(a0)
                beq.s   SKRock_ReturnFromRockTopRiderDetach
                bset    #Status_InAir,(Player_2+status).w
                bclr    #Status_OnObj,(Player_2+status).w

SKRock_ReturnFromRockTopRiderDetach:
                rts
; End of function DetachPlayersStandingOnRock
