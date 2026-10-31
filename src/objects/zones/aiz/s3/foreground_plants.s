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
                lea     word_2B780(pc,d0.w),a1
                move.w  (a1)+,art_tile(a0)
                move.w  (a1)+,priority(a0)
                move.b  (a1)+,width_pixels(a0)
                move.b  (a1)+,height_pixels(a0)
                move.b  subtype(a0),d0
                lsr.w   #2,d0
                andi.w  #$3C,d0
                move.l  off_2B78C(pc,d0.w),(a0)
                rts
; ---------------------------------------------------------------------------
word_2B780:
                dc.w    make_art_tile(ArtTile_AIZMisc1,2,1)
                dc.w    0
                dc.b    $20, $30
                dc.w    make_art_tile(ArtTile_AIZMisc1,2,1)
                dc.w    0
                dc.b    $20, $3C
off_2B78C:
                dc.l    loc_2B7A8
                dc.l    loc_2B7AE
                dc.l    loc_2B7E4
                dc.l    loc_2B81A
                dc.l    loc_2B850
                dc.l    loc_2B886
                dc.l    loc_2B8B8
; ---------------------------------------------------------------------------

loc_2B7A8:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

loc_2B7AE:
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

loc_2B7E4:
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

loc_2B81A:
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

loc_2B850:
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

loc_2B886:
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

loc_2B8B8:
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
