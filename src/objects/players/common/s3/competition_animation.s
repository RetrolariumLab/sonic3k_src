; Owner: objects/players/common/s3
; Responsibility: Shared Sonic and Knuckles competition animation and compact dynamic pattern loading
; Source provenance and ranges: config/reconstruction/source_layout.json
Animate_SonicKnuckles_2P:
                lea     (AniSonic2P).l,a1
                tst.b   character_id(a0)
                beq.s   loc_13A9E
                lea     (AniKnuckles2P).l,a1

loc_13A9E:
                moveq   #0,d0
                move.b  anim(a0),d0
                cmp.b   prev_anim(a0),d0
                beq.s   loc_13AC0
                move.b  d0,prev_anim(a0)
                move.b  #0,anim_frame(a0)
                move.b  #0,anim_frame_timer(a0)
                bclr    #Status_Push,status(a0)

loc_13AC0:
                add.w   d0,d0
                adda.w  (a1,d0.w),a1
                move.b  (a1),d0
                bmi.s   loc_13B30
                move.b  status(a0),d1
                andi.b  #1,d1
                andi.b  #$FC,render_flags(a0)
                or.b    d1,render_flags(a0)
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   locret_13AFE
                move.b  d0,anim_frame_timer(a0)

loc_13AE6:
                moveq   #0,d1
                move.b  anim_frame(a0),d1
                move.b  1(a1,d1.w),d0
                cmpi.b  #$FC,d0
                bhs.s   loc_13B00

loc_13AF6:
                move.b  d0,mapping_frame(a0)
                addq.b  #1,anim_frame(a0)

locret_13AFE:
                rts
; ---------------------------------------------------------------------------

loc_13B00:
                addq.b  #1,d0
                bne.s   loc_13B10
                move.b  #0,anim_frame(a0)
                move.b  1(a1),d0
                bra.s   loc_13AF6
; ---------------------------------------------------------------------------

loc_13B10:
                addq.b  #1,d0
                bne.s   loc_13B24
                move.b  2(a1,d1.w),d0
                sub.b   d0,anim_frame(a0)
                sub.b   d0,d1
                move.b  1(a1,d1.w),d0
                bra.s   loc_13AF6
; ---------------------------------------------------------------------------

loc_13B24:
                addq.b  #1,d0
                bne.s   locret_13B2E
                move.b  2(a1,d1.w),anim(a0)

locret_13B2E:
                rts
; ---------------------------------------------------------------------------

loc_13B30:
                addq.b  #1,d0
                bne.w   loc_13C4A
                moveq   #0,d0
                move.b  flip_angle(a0),d0
                bne.w   loc_13BE4
                moveq   #0,d1
                move.b  angle(a0),d0
                bmi.s   loc_13B4C
                beq.s   loc_13B4C
                subq.b  #1,d0

loc_13B4C:
                move.b  status(a0),d2
                andi.b  #1,d2
                bne.s   loc_13B58
                not.b   d0

loc_13B58:
                addi.b  #$10,d0
                bpl.s   loc_13B60
                moveq   #3,d1

loc_13B60:
                andi.b  #$FC,render_flags(a0)
                eor.b   d1,d2
                or.b    d2,render_flags(a0)
                btst    #Status_Push,status(a0)
                bne.w   loc_13C92
                lsr.b   #5,d0
                andi.b  #3,d0
                move.w  ground_vel(a0),d2
                bpl.s   loc_13B84
                neg.w   d2

loc_13B84:
                tst.b   status_secondary(a0)
                bpl.w   loc_13B8E
                add.w   d2,d2

loc_13B8E:
                move.b  d0,d3
                lea     (AniSonic2P01).l,a1
                cmpi.w  #$600,d2
                bhs.s   loc_13BA4
                lea     (AniSonic2P00).l,a1
                add.b   d0,d0

loc_13BA4:
                add.b   d0,d3
                moveq   #0,d1
                move.b  anim_frame(a0),d1
                move.b  1(a1,d1.w),d0
                cmpi.b  #-1,d0
                bne.s   loc_13BC0
                move.b  #0,anim_frame(a0)
                move.b  1(a1),d0

loc_13BC0:
                move.b  d0,mapping_frame(a0)
                add.b   d3,mapping_frame(a0)
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   locret_13BE2
                neg.w   d2
                addi.w  #$800,d2
                bpl.s   loc_13BD8
                moveq   #0,d2

