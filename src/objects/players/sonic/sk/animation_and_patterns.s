; Owner: objects/players/sonic/sk
; Responsibility: Sonic animation selection, dynamic pattern loading and the common player DPLC dispatch interface
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Animate_Sonic:
                lea     (AniSonic).l,a1
                tst.b   (Super_Sonic_Knux_flag).w
                beq.s   loc_12612
                lea     (AniSuperSonic).l,a1

loc_12612:
                moveq   #0,d0
                move.b  anim(a0),d0
                cmp.b   prev_anim(a0),d0
                beq.s   loc_12634
                move.b  d0,prev_anim(a0)
                move.b  #0,anim_frame(a0)
                move.b  #0,anim_frame_timer(a0)
                bclr    #Status_Push,status(a0)

loc_12634:
                add.w   d0,d0
                adda.w  (a1,d0.w),a1
                move.b  (a1),d0
                bmi.s   loc_126A4
                move.b  status(a0),d1
                andi.b  #1,d1
                andi.b  #$FC,render_flags(a0)
                or.b    d1,render_flags(a0)
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   locret_12672
                move.b  d0,anim_frame_timer(a0)

loc_1265A:
                moveq   #0,d1
                move.b  anim_frame(a0),d1
                move.b  1(a1,d1.w),d0
                cmpi.b  #$FC,d0
                bhs.s   loc_12674

loc_1266A:
                move.b  d0,mapping_frame(a0)
                addq.b  #1,anim_frame(a0)

locret_12672:
                rts
; ---------------------------------------------------------------------------

loc_12674:
                addq.b  #1,d0
                bne.s   loc_12684
                move.b  #0,anim_frame(a0)
                move.b  1(a1),d0
                bra.s   loc_1266A
; ---------------------------------------------------------------------------

loc_12684:
                addq.b  #1,d0
                bne.s   loc_12698
                move.b  2(a1,d1.w),d0
                sub.b   d0,anim_frame(a0)
                sub.b   d0,d1
                move.b  1(a1,d1.w),d0
                bra.s   loc_1266A
; ---------------------------------------------------------------------------

loc_12698:
                addq.b  #1,d0
                bne.s   locret_126A2
                move.b  2(a1,d1.w),anim(a0)

locret_126A2:
                rts
; ---------------------------------------------------------------------------

loc_126A4:
                addq.b  #1,d0
                bne.w   loc_12A2A
                moveq   #0,d0
                tst.b   flip_type(a0)
                bmi.w   Anim_Tumble
                move.b  flip_angle(a0),d0
                bne.w   Anim_Tumble
                moveq   #0,d1
                move.b  angle(a0),d0
                bmi.s   loc_126C8
                beq.s   loc_126C8
                subq.b  #1,d0

loc_126C8:
                move.b  status(a0),d2
                andi.b  #1,d2
                bne.s   loc_126D4
                not.b   d0

loc_126D4:
                addi.b  #$10,d0
                bpl.s   loc_126DC
                moveq   #3,d1

loc_126DC:
                andi.b  #$FC,render_flags(a0)
                eor.b   d1,d2
                or.b    d2,render_flags(a0)
                btst    #Status_Push,status(a0)
                bne.w   loc_12A72
                lsr.b   #4,d0
                andi.b  #6,d0
                move.w  ground_vel(a0),d2
                bpl.s   loc_12700
                neg.w   d2

loc_12700:
                tst.b   status_secondary(a0)
                bpl.w   loc_1270A
                add.w   d2,d2

loc_1270A:
                tst.b   (Super_Sonic_Knux_flag).w
                bne.s   loc_12766
                lea     (AniSonic01).l,a1
                cmpi.w  #$600,d2
                bhs.s   loc_12724
                lea     (AniSonic00).l,a1
                add.b   d0,d0

