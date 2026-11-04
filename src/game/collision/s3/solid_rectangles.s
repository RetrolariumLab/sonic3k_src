; Owner: game/collision/s3
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
                bpl.w   S3Solid_FullReturn
                addq.b  #p2_standing_bit-p1_standing_bit,d6
; End of function SolidObjectFull

; =============== S U B R O U T I N E =======================================

SolidObjectFull_1P:
                btst    d6,status(a0)
                beq.w   S3Solid_CheckVisibleForNewContact
                move.w  d1,d2
                add.w   d2,d2
                btst    #Status_InAir,status(a1)
                bne.s   S3SolidFull_DetachRider
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                bmi.s   S3SolidFull_DetachRider
                cmp.w   d2,d0
                blo.s   S3SolidFull_CarryRider

S3SolidFull_DetachRider:
                bclr    #Status_OnObj,status(a1)
                bset    #Status_InAir,status(a1)
                bclr    d6,status(a0)
                moveq   #0,d4
                rts
; ---------------------------------------------------------------------------

S3SolidFull_CarryRider:
                move.w  d4,d2
                bsr.w   MvSonicOnPtfm
                moveq   #0,d4

S3Solid_FullReturn:
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
                bne.s   S3SolidUngated_DetachRider
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                bmi.s   S3SolidUngated_DetachRider
                cmp.w   d2,d0
                blo.s   S3SolidUngated_CarryRider

S3SolidUngated_DetachRider:
                bclr    #Status_OnObj,status(a1)
                bset    #Status_InAir,status(a1)
                bclr    d6,status(a0)
                moveq   #0,d4
                rts
; ---------------------------------------------------------------------------

S3SolidUngated_CarryRider:
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
                beq.w   S3SolidHalf_CheckNewContact
                move.w  d1,d2
                add.w   d2,d2
                btst    #Status_InAir,status(a1)
                bne.s   S3SolidHalf_DetachRider
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                bmi.s   S3SolidHalf_DetachRider
                cmp.w   d2,d0
                blo.s   S3SolidHalf_CarryAndMarkTop

S3SolidHalf_DetachRider:
                bclr    #Status_OnObj,status(a1)
                bset    #Status_InAir,status(a1)
                bclr    d6,status(a0)
                moveq   #0,d4
                rts
; ---------------------------------------------------------------------------

S3SolidHalf_CarryAndMarkTop:
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
                beq.w   S3SolidDual_CheckNewContact
                move.w  d1,d2
                add.w   d2,d2
                btst    #Status_InAir,status(a1)
                bne.s   S3SolidDual_DetachRider
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                bmi.s   S3SolidDual_DetachRider
                cmp.w   d2,d0
                blo.s   S3Collision_CarryDualHeightProfileRider

S3SolidDual_DetachRider:
                bclr    #Status_OnObj,status(a1)
                bset    #Status_InAir,status(a1)
                bclr    d6,status(a0)
                moveq   #0,d4
                rts
; ---------------------------------------------------------------------------

S3Collision_CarryDualHeightProfileRider:
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
                beq.w   S3SolidHalf_CheckNewContact
                move.w  d1,d2
                add.w   d2,d2
                btst    #Status_InAir,status(a1)
                bne.s   S3SolidKeepAir_DetachRider
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                bmi.s   S3SolidKeepAir_DetachRider
                cmp.w   d2,d0
                blo.s   S3SolidKeepAir_CarryAndMarkTop

S3SolidKeepAir_DetachRider:
                bclr    #Status_OnObj,status(a1)
                bclr    d6,status(a0)
                moveq   #0,d4
                rts
; ---------------------------------------------------------------------------

S3SolidKeepAir_CarryAndMarkTop:
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
                beq.w   S3SolidOffset_CheckNewContact
                btst    #Status_InAir,status(a1)
                bne.s   S3Collision_ReleaseOffsetRectangleRider
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                bmi.s   S3Collision_ReleaseOffsetRectangleRider
                add.w   d1,d1
                cmp.w   d1,d0
                blo.s   S3SolidOffset_SnapAndCarryX

S3Collision_ReleaseOffsetRectangleRider:
                bclr    #Status_OnObj,status(a1)
                bset    #Status_InAir,status(a1)
                bclr    d6,status(a0)
                moveq   #0,d4
                rts
; ---------------------------------------------------------------------------

S3SolidOffset_SnapAndCarryX:
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

S3SolidOffset_CheckNewContact:
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                bmi.w   S3Solid_ClearStalePush
                move.w  d1,d4
                add.w   d4,d4
                cmp.w   d4,d0
                bhi.w   S3Solid_ClearStalePush
                move.w  y_pos(a0),d5
                add.w   d3,d5
                move.b  y_radius(a1),d3
                ext.w   d3
                add.w   d3,d2
                move.w  y_pos(a1),d3
                sub.w   d5,d3
                addq.w  #4,d3
                add.w   d2,d3
                bmi.w   S3Solid_ClearStalePush
                move.w  d2,d4
                add.w   d4,d4
                cmp.w   d4,d3
                bhs.w   S3Solid_ClearStalePush
                bra.w   S3Solid_CheckStateAndResolveX
