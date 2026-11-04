; Owner: objects/zones/fbz/sk
; Responsibility: Piston movement, player collision and mapping resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_FBZPiston:
                move.l  #Map_FBZPiston,mappings(a0)
                move.w  #make_art_tile(ArtTile_FBZOutdoors+$36,1,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.b  #$20,width_pixels(a0)
                move.b  #$20,height_pixels(a0)
                move.w  #$280,priority(a0)
                move.w  x_pos(a0),$44(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsl.w   #3,d0
                move.w  d0,$34(a0)
                andi.w  #$FF80,d0
                addi.w  #$200,d0
                move.w  d0,$36(a0)
                move.l  #SKFBZPiston_SaveXAndRetract,(a0)

SKFBZPiston_SaveXAndRetract:
                move.w  x_pos(a0),-(sp)
                tst.b   $30(a0)
                beq.s   SKFBZPiston_ExtendToLimit
                subq.w  #2,$32(a0)
                bne.s   SKFBZPiston_PlaceAndResolveSolid
                move.b  #0,$30(a0)
                bra.s   SKFBZPiston_PlaceAndResolveSolid
; ---------------------------------------------------------------------------

SKFBZPiston_ExtendToLimit:
                addq.w  #2,$32(a0)
                move.w  $34(a0),d0
                cmp.w   $32(a0),d0
                bne.s   SKFBZPiston_PlaceAndResolveSolid
                move.b  #1,$30(a0)

SKFBZPiston_PlaceAndResolveSolid:
                move.w  $32(a0),d0
                neg.w   d0
                add.w   $44(a0),d0
                move.w  d0,x_pos(a0)
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                addi.w  #$B,d1
                moveq   #0,d2
                move.b  height_pixels(a0),d2
                move.w  d2,d3
                addq.w  #1,d3
                move.w  (sp)+,d4
                jsr     (SolidObjectFull).l
                move.w  $44(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmp.w   $36(a0),d0
                bhi.w   SKFBZPiston_ClearRespawnBit
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKFBZPiston_ClearRespawnBit:
                move.w  respawn_addr(a0),d0
                beq.s   SKFBZPiston_DeleteOutOfRange
                movea.w d0,a2
                bclr    #7,(a2)

SKFBZPiston_DeleteOutOfRange:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------
Map_FBZPiston:
                include "src/objects/shared/zones/fbz/mappings/piston.s"
; End of function Obj_FBZPiston
