; Owner: objects/zones/ssz/sk
; Responsibility: Floating platform motion and player riding
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_SSZFloatingPlatform:
                move.l  #loc_44AA0,(a0)
                move.b  #4,render_flags(a0)
                move.b  #$11,height_pixels(a0)
                move.b  #$20,width_pixels(a0)
                move.w  #$180,priority(a0)
                move.w  #make_art_tile(ArtTile_SSZMisc,2,0),art_tile(a0)
                move.l  #Map_SSZFloatingPlatform,mappings(a0)
                move.b  #1,mapping_frame(a0)
                move.w  y_pos(a0),y_vel(a0)

loc_44AA0:
                move.w  $2E(a0),d0
                move.b  status(a0),d1
                andi.w  #standing_mask,d1
                bne.s   loc_44AB6
                tst.w   d0
                beq.s   loc_44ABE
                subq.w  #1,d0
                bra.s   loc_44ABE
; ---------------------------------------------------------------------------

loc_44AB6:
                cmpi.w  #4,d0
                bhs.s   loc_44ABE
                addq.w  #1,d0

loc_44ABE:
                move.w  d0,$2E(a0)
                add.w   $1A(a0),d0
                move.w  d0,y_pos(a0)
                moveq   #$2B,d1
                moveq   #$11,d2
                moveq   #$11,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectTop).l
                jmp     (Sprite_OnScreen_Test).l
; End of function Obj_SSZFloatingPlatform
