; Owner: objects/players/knuckles/sk
; Responsibility: Knuckles animation selection and dynamic pattern loading
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Animate_Knuckles:
                lea     (AniKnuckles).l,a1
                moveq   #0,d0
                move.b  anim(a0),d0
                cmp.b   prev_anim(a0),d0
                beq.s   loc_17D58
                move.b  d0,prev_anim(a0)
                move.b  #0,anim_frame(a0)
                move.b  #0,anim_frame_timer(a0)
                bclr    #Status_Push,status(a0)

loc_17D58:
                add.w   d0,d0
                adda.w  (a1,d0.w),a1
                move.b  (a1),d0
                bmi.s   loc_17DC8
                move.b  status(a0),d1
                andi.b  #1,d1
                andi.b  #$FC,render_flags(a0)
                or.b    d1,render_flags(a0)
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   locret_17D96
                move.b  d0,anim_frame_timer(a0)

loc_17D7E:
                moveq   #0,d1
                move.b  anim_frame(a0),d1
                move.b  1(a1,d1.w),d0
                cmpi.b  #$FC,d0
                bhs.s   loc_17D98

loc_17D8E:
                move.b  d0,mapping_frame(a0)
                addq.b  #1,anim_frame(a0)

locret_17D96:
                rts
; ---------------------------------------------------------------------------

loc_17D98:
                addq.b  #1,d0
                bne.s   loc_17DA8
                move.b  #0,anim_frame(a0)
                move.b  1(a1),d0
                bra.s   loc_17D8E
; ---------------------------------------------------------------------------

loc_17DA8:
                addq.b  #1,d0
                bne.s   loc_17DBC
                move.b  2(a1,d1.w),d0
                sub.b   d0,anim_frame(a0)
                sub.b   d0,d1
                move.b  1(a1,d1.w),d0
                bra.s   loc_17D8E
; ---------------------------------------------------------------------------

loc_17DBC:
                addq.b  #1,d0
                bne.s   locret_17DC6
                move.b  2(a1,d1.w),anim(a0)

locret_17DC6:
                rts
; ---------------------------------------------------------------------------

loc_17DC8:
                addq.b  #1,d0
                bne.w   loc_17E84
                moveq   #0,d0
                tst.b   flip_type(a0)
                bmi.w   Anim_Tumble
                move.b  flip_angle(a0),d0
                bne.w   Anim_Tumble
                moveq   #0,d1
                move.b  angle(a0),d0
                bmi.s   loc_17DEC
                beq.s   loc_17DEC
                subq.b  #1,d0

loc_17DEC:
                move.b  status(a0),d2
                andi.b  #1,d2
                bne.s   loc_17DF8
                not.b   d0

loc_17DF8:
                addi.b  #$10,d0
                bpl.s   loc_17E00
                moveq   #3,d1

loc_17E00:
                andi.b  #$FC,render_flags(a0)
                eor.b   d1,d2
                or.b    d2,render_flags(a0)
                btst    #Status_Push,status(a0)
                bne.w   loc_17ECC
                lsr.b   #4,d0
                andi.b  #6,d0
                move.w  ground_vel(a0),d2
                bpl.s   loc_17E24
                neg.w   d2

loc_17E24:
                tst.b   status_secondary(a0)
                bpl.w   loc_17E2E
                add.w   d2,d2

loc_17E2E:
                lea     (AniKnuckles01).l,a1
                cmpi.w  #$600,d2
                bhs.s   loc_17E42
                lea     (AniKnuckles00).l,a1
                add.b   d0,d0

loc_17E42:
                add.b   d0,d0
                move.b  d0,d3
                moveq   #0,d1
                move.b  anim_frame(a0),d1
                move.b  1(a1,d1.w),d0
                cmpi.b  #-1,d0
                bne.s   loc_17E60
                move.b  #0,anim_frame(a0)
                move.b  1(a1),d0

loc_17E60:
                move.b  d0,mapping_frame(a0)
                add.b   d3,mapping_frame(a0)
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   locret_17E82
                neg.w   d2
                addi.w  #$800,d2
                bpl.s   loc_17E78
                moveq   #0,d2

loc_17E78:
                lsr.w   #8,d2
                move.b  d2,anim_frame_timer(a0)
                addq.b  #1,anim_frame(a0)

locret_17E82:
                rts
; ---------------------------------------------------------------------------

loc_17E84:
                move.b  status(a0),d1
                andi.b  #1,d1
                andi.b  #$FC,render_flags(a0)
                or.b    d1,render_flags(a0)
                subq.b  #1,anim_frame_timer(a0)
                bpl.w   locret_17D96
                move.w  ground_vel(a0),d2
                bpl.s   loc_17EA6
                neg.w   d2

loc_17EA6:
                lea     (AniKnuckles03).l,a1
                cmpi.w  #$600,d2
                bhs.s   loc_17EB8
                lea     (AniKnuckles02).l,a1

loc_17EB8:
                neg.w   d2
                addi.w  #$400,d2
                bpl.s   loc_17EC2
                moveq   #0,d2

loc_17EC2:
                lsr.w   #8,d2
                move.b  d2,anim_frame_timer(a0)
                bra.w   loc_17D7E
; ---------------------------------------------------------------------------

loc_17ECC:
                subq.b  #1,anim_frame_timer(a0)
                bpl.w   locret_17D96
                move.w  ground_vel(a0),d2
                bmi.s   loc_17EDC
                neg.w   d2

loc_17EDC:
                addi.w  #$800,d2
                bpl.s   loc_17EE4
                moveq   #0,d2

loc_17EE4:
                lsr.w   #8,d2
                move.b  d2,anim_frame_timer(a0)
                lea     (AniKnuckles04).l,a1
                bra.w   loc_17D7E
; End of function Animate_Knuckles

; ---------------------------------------------------------------------------
AniKnuckles:
                include "src/objects/shared/knuckles/animations/knuckles.s"

; =============== S U B R O U T I N E =======================================

Knuckles_Load_PLC:
                moveq   #0,d0
                move.b  mapping_frame(a0),d0

Knuckles_Load_PLC2:
                cmp.b   (Player_prev_frame).w,d0
                beq.s   locret_18162
                move.b  d0,(Player_prev_frame).w
                move.w  #tiles_to_bytes(ArtTile_Player_1),d4

loc_18122:
                lea     (PLC_Knuckles).l,a2
                add.w   d0,d0
                adda.w  (a2,d0.w),a2
                move.w  (a2)+,d5
                subq.w  #1,d5
                bmi.s   locret_18162
                move.l  #ArtUnc_Knux,d6

loc_1813A:
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
                dbf     d5,loc_1813A

locret_18162:
                rts
; End of function Knuckles_Load_PLC
