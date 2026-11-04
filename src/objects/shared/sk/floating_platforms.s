; Owner: objects/shared/sk
; Responsibility: Shared floating platform movement and riding with Marble Garden, Hydrocity and Angel Island mappings
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------
SKFloatPlatform_ShapeRecords:
                dc.b    $20, $20,   0
                even
                dc.b    $18,  $C,   0
                even
                dc.b    $20, $14,   0
                even
; ---------------------------------------------------------------------------

Obj_FloatingPlatform:
                cmpi.w  #0,(Current_zone_and_act).w
                bne.s   SKFloatPlatform_TryAIZ2Art
                move.l  #Map_AIZFloatingPlatform,mappings(a0)
                move.w  #make_art_tile(ArtTile_AIZFloatingPlatform,2,0),art_tile(a0)

SKFloatPlatform_TryAIZ2Art:
                cmpi.w  #1,(Current_zone_and_act).w
                bne.s   SKFloatPlatform_TryHCZArt
                move.l  #Map_AIZFloatingPlatform,mappings(a0)
                move.w  #make_art_tile(ArtTile_AIZ2FloatingPlatform,2,0),art_tile(a0)

SKFloatPlatform_TryHCZArt:
                cmpi.b  #1,(Current_zone).w
                bne.s   SKFloatPlatform_TryMGZArt
                move.l  #Map_HCZFloatingPlatform,mappings(a0)
                move.w  #make_art_tile(ArtTile_HCZMisc+$53,2,0),art_tile(a0)

SKFloatPlatform_TryMGZArt:
                cmpi.b  #2,(Current_zone).w
                bne.s   SKFloatPlatform_InitShapeAndAnchors
                move.l  #Map_MGZFloatingPlatform,mappings(a0)
                move.w  #make_art_tile($001,2,0),art_tile(a0)

SKFloatPlatform_InitShapeAndAnchors:
                move.b  #4,render_flags(a0)
                move.w  #$180,priority(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsr.w   #2,d0
                andi.w  #$1C,d0
                lea     SKFloatPlatform_ShapeRecords(pc,d0.w),a2
                move.b  (a2)+,width_pixels(a0)
                move.b  (a2)+,height_pixels(a0)
                move.b  (a2)+,mapping_frame(a0)
                move.w  x_pos(a0),$30(a0)
                move.w  x_pos(a0),$32(a0)
                move.w  y_pos(a0),$34(a0)
                move.b  status(a0),$2E(a0)
                move.w  #$280,$42(a0)
                move.w  x_pos(a0),$44(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                andi.w  #$F,d0
                subq.w  #8,d0
                bcs.s   SKFloatPlatform_StoreMotionOffset
                cmpi.w  #4,d0
                bhs.s   SKFloatPlatform_WidenCullWindow
                lsl.w   #2,d0
                lea     (Oscillating_table+$2C).w,a2
                lea     (a2,d0.w),a2
                tst.w   (a2)
                bpl.s   SKFloatPlatform_StoreMotionOffset
                bchg    #0,$2E(a0)
                bra.s   SKFloatPlatform_StoreMotionOffset
; ---------------------------------------------------------------------------

; Set range $380 and move the saved X anchor by $100 for the wide motion selectors
SKFloatPlatform_WidenCullWindow:
                move.w  #$380,$42(a0)
                addi.w  #$100,$44(a0)

SKFloatPlatform_StoreMotionOffset:
                move.b  subtype(a0),d0
                andi.b  #$F,d0
                add.b   d0,d0
                move.b  d0,subtype(a0)
                move.l  #SKFloatPlatform_MoveAndCarryRiders,(a0)

; Pass the old X to top collision after movement. The previous render sign gates rider handling
SKFloatPlatform_MoveAndCarryRiders:
                move.w  x_pos(a0),-(sp)
                moveq   #0,d0
                move.b  subtype(a0),d0
                lea     (FloatingPlatformIndex).l,a1
                move.w  (a1,d0.w),d1
                jsr     (a1,d1.w)
                move.w  (sp)+,d4
                tst.b   render_flags(a0)
                bpl.s   SKFloatPlatform_CullByAnchorX
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                moveq   #0,d3
                move.b  height_pixels(a0),d3
                addq.w  #1,d3
                jsr     (SolidObjectTop).l

SKFloatPlatform_CullByAnchorX:
                move.w  $44(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmp.w   $42(a0),d0
                bhi.w   SKFloatPlatform_ClearLoadedBit
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKFloatPlatform_ClearLoadedBit:
                move.w  respawn_addr(a0),d0
                beq.s   SKFloatPlatform_DeleteOutsideRange
                movea.w d0,a2
                bclr    #7,(a2)

SKFloatPlatform_DeleteOutsideRange:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------
Map_MGZFloatingPlatform:
                include "src/objects/shared/zones/mgz/mappings/floating_platform.s"
Map_HCZFloatingPlatform:
                include "src/objects/shared/zones/hcz/mappings/floating_platform.s"
Map_AIZFloatingPlatform:
                include "src/objects/shared/zones/aiz/mappings/floating_platform.s"
; End of function Obj_FloatingPlatform
