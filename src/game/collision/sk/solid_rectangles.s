; Owner: game/collision/sk
; Responsibility: Rectangular solid-platform collision variants, offsets and player attachment motion
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

SolidObjectFull:
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d6
                movem.l d1-d4,-(sp)
                bsr.s   SolidObjectFull_1P
                movem.l (sp)+,d1-d4
                lea     (Player_2).w,a1
                tst.b   render_flags(a1)
                bpl.w   SKSolid_FullReturn
                addq.b  #p2_standing_bit-p1_standing_bit,d6
; End of function SolidObjectFull

; =============== S U B R O U T I N E =======================================

SolidObjectFull_1P:
                btst    d6,status(a0)
                beq.w   SKSolid_CheckVisibleForNewContact
                move.w  d1,d2
                add.w   d2,d2
                btst    #Status_InAir,status(a1)
                bne.s   SKCollision_DetachFullSolidRider
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                bmi.s   SKCollision_DetachFullSolidRider
                cmp.w   d2,d0
                blo.s   SKCollision_CarryExistingFullSolidRider

SKCollision_DetachFullSolidRider:
                bclr    #Status_OnObj,status(a1)
                bset    #Status_InAir,status(a1)
                bclr    d6,status(a0)
                moveq   #0,d4
                rts
; ---------------------------------------------------------------------------

SKCollision_CarryExistingFullSolidRider:
                move.w  d4,d2
                bsr.w   MvSonicOnPtfm
                moveq   #0,d4

SKSolid_FullReturn:
                rts
; End of function SolidObjectFull_1P

; =============== S U B R O U T I N E =======================================

SolidObjectFull2:
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d6
                movem.l d1-d4,-(sp)
                bsr.s   SolidObjectFull2_1P
                movem.l (sp)+,d1-d4
                lea     (Player_2).w,a1
                addq.b  #p2_standing_bit-p1_standing_bit,d6
; End of function SolidObjectFull2

; =============== S U B R O U T I N E =======================================

SolidObjectFull2_1P:
                btst    d6,status(a0)
                beq.w   SolidObject_cont
                move.w  d1,d2
                add.w   d2,d2
                btst    #Status_InAir,status(a1)
                bne.s   SKSolidUngated_DetachRider
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                bmi.s   SKSolidUngated_DetachRider
                cmp.w   d2,d0
                blo.s   SKSolidUngated_CarryRider

SKSolidUngated_DetachRider:
                bclr    #Status_OnObj,status(a1)
                bset    #Status_InAir,status(a1)
                bclr    d6,status(a0)
                moveq   #0,d4
                rts
; ---------------------------------------------------------------------------

SKSolidUngated_CarryRider:
                move.w  d4,d2
                bsr.w   MvSonicOnPtfm
                moveq   #0,d4
                rts
; End of function SolidObjectFull2_1P

; =============== S U B R O U T I N E =======================================

CollidePlayersWithHeightProfileSolid:
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d6
                movem.l d1-d4,-(sp)
                bsr.s   CollidePlayerWithHeightProfileSolid
                movem.l (sp)+,d1-d4
                lea     (Player_2).w,a1
                addq.b  #p2_standing_bit-p1_standing_bit,d6
; End of function CollidePlayersWithHeightProfileSolid

; =============== S U B R O U T I N E =======================================

CollidePlayerWithHeightProfileSolid:
                btst    d6,status(a0)
                beq.w   SKSolidHalf_CheckNewContact
                move.w  d1,d2
                add.w   d2,d2
                btst    #Status_InAir,status(a1)
                bne.s   SKSolidHalf_DetachRider
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                bmi.s   SKSolidHalf_DetachRider
                cmp.w   d2,d0
                blo.s   SKSolidHalf_CarryAndMarkTop

SKSolidHalf_DetachRider:
                bclr    #Status_OnObj,status(a1)
                bset    #Status_InAir,status(a1)
                bclr    d6,status(a0)
                moveq   #0,d4
                rts
