; Owner: objects/bosses/hcz/miniboss/sk
; Responsibility: Hydrocity miniboss engine actors, coordinated effects, defeat sequence and debris states
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_HCZMiniboss_Engine:
                lea     ObjDat2_HCZMiniboss_Engine(pc),a1
                jsr     (SetUp_ObjAttributes2).l
                move.l  #HCZMiniSK_EngineFollowAndCheckDraw,(a0)
                bset    #4,shield_reaction(a0)
                rts
; ---------------------------------------------------------------------------

HCZMiniSK_EngineFollowAndCheckDraw:
                jsr     (Refresh_ChildPosition).l
                bra.s   HCZMiniSK_EngineOrTipCheckDraw
; ---------------------------------------------------------------------------

HCZMiniSK_InitSlottedWaterSplash:
                lea     HCZMiniSK_SplashArtSlots(pc),a1
                jsr     (SetUp_ObjAttributesSlotted).l
                move.w  (Water_level).w,y_pos(a0)
                move.l  #Obj_Wait,(a0)
                tst.b   subtype(a0)
                beq.s   HCZMiniSK_SplashSetDelayedCallback
                move.w  #7,$2E(a0)

HCZMiniSK_SplashSetDelayedCallback:
                move.l  #HCZMiniSK_SplashBeginDPLCAnimation,$34(a0)
                rts
; ---------------------------------------------------------------------------

HCZMiniSK_SplashBeginDPLCAnimation:
                move.l  #HCZMiniSK_SplashAnimateLoadAndDraw,(a0)
                move.l  #Go_Delete_SpriteSlotted3,$34(a0)
                rts
; ---------------------------------------------------------------------------

HCZMiniSK_SplashAnimateLoadAndDraw:
                lea     HCZMiniSK_SplashDPLCAnimation(pc),a1
                jsr     (Animate_RawNoSST).l
                lea     DPLCPtr_HCZMinibossSplash(pc),a2
                jsr     (Perform_DPLC).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

HCZMiniSK_VortexDispatchAndDraw:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  HCZMiniSK_VortexStateOffsets(pc,d0.w),d1
                jsr     HCZMiniSK_VortexStateOffsets(pc,d1.w)
                bsr.w   SwitchHCZVortexToParentDefeatState
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------
HCZMiniSK_VortexStateOffsets:
                dc.w    HCZMiniSK_InitVortexAndClearPlayers-HCZMiniSK_VortexStateOffsets
                dc.w    HCZMiniSK_VortexWaitVisibleAndLoadPal-HCZMiniSK_VortexStateOffsets
                dc.w    HCZMiniSK_VortexAccelerateAndSpawn-HCZMiniSK_VortexStateOffsets
                dc.w    HCZMiniSK_VortexAnimateAcceleration-HCZMiniSK_VortexStateOffsets
                dc.w    HCZMiniSK_VortexCaptureAndCheckStop-HCZMiniSK_VortexStateOffsets
                dc.w    HCZMiniSK_VortexAnimateDeceleration-HCZMiniSK_VortexStateOffsets
; ---------------------------------------------------------------------------

HCZMiniSK_InitVortexAndClearPlayers:
                lea     HCZMiniSK_VortexAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                addi.w  #$148,y_pos(a0)
                clr.w   $42(a0)
                clr.w   $44(a0)
                rts
; ---------------------------------------------------------------------------

HCZMiniSK_VortexWaitVisibleAndLoadPal:
                tst.b   render_flags(a0)
                bpl.w   HCZMiniSK_SharedReturn
                move.b  #4,routine(a0)
                lea     Pal_HCZMinibossWater(pc),a1
                lea     (Water_palette_line_2).w,a2
                moveq   #bytesToLcnt($20),d0

HCZMiniSK_VortexCopyWaterPalette:
                move.l  (a1)+,(a2)+
                dbf     d0,HCZMiniSK_VortexCopyWaterPalette
                rts
; ---------------------------------------------------------------------------

HCZMiniSK_VortexAccelerateAndSpawn:
                movea.w parent3(a0),a1
                btst    #2,$38(a1)
                beq.w   HCZMiniSK_SharedReturn
                move.b  #6,routine(a0)
                move.l  #HCZMiniSK_VortexAccelerationAnim,$30(a0)
                move.l  #HCZMiniSK_VortexBeginCapture,$34(a0)
                moveq   #signextendB(sfx_FanBig),d0
                jsr     (Play_SFX).l
                lea     HCZMiniSK_VortexOrbitChildren(pc),a2
                jmp     (CreateChild6_Simple).l
; ---------------------------------------------------------------------------

