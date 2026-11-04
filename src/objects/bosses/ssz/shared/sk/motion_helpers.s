; Owner: objects/bosses/ssz/shared/sk
; Responsibility: Shared Mecha Sonic movement, collision, pattern, parent-state and palette helper callbacks with private lookup constants
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

SSZScene_ClearP1Velocities:
                lea     (Player_1).w,a1
                clr.w   x_vel(a1)
                clr.w   y_vel(a1)
                clr.w   ground_vel(a1)
                rts
; End of function SSZScene_ClearP1Velocities

; =============== S U B R O U T I N E =======================================

SSZSuperMechaShot_InitEightWayVel:
                moveq   #0,d0
                move.b  subtype(a0),d0
                add.w   d0,d0
                move.l  SSZMecha_RadialShotVelocityPairs(pc,d0.w),x_vel(a0)  ; and y_vel
                rts
; End of function SSZSuperMechaShot_InitEightWayVel

; ---------------------------------------------------------------------------
SSZMecha_RadialShotVelocityPairs:
                dc.w    0,  $400
                dc.w    $2D4,  $2D4
                dc.w    $400,     0
                dc.w    $2D4, -$2D4
                dc.w    0, -$400
                dc.w    -$2D4, -$2D4
                dc.w    -$400,     0
                dc.w    -$2D4,  $2D4

; =============== S U B R O U T I N E =======================================

SSZMechaLaser_SelectAnimAndCallback:
                moveq   #0,d0
                move.b  subtype(a0),d0
                lea     SSZMecha_LaserScriptsAndCallbacks(pc,d0.w),a1
                move.l  (a1)+,$30(a0)
                move.l  (a1)+,$34(a0)
                rts
; End of function SSZMechaLaser_SelectAnimAndCallback

; ---------------------------------------------------------------------------
SSZMecha_LaserScriptsAndCallbacks:
                dc.l    SSZMecha_AimedLaserPrepAnim
                dc.l    SSZMechaLaser_LaunchTowardPlayer
                dc.l    SSZMecha_StationaryLaserDeleteAnim
                dc.l    Go_Delete_Sprite

; =============== S U B R O U T I N E =======================================

; Search the selected zero-terminated region list and return the match result through Z
SSZMecha_TestPlayerAttackRegion:
                bsr.w   SSZMecha_ClassifyPlayerXRegion
                moveq   #0,d0
                move.b  child_dx(a0),d0
                lsl.w   #2,d0
                lea     SSZMecha_AttackRegionRows-4(pc,d0.w),a1

SSZMechaAttackRegionList_ScanForMatch:
                move.b  (a1)+,d1
                beq.s   SSZMecha_AttackRegionMatchReturn
                cmp.b   d1,d2
                bne.s   SSZMechaAttackRegionList_ScanForMatch
                moveq   #1,d0

SSZMecha_AttackRegionMatchReturn:
                rts
; End of function SSZMecha_TestPlayerAttackRegion

; ---------------------------------------------------------------------------
SSZMecha_AttackRegionRows:
                dc.b    1
                dc.b    0
                dc.b    0
                dc.b    0
                dc.b    1
                dc.b    2
                dc.b    0
                dc.b    0
                dc.b    1
                dc.b    2
                dc.b    3
                dc.b    0
                dc.b    4
                dc.b    5
                dc.b    6
                dc.b    0
                dc.b    5
                dc.b    6
                dc.b    0
                dc.b    0
                dc.b    6
                dc.b    0
                dc.b    0
                dc.b    0
                even

; =============== S U B R O U T I N E =======================================

; Use X relative to the camera minimum. Return only classes 1, 2, 3 or 6 in d2 and the side flag in d3.b
SSZMecha_ClassifyPlayerXRegion:
                move.w  (Player_1+x_pos).w,d0
                sub.w   (Camera_min_X_pos).w,d0
                move.w  d0,d1
                subi.w  #$F0,d1
                scc     d3
                bcc.s   SSZMechaPlayerRegion_SelectRightBase
                moveq   #1,d2
                bra.w   SSZMecha_ClassifyPlayerXThresholds
; ---------------------------------------------------------------------------

SSZMechaPlayerRegion_SelectRightBase:
                moveq   #4,d2

