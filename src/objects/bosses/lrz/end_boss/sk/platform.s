; Owner: objects/bosses/lrz/end_boss/sk
; Responsibility: Lava Reef boss-scene moving platform, state dispatch and attached motion callbacks
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_LRZ3Platform:
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsl.w   #2,d0
                jmp     LRZ3Platform_Index(pc,d0.w)
; ---------------------------------------------------------------------------

LRZ3Platform_Index:
                bra.w   LRZBoss_WaitViewportAndTryPlatform
; ---------------------------------------------------------------------------
                bra.w   LRZBoss_SpawnRisingPlatformAndDelete
; ---------------------------------------------------------------------------
                bra.w   LRZBoss_SpawnRisingPlatformAndDelete
; ---------------------------------------------------------------------------
                bra.w   LRZBoss_InitSmallTopSolidPlatform
; ---------------------------------------------------------------------------
                bra.w   LRZBoss_InitLargeSolidPlatform
; ---------------------------------------------------------------------------

LRZBoss_WaitViewportAndTryPlatform:
                bsr.w   IsLRZPlatformOriginInsideCameraViewport
                beq.w   LRZBoss_SharedReturn
                move.l  #LRZBoss_RepeatUntilBossAppears,(a0)
                lea     LRZRisingPlatform_SingleRepeatedChild(pc),a2
                jsr     (CreateChild6_Simple).l
                bne.s   LRZBoss_RepeatUntilBossAppears
                addi.w  #$C0,y_pos(a1)
                move.b  subtype(a0),subtype(a1)
                move.w  #$37F,$2E(a1)

LRZBoss_RepeatUntilBossAppears:
                tst.w   (_unkFAA4).w
                bne.w   LRZBoss_ReleaseRidersAndDelete
                subq.w  #1,$2E(a0)
                bpl.w   LRZBoss_SharedReturn
                move.w  #$17F,$2E(a0)

; =============== S U B R O U T I N E =======================================

; Copy the placement subtype and initialize the lifetime to $4FF
LRZRisingPlatform_Spawn:
                lea     LRZRisingPlatform_SingleRepeatedChild(pc),a2
                jsr     (CreateChild6_Simple).l
                bne.s   LRZBoss_RisingPlatformSpawnReturn
                move.b  subtype(a0),subtype(a1)
                move.w  #$4FF,$2E(a1)

LRZBoss_RisingPlatformSpawnReturn:
                rts
; End of function LRZRisingPlatform_Spawn

; ---------------------------------------------------------------------------

LRZBoss_SpawnRisingPlatformAndDelete:
                bsr.w   IsLRZPlatformOriginInsideCameraViewport
                beq.w   LRZBoss_SharedReturn
                bsr.s   LRZRisingPlatform_Spawn
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

LRZBoss_InitSmallTopSolidPlatform:
                lea     LRZBossSmallPlatform_FullAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #LRZSmallPlatform_MoveTopSolidAndCull,(a0)

LRZSmallPlatform_MoveTopSolidAndCull:
                bsr.w   MoveLRZPlatformAndResolveTopSolidRiders
                jmp     (Sprite_CheckDelete).l
; ---------------------------------------------------------------------------

LRZBoss_InitLargeSolidPlatform:
                lea     LRZBoss_LargePlatformAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #LRZBoss_LargePlatformAnimateAndSolid,(a0)

LRZBoss_LargePlatformAnimateAndSolid:
                lea     LRZBossLargePlatform_UniformFrameLoop(pc),a1
                jsr     (Animate_RawNoSST).l
                moveq   #$2B,d1
                moveq   #$18,d2
                moveq   #$19,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                jmp     (Sprite_CheckDelete).l
; ---------------------------------------------------------------------------

LRZBoss_InitRisingPlatform:
                lea     LRZBossSmallPlatform_FullAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #LRZBoss_RisingPlatformRiseAndWait,(a0)
                move.w  #-$80,y_vel(a0)
                move.w  #$20,$3A(a0)

LRZBoss_RisingPlatformRiseAndWait:
                subq.w  #1,$3A(a0)
                bmi.s   LRZBoss_BeginDescentAndTryOverlay
                bsr.w   MoveLRZPlatformAndResolveTopSolidRiders
                bra.w   LRZBoss_CheckAndClaimArenaPlatform
; ---------------------------------------------------------------------------

LRZBoss_BeginDescentAndTryOverlay:
                move.l  #LRZBoss_DescendAndCheckLifetime,(a0)
                move.w  #$180,priority(a0)
                move.w  #$80,y_vel(a0)
                lea     LRZBoss_PlatformOverlayChild(pc),a2
                jsr     (CreateChild6_Simple).l

