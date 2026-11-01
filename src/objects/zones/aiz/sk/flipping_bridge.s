; Owner: objects/zones/aiz/sk
; Responsibility: Angel Island flipping bridge coordinated sections, timed states and player collision
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_AIZFlippingBridge:
                move.l  #Map_AIZFlippingBridge,mappings(a0)
                move.w  #make_art_tile(ArtTile_AIZMisc2,2,0),art_tile(a0)
                move.b  #$80,width_pixels(a0)
                move.b  #4,height_pixels(a0)
                move.b  #4,render_flags(a0)
                move.w  #$200,priority(a0)
                move.w  y_pos(a0),$30(a0)
                move.l  #word_2AAF2,$32(a0)
                move.b  subtype(a0),d0
                bpl.s   loc_2A98E
                move.l  #word_2AB72,$32(a0)

loc_2A98E:
                move.b  d0,d1
                andi.w  #$F,d0
                addi.w  #$10,d0
                move.b  d0,$37(a0)
                lsr.b   #4,d1
                andi.w  #7,d1
                move.b  d1,$25(a0)
                moveq   #1,d1
                btst    #0,status(a0)
                beq.s   loc_2A9B6
                moveq   #-1,d1
                subq.b  #1,$37(a0)

loc_2A9B6:
                move.b  d1,$36(a0)
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   loc_2AA50
                move.l  #loc_2AA78,(a1)
                move.l  #Map_AIZFlippingBridge,mappings(a1)
                move.w  #make_art_tile(ArtTile_AIZMisc2,2,0),art_tile(a1)
                move.b  #4,render_flags(a1)
                move.b  #$80,width_pixels(a1)
                move.b  #$40,height_pixels(a1)
                move.w  #$200,priority(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                bset    #6,render_flags(a1)
                move.w  #8,mainspr_childsprites(a1)
                move.w  y_pos(a0),d2
                move.w  x_pos(a0),d3
                subi.w  #$70,d3
                addi.w  #$20,d2
                move.w  #8,d4
                tst.b   subtype(a0)
                bpl.s   loc_2AA2A
                subi.w  #$10,d2
                move.w  #4,d4

loc_2AA2A:
                moveq   #0,d1
                lea     sub2_x_pos(a1),a2
                move.w  mainspr_childsprites(a1),d6
                subq.w  #1,d6

loc_2AA36:
                move.w  d3,(a2)+
                move.w  d2,(a2)+
                move.w  d1,(a2)+
                addq.w  #2,d1
                andi.w  #$F,d1
                addi.w  #$20,d3
                sub.w   d4,d2
                dbf     d6,loc_2AA36
                move.w  a1,$3C(a0)

loc_2AA50:
                move.l  #loc_2AA56,(a0)

loc_2AA56:
                movea.w $3C(a0),a3
                bsr.w   AdvanceAizFlippingBridgeFrames
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                movea.l $32(a0),a2
                move.w  x_pos(a0),d4
                jsr     (CollidePlayersWithAizFlippingBridge).l
                jmp     (Delete_Sprite_If_Not_In_Range).l
; ---------------------------------------------------------------------------

loc_2AA78:
                jmp     (Sprite_OnScreen_Test).l

; =============== S U B R O U T I N E =======================================

AdvanceAizFlippingBridgeFrames:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   locret_2AAC8
                move.b  $25(a0),anim_frame_timer(a0)
                lea     sub2_mapframe(a3),a2
                move.w  mainspr_childsprites(a3),d6
                subq.w  #1,d6
                move.b  $37(a0),d2
                move.b  $36(a0),d1
                bmi.s   loc_2AACA

loc_2AA9E:
                add.b   d1,(a2)
                cmp.b   (a2),d2
                bhi.s   loc_2AAA8
                move.b  #0,(a2)

loc_2AAA8:
                addq.w  #next_subspr,a2
                dbf     d6,loc_2AA9E
                tst.b   render_flags(a3)
                bpl.s   locret_2AAC8
                move.b  (Level_frame_counter+1).w,d0
                addq.b  #3,d0
                andi.b  #7,d0
                bne.s   locret_2AAC8
                moveq   #signextendB(sfx_GlideLand),d0
                jsr     (Play_SFX).l

locret_2AAC8:
                rts
; ---------------------------------------------------------------------------

loc_2AACA:
                add.b   d1,(a2)
                bcs.s   loc_2AAD0
                move.b  d2,(a2)

loc_2AAD0:
                addq.w  #next_subspr,a2
                dbf     d6,loc_2AACA
                tst.b   render_flags(a3)
                bpl.s   locret_2AAF0
                move.b  (Level_frame_counter+1).w,d0
                addq.b  #3,d0
                andi.b  #7,d0
                bne.s   locret_2AAF0
                moveq   #signextendB(sfx_GlideLand),d0
                jsr     (Play_SFX).l

locret_2AAF0:
                rts
; End of function AdvanceAizFlippingBridgeFrames

