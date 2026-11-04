; Owner: objects/bosses/hcz/end_boss/sk
; Responsibility: Hydrocity end-boss child priority, motion, palette, collision, callback and debris helpers with their private indexed tables
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

SetHCZBossBombStackPriority:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  HCZBossSK_BombStackPriorities(pc,d0.w),priority(a0)
                rts
; End of function SetHCZBossBombStackPriority

; ---------------------------------------------------------------------------
HCZBossSK_BombStackPriorities:
                dc.w    $280
                dc.w    $200
                dc.w    $180
; ---------------------------------------------------------------------------

HCZBossSK_BombLoadCompactionSteps:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  HCZBossSK_BombPackedCompactionSteps(pc,d0.w),$40(a0)
                rts
; ---------------------------------------------------------------------------
HCZBossSK_BombPackedCompactionSteps:
                dc.w    $101
                dc.w    $100

; =============== S U B R O U T I N E =======================================

SynchronizeHCZBossVortexHeightVisual:
                movea.w parent3(a0),a1
                moveq   #0,d0
                move.b  $39(a1),d0
                cmp.b   $39(a0),d0
                beq.s   HCZBossSK_VortexHeightSyncReturn
                move.b  d0,$39(a0)
                move.b  HCZBossSK_VortexHeightYOffsets+1(pc,d0.w),d1
                ext.w   d1
                move.w  (Water_level).w,d2
                add.w   d1,d2
                move.w  d2,y_pos(a0)
                lsl.w   #2,d0
                move.l  HCZBossSK_VortexAnimationsByHeight(pc,d0.w),$30(a0)
                clr.b   anim_frame_timer(a0)

HCZBossSK_VortexHeightSyncReturn:
                rts
; End of function SynchronizeHCZBossVortexHeightVisual

; ---------------------------------------------------------------------------
; The final bytes preserve the original instruction tail after the offset data
HCZBossSK_VortexHeightYOffsets:
                dc.b    -8
                dc.b    -8
                dc.b    -$10
                dc.b    -$18
                dc.b    -$20
                dc.b    -$28
                dc.b    -$28
                dc.b    0
                dc.b    0
                dc.b    6
                dc.b    -$42
                dc.b    $19
                even
HCZBossSK_VortexAnimationsByHeight:
                dc.l    HCZBossSK_VortexHeight0Anim
                dc.l    HCZBossSK_VortexHeight1Anim
                dc.l    HCZBossSK_VortexHeight2Anim
                dc.l    HCZBossSK_VortexHeight3Anim
                dc.l    HCZBossSK_VortexHeight4And5Anim
                dc.l    HCZBossSK_VortexHeight4And5Anim

; =============== S U B R O U T I N E =======================================

ConfigureHCZBossGeyserLayerFromSubtype:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  d0,$2E(a0)
                move.w  HCZBossSK_GeyserLayerYOffsets(pc,d0.w),d1
                move.w  (Water_level).w,d2
                add.w   d1,d2
                move.w  d2,y_pos(a0)
                add.w   d0,d0
                move.l  HCZBossSK_GeyserLayerAnimationPointers(pc,d0.w),$30(a0)
                rts
; End of function ConfigureHCZBossGeyserLayerFromSubtype

; ---------------------------------------------------------------------------
HCZBossSK_GeyserLayerYOffsets:
                dc.w    -8
                dc.w    -$18
                dc.w    -$28
                dc.w    -$38
                dc.w    -$48
HCZBossSK_GeyserLayerAnimationPointers:
                dc.l    HCZBossSK_GeyserLayer0Anim
                dc.l    HCZBossSK_GeyserLayer1Anim
                dc.l    HCZBossSK_GeyserLayer2Anim
                dc.l    HCZBossSK_GeyserLayer3Anim
                dc.l    HCZBossSK_GeyserLayer4Anim

; =============== S U B R O U T I N E =======================================

PullBothPlayersTowardHCZBossVortex:
                move.w  x_pos(a0),d0
                move.w  (Water_level).w,d1
                addq.w  #8,d1
                move.l  #$20000,d2
                lea     (Player_1).w,a1
                bsr.w   PullDeepPlayerWithHCZVortexDisplacement
                lea     (Player_2).w,a1
; End of function PullBothPlayersTowardHCZBossVortex

; =============== S U B R O U T I N E =======================================

PullDeepPlayerWithHCZVortexDisplacement:
                tst.b   object_control(a1)
                bne.s   HCZBossSK_VortexPullReturn
                cmp.w   y_pos(a1),d1
                bhs.s   HCZBossSK_VortexPullReturn
                cmp.w   x_pos(a1),d0
                bhs.s   HCZBossSK_VortexApplyPullToPlayerX
                neg.l   d2

