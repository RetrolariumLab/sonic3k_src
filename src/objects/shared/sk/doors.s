; Owner: objects/shared/sk
; Responsibility: Shared door movement, trigger control, collision and zone mapping variants
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------
byte_30E18:
                dc.b    $10, $20
                dc.w    make_art_tile(ArtTile_HCZMisc+$A,2,0)
                dc.b    8, $20
                dc.w    make_art_tile(ArtTile_CNZMisc+$C5,2,0)
                dc.b    $10, $20
                dc.w    make_art_tile(ArtTile_DEZMisc+$1E,1,0)
; ---------------------------------------------------------------------------

Obj_Door:
                moveq   #0,d0
                move.b  subtype(a0),d0
                bmi.w   loc_30FD2
                move.b  d0,mapping_frame(a0)
                add.w   d0,d0
                add.w   d0,d0
                lea     byte_30E18(pc,d0.w),a1
                move.b  (a1)+,width_pixels(a0)
                move.b  (a1)+,height_pixels(a0)
                move.w  (a1)+,art_tile(a0)
                move.l  #Map_HCZCNZDEZDoor,mappings(a0)
                ori.b   #4,render_flags(a0)
                move.w  #$300,priority(a0)
                move.w  y_pos(a0),$32(a0)
                move.w  x_pos(a0),d2
                move.w  d2,d3
                subi.w  #$200,d2
                addi.w  #$18,d3
                btst    #0,status(a0)
                beq.s   loc_30E7E
                subi.w  #-$1E8,d2
                addi.w  #$1E8,d3

loc_30E7E:
                move.w  d2,$34(a0)
                move.w  d3,$36(a0)
                move.l  #loc_30E8C,(a0)

loc_30E8C:
                btst    #0,status(a0)
                bne.s   loc_30EA8
                move.w  $34(a0),d2
                move.w  x_pos(a0),d3
                tst.b   $38(a0)
                beq.s   loc_30EBA
                move.w  $36(a0),d3
                bra.s   loc_30EBA
; ---------------------------------------------------------------------------

loc_30EA8:
                move.w  x_pos(a0),d2
                move.w  $36(a0),d3
                tst.b   $38(a0)
                beq.s   loc_30EBA
                move.w  $34(a0),d2

loc_30EBA:
                move.w  $32(a0),d4
                move.w  d4,d5
                subi.w  #$20,d4
                addi.w  #$20,d5
                move.b  #0,$38(a0)
                lea     (Player_1).w,a1
                bsr.w   sub_30F58
                lea     (Player_2).w,a1
                bsr.s   sub_30F58
                tst.b   $38(a0)
                beq.s   loc_30F0A
                cmpi.w  #$40,$30(a0)
                beq.s   loc_30F34
                addq.w  #8,$30(a0)
                cmpi.w  #$40,$30(a0)
                bne.s   loc_30F28
                moveq   #signextendB(sfx_FanLatch),d0
                cmpi.b  #$B,(Current_zone).w            ; are we on DEZ?
                bne.s   loc_30F02                       ; if not, branch
                moveq   #signextendB(sfx_FanLatch),d0   ; this check and sfx selection is not really necessary?

loc_30F02:
                jsr     (Play_SFX).l
                bra.s   loc_30F28
; ---------------------------------------------------------------------------

loc_30F0A:
                tst.w   $30(a0)
                beq.s   loc_30F34
                subq.w  #8,$30(a0)
                bne.s   loc_30F28
                moveq   #signextendB(sfx_FanLatch),d0
                cmpi.b  #$B,(Current_zone).w            ; are we on DEZ?
                bne.s   loc_30F22                       ; if not, branch
                moveq   #signextendB(sfx_FanLatch),d0   ; this check and sfx selection is not really necessary?

loc_30F22:
                jsr     (Play_SFX).l

loc_30F28:
                move.w  $32(a0),d0
                sub.w   $30(a0),d0
                move.w  d0,y_pos(a0)

loc_30F34:
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

; =============== S U B R O U T I N E =======================================

