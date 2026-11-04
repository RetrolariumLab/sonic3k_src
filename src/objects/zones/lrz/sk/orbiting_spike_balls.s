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
                beq.s   SKLRZOrbitBall_InitSmallX
                move.b  #$20,width_pixels(a0)
                move.b  #$20,height_pixels(a0)
                move.b  #1,mapping_frame(a0)
                move.l  #SKLRZOrbitBall_CalcLargeXPhase,(a0)
                bra.w   SKLRZOrbitBall_CalcLargeXPhase
; ---------------------------------------------------------------------------

SKLRZOrbitBall_InitSmallX:
                move.b  #$10,width_pixels(a0)
                move.b  #$10,height_pixels(a0)
                move.l  #SKLRZOrbitBall_CalcSmallXPhase,(a0)

SKLRZOrbitBall_CalcSmallXPhase:
                move.b  #0,collision_flags(a0)
                andi.w  #drawing_mask,art_tile(a0)
                move.b  (Level_frame_counter+1).w,d0
                add.b   d0,d0
                btst    #0,status(a0)
                beq.s   SKLRZOrbitBall_TryEnableSmallXContact
                neg.b   d0

SKLRZOrbitBall_TryEnableSmallXContact:
                add.b   subtype(a0),d0
                bpl.s   SKLRZOrbitBall_PlaceSmallX
                ori.w   #high_priority,art_tile(a0)
                move.b  #$9A,collision_flags(a0)

SKLRZOrbitBall_PlaceSmallX:
                jsr     (GetSineCosine).l
                asr.w   #3,d1
                add.w   $44(a0),d1
                move.w  d1,x_pos(a0)
                move.w  $44(a0),d0
                jmp     (SKTouchCull_TestAnchorAndDraw).l
; ---------------------------------------------------------------------------

SKLRZOrbitBall_CalcLargeXPhase:
                move.b  #0,collision_flags(a0)
                andi.w  #drawing_mask,art_tile(a0)
                move.b  (Level_frame_counter+1).w,d0
                add.b   d0,d0
                btst    #0,status(a0)
                beq.s   SKLRZOrbitBall_TryEnableLargeXContact
                neg.b   d0

SKLRZOrbitBall_TryEnableLargeXContact:
                add.b   subtype(a0),d0
                bpl.s   SKLRZOrbitBall_PlaceLargeX
                ori.w   #high_priority,art_tile(a0)
                move.b  #$8F,collision_flags(a0)

SKLRZOrbitBall_PlaceLargeX:
                jsr     (GetSineCosine).l
                move.w  d1,d0
                asr.w   #1,d1
                add.w   d0,d1
                asr.w   #3,d1
                add.w   $44(a0),d1
                move.w  d1,x_pos(a0)
                move.w  $44(a0),d0
                jmp     (SKTouchCull_TestAnchorAndDraw).l
; ---------------------------------------------------------------------------

Obj_LRZOrbitingSpikeBallVertical:
                move.l  #Map_LRZOrbitingSpikeBall,mappings(a0)
                move.w  #make_art_tile(ArtTile_LRZ2Misc,1,0),art_tile(a0)
                move.b  #4,render_flags(a0)
                move.w  #$280,priority(a0)
                move.w  x_pos(a0),$44(a0)
                move.w  y_pos(a0),$46(a0)
                bclr    #0,subtype(a0)
                beq.s   SKLRZOrbitBall_InitSmallY
                move.b  #$20,width_pixels(a0)
                move.b  #$20,height_pixels(a0)
                move.b  #1,mapping_frame(a0)
                move.l  #SKLRZOrbitBall_CalcLargeYPhase,(a0)
                bra.w   SKLRZOrbitBall_CalcLargeYPhase
; ---------------------------------------------------------------------------

SKLRZOrbitBall_InitSmallY:
                move.b  #$10,width_pixels(a0)
                move.b  #$10,height_pixels(a0)
                move.l  #SKLRZOrbitBall_CalcSmallYPhase,(a0)

SKLRZOrbitBall_CalcSmallYPhase:
                move.b  #0,collision_flags(a0)
                andi.w  #drawing_mask,art_tile(a0)
                move.b  (Level_frame_counter+1).w,d0
                add.b   d0,d0
                btst    #0,status(a0)
                beq.s   SKLRZOrbitBall_TryEnableSmallYContact
                neg.b   d0

SKLRZOrbitBall_TryEnableSmallYContact:
                add.b   subtype(a0),d0
                bpl.s   SKLRZOrbitBall_PlaceSmallY
                ori.w   #high_priority,art_tile(a0)
                move.b  #$9A,collision_flags(a0)

SKLRZOrbitBall_PlaceSmallY:
                jsr     (GetSineCosine).l
                move.w  d1,d0
                asr.w   #2,d1
                add.w   d0,d1
                asr.w   #3,d1
                add.w   $46(a0),d1
                move.w  d1,y_pos(a0)
                move.w  $44(a0),d0
                jmp     (SKTouchCull_TestAnchorAndDraw).l
; ---------------------------------------------------------------------------

SKLRZOrbitBall_CalcLargeYPhase:
                move.b  #0,collision_flags(a0)
                andi.w  #drawing_mask,art_tile(a0)
                move.b  (Level_frame_counter+1).w,d0
                add.b   d0,d0
                btst    #0,status(a0)
                beq.s   SKLRZOrbitBall_TryEnableLargeYContact
                neg.b   d0

SKLRZOrbitBall_TryEnableLargeYContact:
                add.b   subtype(a0),d0
                bpl.s   SKLRZOrbitBall_PlaceLargeY
                ori.w   #high_priority,art_tile(a0)
                move.b  #$8F,collision_flags(a0)

SKLRZOrbitBall_PlaceLargeY:
                jsr     (GetSineCosine).l
                asr.w   #2,d1
                move.w  d1,d0
                asr.w   #3,d0
                sub.w   d0,d1
                add.w   $46(a0),d1
                move.w  d1,y_pos(a0)
                move.w  $44(a0),d0
                jmp     (SKTouchCull_TestAnchorAndDraw).l
; ---------------------------------------------------------------------------
Map_LRZOrbitingSpikeBall:
                include "src/objects/shared/zones/lrz/mappings/orbiting_spike_ball.s"
; End of function Obj_LRZOrbitingSpikeBallHorizontal
