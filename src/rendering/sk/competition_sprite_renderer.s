; Owner: rendering/sk
; Responsibility: Competition sprite display and its private piece-coordinate lookup tables
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

Render_Sprites_CompetitionMode:
                moveq   #($50-2)-1,d7
                moveq   #0,d6
                lea     (Sprite_table_input).w,a5
                lea     (Camera_X_pos_copy).w,a3
; Unlike in Sonic 2, the sprite tables are page-flipped in two-player mode
; This fixes a race-condition where incomplete sprite tables can be uploaded
; to the VDP on lag frames, causing corrupted sprites to appear

; Modify the back buffer
                lea     (Sprite_table+$10).w,a6
                tst.w   (Current_sprite_table_page).w
                beq.s   loc_1B210
                lea     (Sprite_table_alternate+$10).l,a6

loc_1B210:
                tst.b   (Level_started_flag).w
                beq.s   loc_1B21C
                jsr     (Render_HUD_P1).l

loc_1B21C:
                move.b  1(a5),(a5)
                beq.w   loc_1B2C8
                lea     2(a5),a4

loc_1B228:
                movea.w (a4)+,a0
                andi.b  #$7F,render_flags(a0)
                move.b  render_flags(a0),d6
                btst    #4,d6
                bne.w   loc_1B2C2
                move.w  x_pos(a0),d0
                move.w  y_pos(a0),d1
                btst    #6,d6
                bne.w   loc_1B3EC
                btst    #2,d6
                beq.s   loc_1B294
                moveq   #0,d2
                sub.w   (a3),d0
                move.b  width_pixels(a0),d2
                add.w   d2,d0
                and.w   (Screen_X_wrap_value).w,d0
                move.w  d2,d3
                add.w   d2,d2
                addi.w  #320,d2
                cmp.w   d2,d0
                bhs.s   loc_1B2C2
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
                bhs.s   loc_1B2C2
                addi.w  #128,d1
                sub.w   d3,d1

loc_1B294:
                ori.b   #$80,render_flags(a0)
                tst.w   d7
                bmi.s   loc_1B2C2
                movea.l mappings(a0),a1
                moveq   #0,d4
                btst    #5,d6
                bne.s   loc_1B2BA
                move.b  mapping_frame(a0),d4
                add.w   d4,d4
                adda.w  (a1,d4.w),a1
                move.w  (a1)+,d4
                subq.w  #1,d4
                bmi.s   loc_1B2C2

loc_1B2BA:
                move.w  art_tile(a0),d5
                jsr     sub_1AF6C(pc)

loc_1B2C2:
                subq.b  #2,(a5)
                bne.w   loc_1B228

loc_1B2C8:
                lea     $80(a5),a5
                cmpa.l  #Sprite_table_input_end,a5
                blo.w   loc_1B21C
                tst.w   d7
                bmi.s   loc_1B2E4
                moveq   #0,d0

loc_1B2DC:
                move.w  d0,(a6)
                addq.w  #8,a6
                dbf     d7,loc_1B2DC

loc_1B2E4:
                move.l  (Sprite_table_input+2+($80*2)).w,d0
                cmpi.l  #((Player_1&$FFFF)<<16)|(Player_2&$FFFF),d0
                bne.s   loc_1B2F6
                swap    d0
                move.l  d0,(Sprite_table_input+2+($80*2)).w

loc_1B2F6:
                moveq   #$50-1,d7
                lea     (Sprite_table_input).w,a5
                lea     (Camera_X_pos_P2_copy).w,a3
; Unlike in Sonic 2, the sprite tables are page-flipped in two-player mode
; This fixes a race-condition where incomplete sprite tables can be uploaded
; to the VDP on lag frames, causing corrupted sprites to appear

; Modify the back buffer
                lea     (Sprite_table_P2).l,a6
                tst.w   (Current_sprite_table_page).w
                beq.s   loc_1B312
                lea     (Sprite_table_P2_alternate).l,a6

loc_1B312:
                tst.b   (Level_started_flag).w
                beq.s   loc_1B31E
                jsr     (Render_HUD_P2).l

loc_1B31E:
                tst.b   1(a5)
                beq.w   loc_1B3CA
                lea     2(a5),a4

loc_1B32A:
                movea.w (a4)+,a0
                move.b  render_flags(a0),d6
                btst    #3,d6
                bne.w   loc_1B3C2
                move.w  x_pos(a0),d0
                move.w  y_pos(a0),d1
                btst    #6,d6
                bne.w   loc_1B4B8
                btst    #2,d6
                beq.s   loc_1B390
                moveq   #0,d2
                sub.w   (a3),d0
                move.b  width_pixels(a0),d2
                add.w   d2,d0
                and.w   (Screen_X_wrap_value).w,d0
                move.w  d2,d3
                add.w   d2,d2
                addi.w  #320,d2
                cmp.w   d2,d0
                bhs.s   loc_1B3C2
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
                bhs.s   loc_1B3C2
                addi.w  #128,d1
                sub.w   d3,d1