; ---------------------------------------------------------------------------
word_2AAF2:
                dc.b    -$1C,-$1C,-$1C,-$1C
                dc.b    -$1C,-$1C,-$1C,-$1C
                dc.b    -$1C,-$1C,-$1C,-$1C
                dc.b    -$1C,-$1C,-$1C,-$1C
                dc.b    -$14,-$14,-$14,-$14
                dc.b    -$14,-$14,-$14,-$14
                dc.b    -$14,-$14,-$14,-$14
                dc.b    -$14,-$14,-$14,-$14
                dc.b    -$C, -$C, -$C, -$C
                dc.b    -$C, -$C, -$C, -$C
                dc.b    -$C, -$C, -$C, -$C
                dc.b    -$C, -$C, -$C, -$C
                dc.b    -4,  -4,  -4,  -4
                dc.b    -4,  -4,  -4,  -4
                dc.b    -4,  -4,  -4,  -4
                dc.b    -4,  -4,  -4,  -4
                dc.b    4,   4,   4,   4
                dc.b    4,   4,   4,   4
                dc.b    4,   4,   4,   4
                dc.b    4,   4,   4,   4
                dc.b    $C,  $C,  $C,  $C
                dc.b    $C,  $C,  $C,  $C
                dc.b    $C,  $C,  $C,  $C
                dc.b    $C,  $C,  $C,  $C
                dc.b    $14, $14, $14, $14
                dc.b    $14, $14, $14, $14
                dc.b    $14, $14, $14, $14
                dc.b    $14, $14, $14, $14
                dc.b    $1C, $1C, $1C, $1C
                dc.b    $1C, $1C, $1C, $1C
                dc.b    $1C, $1C, $1C, $1C
                dc.b    $1C, $1C, $1C, $1C
word_2AB72:
                dc.b    -$C, -$C, -$C, -$C
                dc.b    -$C, -$C, -$C, -$C
                dc.b    -$C, -$C, -$C, -$C
                dc.b    -$C, -$C, -$C, -$C
                dc.b    -8,  -8,  -8,  -8
                dc.b    -8,  -8,  -8,  -8
                dc.b    -8,  -8,  -8,  -8
                dc.b    -8,  -8,  -8,  -8
                dc.b    -4,  -4,  -4,  -4
                dc.b    -4,  -4,  -4,  -4
                dc.b    -4,  -4,  -4,  -4
                dc.b    -4,  -4,  -4,  -4
                dc.b    0,   0,   0,   0
                dc.b    0,   0,   0,   0
                dc.b    0,   0,   0,   0
                dc.b    0,   0,   0,   0
                dc.b    4,   4,   4,   4
                dc.b    4,   4,   4,   4
                dc.b    4,   4,   4,   4
                dc.b    4,   4,   4,   4
                dc.b    8,   8,   8,   8
                dc.b    8,   8,   8,   8
                dc.b    8,   8,   8,   8
                dc.b    8,   8,   8,   8
                dc.b    $C,  $C,  $C,  $C
                dc.b    $C,  $C,  $C,  $C
                dc.b    $C,  $C,  $C,  $C
                dc.b    $C,  $C,  $C,  $C
                dc.b    $10, $10, $10, $10
                dc.b    $10, $10, $10, $10
                dc.b    $10, $10, $10, $10
                dc.b    $10, $10, $10, $10
                even

; =============== S U B R O U T I N E =======================================

CollidePlayersWithAizFlippingBridge:
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d6
                movem.l d1-d4,-(sp)
                bsr.s   CollidePlayerWithAizFlippingBridge
                movem.l (sp)+,d1-d4
                lea     (Player_2).w,a1
                addq.b  #p2_standing_bit-p1_standing_bit,d6
; End of function CollidePlayersWithAizFlippingBridge

; =============== S U B R O U T I N E =======================================

CollidePlayerWithAizFlippingBridge:
                btst    d6,status(a0)
                beq.s   loc_2AC5E
                move.w  d1,d2
                add.w   d2,d2
                btst    #Status_InAir,status(a1)
                bne.s   loc_2AC2A
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                bmi.s   loc_2AC2A
                cmp.w   d2,d0
                blo.s   loc_2AC3E

loc_2AC2A:
                bclr    #Status_OnObj,status(a1)
                bset    #Status_InAir,status(a1)
                bclr    d6,status(a0)
                moveq   #0,d4
                rts
; ---------------------------------------------------------------------------

loc_2AC3E:
                lsr.w   #5,d0
                add.w   d0,d0
                move.w  d0,d3
                add.w   d0,d0
                add.w   d3,d0
                move.b  sub2_mapframe(a3,d0.w),d0
                cmpi.b  #5,d0
                blo.s   loc_2AC2A
                move.w  d4,d2
                jsr     (SolidObjSloped2).l
                moveq   #0,d4
                rts
; ---------------------------------------------------------------------------

loc_2AC5E:
                tst.w   y_vel(a1)
                bmi.s   locret_2ACDA
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                bmi.s   locret_2ACDA
                add.w   d1,d1
                cmp.w   d1,d0
                bhs.s   locret_2ACDA
                btst    #0,render_flags(a0)
                beq.s   loc_2AC82
                not.w   d0
                add.w   d1,d0

loc_2AC82:
                move.w  d0,d4
                lsr.w   #1,d0
                move.b  (a2,d0.w),d3
                ext.w   d3
                move.w  y_pos(a0),d0
                sub.w   d3,d0
                move.w  y_pos(a1),d2
                move.b  y_radius(a1),d1
                ext.w   d1
                add.w   d2,d1
                addq.w  #4,d1
                sub.w   d1,d0
                bhi.s   locret_2ACDA
                cmpi.w  #-$10,d0
                blo.s   locret_2ACDA
                tst.b   object_control(a1)
                bne.s   locret_2ACDA
                cmpi.b  #6,routine(a1)
                bhs.s   locret_2ACDA
                lsr.w   #5,d4
                add.w   d4,d4
                move.w  d4,d1
                add.w   d4,d4
                add.w   d1,d4
                move.b  sub2_mapframe(a3,d4.w),d4
                cmpi.b  #5,d4
                blo.s   locret_2ACDA
                add.w   d0,d2
                addq.w  #3,d2
                move.w  d2,y_pos(a1)
                jmp     (RideObject_SetRide).l
; ---------------------------------------------------------------------------

locret_2ACDA:
                rts
; End of function CollidePlayerWithAizFlippingBridge
