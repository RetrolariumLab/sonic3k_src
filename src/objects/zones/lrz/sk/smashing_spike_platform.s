; Owner: objects/zones/lrz/sk
; Responsibility: Smashing spike-platform movement, player collision and damage
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_LRZSmashingSpikePlatform:
                move.l  #Map_LRZSmashingSpikePlatform,mappings(a0)
                move.w  #make_art_tile(ArtTile_LRZMisc,2,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.b  #$40,width_pixels(a0)
                move.b  #$20,height_pixels(a0)
                move.w  #$280,priority(a0)
                move.w  y_pos(a0),$46(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsl.w   #3,d0
                move.w  d0,$38(a0)
                move.l  #loc_43128,(a0)

loc_43128:
                tst.b   $32(a0)
                bne.s   loc_43178
                move.w  y_vel(a0),d0
                addi.w  #$40,y_vel(a0)
                ext.l   d0
                lsl.l   #8,d0
                add.l   d0,$34(a0)
                move.w  $34(a0),d2
                cmp.w   $38(a0),d2
                blo.w   loc_431E0
                clr.w   y_vel(a0)
                move.w  $38(a0),$34(a0)
                move.b  #1,$32(a0)
                move.w  #30,$3A(a0)
                move.b  #0,anim_frame(a0)
                tst.b   render_flags(a0)
                bpl.s   loc_431E0
                moveq   #signextendB(sfx_Crash),d0
                jsr     (Play_SFX).l
                bra.s   loc_431E0
; ---------------------------------------------------------------------------

loc_43178:
                tst.w   $3A(a0)
                beq.s   loc_431AA
                subq.w  #1,$3A(a0)
                moveq   #0,d0
                move.b  anim_frame(a0),d0
                move.b  RawAni_43196(pc,d0.w),mapping_frame(a0)
                beq.s   loc_431E0
                addq.b  #1,anim_frame(a0)
                bra.s   loc_431E0
; ---------------------------------------------------------------------------
RawAni_43196:
                dc.b    2,   4,   6,   7,   7,   7,   7,   6,   6,   5,   5,   4,   4,   3,   3,   2,   2,   1,   1,   0
                even
; ---------------------------------------------------------------------------

loc_431AA:
                move.w  $34(a0),d2
                beq.s   loc_431D4
                subq.w  #1,d2
                move.w  d2,$34(a0)
                addq.b  #8,mapping_frame(a0)
                andi.b  #8,mapping_frame(a0)
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #$1F,d0
                bne.s   loc_431E0
                moveq   #signextendB(sfx_Blast),d0
                jsr     (Play_SFX).l
                bra.s   loc_431E0
; ---------------------------------------------------------------------------

loc_431D4:
                move.b  #0,$32(a0)
                move.b  #0,mapping_frame(a0)

loc_431E0:
                move.w  $46(a0),d0
                add.w   $34(a0),d0
                move.w  d0,y_pos(a0)
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                addi.w  #$B,d1
                moveq   #0,d2
                move.b  height_pixels(a0),d2
                move.b  mapping_frame(a0),d0
                andi.w  #7,d0
                sub.w   d0,d2
                move.w  d2,d3
                addq.w  #1,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                swap    d6
                andi.w  #4|8,d6
                bne.s   loc_43222
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

loc_43222:
                move.b  d6,d0
                andi.b  #4,d0
                beq.s   loc_43234
                lea     (Player_1).w,a1
                jsr     (sub_24280).l

loc_43234:
                andi.b  #8,d6
                beq.s   loc_43244
                lea     (Player_2).w,a1
                jsr     (sub_24280).l

loc_43244:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------
Map_LRZSmashingSpikePlatform:
                include "src/objects/shared/zones/lrz/mappings/smashing_spike_platform.s"
; End of function Obj_LRZSmashingSpikePlatform