loc_1B390:
                addi.w  #224/2,d1
                ori.b   #$80,render_flags(a0)
                tst.w   d7
                bmi.s   loc_1B3C2
                movea.l mappings(a0),a1
                moveq   #0,d4
                btst    #5,d6
                bne.s   loc_1B3BA
                move.b  mapping_frame(a0),d4
                add.w   d4,d4
                adda.w  (a1,d4.w),a1
                move.w  (a1)+,d4
                subq.w  #1,d4
                bmi.s   loc_1B3C2

loc_1B3BA:
                move.w  art_tile(a0),d5
                jsr     sub_1AF6C(pc)

loc_1B3C2:
                subq.b  #2,1(a5)
                bne.w   loc_1B32A

loc_1B3CA:
                lea     $80(a5),a5
                cmpa.l  #Sprite_table_input_end,a5
                blo.w   loc_1B31E
                tst.w   d7
                bmi.s   loc_1B3E6
                moveq   #0,d0

loc_1B3DE:
                move.w  d0,(a6)
                addq.w  #8,a6
                dbf     d7,loc_1B3DE

loc_1B3E6:
; The new sprite tables are complete: signal a page flip to
; allow them to be uploaded to the VDP!
                st.b    (Sprite_table_page_flip_pending).w
                rts
; ---------------------------------------------------------------------------

loc_1B3EC:
                moveq   #0,d2
                sub.w   (a3),d0
                move.b  width_pixels(a0),d2
                add.w   d2,d0
                and.w   (Screen_X_wrap_value).w,d0
                move.w  d2,d3
                add.w   d2,d2
                addi.w  #320,d2
                cmp.w   d2,d0
                bhs.w   loc_1B2C2
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
                bhs.w   loc_1B2C2
                addi.w  #128,d1
                sub.w   d3,d1
                ori.b   #$80,render_flags(a0)
                tst.w   d7
                bmi.w   loc_1B2C2
                move.w  art_tile(a0),d5
                movea.l mappings(a0),a2
                moveq   #0,d4
                move.b  mapping_frame(a0),d4
                beq.s   loc_1B46A
                add.w   d4,d4
                lea     (a2),a1
                adda.w  (a1,d4.w),a1
                move.w  (a1)+,d4
                subq.w  #1,d4
                bmi.s   loc_1B46A
                move.w  d6,d3
                jsr     sub_1B070(pc)
                move.w  d3,d6
                tst.w   d7
                bmi.w   loc_1B2C2

loc_1B46A:
                move.w  mainspr_childsprites(a0),d3
                subq.w  #1,d3
                bcs.w   loc_1B2C2
                lea     sub2_x_pos(a0),a0

loc_1B478:
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
                bmi.s   loc_1B4AE
                move.w  d6,-(sp)
                jsr     sub_1B070(pc)
                move.w  (sp)+,d6

loc_1B4AE:
                tst.w   d7
                dbmi    d3,loc_1B478
                bra.w   loc_1B2C2
; ---------------------------------------------------------------------------

loc_1B4B8:
                moveq   #0,d2
                sub.w   (a3),d0
                move.b  width_pixels(a0),d2
                add.w   d2,d0
                and.w   (Screen_X_wrap_value).w,d0
                move.w  d2,d3
                add.w   d2,d2
                addi.w  #320,d2
                cmp.w   d2,d0
                bhs.w   loc_1B3C2
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
                bhs.w   loc_1B3C2
                addi.w  #240,d1
                sub.w   d3,d1
                ori.b   #$80,render_flags(a0)
                tst.w   d7
                bmi.w   loc_1B3C2
                move.w  art_tile(a0),d5
                movea.l mappings(a0),a2
                moveq   #0,d4
                move.b  mapping_frame(a0),d4
                beq.s   loc_1B536
                add.w   d4,d4
                lea     (a2),a1
                adda.w  (a1,d4.w),a1
                move.w  (a1)+,d4
                subq.w  #1,d4
                bmi.s   loc_1B536
                move.w  d6,d3
                jsr     sub_1B070(pc)
                move.w  d3,d6
                tst.w   d7
                bmi.w   loc_1B3C2

loc_1B536:
                move.w  mainspr_childsprites(a0),d3
                subq.w  #1,d3
                bcs.w   loc_1B3C2
                lea     sub2_x_pos(a0),a0

loc_1B544:
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
                bmi.s   loc_1B57E
                move.w  d6,-(sp)
                jsr     sub_1B070(pc)
                move.w  (sp)+,d6

loc_1B57E:
                tst.w   d7
                dbmi    d3,loc_1B544
                bra.w   loc_1B3C2
