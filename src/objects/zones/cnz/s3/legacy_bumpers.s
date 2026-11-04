; Owner: objects/zones/cnz/s3
; Responsibility: Preserved Carnival Night bumper streaming, collision and player rebound behavior
; Source provenance and ranges: config/reconstruction/source_layout.json
S2_SpecialCNZBumpers:
                moveq   #0,d0
                move.b  (CNZ_bumper_routine).w,d0
                move.w  SpecialCNZBumpers_Index(pc,d0.w),d0
                jmp     SpecialCNZBumpers_Index(pc,d0.w)
; End of function S2_SpecialCNZBumpers

; ---------------------------------------------------------------------------
SpecialCNZBumpers_Index:
                dc.w    SpecialCNZBumpers_Init-SpecialCNZBumpers_Index
                dc.w    SpecialCNZBumpers_Main-SpecialCNZBumpers_Index
; ---------------------------------------------------------------------------

SpecialCNZBumpers_Init:
                addq.b  #2,(CNZ_bumper_routine).w
                lea     (SpecialCNZBumpers_Act1).l,a1
                tst.b   (Current_act).w
                beq.s   S3CNZLegacyBump_InitCameraWindow
                lea     (SpecialCNZBumpers_Act2).l,a1

S3CNZLegacyBump_InitCameraWindow:
                move.w  (Camera_X_pos).w,d4
                subq.w  #8,d4
                bhi.s   S3CNZLegacyBump_FindInitialStart
                moveq   #1,d4
                bra.s   S3CNZLegacyBump_FindInitialStart
; ---------------------------------------------------------------------------

S3CNZLegacyBump_AdvanceInitialStart:
                lea     6(a1),a1

S3CNZLegacyBump_FindInitialStart:
                cmp.w   2(a1),d4
                bhi.s   S3CNZLegacyBump_AdvanceInitialStart
                move.l  a1,(CNZ_visible_bumpers_start).w
                move.l  a1,(CNZ_Visible_bumpers_start_P2).w
                addi.w  #$150,d4
                bra.s   S3CNZLegacyBump_FindInitialEnd
; ---------------------------------------------------------------------------

S3CNZLegacyBump_AdvanceInitialEnd:
                lea     6(a1),a1

S3CNZLegacyBump_FindInitialEnd:
                cmp.w   2(a1),d4
                bhi.s   S3CNZLegacyBump_AdvanceInitialEnd
                move.l  a1,(CNZ_Visible_bumpers_end).w
                move.l  a1,(CNZ_Visible_bumpers_end_P2).w
                move.b  #1,(CNZ_bumper_unk).w
                rts
; ---------------------------------------------------------------------------

SpecialCNZBumpers_Main:
                movea.l (CNZ_visible_bumpers_start).w,a1
                move.w  (Camera_X_pos).w,d4
                subq.w  #8,d4
                bhi.s   S3CNZLegacyBump_FindP1Start
                moveq   #1,d4
                bra.s   S3CNZLegacyBump_FindP1Start
; ---------------------------------------------------------------------------

S3CNZLegacyBump_AdvanceP1Start:
                lea     6(a1),a1

S3CNZLegacyBump_FindP1Start:
                cmp.w   2(a1),d4
                bhi.s   S3CNZLegacyBump_AdvanceP1Start
                bra.s   S3CNZLegacyBump_StoreP1Start
; ---------------------------------------------------------------------------

S3CNZLegacyBump_RewindP1Start:
                subq.w  #6,a1

S3CNZLegacyBump_StoreP1Start:
                cmp.w   -4(a1),d4
                bls.s   S3CNZLegacyBump_RewindP1Start
                move.l  a1,(CNZ_visible_bumpers_start).w
                movea.l (CNZ_Visible_bumpers_end).w,a2
                addi.w  #$150,d4
                bra.s   S3CNZLegacyBump_FindP1End
; ---------------------------------------------------------------------------

S3CNZLegacyBump_AdvanceP1End:
                lea     6(a2),a2

S3CNZLegacyBump_FindP1End:
                cmp.w   2(a2),d4
                bhi.s   S3CNZLegacyBump_AdvanceP1End
                bra.s   S3CNZLegacyBump_StoreP1EndAndCheckMode
; ---------------------------------------------------------------------------

S3CNZLegacyBump_RewindP1End:
                subq.w  #6,a2

S3CNZLegacyBump_StoreP1EndAndCheckMode:
                cmp.w   -4(a2),d4
                bls.s   S3CNZLegacyBump_RewindP1End
                move.l  a2,(CNZ_Visible_bumpers_end).w
                tst.w   (Competition_mode).w
                bne.s   S3CNZLegacyBump_UpdateCompetitionP2
                move.l  a1,(CNZ_Visible_bumpers_start_P2).w
                move.l  a2,(CNZ_Visible_bumpers_end_P2).w
                rts
