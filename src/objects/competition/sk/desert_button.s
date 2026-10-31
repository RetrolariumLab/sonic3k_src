; Owner: objects/competition/sk
; Responsibility: Desert Palace button state, trigger behavior and mapping resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_DPZButton:
                move.l  #Map_DPZButton,mappings(a0)
                move.w  #make_art_tile(ArtTile_DPZMisc,2,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.w  #$280,priority(a0)
                move.b  #$C,width_pixels(a0)
                move.b  #8,height_pixels(a0)
                move.l  #loc_362CE,(a0)

loc_362CE:
                move.w  #$C,d1
                move.w  #2,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectTop).l
                lea     (Normal_palette_line_3+$1C).w,a2
                move.b  #0,mapping_frame(a0)
                move.b  subtype(a0),d0
                andi.w  #$F,d0
                lea     (Level_trigger_array).w,a3
                lea     (a3,d0.w),a3
                moveq   #0,d3
                move.b  status(a0),d0
                andi.b  #standing_mask,d0
                bne.s   loc_36310
                bclr    d3,(a3)
                move.l  #$2E000A,(a2)
                bra.s   loc_3634A
; ---------------------------------------------------------------------------

loc_36310:
                tst.b   (a3)
                bne.s   loc_36322
                moveq   #signextendB(sfx_Switch),d0
                jsr     (Play_SFX).l
                move.b  #0,anim_frame_timer(a0)

loc_36322:
                bset    d3,(a3)
                move.b  #1,mapping_frame(a0)
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   loc_3634A
                move.b  #3,anim_frame_timer(a0)
                move.w  (a2),d0
                move.l  #$2E000A,(a2)
                cmpi.w  #$2E,d0
                bne.s   loc_3634A
                move.l  #$C2E0A0E,(a2)

loc_3634A:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
Map_DPZButton:
                include "src/objects/shared/zones/dpz/mappings/button.s"
; End of function Obj_DPZButton
