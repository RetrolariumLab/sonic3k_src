; Owner: game/collision/sk
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
                bpl.w   locret_1DCB4
                addq.b  #p2_standing_bit-p1_standing_bit,d6
; End of function SolidObjectFull

; =============== S U B R O U T I N E =======================================

SolidObjectFull_1P:
                btst    d6,status(a0)
                beq.w   loc_1DF88
                move.w  d1,d2
                add.w   d2,d2
                btst    #Status_InAir,status(a1)
                bne.s   loc_1DC98
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                bmi.s   loc_1DC98
                cmp.w   d2,d0
                blo.s   loc_1DCAC

loc_1DC98:
                bclr    #Status_OnObj,status(a1)
                bset    #Status_InAir,status(a1)
                bclr    d6,status(a0)
                moveq   #0,d4
                rts
; ---------------------------------------------------------------------------

loc_1DCAC:
                move.w  d4,d2
                bsr.w   MvSonicOnPtfm
                moveq   #0,d4

locret_1DCB4:
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
                bne.s   loc_1DCF0
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                bmi.s   loc_1DCF0
                cmp.w   d2,d0
                blo.s   loc_1DD04

loc_1DCF0:
                bclr    #Status_OnObj,status(a1)
                bset    #Status_InAir,status(a1)
                bclr    d6,status(a0)
                moveq   #0,d4
                rts
; ---------------------------------------------------------------------------

loc_1DD04:
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
                beq.w   loc_1DECE
                move.w  d1,d2
                add.w   d2,d2
                btst    #Status_InAir,status(a1)
                bne.s   loc_1DD48
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                bmi.s   loc_1DD48
                cmp.w   d2,d0
                blo.s   loc_1DD5C

loc_1DD48:
                bclr    #Status_OnObj,status(a1)
                bset    #Status_InAir,status(a1)
                bclr    d6,status(a0)
                moveq   #0,d4
                rts
; ---------------------------------------------------------------------------

loc_1DD5C:
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
                beq.w   loc_1DF28
                move.w  d1,d2
                add.w   d2,d2
                btst    #Status_InAir,status(a1)
                bne.s   loc_1DDA8
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                bmi.s   loc_1DDA8
                cmp.w   d2,d0
                blo.s   loc_1DDBC

loc_1DDA8:
                bclr    #Status_OnObj,status(a1)
                bset    #Status_InAir,status(a1)
                bclr    d6,status(a0)
                moveq   #0,d4
                rts
; ---------------------------------------------------------------------------

loc_1DDBC:
                move.w  d4,d2
                bsr.w   SolidObjSloped4
                moveq   #0,d4
                rts
; End of function CollidePlayerWithDualHeightProfileSolid

; =============== S U B R O U T I N E =======================================

CollidePlayersWithHeightProfileKeepAirState:
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d6
                movem.l d1-d4,-(sp)
                bsr.s   CollidePlayerWithHeightProfileKeepAirState
                movem.l (sp)+,d1-d4
                lea     (Player_2).w,a1
                addq.b  #p2_standing_bit-p1_standing_bit,d6
; End of function CollidePlayersWithHeightProfileKeepAirState

; =============== S U B R O U T I N E =======================================

CollidePlayerWithHeightProfileKeepAirState:
                btst    d6,status(a0)
                beq.w   loc_1DECE
                move.w  d1,d2
                add.w   d2,d2
                btst    #Status_InAir,status(a1)
                bne.s   loc_1DE00
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                bmi.s   loc_1DE00
                cmp.w   d2,d0
                blo.s   loc_1DE0E

loc_1DE00:
                bclr    #Status_OnObj,status(a1)
                bclr    d6,status(a0)
                moveq   #0,d4
                rts
; ---------------------------------------------------------------------------

loc_1DE0E:
                move.w  d4,d2
                bsr.w   SolidObjSloped2
                move.w  d6,d4
                addi.b  #$11,d4
                bset    d4,d6
                moveq   #0,d4
                rts
; End of function CollidePlayerWithHeightProfileKeepAirState

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
                beq.w   loc_1DE8C
                btst    #Status_InAir,status(a1)
                bne.s   loc_1DE58
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                bmi.s   loc_1DE58
                add.w   d1,d1
                cmp.w   d1,d0
                blo.s   loc_1DE6C

loc_1DE58:
                bclr    #Status_OnObj,status(a1)
                bset    #Status_InAir,status(a1)
                bclr    d6,status(a0)
                moveq   #0,d4
                rts
; ---------------------------------------------------------------------------

loc_1DE6C:
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

loc_1DE8C:
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                bmi.w   loc_1E0A2
                move.w  d1,d4
                add.w   d4,d4
                cmp.w   d4,d0
                bhi.w   loc_1E0A2
                move.w  y_pos(a0),d5
                add.w   d3,d5
                move.b  y_radius(a1),d3
                ext.w   d3
                add.w   d3,d2
                move.w  y_pos(a1),d3
                sub.w   d5,d3
                addq.w  #4,d3
                add.w   d2,d3
                bmi.w   loc_1E0A2
                move.w  d2,d4
                add.w   d4,d4
                cmp.w   d4,d3
                bhs.w   loc_1E0A2
                bra.w   loc_1DFFE
