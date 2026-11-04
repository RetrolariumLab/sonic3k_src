; Owner: objects/bosses/dez/final_boss/sk
; Responsibility: Death Egg final-boss escape ship state, defeat explosions, debris actors and end-of-scene progression
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

DEZFinal_EscapeDispatchHitAndDraw:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  DEZEscapeShip_StateOffsets(pc,d0.w),d1
                jsr     DEZEscapeShip_StateOffsets(pc,d1.w)
                jsr     (UpdateDEZEscapeShipHitFlashAndDefeatWait).l
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------
DEZEscapeShip_StateOffsets:
                dc.w    DEZFinal_InitEscapeShipAndHealth-DEZEscapeShip_StateOffsets
                dc.w    DEZFinal_RiseToEscapeCameraBand-DEZEscapeShip_StateOffsets
                dc.w    DEZFinal_RunAheadAndBeginSwing-DEZEscapeShip_StateOffsets
                dc.w    DEZFinal_SwingMoveAndWaitPursuit-DEZEscapeShip_StateOffsets
                dc.w    DEZFinal_MoveCameraAndSlowShip-DEZEscapeShip_StateOffsets
; ---------------------------------------------------------------------------

DEZFinal_InitEscapeShipAndHealth:
                lea     DEZFinalEscapeShip_Attributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                bset    #0,render_flags(a0)
                move.b  #$F,collision_flags(a0)
                move.b  #8,collision_property(a0)
                move.w  (Camera_X_pos_copy).w,d0
                addi.w  #$60,d0
                move.w  d0,x_pos(a0)
                move.w  (Camera_Y_pos_copy).w,d0
                addi.w  #$140,d0
                move.w  d0,y_pos(a0)
                jsr     (AllocateObject).l
                bne.s   DEZFinal_SpawnEscapeAttachments
                move.l  #SKLevel_InitializeScreenShakeRumbleActor,(a1)

