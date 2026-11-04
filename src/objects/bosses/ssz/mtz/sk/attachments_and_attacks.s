; Owner: objects/bosses/ssz/mtz/sk
; Responsibility: Sky Sanctuary Metropolis-style boss attached actors, orbiting or moving attack states and defeat effects
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

TickSSZMTZBossLaserPairBurst:
                subi.w  #1,(SSZ_MTZ_boss_laser_timer).w
                bne.s   SSZMTZLaserBurst_ReturnAfterTimerOrSpawn
                tst.b   $31(a0)
                beq.s   SSZMTZLaserBurst_ReturnAfterTimerOrSpawn
                subq.b  #1,$31(a0)
                move.b  #$10,$33(a0)
                move.w  #$1E,(SSZ_MTZ_boss_laser_timer).w
                lea     SSZMTZLaserPair_NormalChildRecords(pc),a2
                jsr     (CreateChild1_Normal).l

SSZMTZLaserBurst_ReturnAfterTimerOrSpawn:
                rts
; End of function TickSSZMTZBossLaserPairBurst

; ---------------------------------------------------------------------------
SSZMTZLaserPair_NormalChildRecords:
                dc.w    2-1
                dc.l    SSZMTZ_InitLaserAtParent
                dc.b    -$C,  -4
                dc.l    SSZMTZ_InitLaserAtParent
                dc.b    -$18,  -4
; ---------------------------------------------------------------------------

SSZMTZ_InitLaserAtParent:
                lea     SSZMTZLaser_Attributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                movea.w parent3(a0),a1
                jsr     (Refresh_ChildPositionAdjusted).l
                moveq   #0,d0
                tst.b   subtype(a0)
                beq.s   SSZMTZLaser_InstallLaunchDelay
                moveq   #8,d0
                move.b  #$C,mapping_frame(a0)
                move.w  #$100,priority(a0)

SSZMTZLaser_InstallLaunchDelay:
                move.w  d0,$2E(a0)
                move.l  #SSZMTZLaser_WaitBeforeHorizontalLaunch,(a0)

SSZMTZLaser_WaitBeforeHorizontalLaunch:
                subq.w  #1,$2E(a0)
                bmi.s   SSZMTZLaser_SelectLaunchVelocityFromFlip
                jmp     (Child_Draw_Sprite).l
; ---------------------------------------------------------------------------

SSZMTZLaser_SelectLaunchVelocityFromFlip:
                move.l  #SSZMTZ_LaserMoveTouchAndCull,(a0)
                move.w  #-$400,d0
                btst    #0,render_flags(a0)
                beq.s   SSZMTZ_LaserSetSpeedAndPlaySound
                neg.w   d0

SSZMTZ_LaserSetSpeedAndPlaySound:
                move.w  d0,x_vel(a0)
                moveq   #signextendB(sfx_Laser),d0
                jsr     (Play_SFX).l

SSZMTZ_LaserMoveTouchAndCull:
                jsr     (MoveSprite2).l
                jmp     (Sprite_CheckDeleteTouch).l
; ---------------------------------------------------------------------------
SSZMTZLaser_Attributes:
                dc.l    Map_SSZMTZOrbs
                dc.w    make_art_tile(ArtTile_SSZMTZOrbs,1,1)
                dc.w    $280
                dc.b    $28,   8,  $D, $9C

; =============== S U B R O U T I N E =======================================

; Request an orb at flash count $1F. The player response edits the low nibble of the packed animation command
SSZMTZBoss_CheckHitOrbRelease:
                bsr.w   SSZMTZBoss_HandleHitOrDefeat
                cmpi.b  #$1F,$1C(a0)
                bne.s   SSZMTZ_HitCheckPlayersHurt
                st      $39(a0)
                lea     (SceneTimerOrSharedMotionRecordBase).w,a1
                andi.b  #$F0,2(a1)
                ori.b   #5,2(a1)
                tst.b   $3C(a0)
                beq.s   SSZMTZ_HitStopSharedXSpeed
                move.b  #$A,$26(a0)
                move.w  #-$180,(SSZ_MTZ_boss_Y_vel).w
                subq.b  #1,$3C(a0)
                move.w  #0,(SSZ_MTZ_boss_X_vel).w

