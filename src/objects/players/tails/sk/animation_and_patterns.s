; Owner: objects/players/tails/sk
; Responsibility: Normal Tails and tail animation sequences with dynamic pattern loading
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Animate_Tails:
                lea     (AniTails).l,a1

Animate_Tails_Part2:
                moveq   #0,d0
                move.b  anim(a0),d0
                cmp.b   prev_anim(a0),d0
                beq.s   loc_1588A
                move.b  d0,prev_anim(a0)
                move.b  #0,anim_frame(a0)
                move.b  #0,anim_frame_timer(a0)
                bclr    #Status_Push,status(a0)

loc_1588A:
                add.w   d0,d0
                adda.w  (a1,d0.w),a1
                move.b  (a1),d0
                bmi.s   loc_158FA
                move.b  status(a0),d1
                andi.b  #1,d1
                andi.b  #$FC,render_flags(a0)
                or.b    d1,render_flags(a0)
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   locret_158C8
                move.b  d0,anim_frame_timer(a0)
; End of function Animate_Tails

; =============== S U B R O U T I N E =======================================

TailsSKStepNormalAnimationFrameBytecode:
                moveq   #0,d1
                move.b  anim_frame(a0),d1
                move.b  1(a1,d1.w),d0
                cmpi.b  #$FC,d0
                bhs.s   loc_158CA

loc_158C0:
                move.b  d0,mapping_frame(a0)
                addq.b  #1,anim_frame(a0)

locret_158C8:
                rts
; ---------------------------------------------------------------------------

loc_158CA:
                addq.b  #1,d0
                bne.s   loc_158DA
                move.b  #0,anim_frame(a0)
                move.b  1(a1),d0
                bra.s   loc_158C0
; ---------------------------------------------------------------------------

loc_158DA:
                addq.b  #1,d0
                bne.s   loc_158EE
                move.b  2(a1,d1.w),d0
                sub.b   d0,anim_frame(a0)
                sub.b   d0,d1
                move.b  1(a1,d1.w),d0
                bra.s   loc_158C0
; ---------------------------------------------------------------------------

loc_158EE:
                addq.b  #1,d0
                bne.s   locret_158F8
                move.b  2(a1,d1.w),anim(a0)

locret_158F8:
                rts
; End of function TailsSKStepNormalAnimationFrameBytecode

; ---------------------------------------------------------------------------

loc_158FA:
                addq.b  #1,d0
                bne.w   loc_159C8
                moveq   #0,d0
                tst.b   flip_type(a0)
                bmi.w   Anim_Tumble
                move.b  flip_angle(a0),d0
                bne.w   Anim_Tumble
                moveq   #0,d1
                move.b  angle(a0),d0
                bmi.s   loc_1591E
                beq.s   loc_1591E
                subq.b  #1,d0

loc_1591E:
                move.b  status(a0),d2
                andi.b  #1,d2
                bne.s   loc_1592A
                not.b   d0

loc_1592A:
                addi.b  #$10,d0
                bpl.s   loc_15932
                moveq   #3,d1

loc_15932:
                andi.b  #$FC,render_flags(a0)
                eor.b   d1,d2
                or.b    d2,render_flags(a0)
                btst    #Status_Push,status(a0)
                bne.w   loc_15A14
                lsr.b   #4,d0
                andi.b  #6,d0
                move.w  ground_vel(a0),d2
                bpl.s   loc_15956
                neg.w   d2

loc_15956:
                tst.b   status_secondary(a0)
                bpl.w   loc_15960
                add.w   d2,d2

loc_15960:
                move.b  d0,d3
                add.b   d3,d3
                add.b   d3,d3
                lea     (AniTails00).l,a1
                cmpi.w  #$600,d2
                blo.s   loc_1598A
                lea     (AniTails01).l,a1
                move.b  d0,d3
                add.b   d3,d3
                cmpi.w  #$700,d2
                blo.s   loc_1598A
                lea     (AniTails1F).l,a1
                move.b  d0,d3

loc_1598A:
                moveq   #0,d1
                move.b  anim_frame(a0),d1
                move.b  1(a1,d1.w),d0
                cmpi.b  #-1,d0
                bne.s   loc_159A4
                move.b  #0,anim_frame(a0)
                move.b  1(a1),d0

loc_159A4:
                move.b  d0,mapping_frame(a0)
                add.b   d3,mapping_frame(a0)
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   locret_159C6
                neg.w   d2
                addi.w  #$800,d2
                bpl.s   loc_159BC
                moveq   #0,d2

loc_159BC:
                lsr.w   #8,d2
                move.b  d2,anim_frame_timer(a0)
                addq.b  #1,anim_frame(a0)

locret_159C6:
                rts
; ---------------------------------------------------------------------------

