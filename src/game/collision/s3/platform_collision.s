; Owner: game/collision/s3
; Responsibility: Sloped and top-only solid platforms, ride attachment and player release checks
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

SolidObjSloped2:
                btst    #Status_OnObj,status(a1)
                beq.s   locret_1BF86
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                lsr.w   #1,d0
                btst    #0,render_flags(a0)
                beq.s   loc_1BF66
                not.w   d0
                add.w   d1,d0

loc_1BF66:
                move.b  (a2,d0.w),d1
                ext.w   d1
                move.w  y_pos(a0),d0
                sub.w   d1,d0
                moveq   #0,d1
                move.b  y_radius(a1),d1
                sub.w   d1,d0
                move.w  d0,y_pos(a1)
                sub.w   x_pos(a0),d2
                sub.w   d2,x_pos(a1)

locret_1BF86:
                rts
; End of function SolidObjSloped2

; =============== S U B R O U T I N E =======================================

SolidObjSloped4:
                btst    #Status_OnObj,status(a1)
                beq.s   locret_1BF86
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                btst    #0,render_flags(a0)
                beq.s   loc_1BFA6
                not.w   d0
                add.w   d1,d0

loc_1BFA6:
                andi.w  #$FFFE,d0
                bra.s   loc_1BF66
; End of function SolidObjSloped4

; =============== S U B R O U T I N E =======================================

SolidObjectTop:
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d6
                movem.l d1-d4,-(sp)
                bsr.s   SolidObjectTop_1P
                movem.l (sp)+,d1-d4
                lea     (Player_2).w,a1
                addq.b  #p2_standing_bit-p1_standing_bit,d6
; End of function SolidObjectTop

; =============== S U B R O U T I N E =======================================

SolidObjectTop_1P:
                btst    d6,status(a0)
                beq.w   loc_1C0DC
                move.w  d1,d2
                add.w   d2,d2
                btst    #Status_InAir,status(a1)
                bne.s   loc_1BFE6
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                bmi.s   loc_1BFE6
                cmp.w   d2,d0
                blo.s   loc_1BFFA

loc_1BFE6:
                bclr    #Status_OnObj,status(a1)
                bset    #Status_InAir,status(a1)
                bclr    d6,status(a0)
                moveq   #0,d4
                rts
; ---------------------------------------------------------------------------

loc_1BFFA:
                move.w  d4,d2
                bsr.w   MvSonicOnPtfm
                moveq   #0,d4
                rts
; End of function SolidObjectTop_1P

; =============== S U B R O U T I N E =======================================

SolidObjectTopSloped2:
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d6
                movem.l d1-d4,-(sp)
                bsr.s   SolidObjectTopSloped2_1P
                movem.l (sp)+,d1-d4
                lea     (Player_2).w,a1
                addq.b  #p2_standing_bit-p1_standing_bit,d6
; End of function SolidObjectTopSloped2

; =============== S U B R O U T I N E =======================================

SolidObjectTopSloped2_1P:
                btst    d6,status(a0)
                beq.w   SolidObjCheckSloped2
                move.w  d1,d2
                add.w   d2,d2
                btst    #Status_InAir,status(a1)
                bne.s   loc_1C03E
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                bmi.s   loc_1C03E
                cmp.w   d2,d0
                blo.s   loc_1C052

loc_1C03E:
                bclr    #Status_OnObj,status(a1)
                bset    #Status_InAir,status(a1)
                bclr    d6,status(a0)
                moveq   #0,d4
                rts
; ---------------------------------------------------------------------------

loc_1C052:
                move.w  d4,d2
                bsr.w   SolidObjSloped2
                moveq   #0,d4
                rts
; End of function SolidObjectTopSloped2_1P

; =============== S U B R O U T I N E =======================================

SolidObjectTopSloped:
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d6
                movem.l d1-d4,-(sp)
                bsr.s   SolidObjectTopSloped_1P
                movem.l (sp)+,d1-d4
                lea     (Player_2).w,a1
                addq.b  #p2_standing_bit-p1_standing_bit,d6
; End of function SolidObjectTopSloped

; =============== S U B R O U T I N E =======================================

SolidObjectTopSloped_1P:
                btst    d6,status(a0)
                bne.s   loc_1C084
                btst    #Status_OnObj,status(a1)
                bne.s   loc_1C0B0
                bra.w   loc_1C0DC
; ---------------------------------------------------------------------------

