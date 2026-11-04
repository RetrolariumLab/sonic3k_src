; Owner: objects/bosses/hcz/miniboss/s3
; Responsibility: Hydrocity miniboss engine actors, coordinated effects, defeat sequence and debris states
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_HCZMiniboss_Engine:
                lea     ObjDat2_HCZMiniboss_Engine(pc),a1
                jsr     (SetUp_ObjAttributes2).l
                move.l  #HCZMiniS3_EngineFollowAndCheckDraw,(a0)
                rts
; ---------------------------------------------------------------------------

HCZMiniS3_EngineFollowAndCheckDraw:
                jsr     (Refresh_ChildPosition).l
                bra.s   HCZMiniS3_EngineOrTipCheckDraw
; ---------------------------------------------------------------------------

HCZMiniS3_InitSlottedWaterSplash:
                lea     HCZMiniS3_SplashArtSlots(pc),a1
                jsr     (SetUp_ObjAttributesSlotted).l
                move.w  (Water_level).w,y_pos(a0)
                move.l  #Obj_Wait,(a0)
                tst.b   subtype(a0)
                beq.s   HCZMiniS3_SplashSetDelayedCallback
                move.w  #7,$2E(a0)

HCZMiniS3_SplashSetDelayedCallback:
                move.l  #HCZMiniS3_SplashBeginDPLCAnimation,$34(a0)
                rts
; ---------------------------------------------------------------------------

HCZMiniS3_SplashBeginDPLCAnimation:
                move.l  #HCZMiniS3_SplashAnimateLoadAndDraw,(a0)
                move.l  #Go_Delete_SpriteSlotted3,$34(a0)
                rts
; ---------------------------------------------------------------------------

HCZMiniS3_SplashAnimateLoadAndDraw:
                lea     HCZMiniS3_SplashDPLCAnimation(pc),a1
                jsr     (Animate_RawNoSST).l
                lea     DPLCPtr_HCZMinibossSplash(pc),a2
                jsr     (Perform_DPLC).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

HCZMiniS3_VortexDispatchAndDraw:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  HCZMiniS3_VortexStateOffsets(pc,d0.w),d1
                jsr     HCZMiniS3_VortexStateOffsets(pc,d1.w)
                bsr.w   SwitchHCZVortexToParentDefeatState
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------
HCZMiniS3_VortexStateOffsets:
                dc.w    HCZMiniS3_InitVortexAndClearPlayers-HCZMiniS3_VortexStateOffsets
                dc.w    HCZMiniS3_VortexWaitVisibleAndLoadPal-HCZMiniS3_VortexStateOffsets
                dc.w    HCZMiniS3_VortexAccelerateAndSpawn-HCZMiniS3_VortexStateOffsets
                dc.w    HCZMiniS3_VortexAnimateAcceleration-HCZMiniS3_VortexStateOffsets
                dc.w    HCZMiniS3_VortexCaptureAndCheckStop-HCZMiniS3_VortexStateOffsets
                dc.w    HCZMiniS3_VortexAnimateDeceleration-HCZMiniS3_VortexStateOffsets
; ---------------------------------------------------------------------------

HCZMiniS3_InitVortexAndClearPlayers:
                lea     HCZMiniS3_VortexAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                addi.w  #$148,y_pos(a0)
                clr.w   $42(a0)
                clr.w   $44(a0)
                rts
; ---------------------------------------------------------------------------

HCZMiniS3_VortexWaitVisibleAndLoadPal:
                tst.b   render_flags(a0)
                bpl.w   HCZMiniS3_SharedReturn
                move.b  #4,routine(a0)
                lea     Pal_HCZMinibossWater(pc),a1
                lea     (Water_palette_line_2).w,a2
                moveq   #bytesToLcnt($20),d0

HCZMiniS3_VortexCopyWaterPalette:
                move.l  (a1)+,(a2)+
                dbf     d0,HCZMiniS3_VortexCopyWaterPalette
                rts
