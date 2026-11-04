; Owner: objects/runtime/sk
; Responsibility: Object art scaling and DMA setup, fixed-point position integration, scaled-coordinate projection and target velocity calculation
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Perform_Art_Scaling:
                clr.w   (_unkF740).w
                move.l  a0,-(sp)
                jsr     Init_ArtScaling
                movea.l (sp)+,a0
                move.l  a0,-(sp)
                move.w  art_tile(a0),d0
                jsr     (TryBuildObjectScaledArt).l
                movea.l (sp)+,a0
                move.w  (_unkF740).w,d3
                lsl.w   #4,d3
                move.l  #Kos_decomp_buffer,d1
                move.w  $3A(a0),d2
                jmp     (Add_To_DMA_Queue).l
; End of function Perform_Art_Scaling

; =============== S U B R O U T I N E =======================================

IntegrateScaledObjectCenter:
                move.w  x_vel(a0),d0
                ext.l   d0
                lsl.l   #8,d0
                add.l   d0,$30(a0)
                move.w  y_vel(a0),d0
                ext.l   d0
                lsl.l   #8,d0
                add.l   d0,$34(a0)
                rts
; End of function IntegrateScaledObjectCenter

; =============== S U B R O U T I N E =======================================

SetScaledObjectOriginFromCenter:
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
; End of function SetScaledObjectOriginFromCenter

; ---------------------------------------------------------------------------

SKRuntime_Velocity_LoadPrimaryPlayerPointBeforeDominantAxisSolve:
                lea     (Player_1).w,a1
                moveq   #0,d0
                move.w  x_pos(a1),d0
                moveq   #0,d1
                move.w  y_pos(a1),d1

; =============== S U B R O U T I N E =======================================

SetVelocityTowardPointByDominantAxis:
                sub.w   x_pos(a0),d0
                smi     d2
                bpl.s   SKRuntime_Velocity_ExtractVerticalDifferenceSignAndMagnitude
                neg.w   d0

SKRuntime_Velocity_ExtractVerticalDifferenceSignAndMagnitude:
                sub.w   y_pos(a0),d1
                smi     d3
                bpl.s   SKRuntime_Velocity_SelectDominantAxisOrEqualMagnitudePath
                neg.w   d1

SKRuntime_Velocity_SelectDominantAxisOrEqualMagnitudePath:
                cmp.w   d1,d0
                scs     d4
                beq.s   SKRuntime_Velocity_HandleEqualMagnitudesIncludingCoincidentPoint
                bcc.s   SKRuntime_Velocity_DivideSwappedMinorDividendByMajorWord
                exg     d0,d1

SKRuntime_Velocity_DivideSwappedMinorDividendByMajorWord:
                swap    d1
                divu.w  d0,d1

SKRuntime_Velocity_ScaleDominantComponentAndMinorQuotient:
                move.w  #$100,d0
                lsl.w   d5,d0
                moveq   #8,d6
                sub.w   d5,d6
                lsr.w   d6,d1

SKRuntime_Velocity_RestoreComponentsAfterVerticalDominance:
                tst.b   d4
                beq.s   SKRuntime_Velocity_ApplyOriginalHorizontalDifferenceSign
                exg     d0,d1

SKRuntime_Velocity_ApplyOriginalHorizontalDifferenceSign:
                tst.b   d2
                beq.s   SKRuntime_Velocity_ApplyOriginalVerticalDifferenceSign
                neg.w   d0

SKRuntime_Velocity_ApplyOriginalVerticalDifferenceSign:
                tst.b   d3
                beq.s   SKRuntime_Velocity_StoreSolvedWordComponentsAndReturn
                neg.w   d1

SKRuntime_Velocity_StoreSolvedWordComponentsAndReturn:
                move.w  d0,x_vel(a0)
                move.w  d1,y_vel(a0)
                rts
; ---------------------------------------------------------------------------

SKRuntime_Velocity_HandleEqualMagnitudesIncludingCoincidentPoint:
                tst.w   d0
                beq.s   SKRuntime_Velocity_ScaleDominantComponentAndMinorQuotient
                move.w  #$100,d0
                lsl.w   d5,d0
                move.w  #$100,d1
                lsl.w   d5,d1
                bra.s   SKRuntime_Velocity_RestoreComponentsAfterVerticalDominance
; End of function SetVelocityTowardPointByDominantAxis
