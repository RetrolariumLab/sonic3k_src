; Owner: objects/competition/s3
; Responsibility: Competition item selection, collection, effects, object motion and mapping resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_2PItem:
                move.l  #Map_2PItem,mappings(a0)
                move.w  #make_art_tile(ArtTile_2PArt_3,0,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.w  #$280,priority(a0)
                move.b  #8,width_pixels(a0)
                move.b  #8,height_pixels(a0)
                move.b  #4,x_radius(a0)
                move.b  #8,y_radius(a0)
                move.w  x_pos(a0),$30(a0)
                move.w  y_pos(a0),$32(a0)
                move.b  subtype(a0),angle(a0)
                moveq   #1,d0
                bclr    #0,status(a0)
                beq.s   S3CompItem_SetOrbitStepAndSpentState
                neg.b   d0

S3CompItem_SetOrbitStepAndSpentState:
                move.b  d0,$27(a0)
                move.b  #3,anim(a0)
                move.b  #7,anim(a0)
                move.b  #$C7,collision_flags(a0)
                move.l  #S3CompItem_OrbitPickupUpdate,(a0)

S3CompItem_OrbitPickupUpdate:
                bsr.s   S3CompItem_ConsumePickupContacts
                move.b  angle(a0),d0
                jsr     (GetSineCosine).l
                asl.w   #3,d1
                move.w  d1,d2
                add.w   d1,d1
                add.w   d1,d2
                add.w   d1,d1
                add.w   d2,d1
                asr.w   #8,d1
                add.w   $30(a0),d1
                and.w   (Screen_X_wrap_value).w,d1
                addi.w  #$400,d1
                move.w  d1,x_pos(a0)
                asl.w   #3,d0
                move.w  d0,d2
                add.w   d0,d0
                add.w   d0,d2
                add.w   d0,d0
                add.w   d2,d0
                asr.w   #8,d0
                add.w   $32(a0),d0
                cmpi.w  #-$100,(Camera_min_Y_pos).w
                bne.s   S3CompItem_CommitOrbitYAndDraw
                and.w   (Screen_Y_wrap_value).w,d0

S3CompItem_CommitOrbitYAndDraw:
                move.w  d0,y_pos(a0)
                move.b  $27(a0),d0
                add.b   d0,angle(a0)
                lea     (Ani_2PItem).l,a1
                jsr     (Animate_Sprite).l
                jsr     (Add_SpriteToCollisionResponseList).l
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

; Dispatch queued contact for Player 1 before Player 2
S3CompItem_ConsumePickupContacts:
                tst.b   collision_property(a0)
                beq.s   S3CompItem_PickupContactReturn
                lea     (Player_1).w,a2
                bclr    #0,collision_property(a0)
                beq.s   S3CompItem_CollectWithP2
                bsr.s   S3CompItem_ApplyEffectFromAnim

S3CompItem_CollectWithP2:
                lea     (Player_2).w,a2
                bclr    #1,collision_property(a0)
                beq.s   S3CompItem_ClearPickupContacts
                bsr.s   S3CompItem_ApplyEffectFromAnim

S3CompItem_ClearPickupContacts:
                clr.b   collision_property(a0)

S3CompItem_PickupContactReturn:
                rts
; End of function S3CompItem_ConsumePickupContacts

; =============== S U B R O U T I N E =======================================

; Animation selects one of seven effects. Index 7 is neutral
S3CompItem_ApplyEffectFromAnim:
                moveq   #0,d0
                move.b  anim(a0),d0
                add.w   d0,d0
                move.w  S3CompItem_CollectedEffectIndex(pc,d0.w),d0
                jsr     S3CompItem_CollectedEffectIndex(pc,d0.w)
                rts
; End of function S3CompItem_ApplyEffectFromAnim