loc_12724:
                add.b   d0,d0
                move.b  d0,d3
                moveq   #0,d1
                move.b  anim_frame(a0),d1
                move.b  1(a1,d1.w),d0
                cmpi.b  #-1,d0
                bne.s   loc_12742
                move.b  #0,anim_frame(a0)
                move.b  1(a1),d0

loc_12742:
                move.b  d0,mapping_frame(a0)
                add.b   d3,mapping_frame(a0)
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   locret_12764
                neg.w   d2
                addi.w  #$800,d2
                bpl.s   loc_1275A
                moveq   #0,d2

loc_1275A:
                lsr.w   #8,d2
                move.b  d2,anim_frame_timer(a0)
                addq.b  #1,anim_frame(a0)

locret_12764:
                rts
; ---------------------------------------------------------------------------

loc_12766:
                lea     (AniSuperSonic01).l,a1
                cmpi.w  #$800,d2
                bhs.s   loc_1277E
                lea     (AniSuperSonic00).l,a1
                add.b   d0,d0
                add.b   d0,d0
                bra.s   loc_12780
; ---------------------------------------------------------------------------

loc_1277E:
                add.b   d0,d0

loc_12780:
                move.b  d0,d3
                moveq   #0,d1
                move.b  anim_frame(a0),d1
                move.b  1(a1,d1.w),d0
                cmpi.b  #-1,d0
                bne.s   loc_1279C
                move.b  #0,anim_frame(a0)
                move.b  1(a1),d0

loc_1279C:
                move.b  d0,mapping_frame(a0)
                add.b   d3,mapping_frame(a0)
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   locret_127BE
                neg.w   d2
                addi.w  #$800,d2
                bpl.s   loc_127B4
                moveq   #0,d2

loc_127B4:
                lsr.w   #8,d2
                move.b  d2,anim_frame_timer(a0)
                addq.b  #1,anim_frame(a0)

locret_127BE:
                rts
; ---------------------------------------------------------------------------

; loc_127C0:
Anim_Tumble:
                move.b  flip_type(a0),d1
                andi.w  #$7F,d1
                bne.w   loc_12872
                move.b  flip_angle(a0),d0
                moveq   #0,d1
                move.b  status(a0),d2
                andi.b  #1,d2
                bne.s   Anim_TumbleLeft
                andi.b  #$FC,render_flags(a0)
                tst.b   flip_type(a0)
                bpl.s   loc_12806
                cmpi.b  #$B,(Current_zone).w            ; is this DEZ?
                beq.s   loc_1280A                       ; if so, branch
                cmpi.b  #4,(Current_zone).w             ; is this FBZ?
                beq.s   loc_1280A                       ; if so, branch
                ori.b   #2,render_flags(a0)
                neg.b   d0
                addi.b  #$8F,d0
                bra.s   loc_1280A
; ---------------------------------------------------------------------------

loc_12806:
                addi.b  #$B,d0

loc_1280A:
                divu.w  #$16,d0
                addi.b  #$31,d0
                move.b  d0,mapping_frame(a0)
                move.b  #0,anim_frame_timer(a0)
                rts
; ---------------------------------------------------------------------------

; loc_1281E:
Anim_TumbleLeft:
                andi.b  #$FC,render_flags(a0)
                tst.b   flip_type(a0)
                bpl.s   loc_1284E
                cmpi.b  #4,(Current_zone).w             ; is this FBZ?
                beq.s   loc_12842                       ; if so, branch
                cmpi.b  #$B,(Current_zone).w            ; is this DEZ?
                beq.s   loc_12842                       ; if so, branch
                cmpi.b  #7,(Current_zone).w             ; is this MHZ?
                bne.s   loc_1284E                       ; if not, branch

loc_12842:
                ori.b   #1,render_flags(a0)
                addi.b  #$B,d0
                bra.s   loc_1285A
; ---------------------------------------------------------------------------

loc_1284E:
                ori.b   #3,render_flags(a0)
                neg.b   d0
                addi.b  #$8F,d0

