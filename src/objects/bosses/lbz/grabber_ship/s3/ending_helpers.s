; Owner: objects/bosses/lbz/grabber_ship/s3
; Responsibility: Launch Base final battle and ending motion, collision, art scaling and external player-sprite animation helpers
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

; Once the parent has high tile priority, set the child's priority and collision and store the caller's continuation as its handler
LBZBoss2Child_LatchPriorityAndColl:
                movea.w parent3(a0),a1
                btst    #7,art_tile(a1)
                beq.s   LBZBoss2S3_PriorityLatchReturn
                bset    #7,art_tile(a0)
                move.l  (sp),(a0)
                move.b  d0,collision_flags(a0)

LBZBoss2S3_PriorityLatchReturn:
                rts
; End of function LBZBoss2Child_LatchPriorityAndColl

; ---------------------------------------------------------------------------
; unused
                movea.w $44(a0),a1
                movea.w parent3(a0),a2
                move.w  x_pos(a1),d0
                moveq   #$10,d2
                btst    #0,render_flags(a2)
                beq.s   LBZBoss2S3_UnusedMidpointFirstOffset
                neg.w   d2

LBZBoss2S3_UnusedMidpointFirstOffset:
                add.w   d2,d0
                move.w  x_pos(a2),d1
                moveq   #$C,d2
                btst    #0,render_flags(a2)
                beq.s   LBZBoss2S3_UnusedStoreActorMidpoint
                neg.w   d2

LBZBoss2S3_UnusedStoreActorMidpoint:
                add.w   d2,d1
                sub.w   d1,d0
                asr.w   #1,d0
                add.w   d0,d1
                move.w  d1,x_pos(a0)
                move.w  y_pos(a1),d0
                subq.w  #4,d0
                move.w  y_pos(a2),d1
                subq.w  #4,d1
                sub.w   d1,d0
                asr.w   #1,d0
                add.w   d0,d1
                move.w  d1,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

LBZBoss2S3_ChoosePassHeightAndSpeed:
                jsr     (Random_Number).l
                andi.w  #6,d0
                move.w  d0,$3A(a0)
                move.w  (Camera_X_pos).w,d1
                move.w  #$1A8,d2
                move.w  #-$300,d3
                btst    #0,render_flags(a0)
                beq.s   LBZBoss2S3_ApplyPassStartMotion
                move.w  #-$68,d2
                neg.w   d3

LBZBoss2S3_ApplyPassStartMotion:
                add.w   d2,d1
                move.w  d1,x_pos(a0)
                move.w  d3,x_vel(a0)
                move.w  (Camera_Y_pos).w,d1
                move.w  LBZBoss2S3_PassCameraYOffsets(pc,d0.w),d2
                add.w   d1,d2
                move.w  d2,y_pos(a0)
                move.w  LBZBoss2S3_PassInitialYSpeeds(pc,d0.w),y_vel(a0)
                move.w  #8,$3C(a0)
                rts
; ---------------------------------------------------------------------------
LBZBoss2S3_PassCameraYOffsets:
                dc.w    $60,   $10,   $A0,   $80
LBZBoss2S3_PassInitialYSpeeds:
                dc.w    0,  $200, -$200,     0
; ---------------------------------------------------------------------------

LBZBoss2S3_ChoosePatrolFacingSpeed:
                move.w  #-$300,d0
                btst    #0,render_flags(a0)
                beq.s   LBZBoss2S3_StorePatrolSpeedAndWait
                neg.w   d0

LBZBoss2S3_StorePatrolSpeedAndWait:
                move.w  d0,x_vel(a0)
                jsr     (Random_Number).l
                andi.w  #$7F,d0
                addi.w  #$C0,d0
                move.w  d0,$2E(a0)
                rts

; =============== S U B R O U T I N E =======================================

LBZBoss2_ReverseAtCameraBounds:
                move.w  (Camera_X_pos).w,d0
                tst.w   x_vel(a0)
                bmi.s   LBZBoss2S3_CheckLeftPatrolBound
                add.w   d2,d0
                cmp.w   x_pos(a0),d0
                bls.s   LBZBoss2S3_ReversePatrolFacingAndSpeed
                bra.w   LBZBoss2S3_PatrolBoundsReturn
; ---------------------------------------------------------------------------

LBZBoss2S3_CheckLeftPatrolBound:
                add.w   d1,d0
                cmp.w   x_pos(a0),d0
                blo.s   LBZBoss2S3_PatrolBoundsReturn

LBZBoss2S3_ReversePatrolFacingAndSpeed:
                bchg    #0,render_flags(a0)
                neg.w   x_vel(a0)

LBZBoss2S3_PatrolBoundsReturn:
                rts
; End of function LBZBoss2_ReverseAtCameraBounds

; =============== S U B R O U T I N E =======================================