; ---------------------------------------------------------------------------
S3CompItem_CollectedEffectIndex:
                dc.w    S3CompItem_ApplyTimedSpeedUp-S3CompItem_CollectedEffectIndex
                dc.w    S3CompItem_ApplyTimedSlowdown-S3CompItem_CollectedEffectIndex
                dc.w    S3CompItem_SwapStatusTimersAndSpeed-S3CompItem_CollectedEffectIndex
                dc.w    S3CompItem_SpendPickupAndAwardRing-S3CompItem_CollectedEffectIndex
                dc.w    S3CompItem_SpendRollingPickupAndGetSlot-S3CompItem_CollectedEffectIndex
                dc.w    S3CompItem_SpendMomentumAndTryFallClone-S3CompItem_CollectedEffectIndex
                dc.w    S3CompItem_SpendFlipAndTryFallClone-S3CompItem_CollectedEffectIndex
                dc.w    S3CompItem_SpentPickupReturn-S3CompItem_CollectedEffectIndex
; ---------------------------------------------------------------------------

S3CompItem_ApplyTimedSpeedUp:
                bset    #Status_SpeedShoes,status_secondary(a2)
                move.b  #(10*60)/8,speed_shoes_timer(a2)
                cmpa.w  #Player_1,a2
                bne.s   S3CompItem_StoreP2SpeedUp
                move.w  #$C00,(Max_speed).w
                move.w  #$18,(Acceleration).w
                move.w  #$80,(Deceleration).w
                bra.s   S3CompItem_SpendSpeedUpAndTryEffect
; ---------------------------------------------------------------------------

S3CompItem_StoreP2SpeedUp:
                move.w  #$C00,(Max_speed_P2).w
                move.w  #$18,(Acceleration_P2).w
                move.w  #$80,(Deceleration_P2).w

S3CompItem_SpendSpeedUpAndTryEffect:
                move.b  #7,anim(a0)
                move.b  #0,collision_flags(a0)
                move.l  #S3CompItem_AnimateEffectOrDelete,d1
                moveq   #9,d2
                bsr.w   S3CompItem_TryCloneEffect
                rts
; ---------------------------------------------------------------------------

S3CompItem_ApplyTimedSlowdown:
                bset    #Status_SpeedShoes,status_secondary(a2)
                move.b  #(10*60)/8,speed_shoes_timer(a2)
                cmpa.w  #Player_1,a2
                bne.s   S3CompItem_StoreP2Slowdown
                move.w  #$300,(Max_speed).w
                move.w  #8,(Acceleration).w
                move.w  #$20,(Deceleration).w
                bra.s   S3CompItem_SpendSlowdownAndTryEffect
; ---------------------------------------------------------------------------

S3CompItem_StoreP2Slowdown:
                move.w  #$300,(Max_speed_P2).w
                move.w  #8,(Acceleration_P2).w
                move.w  #$20,(Deceleration_P2).w

S3CompItem_SpendSlowdownAndTryEffect:
                move.b  #7,anim(a0)
                move.b  #0,collision_flags(a0)
                move.l  #S3CompItem_AnimateEffectOrDelete,d1
                moveq   #9,d2
                bsr.w   S3CompItem_TryCloneEffect
                rts
; ---------------------------------------------------------------------------

S3CompItem_SwapStatusTimersAndSpeed:
                lea     (Player_1).w,a2
                lea     (Player_2).w,a3
                move.b  status_secondary(a2),d0
                move.b  status_secondary(a3),status_secondary(a2)
                move.b  d0,status_secondary(a3)
                move.b  speed_shoes_timer(a2),d0
                move.b  speed_shoes_timer(a3),speed_shoes_timer(a2)
                move.b  d0,speed_shoes_timer(a3)
                move.w  (Max_speed).w,d0
                move.w  (Acceleration).w,d1
                move.w  (Deceleration).w,d2
                move.w  (Max_speed_P2).w,d3
                move.w  (Acceleration_P2).w,d4
                move.w  (Deceleration_P2).w,d5
                move.w  d0,-(sp)
                lea     (Character_Speeds).l,a1
                moveq   #0,d0
                move.b  character_id(a2),d0
                lsl.w   #3,d0
                lea     (a1,d0.w),a1
                move.w  (a1)+,(Max_speed).w
                move.w  (a1)+,(Acceleration).w
                move.w  (a1)+,(Deceleration).w
                lea     (Character_Speeds).l,a1
                moveq   #0,d0
                move.b  character_id(a3),d0
                lsl.w   #3,d0
                lea     (a1,d0.w),a1
                move.w  (a1)+,(Max_speed_P2).w
                move.w  (a1)+,(Acceleration_P2).w
                move.w  (a1)+,(Deceleration_P2).w
                move.w  (sp)+,d0
                btst    #Status_SpeedShoes,status_secondary(a2)
                beq.s   S3CompItem_RestoreOldP1SpeedToP2
                move.w  d3,(Max_speed).w
                move.w  d4,(Acceleration).w
                move.w  d5,(Deceleration).w