DEZFinal_SpawnEscapeAttachments:
                lea     (Child1_MakeRoboHead3).l,a2
                jsr     CreateChild1_Normal(pc)
                lea     DEZFinal_EscapeCraneAndEmeraldChildren(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

DEZFinal_RiseToEscapeCameraBand:
                subq.w  #1,y_pos(a0)
                move.w  (Camera_Y_pos).w,d0
                addi.w  #$50,d0
                cmp.w   y_pos(a0),d0
                blo.w   DEZFinalAttackActors_SharedReturn
                move.b  #4,routine(a0)
                move.w  #$500,x_vel(a0)
                lea     (Child1_MakeRoboShipFlame).l,a2
                jsr     CreateChild1_Normal(pc)
                jmp     (Swing_Setup1).l
; ---------------------------------------------------------------------------

DEZFinal_RunAheadAndBeginSwing:
                bsr.w   DEZEscape_AccelAndLockCameraX
                jsr     Swing_UpAndDown(pc)
                jsr     (MoveSprite2).l
                move.w  (Camera_X_pos).w,d0
                addi.w  #$100,d0
                cmp.w   x_pos(a0),d0
                bhi.s   DEZFinal_EscapeIntroRunReturn
                move.b  #6,routine(a0)
                clr.w   x_vel(a0)
                move.w  #$1F,$2E(a0)
                move.l  #DEZFinal_BeginEscapePursuit,$34(a0)

DEZFinal_EscapeIntroRunReturn:
                rts
; ---------------------------------------------------------------------------

DEZFinal_SwingMoveAndWaitPursuit:
                bsr.w   DEZEscape_TryFallingDebrisEvery16
                jsr     Swing_UpAndDown(pc)
                jsr     (MoveSprite2).l
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

DEZFinal_BeginEscapePursuit:
                move.b  #8,routine(a0)
                move.w  #$500,x_vel(a0)
                bset    #7,$38(a0)
                rts
; ---------------------------------------------------------------------------

DEZFinal_MoveCameraAndSlowShip:
                bsr.w   DEZEscape_AccelAndLockCameraX
                bsr.w   DEZEscape_TryFallingDebrisEvery16
                jsr     Swing_UpAndDown(pc)
                move.w  x_vel(a0),d0
                cmpi.w  #$280,d0
                bls.s   DEZFinal_MoveShipAndClampMinX
                subi.w  #$10,d0
                move.w  d0,x_vel(a0)

DEZFinal_MoveShipAndClampMinX:
                jsr     (MoveSprite2).l
                move.w  (Camera_X_pos).w,d0
                addi.w  #$100,d0
                cmp.w   x_pos(a0),d0
                bls.s   DEZFinal_PursuitPositionReturn
                move.w  d0,x_pos(a0)

DEZFinal_PursuitPositionReturn:
                rts
; ---------------------------------------------------------------------------

DEZFinal_SignalFirstEscapeDefeat:
                bset    #3,(_unkFAB8).w
                move.w  #$F,$2E(a0)
                move.l  #DEZFinal_SignalSecondEscapeDefeat,$34(a0)
                rts
; ---------------------------------------------------------------------------

DEZFinal_SignalSecondEscapeDefeat:
                move.l  #DEZFinal_DepartToExplosionGate,(a0)
                bset    #4,(_unkFAB8).w
                rts
; ---------------------------------------------------------------------------

DEZFinal_DepartToExplosionGate:
                jsr     Swing_UpAndDown(pc)
                jsr     (MoveSprite2).l
                move.w  (Camera_X_pos).w,d0
                addi.w  #$180,d0
                cmp.w   x_pos(a0),d0
                blo.s   DEZFinal_BeginExplosionSweep
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

DEZFinal_BeginExplosionSweep:
                move.l  #DEZFinal_InitSweepAndTryEmitterOne,(a0)
                bset    #5,(_unkFAB8).w
                ori.b   #$30,$38(a0)
                jsr     (AllocateObject).l
                bne.s   DEZFinal_QueueEscapeExplosionArt
                move.l  #SKLevel_InitializeScreenShakeRumbleActor,(a1)

DEZFinal_QueueEscapeExplosionArt:
                lea     (ArtKosM_BadnikExplosion).l,a1
                move.w  #tiles_to_bytes(ArtTile_Explosion),d2
                jmp     (Queue_Kos_Module).l
; ---------------------------------------------------------------------------

DEZFinal_InitSweepAndTryEmitterOne:
                move.l  #DEZFinal_AdvanceSweepAndTryWhiteFade,(a0)
                clr.b   $38(a0)
                move.w  (Camera_X_pos).w,d0
                subi.w  #$80,d0
                move.w  d0,x_pos(a0)
                move.w  (Camera_Y_pos).w,d0
                addi.w  #$80,d0
                move.w  d0,y_pos(a0)
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild6_Simple).l
                bne.s   DEZFinal_TrySweepEmitterTwo
                move.b  #$16,subtype(a1)

DEZFinal_TrySweepEmitterTwo:
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild6_Simple).l
                bne.s   DEZFinal_TrySweepEmitterThree
                move.b  #$16,subtype(a1)

DEZFinal_TrySweepEmitterThree:
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild6_Simple).l
                bne.s   DEZFinal_TrySweepEmitterFour
                move.b  #$18,subtype(a1)

DEZFinal_TrySweepEmitterFour:
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild6_Simple).l
                bne.s   DEZFinal_SweepEmitterSpawnReturn
                move.b  #$18,subtype(a1)

DEZFinal_SweepEmitterSpawnReturn:
                rts
; ---------------------------------------------------------------------------

DEZFinal_AdvanceSweepAndTryWhiteFade:
                addq.w  #2,x_pos(a0)
                move.w  (Camera_X_pos).w,d0
                addi.w  #$80,d0
                cmp.w   x_pos(a0),d0
                bhs.s   DEZFinal_WhiteFadeSetupReturn
                move.l  #DEZFinal_WaitFadeSaveAndRoute,(a0)
                jsr     (AllocateObject).l
                bne.s   DEZFinal_WhiteFadeSelectForcedSlot
                move.l  #SKPalEffect_InitWhiteAndLockRotation,(a1)
                move.w  a1,$44(a0)
                move.w  #3,$3A(a1)
                rts
