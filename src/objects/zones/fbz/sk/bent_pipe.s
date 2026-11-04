; Owner: objects/zones/fbz/sk
; Responsibility: Bent pipe initialization, player contact and display
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------
SKFBZBentPipe_SubtypeDimensions:
                dc.b    $18, $10
                dc.b    $10,   8
                dc.b    $18, $10
                even
; ---------------------------------------------------------------------------

Obj_FBZBentPipe:
                move.l  #Map_FBZBentPipe,mappings(a0)
                move.w  #make_art_tile(ArtTile_FBZMisc+$F2,1,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.w  #$200,priority(a0)
                move.b  subtype(a0),d0
                move.b  d0,mapping_frame(a0)
                andi.w  #3,d0
                add.w   d0,d0
                move.b  SKFBZBentPipe_SubtypeDimensions(pc,d0.w),width_pixels(a0)
                move.b  SKFBZBentPipe_SubtypeDimensions+1(pc,d0.w),height_pixels(a0)
                move.l  #SKFBZBentPipe_ResolveSolidAndDraw,(a0)

SKFBZBentPipe_ResolveSolidAndDraw:
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
Map_FBZBentPipe:
                include "src/objects/shared/zones/fbz/mappings/bent_pipe.s"
; End of function Obj_FBZBentPipe
