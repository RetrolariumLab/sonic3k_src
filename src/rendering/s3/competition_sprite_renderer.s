; Owner: rendering/s3
; Responsibility: Competition sprite display and its private piece-coordinate lookup tables
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

Render_Sprites_CompetitionMode:
                moveq   #(80-2)-1,d7                    ; Number of sprites to render
                moveq   #0,d6
                lea     (Sprite_table_input).w,a5
                lea     (Camera_X_pos_copy).w,a3
; Unlike in Sonic 2, the sprite tables are page-flipped in two-player mode
; This fixes a race-condition where incomplete sprite tables can be uploaded
; to the VDP on lag frames, causing corrupted sprites to appear

; Modify the back buffer
                lea     (Sprite_table+$10).w,a6
                tst.w   (Current_sprite_table_page).w
                beq.s   loc_19872
                lea     (Sprite_table_alternate+$10).l,a6

loc_19872:
                tst.b   (Level_started_flag).w
                beq.s   loc_1987E
                jsr     (Render_HUD_P1).l

loc_1987E:
                move.b  1(a5),(a5)
                beq.w   loc_1992A
                lea     2(a5),a4

loc_1988A:
                movea.w (a4)+,a0
                andi.b  #$7F,render_flags(a0)
                move.b  render_flags(a0),d6
                btst    #4,d6
                bne.w   loc_19924
                move.w  x_pos(a0),d0
                move.w  y_pos(a0),d1
                btst    #6,d6
                bne.w   loc_19A4E
                btst    #2,d6
                beq.s   loc_198F6
                moveq   #0,d2
                sub.w   (a3),d0
                move.b  width_pixels(a0),d2
                add.w   d2,d0
                and.w   (Screen_X_wrap_value).w,d0
                move.w  d2,d3
                add.w   d2,d2
                addi.w  #320,d2
                cmp.w   d2,d0
                bhs.s   loc_19924
                addi.w  #128,d0
                sub.w   d3,d0
                moveq   #0,d2
                sub.w   4(a3),d1
                move.b  height_pixels(a0),d2
                add.w   d2,d1
                and.w   (Screen_Y_wrap_value).w,d1
                move.w  d2,d3
                add.w   d2,d2
                addi.w  #224/2,d2
                cmp.w   d2,d1
                bhs.s   loc_19924
                addi.w  #128,d1
                sub.w   d3,d1

loc_198F6:
                ori.b   #$80,render_flags(a0)
                tst.w   d7
                bmi.s   loc_19924
                movea.l mappings(a0),a1
                moveq   #0,d4
                btst    #5,d6
                bne.s   loc_1991C
                move.b  mapping_frame(a0),d4
                add.w   d4,d4
                adda.w  (a1,d4.w),a1
                move.w  (a1)+,d4
                subq.w  #1,d4
                bmi.s   loc_19924

loc_1991C:
                move.w  art_tile(a0),d5
                jsr     sub_195CE(pc)

loc_19924:
                subq.b  #2,(a5)
                bne.w   loc_1988A

loc_1992A:
                lea     $80(a5),a5
                cmpa.l  #Sprite_table_input_end,a5
                blo.w   loc_1987E
                tst.w   d7
                bmi.s   loc_19946
                moveq   #0,d0

loc_1993E:
                move.w  d0,(a6)
                addq.w  #8,a6
                dbf     d7,loc_1993E

loc_19946:
                move.l  (Sprite_table_input+2+($80*2)).w,d0
                cmpi.l  #((Player_1&$FFFF)<<16)|(Player_2&$FFFF),d0
                bne.s   loc_19958
                swap    d0
                move.l  d0,(Sprite_table_input+2+($80*2)).w

loc_19958:
                moveq   #80-1,d7                        ; Number of sprites to render
                lea     (Sprite_table_input).w,a5
                lea     (Camera_X_pos_P2_copy).w,a3
; Unlike in Sonic 2, the sprite tables are page-flipped in two-player mode
; This fixes a race-condition where incomplete sprite tables can be uploaded
; to the VDP on lag frames, causing corrupted sprites to appear