S3CompItem_RestoreOldP1SpeedToP2:
                btst    #Status_SpeedShoes,status_secondary(a3)
                beq.s   S3CompItem_SpendSwapAndTryEffect
                move.w  d0,(Max_speed_P2).w
                move.w  d1,(Acceleration_P2).w
                move.w  d2,(Deceleration_P2).w

S3CompItem_SpendSwapAndTryEffect:
                move.b  #7,anim(a0)
                move.b  #0,collision_flags(a0)
                move.l  #S3CompItem_AnimateEffectOrDelete,d1
                moveq   #9,d2
                bsr.w   S3CompItem_TryCloneEffect
                rts
; ---------------------------------------------------------------------------

S3CompItem_SpendPickupAndAwardRing:
                move.b  #7,anim(a0)
                move.b  #0,collision_flags(a0)
                move.l  #S3CompItem_AnimateEffectOrDelete,d1
                moveq   #8,d2
                bsr.w   S3CompItem_TryCloneEffect
                cmpa.w  #Player_1,a2
                bne.s   S3CompItem_AwardRingToP2
                jmp     (GiveRing).l
; ---------------------------------------------------------------------------

S3CompItem_AwardRingToP2:
                jmp     (GiveRing_Tails).l
; ---------------------------------------------------------------------------

S3CompItem_SpendRollingPickupAndGetSlot:
                move.b  #7,anim(a0)
                clr.b   collision_flags(a0)
                clr.b   collision_property(a0)
                lea     (Breathing_bubbles).w,a1
                tst.l   (a1)
                moveq   #subtype,d0

S3CompItem_SeedRollingHazardOnPlane:
                move.w  (a0,d0.w),(a1,d0.w)
                subq.w  #2,d0
                bcc.s   S3CompItem_SeedRollingHazardOnPlane
                move.l  #S3CompItem_InitLeftRollingHazardFall,(a1)
                move.b  #4,anim(a1)
                move.w  top_solid_bit(a2),top_solid_bit(a1)
                tst.w   art_tile(a2)
                bpl.s   S3CompItem_RollingHazardSpawnReturn
                ori.w   #high_priority,art_tile(a1)

S3CompItem_RollingHazardSpawnReturn:
                rts
; ---------------------------------------------------------------------------

S3CompItem_SpendMomentumAndTryFallClone:
                move.b  #7,anim(a0)
                clr.b   collision_flags(a0)
                clr.b   collision_property(a0)
                move.l  #S3CompItem_BeginMomentumTrapFall,d1
                moveq   #5,d2
                bsr.w   S3CompItem_TryCloneEffect
                bne.s   S3CompItem_MomentumCloneReturn
                move.w  top_solid_bit(a2),top_solid_bit(a1)

S3CompItem_MomentumCloneReturn:
                rts
; ---------------------------------------------------------------------------

S3CompItem_SpendFlipAndTryFallClone:
                move.b  #7,anim(a0)
                clr.b   collision_flags(a0)
                clr.b   collision_property(a0)
                move.l  #S3CompItem_BeginFlipTrapFall,d1
                moveq   #6,d2
                bsr.w   S3CompItem_TryCloneEffect
                bne.s   S3CompItem_FlipCloneReturn
                move.w  top_solid_bit(a2),top_solid_bit(a1)