; ---------------------------------------------------------------------------

SKSolidHalf_CarryAndMarkTop:
                move.w  d4,d2
                bsr.w   SolidObjSloped2
                move.w  d6,d4
                addi.b  #$11,d4
                bset    d4,d6
                moveq   #0,d4
                rts
; End of function CollidePlayerWithHeightProfileSolid

; ---------------------------------------------------------------------------
; unused leftover from Sonic 2
; DoubleSlopedSolid:
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d6
                movem.l d1-d4,-(sp)
                bsr.s   CollidePlayerWithDualHeightProfileSolid
                movem.l (sp)+,d1-d4
                lea     (Player_2).w,a1
                addq.b  #p2_standing_bit-p1_standing_bit,d6

; =============== S U B R O U T I N E =======================================

CollidePlayerWithDualHeightProfileSolid:
                btst    d6,status(a0)
                beq.w   SKSolidDual_CheckNewContact
                move.w  d1,d2
                add.w   d2,d2
                btst    #Status_InAir,status(a1)
                bne.s   SKCollision_DetachDualHeightProfileRider
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                bmi.s   SKCollision_DetachDualHeightProfileRider
                cmp.w   d2,d0
                blo.s   SKCollision_CarryDualHeightProfileRider

SKCollision_DetachDualHeightProfileRider:
                bclr    #Status_OnObj,status(a1)
                bset    #Status_InAir,status(a1)
                bclr    d6,status(a0)
                moveq   #0,d4
                rts
; ---------------------------------------------------------------------------

SKCollision_CarryDualHeightProfileRider:
                move.w  d4,d2
                bsr.w   SolidObjSloped4
                moveq   #0,d4
                rts
; End of function CollidePlayerWithDualHeightProfileSolid

; =============== S U B R O U T I N E =======================================

HeightProfile_CollideBothKeepAir:
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d6
                movem.l d1-d4,-(sp)
                bsr.s   HeightProfile_CollideOneKeepAir
                movem.l (sp)+,d1-d4
                lea     (Player_2).w,a1
                addq.b  #p2_standing_bit-p1_standing_bit,d6
; End of function HeightProfile_CollideBothKeepAir

; =============== S U B R O U T I N E =======================================

; Use half-resolution height bytes. Release a rider by clearing its standing flags and preserving InAir
HeightProfile_CollideOneKeepAir:
                btst    d6,status(a0)
                beq.w   SKSolidHalf_CheckNewContact
                move.w  d1,d2
                add.w   d2,d2
                btst    #Status_InAir,status(a1)
                bne.s   SKSolidKeepAir_DetachRider
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                bmi.s   SKSolidKeepAir_DetachRider
                cmp.w   d2,d0
                blo.s   SKSolidKeepAir_CarryAndMarkTop

SKSolidKeepAir_DetachRider:
                bclr    #Status_OnObj,status(a1)
                bclr    d6,status(a0)
                moveq   #0,d4
                rts
; ---------------------------------------------------------------------------

SKSolidKeepAir_CarryAndMarkTop:
                move.w  d4,d2
                bsr.w   SolidObjSloped2
                move.w  d6,d4
                addi.b  #$11,d4
                bset    d4,d6
                moveq   #0,d4
                rts
; End of function HeightProfile_CollideOneKeepAir

; =============== S U B R O U T I N E =======================================

SolidObjectFull_Offset:
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d6
                movem.l d1-d4,-(sp)
                bsr.s   SolidObjectFull_Offset_1P
                movem.l (sp)+,d1-d4
                lea     (Player_2).w,a1
                addq.b  #p2_standing_bit-p1_standing_bit,d6
; End of function SolidObjectFull_Offset

; =============== S U B R O U T I N E =======================================

