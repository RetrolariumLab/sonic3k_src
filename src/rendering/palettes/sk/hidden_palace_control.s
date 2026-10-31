; Owner: rendering/palettes/sk
; Responsibility: Hidden Palace scene palette selection, transfer and private palette pointer index
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_HPZPaletteControl:
                move.w  $3A(a0),d0
                moveq   #0,d1
                cmpi.w  #$460,(Camera_X_pos).w
                blo.s   loc_656B8
                moveq   #4,d1

loc_656B8:
                move.w  d1,$3A(a0)
                cmp.w   d0,d1
                beq.s   locret_656D0
                movea.l HPZPaletteControl_PalIndex(pc,d1.w),a1
                lea     (Normal_palette_line_2).w,a2
                moveq   #bytesToLcnt($60),d0

loc_656CA:
                move.l  (a1)+,(a2)+
                dbf     d0,loc_656CA

locret_656D0:
                rts
; ---------------------------------------------------------------------------
HPZPaletteControl_PalIndex:
                dc.l    Pal_HPZIntro
                dc.l    Pal_HPZ