HCZBossSK_VortexApplyPullToPlayerX:
                add.l   d2,x_pos(a1)

HCZBossSK_VortexPullReturn:
                rts
; End of function PullDeepPlayerWithHCZVortexDisplacement

; =============== S U B R O U T I N E =======================================

CaptureBothPlayersInHCZBossVortex:
                movea.w parent3(a0),a1
                moveq   #0,d0
                move.b  $39(a1),d0
                lsl.w   #2,d0
                lea     HCZBossSK_VortexCaptureBoundsByHeight(pc),a1
                lea     (a1,d0.w),a1
                moveq   #$42,d4
                lea     (Player_1).w,a2
                bsr.w   CaptureAndLiftPlayerInHCZBossVortex
                moveq   #$43,d4
                lea     (Player_2).w,a2
; End of function CaptureBothPlayersInHCZBossVortex

; =============== S U B R O U T I N E =======================================

CaptureAndLiftPlayerInHCZBossVortex:
                movea.w parent3(a0),a3
                btst    #7,status(a3)
                bne.w   ReleasePlayerFromHCZBossVortex
                cmpi.b  #6,routine(a2)
                bhs.w   HCZBossSK_VortexReleaseInvalidPlayer
                tst.b   invulnerability_timer(a2)
                bne.w   HCZBossSK_VortexReleaseInvalidPlayer
                tst.b   object_control(a2)
                beq.s   HCZBossSK_VortexCheckCaptureBounds
                tst.b   (a0,d4.w)
                bne.s   HCZBossSK_VortexCheckHeldPlayer

HCZBossSK_VortexCheckCaptureBounds:
                move.w  y_pos(a0),d0
                move.w  y_pos(a2),d2
                add.w   (a1),d0
                cmp.w   d0,d2
                blo.w   HCZBossSK_VortexCaptureReturn
                add.w   2(a1),d0
                cmp.w   d0,d2
                bhs.w   HCZBossSK_VortexCaptureReturn
                move.w  x_pos(a0),d0
                move.w  x_pos(a2),d2
                sub.w   d2,d0
                addi.w  #$10,d0
                cmpi.w  #$20,d0
                bhs.w   HCZBossSK_VortexCaptureReturn
                tst.b   object_control(a2)
                bne.s   HCZBossSK_VortexCheckHeldPlayer
                bsr.w   InitializeHCZBossVortexPlayerCapture

HCZBossSK_VortexCheckHeldPlayer:
                move.w  y_pos(a0),d0
                move.w  y_pos(a2),d2
                add.w   (a1)+,d0
                cmp.w   d0,d2
                blo.w   ReleasePlayerFromHCZBossVortex
                move.w  x_pos(a2),d0
                move.w  x_vel(a2),d1
                move.w  #$80,d2
                sub.w   x_pos(a0),d0
                cmpi.w  #-$12,d0
                ble.s   ReleasePlayerFromHCZBossVortex
                cmpi.w  #$12,d0
                bge.s   ReleasePlayerFromHCZBossVortex
                tst.w   d0
                bmi.s   HCZBossSK_VortexMoveAndLiftPlayer
                neg.w   d2

HCZBossSK_VortexMoveAndLiftPlayer:
                add.w   d2,d1
                move.w  d1,x_vel(a2)
                ext.l   d1
                lsl.l   #8,d1
                add.l   d1,x_pos(a2)
                subq.w  #2,y_pos(a2)
                rts
; ---------------------------------------------------------------------------

HCZBossSK_VortexReleaseInvalidPlayer:
                jsr     (Displace_PlayerOffObject).l
                clr.b   (a0,d4.w)
                clr.b   object_control(a2)
                rts
; End of function CaptureAndLiftPlayerInHCZBossVortex

; ---------------------------------------------------------------------------
HCZBossSK_VortexCaptureBoundsByHeight:
                dc.w    -$18,   $48
                dc.w    -$20,   $58
                dc.w    -$28,   $68
                dc.w    -$30,   $78
                dc.w    -$38,   $88
                dc.w    -$48,   $88

; =============== S U B R O U T I N E =======================================

InitializeHCZBossVortexPlayerCapture:
                st      (a0,d4.w)
                bset    #Status_InAir,status(a2)
                move.b  #1,object_control(a2)
                move.b  #$18,anim(a2)
                clr.b   spin_dash_flag(a2)
                clr.w   x_vel(a2)
                clr.w   y_vel(a2)
                clr.w   ground_vel(a2)

HCZBossSK_VortexCaptureReturn:
                rts