; ---------------------------------------------------------------------------

loc_1DECE:
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                bmi.w   loc_1E0A2
                move.w  d1,d3
                add.w   d3,d3
                cmp.w   d3,d0
                bhi.w   loc_1E0A2
                move.w  d0,d5
                btst    #0,render_flags(a0)
                beq.s   loc_1DEF4
                not.w   d5
                add.w   d3,d5

loc_1DEF4:
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
                bmi.w   loc_1E0A2
                move.w  d2,d4
                add.w   d4,d4
                cmp.w   d4,d3
                bhs.w   loc_1E0A2
                bra.w   loc_1DFFE
; ---------------------------------------------------------------------------

loc_1DF28:
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                bmi.w   loc_1E0A2
                move.w  d1,d3
                add.w   d3,d3
                cmp.w   d3,d0
                bhi.w   loc_1E0A2
                move.w  d0,d5
                btst    #0,render_flags(a0)
                beq.s   loc_1DF4E
                not.w   d5
                add.w   d3,d5

loc_1DF4E:
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
                bmi.w   loc_1E0A2
                add.w   d5,d2
                move.w  d2,d4
                add.w   d5,d4
                cmp.w   d4,d3
                bhs.w   loc_1E0A2
                bra.w   loc_1DFFE
; ---------------------------------------------------------------------------

loc_1DF88:
                tst.b   render_flags(a0)
                bpl.w   loc_1E0A2

SolidObject_cont:
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                move.w  d1,d3
                add.w   d3,d3
                cmp.w   d3,d0
                bhi.w   loc_1E0A2
                tst.b   (Reverse_gravity_flag).w
                beq.s   loc_1DFD6
                move.b  default_y_radius(a1),d4
                ext.w   d4
                add.w   d2,d4
                move.b  y_radius(a1),d3
                ext.w   d3
                add.w   d3,d2
                move.w  y_pos(a1),d3
                sub.w   y_pos(a0),d3
                neg.w   d3
                addq.w  #4,d3
                add.w   d2,d3
                andi.w  #$FFF,d3
                add.w   d2,d4
                cmp.w   d4,d3
                bhs.w   loc_1E0A2
                bra.s   loc_1DFFE
; ---------------------------------------------------------------------------

loc_1DFD6:
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
                andi.w  #$FFF,d3
                add.w   d2,d4
                cmp.w   d4,d3
                bhs.w   loc_1E0A2

loc_1DFFE:
                tst.b   object_control(a1)
                bmi.w   loc_1E0A2
                cmpi.b  #6,routine(a1)
                bhs.w   loc_1E0D0
                tst.w   (Debug_placement_mode).w
                bne.w   loc_1E0D0
                move.w  d0,d5
                cmp.w   d0,d1
                bhs.s   loc_1E026
                add.w   d1,d1
                sub.w   d1,d0
                move.w  d0,d5
                neg.w   d5

loc_1E026:
                move.w  d3,d1
                cmp.w   d3,d2
                bhs.s   loc_1E034
                subq.w  #4,d3
                sub.w   d4,d3
                move.w  d3,d1
                neg.w   d1

loc_1E034:
                cmp.w   d1,d5
                bhi.w   loc_1E0D4
                cmpi.w  #4,d1
                bls.w   loc_1E0D4

loc_1E042:
                tst.w   d0
                beq.s   loc_1E06E
                bmi.s   loc_1E050
                tst.w   x_vel(a1)
                bmi.s   loc_1E06E
                bra.s   loc_1E056
; ---------------------------------------------------------------------------

loc_1E050:
                tst.w   x_vel(a1)
                bpl.s   loc_1E06E

loc_1E056:
                move.w  #0,ground_vel(a1)
                move.w  #0,x_vel(a1)
                tst.b   status_tertiary(a1)
                bpl.s   loc_1E06E
                bset    #6,status_tertiary(a1)

loc_1E06E:
                sub.w   d0,x_pos(a1)
                btst    #Status_InAir,status(a1)
                bne.s   loc_1E094
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

loc_1E094:
                bsr.s   ClearPlayerPushingSolid
                move.w  d6,d4
                addi.b  #$D,d4
                bset    d4,d6
                moveq   #1,d4
                rts
; ---------------------------------------------------------------------------

loc_1E0A2:
                move.l  d6,d4
                addq.b  #pushing_bit_delta,d4
                btst    d4,status(a0)
                beq.s   loc_1E0D0
                cmpi.b  #2,anim(a1)
                beq.s   ClearPlayerPushingSolid
                cmpi.b  #9,anim(a1)
                beq.s   ClearPlayerPushingSolid
                move.w  #1,anim(a1)
