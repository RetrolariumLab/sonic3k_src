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
                beq.s   loc_53AD0
                bhi.s   loc_53AAA
                swap    d3                              ; If Y distance is closer to object
                clr.w   d3
                divu.w  d2,d3
                tst.w   d0
                beq.s   loc_53A9C
                cmpi.w  #$8000,d2                       ; If Y was closer and Sonic is to right of object
                blo.s   loc_53AEC
                tst.w   d0
                beq.s   loc_53AE8
                bra.w   loc_53AF0
; ---------------------------------------------------------------------------

loc_53A9C:
                cmpi.w  #$8000,d2                       ; If Y was closer and Sonic is to left of object
                blo.s   loc_53AFC
                tst.w   d1
                bne.s   loc_53AF8
                bra.w   loc_53B00
; ---------------------------------------------------------------------------

loc_53AAA:
                swap    d2                              ; If X distance is closer to object
                clr.w   d2
                divu.w  d3,d2
                tst.w   d1
                bne.s   loc_53AC2
                cmpi.w  #$8000,d2
                blo.s   loc_53AE4
                tst.w   d0
                bne.s   loc_53AE8
                bra.w   loc_53B00
; ---------------------------------------------------------------------------

loc_53AC2:
                cmpi.w  #$8000,d2
                blo.s   loc_53AF4
                tst.w   d0
                bne.s   loc_53AF0
                bra.w   loc_53AF8
; ---------------------------------------------------------------------------

loc_53AD0:
                tst.w   d0                              ; If X and Y distance are identical
                beq.s   loc_53ADC
                tst.w   d1
                beq.s   loc_53AE8
                bra.w   loc_53AF0
; ---------------------------------------------------------------------------

loc_53ADC:
                tst.w   d1
                bne.s   loc_53AF8
                bra.w   loc_53B00
; ---------------------------------------------------------------------------

loc_53AE4:
                moveq   #0,d4
                rts
; ---------------------------------------------------------------------------

loc_53AE8:
                moveq   #1,d4
                rts
; ---------------------------------------------------------------------------

loc_53AEC:
                moveq   #2,d4
                rts
; ---------------------------------------------------------------------------

loc_53AF0:
                moveq   #3,d4
                rts
; ---------------------------------------------------------------------------

loc_53AF4:
                moveq   #4,d4
                rts
; ---------------------------------------------------------------------------

loc_53AF8:
                moveq   #5,d4
                rts
; ---------------------------------------------------------------------------

loc_53AFC:
                moveq   #6,d4
                rts
; ---------------------------------------------------------------------------

loc_53B00:
                moveq   #7,d4
                rts
; End of function Find_SonicTails8Way

; =============== S U B R O U T I N E =======================================

Set_VelocityXTrackSonic:
                lea     (Player_1).w,a1
                bsr.w   Find_OtherObject
                bclr    #0,render_flags(a0)
                tst.w   d0
                beq.s   loc_53B1E
                neg.w   d4
                bset    #0,render_flags(a0)

loc_53B1E:
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
                beq.s   loc_53B4C
                bcs.s   loc_53B3A
                neg.w   d1

loc_53B3A:
                move.w  x_vel(a0),d4
                add.w   d1,d4
                cmp.w   d2,d4
                blt.s   loc_53B4C
                cmp.w   d0,d4
                bgt.s   loc_53B4C
                move.w  d4,x_vel(a0)

loc_53B4C:
                move.w  y_pos(a0),d4
                cmp.w   y_pos(a1),d4
                beq.s   loc_53B6E
                bcs.s   loc_53B5A
                neg.w   d3

loc_53B5A:
                move.w  y_vel(a0),d4
                add.w   d3,d4
                cmp.w   d2,d4
                blt.s   locret_53B6C
                cmp.w   d0,d4
                bgt.s   locret_53B6C
                move.w  d4,y_vel(a0)

locret_53B6C:
                rts
; ---------------------------------------------------------------------------

loc_53B6E:
                tst.b   d5
                beq.s   locret_53B6C
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
                bhs.s   loc_53B94
                neg.w   d1

loc_53B94:
                move.w  x_vel(a0),d3
                add.w   d1,d3
                cmp.w   d2,d3
                blt.s   locret_53BA6
                cmp.w   d0,d3
                bgt.s   locret_53BA6
                move.w  d3,x_vel(a0)

locret_53BA6:
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
                bhs.s   loc_53BC0
                neg.w   d1

loc_53BC0:
                move.w  y_vel(a0),d3
                add.w   d1,d3
                cmp.w   d2,d3
                blt.s   locret_53BD2
                cmp.w   d0,d3
                bgt.s   locret_53BD2
                move.w  d3,y_vel(a0)

locret_53BD2:
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
                beq.s   loc_53C04
                bcc.s   loc_53BF2
                neg.w   d1

loc_53BF2:
                move.w  x_vel(a0),d4
                add.w   d1,d4
                cmp.w   d2,d4
                blt.s   loc_53C04
                cmp.w   d0,d4
                bgt.s   loc_53C04
                move.w  d4,x_vel(a0)

loc_53C04:
                move.w  y_pos(a1),d6
                move.b  child_dy(a0),d4
                ext.w   d4
                add.w   d4,d6
                cmp.w   y_pos(a0),d6
                beq.s   loc_53C2E
                bcc.s   loc_53C1A
                neg.w   d3

loc_53C1A:
                move.w  y_vel(a0),d4
                add.w   d3,d4
                cmp.w   d2,d4
                blt.s   locret_53C2C
                cmp.w   d0,d4
                bgt.s   locret_53C2C
                move.w  d4,y_vel(a0)

locret_53C2C:
                rts
; ---------------------------------------------------------------------------

loc_53C2E:
                tst.b   d5
                beq.s   locret_53C2C
                clr.w   x_vel(a0)
                clr.w   y_vel(a0)
                rts
