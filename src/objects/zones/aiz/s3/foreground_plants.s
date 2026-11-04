; Owner: objects/zones/aiz/s3
; Responsibility: Angel Island foreground plants, player-relative motion and mapping resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_AIZForegroundPlant:
                move.l  #Map_AIZForegroundPlant,mappings(a0)
                ori.b   #4,render_flags(a0)
                move.w  x_pos(a0),$30(a0)
                move.w  y_pos(a0),$32(a0)
                move.b  subtype(a0),d0
                andi.w  #$F,d0
                move.b  d0,mapping_frame(a0)
                add.w   d0,d0
                move.w  d0,d1
                add.w   d0,d0
                add.w   d1,d0
                lea     S3AIZFgPlant_Attrs(pc,d0.w),a1
                move.w  (a1)+,art_tile(a0)
                move.w  (a1)+,priority(a0)
                move.b  (a1)+,width_pixels(a0)
                move.b  (a1)+,height_pixels(a0)
                move.b  subtype(a0),d0
                lsr.w   #2,d0
                andi.w  #$3C,d0
                move.l  S3AIZFgPlant_ParallaxHandlers(pc,d0.w),(a0)
                rts
; ---------------------------------------------------------------------------
S3AIZFgPlant_Attrs:
                dc.w    make_art_tile(ArtTile_AIZMisc1,2,1)
                dc.w    0
                dc.b    $20, $30
                dc.w    make_art_tile(ArtTile_AIZMisc1,2,1)
                dc.w    0
                dc.b    $20, $3C
S3AIZFgPlant_ParallaxHandlers:
                dc.l    S3AIZFgPlant_DrawStatic
                dc.l    S3AIZFgPlant_ApplyParallax1Over16
                dc.l    S3AIZFgPlant_ApplyParallax1Over8
                dc.l    S3AIZFgPlant_ApplyParallax1Over4
                dc.l    S3AIZFgPlant_ApplyParallax1Over2
                dc.l    S3AIZFgPlant_ApplyParallax1x
                dc.l    S3AIZFgPlant_ApplyParallaxX2Y1
; ---------------------------------------------------------------------------

S3AIZFgPlant_DrawStatic:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

S3AIZFgPlant_ApplyParallax1Over16:
                move.w  $30(a0),d1
                move.w  d1,d2
                subi.w  #320/2,d1
                sub.w   (Camera_X_pos).w,d1
                asr.w   #4,d1
                add.w   d2,d1
                move.w  d1,x_pos(a0)
                move.w  $32(a0),d1
                move.w  d1,d2
                subi.w  #224/2,d1
                sub.w   (Camera_Y_pos).w,d1
                asr.w   #4,d1
                add.w   d2,d1
                move.w  d1,y_pos(a0)
                move.w  $30(a0),d0
                jmp     (Sprite_OnScreen_Test2).l
; ---------------------------------------------------------------------------

S3AIZFgPlant_ApplyParallax1Over8:
                move.w  $30(a0),d1
                move.w  d1,d2
                subi.w  #320/2,d1
                sub.w   (Camera_X_pos).w,d1
                asr.w   #3,d1
                add.w   d2,d1
                move.w  d1,x_pos(a0)
                move.w  $32(a0),d1
                move.w  d1,d2
                subi.w  #224/2,d1
                sub.w   (Camera_Y_pos).w,d1
                asr.w   #3,d1
                add.w   d2,d1
                move.w  d1,y_pos(a0)
                move.w  $30(a0),d0
                jmp     (Sprite_OnScreen_Test2).l
; ---------------------------------------------------------------------------

S3AIZFgPlant_ApplyParallax1Over4:
                move.w  $30(a0),d1
                move.w  d1,d2
                subi.w  #320/2,d1
                sub.w   (Camera_X_pos).w,d1
                asr.w   #2,d1
                add.w   d2,d1
                move.w  d1,x_pos(a0)
                move.w  $32(a0),d1
                move.w  d1,d2
                subi.w  #224/2,d1
                sub.w   (Camera_Y_pos).w,d1
                asr.w   #2,d1
                add.w   d2,d1
                move.w  d1,y_pos(a0)
                move.w  $30(a0),d0
                jmp     (Sprite_OnScreen_Test2).l
; ---------------------------------------------------------------------------

S3AIZFgPlant_ApplyParallax1Over2:
                move.w  $30(a0),d1
                move.w  d1,d2
                subi.w  #320/2,d1
                sub.w   (Camera_X_pos).w,d1
                asr.w   #1,d1
                add.w   d2,d1
                move.w  d1,x_pos(a0)
                move.w  $32(a0),d1
                move.w  d1,d2
                subi.w  #224/2,d1
                sub.w   (Camera_Y_pos).w,d1
                asr.w   #1,d1
                add.w   d2,d1
                move.w  d1,y_pos(a0)
                move.w  $30(a0),d0
                jmp     (Sprite_OnScreen_Test2).l
; ---------------------------------------------------------------------------

S3AIZFgPlant_ApplyParallax1x:
                move.w  $30(a0),d1
                move.w  d1,d2
                subi.w  #320/2,d1
                sub.w   (Camera_X_pos).w,d1
                add.w   d2,d1
                move.w  d1,x_pos(a0)
                move.w  $32(a0),d1
                move.w  d1,d2
                subi.w  #224/2,d1
                sub.w   (Camera_Y_pos).w,d1
                add.w   d2,d1
                move.w  d1,y_pos(a0)
                move.w  $30(a0),d0
                jmp     (Sprite_OnScreen_Test2).l
; ---------------------------------------------------------------------------

S3AIZFgPlant_ApplyParallaxX2Y1:
                move.w  $30(a0),d1
                move.w  d1,d2
                subi.w  #320/2,d1
                sub.w   (Camera_X_pos).w,d1
                add.w   d1,d1
                add.w   d2,d1
                move.w  d1,x_pos(a0)
                move.w  $32(a0),d1
                move.w  d1,d2
                subi.w  #224/2,d1
                sub.w   (Camera_Y_pos).w,d1
                add.w   d2,d1
                move.w  d1,y_pos(a0)
                move.w  $30(a0),d0
                jmp     (Sprite_OnScreen_Test2).l
; ---------------------------------------------------------------------------
Map_AIZForegroundPlant:
                include "src/objects/shared/zones/aiz/mappings/foreground_plant.s"
; End of function Obj_AIZForegroundPlant