; ---------------------------------------------------------------------------

HCZMiniS3_VortexAccelerateAndSpawn:
                movea.w parent3(a0),a1
                btst    #2,$38(a1)
                beq.w   HCZMiniS3_SharedReturn
                move.b  #6,routine(a0)
                move.l  #HCZMiniS3_VortexAccelerationAnim,$30(a0)
                move.l  #HCZMiniS3_VortexBeginCapture,$34(a0)
                moveq   #signextendB(sfx_FanBig),d0
                jsr     (Play_SFX).l
                lea     HCZMiniS3_VortexOrbitChildren(pc),a2
                jmp     (CreateChild6_Simple).l
; ---------------------------------------------------------------------------

HCZMiniS3_VortexAnimateAcceleration:
                lea     HCZMiniS3_VortexAccelerationAnim(pc),a1
                jmp     (Animate_RawNoSSTMultiDelay).l
; ---------------------------------------------------------------------------

HCZMiniS3_VortexBeginCapture:
                move.b  #8,routine(a0)
                move.l  #HCZMiniS3_VortexAccelerationAnim,$30(a0)
                move.l  #HCZMiniS3_VortexResetRequestPoll,$34(a0)
                clr.b   collision_property(a0)
                rts
; ---------------------------------------------------------------------------

HCZMiniS3_VortexCaptureAndCheckStop:
                bsr.w   CapturePlayersInHCZMinibossVortex
                movea.w parent3(a0),a1
                btst    #2,$38(a1)
                beq.s   HCZMiniS3_VortexReleaseAndDecelerate
                moveq   #signextendB(sfx_BossRotate),d0
                jsr     (Play_SFX_Continuous).l
                lea     HCZMiniS3_VortexActiveAnim(pc),a1
                jmp     (Animate_RawNoSST).l
; ---------------------------------------------------------------------------

HCZMiniS3_VortexReleaseAndDecelerate:
                move.b  #$A,routine(a0)
                bset    #3,$38(a0)
                move.l  #HCZMiniS3_VortexResetRequestPoll,$34(a0)
                bsr.w   HCZMiniS3_VortexReleaseP1ThenP2
                jmp     (Animate_RawMultiDelay).l
; ---------------------------------------------------------------------------

HCZMiniS3_VortexAnimateDeceleration:
                lea     HCZMiniS3_VortexDecelerationAnim(pc),a1
                jmp     (Animate_RawNoSSTMultiDelay).l
; ---------------------------------------------------------------------------

HCZMiniS3_VortexResetRequestPoll:
                move.b  #4,routine(a0)
                move.b  #$16,mapping_frame(a0)
                bclr    #3,$38(a0)
                rts
; ---------------------------------------------------------------------------

; Boss flag 4 starts the breakup and releases any captured players
HCZMiniS3_VortexWaitThenBreakUp:
                movea.w parent3(a0),a1
                btst    #4,$38(a1)
                beq.s   HCZMiniS3_VortexDefeatDraw
                lea     HCZMiniS3_VortexDebrisChildren(pc),a2
                jsr     (CreateChild1_Normal).l
                bsr.w   HCZMiniS3_VortexReleaseP1ThenP2
                jsr     (Go_Delete_Sprite_2).l

HCZMiniS3_VortexDefeatDraw:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

HCZMiniS3_InitRandomOrbitParticle:
                lea     HCZMiniS3_ParticleAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #HCZMiniS3_OrbitParticleAnimateAndDraw,(a0)
                jsr     (Random_Number).l
                andi.w  #$FF,d0
                ext.w   d0
                add.w   d0,x_pos(a0)
                swap    d0
                andi.w  #$3F,d0
                subq.w  #8,d0
                add.w   d0,y_pos(a0)
                andi.w  #3,d0
                move.b  d0,mapping_frame(a0)
                lsl.w   #2,d0
                move.l  HCZMiniS3_ParticleAnimationPointers(pc,d0.w),$30(a0)
                move.w  #$1F,$2E(a0)
                move.l  #HCZMiniS3_OrbitParticleFreezeFrame,$34(a0)
                rts