; ---------------------------------------------------------------------------

S3CNZLegacyBump_UpdateCompetitionP2:
                movea.l (CNZ_Visible_bumpers_start_P2).w,a1
                move.w  (Camera_X_pos_P2).w,d4
                subq.w  #8,d4
                bhi.s   S3CNZLegacyBump_FindP2Start
                moveq   #1,d4
                bra.s   S3CNZLegacyBump_FindP2Start
; ---------------------------------------------------------------------------

S3CNZLegacyBump_AdvanceP2Start:
                lea     6(a1),a1

S3CNZLegacyBump_FindP2Start:
                cmp.w   2(a1),d4
                bhi.s   S3CNZLegacyBump_AdvanceP2Start
                bra.s   S3CNZLegacyBump_StoreP2Start
; ---------------------------------------------------------------------------

S3CNZLegacyBump_RewindP2Start:
                subq.w  #6,a1

S3CNZLegacyBump_StoreP2Start:
                cmp.w   -4(a1),d4
                bls.s   S3CNZLegacyBump_RewindP2Start
                move.l  a1,(CNZ_Visible_bumpers_start_P2).w
                movea.l (CNZ_Visible_bumpers_end_P2).w,a2
                addi.w  #$150,d4
                bra.s   S3CNZLegacyBump_FindP2End
; ---------------------------------------------------------------------------

S3CNZLegacyBump_AdvanceP2End:
                lea     6(a2),a2

S3CNZLegacyBump_FindP2End:
                cmp.w   2(a2),d4
                bhi.s   S3CNZLegacyBump_AdvanceP2End
                bra.s   S3CNZLegacyBump_StoreP2End
; ---------------------------------------------------------------------------

S3CNZLegacyBump_RewindP2End:
                subq.w  #6,a2

S3CNZLegacyBump_StoreP2End:
                cmp.w   -4(a2),d4
                bls.s   S3CNZLegacyBump_RewindP2End
                move.l  a2,(CNZ_Visible_bumpers_end_P2).w
                rts

; =============== S U B R O U T I N E =======================================

Check_CNZ_Bumpers:
                movea.l (CNZ_visible_bumpers_start).w,a1
                movea.l (CNZ_Visible_bumpers_end).w,a2
                cmpa.w  #Player_1,a0
                beq.s   S3CNZLegacyBump_TryBuildPlayerBox
                movea.l (CNZ_Visible_bumpers_start_P2).w,a1
                movea.l (CNZ_Visible_bumpers_end_P2).w,a2

S3CNZLegacyBump_TryBuildPlayerBox:
                cmpa.l  a1,a2
                beq.w   S3CNZLegacyBump_ScanReturn
                move.w  x_pos(a0),d2
                move.w  y_pos(a0),d3
                subi.w  #9,d2
                moveq   #0,d5
                move.b  y_radius(a0),d5
                subq.b  #3,d5
                sub.w   d5,d3
                cmpi.b  #$4D,mapping_frame(a0)
                bne.s   S3CNZLegacyBump_SetBoxSizeAndScan
                addi.w  #$C,d3
                moveq   #$A,d5

S3CNZLegacyBump_SetBoxSizeAndScan:
                move.w  #$12,d4
                add.w   d5,d5

CNZ_Bumper_Loop:
                move.w  (a1),d0
                andi.w  #$E,d0
                lea     S3CNZLegacyBump_HalfExtents(pc,d0.w),a3
                moveq   #0,d1
                move.b  (a3)+,d1
                move.w  2(a1),d0
                sub.w   d1,d0
                sub.w   d2,d0
                bcc.s   S3CNZLegacyBump_CheckRightSeparation
                add.w   d1,d1
                add.w   d1,d0
                bcs.s   S3CNZLegacyBump_CheckVerticalOverlap
                bra.w   CNZ_Bumper_Next
; ---------------------------------------------------------------------------

S3CNZLegacyBump_CheckRightSeparation:
                cmp.w   d4,d0
                bhi.w   CNZ_Bumper_Next

S3CNZLegacyBump_CheckVerticalOverlap:
                moveq   #0,d1
                move.b  (a3)+,d1
                move.w  4(a1),d0
                sub.w   d1,d0
                sub.w   d3,d0
                bcc.s   S3CNZLegacyBump_CheckBottomSeparation
                add.w   d1,d1
                add.w   d1,d0
                bcs.w   S3CNZLegacyBump_DispatchContact
                bra.w   CNZ_Bumper_Next
