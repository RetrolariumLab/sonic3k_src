; Owner: objects/runtime/sk
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
                dc.w    0, -$100
                dc.w    -$100, -$100
                dc.w    $100, -$100
                dc.w    -$200, -$100
                dc.w    $200, -$100
                dc.w    -$200, -$200
                dc.w    $200, -$200
                dc.w    -$300, -$200
                dc.w    $300, -$200
                dc.w    -$300, -$300
                dc.w    $300, -$300
                dc.w    -$400, -$300
                dc.w    $400, -$300
                dc.w    -$200, -$300
                dc.w    $200, -$300

; =============== S U B R O U T I N E =======================================

Find_SonicTails8Way:
                bsr.w   Find_SonicTails                 ; This routine seems bugged slightly. Shouldn't the first two cmpi instructions look at d3 and not d2?
                cmp.w   d2,d3
                beq.s   SKAim8_ClassifyEqualDistances
                bhi.s   SKAim8_ClassifyYDominant
                swap    d3                              ; If Y distance is closer to object
                clr.w   d3
                divu.w  d2,d3
                tst.w   d0
                beq.s   SKAim8_LeftXDominant
                cmpi.w  #$8000,d2                       ; If Y was closer and Sonic is to right of object
                blo.s   SKAim8_ReturnSector2
                tst.w   d0
                beq.s   SKAim8_ReturnSector1
                bra.w   SKAim8_ReturnSector3
; ---------------------------------------------------------------------------

; Compare the original X distance in D2 to $8000
SKAim8_LeftXDominant:
                cmpi.w  #$8000,d2                       ; If Y was closer and Sonic is to left of object
                blo.s   SKAim8_ReturnSector6
                tst.w   d1
                bne.s   SKAim8_ReturnSector5
                bra.w   SKAim8_ReturnSector7
; ---------------------------------------------------------------------------

SKAim8_ClassifyYDominant:
                swap    d2                              ; If X distance is closer to object
                clr.w   d2
                divu.w  d3,d2
                tst.w   d1
                bne.s   SKAim8_ClassifyLowerYDominant
                cmpi.w  #$8000,d2
                blo.s   SKAim8_ReturnSector0
                tst.w   d0
                bne.s   SKAim8_ReturnSector1
                bra.w   SKAim8_ReturnSector7
; ---------------------------------------------------------------------------

SKAim8_ClassifyLowerYDominant:
                cmpi.w  #$8000,d2
                blo.s   SKAim8_ReturnSector4
                tst.w   d0
                bne.s   SKAim8_ReturnSector3
                bra.w   SKAim8_ReturnSector5
; ---------------------------------------------------------------------------

SKAim8_ClassifyEqualDistances:
                tst.w   d0                              ; If X and Y distance are identical
                beq.s   SKAim8_ClassifyEqualLeft
                tst.w   d1
                beq.s   SKAim8_ReturnSector1
                bra.w   SKAim8_ReturnSector3
; ---------------------------------------------------------------------------

; A coincident target follows this branch and selects sector 7
SKAim8_ClassifyEqualLeft:
                tst.w   d1
                bne.s   SKAim8_ReturnSector5
                bra.w   SKAim8_ReturnSector7
; ---------------------------------------------------------------------------

SKAim8_ReturnSector0:
                moveq   #0,d4
                rts
; ---------------------------------------------------------------------------

SKAim8_ReturnSector1:
                moveq   #1,d4
                rts
; ---------------------------------------------------------------------------

SKAim8_ReturnSector2:
                moveq   #2,d4
                rts
; ---------------------------------------------------------------------------

SKAim8_ReturnSector3:
                moveq   #3,d4
                rts
; ---------------------------------------------------------------------------

SKAim8_ReturnSector4:
                moveq   #4,d4
                rts
; ---------------------------------------------------------------------------

SKAim8_ReturnSector5:
                moveq   #5,d4
                rts
; ---------------------------------------------------------------------------

SKAim8_ReturnSector6:
                moveq   #6,d4
                rts
; ---------------------------------------------------------------------------

SKAim8_ReturnSector7:
                moveq   #7,d4
                rts
; End of function Find_SonicTails8Way

; =============== S U B R O U T I N E =======================================