; ---------------------------------------------------------------------------

S3SolidHalf_CheckNewContact:
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                bmi.w   S3Solid_ClearStalePush
                move.w  d1,d3
                add.w   d3,d3
                cmp.w   d3,d0
                bhi.w   S3Solid_ClearStalePush
                move.w  d0,d5
                btst    #0,render_flags(a0)
                beq.s   S3SolidHalf_BuildRelativeOverlap
                not.w   d5
                add.w   d3,d5

; Subtract the base height in byte precision before sign-extending the difference
S3SolidHalf_BuildRelativeOverlap:
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
                bmi.w   S3Solid_ClearStalePush
                move.w  d2,d4
                add.w   d4,d4
                cmp.w   d4,d3
                bhs.w   S3Solid_ClearStalePush
                bra.w   S3Solid_CheckStateAndResolveX
; ---------------------------------------------------------------------------

S3SolidDual_CheckNewContact:
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                bmi.w   S3Solid_ClearStalePush
                move.w  d1,d3
                add.w   d3,d3
                cmp.w   d3,d0
                bhi.w   S3Solid_ClearStalePush
                move.w  d0,d5
                btst    #0,render_flags(a0)
                beq.s   S3SolidDual_ReadTopAndExtent
                not.w   d5
                add.w   d3,d5

; Align the index to an even byte and read the top and extent from adjacent signed bytes
S3SolidDual_ReadTopAndExtent:
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
                bmi.w   S3Solid_ClearStalePush
                add.w   d5,d2
                move.w  d2,d4
                add.w   d5,d4
                cmp.w   d4,d3
                bhs.w   S3Solid_ClearStalePush
                bra.w   S3Solid_CheckStateAndResolveX
; ---------------------------------------------------------------------------

S3Solid_CheckVisibleForNewContact:
                tst.b   render_flags(a0)
                bpl.w   S3Solid_ClearStalePush

SolidObject_cont:
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                bmi.w   S3Solid_ClearStalePush
                move.w  d1,d3
                add.w   d3,d3
                cmp.w   d3,d0
                bhi.w   S3Solid_ClearStalePush
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
                bmi.w   S3Solid_ClearStalePush
                andi.w  #$FFF,d3
                add.w   d2,d4
                cmp.w   d4,d3
                bhs.w   S3Solid_ClearStalePush

S3Solid_CheckStateAndResolveX:
                tst.b   object_control(a1)
                bmi.w   S3Solid_ClearStalePush
                cmpi.b  #6,routine(a1)
                bhs.w   S3Solid_ReturnZeroD4
                tst.w   (Debug_placement_mode).w
                bne.w   S3Solid_ReturnZeroD4
                move.w  d0,d5
                cmp.w   d0,d1
                bhs.s   S3Solid_ChooseYCorrection
                add.w   d1,d1
                sub.w   d1,d0
                move.w  d0,d5
                neg.w   d5

S3Solid_ChooseYCorrection:
                move.w  d3,d1
                cmp.w   d3,d2
                bhs.s   S3Solid_ChooseResolutionAxis
                subq.w  #4,d3
                sub.w   d4,d3
                move.w  d3,d1
                neg.w   d1

S3Solid_ChooseResolutionAxis:
                cmp.w   d1,d5
                bhi.w   S3SolidY_ClassifyContact

S3SolidSide_CheckMotionDirection:
                cmpi.w  #4,d1
                bls.w   S3SolidY_ClassifyContact
                tst.w   d0
                beq.s   S3SolidSide_SeparateAndMarkPush
                bmi.s   S3SolidSide_CheckNegativeXMotion
                tst.w   x_vel(a1)
                bmi.s   S3SolidSide_SeparateAndMarkPush
                bra.s   S3SolidSide_StopAndFlagImpact
; ---------------------------------------------------------------------------

S3SolidSide_CheckNegativeXMotion:
                tst.w   x_vel(a1)
                bpl.s   S3SolidSide_SeparateAndMarkPush

S3SolidSide_StopAndFlagImpact:
                move.w  #0,ground_vel(a1)
                move.w  #0,x_vel(a1)
                tst.b   status_tertiary(a1)
                bpl.s   S3SolidSide_SeparateAndMarkPush
                bset    #6,status_tertiary(a1)

S3SolidSide_SeparateAndMarkPush:
                sub.w   d0,x_pos(a1)
                btst    #Status_InAir,status(a1)
                bne.s   S3SolidSide_ClearAirbornePush
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