SSZMTZ_HitStopSharedXSpeed:
                move.w  #0,(SSZ_MTZ_boss_X_vel).w
                rts
; ---------------------------------------------------------------------------

SSZMTZ_HitCheckPlayersHurt:
                cmpi.b  #4,(Player_1+routine).w
                beq.s   SSZMTZ_HitRequestLegacyAnim
                cmpi.b  #4,(Player_2+routine).w
                bne.s   SSZMTZ_HitPlayerCheckReturn

SSZMTZ_HitRequestLegacyAnim:
                lea     (SceneTimerOrSharedMotionRecordBase).w,a1
                move.b  2(a1),d0
                andi.b  #$F,d0
                cmpi.b  #4,d0
                beq.s   SSZMTZ_HitPlayerCheckReturn
                andi.b  #$F0,2(a1)
                ori.b   #4,2(a1)

SSZMTZ_HitPlayerCheckReturn:
                rts
; End of function SSZMTZBoss_CheckHitOrbRelease

; ---------------------------------------------------------------------------

SSZMTZDefeat_BeginRightwardDeparture:
                move.l  #SSZMTZ_DefeatMoveAndTickExit,(a0)
                bset    #0,render_flags(a0)
                move.w  #$400,x_vel(a0)
                clr.w   y_vel(a0)
                rts
; ---------------------------------------------------------------------------

SSZMTZ_DefeatMoveAndTickExit:
                subq.w  #1,$2E(a0)
                bmi.s   SSZMTZ_DefeatSignalAndRestorePal
                jsr     (MoveSprite2).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SSZMTZ_DefeatSignalAndRestorePal:
                clr.b   (Boss_flag).w
                bset    #4,$38(a0)
                st      (MechaSonicHeadDeleteOrOverlayLowByte).w
                st      (Events_bg+$02).w
                lea     (Target_palette_line_2).w,a1
                lea     (Normal_palette_line_2).w,a2
                moveq   #bytesToLcnt($20),d6

SSZMTZ_DefeatRestoreArtAndDelete:
                move.l  (a1)+,(a2)+
                dbf     d6,SSZMTZ_DefeatRestoreArtAndDelete
                moveq   #PLCID_32,d0
                jsr     (Load_PLC).l
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------
; unused
                move.b  $1D(a0),d0
                jsr     (GetSineCosine).l
                asr.w   #6,d0
                add.w   (SSZ_MTZ_boss_Y_pos).w,d0
                move.w  d0,y_pos(a0)
                move.w  (SSZ_MTZ_boss_X_pos).w,x_pos(a0)
                addq.b  #2,$1D(a0)

; =============== S U B R O U T I N E =======================================

; The recovery timer shares storage with the hitter field. Scored defeat leaves the HUD timer running
SSZMTZBoss_HandleHitOrDefeat:
                cmpi.b  #$10,$26(a0)
                bhs.s   SSZMTZ_HitUpdateReturn
                tst.b   collision_property(a0)
                beq.s   SSZMTZ_BeginDefeatFadeAndExplosion
                tst.b   collision_flags(a0)
                bne.s   SSZMTZ_HitUpdateReturn
                tst.b   $1C(a0)
                bne.s   SSZMTZ_HitChooseFlashOffset
                move.b  #$20,$1C(a0)
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l

SSZMTZ_HitChooseFlashOffset:
                moveq   #0,d0
                btst    #0,$1C(a0)
                bne.s   SSZMTZ_HitCopyColorsAndTick
; Bug: this should be 2*3
                addi.w  #2*2,d0

SSZMTZ_HitCopyColorsAndTick:
                bsr.w   CopySSZMTZThreeColorPaletteAtByteOffset
                subq.b  #1,$1C(a0)
                bne.s   SSZMTZ_HitUpdateReturn
                move.b  #$F,collision_flags(a0)

SSZMTZ_HitUpdateReturn:
                rts
; ---------------------------------------------------------------------------

SSZMTZ_BeginDefeatFadeAndExplosion:
                move.l  #Wait_FadeToLevelMusic,(a0)
                move.l  #SSZMTZDefeat_BeginRightwardDeparture,$34(a0)
                st      (EndingOutcomeOrBossSceneSignals).w
                clr.b   $38(a0)
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild1_Normal).l
                bne.s   SSZMTZDefeat_AwardScoreAndSeedFadeDelay
                move.b  #4,subtype(a1)

