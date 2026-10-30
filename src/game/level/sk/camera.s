; Owner: game/level/sk
; Responsibility: Background deformation, horizontal and vertical camera tracking and two-player camera updates
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

DeformBgLayer:
                tst.b   (Deform_lock).w
                beq.s   loc_1BFB8
                rts
; ---------------------------------------------------------------------------

loc_1BFB8:
                clr.w   (Camera_RAM).w
                clr.w   (V_scroll_amount).w
                clr.w   (H_scroll_amount_P2).w
                clr.w   (V_scroll_amount_P2).w
                tst.w   (Competition_mode).w
                bne.w   loc_1C02C
                tst.b   (Scroll_lock).w
                bne.s   loc_1C028
                lea     (Player_1).w,a0
                tst.b   (Scroll_force_positions).w
                beq.s   loc_1BFF0
                move.b  #0,(Scroll_force_positions).w
                move.w  #0,(H_scroll_frame_offset).w
                lea     (Scroll_forced_X_pos-x_pos).w,a0  ; is now a player address

loc_1BFF0:
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
                bne.s   loc_1C024
                move.w  (Distance_from_top_P2).w,d3

loc_1C024:
                bsr.w   MoveCameraY

loc_1C028:
                bra.w   Do_ResizeEvents
; ---------------------------------------------------------------------------

loc_1C02C:
                tst.b   (Scroll_lock).w
                bne.s   loc_1C06E
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
                bne.s   loc_1C06A
                move.w  (Distance_from_top_P2).w,d3

loc_1C06A:
                bsr.w   MoveCameraY

loc_1C06E:
                tst.b   (Scroll_lock_P2).w
                bne.s   loc_1C0A4
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

loc_1C0A4:
                bra.w   Do_ResizeEvents
; End of function DeformBgLayer

; =============== S U B R O U T I N E =======================================

MoveCameraX:
                move.w  (a1),d4
                tst.b   (Teleport_active_flag).w
                bne.s   locret_1C0E6
                move.w  (a5),d1
                beq.s   loc_1C0D2
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
                bra.s   loc_1C0D6
; ---------------------------------------------------------------------------

loc_1C0D2:
                move.w  x_pos(a0),d0

loc_1C0D6:
                sub.w   (a1),d0
                subi.w  #$90,d0
                blt.s   loc_1C0E8
                subi.w  #$10,d0
                bge.s   loc_1C0FC
                clr.w   (a4)

locret_1C0E6:
                rts
; ---------------------------------------------------------------------------

loc_1C0E8:
                cmpi.w  #-$18,d0
                bgt.s   loc_1C0F2
                move.w  #-$18,d0

loc_1C0F2:
                add.w   (a1),d0
                cmp.w   (a2),d0
                bgt.s   loc_1C112
                move.w  (a2),d0
                bra.s   loc_1C112
; ---------------------------------------------------------------------------

loc_1C0FC:
                cmpi.w  #$18,d0
                blo.s   loc_1C106
                move.w  #$18,d0

loc_1C106:
                add.w   (a1),d0
                cmp.w   2(a2),d0
                blt.s   loc_1C112
                move.w  2(a2),d0

loc_1C112:
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
                bne.s   loc_1C132
                and.w   (Screen_Y_wrap_value).w,d0

loc_1C132:
                btst    #Status_Roll,status(a0)
                beq.s   loc_1C13C
                subq.w  #5,d0

loc_1C13C:
                move.w  d3,d1
                tst.w   (Competition_mode).w
                beq.s   loc_1C146
                lsr.w   #1,d1

loc_1C146:
                btst    #Status_InAir,status(a0)
                beq.s   loc_1C164
                addi.w  #$20,d0
                sub.w   d1,d0
                bcs.s   loc_1C1B0
                subi.w  #$40,d0
                bcc.s   loc_1C1B0
                tst.b   (Camera_max_Y_pos_changing).w
                bne.s   loc_1C1C2
                bra.s   loc_1C16E
; ---------------------------------------------------------------------------

loc_1C164:
                sub.w   d1,d0
                bne.s   loc_1C172
                tst.b   (Camera_max_Y_pos_changing).w
                bne.s   loc_1C1C2

loc_1C16E:
                clr.w   (a4)
                rts
; ---------------------------------------------------------------------------

loc_1C172:
                cmpi.w  #$60,d3
                bne.s   loc_1C19E
                tst.b   (Fast_V_scroll_flag).w
                bne.s   loc_1C1B0
                move.w  ground_vel(a0),d1
                bpl.s   loc_1C186
                neg.w   d1