S3CompItem_FlipCloneReturn:
                rts
; ---------------------------------------------------------------------------

S3CompItem_SpentPickupReturn:
                rts
; ---------------------------------------------------------------------------

S3CompItem_InitLeftRollingHazardFall:
                move.w  #-$400,ground_vel(a0)
                move.b  #0,angle(a0)
                move.b  #0,status(a0)
                move.l  #S3CompItem_CheckRollingHazardContacts,d2
                bra.s   S3CompItem_MoveFallAndCheckLanding
; ---------------------------------------------------------------------------

S3CompItem_BeginMomentumTrapFall:
                move.l  #S3CompItem_CheckMomentumTrapContacts,d2
                bra.s   S3CompItem_MoveFallAndCheckLanding
; ---------------------------------------------------------------------------

S3CompItem_BeginFlipTrapFall:
                move.l  #S3CompItem_CheckFlipTrapContacts,d2

; Install the landing handler only after the floor probe returns a negative gap
S3CompItem_MoveFallAndCheckLanding:
                move.l  d2,-(sp)
                jsr     (MoveSprite).l
                jsr     (ObjCheckFloorDist).l
                move.l  (sp)+,d2
                tst.w   d1
                bpl.s   S3CompItem_WrapFallingHazardY
                add.w   d1,y_pos(a0)
                move.l  d2,(a0)
                move.b  #$C7,collision_flags(a0)

S3CompItem_WrapFallingHazardY:
                cmpi.w  #-$100,(Camera_min_Y_pos).w
                bne.s   S3CompItem_CullFallingHazardBelowCamera
                move.w  (Screen_Y_wrap_value).w,d0
                and.w   d0,y_pos(a0)

S3CompItem_CullFallingHazardBelowCamera:
                move.w  (Camera_max_Y_pos).w,d0
                addi.w  #$60,d0
                cmp.w   y_pos(a0),d0
                bge.s   S3CompItem_AnimateFallingHazard
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

S3CompItem_AnimateFallingHazard:
                bra.w   S3CompItem_AnimateEffectOrDelete
; ---------------------------------------------------------------------------

S3CompItem_CheckFlipTrapContacts:
                tst.b   collision_property(a0)
                beq.s   S3CompItem_AnimateFlipTrapOrDelete
                lea     (Player_1).w,a2
                bclr    #0,collision_property(a0)
                beq.s   S3CompItem_CheckP2FlipTrapContact
                bsr.s   S3CompItem_TryUpwardFlipLaunch

S3CompItem_CheckP2FlipTrapContact:
                lea     (Player_2).w,a2
                bclr    #1,collision_property(a0)
                beq.s   S3CompItem_ClearFlipTrapContacts
                bsr.s   S3CompItem_TryUpwardFlipLaunch

S3CompItem_ClearFlipTrapContacts:
                clr.b   collision_property(a0)

S3CompItem_AnimateFlipTrapOrDelete:
                lea     (Ani_2PItem).l,a1
                jsr     (Animate_Sprite).l
                tst.b   routine(a0)
                beq.s   S3CompItem_QueueFlipTrapUnlessSpent
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

S3CompItem_QueueFlipTrapUnlessSpent:
                cmpi.b  #9,anim(a0)
                beq.s   CompetitionItemS3DrawSurvivingFlipTrap
                jsr     (Add_SpriteToCollisionResponseList).l

CompetitionItemS3DrawSurvivingFlipTrap:
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

; Compare the collision-plane word and use the player's facing for the flip
S3CompItem_TryUpwardFlipLaunch:
                move.w  top_solid_bit(a2),d0
                cmp.w   top_solid_bit(a0),d0
                beq.s   S3CompItem_FlipLaunchOnMatchingPlane
                rts
