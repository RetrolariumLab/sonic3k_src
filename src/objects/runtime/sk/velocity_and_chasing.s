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
                beq.s   loc_853E2
                bhi.s   loc_853BC
                swap    d3                              ; If Y distance is closer to object
                clr.w   d3
                divu.w  d2,d3
                tst.w   d0
                beq.s   loc_853AE
                cmpi.w  #$8000,d2                       ; If Y was closer and Sonic is to right of object
                blo.s   loc_853FE
                tst.w   d0
                beq.s   loc_853FA
                bra.w   loc_85402
; ---------------------------------------------------------------------------

loc_853AE:
                cmpi.w  #$8000,d2                       ; If Y was closer and Sonic is to left of object
                blo.s   loc_8540E
                tst.w   d1
                bne.s   loc_8540A
                bra.w   loc_85412
; ---------------------------------------------------------------------------

loc_853BC:
                swap    d2                              ; If X distance is closer to object
                clr.w   d2
                divu.w  d3,d2
                tst.w   d1
                bne.s   loc_853D4
                cmpi.w  #$8000,d2
                blo.s   loc_853F6
                tst.w   d0
                bne.s   loc_853FA
                bra.w   loc_85412
; ---------------------------------------------------------------------------

loc_853D4:
                cmpi.w  #$8000,d2
                blo.s   loc_85406
                tst.w   d0
                bne.s   loc_85402
                bra.w   loc_8540A
; ---------------------------------------------------------------------------

loc_853E2:
                tst.w   d0                              ; If X and Y distance are identical
                beq.s   loc_853EE
                tst.w   d1
                beq.s   loc_853FA
                bra.w   loc_85402
; ---------------------------------------------------------------------------

loc_853EE:
                tst.w   d1
                bne.s   loc_8540A
                bra.w   loc_85412
; ---------------------------------------------------------------------------

loc_853F6:
                moveq   #0,d4
                rts
; ---------------------------------------------------------------------------

loc_853FA:
                moveq   #1,d4
                rts
; ---------------------------------------------------------------------------

loc_853FE:
                moveq   #2,d4
                rts
; ---------------------------------------------------------------------------

loc_85402:
                moveq   #3,d4
                rts
; ---------------------------------------------------------------------------

loc_85406:
                moveq   #4,d4
                rts
; ---------------------------------------------------------------------------

loc_8540A:
                moveq   #5,d4
                rts
; ---------------------------------------------------------------------------

loc_8540E:
                moveq   #6,d4
                rts
; ---------------------------------------------------------------------------

loc_85412:
                moveq   #7,d4
                rts
; End of function Find_SonicTails8Way

; =============== S U B R O U T I N E =======================================

Set_VelocityXTrackSonic:
                lea     (Player_1).w,a1
                bsr.w   Find_OtherObject
                bclr    #0,render_flags(a0)
                tst.w   d0
                beq.s   loc_85430
                neg.w   d4
                bset    #0,render_flags(a0)

loc_85430:
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
                beq.s   loc_8545E
                bcs.s   loc_8544C
                neg.w   d1

loc_8544C:
                move.w  x_vel(a0),d4
                add.w   d1,d4
                cmp.w   d2,d4
                blt.s   loc_8545E
                cmp.w   d0,d4
                bgt.s   loc_8545E
                move.w  d4,x_vel(a0)

loc_8545E:
                move.w  y_pos(a0),d4
                cmp.w   y_pos(a1),d4
                beq.s   loc_85480
                bcs.s   loc_8546C
                neg.w   d3

loc_8546C:
                move.w  y_vel(a0),d4
                add.w   d3,d4
                cmp.w   d2,d4
                blt.s   locret_8547E
                cmp.w   d0,d4
                bgt.s   locret_8547E
                move.w  d4,y_vel(a0)

locret_8547E:
                rts
; ---------------------------------------------------------------------------

loc_85480:
                tst.b   d5
                beq.s   locret_8547E
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
                bhs.s   loc_854A6
                neg.w   d1

loc_854A6:
                move.w  x_vel(a0),d3
                add.w   d1,d3
                cmp.w   d2,d3
                blt.s   locret_854B8
                cmp.w   d0,d3
                bgt.s   locret_854B8
                move.w  d3,x_vel(a0)

locret_854B8:
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
                bhs.s   loc_854D2
                neg.w   d1

loc_854D2:
                move.w  y_vel(a0),d3
                add.w   d1,d3
                cmp.w   d2,d3
                blt.s   locret_854E4
                cmp.w   d0,d3
                bgt.s   locret_854E4
                move.w  d3,y_vel(a0)

locret_854E4:
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
                beq.s   loc_85516
                bcc.s   loc_85504
                neg.w   d1

loc_85504:
                move.w  x_vel(a0),d4
                add.w   d1,d4
                cmp.w   d2,d4
                blt.s   loc_85516
                cmp.w   d0,d4
                bgt.s   loc_85516
                move.w  d4,x_vel(a0)

loc_85516:
                move.w  y_pos(a1),d6
                move.b  child_dy(a0),d4
                ext.w   d4
                add.w   d4,d6
                cmp.w   y_pos(a0),d6
                beq.s   loc_85540
                bcc.s   loc_8552C
                neg.w   d3

loc_8552C:
                move.w  y_vel(a0),d4
                add.w   d3,d4
                cmp.w   d2,d4
                blt.s   locret_8553E
                cmp.w   d0,d4
                bgt.s   locret_8553E
                move.w  d4,y_vel(a0)

locret_8553E:
                rts
; ---------------------------------------------------------------------------

loc_85540:
                tst.b   d5
                beq.s   locret_8553E
                clr.w   x_vel(a0)
                clr.w   y_vel(a0)
                rts
