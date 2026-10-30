; Owner: objects/bonus/pachinko/sk
; Responsibility: Pachinko invisible object placement and preserved state or collision response
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_PachinkoInvisibleUnknown:
                move.l  #Map_PachinkoInvisibleUnknown,mappings(a0)
                move.w  #make_art_tile(ArtTile_PachinkoMain+$97,3,1),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.b  #$88,width_pixels(a0)
                move.b  #8,height_pixels(a0)
                move.w  #$80,priority(a0)
                move.l  #loc_4A0C6,(a0)

loc_4A0C6:
                movea.w $3E(a0),a1
                move.b  angle(a0),d0
                jsr     (GetSineCosine).l
                asr.w   #4,d0
                add.w   y_pos(a1),d0
                move.w  d0,y_pos(a0)
                moveq   #0,d0
                move.b  angle(a0),d0
                addi.b  #$10,d0
                lsr.w   #5,d0
                move.b  RawAni_4A110(pc,d0.w),mapping_frame(a0)
                addi.b  #$84,angle(a0)
                addi.w  #2,x_pos(a0)
                cmpi.w  #$178,x_pos(a0)
                bls.s   loc_4A10A
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_4A10A:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
RawAni_4A110:
                dc.b    0,   1,   2,   3,   4,   3,   2,   1
                even
Map_PachinkoInvisibleUnknown:
                include "src/objects/shared/zones/pachinko/map_invisible_unknown.s"
; End of function Obj_PachinkoInvisibleUnknown
