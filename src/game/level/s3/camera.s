; Owner: game/level/s3
; Responsibility: Background deformation, horizontal and vertical camera tracking and two-player camera updates
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

DeformBgLayer:
                tst.b   (Deform_lock).w
                beq.s   loc_1A480
                rts
; ---------------------------------------------------------------------------

loc_1A480:
                clr.w   (Camera_RAM).w
                clr.w   (V_scroll_amount).w
                clr.w   (H_scroll_amount_P2).w
                clr.w   (V_scroll_amount_P2).w
                tst.w   (Competition_mode).w
                bne.w   loc_1A4DE
                tst.b   (Scroll_lock).w
                bne.s   loc_1A4DA
                lea     (Player_1).w,a0
                lea     (Camera_X_pos).w,a1
                lea     (Camera_min_X_pos).w,a2
                lea     (Camera_RAM).w,a4
                lea     (H_scroll_frame_offset).w,a5
                lea     (Pos_table).w,a6
                bsr.w   MoveCameraX
                lea     (Camera_Y_pos).w,a1
                lea     (Camera_min_X_pos).w,a2
                lea     (V_scroll_amount).w,a4
                move.w  (Distance_from_top).w,d3
                cmpi.w  #2,(Player_mode).w
                bne.s   loc_1A4D6
                move.w  (Distance_from_top_P2).w,d3

loc_1A4D6:
                bsr.w   MoveCameraY

loc_1A4DA:
                bra.w   Do_ResizeEvents
; ---------------------------------------------------------------------------

loc_1A4DE:
                tst.b   (Scroll_lock).w
                bne.s   loc_1A520
                lea     (Player_1).w,a0
                lea     (Camera_X_pos).w,a1
                lea     (Camera_min_X_pos).w,a2
                lea     (Camera_RAM).w,a4
                lea     (H_scroll_frame_offset).w,a5
                lea     (Pos_table).w,a6
                bsr.w   MoveCameraX_2P
                lea     (Camera_Y_pos).w,a1
                lea     (Camera_min_X_pos).w,a2
                lea     (V_scroll_amount).w,a4
                move.w  (Distance_from_top).w,d3
                cmpi.w  #2,(Player_mode).w
                bne.s   loc_1A51C
                move.w  (Distance_from_top_P2).w,d3

loc_1A51C:
                bsr.w   MoveCameraY

loc_1A520:
                tst.b   (Scroll_lock_P2).w
                bne.s   loc_1A556
                lea     (Player_2).w,a0
                lea     (Camera_X_pos_P2).w,a1
                lea     (Camera_min_X_pos_P2).w,a2
                lea     (H_scroll_amount_P2).w,a4
                lea     (H_scroll_frame_offset_P2).w,a5
                lea     (Stat_table).w,a6
                bsr.w   MoveCameraX_2P
                lea     (Camera_Y_pos_P2).w,a1
                lea     (Camera_min_X_pos_P2).w,a2
                lea     (V_scroll_amount_P2).w,a4
                move.w  (Distance_from_top_P2).w,d3
                bsr.w   MoveCameraY

loc_1A556:
                bra.w   Do_ResizeEvents
; End of function DeformBgLayer

; =============== S U B R O U T I N E =======================================

MoveCameraX:
                move.w  (a1),d4
                tst.b   (Teleport_active_flag).w
                bne.s   locret_1A598
                move.w  (a5),d1
                beq.s   loc_1A584
                subi.w  #$100,d1
                move.w  d1,(a5)
                moveq   #0,d1
                move.b  (a5),d1
                lsl.b   #2,d1
                addq.b  #4,d1
                move.w  2(a5),d0
                sub.b   d1,d0
                move.w  (a6,d0.w),d0
                andi.w  #$7FFF,d0
                bra.s   loc_1A588
; ---------------------------------------------------------------------------

loc_1A584:
                move.w  x_pos(a0),d0

loc_1A588:
                sub.w   (a1),d0
                subi.w  #$90,d0
                blt.s   loc_1A59A
                subi.w  #$10,d0
                bge.s   loc_1A5AE
                clr.w   (a4)

locret_1A598:
                rts
; ---------------------------------------------------------------------------

loc_1A59A:
                cmpi.w  #-$18,d0
                bgt.s   loc_1A5A4
                move.w  #-$18,d0

loc_1A5A4:
                add.w   (a1),d0
                cmp.w   (a2),d0
                bgt.s   loc_1A5C4
                move.w  (a2),d0
                bra.s   loc_1A5C4
; ---------------------------------------------------------------------------

loc_1A5AE:
                cmpi.w  #$18,d0
                blo.s   loc_1A5B8
                move.w  #$18,d0

loc_1A5B8:
                add.w   (a1),d0
                cmp.w   2(a2),d0
                blt.s   loc_1A5C4
                move.w  2(a2),d0

loc_1A5C4:
                move.w  d0,d1
                sub.w   (a1),d1
                asl.w   #8,d1
                move.w  d0,(a1)
                move.w  d1,(a4)
                rts
; End of function MoveCameraX

; =============== S U B R O U T I N E =======================================

MoveCameraY:
                moveq   #0,d1
                move.w  y_pos(a0),d0
                sub.w   (a1),d0
                cmpi.w  #-$100,(Camera_min_Y_pos).w
                bne.s   loc_1A5E4
                and.w   (Screen_Y_wrap_value).w,d0

loc_1A5E4:
                btst    #Status_Roll,status(a0)
                beq.s   loc_1A5EE
                subq.w  #5,d0

loc_1A5EE:
                move.w  d3,d1
                tst.w   (Competition_mode).w
                beq.s   loc_1A5F8
                lsr.w   #1,d1