loc_159C8:
                addq.b  #1,d0
                bne.s   loc_15A3C
                move.b  status(a0),d1
                andi.b  #1,d1
                andi.b  #$FC,render_flags(a0)
                or.b    d1,render_flags(a0)
                subq.b  #1,anim_frame_timer(a0)
                bpl.w   locret_158C8
                move.w  ground_vel(a0),d2
                bpl.s   loc_159EE
                neg.w   d2

loc_159EE:
                lea     (AniTails03).l,a1
                cmpi.w  #$600,d2
                bhs.s   loc_15A00
                lea     (AniTails02).l,a1

loc_15A00:
                neg.w   d2
                addi.w  #$400,d2
                bpl.s   loc_15A0A
                moveq   #0,d2

loc_15A0A:
                lsr.w   #8,d2
                move.b  d2,anim_frame_timer(a0)
                bra.w   TailsSKStepNormalAnimationFrameBytecode
; ---------------------------------------------------------------------------

loc_15A14:
                subq.b  #1,anim_frame_timer(a0)
                bpl.w   locret_158C8
                move.w  ground_vel(a0),d2
                bmi.s   loc_15A24
                neg.w   d2

loc_15A24:
                addi.w  #$800,d2
                bpl.s   loc_15A2C
                moveq   #0,d2

loc_15A2C:
                lsr.w   #6,d2
                move.b  d2,anim_frame_timer(a0)
                lea     (AniTails04).l,a1
                bra.w   TailsSKStepNormalAnimationFrameBytecode
; ---------------------------------------------------------------------------

loc_15A3C:
                subq.b  #1,anim_frame_timer(a0)
                bpl.w   locret_158C8
                move.w  x_vel(a2),d1
                move.w  y_vel(a2),d2
                jsr     (GetArcTan).l
                cmpi.b  #$15,(Current_zone).w
                bne.s   loc_15A5E
                add.b   (Stat_table).w,d0

loc_15A5E:
                moveq   #0,d1
                move.b  status(a0),d2
                andi.b  #1,d2
                bne.s   loc_15A6E
                not.b   d0
                bra.s   loc_15A72
; ---------------------------------------------------------------------------

loc_15A6E:
                addi.b  #$80,d0

loc_15A72:
                addi.b  #$10,d0
                bpl.s   loc_15A7A
                moveq   #3,d1

loc_15A7A:
                andi.b  #$FC,render_flags(a0)
                eor.b   d1,d2
                or.b    d2,render_flags(a0)
                tst.b   (Reverse_gravity_flag).w
                beq.s   loc_15A92
                eori.b  #2,render_flags(a0)

loc_15A92:
                lsr.b   #3,d0
                andi.b  #$C,d0
                move.b  d0,d3
                lea     (AniTails_Tail03).l,a1
                move.b  #3,anim_frame_timer(a0)
                bsr.w   TailsSKStepNormalAnimationFrameBytecode
                add.b   d3,mapping_frame(a0)
                rts
; ---------------------------------------------------------------------------
AniTails:
                include "src/objects/shared/tails/animations/tails.s"
; ---------------------------------------------------------------------------

Tails_Tail_Load_PLC:
                moveq   #0,d0
                move.b  mapping_frame(a0),d0
                cmp.b   (Player_prev_frame_P2_tail).w,d0
                beq.w   locret_15CCE
                move.b  d0,(Player_prev_frame_P2_tail).w
                lea     (PLC_Tails_Tail).l,a2
                add.w   d0,d0
                adda.w  (a2,d0.w),a2
                move.w  (a2)+,d5
                subq.w  #1,d5
                bmi.s   locret_15CCE
                move.w  #tiles_to_bytes(ArtTile_Player_2_Tail),d4
                move.l  #ArtUnc_Tails_Tail,d6
                bra.s   loc_15CA6

; =============== S U B R O U T I N E =======================================

Tails_Load_PLC:
                moveq   #0,d0
                move.b  mapping_frame(a0),d0

Tails_Load_PLC2:
                cmp.b   (Player_prev_frame_P2).w,d0
                beq.s   locret_15CCE
                move.b  d0,(Player_prev_frame_P2).w
                lea     (PLC_Tails).l,a2
                add.w   d0,d0
                adda.w  (a2,d0.w),a2
                move.w  (a2)+,d5
                subq.w  #1,d5
                bmi.s   locret_15CCE
                move.w  #tiles_to_bytes(ArtTile_Player_2),d4
                move.l  #ArtUnc_Tails,d6
                cmpi.w  #2*$D1,d0
                blo.s   loc_15CA6
                move.l  #ArtUnc_Tails_Extra,d6

loc_15CA6:
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
                dbf     d5,loc_15CA6

locret_15CCE:
                rts
; End of function Tails_Load_PLC

; =============== S U B R O U T I N E =======================================
