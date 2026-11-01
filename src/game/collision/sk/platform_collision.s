; Owner: game/collision/sk
; Responsibility: Sloped and top-only solid platforms, ride attachment and player release checks
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

SolidObjSloped:
                btst    #Status_OnObj,status(a1)
                beq.s   locret_1E280
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                btst    #0,render_flags(a0)
                beq.s   loc_1E23E
                not.w   d0
                add.w   d1,d0
                add.w   d1,d0

loc_1E23E:
                bra.s   loc_1E260
; End of function SolidObjSloped

; =============== S U B R O U T I N E =======================================

SolidObjSloped2:
                btst    #Status_OnObj,status(a1)
                beq.s   locret_1E280
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                lsr.w   #1,d0
                btst    #0,render_flags(a0)
                beq.s   loc_1E260
                not.w   d0
                add.w   d1,d0

loc_1E260:
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

locret_1E280:
                rts
; End of function SolidObjSloped2

; =============== S U B R O U T I N E =======================================

SolidObjSloped4:
                btst    #Status_OnObj,status(a1)
                beq.s   locret_1E280
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                btst    #0,render_flags(a0)
                beq.s   loc_1E2A0
                not.w   d0
                add.w   d1,d0

loc_1E2A0:
                andi.w  #$FFFE,d0
                bra.s   loc_1E260
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
                beq.w   loc_1E42E
                move.w  d1,d2
                add.w   d2,d2
                btst    #Status_InAir,status(a1)
                bne.s   loc_1E2E0
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                bmi.s   loc_1E2E0
                cmp.w   d2,d0
                blo.s   loc_1E2F4

loc_1E2E0:
                bclr    #Status_OnObj,status(a1)
                bset    #Status_InAir,status(a1)
                bclr    d6,status(a0)
                moveq   #0,d4
                rts
; ---------------------------------------------------------------------------

loc_1E2F4:
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
                bne.s   loc_1E338
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                bmi.s   loc_1E338
                cmp.w   d2,d0
                blo.s   loc_1E34C

loc_1E338:
                bclr    #Status_OnObj,status(a1)
                bset    #Status_InAir,status(a1)
                bclr    d6,status(a0)
                moveq   #0,d4
                rts
; ---------------------------------------------------------------------------

loc_1E34C:
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
                beq.w   SolidObjCheckSloped
                move.w  d1,d2
                add.w   d2,d2
                btst    #Status_InAir,status(a1)
                bne.s   loc_1E390
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                bmi.s   loc_1E390
                cmp.w   d2,d0
                blo.s   loc_1E3A4

loc_1E390:
                bclr    #Status_OnObj,status(a1)
                bset    #Status_InAir,status(a1)
                bclr    d6,status(a0)
                moveq   #0,d4
                rts
; ---------------------------------------------------------------------------

loc_1E3A4:
                move.w  d4,d2
                bsr.w   SolidObjSloped
                moveq   #0,d4
                rts
; End of function SolidObjectTopSloped_1P

; ---------------------------------------------------------------------------
; unused
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d6
                movem.l d1-d4,-(sp)
                bsr.s   CollidePlayerWithUnclaimedFlatPlatform
                movem.l (sp)+,d1-d4
                lea     (Player_2).w,a1
                addq.b  #p2_standing_bit-p1_standing_bit,d6

; =============== S U B R O U T I N E =======================================

CollidePlayerWithUnclaimedFlatPlatform:
                btst    d6,status(a0)
                bne.s   loc_1E3D6
                btst    #Status_OnObj,status(a1)
                bne.s   loc_1E402
                bra.w   loc_1E42E
; ---------------------------------------------------------------------------

loc_1E3D6:
                move.w  d1,d2
                add.w   d2,d2
                btst    #Status_InAir,status(a1)
                bne.s   loc_1E3F2
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                bmi.s   loc_1E3F2
                cmp.w   d2,d0
                blo.s   loc_1E406

loc_1E3F2:
                bclr    #Status_OnObj,status(a1)
                bset    #Status_InAir,status(a1)
                bclr    d6,status(a0)

loc_1E402:
                moveq   #0,d4
                rts
; ---------------------------------------------------------------------------

loc_1E406:
                move.w  d4,d2
                bsr.w   MvSonicOnPtfm
                moveq   #0,d4
                rts
; End of function CollidePlayerWithUnclaimedFlatPlatform

; =============== S U B R O U T I N E =======================================

TryLandPlayerOnPlatformSpan:
                tst.w   y_vel(a1)
                bmi.w   locret_1E4D4
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                bmi.w   locret_1E4D4
                cmp.w   d2,d0
                bhs.w   locret_1E4D4
                bra.s   loc_1E44C
; ---------------------------------------------------------------------------

loc_1E42E:
                tst.w   y_vel(a1)
                bmi.w   locret_1E4D4
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                bmi.w   locret_1E4D4
                add.w   d1,d1
                cmp.w   d1,d0
                bhs.w   locret_1E4D4