HCZMiniSK_VortexAnimateAcceleration:
                lea     HCZMiniSK_VortexAccelerationAnim(pc),a1
                jmp     (Animate_RawNoSSTMultiDelay).l
; ---------------------------------------------------------------------------

HCZMiniSK_VortexBeginCapture:
                move.b  #8,routine(a0)
                move.l  #HCZMiniSK_VortexAccelerationAnim,$30(a0)
                move.l  #HCZMiniSK_VortexResetRequestPoll,$34(a0)
                clr.b   collision_property(a0)
                rts
; ---------------------------------------------------------------------------

HCZMiniSK_VortexCaptureAndCheckStop:
                bsr.w   CapturePlayersInHCZMinibossVortex
                movea.w parent3(a0),a1
                btst    #2,$38(a1)
                beq.s   HCZMiniSK_VortexReleaseAndDecelerate
                moveq   #signextendB(sfx_BossRotate),d0
                jsr     (Play_SFX_Continuous).l
                lea     HCZMiniSK_VortexActiveAnim(pc),a1
                jmp     (Animate_RawNoSST).l
; ---------------------------------------------------------------------------

HCZMiniSK_VortexReleaseAndDecelerate:
                move.b  #$A,routine(a0)
                bset    #3,$38(a0)
                move.l  #HCZMiniSK_VortexResetRequestPoll,$34(a0)
                bsr.w   HCZMiniSK_VortexReleaseP1ThenP2
                jmp     (Animate_RawMultiDelay).l
; ---------------------------------------------------------------------------

HCZMiniSK_VortexAnimateDeceleration:
                lea     HCZMiniSK_VortexDecelerationAnim(pc),a1
                jmp     (Animate_RawNoSSTMultiDelay).l
; ---------------------------------------------------------------------------

HCZMiniSK_VortexResetRequestPoll:
                move.b  #4,routine(a0)
                move.b  #$16,mapping_frame(a0)
                bclr    #3,$38(a0)
                rts
; ---------------------------------------------------------------------------

; Boss flag 4 starts the breakup and releases any captured players
HCZMiniSK_VortexWaitThenBreakUp:
                movea.w parent3(a0),a1
                btst    #4,$38(a1)
                beq.s   HCZMiniSK_VortexDefeatDraw
                lea     HCZMiniSK_VortexDebrisChildren(pc),a2
                jsr     (CreateChild1_Normal).l
                bsr.w   HCZMiniSK_VortexReleaseP1ThenP2
                jsr     (Go_Delete_Sprite_2).l

HCZMiniSK_VortexDefeatDraw:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

HCZMiniSK_InitRandomOrbitParticle:
                lea     HCZMiniSK_ParticleAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #HCZMiniSK_OrbitParticleAnimateAndDraw,(a0)
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
                move.l  HCZMiniSK_ParticleAnimationPointers(pc,d0.w),$30(a0)
                move.w  #$1F,$2E(a0)
                move.l  #HCZMiniSK_OrbitParticleFreezeFrame,$34(a0)
                rts
; ---------------------------------------------------------------------------
HCZMiniSK_ParticleAnimationPointers:
                dc.l    HCZMiniSK_ParticleAnimBase0
                dc.l    HCZMiniSK_ParticleAnimBase1
                dc.l    HCZMiniSK_ParticleAnimBase2
                dc.l    HCZMiniSK_ParticleAnimBase3
; ---------------------------------------------------------------------------

HCZMiniSK_OrbitParticleAnimateAndDraw:
                movea.w parent3(a0),a3
                bsr.w   MoveHCZVortexParticleAroundParent
                jsr     (Animate_Raw).l
                jsr     (Obj_Wait).l
                jmp     (Child_Draw_Sprite2).l
; ---------------------------------------------------------------------------

HCZMiniSK_OrbitParticleFreezeFrame:
                move.l  #HCZMiniSK_OrbitParticleUntilStop,(a0)
                movea.l $30(a0),a1
                move.b  1(a1),mapping_frame(a0)
                rts
; ---------------------------------------------------------------------------

HCZMiniSK_OrbitParticleUntilStop:
                movea.w parent3(a0),a3
                btst    #3,$38(a3)
                bne.s   HCZMiniSK_OrbitParticleBeginFade
                bsr.w   MoveHCZVortexParticleAroundParent
                jmp     (Child_Draw_Sprite2).l
; ---------------------------------------------------------------------------

HCZMiniSK_OrbitParticleBeginFade:
                move.l  #HCZMiniSK_OrbitParticleAnimateAndDraw,(a0)
                move.w  #$1F,$2E(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                rts
