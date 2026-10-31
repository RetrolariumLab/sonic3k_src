; Owner: objects/shared/s3
; Responsibility: Freed animal state, species movement, enemy score display and product-specific animal spawn helpers
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_Animal:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Animal_Index(pc,d0.w),d1
                jmp     Animal_Index(pc,d1.w)
; ---------------------------------------------------------------------------
Animal_Index:
                dc.w    loc_2BEC2-Animal_Index
                dc.w    loc_2BFEA-Animal_Index
                dc.w    loc_2C046-Animal_Index
                dc.w    loc_2C086-Animal_Index
                dc.w    loc_2C046-Animal_Index
                dc.w    loc_2C046-Animal_Index
                dc.w    loc_2C046-Animal_Index
                dc.w    loc_2C086-Animal_Index
                dc.w    loc_2C046-Animal_Index
                dc.w    loc_2C086-Animal_Index
                dc.w    loc_2C046-Animal_Index
                dc.w    loc_2C046-Animal_Index
                dc.w    loc_2C046-Animal_Index
                dc.w    loc_2C046-Animal_Index
                dc.w    loc_2C10C-Animal_Index
                dc.w    loc_2C12E-Animal_Index
                dc.w    loc_2C12E-Animal_Index
                dc.w    loc_2C14E-Animal_Index
                dc.w    loc_2C18A-Animal_Index
                dc.w    loc_2C1E6-Animal_Index
                dc.w    loc_2C206-Animal_Index
                dc.w    loc_2C1E6-Animal_Index
                dc.w    loc_2C206-Animal_Index
                dc.w    loc_2C1E6-Animal_Index
                dc.w    loc_2C246-Animal_Index
                dc.w    loc_2C1A6-Animal_Index
byte_2BDDA:
                dc.b    5, 1
                dc.b    0, 3
                dc.b    5, 1
                dc.b    0, 5
                dc.b    6, 5
                dc.b    2, 3
                dc.b    6, 1
                dc.b    6, 5
                dc.b    6, 5
                dc.b    6, 5
                dc.b    6, 5
                dc.b    6, 5
                dc.b    6, 5
word_2BDF4:
                dc.w    -$200, -$400
                dc.l    Map_Animals5
                dc.w    -$200, -$300
                dc.l    Map_Animals1
                dc.w    -$180, -$300
                dc.l    Map_Animals5
                dc.w    -$140, -$180
                dc.l    Map_Animals4
                dc.w    -$1C0, -$300
                dc.l    Map_Animals3
                dc.w    -$300, -$400
                dc.l    Map_Animals1
                dc.w    -$280, -$380
                dc.l    Map_Animals2
                dc.w    -$280, -$300
                dc.l    Map_Animals1
                dc.w    -$200, -$380
                dc.l    Map_Animals2
                dc.w    -$2C0, -$300
                dc.l    Map_Animals2
                dc.w    -$140, -$200
                dc.l    Map_Animals2
                dc.w    -$200, -$300
                dc.l    Map_Animals2
word_2BE54:
                dc.w    -$440, -$400
                dc.w    -$440, -$400
                dc.w    -$440, -$400
                dc.w    -$300, -$400
                dc.w    -$300, -$400
                dc.w    -$180, -$300
                dc.w    -$180, -$300
                dc.w    -$140, -$180
                dc.w    -$1C0, -$300
                dc.w    -$200, -$300
                dc.w    -$280, -$380
off_2BE80:
                dc.l    Map_Animals1
                dc.l    Map_Animals1
                dc.l    Map_Animals1
                dc.l    Map_Animals5
                dc.l    Map_Animals5
                dc.l    Map_Animals5
                dc.l    Map_Animals5
                dc.l    Map_Animals4
                dc.l    Map_Animals3
                dc.l    Map_Animals1
                dc.l    Map_Animals2
