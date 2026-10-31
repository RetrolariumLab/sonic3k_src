; Owner: objects/zones/lrz/sk
; Responsibility: Horizontal and vertical orbiting spike-ball movement and player collision
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_LRZOrbitingSpikeBallHorizontal:
                move.l  #Map_LRZOrbitingSpikeBall,mappings(a0)
                move.w  #make_art_tile(ArtTile_LRZ2Misc,1,0),art_tile(a0)
                move.b  #4,render_flags(a0)
                move.w  #$280,priority(a0)
                move.w  x_pos(a0),$44(a0)
                move.w  y_pos(a0),$46(a0)
                bclr    #0,subtype(a0)
                beq.s   loc_43B84
                move.b  #$20,width_pixels(a0)
                move.b  #$20,height_pixels(a0)
                move.b  #1,mapping_frame(a0)
                move.l  #loc_43BDE,(a0)
                bra.w   loc_43BDE
; ---------------------------------------------------------------------------

loc_43B84:
                move.b  #$10,width_pixels(a0)
                move.b  #$10,height_pixels(a0)
                move.l  #loc_43B96,(a0)

loc_43B96:
                move.b  #0,collision_flags(a0)
                andi.w  #drawing_mask,art_tile(a0)
                move.b  (Level_frame_counter+1).w,d0
                add.b   d0,d0
                btst    #0,status(a0)
                beq.s   loc_43BB2
                neg.b   d0

loc_43BB2:
                add.b   subtype(a0),d0
                bpl.s   loc_43BC4
                ori.w   #high_priority,art_tile(a0)
                move.b  #$9A,collision_flags(a0)

loc_43BC4:
                jsr     (GetSineCosine).l
                asr.w   #3,d1
                add.w   $44(a0),d1
                move.w  d1,x_pos(a0)
                move.w  $44(a0),d0
                jmp     (loc_1B666).l
; ---------------------------------------------------------------------------

loc_43BDE:
                move.b  #0,collision_flags(a0)
                andi.w  #drawing_mask,art_tile(a0)
                move.b  (Level_frame_counter+1).w,d0
                add.b   d0,d0
                btst    #0,status(a0)
                beq.s   loc_43BFA
                neg.b   d0

loc_43BFA:
                add.b   subtype(a0),d0
                bpl.s   loc_43C0C
                ori.w   #high_priority,art_tile(a0)
                move.b  #$8F,collision_flags(a0)

loc_43C0C:
                jsr     (GetSineCosine).l
                move.w  d1,d0
                asr.w   #1,d1
                add.w   d0,d1
                asr.w   #3,d1
                add.w   $44(a0),d1
                move.w  d1,x_pos(a0)
                move.w  $44(a0),d0
                jmp     (loc_1B666).l
; ---------------------------------------------------------------------------

Obj_LRZOrbitingSpikeBallVertical:
                move.l  #Map_LRZOrbitingSpikeBall,mappings(a0)
                move.w  #make_art_tile(ArtTile_LRZ2Misc,1,0),art_tile(a0)
                move.b  #4,render_flags(a0)
                move.w  #$280,priority(a0)
                move.w  x_pos(a0),$44(a0)
                move.w  y_pos(a0),$46(a0)
                bclr    #0,subtype(a0)
                beq.s   loc_43C76
                move.b  #$20,width_pixels(a0)
                move.b  #$20,height_pixels(a0)
                move.b  #1,mapping_frame(a0)
                move.l  #loc_43CD6,(a0)
                bra.w   loc_43CD6
; ---------------------------------------------------------------------------

loc_43C76:
                move.b  #$10,width_pixels(a0)
                move.b  #$10,height_pixels(a0)
                move.l  #loc_43C88,(a0)

loc_43C88:
                move.b  #0,collision_flags(a0)
                andi.w  #drawing_mask,art_tile(a0)
                move.b  (Level_frame_counter+1).w,d0
                add.b   d0,d0
                btst    #0,status(a0)
                beq.s   loc_43CA4
                neg.b   d0

loc_43CA4:
                add.b   subtype(a0),d0
                bpl.s   loc_43CB6
                ori.w   #high_priority,art_tile(a0)
                move.b  #$9A,collision_flags(a0)

loc_43CB6:
                jsr     (GetSineCosine).l
                move.w  d1,d0
                asr.w   #2,d1
                add.w   d0,d1
                asr.w   #3,d1
                add.w   $46(a0),d1
                move.w  d1,y_pos(a0)
                move.w  $44(a0),d0
                jmp     (loc_1B666).l
; ---------------------------------------------------------------------------

loc_43CD6:
                move.b  #0,collision_flags(a0)
                andi.w  #drawing_mask,art_tile(a0)
                move.b  (Level_frame_counter+1).w,d0
                add.b   d0,d0
                btst    #0,status(a0)
                beq.s   loc_43CF2
                neg.b   d0

loc_43CF2:
                add.b   subtype(a0),d0
                bpl.s   loc_43D04
                ori.w   #high_priority,art_tile(a0)
                move.b  #$8F,collision_flags(a0)

loc_43D04:
                jsr     (GetSineCosine).l
                asr.w   #2,d1
                move.w  d1,d0
                asr.w   #3,d0
                sub.w   d0,d1
                add.w   $46(a0),d1
                move.w  d1,y_pos(a0)
                move.w  $44(a0),d0
                jmp     (loc_1B666).l
; ---------------------------------------------------------------------------
Map_LRZOrbitingSpikeBall:
                include "src/objects/shared/zones/lrz/mappings/orbiting_spike_ball.s"
; End of function Obj_LRZOrbitingSpikeBallHorizontal