; ---------------------------------------------------------------------------

S3CNZLegacyBump_CheckBottomSeparation:
                cmp.w   d5,d0
                bhi.w   CNZ_Bumper_Next
                bra.s   S3CNZLegacyBump_DispatchContact
; ---------------------------------------------------------------------------
S3CNZLegacyBump_HalfExtents:
                dc.b    $20
                dc.b    $20
                dc.b    $20
                dc.b    $20
                dc.b    $40
                dc.b    8
                dc.b    $40
                dc.b    8
                dc.b    8
                dc.b    $40
                dc.b    8
                dc.b    $40
; ---------------------------------------------------------------------------

S3CNZLegacyBump_DispatchContact:
                move.w  (a1),d0
                move.w  S3CNZLegacyBump_BounceTable(pc,d0.w),d0
                jmp     S3CNZLegacyBump_BounceTable(pc,d0.w)
; ---------------------------------------------------------------------------

CNZ_Bumper_Next:
                lea     6(a1),a1
                cmpa.l  a1,a2
                bne.w   CNZ_Bumper_Loop

S3CNZLegacyBump_ScanReturn:
                rts
; ---------------------------------------------------------------------------
S3CNZLegacyBump_BounceTable:
                dc.w    S3CNZLegacyBump_Type0_CheckBottom-S3CNZLegacyBump_BounceTable
                dc.w    S3CNZLegacyBump_Type2_CheckBottom-S3CNZLegacyBump_BounceTable
                dc.w    S3CNZLegacyBump_Type4_CheckBottom-S3CNZLegacyBump_BounceTable
                dc.w    CNZLegacyBumpersS3_CheckTypeSixUpperFace-S3CNZLegacyBump_BounceTable
                dc.w    S3CNZLegacyBump_Type8_CheckRight-S3CNZLegacyBump_BounceTable
                dc.w    S3CNZLegacyBump_Type10_CheckLeft-S3CNZLegacyBump_BounceTable
; ---------------------------------------------------------------------------

S3CNZLegacyBump_Type0_CheckBottom:
                move.w  4(a1),d0
                sub.w   y_pos(a0),d0
                neg.w   d0
                cmpi.w  #$20,d0
                blt.s   S3CNZLegacyBump_Type0_CheckRight
                move.w  #$A00,y_vel(a0)
                bra.w   S3CNZLegacyBump_FinishBounce
; ---------------------------------------------------------------------------

S3CNZLegacyBump_Type0_CheckRight:
                move.w  2(a1),d0
                sub.w   x_pos(a0),d0
                neg.w   d0
                cmpi.w  #$20,d0
                blt.s   S3CNZLegacyBump_Type0_ClampSlopeX
                move.w  #$A00,x_vel(a0)
                bra.w   S3CNZLegacyBump_FinishBounce
; ---------------------------------------------------------------------------

S3CNZLegacyBump_Type0_ClampSlopeX:
                move.w  2(a1),d0
                sub.w   x_pos(a0),d0
                cmpi.w  #$20,d0
                blt.s   S3CNZLegacyBump_Type0_TrySlopeBounce
                move.w  #$20,d0

S3CNZLegacyBump_Type0_TrySlopeBounce:
                add.w   4(a1),d0
                subq.w  #8,d0
                move.w  y_pos(a0),d1
                addi.w  #$E,d1
                sub.w   d1,d0
                bcc.s   S3CNZLegacyBump_Type0_SlopeReturn
                move.w  #$20,d3
                bsr.s   S3CNZLegacyBump_ReflectVelocity
                bra.w   S3CNZLegacyBump_FinishBounce
; ---------------------------------------------------------------------------

S3CNZLegacyBump_Type0_SlopeReturn:
                rts
; ---------------------------------------------------------------------------

S3CNZLegacyBump_ReflectVelocity:
                move.w  x_vel(a0),d1
                move.w  y_vel(a0),d2
                jsr     (GetArcTan).l
                move.b  d0,(_dbgFFDC).w
                sub.w   d3,d0
                move.w  d0,d1
                bpl.s   S3CNZLegacyBump_SelectBounceAngle
                neg.w   d1

S3CNZLegacyBump_SelectBounceAngle:
                neg.w   d0
                add.w   d3,d0
                move.b  d0,(_dbgFFDD).w
                move.b  d1,(_dbgFFDF).w
                cmpi.b  #$38,d1
                bcs.s   S3CNZLegacyBump_SetBounceVelocity
                move.w  d3,d0

