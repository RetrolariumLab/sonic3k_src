; Owner: objects/bosses/mhz/miniboss/sk
; Responsibility: Mushroom Hill miniboss linked actor movement, collision, palette and state helpers
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

SyncMHZMinibossFrameCollisionProxy:
                movea.w parent3(a0),a1
                moveq   #0,d0
                move.b  mapping_frame(a1),d0
                lsl.w   #2,d0
                lea     MHZMini_FrameOffsetsAndResponse(pc,d0.w),a2
                move.b  (a2)+,d0
                ext.w   d0
                move.w  x_pos(a1),d1
                btst    #0,render_flags(a1)
                beq.s   MHZMini_StoreFrameGeometry
                neg.w   d0

MHZMini_StoreFrameGeometry:
                add.w   d0,d1
                move.w  d1,x_pos(a0)
                move.b  (a2)+,d0
                ext.w   d0
                move.w  y_pos(a1),d1
                add.w   d0,d1
                move.w  d1,y_pos(a0)
                move.b  (a2)+,collision_flags(a0)
                move.b  (a2)+,mapping_frame(a0)
                rts
; End of function SyncMHZMinibossFrameCollisionProxy

; ---------------------------------------------------------------------------
MHZMini_FrameOffsetsAndResponse:
                dc.b    -$2A, $28, $A3,  $B
                dc.b    -$2A, $29, $A3,  $B
                dc.b    -$2A, $2A, $A3,  $B
                dc.b    -$2A, $2B, $A3,  $B
                dc.b    -$38,-$10, $9A,  $A
                dc.b    -$38,-$10, $9A,  $A
                dc.b    -$38,-$10, $9A,  $A
                dc.b    -$28, -$B, $9A,  $A
                dc.b    -$31, -$B, $9A,  $A
                dc.b    -8,  -8, $9A,  $A
                dc.b    -$11,  -8, $9A,  $A
                dc.b    $24,  $E, $9B,   4
                dc.b    $24,  $D, $9B,   4
                dc.b    0,   0,   0,   0
                dc.b    $24,  $E, $9B,   4
                dc.b    0,   0,   0,   0
                dc.b    $2B,  $E, $9B,   4
                dc.b    $2A,  $E, $9B,   4
                dc.b    $29,  $E, $9B,   4
                dc.b    0,   0,   0,   0
                dc.b    -$21, $28, $A3,  $B
                dc.b    -$2A, $28, $A3,  $B
                even

; =============== S U B R O U T I N E =======================================

; Use the height before relocation and random bits to seed horizontal speed and both motion adjustments
MHZMiniParticle_InitMotion:
                move.w  (Camera_Y_pos).w,d2
                addi.w  #$E0,d2
                sub.w   y_pos(a0),d2
                lsr.w   #3,d2
                andi.w  #$1E,d2
                jsr     (Random_Number).l
                move.w  MHZMini_SpeedByHeightBucket(pc,d2.w),d3
                andi.w  #$1FF,d0
                add.w   d0,d3
                moveq   #-$C,d4
                btst    #1,d0
                beq.s   MHZMini_StoreMotionAndRandomYAccel
                neg.w   d3
                neg.w   d4

MHZMini_StoreMotionAndRandomYAccel:
                move.w  d3,x_vel(a0)
                move.w  d4,$40(a0)
                swap    d0
                andi.w  #$F,d0
                addq.w  #8,d0
                move.w  d0,$3E(a0)
                rts
; End of function MHZMiniParticle_InitMotion

; ---------------------------------------------------------------------------
MHZMini_SpeedByHeightBucket:
                dc.w    $400
                dc.w    $400
                dc.w    $400
                dc.w    $400
                dc.w    $380
                dc.w    $300
                dc.w    $280
                dc.w    $200
                dc.w    $180
                dc.w    $140
                dc.w    $100
                dc.w    $C0
                dc.w    $80
                dc.w    $80
                dc.w    $80
                dc.w    $80
                dc.w    $40
                dc.w    $40
                dc.w    $40
                dc.w    $40
                dc.w    $3C
                dc.w    $38
                dc.w    $34
                dc.w    $30
                dc.w    $2C
                dc.w    $28
                dc.w    $24
                dc.w    $20
                dc.w    $1C
                dc.w    $18
                dc.w    $14
                dc.w    $10

