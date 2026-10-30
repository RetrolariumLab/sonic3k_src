; Owner: objects/zones/soz/sk
; Responsibility: Sand cork player contact, fracture, movement and mapping resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_SOZSandCork:
                move.l  #Map_SOZSandCork,mappings(a0)
                move.w  #make_art_tile(ArtTile_SOZ2Extra+$E,2,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.b  #$C,width_pixels(a0)
                move.b  #8,height_pixels(a0)
                move.w  #$280,priority(a0)
                move.b  #$C6,collision_flags(a0)
                move.w  respawn_addr(a0),d0
                beq.s   loc_41D2C
                movea.w d0,a2
                btst    #0,(a2)
                beq.s   loc_41D2C
                move.b  subtype(a0),d5
                andi.w  #$7F,d5
                lsl.w   #4,d5
                moveq   #0,d4
                move.w  y_pos(a0),d3
                add.w   d5,d3
                subi.w  #$90,d3

loc_41D12:
                bsr.w   sub_41E1A
                subi.w  #$100,d3
                subi.w  #$100,d5
                bhi.s   loc_41D12
                move.w  respawn_addr(a0),respawn_addr(a1)
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_41D2C:
                move.l  #loc_41D32,(a0)

loc_41D32:
                move.b  collision_property(a0),d0
                beq.w   loc_41D56
                lea     (Player_1).w,a1
                bclr    #0,collision_property(a0)
                beq.s   loc_41D48
                bsr.s   sub_41D5C

loc_41D48:
                lea     (Player_2).w,a1
                bclr    #1,collision_property(a0)
                beq.s   loc_41D56
                bsr.s   sub_41D5C

loc_41D56:
                jmp     (Sprite_CheckDeleteTouch3).l

; =============== S U B R O U T I N E =======================================

sub_41D5C:
                cmpi.b  #2,anim(a1)
                bne.w   locret_41DF2
                neg.w   x_vel(a1)
                neg.w   y_vel(a1)
                move.b  subtype(a0),d4
                andi.w  #$7F,d4
                lsl.w   #4,d4
                move.w  d4,d5
                move.w  y_pos(a0),d3
                subi.w  #$90,d3

loc_41D82:
                bsr.w   sub_41E1A
                subi.w  #$100,d3
                subi.w  #$100,d5
                bcc.s   loc_41D82
                move.w  respawn_addr(a0),respawn_addr(a1)
                lea     (word_41E96).l,a4
                move.l  #loc_41DF4,(a0)
                addq.b  #1,mapping_frame(a0)
                move.w  #0,priority(a0)
                moveq   #signextendB(sfx_Collapse),d0
                jsr     (Play_SFX).l
                jsr     (BreakObjectToPieces2).l
                jsr     (MoveSprite2).l
                addi.w  #$18,y_vel(a0)
                move.w  respawn_addr(a0),d0
                beq.s   loc_41DD2
                movea.w d0,a2
                bset    #0,(a2)

loc_41DD2:
                tst.b   subtype(a0)
                bpl.s   loc_41DE0
                move.w  #-1,(Events_fg_4).w
                bra.s   loc_41DE6
; ---------------------------------------------------------------------------

loc_41DE0:
                move.w  #-1,(Events_fg_5).w

loc_41DE6:
                move.b  #0,collision_flags(a0)
                move.b  #0,collision_property(a0)

locret_41DF2:
                rts
; End of function sub_41D5C

; ---------------------------------------------------------------------------

loc_41DF4:
                jsr     (MoveSprite2).l
                addi.w  #$18,y_vel(a0)
                cmpi.w  #$400,y_vel(a0)
                blt.s   loc_41E0E
                tst.b   render_flags(a0)
                bpl.s   loc_41E14

loc_41E0E:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_41E14:
                jmp     (Delete_Current_Sprite).l

; =============== S U B R O U T I N E =======================================

sub_41E1A:
                jsr     (AllocateObject).l
                bne.w   locret_41E68
                move.l  #loc_41E6A,(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  d3,y_pos(a1)
                move.b  render_flags(a0),render_flags(a1)
                move.l  mappings(a0),mappings(a1)
                move.w  art_tile(a0),art_tile(a1)
                move.w  #$80,priority(a1)
                move.b  #$C,width_pixels(a1)
                move.b  #$80,height_pixels(a1)
                move.w  d4,$30(a1)
                move.b  #2,mapping_frame(a1)
                move.b  subtype(a0),subtype(a1)

locret_41E68:
                rts
; End of function sub_41E1A

; ---------------------------------------------------------------------------

loc_41E6A:
                tst.w   $30(a0)
                beq.s   loc_41E78
                addq.w  #4,y_pos(a0)
                subq.w  #4,$30(a0)

loc_41E78:
; Bug: Level_frame_counter should not be using a0, as a0 is the object's RAM!
                move.b  Level_frame_counter+1(a0),d0
                andi.b  #$F,d0
                bne.s   loc_41E90
                tst.b   render_flags(a0)
                bpl.s   loc_41E90
                moveq   #signextendB(sfx_SlideSkidQuiet),d0
                jsr     (Play_SFX).l

loc_41E90:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------
word_41E96:
                dc.w    -$200, -$200
                dc.w    $80, -$200
                dc.w    $200, -$200
                dc.w    -$1E0, -$1E0
                dc.w    $60, -$1E0
                dc.w    $1E0, -$1E0
Map_SOZSandCork:
                include "src/objects/shared/zones/soz/map_sand_cork.s"