; End of function InitializeHCZBossVortexPlayerCapture

; =============== S U B R O U T I N E =======================================

ReleasePlayerFromHCZBossVortex:
                clr.b   (a0,d4.w)
                bset    #Status_InAir,status(a2)
                clr.b   object_control(a2)
                move.b  #2,anim(a2)
                move.w  #-$200,y_vel(a2)
                rts
; End of function ReleasePlayerFromHCZBossVortex

; ---------------------------------------------------------------------------

HCZBossSK_VortexReleaseTrackedP1:
                tst.b   $42(a0)
                beq.s   HCZBossSK_VortexReleaseTrackedP2
                clr.b   $42(a0)
                lea     (Player_1).w,a2
                bsr.s   ReleasePlayerFromHCZBossVortex

HCZBossSK_VortexReleaseTrackedP2:
                tst.b   $43(a0)
                beq.s   HCZBossSK_VortexReleaseReturn
                clr.b   $43(a0)
                lea     (Player_2).w,a2
                bsr.s   ReleasePlayerFromHCZBossVortex

HCZBossSK_VortexReleaseReturn:
                rts

; =============== S U B R O U T I N E =======================================

ApplyHCZBossGeyserToBothPlayers:
                cmpi.b  #$30,anim_frame(a0)
                bhs.s   HCZBossSK_GeyserLaunchReturn
                lea     HCZBossSK_GeyserLaunchBounds(pc),a1
                lea     (Player_1).w,a2
                bsr.w   LaunchPlayerInsideHCZBossGeyserRectangle
                lea     HCZBossSK_GeyserLaunchBounds(pc),a1
                lea     (Player_2).w,a2
; End of function ApplyHCZBossGeyserToBothPlayers

; =============== S U B R O U T I N E =======================================

LaunchPlayerInsideHCZBossGeyserRectangle:
                tst.b   object_control(a2)
                bne.s   HCZBossSK_GeyserLaunchReturn
                move.w  x_pos(a0),d0
                move.w  x_pos(a2),d1
                add.w   (a1)+,d0
                cmp.w   d0,d1
                blo.s   HCZBossSK_GeyserLaunchReturn
                add.w   (a1)+,d0
                cmp.w   d0,d1
                bhs.s   HCZBossSK_GeyserLaunchReturn
                move.w  y_pos(a0),d0
                move.w  y_pos(a2),d1
                add.w   (a1)+,d0
                cmp.w   d0,d1
                blo.s   HCZBossSK_GeyserLaunchReturn
                add.w   (a1)+,d0
                cmp.w   d0,d1
                bhs.s   HCZBossSK_GeyserLaunchReturn
                move.w  #-$800,y_vel(a2)

HCZBossSK_GeyserLaunchReturn:
                rts
; End of function LaunchPlayerInsideHCZBossGeyserRectangle

; ---------------------------------------------------------------------------
HCZBossSK_GeyserLaunchBounds:
                dc.w    -$C,   $18
                dc.w    -$38,   $40

; =============== S U B R O U T I N E =======================================

AccelerateHCZBossBubbleTowardParentX:
                movea.w parent3(a0),a1
                move.w  x_pos(a0),d0
                move.w  x_vel(a0),d1
                move.w  #$80,d2
                sub.w   x_pos(a1),d0
                tst.w   d0
                bmi.s   HCZBossSK_BubbleIntegrateCenterX
                neg.w   d2

HCZBossSK_BubbleIntegrateCenterX:
                add.w   d2,d1
                move.w  d1,x_vel(a0)
                ext.l   d1
                lsl.l   #8,d1
                add.l   d1,x_pos(a0)
                rts
; End of function AccelerateHCZBossBubbleTowardParentX

; =============== S U B R O U T I N E =======================================

; The 32-update flash changes three colors. Defeat installs the wait handler for this engine
HCZBoss_HandleHitFlashOrDefeat:
                tst.l   (a0)
                beq.s   HCZBossSK_HitUpdateReturn
                tst.b   collision_flags(a0)
                bne.s   HCZBossSK_HitUpdateReturn
                tst.b   collision_property(a0)
                beq.s   HCZBossSK_BeginScoredDefeatWait
                tst.b   $20(a0)
                bne.s   HCZBossSK_HitChooseFlashRow
                move.b  #$20,$20(a0)
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l

HCZBossSK_HitChooseFlashRow:
                bset    #6,status(a0)
                moveq   #0,d0
                btst    #0,$20(a0)
                bne.s   HCZBossSK_HitCopyColorsAndTick
                addq.w  #2*3,d0