SSZMecha_ClassifyPlayerXThresholds:
                cmpi.w  #$50,d0
                blo.s   SSZMecha_PlayerXRegionReturn
                addq.w  #1,d2
                cmpi.w  #$A0,d0
                blo.s   SSZMecha_PlayerXRegionReturn
                addq.w  #1,d2

SSZMecha_PlayerXRegionReturn:
                rts
; End of function SSZMecha_ClassifyPlayerXRegion

; ---------------------------------------------------------------------------

SSZMecha_CheckFacingArenaBound:
                tst.w   x_vel(a0)
                bmi.s   SSZMechaArenaBounds_TestLeftBoundary
                move.w  (_unkFAB6).w,d0
                cmp.w   x_pos(a0),d0
                bls.s   SSZMecha_RunArenaBoundCallback
                rts
; ---------------------------------------------------------------------------

SSZMechaArenaBounds_TestLeftBoundary:
                move.w  (_unkFAB4).w,d0
                cmp.w   x_pos(a0),d0
                bhs.s   SSZMecha_RunArenaBoundCallback
                rts
; ---------------------------------------------------------------------------

SSZMecha_RunArenaBoundCallback:
                jmp     (a1)

; =============== S U B R O U T I N E =======================================

SSZMechaTrail_InitOffsetsAndPriority:
                moveq   #0,d0
                move.b  subtype(a0),d0
                add.w   d0,d0
                lea     SSZMecha_RollTrailOffsetPriority(pc,d0.w),a1
                move.w  (a1)+,child_dx(a0)              ; and child_dy
                move.w  (a1)+,priority(a0)
                rts
; End of function SSZMechaTrail_InitOffsetsAndPriority

; ---------------------------------------------------------------------------
SSZMecha_RollTrailOffsetPriority:
                dc.b    -4, $1C
                dc.w    $300
                dc.b    8, $1C
                dc.w    $200
                dc.b    -8, $1C
                dc.w    $200
                dc.b    4, $1C
                dc.w    $300
                dc.b    $C,  $C
                dc.w    $200

; =============== S U B R O U T I N E =======================================

SSZMechaProxy_SetFromParentFrame:
                lea     SSZMechaCollisionProxy_ParentFrameRows(pc),a1
                movea.w parent3(a0),a2
                moveq   #0,d0
                move.b  mapping_frame(a2),d0
                lsl.w   #2,d0
                adda.w  d0,a1
                move.w  (a1)+,child_dx(a0)              ; and child_dy
                move.b  (a1)+,collision_flags(a0)
                move.b  (a1)+,mapping_frame(a0)
                rts
; End of function SSZMechaProxy_SetFromParentFrame

; ---------------------------------------------------------------------------
SSZMechaCollisionProxy_ParentFrameRows:
                dc.b    $10, -$C, $B4,   2
                dc.b    $10,  -4, $B4,   2
                dc.b    $10,   0, $B4,   2
                dc.b    0,   0,   0,   0
                dc.b    0,   0,   0,   0
                dc.b    0,   0,   0,   0
                dc.b    0,   0,   0,   0
                dc.b    $14,  -8, $9E,   1
                dc.b    $10, -$C, $9E,   1
                dc.b    $C,-$14, $98,   0
                dc.b    0,-$14, $B3,   8
                dc.b    -$C,-$14, $98,   0
                dc.b    -$10, -$C, $B4,   2
                dc.b    $10, -$C, $B4,   2
                dc.b    $10,   4, $B4,   2
                dc.b    $14,  $C, $B4,   2
                dc.b    $17,   5, $B4,   2
                dc.b    $10, -$C, $B4,   2
                dc.b    $C, -$C, $9E,   1
                dc.b    $10, -$C, $B4,   2
                dc.b    $10, -$C, $B4,   2
                dc.b    $10, -$C, $B4,   2
                even

; =============== S U B R O U T I N E =======================================

; Skip collision updates during hit recovery. The caller can request the forced-harmful type
SSZMecha_TrySetCollisionFromFrame:
                btst    #6,status(a0)
                bne.s   SSZMecha_FrameCollisionReturn
                moveq   #0,d0
                move.b  mapping_frame(a0),d0
                move.b  SSZMecha_CollisionFlagsByFrame(pc,d0.w),d0
                btst    #7,$38(a0)
                beq.s   SSZMecha_StoreFrameCollisionFlags
                ori.b   #$80,d0

SSZMecha_StoreFrameCollisionFlags:
                move.b  d0,collision_flags(a0)

