; Owner: objects/ending/sk
; Responsibility: Ending child movement, parent-relative positioning and indexed character attachment offsets
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

EndingBobYFromSavedBaseAndByteSinePhase:
                move.b  $3C(a0),d0
                addq.b  #4,d0
                move.b  d0,$3C(a0)
                jsr     (GetSineCosine).l
                asr.w   #6,d0
                move.w  $3A(a0),d1
                add.w   d0,d1
                move.w  d1,y_pos(a0)
                rts
; End of function EndingBobYFromSavedBaseAndByteSinePhase

; =============== S U B R O U T I N E =======================================

EndingInitializeGentleVerticalSwing:
                move.w  #$80,d0
                move.w  d0,$3E(a0)
                move.w  d0,y_vel(a0)
                move.w  #8,$40(a0)
                bclr    #0,$38(a0)
                rts
; End of function EndingInitializeGentleVerticalSwing

; =============== S U B R O U T I N E =======================================

; Update both positions. One frame sequence has six steps, and the other alternates by V-int phase
EndingTornado_UpdateSubSprites:
                lea     EndingTornado_SubSpriteSignedOffsetPairs(pc),a1
                jsr     (SKMultiSprite_PositionChildren).l
                moveq   #0,d0
                move.b  $44(a0),d0
                addq.b  #1,d0
                cmpi.b  #6,d0
                blo.s   EndPlaneChild_StoreTornadoChildFrames
                moveq   #0,d0

EndPlaneChild_StoreTornadoChildFrames:
                move.b  d0,$44(a0)
                move.b  EndingTornado_FirstSubSpriteFrameCycle(pc,d0.w),$1D(a0)
                moveq   #6,d0
                btst    #0,(V_int_run_count+3).w
                beq.s   EndingTornado_StoreSecondSubSpriteFrame
                moveq   #7,d0

EndingTornado_StoreSecondSubSpriteFrame:
                move.b  d0,$23(a0)
                rts
; End of function EndingTornado_UpdateSubSprites

; ---------------------------------------------------------------------------
EndingTornado_SubSpriteSignedOffsetPairs:
                dc.b    $34,   4, $18, $18
EndingTornado_FirstSubSpriteFrameCycle:
                dc.b    2,   3,   4,   5,   4,   3
                even
; ---------------------------------------------------------------------------
; unused
                move.l  d0,(SceneTimerOrSharedMotionRecordBase).w
                add.l   d0,(SceneAuxiliaryXOrCompetitionTime).w
                move.l  d1,(SceneCreditIndexOrBossMotionPlanAngle).w
                add.l   d1,(SceneAuxiliaryYOrVerticalMotion).w
                rts

; =============== S U B R O U T I N E =======================================

EndingAttachment_SetOffsetsFromPose:
                movea.w parent3(a0),a1
                moveq   #0,d0
                move.b  mapping_frame(a1),d0
                subq.b  #1,d0
                add.w   d0,d0
                move.w  EndPlaneChild_ParentFrameOffsetIndex(pc,d0.w),d1
                lea     EndPlaneChild_ParentFrameOffsetIndex(pc,d1.w),a2
                tst.b   subtype(a0)
                beq.s   EndPlaneChild_StoreSelectedOffsetPair
                addq.w  #2,a2

EndPlaneChild_StoreSelectedOffsetPair:
                move.w  (a2)+,d0
                move.w  d0,child_dx(a0)                 ; and child_dy
                rts
; End of function EndingAttachment_SetOffsetsFromPose

; ---------------------------------------------------------------------------
EndPlaneChild_ParentFrameOffsetIndex:
                dc.w    EndPlaneChild_ParentFrame1Offsets-EndPlaneChild_ParentFrameOffsetIndex
                dc.w    EndPlaneChild_ParentFrame2Offsets-EndPlaneChild_ParentFrameOffsetIndex
                dc.w    EndPlaneChild_ParentFrame3Offsets-EndPlaneChild_ParentFrameOffsetIndex
EndPlaneChild_ParentFrame1Offsets:
                dc.b    -4,   -8
                dc.b    $10, -$14
EndPlaneChild_ParentFrame2Offsets:
                dc.b    -4,   -7
                dc.b    $10,  -$C
EndPlaneChild_ParentFrame3Offsets:
                dc.b    -4,   -4
                dc.b    $10,  -$A
