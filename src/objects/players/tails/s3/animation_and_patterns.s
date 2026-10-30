; Owner: objects/players/tails/s3
; Responsibility: Normal Tails and tail animation sequences with dynamic pattern loading
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Animate_Tails:
                lea     (AniTails).l,a1

Animate_Tails_Part2:
                moveq   #0,d0
                move.b  anim(a0),d0
                cmp.b   prev_anim(a0),d0
                beq.s   loc_16392
                move.b  d0,prev_anim(a0)
                move.b  #0,anim_frame(a0)
                move.b  #0,anim_frame_timer(a0)
                bclr    #Status_Push,status(a0)

loc_16392:
                add.w   d0,d0
                adda.w  (a1,d0.w),a1
                move.b  (a1),d0
                bmi.s   loc_16402
                move.b  status(a0),d1
                andi.b  #1,d1
                andi.b  #$FC,render_flags(a0)
                or.b    d1,render_flags(a0)
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   locret_163D0
                move.b  d0,anim_frame_timer(a0)
; End of function Animate_Tails

; =============== S U B R O U T I N E =======================================

sub_163B8:
                moveq   #0,d1
                move.b  anim_frame(a0),d1
                move.b  1(a1,d1.w),d0
                cmpi.b  #$F0,d0
                bhs.s   loc_163D2

loc_163C8:
                move.b  d0,mapping_frame(a0)
                addq.b  #1,anim_frame(a0)

locret_163D0:
                rts
; ---------------------------------------------------------------------------

loc_163D2:
                addq.b  #1,d0
                bne.s   loc_163E2
                move.b  #0,anim_frame(a0)
                move.b  1(a1),d0
                bra.s   loc_163C8
; ---------------------------------------------------------------------------

loc_163E2:
                addq.b  #1,d0
                bne.s   loc_163F6
                move.b  2(a1,d1.w),d0
                sub.b   d0,anim_frame(a0)
                sub.b   d0,d1
                move.b  1(a1,d1.w),d0
                bra.s   loc_163C8
; ---------------------------------------------------------------------------

loc_163F6:
                addq.b  #1,d0
                bne.s   locret_16400
                move.b  2(a1,d1.w),anim(a0)

locret_16400:
                rts
; End of function sub_163B8

; ---------------------------------------------------------------------------

loc_16402:
                addq.b  #1,d0
                bne.w   loc_164D0
                moveq   #0,d0
                tst.b   flip_type(a0)
                bmi.w   Anim_Tumble
                move.b  flip_angle(a0),d0
                bne.w   Anim_Tumble
                moveq   #0,d1
                move.b  angle(a0),d0
                bmi.s   loc_16426
                beq.s   loc_16426
                subq.b  #1,d0

loc_16426:
                move.b  status(a0),d2
                andi.b  #1,d2
                bne.s   loc_16432
                not.b   d0

loc_16432:
                addi.b  #$10,d0
                bpl.s   loc_1643A
                moveq   #3,d1

loc_1643A:
                andi.b  #$FC,render_flags(a0)
                eor.b   d1,d2
                or.b    d2,render_flags(a0)
                btst    #Status_Push,status(a0)
                bne.w   loc_1651C
                lsr.b   #4,d0
                andi.b  #6,d0
                move.w  ground_vel(a0),d2
                bpl.s   loc_1645E
                neg.w   d2

loc_1645E:
                tst.b   status_secondary(a0)
                bpl.w   loc_16468
                add.w   d2,d2

loc_16468:
                move.b  d0,d3
                add.b   d3,d3
                add.b   d3,d3
                lea     (AniTails00).l,a1
                cmpi.w  #$600,d2
                blo.s   loc_16492
                lea     (AniTails01).l,a1
                move.b  d0,d3
                add.b   d3,d3
                cmpi.w  #$700,d2
                blo.s   loc_16492
                lea     (AniTails1F).l,a1
                move.b  d0,d3

loc_16492:
                moveq   #0,d1
                move.b  anim_frame(a0),d1
                move.b  1(a1,d1.w),d0
                cmpi.b  #-1,d0
                bne.s   loc_164AC
                move.b  #0,anim_frame(a0)
                move.b  1(a1),d0

loc_164AC:
                move.b  d0,mapping_frame(a0)
                add.b   d3,mapping_frame(a0)
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   locret_164CE
                neg.w   d2
                addi.w  #$800,d2
                bpl.s   loc_164C4
                moveq   #0,d2

loc_164C4:
                lsr.w   #8,d2
                move.b  d2,anim_frame_timer(a0)
                addq.b  #1,anim_frame(a0)

locret_164CE:
                rts
; ---------------------------------------------------------------------------