SSZMTZDefeat_AwardScoreAndSeedFadeDelay:
                jmp     (BossDefeated).l
; End of function SSZMTZBoss_HandleHitOrDefeat

; =============== S U B R O U T I N E =======================================

CopySSZMTZThreeColorPaletteAtByteOffset:
                lea     SSZMTZHitFlash_PaletteSlotAddresses(pc),a1
                lea     SSZMTZHitFlash_SourceColorWords(pc,d0.w),a2
                jmp     (CopyWordData_3).l
; End of function CopySSZMTZThreeColorPaletteAtByteOffset

; ---------------------------------------------------------------------------
SSZMTZHitFlash_PaletteSlotAddresses:
                dc.w    Normal_palette+$0E, Normal_palette+$1C, Normal_palette+$1E
SSZMTZHitFlash_SourceColorWords:
                dc.w    8,  $866,  $222
                dc.w    $888,  $CCC,  $EEE
; ---------------------------------------------------------------------------

SSZMTZOrb_DispatchState:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  SSZMTZOrb_StateOffsets(pc,d0.w),d1
                jmp     SSZMTZOrb_StateOffsets(pc,d1.w)
; ---------------------------------------------------------------------------
SSZMTZOrb_StateOffsets:
                dc.w    SSZMTZ_InitFirstOrbInPlace-SSZMTZOrb_StateOffsets
                dc.w    SSZMTZ_OrbOrbitAndCheckRelease-SSZMTZOrb_StateOffsets
                dc.w    SSZMTZ_OrbTickFlightTouchDelay-SSZMTZOrb_StateOffsets
                dc.w    SSZMTZ_OrbTickHopTouchDelay-SSZMTZOrb_StateOffsets
                dc.w    SSZMTZ_OrbPopAndDecReleaseCount-SSZMTZOrb_StateOffsets
; ---------------------------------------------------------------------------

SSZMTZ_InitFirstOrbInPlace:
                movea.l a0,a1
                moveq   #7-1,d3
                moveq   #0,d2
                bra.s   SSZMTZ_InitOrbAndContinueRing
; ---------------------------------------------------------------------------

SSZMTZOrbRing_AllocateNextMember:
                jsr     (AllocateObject).l
                bne.s   SSZMTZ_OrbRingInitReturn

SSZMTZ_InitOrbAndContinueRing:
                move.b  #$20,width_pixels(a1)
                move.l  $34(a0),$34(a1)
                move.l  #SSZMTZOrb_DispatchState,(a1)
                move.l  #Map_SSZMTZOrbs,mappings(a1)
                move.w  #make_art_tile(ArtTile_SSZMTZOrbs,0,0),art_tile(a1)
                ori.b   #4,render_flags(a1)
                move.w  #$180,priority(a1)
                addq.b  #2,routine(a1)
                move.b  #0,mapping_frame(a1)
                move.b  SSZMTZOrbRing_InitialPhaseBytes(pc,d2.w),$2E(a1)
                move.b  SSZMTZOrbRing_InitialPhaseBytes(pc,d2.w),$41(a1)
                move.b  SSZMTZOrbRing_AuxiliaryByteInitializers(pc,d2.w),$40(a1)
                move.b  #$40,$2F(a1)
                move.b  #$87,collision_flags(a1)
                move.b  #0,$42(a1)
                addq.w  #1,d2
                dbf     d3,SSZMTZOrbRing_AllocateNextMember

SSZMTZ_OrbRingInitReturn:
                rts
; ---------------------------------------------------------------------------
SSZMTZOrbRing_InitialPhaseBytes:
                dc.b    $24, $6C, $B4, $FC, $48, $90, $D8
SSZMTZOrbRing_AuxiliaryByteInitializers:
                dc.b    0,   1,   1,   0,   1,   1,   0
                even
; ---------------------------------------------------------------------------

