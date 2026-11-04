; Owner: objects/runtime/s3
; Responsibility: Indexed velocity, eight-way player targeting, tracking and object chase helpers
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Set_IndexedVelocity:
                moveq   #0,d1
                move.b  subtype(a0),d1
                add.w   d1,d1
                add.w   d1,d0
                lea     Obj_VelocityIndex(pc,d0.w),a1
                move.w  (a1)+,x_vel(a0)
                move.w  (a1)+,y_vel(a0)
                btst    #0,render_flags(a0)
                beq.s   .noflip
                neg.w   x_vel(a0)

                .noflip:
                rts
; End of function Set_IndexedVelocity

; ---------------------------------------------------------------------------
Obj_VelocityIndex:
                dc.w    -$100, -$100
                dc.w    $100, -$100
                dc.w    -$200, -$200
                dc.w    $200, -$200
                dc.w    -$300, -$200
                dc.w    $300, -$200
                dc.w    -$200, -$200
                dc.w    0, -$200
                dc.w    -$400, -$300
                dc.w    $400, -$300
                dc.w    $300, -$300
                dc.w    -$400, -$300
                dc.w    $400, -$300
                dc.w    -$200, -$200
                dc.w    $200, -$200
                dc.w    0, -$100
                dc.w    -$40, -$700
                dc.w    -$80, -$700
                dc.w    -$180, -$700
                dc.w    -$100, -$700
                dc.w    -$200, -$700
                dc.w    -$280, -$700
                dc.w    -$300, -$700

; =============== S U B R O U T I N E =======================================

Find_SonicTails8Way:
                bsr.w   Find_SonicTails                 ; This routine seems bugged slightly. Shouldn't the first two cmpi instructions look at d3 and not d2?
                cmp.w   d2,d3
                beq.s   S3Aim8_ClassifyEqualDistances
                bhi.s   S3Aim8_ClassifyYDominant
                swap    d3                              ; If Y distance is closer to object
                clr.w   d3
                divu.w  d2,d3
                tst.w   d0
                beq.s   S3Aim8_LeftXDominant
                cmpi.w  #$8000,d2                       ; If Y was closer and Sonic is to right of object
                blo.s   S3Aim8_ReturnSector2
                tst.w   d0
                beq.s   S3Aim8_ReturnSector1
                bra.w   S3Aim8_ReturnSector3
; ---------------------------------------------------------------------------

; Compare the original X distance in D2 to $8000
S3Aim8_LeftXDominant:
                cmpi.w  #$8000,d2                       ; If Y was closer and Sonic is to left of object
                blo.s   S3Aim8_ReturnSector6
                tst.w   d1
                bne.s   S3Aim8_ReturnSector5
                bra.w   S3Aim8_ReturnSector7
; ---------------------------------------------------------------------------

S3Aim8_ClassifyYDominant:
                swap    d2                              ; If X distance is closer to object
                clr.w   d2
                divu.w  d3,d2
                tst.w   d1
                bne.s   S3Aim8_ClassifyLowerYDominant
                cmpi.w  #$8000,d2
                blo.s   S3Aim8_ReturnSector0
                tst.w   d0
                bne.s   S3Aim8_ReturnSector1
                bra.w   S3Aim8_ReturnSector7
; ---------------------------------------------------------------------------

S3Aim8_ClassifyLowerYDominant:
                cmpi.w  #$8000,d2
                blo.s   S3Aim8_ReturnSector4
                tst.w   d0
                bne.s   S3Aim8_ReturnSector3
                bra.w   S3Aim8_ReturnSector5
; ---------------------------------------------------------------------------

S3Aim8_ClassifyEqualDistances:
                tst.w   d0                              ; If X and Y distance are identical
                beq.s   S3Aim8_ClassifyEqualLeft
                tst.w   d1
                beq.s   S3Aim8_ReturnSector1
                bra.w   S3Aim8_ReturnSector3
; ---------------------------------------------------------------------------

; A coincident target follows this branch and selects sector 7
S3Aim8_ClassifyEqualLeft:
                tst.w   d1
                bne.s   S3Aim8_ReturnSector5
                bra.w   S3Aim8_ReturnSector7
; ---------------------------------------------------------------------------

S3Aim8_ReturnSector0:
                moveq   #0,d4
                rts
; ---------------------------------------------------------------------------

S3Aim8_ReturnSector1:
                moveq   #1,d4
                rts
; ---------------------------------------------------------------------------

S3Aim8_ReturnSector2:
                moveq   #2,d4
                rts
; ---------------------------------------------------------------------------

S3Aim8_ReturnSector3:
                moveq   #3,d4
                rts
; ---------------------------------------------------------------------------

S3Aim8_ReturnSector4:
                moveq   #4,d4
                rts
; ---------------------------------------------------------------------------

S3Aim8_ReturnSector5:
                moveq   #5,d4
                rts
; ---------------------------------------------------------------------------

S3Aim8_ReturnSector6:
                moveq   #6,d4
                rts
; ---------------------------------------------------------------------------

S3Aim8_ReturnSector7:
                moveq   #7,d4
                rts
; End of function Find_SonicTails8Way

; =============== S U B R O U T I N E =======================================

Set_VelocityXTrackSonic:
                lea     (Player_1).w,a1
                bsr.w   Find_OtherObject
                bclr    #0,render_flags(a0)
                tst.w   d0
                beq.s   S3AimX_StoreSignedSpeed
                neg.w   d4
                bset    #0,render_flags(a0)

S3AimX_StoreSignedSpeed:
                move.w  d4,x_vel(a0)
                rts