LRZBoss_DescendAndCheckLifetime:
                bsr.w   MoveLRZPlatformAndResolveTopSolidRiders
                move.b  subtype(a0),d0
                cmpi.b  #1,d0
                beq.s   LRZBoss_CullSubtypeOneOffscreen
                subq.w  #1,$2E(a0)
                bmi.s   LRZBoss_ReleaseRidersAndDelete

LRZBoss_CheckAndClaimArenaPlatform:
                tst.w   (_unkFAA4).w
                beq.s   LRZPlatformShared_DrawCurrent
                tst.b   render_flags(a0)
                bpl.s   LRZBoss_ReleaseRidersAndDelete
                tst.b   d0
                bne.s   LRZPlatformShared_DrawCurrent
                tst.b   (_unkFAA9).w
                bne.s   LRZPlatformShared_DrawCurrent
                cmpi.w  #$612,y_pos(a0)
                bhi.s   LRZPlatformShared_DrawCurrent
                move.l  #LRZBoss_SignalBossAtArenaHeight,(a0)
                st      (_unkFAA9).w

LRZPlatformShared_DrawCurrent:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

LRZBoss_CullSubtypeOneOffscreen:
                tst.b   render_flags(a0)
                bmi.s   LRZPlatformShared_DrawCurrent

LRZBoss_ReleaseRidersAndDelete:
                jsr     (Displace_PlayerOffObject).l
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

LRZBoss_SignalBossAtArenaHeight:
                bsr.w   MoveLRZPlatformAndResolveTopSolidRiders
                cmpi.w  #$612,y_pos(a0)
                blo.s   LRZPlatformShared_DrawCurrent
                move.l  #LRZBoss_CheckShatterAndStream,(a0)
                bset    #0,(_unkFA88).w
                clr.w   y_vel(a0)
                bset    #7,status(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

LRZBoss_CheckShatterAndStream:
                bsr.w   LRZBossPlatform_TryShatter
                tst.b   (_unkFAA3).w
                bne.s   LRZBoss_FollowLavaStreamAndSolid
                tst.b   render_flags(a0)
                bpl.w   LRZBoss_ReleaseRidersAndDelete

LRZBoss_FollowLavaStreamAndSolid:
                bsr.w   SetLRZLavaRiderHorizontalStreamVelocity
                bsr.w   MoveLRZPlatformAndResolveTopSolidRiders
                bsr.w   MatchLRZLavaRiderHeightFromWorldXSample
                jmp     (Sprite_CheckDelete).l
; ---------------------------------------------------------------------------
; unused
                move.l  #LRZBoss_LegacySwingToRightLimit,(a0)
                move.w  #$80,x_vel(a0)
                move.w  #$40,d0
                move.w  d0,$3E(a0)
                move.w  d0,y_vel(a0)
                move.w  #8,$40(a0)
                bclr    #0,$38(a0)
                rts
; ---------------------------------------------------------------------------

LRZBoss_LegacySwingToRightLimit:
                jsr     (Swing_UpAndDown).l
                cmpi.w  #$B60,x_pos(a0)
                blo.s   LRZPlatformLegacy_MoveTopSolidAndCull
                move.l  #LRZPlatformLegacy_MoveTopSolidAndCull,(a0)
                clr.w   x_vel(a0)
                clr.w   y_vel(a0)

LRZPlatformLegacy_MoveTopSolidAndCull:
                bsr.w   MoveLRZPlatformAndResolveTopSolidRiders
                jmp     (Sprite_CheckDelete).l
; ---------------------------------------------------------------------------

LRZBoss_InitStreamPlatform:
                lea     LRZBossSmallPlatform_FullAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                lea     LRZBoss_CheckShatterAndStream(pc),a1
                move.l  a1,(a0)
                jmp     (a1)
; ---------------------------------------------------------------------------

LRZBoss_InitPlatformOverlay:
                lea     LRZBoss_PlatformOverlayAttributes(pc),a1
                jsr     (SetUp_ObjAttributes2).l
                move.l  #LRZBoss_PlatformOverlayFollowDraw,(a0)

LRZBoss_PlatformOverlayFollowDraw:
                movea.w parent3(a0),a1
                move.w  x_pos(a1),x_pos(a0)
                move.w  y_pos(a1),y_pos(a0)
                lea     LRZBossPlatformOverlay_UniformFrameLoop(pc),a1
                jsr     (Animate_RawNoSST).l
                jmp     (Child_Draw_Sprite).l
; ---------------------------------------------------------------------------

LRZBoss_InitPlatformDebris:
                lea     SKLRZ3Scene_PlatformDebrisAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #Obj_FlickerMove,(a0)
                bsr.w   SeedLRZBossPlatformTenDebrisPieces
                jmp     (Draw_Sprite).l