loc_1A5F8:
                btst    #Status_InAir,status(a0)
                beq.s   loc_1A616
                addi.w  #$20,d0
                sub.w   d1,d0
                bcs.s   loc_1A662
                subi.w  #$40,d0
                bcc.s   loc_1A662
                tst.b   (Camera_max_Y_pos_changing).w
                bne.s   loc_1A674
                bra.s   loc_1A620
; ---------------------------------------------------------------------------

loc_1A616:
                sub.w   d1,d0
                bne.s   loc_1A624
                tst.b   (Camera_max_Y_pos_changing).w
                bne.s   loc_1A674

loc_1A620:
                clr.w   (a4)
                rts
; ---------------------------------------------------------------------------

loc_1A624:
                cmpi.w  #$60,d3
                bne.s   loc_1A650
                tst.b   (Fast_V_scroll_flag).w
                bne.s   loc_1A662
                move.w  ground_vel(a0),d1
                bpl.s   loc_1A638
                neg.w   d1

loc_1A638:
                cmpi.w  #$800,d1
                bhs.s   loc_1A662
                move.w  #$600,d1
                cmpi.w  #6,d0
                bgt.s   loc_1A6AC
                cmpi.w  #-6,d0
                blt.s   loc_1A68A
                bra.s   loc_1A67A
; ---------------------------------------------------------------------------

loc_1A650:
                move.w  #$200,d1
                cmpi.w  #2,d0
                bgt.s   loc_1A6AC
                cmpi.w  #-2,d0
                blt.s   loc_1A68A
                bra.s   loc_1A67A
; ---------------------------------------------------------------------------

loc_1A662:
                move.w  #$1800,d1
                cmpi.w  #$18,d0
                bgt.s   loc_1A6AC
                cmpi.w  #-$18,d0
                blt.s   loc_1A68A
                bra.s   loc_1A67A
; ---------------------------------------------------------------------------

loc_1A674:
                moveq   #0,d0
                move.b  d0,(Camera_max_Y_pos_changing).w

loc_1A67A:
                moveq   #0,d1
                move.w  d0,d1
                add.w   (a1),d1
                tst.w   d0
                bpl.w   loc_1A6B4
                bra.w   loc_1A694
; ---------------------------------------------------------------------------

loc_1A68A:
                neg.w   d1
                ext.l   d1
                asl.l   #8,d1
                add.l   (a1),d1
                swap    d1

loc_1A694:
                cmp.w   4(a2),d1
                bgt.s   loc_1A6CC
                cmpi.w  #-$100,d1
                bgt.s   loc_1A6A6
                and.w   (Screen_Y_wrap_value).w,d1
                bra.s   loc_1A6CC
; ---------------------------------------------------------------------------

loc_1A6A6:
                move.w  4(a2),d1
                bra.s   loc_1A6CC
; ---------------------------------------------------------------------------

loc_1A6AC:
                ext.l   d1
                asl.l   #8,d1
                add.l   (a1),d1
                swap    d1

loc_1A6B4:
                cmp.w   6(a2),d1
                blt.s   loc_1A6CC
                move.w  (Screen_Y_wrap_value).w,d3
                addq.w  #1,d3
                sub.w   d3,d1
                bcs.s   loc_1A6C8
                sub.w   d3,(a1)
                bra.s   loc_1A6CC
; ---------------------------------------------------------------------------

loc_1A6C8:
                move.w  6(a2),d1

loc_1A6CC:
                move.w  (a1),d4
                swap    d1
                move.l  d1,d3
                sub.l   (a1),d3
                ror.l   #8,d3
                move.w  d3,(a4)
                move.l  d1,(a1)
                tst.w   (Competition_mode).w
                beq.s   locret_1A6E8
                swap    d1
                and.w   (Screen_Y_wrap_value).w,d1
                move.w  d1,(a1)

locret_1A6E8:
                rts
; End of function MoveCameraY

; =============== S U B R O U T I N E =======================================

MoveCameraX_2P:
                move.w  (a1),d4
                tst.b   (Teleport_active_flag).w
                bne.s   locret_1A72E
                move.w  (a5),d1
                beq.s   loc_1A714
                subi.w  #$100,d1
                move.w  d1,(a5)
                moveq   #0,d1
                move.b  (a5),d1
                lsl.b   #2,d1
                addq.b  #4,d1
                move.w  2(a5),d0
                sub.b   d1,d0
                move.w  (a6,d0.w),d0
                andi.w  #$7FFF,d0
                bra.s   loc_1A718
; ---------------------------------------------------------------------------

loc_1A714:
                move.w  x_pos(a0),d0

loc_1A718:
                move.w  (Screen_X_wrap_value).w,d2
                sub.w   (a1),d0
                and.w   d2,d0
                subi.w  #$90,d0
                blt.s   loc_1A730
                subi.w  #$10,d0
                bge.s   loc_1A73E
                clr.w   (a4)

locret_1A72E:
                rts
; ---------------------------------------------------------------------------

loc_1A730:
                cmpi.w  #-$10,d0
                bgt.s   loc_1A73A
                move.w  #-$10,d0

loc_1A73A:
                add.w   (a1),d0
                bra.s   loc_1A74A
; ---------------------------------------------------------------------------

loc_1A73E:
                cmpi.w  #$10,d0
                blo.s   loc_1A748
                move.w  #$10,d0

loc_1A748:
                add.w   (a1),d0

loc_1A74A:
                move.w  d0,d1
                sub.w   (a1),d1
                asl.w   #8,d1
                and.w   d2,d0
                addi.w  #$400,d0
                move.w  d0,(a1)
                move.w  d1,(a4)
                rts
; End of function MoveCameraX_2P
