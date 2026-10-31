; Owner: objects/ending/sk
; Responsibility: Player-dependent plane attachment mapping, parent priority and adjusted child drawing
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_5EB32:
                move.l  #loc_5EBB4,(a0)
                movea.w parent3(a0),a1
                move.w  priority(a1),priority(a0)
                move.b  #$20,width_pixels(a0)
                move.b  #$20,height_pixels(a0)
                btst    #2,render_flags(a1)
                beq.s   loc_5EB5C
                bset    #2,render_flags(a0)

loc_5EB5C:
                move.w  (Player_mode).w,d0
                add.w   d0,d0
                move.w  off_5EB6A(pc,d0.w),d0
                jmp     off_5EB6A(pc,d0.w)
; ---------------------------------------------------------------------------
off_5EB6A:
                dc.w    loc_5EB72-off_5EB6A
                dc.w    loc_5EB72-off_5EB6A
                dc.w    loc_5EB88-off_5EB6A
                dc.w    loc_5EB9E-off_5EB6A
; ---------------------------------------------------------------------------

loc_5EB72:
                move.l  #Map_SonicPlane,mappings(a0)
                move.w  #make_art_tile(ArtTile_Ending_Plane,0,1),art_tile(a0)
                move.b  #$C,mapping_frame(a0)
                rts
; ---------------------------------------------------------------------------

loc_5EB88:
                move.l  #Map_SonicPlaneEnding,mappings(a0)
                move.w  #make_art_tile(ArtTile_Ending_PlaneExtra,0,1),art_tile(a0)
                move.b  #$B,mapping_frame(a0)
                rts
; ---------------------------------------------------------------------------

loc_5EB9E:
                move.l  #Map_SonicPlaneEnding,mappings(a0)
                move.w  #make_art_tile(ArtTile_Ending_PlaneExtra,0,1),art_tile(a0)
                move.b  #$12,mapping_frame(a0)
                rts
; ---------------------------------------------------------------------------

loc_5EBB4:
                jsr     (Child_GetPriority).l
                jsr     (Refresh_ChildPositionAdjusted).l
                jmp     (Child_Draw_Sprite).l
