; Owner: objects/zones/lrz/sk
; Responsibility: Flamethrower timing, flame objects, player collision and sprite resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_LRZFlameThrower:
                move.l  #Map_LRZFlameThrower,mappings(a0)
                move.w  #make_art_tile($090,1,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.b  #$18,width_pixels(a0)
                move.b  #$10,height_pixels(a0)
                move.w  #$280,priority(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                bpl.s   loc_43DC4
                andi.w  #$7F,d0
                lsl.w   #2,d0
                move.w  d0,$32(a0)
                move.w  #2*60,$30(a0)
                move.b  #7,mapping_frame(a0)
                btst    #0,status(a0)
                beq.s   loc_43DBA
                bset    #1,render_flags(a0)

loc_43DBA:
                move.l  #loc_43F12,(a0)
                bra.w   loc_43F12
; ---------------------------------------------------------------------------

loc_43DC4:
                lsl.w   #2,d0
                move.w  d0,$32(a0)
                move.w  #2*60,$30(a0)
                move.b  #6,mapping_frame(a0)
                move.l  #loc_43DDC,(a0)

loc_43DDC:
                tst.b   $2F(a0)
                bne.s   loc_43DF8
                subq.w  #1,$30(a0)
                bpl.s   loc_43E14
                move.w  $32(a0),$30(a0)
                move.b  #1,$2F(a0)
                bra.w   loc_43EF6
; ---------------------------------------------------------------------------

loc_43DF8:
                subq.w  #1,$30(a0)
                bpl.w   loc_43EF6
                move.w  #2*60,$30(a0)
                move.b  #0,$2F(a0)
                moveq   #signextendB(sfx_FlamethrowerLoud),d0
                jsr     (Play_SFX).l

loc_43E14:
                subq.b  #1,$24(a0)
                bpl.s   loc_43E2A
                move.b  #2,$24(a0)
                addq.b  #1,$25(a0)
                andi.b  #1,$25(a0)

loc_43E2A:
                move.b  (Level_frame_counter+1).w,d0
                move.b  d0,d1
                andi.b  #3,d0
                bne.w   loc_43EF6
                andi.b  #$F,d1
                bne.s   loc_43E4E
                cmpi.w  #30,$30(a0)
                blo.s   loc_43E4E
                moveq   #signextendB(sfx_FlamethrowerLoud),d0
                jsr     (Play_SFX).l

loc_43E4E:
                move.b  angle(a0),d0
                jsr     (GetSineCosine).l
                asr.w   #4,d0
                move.b  d0,$2E(a0)
                addq.b  #8,angle(a0)
                tst.b   render_flags(a0)
                bpl.w   loc_43EF6
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   loc_43EF6
                move.l  #loc_44048,(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                addi.w  #$10,x_pos(a1)
                move.b  render_flags(a0),render_flags(a1)
                move.l  mappings(a0),mappings(a1)
                move.w  #make_art_tile(ArtTile_LRZ2Misc,1,0),art_tile(a1)
                move.w  #$300,priority(a1)
                move.b  #$C,width_pixels(a1)
                move.b  #$C,height_pixels(a1)
                move.b  #$98,collision_flags(a1)
                bset    #4,shield_reaction(a1)
                move.b  $2E(a0),d0
                jsr     (GetSineCosine).l
                asl.w   #2,d1
                asl.w   #2,d0
                move.w  d1,x_vel(a1)
                move.w  d0,y_vel(a1)
                btst    #0,status(a0)
                beq.s   loc_43EE4
                neg.w   x_vel(a1)
                subi.w  #2*$10,x_pos(a1)

loc_43EE4:
                move.b  $25(a0),mapping_frame(a1)
                move.b  $24(a0),$25(a1)
                move.b  #8,$24(a1)

loc_43EF6:
                move.w  #$23,d1
                move.w  #$10,d2
                move.w  #$11,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

loc_43F12:
                tst.b   $2F(a0)
                bne.s   loc_43F2E
                subq.w  #1,$30(a0)
                bpl.s   loc_43F4A
                move.w  $32(a0),$30(a0)
                move.b  #1,$2F(a0)
                bra.w   loc_4402C
; ---------------------------------------------------------------------------

loc_43F2E:
                subq.w  #1,$30(a0)
                bpl.w   loc_4402C
                move.w  #2*60,$30(a0)
                move.b  #0,$2F(a0)
                moveq   #signextendB(sfx_FlamethrowerLoud),d0
                jsr     (Play_SFX).l

loc_43F4A:
                subq.b  #1,$24(a0)
                bpl.s   loc_43F60
                move.b  #2,$24(a0)
                addq.b  #1,$25(a0)
                andi.b  #1,$25(a0)

loc_43F60:
                move.b  (Level_frame_counter+1).w,d0
                move.b  d0,d1
                andi.b  #3,d0
                bne.w   loc_4402C
                andi.b  #$F,d1
                bne.s   loc_43F84
                cmpi.w  #30,$30(a0)
                blo.s   loc_43F84
                moveq   #signextendB(sfx_FlamethrowerLoud),d0
                jsr     (Play_SFX).l

loc_43F84:
                move.b  angle(a0),d0
                jsr     (GetSineCosine).l
                asr.w   #4,d0
                move.b  d0,$2E(a0)
                addq.b  #8,angle(a0)
                tst.b   render_flags(a0)
                bpl.w   loc_4402C
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   loc_4402C
                move.l  #loc_44048,(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                addi.w  #$10,y_pos(a1)
                move.b  render_flags(a0),render_flags(a1)
                move.l  mappings(a0),mappings(a1)
                move.w  #make_art_tile(ArtTile_LRZ2Misc,1,0),art_tile(a1)
                move.w  #$300,priority(a1)
                move.b  #$C,width_pixels(a1)
                move.b  #$C,height_pixels(a1)
                move.b  #$98,collision_flags(a1)
                bset    #4,shield_reaction(a1)
                move.b  $2E(a0),d0
                jsr     (GetSineCosine).l
                asl.w   #2,d1
                asl.w   #2,d0
                move.w  d1,y_vel(a1)
                move.w  d0,x_vel(a1)
                btst    #0,status(a0)
                beq.s   loc_4401A
                neg.w   y_vel(a1)
                subi.w  #$20,y_pos(a1)

loc_4401A:
                move.b  $25(a0),mapping_frame(a1)
                move.b  $24(a0),$25(a1)
                move.b  #8,$24(a1)

loc_4402C:
                move.w  #$1B,d1
                move.w  #$10,d2
                move.w  #$11,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

loc_44048:
                subq.b  #1,$24(a0)
                bpl.s   loc_44060
                move.b  #7,$24(a0)
                addq.b  #2,mapping_frame(a0)
                cmpi.b  #6,mapping_frame(a0)
                bhs.s   loc_44084

loc_44060:
                subq.b  #1,$25(a0)
                bpl.s   loc_44072
                move.b  #2,$25(a0)
                bchg    #0,mapping_frame(a0)

loc_44072:
                jsr     (MoveSprite2).l
                jsr     (Add_SpriteToCollisionResponseList).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_44084:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------
Map_LRZFlameThrower:
                include "src/objects/shared/zones/lrz/map_flamethrower.s"
; End of function Obj_LRZFlameThrower
