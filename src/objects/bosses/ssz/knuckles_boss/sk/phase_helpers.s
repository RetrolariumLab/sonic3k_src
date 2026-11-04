; Owner: objects/bosses/ssz/knuckles_boss/sk
; Responsibility: Knuckles Mecha Sonic phase transitions, child motion and private movement or response helpers
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

SSZKnuxMecha_FallToReturnPaletteGate:
                jsr     (MoveSprite_LightGravity).l
                cmpi.w  #$400,y_vel(a0)
                bge.s   SSZSuperMecha_BeginReturnPaletteScript
                rts
; ---------------------------------------------------------------------------

SSZSuperMecha_BeginReturnPaletteScript:
                move.b  #$44,routine(a0)
                lea     (MechaSonic_RestoreSuperPaletteScript).l,a1

; =============== S U B R O U T I N E =======================================

InstallSingleGlobalPaletteRotationScript:
                lea     (Palette_rotation_data).w,a2
                move.l  (a1)+,(a2)+
                move.l  (a1)+,(a2)+
                clr.w   (a2)
                rts
; End of function InstallSingleGlobalPaletteRotationScript

; ---------------------------------------------------------------------------

SSZKnuxMecha_RunPaletteAndUpdateDamage:
                jsr     (Run_PalRotationScript).l
                bclr    #7,$38(a0)
                cmpi.l  #MechaSonic_RestoreSuperPaletteScript.header,(Palette_rotation_data+4).w
                beq.s   SSZKnuxMecha_LimitUpwardAcceleration
                bset    #7,$38(a0)

SSZKnuxMecha_LimitUpwardAcceleration:
                move.w  y_vel(a0),d0
                addi.w  #-$40,d0
                cmpi.w  #-$400,d0
                blt.s   SSZSuperMecha_MoveAndTestReturnHeight
                move.w  d0,y_vel(a0)

SSZSuperMecha_MoveAndTestReturnHeight:
                jsr     (MoveSprite2).l
                move.w  (_unkFAB0).w,d0
                cmp.w   y_pos(a0),d0
                bhs.s   SSZSuperMecha_ClampHeightAndResumeHover
                rts
; ---------------------------------------------------------------------------

SSZSuperMecha_ClampHeightAndResumeHover:
                move.w  d0,y_pos(a0)
                move.b  #$3C,routine(a0)
                move.b  #6,$39(a0)
                move.w  #$100,d0
                move.w  d0,$3E(a0)
                neg.w   d0
                move.w  d0,y_vel(a0)
                move.w  #$10,$40(a0)
                bset    #0,$38(a0)
                rts
; ---------------------------------------------------------------------------

; Emit the eight-way burst only when the decoder advances to cursor 8
SSZKnuxMecha_AnimateAndEmitRadialBurst:
                jsr     (Run_PalRotationScript).l
                jsr     Animate_RawMultiDelay(pc)
                beq.w   SSZMechaBattleAndChildren_SharedReturn
                cmpi.b  #8,anim_frame(a0)
                bne.w   SSZMechaBattleAndChildren_SharedReturn
                moveq   #signextendB(sfx_BossProjectile),d0
                jsr     (Play_SFX).l
                lea     SSZMecha_RadialBurstChild(pc),a2
                jmp     CreateChild6_Simple(pc)
; ---------------------------------------------------------------------------

SSZKnuxMecha_ResumeHoverAfterBurst:
                move.b  #$3C,routine(a0)
                move.w  #$7F,$2E(a0)
                rts
; ---------------------------------------------------------------------------