S3CNZLegacyBump_SetBounceVelocity:
                move.b  d0,(_dbgFFDE).w
                jsr     (GetSineCosine).l
                muls.w  #-$A00,d1
                asr.l   #8,d1
                move.w  d1,x_vel(a0)
                muls.w  #-$A00,d0
                asr.l   #8,d0
                move.w  d0,y_vel(a0)
                rts
; ---------------------------------------------------------------------------

S3CNZLegacyBump_Type2_CheckBottom:
                move.w  4(a1),d0
                sub.w   y_pos(a0),d0
                neg.w   d0
                cmpi.w  #$20,d0
                blt.s   S3CNZLegacyBump_Type2_CheckLeft
                move.w  #$A00,y_vel(a0)
                bra.w   S3CNZLegacyBump_FinishBounce
; ---------------------------------------------------------------------------

S3CNZLegacyBump_Type2_CheckLeft:
                move.w  2(a1),d0
                sub.w   x_pos(a0),d0
                cmpi.w  #$20,d0
                blt.s   S3CNZLegacyBump_Type2_ClampSlopeX
                move.w  #-$A00,x_vel(a0)
                bra.w   S3CNZLegacyBump_FinishBounce
; ---------------------------------------------------------------------------

S3CNZLegacyBump_Type2_ClampSlopeX:
                move.w  2(a1),d0
                sub.w   x_pos(a0),d0
                neg.w   d0
                cmpi.w  #$20,d0
                blt.s   S3CNZLegacyBump_Type2_TrySlopeBounce
                move.w  #$20,d0

S3CNZLegacyBump_Type2_TrySlopeBounce:
                add.w   4(a1),d0
                subq.w  #8,d0
                move.w  y_pos(a0),d1
                addi.w  #$E,d1
                sub.w   d1,d0
                bcc.s   S3CNZLegacyBump_Type2_SlopeReturn
                move.w  #$60,d3
                bsr.w   S3CNZLegacyBump_ReflectVelocity
                bra.w   S3CNZLegacyBump_FinishBounce
; ---------------------------------------------------------------------------

S3CNZLegacyBump_Type2_SlopeReturn:
                rts
; ---------------------------------------------------------------------------

S3CNZLegacyBump_Type4_CheckBottom:
                move.w  4(a1),d0
                sub.w   y_pos(a0),d0
                neg.w   d0
                cmpi.w  #8,d0
                blt.s   CNZLegacyBumpersS3_CheckTypeFourLeftEnd
                move.w  #$A00,y_vel(a0)
                bra.w   S3CNZLegacyBump_FinishBounce
; ---------------------------------------------------------------------------

CNZLegacyBumpersS3_CheckTypeFourLeftEnd:
                move.w  2(a1),d0
                sub.w   x_pos(a0),d0
                cmpi.w  #$40,d0
                blt.s   CNZLegacyBumpersS3_CheckTypeFourRightEnd
                move.w  #-$A00,x_vel(a0)
                bra.w   S3CNZLegacyBump_FinishBounce
; ---------------------------------------------------------------------------

CNZLegacyBumpersS3_CheckTypeFourRightEnd:
                neg.w   d0
                cmpi.w  #$40,d0
                blt.s   S3CNZLegacyBump_Type4_SelectAngle
                move.w  #$A00,x_vel(a0)
                bra.w   S3CNZLegacyBump_FinishBounce
; ---------------------------------------------------------------------------

S3CNZLegacyBump_Type4_SelectAngle:
                move.w  #$38,d3
                tst.w   d0
                bmi.s   S3CNZLegacyBump_Type4_BounceInside
                move.w  #$48,d3

S3CNZLegacyBump_Type4_BounceInside:
                bsr.w   S3CNZLegacyBump_ReflectVelocity
                bra.w   S3CNZLegacyBump_FinishBounce
; ---------------------------------------------------------------------------

CNZLegacyBumpersS3_CheckTypeSixUpperFace:
                move.w  4(a1),d0
                sub.w   y_pos(a0),d0
                cmpi.w  #8,d0
                blt.s   CNZLegacyBumpersS3_CheckTypeSixLeftEnd
                move.w  #-$A00,y_vel(a0)
                bra.w   S3CNZLegacyBump_FinishBounce
; ---------------------------------------------------------------------------

CNZLegacyBumpersS3_CheckTypeSixLeftEnd:
                move.w  2(a1),d0
                sub.w   x_pos(a0),d0
                cmpi.w  #$40,d0
                blt.s   CNZLegacyBumpersS3_CheckTypeSixRightEnd
                move.w  #-$A00,x_vel(a0)
                bra.w   S3CNZLegacyBump_FinishBounce
