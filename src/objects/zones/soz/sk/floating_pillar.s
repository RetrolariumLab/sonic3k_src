; Owner: objects/zones/soz/sk
; Responsibility: Floating pillar motion, player riding and mapping resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------
byte_4116A:
                dc.b    $20, $40,   0,   0
                dc.b    $20, $50,   1, $30
                dc.b    $20, $50,   2,  $C
                even
; ---------------------------------------------------------------------------

Obj_SOZFloatingPillar:
                move.l  #Map_SOZFloatingPillar,mappings(a0)
                move.w  #make_art_tile($001,2,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.w  #$280,priority(a0)
                move.w  x_pos(a0),$44(a0)
                move.w  y_pos(a0),$46(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsr.w   #2,d0
                andi.w  #$1C,d0
                lea     byte_4116A(pc,d0.w),a2
                move.b  (a2)+,width_pixels(a0)
                move.b  (a2)+,height_pixels(a0)
                move.b  (a2)+,mapping_frame(a0)
                move.b  (a2)+,$34(a0)
                move.b  subtype(a0),d0
                andi.w  #$F,d0
                add.w   d0,d0
                move.w  off_41210(pc,d0.w),d0
                lea     off_41210(pc,d0.w),a1
                move.l  a1,$30(a0)
                move.l  #loc_411D8,(a0)

loc_411D8:
                move.w  x_pos(a0),-(sp)
                movea.l $30(a0),a1
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
                swap    d6
                and.b   $34(a0),d6
                bne.s   loc_4121E

loc_41206:
                move.w  $44(a0),d0
                jmp     (Sprite_OnScreen_Test2).l
; ---------------------------------------------------------------------------
off_41210:
                dc.w    locret_4126E-off_41210
                dc.w    loc_41270-off_41210
                dc.w    loc_4127C-off_41210
                dc.w    loc_41288-off_41210
                dc.w    loc_412A8-off_41210
                dc.w    loc_412B4-off_41210
                dc.w    loc_412C0-off_41210
; ---------------------------------------------------------------------------

loc_4121E:
                cmpi.b  #1,mapping_frame(a0)
                bne.s   loc_4124A
                move.b  d6,d0
                andi.b  #$10,d0
                beq.s   loc_41238
                lea     (Player_1).w,a1
                jsr     (sub_24280).l

loc_41238:
                andi.b  #$20,d6
                beq.s   loc_41248
                lea     (Player_2).w,a1
                jsr     (sub_24280).l

loc_41248:
                bra.s   loc_41206
; ---------------------------------------------------------------------------

loc_4124A:
                move.b  d6,d0
                andi.b  #4,d0
                beq.s   loc_4125C
                lea     (Player_1).w,a1
                jsr     (sub_24280).l

loc_4125C:
                andi.b  #8,d6
                beq.s   loc_4126C
                lea     (Player_2).w,a1
                jsr     (sub_24280).l

loc_4126C:
                bra.s   loc_41206
; ---------------------------------------------------------------------------

locret_4126E:
                rts
; ---------------------------------------------------------------------------

loc_41270:
                moveq   #0,d0
                move.b  (Oscillating_table+$0A).w,d0
                subi.w  #$20,d0
                bra.s   loc_41294
; ---------------------------------------------------------------------------

loc_4127C:
                moveq   #0,d0
                move.b  (Oscillating_table+$1E).w,d0
                subi.w  #$40,d0
                bra.s   loc_41294
; ---------------------------------------------------------------------------

loc_41288:
                moveq   #0,d0
                move.b  (Oscillating_table+$3A).w,d0
                add.w   d0,d0
                subi.w  #$80,d0

loc_41294:
                btst    #0,status(a0)
                beq.s   loc_4129E
                neg.w   d0

loc_4129E:
                add.w   $44(a0),d0
                move.w  d0,x_pos(a0)
                rts
; ---------------------------------------------------------------------------

loc_412A8:
                moveq   #0,d0
                move.b  (Oscillating_table+$0A).w,d0
                subi.w  #$20,d0
                bra.s   loc_412CC
; ---------------------------------------------------------------------------

loc_412B4:
                moveq   #0,d0
                move.b  (Oscillating_table+$1E).w,d0
                subi.w  #$40,d0
                bra.s   loc_412CC
; ---------------------------------------------------------------------------

loc_412C0:
                moveq   #0,d0
                move.b  (Oscillating_table+$3A).w,d0
                add.w   d0,d0
                subi.w  #$80,d0

loc_412CC:
                btst    #0,status(a0)
                beq.s   loc_412D6
                neg.w   d0

loc_412D6:
                add.w   $46(a0),d0
                move.w  d0,y_pos(a0)
                rts
; ---------------------------------------------------------------------------
Map_SOZFloatingPillar:
                include "src/objects/shared/zones/soz/mappings/floating_pillar.s"