word_2BEAC:
                dc.w    make_art_tile($5A5,0,0)
                dc.w    make_art_tile($5A5,0,0)
                dc.w    make_art_tile($5A5,0,0)
                dc.w    make_art_tile($553,0,0)
                dc.w    make_art_tile($553,0,0)
                dc.w    make_art_tile($573,0,0)
                dc.w    make_art_tile($573,0,0)
                dc.w    make_art_tile($585,0,0)
                dc.w    make_art_tile($593,0,0)
                dc.w    make_art_tile($565,0,0)
                dc.w    make_art_tile($5B3,0,0)
; ---------------------------------------------------------------------------

loc_2BEC2:
                tst.b   subtype(a0)
                beq.w   loc_2BF2E
                moveq   #0,d0
                move.b  subtype(a0),d0
                add.w   d0,d0
                move.b  d0,routine(a0)
                subi.w  #$14,d0
                move.w  word_2BEAC(pc,d0.w),art_tile(a0)
                add.w   d0,d0
                move.l  off_2BE80(pc,d0.w),mappings(a0)
                lea     word_2BE54(pc),a1
                move.w  (a1,d0.w),$32(a0)
                move.w  (a1,d0.w),x_vel(a0)
                move.w  2(a1,d0.w),$34(a0)
                move.w  2(a1,d0.w),y_vel(a0)
                move.b  #$C,y_radius(a0)
                move.b  #4,render_flags(a0)
                bset    #0,render_flags(a0)
                move.w  #$300,priority(a0)
                move.b  #8,width_pixels(a0)
                move.b  #7,anim_frame_timer(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_2BF2E:
                addq.b  #2,routine(a0)
                jsr     (Random_Number).l
                move.w  #make_art_tile(ArtTile_Animals1,0,0),art_tile(a0)
                andi.w  #1,d0
                beq.s   loc_2BF4A
                move.w  #make_art_tile(ArtTile_Animals2,0,0),art_tile(a0)

loc_2BF4A:
                moveq   #0,d1
                move.b  (Current_zone).w,d1
                add.w   d1,d1
                add.w   d0,d1
                lea     byte_2BDDA(pc),a1
                move.b  (a1,d1.w),d0
                move.b  d0,$30(a0)
                lsl.w   #3,d0
                lea     word_2BDF4(pc),a1
                adda.w  d0,a1
                move.w  (a1)+,$32(a0)
                move.w  (a1)+,$34(a0)
                move.l  (a1)+,mappings(a0)
                move.b  #$C,y_radius(a0)
                move.b  #4,render_flags(a0)
                bset    #0,render_flags(a0)
                move.w  #$300,priority(a0)
                move.b  #8,width_pixels(a0)
                move.b  #7,anim_frame_timer(a0)
                move.b  #2,mapping_frame(a0)
                move.w  #-$400,y_vel(a0)
                tst.b   $38(a0)
                bne.s   loc_2BFD4
                jsr     (AllocateObject).l
                bne.s   loc_2BFCE
                move.l  #Obj_EnemyScore,(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.w  $3E(a0),d0
                lsr.w   #1,d0
                move.b  d0,mapping_frame(a1)