; ---------------------------------------------------------------------------

HCZMiniSK_InitWaterExitParticle:
                lea     HCZMiniSK_ParticleAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #HCZMiniSK_ExitParticleMoveAndDraw,(a0)
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
                bpl.s   HCZMiniSK_ExitParticleSetOffsetAndSpeed
                st      $3C(a0)

; Replace the launch helper's horizontal speed with the offset scaled by 16
HCZMiniSK_ExitParticleSetOffsetAndSpeed:
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
                lea     HCZMiniSK_ParticleAnimationPointers(pc),a1
                move.l  (a1,d0.w),$30(a0)
                move.w  #$200,y_vel(a0)
                move.w  #$BF,$2E(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

HCZMiniSK_ExitParticleMoveAndDraw:
                tst.b   render_flags(a0)
                bpl.s   HCZMiniSK_ExitParticleDeleteOffscreen
                bsr.w   AccelerateHCZVortexActorTowardCenterX
                jsr     (MoveSprite2).l
                jsr     (Animate_Raw).l
                jsr     (Obj_Wait).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

HCZMiniSK_ExitParticleDeleteOffscreen:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

HCZMiniSK_TransportWaitForP1Underwater:
                lea     (Player_1).w,a1
                btst    #Status_Underwater,status(a1)
                beq.w   HCZMiniSK_SharedReturn
                move.l  #HCZMiniSK_TransportMoveAndSyncPlayer,(a0)
                clr.b   (ZoneEventLatchOrBossReleaseSignal).w
                movea.w parent3(a0),a1
                bset    #0,$38(a1)
                move.b  #4,render_flags(a0)
                lea     (Player_1).w,a1
                lea     (Ctrl_1_locked).w,a2
                tst.b   subtype(a0)
                beq.s   HCZMiniSK_TransportUnlockAndBindPlayer
                lea     (Player_2).w,a1
                lea     (Ctrl_2_locked).w,a2
                btst    #Status_Underwater,status(a1)
                beq.w   HCZMiniSK_TransportDeleteIfNoPlayer

HCZMiniSK_TransportUnlockAndBindPlayer:
                clr.b   (a2)
                tst.l   (a1)
                beq.s   HCZMiniSK_TransportDeleteIfNoPlayer
                move.w  a1,$44(a0)
                bclr    #7,art_tile(a0)
                move.w  x_pos(a1),d0
                move.w  d0,x_pos(a0)
                move.w  y_pos(a1),y_pos(a0)
                move.w  (Camera_X_pos).w,d1
                addi.w  #$A0,d1
                move.w  d1,$3A(a0)
                sub.w   d1,d0
                bpl.s   HCZMiniSK_TransportLaunchAndTakeControl
                st      $3C(a0)

HCZMiniSK_TransportLaunchAndTakeControl:
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

HCZMiniSK_TransportDeleteIfNoPlayer:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

HCZMiniSK_TransportMoveAndSyncPlayer:
                bsr.w   AccelerateHCZVortexActorTowardCenterX
                jsr     (MoveSprite2).l
                movea.w $44(a0),a1
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),d0
                move.w  d0,y_pos(a1)
                cmpi.w  #$828,d0
                bhs.s   HCZMiniSK_TransportChooseRelease
                rts
; ---------------------------------------------------------------------------

HCZMiniSK_TransportChooseRelease:
                tst.b   subtype(a0)
                beq.s   HCZMiniSK_TransportReleaseP1AndSetBounds
                lea     (Player_2).w,a1
                tst.l   (a1)
                beq.s   HCZMiniSK_TransportDeleteAfterRelease
                jsr     (Restore_PlayerControl2).l
                bra.w   HCZMiniSK_TransportDeleteAfterRelease
; ---------------------------------------------------------------------------

HCZMiniSK_TransportReleaseP1AndSetBounds:
                jsr     (Restore_PlayerControl).l
                move.w  #0,(Camera_stored_min_Y_pos).w
                jsr     (Make_LevelSizeObj).l

HCZMiniSK_TransportDeleteAfterRelease:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

HCZMiniSK_InitBossFragmentFlicker:
                lea     HCZMiniSK_BossFragmentAttributes(pc),a1
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

HCZMiniSK_InitFallingVortexDebris:
                lea     HCZMiniSK_VortexDebrisAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #MoveChkDel,(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsr.w   #1,d0
                addi.b  #$1F,d0
                move.b  d0,mapping_frame(a0)
                moveq   #$1C,d0
                jmp     (Set_IndexedVelocity).l
; End of function HCZMiniSK_InitFallingVortexDebris