loc_1C084:
                move.w  d1,d2
                add.w   d2,d2
                btst    #Status_InAir,status(a1)
                bne.s   loc_1C0A0
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                bmi.s   loc_1C0A0
                cmp.w   d2,d0
                blo.s   loc_1C0B4

loc_1C0A0:
                bclr    #Status_OnObj,status(a1)
                bset    #Status_InAir,status(a1)
                bclr    d6,status(a0)

loc_1C0B0:
                moveq   #0,d4
                rts
; ---------------------------------------------------------------------------

loc_1C0B4:
                move.w  d4,d2
                bsr.w   MvSonicOnPtfm
                moveq   #0,d4
                rts
; End of function SolidObjectTopSloped_1P

; =============== S U B R O U T I N E =======================================

sub_1C0BE:
                tst.w   y_vel(a1)
                bmi.w   locret_1C17A
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                bmi.w   locret_1C17A
                cmp.w   d2,d0
                bhs.w   locret_1C17A
                bra.s   loc_1C0FA
; ---------------------------------------------------------------------------

loc_1C0DC:
                tst.w   y_vel(a1)
                bmi.w   locret_1C17A
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                bmi.w   locret_1C17A
                add.w   d1,d1
                cmp.w   d1,d0
                bhs.w   locret_1C17A

loc_1C0FA:
                move.w  y_pos(a0),d0
                sub.w   d3,d0

loc_1C100:
                move.w  y_pos(a1),d2
                move.b  y_radius(a1),d1
                ext.w   d1
                add.w   d2,d1
                addq.w  #4,d1
                sub.w   d1,d0
                bhi.w   locret_1C17A
                cmpi.w  #-$10,d0
                blo.w   locret_1C17A
                tst.b   object_control(a1)
                bmi.w   locret_1C17A
                cmpi.b  #6,routine(a1)
                bhs.w   locret_1C17A
                add.w   d0,d2
                addq.w  #3,d2
                move.w  d2,y_pos(a1)
; End of function sub_1C0BE

; =============== S U B R O U T I N E =======================================

RideObject_SetRide:
                btst    #Status_OnObj,status(a1)
                beq.s   loc_1C146
                movea.w interact(a1),a3
                bclr    d6,status(a3)

loc_1C146:
                move.w  a0,interact(a1)
                move.b  #0,angle(a1)
                move.w  #0,y_vel(a1)
                move.w  x_vel(a1),ground_vel(a1)
                bset    #Status_OnObj,status(a1)
                bset    d6,status(a0)
                bclr    #Status_InAir,status(a1)
                beq.s   locret_1C17A
                move.l  a0,-(sp)
                movea.l a1,a0
                jsr     (Player_TouchFloor).l
                movea.l (sp)+,a0

locret_1C17A:
                rts
; End of function RideObject_SetRide

; ---------------------------------------------------------------------------

SolidObjCheckSloped2:
                tst.w   y_vel(a1)
                bmi.w   locret_1C17A
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                bmi.s   locret_1C17A
                add.w   d1,d1
                cmp.w   d1,d0
                bhs.s   locret_1C17A
                btst    #0,render_flags(a0)
                beq.s   loc_1C1A2
                not.w   d0
                add.w   d1,d0

loc_1C1A2:
                lsr.w   #1,d0
                move.b  (a2,d0.w),d3
                ext.w   d3
                move.w  y_pos(a0),d0
                sub.w   d3,d0
                bra.w   loc_1C100

; =============== S U B R O U T I N E =======================================

CheckPlayerReleaseFromObj:
                lea     (Player_1).w,a1
                btst    #p1_standing_bit,status(a0)
                beq.s   loc_1C1E2
                jsr     (SonicOnObjHitFloor).l
                tst.w   d1
                beq.s   loc_1C1CC
                bpl.s   loc_1C1E2

loc_1C1CC:
                lea     (Player_1).w,a1
                bclr    #Status_OnObj,status(a1)
                bset    #Status_InAir,status(a1)
                bclr    #p1_standing_bit,status(a0)

loc_1C1E2:
                lea     (Player_2).w,a1
                btst    #p2_standing_bit,status(a0)
                beq.s   loc_1C210
                jsr     (SonicOnObjHitFloor).l
                tst.w   d1
                beq.s   loc_1C1FA
                bpl.s   loc_1C210

loc_1C1FA:
                lea     (Player_2).w,a1
                bclr    #Status_OnObj,status(a1)
                bset    #Status_InAir,status(a1)
                bclr    #p2_standing_bit,status(a0)

loc_1C210:
                moveq   #0,d4
                rts
; End of function CheckPlayerReleaseFromObj