; ---------------------------------------------------------------------------
HCZMiniS3_ParticleAnimationPointers:
                dc.l    HCZMiniS3_ParticleAnimBase0
                dc.l    HCZMiniS3_ParticleAnimBase1
                dc.l    HCZMiniS3_ParticleAnimBase2
                dc.l    HCZMiniS3_ParticleAnimBase3
; ---------------------------------------------------------------------------

HCZMiniS3_OrbitParticleAnimateAndDraw:
                movea.w parent3(a0),a3
                bsr.w   MoveHCZVortexParticleAroundParent
                jsr     (Animate_Raw).l
                jsr     (Obj_Wait).l
                jmp     (Child_Draw_Sprite2).l
; ---------------------------------------------------------------------------

HCZMiniS3_OrbitParticleFreezeFrame:
                move.l  #HCZMiniS3_OrbitParticleUntilStop,(a0)
                movea.l $30(a0),a1
                move.b  1(a1),mapping_frame(a0)
                rts
; ---------------------------------------------------------------------------

HCZMiniS3_OrbitParticleUntilStop:
                movea.w parent3(a0),a3
                btst    #3,$38(a3)
                bne.s   HCZMiniS3_OrbitParticleBeginFade
                bsr.w   MoveHCZVortexParticleAroundParent
                jmp     (Child_Draw_Sprite2).l
; ---------------------------------------------------------------------------

HCZMiniS3_OrbitParticleBeginFade:
                move.l  #HCZMiniS3_OrbitParticleAnimateAndDraw,(a0)
                move.w  #$1F,$2E(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                rts
; ---------------------------------------------------------------------------

HCZMiniS3_InitWaterExitParticle:
                lea     HCZMiniS3_ParticleAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #HCZMiniS3_ExitParticleMoveAndDraw,(a0)
                move.w  (Camera_X_pos).w,d0
                addi.w  #$A0,d0
                move.w  d0,x_pos(a0)
                move.w  d0,$3A(a0)
                move.w  (Water_level).w,d0
                addq.w  #8,d0
                move.w  d0,y_pos(a0)
                jsr     (Random_Number).l
                andi.w  #$FF,d0
                move.w  d0,d1
                ext.w   d0
                bpl.s   HCZMiniS3_ExitParticleSetOffsetAndSpeed
                st      $3C(a0)

; Replace the launch helper's horizontal speed with the offset scaled by 16
HCZMiniS3_ExitParticleSetOffsetAndSpeed:
                add.w   d0,x_pos(a0)
                bsr.w   SetHCZVortexLaunchVelocityFromOffset
                lsl.w   #4,d0
                move.w  d0,x_vel(a0)
                andi.b  #1,d1
                move.b  d1,anim_frame(a0)
                swap    d0
                andi.w  #$1F,d0
                add.w   d0,y_pos(a0)
                andi.w  #3,d0
                move.b  d0,mapping_frame(a0)
                lsl.w   #2,d0
                lea     HCZMiniS3_ParticleAnimationPointers(pc),a1
                move.l  (a1,d0.w),$30(a0)
                move.w  #$200,y_vel(a0)
                move.w  #$BF,$2E(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

HCZMiniS3_ExitParticleMoveAndDraw:
                tst.b   render_flags(a0)
                bpl.s   HCZMiniS3_ExitParticleDeleteOffscreen
                bsr.w   AccelerateHCZVortexActorTowardCenterX
                jsr     (MoveSprite2).l
                jsr     (Animate_Raw).l
                jsr     (Obj_Wait).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

HCZMiniS3_ExitParticleDeleteOffscreen:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

