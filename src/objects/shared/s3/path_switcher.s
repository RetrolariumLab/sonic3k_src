; Owner: objects/shared/s3
; Responsibility: Shared foreground priority and collision-path switcher state and geometric contact helpers
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_PathSwap:
                move.l  #Map_PathSwap,mappings(a0)
                move.w  #make_art_tile(ArtTile_Ring,1,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.b  #$40,width_pixels(a0)
                move.b  #$40,height_pixels(a0)
                move.w  #$280,priority(a0)
                move.b  subtype(a0),d0
                btst    #2,d0
                beq.s   loc_1B050
                andi.w  #7,d0
                move.b  d0,mapping_frame(a0)
                andi.w  #3,d0
                add.w   d0,d0
                move.w  word_1B048(pc,d0.w),$32(a0)
                move.w  y_pos(a0),d1
                lea     (Player_1).w,a1
                cmp.w   y_pos(a1),d1
                bhs.s   loc_1B01A
                move.b  #1,$34(a0)

loc_1B01A:
                lea     (Player_2).w,a1
                cmp.w   y_pos(a1),d1
                bhs.s   loc_1B02A
                move.b  #1,$35(a0)

loc_1B02A:
                move.l  #loc_1B208,(a0)
                tst.w   (Competition_mode).w
                beq.w   loc_1B208
                move.l  #loc_1B232,(a0)
                move.w  #make_art_tile(ArtTile_2PArt_3+$C,3,0),art_tile(a0)
                bra.w   loc_1B232
; ---------------------------------------------------------------------------
word_1B048:
                dc.w    $20,   $40,   $80,  $100
; ---------------------------------------------------------------------------

loc_1B050:
                andi.w  #3,d0
                move.b  d0,mapping_frame(a0)
                add.w   d0,d0
                move.w  word_1B048(pc,d0.w),$32(a0)
                move.w  x_pos(a0),d1
                lea     (Player_1).w,a1
                cmp.w   x_pos(a1),d1
                bhs.s   loc_1B074
                move.b  #1,$34(a0)

loc_1B074:
                lea     (Player_2).w,a1
                cmp.w   x_pos(a1),d1
                bhs.s   loc_1B084
                move.b  #1,$35(a0)

loc_1B084:
                move.l  #loc_1B09E,(a0)
                tst.w   (Competition_mode).w
                beq.s   loc_1B09E
                move.l  #loc_1B0C8,(a0)
                move.w  #make_art_tile(ArtTile_2PArt_3+$C,3,0),art_tile(a0)
                bra.s   loc_1B0C8
; ---------------------------------------------------------------------------

loc_1B09E:
                tst.w   (Debug_placement_mode).w
                bne.w   loc_1B0BA
                move.w  x_pos(a0),d1
                lea     $34(a0),a2
                lea     (Player_1).w,a1
                bsr.s   sub_1B0F0
                lea     (Player_2).w,a1
                bsr.s   sub_1B0F0

loc_1B0BA:
                tst.w   (Debug_mode_flag).w
                beq.w   Delete_Sprite_If_Not_In_Range
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

loc_1B0C8:
                move.w  x_pos(a0),d1
                lea     $34(a0),a2
                lea     (Player_1).w,a1
                bsr.s   sub_1B0F0
                lea     (Player_2).w,a1
                bsr.s   sub_1B0F0
                lea     (Breathing_bubbles).w,a1
                tst.w   (Debug_mode_flag).w
                beq.w   sub_1B0F0
                bsr.s   sub_1B0F0
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

sub_1B0F0:
                tst.b   (a2)+
                bne.w   loc_1B182
                cmp.w   x_pos(a1),d1
                bhi.w   locret_1B206
                move.b  #1,-1(a2)
                move.w  y_pos(a0),d2
                move.w  d2,d3
                move.w  $32(a0),d4
                sub.w   d4,d2
                add.w   d4,d3
                move.w  y_pos(a1),d4
                cmp.w   d2,d4
                blt.w   locret_1B206
                cmp.w   d3,d4
                bge.w   locret_1B206
                move.b  subtype(a0),d0
                bpl.s   loc_1B132
                btst    #Status_InAir,status(a1)
                bne.w   locret_1B206

loc_1B132:
                move.w  x_pos(a1),d2
                sub.w   d1,d2
                bcc.s   loc_1B13C
                neg.w   d2

loc_1B13C:
                cmpi.w  #$40,d2
                bhs.w   locret_1B206
                btst    #0,render_flags(a0)
                bne.s   loc_1B16A
                move.b  #$C,top_solid_bit(a1)
                move.b  #$D,lrb_solid_bit(a1)
                btst    #3,d0
                beq.s   loc_1B16A
                move.b  #$E,top_solid_bit(a1)
                move.b  #$F,lrb_solid_bit(a1)

loc_1B16A:
                andi.w  #drawing_mask,art_tile(a1)
                btst    #5,d0
                beq.w   locret_1B206
                ori.w   #high_priority,art_tile(a1)
                bra.w   locret_1B206
; ---------------------------------------------------------------------------

