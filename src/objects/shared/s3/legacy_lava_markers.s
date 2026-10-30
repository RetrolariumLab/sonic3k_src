; Owner: objects/shared/s3
; Responsibility: Preserved legacy lava marker state and normal or debug sprite mappings
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------
byte_1C700:
                dc.b    $96
                dc.b    $94
                dc.b    $95
                even
; ---------------------------------------------------------------------------

Obj_S2LavaMarker:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.b  byte_1C700(pc,d0.w),collision_flags(a0)
                move.l  #Map_S2LavaMarker,mappings(a0)
                tst.w   (Debug_placement_mode).w
                beq.s   loc_1C726
                move.l  #Map_S2LavaMarkerDebug,mappings(a0)

loc_1C726:
                move.w  #make_art_tile(ArtTile_Ring,0,1),art_tile(a0)
                move.b  #$84,render_flags(a0)
                move.b  #$80,width_pixels(a0)
                move.b  #$80,height_pixels(a0)
                move.w  #$200,priority(a0)
                move.b  subtype(a0),mapping_frame(a0)
                move.l  #loc_1C750,(a0)

loc_1C750:
                tst.w   (Competition_mode).w
                bne.s   loc_1C76A
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   loc_1C778

loc_1C76A:
                tst.w   (Debug_placement_mode).w
                beq.s   locret_1C776
                jsr     (Draw_Sprite).l

locret_1C776:
                rts
; ---------------------------------------------------------------------------

loc_1C778:
                move.w  respawn_addr(a0),d0
                beq.s   loc_1C784
                movea.w d0,a2
                bclr    #7,(a2)

loc_1C784:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------
Map_S2LavaMarker:
                include "src/objects/shared/level_misc/map_lava_marker_s2.s"
Map_S2LavaMarkerDebug:
                include "src/objects/shared/level_misc/map_lava_marker_s2_debug.s"
