; Owner: objects/shared/s3
; Responsibility: Shared door movement, trigger control, collision and zone mapping variants
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------
byte_2FAA8:
                dc.b    $10, $20
                dc.w    make_art_tile(ArtTile_HCZMisc+$A,2,0)
                dc.b    8, $20
                dc.w    make_art_tile(ArtTile_CNZMisc+$C5,2,0)
; ---------------------------------------------------------------------------

Obj_Door:
                moveq   #0,d0
                move.b  subtype(a0),d0
                bmi.w   loc_2FC2C
                move.b  d0,mapping_frame(a0)
                add.w   d0,d0
                add.w   d0,d0
                lea     byte_2FAA8(pc,d0.w),a1
                move.b  (a1)+,width_pixels(a0)
                move.b  (a1)+,height_pixels(a0)
                move.w  (a1)+,art_tile(a0)
                move.l  #Map_HCZCNZDoor,mappings(a0)
                ori.b   #4,render_flags(a0)
                move.w  #$300,priority(a0)
                move.w  y_pos(a0),$32(a0)
                move.w  x_pos(a0),d2
                move.w  d2,d3
                subi.w  #$200,d2
                addi.w  #$18,d3
                btst    #0,status(a0)
                beq.s   loc_2FB0A
                subi.w  #-$1E8,d2
                addi.w  #$1E8,d3

loc_2FB0A:
                move.w  d2,$34(a0)
                move.w  d3,$36(a0)
                move.l  #loc_2FB18,(a0)

loc_2FB18:
                btst    #0,status(a0)
                bne.s   loc_2FB34
                move.w  $34(a0),d2
                move.w  x_pos(a0),d3
                tst.b   $38(a0)
                beq.s   loc_2FB46
                move.w  $36(a0),d3
                bra.s   loc_2FB46
; ---------------------------------------------------------------------------

loc_2FB34:
                move.w  x_pos(a0),d2
                move.w  $36(a0),d3
                tst.b   $38(a0)
                beq.s   loc_2FB46
                move.w  $34(a0),d2

loc_2FB46:
                move.w  $32(a0),d4
                move.w  d4,d5
                subi.w  #$20,d4
                addi.w  #$20,d5
                move.b  #0,$38(a0)
                lea     (Player_1).w,a1
                bsr.s   sub_2FBCE
                lea     (Player_2).w,a1
                bsr.s   sub_2FBCE
                tst.b   $38(a0)
                beq.s   loc_2FB8A
                cmpi.w  #$40,$30(a0)
                beq.s   loc_2FBAA
                addq.w  #8,$30(a0)
                cmpi.w  #$40,$30(a0)
                bne.s   loc_2FB9E
                moveq   #signextendB(sfx_FanLatch),d0
                jsr     (Play_SFX).l
                bra.s   loc_2FB9E
; ---------------------------------------------------------------------------

loc_2FB8A:
                tst.w   $30(a0)
                beq.s   loc_2FBAA
                subq.w  #8,$30(a0)
                bne.s   loc_2FB9E
                moveq   #signextendB(sfx_FanLatch),d0
                jsr     (Play_SFX).l

loc_2FB9E:
                move.w  $32(a0),d0
                sub.w   $30(a0),d0
                move.w  d0,y_pos(a0)

loc_2FBAA:
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

sub_2FBCE:
                move.w  x_pos(a1),d0
                cmp.w   d2,d0
                blt.w   locret_2FBFA
                cmp.w   d3,d0
                bhs.w   locret_2FBFA
                move.w  y_pos(a1),d0
                cmp.w   d4,d0
                blo.w   locret_2FBFA
                cmp.w   d5,d0
                bhs.w   locret_2FBFA
                tst.b   object_control(a1)
                bmi.s   locret_2FBFA
                move.b  #1,$38(a0)

locret_2FBFA:
                rts
; End of function sub_2FBCE

; ---------------------------------------------------------------------------
Map_HCZCNZDoor:
                include "src/objects/shared/zones/hcz/mappings/cnz_door_s3.s"
; ---------------------------------------------------------------------------
byte_2FC28:
                dc.b    $20,   8
                dc.w    make_art_tile(ArtTile_CNZMisc+$C5,2,0)
; ---------------------------------------------------------------------------

loc_2FC2C:
                andi.w  #$7F,d0
                move.b  d0,mapping_frame(a0)
                add.w   d0,d0
                add.w   d0,d0
                lea     byte_2FC28(pc,d0.w),a1
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
                beq.s   loc_2FC80
                subi.w  #-$E8,d2
                addi.w  #$E8,d3

loc_2FC80:
                move.w  d2,$34(a0)
                move.w  d3,$36(a0)
                move.l  #loc_2FC8E,(a0)

loc_2FC8E:
                btst    #1,status(a0)
                bne.s   loc_2FCAA
                move.w  $34(a0),d2
                move.w  y_pos(a0),d3
                tst.b   $38(a0)
                beq.s   loc_2FCBC
                move.w  $36(a0),d3
                bra.s   loc_2FCBC
; ---------------------------------------------------------------------------

loc_2FCAA:
                move.w  y_pos(a0),d2
                move.w  $36(a0),d3
                tst.b   $38(a0)
                beq.s   loc_2FCBC
                move.w  $34(a0),d2

loc_2FCBC:
                move.w  $32(a0),d4
                move.w  d4,d5
                subi.w  #$20,d4
                addi.w  #$20,d5
                move.b  #0,$38(a0)
                lea     (Player_1).w,a1
                bsr.s   sub_2FD34
                lea     (Player_2).w,a1
                bsr.s   sub_2FD34
                tst.b   $38(a0)
                beq.s   loc_2FCF0
                cmpi.w  #$40,$30(a0)
                beq.s   loc_2FD10
                addq.w  #8,$30(a0)
                bra.s   loc_2FCFA
; ---------------------------------------------------------------------------

loc_2FCF0:
                tst.w   $30(a0)
                beq.s   loc_2FD10
                subq.w  #8,$30(a0)

loc_2FCFA:
                move.w  $30(a0),d0
                btst    #0,status(a0)
                beq.s   loc_2FD08
                neg.w   d0

loc_2FD08:
                add.w   $32(a0),d0
                move.w  d0,x_pos(a0)

loc_2FD10:
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

sub_2FD34:
                move.w  y_pos(a1),d0
                cmp.w   d2,d0
                blt.w   locret_2FD60
                cmp.w   d3,d0
                bhs.w   locret_2FD60
                move.w  x_pos(a1),d0
                cmp.w   d4,d0
                blo.w   locret_2FD60
                cmp.w   d5,d0
                bhs.w   locret_2FD60
                tst.b   object_control(a1)
                bmi.s   locret_2FD60
                move.b  #1,$38(a0)

locret_2FD60:
                rts
; End of function sub_2FD34

; ---------------------------------------------------------------------------
Map_CNZDoorHorizontal:
                include "src/objects/shared/zones/cnz/mappings/door_horizontal.s"