; ---------------------------------------------------------------------------

; Fall back to fixed object slot 61 when allocation fails
DEZFinal_WhiteFadeSelectForcedSlot:
                lea     (Dynamic_object_RAM+(object_size*61)).w,a1
                movea.l a1,a2
                moveq   #0,d0
                moveq   #bytesToWcnt(object_size),d1

DEZFinal_WhiteFadeInitForcedSlot:
                move.w  d0,(a1)+
                dbf     d1,DEZFinal_WhiteFadeInitForcedSlot
                move.l  #SKPalEffect_InitWhiteAndLockRotation,(a2)
                move.w  a2,$44(a0)
                move.w  #3,$3A(a2)

DEZFinal_WhiteFadeSetupReturn:
                rts
; ---------------------------------------------------------------------------

DEZFinal_WaitFadeSaveAndRoute:
                movea.w $44(a0),a1
                btst    #7,status(a1)
                beq.s   DEZFinal_EscapeCompletionReturn
                st      (SRAM_mask_interrupts_flag).w
                jsr     (SaveGame).l
                jsr     (Go_Delete_Sprite).l
                cmpi.w  #2,(Player_mode).w
                bhs.s   DEZFinal_RouteToNextLevelOrSega
                cmpi.b  #7,(Chaos_emerald_count).w
                bne.s   DEZFinal_RouteToNextLevelOrSega
                move.w  #$C00,d0
                jmp     (StartNewLevel).l
; ---------------------------------------------------------------------------

DEZFinal_RouteToNextLevelOrSega:
                cmpi.w  #3,(Player_mode).w
                beq.s   DEZFinal_ReturnToSegaScreen
                move.w  #$D01,d0
                jmp     (StartNewLevel).l
; ---------------------------------------------------------------------------

DEZFinal_ReturnToSegaScreen:
                move.b  #GameMode_SegaScreen,(Game_mode).w

DEZFinal_EscapeCompletionReturn:
                rts
; ---------------------------------------------------------------------------

DEZFinal_InitEscapeDebris:
                lea     DEZFinalEscapeFallingDebris_Attributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #DEZFinal_EscapeDebrisFallAndCull,(a0)
                jsr     (Random_Number).l
                move.w  #0,priority(a0)
                tst.w   d0
                bpl.s   DEZFinal_RandomizeDebrisPoseAndFall
                move.w  #$300,priority(a0)

DEZFinal_RandomizeDebrisPoseAndFall:
                andi.w  #$1FF,d0
                move.w  (Camera_X_pos).w,d1
                add.w   d0,d1
                addi.w  #$20,d1
                move.w  d1,x_pos(a0)
                move.w  (Camera_Y_pos).w,d1
                subi.w  #$20,d1
                move.w  d1,y_pos(a0)
                andi.b  #3,d0
                or.b    d0,render_flags(a0)
                swap    d0
                move.w  d0,d1
                andi.w  #3,d0
                lea     DEZFinal_EscapeDebrisFrames(pc,d0.w),a1
                move.b  (a1)+,mapping_frame(a0)
                andi.w  #$300,d1
                addi.w  #$100,d1
                move.w  d1,y_vel(a0)
                rts
; ---------------------------------------------------------------------------
DEZFinal_EscapeDebrisFrames:
                dc.b    0,   1,   2,   1
                even
; ---------------------------------------------------------------------------

DEZFinal_EscapeDebrisFallAndCull:
                jsr     (MoveSprite2).l
                move.w  (Camera_Y_pos).w,d0
                addi.w  #$108,d0
                cmp.w   y_pos(a0),d0
                blt.w   DEZFinal_DeleteCurrentActor
                jmp     (Draw_And_Touch_Sprite).l
; End of function DEZFinal_InitEscapeDebris
