; Owner: objects/cutscenes/sk
; Responsibility: Shared Knuckles cutscene state selection, graphics patterns, angle helpers and child positioning
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

SSZSmallDeathEgg_TryParticleEvery32:
                move.b  (V_int_run_count+3).w,d0
                andi.w  #$1F,d0
                bne.w   SKAIZScene_SharedSceneReturn
                moveq   #signextendB(sfx_MissileShoot),d0
                jsr     (Play_SFX).l
                lea     SKSceneData_SSZDeathEggParticleChildren(pc),a2
                jmp     (CreateChild6_Simple).l
; End of function SSZSmallDeathEgg_TryParticleEvery32

; ---------------------------------------------------------------------------

SKScene_SSZStartHalfCameraTracker:
                move.w  (Camera_X_pos).w,$3A(a0)
                move.l  #SKSszCutscene_StoreHalfSignedCameraDelta,(a0)

SKSszCutscene_StoreHalfSignedCameraDelta:
                move.w  (Camera_X_pos).w,d0
                move.w  $3A(a0),d1
                move.w  d0,$3A(a0)
                sub.w   d1,d0
                asr.w   #1,d0
                move.w  d0,(SceneCreditIndexOrBossMotionPlanAngle).w
                rts

; =============== S U B R O U T I N E =======================================

HPZKnucklesFaceTargetFromSideWord:
                bset    #0,render_flags(a0)
                tst.w   d0
                beq.s   SKScene_HPZFacingSideReturn
                bclr    #0,render_flags(a0)

SKScene_HPZFacingSideReturn:
                rts
; End of function HPZKnucklesFaceTargetFromSideWord

; ---------------------------------------------------------------------------

SKScene_HPZCheckHurtInvulnTimer:
                tst.b   $34(a1)
                bne.w   SKAIZScene_SharedSceneReturn

SKScene_HPZHurtUnlessInvincible:
                btst    #Status_InAir,status_secondary(a1)
                bne.w   SKAIZScene_SharedSceneReturn
                jmp     (HurtCharacter_Directly).l
; ---------------------------------------------------------------------------

SKScene_HPZCheckPackedPlayerContacts:
                lea     SKHpzContact_PlayerQueryRectangle(pc),a1
                jsr     (Check_PlayerInRange).l
                tst.l   d0
                beq.w   SKAIZScene_SharedSceneReturn
                tst.w   d0
                beq.s   SKScene_HPZDispatchHighWordContact
                move.l  d0,-(sp)
                bsr.w   HPZKnux_DispatchPlayerContact
                move.l  (sp)+,d0

SKScene_HPZDispatchHighWordContact:
                swap    d0
                tst.w   d0
                beq.w   SKAIZScene_SharedSceneReturn

; =============== S U B R O U T I N E =======================================

; Select the callback by facing side and vertical alignment. Nonrolling invincible contact goes directly to the hit response
HPZKnux_DispatchPlayerContact:
                btst    #4,$38(a0)
                bne.w   SKAIZScene_SharedSceneReturn
                movea.w d0,a1
                btst    #0,render_flags(a0)
                sne     d4
                move.w  x_pos(a1),d1
                cmp.w   x_pos(a0),d1
                bhs.s   SKScene_HPZCheckFrontFacingAndGap
                not.b   d4

SKScene_HPZCheckFrontFacingAndGap:
                tst.b   d4
                bne.s   SKScene_HPZSelectRearOrInvincible
                move.w  y_pos(a1),d2
                sub.w   y_pos(a0),d2
                bpl.s   SKScene_HPZSelectFrontOrInvincible
                neg.w   d2

SKScene_HPZSelectFrontOrInvincible:
                cmpi.w  #$10,d2
                bhs.s   SKScene_HPZSelectRearOrInvincible
                cmpi.b  #2,anim(a1)
                beq.s   SKScene_HPZDispatchFirstContact
                btst    #Status_Invincible,status_secondary(a1)
                bne.w   HPZKnux_TakeHitAndSelectRecoil

SKScene_HPZDispatchFirstContact:
                movea.l (a3),a4
                jmp     (a4)
; ---------------------------------------------------------------------------
; unused
                movea.l 4(a3),a4
                jmp     (a4)
; ---------------------------------------------------------------------------

SKScene_HPZSelectRearOrInvincible:
                cmpi.b  #2,anim(a1)
                beq.s   SKScene_HPZDispatchThirdContact
                btst    #Status_Invincible,status_secondary(a1)
                bne.w   HPZKnux_TakeHitAndSelectRecoil

SKScene_HPZDispatchThirdContact:
                movea.l 8(a3),a4
                jmp     (a4)
; ---------------------------------------------------------------------------
; unused
                movea.l $C(a3),a4
                jmp     (a4)
; End of function HPZKnux_DispatchPlayerContact

; ---------------------------------------------------------------------------
SKHpzContact_PlayerQueryRectangle:
                dc.w    -$18,   $30,  -$18,   $30

; =============== S U B R O U T I N E =======================================

