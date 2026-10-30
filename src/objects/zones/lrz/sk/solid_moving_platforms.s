; Owner: objects/zones/lrz/sk
; Responsibility: Lava Reef solid platform subtype geometry, movement, player riding and mapping resources
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------
byte_25826:
                dc.b    $20, $20, 0
                even
                dc.b    $20, $20, 1
                even
; ---------------------------------------------------------------------------

Obj_LRZSolidMovingPlatforms:
                move.l  #Map_LRZSolidMovingPlatforms,mappings(a0)
                move.w  #make_art_tile($090,2,0),art_tile(a0)
                move.b  #4,render_flags(a0)
                move.w  #$180,priority(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsr.w   #2,d0
                andi.w  #$1C,d0
                lea     byte_25826(pc,d0.w),a2
                move.b  (a2)+,width_pixels(a0)
                move.b  (a2)+,height_pixels(a0)
                move.b  (a2)+,mapping_frame(a0)
                move.w  x_pos(a0),$30(a0)
                move.w  y_pos(a0),$34(a0)
                move.b  subtype(a0),d0
                andi.w  #$F,d0
                add.w   d0,d0
                move.w  off_258BC(pc,d0.w),d0
                lea     off_258BC(pc,d0.w),a1
                move.l  a1,$42(a0)
                move.l  #loc_2588C,(a0)

loc_2588C:
                move.w  x_pos(a0),-(sp)
                movea.l $42(a0),a1
                jsr     (a1)
                move.w  (sp)+,d4
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                addi.w  #$B,d1
                moveq   #0,d2
                move.b  height_pixels(a0),d2
                move.w  d2,d3
                addq.w  #1,d3
                jsr     (SolidObjectFull).l
                move.w  $30(a0),d0
                jmp     (Sprite_OnScreen_Test2).l
; ---------------------------------------------------------------------------
off_258BC:
                dc.w    locret_258CE-off_258BC
                dc.w    loc_258D0-off_258BC
                dc.w    loc_258DC-off_258BC
                dc.w    loc_25924-off_258BC
                dc.w    loc_258FA-off_258BC
                dc.w    loc_25906-off_258BC
                dc.w    loc_25938-off_258BC
                dc.w    loc_2594C-off_258BC
                dc.w    loc_25960-off_258BC
; ---------------------------------------------------------------------------

locret_258CE:
                rts
; ---------------------------------------------------------------------------

loc_258D0:
                moveq   #0,d0
                move.b  (Oscillating_table+$0A).w,d0
                subi.w  #$20,d0
                bra.s   loc_258E6
; ---------------------------------------------------------------------------

loc_258DC:
                moveq   #0,d0
                move.b  (Oscillating_table+$1E).w,d0
                subi.w  #$40,d0

loc_258E6:
                btst    #0,status(a0)
                beq.s   loc_258F0
                neg.w   d0

loc_258F0:
                add.w   $30(a0),d0
                move.w  d0,x_pos(a0)
                rts
; ---------------------------------------------------------------------------

loc_258FA:
                moveq   #0,d0
                move.b  (Oscillating_table+$0A).w,d0
                subi.w  #$20,d0
                bra.s   loc_25910
; ---------------------------------------------------------------------------

loc_25906:
                moveq   #0,d0
                move.b  (Oscillating_table+$1E).w,d0
                subi.w  #$40,d0

loc_25910:
                btst    #0,status(a0)
                beq.s   loc_2591A
                neg.w   d0

loc_2591A:
                add.w   $34(a0),d0
                move.w  d0,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

loc_25924:
                move.w  #$5F,d2
                bsr.s   sub_25974
                subi.w  #$60,d0
                add.w   $30(a0),d0
                move.w  d0,x_pos(a0)
                rts
; ---------------------------------------------------------------------------

loc_25938:
                move.w  #$5F,d2
                bsr.s   sub_25974
                subi.w  #$60,d0
                add.w   $34(a0),d0
                move.w  d0,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

loc_2594C:
                move.w  #$7F,d2
                bsr.s   sub_25974
                subi.w  #$80,d0
                add.w   $30(a0),d0
                move.w  d0,x_pos(a0)
                rts
; ---------------------------------------------------------------------------

loc_25960:
                move.w  #$7F,d2
                bsr.s   sub_25974
                subi.w  #$80,d0
                add.w   $34(a0),d0
                move.w  d0,y_pos(a0)
                rts

; =============== S U B R O U T I N E =======================================

sub_25974:
                tst.b   $3C(a0)
                bne.s   loc_25996
                move.w  $40(a0),d1
                addq.w  #4,d1
                move.w  d1,$40(a0)
                add.w   d1,$36(a0)
                cmp.b   $36(a0),d2
                bhi.s   loc_259B0
                move.b  #1,$3C(a0)
                bra.s   loc_259B0
; ---------------------------------------------------------------------------

loc_25996:
                move.w  $40(a0),d1
                subq.w  #4,d1
                move.w  d1,$40(a0)
                add.w   d1,$36(a0)
                cmp.b   $36(a0),d2
                bls.s   loc_259B0
                move.b  #0,$3C(a0)

loc_259B0:
                moveq   #0,d0
                move.b  $36(a0),d0
                btst    #0,status(a0)
                beq.s   locret_259C2
                neg.w   d0
                add.w   d2,d0

locret_259C2:
                rts
; End of function sub_25974

; ---------------------------------------------------------------------------
Map_LRZSolidMovingPlatforms:
                include "src/objects/shared/zones/lrz/map_solid_moving_platforms.s"
; ---------------------------------------------------------------------------
; unused
                dc.b    $20, $10,   0
                even