HCZMiniS3_TransportWaitForP1Underwater:
                lea     (Player_1).w,a1
                btst    #Status_Underwater,status(a1)
                beq.w   HCZMiniS3_SharedReturn
                move.l  #HCZMiniS3_TransportMoveAndSyncPlayer,(a0)
                clr.b   (_unkFAA2).w
                movea.w parent3(a0),a1
                bset    #0,$38(a1)
                move.b  #4,render_flags(a0)
                lea     (Player_1).w,a1
                lea     (Ctrl_1_locked).w,a2
                tst.b   subtype(a0)
                beq.s   HCZMiniS3_TransportUnlockAndBindPlayer
                lea     (Player_2).w,a1
                lea     (Ctrl_2_locked).w,a2
                btst    #Status_Underwater,status(a1)
                beq.w   HCZMiniS3_TransportDeleteIfNoPlayer

HCZMiniS3_TransportUnlockAndBindPlayer:
                clr.b   (a2)
                tst.l   (a1)
                beq.s   HCZMiniS3_TransportDeleteIfNoPlayer
                move.w  a1,$44(a0)
                bclr    #7,art_tile(a0)
                move.w  x_pos(a1),d0
                move.w  d0,x_pos(a0)
                move.w  y_pos(a1),y_pos(a0)
                move.w  (Camera_X_pos).w,d1
                addi.w  #$A0,d1
                move.w  d1,$3A(a0)
                sub.w   d1,d0
                bpl.s   HCZMiniS3_TransportLaunchAndTakeControl
                st      $3C(a0)

HCZMiniS3_TransportLaunchAndTakeControl:
                bsr.w   SetHCZVortexLaunchVelocityFromOffset
                move.w  #$200,y_vel(a0)
                bset    #Status_InAir,status(a1)
                move.b  #1,object_control(a1)
                move.b  #$F,anim(a1)
                clr.b   spin_dash_flag(a1)
                clr.w   x_vel(a1)
                clr.w   y_vel(a1)
                clr.w   ground_vel(a1)
                rts
; ---------------------------------------------------------------------------

HCZMiniS3_TransportDeleteIfNoPlayer:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

HCZMiniS3_TransportMoveAndSyncPlayer:
                bsr.w   AccelerateHCZVortexActorTowardCenterX
                jsr     (MoveSprite2).l
                movea.w $44(a0),a1
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),d0
                move.w  d0,y_pos(a1)
                cmpi.w  #$828,d0
                bhs.s   HCZMiniS3_TransportChooseRelease
                rts
; ---------------------------------------------------------------------------

HCZMiniS3_TransportChooseRelease:
                tst.b   subtype(a0)
                beq.s   HCZMiniS3_TransportReleaseP1AndSetBounds
                lea     (Player_2).w,a1
                tst.l   (a1)
                beq.s   HCZMiniS3_TransportDeleteAfterRelease
                jsr     (Restore_PlayerControl2).l
                bra.w   HCZMiniS3_TransportDeleteAfterRelease
; ---------------------------------------------------------------------------

HCZMiniS3_TransportReleaseP1AndSetBounds:
                jsr     (Restore_PlayerControl).l
                move.w  #0,(Camera_stored_min_Y_pos).w
                jsr     (Make_LevelSizeObj).l

HCZMiniS3_TransportDeleteAfterRelease:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

HCZMiniS3_InitBossFragmentFlicker:
                lea     HCZMiniS3_BossFragmentAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #Obj_FlickerMove,(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsr.w   #1,d0
                addi.b  #$1B,d0
                move.b  d0,mapping_frame(a0)
                moveq   #$20,d0
                jmp     (Set_IndexedVelocity).l
; ---------------------------------------------------------------------------

HCZMiniS3_InitFallingVortexDebris:
                lea     HCZMiniS3_VortexDebrisAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #MoveChkDel,(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsr.w   #1,d0
                addi.b  #$1F,d0
                move.b  d0,mapping_frame(a0)
                moveq   #$1C,d0
                jmp     (Set_IndexedVelocity).l
; End of function HCZMiniS3_InitFallingVortexDebris