loc_1E44C:
                tst.b   (Reverse_gravity_flag).w
                bne.w   loc_1E4D6
                move.w  y_pos(a0),d0
                sub.w   d3,d0

loc_1E45A:
                move.w  y_pos(a1),d2
                move.b  y_radius(a1),d1
                ext.w   d1
                add.w   d2,d1
                addq.w  #4,d1
                sub.w   d1,d0
                bhi.w   locret_1E4D4
                cmpi.w  #-$10,d0
                blo.w   locret_1E4D4
                tst.b   object_control(a1)
                bmi.w   locret_1E4D4
                cmpi.b  #6,routine(a1)
                bhs.w   locret_1E4D4
                add.w   d0,d2
                addq.w  #3,d2
                move.w  d2,y_pos(a1)
; End of function TryLandPlayerOnPlatformSpan

; =============== S U B R O U T I N E =======================================

RideObject_SetRide:
                btst    #Status_OnObj,status(a1)
                beq.s   loc_1E4A0
                movea.w interact(a1),a3
                bclr    d6,status(a3)

loc_1E4A0:
                move.w  a0,interact(a1)
                move.b  #0,angle(a1)
                move.w  #0,y_vel(a1)
                move.w  x_vel(a1),ground_vel(a1)
                bset    #Status_OnObj,status(a1)
                bset    d6,status(a0)
                bclr    #Status_InAir,status(a1)
                beq.s   locret_1E4D4
                move.l  a0,-(sp)
                movea.l a1,a0
                jsr     (Player_TouchFloor).l
                movea.l (sp)+,a0

locret_1E4D4:
                rts
; End of function RideObject_SetRide

; ---------------------------------------------------------------------------

loc_1E4D6:
                move.w  y_pos(a0),d0
                add.w   d3,d0
                move.w  y_pos(a1),d2
                move.b  y_radius(a1),d1
                ext.w   d1
                neg.w   d1
                add.w   d2,d1
                subq.w  #4,d1
                sub.w   d0,d1
                bhi.s   locret_1E4D4
                cmpi.w  #-$10,d1
                blo.s   locret_1E4D4
                tst.b   object_control(a1)
                bmi.s   locret_1E4D4
                cmpi.b  #6,routine(a1)
                bhs.s   locret_1E4D4
                sub.w   d1,d2
                subq.w  #4,d2
                move.w  d2,y_pos(a1)
                bra.s   RideObject_SetRide
; ---------------------------------------------------------------------------

SolidObjCheckSloped2:
                tst.w   y_vel(a1)
                bmi.w   locret_1E4D4
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                bmi.s   locret_1E4D4
                add.w   d1,d1
                cmp.w   d1,d0
                bhs.s   locret_1E4D4
                btst    #0,render_flags(a0)
                beq.s   loc_1E534
                not.w   d0
                add.w   d1,d0

loc_1E534:
                lsr.w   #1,d0
                move.b  (a2,d0.w),d3
                ext.w   d3
                move.w  y_pos(a0),d0
                sub.w   d3,d0
                bra.w   loc_1E45A
; ---------------------------------------------------------------------------

SolidObjCheckSloped:
                tst.w   y_vel(a1)
                bmi.w   locret_1E4D4
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                bmi.w   locret_1E4D4
                add.w   d1,d1
                cmp.w   d1,d0
                bhs.w   locret_1E4D4
                btst    #0,render_flags(a0)
                beq.s   loc_1E570
                not.w   d0
                add.w   d1,d0

loc_1E570:
                move.b  (a2,d0.w),d3
                ext.w   d3
                move.w  y_pos(a0),d0
                sub.w   d3,d0
                bra.w   loc_1E45A

; =============== S U B R O U T I N E =======================================

CheckPlayerReleaseFromObj:
                lea     (Player_1).w,a1
                btst    #p1_standing_bit,status(a0)
                beq.s   loc_1E5AE
                jsr     (SonicOnObjHitFloor).l
                tst.w   d1
                beq.s   loc_1E598
                bpl.s   loc_1E5AE

loc_1E598:
                lea     (Player_1).w,a1
                bclr    #Status_OnObj,status(a1)
                bset    #Status_InAir,status(a1)
                bclr    #p1_standing_bit,status(a0)

loc_1E5AE:
                lea     (Player_2).w,a1
                btst    #p2_standing_bit,status(a0)
                beq.s   loc_1E5DC
                jsr     (SonicOnObjHitFloor).l
                tst.w   d1
                beq.s   loc_1E5C6
                bpl.s   loc_1E5DC

loc_1E5C6:
                lea     (Player_2).w,a1
                bclr    #Status_OnObj,status(a1)
                bset    #Status_InAir,status(a1)
                bclr    #p2_standing_bit,status(a0)

loc_1E5DC:
                moveq   #0,d4
                rts
; End of function CheckPlayerReleaseFromObj
