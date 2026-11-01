; Owner: objects/zones/soz/sk
; Responsibility: Sand-block spawning, block motion, collision and mapping resources
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

Obj_SOZSpawningSandBlocks:
                move.l  #Map_SOZSpawningSandBlocks,mappings(a0)
                move.w  #make_art_tile(ArtTile_SOZTile,2,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #$C,height_pixels(a0)
                move.w  #$200,priority(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsl.w   #3,d0
                add.w   d0,x_pos(a0)
                move.w  x_pos(a0),$44(a0)
                move.w  y_pos(a0),$46(a0)
                move.w  $44(a0),$30(a0)
                andi.w  #$FF80,d0
                addi.w  #$300,d0
                move.w  d0,$32(a0)
                move.l  #loc_402CC,(a0)

loc_402CC:
                tst.w   $34(a0)
                beq.s   loc_402EE
                subq.w  #1,$34(a0)
                bne.w   locret_4036C
                tst.b   (Oscillating_table+$16).w
                beq.s   loc_402EE
                move.w  #1,$34(a0)
                subq.w  #1,$36(a0)
                bra.w   locret_4036C
; ---------------------------------------------------------------------------

loc_402EE:
                moveq   #0,d0
                move.b  (Oscillating_table+$16).w,d0
                add.w   $46(a0),d0
                move.w  d0,y_pos(a0)
                bsr.s   SpawnSozTimedSandBlock
                bra.w   loc_403B0

; =============== S U B R O U T I N E =======================================

SpawnSozTimedSandBlock:
                subq.w  #1,$36(a0)
                bpl.s   locret_4036C
                move.w  #$7F,$36(a0)
                jsr     (AllocateObject).l
                bne.w   loc_40366
                move.l  #loc_4036E,(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.b  render_flags(a0),render_flags(a1)
                move.l  mappings(a0),mappings(a1)
                move.w  art_tile(a0),art_tile(a1)
                move.w  #$280,priority(a1)
                move.b  #$18,width_pixels(a1)
                move.b  #$C,height_pixels(a1)
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsl.w   #4,d0
                move.w  d0,$34(a1)
                move.w  $30(a0),$30(a1)
                move.w  $32(a0),$32(a1)

loc_40366:
                move.w  #1,$34(a0)

locret_4036C:
                rts
; End of function SpawnSozTimedSandBlock

; ---------------------------------------------------------------------------

loc_4036E:
                move.w  x_pos(a0),-(sp)
                jsr     (MoveSprite).l
                cmpi.w  #$200,y_vel(a0)
                blt.s   loc_403A0
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.s   loc_403A0
                add.w   d1,y_pos(a0)
                move.l  #loc_403DC,(a0)
                move.w  #-$100,x_vel(a0)
                move.w  #0,y_vel(a0)

loc_403A0:
                move.w  (sp)+,d4

loc_403A2:
                move.w  #$18,d1
                move.w  #$D,d3
                jsr     (SolidObjectTop).l

loc_403B0:
                move.w  $30(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmp.w   $32(a0),d0
                bhi.w   loc_403CA
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_403CA:
                move.w  respawn_addr(a0),d0
                beq.s   loc_403D6
                movea.w d0,a2
                bclr    #7,(a2)

loc_403D6:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_403DC:
                subq.w  #1,$34(a0)
                bne.s   loc_403F4
                move.w  y_pos(a0),$46(a0)
                move.w  #0,x_vel(a0)
                move.l  #loc_4040C,(a0)

loc_403F4:
                move.w  x_pos(a0),-(sp)
                jsr     (MoveSprite2).l
                jsr     (ObjCheckFloorDist).l
                add.w   d1,y_pos(a0)
                move.w  (sp)+,d4
                bra.s   loc_403A2
; ---------------------------------------------------------------------------

loc_4040C:
                jsr     (MoveSprite2).l
                addi.w  #8,y_vel(a0)
                move.w  $46(a0),d0
                addi.w  #$12,d0
                cmp.w   $14(a0),d0
                bhs.s   loc_40432
                move.w  #$7F00,x_pos(a0)
                move.w  #$7F00,$30(a0)

loc_40432:
                move.w  x_pos(a0),d4
                bra.w   loc_403A2
; ---------------------------------------------------------------------------
Map_SOZSpawningSandBlocks:
                include "src/objects/shared/zones/soz/mappings/spawning_sand_blocks.s"
