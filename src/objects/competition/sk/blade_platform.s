; Owner: objects/competition/sk
; Responsibility: Competition blade-platform motion, player collision and mapping resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_CGZBladePlatform:
                move.l  #Map_CGZBladePlatform,mappings(a0)
                move.w  #make_art_tile(ArtTile_CGZMisc,3,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.w  #$280,priority(a0)
                move.b  #$20,width_pixels(a0)
                move.b  #8,height_pixels(a0)
                move.w  y_pos(a0),$32(a0)
                bset    #7,status(a0)
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   loc_35B10
                move.l  #loc_35B90,(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                subi.w  #$10,x_pos(a1)
                addi.w  #$C,y_pos(a1)
                move.b  #$A6,collision_flags(a1)
                move.w  a0,$3E(a1)
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   loc_35B10
                move.l  #loc_35BA6,(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                addi.w  #$10,x_pos(a1)
                addi.w  #$14,y_pos(a1)
                move.b  #$A6,collision_flags(a1)
                move.w  a0,$3E(a1)

loc_35B10:
                move.l  #loc_35B16,(a0)

loc_35B16:
                move.b  status(a0),d0
                andi.b  #standing_mask,d0
                beq.s   loc_35B42
                move.w  #$80,d1
                cmpi.b  #p1_standing|p2_standing,d0
                bne.s   loc_35B2E
                move.w  #$100,d1

loc_35B2E:
                add.w   d1,$36(a0)
                cmpi.w  #$8000,$36(a0)
                blo.s   loc_35B40
                move.w  #$8000,$36(a0)

loc_35B40:
                bra.s   loc_35B56
; ---------------------------------------------------------------------------

loc_35B42:
                tst.w   $36(a0)
                beq.s   loc_35B56
                subi.w  #$100,$36(a0)
                bcc.s   loc_35B56
                move.w  #0,$36(a0)

loc_35B56:
                move.w  $32(a0),d0
                add.b   $36(a0),d0
                move.w  d0,y_pos(a0)
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                addi.w  #7,d1
                moveq   #0,d2
                move.b  height_pixels(a0),d2
                move.w  d2,d3
                addq.w  #1,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                addq.b  #1,mapping_frame(a0)
                andi.b  #3,mapping_frame(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_35B90:
                movea.w $3E(a0),a1
                move.w  y_pos(a1),y_pos(a0)
                addi.w  #8,y_pos(a0)
                jmp     (Add_SpriteToCollisionResponseList).l
; ---------------------------------------------------------------------------

loc_35BA6:
                movea.w $3E(a0),a1
                move.w  y_pos(a1),y_pos(a0)
                addi.w  #$10,y_pos(a0)
                jmp     (Add_SpriteToCollisionResponseList).l
; ---------------------------------------------------------------------------
Map_CGZBladePlatform:
                include "src/objects/shared/zones/cgz/mappings/blade_platform.s"
; End of function Obj_CGZBladePlatform