; ---------------------------------------------------------------------------

CNZLegacyBumpersS3_CheckTypeSixRightEnd:
                neg.w   d0
                cmpi.w  #$40,d0
                blt.s   S3CNZLegacyBump_Type6_SelectAngle
                move.w  #$A00,x_vel(a0)
                bra.w   S3CNZLegacyBump_FinishBounce
; ---------------------------------------------------------------------------

S3CNZLegacyBump_Type6_SelectAngle:
                move.w  #$C8,d3
                tst.w   d0
                bmi.s   S3CNZLegacyBump_Type6_BounceInside
                move.w  #$B8,d3

S3CNZLegacyBump_Type6_BounceInside:
                bsr.w   S3CNZLegacyBump_ReflectVelocity
                bra.w   S3CNZLegacyBump_FinishBounce
; ---------------------------------------------------------------------------

S3CNZLegacyBump_Type8_CheckRight:
                move.w  2(a1),d0
                sub.w   x_pos(a0),d0
                neg.w   d0
                cmpi.w  #8,d0
                blt.s   S3CNZLegacyBump_Type8_CheckTop
                move.w  #$A00,x_vel(a0)
                bra.w   S3CNZLegacyBump_FinishBounce
; ---------------------------------------------------------------------------

S3CNZLegacyBump_Type8_CheckTop:
                move.w  4(a1),d0
                sub.w   y_pos(a0),d0
                cmpi.w  #$40,d0
                blt.s   S3CNZLegacyBump_Type8_CheckBottom
                move.w  #-$A00,y_vel(a0)
                bra.w   S3CNZLegacyBump_FinishBounce
; ---------------------------------------------------------------------------

; A hit on the lower end sets X velocity to +$A00
S3CNZLegacyBump_Type8_CheckBottom:
                neg.w   d0
                cmpi.w  #$40,d0
                blt.s   S3CNZLegacyBump_Type8_SelectAngle
                move.w  #$A00,x_vel(a0)
                bra.w   S3CNZLegacyBump_FinishBounce
; ---------------------------------------------------------------------------

S3CNZLegacyBump_Type8_SelectAngle:
                move.w  #8,d3
                tst.w   d0
                bmi.s   S3CNZLegacyBump_Type8_BounceInside
                move.w  #$F8,d3

S3CNZLegacyBump_Type8_BounceInside:
                bsr.w   S3CNZLegacyBump_ReflectVelocity
                bra.w   S3CNZLegacyBump_FinishBounce
; ---------------------------------------------------------------------------

; A hit on the left face sets X velocity to +$A00
S3CNZLegacyBump_Type10_CheckLeft:
                move.w  2(a1),d0
                sub.w   x_pos(a0),d0
                cmpi.w  #8,d0
                blt.s   CNZLegacyBumpersS3_CheckTypeTenUpperEnd
                move.w  #$A00,x_vel(a0)
                bra.w   S3CNZLegacyBump_FinishBounce
; ---------------------------------------------------------------------------

CNZLegacyBumpersS3_CheckTypeTenUpperEnd:
                move.w  4(a1),d0
                sub.w   y_pos(a0),d0
                cmpi.w  #$40,d0
                blt.s   S3CNZLegacyBump_Type10_CheckBottom
                move.w  #-$A00,y_vel(a0)
                bra.w   S3CNZLegacyBump_FinishBounce
; ---------------------------------------------------------------------------

; A hit on the lower end sets X velocity to +$A00
S3CNZLegacyBump_Type10_CheckBottom:
                neg.w   d0
                cmpi.w  #$40,d0
                blt.s   S3CNZLegacyBump_Type10_SelectAngle
                move.w  #$A00,x_vel(a0)
                bra.w   S3CNZLegacyBump_FinishBounce
; ---------------------------------------------------------------------------

S3CNZLegacyBump_Type10_SelectAngle:
                move.w  #$78,d3
                tst.w   d0
                bmi.s   S3CNZLegacyBump_Type10_BounceInside
                move.w  #$88,d3

S3CNZLegacyBump_Type10_BounceInside:
                bsr.w   S3CNZLegacyBump_ReflectVelocity
                bra.w   S3CNZLegacyBump_FinishBounce
; ---------------------------------------------------------------------------

S3CNZLegacyBump_FinishBounce:
                bset    #Status_InAir,status(a0)
                bclr    #Status_RollJump,status(a0)
                bclr    #Status_Push,status(a0)
                clr.b   jumping(a0)
                move.w  #sfx_MagneticSpike,d0
                jmp     (Play_SFX).l
; End of function Check_CNZ_Bumpers
