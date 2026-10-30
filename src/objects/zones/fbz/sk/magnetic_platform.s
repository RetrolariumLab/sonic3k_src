; Owner: objects/zones/fbz/sk
; Responsibility: Magnetic platform state, movement, player collision and riding
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_FBZMagneticPlatform:
                move.l  #Map_FBZMagneticPlatform,mappings(a0)
                move.w  #make_art_tile(ArtTile_FBZMisc+$CA,1,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.b  #$18,width_pixels(a0)
                move.b  #$10,height_pixels(a0)
                move.w  #$280,priority(a0)
                move.b  #$F,y_radius(a0)
                move.w  y_pos(a0),$46(a0)
                move.b  #$8D,collision_flags(a0)
                moveq   #0,d1
                move.b  subtype(a0),d1
                lsl.w   #4,d1
                subi.w  #$20,d1
                move.w  d1,$2E(a0)
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   loc_3B3BA
                move.l  #loc_3B482,(a1)
                move.l  mappings(a0),mappings(a1)
                move.w  art_tile(a0),art_tile(a1)
                move.b  render_flags(a0),render_flags(a1)
                move.b  #$10,width_pixels(a1)
                move.b  #$80,height_pixels(a1)
                move.w  #$200,priority(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                subi.w  #$70,y_pos(a1)
                moveq   #8,d0
                bset    #6,render_flags(a1)
                move.w  d0,mainspr_childsprites(a1)
                move.w  y_pos(a0),d1
                addi.w  #$C,d1
                lea     sub2_x_pos(a1),a2
                move.w  mainspr_childsprites(a1),d0
                subq.w  #1,d0

loc_3B3A2:
                move.w  x_pos(a0),(a2)+
                move.w  d1,(a2)+
                move.w  #1,(a2)+
                dbf     d0,loc_3B3A2
                move.w  #3,$1C(a1)
                move.w  a1,$3C(a0)

loc_3B3BA:
                move.l  #loc_3B3C0,(a0)

loc_3B3C0:
                jsr     (MoveSprite2).l
                addi.w  #$58,y_vel(a0)
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.s   loc_3B3EC
                add.w   d1,y_pos(a0)
                move.w  #0,y_vel(a0)
                move.b  #$10,y_radius(a0)
                move.l  #loc_3B3EC,(a0)

loc_3B3EC:
                tst.b   (_unkF7C1).w
                beq.s   loc_3B3F8
                move.l  #loc_3B3FA,(a0)

loc_3B3F8:
                bra.s   loc_3B462
; ---------------------------------------------------------------------------

loc_3B3FA:
                jsr     (MoveSprite2).l
                subi.w  #$18,y_vel(a0)
                move.w  $46(a0),d0
                sub.w   y_pos(a0),d0
                cmp.w   $2E(a0),d0
                blo.s   loc_3B436
                move.w  $46(a0),d0
                sub.w   $2E(a0),d0
                move.w  d0,y_pos(a0)
                move.w  #0,y_vel(a0)
                move.l  #loc_3B450,(a0)
                moveq   #signextendB(sfx_ChainTension),d0
                jsr     (Play_SFX).l
                bra.s   loc_3B450
; ---------------------------------------------------------------------------

loc_3B436:
                jsr     (ObjCheckCeilingDist).l
                tst.w   d1
                bpl.s   loc_3B450
                sub.w   d1,y_pos(a0)
                move.w  #0,y_vel(a0)
                move.l  #loc_3B450,(a0)

loc_3B450:
                tst.b   (_unkF7C1).w
                bne.s   loc_3B462
                move.b  #$F,y_radius(a0)
                move.l  #loc_3B3C0,(a0)

loc_3B462:
                bsr.w   sub_3B488
                move.w  #$23,d1
                move.w  #8,d2
                move.w  #-9,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull_Offset).l
                jmp     (Sprite_CheckDeleteTouch3).l
; ---------------------------------------------------------------------------

loc_3B482:
                jmp     (Sprite_OnScreen_Test).l

; =============== S U B R O U T I N E =======================================

sub_3B488:
                movea.w $3C(a0),a1
                lea     $20(a1),a2
                move.w  y_pos(a0),d2
                addi.w  #$18,d2
                move.w  $46(a0),d0
                sub.w   y_pos(a0),d0
                move.w  d0,d6
                addi.w  #$18,d6
                lsr.w   #5,d6
                addq.w  #1,d6
                cmpi.w  #8,d6
                blo.s   loc_3B4B2
                moveq   #8,d6

loc_3B4B2:
                move.w  d6,mainspr_childsprites(a1)
                subq.w  #2,d6
                bcs.s   locret_3B4DC

loc_3B4BA:
                move.w  d2,(a2)+
                move.w  #2,(a2)+
                addq.w  #2,a2
                addi.w  #$20,d2
                dbf     d6,loc_3B4BA
                subq.w  #8,d0
                andi.w  #$1F,d0
                cmpi.w  #$10,d0
                bhs.s   locret_3B4DC
                move.w  #1,-4(a2)

locret_3B4DC:
                rts
; End of function sub_3B488

; ---------------------------------------------------------------------------
Map_FBZMagneticPlatform:
                include "src/objects/shared/zones/fbz/map_magnetic_platform.s"