SolidObjectFull_Offset_1P:
                btst    d6,status(a0)
                beq.w   SKSolidOffset_CheckNewContact
                btst    #Status_InAir,status(a1)
                bne.s   SKCollision_DetachOffsetFullSolidRider
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                bmi.s   SKCollision_DetachOffsetFullSolidRider
                add.w   d1,d1
                cmp.w   d1,d0
                blo.s   SKSolidOffset_SnapAndCarryX

SKCollision_DetachOffsetFullSolidRider:
                bclr    #Status_OnObj,status(a1)
                bset    #Status_InAir,status(a1)
                bclr    d6,status(a0)
                moveq   #0,d4
                rts
; ---------------------------------------------------------------------------

SKSolidOffset_SnapAndCarryX:
                move.w  y_pos(a0),d0
                sub.w   d2,d0
                add.w   d3,d0
                moveq   #0,d1
                move.b  y_radius(a1),d1
                sub.w   d1,d0
                move.w  d0,y_pos(a1)
                sub.w   x_pos(a0),d4
                sub.w   d4,x_pos(a1)
                moveq   #0,d4
                rts
; ---------------------------------------------------------------------------

SKSolidOffset_CheckNewContact:
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                bmi.w   SKSolid_ClearStalePush
                move.w  d1,d4
                add.w   d4,d4
                cmp.w   d4,d0
                bhi.w   SKSolid_ClearStalePush
                move.w  y_pos(a0),d5
                add.w   d3,d5
                move.b  y_radius(a1),d3
                ext.w   d3
                add.w   d3,d2
                move.w  y_pos(a1),d3
                sub.w   d5,d3
                addq.w  #4,d3
                add.w   d2,d3
                bmi.w   SKSolid_ClearStalePush
                move.w  d2,d4
                add.w   d4,d4
                cmp.w   d4,d3
                bhs.w   SKSolid_ClearStalePush
                bra.w   SKSolid_CheckStateAndResolveX
; ---------------------------------------------------------------------------

SKSolidHalf_CheckNewContact:
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                bmi.w   SKSolid_ClearStalePush
                move.w  d1,d3
                add.w   d3,d3
                cmp.w   d3,d0
                bhi.w   SKSolid_ClearStalePush
                move.w  d0,d5
                btst    #0,render_flags(a0)
                beq.s   SKSolidHalf_BuildRelativeOverlap
                not.w   d5
                add.w   d3,d5

; Subtract the base height in byte precision before sign-extending the difference
SKSolidHalf_BuildRelativeOverlap:
                lsr.w   #1,d5
                move.b  (a2,d5.w),d3
                sub.b   (a2),d3
                ext.w   d3
                move.w  y_pos(a0),d5
                sub.w   d3,d5
                move.b  y_radius(a1),d3
                ext.w   d3
                add.w   d3,d2
                move.w  y_pos(a1),d3
                sub.w   d5,d3
                addq.w  #4,d3
                add.w   d2,d3
                bmi.w   SKSolid_ClearStalePush
                move.w  d2,d4
                add.w   d4,d4
                cmp.w   d4,d3
                bhs.w   SKSolid_ClearStalePush
                bra.w   SKSolid_CheckStateAndResolveX
; ---------------------------------------------------------------------------

SKSolidDual_CheckNewContact:
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                bmi.w   SKSolid_ClearStalePush
                move.w  d1,d3
                add.w   d3,d3
                cmp.w   d3,d0
                bhi.w   SKSolid_ClearStalePush
                move.w  d0,d5
                btst    #0,render_flags(a0)
                beq.s   SKSolidDual_ReadTopAndExtent
                not.w   d5
                add.w   d3,d5