; =============== S U B R O U T I N E =======================================

; Select from the root frame and the child's side subtype
MHZMiniPart_SetFramePriorityOffsets:
                movea.w parent3(a0),a1
                moveq   #0,d0
                move.b  mapping_frame(a1),d0
                move.b  MHZMini_FramesByParentFrame(pc,d0.w),mapping_frame(a0)
                add.w   d0,d0
                move.w  d0,d1
                lea     MHZMini_QueuePriorityByFrame(pc,d0.w),a2
                move.w  (a2)+,priority(a0)
                add.w   d1,d1
                add.b   subtype(a0),d1
                lea     MHZMini_OffsetPairsByFrame(pc,d1.w),a2
                move.w  (a2)+,child_dx(a0)              ; and child_dy
                rts
; End of function MHZMiniPart_SetFramePriorityOffsets

; ---------------------------------------------------------------------------
MHZMini_FramesByParentFrame:
                dc.b    $16, $16, $16, $16, $16, $17, $16, $16, $16, $16, $16, $16, $16, $16, $16, $16, $16, $16, $16, $16
                dc.b    $16, $16
                even
MHZMini_QueuePriorityByFrame:
                dc.w    $280
                dc.w    $280
                dc.w    $280
                dc.w    $280
                dc.w    $280
                dc.w    $280
                dc.w    $280
                dc.w    $280
                dc.w    $280
                dc.w    $280
                dc.w    $280
                dc.w    $180
                dc.w    $180
                dc.w    $180
                dc.w    $180
                dc.w    $180
                dc.w    $280
                dc.w    $280
                dc.w    $280
                dc.w    $180
                dc.w    $280
                dc.w    $280
MHZMini_OffsetPairsByFrame:
                dc.b    $B, $1C
                dc.b    1, $1C
                dc.b    $B, $1C
                dc.b    1, $1C
                dc.b    $B, $1C
                dc.b    1, $1C
                dc.b    $B, $1C
                dc.b    1, $1C
                dc.b    -8, $1C
                dc.b    -1, $1C
                dc.b    -$18, $12
                dc.b    -$11, $12
                dc.b    -8, $1C
                dc.b    -1, $1C
                dc.b    -8, $1C
                dc.b    -1, $1C
                dc.b    -$11, $1C
                dc.b    -$A, $1C
                dc.b    -8, $1C
                dc.b    -1, $1C
                dc.b    -$11, $1C
                dc.b    -$A, $1C
                dc.b    -8, $1C
                dc.b    $B, $1C
                dc.b    -8, $1B
                dc.b    $B, $1B
                dc.b    -8, $1C
                dc.b    $B, $1C
                dc.b    -8, $1C
                dc.b    $B, $1C
                dc.b    -8, $1C
                dc.b    $B, $1C
                dc.b    -8, $1C
                dc.b    -1, $1C
                dc.b    -$10, $1C
                dc.b    -9, $1C
                dc.b    -$11, $1C
                dc.b    -$A, $1C
                dc.b    -8, $1C
                dc.b    $B, $1C
                dc.b    $C, $1C
                dc.b    6, $1C
                dc.b    $B, $1C
                dc.b    1, $1C
                even

; =============== S U B R O U T I N E =======================================

MHZMini_SetPriorityFromFrame:
                moveq   #0,d0
                move.b  mapping_frame(a0),d0
                move.w  #$200,priority(a0)
                move.b  MHZMini_FrontQueueFlagsByFrame(pc,d0.w),d0
                beq.s   MHZMini_FrameSelectionReturn
                move.w  #$80,priority(a0)

MHZMini_FrameSelectionReturn:
                rts
