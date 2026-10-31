; Owner: objects/zones/aiz/s3
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
                move.l  #word_2A126,$32(a0)
                move.b  subtype(a0),d0
                bpl.s   loc_29FC2
                move.l  #word_2A1A6,$32(a0)

loc_29FC2:
                move.b  d0,d1
                andi.w  #$F,d0
                addi.w  #$10,d0
                move.b  d0,$37(a0)
                lsr.b   #4,d1
                andi.w  #7,d1
                move.b  d1,$25(a0)
                moveq   #1,d1
                btst    #0,status(a0)
                beq.s   loc_29FEA
                moveq   #-1,d1
                subq.b  #1,$37(a0)

loc_29FEA:
                move.b  d1,$36(a0)
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   loc_2A084
                move.l  #loc_2A0AC,(a1)
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
                bpl.s   loc_2A05E
                subi.w  #$10,d2
                move.w  #4,d4

loc_2A05E:
                moveq   #0,d1
                lea     sub2_x_pos(a1),a2
                move.w  mainspr_childsprites(a1),d6
                subq.w  #1,d6

loc_2A06A:
                move.w  d3,(a2)+
                move.w  d2,(a2)+
                move.w  d1,(a2)+
                addq.w  #2,d1
                andi.w  #$F,d1
                addi.w  #$20,d3
                sub.w   d4,d2
                dbf     d6,loc_2A06A
                move.w  a1,$3C(a0)

loc_2A084:
                move.l  #loc_2A08A,(a0)

loc_2A08A:
                movea.w $3C(a0),a3
                bsr.w   sub_2A0B2
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                movea.l $32(a0),a2
                move.w  x_pos(a0),d4
                jsr     (sub_2A226).l
                jmp     (Delete_Sprite_If_Not_In_Range).l
; ---------------------------------------------------------------------------

loc_2A0AC:
                jmp     (Sprite_OnScreen_Test).l

; =============== S U B R O U T I N E =======================================

sub_2A0B2:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   locret_2A0FC
                move.b  $25(a0),anim_frame_timer(a0)
                lea     sub2_mapframe(a3),a2
                move.w  mainspr_childsprites(a3),d6
                subq.w  #1,d6
                move.b  $37(a0),d2
                move.b  $36(a0),d1
                bmi.s   loc_2A0FE

loc_2A0D2:
                add.b   d1,(a2)
                cmp.b   (a2),d2
                bhi.s   loc_2A0DC
                move.b  #0,(a2)

loc_2A0DC:
                addq.w  #next_subspr,a2
                dbf     d6,loc_2A0D2
                tst.b   render_flags(a3)
                bpl.s   locret_2A0FC
                move.b  (Level_frame_counter+1).w,d0
                addq.b  #3,d0
                andi.b  #7,d0
                bne.s   locret_2A0FC
                moveq   #signextendB(sfx_GlideLand),d0
                jsr     (Play_SFX).l

locret_2A0FC:
                rts
; ---------------------------------------------------------------------------

loc_2A0FE:
                add.b   d1,(a2)
                bcs.s   loc_2A104
                move.b  d2,(a2)

loc_2A104:
                addq.w  #next_subspr,a2
                dbf     d6,loc_2A0FE
                tst.b   render_flags(a3)
                bpl.s   locret_2A124
                move.b  (Level_frame_counter+1).w,d0
                addq.b  #3,d0
                andi.b  #7,d0
                bne.s   locret_2A124
                moveq   #signextendB(sfx_GlideLand),d0
                jsr     (Play_SFX).l

locret_2A124:
                rts
; End of function sub_2A0B2

; ---------------------------------------------------------------------------
word_2A126:
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
word_2A1A6:
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

sub_2A226:
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d6
                movem.l d1-d4,-(sp)
                bsr.s   sub_2A23C
                movem.l (sp)+,d1-d4
                lea     (Player_2).w,a1
                addq.b  #p2_standing_bit-p1_standing_bit,d6
; End of function sub_2A226

; =============== S U B R O U T I N E =======================================

sub_2A23C:
                btst    d6,status(a0)
                beq.s   loc_2A292
                move.w  d1,d2
                add.w   d2,d2
                btst    #Status_InAir,status(a1)
                bne.s   loc_2A25E
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                bmi.s   loc_2A25E
                cmp.w   d2,d0
                blo.s   loc_2A272

loc_2A25E:
                bclr    #Status_OnObj,status(a1)
                bset    #Status_InAir,status(a1)
                bclr    d6,status(a0)
                moveq   #0,d4
                rts
; ---------------------------------------------------------------------------

loc_2A272:
                lsr.w   #5,d0
                add.w   d0,d0
                move.w  d0,d3
                add.w   d0,d0
                add.w   d3,d0
                move.b  sub2_mapframe(a3,d0.w),d0
                cmpi.b  #5,d0
                blo.s   loc_2A25E
                move.w  d4,d2
                jsr     (SolidObjSloped2).l
                moveq   #0,d4
                rts
; ---------------------------------------------------------------------------

loc_2A292:
                tst.w   y_vel(a1)
                bmi.s   locret_2A30E
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                bmi.s   locret_2A30E
                add.w   d1,d1
                cmp.w   d1,d0
                bhs.s   locret_2A30E
                btst    #0,render_flags(a0)
                beq.s   loc_2A2B6
                not.w   d0
                add.w   d1,d0

loc_2A2B6:
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
                bhi.s   locret_2A30E
                cmpi.w  #-$10,d0
                blo.s   locret_2A30E
                tst.b   object_control(a1)
                bne.s   locret_2A30E
                cmpi.b  #6,routine(a1)
                bhs.s   locret_2A30E
                lsr.w   #5,d4
                add.w   d4,d4
                move.w  d4,d1
                add.w   d4,d4
                add.w   d1,d4
                move.b  sub2_mapframe(a3,d4.w),d4
                cmpi.b  #5,d4
                blo.s   locret_2A30E
                add.w   d0,d2
                addq.w  #3,d2
                move.w  d2,y_pos(a1)
                jmp     (RideObject_SetRide).l
; ---------------------------------------------------------------------------

locret_2A30E:
                rts
; End of function sub_2A23C

; ---------------------------------------------------------------------------
Map_AIZFlippingBridge:
                include "src/objects/shared/zones/aiz/mappings/flipping_bridge.s"