HCZBossSK_HitCopyColorsAndTick:
                lea     HCZBossSK_HitPaletteDestinations(pc),a1
                lea     HCZEndBossSK_Hit_TwoThreeColorFlashBanks(pc,d0.w),a2
                jsr     (CopyWordData_3).l
                subq.b  #1,$20(a0)
                bne.s   HCZBossSK_HitUpdateReturn
                bclr    #6,status(a0)
                move.b  $25(a0),collision_flags(a0)

HCZBossSK_HitUpdateReturn:
                rts
; ---------------------------------------------------------------------------

HCZBossSK_BeginScoredDefeatWait:
                move.l  #Wait_FadeToLevelMusic,(a0)
                move.l  #HCZBossSK_BeginDefeatBreakaway,$34(a0)
                jmp     (BossDefeated_StopTimer).l
; End of function HCZBoss_HandleHitFlashOrDefeat

; ---------------------------------------------------------------------------
HCZBossSK_HitPaletteDestinations:
                dc.w    Normal_palette_line_2+$14, Normal_palette_line_2+$16, Normal_palette_line_2+$1C
HCZEndBossSK_Hit_TwoThreeColorFlashBanks:
                dc.w    6,   $20,  $624
                dc.w    $EEE,  $EEE,  $EEE

; =============== S U B R O U T I N E =======================================

StartHCZBossColumnDescentAfterRootDeath:
                movea.w $44(a0),a1
                btst    #7,status(a1)
                beq.s   HCZBossSK_ColumnDeathCheckReturn
                bset    #7,status(a0)
                move.l  #HCZBossSK_ColumnDescendOnBossDeath,(a0)
                move.w  #$100,y_vel(a0)
                move.l  #Go_Delete_Sprite_2,$34(a0)
                jsr     (Displace_PlayerOffObject).l

HCZBossSK_ColumnDeathCheckReturn:
                rts
; End of function StartHCZBossColumnDescentAfterRootDeath

; =============== S U B R O U T I N E =======================================

MarkHCZBossVortexDetachedWhenColumnDies:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                beq.s   HCZBossSK_VortexDeathCheckReturn
                bset    #7,status(a0)
                move.b  #4,routine(a0)

HCZBossSK_VortexDeathCheckReturn:
                rts
; End of function MarkHCZBossVortexDetachedWhenColumnDies

; =============== S U B R O U T I N E =======================================

; Publish the height bucket and run the callback when below the base or at the ascent threshold
HCZBossColumn_UpdateHeight:
                move.w  $3A(a0),d0
                sub.w   y_pos(a0),d0
                bcs.s   HCZBossSK_ColumnRunHeightCallback
                andi.w  #$F0,d0
                lsr.w   #4,d0
                move.b  d0,$39(a0)
                tst.w   y_vel(a0)
                bpl.s   HCZBossSK_ColumnHeightUpdateReturn
                cmpi.b  #5,d0
                bhs.s   HCZBossSK_ColumnRunHeightCallback

HCZBossSK_ColumnHeightUpdateReturn:
                rts
; ---------------------------------------------------------------------------

HCZBossSK_ColumnRunHeightCallback:
                movea.l $34(a0),a2
                jmp     (a2)
; End of function HCZBossColumn_UpdateHeight

; ---------------------------------------------------------------------------

HCZBossSK_ExitDebrisInitEightPieces:
                lea     (SKHCZWater_VerticalDebrisRecords).l,a3
                move.w  x_pos(a0),d2
                move.w  y_pos(a0),d3
                subi.w  #$80,d3
                moveq   #8-1,d1

HCZBossSK_ExitDebrisAllocatePiece:
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   HCZBossSK_ExitDebrisSpawnReturn
                move.l  #SKHCZWater_AnimateAirborneDebris,(a1)
                move.l  #Map_HCZWaterWallDebris,mappings(a1)
                move.w  #make_art_tile(ArtTile_HCZCutsceneGeyser+$58,2,0),art_tile(a1)
                move.b  #$84,render_flags(a1)
                move.b  (a3)+,d0
                ext.w   d0
                add.w   d2,d0
                move.w  d0,x_pos(a1)
                move.b  (a3)+,d0
                ext.w   d0
                add.w   d3,d0
                move.w  d0,y_pos(a1)
                move.w  #$280,priority(a1)
                move.b  #$18,width_pixels(a1)
                move.b  #$18,height_pixels(a1)
                move.w  (a3)+,x_vel(a1)
                move.w  (a3)+,y_vel(a1)
                move.b  d1,mapping_frame(a1)
                dbf     d1,HCZBossSK_ExitDebrisAllocatePiece

HCZBossSK_ExitDebrisSpawnReturn:
                rts
