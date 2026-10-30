; Owner: objects/players/sonic/s3
; Responsibility: Sonic animation selection, dynamic pattern loading and the common player DPLC dispatch interface
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Animate_Sonic:
                lea     (AniSonic).l,a1
                tst.b   (Super_Sonic_Knux_flag).w
                beq.s   loc_1345E
                lea     (AniSuperSonic).l,a1

loc_1345E:
                moveq   #0,d0
                move.b  anim(a0),d0
                cmp.b   prev_anim(a0),d0
                beq.s   loc_13480
                move.b  d0,prev_anim(a0)
                move.b  #0,anim_frame(a0)
                move.b  #0,anim_frame_timer(a0)
                bclr    #Status_Push,status(a0)

loc_13480:
                add.w   d0,d0
                adda.w  (a1,d0.w),a1
                move.b  (a1),d0
                bmi.s   loc_134F0
                move.b  status(a0),d1
                andi.b  #1,d1
                andi.b  #$FC,render_flags(a0)
                or.b    d1,render_flags(a0)
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   locret_134BE
                move.b  d0,anim_frame_timer(a0)

loc_134A6:
                moveq   #0,d1
                move.b  anim_frame(a0),d1
                move.b  1(a1,d1.w),d0
                cmpi.b  #$FC,d0
                bhs.s   loc_134C0

loc_134B6:
                move.b  d0,mapping_frame(a0)
                addq.b  #1,anim_frame(a0)

locret_134BE:
                rts
; ---------------------------------------------------------------------------

loc_134C0:
                addq.b  #1,d0
                bne.s   loc_134D0
                move.b  #0,anim_frame(a0)
                move.b  1(a1),d0
                bra.s   loc_134B6
; ---------------------------------------------------------------------------

loc_134D0:
                addq.b  #1,d0
                bne.s   loc_134E4
                move.b  2(a1,d1.w),d0
                sub.b   d0,anim_frame(a0)
                sub.b   d0,d1
                move.b  1(a1,d1.w),d0
                bra.s   loc_134B6
; ---------------------------------------------------------------------------

loc_134E4:
                addq.b  #1,d0
                bne.s   locret_134EE
                move.b  2(a1,d1.w),anim(a0)

locret_134EE:
                rts
; ---------------------------------------------------------------------------

loc_134F0:
                addq.b  #1,d0
                bne.w   loc_13786
                moveq   #0,d0
                tst.b   flip_type(a0)
                bmi.w   Anim_Tumble
                move.b  flip_angle(a0),d0
                bne.w   Anim_Tumble
                moveq   #0,d1
                move.b  angle(a0),d0
                bmi.s   loc_13514
                beq.s   loc_13514
                subq.b  #1,d0

loc_13514:
                move.b  status(a0),d2
                andi.b  #1,d2
                bne.s   loc_13520
                not.b   d0

loc_13520:
                addi.b  #$10,d0
                bpl.s   loc_13528
                moveq   #3,d1

loc_13528:
                andi.b  #$FC,render_flags(a0)
                eor.b   d1,d2
                or.b    d2,render_flags(a0)
                btst    #Status_Push,status(a0)
                bne.w   loc_137CE
                lsr.b   #4,d0
                andi.b  #6,d0
                move.w  ground_vel(a0),d2
                bpl.s   loc_1354C
                neg.w   d2

loc_1354C:
                tst.b   status_secondary(a0)
                bpl.w   loc_13556
                add.w   d2,d2

loc_13556:
                tst.b   (Super_Sonic_Knux_flag).w
                bne.s   loc_135B2
                lea     (AniSonic01).l,a1
                cmpi.w  #$600,d2
                bhs.s   loc_13570
                lea     (AniSonic00).l,a1
                add.b   d0,d0

loc_13570:
                add.b   d0,d0
                move.b  d0,d3
                moveq   #0,d1
                move.b  anim_frame(a0),d1
                move.b  1(a1,d1.w),d0
                cmpi.b  #-1,d0
                bne.s   loc_1358E
                move.b  #0,anim_frame(a0)
                move.b  1(a1),d0

loc_1358E:
                move.b  d0,mapping_frame(a0)
                add.b   d3,mapping_frame(a0)
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   locret_135B0
                neg.w   d2
                addi.w  #$800,d2
                bpl.s   loc_135A6
                moveq   #0,d2

loc_135A6:
                lsr.w   #8,d2
                move.b  d2,anim_frame_timer(a0)
                addq.b  #1,anim_frame(a0)

