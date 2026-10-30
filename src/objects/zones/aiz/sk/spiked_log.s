; Owner: objects/zones/aiz/sk
; Responsibility: Angel Island spiked log state, movement, player collision and damage
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_AIZSpikedLog:
                move.l  #Map_AIZSpikedLog,mappings(a0)
                move.w  #make_art_tile(ArtTile_AIZMisc2,2,0),art_tile(a0)
                move.b  #$18,width_pixels(a0)
                move.b  #8,height_pixels(a0)
                move.b  #4,render_flags(a0)
                move.w  #$200,priority(a0)
                move.w  y_pos(a0),$30(a0)
                move.b  (Water_entered_counter).w,$36(a0)
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   loc_2B7AE
                move.l  #loc_2B8EE,(a1)
                move.b  #4,render_flags(a1)
                move.b  #$9C,collision_flags(a1)
                move.w  a0,$3C(a1)
                move.w  a1,$3C(a0)

loc_2B7AE:
                move.l  #loc_2B7B4,(a0)

loc_2B7B4:
                tst.b   $34(a0)
                bmi.s   loc_2B7E8
                move.b  $36(a0),d0
                cmp.b   (Water_entered_counter).w,d0
                beq.s   loc_2B7D2
                move.b  (Water_entered_counter).w,$36(a0)
                move.b  #-$7F,$34(a0)
                bra.s   loc_2B7E8
; ---------------------------------------------------------------------------

loc_2B7D2:
                move.b  status(a0),d0
                andi.b  #standing_mask,d0
                bne.s   loc_2B7E8
                tst.b   $32(a0)
                beq.s   loc_2B81A
                subq.b  #4,$32(a0)
                bra.s   loc_2B81A
; ---------------------------------------------------------------------------

loc_2B7E8:
                tst.b   $34(a0)
                bne.s   loc_2B806
                move.b  anim_frame(a0),$35(a0)
                move.b  #0,anim_frame(a0)
                move.b  #0,anim_frame_timer(a0)
                move.b  #1,$34(a0)

loc_2B806:
                cmpi.b  #$40,$32(a0)
                beq.s   loc_2B814
                addq.b  #4,$32(a0)
                bra.s   loc_2B81A
; ---------------------------------------------------------------------------

loc_2B814:
                andi.b  #$7F,$34(a0)

loc_2B81A:
                move.b  $32(a0),d0
                jsr     (GetSineCosine).l
                asr.w   #5,d0
                add.w   $30(a0),d0
                move.w  d0,y_pos(a0)
                tst.b   $34(a0)
                beq.s   loc_2B864
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   loc_2B896
                move.b  #3,anim_frame_timer(a0)
                subq.b  #1,mapping_frame(a0)
                andi.b  #$F,mapping_frame(a0)
                addq.b  #1,anim_frame(a0)
                cmpi.b  #$10,anim_frame(a0)
                blo.s   loc_2B896
                move.b  $35(a0),anim_frame(a0)
                move.b  #0,$34(a0)
                bra.s   loc_2B896
; ---------------------------------------------------------------------------

loc_2B864:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   loc_2B896
                move.b  #$17,anim_frame_timer(a0)
                moveq   #0,d0
                move.b  anim_frame(a0),d0
                addq.b  #1,anim_frame(a0)
                move.b  byte_2B88E(pc,d0.w),mapping_frame(a0)
                move.b  byte_2B88E+1(pc,d0.w),d0
                bpl.s   loc_2B88C
                move.b  #0,anim_frame(a0)

loc_2B88C:
                bra.s   loc_2B896
; ---------------------------------------------------------------------------
byte_2B88E:
                dc.b    7
                dc.b    8
                dc.b    9
                dc.b    $A
                dc.b    9
                dc.b    8
                dc.b    -1
                even
; ---------------------------------------------------------------------------

loc_2B896:
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                addi.w  #$B,d1
                moveq   #0,d2
                move.b  height_pixels(a0),d2
                move.w  d2,d3
                addq.w  #1,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   loc_2B8CE
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_2B8CE:
                move.w  $3C(a0),d0
                beq.s   loc_2B8DC
                movea.w d0,a1
                jsr     (Delete_Referenced_Sprite).l

loc_2B8DC:
                move.w  respawn_addr(a0),d0
                beq.s   loc_2B8E8
                movea.w d0,a2
                bclr    #7,(a2)

loc_2B8E8:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_2B8EE:
                movea.w $3C(a0),a1
                move.w  x_pos(a1),x_pos(a0)
                move.w  y_pos(a1),y_pos(a0)
                moveq   #0,d0
                move.b  mapping_frame(a1),d0
                move.b  byte_2B918(pc,d0.w),d0
                beq.s   locret_2B916
                ext.w   d0
                add.w   d0,y_pos(a0)
                jmp     (Add_SpriteToCollisionResponseList).l
; ---------------------------------------------------------------------------

locret_2B916:
                rts
; ---------------------------------------------------------------------------
byte_2B918:
                dc.b    -$C, -$C,   0,   0,   0,   0,   0,  $C,  $C,  $C,   0,   0,   0,   0,   0, -$C
                even