sub_30F58:
                move.w  x_pos(a1),d0
                cmp.w   d2,d0
                blt.w   locret_30F84
                cmp.w   d3,d0
                bhs.w   locret_30F84
                move.w  y_pos(a1),d0
                cmp.w   d4,d0
                blo.w   locret_30F84
                cmp.w   d5,d0
                bhs.w   locret_30F84
                tst.b   object_control(a1)
                bmi.s   locret_30F84
                move.b  #1,$38(a0)

locret_30F84:
                rts
; End of function sub_30F58

; ---------------------------------------------------------------------------
Map_HCZCNZDEZDoor:
                include "src/objects/shared/zones/hcz/map_cnz_dez_door.s"
; ---------------------------------------------------------------------------
byte_30FCE:
                dc.b    $20,   8
                dc.w    make_art_tile(ArtTile_CNZMisc+$C5,2,0)
; ---------------------------------------------------------------------------

loc_30FD2:
                andi.w  #$7F,d0
                move.b  d0,mapping_frame(a0)
                add.w   d0,d0
                add.w   d0,d0
                lea     byte_30FCE(pc,d0.w),a1
                move.b  (a1)+,width_pixels(a0)
                move.b  (a1)+,height_pixels(a0)
                move.w  (a1)+,art_tile(a0)
                move.l  #Map_CNZDoorHorizontal,mappings(a0)
                ori.b   #4,render_flags(a0)
                move.w  #$200,priority(a0)
                move.w  x_pos(a0),$32(a0)
                move.w  y_pos(a0),d2
                move.w  d2,d3
                subi.w  #$100,d2
                addi.w  #$18,d3
                btst    #1,status(a0)
                beq.s   loc_31026
                subi.w  #-$E8,d2
                addi.w  #$E8,d3

loc_31026:
                move.w  d2,$34(a0)
                move.w  d3,$36(a0)
                move.l  #loc_31034,(a0)

loc_31034:
                btst    #1,status(a0)
                bne.s   loc_31050
                move.w  $34(a0),d2
                move.w  y_pos(a0),d3
                tst.b   $38(a0)
                beq.s   loc_31062
                move.w  $36(a0),d3
                bra.s   loc_31062
; ---------------------------------------------------------------------------

loc_31050:
                move.w  y_pos(a0),d2
                move.w  $36(a0),d3
                tst.b   $38(a0)
                beq.s   loc_31062
                move.w  $34(a0),d2

loc_31062:
                move.w  $32(a0),d4
                move.w  d4,d5
                subi.w  #$20,d4
                addi.w  #$20,d5
                move.b  #0,$38(a0)
                lea     (Player_1).w,a1
                bsr.s   sub_310DA
                lea     (Player_2).w,a1
                bsr.s   sub_310DA
                tst.b   $38(a0)
                beq.s   loc_31096
                cmpi.w  #$40,$30(a0)
                beq.s   loc_310B6
                addq.w  #8,$30(a0)
                bra.s   loc_310A0
; ---------------------------------------------------------------------------

loc_31096:
                tst.w   $30(a0)
                beq.s   loc_310B6
                subq.w  #8,$30(a0)

loc_310A0:
                move.w  $30(a0),d0
                btst    #0,status(a0)
                beq.s   loc_310AE
                neg.w   d0

loc_310AE:
                add.w   $32(a0),d0
                move.w  d0,x_pos(a0)

loc_310B6:
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

; =============== S U B R O U T I N E =======================================

sub_310DA:
                move.w  y_pos(a1),d0
                cmp.w   d2,d0
                blt.w   locret_31106
                cmp.w   d3,d0
                bhs.w   locret_31106
                move.w  x_pos(a1),d0
                cmp.w   d4,d0
                blo.w   locret_31106
                cmp.w   d5,d0
                bhs.w   locret_31106
                tst.b   object_control(a1)
                bmi.s   locret_31106
                move.b  #1,$38(a0)

locret_31106:
                rts
; End of function sub_310DA

; ---------------------------------------------------------------------------
Map_CNZDoorHorizontal:
                include "src/objects/shared/zones/cnz/map_door_horizontal.s"
