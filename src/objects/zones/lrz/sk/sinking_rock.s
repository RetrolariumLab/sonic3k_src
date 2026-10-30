; Owner: objects/zones/lrz/sk
; Responsibility: Sinking rock state, motion and player collision
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_LRZSinkingRock:
                move.l  #Map_LRZSinkingRock,mappings(a0)
                move.w  #make_art_tile($0D3,2,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #$10,height_pixels(a0)
                move.w  #$280,priority(a0)
                move.w  y_pos(a0),$46(a0)
                tst.b   (Current_act).w
                beq.s   loc_427DC
                move.b  #1,mapping_frame(a0)
                move.w  #make_art_tile($090,2,0),art_tile(a0)

loc_427DC:
                move.l  #loc_427E2,(a0)

loc_427E2:
                move.b  status(a0),d0
                andi.b  #standing_mask,d0
                bne.s   loc_427F8
                tst.b   $2E(a0)
                beq.s   loc_42804
                subq.b  #1,$2E(a0)
                bra.s   loc_42804
; ---------------------------------------------------------------------------

loc_427F8:
                cmpi.b  #$40,$2E(a0)
                beq.s   loc_42804
                addq.b  #1,$2E(a0)

loc_42804:
                move.b  $2E(a0),d0
                jsr     (GetSineCosine).l
                asr.w   #3,d0
                add.w   $46(a0),d0
                move.w  d0,y_pos(a0)
                move.w  #$1B,d1
                move.w  #$10,d2
                move.w  #$11,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------
Map_LRZSinkingRock:
                include "src/objects/shared/zones/lrz/map_sinking_rock.s"
; End of function Obj_LRZSinkingRock