; Align the index to an even byte and read the top and extent from adjacent signed bytes
SKSolidDual_ReadTopAndExtent:
                andi.w  #$FFFE,d5
                move.b  (a2,d5.w),d3
                move.b  1(a2,d5.w),d2
                ext.w   d2
                ext.w   d3
                move.w  y_pos(a0),d5
                sub.w   d3,d5
                move.w  y_pos(a1),d3
                sub.w   d5,d3
                move.b  y_radius(a1),d5
                ext.w   d5
                add.w   d5,d3
                addq.w  #4,d3
                bmi.w   SKSolid_ClearStalePush
                add.w   d5,d2
                move.w  d2,d4
                add.w   d5,d4
                cmp.w   d4,d3
                bhs.w   SKSolid_ClearStalePush
                bra.w   SKSolid_CheckStateAndResolveX
; ---------------------------------------------------------------------------

SKSolid_CheckVisibleForNewContact:
                tst.b   render_flags(a0)
                bpl.w   SKSolid_ClearStalePush

SolidObject_cont:
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                move.w  d1,d3
                add.w   d3,d3
                cmp.w   d3,d0
                bhi.w   SKSolid_ClearStalePush
                tst.b   (Reverse_gravity_flag).w
                beq.s   SKSolid_ComputeWrapped12BitY
                move.b  default_y_radius(a1),d4
                ext.w   d4
                add.w   d2,d4
                move.b  y_radius(a1),d3
                ext.w   d3
                add.w   d3,d2
                move.w  y_pos(a1),d3
                sub.w   y_pos(a0),d3
                neg.w   d3
                addq.w  #4,d3
                add.w   d2,d3
                andi.w  #$FFF,d3
                add.w   d2,d4
                cmp.w   d4,d3
                bhs.w   SKSolid_ClearStalePush
                bra.s   SKSolid_CheckStateAndResolveX
; ---------------------------------------------------------------------------

SKSolid_ComputeWrapped12BitY:
                move.b  default_y_radius(a1),d4
                ext.w   d4
                add.w   d2,d4
                move.b  y_radius(a1),d3
                ext.w   d3
                add.w   d3,d2
                move.w  y_pos(a1),d3
                sub.w   y_pos(a0),d3
                addq.w  #4,d3
                add.w   d2,d3
                andi.w  #$FFF,d3
                add.w   d2,d4
                cmp.w   d4,d3
                bhs.w   SKSolid_ClearStalePush

SKSolid_CheckStateAndResolveX:
                tst.b   object_control(a1)
                bmi.w   SKSolid_ClearStalePush
                cmpi.b  #6,routine(a1)
                bhs.w   SKSolid_ReturnZeroD4
                tst.w   (Debug_placement_mode).w
                bne.w   SKSolid_ReturnZeroD4
                move.w  d0,d5
                cmp.w   d0,d1
                bhs.s   SKSolid_ChooseYCorrection
                add.w   d1,d1
                sub.w   d1,d0
                move.w  d0,d5
                neg.w   d5

SKSolid_ChooseYCorrection:
                move.w  d3,d1
                cmp.w   d3,d2
                bhs.s   SKSolid_ChooseResolutionAxis
                subq.w  #4,d3
                sub.w   d4,d3
                move.w  d3,d1
                neg.w   d1

SKSolid_ChooseResolutionAxis:
                cmp.w   d1,d5
                bhi.w   SKSolidY_ClassifyContact
                cmpi.w  #4,d1
                bls.w   SKSolidY_ClassifyContact

SKSolidSide_CheckMotionDirection:
                tst.w   d0
                beq.s   SKSolidSide_SeparateAndMarkPush
                bmi.s   SKSolidSide_CheckNegativeXMotion
                tst.w   x_vel(a1)
                bmi.s   SKSolidSide_SeparateAndMarkPush
                bra.s   SKSolidSide_StopAndFlagImpact
; ---------------------------------------------------------------------------

SKSolidSide_CheckNegativeXMotion:
                tst.w   x_vel(a1)
                bpl.s   SKSolidSide_SeparateAndMarkPush

SKSolidSide_StopAndFlagImpact:
                move.w  #0,ground_vel(a1)
                move.w  #0,x_vel(a1)
                tst.b   status_tertiary(a1)
                bpl.s   SKSolidSide_SeparateAndMarkPush
                bset    #6,status_tertiary(a1)

