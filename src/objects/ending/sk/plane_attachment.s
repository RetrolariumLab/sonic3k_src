; Owner: objects/ending/sk
; Responsibility: Player-dependent plane attachment mapping, parent priority and adjusted child drawing
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

EndPlaneChild_InitFromParent:
                move.l  #EndPlaneChild_FollowWithParentPriority,(a0)
                movea.w parent3(a0),a1
                move.w  priority(a1),priority(a0)
                move.b  #$20,width_pixels(a0)
                move.b  #$20,height_pixels(a0)
                btst    #2,render_flags(a1)
                beq.s   EndingPlaneAttachment_SelectModeGraphics
                bset    #2,render_flags(a0)

EndingPlaneAttachment_SelectModeGraphics:
                move.w  (Player_mode).w,d0
                add.w   d0,d0
                move.w  EndPlaneChild_ModeGraphicsOffsets(pc,d0.w),d0
                jmp     EndPlaneChild_ModeGraphicsOffsets(pc,d0.w)
; ---------------------------------------------------------------------------
EndPlaneChild_ModeGraphicsOffsets:
                dc.w    EndPlaneChild_SetDefaultGraphics-EndPlaneChild_ModeGraphicsOffsets
                dc.w    EndPlaneChild_SetDefaultGraphics-EndPlaneChild_ModeGraphicsOffsets
                dc.w    EndPlaneChild_SetTailsGraphics-EndPlaneChild_ModeGraphicsOffsets
                dc.w    EndPlaneChild_SetKnucklesGraphics-EndPlaneChild_ModeGraphicsOffsets
; ---------------------------------------------------------------------------

EndPlaneChild_SetDefaultGraphics:
                move.l  #Map_SonicPlane,mappings(a0)
                move.w  #make_art_tile(ArtTile_Ending_Plane,0,1),art_tile(a0)
                move.b  #$C,mapping_frame(a0)
                rts
; ---------------------------------------------------------------------------

EndPlaneChild_SetTailsGraphics:
                move.l  #Map_SonicPlaneEnding,mappings(a0)
                move.w  #make_art_tile(ArtTile_Ending_PlaneExtra,0,1),art_tile(a0)
                move.b  #$B,mapping_frame(a0)
                rts
; ---------------------------------------------------------------------------

EndPlaneChild_SetKnucklesGraphics:
                move.l  #Map_SonicPlaneEnding,mappings(a0)
                move.w  #make_art_tile(ArtTile_Ending_PlaneExtra,0,1),art_tile(a0)
                move.b  #$12,mapping_frame(a0)
                rts
; ---------------------------------------------------------------------------

EndPlaneChild_FollowWithParentPriority:
                jsr     (Child_GetPriority).l
                jsr     (Refresh_ChildPositionAdjusted).l
                jmp     (Child_Draw_Sprite).l