loc_164D0:
                subq.b  #1,anim_frame_timer(a0)
                bpl.w   locret_163D0
                addq.b  #1,d0
                bne.s   loc_16556
                move.w  ground_vel(a0),d2
                bpl.s   loc_164E4
                neg.w   d2

loc_164E4:
                lea     (AniTails03).l,a1
                cmpi.w  #$600,d2
                bhs.s   loc_164F6
                lea     (AniTails02).l,a1

loc_164F6:
                neg.w   d2
                addi.w  #$400,d2
                bpl.s   loc_16500
                moveq   #0,d2

loc_16500:
                lsr.w   #8,d2
                move.b  d2,anim_frame_timer(a0)
                move.b  status(a0),d1
                andi.b  #1,d1
                andi.b  #$FC,render_flags(a0)
                or.b    d1,render_flags(a0)
                bra.w   sub_163B8
; ---------------------------------------------------------------------------

loc_1651C:
                subq.b  #1,anim_frame_timer(a0)
                bpl.w   locret_163D0
                move.w  ground_vel(a0),d2
                bmi.s   loc_1652C
                neg.w   d2

loc_1652C:
                addi.w  #$800,d2
                bpl.s   loc_16534
                moveq   #0,d2

loc_16534:
                lsr.w   #6,d2
                move.b  d2,anim_frame_timer(a0)
                lea     (AniTails04).l,a1
                move.b  status(a0),d1
                andi.b  #1,d1
                andi.b  #$FC,render_flags(a0)
                or.b    d1,render_flags(a0)
                bra.w   sub_163B8
; ---------------------------------------------------------------------------

loc_16556:
                move.w  x_vel(a2),d1
                move.w  y_vel(a2),d2
                jsr     (GetArcTan).l
                moveq   #0,d1
                move.b  status(a0),d2
                andi.b  #1,d2
                bne.s   loc_16574
                not.b   d0
                bra.s   loc_16578
; ---------------------------------------------------------------------------

loc_16574:
                addi.b  #$80,d0

loc_16578:
                addi.b  #$10,d0
                bpl.s   loc_16580
                moveq   #3,d1

loc_16580:
                andi.b  #$FC,render_flags(a0)
                eor.b   d1,d2
                or.b    d2,render_flags(a0)
                lsr.b   #3,d0
                andi.b  #$C,d0
                move.b  d0,d3
                lea     (AniTails_Tail03).l,a1
                move.b  #3,anim_frame_timer(a0)
                bsr.w   sub_163B8
                add.b   d3,mapping_frame(a0)
                rts
; ---------------------------------------------------------------------------
AniTails:
                include "src/objects/shared/tails/anim_tails_s3.s"
; ---------------------------------------------------------------------------

Tails_Tail_Load_PLC:
                moveq   #0,d0
                move.b  mapping_frame(a0),d0
                cmp.b   (Player_prev_frame_P2_tail).w,d0
                beq.s   locret_167AA
                move.b  d0,(Player_prev_frame_P2_tail).w
                lea     (PLC_Tails_Tail).l,a2
                add.w   d0,d0
                adda.w  (a2,d0.w),a2
                move.w  (a2)+,d5
                subq.w  #1,d5
                bmi.s   locret_167AA
                move.w  #tiles_to_bytes(ArtTile_Player_2_Tail),d4
                move.l  #ArtUnc_Tails_Tail,d6
                bra.s   loc_16782

; =============== S U B R O U T I N E =======================================

Tails_Load_PLC:
                moveq   #0,d0
                move.b  mapping_frame(a0),d0

Tails_Load_PLC2:
                cmp.b   (Player_prev_frame_P2).w,d0
                beq.s   locret_167AA
                move.b  d0,(Player_prev_frame_P2).w
                lea     (PLC_Tails).l,a2
                add.w   d0,d0
                adda.w  (a2,d0.w),a2
                move.w  (a2)+,d5
                subq.w  #1,d5
                bmi.s   locret_167AA
                move.w  #tiles_to_bytes(ArtTile_Player_2),d4
                move.l  #ArtUnc_Tails,d6

loc_16782:
                moveq   #0,d1
                move.w  (a2)+,d1
                move.w  d1,d3
                lsr.w   #8,d3
                andi.w  #$F0,d3
                addi.w  #$10,d3
                andi.w  #$FFF,d1
                lsl.l   #5,d1
                add.l   d6,d1
                move.w  d4,d2
                add.w   d3,d4
                add.w   d3,d4
                jsr     (Add_To_DMA_Queue).l
                dbf     d5,loc_16782

locret_167AA:
                rts
; End of function Tails_Load_PLC

; =============== S U B R O U T I N E =======================================