; End of function MHZMini_SetPriorityFromFrame

; ---------------------------------------------------------------------------
MHZMini_FrontQueueFlagsByFrame:
                dc.b    0
                dc.b    0
                dc.b    0
                dc.b    0
                dc.b    1
                dc.b    1
                dc.b    1
                dc.b    1
                dc.b    1
                dc.b    0
                dc.b    0
                dc.b    0
                dc.b    0
                dc.b    0
                dc.b    0
                dc.b    0
                dc.b    0
                dc.b    0
                dc.b    0
                dc.b    0
                dc.b    0
                dc.b    0
                even

; =============== S U B R O U T I N E =======================================

HandleMHZMinibossFourColorHitOrDefeat:
                tst.b   collision_flags(a0)
                bne.s   MHZMini_HitUpdateReturn
                move.b  collision_property(a0),d0
                beq.s   MHZMini_BeginDefeatFadeAndExplosion
                tst.b   $20(a0)
                bne.s   MHZMini_HitChooseFlashRow
                move.b  #$20,$20(a0)
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l

MHZMini_HitChooseFlashRow:
                bset    #6,status(a0)
                moveq   #0,d0
                btst    #0,$20(a0)
                bne.s   MHZMini_HitCopyColorsAndTick
                addi.w  #2*4,d0

MHZMini_HitCopyColorsAndTick:
                bsr.w   CopyMHZMinibossFourColorPalette
                subq.b  #1,$20(a0)
                bne.s   MHZMini_HitUpdateReturn
                bclr    #6,status(a0)
                move.b  $25(a0),collision_flags(a0)

MHZMini_HitUpdateReturn:
                rts
; ---------------------------------------------------------------------------

MHZMini_BeginDefeatFadeAndExplosion:
                move.l  #Wait_FadeToLevelMusic,(a0)
                move.l  #MHZMini_StartEndSign,$34(a0)
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild6_Simple).l
                bne.s   MHZMini_StopTimerAndAwardScore
                move.b  #$10,subtype(a1)

MHZMini_StopTimerAndAwardScore:
                jmp     (BossDefeated_StopTimer).l
; End of function HandleMHZMinibossFourColorHitOrDefeat

; =============== S U B R O U T I N E =======================================

CopyMHZMinibossFourColorPalette:
                lea     MHZMini_HitPaletteDestinations(pc),a1
                lea     MHZMinibossRootHit_TwoFourColorProfiles(pc,d0.w),a2
                jmp     (CopyWordData_4).l
; End of function CopyMHZMinibossFourColorPalette

; ---------------------------------------------------------------------------
MHZMini_HitPaletteDestinations:
                dc.w    Normal_palette_line_2+$0E, Normal_palette_line_2+$16, Normal_palette_line_2+$1A, Normal_palette_line_2+$1C
MHZMinibossRootHit_TwoFourColorProfiles:
                dc.w    $224,  $222,  $A64,  $642
                dc.w    $AAA,  $EEE,  $888,  $666
; ---------------------------------------------------------------------------

MHZMini_AdvanceCameraIfSameOwner:
                move.w  (Camera_max_X_pos).w,d0
                cmp.w   $34(a0),d0
                bne.s   MHZMini_DeleteCameraAccelerator
                move.l  $30(a0),d1
                addi.l  #$4000,d1
                move.l  d1,$30(a0)
                swap    d1
                add.w   d1,d0
                cmp.w   (Camera_stored_max_X_pos).w,d0
                bhs.s   MHZMini_ClampCameraMaximum
                move.w  d0,(Camera_max_X_pos).w
                move.w  d0,$34(a0)
                rts
; ---------------------------------------------------------------------------

MHZMini_ClampCameraMaximum:
                move.w  (Camera_stored_max_X_pos).w,(Camera_max_X_pos).w

MHZMini_DeleteCameraAccelerator:
                jmp     (Delete_Current_Sprite).l
; End of function MHZMini_AdvanceCameraIfSameOwner