loc_1285A:
                divu.w  #$16,d0
                addi.b  #$31,d0
                move.b  d0,mapping_frame(a0)
                move.b  #0,anim_frame_timer(a0)
                rts
; ---------------------------------------------------------------------------
byte_1286E:
                dc.b    0, $3D, $49, $49
                even
; ---------------------------------------------------------------------------

loc_12872:
                move.b  byte_1286E(pc,d1.w),d3
                cmpi.b  #1,d1
                bne.s   loc_128CA
                move.b  flip_angle(a0),d0
                moveq   #0,d1
                move.b  status(a0),d2
                andi.b  #1,d2
                bne.s   loc_128A8
                andi.b  #$FC,render_flags(a0)
                addi.b  #-8,d0
                divu.w  #$16,d0
                add.b   d3,d0
                move.b  d0,mapping_frame(a0)
                move.b  #0,anim_frame_timer(a0)
                rts
; ---------------------------------------------------------------------------

loc_128A8:
                andi.b  #$FC,render_flags(a0)
                ori.b   #1,render_flags(a0)
                addi.b  #-8,d0
                divu.w  #$16,d0
                add.b   d3,d0
                move.b  d0,mapping_frame(a0)
                move.b  #0,anim_frame_timer(a0)
                rts
; ---------------------------------------------------------------------------

loc_128CA:
                cmpi.b  #2,d1
                bne.s   loc_12920
                move.b  flip_angle(a0),d0
                moveq   #0,d1
                move.b  status(a0),d2
                andi.b  #1,d2
                bne.s   loc_128FC
                andi.b  #$FC,render_flags(a0)
                addi.b  #$B,d0
                divu.w  #$16,d0
                add.b   d3,d0
                move.b  d0,mapping_frame(a0)
                move.b  #0,anim_frame_timer(a0)
                rts
; ---------------------------------------------------------------------------

loc_128FC:
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

loc_12920:
                cmpi.b  #3,d1
                bne.s   loc_1297C
                move.b  flip_angle(a0),d0
                moveq   #0,d1
                move.b  status(a0),d2
                andi.b  #1,d2
                bne.s   loc_1295A
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

loc_1295A:
                andi.b  #$FC,render_flags(a0)
                ori.b   #1,render_flags(a0)
                addi.b  #$B,d0
                divu.w  #$16,d0
                add.b   d3,d0
                move.b  d0,mapping_frame(a0)
                move.b  #0,anim_frame_timer(a0)
                rts
; ---------------------------------------------------------------------------

loc_1297C:
                cmpi.b  #4,d1
                bne.s   loc_129F6
                move.b  flip_angle(a0),d0
                moveq   #0,d1
                move.b  status(a0),d2
                andi.b  #1,d2
                bne.s   loc_129BC
                andi.b  #$FC,render_flags(a0)
                tst.b   flip_type(a0)
                bpl.s   loc_129A4
                addi.b  #$B,d0
                bra.s   loc_129A8
; ---------------------------------------------------------------------------

loc_129A4:
                addi.b  #$B,d0

loc_129A8:
                divu.w  #$16,d0
                addi.b  #$31,d0
                move.b  d0,mapping_frame(a0)
                move.b  #0,anim_frame_timer(a0)
                rts
; ---------------------------------------------------------------------------

loc_129BC:
                andi.b  #$FC,render_flags(a0)
                tst.b   flip_type(a0)
                bpl.s   loc_129D6
                ori.b   #3,render_flags(a0)
                neg.b   d0
                addi.b  #$8F,d0
                bra.s   loc_129E2
; ---------------------------------------------------------------------------

loc_129D6:
                ori.b   #3,render_flags(a0)
                neg.b   d0
                addi.b  #$8F,d0

loc_129E2:
                divu.w  #$16,d0
                addi.b  #$31,d0
                move.b  d0,mapping_frame(a0)
                move.b  #0,anim_frame_timer(a0)
                rts