Set_VelocityXTrackSonic:
                lea     (Player_1).w,a1
                bsr.w   Find_OtherObject
                bclr    #0,render_flags(a0)
                tst.w   d0
                beq.s   SKAimX_StoreSignedSpeed
                neg.w   d4
                bset    #0,render_flags(a0)

SKAimX_StoreSignedSpeed:
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
                beq.s   SKChaseXY_CompareY
                bcs.s   SKChaseXY_TryXSpeed
                neg.w   d1

SKChaseXY_TryXSpeed:
                move.w  x_vel(a0),d4
                add.w   d1,d4
                cmp.w   d2,d4
                blt.s   SKChaseXY_CompareY
                cmp.w   d0,d4
                bgt.s   SKChaseXY_CompareY
                move.w  d4,x_vel(a0)

; Keep the X equality byte in D5 for the final stop test
SKChaseXY_CompareY:
                move.w  y_pos(a0),d4
                cmp.w   y_pos(a1),d4
                beq.s   SKChaseXY_StopIfBothAxesMatch
                bcs.s   SKChaseXY_TryYSpeed
                neg.w   d3

SKChaseXY_TryYSpeed:
                move.w  y_vel(a0),d4
                add.w   d3,d4
                cmp.w   d2,d4
                blt.s   SKChaseXY_Return
                cmp.w   d0,d4
                bgt.s   SKChaseXY_Return
                move.w  d4,y_vel(a0)

; CCR comes from the last comparison or velocity store on the active path
SKChaseXY_Return:
                rts
; ---------------------------------------------------------------------------

SKChaseXY_StopIfBothAxesMatch:
                tst.b   d5
                beq.s   SKChaseXY_Return
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
                bhs.s   SKChaseOffsetX_TrySpeed
                neg.w   d1

SKChaseOffsetX_TrySpeed:
                move.w  x_vel(a0),d3
                add.w   d1,d3
                cmp.w   d2,d3
                blt.s   SKChaseOffsetX_Return
                cmp.w   d0,d3
                bgt.s   SKChaseOffsetX_Return
                move.w  d3,x_vel(a0)

; CCR comes from the limit comparison or accepted velocity store
SKChaseOffsetX_Return:
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
                bhs.s   SKChaseOffsetY_TrySpeed
                neg.w   d1

SKChaseOffsetY_TrySpeed:
                move.w  y_vel(a0),d3
                add.w   d1,d3
                cmp.w   d2,d3
                blt.s   SKChaseOffsetY_Return
                cmp.w   d0,d3
                bgt.s   SKChaseOffsetY_Return
                move.w  d3,y_vel(a0)

; CCR comes from the limit comparison or accepted velocity store
SKChaseOffsetY_Return:
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
                beq.s   SKChaseOffsetXY_CompareY
                bcc.s   SKChaseOffsetXY_TryXSpeed
                neg.w   d1

SKChaseOffsetXY_TryXSpeed:
                move.w  x_vel(a0),d4
                add.w   d1,d4
                cmp.w   d2,d4
                blt.s   SKChaseOffsetXY_CompareY
                cmp.w   d0,d4
                bgt.s   SKChaseOffsetXY_CompareY
                move.w  d4,x_vel(a0)

SKChaseOffsetXY_CompareY:
                move.w  y_pos(a1),d6
                move.b  child_dy(a0),d4
                ext.w   d4
                add.w   d4,d6
                cmp.w   y_pos(a0),d6
                beq.s   SKChaseOffsetXY_StopIfBothAxesMatch
                bcc.s   SKChaseOffsetXY_TryYSpeed
                neg.w   d3

SKChaseOffsetXY_TryYSpeed:
                move.w  y_vel(a0),d4
                add.w   d3,d4
                cmp.w   d2,d4
                blt.s   SKChaseOffsetXY_Return
                cmp.w   d0,d4
                bgt.s   SKChaseOffsetXY_Return
                move.w  d4,y_vel(a0)

; CCR comes from the last comparison or velocity store on the active path
SKChaseOffsetXY_Return:
                rts
; ---------------------------------------------------------------------------

SKChaseOffsetXY_StopIfBothAxesMatch:
                tst.b   d5
                beq.s   SKChaseOffsetXY_Return
                clr.w   x_vel(a0)
                clr.w   y_vel(a0)
                rts