HPZKnux_StopAtCameraXMargins:
                tst.w   x_vel(a0)
                beq.s   SKScene_HPZCameraMarginReturn
                bmi.s   SKScene_HPZClampLeftwardSpeed
                move.w  (Camera_X_pos).w,d0
                addi.w  #$130,d0
                cmp.w   x_pos(a0),d0
                bhi.s   SKScene_HPZCameraMarginReturn
                clr.w   x_vel(a0)
                rts
; ---------------------------------------------------------------------------

SKScene_HPZClampLeftwardSpeed:
                move.w  (Camera_X_pos).w,d0
                addi.w  #$10,d0
                cmp.w   x_pos(a0),d0
                blo.s   SKScene_HPZCameraMarginReturn
                clr.w   x_vel(a0)

SKScene_HPZCameraMarginReturn:
                rts
; End of function HPZKnux_StopAtCameraXMargins

; ---------------------------------------------------------------------------

SKScene_LoadKnuxArtToP2Tiles:
                moveq   #0,d0
                move.b  mapping_frame(a0),d0
                cmp.b   $3A(a0),d0
                beq.s   SKScene_KnuxP2ArtReturn
                move.b  d0,$3A(a0)
                lea     (PLC_Knuckles).l,a2
                add.w   d0,d0
                adda.w  (a2,d0.w),a2
                move.w  (a2)+,d5
                subq.w  #1,d5
                bmi.s   SKScene_KnuxP2ArtReturn
                move.w  #tiles_to_bytes(ArtTile_Player_2),d4
                move.l  #ArtUnc_Knux,d6

SKScene_QueueKnuxP2ArtEntry:
                moveq   #0,d1
                move.w  (a2)+,d1
                move.w  d1,d3
                lsr.w   #8,d3
                andi.w  #$F0,d3
                addi.w  #$10,d3
                andi.w  #$FFF,d1
                lsl.l   #5,d1
                add.l   d6,d1
                move.w  d4,d2
                add.w   d3,d4
                add.w   d3,d4
                jsr     (Add_To_DMA_Queue).l
                dbf     d5,SKScene_QueueKnuxP2ArtEntry

SKScene_KnuxP2ArtReturn:
                rts

; =============== S U B R O U T I N E =======================================

SKScene_LoadKnuxArtToSceneTiles:
                moveq   #0,d0
                move.b  mapping_frame(a0),d0
                cmp.b   $3A(a0),d0
                beq.s   SKScene_KnuxSceneArtReturn
                move.b  d0,$3A(a0)
                lea     (PLC_Knuckles).l,a2
                add.w   d0,d0
                adda.w  (a2,d0.w),a2
                move.w  (a2)+,d5
                subq.w  #1,d5
                bmi.s   SKScene_KnuxSceneArtReturn
                move.w  #tiles_to_bytes(ArtTile_CutsceneKnux),d4
                move.l  #ArtUnc_Knux,d6

SKScene_QueueKnuxSceneArtEntry:
                moveq   #0,d1
                move.w  (a2)+,d1
                move.w  d1,d3
                lsr.w   #8,d3
                andi.w  #$F0,d3
                addi.w  #$10,d3
                andi.w  #$FFF,d1
                lsl.l   #5,d1
                add.l   d6,d1
                move.w  d4,d2
                add.w   d3,d4
                add.w   d3,d4
                jsr     (Add_To_DMA_Queue).l
                dbf     d5,SKScene_QueueKnuxSceneArtEntry

SKScene_KnuxSceneArtReturn:
                rts
; End of function SKScene_LoadKnuxArtToSceneTiles

; =============== S U B R O U T I N E =======================================

HPZKnucklesDustQueueDPLCWhenFrameChanges:
                move.l  #ArtUnc_DashDust,d6
                moveq   #0,d0
                move.b  mapping_frame(a0),d0
                cmp.b   $3A(a0),d0
                beq.s   SKScene_HPZDashDustArtReturn
                move.b  d0,$3A(a0)
                lea     (DPLC_DashSplashDrown).l,a2
                add.w   d0,d0
                adda.w  (a2,d0.w),a2
                move.w  (a2)+,d5
                subq.w  #1,d5
                bmi.s   SKScene_HPZDashDustArtReturn
                move.w  #tiles_to_bytes(ArtTile_HPZKnuxBossDust),d4

SKScene_QueueHPZDashDustArtEntry:
                moveq   #0,d1
                move.w  (a2)+,d1
                move.w  d1,d3
                lsr.w   #8,d3
                andi.w  #$F0,d3
                addi.w  #$10,d3
                andi.w  #$FFF,d1
                lsl.l   #5,d1
                add.l   d6,d1
                move.w  d4,d2
                add.w   d3,d4
                add.w   d3,d4
                jsr     (Add_To_DMA_Queue).l
                dbf     d5,SKScene_QueueHPZDashDustArtEntry

SKScene_HPZDashDustArtReturn:
                rts
; End of function HPZKnucklesDustQueueDPLCWhenFrameChanges