; ---------------------------------------------------------------------------

loc_129F6:
                move.b  flip_angle(a0),d0
                andi.b  #$FC,render_flags(a0)
                moveq   #0,d1
                move.b  status(a0),d2
                andi.b  #1,d2
                beq.s   loc_12A12
                ori.b   #1,render_flags(a0)

loc_12A12:
                addi.b  #$B,d0
                divu.w  #$16,d0
                addi.b  #$31,d0
                move.b  d0,mapping_frame(a0)
                move.b  #0,anim_frame_timer(a0)
                rts
; ---------------------------------------------------------------------------

loc_12A2A:
                move.b  status(a0),d1
                andi.b  #1,d1
                andi.b  #$FC,render_flags(a0)
                or.b    d1,render_flags(a0)
                subq.b  #1,anim_frame_timer(a0)
                bpl.w   locret_12672
                move.w  ground_vel(a0),d2
                bpl.s   loc_12A4C
                neg.w   d2

loc_12A4C:
                lea     (AniSonic03).l,a1
                cmpi.w  #$600,d2
                bhs.s   loc_12A5E
                lea     (AniSonic02).l,a1

loc_12A5E:
                neg.w   d2
                addi.w  #$400,d2
                bpl.s   loc_12A68
                moveq   #0,d2

loc_12A68:
                lsr.w   #8,d2
                move.b  d2,anim_frame_timer(a0)
                bra.w   loc_1265A
; ---------------------------------------------------------------------------

loc_12A72:
                subq.b  #1,anim_frame_timer(a0)
                bpl.w   locret_12672
                move.w  ground_vel(a0),d2
                bmi.s   loc_12A82
                neg.w   d2

loc_12A82:
                addi.w  #$800,d2
                bpl.s   loc_12A8A
                moveq   #0,d2

loc_12A8A:
                lsr.w   #6,d2
                move.b  d2,anim_frame_timer(a0)
                lea     (AniSonic04).l,a1
                tst.b   (Super_Sonic_Knux_flag).w
                beq.s   loc_12AA2
                lea     (AniSuperSonic04).l,a1

loc_12AA2:
                bra.w   loc_1265A
; End of function Animate_Sonic

; ---------------------------------------------------------------------------
AniSonic:
                include "src/objects/shared/sonic/animations/sonic.s"

; =============== S U B R O U T I N E =======================================

Sonic_Load_PLC:
                moveq   #0,d0
                move.b  mapping_frame(a0),d0

Sonic_Load_PLC2:
                cmp.b   (Player_prev_frame).w,d0
                beq.s   locret_12D20
                move.b  d0,(Player_prev_frame).w
                lea     (PLC_Sonic).l,a2
                tst.b   (Super_Sonic_Knux_flag).w
                beq.s   loc_12CD6
                lea     (PLC_SuperSonic).l,a2

loc_12CD6:
                add.w   d0,d0
                adda.w  (a2,d0.w),a2
                move.w  (a2)+,d5
                subq.w  #1,d5
                bmi.s   locret_12D20
                move.w  #tiles_to_bytes(ArtTile_Player_1),d4
                move.l  #ArtUnc_Sonic,d6
                cmpi.w  #2*$DA,d0
                blo.s   loc_12CF8
                move.l  #ArtUnc_Sonic_Extra,d6

loc_12CF8:
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
                dbf     d5,loc_12CF8

locret_12D20:
                rts
; End of function Sonic_Load_PLC

; =============== S U B R O U T I N E =======================================

Perform_Player_DPLC:
                tst.b   character_id(a1)
                beq.s   Sonic_Load_PLC2
                cmpi.b  #1,character_id(a1)
                beq.w   Tails_Load_PLC2
                bra.w   Knuckles_Load_PLC2
; End of function Perform_Player_DPLC

; =============== S U B R O U T I N E =======================================