S3SolidSide_ClearAirbornePush:
                bsr.s   ClearPlayerPushingSolid
                move.w  d6,d4
                addi.b  #$D,d4
                bset    d4,d6
                moveq   #1,d4
                rts
; ---------------------------------------------------------------------------

S3Solid_ClearStalePush:
                move.l  d6,d4
                addq.b  #pushing_bit_delta,d4
                btst    d4,status(a0)
                beq.s   S3Solid_ReturnZeroD4
                cmpi.b  #2,anim(a1)
                beq.s   ClearPlayerPushingSolid
                move.w  #1,anim(a1)
; End of function SolidObjectFull_Offset_1P

; =============== S U B R O U T I N E =======================================

ClearPlayerPushingSolid:
                move.l  d6,d4
                addq.b  #pushing_bit_delta,d4
                bclr    d4,status(a0)
                bclr    #Status_Push,status(a1)

S3Solid_ReturnZeroD4:
                moveq   #0,d4
                rts
; End of function ClearPlayerPushingSolid

; ---------------------------------------------------------------------------

S3SolidY_ClassifyContact:
                tst.w   d3
                bmi.s   S3SolidUnder_CheckPlayerMotion
                cmpi.w  #$10,d3
                blo.s   S3SolidTop_CheckVisualWidth
                bra.s   S3Solid_ClearStalePush
; ---------------------------------------------------------------------------

S3SolidUnder_CheckPlayerMotion:
                btst    #Status_InAir,status(a1)
                bne.s   S3SolidUnder_StopGroundSpeed
                tst.w   y_vel(a1)
                beq.s   S3SolidUnder_MeasureCrushDepth
                bpl.s   S3SolidUnder_FlagTertiaryImpact
                tst.w   d3
                bpl.s   S3SolidUnder_FlagTertiaryImpact
                bra.s   S3SolidUnder_SeparateAndStopY
; ---------------------------------------------------------------------------

S3SolidUnder_StopGroundSpeed:
                move.w  #0,ground_vel(a1)

S3SolidUnder_SeparateAndStopY:
                sub.w   d3,y_pos(a1)
                move.w  #0,y_vel(a1)

S3SolidUnder_FlagTertiaryImpact:
                tst.b   status_tertiary(a1)
                bpl.s   S3Collision_ReturnUndersideContactResult
                bset    #5,status_tertiary(a1)

S3Collision_ReturnUndersideContactResult:
                move.w  d6,d4
                addi.b  #$F,d4
                bset    d4,d6
                moveq   #-2,d4
                rts
; ---------------------------------------------------------------------------

S3SolidUnder_MeasureCrushDepth:
                btst    #Status_InAir,status(a1)
                bne.s   S3SolidUnder_FlagTertiaryImpact
                move.w  d0,d4
                bpl.s   S3SolidUnder_CheckCrush
                neg.w   d4

; Route penetration below 16 pixels to side resolution
S3SolidUnder_CheckCrush:
                cmpi.w  #$10,d4
                blo.w   S3SolidSide_CheckMotionDirection
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

S3SolidTop_CheckVisualWidth:
                subq.w  #4,d3
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                move.w  d1,d2
                add.w   d2,d2
                add.w   x_pos(a1),d1
                sub.w   x_pos(a0),d1
                bmi.s   S3SolidTop_ReturnZeroD4
                cmp.w   d2,d1
                bhs.s   S3SolidTop_ReturnZeroD4
                sub.w   d3,y_pos(a1)
                subq.w  #1,y_pos(a1)
                tst.w   y_vel(a1)
                bmi.s   S3SolidTop_ReturnZeroD4
                bsr.w   RideObject_SetRide
                move.w  d6,d4
                addi.b  #$11,d4
                bset    d4,d6
                moveq   #-1,d4
                rts
; ---------------------------------------------------------------------------

S3SolidTop_ReturnZeroD4:
                moveq   #0,d4
                rts

; =============== S U B R O U T I N E =======================================

MvSonicOnPtfm:
                move.w  y_pos(a0),d0
                sub.w   d3,d0
                bra.s   S3SolidRide_CarryAboveSurface
; ---------------------------------------------------------------------------
; unused leftover from Sonic 1/2
                move.w  y_pos(a0),d0
                subi.w  #9,d0

S3SolidRide_CarryAboveSurface:
                tst.b   object_control(a1)
                bmi.s   S3SolidRide_AboveReturn
                cmpi.b  #6,routine(a1)
                bhs.s   S3SolidRide_AboveReturn
                tst.w   (Debug_placement_mode).w
                bne.s   S3SolidRide_AboveReturn
                moveq   #0,d1
                move.b  y_radius(a1),d1
                sub.w   d1,d0
                move.w  d0,y_pos(a1)
                sub.w   x_pos(a0),d2
                sub.w   d2,x_pos(a1)

S3SolidRide_AboveReturn:
                rts
; End of function MvSonicOnPtfm