HandleLBZFinalBoss2SixColorHitOrDefeat:
                cmpi.b  #8,routine(a0)
                blo.s   LBZBoss2S3_HitUpdateReturn
                tst.b   collision_flags(a0)
                bne.s   LBZBoss2S3_HitUpdateReturn
                move.b  collision_property(a0),d0
                beq.s   LBZBoss2S3_BeginScoredDefeatWait
                tst.b   $20(a0)
                bne.s   LBZBoss2S3_HitChooseFlashRow
                cmpi.b  #$A,routine(a0)
                bne.s   LBZBoss2S3_BeginHitFlashDisableArm
                move.w  #8,$3A(a0)

LBZBoss2S3_BeginHitFlashDisableArm:
                move.b  #$3C,$20(a0)
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l
                movea.w $44(a0),a1
                clr.b   collision_flags(a1)

LBZBoss2S3_HitChooseFlashRow:
                bset    #6,status(a0)
                moveq   #0,d0
                btst    #0,$20(a0)
                bne.s   LBZBoss2S3_HitCopyColorsAndTick
                addi.w  #2*6,d0

; Restore collision on both the root and arm when the flash expires
LBZBoss2S3_HitCopyColorsAndTick:
                bsr.w   CopyLBZFinalBoss2SixColorPalette
                subq.b  #1,$20(a0)
                bne.s   LBZBoss2S3_HitUpdateReturn
                bclr    #6,status(a0)
                move.b  $25(a0),collision_flags(a0)
                movea.w $44(a0),a1
                move.b  #$AD,collision_flags(a1)

LBZBoss2S3_HitUpdateReturn:
                rts
; ---------------------------------------------------------------------------

LBZBoss2S3_BeginScoredDefeatWait:
                move.l  #Wait_Draw,(a0)
                move.l  #LBZBoss2S3_BeginDefeatSinkAndBreakup,$34(a0)
                jsr     BossDefeated_StopTimer(pc)
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild1_Normal).l
                bne.s   LBZBoss2S3_DefeatCheckPlayerRelease
                move.b  #4,subtype(a1)

LBZBoss2S3_DefeatCheckPlayerRelease:
                tst.b   $30(a0)
; Bug: this branch is inverted, freeing the player if they're _not_ being held
                bne.s   LBZBoss2S3_DefeatSaveGame
                jsr     Restore_PlayerControl(pc)

LBZBoss2S3_DefeatSaveGame:
                jmp     (SaveGame).l
; End of function HandleLBZFinalBoss2SixColorHitOrDefeat

; =============== S U B R O U T I N E =======================================

CopyLBZFinalBoss2SixColorPalette:
                lea     LBZBoss2S3_HitPaletteDestinations(pc),a1
                lea     LBZFinalBoss2S3_Hit_TwoSixColorBanks(pc,d0.w),a2
                jmp     CopyWordData_6(pc)
; End of function CopyLBZFinalBoss2SixColorPalette

; ---------------------------------------------------------------------------
LBZBoss2S3_HitPaletteDestinations:
                dc.w    Normal_palette_line_2+$08, Normal_palette_line_2+$0E, Normal_palette_line_2+$10
                dc.w    Normal_palette_line_2+$18, Normal_palette_line_2+$1A, Normal_palette_line_2+$1C
LBZFinalBoss2S3_Hit_TwoSixColorBanks:
                dc.w    8,    $A,     4,  $644,  $422,     0
                dc.w    $888,  $666,  $AAA,  $AAA,  $EEE,  $EEE

; =============== S U B R O U T I N E =======================================

Perform_Art_Scaling:
                clr.w   (ScaledArtAllocatedTileCount).w
                move.l  a0,-(sp)
                jsr     (Init_ArtScaling).l
                movea.l (sp)+,a0
                move.l  a0,-(sp)
                move.w  art_tile(a0),d0
                jsr     (TryBuildObjectScaledArt).l
                movea.l (sp)+,a0
                move.w  (ScaledArtAllocatedTileCount).w,d3
                lsl.w   #4,d3
                move.l  #Kos_decomp_buffer,d1
                move.w  $3A(a0),d2
                jmp     (Add_To_DMA_Queue).l
; End of function Perform_Art_Scaling

; =============== S U B R O U T I N E =======================================

; Apply each candidate velocity only when it remains within that axis's limit
LBZUnusedRobotnik_AdjustVel:
                move.w  x_vel(a0),d0
                addi.w  #-$28,d0
                cmpi.w  #-$80,d0
                blt.s   LBZBoss2S3_UnusedScalerUpdateYSpeed
                move.w  d0,x_vel(a0)

LBZBoss2S3_UnusedScalerUpdateYSpeed:
                move.w  y_vel(a0),d0
                addi.w  #8,d0
                cmpi.w  #$40,d0
                bge.s   LBZBoss2S3_UnusedScalerYSpeedReturn
                move.w  d0,y_vel(a0)

LBZBoss2S3_UnusedScalerYSpeedReturn:
                rts
; End of function LBZUnusedRobotnik_AdjustVel

; =============== S U B R O U T I N E =======================================

