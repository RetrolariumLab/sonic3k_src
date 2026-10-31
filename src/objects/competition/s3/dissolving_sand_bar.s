; Owner: objects/competition/s3
; Responsibility: Desert Palace dissolving sand-bar activation, collapse and player collision
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_DPZDisolvingSandBar:
                move.l  #Map_DPZDissolvingSandBar,mappings(a0)
                move.w  #make_art_tile(ArtTile_DPZMisc,2,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.w  #$200,priority(a0)
                move.b  #$20,width_pixels(a0)
                move.b  #$10,height_pixels(a0)
                tst.b   subtype(a0)
                beq.s   loc_3550C
                move.l  #Map_DPZDissolvingSandBar2,mappings(a0)
                move.b  #$30,width_pixels(a0)
                move.b  #$F,$3D(a0)

loc_3550C:
                move.b  $3D(a0),$3C(a0)
                bset    #7,status(a0)
                move.l  #loc_3551E,(a0)

loc_3551E:
                tst.b   anim(a0)
                bne.s   loc_35558
                move.b  status(a0),d0
                andi.b  #standing_mask,d0
                beq.s   loc_35534
                move.b  #1,$3A(a0)

loc_35534:
                tst.b   $3A(a0)
                beq.s   loc_35558
                subq.b  #1,$3C(a0)
                bpl.s   loc_35558
                tst.b   anim(a0)
                bne.s   loc_35558
                move.b  $3D(a0),$3C(a0)
                move.b  #0,$3A(a0)
                move.b  #1,anim(a0)

loc_35558:
                lea     (Ani_DPZDissolvingSandBar).l,a1
                jsr     (Animate_Sprite).l
                moveq   #0,d0
                move.b  mapping_frame(a0),d0
                move.b  byte_355B8(pc,d0.w),d3
                bne.s   loc_355A2
                lea     (Player_1).w,a1
                bclr    #p1_standing_bit,status(a0)
                beq.s   loc_35588
                bclr    #Status_OnObj,status(a1)
                bset    #Status_InAir,status(a1)

loc_35588:
                lea     (Player_2).w,a1
                bclr    #p2_standing_bit,status(a0)
                beq.s   loc_355A0
                bclr    #Status_OnObj,status(a1)
                bset    #Status_InAir,status(a1)

loc_355A0:
                bra.s   loc_355B2
; ---------------------------------------------------------------------------

loc_355A2:
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                move.w  x_pos(a0),d4
                jsr     (SolidObjectTop).l

loc_355B2:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
byte_355B8:
                dc.b    $11, $11, $11, $11, $10,  $F,  $E,  $D,  $C,  $B,  $A,   9,   8,   7,   6,   5,   4,   3,   2,   1
                dc.b    0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
                even
Ani_DPZDissolvingSandBar:
                include "src/objects/shared/zones/dpz/animations/dissolving_sand_bar.s"
Map_DPZDissolvingSandBar:
                include "src/objects/shared/zones/dpz/mappings/dissolving_sand_bar.s"
; End of function Obj_DPZDisolvingSandBar
