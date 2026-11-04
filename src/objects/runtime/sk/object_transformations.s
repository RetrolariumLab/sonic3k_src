; Owner: objects/runtime/sk
; Responsibility: Object art scaling and DMA setup, fixed-point position integration, scaled-coordinate projection and target velocity calculation
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Perform_Art_Scaling:
                clr.w   (ScaledArtAllocatedTileCount).w
                move.l  a0,-(sp)
                jsr     Init_ArtScaling
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

SKAimVelocity_LoadP1Position:
                lea     (Player_1).w,a1
                moveq   #0,d0
                move.w  x_pos(a1),d0
                moveq   #0,d1
                move.w  y_pos(a1),d1

; =============== S U B R O U T I N E =======================================

SetVelocityTowardPointByDominantAxis:
                sub.w   x_pos(a0),d0
                smi     d2
                bpl.s   SKAimVelocity_GetSignedDY
                neg.w   d0

SKAimVelocity_GetSignedDY:
                sub.w   y_pos(a0),d1
                smi     d3
                bpl.s   SKAimVelocity_SelectMajorAxis
                neg.w   d1

SKAimVelocity_SelectMajorAxis:
                cmp.w   d1,d0
                scs     d4
                beq.s   SKAimVelocity_EqualMagnitudes
                bcc.s   SKAimVelocity_DivideMinorByMajor
                exg     d0,d1

; Swap the minor magnitude into the high word to form a fixed-point dividend
SKAimVelocity_DivideMinorByMajor:
                swap    d1
                divu.w  d0,d1

SKAimVelocity_ScaleComponents:
                move.w  #$100,d0
                lsl.w   d5,d0
                moveq   #8,d6
                sub.w   d5,d6
                lsr.w   d6,d1

SKAimVelocity_RestoreAxisOrder:
                tst.b   d4
                beq.s   SKAimVelocity_RestoreXSign
                exg     d0,d1

SKAimVelocity_RestoreXSign:
                tst.b   d2
                beq.s   SKAimVelocity_RestoreYSign
                neg.w   d0

SKAimVelocity_RestoreYSign:
                tst.b   d3
                beq.s   SKAimVelocity_StoreXY
                neg.w   d1

SKAimVelocity_StoreXY:
                move.w  d0,x_vel(a0)
                move.w  d1,y_vel(a0)
                rts
; ---------------------------------------------------------------------------

; Use equal components on a diagonal. A coincident target enters the scaling path with a zero minor component
SKAimVelocity_EqualMagnitudes:
                tst.w   d0
                beq.s   SKAimVelocity_ScaleComponents
                move.w  #$100,d0
                lsl.w   d5,d0
                move.w  #$100,d1
                lsl.w   d5,d1
                bra.s   SKAimVelocity_RestoreAxisOrder
; End of function SetVelocityTowardPointByDominantAxis