SSZMTZ_OrbOrbitAndCheckRelease:
                movea.l $34(a0),a1
                move.w  y_pos(a1),$30(a0)
                subi.w  #4,$30(a0)
                move.w  x_pos(a1),$3E(a0)
                tst.b   $39(a1)
                beq.s   SSZMTZOrb_ProjectSelectDepthAndDrawTouch
                move.b  #0,$39(a1)
                addi.b  #1,$30(a1)
                addq.b  #2,routine(a0)
                move.b  #$3C,$3C(a0)
                move.b  #2,anim(a0)
                move.w  #-$400,y_vel(a0)
                move.w  #-$80,d1
                move.w  (Player_1+x_pos).w,d0
                sub.w   x_pos(a0),d0
                bpl.s   SSZMTZ_OrbClampReleaseDirection
                neg.w   d1

; Force inward velocity outside either edge of the release range
SSZMTZ_OrbClampReleaseDirection:
                cmpi.w  #$16A0,x_pos(a0)
                bhs.s   SSZMTZOrb_ForceReleaseLeftAtRightBound
                move.w  #$80,d1

SSZMTZOrb_ForceReleaseLeftAtRightBound:
                cmpi.w  #$1760,x_pos(a0)
                blo.s   SSZMTZ_OrbFaceReleaseDirection
                move.w  #-$80,d1

SSZMTZ_OrbFaceReleaseDirection:
                bclr    #0,render_flags(a0)
                tst.w   d1
                bmi.s   SSZMTZ_OrbStoreReleaseXSpeed
                bset    #0,render_flags(a0)

SSZMTZ_OrbStoreReleaseXSpeed:
                move.w  d1,x_vel(a0)

SSZMTZOrb_ProjectSelectDepthAndDrawTouch:
                bsr.w   SSZMTZOrb_ProjectOrbitAndFold
                bsr.w   SSZMTZOrb_SelectFrameAndPriority
                jsr     (Add_SpriteToCollisionResponseList).l
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

; Use separate phases for position and depth while updating the shared fold state
SSZMTZOrb_ProjectOrbitAndFold:
                move.b  $2F(a0),d0
                jsr     (GetSineCosine).l
                move.w  d0,d3
                moveq   #0,d1
                move.b  $38(a1),d1
                muls.w  d1,d0
                move.w  d0,d5
                move.w  d0,d4
                move.b  $3A(a1),d2
                tst.b   $3B(a1)
                beq.s   SSZMTZ_OrbProjectXAndDepth
                move.w  #$10,d2

SSZMTZ_OrbProjectXAndDepth:
                muls.w  d3,d2
                move.w  $3E(a0),d6
                move.b  $2E(a0),d0
                jsr     (GetSineCosine).l
                muls.w  d0,d5
                swap    d5
                add.w   d6,d5
                move.w  d5,x_pos(a0)
                muls.w  d1,d4
                swap    d4
                move.w  d4,$3A(a0)
                move.w  $30(a0),d6
                move.b  $41(a0),d0
                tst.b   $3B(a1)
                beq.s   SSZMTZ_OrbProjectYAndAdvancePhase
                move.b  $42(a0),d0

SSZMTZ_OrbProjectYAndAdvancePhase:
                jsr     (GetSineCosine).l
                muls.w  d0,d2
                swap    d2
                add.w   d6,d2
                move.w  d2,y_pos(a0)
                addq.b  #4,$2E(a0)
                tst.b   $3B(a1)
                bne.s   SSZMTZOrbProjection_HandleSharedFoldMode
                addq.b  #8,$41(a0)
                rts
; ---------------------------------------------------------------------------

SSZMTZOrbProjection_HandleSharedFoldMode:
                cmpi.b  #-1,$3B(a1)
                beq.s   SSZMTZOrbProjection_GrowLocalFoldPhase
                cmpi.b  #$80,$3B(a1)
                bne.s   SSZMTZOrbProjection_ClearSharedFoldMode
                subq.b  #2,$42(a0)
                bpl.s   SSZMTZ_OrbProjectionReturn
                clr.b   $42(a0)

SSZMTZOrbProjection_ClearSharedFoldMode:
                move.b  #0,$3B(a1)
                rts
; ---------------------------------------------------------------------------

SSZMTZOrbProjection_GrowLocalFoldPhase:
                cmpi.b  #$40,$42(a0)
                bhs.s   SSZMTZ_OrbProjectionReturn
                addq.b  #2,$42(a0)

SSZMTZ_OrbProjectionReturn:
                rts
; End of function SSZMTZOrb_ProjectOrbitAndFold
