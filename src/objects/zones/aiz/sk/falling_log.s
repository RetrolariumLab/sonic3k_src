; Owner: objects/zones/aiz/sk
; Responsibility: Angel Island falling log motion, water splash fragments and mapping resources
; Source provenance and ranges: config/reconstruction/source_layout.json
word_2B566:
                dc.w    1
                dc.w    3
                dc.w    7
                dc.w    $F
                dc.w    $1F
                dc.w    $3F
                dc.w    $7F
                dc.w    $FF
                dc.w    $1FF
                dc.w    $3FF
                dc.w    $7FF
                dc.w    $FFF
                dc.w    $1FFF
                dc.w    $3FFF
                dc.w    $7FFF
                dc.w    $FFFF
; ---------------------------------------------------------------------------

Obj_AIZFallingLog:
                cmpi.w  #$26B0,x_pos(a0)
                beq.s   loc_2B596
                cmpi.w  #$2700,x_pos(a0)
                bne.s   loc_2B5A2

loc_2B596:
                tst.b   (Level_trigger_array).w
                beq.s   loc_2B5A2
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_2B5A2:
                move.b  subtype(a0),d0
                move.b  d0,d1
                andi.w  #$F,d0
                move.w  d0,d2
                add.w   d0,d0
                move.w  word_2B566(pc,d0.w),$32(a0)
                subq.w  #3,d2
                bcc.s   loc_2B5BC
                moveq   #0,d2

loc_2B5BC:
                lsr.w   #4,d1
                andi.w  #$F,d1
                lsl.w   d2,d1
                move.w  d1,$34(a0)
                move.b  #4,render_flags(a0)
                move.l  #loc_2B5D4,(a0)

loc_2B5D4:
                move.w  (Level_frame_counter).w,d0
                add.w   $34(a0),d0
                and.w   $32(a0),d0
                bne.w   loc_2B69A
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   loc_2B69A
                move.l  #loc_2B6A0,(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.l  #Map_AIZFallingLog2,mappings(a1)
                move.w  #make_art_tile(ArtTile_AIZMisc2,2,0),art_tile(a1)
                tst.b   (Current_act).w
                bne.s   loc_2B622
                move.l  #Map_AIZFallingLog,mappings(a1)
                move.w  #make_art_tile(ArtTile_AIZFallingLog,2,0),art_tile(a1)

loc_2B622:
                move.b  #$18,width_pixels(a1)
                move.b  #8,height_pixels(a1)
                move.b  #4,render_flags(a1)
                move.w  #$280,priority(a1)
                movea.l a1,a2
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   loc_2B69A
                move.l  #loc_2B72C,(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.l  #Map_AIZFallingLogSplash2,mappings(a1)
                move.w  #make_art_tile(ArtTile_AIZMisc2,3,0),art_tile(a1)
                tst.b   (Current_act).w
                bne.s   loc_2B67A
                move.l  #Map_AIZFallingLogSplash,mappings(a1)
                move.w  #make_art_tile(ArtTile_AIZFallingLog,2,0),art_tile(a1)

loc_2B67A:
                move.b  #$20,width_pixels(a1)
                move.b  #$10,height_pixels(a1)
                move.b  #4,render_flags(a1)
                move.w  #$200,priority(a1)
                move.w  a2,$3C(a1)
                move.w  a1,$3C(a2)

loc_2B69A:
                jmp     (Delete_Sprite_If_Not_In_Range).l
; ---------------------------------------------------------------------------

loc_2B6A0:
                addq.w  #1,y_pos(a0)
                move.w  y_pos(a0),d0
                cmp.w   (Water_level).w,d0
                blo.s   loc_2B6BA
                move.l  #loc_2B6BC,(a0)
                move.b  #60-1,anim_frame_timer(a0)

loc_2B6BA:
                bra.s   loc_2B6D8
; ---------------------------------------------------------------------------

loc_2B6BC:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   loc_2B6C8
                move.w  #$7FF0,x_pos(a0)

loc_2B6C8:
                move.b  anim_frame_timer(a0),d0
                andi.b  #3,d0
                bne.s   loc_2B6D8
                bchg    #0,$36(a0)

loc_2B6D8:
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                moveq   #8,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectTop).l
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   loc_2B70C
                tst.b   $36(a0)
                bne.s   locret_2B70A
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

locret_2B70A:
                rts
; ---------------------------------------------------------------------------

loc_2B70C:
                move.w  $3C(a0),d0
                beq.s   loc_2B71A
                movea.w d0,a1
                jsr     (Delete_Referenced_Sprite).l

loc_2B71A:
                move.w  respawn_addr(a0),d0
                beq.s   loc_2B726
                movea.w d0,a2
                bclr    #7,(a2)

loc_2B726:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_2B72C:
                movea.w $3C(a0),a1
                move.w  x_pos(a1),x_pos(a0)
                move.w  y_pos(a1),y_pos(a0)
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   loc_2B752
                move.b  #3,anim_frame_timer(a0)
                addq.b  #1,mapping_frame(a0)
                andi.b  #3,mapping_frame(a0)

loc_2B752:
                jmp     (Draw_Sprite).l