locret_135B0:
                rts
; ---------------------------------------------------------------------------

loc_135B2:
                lea     (AniSuperSonic01).l,a1
                cmpi.w  #$800,d2
                bhs.s   loc_135CA
                lea     (AniSuperSonic00).l,a1
                add.b   d0,d0
                add.b   d0,d0
                bra.s   loc_135CC
; ---------------------------------------------------------------------------

loc_135CA:
                add.b   d0,d0

loc_135CC:
                move.b  d0,d3
                moveq   #0,d1
                move.b  anim_frame(a0),d1
                move.b  1(a1,d1.w),d0
                cmpi.b  #-1,d0
                bne.s   loc_135E8
                move.b  #0,anim_frame(a0)
                move.b  1(a1),d0

loc_135E8:
                move.b  d0,mapping_frame(a0)
                add.b   d3,mapping_frame(a0)
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   locret_1360A
                neg.w   d2
                addi.w  #$800,d2
                bpl.s   loc_13600
                moveq   #0,d2

loc_13600:
                lsr.w   #8,d2
                move.b  d2,anim_frame_timer(a0)
                addq.b  #1,anim_frame(a0)

locret_1360A:
                rts
; ---------------------------------------------------------------------------

; loc_1360C:
Anim_Tumble:
                move.b  flip_type(a0),d1
                andi.w  #$7F,d1
                bne.s   loc_13682
                move.b  flip_angle(a0),d0
                moveq   #0,d1
                move.b  status(a0),d2
                andi.b  #1,d2
                bne.s   Anim_TumbleLeft
                andi.b  #$FC,render_flags(a0)
                tst.b   flip_type(a0)
                bpl.s   loc_13640
                ori.b   #2,render_flags(a0)
                neg.b   d0
                addi.b  #$8F,d0
                bra.s   loc_13644
; ---------------------------------------------------------------------------

loc_13640:
                addi.b  #$B,d0

loc_13644:
                divu.w  #$16,d0
                addi.b  #$31,d0
                move.b  d0,mapping_frame(a0)
                move.b  #0,anim_frame_timer(a0)
                rts
; ---------------------------------------------------------------------------

; loc_13658:
Anim_TumbleLeft:
                andi.b  #$FC,render_flags(a0)
                ori.b   #3,render_flags(a0)
                neg.b   d0
                addi.b  #$8F,d0
                divu.w  #$16,d0
                addi.b  #$31,d0
                move.b  d0,mapping_frame(a0)
                move.b  #0,anim_frame_timer(a0)
                rts
; ---------------------------------------------------------------------------
byte_1367E:
                dc.b    0, $3D, $49, $49
                even
; ---------------------------------------------------------------------------

loc_13682:
                move.b  byte_1367E(pc,d1.w),d3
                cmpi.b  #1,d1
                bne.s   loc_136DA
                move.b  flip_angle(a0),d0
                moveq   #0,d1
                move.b  status(a0),d2
                andi.b  #1,d2
                bne.s   loc_136B8
                andi.b  #$FC,render_flags(a0)
                addi.b  #-8,d0
                divu.w  #$16,d0
                add.b   d3,d0
                move.b  d0,mapping_frame(a0)
                move.b  #0,anim_frame_timer(a0)
                rts
; ---------------------------------------------------------------------------

loc_136B8:
                andi.b  #$FC,render_flags(a0)
                ori.b   #1,render_flags(a0)
                addi.b  #-8,d0
                divu.w  #$16,d0
                add.b   d3,d0
                move.b  d0,mapping_frame(a0)
                move.b  #0,anim_frame_timer(a0)
                rts
; ---------------------------------------------------------------------------

loc_136DA:
                cmpi.b  #2,d1
                bne.s   loc_13730
                move.b  flip_angle(a0),d0
                moveq   #0,d1
                move.b  status(a0),d2
                andi.b  #1,d2
                bne.s   loc_1370C
                andi.b  #$FC,render_flags(a0)
                addi.b  #$B,d0
                divu.w  #$16,d0
                add.b   d3,d0
                move.b  d0,mapping_frame(a0)
                move.b  #0,anim_frame_timer(a0)
                rts
; ---------------------------------------------------------------------------

loc_1370C:
                andi.b  #$FC,render_flags(a0)
                ori.b   #3,render_flags(a0)
                neg.b   d0
                addi.b  #$8F,d0
                divu.w  #$16,d0
                add.b   d3,d0
                move.b  d0,mapping_frame(a0)
                move.b  #0,anim_frame_timer(a0)
                rts