; ---------------------------------------------------------------------------

S3CompItem_FlipLaunchOnMatchingPlane:
                move.b  #$A,anim(a0)
                move.w  #-$A00,y_vel(a2)
                bset    #Status_InAir,status(a2)
                bclr    #Status_RollJump,status(a2)
                bclr    #Status_Push,status(a2)
                clr.b   jumping(a2)
                move.w  #1,ground_vel(a2)
                move.b  #1,flip_angle(a2)
                move.b  #0,anim(a2)
                move.b  #0,flips_remaining(a2)
                move.b  #4,flip_speed(a2)
                btst    #Status_Facing,status(a2)
                beq.s   S3CompItem_PlayFlipLaunchSound
                neg.b   flip_angle(a2)
                neg.w   ground_vel(a2)

S3CompItem_PlayFlipLaunchSound:
                moveq   #signextendB(sfx_SmallBumpers),d0
                jmp     (Play_SFX).l
; End of function S3CompItem_TryUpwardFlipLaunch

; ---------------------------------------------------------------------------

S3CompItem_CheckMomentumTrapContacts:
                tst.b   collision_property(a0)
                beq.s   S3CompItem_AnimateTrapAndBrakeNegative
                lea     (Player_1).w,a2
                bclr    #0,collision_property(a0)
                beq.s   S3CompItem_CheckP2MomentumTrapContact
                bsr.s   S3CompItem_TryGroundMomentumTrap

S3CompItem_CheckP2MomentumTrapContact:
                lea     (Player_2).w,a2
                bclr    #1,collision_property(a0)
                beq.s   S3CompItem_ClearMomentumTrapContacts
                bsr.s   S3CompItem_TryGroundMomentumTrap

S3CompItem_ClearMomentumTrapContacts:
                clr.b   collision_property(a0)

S3CompItem_AnimateTrapAndBrakeNegative:
                lea     (Ani_2PItem).l,a1
                jsr     (Animate_Sprite).l
                tst.b   $3C(a0)
                beq.s   S3CompItem_DeleteFinishedMomentumTrap
                movea.w $3E(a0),a1
                subq.b  #1,$3C(a0)
                beq.s   S3CompItem_ReleaseMomentumTrapPlayer
                move.w  #$20,d1
                move.w  ground_vel(a1),d0
                bpl.s   S3CompItem_BrakePositiveAndCheckBorrow
                add.w   d1,ground_vel(a1)
                bcc.s   S3CompItem_QueueMomentumTrapContact
                move.w  #0,ground_vel(a1)
                bra.s   S3CompItem_ReleaseMomentumTrapPlayer
; ---------------------------------------------------------------------------

S3CompItem_BrakePositiveAndCheckBorrow:
                sub.w   d1,ground_vel(a1)
                bcc.s   S3CompItem_QueueMomentumTrapContact
                move.w  #0,ground_vel(a1)

S3CompItem_ReleaseMomentumTrapPlayer:
                move.w  #5,move_lock(a1)
                andi.b  #$7F,status_secondary(a1)

S3CompItem_DeleteFinishedMomentumTrap:
                tst.b   routine(a0)
                beq.s   S3CompItem_QueueMomentumTrapContact
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

S3CompItem_QueueMomentumTrapContact:
                jsr     (Add_SpriteToCollisionResponseList).l
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

; Double ground inertia and force the running pose. The trap owns the input lock until release
S3CompItem_TryGroundMomentumTrap:
                move.w  top_solid_bit(a2),d0
                cmp.w   top_solid_bit(a0),d0
                bne.s   S3CompItem_MomentumActivationReturn
                tst.b   status_secondary(a2)
                bmi.s   S3CompItem_MomentumActivationReturn
                btst    #Status_InAir,status(a2)
                bne.s   S3CompItem_MomentumActivationReturn
                tst.w   ground_vel(a2)
                beq.s   S3CompItem_MomentumActivationReturn
                move.b  #9,anim(a0)
                move.b  #0,collision_flags(a0)
                move.w  #$200,d1
                move.w  ground_vel(a2),d0
                bpl.s   S3CompItem_BoostSmallMomentum
                neg.w   d0
                neg.w   d1

