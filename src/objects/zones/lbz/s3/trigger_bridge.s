; Owner: objects/zones/lbz/s3
; Responsibility: Launch Base triggered bridge activation, movement and player collision
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------
byte_24BE4:                                             ; X offset, Y offset, X width, Y width, init routine counter, init mapping frame, second routine counter, second mapping frame
                dc.b    $48,   0,   8, $40,   0,   0,  $A,   8
                dc.b    0, $48, $40,   8,   0,   8,  $A, $10
                dc.b    -$48,   0,   8, $40,   0,   0,  $A,   8
                dc.b    0, $48, $40,   8,   0, $10,  $A, $18
                dc.b    0, $48, $40,   8,   6,   8,   4, $10
                dc.b    $48,   0,   8, $40,   6,   0,   4,   8
                dc.b    0, $48, $40,   8,   6, $10,   4, $18
                dc.b    -$48,   0,   8, $40,   6,   0,   4,   8
                even
; ---------------------------------------------------------------------------

Obj_LBZTriggerBridge:
                move.b  subtype(a0),d0
                move.b  d0,d1
                andi.w  #$F,d1
                tst.b   $34(a0)
                bne.s   loc_24C40
                lea     (Level_trigger_array).w,a3
                tst.b   (a3,d0.w)
                beq.s   loc_24C40
                addq.w  #4,d0

loc_24C40:
                lsr.b   #1,d0
                andi.w  #$38,d0
                lea     byte_24BE4(pc,d0.w),a1
                move.l  #Map_LBZTriggerBridge,mappings(a0)
                move.w  #make_art_tile(ArtTile_LBZMisc,2,0),art_tile(a0)
                move.b  #4,render_flags(a0)
                move.w  #$200,priority(a0)
                move.w  x_pos(a0),$30(a0)
                move.w  y_pos(a0),$32(a0)
                move.b  (a1)+,d0
                ext.w   d0
                add.w   $30(a0),d0
                move.w  d0,x_pos(a0)
                move.b  (a1)+,d0
                ext.w   d0
                add.w   $32(a0),d0
                move.w  d0,y_pos(a0)
                move.b  (a1)+,width_pixels(a0)
                move.b  (a1)+,height_pixels(a0)
                moveq   #0,d0
                move.b  (a1)+,d0
                move.w  d0,$36(a0)
                move.b  (a1)+,mapping_frame(a0)
                tst.b   $34(a0)
                beq.s   loc_24CB2
                move.b  (a1)+,d0
                move.w  d0,$36(a0)
                move.b  (a1)+,mapping_frame(a0)
                move.b  #0,$34(a0)

loc_24CB2:
                move.l  #loc_24CB8,(a0)

loc_24CB8:
                move.w  $36(a0),d0
                move.w  off_24CF2(pc,d0.w),d1
                jsr     off_24CF2(pc,d1.w)
                tst.b   render_flags(a0)
                bpl.s   loc_24CE8
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                addi.w  #$B,d1
                moveq   #0,d2
                move.b  height_pixels(a0),d2
                move.w  d2,d3
                addq.w  #1,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull2).l

loc_24CE8:
                move.w  $30(a0),d0
                jmp     (Sprite_OnScreen_Test2).l
; ---------------------------------------------------------------------------
off_24CF2:
                dc.w    loc_24CFE-off_24CF2
                dc.w    loc_24D58-off_24CF2
                dc.w    loc_24D6A-off_24CF2
                dc.w    loc_24D8C-off_24CF2
                dc.w    loc_24D58-off_24CF2
                dc.w    loc_24D7A-off_24CF2
; ---------------------------------------------------------------------------

loc_24CFE:
                move.b  subtype(a0),d0
                andi.w  #$F,d0
                lea     (Level_trigger_array).w,a3
                tst.b   (a3,d0.w)
                beq.s   locret_24D56
                addq.b  #1,mapping_frame(a0)
                move.w  #7,$38(a0)
                addq.w  #2,$36(a0)
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   locret_24D56
                move.l  #Obj_LBZTriggerBridge,(a1)
                move.w  $30(a0),x_pos(a1)
                move.w  $32(a0),y_pos(a1)
                move.b  subtype(a0),d0
                addi.b  #$40,d0
                andi.b  #$7F,d0
                move.b  d0,subtype(a1)
                move.w  #8,$38(a1)
                move.b  #1,$34(a1)

locret_24D56:
                rts
; ---------------------------------------------------------------------------

loc_24D58:
                addq.b  #1,mapping_frame(a0)
                subq.w  #1,$38(a0)
                bne.s   locret_24D68
                move.w  #$7FFF,x_pos(a0)

locret_24D68:
                rts
; ---------------------------------------------------------------------------

loc_24D6A:
                subq.b  #1,mapping_frame(a0)
                subq.w  #1,$38(a0)
                bne.s   locret_24D78
                addq.w  #2,$36(a0)

locret_24D78:
                rts
; ---------------------------------------------------------------------------

loc_24D7A:
                subq.b  #1,mapping_frame(a0)
                subq.w  #1,$38(a0)
                bne.s   locret_24D8A
                move.w  #0,$36(a0)

locret_24D8A:
                rts
; ---------------------------------------------------------------------------

loc_24D8C:
                move.b  subtype(a0),d0
                andi.w  #$F,d0
                lea     (Level_trigger_array).w,a3
                tst.b   (a3,d0.w)
                bne.s   locret_24DE4
                addq.b  #1,mapping_frame(a0)
                move.w  #7,$38(a0)
                addq.w  #2,$36(a0)
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   locret_24DE4
                move.l  #Obj_LBZTriggerBridge,(a1)
                move.w  $30(a0),x_pos(a1)
                move.w  $32(a0),y_pos(a1)
                move.b  subtype(a0),d0
                addi.b  #$40,d0
                andi.b  #$7F,d0
                move.b  d0,subtype(a1)
                move.w  #8,$38(a1)
                move.b  #1,$34(a1)

locret_24DE4:
                rts
; ---------------------------------------------------------------------------
Map_LBZTriggerBridge:
                include "src/objects/shared/zones/lbz/map_trigger_bridge.s"