; Modify the back buffer
                lea     (Sprite_table_P2).l,a6
                tst.w   (Current_sprite_table_page).w
                beq.s   loc_19974
                lea     (Sprite_table_P2_alternate).l,a6

loc_19974:
                tst.b   (Level_started_flag).w
                beq.s   loc_19980
                jsr     (Render_HUD_P2).l

loc_19980:
                tst.b   1(a5)
                beq.w   loc_19A2C
                lea     2(a5),a4

loc_1998C:
                movea.w (a4)+,a0
                move.b  render_flags(a0),d6
                btst    #3,d6
                bne.w   loc_19A24
                move.w  x_pos(a0),d0
                move.w  y_pos(a0),d1
                btst    #6,d6
                bne.w   loc_19B1A
                btst    #2,d6
                beq.s   loc_199F2
                moveq   #0,d2
                sub.w   (a3),d0
                move.b  width_pixels(a0),d2
                add.w   d2,d0
                and.w   (Screen_X_wrap_value).w,d0
                move.w  d2,d3
                add.w   d2,d2
                addi.w  #320,d2
                cmp.w   d2,d0
                bhs.s   loc_19A24
                addi.w  #128,d0
                sub.w   d3,d0
                moveq   #0,d2
                sub.w   4(a3),d1
                move.b  height_pixels(a0),d2
                add.w   d2,d1
                and.w   (Screen_Y_wrap_value).w,d1
                move.w  d2,d3
                add.w   d2,d2
                addi.w  #224/2,d2
                cmp.w   d2,d1
                bhs.s   loc_19A24
                addi.w  #128,d1
                sub.w   d3,d1

loc_199F2:
                addi.w  #224/2,d1
                ori.b   #$80,render_flags(a0)
                tst.w   d7
                bmi.s   loc_19A24
                movea.l mappings(a0),a1
                moveq   #0,d4
                btst    #5,d6
                bne.s   loc_19A1C
                move.b  mapping_frame(a0),d4
                add.w   d4,d4
                adda.w  (a1,d4.w),a1
                move.w  (a1)+,d4
                subq.w  #1,d4
                bmi.s   loc_19A24

loc_19A1C:
                move.w  art_tile(a0),d5
                jsr     sub_195CE(pc)

loc_19A24:
                subq.b  #2,1(a5)
                bne.w   loc_1998C

loc_19A2C:
                lea     $80(a5),a5
                cmpa.l  #Sprite_table_input_end,a5
                blo.w   loc_19980
                tst.w   d7
                bmi.s   loc_19A48
                moveq   #0,d0

loc_19A40:
                move.w  d0,(a6)
                addq.w  #8,a6
                dbf     d7,loc_19A40

loc_19A48:
; The new sprite tables are complete: signal a page flip to
; allow them to be uploaded to the VDP!
                st.b    (Sprite_table_page_flip_pending).w
                rts
; ---------------------------------------------------------------------------

loc_19A4E:
                moveq   #0,d2
                sub.w   (a3),d0
                move.b  width_pixels(a0),d2
                add.w   d2,d0
                and.w   (Screen_X_wrap_value).w,d0
                move.w  d2,d3
                add.w   d2,d2
                addi.w  #320,d2
                cmp.w   d2,d0
                bhs.w   loc_19924
                addi.w  #128,d0
                sub.w   d3,d0
                moveq   #0,d2
                sub.w   4(a3),d1
                move.b  height_pixels(a0),d2
                add.w   d2,d1
                and.w   (Screen_Y_wrap_value).w,d1
                move.w  d2,d3
                add.w   d2,d2
                addi.w  #224/2,d2
                cmp.w   d2,d1
                bhs.w   loc_19924
                addi.w  #128,d1
                sub.w   d3,d1
                ori.b   #$80,render_flags(a0)
                tst.w   d7
                bmi.w   loc_19924
                move.w  art_tile(a0),d5
                movea.l mappings(a0),a2
                moveq   #0,d4
                move.b  mapping_frame(a0),d4
                beq.s   loc_19ACC
                add.w   d4,d4
                lea     (a2),a1
                adda.w  (a1,d4.w),a1
                move.w  (a1)+,d4
                subq.w  #1,d4
                bmi.s   loc_19ACC
                move.w  d6,d3
                jsr     sub_196D2(pc)
                move.w  d3,d6
                tst.w   d7
                bmi.w   loc_19924

