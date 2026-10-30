; Owner: objects/zones/soz/sk
; Responsibility: Door trigger state, opening, motion and player collision
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_SOZDoor:
                move.l  #Map_SOZDoor,mappings(a0)
                move.w  #make_art_tile(ArtTile_SOZMisc+$8C,2,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.b  #$C,width_pixels(a0)
                move.b  #$40,height_pixels(a0)
                move.w  #$200,priority(a0)
                move.w  x_pos(a0),$44(a0)
                move.w  y_pos(a0),$46(a0)
                move.b  subtype(a0),d0
                andi.w  #$F,d0
                lea     (Level_trigger_array).w,a3
                move.b  (a3,d0.w),d0
                move.w  d0,$36(a0)
                move.b  subtype(a0),d0
                andi.w  #$F0,d0
                beq.s   loc_41BDA
                move.b  #1,mapping_frame(a0)
                move.b  #$40,width_pixels(a0)
                move.b  #$C,height_pixels(a0)
                move.l  #loc_41C3A,(a0)
                bra.s   loc_41C3A
; ---------------------------------------------------------------------------

loc_41BDA:
                move.l  #loc_41BE0,(a0)

loc_41BE0:
                move.b  subtype(a0),d0
                andi.w  #$F,d0
                lea     (Level_trigger_array).w,a3
                move.b  (a3,d0.w),d0
                moveq   #1,d1
                cmp.w   $36(a0),d0
                beq.s   loc_41C00
                bcc.s   loc_41BFC
                neg.w   d1

loc_41BFC:
                add.w   d1,$36(a0)

loc_41C00:
                move.w  $36(a0),d0
                btst    #0,status(a0)
                bne.s   loc_41C0E
                neg.w   d0

loc_41C0E:
                add.w   $46(a0),d0
                move.w  d0,y_pos(a0)

loc_41C16:
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                addi.w  #$B,d1
                moveq   #0,d2
                move.b  height_pixels(a0),d2
                move.w  d2,d3
                addq.w  #1,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

loc_41C3A:
                move.b  subtype(a0),d0
                andi.w  #$F,d0
                lea     (Level_trigger_array).w,a3
                move.b  (a3,d0.w),d0
                moveq   #1,d1
                cmp.w   $36(a0),d0
                beq.s   loc_41C5A
                bcc.s   loc_41C56
                neg.w   d1

loc_41C56:
                add.w   d1,$36(a0)

loc_41C5A:
                move.w  $36(a0),d0
                btst    #0,status(a0)
                bne.s   loc_41C68
                neg.w   d0

loc_41C68:
                add.w   $44(a0),d0
                move.w  d0,x_pos(a0)
                bra.s   loc_41C16
; ---------------------------------------------------------------------------
Map_SOZDoor:
                include "src/objects/shared/zones/soz/map_door.s"
; End of function Obj_SOZDoor