; ---------------------------------------------------------------------------

loc_13730:
                move.b  flip_angle(a0),d0
                moveq   #0,d1
                move.b  status(a0),d2
                andi.b  #1,d2
                bne.s   loc_13764
                andi.b  #$FC,render_flags(a0)
                ori.b   #2,render_flags(a0)
                neg.b   d0
                addi.b  #$8F,d0
                divu.w  #$16,d0
                add.b   d3,d0
                move.b  d0,mapping_frame(a0)
                move.b  #0,anim_frame_timer(a0)
                rts
; ---------------------------------------------------------------------------

loc_13764:
                andi.b  #$FC,render_flags(a0)
                ori.b   #1,render_flags(a0)
                addi.b  #$B,d0
                divu.w  #$16,d0
                add.b   d3,d0
                move.b  d0,mapping_frame(a0)
                move.b  #0,anim_frame_timer(a0)
                rts
; ---------------------------------------------------------------------------

loc_13786:
                subq.b  #1,anim_frame_timer(a0)
                bpl.w   locret_134BE
                move.w  ground_vel(a0),d2
                bpl.s   loc_13796
                neg.w   d2

loc_13796:
                lea     (AniSonic03).l,a1
                cmpi.w  #$600,d2
                bhs.s   loc_137A8
                lea     (AniSonic02).l,a1

loc_137A8:
                neg.w   d2
                addi.w  #$400,d2
                bpl.s   loc_137B2
                moveq   #0,d2

loc_137B2:
                lsr.w   #8,d2
                move.b  d2,anim_frame_timer(a0)
                move.b  status(a0),d1
                andi.b  #1,d1
                andi.b  #$FC,render_flags(a0)
                or.b    d1,render_flags(a0)
                bra.w   loc_134A6
; ---------------------------------------------------------------------------

loc_137CE:
                subq.b  #1,anim_frame_timer(a0)
                bpl.w   locret_134BE
                move.w  ground_vel(a0),d2
                bmi.s   loc_137DE
                neg.w   d2

loc_137DE:
                addi.w  #$800,d2
                bpl.s   loc_137E6
                moveq   #0,d2

loc_137E6:
                lsr.w   #6,d2
                move.b  d2,anim_frame_timer(a0)
                lea     (AniSonic04).l,a1
                tst.b   (Super_Sonic_Knux_flag).w
                beq.s   loc_137FE
                lea     (AniSuperSonic04).l,a1

loc_137FE:
                move.b  status(a0),d1
                andi.b  #1,d1
                andi.b  #$FC,render_flags(a0)
                or.b    d1,render_flags(a0)
                bra.w   loc_134A6
; End of function Animate_Sonic

; ---------------------------------------------------------------------------
AniSonic:
                include "src/objects/shared/sonic/anim_sonic_s3.s"

; =============== S U B R O U T I N E =======================================

Sonic_Load_PLC:
                moveq   #0,d0
                move.b  mapping_frame(a0),d0

Sonic_Load_PLC2:
                cmp.b   (Player_prev_frame).w,d0
                beq.s   locret_13A80
                move.b  d0,(Player_prev_frame).w
                lea     (PLC_Sonic).l,a2
                tst.b   (Super_Sonic_Knux_flag).w
                beq.s   loc_13A44
                lea     (PLC_SuperSonic).l,a2

loc_13A44:
                add.w   d0,d0
                adda.w  (a2,d0.w),a2
                move.w  (a2)+,d5
                subq.w  #1,d5
                bmi.s   locret_13A80
                move.w  #tiles_to_bytes(ArtTile_Player_1),d4

loc_13A54:
                moveq   #0,d1
                move.w  (a2)+,d1
                move.w  d1,d3
                lsr.w   #8,d3
                andi.w  #$F0,d3
                addi.w  #$10,d3
                andi.w  #$FFF,d1
                lsl.l   #5,d1
                addi.l  #ArtUnc_Sonic,d1
                move.w  d4,d2
                add.w   d3,d4
                add.w   d3,d4
                jsr     (Add_To_DMA_Queue).l
                dbf     d5,loc_13A54

locret_13A80:
                rts
; End of function Sonic_Load_PLC

; =============== S U B R O U T I N E =======================================

Perform_Player_DPLC:
                tst.b   character_id(a1)
                beq.s   Sonic_Load_PLC2
                bra.w   Tails_Load_PLC2
; End of function Perform_Player_DPLC

; =============== S U B R O U T I N E =======================================
