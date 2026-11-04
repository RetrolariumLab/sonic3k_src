; Owner: objects/zones/dez/sk
; Responsibility: Death Egg floating platform placement, motion and player collision
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_DEZFloatingPlatform:
                move.l  #Map_DEZFloatingPlatform,mappings(a0)
                move.w  #make_art_tile(ArtTile_DEZ2Extra+$8,1,0),art_tile(a0)
                move.b  #4,render_flags(a0)
                move.w  #$200,priority(a0)
                move.b  #$20,width_pixels(a0)
                move.b  #$10,height_pixels(a0)
                move.w  x_pos(a0),$30(a0)
                move.w  y_pos(a0),$34(a0)
                move.b  subtype(a0),d0
                andi.w  #$F,d0
                add.w   d0,d0
                move.w  word_25AB8(pc,d0.w),d0
                lea     word_25AB8(pc,d0.w),a1
                move.l  a1,$42(a0)
                move.l  #loc_25A7E,(a0)

loc_25A7E:
                move.w  x_pos(a0),-(sp)
                movea.l $42(a0),a1
                jsr     (a1)
                move.w  (sp)+,d4
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                addi.w  #$B,d1
                moveq   #0,d2
                move.b  height_pixels(a0),d2
                move.w  d2,d3
                addq.w  #1,d3
                jsr     (SolidObjectFull).l
                addq.b  #1,mapping_frame(a0)
                andi.b  #1,mapping_frame(a0)
                move.w  $30(a0),d0
                jmp     (Sprite_OnScreen_Test2).l
; ---------------------------------------------------------------------------
word_25AB8:
                dc.w    SKLRZMovingSolid_Stationary-word_25AB8
                dc.w    SKLRZMovingSolid_OscillateX64-word_25AB8
                dc.w    SKLRZMovingSolid_OscillateX128-word_25AB8
                dc.w    SKLRZMovingSolid_AccelOscillateX96-word_25AB8
                dc.w    SKLRZMovingSolid_OscillateY64-word_25AB8
                dc.w    SKLRZMovingSolid_OscillateY128-word_25AB8
                dc.w    SKLRZMovingSolid_AccelOscillateY96-word_25AB8
                dc.w    SKLRZMovingSolid_AccelOscillateX128-word_25AB8
                dc.w    SKLRZMovingSolid_AccelOscillateY128-word_25AB8
; ---------------------------------------------------------------------------
Map_DEZFloatingPlatform:
                include "src/objects/shared/zones/dez/mappings/floating_platform.s"
; End of function Obj_DEZFloatingPlatform