loc_13BD8:
                lsr.w   #8,d2
                move.b  d2,anim_frame_timer(a0)
                addq.b  #1,anim_frame(a0)

locret_13BE2:
                rts
; ---------------------------------------------------------------------------

loc_13BE4:
                move.b  flip_angle(a0),d0
                moveq   #0,d1
                move.b  status(a0),d2
                andi.b  #1,d2
                bne.s   loc_13C12
                andi.b  #$FC,render_flags(a0)
                addi.b  #$16,d0
                divu.w  #$2C,d0
                addi.b  #$15,d0
                move.b  d0,mapping_frame(a0)
                move.b  #0,anim_frame_timer(a0)
                rts
; ---------------------------------------------------------------------------

loc_13C12:
                andi.b  #$FC,render_flags(a0)
                tst.b   flip_type(a0)
                bpl.s   loc_13C2A
                ori.b   #1,render_flags(a0)
                addi.b  #$16,d0
                bra.s   loc_13C36
; ---------------------------------------------------------------------------

loc_13C2A:
                ori.b   #3,render_flags(a0)
                neg.b   d0
                addi.b  #$9A,d0

loc_13C36:
                divu.w  #$2C,d0
                addi.b  #$15,d0
                move.b  d0,mapping_frame(a0)
                move.b  #0,anim_frame_timer(a0)
                rts
; ---------------------------------------------------------------------------

loc_13C4A:
                subq.b  #1,anim_frame_timer(a0)
                bpl.w   locret_13AFE
                move.w  ground_vel(a0),d2
                bpl.s   loc_13C5A
                neg.w   d2

loc_13C5A:
                lea     (AniSonic2P03).l,a1
                cmpi.w  #$600,d2
                bhs.s   loc_13C6C
                lea     (AniSonic2P02).l,a1

loc_13C6C:
                neg.w   d2
                addi.w  #$400,d2
                bpl.s   loc_13C76
                moveq   #0,d2

loc_13C76:
                lsr.w   #8,d2
                move.b  d2,anim_frame_timer(a0)
                move.b  status(a0),d1
                andi.b  #1,d1
                andi.b  #$FC,render_flags(a0)
                or.b    d1,render_flags(a0)
                bra.w   loc_13AE6
; ---------------------------------------------------------------------------

loc_13C92:
                subq.b  #1,anim_frame_timer(a0)
                bpl.w   locret_13AFE
                move.w  ground_vel(a0),d2
                bmi.s   loc_13CA2
                neg.w   d2

loc_13CA2:
                addi.w  #$800,d2
                bpl.s   loc_13CAA
                moveq   #0,d2

loc_13CAA:
                lsr.w   #6,d2
                lea     (AniSonic2P04).l,a1
                tst.b   character_id(a0)
                beq.s   loc_13CC0
                lea     (AniKnuckles2P04).l,a1
                lsr.w   #2,d2

loc_13CC0:
                move.b  d2,anim_frame_timer(a0)
                move.b  status(a0),d1
                andi.b  #1,d1
                andi.b  #$FC,render_flags(a0)
                or.b    d1,render_flags(a0)
                bra.w   loc_13AE6
; End of function Animate_SonicKnuckles_2P

; ---------------------------------------------------------------------------
AniSonic2P:
                include "src/objects/shared/sonic/animations/knuckles_2p.s"

; =============== S U B R O U T I N E =======================================

SonicKnuckles2P_Load_PLC:
                moveq   #0,d0
                move.b  mapping_frame(a0),d0
                lea     (PLC_Sonic2P).l,a2
                move.l  #ArtUnc_Sonic2P,d6
                tst.b   character_id(a0)
                beq.s   loc_13E14
                lea     (PLC_Knuckles2P).l,a2
                move.l  #ArtUnc_Knuckles2P,d6

loc_13E14:
                add.w   d0,d0
                adda.w  (a2,d0.w),a2
                move.w  (a2)+,d5
                subq.w  #1,d5
                bmi.s   locret_13E56
                move.w  #tiles_to_bytes(ArtTile_Player_1),d4
                cmpa.w  #Player_1,a0
                beq.s   loc_13E2E
                move.w  #tiles_to_bytes(ArtTile_Player_2),d4

loc_13E2E:
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
                dbf     d5,loc_13E2E

locret_13E56:
                rts
; End of function SonicKnuckles2P_Load_PLC

; ---------------------------------------------------------------------------