SKSolidSide_SeparateAndMarkPush:
                sub.w   d0,x_pos(a1)
                btst    #Status_InAir,status(a1)
                bne.s   SKSolidSide_ClearAirbornePush
                move.l  d6,d4
                addq.b  #pushing_bit_delta,d4
                bset    d4,status(a0)
                bset    #Status_Push,status(a1)
                move.w  d6,d4
                addi.b  #$D,d4
                bset    d4,d6
                moveq   #1,d4
                rts
; ---------------------------------------------------------------------------

SKSolidSide_ClearAirbornePush:
                bsr.s   ClearPlayerPushingSolid
                move.w  d6,d4
                addi.b  #$D,d4
                bset    d4,d6
                moveq   #1,d4
                rts
; ---------------------------------------------------------------------------

SKSolid_ClearStalePush:
                move.l  d6,d4
                addq.b  #pushing_bit_delta,d4
                btst    d4,status(a0)
                beq.s   SKSolid_ReturnZeroD4
                cmpi.b  #2,anim(a1)
                beq.s   ClearPlayerPushingSolid
                cmpi.b  #9,anim(a1)
                beq.s   ClearPlayerPushingSolid
                move.w  #1,anim(a1)
; End of function SolidObjectFull_Offset_1P

; =============== S U B R O U T I N E =======================================

ClearPlayerPushingSolid:
                move.l  d6,d4
                addq.b  #pushing_bit_delta,d4
                bclr    d4,status(a0)
                bclr    #Status_Push,status(a1)

SKSolid_ReturnZeroD4:
                moveq   #0,d4
                rts
; End of function ClearPlayerPushingSolid

; ---------------------------------------------------------------------------

SKSolidY_ClassifyContact:
                tst.w   d3
                bmi.s   SKSolidUnder_CheckPlayerMotion
                cmpi.w  #$10,d3
                blo.s   SKSolidTop_CheckVisualWidth
                bra.s   SKSolid_ClearStalePush
; ---------------------------------------------------------------------------

SKSolidUnder_CheckPlayerMotion:
                btst    #Status_InAir,status(a1)
                bne.s   SKSolidUnder_StopGroundSpeed
                tst.w   y_vel(a1)
                beq.s   SKSolidUnder_MeasureCrushDepth
                bpl.s   SKCollision_FlagTertiaryUndersideImpact
                tst.w   d3
                bpl.s   SKCollision_FlagTertiaryUndersideImpact
                bra.s   SKSolidUnder_ApplyGravityToY
; ---------------------------------------------------------------------------

SKSolidUnder_StopGroundSpeed:
                move.w  #0,ground_vel(a1)

SKSolidUnder_ApplyGravityToY:
                tst.b   (Reverse_gravity_flag).w
                beq.s   SKSolidUnder_SeparateAndStopY
                neg.w   d3

SKSolidUnder_SeparateAndStopY:
                sub.w   d3,y_pos(a1)
                move.w  #0,y_vel(a1)

SKCollision_FlagTertiaryUndersideImpact:
                tst.b   status_tertiary(a1)
                bpl.s   SKSolidUnder_MarkAndReturnMinus2
                bset    #5,status_tertiary(a1)

SKSolidUnder_MarkAndReturnMinus2:
                move.w  d6,d4
                addi.b  #$F,d4
                bset    d4,d6
                moveq   #-2,d4
                rts
; ---------------------------------------------------------------------------

SKSolidUnder_MeasureCrushDepth:
                btst    #Status_InAir,status(a1)
                bne.s   SKCollision_FlagTertiaryUndersideImpact
                move.w  d0,d4
                bpl.s   SKSolidUnder_CheckCrush
                neg.w   d4