loc_1B182:
                cmp.w   x_pos(a1),d1
                bls.w   locret_1B206
                move.b  #0,-1(a2)
                move.w  y_pos(a0),d2
                move.w  d2,d3
                move.w  $32(a0),d4
                sub.w   d4,d2
                add.w   d4,d3
                move.w  y_pos(a1),d4
                cmp.w   d2,d4
                blt.w   locret_1B206
                cmp.w   d3,d4
                bge.w   locret_1B206
                move.b  subtype(a0),d0
                bpl.s   loc_1B1BE
                btst    #Status_InAir,status(a1)
                bne.w   locret_1B206

loc_1B1BE:
                move.w  x_pos(a1),d2
                sub.w   d1,d2
                bcc.s   loc_1B1C8
                neg.w   d2

loc_1B1C8:
                cmpi.w  #$40,d2
                bhs.s   locret_1B206
                btst    #0,render_flags(a0)
                bne.s   loc_1B1F4
                move.b  #$C,top_solid_bit(a1)
                move.b  #$D,lrb_solid_bit(a1)
                btst    #4,d0
                beq.s   loc_1B1F4
                move.b  #$E,top_solid_bit(a1)
                move.b  #$F,lrb_solid_bit(a1)

loc_1B1F4:
                andi.w  #drawing_mask,art_tile(a1)
                btst    #6,d0
                beq.s   locret_1B206
                ori.w   #high_priority,art_tile(a1)

locret_1B206:
                rts
; End of function sub_1B0F0

; ---------------------------------------------------------------------------

loc_1B208:
                tst.w   (Debug_placement_mode).w
                bne.w   loc_1B224
                move.w  y_pos(a0),d1
                lea     $34(a0),a2
                lea     (Player_1).w,a1
                bsr.s   sub_1B25A
                lea     (Player_2).w,a1
                bsr.s   sub_1B25A

loc_1B224:
                tst.w   (Debug_mode_flag).w
                beq.w   Delete_Sprite_If_Not_In_Range
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

loc_1B232:
                move.w  y_pos(a0),d1
                lea     $34(a0),a2
                lea     (Player_1).w,a1
                bsr.s   sub_1B25A
                lea     (Player_2).w,a1
                bsr.s   sub_1B25A
                lea     (Breathing_bubbles).w,a1
                tst.w   (Debug_mode_flag).w
                beq.w   sub_1B25A
                bsr.s   sub_1B25A
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

sub_1B25A:
                tst.b   (a2)+
                bne.w   loc_1B2EC
                cmp.w   y_pos(a1),d1
                bhi.w   locret_1B370
                move.b  #1,-1(a2)
                move.w  x_pos(a0),d2
                move.w  d2,d3
                move.w  $32(a0),d4
                sub.w   d4,d2
                add.w   d4,d3
                move.w  x_pos(a1),d4
                cmp.w   d2,d4
                blt.w   locret_1B370
                cmp.w   d3,d4
                bge.w   locret_1B370
                move.b  subtype(a0),d0
                bpl.s   loc_1B29C
                btst    #Status_InAir,status(a1)
                bne.w   locret_1B370

loc_1B29C:
                move.w  y_pos(a1),d2
                sub.w   d1,d2
                bcc.s   loc_1B2A6
                neg.w   d2

loc_1B2A6:
                cmpi.w  #$40,d2
                bhs.w   locret_1B370
                btst    #0,render_flags(a0)
                bne.s   loc_1B2D4
                move.b  #$C,top_solid_bit(a1)
                move.b  #$D,lrb_solid_bit(a1)
                btst    #3,d0
                beq.s   loc_1B2D4
                move.b  #$E,top_solid_bit(a1)
                move.b  #$F,lrb_solid_bit(a1)

loc_1B2D4:
                andi.w  #drawing_mask,art_tile(a1)
                btst    #5,d0
                beq.w   locret_1B370
                ori.w   #high_priority,art_tile(a1)
                bra.w   locret_1B370
; ---------------------------------------------------------------------------

loc_1B2EC:
                cmp.w   y_pos(a1),d1
                bls.w   locret_1B370
                move.b  #0,-1(a2)
                move.w  x_pos(a0),d2
                move.w  d2,d3
                move.w  $32(a0),d4
                sub.w   d4,d2
                add.w   d4,d3
                move.w  x_pos(a1),d4
                cmp.w   d2,d4
                blt.w   locret_1B370
                cmp.w   d3,d4
                bge.w   locret_1B370
                move.b  subtype(a0),d0
                bpl.s   loc_1B328
                btst    #Status_InAir,status(a1)
                bne.w   locret_1B370

loc_1B328:
                move.w  y_pos(a1),d2
                sub.w   d1,d2
                bcc.s   loc_1B332
                neg.w   d2

loc_1B332:
                cmpi.w  #$40,d2
                bhs.s   locret_1B370
                btst    #0,render_flags(a0)
                bne.s   loc_1B35E
                move.b  #$C,top_solid_bit(a1)
                move.b  #$D,lrb_solid_bit(a1)
                btst    #4,d0
                beq.s   loc_1B35E
                move.b  #$E,top_solid_bit(a1)
                move.b  #$F,lrb_solid_bit(a1)

loc_1B35E:
                andi.w  #drawing_mask,art_tile(a1)
                btst    #6,d0
                beq.s   locret_1B370
                ori.w   #high_priority,art_tile(a1)

locret_1B370:
                rts
; End of function sub_1B25A

; ---------------------------------------------------------------------------
Map_PathSwap:
                include "src/objects/shared/level_misc/map_path_swap.s"