loc_1C186:
                cmpi.w  #$800,d1
                bhs.s   loc_1C1B0
                move.w  #$600,d1
                cmpi.w  #6,d0
                bgt.s   loc_1C1FA
                cmpi.w  #-6,d0
                blt.s   loc_1C1D8
                bra.s   loc_1C1C8
; ---------------------------------------------------------------------------

loc_1C19E:
                move.w  #$200,d1
                cmpi.w  #2,d0
                bgt.s   loc_1C1FA
                cmpi.w  #-2,d0
                blt.s   loc_1C1D8
                bra.s   loc_1C1C8
; ---------------------------------------------------------------------------

loc_1C1B0:
                move.w  #$1800,d1
                cmpi.w  #$18,d0
                bgt.s   loc_1C1FA
                cmpi.w  #-$18,d0
                blt.s   loc_1C1D8
                bra.s   loc_1C1C8
; ---------------------------------------------------------------------------

loc_1C1C2:
                moveq   #0,d0
                move.b  d0,(Camera_max_Y_pos_changing).w

loc_1C1C8:
                moveq   #0,d1
                move.w  d0,d1
                add.w   (a1),d1
                tst.w   d0
                bpl.w   loc_1C202
                bra.w   loc_1C1E2
; ---------------------------------------------------------------------------

loc_1C1D8:
                neg.w   d1
                ext.l   d1
                asl.l   #8,d1
                add.l   (a1),d1
                swap    d1

loc_1C1E2:
                cmp.w   4(a2),d1
                bgt.s   loc_1C21A
                cmpi.w  #-$100,d1
                bgt.s   loc_1C1F4
                and.w   (Screen_Y_wrap_value).w,d1
                bra.s   loc_1C21A
; ---------------------------------------------------------------------------

loc_1C1F4:
                move.w  4(a2),d1
                bra.s   loc_1C21A
; ---------------------------------------------------------------------------

loc_1C1FA:
                ext.l   d1
                asl.l   #8,d1
                add.l   (a1),d1
                swap    d1

loc_1C202:
                cmp.w   6(a2),d1
                blt.s   loc_1C21A
                move.w  (Screen_Y_wrap_value).w,d3
                addq.w  #1,d3
                sub.w   d3,d1
                bcs.s   loc_1C216
                sub.w   d3,(a1)
                bra.s   loc_1C21A
; ---------------------------------------------------------------------------

loc_1C216:
                move.w  6(a2),d1

loc_1C21A:
                move.w  (a1),d4
                swap    d1
                move.l  d1,d3
                sub.l   (a1),d3
                ror.l   #8,d3
                move.w  d3,(a4)
                move.l  d1,(a1)
                tst.w   (Competition_mode).w
                beq.s   locret_1C236
                swap    d1
                and.w   (Screen_Y_wrap_value).w,d1
                move.w  d1,(a1)

locret_1C236:
                rts
; End of function MoveCameraY

; =============== S U B R O U T I N E =======================================

MoveCameraX_2P:
                move.w  (a1),d4
                tst.b   (Teleport_active_flag).w
                bne.s   locret_1C27C
                move.w  (a5),d1
                beq.s   loc_1C262
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
                bra.s   loc_1C266
; ---------------------------------------------------------------------------

loc_1C262:
                move.w  x_pos(a0),d0

loc_1C266:
                move.w  (Screen_X_wrap_value).w,d2
                sub.w   (a1),d0
                and.w   d2,d0
                subi.w  #$90,d0
                blt.s   loc_1C27E
                subi.w  #$10,d0
                bge.s   loc_1C28C
                clr.w   (a4)

locret_1C27C:
                rts
; ---------------------------------------------------------------------------

loc_1C27E:
                cmpi.w  #-$10,d0
                bgt.s   loc_1C288
                move.w  #-$10,d0

loc_1C288:
                add.w   (a1),d0
                bra.s   loc_1C298
; ---------------------------------------------------------------------------

loc_1C28C:
                cmpi.w  #$10,d0
                blo.s   loc_1C296
                move.w  #$10,d0

loc_1C296:
                add.w   (a1),d0

loc_1C298:
                move.w  d0,d1
                sub.w   (a1),d1
                asl.w   #8,d1
                and.w   d2,d0
                addi.w  #$400,d0
                move.w  d0,(a1)
                move.w  d1,(a4)
                rts
; End of function MoveCameraX_2P