; End of function Set_VelocityXTrackSonic

; =============== S U B R O U T I N E =======================================

Chase_Object:
                move.w  d0,d2                           ; d0 = Maximum speed
                neg.w   d2
                move.w  d1,d3                           ; d1 = acceleration
                move.w  x_pos(a0),d4
                cmp.w   x_pos(a1),d4
                seq     d5
                beq.s   S3ChaseXY_CompareY
                bcs.s   S3ChaseXY_TryXSpeed
                neg.w   d1

S3ChaseXY_TryXSpeed:
                move.w  x_vel(a0),d4
                add.w   d1,d4
                cmp.w   d2,d4
                blt.s   S3ChaseXY_CompareY
                cmp.w   d0,d4
                bgt.s   S3ChaseXY_CompareY
                move.w  d4,x_vel(a0)

; Keep the X equality byte in D5 for the final stop test
S3ChaseXY_CompareY:
                move.w  y_pos(a0),d4
                cmp.w   y_pos(a1),d4
                beq.s   S3ChaseXY_StopIfBothAxesMatch
                bcs.s   S3ChaseXY_TryYSpeed
                neg.w   d3

S3ChaseXY_TryYSpeed:
                move.w  y_vel(a0),d4
                add.w   d3,d4
                cmp.w   d2,d4
                blt.s   S3ChaseXY_Return
                cmp.w   d0,d4
                bgt.s   S3ChaseXY_Return
                move.w  d4,y_vel(a0)

; CCR comes from the last comparison or velocity store on the active path
S3ChaseXY_Return:
                rts
; ---------------------------------------------------------------------------

S3ChaseXY_StopIfBothAxesMatch:
                tst.b   d5
                beq.s   S3ChaseXY_Return
                clr.w   x_vel(a0)
                clr.w   y_vel(a0)
                rts
; End of function Chase_Object

; =============== S U B R O U T I N E =======================================

Chase_ObjectXOnly:
                move.w  d0,d2
                neg.w   d2
                move.w  x_pos(a1),d3
                move.b  child_dx(a0),d4
                ext.w   d4
                add.w   d4,d3
                cmp.w   x_pos(a0),d3
                bhs.s   S3ChaseOffsetX_TrySpeed
                neg.w   d1

S3ChaseOffsetX_TrySpeed:
                move.w  x_vel(a0),d3
                add.w   d1,d3
                cmp.w   d2,d3
                blt.s   S3ChaseOffsetX_Return
                cmp.w   d0,d3
                bgt.s   S3ChaseOffsetX_Return
                move.w  d3,x_vel(a0)

; CCR comes from the limit comparison or accepted velocity store
S3ChaseOffsetX_Return:
                rts
; End of function Chase_ObjectXOnly

; =============== S U B R O U T I N E =======================================

Chase_ObjectYOnly:
                move.w  d0,d2
                neg.w   d2
                move.w  y_pos(a1),d3
                move.b  child_dy(a0),d4
                ext.w   d4
                add.w   d4,d3
                cmp.w   y_pos(a0),d3
                bhs.s   S3ChaseOffsetY_TrySpeed
                neg.w   d1

S3ChaseOffsetY_TrySpeed:
                move.w  y_vel(a0),d3
                add.w   d1,d3
                cmp.w   d2,d3
                blt.s   S3ChaseOffsetY_Return
                cmp.w   d0,d3
                bgt.s   S3ChaseOffsetY_Return
                move.w  d3,y_vel(a0)

; CCR comes from the limit comparison or accepted velocity store
S3ChaseOffsetY_Return:
                rts
; End of function Chase_ObjectYOnly

; ---------------------------------------------------------------------------
                move.w  d0,d2                           ; Unused, seems to be a combination of the above two routines, but additionally using offsets
                neg.w   d2
                move.w  d1,d3
                move.w  x_pos(a1),d6
                move.b  child_dx(a0),d4
                ext.w   d4
                add.w   d4,d6
                cmp.w   x_pos(a0),d6
                seq     d5
                beq.s   S3ChaseOffsetXY_CompareY
                bcc.s   S3ChaseOffsetXY_TryXSpeed
                neg.w   d1

S3ChaseOffsetXY_TryXSpeed:
                move.w  x_vel(a0),d4
                add.w   d1,d4
                cmp.w   d2,d4
                blt.s   S3ChaseOffsetXY_CompareY
                cmp.w   d0,d4
                bgt.s   S3ChaseOffsetXY_CompareY
                move.w  d4,x_vel(a0)

S3ChaseOffsetXY_CompareY:
                move.w  y_pos(a1),d6
                move.b  child_dy(a0),d4
                ext.w   d4
                add.w   d4,d6
                cmp.w   y_pos(a0),d6
                beq.s   S3ChaseOffsetXY_StopIfBothAxesMatch
                bcc.s   S3ChaseOffsetXY_TryYSpeed
                neg.w   d3

S3ChaseOffsetXY_TryYSpeed:
                move.w  y_vel(a0),d4
                add.w   d3,d4
                cmp.w   d2,d4
                blt.s   S3ChaseOffsetXY_Return
                cmp.w   d0,d4
                bgt.s   S3ChaseOffsetXY_Return
                move.w  d4,y_vel(a0)

; CCR comes from the last comparison or velocity store on the active path
S3ChaseOffsetXY_Return:
                rts
; ---------------------------------------------------------------------------

S3ChaseOffsetXY_StopIfBothAxesMatch:
                tst.b   d5
                beq.s   S3ChaseOffsetXY_Return
                clr.w   x_vel(a0)
                clr.w   y_vel(a0)
                rts