SSZMecha_FrameCollisionReturn:
                rts
; End of function SSZMecha_TrySetCollisionFromFrame

; ---------------------------------------------------------------------------
SSZMecha_CollisionFlagsByFrame:
                dc.b    $23
                dc.b    $23
                dc.b    9
                dc.b    $86
                dc.b    $86
                dc.b    $86
                dc.b    $86
                dc.b    $1A
                dc.b    $23
                dc.b    $23
                dc.b    $23
                dc.b    $23
                dc.b    $23
                dc.b    $23
                dc.b    9
                dc.b    0
                dc.b    9
                dc.b    $23
                dc.b    6
                dc.b    $23
                dc.b    $23
                dc.b    $23
                even

; =============== S U B R O U T I N E =======================================

; At zero HP, tail-call the defeat handler in a4. The five-color flash retains its shifted palette offset
SSZMecha_HandleHitFlashOrDefeat:
                tst.b   collision_flags(a0)
                bne.s   SSZMechaHitFlash_ReturnFromRecovery
                move.b  collision_property(a0),d0
                beq.s   SSZMecha_RunDefeatCallback
                tst.b   $20(a0)
                bne.s   SSZMecha_HitChooseFlashOffset
                move.b  #$20,$20(a0)
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l
                bset    #6,status(a0)

SSZMecha_HitChooseFlashOffset:
                moveq   #0,d0
                btst    #0,$20(a0)
                bne.s   SSZMecha_HitCopyColorsAndTick
; Bug: this should be 2*5
                addi.w  #2*4,d0

SSZMecha_HitCopyColorsAndTick:
                bsr.w   CopySSZMechaFiveColorPaletteAtByteOffset
                subq.b  #1,$20(a0)
                bne.s   SSZMechaHitFlash_ReturnFromRecovery
                bclr    #6,status(a0)

SSZMechaHitFlash_ReturnFromRecovery:
                rts
; ---------------------------------------------------------------------------

SSZMecha_RunDefeatCallback:
                jmp     (a4)
; End of function SSZMecha_HandleHitFlashOrDefeat

; =============== S U B R O U T I N E =======================================

; Switch the root to the shared post-battle controller, award score, stop the timer and try to spawn an explosion
SSZMecha_BeginScoredDefeatScene:
                move.l  #SSZMecha_DefeatDispatchAndDraw,(a0)
                clr.b   routine(a0)
                move.l  #SSZMechaPostBattle_BeginDefeatFall,$34(a0)
                bset    #6,status(a0)
                clr.b   (Update_HUD_timer).w
                move.w  #$7F,$2E(a0)
                moveq   #100,d0
                jsr     (HUD_AddToScore).l
                bclr    #7,render_flags(a0)
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     CreateChild1_Normal(pc)
                bne.s   SSZMecha_DefeatExplosionSpawnReturn
                move.b  #4,subtype(a1)

SSZMecha_DefeatExplosionSpawnReturn:
                rts
; End of function SSZMecha_BeginScoredDefeatScene

; ---------------------------------------------------------------------------

SSZMecha_FreezeCameraAndRestorePal:
                bset    #7,$38(a0)
                bsr.s   SSZMecha_BeginScoredDefeatScene
                move.w  (Camera_X_pos).w,d0
                move.w  d0,(Camera_min_X_pos).w
                move.w  d0,(Camera_max_X_pos).w
                lea     (Pal_SSZGHZMisc).l,a1
                jmp     (PalLoad_Line1).l

; =============== S U B R O U T I N E =======================================

CopySSZMechaFiveColorPaletteAtByteOffset:
                lea     SSZMecha_HitPaletteDestinations(pc),a1
                lea     SSZMechaHitFlash_SourceColorWords(pc,d0.w),a2
                jmp     (CopyWordData_5).l
; End of function CopySSZMechaFiveColorPaletteAtByteOffset

; ---------------------------------------------------------------------------
SSZMecha_HitPaletteDestinations:
                dc.w    Normal_palette_line_2+$08, Normal_palette_line_2+$14, Normal_palette_line_2+$16, Normal_palette_line_2+$18, Normal_palette_line_2+$1C
SSZMechaHitFlash_SourceColorWords:
                dc.w    8,  $A24,  $624,  $422,   $20
                dc.w    $888,  $666,  $888,  $AAA,  $EEE