; Route penetration below 16 pixels to side resolution
SKSolidUnder_CheckCrush:
                cmpi.w  #$10,d4
                blo.w   SKSolidSide_CheckMotionDirection
                move.l  a0,-(sp)
                movea.l a1,a0
                jsr     (Kill_Character).l
                movea.l (sp)+,a0
                move.w  d6,d4
                addi.b  #$F,d4
                bset    d4,d6
                moveq   #-2,d4
                rts
; ---------------------------------------------------------------------------

SKSolidTop_CheckVisualWidth:
                subq.w  #4,d3
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                move.w  d1,d2
                add.w   d2,d2
                add.w   x_pos(a1),d1
                sub.w   x_pos(a0),d1
                bmi.s   SKSolidTop_ReturnZeroD4
                cmp.w   d2,d1
                bhs.s   SKSolidTop_ReturnZeroD4
                subq.w  #1,y_pos(a1)
                tst.b   (Reverse_gravity_flag).w
                beq.s   SKSolidTop_SnapAndTryRide
                neg.w   d3
                addq.w  #2,y_pos(a1)

; Position correction precedes the velocity check. Only a nonnegative Y speed attaches the rider
SKSolidTop_SnapAndTryRide:
                sub.w   d3,y_pos(a1)
                tst.w   y_vel(a1)
                bmi.s   SKSolidTop_ReturnZeroD4
                bsr.w   RideObject_SetRide
                move.w  d6,d4
                addi.b  #$11,d4
                bset    d4,d6
                moveq   #-1,d4
                rts
; ---------------------------------------------------------------------------

SKSolidTop_ReturnZeroD4:
                moveq   #0,d4
                rts

; =============== S U B R O U T I N E =======================================

MvSonicOnPtfm:
                tst.b   (Reverse_gravity_flag).w
                bne.s   SKSolidRide_ComputeReverseSurface
                move.w  y_pos(a0),d0
                sub.w   d3,d0
                bra.s   SKSolidRide_CarryAboveSurface
; ---------------------------------------------------------------------------

SKSolidRide_ComputeReverseSurface:
                move.w  y_pos(a0),d0
                add.w   d3,d0
                bra.s   SKSolidRide_CarryBelowSurface
; ---------------------------------------------------------------------------
; This is hilarious. The unused S1 code was upgraded with an S3K feature
                tst.b   (Reverse_gravity_flag).w
                beq.s   SKSolidRide_ComputeSurfaceMinus9
                move.w  y_pos(a0),d0
                addi.w  #9,d0
                bra.s   SKSolidRide_CarryBelowSurface
; ---------------------------------------------------------------------------

SKSolidRide_ComputeSurfaceMinus9:
                move.w  y_pos(a0),d0
                subi.w  #9,d0

SKSolidRide_CarryAboveSurface:
                tst.b   object_control(a1)
                bmi.s   SKSolidRide_AboveReturn
                cmpi.b  #6,routine(a1)
                bhs.s   SKSolidRide_AboveReturn
                tst.w   (Debug_placement_mode).w
                bne.s   SKSolidRide_AboveReturn
                moveq   #0,d1
                move.b  y_radius(a1),d1
                sub.w   d1,d0
                move.w  d0,y_pos(a1)
                sub.w   x_pos(a0),d2
                sub.w   d2,x_pos(a1)

SKSolidRide_AboveReturn:
                rts
; ---------------------------------------------------------------------------

SKSolidRide_CarryBelowSurface:
                tst.b   object_control(a1)
                bmi.s   SKSolidRide_BelowReturn
                cmpi.b  #6,routine(a1)
                bhs.s   SKSolidRide_BelowReturn
                tst.w   (Debug_placement_mode).w
                bne.s   SKSolidRide_BelowReturn
                moveq   #0,d1
                move.b  y_radius(a1),d1
                add.w   d1,d0
                move.w  d0,y_pos(a1)
                sub.w   x_pos(a0),d2
                sub.w   d2,x_pos(a1)

SKSolidRide_BelowReturn:
                rts
; End of function MvSonicOnPtfm
