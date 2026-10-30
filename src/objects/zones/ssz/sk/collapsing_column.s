; Owner: objects/zones/ssz/sk
; Responsibility: Collapsing column activation, fragments and player collision
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_SSZCollapsingColumn:
                move.l  #loc_44B30,(a0)
                move.b  #4,render_flags(a0)
                move.b  #1,routine(a0)
                move.b  #$21,height_pixels(a0)
                move.b  #$10,width_pixels(a0)
                move.w  #$180,priority(a0)
                move.w  #make_art_tile(ArtTile_SSZMisc+$10,3,1),art_tile(a0)
                move.l  #Map_SSZFloatingPlatform,mappings(a0)
                move.b  #2,mapping_frame(a0)
                move.w  y_pos(a0),y_vel(a0)
                jsr     (Random_Number).l
                andi.w  #$1FFF,d0
                addi.w  #$800,d0
                move.w  d0,$30(a0)

loc_44B30:
                move.b  status(a0),d0
                andi.w  #standing_mask,d0
                beq.s   loc_44B90
                clr.b   routine(a0)
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   loc_44B7E
                lea     word_46618(pc),a2
                move.w  x_pos(a0),d1
                moveq   #8-1,d2

loc_44B50:
                move.l  #loc_44BCC,(a1)
                move.w  a0,$2E(a1)
                move.w  (a2)+,d3
                add.w   d1,d3
                move.w  d3,x_pos(a1)
                move.w  (a2)+,$30(a1)
                move.w  (a2)+,$32(a1)
                move.w  (a2)+,d3
                move.b  d3,mapping_frame(a1)
                addq.b  #1,routine(a0)
                jsr     (CreateNewSprite4).l
                dbne    d2,loc_44B50

loc_44B7E:
                moveq   #signextendB(sfx_Collapse),d0
                jsr     (Play_SFX).l
                clr.b   mapping_frame(a0)
                move.l  #loc_44B90,(a0)

loc_44B90:
                tst.b   routine(a0)
                beq.s   loc_44B98
                bpl.s   loc_44B9E

loc_44B98:
                move.w  #$7FFF,x_pos(a0)

loc_44B9E:
                move.l  #$2800,d0
                move.l  #$80,d1
                jsr     Gradual_SwingOffset(pc)
                add.w   $1A(a0),d0
                move.w  d0,y_pos(a0)
                moveq   #$1B,d1
                moveq   #$21,d2
                moveq   #$21,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectTop).l
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

loc_44BCC:
                move.l  #loc_44BF8,(a0)
                move.b  #$84,render_flags(a0)
                move.b  #8,height_pixels(a0)
                move.b  #8,width_pixels(a0)
                move.w  #$200,priority(a0)
                move.w  #make_art_tile(ArtTile_SSZMisc+$10,3,1),art_tile(a0)
                move.l  #Map_SSZFloatingPlatform,mappings(a0)

loc_44BF8:
                movea.w $2E(a0),a1
                tst.b   render_flags(a0)
                bmi.s   loc_44C14
                tst.w   $32(a0)
                beq.s   loc_44C0E
                bmi.s   loc_44C0E
                subq.b  #1,routine(a1)

loc_44C0E:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_44C14:
                subq.w  #1,$32(a0)
                bpl.s   loc_44C2C
                move.w  y_pos(a0),d0
                addi.l  #$3800,$34(a0)
                add.w   $34(a0),d0
                bra.s   loc_44C3A
; ---------------------------------------------------------------------------

loc_44C2C:
                bne.s   loc_44C32
                subq.b  #1,routine(a1)

loc_44C32:
                move.w  y_pos(a1),d0
                add.w   $30(a0),d0

loc_44C3A:
                move.w  d0,y_pos(a0)
                jmp     (Draw_Sprite).l
; End of function Obj_SSZCollapsingColumn