S3CompItem_BoostSmallMomentum:
                cmpi.w  #$200,d0
                bhs.s   S3CompItem_DoubleMomentumAndLatch
                add.w   d1,ground_vel(a2)

; Start the 60-frame hold after doubling the selected player's ground speed
S3CompItem_DoubleMomentumAndLatch:
                asl     ground_vel(a2)
                move.b  #$1B,anim(a2)
                ori.b   #$80,status_secondary(a2)
                move.w  a2,$3E(a0)
                move.b  #$3C,$3C(a0)

S3CompItem_MomentumActivationReturn:
                rts
; End of function S3CompItem_TryGroundMomentumTrap

; ---------------------------------------------------------------------------

S3CompItem_CheckRollingHazardContacts:
                tst.b   collision_property(a0)
                beq.s   S3CompItem_MoveRollSelectFrameAndCull
                lea     (Player_1).w,a2
                bclr    #0,collision_property(a0)
                beq.s   S3CompItem_CheckP2RollingContact
                bsr.s   S3CompRollingItem_ExplodeOnHit

S3CompItem_CheckP2RollingContact:
                lea     (Player_2).w,a2
                bclr    #1,collision_property(a0)
                beq.s   S3CompItem_ClearRollingHazardContacts
                bsr.s   S3CompRollingItem_ExplodeOnHit

S3CompItem_ClearRollingHazardContacts:
                clr.b   collision_property(a0)

S3CompItem_MoveRollSelectFrameAndCull:
                bsr.w   S3CompRollingItem_UpdateMovement
                move.b  angle(a0),d0
                addi.b  #$10,d0
                lsr.b   #5,d0
                addi.b  #$11,d0
                move.b  d0,mapping_frame(a0)
                move.w  (Camera_max_Y_pos).w,d0
                addi.w  #$60,d0
                cmp.w   y_pos(a0),d0
                bge.s   S3CompItem_QueueRollingContactAndDraw
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

S3CompItem_QueueRollingContactAndDraw:
                jsr     (Add_SpriteToCollisionResponseList).l
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

; Require matching collision planes, then enter the explosion animation and tail-call the standard hazard response
S3CompRollingItem_ExplodeOnHit:
                move.w  top_solid_bit(a2),d0
                cmp.w   top_solid_bit(a0),d0
                beq.s   S3CompItem_StartExplosionThenHurt
                rts
; ---------------------------------------------------------------------------

S3CompItem_StartExplosionThenHurt:
                move.l  #S3CompItem_AnimateEffectOrDelete,(a0)
                move.b  #$B,anim(a0)
                movea.l a2,a1
                jmp     (HurtPlayerFromSolidHazard).l
; End of function S3CompRollingItem_ExplodeOnHit

; =============== S U B R O U T I N E =======================================

; Roll left on terrain or fall, wrap world coordinates and explode on left-wall penetration at a horizontal angle
S3CompRollingItem_UpdateMovement:
                btst    #1,status(a0)
                bne.s   S3CompItem_AccelerateAirRollLeft
                move.b  angle(a0),d0
                jsr     (GetSineCosine).l
                muls.w  ground_vel(a0),d1
                asr.l   #8,d1
                move.w  d1,x_vel(a0)
                muls.w  ground_vel(a0),d0
                asr.l   #8,d0
                move.w  d0,y_vel(a0)
                jsr     (MoveSprite2).l
                move.w  (Screen_Y_wrap_value).w,d0
                and.w   d0,y_pos(a0)
                move.w  (Screen_X_wrap_value).w,d0
                and.w   d0,x_pos(a0)
                addi.w  #$400,x_pos(a0)
                jsr     (Player_AnglePos).l
                move.b  angle(a0),d0
                bne.s   S3CompItem_GroundRollUpdateReturn
                jsr     (ProbeLeftWallUsingYRadius).l
                tst.w   d1
                bpl.s   S3CompItem_GroundRollUpdateReturn
                sub.w   d1,x_pos(a0)
                move.l  #S3CompItem_AnimateEffectOrDelete,(a0)
                move.b  #$B,anim(a0)

