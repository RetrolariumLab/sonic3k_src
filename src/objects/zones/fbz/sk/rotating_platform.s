; Owner: objects/zones/fbz/sk
; Responsibility: Rotating platform phase, motion, collision and player riding
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_FBZRotatingPlatform:
                move.b  subtype(a0),d0
                andi.w  #$F,d0
                lsl.w   #3,d0
                lea     byte_3B780(pc,d0.w),a2
                moveq   #0,d1
                move.b  (a2)+,d1
                move.b  (a2)+,d2
                movea.l a0,a1
                bra.w   loc_3B802
; ---------------------------------------------------------------------------
byte_3B780:
                dc.b    6-1,   0, $5C, $44, $2C, $D4, $BC, $A4
                dc.b    6-1,   1, $5C, $44, $2C, $D4, $BC, $A4
                dc.b    6-1, $21, $5C, $44, $2C, $D4, $BC, $A4
                dc.b    4-1,   0, $44, $2C, $D4, $BC,   0,   0
                dc.b    4-1,   1, $44, $2C, $D4, $BC,   0,   0
                dc.b    4-1,   9, $44, $2C, $D4, $BC,   0,   0
                dc.b    2-1,   0, $2C, $D4,   0,   0,   0,   0
                dc.b    2-1,   1, $2C, $D4,   0,   0,   0,   0
                dc.b    2-1,   3, $2C, $D4,   0,   0,   0,   0
                dc.b    3-1,   0, $5C, $44, $2C,   0,   0,   0
                dc.b    3-1,   1, $5C, $44, $2C,   0,   0,   0
                dc.b    2-1,   0, $44, $2C,   0,   0,   0,   0
                dc.b    2-1,   1, $44, $2C,   0,   0,   0,   0
                dc.b    1-1,   0, $2C,   0,   0,   0,   0,   0
                dc.b    1-1,   1, $2C,   0,   0,   0,   0,   0
                even
; ---------------------------------------------------------------------------

loc_3B7F8:
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   loc_3B866

loc_3B802:
                move.l  #loc_3B86A,(a1)
                move.l  #Map_FBZRotatingPlatform,mappings(a1)
                move.w  #make_art_tile(ArtTile_FBZMisc+$F2,1,0),art_tile(a1)
                ori.b   #4,render_flags(a1)
                move.b  #$C,width_pixels(a1)
                move.b  #$C,height_pixels(a1)
                move.w  #$280,priority(a1)
                move.b  status(a0),status(a1)
                bset    #7,status(a1)
                move.w  x_pos(a0),$44(a1)
                move.w  y_pos(a0),$46(a1)
                move.b  (a2)+,$30(a1)
                lsr.b   #1,d2
                bcc.s   loc_3B866
                move.l  #loc_3B8C2,(a1)
                move.w  #make_art_tile(ArtTile_FBZMisc+$CA,1,0),art_tile(a1)
                move.b  #1,mapping_frame(a1)
                move.b  #$86,collision_flags(a1)

loc_3B866:
                dbf     d1,loc_3B7F8

loc_3B86A:
                move.w  x_pos(a0),-(sp)
                move.b  angle(a0),d0
                jsr     (GetSineCosine).l
                move.w  $30(a0),d2
                muls.w  d2,d1
                muls.w  d2,d0
                swap    d1
                swap    d0
                add.w   $44(a0),d1
                add.w   $46(a0),d0
                move.w  d1,x_pos(a0)
                move.w  d0,y_pos(a0)
                move.w  #$17,d1
                move.w  #$C,d2
                move.w  #$D,d3
                move.w  (sp)+,d4
                jsr     (SolidObjectFull).l
                moveq   #1,d1
                btst    #0,status(a0)
                beq.s   loc_3B8B4
                neg.w   d1

loc_3B8B4:
                add.b   d1,angle(a0)
                move.w  $44(a0),d0
                jmp     (Sprite_OnScreen_Test2).l
; ---------------------------------------------------------------------------

loc_3B8C2:
                move.w  x_pos(a0),-(sp)
                move.b  angle(a0),d0
                jsr     (GetSineCosine).l
                move.w  $30(a0),d2
                muls.w  d2,d1
                muls.w  d2,d0
                swap    d1
                swap    d0
                add.w   $44(a0),d1
                add.w   $46(a0),d0
                move.w  d1,x_pos(a0)
                move.w  d0,$14(a0)
                move.w  #$17,d1
                move.w  #$C,d2
                move.w  #$D,d3
                move.w  (sp)+,d4
                jsr     (SolidObjectFull).l
                moveq   #1,d1
                btst    #0,status(a0)
                beq.s   loc_3B90C
                neg.w   d1

loc_3B90C:
                add.b   d1,angle(a0)
                move.w  $44(a0),d0
                jmp     (loc_1B666).l
; ---------------------------------------------------------------------------
Map_FBZRotatingPlatform:
                include "src/objects/shared/zones/fbz/mappings/rotating_platform.s"
; End of function Obj_FBZRotatingPlatform
