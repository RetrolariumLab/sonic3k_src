; Owner: objects/zones/aiz/s3
; Responsibility: Angel Island disappearing floor timing, sprite state and player collision
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------
word_29316:
                dc.w    1
                dc.w    3
                dc.w    7
                dc.w    $F
                dc.w    $1F
                dc.w    $3F
                dc.w    $7F
                dc.w    $FF
                dc.w    $1FF
                dc.w    $3FF
                dc.w    $7FF
                dc.w    $FFF
                dc.w    $1FFF
                dc.w    $3FFF
                dc.w    $7FFF
                dc.w    $FFFF
; ---------------------------------------------------------------------------

Obj_AIZDisappearingFloor:
                move.b  subtype(a0),d0
                move.b  d0,d1
                andi.w  #$F,d0
                move.w  d0,d2
                add.w   d0,d0
                move.w  word_29316(pc,d0.w),$32(a0)
                subq.w  #3,d2
                bcc.s   loc_29350
                moveq   #0,d2

loc_29350:
                lsr.w   #4,d1
                andi.w  #$F,d1
                lsl.w   d2,d1
                move.w  d1,$34(a0)
                move.l  #Map_AIZDisappearingFloor,mappings(a0)
                move.w  #make_art_tile(ArtTile_AIZMisc2,2,0),art_tile(a0)  ; immediately gets overwritten?
                move.w  #make_art_tile($001,2,0),art_tile(a0)
                move.b  #$20,width_pixels(a0)
                move.b  #$18,height_pixels(a0)
                move.b  #4,render_flags(a0)
                move.w  #$280,priority(a0)
                move.w  (Level_frame_counter).w,d0
                add.w   $34(a0),d0
                and.w   $32(a0),d0
                beq.s   loc_293B4
                subi.w  #$C8,d0
                bcc.s   loc_293B4
                neg.w   d0
                move.b  d0,anim_frame_timer(a0)
                move.b  #0,anim_frame(a0)
                move.w  #(2<<8)|2,anim(a0)              ; and prev_anim
                move.b  #5,mapping_frame(a0)

loc_293B4:
                move.l  #loc_293BA,(a0)

loc_293BA:
                move.w  (Level_frame_counter).w,d0
                add.w   $34(a0),d0
                and.w   $32(a0),d0
                bne.w   loc_293E4
                move.w  #(1<<8)|0,anim(a0)              ; and prev_anim
                move.b  #0,$36(a0)
                tst.b   render_flags(a0)
                bpl.s   loc_293E4
                moveq   #signextendB(sfx_WaterfallSplash),d0
                jsr     (Play_SFX).l

loc_293E4:
                lea     (Ani_AIZDisappearingFloor).l,a1
                jsr     (Animate_SpriteIrregularDelay).l
                cmpi.b  #5,mapping_frame(a0)
                bne.s   loc_2944A
                tst.b   $36(a0)
                bne.s   loc_2944A
                move.b  #1,$36(a0)
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   loc_2944A
                move.l  #loc_29450,(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.l  #Map_AIZDisappearingFloor2,mappings(a1)
                move.w  #make_art_tile(ArtTile_AIZMisc2,3,0),art_tile(a1)
                move.b  #$28,width_pixels(a1)
                move.b  #$20,height_pixels(a1)
                move.b  #4,render_flags(a1)
                move.w  #$200,priority(a1)
                move.w  a0,$3C(a1)

loc_2944A:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

loc_29450:
                movea.w $3C(a0),a1
                cmpi.b  #3,mapping_frame(a1)
                bne.s   loc_29462
                move.w  #$7FF0,x_pos(a0)

loc_29462:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   loc_29478
                move.b  #3,anim_frame_timer(a0)
                addq.b  #1,mapping_frame(a0)
                andi.b  #3,mapping_frame(a0)

loc_29478:
                move.w  #$2B,d1
                move.w  #$18,d2
                move.w  #$19,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------
Ani_AIZDisappearingFloor:
                include "src/objects/shared/zones/aiz/animations/disappearing_floor.s"
Map_AIZDisappearingFloor:
                include "src/objects/shared/zones/aiz/mappings/disappearing_floor.s"
; End of function Obj_AIZDisappearingFloor