S3CompItem_GroundRollUpdateReturn:
                rts
; ---------------------------------------------------------------------------

S3CompItem_AccelerateAirRollLeft:
                subi.w  #$10,x_vel(a0)
                cmpi.w  #-$400,x_vel(a0)
                bgt.s   S3CompItem_MoveAirRollAndLand
                move.w  #-$400,x_vel(a0)

S3CompItem_MoveAirRollAndLand:
                jsr     (MoveSprite).l
                move.w  (Screen_Y_wrap_value).w,d0
                and.w   d0,y_pos(a0)
                move.w  (Screen_X_wrap_value).w,d0
                and.w   d0,x_pos(a0)
                addi.w  #$400,x_pos(a0)
                jsr     (ChkFloorEdge).l
                tst.w   d1
                bpl.s   S3CompItem_RelaxAirRollAngle
                add.w   d1,y_pos(a0)
                bclr    #1,status(a0)
                move.b  #0,angle(a0)
                rts
; ---------------------------------------------------------------------------

S3CompItem_RelaxAirRollAngle:
                move.b  angle(a0),d0
                beq.s   S3CompItem_ProbeLeftWallAtZeroAngle
                bpl.s   S3CompItem_ClampPositiveAngleAtZero
                addq.b  #2,d0
                bcc.s   S3CompItem_StoreRelaxedAngle
                moveq   #0,d0
                bra.s   S3CompItem_StoreRelaxedAngle
; ---------------------------------------------------------------------------

S3CompItem_ClampPositiveAngleAtZero:
                subq.b  #2,d0
                bcc.s   S3CompItem_StoreRelaxedAngle
                moveq   #0,d0

S3CompItem_StoreRelaxedAngle:
                move.b  d0,angle(a0)

S3CompItem_ProbeLeftWallAtZeroAngle:
                move.b  angle(a0),d0
                bne.s   S3CompItem_AirRollUpdateReturn
                jsr     (ProbeLeftWallUsingYRadius).l
                tst.w   d1
                bpl.s   S3CompItem_AirRollUpdateReturn
                sub.w   d1,x_pos(a0)
                move.l  #S3CompItem_AnimateEffectOrDelete,(a0)
                move.b  #$B,anim(a0)
                rts
; ---------------------------------------------------------------------------

S3CompItem_AirRollUpdateReturn:
                rts
; ---------------------------------------------------------------------------

S3CompItem_AnimateEffectOrDelete:
                lea     (Ani_2PItem).l,a1
                jsr     (Animate_Sprite).l
                tst.b   routine(a0)
                beq.s   S3CompItem_DrawActiveEffect
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

S3CompItem_DrawActiveEffect:
                jmp     (Draw_Sprite).l
; End of function S3CompRollingItem_UpdateMovement

; =============== S U B R O U T I N E =======================================

; Allocate after the current slot, copy the common object prefix and install the supplied handler and animation
S3CompItem_TryCloneEffect:
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   S3CompItem_CloneStatusReturn
                moveq   #subtype,d0

S3CompItem_CopyClonePrefixAndSetAnim:
                move.w  (a0,d0.w),(a1,d0.w)
                subq.w  #2,d0
                bcc.s   S3CompItem_CopyClonePrefixAndSetAnim
                move.l  d1,(a1)
                move.b  d2,anim(a1)
                moveq   #0,d0

S3CompItem_CloneStatusReturn:
                rts
; End of function S3CompItem_TryCloneEffect

; ---------------------------------------------------------------------------
Ani_2PItem:
                include "src/game/competition/shared/animations/item.s"
Map_2PItem:
                include "src/game/competition/shared/mappings/item.s"