loc_19ACC:
                move.w  mainspr_childsprites(a0),d3
                subq.w  #1,d3
                bcs.w   loc_19924
                lea     sub2_x_pos(a0),a0

loc_19ADA:
                move.w  (a0)+,d0
                sub.w   (a3),d0
                addi.w  #128,d0
                and.w   (Screen_X_wrap_value).w,d0
                move.w  (a0)+,d1
                sub.w   4(a3),d1
                addi.w  #128,d1
                and.w   (Screen_Y_wrap_value).w,d1
                addq.w  #1,a0
                moveq   #0,d4
                move.b  (a0)+,d4
                add.w   d4,d4
                lea     (a2),a1
                adda.w  (a1,d4.w),a1
                move.w  (a1)+,d4
                subq.w  #1,d4
                bmi.s   loc_19B10
                move.w  d6,-(sp)
                jsr     sub_196D2(pc)
                move.w  (sp)+,d6

loc_19B10:
                tst.w   d7
                dbmi    d3,loc_19ADA
                bra.w   loc_19924
; ---------------------------------------------------------------------------

loc_19B1A:
                moveq   #0,d2
                sub.w   (a3),d0
                move.b  width_pixels(a0),d2
                add.w   d2,d0
                and.w   (Screen_X_wrap_value).w,d0
                move.w  d2,d3
                add.w   d2,d2
                addi.w  #320,d2
                cmp.w   d2,d0
                bhs.w   loc_19A24
                addi.w  #128,d0
                sub.w   d3,d0
                moveq   #0,d2
                sub.w   4(a3),d1
                move.b  height_pixels(a0),d2
                add.w   d2,d1
                and.w   (Screen_Y_wrap_value).w,d1
                move.w  d2,d3
                add.w   d2,d2
                addi.w  #224/2,d2
                cmp.w   d2,d1
                bhs.w   loc_19A24
                addi.w  #240,d1
                sub.w   d3,d1
                ori.b   #$80,render_flags(a0)
                tst.w   d7
                bmi.w   loc_19A24
                move.w  art_tile(a0),d5
                movea.l mappings(a0),a2
                moveq   #0,d4
                move.b  mapping_frame(a0),d4
                beq.s   loc_19B98
                add.w   d4,d4
                lea     (a2),a1
                adda.w  (a1,d4.w),a1
                move.w  (a1)+,d4
                subq.w  #1,d4
                bmi.s   loc_19B98
                move.w  d6,d3
                jsr     sub_196D2(pc)
                move.w  d3,d6
                tst.w   d7
                bmi.w   loc_19A24

loc_19B98:
                move.w  mainspr_childsprites(a0),d3
                subq.w  #1,d3
                bcs.w   loc_19A24
                lea     sub2_x_pos(a0),a0

loc_19BA6:
                move.w  (a0)+,d0
                sub.w   (a3),d0
                addi.w  #128,d0
                and.w   (Screen_X_wrap_value).w,d0
                move.w  (a0)+,d1
                sub.w   4(a3),d1
                addi.w  #128,d1
                and.w   (Screen_Y_wrap_value).w,d1
                addi.w  #224/2,d1
                addq.w  #1,a0
                moveq   #0,d4
                move.b  (a0)+,d4
                add.w   d4,d4
                lea     (a2),a1
                adda.w  (a1,d4.w),a1
                move.w  (a1)+,d4
                subq.w  #1,d4
                bmi.s   loc_19BE0
                move.w  d6,-(sp)
                jsr     sub_196D2(pc)
                move.w  (sp)+,d6

loc_19BE0:
                tst.w   d7
                dbmi    d3,loc_19BA6
                bra.w   loc_19A24