; End of function SolidObjectFull_Offset_1P

; =============== S U B R O U T I N E =======================================

ClearPlayerPushingSolid:
                move.l  d6,d4
                addq.b  #pushing_bit_delta,d4
                bclr    d4,status(a0)
                bclr    #Status_Push,status(a1)

loc_1E0D0:
                moveq   #0,d4
                rts
; End of function ClearPlayerPushingSolid

; ---------------------------------------------------------------------------

loc_1E0D4:
                tst.w   d3
                bmi.s   loc_1E0E0
                cmpi.w  #$10,d3
                blo.s   loc_1E154
                bra.s   loc_1E0A2
; ---------------------------------------------------------------------------

loc_1E0E0:
                btst    #Status_InAir,status(a1)
                bne.s   loc_1E0F6
                tst.w   y_vel(a1)
                beq.s   loc_1E126
                bpl.s   loc_1E10E
                tst.w   d3
                bpl.s   loc_1E10E
                bra.s   loc_1E0FC
; ---------------------------------------------------------------------------

loc_1E0F6:
                move.w  #0,ground_vel(a1)

loc_1E0FC:
                tst.b   (Reverse_gravity_flag).w
                beq.s   loc_1E104
                neg.w   d3

loc_1E104:
                sub.w   d3,y_pos(a1)
                move.w  #0,y_vel(a1)

loc_1E10E:
                tst.b   status_tertiary(a1)
                bpl.s   loc_1E11A
                bset    #5,status_tertiary(a1)

loc_1E11A:
                move.w  d6,d4
                addi.b  #$F,d4
                bset    d4,d6
                moveq   #-2,d4
                rts
; ---------------------------------------------------------------------------

loc_1E126:
                btst    #Status_InAir,status(a1)
                bne.s   loc_1E10E
                move.w  d0,d4
                bpl.s   loc_1E134
                neg.w   d4

loc_1E134:
                cmpi.w  #$10,d4
                blo.w   loc_1E042
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

loc_1E154:
                subq.w  #4,d3
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                move.w  d1,d2
                add.w   d2,d2
                add.w   x_pos(a1),d1
                sub.w   x_pos(a0),d1
                bmi.s   loc_1E198
                cmp.w   d2,d1
                bhs.s   loc_1E198
                subq.w  #1,y_pos(a1)
                tst.b   (Reverse_gravity_flag).w
                beq.s   loc_1E17E
                neg.w   d3
                addq.w  #2,y_pos(a1)

loc_1E17E:
                sub.w   d3,y_pos(a1)
                tst.w   y_vel(a1)
                bmi.s   loc_1E198
                bsr.w   RideObject_SetRide
                move.w  d6,d4
                addi.b  #$11,d4
                bset    d4,d6
                moveq   #-1,d4
                rts
; ---------------------------------------------------------------------------

loc_1E198:
                moveq   #0,d4
                rts

; =============== S U B R O U T I N E =======================================

MvSonicOnPtfm:
                tst.b   (Reverse_gravity_flag).w
                bne.s   loc_1E1AA
                move.w  y_pos(a0),d0
                sub.w   d3,d0
                bra.s   loc_1E1CA
; ---------------------------------------------------------------------------

loc_1E1AA:
                move.w  y_pos(a0),d0
                add.w   d3,d0
                bra.s   loc_1E1F4
; ---------------------------------------------------------------------------
; This is hilarious. The unused S1 code was upgraded with an S3K feature
                tst.b   (Reverse_gravity_flag).w
                beq.s   loc_1E1C2
                move.w  y_pos(a0),d0
                addi.w  #9,d0
                bra.s   loc_1E1F4
; ---------------------------------------------------------------------------

loc_1E1C2:
                move.w  y_pos(a0),d0
                subi.w  #9,d0

loc_1E1CA:
                tst.b   object_control(a1)
                bmi.s   locret_1E1F2
                cmpi.b  #6,routine(a1)
                bhs.s   locret_1E1F2
                tst.w   (Debug_placement_mode).w
                bne.s   locret_1E1F2
                moveq   #0,d1
                move.b  y_radius(a1),d1
                sub.w   d1,d0
                move.w  d0,y_pos(a1)
                sub.w   x_pos(a0),d2
                sub.w   d2,x_pos(a1)

locret_1E1F2:
                rts
; ---------------------------------------------------------------------------

loc_1E1F4:
                tst.b   object_control(a1)
                bmi.s   locret_1E21C
                cmpi.b  #6,routine(a1)
                bhs.s   locret_1E21C
                tst.w   (Debug_placement_mode).w
                bne.s   locret_1E21C
                moveq   #0,d1
                move.b  y_radius(a1),d1
                add.w   d1,d0
                move.w  d0,y_pos(a1)
                sub.w   x_pos(a0),d2
                sub.w   d2,x_pos(a1)

locret_1E21C:
                rts
; End of function MvSonicOnPtfm