SSZSuperMechaRadialProjectile_Initialize:
                lea     SSZSuperMechaRadialProjectile_Attributes(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #SSZKnuxMecha_RadialShotMoveAndCull,(a0)
                bsr.w   SSZSuperMechaShot_InitEightWayVel

SSZKnuxMecha_RadialShotMoveAndCull:
                jsr     (MoveSprite2).l
                jmp     (Sprite_CheckDeleteTouchXY).l
; ---------------------------------------------------------------------------

SSZKnuxMecha_InitLaserAnimAndCallback:
                lea     SSZMechaLaser_Attributes(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #SSZKnuxMecha_LaserChargeFollowAndTouch,(a0)
                bsr.w   SSZMechaLaser_SelectAnimAndCallback

SSZKnuxMecha_LaserChargeFollowAndTouch:
                jsr     Animate_Raw(pc)
                jsr     Refresh_ChildPositionAdjusted(pc)
                jmp     (Child_DrawTouch_Sprite).l
; ---------------------------------------------------------------------------

SSZMechaLaser_LaunchTowardPlayer:
                move.l  #SSZKnuxMecha_LaserAnimateFlightAndCull,(a0)
                moveq   #signextendB(sfx_BossLaser),d0
                jsr     (Play_SFX).l
                moveq   #2,d5
                jmp     (SKAimVelocity_LoadP1Position).l
; ---------------------------------------------------------------------------

SSZKnuxMecha_LaserAnimateFlightAndCull:
                lea     SSZMechaLaser_FlightUniformRawAnimation(pc),a1
                jsr     Animate_RawNoSST(pc)
                jsr     (MoveSprite2).l
                jmp     (Sprite_CheckDeleteTouchXY).l
; ---------------------------------------------------------------------------

SSZMechaActiveEffect_Initialize:
                lea     SSZMechaActiveEffect_Attributes(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #SSZKnuxMecha_ActiveEffectFollowAndEmit,(a0)

SSZKnuxMecha_ActiveEffectFollowAndEmit:
                lea     SSZMechaActiveEffect_UniformRawAnimation(pc),a1
                jsr     Animate_RawNoSST(pc)
                jsr     Refresh_ChildPositionAdjusted(pc)
                movea.w parent3(a0),a1
                btst    #6,$38(a1)
                beq.w   SSZMechaChildren_DeleteCurrent
                cmpi.b  #$12,mapping_frame(a1)
                bne.w   SSZMechaBattleAndChildren_SharedReturn
                btst    #0,(V_int_run_count+3).w
                lea     SSZMechaActiveParticle_SimpleChildRecord(pc),a2
                jsr     CreateChild6_Simple(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SSZKnuxMecha_InitRandomActiveParticle:
                lea     SSZMechaActiveParticle_PartialAttributes(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #SSZKnuxMecha_ActiveParticleAnimate,(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                jsr     (Random_Number).l
                andi.w  #$1F,d0
                subi.w  #$F,d0
                add.w   d0,x_pos(a0)
                swap    d0
                andi.w  #$1F,d0
                subi.w  #$F,d0
                add.w   d0,y_pos(a0)

SSZKnuxMecha_ActiveParticleAnimate:
                lea     SSZMecha_ActiveParticleDeleteAnim(pc),a1
                jsr     Animate_RawNoSSTMultiDelay(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SSZKnuxMecha_InitEmeraldAndPalette:
                lea     SSZMechaMasterEmerald_Attributes(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.w  (Camera_max_X_pos).w,d0
                addi.w  #$100,d0
                move.w  d0,x_pos(a0)
                move.w  (Camera_Y_pos).w,d0
                addi.w  #$A8,d0
                move.w  d0,y_pos(a0)
                move.l  #SSZKnuxMecha_EmeraldSetFrameFromScene,(a0)
                lea     (Collected_emeralds_array).w,a1
                moveq   #3,d0
                moveq   #7-1,d1

SSZKnuxMecha_EmeraldCheckCollected:
                cmp.b   (a1)+,d0
                bne.s   SSZKnuxMecha_EmeraldPaletteInitReturn
                dbf     d1,SSZKnuxMecha_EmeraldCheckCollected
                move.l  #SSZKnuxMecha_EmeraldCycleAndUpdateFrame,(a0)

SSZKnuxMecha_EmeraldPaletteInitReturn:
                rts
; ---------------------------------------------------------------------------

SSZKnuxMecha_EmeraldCycleAndUpdateFrame:
                lea     SSZMasterEmeraldColorCycle_IndexedScript(pc),a1
                lea     (Normal_palette_line_3+$1C).w,a2
                jsr     (Run_PalRotationScript2).l

SSZKnuxMecha_EmeraldSetFrameFromScene:
                move.b  #0,mapping_frame(a0)
                btst    #6,(_unkFAB8).w
                beq.s   SSZKnuxMecha_EmeraldDrawOrDelete
                move.b  #1,mapping_frame(a0)

SSZKnuxMecha_EmeraldDrawOrDelete:
                tst.b   (_unkFAA2).w
                bne.w   SSZMechaChildren_DeleteCurrent
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SSZKnuxMecha_InitSignalCoordMode:
                lea     SSZMechaSignalEffect_Attributes(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                movea.w parent3(a0),a1
                btst    #2,render_flags(a1)
                bne.s   SSZKnuxMecha_SignalSetAnimAndCallback
                bclr    #2,render_flags(a0)

SSZKnuxMecha_SignalSetAnimAndCallback:
                move.l  #SSZMechaSignalEffect_AnimateAndDraw,(a0)
                move.l  #SSZMecha_ParentReleaseSignalAnim,$30(a0)
                move.l  #SSZKnuxMecha_SignalClearParentWait,$34(a0)
                jsr     Refresh_ChildPositionAdjusted(pc)

SSZMechaSignalEffect_AnimateAndDraw:
                jsr     Animate_RawMultiDelay(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SSZKnuxMecha_SignalClearParentWait:
                move.l  #SSZKnuxMecha_SignalFollowOnFrame14,(a0)
                movea.w parent3(a0),a1
                bclr    #6,$38(a1)
                rts
; ---------------------------------------------------------------------------

SSZKnuxMecha_SignalFollowOnFrame14:
                move.b  #-7,child_dx(a0)
                move.b  #3,child_dy(a0)
                jsr     Refresh_ChildPositionAdjusted(pc)
                movea.w parent3(a0),a1
                cmpi.b  #$E,mapping_frame(a1)
                bne.s   SSZMechaChildren_DeleteCurrent
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SSZMechaChildren_DeleteCurrent:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

SSZKnuxMecha_InitSecondRollTrail:
                addq.b  #4,subtype(a0)

SSZMechaRollingTrail_Initialize:
                lea     SSZMechaRollingTrail_Attributes(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #SSZKnuxMecha_RollTrailFollowAndAnimate,(a0)
                bsr.w   SSZMechaTrail_InitOffsetsAndPriority
                moveq   #signextendB(sfx_Roll),d0
                jsr     (Play_SFX).l

SSZKnuxMecha_RollTrailFollowAndAnimate:
                lea     SSZMechaRollingTrail_RawAnimation(pc),a1
                jsr     Animate_RawNoSSTMultiDelay(pc)
                jsr     Refresh_ChildPositionAdjusted(pc)
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   SSZKnuxMecha_DeleteRollTrail
                btst    #2,$38(a1)
                beq.s   SSZKnuxMecha_DeleteRollTrail
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SSZKnuxMecha_DeleteRollTrail:
                jmp     (Go_Delete_Sprite).l