; =============== S U B R O U T I N E =======================================

; Add the signed byte step to the phase. Reverse the step when the signed countdown expires
HPZCrane_TickOscillation:
                move.b  $40(a0),d0
                add.b   d0,$3C(a0)
                subq.b  #1,$39(a0)
                bpl.s   SKScene_HPZCraneAngleUpdateReturn
                move.b  $30(a0),$39(a0)
                neg.b   $40(a0)

SKScene_HPZCraneAngleUpdateReturn:
                rts
; End of function HPZCrane_TickOscillation

; =============== S U B R O U T I N E =======================================

; Round the phase to frames $13 through $1A
HPZCrane_SelectEightWayFrame:
                moveq   #0,d0
                move.b  $3C(a0),d0
                addi.b  #$10,d0
                rol.b   #3,d0
                andi.b  #7,d0
                addi.b  #$13,d0
                move.b  d0,mapping_frame(a0)
                rts
; End of function HPZCrane_SelectEightWayFrame

; ---------------------------------------------------------------------------

SKScene_HPZSeedPlatformFragment:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  d0,d3
                lea     SKHpzPlatformFragment_LaunchOffsets(pc,d0.w),a1
                move.b  (a1)+,d1
                ext.w   d1
                add.w   d1,x_pos(a0)
                move.b  (a1)+,d2
                ext.w   d2
                add.w   d2,y_pos(a0)
                lsr.w   #1,d0
                addq.b  #7,d0
                move.b  d0,mapping_frame(a0)
                move.w  #-$200,d0
                lsl.w   #4,d3
                neg.w   d3
                add.w   d3,d0
                move.w  d0,x_vel(a0)
                lsl.w   #1,d3
                andi.w  #$180,d3
                addi.w  #$80,d3
                tst.w   d2
                bpl.s   SKScene_HPZStoreFragmentYVelocity
                neg.w   d3

SKScene_HPZStoreFragmentYVelocity:
                move.w  d3,y_vel(a0)
                rts
; ---------------------------------------------------------------------------
SKHpzPlatformFragment_LaunchOffsets:
                dc.b    8,   -8
                dc.b    8,    0
                dc.b    8, -$10
                dc.b    8,    8
                dc.b    8, -$18
                dc.b    8,  $10
                dc.b    8, -$20
                dc.b    8,  $18
                dc.b    0,   -8
                dc.b    0,    0
                dc.b    0, -$10
                dc.b    0,    8
                dc.b    0, -$18
                dc.b    0,  $10
                dc.b    0, -$20
                dc.b    0,  $18
                dc.b    -8,   -8
                dc.b    -8,    0
                dc.b    -8, -$10
                dc.b    -8,    8
                dc.b    -8, -$18
                dc.b    -8,  $10
                dc.b    -8, -$20
                dc.b    -8,  $18
                dc.b    -$10,   -8
                dc.b    -$10,    0
                dc.b    -$10, -$10
                dc.b    -$10,    8
                dc.b    -$10, -$18
                dc.b    -$10,  $10
                dc.b    -$10, -$20
                dc.b    -$10,  $18

; =============== S U B R O U T I N E =======================================

; Count 48 updates while hit status bit 6 is set, then clear the bit
HPZShip_TickMovingHitPause:
                btst    #6,status(a0)
                beq.s   SKHpzShip_ReturnAfterMovingHitPauseGate
                tst.b   $20(a0)
                bne.s   SKScene_HPZTickShipHitPause
                move.b  #$30,$20(a0)
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l

SKScene_HPZTickShipHitPause:
                subq.b  #1,$20(a0)
                bne.s   SKHpzShip_ReturnAfterMovingHitPauseGate
                bclr    #6,status(a0)

SKHpzShip_ReturnAfterMovingHitPauseGate:
                rts
; End of function HPZShip_TickMovingHitPause

; =============== S U B R O U T I N E =======================================

; Flash three palette slots for 32 updates before restoring the saved collision type
HPZShip_TickHitFlashAndRestoreColl:
                tst.b   collision_flags(a0)
                bne.s   SKScene_HPZShipFlashUpdateReturn
                tst.b   $20(a0)
                bne.s   SKScene_HPZSelectShipHitFlashPhase
                move.b  #$20,$20(a0)
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l
                bset    #6,status(a0)

SKScene_HPZSelectShipHitFlashPhase:
                moveq   #0,d0
                btst    #0,$20(a0)
                bne.s   SKScene_HPZCopyShipFlashAndRestoreTouch
; Bug: should be 2*3
                addi.w  #2*2,d0

SKScene_HPZCopyShipFlashAndRestoreTouch:
                jsr     (CopySSZGHZThreeColorPaletteAtByteOffset).l
                subq.b  #1,$20(a0)
                bne.s   SKScene_HPZShipFlashUpdateReturn
                bclr    #6,status(a0)
                move.b  $25(a0),collision_flags(a0)

SKScene_HPZShipFlashUpdateReturn:
                rts
; End of function HPZShip_TickHitFlashAndRestoreColl