; Integrate the alternate fixed-point coordinates and subtract the scale-dependent origin before writing integer X and Y
LBZUnusedRobotnik_IntegrateAndProject:
                bsr.w   IntegrateScaledActorPositionAccumulators
                move.w  $30(a0),d2
                move.w  $34(a0),d3
                moveq   #0,d0
                move.b  $40(a0),d0
                addq.w  #4,d0
                move.l  #$100,d4
                divu.w  d0,d4
                sub.w   d4,d2
                sub.w   d4,d3
                move.w  d2,x_pos(a0)
                move.w  d3,y_pos(a0)
                rts
; End of function LBZUnusedRobotnik_IntegrateAndProject

; =============== S U B R O U T I N E =======================================

; Regenerate and queue scaled art as the actor grows. Schedule deletion after the last source frame
LBZUnusedRobotnik_StepArtAndScale:
                subq.w  #1,$1C(a0)
                bpl.s   LBZBoss2S3_UnusedScalerTickArt
                moveq   #0,d0
                move.b  anim_frame(a0),d0
                addq.b  #1,d0
                cmpi.b  #6,d0
                bhi.s   LBZBoss2S3_UnusedScalerQueueDeletion
                move.b  d0,anim_frame(a0)
                add.w   d0,d0
                move.w  LBZBoss2S3_UnusedScalerFrameDelays(pc,d0.w),$1C(a0)
                add.w   d0,d0
                move.l  LBZBoss2S3_UnusedScalerArtPointers(pc,d0.w),$42(a0)

LBZBoss2S3_UnusedScalerTickArt:
                subq.b  #1,$25(a0)
                bpl.s   LBZBoss2S3_UnusedScalerArtReturn
                move.b  #4,$25(a0)
                move.b  $40(a0),d0
                addq.b  #1,d0
                bmi.s   LBZBoss2S3_UnusedScalerArtReturn
                move.b  d0,$40(a0)
                bsr.w   Perform_Art_Scaling

LBZBoss2S3_UnusedScalerArtReturn:
                rts
; ---------------------------------------------------------------------------

LBZBoss2S3_UnusedScalerQueueDeletion:
                jmp     (Go_Delete_Sprite).l
; End of function LBZUnusedRobotnik_StepArtAndScale

; ---------------------------------------------------------------------------
LBZBoss2S3_UnusedScalerFrameDelays:
                dc.w    $20
                dc.w    $20
                dc.w    $10
                dc.w    8
                dc.w    8
                dc.w    8
                dc.w    $200
LBZBoss2S3_UnusedScalerArtPointers:
                dc.l    ArtScaled_LBZ2UnusedRobotnik
                dc.l    ArtScaled_LBZ2UnusedRobotnik
                dc.l    ArtScaled_LBZ2UnusedRobotnik+$1000
                dc.l    ArtScaled_LBZ2UnusedRobotnik+$2000
                dc.l    ArtScaled_LBZ2UnusedRobotnik+$3000
                dc.l    ArtScaled_LBZ2UnusedRobotnik+$4000
                dc.l    ArtScaled_LBZ2UnusedRobotnik+$5000

; =============== S U B R O U T I N E =======================================

LoadLBZEndingPosePaletteLine:
                move.w  $3A(a0),d1
                movea.l LBZBoss2S3_EndingPosePalettes(pc,d1.w),a1
                lea     (Normal_palette).w,a2
                moveq   #bytesToLcnt($20),d0

LBZBoss2S3_EndingCopyPosePalette:
                move.l  (a1)+,(a2)+
                dbf     d0,LBZBoss2S3_EndingCopyPosePalette
                rts
; End of function LoadLBZEndingPosePaletteLine

; ---------------------------------------------------------------------------
LBZBoss2S3_EndingPosePalettes:
                dc.l    Pal_SonicEndPose
                dc.l    Pal_TailsEndPose
                dc.l    Pal_SuperSonicEndPose
                dc.l    Pal_SuperSonicEndPose

; =============== S U B R O U T I N E =======================================

Animate_ExternalPlayerSprite:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   LBZBoss2S3_ExternalAnimUpdateReturn
                lea     (Player_1).w,a2
                move.b  (a1),anim_frame_timer(a0)
                moveq   #0,d0
                move.b  anim_frame(a0),d0
                addq.b  #2,d0
                move.b  d0,anim_frame(a0)
                move.b  1(a1,d0.w),d1
                cmpi.b  #-1,d1
                beq.s   LBZBoss2S3_ExternalAnimRunEndCallback
                move.b  d1,mapping_frame(a2)
                bclr    #0,render_flags(a2)
                tst.b   2(a1,d0.w)
                beq.s   LBZBoss2S3_ExternalAnimUpdateReturn
                bset    #0,render_flags(a2)

LBZBoss2S3_ExternalAnimUpdateReturn:
                rts
; ---------------------------------------------------------------------------

LBZBoss2S3_ExternalAnimRunEndCallback:
                movea.l $34(a0),a1
                jmp     (a1)
; End of function Animate_ExternalPlayerSprite
