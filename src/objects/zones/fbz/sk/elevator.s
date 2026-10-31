; Owner: objects/zones/fbz/sk
; Responsibility: Elevator movement, player riding and trigger state
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_FBZElevator:
                move.l  #loc_3CA20,(a0)

loc_3CA20:
                subq.w  #1,$30(a0)
                bpl.s   loc_3CA8C
                move.w  #$5F,$30(a0)
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   loc_3CA8C
                move.l  #loc_3CA92,(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.l  #Map_FBZElevator,mappings(a1)
                move.w  #make_art_tile(ArtTile_FBZMisc2,2,0),art_tile(a1)
                ori.b   #4,render_flags(a1)
                move.b  #$30,width_pixels(a1)
                move.b  #$20,height_pixels(a1)
                move.w  #$80,priority(a1)
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsl.w   #3,d0
                move.w  d0,$30(a1)
                move.w  #1,y_vel(a1)
                btst    #0,status(a0)
                bne.s   loc_3CA8C
                neg.w   y_vel(a1)

loc_3CA8C:
                jmp     (Delete_Sprite_If_Not_In_Range).l
; ---------------------------------------------------------------------------

loc_3CA92:
                subq.w  #1,$30(a0)
                bpl.s   loc_3CA9E
                move.w  #$7F00,x_pos(a0)

loc_3CA9E:
                move.w  y_vel(a0),d0
                add.w   d0,y_pos(a0)
                move.w  #$3B,d1
                move.w  #$10,d2
                move.w  x_pos(a0),d4
                lea     (byte_3CAD0).l,a2
                jsr     (sub_1DD0E).l
                tst.w   y_vel(a0)
                bmi.s   loc_3CACA
                jsr     (CheckPlayerReleaseFromObj).l

loc_3CACA:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------
byte_3CAD0:
                dc.b    $10, $10, $10, $10, $10, $10, $10, $11, $12, $12, $13, $13, $13, $14, $14, $14, $15, $15, $15, $16
                dc.b    $16, $16, $17, $17, $17, $18, $18, $18, $19, $19, $19, $1A, $1A, $1A, $1B, $1B, $1B, $1C, $1C, $1C
                dc.b    $1D, $1D, $1D, $1E, $1E, $1E, $1F, $1F, $1F, $20, $20, $20, $21, $21, $21, $21, $21, $21, $21, $21
                even
Map_FBZElevator:
                include "src/objects/shared/zones/fbz/mappings/elevator.s"
; End of function Obj_FBZElevator