loc_2BFCE:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_2BFD4:
                move.b  #$1C,routine(a0)
                clr.w   x_vel(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_2BFE4:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_2BFEA:
                tst.b   render_flags(a0)
                bpl.s   loc_2BFE4
                jsr     (MoveSprite).l
                tst.w   y_vel(a0)
                bmi.s   loc_2C040
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.s   loc_2C040
                add.w   d1,y_pos(a0)
                move.w  $32(a0),x_vel(a0)
                move.w  $34(a0),y_vel(a0)
                move.b  #1,mapping_frame(a0)
                move.b  $30(a0),d0
                add.b   d0,d0
                addq.b  #4,d0
                move.b  d0,routine(a0)
                tst.b   $38(a0)
                beq.s   loc_2C040
                btst    #4,(V_int_run_count+3).w
                beq.s   loc_2C040
                neg.w   x_vel(a0)
                bchg    #0,render_flags(a0)

loc_2C040:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_2C046:
                jsr     (MoveSprite).l
                move.b  #1,mapping_frame(a0)
                tst.w   y_vel(a0)
                bmi.s   loc_2C072
                move.b  #0,mapping_frame(a0)
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.s   loc_2C072
                add.w   d1,y_pos(a0)
                move.w  $34(a0),y_vel(a0)

loc_2C072:
                tst.b   subtype(a0)
                bne.s   loc_2C0EE
                tst.b   render_flags(a0)
                bpl.w   loc_2BFE4
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_2C086:
                jsr     (MoveSprite2).l
                addi.w  #$18,y_vel(a0)
                tst.w   y_vel(a0)
                bmi.s   loc_2C0C4
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.s   loc_2C0C4
                add.w   d1,y_pos(a0)
                move.w  $34(a0),y_vel(a0)
                tst.b   subtype(a0)
                beq.s   loc_2C0C4
                cmpi.b  #$A,subtype(a0)
                beq.s   loc_2C0C4
                neg.w   x_vel(a0)
                bchg    #0,render_flags(a0)

loc_2C0C4:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   loc_2C0DA
                move.b  #1,anim_frame_timer(a0)
                addq.b  #1,mapping_frame(a0)
                andi.b  #1,mapping_frame(a0)

loc_2C0DA:
                tst.b   subtype(a0)
                bne.s   loc_2C0EE
                tst.b   render_flags(a0)
                bpl.w   loc_2BFE4
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_2C0EE:
                move.w  x_pos(a0),d0
                sub.w   (Player_1+x_pos).w,d0
                bcs.s   loc_2C106
                subi.w  #$180,d0
                bpl.s   loc_2C106
                tst.b   render_flags(a0)
                bpl.w   loc_2BFE4

loc_2C106:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_2C10C:
                tst.b   render_flags(a0)
                bpl.w   loc_2BFE4
                subq.w  #1,$36(a0)
                bne.w   loc_2C128
                move.b  #2,routine(a0)
                move.w  #$80,priority(a0)

loc_2C128:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_2C12E:
                bsr.w   sub_2C2DC
                bcc.s   loc_2C14A
                move.w  $32(a0),x_vel(a0)
                move.w  $34(a0),y_vel(a0)
                move.b  #$E,routine(a0)
                bra.w   loc_2C086
; ---------------------------------------------------------------------------

loc_2C14A:
                bra.w   loc_2C0EE
; ---------------------------------------------------------------------------

loc_2C14E:
                bsr.w   sub_2C2DC
                bpl.s   loc_2C186
                clr.w   x_vel(a0)
                clr.w   $32(a0)
                jsr     (MoveSprite2).l
                addi.w  #$18,y_vel(a0)
                bsr.w   sub_2C29C
                bsr.w   sub_2C2C4
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   loc_2C186
                move.b  #1,anim_frame_timer(a0)
                addq.b  #1,mapping_frame(a0)
                andi.b  #1,mapping_frame(a0)

loc_2C186:
                bra.w   loc_2C0EE
; ---------------------------------------------------------------------------

loc_2C18A:
                bsr.w   sub_2C2DC
                bpl.s   loc_2C1E2
                move.w  $32(a0),x_vel(a0)
                move.w  $34(a0),y_vel(a0)
                move.b  #4,routine(a0)
                bra.w   loc_2C046
; ---------------------------------------------------------------------------

loc_2C1A6:
                jsr     (MoveSprite).l
                move.b  #1,mapping_frame(a0)
                tst.w   y_vel(a0)
                bmi.s   loc_2C1E2
                move.b  #0,mapping_frame(a0)
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.s   loc_2C1E2
                not.b   subtype+1(a0)
                bne.s   loc_2C1D8
                neg.w   x_vel(a0)
                bchg    #0,render_flags(a0)

loc_2C1D8:
                add.w   d1,y_pos(a0)
                move.w  $34(a0),y_vel(a0)

loc_2C1E2:
                bra.w   loc_2C0EE
; ---------------------------------------------------------------------------

loc_2C1E6:
                bsr.w   sub_2C2DC
                bpl.s   loc_2C202
                clr.w   x_vel(a0)
                clr.w   $32(a0)
                jsr     (MoveSprite).l
                bsr.w   sub_2C29C
                bsr.w   sub_2C2C4

loc_2C202:
                bra.w   loc_2C0EE
; ---------------------------------------------------------------------------

loc_2C206:
                bsr.w   sub_2C2DC
                bpl.s   loc_2C242
                jsr     (MoveSprite).l
                move.b  #1,mapping_frame(a0)
                tst.w   y_vel(a0)
                bmi.s   loc_2C242
                move.b  #0,mapping_frame(a0)
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.s   loc_2C242
                neg.w   x_vel(a0)
                bchg    #0,render_flags(a0)
                add.w   d1,y_pos(a0)
                move.w  $34(a0),y_vel(a0)

loc_2C242:
                bra.w   loc_2C0EE
; ---------------------------------------------------------------------------

loc_2C246:
                bsr.w   sub_2C2DC
                bpl.s   loc_2C298
                jsr     (MoveSprite2).l
                addi.w  #$18,y_vel(a0)
                tst.w   y_vel(a0)
                bmi.s   loc_2C282
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.s   loc_2C282
                not.b   subtype+1(a0)
                bne.s   loc_2C278
                neg.w   x_vel(a0)
                bchg    #0,render_flags(a0)

loc_2C278:
                add.w   d1,y_pos(a0)
                move.w  $34(a0),y_vel(a0)

loc_2C282:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   loc_2C298
                move.b  #1,anim_frame_timer(a0)
                addq.b  #1,mapping_frame(a0)
                andi.b  #1,mapping_frame(a0)

loc_2C298:
                bra.w   loc_2C0EE

; =============== S U B R O U T I N E =======================================

sub_2C29C:
                move.b  #1,mapping_frame(a0)
                tst.w   y_vel(a0)
                bmi.s   locret_2C2C2
                move.b  #0,mapping_frame(a0)
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.s   locret_2C2C2
                add.w   d1,y_pos(a0)
                move.w  $34(a0),y_vel(a0)

locret_2C2C2:
                rts
; End of function sub_2C29C

; =============== S U B R O U T I N E =======================================

sub_2C2C4:
                bset    #0,render_flags(a0)
                move.w  x_pos(a0),d0
                sub.w   (Player_1+x_pos).w,d0
                bcc.s   locret_2C2DA
                bclr    #0,render_flags(a0)

locret_2C2DA:
                rts
; End of function sub_2C2C4

; =============== S U B R O U T I N E =======================================

sub_2C2DC:
                move.w  (Player_1+x_pos).w,d0
                sub.w   x_pos(a0),d0
                subi.w  #$B8,d0
                rts
; End of function sub_2C2DC

; ---------------------------------------------------------------------------

Obj_EnemyScore:
                move.l  #Map_EnemyScore,mappings(a0)
                move.w  #make_art_tile(ArtTile_StarPost,0,1),art_tile(a0)
                move.b  #4,render_flags(a0)
                move.w  #$80,priority(a0)
                move.b  #8,width_pixels(a0)
                move.w  #-$300,y_vel(a0)
                move.l  #loc_2C316,(a0)

loc_2C316:
                tst.w   y_vel(a0)
                bpl.w   loc_2BFE4
                jsr     (MoveSprite2).l
                addi.w  #$18,y_vel(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
Map_Animals1:
                include "src/objects/shared/animals/mappings/set_1.s"
Map_Animals2:
                include "src/objects/shared/animals/mappings/set_2.s"
Map_Animals3:
                include "src/objects/shared/animals/mappings/set_3.s"
Map_Animals4:
                include "src/objects/shared/animals/mappings/set_4.s"
Map_Animals5:
                include "src/objects/shared/animals/mappings/set_5.s"
Map_EnemyScore:
                include "src/objects/shared/enemy_misc/mappings/enemy_points.s"
